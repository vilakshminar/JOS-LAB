
obj/net/testinput:     file format elf64-x86-64


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
  80003c:	e8 eb 09 00 00       	callq  800a2c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <announce>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


static void
announce(void)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 30          	sub    $0x30,%rsp
	// with ARP requests.  Ideally, we would use gratuitous ARP
	// for this, but QEMU's ARP implementation is dumb and only
	// listens for very specific ARP requests, such as requests
	// for the gateway IP.

	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80004c:	c6 45 e0 52          	movb   $0x52,-0x20(%rbp)
  800050:	c6 45 e1 54          	movb   $0x54,-0x1f(%rbp)
  800054:	c6 45 e2 00          	movb   $0x0,-0x1e(%rbp)
  800058:	c6 45 e3 12          	movb   $0x12,-0x1d(%rbp)
  80005c:	c6 45 e4 34          	movb   $0x34,-0x1c(%rbp)
  800060:	c6 45 e5 56          	movb   $0x56,-0x1b(%rbp)
	uint32_t myip = inet_addr(IP);
  800064:	48 bf 40 52 80 00 00 	movabs $0x805240,%rdi
  80006b:	00 00 00 
  80006e:	48 b8 9c 4d 80 00 00 	movabs $0x804d9c,%rax
  800075:	00 00 00 
  800078:	ff d0                	callq  *%rax
  80007a:	89 45 dc             	mov    %eax,-0x24(%rbp)
	uint32_t gwip = inet_addr(DEFAULT);
  80007d:	48 bf 4a 52 80 00 00 	movabs $0x80524a,%rdi
  800084:	00 00 00 
  800087:	48 b8 9c 4d 80 00 00 	movabs $0x804d9c,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	89 45 d8             	mov    %eax,-0x28(%rbp)
	int r;

	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800096:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80009d:	00 00 00 
  8000a0:	48 8b 00             	mov    (%rax),%rax
  8000a3:	ba 07 00 00 00       	mov    $0x7,%edx
  8000a8:	48 89 c6             	mov    %rax,%rsi
  8000ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8000b0:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
  8000bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c3:	79 30                	jns    8000f5 <announce+0xb1>
		panic("sys_page_map: %e", r);
  8000c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c8:	89 c1                	mov    %eax,%ecx
  8000ca:	48 ba 53 52 80 00 00 	movabs $0x805253,%rdx
  8000d1:	00 00 00 
  8000d4:	be 19 00 00 00       	mov    $0x19,%esi
  8000d9:	48 bf 64 52 80 00 00 	movabs $0x805264,%rdi
  8000e0:	00 00 00 
  8000e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e8:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  8000ef:	00 00 00 
  8000f2:	41 ff d0             	callq  *%r8

	struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
  8000f5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000fc:	00 00 00 
  8000ff:	48 8b 00             	mov    (%rax),%rax
  800102:	48 83 c0 04          	add    $0x4,%rax
  800106:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	pkt->jp_len = sizeof(*arp);
  80010a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800111:	00 00 00 
  800114:	48 8b 00             	mov    (%rax),%rax
  800117:	c7 00 2a 00 00 00    	movl   $0x2a,(%rax)

	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  80011d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800121:	ba 06 00 00 00       	mov    $0x6,%edx
  800126:	be ff 00 00 00       	mov    $0xff,%esi
  80012b:	48 89 c7             	mov    %rax,%rdi
  80012e:	48 b8 83 1b 80 00 00 	movabs $0x801b83,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  80013a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80013e:	48 8d 48 06          	lea    0x6(%rax),%rcx
  800142:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800146:	ba 06 00 00 00       	mov    $0x6,%edx
  80014b:	48 89 c6             	mov    %rax,%rsi
  80014e:	48 89 cf             	mov    %rcx,%rdi
  800151:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  800158:	00 00 00 
  80015b:	ff d0                	callq  *%rax
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  80015d:	bf 06 08 00 00       	mov    $0x806,%edi
  800162:	48 b8 a4 51 80 00 00 	movabs $0x8051a4,%rax
  800169:	00 00 00 
  80016c:	ff d0                	callq  *%rax
  80016e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800172:	66 89 42 0c          	mov    %ax,0xc(%rdx)
	arp->hwtype = htons(1); // Ethernet
  800176:	bf 01 00 00 00       	mov    $0x1,%edi
  80017b:	48 b8 a4 51 80 00 00 	movabs $0x8051a4,%rax
  800182:	00 00 00 
  800185:	ff d0                	callq  *%rax
  800187:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80018b:	66 89 42 0e          	mov    %ax,0xe(%rdx)
	arp->proto = htons(ETHTYPE_IP);
  80018f:	bf 00 08 00 00       	mov    $0x800,%edi
  800194:	48 b8 a4 51 80 00 00 	movabs $0x8051a4,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
  8001a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a4:	66 89 42 10          	mov    %ax,0x10(%rdx)
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001a8:	bf 04 06 00 00       	mov    $0x604,%edi
  8001ad:	48 b8 a4 51 80 00 00 	movabs $0x8051a4,%rax
  8001b4:	00 00 00 
  8001b7:	ff d0                	callq  *%rax
  8001b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001bd:	66 89 42 12          	mov    %ax,0x12(%rdx)
	arp->opcode = htons(ARP_REQUEST);
  8001c1:	bf 01 00 00 00       	mov    $0x1,%edi
  8001c6:	48 b8 a4 51 80 00 00 	movabs $0x8051a4,%rax
  8001cd:	00 00 00 
  8001d0:	ff d0                	callq  *%rax
  8001d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d6:	66 89 42 14          	mov    %ax,0x14(%rdx)
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001de:	48 8d 48 16          	lea    0x16(%rax),%rcx
  8001e2:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8001e6:	ba 06 00 00 00       	mov    $0x6,%edx
  8001eb:	48 89 c6             	mov    %rax,%rsi
  8001ee:	48 89 cf             	mov    %rcx,%rdi
  8001f1:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  8001f8:	00 00 00 
  8001fb:	ff d0                	callq  *%rax
	memcpy(arp->sipaddr.addrw, &myip, 4);
  8001fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800201:	48 8d 48 1c          	lea    0x1c(%rax),%rcx
  800205:	48 8d 45 dc          	lea    -0x24(%rbp),%rax
  800209:	ba 04 00 00 00       	mov    $0x4,%edx
  80020e:	48 89 c6             	mov    %rax,%rsi
  800211:	48 89 cf             	mov    %rcx,%rdi
  800214:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  800220:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800224:	48 83 c0 20          	add    $0x20,%rax
  800228:	ba 06 00 00 00       	mov    $0x6,%edx
  80022d:	be 00 00 00 00       	mov    $0x0,%esi
  800232:	48 89 c7             	mov    %rax,%rdi
  800235:	48 b8 83 1b 80 00 00 	movabs $0x801b83,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  800241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800245:	48 8d 48 26          	lea    0x26(%rax),%rcx
  800249:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80024d:	ba 04 00 00 00       	mov    $0x4,%edx
  800252:	48 89 c6             	mov    %rax,%rsi
  800255:	48 89 cf             	mov    %rcx,%rdi
  800258:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax

	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  800264:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80026b:	00 00 00 
  80026e:	48 8b 10             	mov    (%rax),%rdx
  800271:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  800278:	00 00 00 
  80027b:	8b 00                	mov    (%rax),%eax
  80027d:	b9 07 00 00 00       	mov    $0x7,%ecx
  800282:	be 0b 00 00 00       	mov    $0xb,%esi
  800287:	89 c7                	mov    %eax,%edi
  800289:	48 b8 e8 2c 80 00 00 	movabs $0x802ce8,%rax
  800290:	00 00 00 
  800293:	ff d0                	callq  *%rax
	sys_page_unmap(0, pkt);
  800295:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80029c:	00 00 00 
  80029f:	48 8b 00             	mov    (%rax),%rax
  8002a2:	48 89 c6             	mov    %rax,%rsi
  8002a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8002aa:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  8002b1:	00 00 00 
  8002b4:	ff d0                	callq  *%rax
}
  8002b6:	c9                   	leaveq 
  8002b7:	c3                   	retq   

00000000008002b8 <hexdump>:

static void
hexdump(const char *prefix, const void *data, int len)
{
  8002b8:	55                   	push   %rbp
  8002b9:	48 89 e5             	mov    %rsp,%rbp
  8002bc:	53                   	push   %rbx
  8002bd:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8002c4:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
  8002cb:	48 89 b5 70 ff ff ff 	mov    %rsi,-0x90(%rbp)
  8002d2:	89 95 6c ff ff ff    	mov    %edx,-0x94(%rbp)
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
  8002d8:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  8002dc:	48 83 c0 50          	add    $0x50,%rax
  8002e0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	char *out = NULL;
  8002e4:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8002eb:	00 
	for (i = 0; i < len; i++) {
  8002ec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8002f3:	e9 4f 01 00 00       	jmpq   800447 <hexdump+0x18f>
		if (i % 16 == 0)
  8002f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002fb:	83 e0 0f             	and    $0xf,%eax
  8002fe:	85 c0                	test   %eax,%eax
  800300:	75 53                	jne    800355 <hexdump+0x9d>
			out = buf + snprintf(buf, end - buf,
  800302:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800306:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  80030a:	48 89 d1             	mov    %rdx,%rcx
  80030d:	48 29 c1             	sub    %rax,%rcx
  800310:	48 89 c8             	mov    %rcx,%rax
  800313:	89 c6                	mov    %eax,%esi
  800315:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  800318:	48 8b 95 78 ff ff ff 	mov    -0x88(%rbp),%rdx
  80031f:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  800323:	41 89 c8             	mov    %ecx,%r8d
  800326:	48 89 d1             	mov    %rdx,%rcx
  800329:	48 ba 74 52 80 00 00 	movabs $0x805274,%rdx
  800330:	00 00 00 
  800333:	48 89 c7             	mov    %rax,%rdi
  800336:	b8 00 00 00 00       	mov    $0x0,%eax
  80033b:	49 b9 9e 17 80 00 00 	movabs $0x80179e,%r9
  800342:	00 00 00 
  800345:	41 ff d1             	callq  *%r9
  800348:	48 98                	cltq   
  80034a:	48 8d 55 80          	lea    -0x80(%rbp),%rdx
  80034e:	48 01 d0             	add    %rdx,%rax
  800351:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  800355:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800358:	48 98                	cltq   
  80035a:	48 03 85 70 ff ff ff 	add    -0x90(%rbp),%rax
  800361:	0f b6 00             	movzbl (%rax),%eax
  800364:	0f b6 d0             	movzbl %al,%edx
  800367:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80036b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80036f:	48 89 cb             	mov    %rcx,%rbx
  800372:	48 29 c3             	sub    %rax,%rbx
  800375:	48 89 d8             	mov    %rbx,%rax
  800378:	89 c6                	mov    %eax,%esi
  80037a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80037e:	89 d1                	mov    %edx,%ecx
  800380:	48 ba 7e 52 80 00 00 	movabs $0x80527e,%rdx
  800387:	00 00 00 
  80038a:	48 89 c7             	mov    %rax,%rdi
  80038d:	b8 00 00 00 00       	mov    $0x0,%eax
  800392:	49 b8 9e 17 80 00 00 	movabs $0x80179e,%r8
  800399:	00 00 00 
  80039c:	41 ff d0             	callq  *%r8
  80039f:	48 98                	cltq   
  8003a1:	48 01 45 e0          	add    %rax,-0x20(%rbp)
		if (i % 16 == 15 || i == len - 1)
  8003a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003a8:	89 c2                	mov    %eax,%edx
  8003aa:	c1 fa 1f             	sar    $0x1f,%edx
  8003ad:	c1 ea 1c             	shr    $0x1c,%edx
  8003b0:	01 d0                	add    %edx,%eax
  8003b2:	83 e0 0f             	and    $0xf,%eax
  8003b5:	29 d0                	sub    %edx,%eax
  8003b7:	83 f8 0f             	cmp    $0xf,%eax
  8003ba:	74 0e                	je     8003ca <hexdump+0x112>
  8003bc:	8b 85 6c ff ff ff    	mov    -0x94(%rbp),%eax
  8003c2:	83 e8 01             	sub    $0x1,%eax
  8003c5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8003c8:	75 33                	jne    8003fd <hexdump+0x145>
			cprintf("%.*s\n", out - buf, buf);
  8003ca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8003ce:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  8003d2:	48 89 d1             	mov    %rdx,%rcx
  8003d5:	48 29 c1             	sub    %rax,%rcx
  8003d8:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  8003dc:	48 89 c2             	mov    %rax,%rdx
  8003df:	48 89 ce             	mov    %rcx,%rsi
  8003e2:	48 bf 83 52 80 00 00 	movabs $0x805283,%rdi
  8003e9:	00 00 00 
  8003ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f1:	48 b9 2f 0d 80 00 00 	movabs $0x800d2f,%rcx
  8003f8:	00 00 00 
  8003fb:	ff d1                	callq  *%rcx
		if (i % 2 == 1)
  8003fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800400:	89 c2                	mov    %eax,%edx
  800402:	c1 fa 1f             	sar    $0x1f,%edx
  800405:	c1 ea 1f             	shr    $0x1f,%edx
  800408:	01 d0                	add    %edx,%eax
  80040a:	83 e0 01             	and    $0x1,%eax
  80040d:	29 d0                	sub    %edx,%eax
  80040f:	83 f8 01             	cmp    $0x1,%eax
  800412:	75 0c                	jne    800420 <hexdump+0x168>
			*(out++) = ' ';
  800414:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800418:	c6 00 20             	movb   $0x20,(%rax)
  80041b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
		if (i % 16 == 7)
  800420:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800423:	89 c2                	mov    %eax,%edx
  800425:	c1 fa 1f             	sar    $0x1f,%edx
  800428:	c1 ea 1c             	shr    $0x1c,%edx
  80042b:	01 d0                	add    %edx,%eax
  80042d:	83 e0 0f             	and    $0xf,%eax
  800430:	29 d0                	sub    %edx,%eax
  800432:	83 f8 07             	cmp    $0x7,%eax
  800435:	75 0c                	jne    800443 <hexdump+0x18b>
			*(out++) = ' ';
  800437:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80043b:	c6 00 20             	movb   $0x20,(%rax)
  80043e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  800443:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800447:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80044a:	3b 85 6c ff ff ff    	cmp    -0x94(%rbp),%eax
  800450:	0f 8c a2 fe ff ff    	jl     8002f8 <hexdump+0x40>
		if (i % 2 == 1)
			*(out++) = ' ';
		if (i % 16 == 7)
			*(out++) = ' ';
	}
}
  800456:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80045d:	5b                   	pop    %rbx
  80045e:	5d                   	pop    %rbp
  80045f:	c3                   	retq   

0000000000800460 <umain>:

void
umain(int argc, char **argv)
{
  800460:	55                   	push   %rbp
  800461:	48 89 e5             	mov    %rsp,%rbp
  800464:	48 83 ec 30          	sub    $0x30,%rsp
  800468:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80046b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	envid_t ns_envid = sys_getenvid();
  80046f:	48 b8 a8 21 80 00 00 	movabs $0x8021a8,%rax
  800476:	00 00 00 
  800479:	ff d0                	callq  *%rax
  80047b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	int i, r, first = 1;
  80047e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	binaryname = "testinput";
  800485:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80048c:	00 00 00 
  80048f:	48 ba 89 52 80 00 00 	movabs $0x805289,%rdx
  800496:	00 00 00 
  800499:	48 89 10             	mov    %rdx,(%rax)

	output_envid = fork();
  80049c:	48 b8 fb 28 80 00 00 	movabs $0x8028fb,%rax
  8004a3:	00 00 00 
  8004a6:	ff d0                	callq  *%rax
  8004a8:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  8004af:	00 00 00 
  8004b2:	89 02                	mov    %eax,(%rdx)
	if (output_envid < 0)
  8004b4:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8004bb:	00 00 00 
  8004be:	8b 00                	mov    (%rax),%eax
  8004c0:	85 c0                	test   %eax,%eax
  8004c2:	79 2a                	jns    8004ee <umain+0x8e>
		panic("error forking");
  8004c4:	48 ba 93 52 80 00 00 	movabs $0x805293,%rdx
  8004cb:	00 00 00 
  8004ce:	be 4d 00 00 00       	mov    $0x4d,%esi
  8004d3:	48 bf 64 52 80 00 00 	movabs $0x805264,%rdi
  8004da:	00 00 00 
  8004dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e2:	48 b9 f4 0a 80 00 00 	movabs $0x800af4,%rcx
  8004e9:	00 00 00 
  8004ec:	ff d1                	callq  *%rcx
	else if (output_envid == 0) {
  8004ee:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8004f5:	00 00 00 
  8004f8:	8b 00                	mov    (%rax),%eax
  8004fa:	85 c0                	test   %eax,%eax
  8004fc:	75 16                	jne    800514 <umain+0xb4>
		output(ns_envid);
  8004fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800501:	89 c7                	mov    %eax,%edi
  800503:	48 b8 44 09 80 00 00 	movabs $0x800944,%rax
  80050a:	00 00 00 
  80050d:	ff d0                	callq  *%rax
		return;
  80050f:	e9 fc 01 00 00       	jmpq   800710 <umain+0x2b0>
	}

	input_envid = fork();
  800514:	48 b8 fb 28 80 00 00 	movabs $0x8028fb,%rax
  80051b:	00 00 00 
  80051e:	ff d0                	callq  *%rax
  800520:	48 ba 08 80 80 00 00 	movabs $0x808008,%rdx
  800527:	00 00 00 
  80052a:	89 02                	mov    %eax,(%rdx)
	if (input_envid < 0)
  80052c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800533:	00 00 00 
  800536:	8b 00                	mov    (%rax),%eax
  800538:	85 c0                	test   %eax,%eax
  80053a:	79 2a                	jns    800566 <umain+0x106>
		panic("error forking");
  80053c:	48 ba 93 52 80 00 00 	movabs $0x805293,%rdx
  800543:	00 00 00 
  800546:	be 55 00 00 00       	mov    $0x55,%esi
  80054b:	48 bf 64 52 80 00 00 	movabs $0x805264,%rdi
  800552:	00 00 00 
  800555:	b8 00 00 00 00       	mov    $0x0,%eax
  80055a:	48 b9 f4 0a 80 00 00 	movabs $0x800af4,%rcx
  800561:	00 00 00 
  800564:	ff d1                	callq  *%rcx
	else if (input_envid == 0) {
  800566:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80056d:	00 00 00 
  800570:	8b 00                	mov    (%rax),%eax
  800572:	85 c0                	test   %eax,%eax
  800574:	75 17                	jne    80058d <umain+0x12d>
		input(ns_envid);
  800576:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800579:	89 c7                	mov    %eax,%edi
  80057b:	48 b8 34 08 80 00 00 	movabs $0x800834,%rax
  800582:	00 00 00 
  800585:	ff d0                	callq  *%rax
		return;
  800587:	90                   	nop
  800588:	e9 83 01 00 00       	jmpq   800710 <umain+0x2b0>
	}

	cprintf("Sending ARP announcement...\n");
  80058d:	48 bf a1 52 80 00 00 	movabs $0x8052a1,%rdi
  800594:	00 00 00 
  800597:	b8 00 00 00 00       	mov    $0x0,%eax
  80059c:	48 ba 2f 0d 80 00 00 	movabs $0x800d2f,%rdx
  8005a3:	00 00 00 
  8005a6:	ff d2                	callq  *%rdx
	announce();
  8005a8:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8005af:	00 00 00 
  8005b2:	ff d0                	callq  *%rax

	while (1) {
		envid_t whom;
		int perm;

		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  8005b4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8005bb:	00 00 00 
  8005be:	48 8b 08             	mov    (%rax),%rcx
  8005c1:	48 8d 55 ec          	lea    -0x14(%rbp),%rdx
  8005c5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8005c9:	48 89 ce             	mov    %rcx,%rsi
  8005cc:	48 89 c7             	mov    %rax,%rdi
  8005cf:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  8005d6:	00 00 00 
  8005d9:	ff d0                	callq  *%rax
  8005db:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (req < 0)
  8005de:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8005e2:	79 30                	jns    800614 <umain+0x1b4>
			panic("ipc_recv: %e", req);
  8005e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8005e7:	89 c1                	mov    %eax,%ecx
  8005e9:	48 ba be 52 80 00 00 	movabs $0x8052be,%rdx
  8005f0:	00 00 00 
  8005f3:	be 64 00 00 00       	mov    $0x64,%esi
  8005f8:	48 bf 64 52 80 00 00 	movabs $0x805264,%rdi
  8005ff:	00 00 00 
  800602:	b8 00 00 00 00       	mov    $0x0,%eax
  800607:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  80060e:	00 00 00 
  800611:	41 ff d0             	callq  *%r8
		if (whom != input_envid)
  800614:	8b 55 f0             	mov    -0x10(%rbp),%edx
  800617:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80061e:	00 00 00 
  800621:	8b 00                	mov    (%rax),%eax
  800623:	39 c2                	cmp    %eax,%edx
  800625:	74 30                	je     800657 <umain+0x1f7>
			panic("IPC from unexpected environment %08x", whom);
  800627:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80062a:	89 c1                	mov    %eax,%ecx
  80062c:	48 ba d0 52 80 00 00 	movabs $0x8052d0,%rdx
  800633:	00 00 00 
  800636:	be 66 00 00 00       	mov    $0x66,%esi
  80063b:	48 bf 64 52 80 00 00 	movabs $0x805264,%rdi
  800642:	00 00 00 
  800645:	b8 00 00 00 00       	mov    $0x0,%eax
  80064a:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  800651:	00 00 00 
  800654:	41 ff d0             	callq  *%r8
		if (req != NSREQ_INPUT)
  800657:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  80065b:	74 30                	je     80068d <umain+0x22d>
			panic("Unexpected IPC %d", req);
  80065d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800660:	89 c1                	mov    %eax,%ecx
  800662:	48 ba f5 52 80 00 00 	movabs $0x8052f5,%rdx
  800669:	00 00 00 
  80066c:	be 68 00 00 00       	mov    $0x68,%esi
  800671:	48 bf 64 52 80 00 00 	movabs $0x805264,%rdi
  800678:	00 00 00 
  80067b:	b8 00 00 00 00       	mov    $0x0,%eax
  800680:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  800687:	00 00 00 
  80068a:	41 ff d0             	callq  *%r8

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  80068d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800694:	00 00 00 
  800697:	48 8b 00             	mov    (%rax),%rax
  80069a:	8b 00                	mov    (%rax),%eax
  80069c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8006a3:	00 00 00 
  8006a6:	48 8b 12             	mov    (%rdx),%rdx
  8006a9:	48 8d 4a 04          	lea    0x4(%rdx),%rcx
  8006ad:	89 c2                	mov    %eax,%edx
  8006af:	48 89 ce             	mov    %rcx,%rsi
  8006b2:	48 bf 07 53 80 00 00 	movabs $0x805307,%rdi
  8006b9:	00 00 00 
  8006bc:	48 b8 b8 02 80 00 00 	movabs $0x8002b8,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
		cprintf("\n");
  8006c8:	48 bf 0f 53 80 00 00 	movabs $0x80530f,%rdi
  8006cf:	00 00 00 
  8006d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d7:	48 ba 2f 0d 80 00 00 	movabs $0x800d2f,%rdx
  8006de:	00 00 00 
  8006e1:	ff d2                	callq  *%rdx

		// Only indicate that we're waiting for packets once
		// we've received the ARP reply
		if (first)
  8006e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006e7:	74 1b                	je     800704 <umain+0x2a4>
			cprintf("Waiting for packets...\n");
  8006e9:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  8006f0:	00 00 00 
  8006f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f8:	48 ba 2f 0d 80 00 00 	movabs $0x800d2f,%rdx
  8006ff:	00 00 00 
  800702:	ff d2                	callq  *%rdx
		first = 0;
  800704:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
  80070b:	e9 a4 fe ff ff       	jmpq   8005b4 <umain+0x154>
}
  800710:	c9                   	leaveq 
  800711:	c3                   	retq   
	...

0000000000800714 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800714:	55                   	push   %rbp
  800715:	48 89 e5             	mov    %rsp,%rbp
  800718:	48 83 ec 20          	sub    $0x20,%rsp
  80071c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80071f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  800722:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  800729:	00 00 00 
  80072c:	ff d0                	callq  *%rax
  80072e:	03 45 e8             	add    -0x18(%rbp),%eax
  800731:	89 45 fc             	mov    %eax,-0x4(%rbp)

	binaryname = "ns_timer";
  800734:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80073b:	00 00 00 
  80073e:	48 ba 30 53 80 00 00 	movabs $0x805330,%rdx
  800745:	00 00 00 
  800748:	48 89 10             	mov    %rdx,(%rax)

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  80074b:	eb 0c                	jmp    800759 <timer+0x45>
			sys_yield();
  80074d:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  800754:	00 00 00 
  800757:	ff d0                	callq  *%rax
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  800759:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  800760:	00 00 00 
  800763:	ff d0                	callq  *%rax
  800765:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800768:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80076b:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80076e:	73 06                	jae    800776 <timer+0x62>
  800770:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800774:	79 d7                	jns    80074d <timer+0x39>
			sys_yield();
		}
		if (r < 0)
  800776:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80077a:	79 30                	jns    8007ac <timer+0x98>
			panic("sys_time_msec: %e", r);
  80077c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80077f:	89 c1                	mov    %eax,%ecx
  800781:	48 ba 39 53 80 00 00 	movabs $0x805339,%rdx
  800788:	00 00 00 
  80078b:	be 0f 00 00 00       	mov    $0xf,%esi
  800790:	48 bf 4b 53 80 00 00 	movabs $0x80534b,%rdi
  800797:	00 00 00 
  80079a:	b8 00 00 00 00       	mov    $0x0,%eax
  80079f:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  8007a6:	00 00 00 
  8007a9:	41 ff d0             	callq  *%r8

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8007ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8007af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b9:	be 0c 00 00 00       	mov    $0xc,%esi
  8007be:	89 c7                	mov    %eax,%edi
  8007c0:	48 b8 e8 2c 80 00 00 	movabs $0x802ce8,%rax
  8007c7:	00 00 00 
  8007ca:	ff d0                	callq  *%rax

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8007cc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8007d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d5:	be 00 00 00 00       	mov    $0x0,%esi
  8007da:	48 89 c7             	mov    %rax,%rdi
  8007dd:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  8007e4:	00 00 00 
  8007e7:	ff d0                	callq  *%rax
  8007e9:	89 45 f4             	mov    %eax,-0xc(%rbp)

			if (whom != ns_envid) {
  8007ec:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8007ef:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8007f2:	39 c2                	cmp    %eax,%edx
  8007f4:	74 22                	je     800818 <timer+0x104>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8007f6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8007f9:	89 c6                	mov    %eax,%esi
  8007fb:	48 bf 58 53 80 00 00 	movabs $0x805358,%rdi
  800802:	00 00 00 
  800805:	b8 00 00 00 00       	mov    $0x0,%eax
  80080a:	48 ba 2f 0d 80 00 00 	movabs $0x800d2f,%rdx
  800811:	00 00 00 
  800814:	ff d2                	callq  *%rdx
				continue;
			}

			stop = sys_time_msec() + to;
			break;
		}
  800816:	eb b4                	jmp    8007cc <timer+0xb8>
			if (whom != ns_envid) {
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  800818:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  80081f:	00 00 00 
  800822:	ff d0                	callq  *%rax
  800824:	03 45 f4             	add    -0xc(%rbp),%eax
  800827:	89 45 fc             	mov    %eax,-0x4(%rbp)
			break;
  80082a:	90                   	nop
		}
	}
  80082b:	90                   	nop
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  80082c:	e9 28 ff ff ff       	jmpq   800759 <timer+0x45>
  800831:	00 00                	add    %al,(%rax)
	...

0000000000800834 <input>:
extern union Nsipc nsipcbuf;


void
input(envid_t ns_envid)
{
  800834:	55                   	push   %rbp
  800835:	48 89 e5             	mov    %rsp,%rbp
  800838:	48 83 ec 40          	sub    $0x40,%rsp
  80083c:	89 7d cc             	mov    %edi,-0x34(%rbp)
	binaryname = "ns_input";
  80083f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800846:	00 00 00 
  800849:	48 ba 98 53 80 00 00 	movabs $0x805398,%rdx
  800850:	00 00 00 
  800853:	48 89 10             	mov    %rdx,(%rax)
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
	struct jif_pkt *packet;
	uintptr_t addr;
	size_t len;
	uint32_t reqType = NSREQ_INPUT;
  800856:	c7 45 fc 0a 00 00 00 	movl   $0xa,-0x4(%rbp)
	int r, recvBuffLen=0;
  80085d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	packet = (struct jif_pkt *)&(nsipcbuf);
  800864:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80086b:	00 00 00 
  80086e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//Allocate a page for receiving the packet data
        if ((r = sys_page_alloc(0,(void *)((uintptr_t)packet), PTE_P|PTE_U|PTE_W)) < 0)
  800872:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800876:	ba 07 00 00 00       	mov    $0x7,%edx
  80087b:	48 89 c6             	mov    %rax,%rsi
  80087e:	bf 00 00 00 00       	mov    $0x0,%edi
  800883:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  80088a:	00 00 00 
  80088d:	ff d0                	callq  *%rax
  80088f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800892:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800896:	79 30                	jns    8008c8 <input+0x94>
        	panic("panic in input environment:sys_page_alloc: %e\n", r);
  800898:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80089b:	89 c1                	mov    %eax,%ecx
  80089d:	48 ba a8 53 80 00 00 	movabs $0x8053a8,%rdx
  8008a4:	00 00 00 
  8008a7:	be 19 00 00 00       	mov    $0x19,%esi
  8008ac:	48 bf d7 53 80 00 00 	movabs $0x8053d7,%rdi
  8008b3:	00 00 00 
  8008b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bb:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  8008c2:	00 00 00 
  8008c5:	41 ff d0             	callq  *%r8
        while(1)
        {
		//Receive the packet from the device driver into the page allocated
		addr = (uintptr_t)packet + sizeof(packet->jp_len);
  8008c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008cc:	48 83 c0 04          	add    $0x4,%rax
  8008d0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		len = (size_t)(PGSIZE - sizeof(packet->jp_len));
  8008d4:	48 c7 45 d8 fc 0f 00 	movq   $0xffc,-0x28(%rbp)
  8008db:	00 
		while((recvBuffLen = sys_receive_packet((void *)addr,len)) < 0)
  8008dc:	eb 0c                	jmp    8008ea <input+0xb6>
                	sys_yield();
  8008de:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  8008e5:	00 00 00 
  8008e8:	ff d0                	callq  *%rax
        while(1)
        {
		//Receive the packet from the device driver into the page allocated
		addr = (uintptr_t)packet + sizeof(packet->jp_len);
		len = (size_t)(PGSIZE - sizeof(packet->jp_len));
		while((recvBuffLen = sys_receive_packet((void *)addr,len)) < 0)
  8008ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008ee:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8008f2:	48 89 d6             	mov    %rdx,%rsi
  8008f5:	48 89 c7             	mov    %rax,%rdi
  8008f8:	48 b8 19 25 80 00 00 	movabs $0x802519,%rax
  8008ff:	00 00 00 
  800902:	ff d0                	callq  *%rax
  800904:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800907:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80090b:	78 d1                	js     8008de <input+0xaa>
                	sys_yield();
                packet->jp_len = recvBuffLen;
  80090d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800911:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800914:	89 10                	mov    %edx,(%rax)
		//Send the NSREQ_INPUT IPC message to ns with packet in page
                ipc_send(ns_envid, reqType, packet, PTE_P|PTE_U);
  800916:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80091a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80091d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800920:	b9 05 00 00 00       	mov    $0x5,%ecx
  800925:	89 c7                	mov    %eax,%edi
  800927:	48 b8 e8 2c 80 00 00 	movabs $0x802ce8,%rax
  80092e:	00 00 00 
  800931:	ff d0                	callq  *%rax
                sys_yield();
  800933:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  80093a:	00 00 00 
  80093d:	ff d0                	callq  *%rax
        }
  80093f:	eb 87                	jmp    8008c8 <input+0x94>
  800941:	00 00                	add    %al,(%rax)
	...

0000000000800944 <output>:
#include "ns.h"
extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  800944:	55                   	push   %rbp
  800945:	48 89 e5             	mov    %rsp,%rbp
  800948:	48 83 ec 20          	sub    $0x20,%rsp
  80094c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	binaryname = "ns_output";
  80094f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800956:	00 00 00 
  800959:	48 ba e8 53 80 00 00 	movabs $0x8053e8,%rdx
  800960:	00 00 00 
  800963:	48 89 10             	mov    %rdx,(%rax)
	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
	while(1)
	{
		perm = 0;
  800966:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
		//Read a packet from ns
		reqType = ipc_recv(&envid_sender, &nsipcbuf, &perm);
  80096d:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
  800971:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  800975:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  80097c:	00 00 00 
  80097f:	48 89 c7             	mov    %rax,%rdi
  800982:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  800989:	00 00 00 
  80098c:	ff d0                	callq  *%rax
  80098e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		//Check if ipc_recv has received correctly
		if(!(perm & PTE_P))
  800991:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800994:	83 e0 01             	and    $0x1,%eax
  800997:	85 c0                	test   %eax,%eax
  800999:	75 22                	jne    8009bd <output+0x79>
		{
			cprintf("Invalid request from network server[%08x]:no page",envid_sender);
  80099b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80099e:	89 c6                	mov    %eax,%esi
  8009a0:	48 bf f8 53 80 00 00 	movabs $0x8053f8,%rdi
  8009a7:	00 00 00 
  8009aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8009af:	48 ba 2f 0d 80 00 00 	movabs $0x800d2f,%rdx
  8009b6:	00 00 00 
  8009b9:	ff d2                	callq  *%rdx
			continue; 
  8009bb:	eb 67                	jmp    800a24 <output+0xe0>
		}
		if(reqType != NSREQ_OUTPUT)
  8009bd:	83 7d fc 0b          	cmpl   $0xb,-0x4(%rbp)
  8009c1:	74 30                	je     8009f3 <output+0xaf>
		{
			cprintf("Invalid request from network server[%08x]:not a NSREQ_OUTPUT message",envid_sender);
  8009c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8009c6:	89 c6                	mov    %eax,%esi
  8009c8:	48 bf 30 54 80 00 00 	movabs $0x805430,%rdi
  8009cf:	00 00 00 
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d7:	48 ba 2f 0d 80 00 00 	movabs $0x800d2f,%rdx
  8009de:	00 00 00 
  8009e1:	ff d2                	callq  *%rdx
			continue;
  8009e3:	eb 3f                	jmp    800a24 <output+0xe0>
		}
		//Send packet to device driver.If packet send fails, give up CPU
		while(sys_send_packet(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len) < 0)
			sys_yield();
  8009e5:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  8009ec:	00 00 00 
  8009ef:	ff d0                	callq  *%rax
  8009f1:	eb 01                	jmp    8009f4 <output+0xb0>
		{
			cprintf("Invalid request from network server[%08x]:not a NSREQ_OUTPUT message",envid_sender);
			continue;
		}
		//Send packet to device driver.If packet send fails, give up CPU
		while(sys_send_packet(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len) < 0)
  8009f3:	90                   	nop
  8009f4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8009fb:	00 00 00 
  8009fe:	8b 00                	mov    (%rax),%eax
  800a00:	48 98                	cltq   
  800a02:	48 89 c6             	mov    %rax,%rsi
  800a05:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  800a0c:	00 00 00 
  800a0f:	48 b8 cf 24 80 00 00 	movabs $0x8024cf,%rax
  800a16:	00 00 00 
  800a19:	ff d0                	callq  *%rax
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	78 c6                	js     8009e5 <output+0xa1>
			sys_yield();
	}
  800a1f:	e9 42 ff ff ff       	jmpq   800966 <output+0x22>
  800a24:	e9 3d ff ff ff       	jmpq   800966 <output+0x22>
  800a29:	00 00                	add    %al,(%rax)
	...

0000000000800a2c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a2c:	55                   	push   %rbp
  800a2d:	48 89 e5             	mov    %rsp,%rbp
  800a30:	48 83 ec 10          	sub    $0x10,%rsp
  800a34:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a37:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800a3b:	48 b8 70 80 80 00 00 	movabs $0x808070,%rax
  800a42:	00 00 00 
  800a45:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800a4c:	48 b8 a8 21 80 00 00 	movabs $0x8021a8,%rax
  800a53:	00 00 00 
  800a56:	ff d0                	callq  *%rax
  800a58:	48 98                	cltq   
  800a5a:	48 89 c2             	mov    %rax,%rdx
  800a5d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800a63:	48 89 d0             	mov    %rdx,%rax
  800a66:	48 c1 e0 03          	shl    $0x3,%rax
  800a6a:	48 01 d0             	add    %rdx,%rax
  800a6d:	48 c1 e0 05          	shl    $0x5,%rax
  800a71:	48 89 c2             	mov    %rax,%rdx
  800a74:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800a7b:	00 00 00 
  800a7e:	48 01 c2             	add    %rax,%rdx
  800a81:	48 b8 70 80 80 00 00 	movabs $0x808070,%rax
  800a88:	00 00 00 
  800a8b:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a92:	7e 14                	jle    800aa8 <libmain+0x7c>
		binaryname = argv[0];
  800a94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a98:	48 8b 10             	mov    (%rax),%rdx
  800a9b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800aa2:	00 00 00 
  800aa5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800aa8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800aaf:	48 89 d6             	mov    %rdx,%rsi
  800ab2:	89 c7                	mov    %eax,%edi
  800ab4:	48 b8 60 04 80 00 00 	movabs $0x800460,%rax
  800abb:	00 00 00 
  800abe:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800ac0:	48 b8 d0 0a 80 00 00 	movabs $0x800ad0,%rax
  800ac7:	00 00 00 
  800aca:	ff d0                	callq  *%rax
}
  800acc:	c9                   	leaveq 
  800acd:	c3                   	retq   
	...

0000000000800ad0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800ad0:	55                   	push   %rbp
  800ad1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800ad4:	48 b8 71 31 80 00 00 	movabs $0x803171,%rax
  800adb:	00 00 00 
  800ade:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800ae0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae5:	48 b8 64 21 80 00 00 	movabs $0x802164,%rax
  800aec:	00 00 00 
  800aef:	ff d0                	callq  *%rax
}
  800af1:	5d                   	pop    %rbp
  800af2:	c3                   	retq   
	...

0000000000800af4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800af4:	55                   	push   %rbp
  800af5:	48 89 e5             	mov    %rsp,%rbp
  800af8:	53                   	push   %rbx
  800af9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800b00:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800b07:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800b0d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800b14:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800b1b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800b22:	84 c0                	test   %al,%al
  800b24:	74 23                	je     800b49 <_panic+0x55>
  800b26:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800b2d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800b31:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800b35:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800b39:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800b3d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800b41:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800b45:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800b49:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b50:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800b57:	00 00 00 
  800b5a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800b61:	00 00 00 
  800b64:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b68:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800b6f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800b76:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800b7d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800b84:	00 00 00 
  800b87:	48 8b 18             	mov    (%rax),%rbx
  800b8a:	48 b8 a8 21 80 00 00 	movabs $0x8021a8,%rax
  800b91:	00 00 00 
  800b94:	ff d0                	callq  *%rax
  800b96:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800b9c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ba3:	41 89 c8             	mov    %ecx,%r8d
  800ba6:	48 89 d1             	mov    %rdx,%rcx
  800ba9:	48 89 da             	mov    %rbx,%rdx
  800bac:	89 c6                	mov    %eax,%esi
  800bae:	48 bf 80 54 80 00 00 	movabs $0x805480,%rdi
  800bb5:	00 00 00 
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbd:	49 b9 2f 0d 80 00 00 	movabs $0x800d2f,%r9
  800bc4:	00 00 00 
  800bc7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800bca:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800bd1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bd8:	48 89 d6             	mov    %rdx,%rsi
  800bdb:	48 89 c7             	mov    %rax,%rdi
  800bde:	48 b8 83 0c 80 00 00 	movabs $0x800c83,%rax
  800be5:	00 00 00 
  800be8:	ff d0                	callq  *%rax
	cprintf("\n");
  800bea:	48 bf a3 54 80 00 00 	movabs $0x8054a3,%rdi
  800bf1:	00 00 00 
  800bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf9:	48 ba 2f 0d 80 00 00 	movabs $0x800d2f,%rdx
  800c00:	00 00 00 
  800c03:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c05:	cc                   	int3   
  800c06:	eb fd                	jmp    800c05 <_panic+0x111>

0000000000800c08 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800c08:	55                   	push   %rbp
  800c09:	48 89 e5             	mov    %rsp,%rbp
  800c0c:	48 83 ec 10          	sub    $0x10,%rsp
  800c10:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800c17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c1b:	8b 00                	mov    (%rax),%eax
  800c1d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c20:	89 d6                	mov    %edx,%esi
  800c22:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800c26:	48 63 d0             	movslq %eax,%rdx
  800c29:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800c2e:	8d 50 01             	lea    0x1(%rax),%edx
  800c31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c35:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800c37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c3b:	8b 00                	mov    (%rax),%eax
  800c3d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c42:	75 2c                	jne    800c70 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800c44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c48:	8b 00                	mov    (%rax),%eax
  800c4a:	48 98                	cltq   
  800c4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c50:	48 83 c2 08          	add    $0x8,%rdx
  800c54:	48 89 c6             	mov    %rax,%rsi
  800c57:	48 89 d7             	mov    %rdx,%rdi
  800c5a:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  800c61:	00 00 00 
  800c64:	ff d0                	callq  *%rax
		b->idx = 0;
  800c66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800c70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c74:	8b 40 04             	mov    0x4(%rax),%eax
  800c77:	8d 50 01             	lea    0x1(%rax),%edx
  800c7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c7e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800c81:	c9                   	leaveq 
  800c82:	c3                   	retq   

0000000000800c83 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800c83:	55                   	push   %rbp
  800c84:	48 89 e5             	mov    %rsp,%rbp
  800c87:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800c8e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800c95:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800c9c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800ca3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800caa:	48 8b 0a             	mov    (%rdx),%rcx
  800cad:	48 89 08             	mov    %rcx,(%rax)
  800cb0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cb4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cb8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cbc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800cc0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800cc7:	00 00 00 
	b.cnt = 0;
  800cca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800cd1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800cd4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800cdb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800ce2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800ce9:	48 89 c6             	mov    %rax,%rsi
  800cec:	48 bf 08 0c 80 00 00 	movabs $0x800c08,%rdi
  800cf3:	00 00 00 
  800cf6:	48 b8 e0 10 80 00 00 	movabs $0x8010e0,%rax
  800cfd:	00 00 00 
  800d00:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800d02:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800d08:	48 98                	cltq   
  800d0a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800d11:	48 83 c2 08          	add    $0x8,%rdx
  800d15:	48 89 c6             	mov    %rax,%rsi
  800d18:	48 89 d7             	mov    %rdx,%rdi
  800d1b:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  800d22:	00 00 00 
  800d25:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800d27:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800d2d:	c9                   	leaveq 
  800d2e:	c3                   	retq   

0000000000800d2f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800d2f:	55                   	push   %rbp
  800d30:	48 89 e5             	mov    %rsp,%rbp
  800d33:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800d3a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800d41:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800d48:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d4f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d56:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d5d:	84 c0                	test   %al,%al
  800d5f:	74 20                	je     800d81 <cprintf+0x52>
  800d61:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d65:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d69:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d6d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d71:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d75:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d79:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d7d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d81:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800d88:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800d8f:	00 00 00 
  800d92:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d99:	00 00 00 
  800d9c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800da0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800da7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dae:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800db5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800dbc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dc3:	48 8b 0a             	mov    (%rdx),%rcx
  800dc6:	48 89 08             	mov    %rcx,(%rax)
  800dc9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dcd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dd1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dd5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800dd9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800de0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800de7:	48 89 d6             	mov    %rdx,%rsi
  800dea:	48 89 c7             	mov    %rax,%rdi
  800ded:	48 b8 83 0c 80 00 00 	movabs $0x800c83,%rax
  800df4:	00 00 00 
  800df7:	ff d0                	callq  *%rax
  800df9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800dff:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e05:	c9                   	leaveq 
  800e06:	c3                   	retq   
	...

0000000000800e08 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e08:	55                   	push   %rbp
  800e09:	48 89 e5             	mov    %rsp,%rbp
  800e0c:	48 83 ec 30          	sub    $0x30,%rsp
  800e10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800e14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800e18:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e1c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800e1f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800e23:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e27:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800e2a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800e2e:	77 52                	ja     800e82 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e30:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800e33:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800e37:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800e3a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800e3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e42:	ba 00 00 00 00       	mov    $0x0,%edx
  800e47:	48 f7 75 d0          	divq   -0x30(%rbp)
  800e4b:	48 89 c2             	mov    %rax,%rdx
  800e4e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e51:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e54:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800e58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e5c:	41 89 f9             	mov    %edi,%r9d
  800e5f:	48 89 c7             	mov    %rax,%rdi
  800e62:	48 b8 08 0e 80 00 00 	movabs $0x800e08,%rax
  800e69:	00 00 00 
  800e6c:	ff d0                	callq  *%rax
  800e6e:	eb 1c                	jmp    800e8c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e74:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e77:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800e7b:	48 89 d6             	mov    %rdx,%rsi
  800e7e:	89 c7                	mov    %eax,%edi
  800e80:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e82:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800e86:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800e8a:	7f e4                	jg     800e70 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e8c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e93:	ba 00 00 00 00       	mov    $0x0,%edx
  800e98:	48 f7 f1             	div    %rcx
  800e9b:	48 89 d0             	mov    %rdx,%rax
  800e9e:	48 ba 88 56 80 00 00 	movabs $0x805688,%rdx
  800ea5:	00 00 00 
  800ea8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800eac:	0f be c0             	movsbl %al,%eax
  800eaf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800eb3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800eb7:	48 89 d6             	mov    %rdx,%rsi
  800eba:	89 c7                	mov    %eax,%edi
  800ebc:	ff d1                	callq  *%rcx
}
  800ebe:	c9                   	leaveq 
  800ebf:	c3                   	retq   

0000000000800ec0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ec0:	55                   	push   %rbp
  800ec1:	48 89 e5             	mov    %rsp,%rbp
  800ec4:	48 83 ec 20          	sub    $0x20,%rsp
  800ec8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ecc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800ecf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ed3:	7e 52                	jle    800f27 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800ed5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed9:	8b 00                	mov    (%rax),%eax
  800edb:	83 f8 30             	cmp    $0x30,%eax
  800ede:	73 24                	jae    800f04 <getuint+0x44>
  800ee0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ee8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eec:	8b 00                	mov    (%rax),%eax
  800eee:	89 c0                	mov    %eax,%eax
  800ef0:	48 01 d0             	add    %rdx,%rax
  800ef3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ef7:	8b 12                	mov    (%rdx),%edx
  800ef9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800efc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f00:	89 0a                	mov    %ecx,(%rdx)
  800f02:	eb 17                	jmp    800f1b <getuint+0x5b>
  800f04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f08:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f0c:	48 89 d0             	mov    %rdx,%rax
  800f0f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f13:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f17:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f1b:	48 8b 00             	mov    (%rax),%rax
  800f1e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f22:	e9 a3 00 00 00       	jmpq   800fca <getuint+0x10a>
	else if (lflag)
  800f27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f2b:	74 4f                	je     800f7c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800f2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f31:	8b 00                	mov    (%rax),%eax
  800f33:	83 f8 30             	cmp    $0x30,%eax
  800f36:	73 24                	jae    800f5c <getuint+0x9c>
  800f38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f44:	8b 00                	mov    (%rax),%eax
  800f46:	89 c0                	mov    %eax,%eax
  800f48:	48 01 d0             	add    %rdx,%rax
  800f4b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f4f:	8b 12                	mov    (%rdx),%edx
  800f51:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f58:	89 0a                	mov    %ecx,(%rdx)
  800f5a:	eb 17                	jmp    800f73 <getuint+0xb3>
  800f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f60:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f64:	48 89 d0             	mov    %rdx,%rax
  800f67:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f6f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f73:	48 8b 00             	mov    (%rax),%rax
  800f76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f7a:	eb 4e                	jmp    800fca <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f80:	8b 00                	mov    (%rax),%eax
  800f82:	83 f8 30             	cmp    $0x30,%eax
  800f85:	73 24                	jae    800fab <getuint+0xeb>
  800f87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f93:	8b 00                	mov    (%rax),%eax
  800f95:	89 c0                	mov    %eax,%eax
  800f97:	48 01 d0             	add    %rdx,%rax
  800f9a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f9e:	8b 12                	mov    (%rdx),%edx
  800fa0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800fa3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fa7:	89 0a                	mov    %ecx,(%rdx)
  800fa9:	eb 17                	jmp    800fc2 <getuint+0x102>
  800fab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800faf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800fb3:	48 89 d0             	mov    %rdx,%rax
  800fb6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800fba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fbe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fc2:	8b 00                	mov    (%rax),%eax
  800fc4:	89 c0                	mov    %eax,%eax
  800fc6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800fca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fce:	c9                   	leaveq 
  800fcf:	c3                   	retq   

0000000000800fd0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800fd0:	55                   	push   %rbp
  800fd1:	48 89 e5             	mov    %rsp,%rbp
  800fd4:	48 83 ec 20          	sub    $0x20,%rsp
  800fd8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fdc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800fdf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800fe3:	7e 52                	jle    801037 <getint+0x67>
		x=va_arg(*ap, long long);
  800fe5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe9:	8b 00                	mov    (%rax),%eax
  800feb:	83 f8 30             	cmp    $0x30,%eax
  800fee:	73 24                	jae    801014 <getint+0x44>
  800ff0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ff8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ffc:	8b 00                	mov    (%rax),%eax
  800ffe:	89 c0                	mov    %eax,%eax
  801000:	48 01 d0             	add    %rdx,%rax
  801003:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801007:	8b 12                	mov    (%rdx),%edx
  801009:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80100c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801010:	89 0a                	mov    %ecx,(%rdx)
  801012:	eb 17                	jmp    80102b <getint+0x5b>
  801014:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801018:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80101c:	48 89 d0             	mov    %rdx,%rax
  80101f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801023:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801027:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80102b:	48 8b 00             	mov    (%rax),%rax
  80102e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801032:	e9 a3 00 00 00       	jmpq   8010da <getint+0x10a>
	else if (lflag)
  801037:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80103b:	74 4f                	je     80108c <getint+0xbc>
		x=va_arg(*ap, long);
  80103d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801041:	8b 00                	mov    (%rax),%eax
  801043:	83 f8 30             	cmp    $0x30,%eax
  801046:	73 24                	jae    80106c <getint+0x9c>
  801048:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801050:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801054:	8b 00                	mov    (%rax),%eax
  801056:	89 c0                	mov    %eax,%eax
  801058:	48 01 d0             	add    %rdx,%rax
  80105b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80105f:	8b 12                	mov    (%rdx),%edx
  801061:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801064:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801068:	89 0a                	mov    %ecx,(%rdx)
  80106a:	eb 17                	jmp    801083 <getint+0xb3>
  80106c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801070:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801074:	48 89 d0             	mov    %rdx,%rax
  801077:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80107b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80107f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801083:	48 8b 00             	mov    (%rax),%rax
  801086:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80108a:	eb 4e                	jmp    8010da <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80108c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801090:	8b 00                	mov    (%rax),%eax
  801092:	83 f8 30             	cmp    $0x30,%eax
  801095:	73 24                	jae    8010bb <getint+0xeb>
  801097:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80109f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a3:	8b 00                	mov    (%rax),%eax
  8010a5:	89 c0                	mov    %eax,%eax
  8010a7:	48 01 d0             	add    %rdx,%rax
  8010aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010ae:	8b 12                	mov    (%rdx),%edx
  8010b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010b7:	89 0a                	mov    %ecx,(%rdx)
  8010b9:	eb 17                	jmp    8010d2 <getint+0x102>
  8010bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010c3:	48 89 d0             	mov    %rdx,%rax
  8010c6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010ce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010d2:	8b 00                	mov    (%rax),%eax
  8010d4:	48 98                	cltq   
  8010d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8010da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010de:	c9                   	leaveq 
  8010df:	c3                   	retq   

00000000008010e0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010e0:	55                   	push   %rbp
  8010e1:	48 89 e5             	mov    %rsp,%rbp
  8010e4:	41 54                	push   %r12
  8010e6:	53                   	push   %rbx
  8010e7:	48 83 ec 60          	sub    $0x60,%rsp
  8010eb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8010ef:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8010f3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8010f7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8010fb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010ff:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801103:	48 8b 0a             	mov    (%rdx),%rcx
  801106:	48 89 08             	mov    %rcx,(%rax)
  801109:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80110d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801111:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801115:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801119:	eb 17                	jmp    801132 <vprintfmt+0x52>
			if (ch == '\0')
  80111b:	85 db                	test   %ebx,%ebx
  80111d:	0f 84 d7 04 00 00    	je     8015fa <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  801123:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801127:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80112b:	48 89 c6             	mov    %rax,%rsi
  80112e:	89 df                	mov    %ebx,%edi
  801130:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801132:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801136:	0f b6 00             	movzbl (%rax),%eax
  801139:	0f b6 d8             	movzbl %al,%ebx
  80113c:	83 fb 25             	cmp    $0x25,%ebx
  80113f:	0f 95 c0             	setne  %al
  801142:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  801147:	84 c0                	test   %al,%al
  801149:	75 d0                	jne    80111b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80114b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80114f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801156:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80115d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801164:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80116b:	eb 04                	jmp    801171 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80116d:	90                   	nop
  80116e:	eb 01                	jmp    801171 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  801170:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801171:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801175:	0f b6 00             	movzbl (%rax),%eax
  801178:	0f b6 d8             	movzbl %al,%ebx
  80117b:	89 d8                	mov    %ebx,%eax
  80117d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  801182:	83 e8 23             	sub    $0x23,%eax
  801185:	83 f8 55             	cmp    $0x55,%eax
  801188:	0f 87 38 04 00 00    	ja     8015c6 <vprintfmt+0x4e6>
  80118e:	89 c0                	mov    %eax,%eax
  801190:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801197:	00 
  801198:	48 b8 b0 56 80 00 00 	movabs $0x8056b0,%rax
  80119f:	00 00 00 
  8011a2:	48 01 d0             	add    %rdx,%rax
  8011a5:	48 8b 00             	mov    (%rax),%rax
  8011a8:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8011aa:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8011ae:	eb c1                	jmp    801171 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011b0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8011b4:	eb bb                	jmp    801171 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011b6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8011bd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8011c0:	89 d0                	mov    %edx,%eax
  8011c2:	c1 e0 02             	shl    $0x2,%eax
  8011c5:	01 d0                	add    %edx,%eax
  8011c7:	01 c0                	add    %eax,%eax
  8011c9:	01 d8                	add    %ebx,%eax
  8011cb:	83 e8 30             	sub    $0x30,%eax
  8011ce:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8011d1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011d5:	0f b6 00             	movzbl (%rax),%eax
  8011d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011db:	83 fb 2f             	cmp    $0x2f,%ebx
  8011de:	7e 63                	jle    801243 <vprintfmt+0x163>
  8011e0:	83 fb 39             	cmp    $0x39,%ebx
  8011e3:	7f 5e                	jg     801243 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011e5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011ea:	eb d1                	jmp    8011bd <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8011ec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011ef:	83 f8 30             	cmp    $0x30,%eax
  8011f2:	73 17                	jae    80120b <vprintfmt+0x12b>
  8011f4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011fb:	89 c0                	mov    %eax,%eax
  8011fd:	48 01 d0             	add    %rdx,%rax
  801200:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801203:	83 c2 08             	add    $0x8,%edx
  801206:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801209:	eb 0f                	jmp    80121a <vprintfmt+0x13a>
  80120b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80120f:	48 89 d0             	mov    %rdx,%rax
  801212:	48 83 c2 08          	add    $0x8,%rdx
  801216:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80121a:	8b 00                	mov    (%rax),%eax
  80121c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80121f:	eb 23                	jmp    801244 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  801221:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801225:	0f 89 42 ff ff ff    	jns    80116d <vprintfmt+0x8d>
				width = 0;
  80122b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801232:	e9 36 ff ff ff       	jmpq   80116d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  801237:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80123e:	e9 2e ff ff ff       	jmpq   801171 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801243:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801244:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801248:	0f 89 22 ff ff ff    	jns    801170 <vprintfmt+0x90>
				width = precision, precision = -1;
  80124e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801251:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801254:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80125b:	e9 10 ff ff ff       	jmpq   801170 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801260:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801264:	e9 08 ff ff ff       	jmpq   801171 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801269:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80126c:	83 f8 30             	cmp    $0x30,%eax
  80126f:	73 17                	jae    801288 <vprintfmt+0x1a8>
  801271:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801275:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801278:	89 c0                	mov    %eax,%eax
  80127a:	48 01 d0             	add    %rdx,%rax
  80127d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801280:	83 c2 08             	add    $0x8,%edx
  801283:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801286:	eb 0f                	jmp    801297 <vprintfmt+0x1b7>
  801288:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80128c:	48 89 d0             	mov    %rdx,%rax
  80128f:	48 83 c2 08          	add    $0x8,%rdx
  801293:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801297:	8b 00                	mov    (%rax),%eax
  801299:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80129d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8012a1:	48 89 d6             	mov    %rdx,%rsi
  8012a4:	89 c7                	mov    %eax,%edi
  8012a6:	ff d1                	callq  *%rcx
			break;
  8012a8:	e9 47 03 00 00       	jmpq   8015f4 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8012ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012b0:	83 f8 30             	cmp    $0x30,%eax
  8012b3:	73 17                	jae    8012cc <vprintfmt+0x1ec>
  8012b5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8012b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012bc:	89 c0                	mov    %eax,%eax
  8012be:	48 01 d0             	add    %rdx,%rax
  8012c1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012c4:	83 c2 08             	add    $0x8,%edx
  8012c7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012ca:	eb 0f                	jmp    8012db <vprintfmt+0x1fb>
  8012cc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012d0:	48 89 d0             	mov    %rdx,%rax
  8012d3:	48 83 c2 08          	add    $0x8,%rdx
  8012d7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012db:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8012dd:	85 db                	test   %ebx,%ebx
  8012df:	79 02                	jns    8012e3 <vprintfmt+0x203>
				err = -err;
  8012e1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012e3:	83 fb 10             	cmp    $0x10,%ebx
  8012e6:	7f 16                	jg     8012fe <vprintfmt+0x21e>
  8012e8:	48 b8 00 56 80 00 00 	movabs $0x805600,%rax
  8012ef:	00 00 00 
  8012f2:	48 63 d3             	movslq %ebx,%rdx
  8012f5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8012f9:	4d 85 e4             	test   %r12,%r12
  8012fc:	75 2e                	jne    80132c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  8012fe:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801302:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801306:	89 d9                	mov    %ebx,%ecx
  801308:	48 ba 99 56 80 00 00 	movabs $0x805699,%rdx
  80130f:	00 00 00 
  801312:	48 89 c7             	mov    %rax,%rdi
  801315:	b8 00 00 00 00       	mov    $0x0,%eax
  80131a:	49 b8 04 16 80 00 00 	movabs $0x801604,%r8
  801321:	00 00 00 
  801324:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801327:	e9 c8 02 00 00       	jmpq   8015f4 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80132c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801330:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801334:	4c 89 e1             	mov    %r12,%rcx
  801337:	48 ba a2 56 80 00 00 	movabs $0x8056a2,%rdx
  80133e:	00 00 00 
  801341:	48 89 c7             	mov    %rax,%rdi
  801344:	b8 00 00 00 00       	mov    $0x0,%eax
  801349:	49 b8 04 16 80 00 00 	movabs $0x801604,%r8
  801350:	00 00 00 
  801353:	41 ff d0             	callq  *%r8
			break;
  801356:	e9 99 02 00 00       	jmpq   8015f4 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80135b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80135e:	83 f8 30             	cmp    $0x30,%eax
  801361:	73 17                	jae    80137a <vprintfmt+0x29a>
  801363:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801367:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80136a:	89 c0                	mov    %eax,%eax
  80136c:	48 01 d0             	add    %rdx,%rax
  80136f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801372:	83 c2 08             	add    $0x8,%edx
  801375:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801378:	eb 0f                	jmp    801389 <vprintfmt+0x2a9>
  80137a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80137e:	48 89 d0             	mov    %rdx,%rax
  801381:	48 83 c2 08          	add    $0x8,%rdx
  801385:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801389:	4c 8b 20             	mov    (%rax),%r12
  80138c:	4d 85 e4             	test   %r12,%r12
  80138f:	75 0a                	jne    80139b <vprintfmt+0x2bb>
				p = "(null)";
  801391:	49 bc a5 56 80 00 00 	movabs $0x8056a5,%r12
  801398:	00 00 00 
			if (width > 0 && padc != '-')
  80139b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80139f:	7e 7a                	jle    80141b <vprintfmt+0x33b>
  8013a1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8013a5:	74 74                	je     80141b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013a7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8013aa:	48 98                	cltq   
  8013ac:	48 89 c6             	mov    %rax,%rsi
  8013af:	4c 89 e7             	mov    %r12,%rdi
  8013b2:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  8013b9:	00 00 00 
  8013bc:	ff d0                	callq  *%rax
  8013be:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8013c1:	eb 17                	jmp    8013da <vprintfmt+0x2fa>
					putch(padc, putdat);
  8013c3:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  8013c7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013cb:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8013cf:	48 89 d6             	mov    %rdx,%rsi
  8013d2:	89 c7                	mov    %eax,%edi
  8013d4:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013d6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8013da:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013de:	7f e3                	jg     8013c3 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013e0:	eb 39                	jmp    80141b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  8013e2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8013e6:	74 1e                	je     801406 <vprintfmt+0x326>
  8013e8:	83 fb 1f             	cmp    $0x1f,%ebx
  8013eb:	7e 05                	jle    8013f2 <vprintfmt+0x312>
  8013ed:	83 fb 7e             	cmp    $0x7e,%ebx
  8013f0:	7e 14                	jle    801406 <vprintfmt+0x326>
					putch('?', putdat);
  8013f2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8013f6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8013fa:	48 89 c6             	mov    %rax,%rsi
  8013fd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801402:	ff d2                	callq  *%rdx
  801404:	eb 0f                	jmp    801415 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  801406:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80140a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80140e:	48 89 c6             	mov    %rax,%rsi
  801411:	89 df                	mov    %ebx,%edi
  801413:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801415:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801419:	eb 01                	jmp    80141c <vprintfmt+0x33c>
  80141b:	90                   	nop
  80141c:	41 0f b6 04 24       	movzbl (%r12),%eax
  801421:	0f be d8             	movsbl %al,%ebx
  801424:	85 db                	test   %ebx,%ebx
  801426:	0f 95 c0             	setne  %al
  801429:	49 83 c4 01          	add    $0x1,%r12
  80142d:	84 c0                	test   %al,%al
  80142f:	74 28                	je     801459 <vprintfmt+0x379>
  801431:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801435:	78 ab                	js     8013e2 <vprintfmt+0x302>
  801437:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80143b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80143f:	79 a1                	jns    8013e2 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801441:	eb 16                	jmp    801459 <vprintfmt+0x379>
				putch(' ', putdat);
  801443:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801447:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80144b:	48 89 c6             	mov    %rax,%rsi
  80144e:	bf 20 00 00 00       	mov    $0x20,%edi
  801453:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801455:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801459:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80145d:	7f e4                	jg     801443 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  80145f:	e9 90 01 00 00       	jmpq   8015f4 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801464:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801468:	be 03 00 00 00       	mov    $0x3,%esi
  80146d:	48 89 c7             	mov    %rax,%rdi
  801470:	48 b8 d0 0f 80 00 00 	movabs $0x800fd0,%rax
  801477:	00 00 00 
  80147a:	ff d0                	callq  *%rax
  80147c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801484:	48 85 c0             	test   %rax,%rax
  801487:	79 1d                	jns    8014a6 <vprintfmt+0x3c6>
				putch('-', putdat);
  801489:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80148d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801491:	48 89 c6             	mov    %rax,%rsi
  801494:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801499:	ff d2                	callq  *%rdx
				num = -(long long) num;
  80149b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149f:	48 f7 d8             	neg    %rax
  8014a2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8014a6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8014ad:	e9 d5 00 00 00       	jmpq   801587 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8014b2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014b6:	be 03 00 00 00       	mov    $0x3,%esi
  8014bb:	48 89 c7             	mov    %rax,%rdi
  8014be:	48 b8 c0 0e 80 00 00 	movabs $0x800ec0,%rax
  8014c5:	00 00 00 
  8014c8:	ff d0                	callq  *%rax
  8014ca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8014ce:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8014d5:	e9 ad 00 00 00       	jmpq   801587 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  8014da:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014de:	be 03 00 00 00       	mov    $0x3,%esi
  8014e3:	48 89 c7             	mov    %rax,%rdi
  8014e6:	48 b8 c0 0e 80 00 00 	movabs $0x800ec0,%rax
  8014ed:	00 00 00 
  8014f0:	ff d0                	callq  *%rax
  8014f2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  8014f6:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8014fd:	e9 85 00 00 00       	jmpq   801587 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  801502:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801506:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80150a:	48 89 c6             	mov    %rax,%rsi
  80150d:	bf 30 00 00 00       	mov    $0x30,%edi
  801512:	ff d2                	callq  *%rdx
			putch('x', putdat);
  801514:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801518:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80151c:	48 89 c6             	mov    %rax,%rsi
  80151f:	bf 78 00 00 00       	mov    $0x78,%edi
  801524:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801526:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801529:	83 f8 30             	cmp    $0x30,%eax
  80152c:	73 17                	jae    801545 <vprintfmt+0x465>
  80152e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801532:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801535:	89 c0                	mov    %eax,%eax
  801537:	48 01 d0             	add    %rdx,%rax
  80153a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80153d:	83 c2 08             	add    $0x8,%edx
  801540:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801543:	eb 0f                	jmp    801554 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  801545:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801549:	48 89 d0             	mov    %rdx,%rax
  80154c:	48 83 c2 08          	add    $0x8,%rdx
  801550:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801554:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801557:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80155b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801562:	eb 23                	jmp    801587 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801564:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801568:	be 03 00 00 00       	mov    $0x3,%esi
  80156d:	48 89 c7             	mov    %rax,%rdi
  801570:	48 b8 c0 0e 80 00 00 	movabs $0x800ec0,%rax
  801577:	00 00 00 
  80157a:	ff d0                	callq  *%rax
  80157c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801580:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801587:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80158c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80158f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801592:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801596:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80159a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80159e:	45 89 c1             	mov    %r8d,%r9d
  8015a1:	41 89 f8             	mov    %edi,%r8d
  8015a4:	48 89 c7             	mov    %rax,%rdi
  8015a7:	48 b8 08 0e 80 00 00 	movabs $0x800e08,%rax
  8015ae:	00 00 00 
  8015b1:	ff d0                	callq  *%rax
			break;
  8015b3:	eb 3f                	jmp    8015f4 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8015b5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8015b9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8015bd:	48 89 c6             	mov    %rax,%rsi
  8015c0:	89 df                	mov    %ebx,%edi
  8015c2:	ff d2                	callq  *%rdx
			break;
  8015c4:	eb 2e                	jmp    8015f4 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8015c6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8015ca:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8015ce:	48 89 c6             	mov    %rax,%rsi
  8015d1:	bf 25 00 00 00       	mov    $0x25,%edi
  8015d6:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8015d8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015dd:	eb 05                	jmp    8015e4 <vprintfmt+0x504>
  8015df:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015e4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8015e8:	48 83 e8 01          	sub    $0x1,%rax
  8015ec:	0f b6 00             	movzbl (%rax),%eax
  8015ef:	3c 25                	cmp    $0x25,%al
  8015f1:	75 ec                	jne    8015df <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  8015f3:	90                   	nop
		}
	}
  8015f4:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8015f5:	e9 38 fb ff ff       	jmpq   801132 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  8015fa:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  8015fb:	48 83 c4 60          	add    $0x60,%rsp
  8015ff:	5b                   	pop    %rbx
  801600:	41 5c                	pop    %r12
  801602:	5d                   	pop    %rbp
  801603:	c3                   	retq   

0000000000801604 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801604:	55                   	push   %rbp
  801605:	48 89 e5             	mov    %rsp,%rbp
  801608:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80160f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801616:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80161d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801624:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80162b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801632:	84 c0                	test   %al,%al
  801634:	74 20                	je     801656 <printfmt+0x52>
  801636:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80163a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80163e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801642:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801646:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80164a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80164e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801652:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801656:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80165d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801664:	00 00 00 
  801667:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80166e:	00 00 00 
  801671:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801675:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80167c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801683:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80168a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801691:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801698:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80169f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8016a6:	48 89 c7             	mov    %rax,%rdi
  8016a9:	48 b8 e0 10 80 00 00 	movabs $0x8010e0,%rax
  8016b0:	00 00 00 
  8016b3:	ff d0                	callq  *%rax
	va_end(ap);
}
  8016b5:	c9                   	leaveq 
  8016b6:	c3                   	retq   

00000000008016b7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8016b7:	55                   	push   %rbp
  8016b8:	48 89 e5             	mov    %rsp,%rbp
  8016bb:	48 83 ec 10          	sub    $0x10,%rsp
  8016bf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8016c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8016c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ca:	8b 40 10             	mov    0x10(%rax),%eax
  8016cd:	8d 50 01             	lea    0x1(%rax),%edx
  8016d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8016d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016db:	48 8b 10             	mov    (%rax),%rdx
  8016de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8016e6:	48 39 c2             	cmp    %rax,%rdx
  8016e9:	73 17                	jae    801702 <sprintputch+0x4b>
		*b->buf++ = ch;
  8016eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ef:	48 8b 00             	mov    (%rax),%rax
  8016f2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8016f5:	88 10                	mov    %dl,(%rax)
  8016f7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ff:	48 89 10             	mov    %rdx,(%rax)
}
  801702:	c9                   	leaveq 
  801703:	c3                   	retq   

0000000000801704 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801704:	55                   	push   %rbp
  801705:	48 89 e5             	mov    %rsp,%rbp
  801708:	48 83 ec 50          	sub    $0x50,%rsp
  80170c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801710:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801713:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801717:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80171b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80171f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801723:	48 8b 0a             	mov    (%rdx),%rcx
  801726:	48 89 08             	mov    %rcx,(%rax)
  801729:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80172d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801731:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801735:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801739:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80173d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801741:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801744:	48 98                	cltq   
  801746:	48 83 e8 01          	sub    $0x1,%rax
  80174a:	48 03 45 c8          	add    -0x38(%rbp),%rax
  80174e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801752:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801759:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80175e:	74 06                	je     801766 <vsnprintf+0x62>
  801760:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801764:	7f 07                	jg     80176d <vsnprintf+0x69>
		return -E_INVAL;
  801766:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80176b:	eb 2f                	jmp    80179c <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80176d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801771:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801775:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801779:	48 89 c6             	mov    %rax,%rsi
  80177c:	48 bf b7 16 80 00 00 	movabs $0x8016b7,%rdi
  801783:	00 00 00 
  801786:	48 b8 e0 10 80 00 00 	movabs $0x8010e0,%rax
  80178d:	00 00 00 
  801790:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801792:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801796:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801799:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80179c:	c9                   	leaveq 
  80179d:	c3                   	retq   

000000000080179e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80179e:	55                   	push   %rbp
  80179f:	48 89 e5             	mov    %rsp,%rbp
  8017a2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8017a9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8017b0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8017b6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8017bd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8017c4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8017cb:	84 c0                	test   %al,%al
  8017cd:	74 20                	je     8017ef <snprintf+0x51>
  8017cf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8017d3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8017d7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8017db:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8017df:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8017e3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8017e7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8017eb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8017ef:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8017f6:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8017fd:	00 00 00 
  801800:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801807:	00 00 00 
  80180a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80180e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801815:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80181c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801823:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80182a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801831:	48 8b 0a             	mov    (%rdx),%rcx
  801834:	48 89 08             	mov    %rcx,(%rax)
  801837:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80183b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80183f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801843:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801847:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80184e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801855:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80185b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801862:	48 89 c7             	mov    %rax,%rdi
  801865:	48 b8 04 17 80 00 00 	movabs $0x801704,%rax
  80186c:	00 00 00 
  80186f:	ff d0                	callq  *%rax
  801871:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801877:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80187d:	c9                   	leaveq 
  80187e:	c3                   	retq   
	...

0000000000801880 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801880:	55                   	push   %rbp
  801881:	48 89 e5             	mov    %rsp,%rbp
  801884:	48 83 ec 18          	sub    $0x18,%rsp
  801888:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80188c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801893:	eb 09                	jmp    80189e <strlen+0x1e>
		n++;
  801895:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801899:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80189e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018a2:	0f b6 00             	movzbl (%rax),%eax
  8018a5:	84 c0                	test   %al,%al
  8018a7:	75 ec                	jne    801895 <strlen+0x15>
		n++;
	return n;
  8018a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018ac:	c9                   	leaveq 
  8018ad:	c3                   	retq   

00000000008018ae <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8018ae:	55                   	push   %rbp
  8018af:	48 89 e5             	mov    %rsp,%rbp
  8018b2:	48 83 ec 20          	sub    $0x20,%rsp
  8018b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018c5:	eb 0e                	jmp    8018d5 <strnlen+0x27>
		n++;
  8018c7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018cb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018d0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8018d5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8018da:	74 0b                	je     8018e7 <strnlen+0x39>
  8018dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e0:	0f b6 00             	movzbl (%rax),%eax
  8018e3:	84 c0                	test   %al,%al
  8018e5:	75 e0                	jne    8018c7 <strnlen+0x19>
		n++;
	return n;
  8018e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018ea:	c9                   	leaveq 
  8018eb:	c3                   	retq   

00000000008018ec <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018ec:	55                   	push   %rbp
  8018ed:	48 89 e5             	mov    %rsp,%rbp
  8018f0:	48 83 ec 20          	sub    $0x20,%rsp
  8018f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8018fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801900:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801904:	90                   	nop
  801905:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801909:	0f b6 10             	movzbl (%rax),%edx
  80190c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801910:	88 10                	mov    %dl,(%rax)
  801912:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801916:	0f b6 00             	movzbl (%rax),%eax
  801919:	84 c0                	test   %al,%al
  80191b:	0f 95 c0             	setne  %al
  80191e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801923:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801928:	84 c0                	test   %al,%al
  80192a:	75 d9                	jne    801905 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80192c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801930:	c9                   	leaveq 
  801931:	c3                   	retq   

0000000000801932 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801932:	55                   	push   %rbp
  801933:	48 89 e5             	mov    %rsp,%rbp
  801936:	48 83 ec 20          	sub    $0x20,%rsp
  80193a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80193e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801946:	48 89 c7             	mov    %rax,%rdi
  801949:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  801950:	00 00 00 
  801953:	ff d0                	callq  *%rax
  801955:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801958:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80195b:	48 98                	cltq   
  80195d:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801961:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801965:	48 89 d6             	mov    %rdx,%rsi
  801968:	48 89 c7             	mov    %rax,%rdi
  80196b:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  801972:	00 00 00 
  801975:	ff d0                	callq  *%rax
	return dst;
  801977:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80197b:	c9                   	leaveq 
  80197c:	c3                   	retq   

000000000080197d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80197d:	55                   	push   %rbp
  80197e:	48 89 e5             	mov    %rsp,%rbp
  801981:	48 83 ec 28          	sub    $0x28,%rsp
  801985:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801989:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80198d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801991:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801995:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801999:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8019a0:	00 
  8019a1:	eb 27                	jmp    8019ca <strncpy+0x4d>
		*dst++ = *src;
  8019a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019a7:	0f b6 10             	movzbl (%rax),%edx
  8019aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ae:	88 10                	mov    %dl,(%rax)
  8019b0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8019b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019b9:	0f b6 00             	movzbl (%rax),%eax
  8019bc:	84 c0                	test   %al,%al
  8019be:	74 05                	je     8019c5 <strncpy+0x48>
			src++;
  8019c0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ce:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8019d2:	72 cf                	jb     8019a3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8019d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019d8:	c9                   	leaveq 
  8019d9:	c3                   	retq   

00000000008019da <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019da:	55                   	push   %rbp
  8019db:	48 89 e5             	mov    %rsp,%rbp
  8019de:	48 83 ec 28          	sub    $0x28,%rsp
  8019e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8019ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8019f6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8019fb:	74 37                	je     801a34 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8019fd:	eb 17                	jmp    801a16 <strlcpy+0x3c>
			*dst++ = *src++;
  8019ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a03:	0f b6 10             	movzbl (%rax),%edx
  801a06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a0a:	88 10                	mov    %dl,(%rax)
  801a0c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801a11:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a16:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a1b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a20:	74 0b                	je     801a2d <strlcpy+0x53>
  801a22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a26:	0f b6 00             	movzbl (%rax),%eax
  801a29:	84 c0                	test   %al,%al
  801a2b:	75 d2                	jne    8019ff <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801a2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a31:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801a34:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a3c:	48 89 d1             	mov    %rdx,%rcx
  801a3f:	48 29 c1             	sub    %rax,%rcx
  801a42:	48 89 c8             	mov    %rcx,%rax
}
  801a45:	c9                   	leaveq 
  801a46:	c3                   	retq   

0000000000801a47 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a47:	55                   	push   %rbp
  801a48:	48 89 e5             	mov    %rsp,%rbp
  801a4b:	48 83 ec 10          	sub    $0x10,%rsp
  801a4f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a53:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801a57:	eb 0a                	jmp    801a63 <strcmp+0x1c>
		p++, q++;
  801a59:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a5e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a67:	0f b6 00             	movzbl (%rax),%eax
  801a6a:	84 c0                	test   %al,%al
  801a6c:	74 12                	je     801a80 <strcmp+0x39>
  801a6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a72:	0f b6 10             	movzbl (%rax),%edx
  801a75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a79:	0f b6 00             	movzbl (%rax),%eax
  801a7c:	38 c2                	cmp    %al,%dl
  801a7e:	74 d9                	je     801a59 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a84:	0f b6 00             	movzbl (%rax),%eax
  801a87:	0f b6 d0             	movzbl %al,%edx
  801a8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a8e:	0f b6 00             	movzbl (%rax),%eax
  801a91:	0f b6 c0             	movzbl %al,%eax
  801a94:	89 d1                	mov    %edx,%ecx
  801a96:	29 c1                	sub    %eax,%ecx
  801a98:	89 c8                	mov    %ecx,%eax
}
  801a9a:	c9                   	leaveq 
  801a9b:	c3                   	retq   

0000000000801a9c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a9c:	55                   	push   %rbp
  801a9d:	48 89 e5             	mov    %rsp,%rbp
  801aa0:	48 83 ec 18          	sub    $0x18,%rsp
  801aa4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aa8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aac:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801ab0:	eb 0f                	jmp    801ac1 <strncmp+0x25>
		n--, p++, q++;
  801ab2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801ab7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801abc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801ac1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ac6:	74 1d                	je     801ae5 <strncmp+0x49>
  801ac8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801acc:	0f b6 00             	movzbl (%rax),%eax
  801acf:	84 c0                	test   %al,%al
  801ad1:	74 12                	je     801ae5 <strncmp+0x49>
  801ad3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad7:	0f b6 10             	movzbl (%rax),%edx
  801ada:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ade:	0f b6 00             	movzbl (%rax),%eax
  801ae1:	38 c2                	cmp    %al,%dl
  801ae3:	74 cd                	je     801ab2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801ae5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801aea:	75 07                	jne    801af3 <strncmp+0x57>
		return 0;
  801aec:	b8 00 00 00 00       	mov    $0x0,%eax
  801af1:	eb 1a                	jmp    801b0d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801af3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af7:	0f b6 00             	movzbl (%rax),%eax
  801afa:	0f b6 d0             	movzbl %al,%edx
  801afd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b01:	0f b6 00             	movzbl (%rax),%eax
  801b04:	0f b6 c0             	movzbl %al,%eax
  801b07:	89 d1                	mov    %edx,%ecx
  801b09:	29 c1                	sub    %eax,%ecx
  801b0b:	89 c8                	mov    %ecx,%eax
}
  801b0d:	c9                   	leaveq 
  801b0e:	c3                   	retq   

0000000000801b0f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801b0f:	55                   	push   %rbp
  801b10:	48 89 e5             	mov    %rsp,%rbp
  801b13:	48 83 ec 10          	sub    $0x10,%rsp
  801b17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b1b:	89 f0                	mov    %esi,%eax
  801b1d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b20:	eb 17                	jmp    801b39 <strchr+0x2a>
		if (*s == c)
  801b22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b26:	0f b6 00             	movzbl (%rax),%eax
  801b29:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b2c:	75 06                	jne    801b34 <strchr+0x25>
			return (char *) s;
  801b2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b32:	eb 15                	jmp    801b49 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b34:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b3d:	0f b6 00             	movzbl (%rax),%eax
  801b40:	84 c0                	test   %al,%al
  801b42:	75 de                	jne    801b22 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801b44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b49:	c9                   	leaveq 
  801b4a:	c3                   	retq   

0000000000801b4b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b4b:	55                   	push   %rbp
  801b4c:	48 89 e5             	mov    %rsp,%rbp
  801b4f:	48 83 ec 10          	sub    $0x10,%rsp
  801b53:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b57:	89 f0                	mov    %esi,%eax
  801b59:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b5c:	eb 11                	jmp    801b6f <strfind+0x24>
		if (*s == c)
  801b5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b62:	0f b6 00             	movzbl (%rax),%eax
  801b65:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b68:	74 12                	je     801b7c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b6a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b73:	0f b6 00             	movzbl (%rax),%eax
  801b76:	84 c0                	test   %al,%al
  801b78:	75 e4                	jne    801b5e <strfind+0x13>
  801b7a:	eb 01                	jmp    801b7d <strfind+0x32>
		if (*s == c)
			break;
  801b7c:	90                   	nop
	return (char *) s;
  801b7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b81:	c9                   	leaveq 
  801b82:	c3                   	retq   

0000000000801b83 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b83:	55                   	push   %rbp
  801b84:	48 89 e5             	mov    %rsp,%rbp
  801b87:	48 83 ec 18          	sub    $0x18,%rsp
  801b8b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b8f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801b92:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801b96:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b9b:	75 06                	jne    801ba3 <memset+0x20>
		return v;
  801b9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ba1:	eb 69                	jmp    801c0c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801ba3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ba7:	83 e0 03             	and    $0x3,%eax
  801baa:	48 85 c0             	test   %rax,%rax
  801bad:	75 48                	jne    801bf7 <memset+0x74>
  801baf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bb3:	83 e0 03             	and    $0x3,%eax
  801bb6:	48 85 c0             	test   %rax,%rax
  801bb9:	75 3c                	jne    801bf7 <memset+0x74>
		c &= 0xFF;
  801bbb:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801bc2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bc5:	89 c2                	mov    %eax,%edx
  801bc7:	c1 e2 18             	shl    $0x18,%edx
  801bca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bcd:	c1 e0 10             	shl    $0x10,%eax
  801bd0:	09 c2                	or     %eax,%edx
  801bd2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bd5:	c1 e0 08             	shl    $0x8,%eax
  801bd8:	09 d0                	or     %edx,%eax
  801bda:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801bdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be1:	48 89 c1             	mov    %rax,%rcx
  801be4:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801be8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bef:	48 89 d7             	mov    %rdx,%rdi
  801bf2:	fc                   	cld    
  801bf3:	f3 ab                	rep stos %eax,%es:(%rdi)
  801bf5:	eb 11                	jmp    801c08 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801bf7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bfb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bfe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c02:	48 89 d7             	mov    %rdx,%rdi
  801c05:	fc                   	cld    
  801c06:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801c08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801c0c:	c9                   	leaveq 
  801c0d:	c3                   	retq   

0000000000801c0e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801c0e:	55                   	push   %rbp
  801c0f:	48 89 e5             	mov    %rsp,%rbp
  801c12:	48 83 ec 28          	sub    $0x28,%rsp
  801c16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c1e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801c22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801c2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c2e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801c32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c36:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c3a:	0f 83 88 00 00 00    	jae    801cc8 <memmove+0xba>
  801c40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c44:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c48:	48 01 d0             	add    %rdx,%rax
  801c4b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c4f:	76 77                	jbe    801cc8 <memmove+0xba>
		s += n;
  801c51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c55:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801c59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c5d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801c61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c65:	83 e0 03             	and    $0x3,%eax
  801c68:	48 85 c0             	test   %rax,%rax
  801c6b:	75 3b                	jne    801ca8 <memmove+0x9a>
  801c6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c71:	83 e0 03             	and    $0x3,%eax
  801c74:	48 85 c0             	test   %rax,%rax
  801c77:	75 2f                	jne    801ca8 <memmove+0x9a>
  801c79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c7d:	83 e0 03             	and    $0x3,%eax
  801c80:	48 85 c0             	test   %rax,%rax
  801c83:	75 23                	jne    801ca8 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801c85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c89:	48 83 e8 04          	sub    $0x4,%rax
  801c8d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c91:	48 83 ea 04          	sub    $0x4,%rdx
  801c95:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801c99:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801c9d:	48 89 c7             	mov    %rax,%rdi
  801ca0:	48 89 d6             	mov    %rdx,%rsi
  801ca3:	fd                   	std    
  801ca4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ca6:	eb 1d                	jmp    801cc5 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801ca8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cac:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801cb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb4:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801cb8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cbc:	48 89 d7             	mov    %rdx,%rdi
  801cbf:	48 89 c1             	mov    %rax,%rcx
  801cc2:	fd                   	std    
  801cc3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801cc5:	fc                   	cld    
  801cc6:	eb 57                	jmp    801d1f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801cc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ccc:	83 e0 03             	and    $0x3,%eax
  801ccf:	48 85 c0             	test   %rax,%rax
  801cd2:	75 36                	jne    801d0a <memmove+0xfc>
  801cd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cd8:	83 e0 03             	and    $0x3,%eax
  801cdb:	48 85 c0             	test   %rax,%rax
  801cde:	75 2a                	jne    801d0a <memmove+0xfc>
  801ce0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ce4:	83 e0 03             	and    $0x3,%eax
  801ce7:	48 85 c0             	test   %rax,%rax
  801cea:	75 1e                	jne    801d0a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801cec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf0:	48 89 c1             	mov    %rax,%rcx
  801cf3:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801cf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cfb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cff:	48 89 c7             	mov    %rax,%rdi
  801d02:	48 89 d6             	mov    %rdx,%rsi
  801d05:	fc                   	cld    
  801d06:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801d08:	eb 15                	jmp    801d1f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d0e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d12:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801d16:	48 89 c7             	mov    %rax,%rdi
  801d19:	48 89 d6             	mov    %rdx,%rsi
  801d1c:	fc                   	cld    
  801d1d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801d1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d23:	c9                   	leaveq 
  801d24:	c3                   	retq   

0000000000801d25 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d25:	55                   	push   %rbp
  801d26:	48 89 e5             	mov    %rsp,%rbp
  801d29:	48 83 ec 18          	sub    $0x18,%rsp
  801d2d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d35:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801d39:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d3d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d45:	48 89 ce             	mov    %rcx,%rsi
  801d48:	48 89 c7             	mov    %rax,%rdi
  801d4b:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  801d52:	00 00 00 
  801d55:	ff d0                	callq  *%rax
}
  801d57:	c9                   	leaveq 
  801d58:	c3                   	retq   

0000000000801d59 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d59:	55                   	push   %rbp
  801d5a:	48 89 e5             	mov    %rsp,%rbp
  801d5d:	48 83 ec 28          	sub    $0x28,%rsp
  801d61:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d65:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d69:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801d6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d71:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801d75:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801d7d:	eb 38                	jmp    801db7 <memcmp+0x5e>
		if (*s1 != *s2)
  801d7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d83:	0f b6 10             	movzbl (%rax),%edx
  801d86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d8a:	0f b6 00             	movzbl (%rax),%eax
  801d8d:	38 c2                	cmp    %al,%dl
  801d8f:	74 1c                	je     801dad <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801d91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d95:	0f b6 00             	movzbl (%rax),%eax
  801d98:	0f b6 d0             	movzbl %al,%edx
  801d9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d9f:	0f b6 00             	movzbl (%rax),%eax
  801da2:	0f b6 c0             	movzbl %al,%eax
  801da5:	89 d1                	mov    %edx,%ecx
  801da7:	29 c1                	sub    %eax,%ecx
  801da9:	89 c8                	mov    %ecx,%eax
  801dab:	eb 20                	jmp    801dcd <memcmp+0x74>
		s1++, s2++;
  801dad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801db2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801db7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801dbc:	0f 95 c0             	setne  %al
  801dbf:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801dc4:	84 c0                	test   %al,%al
  801dc6:	75 b7                	jne    801d7f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcd:	c9                   	leaveq 
  801dce:	c3                   	retq   

0000000000801dcf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dcf:	55                   	push   %rbp
  801dd0:	48 89 e5             	mov    %rsp,%rbp
  801dd3:	48 83 ec 28          	sub    $0x28,%rsp
  801dd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ddb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801dde:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801de2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801de6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801dea:	48 01 d0             	add    %rdx,%rax
  801ded:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801df1:	eb 13                	jmp    801e06 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801df3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df7:	0f b6 10             	movzbl (%rax),%edx
  801dfa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dfd:	38 c2                	cmp    %al,%dl
  801dff:	74 11                	je     801e12 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801e01:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801e06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e0a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801e0e:	72 e3                	jb     801df3 <memfind+0x24>
  801e10:	eb 01                	jmp    801e13 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801e12:	90                   	nop
	return (void *) s;
  801e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801e17:	c9                   	leaveq 
  801e18:	c3                   	retq   

0000000000801e19 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e19:	55                   	push   %rbp
  801e1a:	48 89 e5             	mov    %rsp,%rbp
  801e1d:	48 83 ec 38          	sub    $0x38,%rsp
  801e21:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e25:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801e29:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801e2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801e33:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801e3a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e3b:	eb 05                	jmp    801e42 <strtol+0x29>
		s++;
  801e3d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e46:	0f b6 00             	movzbl (%rax),%eax
  801e49:	3c 20                	cmp    $0x20,%al
  801e4b:	74 f0                	je     801e3d <strtol+0x24>
  801e4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e51:	0f b6 00             	movzbl (%rax),%eax
  801e54:	3c 09                	cmp    $0x9,%al
  801e56:	74 e5                	je     801e3d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5c:	0f b6 00             	movzbl (%rax),%eax
  801e5f:	3c 2b                	cmp    $0x2b,%al
  801e61:	75 07                	jne    801e6a <strtol+0x51>
		s++;
  801e63:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e68:	eb 17                	jmp    801e81 <strtol+0x68>
	else if (*s == '-')
  801e6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e6e:	0f b6 00             	movzbl (%rax),%eax
  801e71:	3c 2d                	cmp    $0x2d,%al
  801e73:	75 0c                	jne    801e81 <strtol+0x68>
		s++, neg = 1;
  801e75:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e7a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e81:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e85:	74 06                	je     801e8d <strtol+0x74>
  801e87:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801e8b:	75 28                	jne    801eb5 <strtol+0x9c>
  801e8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e91:	0f b6 00             	movzbl (%rax),%eax
  801e94:	3c 30                	cmp    $0x30,%al
  801e96:	75 1d                	jne    801eb5 <strtol+0x9c>
  801e98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e9c:	48 83 c0 01          	add    $0x1,%rax
  801ea0:	0f b6 00             	movzbl (%rax),%eax
  801ea3:	3c 78                	cmp    $0x78,%al
  801ea5:	75 0e                	jne    801eb5 <strtol+0x9c>
		s += 2, base = 16;
  801ea7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801eac:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801eb3:	eb 2c                	jmp    801ee1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801eb5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801eb9:	75 19                	jne    801ed4 <strtol+0xbb>
  801ebb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ebf:	0f b6 00             	movzbl (%rax),%eax
  801ec2:	3c 30                	cmp    $0x30,%al
  801ec4:	75 0e                	jne    801ed4 <strtol+0xbb>
		s++, base = 8;
  801ec6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ecb:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801ed2:	eb 0d                	jmp    801ee1 <strtol+0xc8>
	else if (base == 0)
  801ed4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ed8:	75 07                	jne    801ee1 <strtol+0xc8>
		base = 10;
  801eda:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ee1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee5:	0f b6 00             	movzbl (%rax),%eax
  801ee8:	3c 2f                	cmp    $0x2f,%al
  801eea:	7e 1d                	jle    801f09 <strtol+0xf0>
  801eec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef0:	0f b6 00             	movzbl (%rax),%eax
  801ef3:	3c 39                	cmp    $0x39,%al
  801ef5:	7f 12                	jg     801f09 <strtol+0xf0>
			dig = *s - '0';
  801ef7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801efb:	0f b6 00             	movzbl (%rax),%eax
  801efe:	0f be c0             	movsbl %al,%eax
  801f01:	83 e8 30             	sub    $0x30,%eax
  801f04:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f07:	eb 4e                	jmp    801f57 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801f09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f0d:	0f b6 00             	movzbl (%rax),%eax
  801f10:	3c 60                	cmp    $0x60,%al
  801f12:	7e 1d                	jle    801f31 <strtol+0x118>
  801f14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f18:	0f b6 00             	movzbl (%rax),%eax
  801f1b:	3c 7a                	cmp    $0x7a,%al
  801f1d:	7f 12                	jg     801f31 <strtol+0x118>
			dig = *s - 'a' + 10;
  801f1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f23:	0f b6 00             	movzbl (%rax),%eax
  801f26:	0f be c0             	movsbl %al,%eax
  801f29:	83 e8 57             	sub    $0x57,%eax
  801f2c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f2f:	eb 26                	jmp    801f57 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801f31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f35:	0f b6 00             	movzbl (%rax),%eax
  801f38:	3c 40                	cmp    $0x40,%al
  801f3a:	7e 47                	jle    801f83 <strtol+0x16a>
  801f3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f40:	0f b6 00             	movzbl (%rax),%eax
  801f43:	3c 5a                	cmp    $0x5a,%al
  801f45:	7f 3c                	jg     801f83 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801f47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f4b:	0f b6 00             	movzbl (%rax),%eax
  801f4e:	0f be c0             	movsbl %al,%eax
  801f51:	83 e8 37             	sub    $0x37,%eax
  801f54:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801f57:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f5a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801f5d:	7d 23                	jge    801f82 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801f5f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f64:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f67:	48 98                	cltq   
  801f69:	48 89 c2             	mov    %rax,%rdx
  801f6c:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801f71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f74:	48 98                	cltq   
  801f76:	48 01 d0             	add    %rdx,%rax
  801f79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801f7d:	e9 5f ff ff ff       	jmpq   801ee1 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801f82:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801f83:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801f88:	74 0b                	je     801f95 <strtol+0x17c>
		*endptr = (char *) s;
  801f8a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f8e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f92:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801f95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f99:	74 09                	je     801fa4 <strtol+0x18b>
  801f9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f9f:	48 f7 d8             	neg    %rax
  801fa2:	eb 04                	jmp    801fa8 <strtol+0x18f>
  801fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801fa8:	c9                   	leaveq 
  801fa9:	c3                   	retq   

0000000000801faa <strstr>:

char * strstr(const char *in, const char *str)
{
  801faa:	55                   	push   %rbp
  801fab:	48 89 e5             	mov    %rsp,%rbp
  801fae:	48 83 ec 30          	sub    $0x30,%rsp
  801fb2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fb6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801fba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fbe:	0f b6 00             	movzbl (%rax),%eax
  801fc1:	88 45 ff             	mov    %al,-0x1(%rbp)
  801fc4:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801fc9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801fcd:	75 06                	jne    801fd5 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  801fcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd3:	eb 68                	jmp    80203d <strstr+0x93>

    len = strlen(str);
  801fd5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fd9:	48 89 c7             	mov    %rax,%rdi
  801fdc:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  801fe3:	00 00 00 
  801fe6:	ff d0                	callq  *%rax
  801fe8:	48 98                	cltq   
  801fea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801fee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff2:	0f b6 00             	movzbl (%rax),%eax
  801ff5:	88 45 ef             	mov    %al,-0x11(%rbp)
  801ff8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801ffd:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802001:	75 07                	jne    80200a <strstr+0x60>
                return (char *) 0;
  802003:	b8 00 00 00 00       	mov    $0x0,%eax
  802008:	eb 33                	jmp    80203d <strstr+0x93>
        } while (sc != c);
  80200a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80200e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802011:	75 db                	jne    801fee <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  802013:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802017:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80201b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80201f:	48 89 ce             	mov    %rcx,%rsi
  802022:	48 89 c7             	mov    %rax,%rdi
  802025:	48 b8 9c 1a 80 00 00 	movabs $0x801a9c,%rax
  80202c:	00 00 00 
  80202f:	ff d0                	callq  *%rax
  802031:	85 c0                	test   %eax,%eax
  802033:	75 b9                	jne    801fee <strstr+0x44>

    return (char *) (in - 1);
  802035:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802039:	48 83 e8 01          	sub    $0x1,%rax
}
  80203d:	c9                   	leaveq 
  80203e:	c3                   	retq   
	...

0000000000802040 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802040:	55                   	push   %rbp
  802041:	48 89 e5             	mov    %rsp,%rbp
  802044:	53                   	push   %rbx
  802045:	48 83 ec 58          	sub    $0x58,%rsp
  802049:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80204c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80204f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802053:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802057:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80205b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80205f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802062:	89 45 ac             	mov    %eax,-0x54(%rbp)
  802065:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802069:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80206d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802071:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802075:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802079:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80207c:	4c 89 c3             	mov    %r8,%rbx
  80207f:	cd 30                	int    $0x30
  802081:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  802085:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  802089:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80208d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802091:	74 3e                	je     8020d1 <syscall+0x91>
  802093:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802098:	7e 37                	jle    8020d1 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80209a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80209e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8020a1:	49 89 d0             	mov    %rdx,%r8
  8020a4:	89 c1                	mov    %eax,%ecx
  8020a6:	48 ba 60 59 80 00 00 	movabs $0x805960,%rdx
  8020ad:	00 00 00 
  8020b0:	be 23 00 00 00       	mov    $0x23,%esi
  8020b5:	48 bf 7d 59 80 00 00 	movabs $0x80597d,%rdi
  8020bc:	00 00 00 
  8020bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c4:	49 b9 f4 0a 80 00 00 	movabs $0x800af4,%r9
  8020cb:	00 00 00 
  8020ce:	41 ff d1             	callq  *%r9

	return ret;
  8020d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8020d5:	48 83 c4 58          	add    $0x58,%rsp
  8020d9:	5b                   	pop    %rbx
  8020da:	5d                   	pop    %rbp
  8020db:	c3                   	retq   

00000000008020dc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8020dc:	55                   	push   %rbp
  8020dd:	48 89 e5             	mov    %rsp,%rbp
  8020e0:	48 83 ec 20          	sub    $0x20,%rsp
  8020e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8020ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020f4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020fb:	00 
  8020fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802102:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802108:	48 89 d1             	mov    %rdx,%rcx
  80210b:	48 89 c2             	mov    %rax,%rdx
  80210e:	be 00 00 00 00       	mov    $0x0,%esi
  802113:	bf 00 00 00 00       	mov    $0x0,%edi
  802118:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  80211f:	00 00 00 
  802122:	ff d0                	callq  *%rax
}
  802124:	c9                   	leaveq 
  802125:	c3                   	retq   

0000000000802126 <sys_cgetc>:

int
sys_cgetc(void)
{
  802126:	55                   	push   %rbp
  802127:	48 89 e5             	mov    %rsp,%rbp
  80212a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80212e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802135:	00 
  802136:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80213c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802142:	b9 00 00 00 00       	mov    $0x0,%ecx
  802147:	ba 00 00 00 00       	mov    $0x0,%edx
  80214c:	be 00 00 00 00       	mov    $0x0,%esi
  802151:	bf 01 00 00 00       	mov    $0x1,%edi
  802156:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  80215d:	00 00 00 
  802160:	ff d0                	callq  *%rax
}
  802162:	c9                   	leaveq 
  802163:	c3                   	retq   

0000000000802164 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802164:	55                   	push   %rbp
  802165:	48 89 e5             	mov    %rsp,%rbp
  802168:	48 83 ec 20          	sub    $0x20,%rsp
  80216c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80216f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802172:	48 98                	cltq   
  802174:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80217b:	00 
  80217c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802182:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802188:	b9 00 00 00 00       	mov    $0x0,%ecx
  80218d:	48 89 c2             	mov    %rax,%rdx
  802190:	be 01 00 00 00       	mov    $0x1,%esi
  802195:	bf 03 00 00 00       	mov    $0x3,%edi
  80219a:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  8021a1:	00 00 00 
  8021a4:	ff d0                	callq  *%rax
}
  8021a6:	c9                   	leaveq 
  8021a7:	c3                   	retq   

00000000008021a8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8021a8:	55                   	push   %rbp
  8021a9:	48 89 e5             	mov    %rsp,%rbp
  8021ac:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8021b0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021b7:	00 
  8021b8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ce:	be 00 00 00 00       	mov    $0x0,%esi
  8021d3:	bf 02 00 00 00       	mov    $0x2,%edi
  8021d8:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  8021df:	00 00 00 
  8021e2:	ff d0                	callq  *%rax
}
  8021e4:	c9                   	leaveq 
  8021e5:	c3                   	retq   

00000000008021e6 <sys_yield>:

void
sys_yield(void)
{
  8021e6:	55                   	push   %rbp
  8021e7:	48 89 e5             	mov    %rsp,%rbp
  8021ea:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8021ee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021f5:	00 
  8021f6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802202:	b9 00 00 00 00       	mov    $0x0,%ecx
  802207:	ba 00 00 00 00       	mov    $0x0,%edx
  80220c:	be 00 00 00 00       	mov    $0x0,%esi
  802211:	bf 0b 00 00 00       	mov    $0xb,%edi
  802216:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  80221d:	00 00 00 
  802220:	ff d0                	callq  *%rax
}
  802222:	c9                   	leaveq 
  802223:	c3                   	retq   

0000000000802224 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802224:	55                   	push   %rbp
  802225:	48 89 e5             	mov    %rsp,%rbp
  802228:	48 83 ec 20          	sub    $0x20,%rsp
  80222c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80222f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802233:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802236:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802239:	48 63 c8             	movslq %eax,%rcx
  80223c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802240:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802243:	48 98                	cltq   
  802245:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80224c:	00 
  80224d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802253:	49 89 c8             	mov    %rcx,%r8
  802256:	48 89 d1             	mov    %rdx,%rcx
  802259:	48 89 c2             	mov    %rax,%rdx
  80225c:	be 01 00 00 00       	mov    $0x1,%esi
  802261:	bf 04 00 00 00       	mov    $0x4,%edi
  802266:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  80226d:	00 00 00 
  802270:	ff d0                	callq  *%rax
}
  802272:	c9                   	leaveq 
  802273:	c3                   	retq   

0000000000802274 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802274:	55                   	push   %rbp
  802275:	48 89 e5             	mov    %rsp,%rbp
  802278:	48 83 ec 30          	sub    $0x30,%rsp
  80227c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80227f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802283:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802286:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80228a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80228e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802291:	48 63 c8             	movslq %eax,%rcx
  802294:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802298:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80229b:	48 63 f0             	movslq %eax,%rsi
  80229e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a5:	48 98                	cltq   
  8022a7:	48 89 0c 24          	mov    %rcx,(%rsp)
  8022ab:	49 89 f9             	mov    %rdi,%r9
  8022ae:	49 89 f0             	mov    %rsi,%r8
  8022b1:	48 89 d1             	mov    %rdx,%rcx
  8022b4:	48 89 c2             	mov    %rax,%rdx
  8022b7:	be 01 00 00 00       	mov    $0x1,%esi
  8022bc:	bf 05 00 00 00       	mov    $0x5,%edi
  8022c1:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  8022c8:	00 00 00 
  8022cb:	ff d0                	callq  *%rax
}
  8022cd:	c9                   	leaveq 
  8022ce:	c3                   	retq   

00000000008022cf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8022cf:	55                   	push   %rbp
  8022d0:	48 89 e5             	mov    %rsp,%rbp
  8022d3:	48 83 ec 20          	sub    $0x20,%rsp
  8022d7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8022de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e5:	48 98                	cltq   
  8022e7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022ee:	00 
  8022ef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022f5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022fb:	48 89 d1             	mov    %rdx,%rcx
  8022fe:	48 89 c2             	mov    %rax,%rdx
  802301:	be 01 00 00 00       	mov    $0x1,%esi
  802306:	bf 06 00 00 00       	mov    $0x6,%edi
  80230b:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  802312:	00 00 00 
  802315:	ff d0                	callq  *%rax
}
  802317:	c9                   	leaveq 
  802318:	c3                   	retq   

0000000000802319 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802319:	55                   	push   %rbp
  80231a:	48 89 e5             	mov    %rsp,%rbp
  80231d:	48 83 ec 20          	sub    $0x20,%rsp
  802321:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802324:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802327:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80232a:	48 63 d0             	movslq %eax,%rdx
  80232d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802330:	48 98                	cltq   
  802332:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802339:	00 
  80233a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802340:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802346:	48 89 d1             	mov    %rdx,%rcx
  802349:	48 89 c2             	mov    %rax,%rdx
  80234c:	be 01 00 00 00       	mov    $0x1,%esi
  802351:	bf 08 00 00 00       	mov    $0x8,%edi
  802356:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  80235d:	00 00 00 
  802360:	ff d0                	callq  *%rax
}
  802362:	c9                   	leaveq 
  802363:	c3                   	retq   

0000000000802364 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802364:	55                   	push   %rbp
  802365:	48 89 e5             	mov    %rsp,%rbp
  802368:	48 83 ec 20          	sub    $0x20,%rsp
  80236c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80236f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802373:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802377:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237a:	48 98                	cltq   
  80237c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802383:	00 
  802384:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80238a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802390:	48 89 d1             	mov    %rdx,%rcx
  802393:	48 89 c2             	mov    %rax,%rdx
  802396:	be 01 00 00 00       	mov    $0x1,%esi
  80239b:	bf 09 00 00 00       	mov    $0x9,%edi
  8023a0:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  8023a7:	00 00 00 
  8023aa:	ff d0                	callq  *%rax
}
  8023ac:	c9                   	leaveq 
  8023ad:	c3                   	retq   

00000000008023ae <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8023ae:	55                   	push   %rbp
  8023af:	48 89 e5             	mov    %rsp,%rbp
  8023b2:	48 83 ec 20          	sub    $0x20,%rsp
  8023b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8023bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c4:	48 98                	cltq   
  8023c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023cd:	00 
  8023ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023da:	48 89 d1             	mov    %rdx,%rcx
  8023dd:	48 89 c2             	mov    %rax,%rdx
  8023e0:	be 01 00 00 00       	mov    $0x1,%esi
  8023e5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8023ea:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  8023f1:	00 00 00 
  8023f4:	ff d0                	callq  *%rax
}
  8023f6:	c9                   	leaveq 
  8023f7:	c3                   	retq   

00000000008023f8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8023f8:	55                   	push   %rbp
  8023f9:	48 89 e5             	mov    %rsp,%rbp
  8023fc:	48 83 ec 30          	sub    $0x30,%rsp
  802400:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802403:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802407:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80240b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80240e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802411:	48 63 f0             	movslq %eax,%rsi
  802414:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802418:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241b:	48 98                	cltq   
  80241d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802421:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802428:	00 
  802429:	49 89 f1             	mov    %rsi,%r9
  80242c:	49 89 c8             	mov    %rcx,%r8
  80242f:	48 89 d1             	mov    %rdx,%rcx
  802432:	48 89 c2             	mov    %rax,%rdx
  802435:	be 00 00 00 00       	mov    $0x0,%esi
  80243a:	bf 0c 00 00 00       	mov    $0xc,%edi
  80243f:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  802446:	00 00 00 
  802449:	ff d0                	callq  *%rax
}
  80244b:	c9                   	leaveq 
  80244c:	c3                   	retq   

000000000080244d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80244d:	55                   	push   %rbp
  80244e:	48 89 e5             	mov    %rsp,%rbp
  802451:	48 83 ec 20          	sub    $0x20,%rsp
  802455:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802459:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80245d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802464:	00 
  802465:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80246b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802471:	b9 00 00 00 00       	mov    $0x0,%ecx
  802476:	48 89 c2             	mov    %rax,%rdx
  802479:	be 01 00 00 00       	mov    $0x1,%esi
  80247e:	bf 0d 00 00 00       	mov    $0xd,%edi
  802483:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  80248a:	00 00 00 
  80248d:	ff d0                	callq  *%rax
}
  80248f:	c9                   	leaveq 
  802490:	c3                   	retq   

0000000000802491 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802491:	55                   	push   %rbp
  802492:	48 89 e5             	mov    %rsp,%rbp
  802495:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802499:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024a0:	00 
  8024a1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024a7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8024b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8024b7:	be 00 00 00 00       	mov    $0x0,%esi
  8024bc:	bf 0e 00 00 00       	mov    $0xe,%edi
  8024c1:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  8024c8:	00 00 00 
  8024cb:	ff d0                	callq  *%rax
}
  8024cd:	c9                   	leaveq 
  8024ce:	c3                   	retq   

00000000008024cf <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  8024cf:	55                   	push   %rbp
  8024d0:	48 89 e5             	mov    %rsp,%rbp
  8024d3:	48 83 ec 20          	sub    $0x20,%rsp
  8024d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  8024df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024e7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024ee:	00 
  8024ef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024f5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024fb:	48 89 d1             	mov    %rdx,%rcx
  8024fe:	48 89 c2             	mov    %rax,%rdx
  802501:	be 00 00 00 00       	mov    $0x0,%esi
  802506:	bf 0f 00 00 00       	mov    $0xf,%edi
  80250b:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  802512:	00 00 00 
  802515:	ff d0                	callq  *%rax
}
  802517:	c9                   	leaveq 
  802518:	c3                   	retq   

0000000000802519 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  802519:	55                   	push   %rbp
  80251a:	48 89 e5             	mov    %rsp,%rbp
  80251d:	48 83 ec 20          	sub    $0x20,%rsp
  802521:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802525:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  802529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80252d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802531:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802538:	00 
  802539:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80253f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802545:	48 89 d1             	mov    %rdx,%rcx
  802548:	48 89 c2             	mov    %rax,%rdx
  80254b:	be 00 00 00 00       	mov    $0x0,%esi
  802550:	bf 10 00 00 00       	mov    $0x10,%edi
  802555:	48 b8 40 20 80 00 00 	movabs $0x802040,%rax
  80255c:	00 00 00 
  80255f:	ff d0                	callq  *%rax
}
  802561:	c9                   	leaveq 
  802562:	c3                   	retq   
	...

0000000000802564 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802564:	55                   	push   %rbp
  802565:	48 89 e5             	mov    %rsp,%rbp
  802568:	48 83 ec 30          	sub    $0x30,%rsp
  80256c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802570:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802574:	48 8b 00             	mov    (%rax),%rax
  802577:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80257b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80257f:	48 8b 40 08          	mov    0x8(%rax),%rax
  802583:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  802586:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802589:	83 e0 02             	and    $0x2,%eax
  80258c:	85 c0                	test   %eax,%eax
  80258e:	74 23                	je     8025b3 <pgfault+0x4f>
  802590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802594:	48 89 c2             	mov    %rax,%rdx
  802597:	48 c1 ea 0c          	shr    $0xc,%rdx
  80259b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025a2:	01 00 00 
  8025a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a9:	25 00 08 00 00       	and    $0x800,%eax
  8025ae:	48 85 c0             	test   %rax,%rax
  8025b1:	75 2a                	jne    8025dd <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  8025b3:	48 ba 90 59 80 00 00 	movabs $0x805990,%rdx
  8025ba:	00 00 00 
  8025bd:	be 1c 00 00 00       	mov    $0x1c,%esi
  8025c2:	48 bf c5 59 80 00 00 	movabs $0x8059c5,%rdi
  8025c9:	00 00 00 
  8025cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d1:	48 b9 f4 0a 80 00 00 	movabs $0x800af4,%rcx
  8025d8:	00 00 00 
  8025db:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  8025dd:	ba 07 00 00 00       	mov    $0x7,%edx
  8025e2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8025e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ec:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  8025f3:	00 00 00 
  8025f6:	ff d0                	callq  *%rax
  8025f8:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8025fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8025ff:	79 30                	jns    802631 <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  802601:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802604:	89 c1                	mov    %eax,%ecx
  802606:	48 ba d0 59 80 00 00 	movabs $0x8059d0,%rdx
  80260d:	00 00 00 
  802610:	be 26 00 00 00       	mov    $0x26,%esi
  802615:	48 bf c5 59 80 00 00 	movabs $0x8059c5,%rdi
  80261c:	00 00 00 
  80261f:	b8 00 00 00 00       	mov    $0x0,%eax
  802624:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  80262b:	00 00 00 
  80262e:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  802631:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802635:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802639:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802643:	ba 00 10 00 00       	mov    $0x1000,%edx
  802648:	48 89 c6             	mov    %rax,%rsi
  80264b:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802650:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  802657:	00 00 00 
  80265a:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  80265c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802660:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  802664:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802668:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80266e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802674:	48 89 c1             	mov    %rax,%rcx
  802677:	ba 00 00 00 00       	mov    $0x0,%edx
  80267c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802681:	bf 00 00 00 00       	mov    $0x0,%edi
  802686:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  80268d:	00 00 00 
  802690:	ff d0                	callq  *%rax
  802692:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802695:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802699:	79 30                	jns    8026cb <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  80269b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80269e:	89 c1                	mov    %eax,%ecx
  8026a0:	48 ba f8 59 80 00 00 	movabs $0x8059f8,%rdx
  8026a7:	00 00 00 
  8026aa:	be 2b 00 00 00       	mov    $0x2b,%esi
  8026af:	48 bf c5 59 80 00 00 	movabs $0x8059c5,%rdi
  8026b6:	00 00 00 
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026be:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  8026c5:	00 00 00 
  8026c8:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  8026cb:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8026d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d5:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  8026dc:	00 00 00 
  8026df:	ff d0                	callq  *%rax
  8026e1:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8026e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8026e8:	79 30                	jns    80271a <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  8026ea:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8026ed:	89 c1                	mov    %eax,%ecx
  8026ef:	48 ba 20 5a 80 00 00 	movabs $0x805a20,%rdx
  8026f6:	00 00 00 
  8026f9:	be 2e 00 00 00       	mov    $0x2e,%esi
  8026fe:	48 bf c5 59 80 00 00 	movabs $0x8059c5,%rdi
  802705:	00 00 00 
  802708:	b8 00 00 00 00       	mov    $0x0,%eax
  80270d:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  802714:	00 00 00 
  802717:	41 ff d0             	callq  *%r8
	
}
  80271a:	c9                   	leaveq 
  80271b:	c3                   	retq   

000000000080271c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80271c:	55                   	push   %rbp
  80271d:	48 89 e5             	mov    %rsp,%rbp
  802720:	48 83 ec 30          	sub    $0x30,%rsp
  802724:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802727:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  80272a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802731:	01 00 00 
  802734:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802737:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80273b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  80273f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802743:	25 07 0e 00 00       	and    $0xe07,%eax
  802748:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  80274b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80274e:	48 c1 e0 0c          	shl    $0xc,%rax
  802752:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  802756:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802759:	25 00 04 00 00       	and    $0x400,%eax
  80275e:	85 c0                	test   %eax,%eax
  802760:	74 5c                	je     8027be <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  802762:	8b 75 f4             	mov    -0xc(%rbp),%esi
  802765:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802769:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80276c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802770:	41 89 f0             	mov    %esi,%r8d
  802773:	48 89 c6             	mov    %rax,%rsi
  802776:	bf 00 00 00 00       	mov    $0x0,%edi
  80277b:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802782:	00 00 00 
  802785:	ff d0                	callq  *%rax
  802787:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  80278a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80278e:	0f 89 60 01 00 00    	jns    8028f4 <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  802794:	48 ba 48 5a 80 00 00 	movabs $0x805a48,%rdx
  80279b:	00 00 00 
  80279e:	be 4d 00 00 00       	mov    $0x4d,%esi
  8027a3:	48 bf c5 59 80 00 00 	movabs $0x8059c5,%rdi
  8027aa:	00 00 00 
  8027ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b2:	48 b9 f4 0a 80 00 00 	movabs $0x800af4,%rcx
  8027b9:	00 00 00 
  8027bc:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  8027be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8027c1:	83 e0 02             	and    $0x2,%eax
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	75 10                	jne    8027d8 <duppage+0xbc>
  8027c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8027cb:	25 00 08 00 00       	and    $0x800,%eax
  8027d0:	85 c0                	test   %eax,%eax
  8027d2:	0f 84 c4 00 00 00    	je     80289c <duppage+0x180>
	{
		perm |= PTE_COW;
  8027d8:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  8027df:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  8027e3:	8b 75 f4             	mov    -0xc(%rbp),%esi
  8027e6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027ea:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f1:	41 89 f0             	mov    %esi,%r8d
  8027f4:	48 89 c6             	mov    %rax,%rsi
  8027f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8027fc:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802803:	00 00 00 
  802806:	ff d0                	callq  *%rax
  802808:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  80280b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80280f:	79 2a                	jns    80283b <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  802811:	48 ba 78 5a 80 00 00 	movabs $0x805a78,%rdx
  802818:	00 00 00 
  80281b:	be 56 00 00 00       	mov    $0x56,%esi
  802820:	48 bf c5 59 80 00 00 	movabs $0x8059c5,%rdi
  802827:	00 00 00 
  80282a:	b8 00 00 00 00       	mov    $0x0,%eax
  80282f:	48 b9 f4 0a 80 00 00 	movabs $0x800af4,%rcx
  802836:	00 00 00 
  802839:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  80283b:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  80283e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802842:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802846:	41 89 c8             	mov    %ecx,%r8d
  802849:	48 89 d1             	mov    %rdx,%rcx
  80284c:	ba 00 00 00 00       	mov    $0x0,%edx
  802851:	48 89 c6             	mov    %rax,%rsi
  802854:	bf 00 00 00 00       	mov    $0x0,%edi
  802859:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  802860:	00 00 00 
  802863:	ff d0                	callq  *%rax
  802865:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  802868:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80286c:	0f 89 82 00 00 00    	jns    8028f4 <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  802872:	48 ba 78 5a 80 00 00 	movabs $0x805a78,%rdx
  802879:	00 00 00 
  80287c:	be 59 00 00 00       	mov    $0x59,%esi
  802881:	48 bf c5 59 80 00 00 	movabs $0x8059c5,%rdi
  802888:	00 00 00 
  80288b:	b8 00 00 00 00       	mov    $0x0,%eax
  802890:	48 b9 f4 0a 80 00 00 	movabs $0x800af4,%rcx
  802897:	00 00 00 
  80289a:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  80289c:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80289f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028a3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028aa:	41 89 f0             	mov    %esi,%r8d
  8028ad:	48 89 c6             	mov    %rax,%rsi
  8028b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8028b5:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  8028bc:	00 00 00 
  8028bf:	ff d0                	callq  *%rax
  8028c1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  8028c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8028c8:	79 2a                	jns    8028f4 <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  8028ca:	48 ba b0 5a 80 00 00 	movabs $0x805ab0,%rdx
  8028d1:	00 00 00 
  8028d4:	be 60 00 00 00       	mov    $0x60,%esi
  8028d9:	48 bf c5 59 80 00 00 	movabs $0x8059c5,%rdi
  8028e0:	00 00 00 
  8028e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e8:	48 b9 f4 0a 80 00 00 	movabs $0x800af4,%rcx
  8028ef:	00 00 00 
  8028f2:	ff d1                	callq  *%rcx
	}
	return 0;
  8028f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f9:	c9                   	leaveq 
  8028fa:	c3                   	retq   

00000000008028fb <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8028fb:	55                   	push   %rbp
  8028fc:	48 89 e5             	mov    %rsp,%rbp
  8028ff:	53                   	push   %rbx
  802900:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  802904:	48 bf 64 25 80 00 00 	movabs $0x802564,%rdi
  80290b:	00 00 00 
  80290e:	48 b8 c0 4b 80 00 00 	movabs $0x804bc0,%rax
  802915:	00 00 00 
  802918:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80291a:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  802921:	8b 45 bc             	mov    -0x44(%rbp),%eax
  802924:	cd 30                	int    $0x30
  802926:	89 c3                	mov    %eax,%ebx
  802928:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80292b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  80292e:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  802931:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802935:	79 30                	jns    802967 <fork+0x6c>
                panic("sys_exofork: %e", envid);
  802937:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80293a:	89 c1                	mov    %eax,%ecx
  80293c:	48 ba d4 5a 80 00 00 	movabs $0x805ad4,%rdx
  802943:	00 00 00 
  802946:	be 7f 00 00 00       	mov    $0x7f,%esi
  80294b:	48 bf c5 59 80 00 00 	movabs $0x8059c5,%rdi
  802952:	00 00 00 
  802955:	b8 00 00 00 00       	mov    $0x0,%eax
  80295a:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  802961:	00 00 00 
  802964:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  802967:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80296b:	75 4c                	jne    8029b9 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  80296d:	48 b8 a8 21 80 00 00 	movabs $0x8021a8,%rax
  802974:	00 00 00 
  802977:	ff d0                	callq  *%rax
  802979:	48 98                	cltq   
  80297b:	48 89 c2             	mov    %rax,%rdx
  80297e:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802984:	48 89 d0             	mov    %rdx,%rax
  802987:	48 c1 e0 03          	shl    $0x3,%rax
  80298b:	48 01 d0             	add    %rdx,%rax
  80298e:	48 c1 e0 05          	shl    $0x5,%rax
  802992:	48 89 c2             	mov    %rax,%rdx
  802995:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80299c:	00 00 00 
  80299f:	48 01 c2             	add    %rax,%rdx
  8029a2:	48 b8 70 80 80 00 00 	movabs $0x808070,%rax
  8029a9:	00 00 00 
  8029ac:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  8029af:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b4:	e9 38 02 00 00       	jmpq   802bf1 <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  8029b9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8029bc:	ba 07 00 00 00       	mov    $0x7,%edx
  8029c1:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8029c6:	89 c7                	mov    %eax,%edi
  8029c8:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  8029cf:	00 00 00 
  8029d2:	ff d0                	callq  *%rax
  8029d4:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  8029d7:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8029db:	79 30                	jns    802a0d <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  8029dd:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8029e0:	89 c1                	mov    %eax,%ecx
  8029e2:	48 ba e8 5a 80 00 00 	movabs $0x805ae8,%rdx
  8029e9:	00 00 00 
  8029ec:	be 8b 00 00 00       	mov    $0x8b,%esi
  8029f1:	48 bf c5 59 80 00 00 	movabs $0x8059c5,%rdi
  8029f8:	00 00 00 
  8029fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802a00:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  802a07:	00 00 00 
  802a0a:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  802a0d:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  802a14:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802a1b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  802a22:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  802a29:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  802a30:	e9 0a 01 00 00       	jmpq   802b3f <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  802a35:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802a3c:	01 00 00 
  802a3f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a42:	48 63 d2             	movslq %edx,%rdx
  802a45:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a49:	83 e0 01             	and    $0x1,%eax
  802a4c:	84 c0                	test   %al,%al
  802a4e:	0f 84 e7 00 00 00    	je     802b3b <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  802a54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  802a5b:	e9 cf 00 00 00       	jmpq   802b2f <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  802a60:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802a67:	01 00 00 
  802a6a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a6d:	48 63 d2             	movslq %edx,%rdx
  802a70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a74:	83 e0 01             	and    $0x1,%eax
  802a77:	84 c0                	test   %al,%al
  802a79:	0f 84 a0 00 00 00    	je     802b1f <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  802a7f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  802a86:	e9 85 00 00 00       	jmpq   802b10 <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  802a8b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a92:	01 00 00 
  802a95:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a98:	48 63 d2             	movslq %edx,%rdx
  802a9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a9f:	83 e0 01             	and    $0x1,%eax
  802aa2:	84 c0                	test   %al,%al
  802aa4:	74 56                	je     802afc <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802aa6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  802aad:	eb 42                	jmp    802af1 <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  802aaf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ab6:	01 00 00 
  802ab9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802abc:	48 63 d2             	movslq %edx,%rdx
  802abf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ac3:	83 e0 01             	and    $0x1,%eax
  802ac6:	84 c0                	test   %al,%al
  802ac8:	74 1f                	je     802ae9 <fork+0x1ee>
  802aca:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  802ad1:	74 16                	je     802ae9 <fork+0x1ee>
									 duppage(envid,d1);
  802ad3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802ad6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ad9:	89 d6                	mov    %edx,%esi
  802adb:	89 c7                	mov    %eax,%edi
  802add:	48 b8 1c 27 80 00 00 	movabs $0x80271c,%rax
  802ae4:	00 00 00 
  802ae7:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802ae9:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  802aed:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  802af1:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  802af8:	7e b5                	jle    802aaf <fork+0x1b4>
  802afa:	eb 0c                	jmp    802b08 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  802afc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802aff:	83 c0 01             	add    $0x1,%eax
  802b02:	c1 e0 09             	shl    $0x9,%eax
  802b05:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  802b08:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  802b0c:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  802b10:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  802b17:	0f 8e 6e ff ff ff    	jle    802a8b <fork+0x190>
  802b1d:	eb 0c                	jmp    802b2b <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  802b1f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802b22:	83 c0 01             	add    $0x1,%eax
  802b25:	c1 e0 09             	shl    $0x9,%eax
  802b28:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  802b2b:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  802b2f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802b32:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  802b35:	0f 8c 25 ff ff ff    	jl     802a60 <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802b3b:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  802b3f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b42:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802b45:	0f 8c ea fe ff ff    	jl     802a35 <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  802b4b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802b4e:	48 be 84 4c 80 00 00 	movabs $0x804c84,%rsi
  802b55:	00 00 00 
  802b58:	89 c7                	mov    %eax,%edi
  802b5a:	48 b8 ae 23 80 00 00 	movabs $0x8023ae,%rax
  802b61:	00 00 00 
  802b64:	ff d0                	callq  *%rax
  802b66:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802b69:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802b6d:	79 30                	jns    802b9f <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  802b6f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802b72:	89 c1                	mov    %eax,%ecx
  802b74:	48 ba 08 5b 80 00 00 	movabs $0x805b08,%rdx
  802b7b:	00 00 00 
  802b7e:	be ad 00 00 00       	mov    $0xad,%esi
  802b83:	48 bf c5 59 80 00 00 	movabs $0x8059c5,%rdi
  802b8a:	00 00 00 
  802b8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b92:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  802b99:	00 00 00 
  802b9c:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  802b9f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ba2:	be 02 00 00 00       	mov    $0x2,%esi
  802ba7:	89 c7                	mov    %eax,%edi
  802ba9:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  802bb0:	00 00 00 
  802bb3:	ff d0                	callq  *%rax
  802bb5:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802bb8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802bbc:	79 30                	jns    802bee <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  802bbe:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802bc1:	89 c1                	mov    %eax,%ecx
  802bc3:	48 ba 38 5b 80 00 00 	movabs $0x805b38,%rdx
  802bca:	00 00 00 
  802bcd:	be b0 00 00 00       	mov    $0xb0,%esi
  802bd2:	48 bf c5 59 80 00 00 	movabs $0x8059c5,%rdi
  802bd9:	00 00 00 
  802bdc:	b8 00 00 00 00       	mov    $0x0,%eax
  802be1:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  802be8:	00 00 00 
  802beb:	41 ff d0             	callq  *%r8
	return envid;
  802bee:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  802bf1:	48 83 c4 48          	add    $0x48,%rsp
  802bf5:	5b                   	pop    %rbx
  802bf6:	5d                   	pop    %rbp
  802bf7:	c3                   	retq   

0000000000802bf8 <sfork>:

// Challenge!
int
sfork(void)
{
  802bf8:	55                   	push   %rbp
  802bf9:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802bfc:	48 ba 5c 5b 80 00 00 	movabs $0x805b5c,%rdx
  802c03:	00 00 00 
  802c06:	be b8 00 00 00       	mov    $0xb8,%esi
  802c0b:	48 bf c5 59 80 00 00 	movabs $0x8059c5,%rdi
  802c12:	00 00 00 
  802c15:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1a:	48 b9 f4 0a 80 00 00 	movabs $0x800af4,%rcx
  802c21:	00 00 00 
  802c24:	ff d1                	callq  *%rcx
	...

0000000000802c28 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c28:	55                   	push   %rbp
  802c29:	48 89 e5             	mov    %rsp,%rbp
  802c2c:	48 83 ec 30          	sub    $0x30,%rsp
  802c30:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c38:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  802c3c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c41:	74 18                	je     802c5b <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  802c43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c47:	48 89 c7             	mov    %rax,%rdi
  802c4a:	48 b8 4d 24 80 00 00 	movabs $0x80244d,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
  802c56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c59:	eb 19                	jmp    802c74 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  802c5b:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  802c62:	00 00 00 
  802c65:	48 b8 4d 24 80 00 00 	movabs $0x80244d,%rax
  802c6c:	00 00 00 
  802c6f:	ff d0                	callq  *%rax
  802c71:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  802c74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c78:	79 19                	jns    802c93 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  802c7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  802c84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c88:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  802c8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c91:	eb 53                	jmp    802ce6 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  802c93:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802c98:	74 19                	je     802cb3 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  802c9a:	48 b8 70 80 80 00 00 	movabs $0x808070,%rax
  802ca1:	00 00 00 
  802ca4:	48 8b 00             	mov    (%rax),%rax
  802ca7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802cad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb1:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  802cb3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802cb8:	74 19                	je     802cd3 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  802cba:	48 b8 70 80 80 00 00 	movabs $0x808070,%rax
  802cc1:	00 00 00 
  802cc4:	48 8b 00             	mov    (%rax),%rax
  802cc7:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802ccd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cd1:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  802cd3:	48 b8 70 80 80 00 00 	movabs $0x808070,%rax
  802cda:	00 00 00 
  802cdd:	48 8b 00             	mov    (%rax),%rax
  802ce0:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  802ce6:	c9                   	leaveq 
  802ce7:	c3                   	retq   

0000000000802ce8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802ce8:	55                   	push   %rbp
  802ce9:	48 89 e5             	mov    %rsp,%rbp
  802cec:	48 83 ec 30          	sub    $0x30,%rsp
  802cf0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cf3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802cf6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802cfa:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  802cfd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  802d04:	e9 96 00 00 00       	jmpq   802d9f <ipc_send+0xb7>
	{
		if(pg!=NULL)
  802d09:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802d0e:	74 20                	je     802d30 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  802d10:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802d13:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802d16:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d1a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d1d:	89 c7                	mov    %eax,%edi
  802d1f:	48 b8 f8 23 80 00 00 	movabs $0x8023f8,%rax
  802d26:	00 00 00 
  802d29:	ff d0                	callq  *%rax
  802d2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d2e:	eb 2d                	jmp    802d5d <ipc_send+0x75>
		else if(pg==NULL)
  802d30:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802d35:	75 26                	jne    802d5d <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  802d37:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802d3a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d42:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802d49:	00 00 00 
  802d4c:	89 c7                	mov    %eax,%edi
  802d4e:	48 b8 f8 23 80 00 00 	movabs $0x8023f8,%rax
  802d55:	00 00 00 
  802d58:	ff d0                	callq  *%rax
  802d5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  802d5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d61:	79 30                	jns    802d93 <ipc_send+0xab>
  802d63:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802d67:	74 2a                	je     802d93 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  802d69:	48 ba 72 5b 80 00 00 	movabs $0x805b72,%rdx
  802d70:	00 00 00 
  802d73:	be 40 00 00 00       	mov    $0x40,%esi
  802d78:	48 bf 8a 5b 80 00 00 	movabs $0x805b8a,%rdi
  802d7f:	00 00 00 
  802d82:	b8 00 00 00 00       	mov    $0x0,%eax
  802d87:	48 b9 f4 0a 80 00 00 	movabs $0x800af4,%rcx
  802d8e:	00 00 00 
  802d91:	ff d1                	callq  *%rcx
		}
		sys_yield();
  802d93:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  802d9a:	00 00 00 
  802d9d:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  802d9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da3:	0f 85 60 ff ff ff    	jne    802d09 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  802da9:	c9                   	leaveq 
  802daa:	c3                   	retq   

0000000000802dab <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802dab:	55                   	push   %rbp
  802dac:	48 89 e5             	mov    %rsp,%rbp
  802daf:	48 83 ec 18          	sub    $0x18,%rsp
  802db3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  802db6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802dbd:	eb 5e                	jmp    802e1d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802dbf:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802dc6:	00 00 00 
  802dc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcc:	48 63 d0             	movslq %eax,%rdx
  802dcf:	48 89 d0             	mov    %rdx,%rax
  802dd2:	48 c1 e0 03          	shl    $0x3,%rax
  802dd6:	48 01 d0             	add    %rdx,%rax
  802dd9:	48 c1 e0 05          	shl    $0x5,%rax
  802ddd:	48 01 c8             	add    %rcx,%rax
  802de0:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802de6:	8b 00                	mov    (%rax),%eax
  802de8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802deb:	75 2c                	jne    802e19 <ipc_find_env+0x6e>
			return envs[i].env_id;
  802ded:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802df4:	00 00 00 
  802df7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfa:	48 63 d0             	movslq %eax,%rdx
  802dfd:	48 89 d0             	mov    %rdx,%rax
  802e00:	48 c1 e0 03          	shl    $0x3,%rax
  802e04:	48 01 d0             	add    %rdx,%rax
  802e07:	48 c1 e0 05          	shl    $0x5,%rax
  802e0b:	48 01 c8             	add    %rcx,%rax
  802e0e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802e14:	8b 40 08             	mov    0x8(%rax),%eax
  802e17:	eb 12                	jmp    802e2b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802e19:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802e1d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802e24:	7e 99                	jle    802dbf <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e2b:	c9                   	leaveq 
  802e2c:	c3                   	retq   
  802e2d:	00 00                	add    %al,(%rax)
	...

0000000000802e30 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802e30:	55                   	push   %rbp
  802e31:	48 89 e5             	mov    %rsp,%rbp
  802e34:	48 83 ec 08          	sub    $0x8,%rsp
  802e38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802e3c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e40:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802e47:	ff ff ff 
  802e4a:	48 01 d0             	add    %rdx,%rax
  802e4d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802e51:	c9                   	leaveq 
  802e52:	c3                   	retq   

0000000000802e53 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802e53:	55                   	push   %rbp
  802e54:	48 89 e5             	mov    %rsp,%rbp
  802e57:	48 83 ec 08          	sub    $0x8,%rsp
  802e5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802e5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e63:	48 89 c7             	mov    %rax,%rdi
  802e66:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  802e6d:	00 00 00 
  802e70:	ff d0                	callq  *%rax
  802e72:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802e78:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802e7c:	c9                   	leaveq 
  802e7d:	c3                   	retq   

0000000000802e7e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802e7e:	55                   	push   %rbp
  802e7f:	48 89 e5             	mov    %rsp,%rbp
  802e82:	48 83 ec 18          	sub    $0x18,%rsp
  802e86:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802e8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e91:	eb 6b                	jmp    802efe <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802e93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e96:	48 98                	cltq   
  802e98:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802e9e:	48 c1 e0 0c          	shl    $0xc,%rax
  802ea2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802ea6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eaa:	48 89 c2             	mov    %rax,%rdx
  802ead:	48 c1 ea 15          	shr    $0x15,%rdx
  802eb1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802eb8:	01 00 00 
  802ebb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ebf:	83 e0 01             	and    $0x1,%eax
  802ec2:	48 85 c0             	test   %rax,%rax
  802ec5:	74 21                	je     802ee8 <fd_alloc+0x6a>
  802ec7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ecb:	48 89 c2             	mov    %rax,%rdx
  802ece:	48 c1 ea 0c          	shr    $0xc,%rdx
  802ed2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ed9:	01 00 00 
  802edc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ee0:	83 e0 01             	and    $0x1,%eax
  802ee3:	48 85 c0             	test   %rax,%rax
  802ee6:	75 12                	jne    802efa <fd_alloc+0x7c>
			*fd_store = fd;
  802ee8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ef0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef8:	eb 1a                	jmp    802f14 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802efa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802efe:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802f02:	7e 8f                	jle    802e93 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802f04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f08:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802f0f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802f14:	c9                   	leaveq 
  802f15:	c3                   	retq   

0000000000802f16 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802f16:	55                   	push   %rbp
  802f17:	48 89 e5             	mov    %rsp,%rbp
  802f1a:	48 83 ec 20          	sub    $0x20,%rsp
  802f1e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f21:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802f25:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f29:	78 06                	js     802f31 <fd_lookup+0x1b>
  802f2b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802f2f:	7e 07                	jle    802f38 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802f31:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f36:	eb 6c                	jmp    802fa4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802f38:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f3b:	48 98                	cltq   
  802f3d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802f43:	48 c1 e0 0c          	shl    $0xc,%rax
  802f47:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802f4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f4f:	48 89 c2             	mov    %rax,%rdx
  802f52:	48 c1 ea 15          	shr    $0x15,%rdx
  802f56:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802f5d:	01 00 00 
  802f60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f64:	83 e0 01             	and    $0x1,%eax
  802f67:	48 85 c0             	test   %rax,%rax
  802f6a:	74 21                	je     802f8d <fd_lookup+0x77>
  802f6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f70:	48 89 c2             	mov    %rax,%rdx
  802f73:	48 c1 ea 0c          	shr    $0xc,%rdx
  802f77:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f7e:	01 00 00 
  802f81:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f85:	83 e0 01             	and    $0x1,%eax
  802f88:	48 85 c0             	test   %rax,%rax
  802f8b:	75 07                	jne    802f94 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802f8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f92:	eb 10                	jmp    802fa4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802f94:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f98:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f9c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802f9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fa4:	c9                   	leaveq 
  802fa5:	c3                   	retq   

0000000000802fa6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802fa6:	55                   	push   %rbp
  802fa7:	48 89 e5             	mov    %rsp,%rbp
  802faa:	48 83 ec 30          	sub    $0x30,%rsp
  802fae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802fb2:	89 f0                	mov    %esi,%eax
  802fb4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802fb7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fbb:	48 89 c7             	mov    %rax,%rdi
  802fbe:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  802fc5:	00 00 00 
  802fc8:	ff d0                	callq  *%rax
  802fca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fce:	48 89 d6             	mov    %rdx,%rsi
  802fd1:	89 c7                	mov    %eax,%edi
  802fd3:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  802fda:	00 00 00 
  802fdd:	ff d0                	callq  *%rax
  802fdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe6:	78 0a                	js     802ff2 <fd_close+0x4c>
	    || fd != fd2)
  802fe8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fec:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802ff0:	74 12                	je     803004 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802ff2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802ff6:	74 05                	je     802ffd <fd_close+0x57>
  802ff8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffb:	eb 05                	jmp    803002 <fd_close+0x5c>
  802ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  803002:	eb 69                	jmp    80306d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803004:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803008:	8b 00                	mov    (%rax),%eax
  80300a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80300e:	48 89 d6             	mov    %rdx,%rsi
  803011:	89 c7                	mov    %eax,%edi
  803013:	48 b8 6f 30 80 00 00 	movabs $0x80306f,%rax
  80301a:	00 00 00 
  80301d:	ff d0                	callq  *%rax
  80301f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803022:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803026:	78 2a                	js     803052 <fd_close+0xac>
		if (dev->dev_close)
  803028:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302c:	48 8b 40 20          	mov    0x20(%rax),%rax
  803030:	48 85 c0             	test   %rax,%rax
  803033:	74 16                	je     80304b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  803035:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803039:	48 8b 50 20          	mov    0x20(%rax),%rdx
  80303d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803041:	48 89 c7             	mov    %rax,%rdi
  803044:	ff d2                	callq  *%rdx
  803046:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803049:	eb 07                	jmp    803052 <fd_close+0xac>
		else
			r = 0;
  80304b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  803052:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803056:	48 89 c6             	mov    %rax,%rsi
  803059:	bf 00 00 00 00       	mov    $0x0,%edi
  80305e:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  803065:	00 00 00 
  803068:	ff d0                	callq  *%rax
	return r;
  80306a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80306d:	c9                   	leaveq 
  80306e:	c3                   	retq   

000000000080306f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80306f:	55                   	push   %rbp
  803070:	48 89 e5             	mov    %rsp,%rbp
  803073:	48 83 ec 20          	sub    $0x20,%rsp
  803077:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80307a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80307e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803085:	eb 41                	jmp    8030c8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  803087:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80308e:	00 00 00 
  803091:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803094:	48 63 d2             	movslq %edx,%rdx
  803097:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80309b:	8b 00                	mov    (%rax),%eax
  80309d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8030a0:	75 22                	jne    8030c4 <dev_lookup+0x55>
			*dev = devtab[i];
  8030a2:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8030a9:	00 00 00 
  8030ac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030af:	48 63 d2             	movslq %edx,%rdx
  8030b2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8030b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ba:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8030bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c2:	eb 60                	jmp    803124 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8030c4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8030c8:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8030cf:	00 00 00 
  8030d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030d5:	48 63 d2             	movslq %edx,%rdx
  8030d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030dc:	48 85 c0             	test   %rax,%rax
  8030df:	75 a6                	jne    803087 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8030e1:	48 b8 70 80 80 00 00 	movabs $0x808070,%rax
  8030e8:	00 00 00 
  8030eb:	48 8b 00             	mov    (%rax),%rax
  8030ee:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8030f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8030f7:	89 c6                	mov    %eax,%esi
  8030f9:	48 bf 98 5b 80 00 00 	movabs $0x805b98,%rdi
  803100:	00 00 00 
  803103:	b8 00 00 00 00       	mov    $0x0,%eax
  803108:	48 b9 2f 0d 80 00 00 	movabs $0x800d2f,%rcx
  80310f:	00 00 00 
  803112:	ff d1                	callq  *%rcx
	*dev = 0;
  803114:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803118:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80311f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803124:	c9                   	leaveq 
  803125:	c3                   	retq   

0000000000803126 <close>:

int
close(int fdnum)
{
  803126:	55                   	push   %rbp
  803127:	48 89 e5             	mov    %rsp,%rbp
  80312a:	48 83 ec 20          	sub    $0x20,%rsp
  80312e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803131:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803135:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803138:	48 89 d6             	mov    %rdx,%rsi
  80313b:	89 c7                	mov    %eax,%edi
  80313d:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  803144:	00 00 00 
  803147:	ff d0                	callq  *%rax
  803149:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80314c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803150:	79 05                	jns    803157 <close+0x31>
		return r;
  803152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803155:	eb 18                	jmp    80316f <close+0x49>
	else
		return fd_close(fd, 1);
  803157:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80315b:	be 01 00 00 00       	mov    $0x1,%esi
  803160:	48 89 c7             	mov    %rax,%rdi
  803163:	48 b8 a6 2f 80 00 00 	movabs $0x802fa6,%rax
  80316a:	00 00 00 
  80316d:	ff d0                	callq  *%rax
}
  80316f:	c9                   	leaveq 
  803170:	c3                   	retq   

0000000000803171 <close_all>:

void
close_all(void)
{
  803171:	55                   	push   %rbp
  803172:	48 89 e5             	mov    %rsp,%rbp
  803175:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803179:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803180:	eb 15                	jmp    803197 <close_all+0x26>
		close(i);
  803182:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803185:	89 c7                	mov    %eax,%edi
  803187:	48 b8 26 31 80 00 00 	movabs $0x803126,%rax
  80318e:	00 00 00 
  803191:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  803193:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803197:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80319b:	7e e5                	jle    803182 <close_all+0x11>
		close(i);
}
  80319d:	c9                   	leaveq 
  80319e:	c3                   	retq   

000000000080319f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80319f:	55                   	push   %rbp
  8031a0:	48 89 e5             	mov    %rsp,%rbp
  8031a3:	48 83 ec 40          	sub    $0x40,%rsp
  8031a7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8031aa:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8031ad:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8031b1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8031b4:	48 89 d6             	mov    %rdx,%rsi
  8031b7:	89 c7                	mov    %eax,%edi
  8031b9:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  8031c0:	00 00 00 
  8031c3:	ff d0                	callq  *%rax
  8031c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031cc:	79 08                	jns    8031d6 <dup+0x37>
		return r;
  8031ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d1:	e9 70 01 00 00       	jmpq   803346 <dup+0x1a7>
	close(newfdnum);
  8031d6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8031d9:	89 c7                	mov    %eax,%edi
  8031db:	48 b8 26 31 80 00 00 	movabs $0x803126,%rax
  8031e2:	00 00 00 
  8031e5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8031e7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8031ea:	48 98                	cltq   
  8031ec:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8031f2:	48 c1 e0 0c          	shl    $0xc,%rax
  8031f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8031fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031fe:	48 89 c7             	mov    %rax,%rdi
  803201:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  803208:	00 00 00 
  80320b:	ff d0                	callq  *%rax
  80320d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803215:	48 89 c7             	mov    %rax,%rdi
  803218:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  80321f:	00 00 00 
  803222:	ff d0                	callq  *%rax
  803224:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803228:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80322c:	48 89 c2             	mov    %rax,%rdx
  80322f:	48 c1 ea 15          	shr    $0x15,%rdx
  803233:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80323a:	01 00 00 
  80323d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803241:	83 e0 01             	and    $0x1,%eax
  803244:	84 c0                	test   %al,%al
  803246:	74 71                	je     8032b9 <dup+0x11a>
  803248:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80324c:	48 89 c2             	mov    %rax,%rdx
  80324f:	48 c1 ea 0c          	shr    $0xc,%rdx
  803253:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80325a:	01 00 00 
  80325d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803261:	83 e0 01             	and    $0x1,%eax
  803264:	84 c0                	test   %al,%al
  803266:	74 51                	je     8032b9 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803268:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80326c:	48 89 c2             	mov    %rax,%rdx
  80326f:	48 c1 ea 0c          	shr    $0xc,%rdx
  803273:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80327a:	01 00 00 
  80327d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803281:	89 c1                	mov    %eax,%ecx
  803283:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  803289:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80328d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803291:	41 89 c8             	mov    %ecx,%r8d
  803294:	48 89 d1             	mov    %rdx,%rcx
  803297:	ba 00 00 00 00       	mov    $0x0,%edx
  80329c:	48 89 c6             	mov    %rax,%rsi
  80329f:	bf 00 00 00 00       	mov    $0x0,%edi
  8032a4:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  8032ab:	00 00 00 
  8032ae:	ff d0                	callq  *%rax
  8032b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b7:	78 56                	js     80330f <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8032b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032bd:	48 89 c2             	mov    %rax,%rdx
  8032c0:	48 c1 ea 0c          	shr    $0xc,%rdx
  8032c4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8032cb:	01 00 00 
  8032ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032d2:	89 c1                	mov    %eax,%ecx
  8032d4:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8032da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032e2:	41 89 c8             	mov    %ecx,%r8d
  8032e5:	48 89 d1             	mov    %rdx,%rcx
  8032e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8032ed:	48 89 c6             	mov    %rax,%rsi
  8032f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f5:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  8032fc:	00 00 00 
  8032ff:	ff d0                	callq  *%rax
  803301:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803304:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803308:	78 08                	js     803312 <dup+0x173>
		goto err;

	return newfdnum;
  80330a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80330d:	eb 37                	jmp    803346 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80330f:	90                   	nop
  803310:	eb 01                	jmp    803313 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  803312:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  803313:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803317:	48 89 c6             	mov    %rax,%rsi
  80331a:	bf 00 00 00 00       	mov    $0x0,%edi
  80331f:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  803326:	00 00 00 
  803329:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80332b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80332f:	48 89 c6             	mov    %rax,%rsi
  803332:	bf 00 00 00 00       	mov    $0x0,%edi
  803337:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  80333e:	00 00 00 
  803341:	ff d0                	callq  *%rax
	return r;
  803343:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803346:	c9                   	leaveq 
  803347:	c3                   	retq   

0000000000803348 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803348:	55                   	push   %rbp
  803349:	48 89 e5             	mov    %rsp,%rbp
  80334c:	48 83 ec 40          	sub    $0x40,%rsp
  803350:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803353:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803357:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80335b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80335f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803362:	48 89 d6             	mov    %rdx,%rsi
  803365:	89 c7                	mov    %eax,%edi
  803367:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  80336e:	00 00 00 
  803371:	ff d0                	callq  *%rax
  803373:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803376:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80337a:	78 24                	js     8033a0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80337c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803380:	8b 00                	mov    (%rax),%eax
  803382:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803386:	48 89 d6             	mov    %rdx,%rsi
  803389:	89 c7                	mov    %eax,%edi
  80338b:	48 b8 6f 30 80 00 00 	movabs $0x80306f,%rax
  803392:	00 00 00 
  803395:	ff d0                	callq  *%rax
  803397:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80339a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80339e:	79 05                	jns    8033a5 <read+0x5d>
		return r;
  8033a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a3:	eb 7a                	jmp    80341f <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8033a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a9:	8b 40 08             	mov    0x8(%rax),%eax
  8033ac:	83 e0 03             	and    $0x3,%eax
  8033af:	83 f8 01             	cmp    $0x1,%eax
  8033b2:	75 3a                	jne    8033ee <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8033b4:	48 b8 70 80 80 00 00 	movabs $0x808070,%rax
  8033bb:	00 00 00 
  8033be:	48 8b 00             	mov    (%rax),%rax
  8033c1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8033c7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8033ca:	89 c6                	mov    %eax,%esi
  8033cc:	48 bf b7 5b 80 00 00 	movabs $0x805bb7,%rdi
  8033d3:	00 00 00 
  8033d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8033db:	48 b9 2f 0d 80 00 00 	movabs $0x800d2f,%rcx
  8033e2:	00 00 00 
  8033e5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8033e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8033ec:	eb 31                	jmp    80341f <read+0xd7>
	}
	if (!dev->dev_read)
  8033ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8033f6:	48 85 c0             	test   %rax,%rax
  8033f9:	75 07                	jne    803402 <read+0xba>
		return -E_NOT_SUPP;
  8033fb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803400:	eb 1d                	jmp    80341f <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  803402:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803406:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80340a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80340e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803412:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803416:	48 89 ce             	mov    %rcx,%rsi
  803419:	48 89 c7             	mov    %rax,%rdi
  80341c:	41 ff d0             	callq  *%r8
}
  80341f:	c9                   	leaveq 
  803420:	c3                   	retq   

0000000000803421 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803421:	55                   	push   %rbp
  803422:	48 89 e5             	mov    %rsp,%rbp
  803425:	48 83 ec 30          	sub    $0x30,%rsp
  803429:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80342c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803430:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803434:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80343b:	eb 46                	jmp    803483 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80343d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803440:	48 98                	cltq   
  803442:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803446:	48 29 c2             	sub    %rax,%rdx
  803449:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344c:	48 98                	cltq   
  80344e:	48 89 c1             	mov    %rax,%rcx
  803451:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  803455:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803458:	48 89 ce             	mov    %rcx,%rsi
  80345b:	89 c7                	mov    %eax,%edi
  80345d:	48 b8 48 33 80 00 00 	movabs $0x803348,%rax
  803464:	00 00 00 
  803467:	ff d0                	callq  *%rax
  803469:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80346c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803470:	79 05                	jns    803477 <readn+0x56>
			return m;
  803472:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803475:	eb 1d                	jmp    803494 <readn+0x73>
		if (m == 0)
  803477:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80347b:	74 13                	je     803490 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80347d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803480:	01 45 fc             	add    %eax,-0x4(%rbp)
  803483:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803486:	48 98                	cltq   
  803488:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80348c:	72 af                	jb     80343d <readn+0x1c>
  80348e:	eb 01                	jmp    803491 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  803490:	90                   	nop
	}
	return tot;
  803491:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803494:	c9                   	leaveq 
  803495:	c3                   	retq   

0000000000803496 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803496:	55                   	push   %rbp
  803497:	48 89 e5             	mov    %rsp,%rbp
  80349a:	48 83 ec 40          	sub    $0x40,%rsp
  80349e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8034a1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034a5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8034a9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8034ad:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034b0:	48 89 d6             	mov    %rdx,%rsi
  8034b3:	89 c7                	mov    %eax,%edi
  8034b5:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  8034bc:	00 00 00 
  8034bf:	ff d0                	callq  *%rax
  8034c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c8:	78 24                	js     8034ee <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8034ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ce:	8b 00                	mov    (%rax),%eax
  8034d0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034d4:	48 89 d6             	mov    %rdx,%rsi
  8034d7:	89 c7                	mov    %eax,%edi
  8034d9:	48 b8 6f 30 80 00 00 	movabs $0x80306f,%rax
  8034e0:	00 00 00 
  8034e3:	ff d0                	callq  *%rax
  8034e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034ec:	79 05                	jns    8034f3 <write+0x5d>
		return r;
  8034ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f1:	eb 79                	jmp    80356c <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8034f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f7:	8b 40 08             	mov    0x8(%rax),%eax
  8034fa:	83 e0 03             	and    $0x3,%eax
  8034fd:	85 c0                	test   %eax,%eax
  8034ff:	75 3a                	jne    80353b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803501:	48 b8 70 80 80 00 00 	movabs $0x808070,%rax
  803508:	00 00 00 
  80350b:	48 8b 00             	mov    (%rax),%rax
  80350e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803514:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803517:	89 c6                	mov    %eax,%esi
  803519:	48 bf d3 5b 80 00 00 	movabs $0x805bd3,%rdi
  803520:	00 00 00 
  803523:	b8 00 00 00 00       	mov    $0x0,%eax
  803528:	48 b9 2f 0d 80 00 00 	movabs $0x800d2f,%rcx
  80352f:	00 00 00 
  803532:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803534:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803539:	eb 31                	jmp    80356c <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80353b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80353f:	48 8b 40 18          	mov    0x18(%rax),%rax
  803543:	48 85 c0             	test   %rax,%rax
  803546:	75 07                	jne    80354f <write+0xb9>
		return -E_NOT_SUPP;
  803548:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80354d:	eb 1d                	jmp    80356c <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80354f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803553:	4c 8b 40 18          	mov    0x18(%rax),%r8
  803557:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80355b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80355f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803563:	48 89 ce             	mov    %rcx,%rsi
  803566:	48 89 c7             	mov    %rax,%rdi
  803569:	41 ff d0             	callq  *%r8
}
  80356c:	c9                   	leaveq 
  80356d:	c3                   	retq   

000000000080356e <seek>:

int
seek(int fdnum, off_t offset)
{
  80356e:	55                   	push   %rbp
  80356f:	48 89 e5             	mov    %rsp,%rbp
  803572:	48 83 ec 18          	sub    $0x18,%rsp
  803576:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803579:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80357c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803580:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803583:	48 89 d6             	mov    %rdx,%rsi
  803586:	89 c7                	mov    %eax,%edi
  803588:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  80358f:	00 00 00 
  803592:	ff d0                	callq  *%rax
  803594:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803597:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80359b:	79 05                	jns    8035a2 <seek+0x34>
		return r;
  80359d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a0:	eb 0f                	jmp    8035b1 <seek+0x43>
	fd->fd_offset = offset;
  8035a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035a9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8035ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035b1:	c9                   	leaveq 
  8035b2:	c3                   	retq   

00000000008035b3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8035b3:	55                   	push   %rbp
  8035b4:	48 89 e5             	mov    %rsp,%rbp
  8035b7:	48 83 ec 30          	sub    $0x30,%rsp
  8035bb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8035be:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8035c1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8035c5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035c8:	48 89 d6             	mov    %rdx,%rsi
  8035cb:	89 c7                	mov    %eax,%edi
  8035cd:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  8035d4:	00 00 00 
  8035d7:	ff d0                	callq  *%rax
  8035d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e0:	78 24                	js     803606 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8035e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e6:	8b 00                	mov    (%rax),%eax
  8035e8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8035ec:	48 89 d6             	mov    %rdx,%rsi
  8035ef:	89 c7                	mov    %eax,%edi
  8035f1:	48 b8 6f 30 80 00 00 	movabs $0x80306f,%rax
  8035f8:	00 00 00 
  8035fb:	ff d0                	callq  *%rax
  8035fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803600:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803604:	79 05                	jns    80360b <ftruncate+0x58>
		return r;
  803606:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803609:	eb 72                	jmp    80367d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80360b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80360f:	8b 40 08             	mov    0x8(%rax),%eax
  803612:	83 e0 03             	and    $0x3,%eax
  803615:	85 c0                	test   %eax,%eax
  803617:	75 3a                	jne    803653 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803619:	48 b8 70 80 80 00 00 	movabs $0x808070,%rax
  803620:	00 00 00 
  803623:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803626:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80362c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80362f:	89 c6                	mov    %eax,%esi
  803631:	48 bf f0 5b 80 00 00 	movabs $0x805bf0,%rdi
  803638:	00 00 00 
  80363b:	b8 00 00 00 00       	mov    $0x0,%eax
  803640:	48 b9 2f 0d 80 00 00 	movabs $0x800d2f,%rcx
  803647:	00 00 00 
  80364a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80364c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803651:	eb 2a                	jmp    80367d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803653:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803657:	48 8b 40 30          	mov    0x30(%rax),%rax
  80365b:	48 85 c0             	test   %rax,%rax
  80365e:	75 07                	jne    803667 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803660:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803665:	eb 16                	jmp    80367d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803667:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366b:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80366f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803673:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803676:	89 d6                	mov    %edx,%esi
  803678:	48 89 c7             	mov    %rax,%rdi
  80367b:	ff d1                	callq  *%rcx
}
  80367d:	c9                   	leaveq 
  80367e:	c3                   	retq   

000000000080367f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80367f:	55                   	push   %rbp
  803680:	48 89 e5             	mov    %rsp,%rbp
  803683:	48 83 ec 30          	sub    $0x30,%rsp
  803687:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80368a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80368e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803692:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803695:	48 89 d6             	mov    %rdx,%rsi
  803698:	89 c7                	mov    %eax,%edi
  80369a:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  8036a1:	00 00 00 
  8036a4:	ff d0                	callq  *%rax
  8036a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ad:	78 24                	js     8036d3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8036af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036b3:	8b 00                	mov    (%rax),%eax
  8036b5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8036b9:	48 89 d6             	mov    %rdx,%rsi
  8036bc:	89 c7                	mov    %eax,%edi
  8036be:	48 b8 6f 30 80 00 00 	movabs $0x80306f,%rax
  8036c5:	00 00 00 
  8036c8:	ff d0                	callq  *%rax
  8036ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036d1:	79 05                	jns    8036d8 <fstat+0x59>
		return r;
  8036d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d6:	eb 5e                	jmp    803736 <fstat+0xb7>
	if (!dev->dev_stat)
  8036d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036dc:	48 8b 40 28          	mov    0x28(%rax),%rax
  8036e0:	48 85 c0             	test   %rax,%rax
  8036e3:	75 07                	jne    8036ec <fstat+0x6d>
		return -E_NOT_SUPP;
  8036e5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8036ea:	eb 4a                	jmp    803736 <fstat+0xb7>
	stat->st_name[0] = 0;
  8036ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036f0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8036f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036f7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8036fe:	00 00 00 
	stat->st_isdir = 0;
  803701:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803705:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80370c:	00 00 00 
	stat->st_dev = dev;
  80370f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803713:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803717:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80371e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803722:	48 8b 48 28          	mov    0x28(%rax),%rcx
  803726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80372a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80372e:	48 89 d6             	mov    %rdx,%rsi
  803731:	48 89 c7             	mov    %rax,%rdi
  803734:	ff d1                	callq  *%rcx
}
  803736:	c9                   	leaveq 
  803737:	c3                   	retq   

0000000000803738 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803738:	55                   	push   %rbp
  803739:	48 89 e5             	mov    %rsp,%rbp
  80373c:	48 83 ec 20          	sub    $0x20,%rsp
  803740:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803744:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80374c:	be 00 00 00 00       	mov    $0x0,%esi
  803751:	48 89 c7             	mov    %rax,%rdi
  803754:	48 b8 27 38 80 00 00 	movabs $0x803827,%rax
  80375b:	00 00 00 
  80375e:	ff d0                	callq  *%rax
  803760:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803763:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803767:	79 05                	jns    80376e <stat+0x36>
		return fd;
  803769:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80376c:	eb 2f                	jmp    80379d <stat+0x65>
	r = fstat(fd, stat);
  80376e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803772:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803775:	48 89 d6             	mov    %rdx,%rsi
  803778:	89 c7                	mov    %eax,%edi
  80377a:	48 b8 7f 36 80 00 00 	movabs $0x80367f,%rax
  803781:	00 00 00 
  803784:	ff d0                	callq  *%rax
  803786:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803789:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80378c:	89 c7                	mov    %eax,%edi
  80378e:	48 b8 26 31 80 00 00 	movabs $0x803126,%rax
  803795:	00 00 00 
  803798:	ff d0                	callq  *%rax
	return r;
  80379a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80379d:	c9                   	leaveq 
  80379e:	c3                   	retq   
	...

00000000008037a0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8037a0:	55                   	push   %rbp
  8037a1:	48 89 e5             	mov    %rsp,%rbp
  8037a4:	48 83 ec 10          	sub    $0x10,%rsp
  8037a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8037af:	48 b8 3c 80 80 00 00 	movabs $0x80803c,%rax
  8037b6:	00 00 00 
  8037b9:	8b 00                	mov    (%rax),%eax
  8037bb:	85 c0                	test   %eax,%eax
  8037bd:	75 1d                	jne    8037dc <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8037bf:	bf 01 00 00 00       	mov    $0x1,%edi
  8037c4:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  8037cb:	00 00 00 
  8037ce:	ff d0                	callq  *%rax
  8037d0:	48 ba 3c 80 80 00 00 	movabs $0x80803c,%rdx
  8037d7:	00 00 00 
  8037da:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8037dc:	48 b8 3c 80 80 00 00 	movabs $0x80803c,%rax
  8037e3:	00 00 00 
  8037e6:	8b 00                	mov    (%rax),%eax
  8037e8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8037eb:	b9 07 00 00 00       	mov    $0x7,%ecx
  8037f0:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8037f7:	00 00 00 
  8037fa:	89 c7                	mov    %eax,%edi
  8037fc:	48 b8 e8 2c 80 00 00 	movabs $0x802ce8,%rax
  803803:	00 00 00 
  803806:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803808:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80380c:	ba 00 00 00 00       	mov    $0x0,%edx
  803811:	48 89 c6             	mov    %rax,%rsi
  803814:	bf 00 00 00 00       	mov    $0x0,%edi
  803819:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  803820:	00 00 00 
  803823:	ff d0                	callq  *%rax
}
  803825:	c9                   	leaveq 
  803826:	c3                   	retq   

0000000000803827 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803827:	55                   	push   %rbp
  803828:	48 89 e5             	mov    %rsp,%rbp
  80382b:	48 83 ec 20          	sub    $0x20,%rsp
  80382f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803833:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  803836:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80383a:	48 89 c7             	mov    %rax,%rdi
  80383d:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  803844:	00 00 00 
  803847:	ff d0                	callq  *%rax
  803849:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80384e:	7e 0a                	jle    80385a <open+0x33>
                return -E_BAD_PATH;
  803850:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803855:	e9 a5 00 00 00       	jmpq   8038ff <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  80385a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80385e:	48 89 c7             	mov    %rax,%rdi
  803861:	48 b8 7e 2e 80 00 00 	movabs $0x802e7e,%rax
  803868:	00 00 00 
  80386b:	ff d0                	callq  *%rax
  80386d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803870:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803874:	79 08                	jns    80387e <open+0x57>
		return r;
  803876:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803879:	e9 81 00 00 00       	jmpq   8038ff <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  80387e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803882:	48 89 c6             	mov    %rax,%rsi
  803885:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80388c:	00 00 00 
  80388f:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  803896:	00 00 00 
  803899:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  80389b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8038a2:	00 00 00 
  8038a5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8038a8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  8038ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b2:	48 89 c6             	mov    %rax,%rsi
  8038b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8038ba:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  8038c1:	00 00 00 
  8038c4:	ff d0                	callq  *%rax
  8038c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  8038c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038cd:	79 1d                	jns    8038ec <open+0xc5>
	{
		fd_close(fd,0);
  8038cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d3:	be 00 00 00 00       	mov    $0x0,%esi
  8038d8:	48 89 c7             	mov    %rax,%rdi
  8038db:	48 b8 a6 2f 80 00 00 	movabs $0x802fa6,%rax
  8038e2:	00 00 00 
  8038e5:	ff d0                	callq  *%rax
		return r;
  8038e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ea:	eb 13                	jmp    8038ff <open+0xd8>
	}
	return fd2num(fd);
  8038ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f0:	48 89 c7             	mov    %rax,%rdi
  8038f3:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  8038fa:	00 00 00 
  8038fd:	ff d0                	callq  *%rax
	


}
  8038ff:	c9                   	leaveq 
  803900:	c3                   	retq   

0000000000803901 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803901:	55                   	push   %rbp
  803902:	48 89 e5             	mov    %rsp,%rbp
  803905:	48 83 ec 10          	sub    $0x10,%rsp
  803909:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80390d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803911:	8b 50 0c             	mov    0xc(%rax),%edx
  803914:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80391b:	00 00 00 
  80391e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803920:	be 00 00 00 00       	mov    $0x0,%esi
  803925:	bf 06 00 00 00       	mov    $0x6,%edi
  80392a:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  803931:	00 00 00 
  803934:	ff d0                	callq  *%rax
}
  803936:	c9                   	leaveq 
  803937:	c3                   	retq   

0000000000803938 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803938:	55                   	push   %rbp
  803939:	48 89 e5             	mov    %rsp,%rbp
  80393c:	48 83 ec 30          	sub    $0x30,%rsp
  803940:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803944:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803948:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80394c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803950:	8b 50 0c             	mov    0xc(%rax),%edx
  803953:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80395a:	00 00 00 
  80395d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80395f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803966:	00 00 00 
  803969:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80396d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803971:	be 00 00 00 00       	mov    $0x0,%esi
  803976:	bf 03 00 00 00       	mov    $0x3,%edi
  80397b:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  803982:	00 00 00 
  803985:	ff d0                	callq  *%rax
  803987:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80398a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80398e:	79 05                	jns    803995 <devfile_read+0x5d>
	{
		return r;
  803990:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803993:	eb 2c                	jmp    8039c1 <devfile_read+0x89>
	}
	if(r > 0)
  803995:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803999:	7e 23                	jle    8039be <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  80399b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80399e:	48 63 d0             	movslq %eax,%rdx
  8039a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039a5:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8039ac:	00 00 00 
  8039af:	48 89 c7             	mov    %rax,%rdi
  8039b2:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  8039b9:	00 00 00 
  8039bc:	ff d0                	callq  *%rax
	return r;
  8039be:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8039c1:	c9                   	leaveq 
  8039c2:	c3                   	retq   

00000000008039c3 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8039c3:	55                   	push   %rbp
  8039c4:	48 89 e5             	mov    %rsp,%rbp
  8039c7:	48 83 ec 30          	sub    $0x30,%rsp
  8039cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039d3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  8039d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039db:	8b 50 0c             	mov    0xc(%rax),%edx
  8039de:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8039e5:	00 00 00 
  8039e8:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  8039ea:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8039f1:	00 
  8039f2:	76 08                	jbe    8039fc <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8039f4:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8039fb:	00 
	fsipcbuf.write.req_n=n;
  8039fc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803a03:	00 00 00 
  803a06:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a0a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803a0e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a16:	48 89 c6             	mov    %rax,%rsi
  803a19:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803a20:	00 00 00 
  803a23:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  803a2a:	00 00 00 
  803a2d:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  803a2f:	be 00 00 00 00       	mov    $0x0,%esi
  803a34:	bf 04 00 00 00       	mov    $0x4,%edi
  803a39:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  803a40:	00 00 00 
  803a43:	ff d0                	callq  *%rax
  803a45:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  803a48:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a4b:	c9                   	leaveq 
  803a4c:	c3                   	retq   

0000000000803a4d <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  803a4d:	55                   	push   %rbp
  803a4e:	48 89 e5             	mov    %rsp,%rbp
  803a51:	48 83 ec 10          	sub    $0x10,%rsp
  803a55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a59:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803a5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a60:	8b 50 0c             	mov    0xc(%rax),%edx
  803a63:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803a6a:	00 00 00 
  803a6d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  803a6f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803a76:	00 00 00 
  803a79:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803a7c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803a7f:	be 00 00 00 00       	mov    $0x0,%esi
  803a84:	bf 02 00 00 00       	mov    $0x2,%edi
  803a89:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  803a90:	00 00 00 
  803a93:	ff d0                	callq  *%rax
}
  803a95:	c9                   	leaveq 
  803a96:	c3                   	retq   

0000000000803a97 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803a97:	55                   	push   %rbp
  803a98:	48 89 e5             	mov    %rsp,%rbp
  803a9b:	48 83 ec 20          	sub    $0x20,%rsp
  803a9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803aa3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803aa7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aab:	8b 50 0c             	mov    0xc(%rax),%edx
  803aae:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803ab5:	00 00 00 
  803ab8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803aba:	be 00 00 00 00       	mov    $0x0,%esi
  803abf:	bf 05 00 00 00       	mov    $0x5,%edi
  803ac4:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  803acb:	00 00 00 
  803ace:	ff d0                	callq  *%rax
  803ad0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ad3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad7:	79 05                	jns    803ade <devfile_stat+0x47>
		return r;
  803ad9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803adc:	eb 56                	jmp    803b34 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803ade:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ae2:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803ae9:	00 00 00 
  803aec:	48 89 c7             	mov    %rax,%rdi
  803aef:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  803af6:	00 00 00 
  803af9:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803afb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803b02:	00 00 00 
  803b05:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803b0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b0f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803b15:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803b1c:	00 00 00 
  803b1f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803b25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b29:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803b2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b34:	c9                   	leaveq 
  803b35:	c3                   	retq   
	...

0000000000803b38 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803b38:	55                   	push   %rbp
  803b39:	48 89 e5             	mov    %rsp,%rbp
  803b3c:	48 83 ec 20          	sub    $0x20,%rsp
  803b40:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803b43:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b47:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b4a:	48 89 d6             	mov    %rdx,%rsi
  803b4d:	89 c7                	mov    %eax,%edi
  803b4f:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  803b56:	00 00 00 
  803b59:	ff d0                	callq  *%rax
  803b5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b62:	79 05                	jns    803b69 <fd2sockid+0x31>
		return r;
  803b64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b67:	eb 24                	jmp    803b8d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803b69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6d:	8b 10                	mov    (%rax),%edx
  803b6f:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803b76:	00 00 00 
  803b79:	8b 00                	mov    (%rax),%eax
  803b7b:	39 c2                	cmp    %eax,%edx
  803b7d:	74 07                	je     803b86 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803b7f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803b84:	eb 07                	jmp    803b8d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803b86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803b8d:	c9                   	leaveq 
  803b8e:	c3                   	retq   

0000000000803b8f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803b8f:	55                   	push   %rbp
  803b90:	48 89 e5             	mov    %rsp,%rbp
  803b93:	48 83 ec 20          	sub    $0x20,%rsp
  803b97:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803b9a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b9e:	48 89 c7             	mov    %rax,%rdi
  803ba1:	48 b8 7e 2e 80 00 00 	movabs $0x802e7e,%rax
  803ba8:	00 00 00 
  803bab:	ff d0                	callq  *%rax
  803bad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bb4:	78 26                	js     803bdc <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803bb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bba:	ba 07 04 00 00       	mov    $0x407,%edx
  803bbf:	48 89 c6             	mov    %rax,%rsi
  803bc2:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc7:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  803bce:	00 00 00 
  803bd1:	ff d0                	callq  *%rax
  803bd3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bda:	79 16                	jns    803bf2 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803bdc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bdf:	89 c7                	mov    %eax,%edi
  803be1:	48 b8 9c 40 80 00 00 	movabs $0x80409c,%rax
  803be8:	00 00 00 
  803beb:	ff d0                	callq  *%rax
		return r;
  803bed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf0:	eb 3a                	jmp    803c2c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803bf2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf6:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803bfd:	00 00 00 
  803c00:	8b 12                	mov    (%rdx),%edx
  803c02:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803c04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c08:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803c0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c13:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c16:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803c19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c1d:	48 89 c7             	mov    %rax,%rdi
  803c20:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  803c27:	00 00 00 
  803c2a:	ff d0                	callq  *%rax
}
  803c2c:	c9                   	leaveq 
  803c2d:	c3                   	retq   

0000000000803c2e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803c2e:	55                   	push   %rbp
  803c2f:	48 89 e5             	mov    %rsp,%rbp
  803c32:	48 83 ec 30          	sub    $0x30,%rsp
  803c36:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c39:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c3d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c41:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c44:	89 c7                	mov    %eax,%edi
  803c46:	48 b8 38 3b 80 00 00 	movabs $0x803b38,%rax
  803c4d:	00 00 00 
  803c50:	ff d0                	callq  *%rax
  803c52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c59:	79 05                	jns    803c60 <accept+0x32>
		return r;
  803c5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c5e:	eb 3b                	jmp    803c9b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803c60:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803c64:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803c68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6b:	48 89 ce             	mov    %rcx,%rsi
  803c6e:	89 c7                	mov    %eax,%edi
  803c70:	48 b8 79 3f 80 00 00 	movabs $0x803f79,%rax
  803c77:	00 00 00 
  803c7a:	ff d0                	callq  *%rax
  803c7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c83:	79 05                	jns    803c8a <accept+0x5c>
		return r;
  803c85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c88:	eb 11                	jmp    803c9b <accept+0x6d>
	return alloc_sockfd(r);
  803c8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c8d:	89 c7                	mov    %eax,%edi
  803c8f:	48 b8 8f 3b 80 00 00 	movabs $0x803b8f,%rax
  803c96:	00 00 00 
  803c99:	ff d0                	callq  *%rax
}
  803c9b:	c9                   	leaveq 
  803c9c:	c3                   	retq   

0000000000803c9d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c9d:	55                   	push   %rbp
  803c9e:	48 89 e5             	mov    %rsp,%rbp
  803ca1:	48 83 ec 20          	sub    $0x20,%rsp
  803ca5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ca8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cac:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803caf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cb2:	89 c7                	mov    %eax,%edi
  803cb4:	48 b8 38 3b 80 00 00 	movabs $0x803b38,%rax
  803cbb:	00 00 00 
  803cbe:	ff d0                	callq  *%rax
  803cc0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cc3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cc7:	79 05                	jns    803cce <bind+0x31>
		return r;
  803cc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ccc:	eb 1b                	jmp    803ce9 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803cce:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803cd1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803cd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd8:	48 89 ce             	mov    %rcx,%rsi
  803cdb:	89 c7                	mov    %eax,%edi
  803cdd:	48 b8 f8 3f 80 00 00 	movabs $0x803ff8,%rax
  803ce4:	00 00 00 
  803ce7:	ff d0                	callq  *%rax
}
  803ce9:	c9                   	leaveq 
  803cea:	c3                   	retq   

0000000000803ceb <shutdown>:

int
shutdown(int s, int how)
{
  803ceb:	55                   	push   %rbp
  803cec:	48 89 e5             	mov    %rsp,%rbp
  803cef:	48 83 ec 20          	sub    $0x20,%rsp
  803cf3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cf6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803cf9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cfc:	89 c7                	mov    %eax,%edi
  803cfe:	48 b8 38 3b 80 00 00 	movabs $0x803b38,%rax
  803d05:	00 00 00 
  803d08:	ff d0                	callq  *%rax
  803d0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d11:	79 05                	jns    803d18 <shutdown+0x2d>
		return r;
  803d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d16:	eb 16                	jmp    803d2e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803d18:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d1e:	89 d6                	mov    %edx,%esi
  803d20:	89 c7                	mov    %eax,%edi
  803d22:	48 b8 5c 40 80 00 00 	movabs $0x80405c,%rax
  803d29:	00 00 00 
  803d2c:	ff d0                	callq  *%rax
}
  803d2e:	c9                   	leaveq 
  803d2f:	c3                   	retq   

0000000000803d30 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803d30:	55                   	push   %rbp
  803d31:	48 89 e5             	mov    %rsp,%rbp
  803d34:	48 83 ec 10          	sub    $0x10,%rsp
  803d38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803d3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d40:	48 89 c7             	mov    %rax,%rdi
  803d43:	48 b8 10 4d 80 00 00 	movabs $0x804d10,%rax
  803d4a:	00 00 00 
  803d4d:	ff d0                	callq  *%rax
  803d4f:	83 f8 01             	cmp    $0x1,%eax
  803d52:	75 17                	jne    803d6b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803d54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d58:	8b 40 0c             	mov    0xc(%rax),%eax
  803d5b:	89 c7                	mov    %eax,%edi
  803d5d:	48 b8 9c 40 80 00 00 	movabs $0x80409c,%rax
  803d64:	00 00 00 
  803d67:	ff d0                	callq  *%rax
  803d69:	eb 05                	jmp    803d70 <devsock_close+0x40>
	else
		return 0;
  803d6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d70:	c9                   	leaveq 
  803d71:	c3                   	retq   

0000000000803d72 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803d72:	55                   	push   %rbp
  803d73:	48 89 e5             	mov    %rsp,%rbp
  803d76:	48 83 ec 20          	sub    $0x20,%rsp
  803d7a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d7d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d81:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d84:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d87:	89 c7                	mov    %eax,%edi
  803d89:	48 b8 38 3b 80 00 00 	movabs $0x803b38,%rax
  803d90:	00 00 00 
  803d93:	ff d0                	callq  *%rax
  803d95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d9c:	79 05                	jns    803da3 <connect+0x31>
		return r;
  803d9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da1:	eb 1b                	jmp    803dbe <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803da3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803da6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803daa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dad:	48 89 ce             	mov    %rcx,%rsi
  803db0:	89 c7                	mov    %eax,%edi
  803db2:	48 b8 c9 40 80 00 00 	movabs $0x8040c9,%rax
  803db9:	00 00 00 
  803dbc:	ff d0                	callq  *%rax
}
  803dbe:	c9                   	leaveq 
  803dbf:	c3                   	retq   

0000000000803dc0 <listen>:

int
listen(int s, int backlog)
{
  803dc0:	55                   	push   %rbp
  803dc1:	48 89 e5             	mov    %rsp,%rbp
  803dc4:	48 83 ec 20          	sub    $0x20,%rsp
  803dc8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803dcb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803dce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dd1:	89 c7                	mov    %eax,%edi
  803dd3:	48 b8 38 3b 80 00 00 	movabs $0x803b38,%rax
  803dda:	00 00 00 
  803ddd:	ff d0                	callq  *%rax
  803ddf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803de2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803de6:	79 05                	jns    803ded <listen+0x2d>
		return r;
  803de8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803deb:	eb 16                	jmp    803e03 <listen+0x43>
	return nsipc_listen(r, backlog);
  803ded:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803df0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df3:	89 d6                	mov    %edx,%esi
  803df5:	89 c7                	mov    %eax,%edi
  803df7:	48 b8 2d 41 80 00 00 	movabs $0x80412d,%rax
  803dfe:	00 00 00 
  803e01:	ff d0                	callq  *%rax
}
  803e03:	c9                   	leaveq 
  803e04:	c3                   	retq   

0000000000803e05 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803e05:	55                   	push   %rbp
  803e06:	48 89 e5             	mov    %rsp,%rbp
  803e09:	48 83 ec 20          	sub    $0x20,%rsp
  803e0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e15:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803e19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e1d:	89 c2                	mov    %eax,%edx
  803e1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e23:	8b 40 0c             	mov    0xc(%rax),%eax
  803e26:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803e2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  803e2f:	89 c7                	mov    %eax,%edi
  803e31:	48 b8 6d 41 80 00 00 	movabs $0x80416d,%rax
  803e38:	00 00 00 
  803e3b:	ff d0                	callq  *%rax
}
  803e3d:	c9                   	leaveq 
  803e3e:	c3                   	retq   

0000000000803e3f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803e3f:	55                   	push   %rbp
  803e40:	48 89 e5             	mov    %rsp,%rbp
  803e43:	48 83 ec 20          	sub    $0x20,%rsp
  803e47:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e4f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803e53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e57:	89 c2                	mov    %eax,%edx
  803e59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e5d:	8b 40 0c             	mov    0xc(%rax),%eax
  803e60:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803e64:	b9 00 00 00 00       	mov    $0x0,%ecx
  803e69:	89 c7                	mov    %eax,%edi
  803e6b:	48 b8 39 42 80 00 00 	movabs $0x804239,%rax
  803e72:	00 00 00 
  803e75:	ff d0                	callq  *%rax
}
  803e77:	c9                   	leaveq 
  803e78:	c3                   	retq   

0000000000803e79 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803e79:	55                   	push   %rbp
  803e7a:	48 89 e5             	mov    %rsp,%rbp
  803e7d:	48 83 ec 10          	sub    $0x10,%rsp
  803e81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803e89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e8d:	48 be 1b 5c 80 00 00 	movabs $0x805c1b,%rsi
  803e94:	00 00 00 
  803e97:	48 89 c7             	mov    %rax,%rdi
  803e9a:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  803ea1:	00 00 00 
  803ea4:	ff d0                	callq  *%rax
	return 0;
  803ea6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803eab:	c9                   	leaveq 
  803eac:	c3                   	retq   

0000000000803ead <socket>:

int
socket(int domain, int type, int protocol)
{
  803ead:	55                   	push   %rbp
  803eae:	48 89 e5             	mov    %rsp,%rbp
  803eb1:	48 83 ec 20          	sub    $0x20,%rsp
  803eb5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803eb8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ebb:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803ebe:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803ec1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803ec4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ec7:	89 ce                	mov    %ecx,%esi
  803ec9:	89 c7                	mov    %eax,%edi
  803ecb:	48 b8 f1 42 80 00 00 	movabs $0x8042f1,%rax
  803ed2:	00 00 00 
  803ed5:	ff d0                	callq  *%rax
  803ed7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ede:	79 05                	jns    803ee5 <socket+0x38>
		return r;
  803ee0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ee3:	eb 11                	jmp    803ef6 <socket+0x49>
	return alloc_sockfd(r);
  803ee5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ee8:	89 c7                	mov    %eax,%edi
  803eea:	48 b8 8f 3b 80 00 00 	movabs $0x803b8f,%rax
  803ef1:	00 00 00 
  803ef4:	ff d0                	callq  *%rax
}
  803ef6:	c9                   	leaveq 
  803ef7:	c3                   	retq   

0000000000803ef8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803ef8:	55                   	push   %rbp
  803ef9:	48 89 e5             	mov    %rsp,%rbp
  803efc:	48 83 ec 10          	sub    $0x10,%rsp
  803f00:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803f03:	48 b8 48 80 80 00 00 	movabs $0x808048,%rax
  803f0a:	00 00 00 
  803f0d:	8b 00                	mov    (%rax),%eax
  803f0f:	85 c0                	test   %eax,%eax
  803f11:	75 1d                	jne    803f30 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803f13:	bf 02 00 00 00       	mov    $0x2,%edi
  803f18:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  803f1f:	00 00 00 
  803f22:	ff d0                	callq  *%rax
  803f24:	48 ba 48 80 80 00 00 	movabs $0x808048,%rdx
  803f2b:	00 00 00 
  803f2e:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803f30:	48 b8 48 80 80 00 00 	movabs $0x808048,%rax
  803f37:	00 00 00 
  803f3a:	8b 00                	mov    (%rax),%eax
  803f3c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803f3f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803f44:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803f4b:	00 00 00 
  803f4e:	89 c7                	mov    %eax,%edi
  803f50:	48 b8 e8 2c 80 00 00 	movabs $0x802ce8,%rax
  803f57:	00 00 00 
  803f5a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803f5c:	ba 00 00 00 00       	mov    $0x0,%edx
  803f61:	be 00 00 00 00       	mov    $0x0,%esi
  803f66:	bf 00 00 00 00       	mov    $0x0,%edi
  803f6b:	48 b8 28 2c 80 00 00 	movabs $0x802c28,%rax
  803f72:	00 00 00 
  803f75:	ff d0                	callq  *%rax
}
  803f77:	c9                   	leaveq 
  803f78:	c3                   	retq   

0000000000803f79 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803f79:	55                   	push   %rbp
  803f7a:	48 89 e5             	mov    %rsp,%rbp
  803f7d:	48 83 ec 30          	sub    $0x30,%rsp
  803f81:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f88:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803f8c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f93:	00 00 00 
  803f96:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f99:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803f9b:	bf 01 00 00 00       	mov    $0x1,%edi
  803fa0:	48 b8 f8 3e 80 00 00 	movabs $0x803ef8,%rax
  803fa7:	00 00 00 
  803faa:	ff d0                	callq  *%rax
  803fac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803faf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fb3:	78 3e                	js     803ff3 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803fb5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fbc:	00 00 00 
  803fbf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803fc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc7:	8b 40 10             	mov    0x10(%rax),%eax
  803fca:	89 c2                	mov    %eax,%edx
  803fcc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803fd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fd4:	48 89 ce             	mov    %rcx,%rsi
  803fd7:	48 89 c7             	mov    %rax,%rdi
  803fda:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  803fe1:	00 00 00 
  803fe4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803fe6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fea:	8b 50 10             	mov    0x10(%rax),%edx
  803fed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ff1:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803ff3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ff6:	c9                   	leaveq 
  803ff7:	c3                   	retq   

0000000000803ff8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803ff8:	55                   	push   %rbp
  803ff9:	48 89 e5             	mov    %rsp,%rbp
  803ffc:	48 83 ec 10          	sub    $0x10,%rsp
  804000:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804003:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804007:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80400a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804011:	00 00 00 
  804014:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804017:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804019:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80401c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804020:	48 89 c6             	mov    %rax,%rsi
  804023:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80402a:	00 00 00 
  80402d:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  804034:	00 00 00 
  804037:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804039:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804040:	00 00 00 
  804043:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804046:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804049:	bf 02 00 00 00       	mov    $0x2,%edi
  80404e:	48 b8 f8 3e 80 00 00 	movabs $0x803ef8,%rax
  804055:	00 00 00 
  804058:	ff d0                	callq  *%rax
}
  80405a:	c9                   	leaveq 
  80405b:	c3                   	retq   

000000000080405c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80405c:	55                   	push   %rbp
  80405d:	48 89 e5             	mov    %rsp,%rbp
  804060:	48 83 ec 10          	sub    $0x10,%rsp
  804064:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804067:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80406a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804071:	00 00 00 
  804074:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804077:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804079:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804080:	00 00 00 
  804083:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804086:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804089:	bf 03 00 00 00       	mov    $0x3,%edi
  80408e:	48 b8 f8 3e 80 00 00 	movabs $0x803ef8,%rax
  804095:	00 00 00 
  804098:	ff d0                	callq  *%rax
}
  80409a:	c9                   	leaveq 
  80409b:	c3                   	retq   

000000000080409c <nsipc_close>:

int
nsipc_close(int s)
{
  80409c:	55                   	push   %rbp
  80409d:	48 89 e5             	mov    %rsp,%rbp
  8040a0:	48 83 ec 10          	sub    $0x10,%rsp
  8040a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8040a7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040ae:	00 00 00 
  8040b1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8040b4:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8040b6:	bf 04 00 00 00       	mov    $0x4,%edi
  8040bb:	48 b8 f8 3e 80 00 00 	movabs $0x803ef8,%rax
  8040c2:	00 00 00 
  8040c5:	ff d0                	callq  *%rax
}
  8040c7:	c9                   	leaveq 
  8040c8:	c3                   	retq   

00000000008040c9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8040c9:	55                   	push   %rbp
  8040ca:	48 89 e5             	mov    %rsp,%rbp
  8040cd:	48 83 ec 10          	sub    $0x10,%rsp
  8040d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8040d8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8040db:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040e2:	00 00 00 
  8040e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8040e8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8040ea:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f1:	48 89 c6             	mov    %rax,%rsi
  8040f4:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8040fb:	00 00 00 
  8040fe:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  804105:	00 00 00 
  804108:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80410a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804111:	00 00 00 
  804114:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804117:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80411a:	bf 05 00 00 00       	mov    $0x5,%edi
  80411f:	48 b8 f8 3e 80 00 00 	movabs $0x803ef8,%rax
  804126:	00 00 00 
  804129:	ff d0                	callq  *%rax
}
  80412b:	c9                   	leaveq 
  80412c:	c3                   	retq   

000000000080412d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80412d:	55                   	push   %rbp
  80412e:	48 89 e5             	mov    %rsp,%rbp
  804131:	48 83 ec 10          	sub    $0x10,%rsp
  804135:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804138:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80413b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804142:	00 00 00 
  804145:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804148:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80414a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804151:	00 00 00 
  804154:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804157:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80415a:	bf 06 00 00 00       	mov    $0x6,%edi
  80415f:	48 b8 f8 3e 80 00 00 	movabs $0x803ef8,%rax
  804166:	00 00 00 
  804169:	ff d0                	callq  *%rax
}
  80416b:	c9                   	leaveq 
  80416c:	c3                   	retq   

000000000080416d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80416d:	55                   	push   %rbp
  80416e:	48 89 e5             	mov    %rsp,%rbp
  804171:	48 83 ec 30          	sub    $0x30,%rsp
  804175:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804178:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80417c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80417f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804182:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804189:	00 00 00 
  80418c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80418f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804191:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804198:	00 00 00 
  80419b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80419e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8041a1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041a8:	00 00 00 
  8041ab:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8041ae:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8041b1:	bf 07 00 00 00       	mov    $0x7,%edi
  8041b6:	48 b8 f8 3e 80 00 00 	movabs $0x803ef8,%rax
  8041bd:	00 00 00 
  8041c0:	ff d0                	callq  *%rax
  8041c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041c9:	78 69                	js     804234 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8041cb:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8041d2:	7f 08                	jg     8041dc <nsipc_recv+0x6f>
  8041d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d7:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8041da:	7e 35                	jle    804211 <nsipc_recv+0xa4>
  8041dc:	48 b9 22 5c 80 00 00 	movabs $0x805c22,%rcx
  8041e3:	00 00 00 
  8041e6:	48 ba 37 5c 80 00 00 	movabs $0x805c37,%rdx
  8041ed:	00 00 00 
  8041f0:	be 61 00 00 00       	mov    $0x61,%esi
  8041f5:	48 bf 4c 5c 80 00 00 	movabs $0x805c4c,%rdi
  8041fc:	00 00 00 
  8041ff:	b8 00 00 00 00       	mov    $0x0,%eax
  804204:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  80420b:	00 00 00 
  80420e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804214:	48 63 d0             	movslq %eax,%rdx
  804217:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80421b:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804222:	00 00 00 
  804225:	48 89 c7             	mov    %rax,%rdi
  804228:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  80422f:	00 00 00 
  804232:	ff d0                	callq  *%rax
	}

	return r;
  804234:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804237:	c9                   	leaveq 
  804238:	c3                   	retq   

0000000000804239 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804239:	55                   	push   %rbp
  80423a:	48 89 e5             	mov    %rsp,%rbp
  80423d:	48 83 ec 20          	sub    $0x20,%rsp
  804241:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804244:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804248:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80424b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80424e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804255:	00 00 00 
  804258:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80425b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80425d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804264:	7e 35                	jle    80429b <nsipc_send+0x62>
  804266:	48 b9 58 5c 80 00 00 	movabs $0x805c58,%rcx
  80426d:	00 00 00 
  804270:	48 ba 37 5c 80 00 00 	movabs $0x805c37,%rdx
  804277:	00 00 00 
  80427a:	be 6c 00 00 00       	mov    $0x6c,%esi
  80427f:	48 bf 4c 5c 80 00 00 	movabs $0x805c4c,%rdi
  804286:	00 00 00 
  804289:	b8 00 00 00 00       	mov    $0x0,%eax
  80428e:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  804295:	00 00 00 
  804298:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80429b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80429e:	48 63 d0             	movslq %eax,%rdx
  8042a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042a5:	48 89 c6             	mov    %rax,%rsi
  8042a8:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  8042af:	00 00 00 
  8042b2:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  8042b9:	00 00 00 
  8042bc:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8042be:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042c5:	00 00 00 
  8042c8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8042cb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8042ce:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042d5:	00 00 00 
  8042d8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8042db:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8042de:	bf 08 00 00 00       	mov    $0x8,%edi
  8042e3:	48 b8 f8 3e 80 00 00 	movabs $0x803ef8,%rax
  8042ea:	00 00 00 
  8042ed:	ff d0                	callq  *%rax
}
  8042ef:	c9                   	leaveq 
  8042f0:	c3                   	retq   

00000000008042f1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8042f1:	55                   	push   %rbp
  8042f2:	48 89 e5             	mov    %rsp,%rbp
  8042f5:	48 83 ec 10          	sub    $0x10,%rsp
  8042f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8042fc:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8042ff:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804302:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804309:	00 00 00 
  80430c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80430f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804311:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804318:	00 00 00 
  80431b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80431e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804321:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804328:	00 00 00 
  80432b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80432e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804331:	bf 09 00 00 00       	mov    $0x9,%edi
  804336:	48 b8 f8 3e 80 00 00 	movabs $0x803ef8,%rax
  80433d:	00 00 00 
  804340:	ff d0                	callq  *%rax
}
  804342:	c9                   	leaveq 
  804343:	c3                   	retq   

0000000000804344 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804344:	55                   	push   %rbp
  804345:	48 89 e5             	mov    %rsp,%rbp
  804348:	53                   	push   %rbx
  804349:	48 83 ec 38          	sub    $0x38,%rsp
  80434d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804351:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804355:	48 89 c7             	mov    %rax,%rdi
  804358:	48 b8 7e 2e 80 00 00 	movabs $0x802e7e,%rax
  80435f:	00 00 00 
  804362:	ff d0                	callq  *%rax
  804364:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804367:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80436b:	0f 88 bf 01 00 00    	js     804530 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804371:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804375:	ba 07 04 00 00       	mov    $0x407,%edx
  80437a:	48 89 c6             	mov    %rax,%rsi
  80437d:	bf 00 00 00 00       	mov    $0x0,%edi
  804382:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  804389:	00 00 00 
  80438c:	ff d0                	callq  *%rax
  80438e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804391:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804395:	0f 88 95 01 00 00    	js     804530 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80439b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80439f:	48 89 c7             	mov    %rax,%rdi
  8043a2:	48 b8 7e 2e 80 00 00 	movabs $0x802e7e,%rax
  8043a9:	00 00 00 
  8043ac:	ff d0                	callq  *%rax
  8043ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043b5:	0f 88 5d 01 00 00    	js     804518 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043bf:	ba 07 04 00 00       	mov    $0x407,%edx
  8043c4:	48 89 c6             	mov    %rax,%rsi
  8043c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8043cc:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  8043d3:	00 00 00 
  8043d6:	ff d0                	callq  *%rax
  8043d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043db:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043df:	0f 88 33 01 00 00    	js     804518 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8043e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043e9:	48 89 c7             	mov    %rax,%rdi
  8043ec:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  8043f3:	00 00 00 
  8043f6:	ff d0                	callq  *%rax
  8043f8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804400:	ba 07 04 00 00       	mov    $0x407,%edx
  804405:	48 89 c6             	mov    %rax,%rsi
  804408:	bf 00 00 00 00       	mov    $0x0,%edi
  80440d:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  804414:	00 00 00 
  804417:	ff d0                	callq  *%rax
  804419:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80441c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804420:	0f 88 d9 00 00 00    	js     8044ff <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804426:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80442a:	48 89 c7             	mov    %rax,%rdi
  80442d:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  804434:	00 00 00 
  804437:	ff d0                	callq  *%rax
  804439:	48 89 c2             	mov    %rax,%rdx
  80443c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804440:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804446:	48 89 d1             	mov    %rdx,%rcx
  804449:	ba 00 00 00 00       	mov    $0x0,%edx
  80444e:	48 89 c6             	mov    %rax,%rsi
  804451:	bf 00 00 00 00       	mov    $0x0,%edi
  804456:	48 b8 74 22 80 00 00 	movabs $0x802274,%rax
  80445d:	00 00 00 
  804460:	ff d0                	callq  *%rax
  804462:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804465:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804469:	78 79                	js     8044e4 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80446b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80446f:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804476:	00 00 00 
  804479:	8b 12                	mov    (%rdx),%edx
  80447b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80447d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804481:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804488:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80448c:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804493:	00 00 00 
  804496:	8b 12                	mov    (%rdx),%edx
  804498:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80449a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80449e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8044a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044a9:	48 89 c7             	mov    %rax,%rdi
  8044ac:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  8044b3:	00 00 00 
  8044b6:	ff d0                	callq  *%rax
  8044b8:	89 c2                	mov    %eax,%edx
  8044ba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8044be:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8044c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8044c4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8044c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044cc:	48 89 c7             	mov    %rax,%rdi
  8044cf:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  8044d6:	00 00 00 
  8044d9:	ff d0                	callq  *%rax
  8044db:	89 03                	mov    %eax,(%rbx)
	return 0;
  8044dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8044e2:	eb 4f                	jmp    804533 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8044e4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8044e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044e9:	48 89 c6             	mov    %rax,%rsi
  8044ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8044f1:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  8044f8:	00 00 00 
  8044fb:	ff d0                	callq  *%rax
  8044fd:	eb 01                	jmp    804500 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8044ff:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  804500:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804504:	48 89 c6             	mov    %rax,%rsi
  804507:	bf 00 00 00 00       	mov    $0x0,%edi
  80450c:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  804513:	00 00 00 
  804516:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  804518:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80451c:	48 89 c6             	mov    %rax,%rsi
  80451f:	bf 00 00 00 00       	mov    $0x0,%edi
  804524:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  80452b:	00 00 00 
  80452e:	ff d0                	callq  *%rax
    err:
	return r;
  804530:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804533:	48 83 c4 38          	add    $0x38,%rsp
  804537:	5b                   	pop    %rbx
  804538:	5d                   	pop    %rbp
  804539:	c3                   	retq   

000000000080453a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80453a:	55                   	push   %rbp
  80453b:	48 89 e5             	mov    %rsp,%rbp
  80453e:	53                   	push   %rbx
  80453f:	48 83 ec 28          	sub    $0x28,%rsp
  804543:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804547:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80454b:	eb 01                	jmp    80454e <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  80454d:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80454e:	48 b8 70 80 80 00 00 	movabs $0x808070,%rax
  804555:	00 00 00 
  804558:	48 8b 00             	mov    (%rax),%rax
  80455b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804561:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804564:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804568:	48 89 c7             	mov    %rax,%rdi
  80456b:	48 b8 10 4d 80 00 00 	movabs $0x804d10,%rax
  804572:	00 00 00 
  804575:	ff d0                	callq  *%rax
  804577:	89 c3                	mov    %eax,%ebx
  804579:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80457d:	48 89 c7             	mov    %rax,%rdi
  804580:	48 b8 10 4d 80 00 00 	movabs $0x804d10,%rax
  804587:	00 00 00 
  80458a:	ff d0                	callq  *%rax
  80458c:	39 c3                	cmp    %eax,%ebx
  80458e:	0f 94 c0             	sete   %al
  804591:	0f b6 c0             	movzbl %al,%eax
  804594:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804597:	48 b8 70 80 80 00 00 	movabs $0x808070,%rax
  80459e:	00 00 00 
  8045a1:	48 8b 00             	mov    (%rax),%rax
  8045a4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8045aa:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8045ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045b0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8045b3:	75 0a                	jne    8045bf <_pipeisclosed+0x85>
			return ret;
  8045b5:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8045b8:	48 83 c4 28          	add    $0x28,%rsp
  8045bc:	5b                   	pop    %rbx
  8045bd:	5d                   	pop    %rbp
  8045be:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8045bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045c2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8045c5:	74 86                	je     80454d <_pipeisclosed+0x13>
  8045c7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8045cb:	75 80                	jne    80454d <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8045cd:	48 b8 70 80 80 00 00 	movabs $0x808070,%rax
  8045d4:	00 00 00 
  8045d7:	48 8b 00             	mov    (%rax),%rax
  8045da:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8045e0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8045e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045e6:	89 c6                	mov    %eax,%esi
  8045e8:	48 bf 69 5c 80 00 00 	movabs $0x805c69,%rdi
  8045ef:	00 00 00 
  8045f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8045f7:	49 b8 2f 0d 80 00 00 	movabs $0x800d2f,%r8
  8045fe:	00 00 00 
  804601:	41 ff d0             	callq  *%r8
	}
  804604:	e9 44 ff ff ff       	jmpq   80454d <_pipeisclosed+0x13>

0000000000804609 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  804609:	55                   	push   %rbp
  80460a:	48 89 e5             	mov    %rsp,%rbp
  80460d:	48 83 ec 30          	sub    $0x30,%rsp
  804611:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804614:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804618:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80461b:	48 89 d6             	mov    %rdx,%rsi
  80461e:	89 c7                	mov    %eax,%edi
  804620:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  804627:	00 00 00 
  80462a:	ff d0                	callq  *%rax
  80462c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80462f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804633:	79 05                	jns    80463a <pipeisclosed+0x31>
		return r;
  804635:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804638:	eb 31                	jmp    80466b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80463a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80463e:	48 89 c7             	mov    %rax,%rdi
  804641:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  804648:	00 00 00 
  80464b:	ff d0                	callq  *%rax
  80464d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804655:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804659:	48 89 d6             	mov    %rdx,%rsi
  80465c:	48 89 c7             	mov    %rax,%rdi
  80465f:	48 b8 3a 45 80 00 00 	movabs $0x80453a,%rax
  804666:	00 00 00 
  804669:	ff d0                	callq  *%rax
}
  80466b:	c9                   	leaveq 
  80466c:	c3                   	retq   

000000000080466d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80466d:	55                   	push   %rbp
  80466e:	48 89 e5             	mov    %rsp,%rbp
  804671:	48 83 ec 40          	sub    $0x40,%rsp
  804675:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804679:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80467d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804681:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804685:	48 89 c7             	mov    %rax,%rdi
  804688:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  80468f:	00 00 00 
  804692:	ff d0                	callq  *%rax
  804694:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804698:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80469c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8046a0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8046a7:	00 
  8046a8:	e9 97 00 00 00       	jmpq   804744 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8046ad:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8046b2:	74 09                	je     8046bd <devpipe_read+0x50>
				return i;
  8046b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046b8:	e9 95 00 00 00       	jmpq   804752 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8046bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046c5:	48 89 d6             	mov    %rdx,%rsi
  8046c8:	48 89 c7             	mov    %rax,%rdi
  8046cb:	48 b8 3a 45 80 00 00 	movabs $0x80453a,%rax
  8046d2:	00 00 00 
  8046d5:	ff d0                	callq  *%rax
  8046d7:	85 c0                	test   %eax,%eax
  8046d9:	74 07                	je     8046e2 <devpipe_read+0x75>
				return 0;
  8046db:	b8 00 00 00 00       	mov    $0x0,%eax
  8046e0:	eb 70                	jmp    804752 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8046e2:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  8046e9:	00 00 00 
  8046ec:	ff d0                	callq  *%rax
  8046ee:	eb 01                	jmp    8046f1 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8046f0:	90                   	nop
  8046f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046f5:	8b 10                	mov    (%rax),%edx
  8046f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046fb:	8b 40 04             	mov    0x4(%rax),%eax
  8046fe:	39 c2                	cmp    %eax,%edx
  804700:	74 ab                	je     8046ad <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804702:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804706:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80470a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80470e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804712:	8b 00                	mov    (%rax),%eax
  804714:	89 c2                	mov    %eax,%edx
  804716:	c1 fa 1f             	sar    $0x1f,%edx
  804719:	c1 ea 1b             	shr    $0x1b,%edx
  80471c:	01 d0                	add    %edx,%eax
  80471e:	83 e0 1f             	and    $0x1f,%eax
  804721:	29 d0                	sub    %edx,%eax
  804723:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804727:	48 98                	cltq   
  804729:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80472e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804730:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804734:	8b 00                	mov    (%rax),%eax
  804736:	8d 50 01             	lea    0x1(%rax),%edx
  804739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80473d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80473f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804744:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804748:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80474c:	72 a2                	jb     8046f0 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80474e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804752:	c9                   	leaveq 
  804753:	c3                   	retq   

0000000000804754 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804754:	55                   	push   %rbp
  804755:	48 89 e5             	mov    %rsp,%rbp
  804758:	48 83 ec 40          	sub    $0x40,%rsp
  80475c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804760:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804764:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804768:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80476c:	48 89 c7             	mov    %rax,%rdi
  80476f:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  804776:	00 00 00 
  804779:	ff d0                	callq  *%rax
  80477b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80477f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804783:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804787:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80478e:	00 
  80478f:	e9 93 00 00 00       	jmpq   804827 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804794:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804798:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80479c:	48 89 d6             	mov    %rdx,%rsi
  80479f:	48 89 c7             	mov    %rax,%rdi
  8047a2:	48 b8 3a 45 80 00 00 	movabs $0x80453a,%rax
  8047a9:	00 00 00 
  8047ac:	ff d0                	callq  *%rax
  8047ae:	85 c0                	test   %eax,%eax
  8047b0:	74 07                	je     8047b9 <devpipe_write+0x65>
				return 0;
  8047b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8047b7:	eb 7c                	jmp    804835 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8047b9:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  8047c0:	00 00 00 
  8047c3:	ff d0                	callq  *%rax
  8047c5:	eb 01                	jmp    8047c8 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8047c7:	90                   	nop
  8047c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047cc:	8b 40 04             	mov    0x4(%rax),%eax
  8047cf:	48 63 d0             	movslq %eax,%rdx
  8047d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047d6:	8b 00                	mov    (%rax),%eax
  8047d8:	48 98                	cltq   
  8047da:	48 83 c0 20          	add    $0x20,%rax
  8047de:	48 39 c2             	cmp    %rax,%rdx
  8047e1:	73 b1                	jae    804794 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8047e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047e7:	8b 40 04             	mov    0x4(%rax),%eax
  8047ea:	89 c2                	mov    %eax,%edx
  8047ec:	c1 fa 1f             	sar    $0x1f,%edx
  8047ef:	c1 ea 1b             	shr    $0x1b,%edx
  8047f2:	01 d0                	add    %edx,%eax
  8047f4:	83 e0 1f             	and    $0x1f,%eax
  8047f7:	29 d0                	sub    %edx,%eax
  8047f9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8047fd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804801:	48 01 ca             	add    %rcx,%rdx
  804804:	0f b6 0a             	movzbl (%rdx),%ecx
  804807:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80480b:	48 98                	cltq   
  80480d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804811:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804815:	8b 40 04             	mov    0x4(%rax),%eax
  804818:	8d 50 01             	lea    0x1(%rax),%edx
  80481b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80481f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804822:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804827:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80482b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80482f:	72 96                	jb     8047c7 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804831:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804835:	c9                   	leaveq 
  804836:	c3                   	retq   

0000000000804837 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804837:	55                   	push   %rbp
  804838:	48 89 e5             	mov    %rsp,%rbp
  80483b:	48 83 ec 20          	sub    $0x20,%rsp
  80483f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804843:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80484b:	48 89 c7             	mov    %rax,%rdi
  80484e:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  804855:	00 00 00 
  804858:	ff d0                	callq  *%rax
  80485a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80485e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804862:	48 be 7c 5c 80 00 00 	movabs $0x805c7c,%rsi
  804869:	00 00 00 
  80486c:	48 89 c7             	mov    %rax,%rdi
  80486f:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  804876:	00 00 00 
  804879:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80487b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80487f:	8b 50 04             	mov    0x4(%rax),%edx
  804882:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804886:	8b 00                	mov    (%rax),%eax
  804888:	29 c2                	sub    %eax,%edx
  80488a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80488e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804894:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804898:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80489f:	00 00 00 
	stat->st_dev = &devpipe;
  8048a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048a6:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8048ad:	00 00 00 
  8048b0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8048b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8048bc:	c9                   	leaveq 
  8048bd:	c3                   	retq   

00000000008048be <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8048be:	55                   	push   %rbp
  8048bf:	48 89 e5             	mov    %rsp,%rbp
  8048c2:	48 83 ec 10          	sub    $0x10,%rsp
  8048c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8048ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048ce:	48 89 c6             	mov    %rax,%rsi
  8048d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8048d6:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  8048dd:	00 00 00 
  8048e0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8048e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048e6:	48 89 c7             	mov    %rax,%rdi
  8048e9:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  8048f0:	00 00 00 
  8048f3:	ff d0                	callq  *%rax
  8048f5:	48 89 c6             	mov    %rax,%rsi
  8048f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8048fd:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  804904:	00 00 00 
  804907:	ff d0                	callq  *%rax
}
  804909:	c9                   	leaveq 
  80490a:	c3                   	retq   
	...

000000000080490c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80490c:	55                   	push   %rbp
  80490d:	48 89 e5             	mov    %rsp,%rbp
  804910:	48 83 ec 20          	sub    $0x20,%rsp
  804914:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804917:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80491a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80491d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804921:	be 01 00 00 00       	mov    $0x1,%esi
  804926:	48 89 c7             	mov    %rax,%rdi
  804929:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  804930:	00 00 00 
  804933:	ff d0                	callq  *%rax
}
  804935:	c9                   	leaveq 
  804936:	c3                   	retq   

0000000000804937 <getchar>:

int
getchar(void)
{
  804937:	55                   	push   %rbp
  804938:	48 89 e5             	mov    %rsp,%rbp
  80493b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80493f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804943:	ba 01 00 00 00       	mov    $0x1,%edx
  804948:	48 89 c6             	mov    %rax,%rsi
  80494b:	bf 00 00 00 00       	mov    $0x0,%edi
  804950:	48 b8 48 33 80 00 00 	movabs $0x803348,%rax
  804957:	00 00 00 
  80495a:	ff d0                	callq  *%rax
  80495c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80495f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804963:	79 05                	jns    80496a <getchar+0x33>
		return r;
  804965:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804968:	eb 14                	jmp    80497e <getchar+0x47>
	if (r < 1)
  80496a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80496e:	7f 07                	jg     804977 <getchar+0x40>
		return -E_EOF;
  804970:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804975:	eb 07                	jmp    80497e <getchar+0x47>
	return c;
  804977:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80497b:	0f b6 c0             	movzbl %al,%eax
}
  80497e:	c9                   	leaveq 
  80497f:	c3                   	retq   

0000000000804980 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804980:	55                   	push   %rbp
  804981:	48 89 e5             	mov    %rsp,%rbp
  804984:	48 83 ec 20          	sub    $0x20,%rsp
  804988:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80498b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80498f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804992:	48 89 d6             	mov    %rdx,%rsi
  804995:	89 c7                	mov    %eax,%edi
  804997:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  80499e:	00 00 00 
  8049a1:	ff d0                	callq  *%rax
  8049a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049aa:	79 05                	jns    8049b1 <iscons+0x31>
		return r;
  8049ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049af:	eb 1a                	jmp    8049cb <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8049b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049b5:	8b 10                	mov    (%rax),%edx
  8049b7:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8049be:	00 00 00 
  8049c1:	8b 00                	mov    (%rax),%eax
  8049c3:	39 c2                	cmp    %eax,%edx
  8049c5:	0f 94 c0             	sete   %al
  8049c8:	0f b6 c0             	movzbl %al,%eax
}
  8049cb:	c9                   	leaveq 
  8049cc:	c3                   	retq   

00000000008049cd <opencons>:

int
opencons(void)
{
  8049cd:	55                   	push   %rbp
  8049ce:	48 89 e5             	mov    %rsp,%rbp
  8049d1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8049d5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8049d9:	48 89 c7             	mov    %rax,%rdi
  8049dc:	48 b8 7e 2e 80 00 00 	movabs $0x802e7e,%rax
  8049e3:	00 00 00 
  8049e6:	ff d0                	callq  *%rax
  8049e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049ef:	79 05                	jns    8049f6 <opencons+0x29>
		return r;
  8049f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049f4:	eb 5b                	jmp    804a51 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8049f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049fa:	ba 07 04 00 00       	mov    $0x407,%edx
  8049ff:	48 89 c6             	mov    %rax,%rsi
  804a02:	bf 00 00 00 00       	mov    $0x0,%edi
  804a07:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  804a0e:	00 00 00 
  804a11:	ff d0                	callq  *%rax
  804a13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a1a:	79 05                	jns    804a21 <opencons+0x54>
		return r;
  804a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a1f:	eb 30                	jmp    804a51 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804a21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a25:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804a2c:	00 00 00 
  804a2f:	8b 12                	mov    (%rdx),%edx
  804a31:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804a33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a37:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804a3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a42:	48 89 c7             	mov    %rax,%rdi
  804a45:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  804a4c:	00 00 00 
  804a4f:	ff d0                	callq  *%rax
}
  804a51:	c9                   	leaveq 
  804a52:	c3                   	retq   

0000000000804a53 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804a53:	55                   	push   %rbp
  804a54:	48 89 e5             	mov    %rsp,%rbp
  804a57:	48 83 ec 30          	sub    $0x30,%rsp
  804a5b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804a5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804a63:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804a67:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804a6c:	75 13                	jne    804a81 <devcons_read+0x2e>
		return 0;
  804a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  804a73:	eb 49                	jmp    804abe <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804a75:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  804a7c:	00 00 00 
  804a7f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804a81:	48 b8 26 21 80 00 00 	movabs $0x802126,%rax
  804a88:	00 00 00 
  804a8b:	ff d0                	callq  *%rax
  804a8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a94:	74 df                	je     804a75 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804a96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a9a:	79 05                	jns    804aa1 <devcons_read+0x4e>
		return c;
  804a9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a9f:	eb 1d                	jmp    804abe <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804aa1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804aa5:	75 07                	jne    804aae <devcons_read+0x5b>
		return 0;
  804aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  804aac:	eb 10                	jmp    804abe <devcons_read+0x6b>
	*(char*)vbuf = c;
  804aae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ab1:	89 c2                	mov    %eax,%edx
  804ab3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ab7:	88 10                	mov    %dl,(%rax)
	return 1;
  804ab9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804abe:	c9                   	leaveq 
  804abf:	c3                   	retq   

0000000000804ac0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804ac0:	55                   	push   %rbp
  804ac1:	48 89 e5             	mov    %rsp,%rbp
  804ac4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804acb:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804ad2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804ad9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804ae0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804ae7:	eb 77                	jmp    804b60 <devcons_write+0xa0>
		m = n - tot;
  804ae9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804af0:	89 c2                	mov    %eax,%edx
  804af2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804af5:	89 d1                	mov    %edx,%ecx
  804af7:	29 c1                	sub    %eax,%ecx
  804af9:	89 c8                	mov    %ecx,%eax
  804afb:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804afe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b01:	83 f8 7f             	cmp    $0x7f,%eax
  804b04:	76 07                	jbe    804b0d <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  804b06:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804b0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b10:	48 63 d0             	movslq %eax,%rdx
  804b13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b16:	48 98                	cltq   
  804b18:	48 89 c1             	mov    %rax,%rcx
  804b1b:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  804b22:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804b29:	48 89 ce             	mov    %rcx,%rsi
  804b2c:	48 89 c7             	mov    %rax,%rdi
  804b2f:	48 b8 0e 1c 80 00 00 	movabs $0x801c0e,%rax
  804b36:	00 00 00 
  804b39:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804b3b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b3e:	48 63 d0             	movslq %eax,%rdx
  804b41:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804b48:	48 89 d6             	mov    %rdx,%rsi
  804b4b:	48 89 c7             	mov    %rax,%rdi
  804b4e:	48 b8 dc 20 80 00 00 	movabs $0x8020dc,%rax
  804b55:	00 00 00 
  804b58:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804b5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b5d:	01 45 fc             	add    %eax,-0x4(%rbp)
  804b60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b63:	48 98                	cltq   
  804b65:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804b6c:	0f 82 77 ff ff ff    	jb     804ae9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804b72:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804b75:	c9                   	leaveq 
  804b76:	c3                   	retq   

0000000000804b77 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804b77:	55                   	push   %rbp
  804b78:	48 89 e5             	mov    %rsp,%rbp
  804b7b:	48 83 ec 08          	sub    $0x8,%rsp
  804b7f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804b83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b88:	c9                   	leaveq 
  804b89:	c3                   	retq   

0000000000804b8a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804b8a:	55                   	push   %rbp
  804b8b:	48 89 e5             	mov    %rsp,%rbp
  804b8e:	48 83 ec 10          	sub    $0x10,%rsp
  804b92:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804b96:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804b9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b9e:	48 be 88 5c 80 00 00 	movabs $0x805c88,%rsi
  804ba5:	00 00 00 
  804ba8:	48 89 c7             	mov    %rax,%rdi
  804bab:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  804bb2:	00 00 00 
  804bb5:	ff d0                	callq  *%rax
	return 0;
  804bb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804bbc:	c9                   	leaveq 
  804bbd:	c3                   	retq   
	...

0000000000804bc0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804bc0:	55                   	push   %rbp
  804bc1:	48 89 e5             	mov    %rsp,%rbp
  804bc4:	48 83 ec 20          	sub    $0x20,%rsp
  804bc8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  804bcc:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804bd3:	00 00 00 
  804bd6:	48 8b 00             	mov    (%rax),%rax
  804bd9:	48 85 c0             	test   %rax,%rax
  804bdc:	0f 85 8e 00 00 00    	jne    804c70 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  804be2:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  804be9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  804bf0:	48 b8 a8 21 80 00 00 	movabs $0x8021a8,%rax
  804bf7:	00 00 00 
  804bfa:	ff d0                	callq  *%rax
  804bfc:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  804bff:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  804c03:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804c06:	ba 07 00 00 00       	mov    $0x7,%edx
  804c0b:	48 89 ce             	mov    %rcx,%rsi
  804c0e:	89 c7                	mov    %eax,%edi
  804c10:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  804c17:	00 00 00 
  804c1a:	ff d0                	callq  *%rax
  804c1c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  804c1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  804c23:	74 30                	je     804c55 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  804c25:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804c28:	89 c1                	mov    %eax,%ecx
  804c2a:	48 ba 90 5c 80 00 00 	movabs $0x805c90,%rdx
  804c31:	00 00 00 
  804c34:	be 24 00 00 00       	mov    $0x24,%esi
  804c39:	48 bf c7 5c 80 00 00 	movabs $0x805cc7,%rdi
  804c40:	00 00 00 
  804c43:	b8 00 00 00 00       	mov    $0x0,%eax
  804c48:	49 b8 f4 0a 80 00 00 	movabs $0x800af4,%r8
  804c4f:	00 00 00 
  804c52:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  804c55:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804c58:	48 be 84 4c 80 00 00 	movabs $0x804c84,%rsi
  804c5f:	00 00 00 
  804c62:	89 c7                	mov    %eax,%edi
  804c64:	48 b8 ae 23 80 00 00 	movabs $0x8023ae,%rax
  804c6b:	00 00 00 
  804c6e:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804c70:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804c77:	00 00 00 
  804c7a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804c7e:	48 89 10             	mov    %rdx,(%rax)
}
  804c81:	c9                   	leaveq 
  804c82:	c3                   	retq   
	...

0000000000804c84 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  804c84:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  804c87:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804c8e:	00 00 00 
	call *%rax
  804c91:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  804c93:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  804c97:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  804c9b:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  804c9e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804ca5:	00 
		movq 120(%rsp), %rcx				// trap time rip
  804ca6:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  804cab:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  804cae:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  804caf:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  804cb2:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  804cb9:	00 08 
		POPA_						// copy the register contents to the registers
  804cbb:	4c 8b 3c 24          	mov    (%rsp),%r15
  804cbf:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804cc4:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804cc9:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804cce:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804cd3:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804cd8:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804cdd:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804ce2:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804ce7:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804cec:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804cf1:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804cf6:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804cfb:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804d00:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804d05:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  804d09:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  804d0d:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  804d0e:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  804d0f:	c3                   	retq   

0000000000804d10 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804d10:	55                   	push   %rbp
  804d11:	48 89 e5             	mov    %rsp,%rbp
  804d14:	48 83 ec 18          	sub    $0x18,%rsp
  804d18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804d1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d20:	48 89 c2             	mov    %rax,%rdx
  804d23:	48 c1 ea 15          	shr    $0x15,%rdx
  804d27:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804d2e:	01 00 00 
  804d31:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d35:	83 e0 01             	and    $0x1,%eax
  804d38:	48 85 c0             	test   %rax,%rax
  804d3b:	75 07                	jne    804d44 <pageref+0x34>
		return 0;
  804d3d:	b8 00 00 00 00       	mov    $0x0,%eax
  804d42:	eb 53                	jmp    804d97 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804d44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d48:	48 89 c2             	mov    %rax,%rdx
  804d4b:	48 c1 ea 0c          	shr    $0xc,%rdx
  804d4f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804d56:	01 00 00 
  804d59:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d5d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804d61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d65:	83 e0 01             	and    $0x1,%eax
  804d68:	48 85 c0             	test   %rax,%rax
  804d6b:	75 07                	jne    804d74 <pageref+0x64>
		return 0;
  804d6d:	b8 00 00 00 00       	mov    $0x0,%eax
  804d72:	eb 23                	jmp    804d97 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804d74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d78:	48 89 c2             	mov    %rax,%rdx
  804d7b:	48 c1 ea 0c          	shr    $0xc,%rdx
  804d7f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804d86:	00 00 00 
  804d89:	48 c1 e2 04          	shl    $0x4,%rdx
  804d8d:	48 01 d0             	add    %rdx,%rax
  804d90:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804d94:	0f b7 c0             	movzwl %ax,%eax
}
  804d97:	c9                   	leaveq 
  804d98:	c3                   	retq   
  804d99:	00 00                	add    %al,(%rax)
	...

0000000000804d9c <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804d9c:	55                   	push   %rbp
  804d9d:	48 89 e5             	mov    %rsp,%rbp
  804da0:	48 83 ec 20          	sub    $0x20,%rsp
  804da4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804da8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804dac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804db0:	48 89 d6             	mov    %rdx,%rsi
  804db3:	48 89 c7             	mov    %rax,%rdi
  804db6:	48 b8 d2 4d 80 00 00 	movabs $0x804dd2,%rax
  804dbd:	00 00 00 
  804dc0:	ff d0                	callq  *%rax
  804dc2:	85 c0                	test   %eax,%eax
  804dc4:	74 05                	je     804dcb <inet_addr+0x2f>
    return (val.s_addr);
  804dc6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804dc9:	eb 05                	jmp    804dd0 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  804dcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  804dd0:	c9                   	leaveq 
  804dd1:	c3                   	retq   

0000000000804dd2 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  804dd2:	55                   	push   %rbp
  804dd3:	48 89 e5             	mov    %rsp,%rbp
  804dd6:	53                   	push   %rbx
  804dd7:	48 83 ec 48          	sub    $0x48,%rsp
  804ddb:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  804ddf:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804de3:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  804de7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

  c = *cp;
  804deb:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804def:	0f b6 00             	movzbl (%rax),%eax
  804df2:	0f be c0             	movsbl %al,%eax
  804df5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804df8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804dfb:	3c 2f                	cmp    $0x2f,%al
  804dfd:	76 07                	jbe    804e06 <inet_aton+0x34>
  804dff:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e02:	3c 39                	cmp    $0x39,%al
  804e04:	76 0a                	jbe    804e10 <inet_aton+0x3e>
      return (0);
  804e06:	b8 00 00 00 00       	mov    $0x0,%eax
  804e0b:	e9 6a 02 00 00       	jmpq   80507a <inet_aton+0x2a8>
    val = 0;
  804e10:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    base = 10;
  804e17:	c7 45 e8 0a 00 00 00 	movl   $0xa,-0x18(%rbp)
    if (c == '0') {
  804e1e:	83 7d e4 30          	cmpl   $0x30,-0x1c(%rbp)
  804e22:	75 40                	jne    804e64 <inet_aton+0x92>
      c = *++cp;
  804e24:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804e29:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804e2d:	0f b6 00             	movzbl (%rax),%eax
  804e30:	0f be c0             	movsbl %al,%eax
  804e33:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      if (c == 'x' || c == 'X') {
  804e36:	83 7d e4 78          	cmpl   $0x78,-0x1c(%rbp)
  804e3a:	74 06                	je     804e42 <inet_aton+0x70>
  804e3c:	83 7d e4 58          	cmpl   $0x58,-0x1c(%rbp)
  804e40:	75 1b                	jne    804e5d <inet_aton+0x8b>
        base = 16;
  804e42:	c7 45 e8 10 00 00 00 	movl   $0x10,-0x18(%rbp)
        c = *++cp;
  804e49:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804e4e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804e52:	0f b6 00             	movzbl (%rax),%eax
  804e55:	0f be c0             	movsbl %al,%eax
  804e58:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  804e5b:	eb 07                	jmp    804e64 <inet_aton+0x92>
      } else
        base = 8;
  804e5d:	c7 45 e8 08 00 00 00 	movl   $0x8,-0x18(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  804e64:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e67:	3c 2f                	cmp    $0x2f,%al
  804e69:	76 2f                	jbe    804e9a <inet_aton+0xc8>
  804e6b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e6e:	3c 39                	cmp    $0x39,%al
  804e70:	77 28                	ja     804e9a <inet_aton+0xc8>
        val = (val * base) + (int)(c - '0');
  804e72:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804e75:	89 c2                	mov    %eax,%edx
  804e77:	0f af 55 ec          	imul   -0x14(%rbp),%edx
  804e7b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e7e:	01 d0                	add    %edx,%eax
  804e80:	83 e8 30             	sub    $0x30,%eax
  804e83:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  804e86:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804e8b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804e8f:	0f b6 00             	movzbl (%rax),%eax
  804e92:	0f be c0             	movsbl %al,%eax
  804e95:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  804e98:	eb ca                	jmp    804e64 <inet_aton+0x92>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804e9a:	83 7d e8 10          	cmpl   $0x10,-0x18(%rbp)
  804e9e:	75 74                	jne    804f14 <inet_aton+0x142>
  804ea0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ea3:	3c 2f                	cmp    $0x2f,%al
  804ea5:	76 07                	jbe    804eae <inet_aton+0xdc>
  804ea7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804eaa:	3c 39                	cmp    $0x39,%al
  804eac:	76 1c                	jbe    804eca <inet_aton+0xf8>
  804eae:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804eb1:	3c 60                	cmp    $0x60,%al
  804eb3:	76 07                	jbe    804ebc <inet_aton+0xea>
  804eb5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804eb8:	3c 66                	cmp    $0x66,%al
  804eba:	76 0e                	jbe    804eca <inet_aton+0xf8>
  804ebc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ebf:	3c 40                	cmp    $0x40,%al
  804ec1:	76 51                	jbe    804f14 <inet_aton+0x142>
  804ec3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ec6:	3c 46                	cmp    $0x46,%al
  804ec8:	77 4a                	ja     804f14 <inet_aton+0x142>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  804eca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804ecd:	89 c2                	mov    %eax,%edx
  804ecf:	c1 e2 04             	shl    $0x4,%edx
  804ed2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ed5:	8d 48 0a             	lea    0xa(%rax),%ecx
  804ed8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804edb:	3c 60                	cmp    $0x60,%al
  804edd:	76 0e                	jbe    804eed <inet_aton+0x11b>
  804edf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ee2:	3c 7a                	cmp    $0x7a,%al
  804ee4:	77 07                	ja     804eed <inet_aton+0x11b>
  804ee6:	b8 61 00 00 00       	mov    $0x61,%eax
  804eeb:	eb 05                	jmp    804ef2 <inet_aton+0x120>
  804eed:	b8 41 00 00 00       	mov    $0x41,%eax
  804ef2:	89 cb                	mov    %ecx,%ebx
  804ef4:	29 c3                	sub    %eax,%ebx
  804ef6:	89 d8                	mov    %ebx,%eax
  804ef8:	09 d0                	or     %edx,%eax
  804efa:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  804efd:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804f02:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804f06:	0f b6 00             	movzbl (%rax),%eax
  804f09:	0f be c0             	movsbl %al,%eax
  804f0c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else
        break;
    }
  804f0f:	e9 50 ff ff ff       	jmpq   804e64 <inet_aton+0x92>
    if (c == '.') {
  804f14:	83 7d e4 2e          	cmpl   $0x2e,-0x1c(%rbp)
  804f18:	75 3d                	jne    804f57 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  804f1a:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  804f1e:	48 83 c0 0c          	add    $0xc,%rax
  804f22:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  804f26:	72 0a                	jb     804f32 <inet_aton+0x160>
        return (0);
  804f28:	b8 00 00 00 00       	mov    $0x0,%eax
  804f2d:	e9 48 01 00 00       	jmpq   80507a <inet_aton+0x2a8>
      *pp++ = val;
  804f32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804f36:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804f39:	89 10                	mov    %edx,(%rax)
  804f3b:	48 83 45 d8 04       	addq   $0x4,-0x28(%rbp)
      c = *++cp;
  804f40:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804f45:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804f49:	0f b6 00             	movzbl (%rax),%eax
  804f4c:	0f be c0             	movsbl %al,%eax
  804f4f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    } else
      break;
  }
  804f52:	e9 a1 fe ff ff       	jmpq   804df8 <inet_aton+0x26>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  804f57:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804f58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804f5c:	74 3c                	je     804f9a <inet_aton+0x1c8>
  804f5e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804f61:	3c 1f                	cmp    $0x1f,%al
  804f63:	76 2b                	jbe    804f90 <inet_aton+0x1be>
  804f65:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804f68:	84 c0                	test   %al,%al
  804f6a:	78 24                	js     804f90 <inet_aton+0x1be>
  804f6c:	83 7d e4 20          	cmpl   $0x20,-0x1c(%rbp)
  804f70:	74 28                	je     804f9a <inet_aton+0x1c8>
  804f72:	83 7d e4 0c          	cmpl   $0xc,-0x1c(%rbp)
  804f76:	74 22                	je     804f9a <inet_aton+0x1c8>
  804f78:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%rbp)
  804f7c:	74 1c                	je     804f9a <inet_aton+0x1c8>
  804f7e:	83 7d e4 0d          	cmpl   $0xd,-0x1c(%rbp)
  804f82:	74 16                	je     804f9a <inet_aton+0x1c8>
  804f84:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  804f88:	74 10                	je     804f9a <inet_aton+0x1c8>
  804f8a:	83 7d e4 0b          	cmpl   $0xb,-0x1c(%rbp)
  804f8e:	74 0a                	je     804f9a <inet_aton+0x1c8>
    return (0);
  804f90:	b8 00 00 00 00       	mov    $0x0,%eax
  804f95:	e9 e0 00 00 00       	jmpq   80507a <inet_aton+0x2a8>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804f9a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804f9e:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  804fa2:	48 89 d1             	mov    %rdx,%rcx
  804fa5:	48 29 c1             	sub    %rax,%rcx
  804fa8:	48 89 c8             	mov    %rcx,%rax
  804fab:	48 c1 f8 02          	sar    $0x2,%rax
  804faf:	83 c0 01             	add    $0x1,%eax
  804fb2:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  switch (n) {
  804fb5:	83 7d d4 04          	cmpl   $0x4,-0x2c(%rbp)
  804fb9:	0f 87 98 00 00 00    	ja     805057 <inet_aton+0x285>
  804fbf:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804fc2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804fc9:	00 
  804fca:	48 b8 d8 5c 80 00 00 	movabs $0x805cd8,%rax
  804fd1:	00 00 00 
  804fd4:	48 01 d0             	add    %rdx,%rax
  804fd7:	48 8b 00             	mov    (%rax),%rax
  804fda:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  804fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  804fe1:	e9 94 00 00 00       	jmpq   80507a <inet_aton+0x2a8>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804fe6:	81 7d ec ff ff ff 00 	cmpl   $0xffffff,-0x14(%rbp)
  804fed:	76 0a                	jbe    804ff9 <inet_aton+0x227>
      return (0);
  804fef:	b8 00 00 00 00       	mov    $0x0,%eax
  804ff4:	e9 81 00 00 00       	jmpq   80507a <inet_aton+0x2a8>
    val |= parts[0] << 24;
  804ff9:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804ffc:	c1 e0 18             	shl    $0x18,%eax
  804fff:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  805002:	eb 53                	jmp    805057 <inet_aton+0x285>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  805004:	81 7d ec ff ff 00 00 	cmpl   $0xffff,-0x14(%rbp)
  80500b:	76 07                	jbe    805014 <inet_aton+0x242>
      return (0);
  80500d:	b8 00 00 00 00       	mov    $0x0,%eax
  805012:	eb 66                	jmp    80507a <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  805014:	8b 45 c0             	mov    -0x40(%rbp),%eax
  805017:	89 c2                	mov    %eax,%edx
  805019:	c1 e2 18             	shl    $0x18,%edx
  80501c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80501f:	c1 e0 10             	shl    $0x10,%eax
  805022:	09 d0                	or     %edx,%eax
  805024:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  805027:	eb 2e                	jmp    805057 <inet_aton+0x285>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  805029:	81 7d ec ff 00 00 00 	cmpl   $0xff,-0x14(%rbp)
  805030:	76 07                	jbe    805039 <inet_aton+0x267>
      return (0);
  805032:	b8 00 00 00 00       	mov    $0x0,%eax
  805037:	eb 41                	jmp    80507a <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  805039:	8b 45 c0             	mov    -0x40(%rbp),%eax
  80503c:	89 c2                	mov    %eax,%edx
  80503e:	c1 e2 18             	shl    $0x18,%edx
  805041:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  805044:	c1 e0 10             	shl    $0x10,%eax
  805047:	09 c2                	or     %eax,%edx
  805049:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80504c:	c1 e0 08             	shl    $0x8,%eax
  80504f:	09 d0                	or     %edx,%eax
  805051:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  805054:	eb 01                	jmp    805057 <inet_aton+0x285>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  805056:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  805057:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  80505c:	74 17                	je     805075 <inet_aton+0x2a3>
    addr->s_addr = htonl(val);
  80505e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805061:	89 c7                	mov    %eax,%edi
  805063:	48 b8 e9 51 80 00 00 	movabs $0x8051e9,%rax
  80506a:	00 00 00 
  80506d:	ff d0                	callq  *%rax
  80506f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  805073:	89 02                	mov    %eax,(%rdx)
  return (1);
  805075:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80507a:	48 83 c4 48          	add    $0x48,%rsp
  80507e:	5b                   	pop    %rbx
  80507f:	5d                   	pop    %rbp
  805080:	c3                   	retq   

0000000000805081 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  805081:	55                   	push   %rbp
  805082:	48 89 e5             	mov    %rsp,%rbp
  805085:	48 83 ec 30          	sub    $0x30,%rsp
  805089:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80508c:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80508f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  805092:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  805099:	00 00 00 
  80509c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  8050a0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8050a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  8050a8:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  8050ac:	e9 d1 00 00 00       	jmpq   805182 <inet_ntoa+0x101>
    i = 0;
  8050b1:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  8050b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050b9:	0f b6 08             	movzbl (%rax),%ecx
  8050bc:	0f b6 d1             	movzbl %cl,%edx
  8050bf:	89 d0                	mov    %edx,%eax
  8050c1:	c1 e0 02             	shl    $0x2,%eax
  8050c4:	01 d0                	add    %edx,%eax
  8050c6:	c1 e0 03             	shl    $0x3,%eax
  8050c9:	01 d0                	add    %edx,%eax
  8050cb:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8050d2:	01 d0                	add    %edx,%eax
  8050d4:	66 c1 e8 08          	shr    $0x8,%ax
  8050d8:	c0 e8 03             	shr    $0x3,%al
  8050db:	88 45 ed             	mov    %al,-0x13(%rbp)
  8050de:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8050e2:	89 d0                	mov    %edx,%eax
  8050e4:	c1 e0 02             	shl    $0x2,%eax
  8050e7:	01 d0                	add    %edx,%eax
  8050e9:	01 c0                	add    %eax,%eax
  8050eb:	89 ca                	mov    %ecx,%edx
  8050ed:	28 c2                	sub    %al,%dl
  8050ef:	89 d0                	mov    %edx,%eax
  8050f1:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8050f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050f8:	0f b6 00             	movzbl (%rax),%eax
  8050fb:	0f b6 d0             	movzbl %al,%edx
  8050fe:	89 d0                	mov    %edx,%eax
  805100:	c1 e0 02             	shl    $0x2,%eax
  805103:	01 d0                	add    %edx,%eax
  805105:	c1 e0 03             	shl    $0x3,%eax
  805108:	01 d0                	add    %edx,%eax
  80510a:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  805111:	01 d0                	add    %edx,%eax
  805113:	66 c1 e8 08          	shr    $0x8,%ax
  805117:	89 c2                	mov    %eax,%edx
  805119:	c0 ea 03             	shr    $0x3,%dl
  80511c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805120:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  805122:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  805126:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  80512a:	83 c2 30             	add    $0x30,%edx
  80512d:	48 98                	cltq   
  80512f:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
  805133:	80 45 ee 01          	addb   $0x1,-0x12(%rbp)
    } while(*ap);
  805137:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80513b:	0f b6 00             	movzbl (%rax),%eax
  80513e:	84 c0                	test   %al,%al
  805140:	0f 85 6f ff ff ff    	jne    8050b5 <inet_ntoa+0x34>
    while(i--)
  805146:	eb 16                	jmp    80515e <inet_ntoa+0xdd>
      *rp++ = inv[i];
  805148:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80514c:	48 98                	cltq   
  80514e:	0f b6 54 05 e0       	movzbl -0x20(%rbp,%rax,1),%edx
  805153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805157:	88 10                	mov    %dl,(%rax)
  805159:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80515e:	80 7d ee 00          	cmpb   $0x0,-0x12(%rbp)
  805162:	0f 95 c0             	setne  %al
  805165:	80 6d ee 01          	subb   $0x1,-0x12(%rbp)
  805169:	84 c0                	test   %al,%al
  80516b:	75 db                	jne    805148 <inet_ntoa+0xc7>
      *rp++ = inv[i];
    *rp++ = '.';
  80516d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805171:	c6 00 2e             	movb   $0x2e,(%rax)
  805174:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    ap++;
  805179:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80517e:	80 45 ef 01          	addb   $0x1,-0x11(%rbp)
  805182:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  805186:	0f 86 25 ff ff ff    	jbe    8050b1 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  80518c:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  805191:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805195:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  805198:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80519f:	00 00 00 
}
  8051a2:	c9                   	leaveq 
  8051a3:	c3                   	retq   

00000000008051a4 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8051a4:	55                   	push   %rbp
  8051a5:	48 89 e5             	mov    %rsp,%rbp
  8051a8:	48 83 ec 08          	sub    $0x8,%rsp
  8051ac:	89 f8                	mov    %edi,%eax
  8051ae:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8051b2:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8051b6:	c1 e0 08             	shl    $0x8,%eax
  8051b9:	89 c2                	mov    %eax,%edx
  8051bb:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8051bf:	66 c1 e8 08          	shr    $0x8,%ax
  8051c3:	09 d0                	or     %edx,%eax
}
  8051c5:	c9                   	leaveq 
  8051c6:	c3                   	retq   

00000000008051c7 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8051c7:	55                   	push   %rbp
  8051c8:	48 89 e5             	mov    %rsp,%rbp
  8051cb:	48 83 ec 08          	sub    $0x8,%rsp
  8051cf:	89 f8                	mov    %edi,%eax
  8051d1:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  8051d5:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8051d9:	89 c7                	mov    %eax,%edi
  8051db:	48 b8 a4 51 80 00 00 	movabs $0x8051a4,%rax
  8051e2:	00 00 00 
  8051e5:	ff d0                	callq  *%rax
}
  8051e7:	c9                   	leaveq 
  8051e8:	c3                   	retq   

00000000008051e9 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8051e9:	55                   	push   %rbp
  8051ea:	48 89 e5             	mov    %rsp,%rbp
  8051ed:	48 83 ec 08          	sub    $0x8,%rsp
  8051f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  8051f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051f7:	89 c2                	mov    %eax,%edx
  8051f9:	c1 e2 18             	shl    $0x18,%edx
    ((n & 0xff00) << 8) |
  8051fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051ff:	25 00 ff 00 00       	and    $0xff00,%eax
  805204:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805207:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  805209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80520c:	25 00 00 ff 00       	and    $0xff0000,%eax
  805211:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805215:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  805217:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80521a:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80521d:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80521f:	c9                   	leaveq 
  805220:	c3                   	retq   

0000000000805221 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  805221:	55                   	push   %rbp
  805222:	48 89 e5             	mov    %rsp,%rbp
  805225:	48 83 ec 08          	sub    $0x8,%rsp
  805229:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  80522c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80522f:	89 c7                	mov    %eax,%edi
  805231:	48 b8 e9 51 80 00 00 	movabs $0x8051e9,%rax
  805238:	00 00 00 
  80523b:	ff d0                	callq  *%rax
}
  80523d:	c9                   	leaveq 
  80523e:	c3                   	retq   
