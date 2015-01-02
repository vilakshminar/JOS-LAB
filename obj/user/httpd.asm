
obj/user/httpd.debug:     file format elf64-x86-64


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
  80003c:	e8 1b 0c 00 00       	callq  800c5c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <die>:
	{404, "Not Found"},
};

static void
die(char *m)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 10          	sub    $0x10,%rsp
  80004c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%s\n", m);
  800050:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800054:	48 89 c6             	mov    %rax,%rsi
  800057:	48 bf 3c 52 80 00 00 	movabs $0x80523c,%rdi
  80005e:	00 00 00 
  800061:	b8 00 00 00 00       	mov    $0x0,%eax
  800066:	48 ba 5f 0f 80 00 00 	movabs $0x800f5f,%rdx
  80006d:	00 00 00 
  800070:	ff d2                	callq  *%rdx
	exit();
  800072:	48 b8 00 0d 80 00 00 	movabs $0x800d00,%rax
  800079:	00 00 00 
  80007c:	ff d0                	callq  *%rax
}
  80007e:	c9                   	leaveq 
  80007f:	c3                   	retq   

0000000000800080 <req_free>:

static void
req_free(struct http_request *req)
{
  800080:	55                   	push   %rbp
  800081:	48 89 e5             	mov    %rsp,%rbp
  800084:	48 83 ec 10          	sub    $0x10,%rsp
  800088:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	free(req->url);
  80008c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800090:	48 8b 40 08          	mov    0x8(%rax),%rax
  800094:	48 89 c7             	mov    %rax,%rdi
  800097:	48 b8 c1 40 80 00 00 	movabs $0x8040c1,%rax
  80009e:	00 00 00 
  8000a1:	ff d0                	callq  *%rax
	free(req->version);
  8000a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000a7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8000ab:	48 89 c7             	mov    %rax,%rdi
  8000ae:	48 b8 c1 40 80 00 00 	movabs $0x8040c1,%rax
  8000b5:	00 00 00 
  8000b8:	ff d0                	callq  *%rax
}
  8000ba:	c9                   	leaveq 
  8000bb:	c3                   	retq   

00000000008000bc <send_header>:

static int
send_header(struct http_request *req, int code)
{
  8000bc:	55                   	push   %rbp
  8000bd:	48 89 e5             	mov    %rsp,%rbp
  8000c0:	48 83 ec 20          	sub    $0x20,%rsp
  8000c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8000c8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	struct responce_header *h = headers;
  8000cb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000d2:	00 00 00 
  8000d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (h->code != 0 && h->header!= 0) {
  8000d9:	eb 10                	jmp    8000eb <send_header+0x2f>
		if (h->code == code)
  8000db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000df:	8b 00                	mov    (%rax),%eax
  8000e1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8000e4:	74 1e                	je     800104 <send_header+0x48>
			break;
		h++;
  8000e6:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
	while (h->code != 0 && h->header!= 0) {
  8000eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000ef:	8b 00                	mov    (%rax),%eax
  8000f1:	85 c0                	test   %eax,%eax
  8000f3:	74 10                	je     800105 <send_header+0x49>
  8000f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8000fd:	48 85 c0             	test   %rax,%rax
  800100:	75 d9                	jne    8000db <send_header+0x1f>
  800102:	eb 01                	jmp    800105 <send_header+0x49>
		if (h->code == code)
			break;
  800104:	90                   	nop
		h++;
	}

	if (h->code == 0)
  800105:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800109:	8b 00                	mov    (%rax),%eax
  80010b:	85 c0                	test   %eax,%eax
  80010d:	75 07                	jne    800116 <send_header+0x5a>
		return -1;
  80010f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800114:	eb 5f                	jmp    800175 <send_header+0xb9>

	int len = strlen(h->header);
  800116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80011a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80011e:	48 89 c7             	mov    %rax,%rdi
  800121:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  800128:	00 00 00 
  80012b:	ff d0                	callq  *%rax
  80012d:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (write(req->sock, h->header, len) != len) {
  800130:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800133:	48 63 d0             	movslq %eax,%rdx
  800136:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80013a:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80013e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800142:	8b 00                	mov    (%rax),%eax
  800144:	48 89 ce             	mov    %rcx,%rsi
  800147:	89 c7                	mov    %eax,%edi
  800149:	48 b8 fa 2d 80 00 00 	movabs $0x802dfa,%rax
  800150:	00 00 00 
  800153:	ff d0                	callq  *%rax
  800155:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800158:	74 16                	je     800170 <send_header+0xb4>
		die("Failed to send bytes to client");
  80015a:	48 bf 40 52 80 00 00 	movabs $0x805240,%rdi
  800161:	00 00 00 
  800164:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
	}

	return 0;
  800170:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800175:	c9                   	leaveq 
  800176:	c3                   	retq   

0000000000800177 <send_data>:

static int
send_data(struct http_request *req, int fd)
{
  800177:	55                   	push   %rbp
  800178:	48 89 e5             	mov    %rsp,%rbp
  80017b:	53                   	push   %rbx
  80017c:	48 81 ec d8 00 00 00 	sub    $0xd8,%rsp
  800183:	48 89 bd 38 ff ff ff 	mov    %rdi,-0xc8(%rbp)
  80018a:	89 b5 34 ff ff ff    	mov    %esi,-0xcc(%rbp)
  800190:	48 89 e0             	mov    %rsp,%rax
  800193:	48 89 c3             	mov    %rax,%rbx
	// LAB 6: Your code here.
	//cprintf("Inside send_data\n");
	int r,bufSize;
	struct Stat stat;
	r = fstat(fd,&stat);
  800196:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  80019d:	8b 85 34 ff ff ff    	mov    -0xcc(%rbp),%eax
  8001a3:	48 89 d6             	mov    %rdx,%rsi
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	48 b8 e3 2f 80 00 00 	movabs $0x802fe3,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax
  8001b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
	bufSize = stat.st_size;
  8001b7:	8b 45 c0             	mov    -0x40(%rbp),%eax
  8001ba:	89 45 e8             	mov    %eax,-0x18(%rbp)
	char buf[bufSize];
  8001bd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8001c0:	48 63 d0             	movslq %eax,%rdx
  8001c3:	48 83 ea 01          	sub    $0x1,%rdx
  8001c7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8001cb:	48 98                	cltq   
  8001cd:	48 8d 50 0f          	lea    0xf(%rax),%rdx
  8001d1:	b8 10 00 00 00       	mov    $0x10,%eax
  8001d6:	48 83 e8 01          	sub    $0x1,%rax
  8001da:	48 01 d0             	add    %rdx,%rax
  8001dd:	48 c7 85 28 ff ff ff 	movq   $0x10,-0xd8(%rbp)
  8001e4:	10 00 00 00 
  8001e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ed:	48 f7 b5 28 ff ff ff 	divq   -0xd8(%rbp)
  8001f4:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8001f8:	48 29 c4             	sub    %rax,%rsp
  8001fb:	48 89 e0             	mov    %rsp,%rax
  8001fe:	48 83 c0 0f          	add    $0xf,%rax
  800202:	48 c1 e8 04          	shr    $0x4,%rax
  800206:	48 c1 e0 04          	shl    $0x4,%rax
  80020a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	ssize_t nBytesRead = read(fd, buf, bufSize);
  80020e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800211:	48 63 d0             	movslq %eax,%rdx
  800214:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800218:	8b 85 34 ff ff ff    	mov    -0xcc(%rbp),%eax
  80021e:	48 89 ce             	mov    %rcx,%rsi
  800221:	89 c7                	mov    %eax,%edi
  800223:	48 b8 ac 2c 80 00 00 	movabs $0x802cac,%rax
  80022a:	00 00 00 
  80022d:	ff d0                	callq  *%rax
  80022f:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	if(nBytesRead < 0)
  800232:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800236:	79 16                	jns    80024e <send_data+0xd7>
		die("send_data:Read failed");
  800238:	48 bf 5f 52 80 00 00 	movabs $0x80525f,%rdi
  80023f:	00 00 00 
  800242:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800249:	00 00 00 
  80024c:	ff d0                	callq  *%rax
	if(write(req->sock, buf, nBytesRead) != nBytesRead)
  80024e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800251:	48 63 d0             	movslq %eax,%rdx
  800254:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800258:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  80025f:	8b 00                	mov    (%rax),%eax
  800261:	48 89 ce             	mov    %rcx,%rsi
  800264:	89 c7                	mov    %eax,%edi
  800266:	48 b8 fa 2d 80 00 00 	movabs $0x802dfa,%rax
  80026d:	00 00 00 
  800270:	ff d0                	callq  *%rax
  800272:	3b 45 d4             	cmp    -0x2c(%rbp),%eax
  800275:	74 16                	je     80028d <send_data+0x116>
		die("send_data:Did not write all the bytes");
  800277:	48 bf 78 52 80 00 00 	movabs $0x805278,%rdi
  80027e:	00 00 00 
  800281:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800288:	00 00 00 
  80028b:	ff d0                	callq  *%rax
	return 0;
  80028d:	b8 00 00 00 00       	mov    $0x0,%eax
  800292:	48 89 dc             	mov    %rbx,%rsp
}
  800295:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800299:	c9                   	leaveq 
  80029a:	c3                   	retq   

000000000080029b <send_size>:

static int
send_size(struct http_request *req, off_t size)
{
  80029b:	55                   	push   %rbp
  80029c:	48 89 e5             	mov    %rsp,%rbp
  80029f:	48 83 ec 60          	sub    $0x60,%rsp
  8002a3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8002a7:	89 75 a4             	mov    %esi,-0x5c(%rbp)
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  8002aa:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8002ad:	48 63 d0             	movslq %eax,%rdx
  8002b0:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8002b4:	48 89 d1             	mov    %rdx,%rcx
  8002b7:	48 ba 9e 52 80 00 00 	movabs $0x80529e,%rdx
  8002be:	00 00 00 
  8002c1:	be 40 00 00 00       	mov    $0x40,%esi
  8002c6:	48 89 c7             	mov    %rax,%rdi
  8002c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ce:	49 b8 ce 19 80 00 00 	movabs $0x8019ce,%r8
  8002d5:	00 00 00 
  8002d8:	41 ff d0             	callq  *%r8
  8002db:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r > 63)
  8002de:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  8002e2:	7e 2a                	jle    80030e <send_size+0x73>
		panic("buffer too small!");
  8002e4:	48 ba b4 52 80 00 00 	movabs $0x8052b4,%rdx
  8002eb:	00 00 00 
  8002ee:	be 66 00 00 00       	mov    $0x66,%esi
  8002f3:	48 bf c6 52 80 00 00 	movabs $0x8052c6,%rdi
  8002fa:	00 00 00 
  8002fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800302:	48 b9 24 0d 80 00 00 	movabs $0x800d24,%rcx
  800309:	00 00 00 
  80030c:	ff d1                	callq  *%rcx

	if (write(req->sock, buf, r) != r)
  80030e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800311:	48 63 d0             	movslq %eax,%rdx
  800314:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800318:	8b 00                	mov    (%rax),%eax
  80031a:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  80031e:	48 89 ce             	mov    %rcx,%rsi
  800321:	89 c7                	mov    %eax,%edi
  800323:	48 b8 fa 2d 80 00 00 	movabs $0x802dfa,%rax
  80032a:	00 00 00 
  80032d:	ff d0                	callq  *%rax
  80032f:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800332:	74 07                	je     80033b <send_size+0xa0>
		return -1;
  800334:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800339:	eb 05                	jmp    800340 <send_size+0xa5>

	return 0;
  80033b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800340:	c9                   	leaveq 
  800341:	c3                   	retq   

0000000000800342 <mime_type>:

static const char*
mime_type(const char *file)
{
  800342:	55                   	push   %rbp
  800343:	48 89 e5             	mov    %rsp,%rbp
  800346:	48 83 ec 08          	sub    $0x8,%rsp
  80034a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	//TODO: for now only a single mime type
	return "text/html";
  80034e:	48 b8 d3 52 80 00 00 	movabs $0x8052d3,%rax
  800355:	00 00 00 
}
  800358:	c9                   	leaveq 
  800359:	c3                   	retq   

000000000080035a <send_content_type>:

static int
send_content_type(struct http_request *req)
{
  80035a:	55                   	push   %rbp
  80035b:	48 89 e5             	mov    %rsp,%rbp
  80035e:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
  800365:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
	char buf[128];
	int r;
	const char *type;

	type = mime_type(req->url);
  80036c:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800373:	48 8b 40 08          	mov    0x8(%rax),%rax
  800377:	48 89 c7             	mov    %rax,%rdi
  80037a:	48 b8 42 03 80 00 00 	movabs $0x800342,%rax
  800381:	00 00 00 
  800384:	ff d0                	callq  *%rax
  800386:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!type)
  80038a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80038f:	75 0a                	jne    80039b <send_content_type+0x41>
		return -1;
  800391:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800396:	e9 9d 00 00 00       	jmpq   800438 <send_content_type+0xde>

	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  80039b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80039f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003a6:	48 89 d1             	mov    %rdx,%rcx
  8003a9:	48 ba dd 52 80 00 00 	movabs $0x8052dd,%rdx
  8003b0:	00 00 00 
  8003b3:	be 80 00 00 00       	mov    $0x80,%esi
  8003b8:	48 89 c7             	mov    %rax,%rdi
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c0:	49 b8 ce 19 80 00 00 	movabs $0x8019ce,%r8
  8003c7:	00 00 00 
  8003ca:	41 ff d0             	callq  *%r8
  8003cd:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (r > 127)
  8003d0:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  8003d4:	7e 2a                	jle    800400 <send_content_type+0xa6>
		panic("buffer too small!");
  8003d6:	48 ba b4 52 80 00 00 	movabs $0x8052b4,%rdx
  8003dd:	00 00 00 
  8003e0:	be 82 00 00 00       	mov    $0x82,%esi
  8003e5:	48 bf c6 52 80 00 00 	movabs $0x8052c6,%rdi
  8003ec:	00 00 00 
  8003ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f4:	48 b9 24 0d 80 00 00 	movabs $0x800d24,%rcx
  8003fb:	00 00 00 
  8003fe:	ff d1                	callq  *%rcx

	if (write(req->sock, buf, r) != r)
  800400:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800403:	48 63 d0             	movslq %eax,%rdx
  800406:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80040d:	8b 00                	mov    (%rax),%eax
  80040f:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  800416:	48 89 ce             	mov    %rcx,%rsi
  800419:	89 c7                	mov    %eax,%edi
  80041b:	48 b8 fa 2d 80 00 00 	movabs $0x802dfa,%rax
  800422:	00 00 00 
  800425:	ff d0                	callq  *%rax
  800427:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80042a:	74 07                	je     800433 <send_content_type+0xd9>
		return -1;
  80042c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800431:	eb 05                	jmp    800438 <send_content_type+0xde>

	return 0;
  800433:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800438:	c9                   	leaveq 
  800439:	c3                   	retq   

000000000080043a <send_header_fin>:

static int
send_header_fin(struct http_request *req)
{
  80043a:	55                   	push   %rbp
  80043b:	48 89 e5             	mov    %rsp,%rbp
  80043e:	48 83 ec 20          	sub    $0x20,%rsp
  800442:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	const char *fin = "\r\n";
  800446:	48 b8 f0 52 80 00 00 	movabs $0x8052f0,%rax
  80044d:	00 00 00 
  800450:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	int fin_len = strlen(fin);
  800454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800458:	48 89 c7             	mov    %rax,%rdi
  80045b:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  800462:	00 00 00 
  800465:	ff d0                	callq  *%rax
  800467:	89 45 f4             	mov    %eax,-0xc(%rbp)

	if (write(req->sock, fin, fin_len) != fin_len)
  80046a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80046d:	48 63 d0             	movslq %eax,%rdx
  800470:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800474:	8b 00                	mov    (%rax),%eax
  800476:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80047a:	48 89 ce             	mov    %rcx,%rsi
  80047d:	89 c7                	mov    %eax,%edi
  80047f:	48 b8 fa 2d 80 00 00 	movabs $0x802dfa,%rax
  800486:	00 00 00 
  800489:	ff d0                	callq  *%rax
  80048b:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80048e:	74 07                	je     800497 <send_header_fin+0x5d>
		return -1;
  800490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800495:	eb 05                	jmp    80049c <send_header_fin+0x62>

	return 0;
  800497:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80049c:	c9                   	leaveq 
  80049d:	c3                   	retq   

000000000080049e <http_request_parse>:

// given a request, this function creates a struct http_request
static int
http_request_parse(struct http_request *req, char *request)
{
  80049e:	55                   	push   %rbp
  80049f:	48 89 e5             	mov    %rsp,%rbp
  8004a2:	48 83 ec 30          	sub    $0x30,%rsp
  8004a6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8004aa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	const char *url;
	const char *version;
	int url_len, version_len;

	if (!req)
  8004ae:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8004b3:	75 0a                	jne    8004bf <http_request_parse+0x21>
		return -1;
  8004b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004ba:	e9 5d 01 00 00       	jmpq   80061c <http_request_parse+0x17e>

	if (strncmp(request, "GET ", 4) != 0)
  8004bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004c3:	ba 04 00 00 00       	mov    $0x4,%edx
  8004c8:	48 be f3 52 80 00 00 	movabs $0x8052f3,%rsi
  8004cf:	00 00 00 
  8004d2:	48 89 c7             	mov    %rax,%rdi
  8004d5:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  8004dc:	00 00 00 
  8004df:	ff d0                	callq  *%rax
  8004e1:	85 c0                	test   %eax,%eax
  8004e3:	74 0a                	je     8004ef <http_request_parse+0x51>
		return -E_BAD_REQ;
  8004e5:	b8 18 fc ff ff       	mov    $0xfffffc18,%eax
  8004ea:	e9 2d 01 00 00       	jmpq   80061c <http_request_parse+0x17e>

	// skip GET
	request += 4;
  8004ef:	48 83 45 d0 04       	addq   $0x4,-0x30(%rbp)

	// get the url
	url = request;
  8004f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (*request && *request != ' ')
  8004fc:	eb 05                	jmp    800503 <http_request_parse+0x65>
		request++;
  8004fe:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	// skip GET
	request += 4;

	// get the url
	url = request;
	while (*request && *request != ' ')
  800503:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800507:	0f b6 00             	movzbl (%rax),%eax
  80050a:	84 c0                	test   %al,%al
  80050c:	74 0b                	je     800519 <http_request_parse+0x7b>
  80050e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800512:	0f b6 00             	movzbl (%rax),%eax
  800515:	3c 20                	cmp    $0x20,%al
  800517:	75 e5                	jne    8004fe <http_request_parse+0x60>
		request++;
	url_len = request - url;
  800519:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80051d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800521:	48 89 d1             	mov    %rdx,%rcx
  800524:	48 29 c1             	sub    %rax,%rcx
  800527:	48 89 c8             	mov    %rcx,%rax
  80052a:	89 45 f4             	mov    %eax,-0xc(%rbp)

	req->url = malloc(url_len + 1);
  80052d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800530:	83 c0 01             	add    $0x1,%eax
  800533:	48 98                	cltq   
  800535:	48 89 c7             	mov    %rax,%rdi
  800538:	48 b8 41 3d 80 00 00 	movabs $0x803d41,%rax
  80053f:	00 00 00 
  800542:	ff d0                	callq  *%rax
  800544:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800548:	48 89 42 08          	mov    %rax,0x8(%rdx)
	memmove(req->url, url, url_len);
  80054c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80054f:	48 63 d0             	movslq %eax,%rdx
  800552:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800556:	48 8b 40 08          	mov    0x8(%rax),%rax
  80055a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80055e:	48 89 ce             	mov    %rcx,%rsi
  800561:	48 89 c7             	mov    %rax,%rdi
  800564:	48 b8 3e 1e 80 00 00 	movabs $0x801e3e,%rax
  80056b:	00 00 00 
  80056e:	ff d0                	callq  *%rax
	req->url[url_len] = '\0';
  800570:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800574:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800578:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80057b:	48 98                	cltq   
  80057d:	48 01 d0             	add    %rdx,%rax
  800580:	c6 00 00             	movb   $0x0,(%rax)

	// skip space
	request++;
  800583:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)

	version = request;
  800588:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80058c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	while (*request && *request != '\n')
  800590:	eb 05                	jmp    800597 <http_request_parse+0xf9>
		request++;
  800592:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)

	// skip space
	request++;

	version = request;
	while (*request && *request != '\n')
  800597:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80059b:	0f b6 00             	movzbl (%rax),%eax
  80059e:	84 c0                	test   %al,%al
  8005a0:	74 0b                	je     8005ad <http_request_parse+0x10f>
  8005a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8005a6:	0f b6 00             	movzbl (%rax),%eax
  8005a9:	3c 0a                	cmp    $0xa,%al
  8005ab:	75 e5                	jne    800592 <http_request_parse+0xf4>
		request++;
	version_len = request - version;
  8005ad:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8005b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b5:	48 89 d1             	mov    %rdx,%rcx
  8005b8:	48 29 c1             	sub    %rax,%rcx
  8005bb:	48 89 c8             	mov    %rcx,%rax
  8005be:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	req->version = malloc(version_len + 1);
  8005c1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005c4:	83 c0 01             	add    $0x1,%eax
  8005c7:	48 98                	cltq   
  8005c9:	48 89 c7             	mov    %rax,%rdi
  8005cc:	48 b8 41 3d 80 00 00 	movabs $0x803d41,%rax
  8005d3:	00 00 00 
  8005d6:	ff d0                	callq  *%rax
  8005d8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8005dc:	48 89 42 10          	mov    %rax,0x10(%rdx)
	memmove(req->version, version, version_len);
  8005e0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005e3:	48 63 d0             	movslq %eax,%rdx
  8005e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ea:	48 8b 40 10          	mov    0x10(%rax),%rax
  8005ee:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8005f2:	48 89 ce             	mov    %rcx,%rsi
  8005f5:	48 89 c7             	mov    %rax,%rdi
  8005f8:	48 b8 3e 1e 80 00 00 	movabs $0x801e3e,%rax
  8005ff:	00 00 00 
  800602:	ff d0                	callq  *%rax
	req->version[version_len] = '\0';
  800604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800608:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80060c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80060f:	48 98                	cltq   
  800611:	48 01 d0             	add    %rdx,%rax
  800614:	c6 00 00             	movb   $0x0,(%rax)

	// no entity parsing

	return 0;
  800617:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80061c:	c9                   	leaveq 
  80061d:	c3                   	retq   

000000000080061e <send_error>:

static int
send_error(struct http_request *req, int code)
{
  80061e:	55                   	push   %rbp
  80061f:	48 89 e5             	mov    %rsp,%rbp
  800622:	48 81 ec 30 02 00 00 	sub    $0x230,%rsp
  800629:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  800630:	89 b5 e4 fd ff ff    	mov    %esi,-0x21c(%rbp)
	char buf[512];
	int r;

	struct error_messages *e = errors;
  800636:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80063d:	00 00 00 
  800640:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->code != 0 && e->msg != 0) {
  800644:	eb 13                	jmp    800659 <send_error+0x3b>
		if (e->code == code)
  800646:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80064a:	8b 00                	mov    (%rax),%eax
  80064c:	3b 85 e4 fd ff ff    	cmp    -0x21c(%rbp),%eax
  800652:	74 1e                	je     800672 <send_error+0x54>
			break;
		e++;
  800654:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)
{
	char buf[512];
	int r;

	struct error_messages *e = errors;
	while (e->code != 0 && e->msg != 0) {
  800659:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80065d:	8b 00                	mov    (%rax),%eax
  80065f:	85 c0                	test   %eax,%eax
  800661:	74 10                	je     800673 <send_error+0x55>
  800663:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800667:	48 8b 40 08          	mov    0x8(%rax),%rax
  80066b:	48 85 c0             	test   %rax,%rax
  80066e:	75 d6                	jne    800646 <send_error+0x28>
  800670:	eb 01                	jmp    800673 <send_error+0x55>
		if (e->code == code)
			break;
  800672:	90                   	nop
		e++;
	}

	if (e->code == 0)
  800673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800677:	8b 00                	mov    (%rax),%eax
  800679:	85 c0                	test   %eax,%eax
  80067b:	75 0a                	jne    800687 <send_error+0x69>
		return -1;
  80067d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800682:	e9 8e 00 00 00       	jmpq   800715 <send_error+0xf7>
			       "Server: jhttpd/" VERSION "\r\n"
			       "Connection: close"
			       "Content-type: text/html\r\n"
			       "\r\n"
			       "<html><body><p>%d - %s</p></body></html>\r\n",
			       e->code, e->msg, e->code, e->msg);
  800687:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
	}

	if (e->code == 0)
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  80068b:	48 8b 48 08          	mov    0x8(%rax),%rcx
			       "Server: jhttpd/" VERSION "\r\n"
			       "Connection: close"
			       "Content-type: text/html\r\n"
			       "\r\n"
			       "<html><body><p>%d - %s</p></body></html>\r\n",
			       e->code, e->msg, e->code, e->msg);
  80068f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
	}

	if (e->code == 0)
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  800693:	8b 38                	mov    (%rax),%edi
			       "Server: jhttpd/" VERSION "\r\n"
			       "Connection: close"
			       "Content-type: text/html\r\n"
			       "\r\n"
			       "<html><body><p>%d - %s</p></body></html>\r\n",
			       e->code, e->msg, e->code, e->msg);
  800695:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
	}

	if (e->code == 0)
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  800699:	48 8b 70 08          	mov    0x8(%rax),%rsi
			       "Server: jhttpd/" VERSION "\r\n"
			       "Connection: close"
			       "Content-type: text/html\r\n"
			       "\r\n"
			       "<html><body><p>%d - %s</p></body></html>\r\n",
			       e->code, e->msg, e->code, e->msg);
  80069d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
	}

	if (e->code == 0)
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  8006a1:	8b 10                	mov    (%rax),%edx
  8006a3:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  8006aa:	48 89 0c 24          	mov    %rcx,(%rsp)
  8006ae:	41 89 f9             	mov    %edi,%r9d
  8006b1:	49 89 f0             	mov    %rsi,%r8
  8006b4:	89 d1                	mov    %edx,%ecx
  8006b6:	48 ba f8 52 80 00 00 	movabs $0x8052f8,%rdx
  8006bd:	00 00 00 
  8006c0:	be 00 02 00 00       	mov    $0x200,%esi
  8006c5:	48 89 c7             	mov    %rax,%rdi
  8006c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8006cd:	49 ba ce 19 80 00 00 	movabs $0x8019ce,%r10
  8006d4:	00 00 00 
  8006d7:	41 ff d2             	callq  *%r10
  8006da:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "Content-type: text/html\r\n"
			       "\r\n"
			       "<html><body><p>%d - %s</p></body></html>\r\n",
			       e->code, e->msg, e->code, e->msg);

	if (write(req->sock, buf, r) != r)
  8006dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8006e0:	48 63 d0             	movslq %eax,%rdx
  8006e3:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8006ea:	8b 00                	mov    (%rax),%eax
  8006ec:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8006f3:	48 89 ce             	mov    %rcx,%rsi
  8006f6:	89 c7                	mov    %eax,%edi
  8006f8:	48 b8 fa 2d 80 00 00 	movabs $0x802dfa,%rax
  8006ff:	00 00 00 
  800702:	ff d0                	callq  *%rax
  800704:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800707:	74 07                	je     800710 <send_error+0xf2>
		return -1;
  800709:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80070e:	eb 05                	jmp    800715 <send_error+0xf7>

	return 0;
  800710:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800715:	c9                   	leaveq 
  800716:	c3                   	retq   

0000000000800717 <send_file>:

static int
send_file(struct http_request *req)
{
  800717:	55                   	push   %rbp
  800718:	48 89 e5             	mov    %rsp,%rbp
  80071b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800722:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
	int r;
	off_t file_size = -1;
  800729:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	// if the file does not exist, send a 404 error using send_error
	// if the file is a directory, send a 404 error using send_error
	// set file_size to the size of the file

	// LAB 6: Your code here.
	fd = open(req->url, O_RDONLY);
  800730:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800737:	48 8b 40 08          	mov    0x8(%rax),%rax
  80073b:	be 00 00 00 00       	mov    $0x0,%esi
  800740:	48 89 c7             	mov    %rax,%rdi
  800743:	48 b8 8b 31 80 00 00 	movabs $0x80318b,%rax
  80074a:	00 00 00 
  80074d:	ff d0                	callq  *%rax
  80074f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//struct Fd *open_file = INDEX2FD(i);	
	if(fd < 0)
  800752:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800756:	79 6d                	jns    8007c5 <send_file+0xae>
	{
		cprintf("file %s does not exists\n",req->url);
  800758:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80075f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800763:	48 89 c6             	mov    %rax,%rsi
  800766:	48 bf 73 53 80 00 00 	movabs $0x805373,%rdi
  80076d:	00 00 00 
  800770:	b8 00 00 00 00       	mov    $0x0,%eax
  800775:	48 ba 5f 0f 80 00 00 	movabs $0x800f5f,%rdx
  80077c:	00 00 00 
  80077f:	ff d2                	callq  *%rdx
		r = send_error(req, 404);
  800781:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800788:	be 94 01 00 00       	mov    $0x194,%esi
  80078d:	48 89 c7             	mov    %rax,%rdi
  800790:	48 b8 1e 06 80 00 00 	movabs $0x80061e,%rax
  800797:	00 00 00 
  80079a:	ff d0                	callq  *%rax
  80079c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0)
  80079f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007a3:	79 20                	jns    8007c5 <send_file+0xae>
			cprintf("send_file:send_error failed:%e\n",r);
  8007a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007a8:	89 c6                	mov    %eax,%esi
  8007aa:	48 bf 90 53 80 00 00 	movabs $0x805390,%rdi
  8007b1:	00 00 00 
  8007b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b9:	48 ba 5f 0f 80 00 00 	movabs $0x800f5f,%rdx
  8007c0:	00 00 00 
  8007c3:	ff d2                	callq  *%rdx
	}
	r = fstat(fd, &stat);
  8007c5:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  8007cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8007cf:	48 89 d6             	mov    %rdx,%rsi
  8007d2:	89 c7                	mov    %eax,%edi
  8007d4:	48 b8 e3 2f 80 00 00 	movabs $0x802fe3,%rax
  8007db:	00 00 00 
  8007de:	ff d0                	callq  *%rax
  8007e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  8007e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007e7:	79 3e                	jns    800827 <send_file+0x110>
	{
		cprintf("send_file:fstat failed:%e\n",r);
  8007e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007ec:	89 c6                	mov    %eax,%esi
  8007ee:	48 bf b0 53 80 00 00 	movabs $0x8053b0,%rdi
  8007f5:	00 00 00 
  8007f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fd:	48 ba 5f 0f 80 00 00 	movabs $0x800f5f,%rdx
  800804:	00 00 00 
  800807:	ff d2                	callq  *%rdx
		r = send_error(req, 404);
  800809:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800810:	be 94 01 00 00       	mov    $0x194,%esi
  800815:	48 89 c7             	mov    %rax,%rdi
  800818:	48 b8 1e 06 80 00 00 	movabs $0x80061e,%rax
  80081f:	00 00 00 
  800822:	ff d0                	callq  *%rax
  800824:	89 45 fc             	mov    %eax,-0x4(%rbp)
	}
	if(stat.st_isdir == 1)
  800827:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80082a:	83 f8 01             	cmp    $0x1,%eax
  80082d:	75 6d                	jne    80089c <send_file+0x185>
	{
		cprintf("file %s is a directory\n",req->url);
  80082f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800836:	48 8b 40 08          	mov    0x8(%rax),%rax
  80083a:	48 89 c6             	mov    %rax,%rsi
  80083d:	48 bf cb 53 80 00 00 	movabs $0x8053cb,%rdi
  800844:	00 00 00 
  800847:	b8 00 00 00 00       	mov    $0x0,%eax
  80084c:	48 ba 5f 0f 80 00 00 	movabs $0x800f5f,%rdx
  800853:	00 00 00 
  800856:	ff d2                	callq  *%rdx
		 r = send_error(req, 404);
  800858:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80085f:	be 94 01 00 00       	mov    $0x194,%esi
  800864:	48 89 c7             	mov    %rax,%rdi
  800867:	48 b8 1e 06 80 00 00 	movabs $0x80061e,%rax
  80086e:	00 00 00 
  800871:	ff d0                	callq  *%rax
  800873:	89 45 fc             	mov    %eax,-0x4(%rbp)
                if(r<0)
  800876:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80087a:	79 20                	jns    80089c <send_file+0x185>
                        cprintf("send_file:send_error failed:%e\n",r);
  80087c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80087f:	89 c6                	mov    %eax,%esi
  800881:	48 bf 90 53 80 00 00 	movabs $0x805390,%rdi
  800888:	00 00 00 
  80088b:	b8 00 00 00 00       	mov    $0x0,%eax
  800890:	48 ba 5f 0f 80 00 00 	movabs $0x800f5f,%rdx
  800897:	00 00 00 
  80089a:	ff d2                	callq  *%rdx
	}
	file_size = stat.st_size;
  80089c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80089f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	
	if ((r = send_header(req, 200)) < 0)
  8008a2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8008a9:	be c8 00 00 00       	mov    $0xc8,%esi
  8008ae:	48 89 c7             	mov    %rax,%rdi
  8008b1:	48 b8 bc 00 80 00 00 	movabs $0x8000bc,%rax
  8008b8:	00 00 00 
  8008bb:	ff d0                	callq  *%rax
  8008bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008c4:	0f 88 82 00 00 00    	js     80094c <send_file+0x235>
		goto end;

	if ((r = send_size(req, file_size)) < 0)
  8008ca:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8008cd:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8008d4:	89 d6                	mov    %edx,%esi
  8008d6:	48 89 c7             	mov    %rax,%rdi
  8008d9:	48 b8 9b 02 80 00 00 	movabs $0x80029b,%rax
  8008e0:	00 00 00 
  8008e3:	ff d0                	callq  *%rax
  8008e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008ec:	78 61                	js     80094f <send_file+0x238>
		goto end;

	if ((r = send_content_type(req)) < 0)
  8008ee:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8008f5:	48 89 c7             	mov    %rax,%rdi
  8008f8:	48 b8 5a 03 80 00 00 	movabs $0x80035a,%rax
  8008ff:	00 00 00 
  800902:	ff d0                	callq  *%rax
  800904:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800907:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80090b:	78 45                	js     800952 <send_file+0x23b>
		goto end;

	if ((r = send_header_fin(req)) < 0)
  80090d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800914:	48 89 c7             	mov    %rax,%rdi
  800917:	48 b8 3a 04 80 00 00 	movabs $0x80043a,%rax
  80091e:	00 00 00 
  800921:	ff d0                	callq  *%rax
  800923:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800926:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80092a:	78 29                	js     800955 <send_file+0x23e>
		goto end;

	r = send_data(req, fd);
  80092c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80092f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800936:	89 d6                	mov    %edx,%esi
  800938:	48 89 c7             	mov    %rax,%rdi
  80093b:	48 b8 77 01 80 00 00 	movabs $0x800177,%rax
  800942:	00 00 00 
  800945:	ff d0                	callq  *%rax
  800947:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80094a:	eb 0a                	jmp    800956 <send_file+0x23f>
                        cprintf("send_file:send_error failed:%e\n",r);
	}
	file_size = stat.st_size;
	
	if ((r = send_header(req, 200)) < 0)
		goto end;
  80094c:	90                   	nop
  80094d:	eb 07                	jmp    800956 <send_file+0x23f>

	if ((r = send_size(req, file_size)) < 0)
		goto end;
  80094f:	90                   	nop
  800950:	eb 04                	jmp    800956 <send_file+0x23f>

	if ((r = send_content_type(req)) < 0)
		goto end;
  800952:	90                   	nop
  800953:	eb 01                	jmp    800956 <send_file+0x23f>

	if ((r = send_header_fin(req)) < 0)
		goto end;
  800955:	90                   	nop

	r = send_data(req, fd);

end:
	close(fd);
  800956:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800959:	89 c7                	mov    %eax,%edi
  80095b:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  800962:	00 00 00 
  800965:	ff d0                	callq  *%rax
	return r;
  800967:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80096a:	c9                   	leaveq 
  80096b:	c3                   	retq   

000000000080096c <handle_client>:

static void
handle_client(int sock)
{
  80096c:	55                   	push   %rbp
  80096d:	48 89 e5             	mov    %rsp,%rbp
  800970:	48 81 ec 40 02 00 00 	sub    $0x240,%rsp
  800977:	89 bd cc fd ff ff    	mov    %edi,-0x234(%rbp)
	struct http_request con_d;
	int r;
	char buffer[BUFFSIZE];
	int received = -1;
  80097d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	struct http_request *req = &con_d;
  800984:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800988:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80098c:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  800993:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  800999:	ba 00 02 00 00       	mov    $0x200,%edx
  80099e:	48 89 ce             	mov    %rcx,%rsi
  8009a1:	89 c7                	mov    %eax,%edi
  8009a3:	48 b8 ac 2c 80 00 00 	movabs $0x802cac,%rax
  8009aa:	00 00 00 
  8009ad:	ff d0                	callq  *%rax
  8009af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009b6:	79 2a                	jns    8009e2 <handle_client+0x76>
			panic("failed to read");
  8009b8:	48 ba e3 53 80 00 00 	movabs $0x8053e3,%rdx
  8009bf:	00 00 00 
  8009c2:	be 25 01 00 00       	mov    $0x125,%esi
  8009c7:	48 bf c6 52 80 00 00 	movabs $0x8052c6,%rdi
  8009ce:	00 00 00 
  8009d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d6:	48 b9 24 0d 80 00 00 	movabs $0x800d24,%rcx
  8009dd:	00 00 00 
  8009e0:	ff d1                	callq  *%rcx

		memset(req, 0, sizeof(req));
  8009e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009e6:	ba 08 00 00 00       	mov    $0x8,%edx
  8009eb:	be 00 00 00 00       	mov    $0x0,%esi
  8009f0:	48 89 c7             	mov    %rax,%rdi
  8009f3:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  8009fa:	00 00 00 
  8009fd:	ff d0                	callq  *%rax

		req->sock = sock;
  8009ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a03:	8b 95 cc fd ff ff    	mov    -0x234(%rbp),%edx
  800a09:	89 10                	mov    %edx,(%rax)

		r = http_request_parse(req, buffer);
  800a0b:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  800a12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a16:	48 89 d6             	mov    %rdx,%rsi
  800a19:	48 89 c7             	mov    %rax,%rdi
  800a1c:	48 b8 9e 04 80 00 00 	movabs $0x80049e,%rax
  800a23:	00 00 00 
  800a26:	ff d0                	callq  *%rax
  800a28:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r == -E_BAD_REQ)
  800a2b:	81 7d ec 18 fc ff ff 	cmpl   $0xfffffc18,-0x14(%rbp)
  800a32:	75 1a                	jne    800a4e <handle_client+0xe2>
			send_error(req, 400);
  800a34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a38:	be 90 01 00 00       	mov    $0x190,%esi
  800a3d:	48 89 c7             	mov    %rax,%rdi
  800a40:	48 b8 1e 06 80 00 00 	movabs $0x80061e,%rax
  800a47:	00 00 00 
  800a4a:	ff d0                	callq  *%rax
  800a4c:	eb 43                	jmp    800a91 <handle_client+0x125>
		else if (r < 0)
  800a4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800a52:	79 2a                	jns    800a7e <handle_client+0x112>
			panic("parse failed");
  800a54:	48 ba f2 53 80 00 00 	movabs $0x8053f2,%rdx
  800a5b:	00 00 00 
  800a5e:	be 2f 01 00 00       	mov    $0x12f,%esi
  800a63:	48 bf c6 52 80 00 00 	movabs $0x8052c6,%rdi
  800a6a:	00 00 00 
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a72:	48 b9 24 0d 80 00 00 	movabs $0x800d24,%rcx
  800a79:	00 00 00 
  800a7c:	ff d1                	callq  *%rcx
		else
			send_file(req);
  800a7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a82:	48 89 c7             	mov    %rax,%rdi
  800a85:	48 b8 17 07 80 00 00 	movabs $0x800717,%rax
  800a8c:	00 00 00 
  800a8f:	ff d0                	callq  *%rax

		req_free(req);
  800a91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a95:	48 89 c7             	mov    %rax,%rdi
  800a98:	48 b8 80 00 80 00 00 	movabs $0x800080,%rax
  800a9f:	00 00 00 
  800aa2:	ff d0                	callq  *%rax

		// no keep alive
		break;
  800aa4:	90                   	nop
	}

	close(sock);
  800aa5:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  800aab:	89 c7                	mov    %eax,%edi
  800aad:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  800ab4:	00 00 00 
  800ab7:	ff d0                	callq  *%rax
}
  800ab9:	c9                   	leaveq 
  800aba:	c3                   	retq   

0000000000800abb <umain>:

void
umain(int argc, char **argv)
{
  800abb:	55                   	push   %rbp
  800abc:	48 89 e5             	mov    %rsp,%rbp
  800abf:	48 83 ec 50          	sub    $0x50,%rsp
  800ac3:	89 7d bc             	mov    %edi,-0x44(%rbp)
  800ac6:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  800aca:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800ad1:	00 00 00 
  800ad4:	48 ba ff 53 80 00 00 	movabs $0x8053ff,%rdx
  800adb:	00 00 00 
  800ade:	48 89 10             	mov    %rdx,(%rax)

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800ae1:	ba 06 00 00 00       	mov    $0x6,%edx
  800ae6:	be 01 00 00 00       	mov    $0x1,%esi
  800aeb:	bf 02 00 00 00       	mov    $0x2,%edi
  800af0:	48 b8 11 38 80 00 00 	movabs $0x803811,%rax
  800af7:	00 00 00 
  800afa:	ff d0                	callq  *%rax
  800afc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800aff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b03:	79 16                	jns    800b1b <umain+0x60>
		die("Failed to create socket");
  800b05:	48 bf 06 54 80 00 00 	movabs $0x805406,%rdi
  800b0c:	00 00 00 
  800b0f:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800b16:	00 00 00 
  800b19:	ff d0                	callq  *%rax

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  800b1b:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800b1f:	ba 10 00 00 00       	mov    $0x10,%edx
  800b24:	be 00 00 00 00       	mov    $0x0,%esi
  800b29:	48 89 c7             	mov    %rax,%rdi
  800b2c:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  800b33:	00 00 00 
  800b36:	ff d0                	callq  *%rax
	server.sin_family = AF_INET;			// Internet/IP
  800b38:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  800b3c:	bf 00 00 00 00       	mov    $0x0,%edi
  800b41:	48 b8 91 51 80 00 00 	movabs $0x805191,%rax
  800b48:	00 00 00 
  800b4b:	ff d0                	callq  *%rax
  800b4d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	server.sin_port = htons(PORT);			// server port
  800b50:	bf 50 00 00 00       	mov    $0x50,%edi
  800b55:	48 b8 4c 51 80 00 00 	movabs $0x80514c,%rax
  800b5c:	00 00 00 
  800b5f:	ff d0                	callq  *%rax
  800b61:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  800b65:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  800b69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b6c:	ba 10 00 00 00       	mov    $0x10,%edx
  800b71:	48 89 ce             	mov    %rcx,%rsi
  800b74:	89 c7                	mov    %eax,%edi
  800b76:	48 b8 01 36 80 00 00 	movabs $0x803601,%rax
  800b7d:	00 00 00 
  800b80:	ff d0                	callq  *%rax
  800b82:	85 c0                	test   %eax,%eax
  800b84:	79 16                	jns    800b9c <umain+0xe1>
		 sizeof(server)) < 0)
	{
		die("Failed to bind the server socket");
  800b86:	48 bf 20 54 80 00 00 	movabs $0x805420,%rdi
  800b8d:	00 00 00 
  800b90:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800b97:	00 00 00 
  800b9a:	ff d0                	callq  *%rax
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800b9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b9f:	be 05 00 00 00       	mov    $0x5,%esi
  800ba4:	89 c7                	mov    %eax,%edi
  800ba6:	48 b8 24 37 80 00 00 	movabs $0x803724,%rax
  800bad:	00 00 00 
  800bb0:	ff d0                	callq  *%rax
  800bb2:	85 c0                	test   %eax,%eax
  800bb4:	79 16                	jns    800bcc <umain+0x111>
		die("Failed to listen on server socket");
  800bb6:	48 bf 48 54 80 00 00 	movabs $0x805448,%rdi
  800bbd:	00 00 00 
  800bc0:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800bc7:	00 00 00 
  800bca:	ff d0                	callq  *%rax

	cprintf("Waiting for http connections...\n");
  800bcc:	48 bf 70 54 80 00 00 	movabs $0x805470,%rdi
  800bd3:	00 00 00 
  800bd6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdb:	48 ba 5f 0f 80 00 00 	movabs $0x800f5f,%rdx
  800be2:	00 00 00 
  800be5:	ff d2                	callq  *%rdx

	while (1) {
		unsigned int clientlen = sizeof(client);
  800be7:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
		// Wait for client connection
		if ((clientsock = accept(serversock,
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
  800bee:	48 8d 55 cc          	lea    -0x34(%rbp),%rdx

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
					 (struct sockaddr *) &client,
  800bf2:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
	cprintf("Waiting for http connections...\n");

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bf9:	48 89 ce             	mov    %rcx,%rsi
  800bfc:	89 c7                	mov    %eax,%edi
  800bfe:	48 b8 92 35 80 00 00 	movabs $0x803592,%rax
  800c05:	00 00 00 
  800c08:	ff d0                	callq  *%rax
  800c0a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800c0d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c11:	79 16                	jns    800c29 <umain+0x16e>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800c13:	48 bf 98 54 80 00 00 	movabs $0x805498,%rdi
  800c1a:	00 00 00 
  800c1d:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800c24:	00 00 00 
  800c27:	ff d0                	callq  *%rax
		}
		cprintf("\nAccepted client socket:%d\n",clientsock);
  800c29:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c2c:	89 c6                	mov    %eax,%esi
  800c2e:	48 bf bb 54 80 00 00 	movabs $0x8054bb,%rdi
  800c35:	00 00 00 
  800c38:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3d:	48 ba 5f 0f 80 00 00 	movabs $0x800f5f,%rdx
  800c44:	00 00 00 
  800c47:	ff d2                	callq  *%rdx
		handle_client(clientsock);
  800c49:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c4c:	89 c7                	mov    %eax,%edi
  800c4e:	48 b8 6c 09 80 00 00 	movabs $0x80096c,%rax
  800c55:	00 00 00 
  800c58:	ff d0                	callq  *%rax
	}
  800c5a:	eb 8b                	jmp    800be7 <umain+0x12c>

0000000000800c5c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800c5c:	55                   	push   %rbp
  800c5d:	48 89 e5             	mov    %rsp,%rbp
  800c60:	48 83 ec 10          	sub    $0x10,%rsp
  800c64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800c6b:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  800c72:	00 00 00 
  800c75:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800c7c:	48 b8 d8 23 80 00 00 	movabs $0x8023d8,%rax
  800c83:	00 00 00 
  800c86:	ff d0                	callq  *%rax
  800c88:	48 98                	cltq   
  800c8a:	48 89 c2             	mov    %rax,%rdx
  800c8d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800c93:	48 89 d0             	mov    %rdx,%rax
  800c96:	48 c1 e0 03          	shl    $0x3,%rax
  800c9a:	48 01 d0             	add    %rdx,%rax
  800c9d:	48 c1 e0 05          	shl    $0x5,%rax
  800ca1:	48 89 c2             	mov    %rax,%rdx
  800ca4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800cab:	00 00 00 
  800cae:	48 01 c2             	add    %rax,%rdx
  800cb1:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  800cb8:	00 00 00 
  800cbb:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800cbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cc2:	7e 14                	jle    800cd8 <libmain+0x7c>
		binaryname = argv[0];
  800cc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc8:	48 8b 10             	mov    (%rax),%rdx
  800ccb:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800cd2:	00 00 00 
  800cd5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800cd8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cdf:	48 89 d6             	mov    %rdx,%rsi
  800ce2:	89 c7                	mov    %eax,%edi
  800ce4:	48 b8 bb 0a 80 00 00 	movabs $0x800abb,%rax
  800ceb:	00 00 00 
  800cee:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800cf0:	48 b8 00 0d 80 00 00 	movabs $0x800d00,%rax
  800cf7:	00 00 00 
  800cfa:	ff d0                	callq  *%rax
}
  800cfc:	c9                   	leaveq 
  800cfd:	c3                   	retq   
	...

0000000000800d00 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800d00:	55                   	push   %rbp
  800d01:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800d04:	48 b8 d5 2a 80 00 00 	movabs $0x802ad5,%rax
  800d0b:	00 00 00 
  800d0e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800d10:	bf 00 00 00 00       	mov    $0x0,%edi
  800d15:	48 b8 94 23 80 00 00 	movabs $0x802394,%rax
  800d1c:	00 00 00 
  800d1f:	ff d0                	callq  *%rax
}
  800d21:	5d                   	pop    %rbp
  800d22:	c3                   	retq   
	...

0000000000800d24 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d24:	55                   	push   %rbp
  800d25:	48 89 e5             	mov    %rsp,%rbp
  800d28:	53                   	push   %rbx
  800d29:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800d30:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800d37:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800d3d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800d44:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800d4b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800d52:	84 c0                	test   %al,%al
  800d54:	74 23                	je     800d79 <_panic+0x55>
  800d56:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800d5d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800d61:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800d65:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800d69:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800d6d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800d71:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800d75:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800d79:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d80:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800d87:	00 00 00 
  800d8a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800d91:	00 00 00 
  800d94:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d98:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800d9f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800da6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800dad:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800db4:	00 00 00 
  800db7:	48 8b 18             	mov    (%rax),%rbx
  800dba:	48 b8 d8 23 80 00 00 	movabs $0x8023d8,%rax
  800dc1:	00 00 00 
  800dc4:	ff d0                	callq  *%rax
  800dc6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800dcc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dd3:	41 89 c8             	mov    %ecx,%r8d
  800dd6:	48 89 d1             	mov    %rdx,%rcx
  800dd9:	48 89 da             	mov    %rbx,%rdx
  800ddc:	89 c6                	mov    %eax,%esi
  800dde:	48 bf e8 54 80 00 00 	movabs $0x8054e8,%rdi
  800de5:	00 00 00 
  800de8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ded:	49 b9 5f 0f 80 00 00 	movabs $0x800f5f,%r9
  800df4:	00 00 00 
  800df7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800dfa:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800e01:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e08:	48 89 d6             	mov    %rdx,%rsi
  800e0b:	48 89 c7             	mov    %rax,%rdi
  800e0e:	48 b8 b3 0e 80 00 00 	movabs $0x800eb3,%rax
  800e15:	00 00 00 
  800e18:	ff d0                	callq  *%rax
	cprintf("\n");
  800e1a:	48 bf 0b 55 80 00 00 	movabs $0x80550b,%rdi
  800e21:	00 00 00 
  800e24:	b8 00 00 00 00       	mov    $0x0,%eax
  800e29:	48 ba 5f 0f 80 00 00 	movabs $0x800f5f,%rdx
  800e30:	00 00 00 
  800e33:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e35:	cc                   	int3   
  800e36:	eb fd                	jmp    800e35 <_panic+0x111>

0000000000800e38 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800e38:	55                   	push   %rbp
  800e39:	48 89 e5             	mov    %rsp,%rbp
  800e3c:	48 83 ec 10          	sub    $0x10,%rsp
  800e40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800e47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4b:	8b 00                	mov    (%rax),%eax
  800e4d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e50:	89 d6                	mov    %edx,%esi
  800e52:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800e56:	48 63 d0             	movslq %eax,%rdx
  800e59:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800e5e:	8d 50 01             	lea    0x1(%rax),%edx
  800e61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e65:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800e67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6b:	8b 00                	mov    (%rax),%eax
  800e6d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e72:	75 2c                	jne    800ea0 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800e74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e78:	8b 00                	mov    (%rax),%eax
  800e7a:	48 98                	cltq   
  800e7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e80:	48 83 c2 08          	add    $0x8,%rdx
  800e84:	48 89 c6             	mov    %rax,%rsi
  800e87:	48 89 d7             	mov    %rdx,%rdi
  800e8a:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  800e91:	00 00 00 
  800e94:	ff d0                	callq  *%rax
		b->idx = 0;
  800e96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800ea0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea4:	8b 40 04             	mov    0x4(%rax),%eax
  800ea7:	8d 50 01             	lea    0x1(%rax),%edx
  800eaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eae:	89 50 04             	mov    %edx,0x4(%rax)
}
  800eb1:	c9                   	leaveq 
  800eb2:	c3                   	retq   

0000000000800eb3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800eb3:	55                   	push   %rbp
  800eb4:	48 89 e5             	mov    %rsp,%rbp
  800eb7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800ebe:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ec5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800ecc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800ed3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800eda:	48 8b 0a             	mov    (%rdx),%rcx
  800edd:	48 89 08             	mov    %rcx,(%rax)
  800ee0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ee4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ee8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eec:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800ef0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800ef7:	00 00 00 
	b.cnt = 0;
  800efa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800f01:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800f04:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800f0b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800f12:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800f19:	48 89 c6             	mov    %rax,%rsi
  800f1c:	48 bf 38 0e 80 00 00 	movabs $0x800e38,%rdi
  800f23:	00 00 00 
  800f26:	48 b8 10 13 80 00 00 	movabs $0x801310,%rax
  800f2d:	00 00 00 
  800f30:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800f32:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800f38:	48 98                	cltq   
  800f3a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800f41:	48 83 c2 08          	add    $0x8,%rdx
  800f45:	48 89 c6             	mov    %rax,%rsi
  800f48:	48 89 d7             	mov    %rdx,%rdi
  800f4b:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  800f52:	00 00 00 
  800f55:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800f57:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800f5d:	c9                   	leaveq 
  800f5e:	c3                   	retq   

0000000000800f5f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800f5f:	55                   	push   %rbp
  800f60:	48 89 e5             	mov    %rsp,%rbp
  800f63:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800f6a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800f71:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800f78:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f7f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f86:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f8d:	84 c0                	test   %al,%al
  800f8f:	74 20                	je     800fb1 <cprintf+0x52>
  800f91:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f95:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f99:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f9d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fa1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fa5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fa9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fad:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fb1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800fb8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800fbf:	00 00 00 
  800fc2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fc9:	00 00 00 
  800fcc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fd0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fd7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fde:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fe5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fec:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ff3:	48 8b 0a             	mov    (%rdx),%rcx
  800ff6:	48 89 08             	mov    %rcx,(%rax)
  800ff9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ffd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801001:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801005:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  801009:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801010:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801017:	48 89 d6             	mov    %rdx,%rsi
  80101a:	48 89 c7             	mov    %rax,%rdi
  80101d:	48 b8 b3 0e 80 00 00 	movabs $0x800eb3,%rax
  801024:	00 00 00 
  801027:	ff d0                	callq  *%rax
  801029:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80102f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801035:	c9                   	leaveq 
  801036:	c3                   	retq   
	...

0000000000801038 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801038:	55                   	push   %rbp
  801039:	48 89 e5             	mov    %rsp,%rbp
  80103c:	48 83 ec 30          	sub    $0x30,%rsp
  801040:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801044:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801048:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80104c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80104f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  801053:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801057:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80105a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80105e:	77 52                	ja     8010b2 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801060:	8b 45 e0             	mov    -0x20(%rbp),%eax
  801063:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801067:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80106a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80106e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801072:	ba 00 00 00 00       	mov    $0x0,%edx
  801077:	48 f7 75 d0          	divq   -0x30(%rbp)
  80107b:	48 89 c2             	mov    %rax,%rdx
  80107e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801081:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801084:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801088:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108c:	41 89 f9             	mov    %edi,%r9d
  80108f:	48 89 c7             	mov    %rax,%rdi
  801092:	48 b8 38 10 80 00 00 	movabs $0x801038,%rax
  801099:	00 00 00 
  80109c:	ff d0                	callq  *%rax
  80109e:	eb 1c                	jmp    8010bc <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8010a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010a4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8010a7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8010ab:	48 89 d6             	mov    %rdx,%rsi
  8010ae:	89 c7                	mov    %eax,%edi
  8010b0:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010b2:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8010b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8010ba:	7f e4                	jg     8010a0 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010bc:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8010bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c8:	48 f7 f1             	div    %rcx
  8010cb:	48 89 d0             	mov    %rdx,%rax
  8010ce:	48 ba e8 56 80 00 00 	movabs $0x8056e8,%rdx
  8010d5:	00 00 00 
  8010d8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8010dc:	0f be c0             	movsbl %al,%eax
  8010df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010e3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8010e7:	48 89 d6             	mov    %rdx,%rsi
  8010ea:	89 c7                	mov    %eax,%edi
  8010ec:	ff d1                	callq  *%rcx
}
  8010ee:	c9                   	leaveq 
  8010ef:	c3                   	retq   

00000000008010f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010f0:	55                   	push   %rbp
  8010f1:	48 89 e5             	mov    %rsp,%rbp
  8010f4:	48 83 ec 20          	sub    $0x20,%rsp
  8010f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010fc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8010ff:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801103:	7e 52                	jle    801157 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  801105:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801109:	8b 00                	mov    (%rax),%eax
  80110b:	83 f8 30             	cmp    $0x30,%eax
  80110e:	73 24                	jae    801134 <getuint+0x44>
  801110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801114:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801118:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111c:	8b 00                	mov    (%rax),%eax
  80111e:	89 c0                	mov    %eax,%eax
  801120:	48 01 d0             	add    %rdx,%rax
  801123:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801127:	8b 12                	mov    (%rdx),%edx
  801129:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80112c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801130:	89 0a                	mov    %ecx,(%rdx)
  801132:	eb 17                	jmp    80114b <getuint+0x5b>
  801134:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801138:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80113c:	48 89 d0             	mov    %rdx,%rax
  80113f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801143:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801147:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80114b:	48 8b 00             	mov    (%rax),%rax
  80114e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801152:	e9 a3 00 00 00       	jmpq   8011fa <getuint+0x10a>
	else if (lflag)
  801157:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80115b:	74 4f                	je     8011ac <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80115d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801161:	8b 00                	mov    (%rax),%eax
  801163:	83 f8 30             	cmp    $0x30,%eax
  801166:	73 24                	jae    80118c <getuint+0x9c>
  801168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801170:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801174:	8b 00                	mov    (%rax),%eax
  801176:	89 c0                	mov    %eax,%eax
  801178:	48 01 d0             	add    %rdx,%rax
  80117b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80117f:	8b 12                	mov    (%rdx),%edx
  801181:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801184:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801188:	89 0a                	mov    %ecx,(%rdx)
  80118a:	eb 17                	jmp    8011a3 <getuint+0xb3>
  80118c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801190:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801194:	48 89 d0             	mov    %rdx,%rax
  801197:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80119b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80119f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011a3:	48 8b 00             	mov    (%rax),%rax
  8011a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8011aa:	eb 4e                	jmp    8011fa <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8011ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b0:	8b 00                	mov    (%rax),%eax
  8011b2:	83 f8 30             	cmp    $0x30,%eax
  8011b5:	73 24                	jae    8011db <getuint+0xeb>
  8011b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8011bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c3:	8b 00                	mov    (%rax),%eax
  8011c5:	89 c0                	mov    %eax,%eax
  8011c7:	48 01 d0             	add    %rdx,%rax
  8011ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ce:	8b 12                	mov    (%rdx),%edx
  8011d0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8011d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d7:	89 0a                	mov    %ecx,(%rdx)
  8011d9:	eb 17                	jmp    8011f2 <getuint+0x102>
  8011db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011df:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8011e3:	48 89 d0             	mov    %rdx,%rax
  8011e6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8011ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ee:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011f2:	8b 00                	mov    (%rax),%eax
  8011f4:	89 c0                	mov    %eax,%eax
  8011f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8011fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011fe:	c9                   	leaveq 
  8011ff:	c3                   	retq   

0000000000801200 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801200:	55                   	push   %rbp
  801201:	48 89 e5             	mov    %rsp,%rbp
  801204:	48 83 ec 20          	sub    $0x20,%rsp
  801208:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80120c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80120f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801213:	7e 52                	jle    801267 <getint+0x67>
		x=va_arg(*ap, long long);
  801215:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801219:	8b 00                	mov    (%rax),%eax
  80121b:	83 f8 30             	cmp    $0x30,%eax
  80121e:	73 24                	jae    801244 <getint+0x44>
  801220:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801224:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801228:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122c:	8b 00                	mov    (%rax),%eax
  80122e:	89 c0                	mov    %eax,%eax
  801230:	48 01 d0             	add    %rdx,%rax
  801233:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801237:	8b 12                	mov    (%rdx),%edx
  801239:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80123c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801240:	89 0a                	mov    %ecx,(%rdx)
  801242:	eb 17                	jmp    80125b <getint+0x5b>
  801244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801248:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80124c:	48 89 d0             	mov    %rdx,%rax
  80124f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801253:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801257:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80125b:	48 8b 00             	mov    (%rax),%rax
  80125e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801262:	e9 a3 00 00 00       	jmpq   80130a <getint+0x10a>
	else if (lflag)
  801267:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80126b:	74 4f                	je     8012bc <getint+0xbc>
		x=va_arg(*ap, long);
  80126d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801271:	8b 00                	mov    (%rax),%eax
  801273:	83 f8 30             	cmp    $0x30,%eax
  801276:	73 24                	jae    80129c <getint+0x9c>
  801278:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801280:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801284:	8b 00                	mov    (%rax),%eax
  801286:	89 c0                	mov    %eax,%eax
  801288:	48 01 d0             	add    %rdx,%rax
  80128b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80128f:	8b 12                	mov    (%rdx),%edx
  801291:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801294:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801298:	89 0a                	mov    %ecx,(%rdx)
  80129a:	eb 17                	jmp    8012b3 <getint+0xb3>
  80129c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012a4:	48 89 d0             	mov    %rdx,%rax
  8012a7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8012ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012af:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8012b3:	48 8b 00             	mov    (%rax),%rax
  8012b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8012ba:	eb 4e                	jmp    80130a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8012bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c0:	8b 00                	mov    (%rax),%eax
  8012c2:	83 f8 30             	cmp    $0x30,%eax
  8012c5:	73 24                	jae    8012eb <getint+0xeb>
  8012c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8012cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d3:	8b 00                	mov    (%rax),%eax
  8012d5:	89 c0                	mov    %eax,%eax
  8012d7:	48 01 d0             	add    %rdx,%rax
  8012da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012de:	8b 12                	mov    (%rdx),%edx
  8012e0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8012e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012e7:	89 0a                	mov    %ecx,(%rdx)
  8012e9:	eb 17                	jmp    801302 <getint+0x102>
  8012eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ef:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012f3:	48 89 d0             	mov    %rdx,%rax
  8012f6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8012fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012fe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801302:	8b 00                	mov    (%rax),%eax
  801304:	48 98                	cltq   
  801306:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80130a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80130e:	c9                   	leaveq 
  80130f:	c3                   	retq   

0000000000801310 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801310:	55                   	push   %rbp
  801311:	48 89 e5             	mov    %rsp,%rbp
  801314:	41 54                	push   %r12
  801316:	53                   	push   %rbx
  801317:	48 83 ec 60          	sub    $0x60,%rsp
  80131b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80131f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801323:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801327:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80132b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80132f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801333:	48 8b 0a             	mov    (%rdx),%rcx
  801336:	48 89 08             	mov    %rcx,(%rax)
  801339:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80133d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801341:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801345:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801349:	eb 17                	jmp    801362 <vprintfmt+0x52>
			if (ch == '\0')
  80134b:	85 db                	test   %ebx,%ebx
  80134d:	0f 84 d7 04 00 00    	je     80182a <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  801353:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801357:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80135b:	48 89 c6             	mov    %rax,%rsi
  80135e:	89 df                	mov    %ebx,%edi
  801360:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801362:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801366:	0f b6 00             	movzbl (%rax),%eax
  801369:	0f b6 d8             	movzbl %al,%ebx
  80136c:	83 fb 25             	cmp    $0x25,%ebx
  80136f:	0f 95 c0             	setne  %al
  801372:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  801377:	84 c0                	test   %al,%al
  801379:	75 d0                	jne    80134b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80137b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80137f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801386:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80138d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801394:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80139b:	eb 04                	jmp    8013a1 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80139d:	90                   	nop
  80139e:	eb 01                	jmp    8013a1 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8013a0:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013a1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013a5:	0f b6 00             	movzbl (%rax),%eax
  8013a8:	0f b6 d8             	movzbl %al,%ebx
  8013ab:	89 d8                	mov    %ebx,%eax
  8013ad:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8013b2:	83 e8 23             	sub    $0x23,%eax
  8013b5:	83 f8 55             	cmp    $0x55,%eax
  8013b8:	0f 87 38 04 00 00    	ja     8017f6 <vprintfmt+0x4e6>
  8013be:	89 c0                	mov    %eax,%eax
  8013c0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8013c7:	00 
  8013c8:	48 b8 10 57 80 00 00 	movabs $0x805710,%rax
  8013cf:	00 00 00 
  8013d2:	48 01 d0             	add    %rdx,%rax
  8013d5:	48 8b 00             	mov    (%rax),%rax
  8013d8:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8013da:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8013de:	eb c1                	jmp    8013a1 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013e0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8013e4:	eb bb                	jmp    8013a1 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013e6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8013ed:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8013f0:	89 d0                	mov    %edx,%eax
  8013f2:	c1 e0 02             	shl    $0x2,%eax
  8013f5:	01 d0                	add    %edx,%eax
  8013f7:	01 c0                	add    %eax,%eax
  8013f9:	01 d8                	add    %ebx,%eax
  8013fb:	83 e8 30             	sub    $0x30,%eax
  8013fe:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  801401:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801405:	0f b6 00             	movzbl (%rax),%eax
  801408:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80140b:	83 fb 2f             	cmp    $0x2f,%ebx
  80140e:	7e 63                	jle    801473 <vprintfmt+0x163>
  801410:	83 fb 39             	cmp    $0x39,%ebx
  801413:	7f 5e                	jg     801473 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801415:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80141a:	eb d1                	jmp    8013ed <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80141c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80141f:	83 f8 30             	cmp    $0x30,%eax
  801422:	73 17                	jae    80143b <vprintfmt+0x12b>
  801424:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801428:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80142b:	89 c0                	mov    %eax,%eax
  80142d:	48 01 d0             	add    %rdx,%rax
  801430:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801433:	83 c2 08             	add    $0x8,%edx
  801436:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801439:	eb 0f                	jmp    80144a <vprintfmt+0x13a>
  80143b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80143f:	48 89 d0             	mov    %rdx,%rax
  801442:	48 83 c2 08          	add    $0x8,%rdx
  801446:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80144a:	8b 00                	mov    (%rax),%eax
  80144c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80144f:	eb 23                	jmp    801474 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  801451:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801455:	0f 89 42 ff ff ff    	jns    80139d <vprintfmt+0x8d>
				width = 0;
  80145b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801462:	e9 36 ff ff ff       	jmpq   80139d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  801467:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80146e:	e9 2e ff ff ff       	jmpq   8013a1 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801473:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801474:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801478:	0f 89 22 ff ff ff    	jns    8013a0 <vprintfmt+0x90>
				width = precision, precision = -1;
  80147e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801481:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801484:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80148b:	e9 10 ff ff ff       	jmpq   8013a0 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801490:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801494:	e9 08 ff ff ff       	jmpq   8013a1 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801499:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80149c:	83 f8 30             	cmp    $0x30,%eax
  80149f:	73 17                	jae    8014b8 <vprintfmt+0x1a8>
  8014a1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014a8:	89 c0                	mov    %eax,%eax
  8014aa:	48 01 d0             	add    %rdx,%rax
  8014ad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014b0:	83 c2 08             	add    $0x8,%edx
  8014b3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8014b6:	eb 0f                	jmp    8014c7 <vprintfmt+0x1b7>
  8014b8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014bc:	48 89 d0             	mov    %rdx,%rax
  8014bf:	48 83 c2 08          	add    $0x8,%rdx
  8014c3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8014c7:	8b 00                	mov    (%rax),%eax
  8014c9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014cd:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8014d1:	48 89 d6             	mov    %rdx,%rsi
  8014d4:	89 c7                	mov    %eax,%edi
  8014d6:	ff d1                	callq  *%rcx
			break;
  8014d8:	e9 47 03 00 00       	jmpq   801824 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8014dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014e0:	83 f8 30             	cmp    $0x30,%eax
  8014e3:	73 17                	jae    8014fc <vprintfmt+0x1ec>
  8014e5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014ec:	89 c0                	mov    %eax,%eax
  8014ee:	48 01 d0             	add    %rdx,%rax
  8014f1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014f4:	83 c2 08             	add    $0x8,%edx
  8014f7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8014fa:	eb 0f                	jmp    80150b <vprintfmt+0x1fb>
  8014fc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801500:	48 89 d0             	mov    %rdx,%rax
  801503:	48 83 c2 08          	add    $0x8,%rdx
  801507:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80150b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80150d:	85 db                	test   %ebx,%ebx
  80150f:	79 02                	jns    801513 <vprintfmt+0x203>
				err = -err;
  801511:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801513:	83 fb 10             	cmp    $0x10,%ebx
  801516:	7f 16                	jg     80152e <vprintfmt+0x21e>
  801518:	48 b8 60 56 80 00 00 	movabs $0x805660,%rax
  80151f:	00 00 00 
  801522:	48 63 d3             	movslq %ebx,%rdx
  801525:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801529:	4d 85 e4             	test   %r12,%r12
  80152c:	75 2e                	jne    80155c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80152e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801532:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801536:	89 d9                	mov    %ebx,%ecx
  801538:	48 ba f9 56 80 00 00 	movabs $0x8056f9,%rdx
  80153f:	00 00 00 
  801542:	48 89 c7             	mov    %rax,%rdi
  801545:	b8 00 00 00 00       	mov    $0x0,%eax
  80154a:	49 b8 34 18 80 00 00 	movabs $0x801834,%r8
  801551:	00 00 00 
  801554:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801557:	e9 c8 02 00 00       	jmpq   801824 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80155c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801560:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801564:	4c 89 e1             	mov    %r12,%rcx
  801567:	48 ba 02 57 80 00 00 	movabs $0x805702,%rdx
  80156e:	00 00 00 
  801571:	48 89 c7             	mov    %rax,%rdi
  801574:	b8 00 00 00 00       	mov    $0x0,%eax
  801579:	49 b8 34 18 80 00 00 	movabs $0x801834,%r8
  801580:	00 00 00 
  801583:	41 ff d0             	callq  *%r8
			break;
  801586:	e9 99 02 00 00       	jmpq   801824 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80158b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80158e:	83 f8 30             	cmp    $0x30,%eax
  801591:	73 17                	jae    8015aa <vprintfmt+0x29a>
  801593:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801597:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80159a:	89 c0                	mov    %eax,%eax
  80159c:	48 01 d0             	add    %rdx,%rax
  80159f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8015a2:	83 c2 08             	add    $0x8,%edx
  8015a5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8015a8:	eb 0f                	jmp    8015b9 <vprintfmt+0x2a9>
  8015aa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8015ae:	48 89 d0             	mov    %rdx,%rax
  8015b1:	48 83 c2 08          	add    $0x8,%rdx
  8015b5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8015b9:	4c 8b 20             	mov    (%rax),%r12
  8015bc:	4d 85 e4             	test   %r12,%r12
  8015bf:	75 0a                	jne    8015cb <vprintfmt+0x2bb>
				p = "(null)";
  8015c1:	49 bc 05 57 80 00 00 	movabs $0x805705,%r12
  8015c8:	00 00 00 
			if (width > 0 && padc != '-')
  8015cb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8015cf:	7e 7a                	jle    80164b <vprintfmt+0x33b>
  8015d1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8015d5:	74 74                	je     80164b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015d7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8015da:	48 98                	cltq   
  8015dc:	48 89 c6             	mov    %rax,%rsi
  8015df:	4c 89 e7             	mov    %r12,%rdi
  8015e2:	48 b8 de 1a 80 00 00 	movabs $0x801ade,%rax
  8015e9:	00 00 00 
  8015ec:	ff d0                	callq  *%rax
  8015ee:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8015f1:	eb 17                	jmp    80160a <vprintfmt+0x2fa>
					putch(padc, putdat);
  8015f3:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  8015f7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015fb:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8015ff:	48 89 d6             	mov    %rdx,%rsi
  801602:	89 c7                	mov    %eax,%edi
  801604:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801606:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80160a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80160e:	7f e3                	jg     8015f3 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801610:	eb 39                	jmp    80164b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  801612:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801616:	74 1e                	je     801636 <vprintfmt+0x326>
  801618:	83 fb 1f             	cmp    $0x1f,%ebx
  80161b:	7e 05                	jle    801622 <vprintfmt+0x312>
  80161d:	83 fb 7e             	cmp    $0x7e,%ebx
  801620:	7e 14                	jle    801636 <vprintfmt+0x326>
					putch('?', putdat);
  801622:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801626:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80162a:	48 89 c6             	mov    %rax,%rsi
  80162d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801632:	ff d2                	callq  *%rdx
  801634:	eb 0f                	jmp    801645 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  801636:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80163a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80163e:	48 89 c6             	mov    %rax,%rsi
  801641:	89 df                	mov    %ebx,%edi
  801643:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801645:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801649:	eb 01                	jmp    80164c <vprintfmt+0x33c>
  80164b:	90                   	nop
  80164c:	41 0f b6 04 24       	movzbl (%r12),%eax
  801651:	0f be d8             	movsbl %al,%ebx
  801654:	85 db                	test   %ebx,%ebx
  801656:	0f 95 c0             	setne  %al
  801659:	49 83 c4 01          	add    $0x1,%r12
  80165d:	84 c0                	test   %al,%al
  80165f:	74 28                	je     801689 <vprintfmt+0x379>
  801661:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801665:	78 ab                	js     801612 <vprintfmt+0x302>
  801667:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80166b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80166f:	79 a1                	jns    801612 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801671:	eb 16                	jmp    801689 <vprintfmt+0x379>
				putch(' ', putdat);
  801673:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801677:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80167b:	48 89 c6             	mov    %rax,%rsi
  80167e:	bf 20 00 00 00       	mov    $0x20,%edi
  801683:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801685:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801689:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80168d:	7f e4                	jg     801673 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  80168f:	e9 90 01 00 00       	jmpq   801824 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801694:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801698:	be 03 00 00 00       	mov    $0x3,%esi
  80169d:	48 89 c7             	mov    %rax,%rdi
  8016a0:	48 b8 00 12 80 00 00 	movabs $0x801200,%rax
  8016a7:	00 00 00 
  8016aa:	ff d0                	callq  *%rax
  8016ac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8016b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b4:	48 85 c0             	test   %rax,%rax
  8016b7:	79 1d                	jns    8016d6 <vprintfmt+0x3c6>
				putch('-', putdat);
  8016b9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8016bd:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8016c1:	48 89 c6             	mov    %rax,%rsi
  8016c4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8016c9:	ff d2                	callq  *%rdx
				num = -(long long) num;
  8016cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016cf:	48 f7 d8             	neg    %rax
  8016d2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8016d6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8016dd:	e9 d5 00 00 00       	jmpq   8017b7 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8016e2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8016e6:	be 03 00 00 00       	mov    $0x3,%esi
  8016eb:	48 89 c7             	mov    %rax,%rdi
  8016ee:	48 b8 f0 10 80 00 00 	movabs $0x8010f0,%rax
  8016f5:	00 00 00 
  8016f8:	ff d0                	callq  *%rax
  8016fa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8016fe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801705:	e9 ad 00 00 00       	jmpq   8017b7 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  80170a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80170e:	be 03 00 00 00       	mov    $0x3,%esi
  801713:	48 89 c7             	mov    %rax,%rdi
  801716:	48 b8 f0 10 80 00 00 	movabs $0x8010f0,%rax
  80171d:	00 00 00 
  801720:	ff d0                	callq  *%rax
  801722:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  801726:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80172d:	e9 85 00 00 00       	jmpq   8017b7 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  801732:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801736:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80173a:	48 89 c6             	mov    %rax,%rsi
  80173d:	bf 30 00 00 00       	mov    $0x30,%edi
  801742:	ff d2                	callq  *%rdx
			putch('x', putdat);
  801744:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801748:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80174c:	48 89 c6             	mov    %rax,%rsi
  80174f:	bf 78 00 00 00       	mov    $0x78,%edi
  801754:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801756:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801759:	83 f8 30             	cmp    $0x30,%eax
  80175c:	73 17                	jae    801775 <vprintfmt+0x465>
  80175e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801762:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801765:	89 c0                	mov    %eax,%eax
  801767:	48 01 d0             	add    %rdx,%rax
  80176a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80176d:	83 c2 08             	add    $0x8,%edx
  801770:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801773:	eb 0f                	jmp    801784 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  801775:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801779:	48 89 d0             	mov    %rdx,%rax
  80177c:	48 83 c2 08          	add    $0x8,%rdx
  801780:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801784:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801787:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80178b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801792:	eb 23                	jmp    8017b7 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801794:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801798:	be 03 00 00 00       	mov    $0x3,%esi
  80179d:	48 89 c7             	mov    %rax,%rdi
  8017a0:	48 b8 f0 10 80 00 00 	movabs $0x8010f0,%rax
  8017a7:	00 00 00 
  8017aa:	ff d0                	callq  *%rax
  8017ac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8017b0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8017b7:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8017bc:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8017bf:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8017c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017c6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8017ca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017ce:	45 89 c1             	mov    %r8d,%r9d
  8017d1:	41 89 f8             	mov    %edi,%r8d
  8017d4:	48 89 c7             	mov    %rax,%rdi
  8017d7:	48 b8 38 10 80 00 00 	movabs $0x801038,%rax
  8017de:	00 00 00 
  8017e1:	ff d0                	callq  *%rax
			break;
  8017e3:	eb 3f                	jmp    801824 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017e5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8017e9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8017ed:	48 89 c6             	mov    %rax,%rsi
  8017f0:	89 df                	mov    %ebx,%edi
  8017f2:	ff d2                	callq  *%rdx
			break;
  8017f4:	eb 2e                	jmp    801824 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017f6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8017fa:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8017fe:	48 89 c6             	mov    %rax,%rsi
  801801:	bf 25 00 00 00       	mov    $0x25,%edi
  801806:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  801808:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80180d:	eb 05                	jmp    801814 <vprintfmt+0x504>
  80180f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801814:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801818:	48 83 e8 01          	sub    $0x1,%rax
  80181c:	0f b6 00             	movzbl (%rax),%eax
  80181f:	3c 25                	cmp    $0x25,%al
  801821:	75 ec                	jne    80180f <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  801823:	90                   	nop
		}
	}
  801824:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801825:	e9 38 fb ff ff       	jmpq   801362 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  80182a:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  80182b:	48 83 c4 60          	add    $0x60,%rsp
  80182f:	5b                   	pop    %rbx
  801830:	41 5c                	pop    %r12
  801832:	5d                   	pop    %rbp
  801833:	c3                   	retq   

0000000000801834 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801834:	55                   	push   %rbp
  801835:	48 89 e5             	mov    %rsp,%rbp
  801838:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80183f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801846:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80184d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801854:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80185b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801862:	84 c0                	test   %al,%al
  801864:	74 20                	je     801886 <printfmt+0x52>
  801866:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80186a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80186e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801872:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801876:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80187a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80187e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801882:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801886:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80188d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801894:	00 00 00 
  801897:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80189e:	00 00 00 
  8018a1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8018a5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8018ac:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8018b3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8018ba:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8018c1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8018c8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8018cf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8018d6:	48 89 c7             	mov    %rax,%rdi
  8018d9:	48 b8 10 13 80 00 00 	movabs $0x801310,%rax
  8018e0:	00 00 00 
  8018e3:	ff d0                	callq  *%rax
	va_end(ap);
}
  8018e5:	c9                   	leaveq 
  8018e6:	c3                   	retq   

00000000008018e7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8018e7:	55                   	push   %rbp
  8018e8:	48 89 e5             	mov    %rsp,%rbp
  8018eb:	48 83 ec 10          	sub    $0x10,%rsp
  8018ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8018f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018fa:	8b 40 10             	mov    0x10(%rax),%eax
  8018fd:	8d 50 01             	lea    0x1(%rax),%edx
  801900:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801904:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801907:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80190b:	48 8b 10             	mov    (%rax),%rdx
  80190e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801912:	48 8b 40 08          	mov    0x8(%rax),%rax
  801916:	48 39 c2             	cmp    %rax,%rdx
  801919:	73 17                	jae    801932 <sprintputch+0x4b>
		*b->buf++ = ch;
  80191b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80191f:	48 8b 00             	mov    (%rax),%rax
  801922:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801925:	88 10                	mov    %dl,(%rax)
  801927:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80192b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80192f:	48 89 10             	mov    %rdx,(%rax)
}
  801932:	c9                   	leaveq 
  801933:	c3                   	retq   

0000000000801934 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801934:	55                   	push   %rbp
  801935:	48 89 e5             	mov    %rsp,%rbp
  801938:	48 83 ec 50          	sub    $0x50,%rsp
  80193c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801940:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801943:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801947:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80194b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80194f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801953:	48 8b 0a             	mov    (%rdx),%rcx
  801956:	48 89 08             	mov    %rcx,(%rax)
  801959:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80195d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801961:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801965:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801969:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80196d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801971:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801974:	48 98                	cltq   
  801976:	48 83 e8 01          	sub    $0x1,%rax
  80197a:	48 03 45 c8          	add    -0x38(%rbp),%rax
  80197e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801982:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801989:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80198e:	74 06                	je     801996 <vsnprintf+0x62>
  801990:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801994:	7f 07                	jg     80199d <vsnprintf+0x69>
		return -E_INVAL;
  801996:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80199b:	eb 2f                	jmp    8019cc <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80199d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8019a1:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8019a5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8019a9:	48 89 c6             	mov    %rax,%rsi
  8019ac:	48 bf e7 18 80 00 00 	movabs $0x8018e7,%rdi
  8019b3:	00 00 00 
  8019b6:	48 b8 10 13 80 00 00 	movabs $0x801310,%rax
  8019bd:	00 00 00 
  8019c0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8019c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019c6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8019c9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8019cc:	c9                   	leaveq 
  8019cd:	c3                   	retq   

00000000008019ce <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8019ce:	55                   	push   %rbp
  8019cf:	48 89 e5             	mov    %rsp,%rbp
  8019d2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8019d9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8019e0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8019e6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8019ed:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8019f4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8019fb:	84 c0                	test   %al,%al
  8019fd:	74 20                	je     801a1f <snprintf+0x51>
  8019ff:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801a03:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801a07:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801a0b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801a0f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801a13:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801a17:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801a1b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801a1f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801a26:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801a2d:	00 00 00 
  801a30:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801a37:	00 00 00 
  801a3a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801a3e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801a45:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801a4c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801a53:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801a5a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801a61:	48 8b 0a             	mov    (%rdx),%rcx
  801a64:	48 89 08             	mov    %rcx,(%rax)
  801a67:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801a6b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801a6f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801a73:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801a77:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801a7e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801a85:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801a8b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a92:	48 89 c7             	mov    %rax,%rdi
  801a95:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  801a9c:	00 00 00 
  801a9f:	ff d0                	callq  *%rax
  801aa1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801aa7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801aad:	c9                   	leaveq 
  801aae:	c3                   	retq   
	...

0000000000801ab0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801ab0:	55                   	push   %rbp
  801ab1:	48 89 e5             	mov    %rsp,%rbp
  801ab4:	48 83 ec 18          	sub    $0x18,%rsp
  801ab8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801abc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ac3:	eb 09                	jmp    801ace <strlen+0x1e>
		n++;
  801ac5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ac9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801ace:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ad2:	0f b6 00             	movzbl (%rax),%eax
  801ad5:	84 c0                	test   %al,%al
  801ad7:	75 ec                	jne    801ac5 <strlen+0x15>
		n++;
	return n;
  801ad9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801adc:	c9                   	leaveq 
  801add:	c3                   	retq   

0000000000801ade <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801ade:	55                   	push   %rbp
  801adf:	48 89 e5             	mov    %rsp,%rbp
  801ae2:	48 83 ec 20          	sub    $0x20,%rsp
  801ae6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801aea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801aee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801af5:	eb 0e                	jmp    801b05 <strnlen+0x27>
		n++;
  801af7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801afb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801b00:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801b05:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801b0a:	74 0b                	je     801b17 <strnlen+0x39>
  801b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b10:	0f b6 00             	movzbl (%rax),%eax
  801b13:	84 c0                	test   %al,%al
  801b15:	75 e0                	jne    801af7 <strnlen+0x19>
		n++;
	return n;
  801b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b1a:	c9                   	leaveq 
  801b1b:	c3                   	retq   

0000000000801b1c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b1c:	55                   	push   %rbp
  801b1d:	48 89 e5             	mov    %rsp,%rbp
  801b20:	48 83 ec 20          	sub    $0x20,%rsp
  801b24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801b2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b30:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801b34:	90                   	nop
  801b35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b39:	0f b6 10             	movzbl (%rax),%edx
  801b3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b40:	88 10                	mov    %dl,(%rax)
  801b42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b46:	0f b6 00             	movzbl (%rax),%eax
  801b49:	84 c0                	test   %al,%al
  801b4b:	0f 95 c0             	setne  %al
  801b4e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801b53:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801b58:	84 c0                	test   %al,%al
  801b5a:	75 d9                	jne    801b35 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801b5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b60:	c9                   	leaveq 
  801b61:	c3                   	retq   

0000000000801b62 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801b62:	55                   	push   %rbp
  801b63:	48 89 e5             	mov    %rsp,%rbp
  801b66:	48 83 ec 20          	sub    $0x20,%rsp
  801b6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b6e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801b72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b76:	48 89 c7             	mov    %rax,%rdi
  801b79:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  801b80:	00 00 00 
  801b83:	ff d0                	callq  *%rax
  801b85:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801b88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8b:	48 98                	cltq   
  801b8d:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801b91:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b95:	48 89 d6             	mov    %rdx,%rsi
  801b98:	48 89 c7             	mov    %rax,%rdi
  801b9b:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  801ba2:	00 00 00 
  801ba5:	ff d0                	callq  *%rax
	return dst;
  801ba7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bab:	c9                   	leaveq 
  801bac:	c3                   	retq   

0000000000801bad <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bad:	55                   	push   %rbp
  801bae:	48 89 e5             	mov    %rsp,%rbp
  801bb1:	48 83 ec 28          	sub    $0x28,%rsp
  801bb5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bb9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bbd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801bc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801bc9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801bd0:	00 
  801bd1:	eb 27                	jmp    801bfa <strncpy+0x4d>
		*dst++ = *src;
  801bd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bd7:	0f b6 10             	movzbl (%rax),%edx
  801bda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bde:	88 10                	mov    %dl,(%rax)
  801be0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801be5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801be9:	0f b6 00             	movzbl (%rax),%eax
  801bec:	84 c0                	test   %al,%al
  801bee:	74 05                	je     801bf5 <strncpy+0x48>
			src++;
  801bf0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bf5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bfe:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801c02:	72 cf                	jb     801bd3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801c08:	c9                   	leaveq 
  801c09:	c3                   	retq   

0000000000801c0a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c0a:	55                   	push   %rbp
  801c0b:	48 89 e5             	mov    %rsp,%rbp
  801c0e:	48 83 ec 28          	sub    $0x28,%rsp
  801c12:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c16:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c1a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801c1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801c26:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c2b:	74 37                	je     801c64 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801c2d:	eb 17                	jmp    801c46 <strlcpy+0x3c>
			*dst++ = *src++;
  801c2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c33:	0f b6 10             	movzbl (%rax),%edx
  801c36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c3a:	88 10                	mov    %dl,(%rax)
  801c3c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801c41:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801c46:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801c4b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c50:	74 0b                	je     801c5d <strlcpy+0x53>
  801c52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c56:	0f b6 00             	movzbl (%rax),%eax
  801c59:	84 c0                	test   %al,%al
  801c5b:	75 d2                	jne    801c2f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801c5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c61:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801c64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c6c:	48 89 d1             	mov    %rdx,%rcx
  801c6f:	48 29 c1             	sub    %rax,%rcx
  801c72:	48 89 c8             	mov    %rcx,%rax
}
  801c75:	c9                   	leaveq 
  801c76:	c3                   	retq   

0000000000801c77 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c77:	55                   	push   %rbp
  801c78:	48 89 e5             	mov    %rsp,%rbp
  801c7b:	48 83 ec 10          	sub    $0x10,%rsp
  801c7f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801c87:	eb 0a                	jmp    801c93 <strcmp+0x1c>
		p++, q++;
  801c89:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c8e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801c93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c97:	0f b6 00             	movzbl (%rax),%eax
  801c9a:	84 c0                	test   %al,%al
  801c9c:	74 12                	je     801cb0 <strcmp+0x39>
  801c9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca2:	0f b6 10             	movzbl (%rax),%edx
  801ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca9:	0f b6 00             	movzbl (%rax),%eax
  801cac:	38 c2                	cmp    %al,%dl
  801cae:	74 d9                	je     801c89 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801cb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb4:	0f b6 00             	movzbl (%rax),%eax
  801cb7:	0f b6 d0             	movzbl %al,%edx
  801cba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cbe:	0f b6 00             	movzbl (%rax),%eax
  801cc1:	0f b6 c0             	movzbl %al,%eax
  801cc4:	89 d1                	mov    %edx,%ecx
  801cc6:	29 c1                	sub    %eax,%ecx
  801cc8:	89 c8                	mov    %ecx,%eax
}
  801cca:	c9                   	leaveq 
  801ccb:	c3                   	retq   

0000000000801ccc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801ccc:	55                   	push   %rbp
  801ccd:	48 89 e5             	mov    %rsp,%rbp
  801cd0:	48 83 ec 18          	sub    $0x18,%rsp
  801cd4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cd8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cdc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801ce0:	eb 0f                	jmp    801cf1 <strncmp+0x25>
		n--, p++, q++;
  801ce2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801ce7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801cec:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801cf1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cf6:	74 1d                	je     801d15 <strncmp+0x49>
  801cf8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cfc:	0f b6 00             	movzbl (%rax),%eax
  801cff:	84 c0                	test   %al,%al
  801d01:	74 12                	je     801d15 <strncmp+0x49>
  801d03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d07:	0f b6 10             	movzbl (%rax),%edx
  801d0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d0e:	0f b6 00             	movzbl (%rax),%eax
  801d11:	38 c2                	cmp    %al,%dl
  801d13:	74 cd                	je     801ce2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801d15:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d1a:	75 07                	jne    801d23 <strncmp+0x57>
		return 0;
  801d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d21:	eb 1a                	jmp    801d3d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d27:	0f b6 00             	movzbl (%rax),%eax
  801d2a:	0f b6 d0             	movzbl %al,%edx
  801d2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d31:	0f b6 00             	movzbl (%rax),%eax
  801d34:	0f b6 c0             	movzbl %al,%eax
  801d37:	89 d1                	mov    %edx,%ecx
  801d39:	29 c1                	sub    %eax,%ecx
  801d3b:	89 c8                	mov    %ecx,%eax
}
  801d3d:	c9                   	leaveq 
  801d3e:	c3                   	retq   

0000000000801d3f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d3f:	55                   	push   %rbp
  801d40:	48 89 e5             	mov    %rsp,%rbp
  801d43:	48 83 ec 10          	sub    $0x10,%rsp
  801d47:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d4b:	89 f0                	mov    %esi,%eax
  801d4d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d50:	eb 17                	jmp    801d69 <strchr+0x2a>
		if (*s == c)
  801d52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d56:	0f b6 00             	movzbl (%rax),%eax
  801d59:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d5c:	75 06                	jne    801d64 <strchr+0x25>
			return (char *) s;
  801d5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d62:	eb 15                	jmp    801d79 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d64:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6d:	0f b6 00             	movzbl (%rax),%eax
  801d70:	84 c0                	test   %al,%al
  801d72:	75 de                	jne    801d52 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801d74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d79:	c9                   	leaveq 
  801d7a:	c3                   	retq   

0000000000801d7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d7b:	55                   	push   %rbp
  801d7c:	48 89 e5             	mov    %rsp,%rbp
  801d7f:	48 83 ec 10          	sub    $0x10,%rsp
  801d83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d87:	89 f0                	mov    %esi,%eax
  801d89:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d8c:	eb 11                	jmp    801d9f <strfind+0x24>
		if (*s == c)
  801d8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d92:	0f b6 00             	movzbl (%rax),%eax
  801d95:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d98:	74 12                	je     801dac <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801d9a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da3:	0f b6 00             	movzbl (%rax),%eax
  801da6:	84 c0                	test   %al,%al
  801da8:	75 e4                	jne    801d8e <strfind+0x13>
  801daa:	eb 01                	jmp    801dad <strfind+0x32>
		if (*s == c)
			break;
  801dac:	90                   	nop
	return (char *) s;
  801dad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801db1:	c9                   	leaveq 
  801db2:	c3                   	retq   

0000000000801db3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801db3:	55                   	push   %rbp
  801db4:	48 89 e5             	mov    %rsp,%rbp
  801db7:	48 83 ec 18          	sub    $0x18,%rsp
  801dbb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dbf:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801dc2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801dc6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801dcb:	75 06                	jne    801dd3 <memset+0x20>
		return v;
  801dcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd1:	eb 69                	jmp    801e3c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801dd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd7:	83 e0 03             	and    $0x3,%eax
  801dda:	48 85 c0             	test   %rax,%rax
  801ddd:	75 48                	jne    801e27 <memset+0x74>
  801ddf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de3:	83 e0 03             	and    $0x3,%eax
  801de6:	48 85 c0             	test   %rax,%rax
  801de9:	75 3c                	jne    801e27 <memset+0x74>
		c &= 0xFF;
  801deb:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801df2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801df5:	89 c2                	mov    %eax,%edx
  801df7:	c1 e2 18             	shl    $0x18,%edx
  801dfa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dfd:	c1 e0 10             	shl    $0x10,%eax
  801e00:	09 c2                	or     %eax,%edx
  801e02:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e05:	c1 e0 08             	shl    $0x8,%eax
  801e08:	09 d0                	or     %edx,%eax
  801e0a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801e0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e11:	48 89 c1             	mov    %rax,%rcx
  801e14:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801e18:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e1c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e1f:	48 89 d7             	mov    %rdx,%rdi
  801e22:	fc                   	cld    
  801e23:	f3 ab                	rep stos %eax,%es:(%rdi)
  801e25:	eb 11                	jmp    801e38 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e27:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e2b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e2e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e32:	48 89 d7             	mov    %rdx,%rdi
  801e35:	fc                   	cld    
  801e36:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801e38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801e3c:	c9                   	leaveq 
  801e3d:	c3                   	retq   

0000000000801e3e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e3e:	55                   	push   %rbp
  801e3f:	48 89 e5             	mov    %rsp,%rbp
  801e42:	48 83 ec 28          	sub    $0x28,%rsp
  801e46:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e4a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e4e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801e52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e56:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801e5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e5e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801e62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e66:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e6a:	0f 83 88 00 00 00    	jae    801ef8 <memmove+0xba>
  801e70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e74:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e78:	48 01 d0             	add    %rdx,%rax
  801e7b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e7f:	76 77                	jbe    801ef8 <memmove+0xba>
		s += n;
  801e81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e85:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801e89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e8d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801e91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e95:	83 e0 03             	and    $0x3,%eax
  801e98:	48 85 c0             	test   %rax,%rax
  801e9b:	75 3b                	jne    801ed8 <memmove+0x9a>
  801e9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ea1:	83 e0 03             	and    $0x3,%eax
  801ea4:	48 85 c0             	test   %rax,%rax
  801ea7:	75 2f                	jne    801ed8 <memmove+0x9a>
  801ea9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ead:	83 e0 03             	and    $0x3,%eax
  801eb0:	48 85 c0             	test   %rax,%rax
  801eb3:	75 23                	jne    801ed8 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb9:	48 83 e8 04          	sub    $0x4,%rax
  801ebd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ec1:	48 83 ea 04          	sub    $0x4,%rdx
  801ec5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801ec9:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801ecd:	48 89 c7             	mov    %rax,%rdi
  801ed0:	48 89 d6             	mov    %rdx,%rsi
  801ed3:	fd                   	std    
  801ed4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ed6:	eb 1d                	jmp    801ef5 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801ed8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801edc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801ee0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee4:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801ee8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eec:	48 89 d7             	mov    %rdx,%rdi
  801eef:	48 89 c1             	mov    %rax,%rcx
  801ef2:	fd                   	std    
  801ef3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ef5:	fc                   	cld    
  801ef6:	eb 57                	jmp    801f4f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ef8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801efc:	83 e0 03             	and    $0x3,%eax
  801eff:	48 85 c0             	test   %rax,%rax
  801f02:	75 36                	jne    801f3a <memmove+0xfc>
  801f04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f08:	83 e0 03             	and    $0x3,%eax
  801f0b:	48 85 c0             	test   %rax,%rax
  801f0e:	75 2a                	jne    801f3a <memmove+0xfc>
  801f10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f14:	83 e0 03             	and    $0x3,%eax
  801f17:	48 85 c0             	test   %rax,%rax
  801f1a:	75 1e                	jne    801f3a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f20:	48 89 c1             	mov    %rax,%rcx
  801f23:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801f27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f2b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f2f:	48 89 c7             	mov    %rax,%rdi
  801f32:	48 89 d6             	mov    %rdx,%rsi
  801f35:	fc                   	cld    
  801f36:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801f38:	eb 15                	jmp    801f4f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801f3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f3e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f42:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801f46:	48 89 c7             	mov    %rax,%rdi
  801f49:	48 89 d6             	mov    %rdx,%rsi
  801f4c:	fc                   	cld    
  801f4d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801f4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f53:	c9                   	leaveq 
  801f54:	c3                   	retq   

0000000000801f55 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f55:	55                   	push   %rbp
  801f56:	48 89 e5             	mov    %rsp,%rbp
  801f59:	48 83 ec 18          	sub    $0x18,%rsp
  801f5d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f61:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f65:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801f69:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f6d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f75:	48 89 ce             	mov    %rcx,%rsi
  801f78:	48 89 c7             	mov    %rax,%rdi
  801f7b:	48 b8 3e 1e 80 00 00 	movabs $0x801e3e,%rax
  801f82:	00 00 00 
  801f85:	ff d0                	callq  *%rax
}
  801f87:	c9                   	leaveq 
  801f88:	c3                   	retq   

0000000000801f89 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f89:	55                   	push   %rbp
  801f8a:	48 89 e5             	mov    %rsp,%rbp
  801f8d:	48 83 ec 28          	sub    $0x28,%rsp
  801f91:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f95:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f99:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801f9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801fa5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fa9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801fad:	eb 38                	jmp    801fe7 <memcmp+0x5e>
		if (*s1 != *s2)
  801faf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb3:	0f b6 10             	movzbl (%rax),%edx
  801fb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fba:	0f b6 00             	movzbl (%rax),%eax
  801fbd:	38 c2                	cmp    %al,%dl
  801fbf:	74 1c                	je     801fdd <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801fc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc5:	0f b6 00             	movzbl (%rax),%eax
  801fc8:	0f b6 d0             	movzbl %al,%edx
  801fcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fcf:	0f b6 00             	movzbl (%rax),%eax
  801fd2:	0f b6 c0             	movzbl %al,%eax
  801fd5:	89 d1                	mov    %edx,%ecx
  801fd7:	29 c1                	sub    %eax,%ecx
  801fd9:	89 c8                	mov    %ecx,%eax
  801fdb:	eb 20                	jmp    801ffd <memcmp+0x74>
		s1++, s2++;
  801fdd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801fe2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801fe7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801fec:	0f 95 c0             	setne  %al
  801fef:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801ff4:	84 c0                	test   %al,%al
  801ff6:	75 b7                	jne    801faf <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffd:	c9                   	leaveq 
  801ffe:	c3                   	retq   

0000000000801fff <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801fff:	55                   	push   %rbp
  802000:	48 89 e5             	mov    %rsp,%rbp
  802003:	48 83 ec 28          	sub    $0x28,%rsp
  802007:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80200b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80200e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802012:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802016:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80201a:	48 01 d0             	add    %rdx,%rax
  80201d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802021:	eb 13                	jmp    802036 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  802023:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802027:	0f b6 10             	movzbl (%rax),%edx
  80202a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80202d:	38 c2                	cmp    %al,%dl
  80202f:	74 11                	je     802042 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802031:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802036:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80203a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80203e:	72 e3                	jb     802023 <memfind+0x24>
  802040:	eb 01                	jmp    802043 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802042:	90                   	nop
	return (void *) s;
  802043:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802047:	c9                   	leaveq 
  802048:	c3                   	retq   

0000000000802049 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802049:	55                   	push   %rbp
  80204a:	48 89 e5             	mov    %rsp,%rbp
  80204d:	48 83 ec 38          	sub    $0x38,%rsp
  802051:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802055:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802059:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80205c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  802063:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80206a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80206b:	eb 05                	jmp    802072 <strtol+0x29>
		s++;
  80206d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802072:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802076:	0f b6 00             	movzbl (%rax),%eax
  802079:	3c 20                	cmp    $0x20,%al
  80207b:	74 f0                	je     80206d <strtol+0x24>
  80207d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802081:	0f b6 00             	movzbl (%rax),%eax
  802084:	3c 09                	cmp    $0x9,%al
  802086:	74 e5                	je     80206d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  802088:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80208c:	0f b6 00             	movzbl (%rax),%eax
  80208f:	3c 2b                	cmp    $0x2b,%al
  802091:	75 07                	jne    80209a <strtol+0x51>
		s++;
  802093:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802098:	eb 17                	jmp    8020b1 <strtol+0x68>
	else if (*s == '-')
  80209a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80209e:	0f b6 00             	movzbl (%rax),%eax
  8020a1:	3c 2d                	cmp    $0x2d,%al
  8020a3:	75 0c                	jne    8020b1 <strtol+0x68>
		s++, neg = 1;
  8020a5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8020aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8020b1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020b5:	74 06                	je     8020bd <strtol+0x74>
  8020b7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8020bb:	75 28                	jne    8020e5 <strtol+0x9c>
  8020bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c1:	0f b6 00             	movzbl (%rax),%eax
  8020c4:	3c 30                	cmp    $0x30,%al
  8020c6:	75 1d                	jne    8020e5 <strtol+0x9c>
  8020c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020cc:	48 83 c0 01          	add    $0x1,%rax
  8020d0:	0f b6 00             	movzbl (%rax),%eax
  8020d3:	3c 78                	cmp    $0x78,%al
  8020d5:	75 0e                	jne    8020e5 <strtol+0x9c>
		s += 2, base = 16;
  8020d7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8020dc:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8020e3:	eb 2c                	jmp    802111 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8020e5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020e9:	75 19                	jne    802104 <strtol+0xbb>
  8020eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ef:	0f b6 00             	movzbl (%rax),%eax
  8020f2:	3c 30                	cmp    $0x30,%al
  8020f4:	75 0e                	jne    802104 <strtol+0xbb>
		s++, base = 8;
  8020f6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8020fb:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  802102:	eb 0d                	jmp    802111 <strtol+0xc8>
	else if (base == 0)
  802104:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802108:	75 07                	jne    802111 <strtol+0xc8>
		base = 10;
  80210a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802111:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802115:	0f b6 00             	movzbl (%rax),%eax
  802118:	3c 2f                	cmp    $0x2f,%al
  80211a:	7e 1d                	jle    802139 <strtol+0xf0>
  80211c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802120:	0f b6 00             	movzbl (%rax),%eax
  802123:	3c 39                	cmp    $0x39,%al
  802125:	7f 12                	jg     802139 <strtol+0xf0>
			dig = *s - '0';
  802127:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80212b:	0f b6 00             	movzbl (%rax),%eax
  80212e:	0f be c0             	movsbl %al,%eax
  802131:	83 e8 30             	sub    $0x30,%eax
  802134:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802137:	eb 4e                	jmp    802187 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  802139:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80213d:	0f b6 00             	movzbl (%rax),%eax
  802140:	3c 60                	cmp    $0x60,%al
  802142:	7e 1d                	jle    802161 <strtol+0x118>
  802144:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802148:	0f b6 00             	movzbl (%rax),%eax
  80214b:	3c 7a                	cmp    $0x7a,%al
  80214d:	7f 12                	jg     802161 <strtol+0x118>
			dig = *s - 'a' + 10;
  80214f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802153:	0f b6 00             	movzbl (%rax),%eax
  802156:	0f be c0             	movsbl %al,%eax
  802159:	83 e8 57             	sub    $0x57,%eax
  80215c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80215f:	eb 26                	jmp    802187 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  802161:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802165:	0f b6 00             	movzbl (%rax),%eax
  802168:	3c 40                	cmp    $0x40,%al
  80216a:	7e 47                	jle    8021b3 <strtol+0x16a>
  80216c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802170:	0f b6 00             	movzbl (%rax),%eax
  802173:	3c 5a                	cmp    $0x5a,%al
  802175:	7f 3c                	jg     8021b3 <strtol+0x16a>
			dig = *s - 'A' + 10;
  802177:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80217b:	0f b6 00             	movzbl (%rax),%eax
  80217e:	0f be c0             	movsbl %al,%eax
  802181:	83 e8 37             	sub    $0x37,%eax
  802184:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  802187:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80218a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80218d:	7d 23                	jge    8021b2 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80218f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802194:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802197:	48 98                	cltq   
  802199:	48 89 c2             	mov    %rax,%rdx
  80219c:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8021a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021a4:	48 98                	cltq   
  8021a6:	48 01 d0             	add    %rdx,%rax
  8021a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8021ad:	e9 5f ff ff ff       	jmpq   802111 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8021b2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8021b3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8021b8:	74 0b                	je     8021c5 <strtol+0x17c>
		*endptr = (char *) s;
  8021ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021be:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021c2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8021c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c9:	74 09                	je     8021d4 <strtol+0x18b>
  8021cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021cf:	48 f7 d8             	neg    %rax
  8021d2:	eb 04                	jmp    8021d8 <strtol+0x18f>
  8021d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8021d8:	c9                   	leaveq 
  8021d9:	c3                   	retq   

00000000008021da <strstr>:

char * strstr(const char *in, const char *str)
{
  8021da:	55                   	push   %rbp
  8021db:	48 89 e5             	mov    %rsp,%rbp
  8021de:	48 83 ec 30          	sub    $0x30,%rsp
  8021e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8021e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8021ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021ee:	0f b6 00             	movzbl (%rax),%eax
  8021f1:	88 45 ff             	mov    %al,-0x1(%rbp)
  8021f4:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8021f9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8021fd:	75 06                	jne    802205 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8021ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802203:	eb 68                	jmp    80226d <strstr+0x93>

    len = strlen(str);
  802205:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802209:	48 89 c7             	mov    %rax,%rdi
  80220c:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  802213:	00 00 00 
  802216:	ff d0                	callq  *%rax
  802218:	48 98                	cltq   
  80221a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80221e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802222:	0f b6 00             	movzbl (%rax),%eax
  802225:	88 45 ef             	mov    %al,-0x11(%rbp)
  802228:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  80222d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802231:	75 07                	jne    80223a <strstr+0x60>
                return (char *) 0;
  802233:	b8 00 00 00 00       	mov    $0x0,%eax
  802238:	eb 33                	jmp    80226d <strstr+0x93>
        } while (sc != c);
  80223a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80223e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802241:	75 db                	jne    80221e <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  802243:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802247:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80224b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80224f:	48 89 ce             	mov    %rcx,%rsi
  802252:	48 89 c7             	mov    %rax,%rdi
  802255:	48 b8 cc 1c 80 00 00 	movabs $0x801ccc,%rax
  80225c:	00 00 00 
  80225f:	ff d0                	callq  *%rax
  802261:	85 c0                	test   %eax,%eax
  802263:	75 b9                	jne    80221e <strstr+0x44>

    return (char *) (in - 1);
  802265:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802269:	48 83 e8 01          	sub    $0x1,%rax
}
  80226d:	c9                   	leaveq 
  80226e:	c3                   	retq   
	...

0000000000802270 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802270:	55                   	push   %rbp
  802271:	48 89 e5             	mov    %rsp,%rbp
  802274:	53                   	push   %rbx
  802275:	48 83 ec 58          	sub    $0x58,%rsp
  802279:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80227c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80227f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802283:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802287:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80228b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80228f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802292:	89 45 ac             	mov    %eax,-0x54(%rbp)
  802295:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802299:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80229d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8022a1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8022a5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8022a9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8022ac:	4c 89 c3             	mov    %r8,%rbx
  8022af:	cd 30                	int    $0x30
  8022b1:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8022b5:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8022b9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8022bd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8022c1:	74 3e                	je     802301 <syscall+0x91>
  8022c3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8022c8:	7e 37                	jle    802301 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8022ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022ce:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022d1:	49 89 d0             	mov    %rdx,%r8
  8022d4:	89 c1                	mov    %eax,%ecx
  8022d6:	48 ba c0 59 80 00 00 	movabs $0x8059c0,%rdx
  8022dd:	00 00 00 
  8022e0:	be 23 00 00 00       	mov    $0x23,%esi
  8022e5:	48 bf dd 59 80 00 00 	movabs $0x8059dd,%rdi
  8022ec:	00 00 00 
  8022ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f4:	49 b9 24 0d 80 00 00 	movabs $0x800d24,%r9
  8022fb:	00 00 00 
  8022fe:	41 ff d1             	callq  *%r9

	return ret;
  802301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802305:	48 83 c4 58          	add    $0x58,%rsp
  802309:	5b                   	pop    %rbx
  80230a:	5d                   	pop    %rbp
  80230b:	c3                   	retq   

000000000080230c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80230c:	55                   	push   %rbp
  80230d:	48 89 e5             	mov    %rsp,%rbp
  802310:	48 83 ec 20          	sub    $0x20,%rsp
  802314:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802318:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80231c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802320:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802324:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80232b:	00 
  80232c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802332:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802338:	48 89 d1             	mov    %rdx,%rcx
  80233b:	48 89 c2             	mov    %rax,%rdx
  80233e:	be 00 00 00 00       	mov    $0x0,%esi
  802343:	bf 00 00 00 00       	mov    $0x0,%edi
  802348:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  80234f:	00 00 00 
  802352:	ff d0                	callq  *%rax
}
  802354:	c9                   	leaveq 
  802355:	c3                   	retq   

0000000000802356 <sys_cgetc>:

int
sys_cgetc(void)
{
  802356:	55                   	push   %rbp
  802357:	48 89 e5             	mov    %rsp,%rbp
  80235a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80235e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802365:	00 
  802366:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80236c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802372:	b9 00 00 00 00       	mov    $0x0,%ecx
  802377:	ba 00 00 00 00       	mov    $0x0,%edx
  80237c:	be 00 00 00 00       	mov    $0x0,%esi
  802381:	bf 01 00 00 00       	mov    $0x1,%edi
  802386:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  80238d:	00 00 00 
  802390:	ff d0                	callq  *%rax
}
  802392:	c9                   	leaveq 
  802393:	c3                   	retq   

0000000000802394 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802394:	55                   	push   %rbp
  802395:	48 89 e5             	mov    %rsp,%rbp
  802398:	48 83 ec 20          	sub    $0x20,%rsp
  80239c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80239f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a2:	48 98                	cltq   
  8023a4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023ab:	00 
  8023ac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023bd:	48 89 c2             	mov    %rax,%rdx
  8023c0:	be 01 00 00 00       	mov    $0x1,%esi
  8023c5:	bf 03 00 00 00       	mov    $0x3,%edi
  8023ca:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  8023d1:	00 00 00 
  8023d4:	ff d0                	callq  *%rax
}
  8023d6:	c9                   	leaveq 
  8023d7:	c3                   	retq   

00000000008023d8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8023d8:	55                   	push   %rbp
  8023d9:	48 89 e5             	mov    %rsp,%rbp
  8023dc:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8023e0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023e7:	00 
  8023e8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8023fe:	be 00 00 00 00       	mov    $0x0,%esi
  802403:	bf 02 00 00 00       	mov    $0x2,%edi
  802408:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  80240f:	00 00 00 
  802412:	ff d0                	callq  *%rax
}
  802414:	c9                   	leaveq 
  802415:	c3                   	retq   

0000000000802416 <sys_yield>:

void
sys_yield(void)
{
  802416:	55                   	push   %rbp
  802417:	48 89 e5             	mov    %rsp,%rbp
  80241a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80241e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802425:	00 
  802426:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80242c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802432:	b9 00 00 00 00       	mov    $0x0,%ecx
  802437:	ba 00 00 00 00       	mov    $0x0,%edx
  80243c:	be 00 00 00 00       	mov    $0x0,%esi
  802441:	bf 0b 00 00 00       	mov    $0xb,%edi
  802446:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  80244d:	00 00 00 
  802450:	ff d0                	callq  *%rax
}
  802452:	c9                   	leaveq 
  802453:	c3                   	retq   

0000000000802454 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802454:	55                   	push   %rbp
  802455:	48 89 e5             	mov    %rsp,%rbp
  802458:	48 83 ec 20          	sub    $0x20,%rsp
  80245c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80245f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802463:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802466:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802469:	48 63 c8             	movslq %eax,%rcx
  80246c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802470:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802473:	48 98                	cltq   
  802475:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80247c:	00 
  80247d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802483:	49 89 c8             	mov    %rcx,%r8
  802486:	48 89 d1             	mov    %rdx,%rcx
  802489:	48 89 c2             	mov    %rax,%rdx
  80248c:	be 01 00 00 00       	mov    $0x1,%esi
  802491:	bf 04 00 00 00       	mov    $0x4,%edi
  802496:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  80249d:	00 00 00 
  8024a0:	ff d0                	callq  *%rax
}
  8024a2:	c9                   	leaveq 
  8024a3:	c3                   	retq   

00000000008024a4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8024a4:	55                   	push   %rbp
  8024a5:	48 89 e5             	mov    %rsp,%rbp
  8024a8:	48 83 ec 30          	sub    $0x30,%rsp
  8024ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8024b3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8024b6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8024ba:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8024be:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8024c1:	48 63 c8             	movslq %eax,%rcx
  8024c4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8024c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024cb:	48 63 f0             	movslq %eax,%rsi
  8024ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d5:	48 98                	cltq   
  8024d7:	48 89 0c 24          	mov    %rcx,(%rsp)
  8024db:	49 89 f9             	mov    %rdi,%r9
  8024de:	49 89 f0             	mov    %rsi,%r8
  8024e1:	48 89 d1             	mov    %rdx,%rcx
  8024e4:	48 89 c2             	mov    %rax,%rdx
  8024e7:	be 01 00 00 00       	mov    $0x1,%esi
  8024ec:	bf 05 00 00 00       	mov    $0x5,%edi
  8024f1:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  8024f8:	00 00 00 
  8024fb:	ff d0                	callq  *%rax
}
  8024fd:	c9                   	leaveq 
  8024fe:	c3                   	retq   

00000000008024ff <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8024ff:	55                   	push   %rbp
  802500:	48 89 e5             	mov    %rsp,%rbp
  802503:	48 83 ec 20          	sub    $0x20,%rsp
  802507:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80250a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80250e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802512:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802515:	48 98                	cltq   
  802517:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80251e:	00 
  80251f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802525:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80252b:	48 89 d1             	mov    %rdx,%rcx
  80252e:	48 89 c2             	mov    %rax,%rdx
  802531:	be 01 00 00 00       	mov    $0x1,%esi
  802536:	bf 06 00 00 00       	mov    $0x6,%edi
  80253b:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  802542:	00 00 00 
  802545:	ff d0                	callq  *%rax
}
  802547:	c9                   	leaveq 
  802548:	c3                   	retq   

0000000000802549 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802549:	55                   	push   %rbp
  80254a:	48 89 e5             	mov    %rsp,%rbp
  80254d:	48 83 ec 20          	sub    $0x20,%rsp
  802551:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802554:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802557:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80255a:	48 63 d0             	movslq %eax,%rdx
  80255d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802560:	48 98                	cltq   
  802562:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802569:	00 
  80256a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802570:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802576:	48 89 d1             	mov    %rdx,%rcx
  802579:	48 89 c2             	mov    %rax,%rdx
  80257c:	be 01 00 00 00       	mov    $0x1,%esi
  802581:	bf 08 00 00 00       	mov    $0x8,%edi
  802586:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  80258d:	00 00 00 
  802590:	ff d0                	callq  *%rax
}
  802592:	c9                   	leaveq 
  802593:	c3                   	retq   

0000000000802594 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802594:	55                   	push   %rbp
  802595:	48 89 e5             	mov    %rsp,%rbp
  802598:	48 83 ec 20          	sub    $0x20,%rsp
  80259c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80259f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8025a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025aa:	48 98                	cltq   
  8025ac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025b3:	00 
  8025b4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025c0:	48 89 d1             	mov    %rdx,%rcx
  8025c3:	48 89 c2             	mov    %rax,%rdx
  8025c6:	be 01 00 00 00       	mov    $0x1,%esi
  8025cb:	bf 09 00 00 00       	mov    $0x9,%edi
  8025d0:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  8025d7:	00 00 00 
  8025da:	ff d0                	callq  *%rax
}
  8025dc:	c9                   	leaveq 
  8025dd:	c3                   	retq   

00000000008025de <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8025de:	55                   	push   %rbp
  8025df:	48 89 e5             	mov    %rsp,%rbp
  8025e2:	48 83 ec 20          	sub    $0x20,%rsp
  8025e6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8025ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f4:	48 98                	cltq   
  8025f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025fd:	00 
  8025fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802604:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80260a:	48 89 d1             	mov    %rdx,%rcx
  80260d:	48 89 c2             	mov    %rax,%rdx
  802610:	be 01 00 00 00       	mov    $0x1,%esi
  802615:	bf 0a 00 00 00       	mov    $0xa,%edi
  80261a:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  802621:	00 00 00 
  802624:	ff d0                	callq  *%rax
}
  802626:	c9                   	leaveq 
  802627:	c3                   	retq   

0000000000802628 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802628:	55                   	push   %rbp
  802629:	48 89 e5             	mov    %rsp,%rbp
  80262c:	48 83 ec 30          	sub    $0x30,%rsp
  802630:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802633:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802637:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80263b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80263e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802641:	48 63 f0             	movslq %eax,%rsi
  802644:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802648:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264b:	48 98                	cltq   
  80264d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802651:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802658:	00 
  802659:	49 89 f1             	mov    %rsi,%r9
  80265c:	49 89 c8             	mov    %rcx,%r8
  80265f:	48 89 d1             	mov    %rdx,%rcx
  802662:	48 89 c2             	mov    %rax,%rdx
  802665:	be 00 00 00 00       	mov    $0x0,%esi
  80266a:	bf 0c 00 00 00       	mov    $0xc,%edi
  80266f:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  802676:	00 00 00 
  802679:	ff d0                	callq  *%rax
}
  80267b:	c9                   	leaveq 
  80267c:	c3                   	retq   

000000000080267d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80267d:	55                   	push   %rbp
  80267e:	48 89 e5             	mov    %rsp,%rbp
  802681:	48 83 ec 20          	sub    $0x20,%rsp
  802685:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80268d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802694:	00 
  802695:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80269b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8026a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8026a6:	48 89 c2             	mov    %rax,%rdx
  8026a9:	be 01 00 00 00       	mov    $0x1,%esi
  8026ae:	bf 0d 00 00 00       	mov    $0xd,%edi
  8026b3:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  8026ba:	00 00 00 
  8026bd:	ff d0                	callq  *%rax
}
  8026bf:	c9                   	leaveq 
  8026c0:	c3                   	retq   

00000000008026c1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8026c1:	55                   	push   %rbp
  8026c2:	48 89 e5             	mov    %rsp,%rbp
  8026c5:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8026c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8026d0:	00 
  8026d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8026d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8026dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8026e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e7:	be 00 00 00 00       	mov    $0x0,%esi
  8026ec:	bf 0e 00 00 00       	mov    $0xe,%edi
  8026f1:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  8026f8:	00 00 00 
  8026fb:	ff d0                	callq  *%rax
}
  8026fd:	c9                   	leaveq 
  8026fe:	c3                   	retq   

00000000008026ff <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  8026ff:	55                   	push   %rbp
  802700:	48 89 e5             	mov    %rsp,%rbp
  802703:	48 83 ec 20          	sub    $0x20,%rsp
  802707:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80270b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  80270f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802713:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802717:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80271e:	00 
  80271f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802725:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80272b:	48 89 d1             	mov    %rdx,%rcx
  80272e:	48 89 c2             	mov    %rax,%rdx
  802731:	be 00 00 00 00       	mov    $0x0,%esi
  802736:	bf 0f 00 00 00       	mov    $0xf,%edi
  80273b:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  802742:	00 00 00 
  802745:	ff d0                	callq  *%rax
}
  802747:	c9                   	leaveq 
  802748:	c3                   	retq   

0000000000802749 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  802749:	55                   	push   %rbp
  80274a:	48 89 e5             	mov    %rsp,%rbp
  80274d:	48 83 ec 20          	sub    $0x20,%rsp
  802751:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802755:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  802759:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80275d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802761:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802768:	00 
  802769:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80276f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802775:	48 89 d1             	mov    %rdx,%rcx
  802778:	48 89 c2             	mov    %rax,%rdx
  80277b:	be 00 00 00 00       	mov    $0x0,%esi
  802780:	bf 10 00 00 00       	mov    $0x10,%edi
  802785:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  80278c:	00 00 00 
  80278f:	ff d0                	callq  *%rax
}
  802791:	c9                   	leaveq 
  802792:	c3                   	retq   
	...

0000000000802794 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802794:	55                   	push   %rbp
  802795:	48 89 e5             	mov    %rsp,%rbp
  802798:	48 83 ec 08          	sub    $0x8,%rsp
  80279c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8027a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027a4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8027ab:	ff ff ff 
  8027ae:	48 01 d0             	add    %rdx,%rax
  8027b1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8027b5:	c9                   	leaveq 
  8027b6:	c3                   	retq   

00000000008027b7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8027b7:	55                   	push   %rbp
  8027b8:	48 89 e5             	mov    %rsp,%rbp
  8027bb:	48 83 ec 08          	sub    $0x8,%rsp
  8027bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8027c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027c7:	48 89 c7             	mov    %rax,%rdi
  8027ca:	48 b8 94 27 80 00 00 	movabs $0x802794,%rax
  8027d1:	00 00 00 
  8027d4:	ff d0                	callq  *%rax
  8027d6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8027dc:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8027e0:	c9                   	leaveq 
  8027e1:	c3                   	retq   

00000000008027e2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8027e2:	55                   	push   %rbp
  8027e3:	48 89 e5             	mov    %rsp,%rbp
  8027e6:	48 83 ec 18          	sub    $0x18,%rsp
  8027ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8027ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027f5:	eb 6b                	jmp    802862 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8027f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fa:	48 98                	cltq   
  8027fc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802802:	48 c1 e0 0c          	shl    $0xc,%rax
  802806:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80280a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280e:	48 89 c2             	mov    %rax,%rdx
  802811:	48 c1 ea 15          	shr    $0x15,%rdx
  802815:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80281c:	01 00 00 
  80281f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802823:	83 e0 01             	and    $0x1,%eax
  802826:	48 85 c0             	test   %rax,%rax
  802829:	74 21                	je     80284c <fd_alloc+0x6a>
  80282b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80282f:	48 89 c2             	mov    %rax,%rdx
  802832:	48 c1 ea 0c          	shr    $0xc,%rdx
  802836:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80283d:	01 00 00 
  802840:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802844:	83 e0 01             	and    $0x1,%eax
  802847:	48 85 c0             	test   %rax,%rax
  80284a:	75 12                	jne    80285e <fd_alloc+0x7c>
			*fd_store = fd;
  80284c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802850:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802854:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802857:	b8 00 00 00 00       	mov    $0x0,%eax
  80285c:	eb 1a                	jmp    802878 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80285e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802862:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802866:	7e 8f                	jle    8027f7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802868:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802873:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802878:	c9                   	leaveq 
  802879:	c3                   	retq   

000000000080287a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80287a:	55                   	push   %rbp
  80287b:	48 89 e5             	mov    %rsp,%rbp
  80287e:	48 83 ec 20          	sub    $0x20,%rsp
  802882:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802885:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802889:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80288d:	78 06                	js     802895 <fd_lookup+0x1b>
  80288f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802893:	7e 07                	jle    80289c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802895:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80289a:	eb 6c                	jmp    802908 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80289c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80289f:	48 98                	cltq   
  8028a1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028a7:	48 c1 e0 0c          	shl    $0xc,%rax
  8028ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8028af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028b3:	48 89 c2             	mov    %rax,%rdx
  8028b6:	48 c1 ea 15          	shr    $0x15,%rdx
  8028ba:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028c1:	01 00 00 
  8028c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028c8:	83 e0 01             	and    $0x1,%eax
  8028cb:	48 85 c0             	test   %rax,%rax
  8028ce:	74 21                	je     8028f1 <fd_lookup+0x77>
  8028d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028d4:	48 89 c2             	mov    %rax,%rdx
  8028d7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8028db:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028e2:	01 00 00 
  8028e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028e9:	83 e0 01             	and    $0x1,%eax
  8028ec:	48 85 c0             	test   %rax,%rax
  8028ef:	75 07                	jne    8028f8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8028f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028f6:	eb 10                	jmp    802908 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8028f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802900:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802908:	c9                   	leaveq 
  802909:	c3                   	retq   

000000000080290a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80290a:	55                   	push   %rbp
  80290b:	48 89 e5             	mov    %rsp,%rbp
  80290e:	48 83 ec 30          	sub    $0x30,%rsp
  802912:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802916:	89 f0                	mov    %esi,%eax
  802918:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80291b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80291f:	48 89 c7             	mov    %rax,%rdi
  802922:	48 b8 94 27 80 00 00 	movabs $0x802794,%rax
  802929:	00 00 00 
  80292c:	ff d0                	callq  *%rax
  80292e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802932:	48 89 d6             	mov    %rdx,%rsi
  802935:	89 c7                	mov    %eax,%edi
  802937:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  80293e:	00 00 00 
  802941:	ff d0                	callq  *%rax
  802943:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802946:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294a:	78 0a                	js     802956 <fd_close+0x4c>
	    || fd != fd2)
  80294c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802950:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802954:	74 12                	je     802968 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802956:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80295a:	74 05                	je     802961 <fd_close+0x57>
  80295c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295f:	eb 05                	jmp    802966 <fd_close+0x5c>
  802961:	b8 00 00 00 00       	mov    $0x0,%eax
  802966:	eb 69                	jmp    8029d1 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802968:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80296c:	8b 00                	mov    (%rax),%eax
  80296e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802972:	48 89 d6             	mov    %rdx,%rsi
  802975:	89 c7                	mov    %eax,%edi
  802977:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  80297e:	00 00 00 
  802981:	ff d0                	callq  *%rax
  802983:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802986:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80298a:	78 2a                	js     8029b6 <fd_close+0xac>
		if (dev->dev_close)
  80298c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802990:	48 8b 40 20          	mov    0x20(%rax),%rax
  802994:	48 85 c0             	test   %rax,%rax
  802997:	74 16                	je     8029af <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299d:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8029a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029a5:	48 89 c7             	mov    %rax,%rdi
  8029a8:	ff d2                	callq  *%rdx
  8029aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ad:	eb 07                	jmp    8029b6 <fd_close+0xac>
		else
			r = 0;
  8029af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8029b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029ba:	48 89 c6             	mov    %rax,%rsi
  8029bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8029c2:	48 b8 ff 24 80 00 00 	movabs $0x8024ff,%rax
  8029c9:	00 00 00 
  8029cc:	ff d0                	callq  *%rax
	return r;
  8029ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029d1:	c9                   	leaveq 
  8029d2:	c3                   	retq   

00000000008029d3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8029d3:	55                   	push   %rbp
  8029d4:	48 89 e5             	mov    %rsp,%rbp
  8029d7:	48 83 ec 20          	sub    $0x20,%rsp
  8029db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8029e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029e9:	eb 41                	jmp    802a2c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8029eb:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  8029f2:	00 00 00 
  8029f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029f8:	48 63 d2             	movslq %edx,%rdx
  8029fb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029ff:	8b 00                	mov    (%rax),%eax
  802a01:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a04:	75 22                	jne    802a28 <dev_lookup+0x55>
			*dev = devtab[i];
  802a06:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  802a0d:	00 00 00 
  802a10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a13:	48 63 d2             	movslq %edx,%rdx
  802a16:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802a1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a1e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a21:	b8 00 00 00 00       	mov    $0x0,%eax
  802a26:	eb 60                	jmp    802a88 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802a28:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a2c:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  802a33:	00 00 00 
  802a36:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a39:	48 63 d2             	movslq %edx,%rdx
  802a3c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a40:	48 85 c0             	test   %rax,%rax
  802a43:	75 a6                	jne    8029eb <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802a45:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  802a4c:	00 00 00 
  802a4f:	48 8b 00             	mov    (%rax),%rax
  802a52:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a58:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a5b:	89 c6                	mov    %eax,%esi
  802a5d:	48 bf f0 59 80 00 00 	movabs $0x8059f0,%rdi
  802a64:	00 00 00 
  802a67:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6c:	48 b9 5f 0f 80 00 00 	movabs $0x800f5f,%rcx
  802a73:	00 00 00 
  802a76:	ff d1                	callq  *%rcx
	*dev = 0;
  802a78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a7c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802a83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802a88:	c9                   	leaveq 
  802a89:	c3                   	retq   

0000000000802a8a <close>:

int
close(int fdnum)
{
  802a8a:	55                   	push   %rbp
  802a8b:	48 89 e5             	mov    %rsp,%rbp
  802a8e:	48 83 ec 20          	sub    $0x20,%rsp
  802a92:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a95:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a9c:	48 89 d6             	mov    %rdx,%rsi
  802a9f:	89 c7                	mov    %eax,%edi
  802aa1:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  802aa8:	00 00 00 
  802aab:	ff d0                	callq  *%rax
  802aad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab4:	79 05                	jns    802abb <close+0x31>
		return r;
  802ab6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab9:	eb 18                	jmp    802ad3 <close+0x49>
	else
		return fd_close(fd, 1);
  802abb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abf:	be 01 00 00 00       	mov    $0x1,%esi
  802ac4:	48 89 c7             	mov    %rax,%rdi
  802ac7:	48 b8 0a 29 80 00 00 	movabs $0x80290a,%rax
  802ace:	00 00 00 
  802ad1:	ff d0                	callq  *%rax
}
  802ad3:	c9                   	leaveq 
  802ad4:	c3                   	retq   

0000000000802ad5 <close_all>:

void
close_all(void)
{
  802ad5:	55                   	push   %rbp
  802ad6:	48 89 e5             	mov    %rsp,%rbp
  802ad9:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802add:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ae4:	eb 15                	jmp    802afb <close_all+0x26>
		close(i);
  802ae6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae9:	89 c7                	mov    %eax,%edi
  802aeb:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  802af2:	00 00 00 
  802af5:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802af7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802afb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802aff:	7e e5                	jle    802ae6 <close_all+0x11>
		close(i);
}
  802b01:	c9                   	leaveq 
  802b02:	c3                   	retq   

0000000000802b03 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b03:	55                   	push   %rbp
  802b04:	48 89 e5             	mov    %rsp,%rbp
  802b07:	48 83 ec 40          	sub    $0x40,%rsp
  802b0b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802b0e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b11:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802b15:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802b18:	48 89 d6             	mov    %rdx,%rsi
  802b1b:	89 c7                	mov    %eax,%edi
  802b1d:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  802b24:	00 00 00 
  802b27:	ff d0                	callq  *%rax
  802b29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b30:	79 08                	jns    802b3a <dup+0x37>
		return r;
  802b32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b35:	e9 70 01 00 00       	jmpq   802caa <dup+0x1a7>
	close(newfdnum);
  802b3a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b3d:	89 c7                	mov    %eax,%edi
  802b3f:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  802b46:	00 00 00 
  802b49:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802b4b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b4e:	48 98                	cltq   
  802b50:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b56:	48 c1 e0 0c          	shl    $0xc,%rax
  802b5a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802b5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b62:	48 89 c7             	mov    %rax,%rdi
  802b65:	48 b8 b7 27 80 00 00 	movabs $0x8027b7,%rax
  802b6c:	00 00 00 
  802b6f:	ff d0                	callq  *%rax
  802b71:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802b75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b79:	48 89 c7             	mov    %rax,%rdi
  802b7c:	48 b8 b7 27 80 00 00 	movabs $0x8027b7,%rax
  802b83:	00 00 00 
  802b86:	ff d0                	callq  *%rax
  802b88:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802b8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b90:	48 89 c2             	mov    %rax,%rdx
  802b93:	48 c1 ea 15          	shr    $0x15,%rdx
  802b97:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b9e:	01 00 00 
  802ba1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ba5:	83 e0 01             	and    $0x1,%eax
  802ba8:	84 c0                	test   %al,%al
  802baa:	74 71                	je     802c1d <dup+0x11a>
  802bac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb0:	48 89 c2             	mov    %rax,%rdx
  802bb3:	48 c1 ea 0c          	shr    $0xc,%rdx
  802bb7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bbe:	01 00 00 
  802bc1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bc5:	83 e0 01             	and    $0x1,%eax
  802bc8:	84 c0                	test   %al,%al
  802bca:	74 51                	je     802c1d <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802bcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd0:	48 89 c2             	mov    %rax,%rdx
  802bd3:	48 c1 ea 0c          	shr    $0xc,%rdx
  802bd7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bde:	01 00 00 
  802be1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802be5:	89 c1                	mov    %eax,%ecx
  802be7:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802bed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802bf1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf5:	41 89 c8             	mov    %ecx,%r8d
  802bf8:	48 89 d1             	mov    %rdx,%rcx
  802bfb:	ba 00 00 00 00       	mov    $0x0,%edx
  802c00:	48 89 c6             	mov    %rax,%rsi
  802c03:	bf 00 00 00 00       	mov    $0x0,%edi
  802c08:	48 b8 a4 24 80 00 00 	movabs $0x8024a4,%rax
  802c0f:	00 00 00 
  802c12:	ff d0                	callq  *%rax
  802c14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1b:	78 56                	js     802c73 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802c1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c21:	48 89 c2             	mov    %rax,%rdx
  802c24:	48 c1 ea 0c          	shr    $0xc,%rdx
  802c28:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c2f:	01 00 00 
  802c32:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c36:	89 c1                	mov    %eax,%ecx
  802c38:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802c3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c46:	41 89 c8             	mov    %ecx,%r8d
  802c49:	48 89 d1             	mov    %rdx,%rcx
  802c4c:	ba 00 00 00 00       	mov    $0x0,%edx
  802c51:	48 89 c6             	mov    %rax,%rsi
  802c54:	bf 00 00 00 00       	mov    $0x0,%edi
  802c59:	48 b8 a4 24 80 00 00 	movabs $0x8024a4,%rax
  802c60:	00 00 00 
  802c63:	ff d0                	callq  *%rax
  802c65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c6c:	78 08                	js     802c76 <dup+0x173>
		goto err;

	return newfdnum;
  802c6e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c71:	eb 37                	jmp    802caa <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802c73:	90                   	nop
  802c74:	eb 01                	jmp    802c77 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802c76:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802c77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c7b:	48 89 c6             	mov    %rax,%rsi
  802c7e:	bf 00 00 00 00       	mov    $0x0,%edi
  802c83:	48 b8 ff 24 80 00 00 	movabs $0x8024ff,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802c8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c93:	48 89 c6             	mov    %rax,%rsi
  802c96:	bf 00 00 00 00       	mov    $0x0,%edi
  802c9b:	48 b8 ff 24 80 00 00 	movabs $0x8024ff,%rax
  802ca2:	00 00 00 
  802ca5:	ff d0                	callq  *%rax
	return r;
  802ca7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802caa:	c9                   	leaveq 
  802cab:	c3                   	retq   

0000000000802cac <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802cac:	55                   	push   %rbp
  802cad:	48 89 e5             	mov    %rsp,%rbp
  802cb0:	48 83 ec 40          	sub    $0x40,%rsp
  802cb4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cb7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802cbb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cbf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cc3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cc6:	48 89 d6             	mov    %rdx,%rsi
  802cc9:	89 c7                	mov    %eax,%edi
  802ccb:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  802cd2:	00 00 00 
  802cd5:	ff d0                	callq  *%rax
  802cd7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cde:	78 24                	js     802d04 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ce0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce4:	8b 00                	mov    (%rax),%eax
  802ce6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cea:	48 89 d6             	mov    %rdx,%rsi
  802ced:	89 c7                	mov    %eax,%edi
  802cef:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802cf6:	00 00 00 
  802cf9:	ff d0                	callq  *%rax
  802cfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d02:	79 05                	jns    802d09 <read+0x5d>
		return r;
  802d04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d07:	eb 7a                	jmp    802d83 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802d09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0d:	8b 40 08             	mov    0x8(%rax),%eax
  802d10:	83 e0 03             	and    $0x3,%eax
  802d13:	83 f8 01             	cmp    $0x1,%eax
  802d16:	75 3a                	jne    802d52 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802d18:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  802d1f:	00 00 00 
  802d22:	48 8b 00             	mov    (%rax),%rax
  802d25:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d2b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d2e:	89 c6                	mov    %eax,%esi
  802d30:	48 bf 0f 5a 80 00 00 	movabs $0x805a0f,%rdi
  802d37:	00 00 00 
  802d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3f:	48 b9 5f 0f 80 00 00 	movabs $0x800f5f,%rcx
  802d46:	00 00 00 
  802d49:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d50:	eb 31                	jmp    802d83 <read+0xd7>
	}
	if (!dev->dev_read)
  802d52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d56:	48 8b 40 10          	mov    0x10(%rax),%rax
  802d5a:	48 85 c0             	test   %rax,%rax
  802d5d:	75 07                	jne    802d66 <read+0xba>
		return -E_NOT_SUPP;
  802d5f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d64:	eb 1d                	jmp    802d83 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802d66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6a:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802d6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d72:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d76:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d7a:	48 89 ce             	mov    %rcx,%rsi
  802d7d:	48 89 c7             	mov    %rax,%rdi
  802d80:	41 ff d0             	callq  *%r8
}
  802d83:	c9                   	leaveq 
  802d84:	c3                   	retq   

0000000000802d85 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802d85:	55                   	push   %rbp
  802d86:	48 89 e5             	mov    %rsp,%rbp
  802d89:	48 83 ec 30          	sub    $0x30,%rsp
  802d8d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d94:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d9f:	eb 46                	jmp    802de7 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802da1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da4:	48 98                	cltq   
  802da6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802daa:	48 29 c2             	sub    %rax,%rdx
  802dad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db0:	48 98                	cltq   
  802db2:	48 89 c1             	mov    %rax,%rcx
  802db5:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802db9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dbc:	48 89 ce             	mov    %rcx,%rsi
  802dbf:	89 c7                	mov    %eax,%edi
  802dc1:	48 b8 ac 2c 80 00 00 	movabs $0x802cac,%rax
  802dc8:	00 00 00 
  802dcb:	ff d0                	callq  *%rax
  802dcd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802dd0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802dd4:	79 05                	jns    802ddb <readn+0x56>
			return m;
  802dd6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dd9:	eb 1d                	jmp    802df8 <readn+0x73>
		if (m == 0)
  802ddb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ddf:	74 13                	je     802df4 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802de1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802de4:	01 45 fc             	add    %eax,-0x4(%rbp)
  802de7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dea:	48 98                	cltq   
  802dec:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802df0:	72 af                	jb     802da1 <readn+0x1c>
  802df2:	eb 01                	jmp    802df5 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802df4:	90                   	nop
	}
	return tot;
  802df5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802df8:	c9                   	leaveq 
  802df9:	c3                   	retq   

0000000000802dfa <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802dfa:	55                   	push   %rbp
  802dfb:	48 89 e5             	mov    %rsp,%rbp
  802dfe:	48 83 ec 40          	sub    $0x40,%rsp
  802e02:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e05:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e09:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e0d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e11:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e14:	48 89 d6             	mov    %rdx,%rsi
  802e17:	89 c7                	mov    %eax,%edi
  802e19:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  802e20:	00 00 00 
  802e23:	ff d0                	callq  *%rax
  802e25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e2c:	78 24                	js     802e52 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e32:	8b 00                	mov    (%rax),%eax
  802e34:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e38:	48 89 d6             	mov    %rdx,%rsi
  802e3b:	89 c7                	mov    %eax,%edi
  802e3d:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802e44:	00 00 00 
  802e47:	ff d0                	callq  *%rax
  802e49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e50:	79 05                	jns    802e57 <write+0x5d>
		return r;
  802e52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e55:	eb 79                	jmp    802ed0 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5b:	8b 40 08             	mov    0x8(%rax),%eax
  802e5e:	83 e0 03             	and    $0x3,%eax
  802e61:	85 c0                	test   %eax,%eax
  802e63:	75 3a                	jne    802e9f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802e65:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  802e6c:	00 00 00 
  802e6f:	48 8b 00             	mov    (%rax),%rax
  802e72:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e78:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e7b:	89 c6                	mov    %eax,%esi
  802e7d:	48 bf 2b 5a 80 00 00 	movabs $0x805a2b,%rdi
  802e84:	00 00 00 
  802e87:	b8 00 00 00 00       	mov    $0x0,%eax
  802e8c:	48 b9 5f 0f 80 00 00 	movabs $0x800f5f,%rcx
  802e93:	00 00 00 
  802e96:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802e98:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e9d:	eb 31                	jmp    802ed0 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802e9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea3:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ea7:	48 85 c0             	test   %rax,%rax
  802eaa:	75 07                	jne    802eb3 <write+0xb9>
		return -E_NOT_SUPP;
  802eac:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802eb1:	eb 1d                	jmp    802ed0 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802eb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb7:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802ebb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ebf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ec3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ec7:	48 89 ce             	mov    %rcx,%rsi
  802eca:	48 89 c7             	mov    %rax,%rdi
  802ecd:	41 ff d0             	callq  *%r8
}
  802ed0:	c9                   	leaveq 
  802ed1:	c3                   	retq   

0000000000802ed2 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ed2:	55                   	push   %rbp
  802ed3:	48 89 e5             	mov    %rsp,%rbp
  802ed6:	48 83 ec 18          	sub    $0x18,%rsp
  802eda:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802edd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ee0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ee4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ee7:	48 89 d6             	mov    %rdx,%rsi
  802eea:	89 c7                	mov    %eax,%edi
  802eec:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  802ef3:	00 00 00 
  802ef6:	ff d0                	callq  *%rax
  802ef8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802efb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eff:	79 05                	jns    802f06 <seek+0x34>
		return r;
  802f01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f04:	eb 0f                	jmp    802f15 <seek+0x43>
	fd->fd_offset = offset;
  802f06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f0a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f0d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802f10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f15:	c9                   	leaveq 
  802f16:	c3                   	retq   

0000000000802f17 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f17:	55                   	push   %rbp
  802f18:	48 89 e5             	mov    %rsp,%rbp
  802f1b:	48 83 ec 30          	sub    $0x30,%rsp
  802f1f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f22:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f25:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f29:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f2c:	48 89 d6             	mov    %rdx,%rsi
  802f2f:	89 c7                	mov    %eax,%edi
  802f31:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  802f38:	00 00 00 
  802f3b:	ff d0                	callq  *%rax
  802f3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f44:	78 24                	js     802f6a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f4a:	8b 00                	mov    (%rax),%eax
  802f4c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f50:	48 89 d6             	mov    %rdx,%rsi
  802f53:	89 c7                	mov    %eax,%edi
  802f55:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  802f5c:	00 00 00 
  802f5f:	ff d0                	callq  *%rax
  802f61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f68:	79 05                	jns    802f6f <ftruncate+0x58>
		return r;
  802f6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f6d:	eb 72                	jmp    802fe1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f73:	8b 40 08             	mov    0x8(%rax),%eax
  802f76:	83 e0 03             	and    $0x3,%eax
  802f79:	85 c0                	test   %eax,%eax
  802f7b:	75 3a                	jne    802fb7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802f7d:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  802f84:	00 00 00 
  802f87:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802f8a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f90:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f93:	89 c6                	mov    %eax,%esi
  802f95:	48 bf 48 5a 80 00 00 	movabs $0x805a48,%rdi
  802f9c:	00 00 00 
  802f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa4:	48 b9 5f 0f 80 00 00 	movabs $0x800f5f,%rcx
  802fab:	00 00 00 
  802fae:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802fb0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fb5:	eb 2a                	jmp    802fe1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbb:	48 8b 40 30          	mov    0x30(%rax),%rax
  802fbf:	48 85 c0             	test   %rax,%rax
  802fc2:	75 07                	jne    802fcb <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802fc4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fc9:	eb 16                	jmp    802fe1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802fcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fcf:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802fd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802fda:	89 d6                	mov    %edx,%esi
  802fdc:	48 89 c7             	mov    %rax,%rdi
  802fdf:	ff d1                	callq  *%rcx
}
  802fe1:	c9                   	leaveq 
  802fe2:	c3                   	retq   

0000000000802fe3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802fe3:	55                   	push   %rbp
  802fe4:	48 89 e5             	mov    %rsp,%rbp
  802fe7:	48 83 ec 30          	sub    $0x30,%rsp
  802feb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802fee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ff2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ff6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ff9:	48 89 d6             	mov    %rdx,%rsi
  802ffc:	89 c7                	mov    %eax,%edi
  802ffe:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  803005:	00 00 00 
  803008:	ff d0                	callq  *%rax
  80300a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80300d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803011:	78 24                	js     803037 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803013:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803017:	8b 00                	mov    (%rax),%eax
  803019:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80301d:	48 89 d6             	mov    %rdx,%rsi
  803020:	89 c7                	mov    %eax,%edi
  803022:	48 b8 d3 29 80 00 00 	movabs $0x8029d3,%rax
  803029:	00 00 00 
  80302c:	ff d0                	callq  *%rax
  80302e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803031:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803035:	79 05                	jns    80303c <fstat+0x59>
		return r;
  803037:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80303a:	eb 5e                	jmp    80309a <fstat+0xb7>
	if (!dev->dev_stat)
  80303c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803040:	48 8b 40 28          	mov    0x28(%rax),%rax
  803044:	48 85 c0             	test   %rax,%rax
  803047:	75 07                	jne    803050 <fstat+0x6d>
		return -E_NOT_SUPP;
  803049:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80304e:	eb 4a                	jmp    80309a <fstat+0xb7>
	stat->st_name[0] = 0;
  803050:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803054:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803057:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80305b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803062:	00 00 00 
	stat->st_isdir = 0;
  803065:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803069:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803070:	00 00 00 
	stat->st_dev = dev;
  803073:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803077:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80307b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803082:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803086:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80308a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80308e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803092:	48 89 d6             	mov    %rdx,%rsi
  803095:	48 89 c7             	mov    %rax,%rdi
  803098:	ff d1                	callq  *%rcx
}
  80309a:	c9                   	leaveq 
  80309b:	c3                   	retq   

000000000080309c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80309c:	55                   	push   %rbp
  80309d:	48 89 e5             	mov    %rsp,%rbp
  8030a0:	48 83 ec 20          	sub    $0x20,%rsp
  8030a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8030ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b0:	be 00 00 00 00       	mov    $0x0,%esi
  8030b5:	48 89 c7             	mov    %rax,%rdi
  8030b8:	48 b8 8b 31 80 00 00 	movabs $0x80318b,%rax
  8030bf:	00 00 00 
  8030c2:	ff d0                	callq  *%rax
  8030c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030cb:	79 05                	jns    8030d2 <stat+0x36>
		return fd;
  8030cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d0:	eb 2f                	jmp    803101 <stat+0x65>
	r = fstat(fd, stat);
  8030d2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8030d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d9:	48 89 d6             	mov    %rdx,%rsi
  8030dc:	89 c7                	mov    %eax,%edi
  8030de:	48 b8 e3 2f 80 00 00 	movabs $0x802fe3,%rax
  8030e5:	00 00 00 
  8030e8:	ff d0                	callq  *%rax
  8030ea:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8030ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f0:	89 c7                	mov    %eax,%edi
  8030f2:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  8030f9:	00 00 00 
  8030fc:	ff d0                	callq  *%rax
	return r;
  8030fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803101:	c9                   	leaveq 
  803102:	c3                   	retq   
	...

0000000000803104 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803104:	55                   	push   %rbp
  803105:	48 89 e5             	mov    %rsp,%rbp
  803108:	48 83 ec 10          	sub    $0x10,%rsp
  80310c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80310f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803113:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80311a:	00 00 00 
  80311d:	8b 00                	mov    (%rax),%eax
  80311f:	85 c0                	test   %eax,%eax
  803121:	75 1d                	jne    803140 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803123:	bf 01 00 00 00       	mov    $0x1,%edi
  803128:	48 b8 33 4c 80 00 00 	movabs $0x804c33,%rax
  80312f:	00 00 00 
  803132:	ff d0                	callq  *%rax
  803134:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  80313b:	00 00 00 
  80313e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803140:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803147:	00 00 00 
  80314a:	8b 00                	mov    (%rax),%eax
  80314c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80314f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803154:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80315b:	00 00 00 
  80315e:	89 c7                	mov    %eax,%edi
  803160:	48 b8 70 4b 80 00 00 	movabs $0x804b70,%rax
  803167:	00 00 00 
  80316a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80316c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803170:	ba 00 00 00 00       	mov    $0x0,%edx
  803175:	48 89 c6             	mov    %rax,%rsi
  803178:	bf 00 00 00 00       	mov    $0x0,%edi
  80317d:	48 b8 b0 4a 80 00 00 	movabs $0x804ab0,%rax
  803184:	00 00 00 
  803187:	ff d0                	callq  *%rax
}
  803189:	c9                   	leaveq 
  80318a:	c3                   	retq   

000000000080318b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80318b:	55                   	push   %rbp
  80318c:	48 89 e5             	mov    %rsp,%rbp
  80318f:	48 83 ec 20          	sub    $0x20,%rsp
  803193:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803197:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  80319a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80319e:	48 89 c7             	mov    %rax,%rdi
  8031a1:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  8031a8:	00 00 00 
  8031ab:	ff d0                	callq  *%rax
  8031ad:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8031b2:	7e 0a                	jle    8031be <open+0x33>
                return -E_BAD_PATH;
  8031b4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031b9:	e9 a5 00 00 00       	jmpq   803263 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  8031be:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8031c2:	48 89 c7             	mov    %rax,%rdi
  8031c5:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  8031cc:	00 00 00 
  8031cf:	ff d0                	callq  *%rax
  8031d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031d8:	79 08                	jns    8031e2 <open+0x57>
		return r;
  8031da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031dd:	e9 81 00 00 00       	jmpq   803263 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  8031e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031e6:	48 89 c6             	mov    %rax,%rsi
  8031e9:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8031f0:	00 00 00 
  8031f3:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  8031fa:	00 00 00 
  8031fd:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  8031ff:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803206:	00 00 00 
  803209:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80320c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  803212:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803216:	48 89 c6             	mov    %rax,%rsi
  803219:	bf 01 00 00 00       	mov    $0x1,%edi
  80321e:	48 b8 04 31 80 00 00 	movabs $0x803104,%rax
  803225:	00 00 00 
  803228:	ff d0                	callq  *%rax
  80322a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  80322d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803231:	79 1d                	jns    803250 <open+0xc5>
	{
		fd_close(fd,0);
  803233:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803237:	be 00 00 00 00       	mov    $0x0,%esi
  80323c:	48 89 c7             	mov    %rax,%rdi
  80323f:	48 b8 0a 29 80 00 00 	movabs $0x80290a,%rax
  803246:	00 00 00 
  803249:	ff d0                	callq  *%rax
		return r;
  80324b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324e:	eb 13                	jmp    803263 <open+0xd8>
	}
	return fd2num(fd);
  803250:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803254:	48 89 c7             	mov    %rax,%rdi
  803257:	48 b8 94 27 80 00 00 	movabs $0x802794,%rax
  80325e:	00 00 00 
  803261:	ff d0                	callq  *%rax
	


}
  803263:	c9                   	leaveq 
  803264:	c3                   	retq   

0000000000803265 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803265:	55                   	push   %rbp
  803266:	48 89 e5             	mov    %rsp,%rbp
  803269:	48 83 ec 10          	sub    $0x10,%rsp
  80326d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803275:	8b 50 0c             	mov    0xc(%rax),%edx
  803278:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80327f:	00 00 00 
  803282:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803284:	be 00 00 00 00       	mov    $0x0,%esi
  803289:	bf 06 00 00 00       	mov    $0x6,%edi
  80328e:	48 b8 04 31 80 00 00 	movabs $0x803104,%rax
  803295:	00 00 00 
  803298:	ff d0                	callq  *%rax
}
  80329a:	c9                   	leaveq 
  80329b:	c3                   	retq   

000000000080329c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80329c:	55                   	push   %rbp
  80329d:	48 89 e5             	mov    %rsp,%rbp
  8032a0:	48 83 ec 30          	sub    $0x30,%rsp
  8032a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8032b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b4:	8b 50 0c             	mov    0xc(%rax),%edx
  8032b7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032be:	00 00 00 
  8032c1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8032c3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032ca:	00 00 00 
  8032cd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032d1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8032d5:	be 00 00 00 00       	mov    $0x0,%esi
  8032da:	bf 03 00 00 00       	mov    $0x3,%edi
  8032df:	48 b8 04 31 80 00 00 	movabs $0x803104,%rax
  8032e6:	00 00 00 
  8032e9:	ff d0                	callq  *%rax
  8032eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f2:	79 05                	jns    8032f9 <devfile_read+0x5d>
	{
		return r;
  8032f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f7:	eb 2c                	jmp    803325 <devfile_read+0x89>
	}
	if(r > 0)
  8032f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032fd:	7e 23                	jle    803322 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  8032ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803302:	48 63 d0             	movslq %eax,%rdx
  803305:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803309:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803310:	00 00 00 
  803313:	48 89 c7             	mov    %rax,%rdi
  803316:	48 b8 3e 1e 80 00 00 	movabs $0x801e3e,%rax
  80331d:	00 00 00 
  803320:	ff d0                	callq  *%rax
	return r;
  803322:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  803325:	c9                   	leaveq 
  803326:	c3                   	retq   

0000000000803327 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803327:	55                   	push   %rbp
  803328:	48 89 e5             	mov    %rsp,%rbp
  80332b:	48 83 ec 30          	sub    $0x30,%rsp
  80332f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803333:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803337:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  80333b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80333f:	8b 50 0c             	mov    0xc(%rax),%edx
  803342:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803349:	00 00 00 
  80334c:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  80334e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803355:	00 
  803356:	76 08                	jbe    803360 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  803358:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80335f:	00 
	fsipcbuf.write.req_n=n;
  803360:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803367:	00 00 00 
  80336a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80336e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803372:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803376:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80337a:	48 89 c6             	mov    %rax,%rsi
  80337d:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803384:	00 00 00 
  803387:	48 b8 3e 1e 80 00 00 	movabs $0x801e3e,%rax
  80338e:	00 00 00 
  803391:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  803393:	be 00 00 00 00       	mov    $0x0,%esi
  803398:	bf 04 00 00 00       	mov    $0x4,%edi
  80339d:	48 b8 04 31 80 00 00 	movabs $0x803104,%rax
  8033a4:	00 00 00 
  8033a7:	ff d0                	callq  *%rax
  8033a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  8033ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033af:	c9                   	leaveq 
  8033b0:	c3                   	retq   

00000000008033b1 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  8033b1:	55                   	push   %rbp
  8033b2:	48 89 e5             	mov    %rsp,%rbp
  8033b5:	48 83 ec 10          	sub    $0x10,%rsp
  8033b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033bd:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8033c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033c4:	8b 50 0c             	mov    0xc(%rax),%edx
  8033c7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033ce:	00 00 00 
  8033d1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  8033d3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033da:	00 00 00 
  8033dd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8033e0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8033e3:	be 00 00 00 00       	mov    $0x0,%esi
  8033e8:	bf 02 00 00 00       	mov    $0x2,%edi
  8033ed:	48 b8 04 31 80 00 00 	movabs $0x803104,%rax
  8033f4:	00 00 00 
  8033f7:	ff d0                	callq  *%rax
}
  8033f9:	c9                   	leaveq 
  8033fa:	c3                   	retq   

00000000008033fb <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8033fb:	55                   	push   %rbp
  8033fc:	48 89 e5             	mov    %rsp,%rbp
  8033ff:	48 83 ec 20          	sub    $0x20,%rsp
  803403:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803407:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80340b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80340f:	8b 50 0c             	mov    0xc(%rax),%edx
  803412:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803419:	00 00 00 
  80341c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80341e:	be 00 00 00 00       	mov    $0x0,%esi
  803423:	bf 05 00 00 00       	mov    $0x5,%edi
  803428:	48 b8 04 31 80 00 00 	movabs $0x803104,%rax
  80342f:	00 00 00 
  803432:	ff d0                	callq  *%rax
  803434:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803437:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80343b:	79 05                	jns    803442 <devfile_stat+0x47>
		return r;
  80343d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803440:	eb 56                	jmp    803498 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803442:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803446:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80344d:	00 00 00 
  803450:	48 89 c7             	mov    %rax,%rdi
  803453:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  80345a:	00 00 00 
  80345d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80345f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803466:	00 00 00 
  803469:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80346f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803473:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803479:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803480:	00 00 00 
  803483:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803489:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80348d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803493:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803498:	c9                   	leaveq 
  803499:	c3                   	retq   
	...

000000000080349c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80349c:	55                   	push   %rbp
  80349d:	48 89 e5             	mov    %rsp,%rbp
  8034a0:	48 83 ec 20          	sub    $0x20,%rsp
  8034a4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8034a7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034ae:	48 89 d6             	mov    %rdx,%rsi
  8034b1:	89 c7                	mov    %eax,%edi
  8034b3:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  8034ba:	00 00 00 
  8034bd:	ff d0                	callq  *%rax
  8034bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c6:	79 05                	jns    8034cd <fd2sockid+0x31>
		return r;
  8034c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034cb:	eb 24                	jmp    8034f1 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8034cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d1:	8b 10                	mov    (%rax),%edx
  8034d3:	48 b8 e0 70 80 00 00 	movabs $0x8070e0,%rax
  8034da:	00 00 00 
  8034dd:	8b 00                	mov    (%rax),%eax
  8034df:	39 c2                	cmp    %eax,%edx
  8034e1:	74 07                	je     8034ea <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8034e3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8034e8:	eb 07                	jmp    8034f1 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8034ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ee:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8034f1:	c9                   	leaveq 
  8034f2:	c3                   	retq   

00000000008034f3 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8034f3:	55                   	push   %rbp
  8034f4:	48 89 e5             	mov    %rsp,%rbp
  8034f7:	48 83 ec 20          	sub    $0x20,%rsp
  8034fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8034fe:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803502:	48 89 c7             	mov    %rax,%rdi
  803505:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  80350c:	00 00 00 
  80350f:	ff d0                	callq  *%rax
  803511:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803514:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803518:	78 26                	js     803540 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80351a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80351e:	ba 07 04 00 00       	mov    $0x407,%edx
  803523:	48 89 c6             	mov    %rax,%rsi
  803526:	bf 00 00 00 00       	mov    $0x0,%edi
  80352b:	48 b8 54 24 80 00 00 	movabs $0x802454,%rax
  803532:	00 00 00 
  803535:	ff d0                	callq  *%rax
  803537:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80353a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80353e:	79 16                	jns    803556 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803540:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803543:	89 c7                	mov    %eax,%edi
  803545:	48 b8 00 3a 80 00 00 	movabs $0x803a00,%rax
  80354c:	00 00 00 
  80354f:	ff d0                	callq  *%rax
		return r;
  803551:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803554:	eb 3a                	jmp    803590 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80355a:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803561:	00 00 00 
  803564:	8b 12                	mov    (%rdx),%edx
  803566:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803568:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803573:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803577:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80357a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80357d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803581:	48 89 c7             	mov    %rax,%rdi
  803584:	48 b8 94 27 80 00 00 	movabs $0x802794,%rax
  80358b:	00 00 00 
  80358e:	ff d0                	callq  *%rax
}
  803590:	c9                   	leaveq 
  803591:	c3                   	retq   

0000000000803592 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803592:	55                   	push   %rbp
  803593:	48 89 e5             	mov    %rsp,%rbp
  803596:	48 83 ec 30          	sub    $0x30,%rsp
  80359a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80359d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035a8:	89 c7                	mov    %eax,%edi
  8035aa:	48 b8 9c 34 80 00 00 	movabs $0x80349c,%rax
  8035b1:	00 00 00 
  8035b4:	ff d0                	callq  *%rax
  8035b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035bd:	79 05                	jns    8035c4 <accept+0x32>
		return r;
  8035bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c2:	eb 3b                	jmp    8035ff <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8035c4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035c8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035cf:	48 89 ce             	mov    %rcx,%rsi
  8035d2:	89 c7                	mov    %eax,%edi
  8035d4:	48 b8 dd 38 80 00 00 	movabs $0x8038dd,%rax
  8035db:	00 00 00 
  8035de:	ff d0                	callq  *%rax
  8035e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e7:	79 05                	jns    8035ee <accept+0x5c>
		return r;
  8035e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ec:	eb 11                	jmp    8035ff <accept+0x6d>
	return alloc_sockfd(r);
  8035ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f1:	89 c7                	mov    %eax,%edi
  8035f3:	48 b8 f3 34 80 00 00 	movabs $0x8034f3,%rax
  8035fa:	00 00 00 
  8035fd:	ff d0                	callq  *%rax
}
  8035ff:	c9                   	leaveq 
  803600:	c3                   	retq   

0000000000803601 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803601:	55                   	push   %rbp
  803602:	48 89 e5             	mov    %rsp,%rbp
  803605:	48 83 ec 20          	sub    $0x20,%rsp
  803609:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80360c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803610:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803613:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803616:	89 c7                	mov    %eax,%edi
  803618:	48 b8 9c 34 80 00 00 	movabs $0x80349c,%rax
  80361f:	00 00 00 
  803622:	ff d0                	callq  *%rax
  803624:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803627:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80362b:	79 05                	jns    803632 <bind+0x31>
		return r;
  80362d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803630:	eb 1b                	jmp    80364d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803632:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803635:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803639:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363c:	48 89 ce             	mov    %rcx,%rsi
  80363f:	89 c7                	mov    %eax,%edi
  803641:	48 b8 5c 39 80 00 00 	movabs $0x80395c,%rax
  803648:	00 00 00 
  80364b:	ff d0                	callq  *%rax
}
  80364d:	c9                   	leaveq 
  80364e:	c3                   	retq   

000000000080364f <shutdown>:

int
shutdown(int s, int how)
{
  80364f:	55                   	push   %rbp
  803650:	48 89 e5             	mov    %rsp,%rbp
  803653:	48 83 ec 20          	sub    $0x20,%rsp
  803657:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80365a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80365d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803660:	89 c7                	mov    %eax,%edi
  803662:	48 b8 9c 34 80 00 00 	movabs $0x80349c,%rax
  803669:	00 00 00 
  80366c:	ff d0                	callq  *%rax
  80366e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803671:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803675:	79 05                	jns    80367c <shutdown+0x2d>
		return r;
  803677:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367a:	eb 16                	jmp    803692 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80367c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80367f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803682:	89 d6                	mov    %edx,%esi
  803684:	89 c7                	mov    %eax,%edi
  803686:	48 b8 c0 39 80 00 00 	movabs $0x8039c0,%rax
  80368d:	00 00 00 
  803690:	ff d0                	callq  *%rax
}
  803692:	c9                   	leaveq 
  803693:	c3                   	retq   

0000000000803694 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803694:	55                   	push   %rbp
  803695:	48 89 e5             	mov    %rsp,%rbp
  803698:	48 83 ec 10          	sub    $0x10,%rsp
  80369c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8036a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036a4:	48 89 c7             	mov    %rax,%rdi
  8036a7:	48 b8 b8 4c 80 00 00 	movabs $0x804cb8,%rax
  8036ae:	00 00 00 
  8036b1:	ff d0                	callq  *%rax
  8036b3:	83 f8 01             	cmp    $0x1,%eax
  8036b6:	75 17                	jne    8036cf <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8036b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036bc:	8b 40 0c             	mov    0xc(%rax),%eax
  8036bf:	89 c7                	mov    %eax,%edi
  8036c1:	48 b8 00 3a 80 00 00 	movabs $0x803a00,%rax
  8036c8:	00 00 00 
  8036cb:	ff d0                	callq  *%rax
  8036cd:	eb 05                	jmp    8036d4 <devsock_close+0x40>
	else
		return 0;
  8036cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036d4:	c9                   	leaveq 
  8036d5:	c3                   	retq   

00000000008036d6 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036d6:	55                   	push   %rbp
  8036d7:	48 89 e5             	mov    %rsp,%rbp
  8036da:	48 83 ec 20          	sub    $0x20,%rsp
  8036de:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036e5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036eb:	89 c7                	mov    %eax,%edi
  8036ed:	48 b8 9c 34 80 00 00 	movabs $0x80349c,%rax
  8036f4:	00 00 00 
  8036f7:	ff d0                	callq  *%rax
  8036f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803700:	79 05                	jns    803707 <connect+0x31>
		return r;
  803702:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803705:	eb 1b                	jmp    803722 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803707:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80370a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80370e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803711:	48 89 ce             	mov    %rcx,%rsi
  803714:	89 c7                	mov    %eax,%edi
  803716:	48 b8 2d 3a 80 00 00 	movabs $0x803a2d,%rax
  80371d:	00 00 00 
  803720:	ff d0                	callq  *%rax
}
  803722:	c9                   	leaveq 
  803723:	c3                   	retq   

0000000000803724 <listen>:

int
listen(int s, int backlog)
{
  803724:	55                   	push   %rbp
  803725:	48 89 e5             	mov    %rsp,%rbp
  803728:	48 83 ec 20          	sub    $0x20,%rsp
  80372c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80372f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803732:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803735:	89 c7                	mov    %eax,%edi
  803737:	48 b8 9c 34 80 00 00 	movabs $0x80349c,%rax
  80373e:	00 00 00 
  803741:	ff d0                	callq  *%rax
  803743:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803746:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80374a:	79 05                	jns    803751 <listen+0x2d>
		return r;
  80374c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80374f:	eb 16                	jmp    803767 <listen+0x43>
	return nsipc_listen(r, backlog);
  803751:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803754:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803757:	89 d6                	mov    %edx,%esi
  803759:	89 c7                	mov    %eax,%edi
  80375b:	48 b8 91 3a 80 00 00 	movabs $0x803a91,%rax
  803762:	00 00 00 
  803765:	ff d0                	callq  *%rax
}
  803767:	c9                   	leaveq 
  803768:	c3                   	retq   

0000000000803769 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803769:	55                   	push   %rbp
  80376a:	48 89 e5             	mov    %rsp,%rbp
  80376d:	48 83 ec 20          	sub    $0x20,%rsp
  803771:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803775:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803779:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80377d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803781:	89 c2                	mov    %eax,%edx
  803783:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803787:	8b 40 0c             	mov    0xc(%rax),%eax
  80378a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80378e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803793:	89 c7                	mov    %eax,%edi
  803795:	48 b8 d1 3a 80 00 00 	movabs $0x803ad1,%rax
  80379c:	00 00 00 
  80379f:	ff d0                	callq  *%rax
}
  8037a1:	c9                   	leaveq 
  8037a2:	c3                   	retq   

00000000008037a3 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8037a3:	55                   	push   %rbp
  8037a4:	48 89 e5             	mov    %rsp,%rbp
  8037a7:	48 83 ec 20          	sub    $0x20,%rsp
  8037ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8037b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037bb:	89 c2                	mov    %eax,%edx
  8037bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c1:	8b 40 0c             	mov    0xc(%rax),%eax
  8037c4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8037c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8037cd:	89 c7                	mov    %eax,%edi
  8037cf:	48 b8 9d 3b 80 00 00 	movabs $0x803b9d,%rax
  8037d6:	00 00 00 
  8037d9:	ff d0                	callq  *%rax
}
  8037db:	c9                   	leaveq 
  8037dc:	c3                   	retq   

00000000008037dd <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8037dd:	55                   	push   %rbp
  8037de:	48 89 e5             	mov    %rsp,%rbp
  8037e1:	48 83 ec 10          	sub    $0x10,%rsp
  8037e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8037ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f1:	48 be 73 5a 80 00 00 	movabs $0x805a73,%rsi
  8037f8:	00 00 00 
  8037fb:	48 89 c7             	mov    %rax,%rdi
  8037fe:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  803805:	00 00 00 
  803808:	ff d0                	callq  *%rax
	return 0;
  80380a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80380f:	c9                   	leaveq 
  803810:	c3                   	retq   

0000000000803811 <socket>:

int
socket(int domain, int type, int protocol)
{
  803811:	55                   	push   %rbp
  803812:	48 89 e5             	mov    %rsp,%rbp
  803815:	48 83 ec 20          	sub    $0x20,%rsp
  803819:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80381c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80381f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803822:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803825:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803828:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80382b:	89 ce                	mov    %ecx,%esi
  80382d:	89 c7                	mov    %eax,%edi
  80382f:	48 b8 55 3c 80 00 00 	movabs $0x803c55,%rax
  803836:	00 00 00 
  803839:	ff d0                	callq  *%rax
  80383b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80383e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803842:	79 05                	jns    803849 <socket+0x38>
		return r;
  803844:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803847:	eb 11                	jmp    80385a <socket+0x49>
	return alloc_sockfd(r);
  803849:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384c:	89 c7                	mov    %eax,%edi
  80384e:	48 b8 f3 34 80 00 00 	movabs $0x8034f3,%rax
  803855:	00 00 00 
  803858:	ff d0                	callq  *%rax
}
  80385a:	c9                   	leaveq 
  80385b:	c3                   	retq   

000000000080385c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80385c:	55                   	push   %rbp
  80385d:	48 89 e5             	mov    %rsp,%rbp
  803860:	48 83 ec 10          	sub    $0x10,%rsp
  803864:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803867:	48 b8 2c 80 80 00 00 	movabs $0x80802c,%rax
  80386e:	00 00 00 
  803871:	8b 00                	mov    (%rax),%eax
  803873:	85 c0                	test   %eax,%eax
  803875:	75 1d                	jne    803894 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803877:	bf 02 00 00 00       	mov    $0x2,%edi
  80387c:	48 b8 33 4c 80 00 00 	movabs $0x804c33,%rax
  803883:	00 00 00 
  803886:	ff d0                	callq  *%rax
  803888:	48 ba 2c 80 80 00 00 	movabs $0x80802c,%rdx
  80388f:	00 00 00 
  803892:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803894:	48 b8 2c 80 80 00 00 	movabs $0x80802c,%rax
  80389b:	00 00 00 
  80389e:	8b 00                	mov    (%rax),%eax
  8038a0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8038a3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8038a8:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8038af:	00 00 00 
  8038b2:	89 c7                	mov    %eax,%edi
  8038b4:	48 b8 70 4b 80 00 00 	movabs $0x804b70,%rax
  8038bb:	00 00 00 
  8038be:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8038c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8038c5:	be 00 00 00 00       	mov    $0x0,%esi
  8038ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8038cf:	48 b8 b0 4a 80 00 00 	movabs $0x804ab0,%rax
  8038d6:	00 00 00 
  8038d9:	ff d0                	callq  *%rax
}
  8038db:	c9                   	leaveq 
  8038dc:	c3                   	retq   

00000000008038dd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8038dd:	55                   	push   %rbp
  8038de:	48 89 e5             	mov    %rsp,%rbp
  8038e1:	48 83 ec 30          	sub    $0x30,%rsp
  8038e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8038f0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038f7:	00 00 00 
  8038fa:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038fd:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8038ff:	bf 01 00 00 00       	mov    $0x1,%edi
  803904:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  80390b:	00 00 00 
  80390e:	ff d0                	callq  *%rax
  803910:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803913:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803917:	78 3e                	js     803957 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803919:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803920:	00 00 00 
  803923:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803927:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80392b:	8b 40 10             	mov    0x10(%rax),%eax
  80392e:	89 c2                	mov    %eax,%edx
  803930:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803934:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803938:	48 89 ce             	mov    %rcx,%rsi
  80393b:	48 89 c7             	mov    %rax,%rdi
  80393e:	48 b8 3e 1e 80 00 00 	movabs $0x801e3e,%rax
  803945:	00 00 00 
  803948:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80394a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80394e:	8b 50 10             	mov    0x10(%rax),%edx
  803951:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803955:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803957:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80395a:	c9                   	leaveq 
  80395b:	c3                   	retq   

000000000080395c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80395c:	55                   	push   %rbp
  80395d:	48 89 e5             	mov    %rsp,%rbp
  803960:	48 83 ec 10          	sub    $0x10,%rsp
  803964:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803967:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80396b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80396e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803975:	00 00 00 
  803978:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80397b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80397d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803980:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803984:	48 89 c6             	mov    %rax,%rsi
  803987:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80398e:	00 00 00 
  803991:	48 b8 3e 1e 80 00 00 	movabs $0x801e3e,%rax
  803998:	00 00 00 
  80399b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80399d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039a4:	00 00 00 
  8039a7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039aa:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8039ad:	bf 02 00 00 00       	mov    $0x2,%edi
  8039b2:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  8039b9:	00 00 00 
  8039bc:	ff d0                	callq  *%rax
}
  8039be:	c9                   	leaveq 
  8039bf:	c3                   	retq   

00000000008039c0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8039c0:	55                   	push   %rbp
  8039c1:	48 89 e5             	mov    %rsp,%rbp
  8039c4:	48 83 ec 10          	sub    $0x10,%rsp
  8039c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039cb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8039ce:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039d5:	00 00 00 
  8039d8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039db:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8039dd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039e4:	00 00 00 
  8039e7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039ea:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8039ed:	bf 03 00 00 00       	mov    $0x3,%edi
  8039f2:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  8039f9:	00 00 00 
  8039fc:	ff d0                	callq  *%rax
}
  8039fe:	c9                   	leaveq 
  8039ff:	c3                   	retq   

0000000000803a00 <nsipc_close>:

int
nsipc_close(int s)
{
  803a00:	55                   	push   %rbp
  803a01:	48 89 e5             	mov    %rsp,%rbp
  803a04:	48 83 ec 10          	sub    $0x10,%rsp
  803a08:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803a0b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a12:	00 00 00 
  803a15:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a18:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803a1a:	bf 04 00 00 00       	mov    $0x4,%edi
  803a1f:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  803a26:	00 00 00 
  803a29:	ff d0                	callq  *%rax
}
  803a2b:	c9                   	leaveq 
  803a2c:	c3                   	retq   

0000000000803a2d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a2d:	55                   	push   %rbp
  803a2e:	48 89 e5             	mov    %rsp,%rbp
  803a31:	48 83 ec 10          	sub    $0x10,%rsp
  803a35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a3c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803a3f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a46:	00 00 00 
  803a49:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a4c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803a4e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a55:	48 89 c6             	mov    %rax,%rsi
  803a58:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803a5f:	00 00 00 
  803a62:	48 b8 3e 1e 80 00 00 	movabs $0x801e3e,%rax
  803a69:	00 00 00 
  803a6c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803a6e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a75:	00 00 00 
  803a78:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a7b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803a7e:	bf 05 00 00 00       	mov    $0x5,%edi
  803a83:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  803a8a:	00 00 00 
  803a8d:	ff d0                	callq  *%rax
}
  803a8f:	c9                   	leaveq 
  803a90:	c3                   	retq   

0000000000803a91 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803a91:	55                   	push   %rbp
  803a92:	48 89 e5             	mov    %rsp,%rbp
  803a95:	48 83 ec 10          	sub    $0x10,%rsp
  803a99:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a9c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803a9f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aa6:	00 00 00 
  803aa9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803aac:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803aae:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ab5:	00 00 00 
  803ab8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803abb:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803abe:	bf 06 00 00 00       	mov    $0x6,%edi
  803ac3:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  803aca:	00 00 00 
  803acd:	ff d0                	callq  *%rax
}
  803acf:	c9                   	leaveq 
  803ad0:	c3                   	retq   

0000000000803ad1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803ad1:	55                   	push   %rbp
  803ad2:	48 89 e5             	mov    %rsp,%rbp
  803ad5:	48 83 ec 30          	sub    $0x30,%rsp
  803ad9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803adc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ae0:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803ae3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803ae6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aed:	00 00 00 
  803af0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803af3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803af5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803afc:	00 00 00 
  803aff:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b02:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803b05:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b0c:	00 00 00 
  803b0f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803b12:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b15:	bf 07 00 00 00       	mov    $0x7,%edi
  803b1a:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  803b21:	00 00 00 
  803b24:	ff d0                	callq  *%rax
  803b26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b2d:	78 69                	js     803b98 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803b2f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803b36:	7f 08                	jg     803b40 <nsipc_recv+0x6f>
  803b38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803b3e:	7e 35                	jle    803b75 <nsipc_recv+0xa4>
  803b40:	48 b9 7a 5a 80 00 00 	movabs $0x805a7a,%rcx
  803b47:	00 00 00 
  803b4a:	48 ba 8f 5a 80 00 00 	movabs $0x805a8f,%rdx
  803b51:	00 00 00 
  803b54:	be 61 00 00 00       	mov    $0x61,%esi
  803b59:	48 bf a4 5a 80 00 00 	movabs $0x805aa4,%rdi
  803b60:	00 00 00 
  803b63:	b8 00 00 00 00       	mov    $0x0,%eax
  803b68:	49 b8 24 0d 80 00 00 	movabs $0x800d24,%r8
  803b6f:	00 00 00 
  803b72:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803b75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b78:	48 63 d0             	movslq %eax,%rdx
  803b7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b7f:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803b86:	00 00 00 
  803b89:	48 89 c7             	mov    %rax,%rdi
  803b8c:	48 b8 3e 1e 80 00 00 	movabs $0x801e3e,%rax
  803b93:	00 00 00 
  803b96:	ff d0                	callq  *%rax
	}

	return r;
  803b98:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b9b:	c9                   	leaveq 
  803b9c:	c3                   	retq   

0000000000803b9d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803b9d:	55                   	push   %rbp
  803b9e:	48 89 e5             	mov    %rsp,%rbp
  803ba1:	48 83 ec 20          	sub    $0x20,%rsp
  803ba5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ba8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bac:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803baf:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803bb2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bb9:	00 00 00 
  803bbc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bbf:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803bc1:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803bc8:	7e 35                	jle    803bff <nsipc_send+0x62>
  803bca:	48 b9 b0 5a 80 00 00 	movabs $0x805ab0,%rcx
  803bd1:	00 00 00 
  803bd4:	48 ba 8f 5a 80 00 00 	movabs $0x805a8f,%rdx
  803bdb:	00 00 00 
  803bde:	be 6c 00 00 00       	mov    $0x6c,%esi
  803be3:	48 bf a4 5a 80 00 00 	movabs $0x805aa4,%rdi
  803bea:	00 00 00 
  803bed:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf2:	49 b8 24 0d 80 00 00 	movabs $0x800d24,%r8
  803bf9:	00 00 00 
  803bfc:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803bff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c02:	48 63 d0             	movslq %eax,%rdx
  803c05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c09:	48 89 c6             	mov    %rax,%rsi
  803c0c:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803c13:	00 00 00 
  803c16:	48 b8 3e 1e 80 00 00 	movabs $0x801e3e,%rax
  803c1d:	00 00 00 
  803c20:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803c22:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c29:	00 00 00 
  803c2c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c2f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803c32:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c39:	00 00 00 
  803c3c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c3f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803c42:	bf 08 00 00 00       	mov    $0x8,%edi
  803c47:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  803c4e:	00 00 00 
  803c51:	ff d0                	callq  *%rax
}
  803c53:	c9                   	leaveq 
  803c54:	c3                   	retq   

0000000000803c55 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803c55:	55                   	push   %rbp
  803c56:	48 89 e5             	mov    %rsp,%rbp
  803c59:	48 83 ec 10          	sub    $0x10,%rsp
  803c5d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c60:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803c63:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803c66:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c6d:	00 00 00 
  803c70:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c73:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803c75:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c7c:	00 00 00 
  803c7f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c82:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803c85:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c8c:	00 00 00 
  803c8f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803c92:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803c95:	bf 09 00 00 00       	mov    $0x9,%edi
  803c9a:	48 b8 5c 38 80 00 00 	movabs $0x80385c,%rax
  803ca1:	00 00 00 
  803ca4:	ff d0                	callq  *%rax
}
  803ca6:	c9                   	leaveq 
  803ca7:	c3                   	retq   

0000000000803ca8 <isfree>:
static uint8_t *mend   = (uint8_t*) 0x10000000;
static uint8_t *mptr;

static int
isfree(void *v, size_t n)
{
  803ca8:	55                   	push   %rbp
  803ca9:	48 89 e5             	mov    %rsp,%rbp
  803cac:	48 83 ec 20          	sub    $0x20,%rsp
  803cb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803cb4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	uintptr_t va, end_va = (uintptr_t) v + n;
  803cb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cbc:	48 03 45 e0          	add    -0x20(%rbp),%rax
  803cc0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803cc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cc8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803ccc:	eb 62                	jmp    803d30 <isfree+0x88>
		if (va >= (uintptr_t) mend
  803cce:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803cd5:	00 00 00 
  803cd8:	48 8b 00             	mov    (%rax),%rax
  803cdb:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803cdf:	76 40                	jbe    803d21 <isfree+0x79>
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  803ce1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ce5:	48 89 c2             	mov    %rax,%rdx
  803ce8:	48 c1 ea 15          	shr    $0x15,%rdx
  803cec:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803cf3:	01 00 00 
  803cf6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cfa:	83 e0 01             	and    $0x1,%eax
  803cfd:	84 c0                	test   %al,%al
  803cff:	74 27                	je     803d28 <isfree+0x80>
  803d01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d05:	48 89 c2             	mov    %rax,%rdx
  803d08:	48 c1 ea 0c          	shr    $0xc,%rdx
  803d0c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d13:	01 00 00 
  803d16:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d1a:	83 e0 01             	and    $0x1,%eax
  803d1d:	84 c0                	test   %al,%al
  803d1f:	74 07                	je     803d28 <isfree+0x80>
			return 0;
  803d21:	b8 00 00 00 00       	mov    $0x0,%eax
  803d26:	eb 17                	jmp    803d3f <isfree+0x97>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  803d28:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803d2f:	00 
  803d30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d34:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803d38:	72 94                	jb     803cce <isfree+0x26>
		if (va >= (uintptr_t) mend
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
			return 0;
	return 1;
  803d3a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d3f:	c9                   	leaveq 
  803d40:	c3                   	retq   

0000000000803d41 <malloc>:

void*
malloc(size_t n)
{
  803d41:	55                   	push   %rbp
  803d42:	48 89 e5             	mov    %rsp,%rbp
  803d45:	48 83 ec 60          	sub    $0x60,%rsp
  803d49:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  803d4d:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803d54:	00 00 00 
  803d57:	48 8b 00             	mov    (%rax),%rax
  803d5a:	48 85 c0             	test   %rax,%rax
  803d5d:	75 1a                	jne    803d79 <malloc+0x38>
		mptr = mbegin;
  803d5f:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  803d66:	00 00 00 
  803d69:	48 8b 10             	mov    (%rax),%rdx
  803d6c:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803d73:	00 00 00 
  803d76:	48 89 10             	mov    %rdx,(%rax)

	n = ROUNDUP(n, 4);
  803d79:	48 c7 45 f0 04 00 00 	movq   $0x4,-0x10(%rbp)
  803d80:	00 
  803d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d85:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803d89:	48 01 d0             	add    %rdx,%rax
  803d8c:	48 83 e8 01          	sub    $0x1,%rax
  803d90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803d94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d98:	ba 00 00 00 00       	mov    $0x0,%edx
  803d9d:	48 f7 75 f0          	divq   -0x10(%rbp)
  803da1:	48 89 d0             	mov    %rdx,%rax
  803da4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803da8:	48 89 d1             	mov    %rdx,%rcx
  803dab:	48 29 c1             	sub    %rax,%rcx
  803dae:	48 89 c8             	mov    %rcx,%rax
  803db1:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	if (n >= MAXMALLOC)
  803db5:	48 81 7d a8 ff ff 0f 	cmpq   $0xfffff,-0x58(%rbp)
  803dbc:	00 
  803dbd:	76 0a                	jbe    803dc9 <malloc+0x88>
		return 0;
  803dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc4:	e9 f6 02 00 00       	jmpq   8040bf <malloc+0x37e>

	if ((uintptr_t) mptr % PGSIZE){
  803dc9:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803dd0:	00 00 00 
  803dd3:	48 8b 00             	mov    (%rax),%rax
  803dd6:	25 ff 0f 00 00       	and    $0xfff,%eax
  803ddb:	48 85 c0             	test   %rax,%rax
  803dde:	0f 84 12 01 00 00    	je     803ef6 <malloc+0x1b5>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  803de4:	48 c7 45 e0 00 10 00 	movq   $0x1000,-0x20(%rbp)
  803deb:	00 
  803dec:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803df3:	00 00 00 
  803df6:	48 8b 00             	mov    (%rax),%rax
  803df9:	48 03 45 e0          	add    -0x20(%rbp),%rax
  803dfd:	48 83 e8 01          	sub    $0x1,%rax
  803e01:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803e05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e09:	ba 00 00 00 00       	mov    $0x0,%edx
  803e0e:	48 f7 75 e0          	divq   -0x20(%rbp)
  803e12:	48 89 d0             	mov    %rdx,%rax
  803e15:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803e19:	48 89 d1             	mov    %rdx,%rcx
  803e1c:	48 29 c1             	sub    %rax,%rcx
  803e1f:	48 89 c8             	mov    %rcx,%rax
  803e22:	48 83 e8 04          	sub    $0x4,%rax
  803e26:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  803e2a:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803e31:	00 00 00 
  803e34:	48 8b 00             	mov    (%rax),%rax
  803e37:	48 89 c1             	mov    %rax,%rcx
  803e3a:	48 c1 e9 0c          	shr    $0xc,%rcx
  803e3e:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803e45:	00 00 00 
  803e48:	48 8b 00             	mov    (%rax),%rax
  803e4b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803e4f:	48 83 c2 03          	add    $0x3,%rdx
  803e53:	48 01 d0             	add    %rdx,%rax
  803e56:	48 c1 e8 0c          	shr    $0xc,%rax
  803e5a:	48 39 c1             	cmp    %rax,%rcx
  803e5d:	75 4a                	jne    803ea9 <malloc+0x168>
			(*ref)++;
  803e5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e63:	8b 00                	mov    (%rax),%eax
  803e65:	8d 50 01             	lea    0x1(%rax),%edx
  803e68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e6c:	89 10                	mov    %edx,(%rax)
			v = mptr;
  803e6e:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803e75:	00 00 00 
  803e78:	48 8b 00             	mov    (%rax),%rax
  803e7b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			mptr += n;
  803e7f:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803e86:	00 00 00 
  803e89:	48 8b 00             	mov    (%rax),%rax
  803e8c:	48 89 c2             	mov    %rax,%rdx
  803e8f:	48 03 55 a8          	add    -0x58(%rbp),%rdx
  803e93:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803e9a:	00 00 00 
  803e9d:	48 89 10             	mov    %rdx,(%rax)
			return v;
  803ea0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ea4:	e9 16 02 00 00       	jmpq   8040bf <malloc+0x37e>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  803ea9:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803eb0:	00 00 00 
  803eb3:	48 8b 00             	mov    (%rax),%rax
  803eb6:	48 89 c7             	mov    %rax,%rdi
  803eb9:	48 b8 c1 40 80 00 00 	movabs $0x8040c1,%rax
  803ec0:	00 00 00 
  803ec3:	ff d0                	callq  *%rax
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  803ec5:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803ecc:	00 00 00 
  803ecf:	48 8b 00             	mov    (%rax),%rax
  803ed2:	48 05 00 10 00 00    	add    $0x1000,%rax
  803ed8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803edc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803ee0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803ee6:	48 89 c2             	mov    %rax,%rdx
  803ee9:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803ef0:	00 00 00 
  803ef3:	48 89 10             	mov    %rdx,(%rax)
	 * now we need to find some address space for this chunk.
	 * if it's less than a page we leave it open for allocation.
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
  803ef6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  803efd:	eb 01                	jmp    803f00 <malloc+0x1bf>
		if (mptr == mend) {
			mptr = mbegin;
			if (++nwrap == 2)
				return 0;	/* out of address space */
		}
	}
  803eff:	90                   	nop
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
  803f00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803f04:	48 8d 50 04          	lea    0x4(%rax),%rdx
  803f08:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803f0f:	00 00 00 
  803f12:	48 8b 00             	mov    (%rax),%rax
  803f15:	48 89 d6             	mov    %rdx,%rsi
  803f18:	48 89 c7             	mov    %rax,%rdi
  803f1b:	48 b8 a8 3c 80 00 00 	movabs $0x803ca8,%rax
  803f22:	00 00 00 
  803f25:	ff d0                	callq  *%rax
  803f27:	85 c0                	test   %eax,%eax
  803f29:	75 72                	jne    803f9d <malloc+0x25c>
			break;
		mptr += PGSIZE;
  803f2b:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803f32:	00 00 00 
  803f35:	48 8b 00             	mov    (%rax),%rax
  803f38:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
  803f3f:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803f46:	00 00 00 
  803f49:	48 89 10             	mov    %rdx,(%rax)
		if (mptr == mend) {
  803f4c:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803f53:	00 00 00 
  803f56:	48 8b 10             	mov    (%rax),%rdx
  803f59:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803f60:	00 00 00 
  803f63:	48 8b 00             	mov    (%rax),%rax
  803f66:	48 39 c2             	cmp    %rax,%rdx
  803f69:	75 94                	jne    803eff <malloc+0x1be>
			mptr = mbegin;
  803f6b:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  803f72:	00 00 00 
  803f75:	48 8b 10             	mov    (%rax),%rdx
  803f78:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803f7f:	00 00 00 
  803f82:	48 89 10             	mov    %rdx,(%rax)
			if (++nwrap == 2)
  803f85:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  803f89:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
  803f8d:	0f 85 6c ff ff ff    	jne    803eff <malloc+0x1be>
				return 0;	/* out of address space */
  803f93:	b8 00 00 00 00       	mov    $0x0,%eax
  803f98:	e9 22 01 00 00       	jmpq   8040bf <malloc+0x37e>
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
  803f9d:	90                   	nop
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  803f9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fa5:	e9 a1 00 00 00       	jmpq   80404b <malloc+0x30a>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  803faa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fad:	05 00 10 00 00       	add    $0x1000,%eax
  803fb2:	48 98                	cltq   
  803fb4:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803fb8:	48 83 c2 04          	add    $0x4,%rdx
  803fbc:	48 39 d0             	cmp    %rdx,%rax
  803fbf:	73 07                	jae    803fc8 <malloc+0x287>
  803fc1:	b8 00 04 00 00       	mov    $0x400,%eax
  803fc6:	eb 05                	jmp    803fcd <malloc+0x28c>
  803fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  803fcd:	89 45 bc             	mov    %eax,-0x44(%rbp)
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  803fd0:	8b 45 bc             	mov    -0x44(%rbp),%eax
  803fd3:	89 c2                	mov    %eax,%edx
  803fd5:	83 ca 07             	or     $0x7,%edx
  803fd8:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  803fdf:	00 00 00 
  803fe2:	48 8b 08             	mov    (%rax),%rcx
  803fe5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fe8:	48 98                	cltq   
  803fea:	48 01 c8             	add    %rcx,%rax
  803fed:	48 89 c6             	mov    %rax,%rsi
  803ff0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ff5:	48 b8 54 24 80 00 00 	movabs $0x802454,%rax
  803ffc:	00 00 00 
  803fff:	ff d0                	callq  *%rax
  804001:	85 c0                	test   %eax,%eax
  804003:	79 3f                	jns    804044 <malloc+0x303>
			for (; i >= 0; i -= PGSIZE)
  804005:	eb 30                	jmp    804037 <malloc+0x2f6>
				sys_page_unmap(0, mptr + i);
  804007:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  80400e:	00 00 00 
  804011:	48 8b 10             	mov    (%rax),%rdx
  804014:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804017:	48 98                	cltq   
  804019:	48 01 d0             	add    %rdx,%rax
  80401c:	48 89 c6             	mov    %rax,%rsi
  80401f:	bf 00 00 00 00       	mov    $0x0,%edi
  804024:	48 b8 ff 24 80 00 00 	movabs $0x8024ff,%rax
  80402b:	00 00 00 
  80402e:	ff d0                	callq  *%rax
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  804030:	81 6d fc 00 10 00 00 	subl   $0x1000,-0x4(%rbp)
  804037:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80403b:	79 ca                	jns    804007 <malloc+0x2c6>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
  80403d:	b8 00 00 00 00       	mov    $0x0,%eax
  804042:	eb 7b                	jmp    8040bf <malloc+0x37e>
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  804044:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80404b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80404e:	48 98                	cltq   
  804050:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  804054:	48 83 c2 04          	add    $0x4,%rdx
  804058:	48 39 d0             	cmp    %rdx,%rax
  80405b:	0f 82 49 ff ff ff    	jb     803faa <malloc+0x269>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  804061:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  804068:	00 00 00 
  80406b:	48 8b 00             	mov    (%rax),%rax
  80406e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804071:	48 63 d2             	movslq %edx,%rdx
  804074:	48 83 ea 04          	sub    $0x4,%rdx
  804078:	48 01 d0             	add    %rdx,%rax
  80407b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	*ref = 2;	/* reference for mptr, reference for returned block */
  80407f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804083:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
	v = mptr;
  804089:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  804090:	00 00 00 
  804093:	48 8b 00             	mov    (%rax),%rax
  804096:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	mptr += n;
  80409a:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  8040a1:	00 00 00 
  8040a4:	48 8b 00             	mov    (%rax),%rax
  8040a7:	48 89 c2             	mov    %rax,%rdx
  8040aa:	48 03 55 a8          	add    -0x58(%rbp),%rdx
  8040ae:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  8040b5:	00 00 00 
  8040b8:	48 89 10             	mov    %rdx,(%rax)
	return v;
  8040bb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
  8040bf:	c9                   	leaveq 
  8040c0:	c3                   	retq   

00000000008040c1 <free>:

void
free(void *v)
{
  8040c1:	55                   	push   %rbp
  8040c2:	48 89 e5             	mov    %rsp,%rbp
  8040c5:	48 83 ec 30          	sub    $0x30,%rsp
  8040c9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  8040cd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040d2:	0f 84 56 01 00 00    	je     80422e <free+0x16d>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  8040d8:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  8040df:	00 00 00 
  8040e2:	48 8b 00             	mov    (%rax),%rax
  8040e5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8040e9:	77 13                	ja     8040fe <free+0x3d>
  8040eb:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8040f2:	00 00 00 
  8040f5:	48 8b 00             	mov    (%rax),%rax
  8040f8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8040fc:	72 35                	jb     804133 <free+0x72>
  8040fe:	48 b9 c0 5a 80 00 00 	movabs $0x805ac0,%rcx
  804105:	00 00 00 
  804108:	48 ba ee 5a 80 00 00 	movabs $0x805aee,%rdx
  80410f:	00 00 00 
  804112:	be 7a 00 00 00       	mov    $0x7a,%esi
  804117:	48 bf 03 5b 80 00 00 	movabs $0x805b03,%rdi
  80411e:	00 00 00 
  804121:	b8 00 00 00 00       	mov    $0x0,%eax
  804126:	49 b8 24 0d 80 00 00 	movabs $0x800d24,%r8
  80412d:	00 00 00 
  804130:	41 ff d0             	callq  *%r8

	c = ROUNDDOWN(v, PGSIZE);
  804133:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804137:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80413b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80413f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804145:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  804149:	eb 7b                	jmp    8041c6 <free+0x105>
		sys_page_unmap(0, c);
  80414b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80414f:	48 89 c6             	mov    %rax,%rsi
  804152:	bf 00 00 00 00       	mov    $0x0,%edi
  804157:	48 b8 ff 24 80 00 00 	movabs $0x8024ff,%rax
  80415e:	00 00 00 
  804161:	ff d0                	callq  *%rax
		c += PGSIZE;
  804163:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  80416a:	00 
		assert(mbegin <= c && c < mend);
  80416b:	48 b8 18 71 80 00 00 	movabs $0x807118,%rax
  804172:	00 00 00 
  804175:	48 8b 00             	mov    (%rax),%rax
  804178:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80417c:	77 13                	ja     804191 <free+0xd0>
  80417e:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804185:	00 00 00 
  804188:	48 8b 00             	mov    (%rax),%rax
  80418b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80418f:	72 35                	jb     8041c6 <free+0x105>
  804191:	48 b9 10 5b 80 00 00 	movabs $0x805b10,%rcx
  804198:	00 00 00 
  80419b:	48 ba ee 5a 80 00 00 	movabs $0x805aee,%rdx
  8041a2:	00 00 00 
  8041a5:	be 81 00 00 00       	mov    $0x81,%esi
  8041aa:	48 bf 03 5b 80 00 00 	movabs $0x805b03,%rdi
  8041b1:	00 00 00 
  8041b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8041b9:	49 b8 24 0d 80 00 00 	movabs $0x800d24,%r8
  8041c0:	00 00 00 
  8041c3:	41 ff d0             	callq  *%r8
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  8041c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041ca:	48 89 c2             	mov    %rax,%rdx
  8041cd:	48 c1 ea 0c          	shr    $0xc,%rdx
  8041d1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8041d8:	01 00 00 
  8041db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041df:	25 00 04 00 00       	and    $0x400,%eax
  8041e4:	48 85 c0             	test   %rax,%rax
  8041e7:	0f 85 5e ff ff ff    	jne    80414b <free+0x8a>

	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
  8041ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041f1:	48 05 fc 0f 00 00    	add    $0xffc,%rax
  8041f7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (--(*ref) == 0)
  8041fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041ff:	8b 00                	mov    (%rax),%eax
  804201:	8d 50 ff             	lea    -0x1(%rax),%edx
  804204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804208:	89 10                	mov    %edx,(%rax)
  80420a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80420e:	8b 00                	mov    (%rax),%eax
  804210:	85 c0                	test   %eax,%eax
  804212:	75 1b                	jne    80422f <free+0x16e>
		sys_page_unmap(0, c);
  804214:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804218:	48 89 c6             	mov    %rax,%rsi
  80421b:	bf 00 00 00 00       	mov    $0x0,%edi
  804220:	48 b8 ff 24 80 00 00 	movabs $0x8024ff,%rax
  804227:	00 00 00 
  80422a:	ff d0                	callq  *%rax
  80422c:	eb 01                	jmp    80422f <free+0x16e>
{
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
		return;
  80422e:	90                   	nop
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
		sys_page_unmap(0, c);
}
  80422f:	c9                   	leaveq 
  804230:	c3                   	retq   
  804231:	00 00                	add    %al,(%rax)
	...

0000000000804234 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804234:	55                   	push   %rbp
  804235:	48 89 e5             	mov    %rsp,%rbp
  804238:	53                   	push   %rbx
  804239:	48 83 ec 38          	sub    $0x38,%rsp
  80423d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804241:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804245:	48 89 c7             	mov    %rax,%rdi
  804248:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  80424f:	00 00 00 
  804252:	ff d0                	callq  *%rax
  804254:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804257:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80425b:	0f 88 bf 01 00 00    	js     804420 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804261:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804265:	ba 07 04 00 00       	mov    $0x407,%edx
  80426a:	48 89 c6             	mov    %rax,%rsi
  80426d:	bf 00 00 00 00       	mov    $0x0,%edi
  804272:	48 b8 54 24 80 00 00 	movabs $0x802454,%rax
  804279:	00 00 00 
  80427c:	ff d0                	callq  *%rax
  80427e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804281:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804285:	0f 88 95 01 00 00    	js     804420 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80428b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80428f:	48 89 c7             	mov    %rax,%rdi
  804292:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  804299:	00 00 00 
  80429c:	ff d0                	callq  *%rax
  80429e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042a5:	0f 88 5d 01 00 00    	js     804408 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8042ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042af:	ba 07 04 00 00       	mov    $0x407,%edx
  8042b4:	48 89 c6             	mov    %rax,%rsi
  8042b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8042bc:	48 b8 54 24 80 00 00 	movabs $0x802454,%rax
  8042c3:	00 00 00 
  8042c6:	ff d0                	callq  *%rax
  8042c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042cf:	0f 88 33 01 00 00    	js     804408 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8042d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042d9:	48 89 c7             	mov    %rax,%rdi
  8042dc:	48 b8 b7 27 80 00 00 	movabs $0x8027b7,%rax
  8042e3:	00 00 00 
  8042e6:	ff d0                	callq  *%rax
  8042e8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8042ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042f0:	ba 07 04 00 00       	mov    $0x407,%edx
  8042f5:	48 89 c6             	mov    %rax,%rsi
  8042f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8042fd:	48 b8 54 24 80 00 00 	movabs $0x802454,%rax
  804304:	00 00 00 
  804307:	ff d0                	callq  *%rax
  804309:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80430c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804310:	0f 88 d9 00 00 00    	js     8043ef <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804316:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80431a:	48 89 c7             	mov    %rax,%rdi
  80431d:	48 b8 b7 27 80 00 00 	movabs $0x8027b7,%rax
  804324:	00 00 00 
  804327:	ff d0                	callq  *%rax
  804329:	48 89 c2             	mov    %rax,%rdx
  80432c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804330:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804336:	48 89 d1             	mov    %rdx,%rcx
  804339:	ba 00 00 00 00       	mov    $0x0,%edx
  80433e:	48 89 c6             	mov    %rax,%rsi
  804341:	bf 00 00 00 00       	mov    $0x0,%edi
  804346:	48 b8 a4 24 80 00 00 	movabs $0x8024a4,%rax
  80434d:	00 00 00 
  804350:	ff d0                	callq  *%rax
  804352:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804355:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804359:	78 79                	js     8043d4 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80435b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80435f:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  804366:	00 00 00 
  804369:	8b 12                	mov    (%rdx),%edx
  80436b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80436d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804371:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804378:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80437c:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  804383:	00 00 00 
  804386:	8b 12                	mov    (%rdx),%edx
  804388:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80438a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80438e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804395:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804399:	48 89 c7             	mov    %rax,%rdi
  80439c:	48 b8 94 27 80 00 00 	movabs $0x802794,%rax
  8043a3:	00 00 00 
  8043a6:	ff d0                	callq  *%rax
  8043a8:	89 c2                	mov    %eax,%edx
  8043aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043ae:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8043b0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043b4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8043b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043bc:	48 89 c7             	mov    %rax,%rdi
  8043bf:	48 b8 94 27 80 00 00 	movabs $0x802794,%rax
  8043c6:	00 00 00 
  8043c9:	ff d0                	callq  *%rax
  8043cb:	89 03                	mov    %eax,(%rbx)
	return 0;
  8043cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8043d2:	eb 4f                	jmp    804423 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8043d4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8043d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043d9:	48 89 c6             	mov    %rax,%rsi
  8043dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8043e1:	48 b8 ff 24 80 00 00 	movabs $0x8024ff,%rax
  8043e8:	00 00 00 
  8043eb:	ff d0                	callq  *%rax
  8043ed:	eb 01                	jmp    8043f0 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8043ef:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8043f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043f4:	48 89 c6             	mov    %rax,%rsi
  8043f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8043fc:	48 b8 ff 24 80 00 00 	movabs $0x8024ff,%rax
  804403:	00 00 00 
  804406:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  804408:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80440c:	48 89 c6             	mov    %rax,%rsi
  80440f:	bf 00 00 00 00       	mov    $0x0,%edi
  804414:	48 b8 ff 24 80 00 00 	movabs $0x8024ff,%rax
  80441b:	00 00 00 
  80441e:	ff d0                	callq  *%rax
    err:
	return r;
  804420:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804423:	48 83 c4 38          	add    $0x38,%rsp
  804427:	5b                   	pop    %rbx
  804428:	5d                   	pop    %rbp
  804429:	c3                   	retq   

000000000080442a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80442a:	55                   	push   %rbp
  80442b:	48 89 e5             	mov    %rsp,%rbp
  80442e:	53                   	push   %rbx
  80442f:	48 83 ec 28          	sub    $0x28,%rsp
  804433:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804437:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80443b:	eb 01                	jmp    80443e <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  80443d:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80443e:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  804445:	00 00 00 
  804448:	48 8b 00             	mov    (%rax),%rax
  80444b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804451:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804458:	48 89 c7             	mov    %rax,%rdi
  80445b:	48 b8 b8 4c 80 00 00 	movabs $0x804cb8,%rax
  804462:	00 00 00 
  804465:	ff d0                	callq  *%rax
  804467:	89 c3                	mov    %eax,%ebx
  804469:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80446d:	48 89 c7             	mov    %rax,%rdi
  804470:	48 b8 b8 4c 80 00 00 	movabs $0x804cb8,%rax
  804477:	00 00 00 
  80447a:	ff d0                	callq  *%rax
  80447c:	39 c3                	cmp    %eax,%ebx
  80447e:	0f 94 c0             	sete   %al
  804481:	0f b6 c0             	movzbl %al,%eax
  804484:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804487:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80448e:	00 00 00 
  804491:	48 8b 00             	mov    (%rax),%rax
  804494:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80449a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80449d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044a0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8044a3:	75 0a                	jne    8044af <_pipeisclosed+0x85>
			return ret;
  8044a5:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8044a8:	48 83 c4 28          	add    $0x28,%rsp
  8044ac:	5b                   	pop    %rbx
  8044ad:	5d                   	pop    %rbp
  8044ae:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8044af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044b2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8044b5:	74 86                	je     80443d <_pipeisclosed+0x13>
  8044b7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8044bb:	75 80                	jne    80443d <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8044bd:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8044c4:	00 00 00 
  8044c7:	48 8b 00             	mov    (%rax),%rax
  8044ca:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8044d0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8044d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044d6:	89 c6                	mov    %eax,%esi
  8044d8:	48 bf 2d 5b 80 00 00 	movabs $0x805b2d,%rdi
  8044df:	00 00 00 
  8044e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8044e7:	49 b8 5f 0f 80 00 00 	movabs $0x800f5f,%r8
  8044ee:	00 00 00 
  8044f1:	41 ff d0             	callq  *%r8
	}
  8044f4:	e9 44 ff ff ff       	jmpq   80443d <_pipeisclosed+0x13>

00000000008044f9 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  8044f9:	55                   	push   %rbp
  8044fa:	48 89 e5             	mov    %rsp,%rbp
  8044fd:	48 83 ec 30          	sub    $0x30,%rsp
  804501:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804504:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804508:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80450b:	48 89 d6             	mov    %rdx,%rsi
  80450e:	89 c7                	mov    %eax,%edi
  804510:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  804517:	00 00 00 
  80451a:	ff d0                	callq  *%rax
  80451c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80451f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804523:	79 05                	jns    80452a <pipeisclosed+0x31>
		return r;
  804525:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804528:	eb 31                	jmp    80455b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80452a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80452e:	48 89 c7             	mov    %rax,%rdi
  804531:	48 b8 b7 27 80 00 00 	movabs $0x8027b7,%rax
  804538:	00 00 00 
  80453b:	ff d0                	callq  *%rax
  80453d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804545:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804549:	48 89 d6             	mov    %rdx,%rsi
  80454c:	48 89 c7             	mov    %rax,%rdi
  80454f:	48 b8 2a 44 80 00 00 	movabs $0x80442a,%rax
  804556:	00 00 00 
  804559:	ff d0                	callq  *%rax
}
  80455b:	c9                   	leaveq 
  80455c:	c3                   	retq   

000000000080455d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80455d:	55                   	push   %rbp
  80455e:	48 89 e5             	mov    %rsp,%rbp
  804561:	48 83 ec 40          	sub    $0x40,%rsp
  804565:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804569:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80456d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804571:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804575:	48 89 c7             	mov    %rax,%rdi
  804578:	48 b8 b7 27 80 00 00 	movabs $0x8027b7,%rax
  80457f:	00 00 00 
  804582:	ff d0                	callq  *%rax
  804584:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804588:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80458c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804590:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804597:	00 
  804598:	e9 97 00 00 00       	jmpq   804634 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80459d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8045a2:	74 09                	je     8045ad <devpipe_read+0x50>
				return i;
  8045a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045a8:	e9 95 00 00 00       	jmpq   804642 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8045ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045b5:	48 89 d6             	mov    %rdx,%rsi
  8045b8:	48 89 c7             	mov    %rax,%rdi
  8045bb:	48 b8 2a 44 80 00 00 	movabs $0x80442a,%rax
  8045c2:	00 00 00 
  8045c5:	ff d0                	callq  *%rax
  8045c7:	85 c0                	test   %eax,%eax
  8045c9:	74 07                	je     8045d2 <devpipe_read+0x75>
				return 0;
  8045cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8045d0:	eb 70                	jmp    804642 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8045d2:	48 b8 16 24 80 00 00 	movabs $0x802416,%rax
  8045d9:	00 00 00 
  8045dc:	ff d0                	callq  *%rax
  8045de:	eb 01                	jmp    8045e1 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8045e0:	90                   	nop
  8045e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045e5:	8b 10                	mov    (%rax),%edx
  8045e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045eb:	8b 40 04             	mov    0x4(%rax),%eax
  8045ee:	39 c2                	cmp    %eax,%edx
  8045f0:	74 ab                	je     80459d <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8045f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8045fa:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8045fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804602:	8b 00                	mov    (%rax),%eax
  804604:	89 c2                	mov    %eax,%edx
  804606:	c1 fa 1f             	sar    $0x1f,%edx
  804609:	c1 ea 1b             	shr    $0x1b,%edx
  80460c:	01 d0                	add    %edx,%eax
  80460e:	83 e0 1f             	and    $0x1f,%eax
  804611:	29 d0                	sub    %edx,%eax
  804613:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804617:	48 98                	cltq   
  804619:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80461e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804620:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804624:	8b 00                	mov    (%rax),%eax
  804626:	8d 50 01             	lea    0x1(%rax),%edx
  804629:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80462d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80462f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804634:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804638:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80463c:	72 a2                	jb     8045e0 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80463e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804642:	c9                   	leaveq 
  804643:	c3                   	retq   

0000000000804644 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804644:	55                   	push   %rbp
  804645:	48 89 e5             	mov    %rsp,%rbp
  804648:	48 83 ec 40          	sub    $0x40,%rsp
  80464c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804650:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804654:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80465c:	48 89 c7             	mov    %rax,%rdi
  80465f:	48 b8 b7 27 80 00 00 	movabs $0x8027b7,%rax
  804666:	00 00 00 
  804669:	ff d0                	callq  *%rax
  80466b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80466f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804673:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804677:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80467e:	00 
  80467f:	e9 93 00 00 00       	jmpq   804717 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804684:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804688:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80468c:	48 89 d6             	mov    %rdx,%rsi
  80468f:	48 89 c7             	mov    %rax,%rdi
  804692:	48 b8 2a 44 80 00 00 	movabs $0x80442a,%rax
  804699:	00 00 00 
  80469c:	ff d0                	callq  *%rax
  80469e:	85 c0                	test   %eax,%eax
  8046a0:	74 07                	je     8046a9 <devpipe_write+0x65>
				return 0;
  8046a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8046a7:	eb 7c                	jmp    804725 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8046a9:	48 b8 16 24 80 00 00 	movabs $0x802416,%rax
  8046b0:	00 00 00 
  8046b3:	ff d0                	callq  *%rax
  8046b5:	eb 01                	jmp    8046b8 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8046b7:	90                   	nop
  8046b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046bc:	8b 40 04             	mov    0x4(%rax),%eax
  8046bf:	48 63 d0             	movslq %eax,%rdx
  8046c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046c6:	8b 00                	mov    (%rax),%eax
  8046c8:	48 98                	cltq   
  8046ca:	48 83 c0 20          	add    $0x20,%rax
  8046ce:	48 39 c2             	cmp    %rax,%rdx
  8046d1:	73 b1                	jae    804684 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8046d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046d7:	8b 40 04             	mov    0x4(%rax),%eax
  8046da:	89 c2                	mov    %eax,%edx
  8046dc:	c1 fa 1f             	sar    $0x1f,%edx
  8046df:	c1 ea 1b             	shr    $0x1b,%edx
  8046e2:	01 d0                	add    %edx,%eax
  8046e4:	83 e0 1f             	and    $0x1f,%eax
  8046e7:	29 d0                	sub    %edx,%eax
  8046e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8046ed:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8046f1:	48 01 ca             	add    %rcx,%rdx
  8046f4:	0f b6 0a             	movzbl (%rdx),%ecx
  8046f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046fb:	48 98                	cltq   
  8046fd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804701:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804705:	8b 40 04             	mov    0x4(%rax),%eax
  804708:	8d 50 01             	lea    0x1(%rax),%edx
  80470b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80470f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804712:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804717:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80471b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80471f:	72 96                	jb     8046b7 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804721:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804725:	c9                   	leaveq 
  804726:	c3                   	retq   

0000000000804727 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804727:	55                   	push   %rbp
  804728:	48 89 e5             	mov    %rsp,%rbp
  80472b:	48 83 ec 20          	sub    $0x20,%rsp
  80472f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804733:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80473b:	48 89 c7             	mov    %rax,%rdi
  80473e:	48 b8 b7 27 80 00 00 	movabs $0x8027b7,%rax
  804745:	00 00 00 
  804748:	ff d0                	callq  *%rax
  80474a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80474e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804752:	48 be 40 5b 80 00 00 	movabs $0x805b40,%rsi
  804759:	00 00 00 
  80475c:	48 89 c7             	mov    %rax,%rdi
  80475f:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  804766:	00 00 00 
  804769:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80476b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80476f:	8b 50 04             	mov    0x4(%rax),%edx
  804772:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804776:	8b 00                	mov    (%rax),%eax
  804778:	29 c2                	sub    %eax,%edx
  80477a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80477e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804784:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804788:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80478f:	00 00 00 
	stat->st_dev = &devpipe;
  804792:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804796:	48 ba 40 71 80 00 00 	movabs $0x807140,%rdx
  80479d:	00 00 00 
  8047a0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8047a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047ac:	c9                   	leaveq 
  8047ad:	c3                   	retq   

00000000008047ae <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8047ae:	55                   	push   %rbp
  8047af:	48 89 e5             	mov    %rsp,%rbp
  8047b2:	48 83 ec 10          	sub    $0x10,%rsp
  8047b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8047ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047be:	48 89 c6             	mov    %rax,%rsi
  8047c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8047c6:	48 b8 ff 24 80 00 00 	movabs $0x8024ff,%rax
  8047cd:	00 00 00 
  8047d0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8047d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047d6:	48 89 c7             	mov    %rax,%rdi
  8047d9:	48 b8 b7 27 80 00 00 	movabs $0x8027b7,%rax
  8047e0:	00 00 00 
  8047e3:	ff d0                	callq  *%rax
  8047e5:	48 89 c6             	mov    %rax,%rsi
  8047e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8047ed:	48 b8 ff 24 80 00 00 	movabs $0x8024ff,%rax
  8047f4:	00 00 00 
  8047f7:	ff d0                	callq  *%rax
}
  8047f9:	c9                   	leaveq 
  8047fa:	c3                   	retq   
	...

00000000008047fc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8047fc:	55                   	push   %rbp
  8047fd:	48 89 e5             	mov    %rsp,%rbp
  804800:	48 83 ec 20          	sub    $0x20,%rsp
  804804:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804807:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80480a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80480d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804811:	be 01 00 00 00       	mov    $0x1,%esi
  804816:	48 89 c7             	mov    %rax,%rdi
  804819:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  804820:	00 00 00 
  804823:	ff d0                	callq  *%rax
}
  804825:	c9                   	leaveq 
  804826:	c3                   	retq   

0000000000804827 <getchar>:

int
getchar(void)
{
  804827:	55                   	push   %rbp
  804828:	48 89 e5             	mov    %rsp,%rbp
  80482b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80482f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804833:	ba 01 00 00 00       	mov    $0x1,%edx
  804838:	48 89 c6             	mov    %rax,%rsi
  80483b:	bf 00 00 00 00       	mov    $0x0,%edi
  804840:	48 b8 ac 2c 80 00 00 	movabs $0x802cac,%rax
  804847:	00 00 00 
  80484a:	ff d0                	callq  *%rax
  80484c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80484f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804853:	79 05                	jns    80485a <getchar+0x33>
		return r;
  804855:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804858:	eb 14                	jmp    80486e <getchar+0x47>
	if (r < 1)
  80485a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80485e:	7f 07                	jg     804867 <getchar+0x40>
		return -E_EOF;
  804860:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804865:	eb 07                	jmp    80486e <getchar+0x47>
	return c;
  804867:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80486b:	0f b6 c0             	movzbl %al,%eax
}
  80486e:	c9                   	leaveq 
  80486f:	c3                   	retq   

0000000000804870 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804870:	55                   	push   %rbp
  804871:	48 89 e5             	mov    %rsp,%rbp
  804874:	48 83 ec 20          	sub    $0x20,%rsp
  804878:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80487b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80487f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804882:	48 89 d6             	mov    %rdx,%rsi
  804885:	89 c7                	mov    %eax,%edi
  804887:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  80488e:	00 00 00 
  804891:	ff d0                	callq  *%rax
  804893:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804896:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80489a:	79 05                	jns    8048a1 <iscons+0x31>
		return r;
  80489c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80489f:	eb 1a                	jmp    8048bb <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8048a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048a5:	8b 10                	mov    (%rax),%edx
  8048a7:	48 b8 80 71 80 00 00 	movabs $0x807180,%rax
  8048ae:	00 00 00 
  8048b1:	8b 00                	mov    (%rax),%eax
  8048b3:	39 c2                	cmp    %eax,%edx
  8048b5:	0f 94 c0             	sete   %al
  8048b8:	0f b6 c0             	movzbl %al,%eax
}
  8048bb:	c9                   	leaveq 
  8048bc:	c3                   	retq   

00000000008048bd <opencons>:

int
opencons(void)
{
  8048bd:	55                   	push   %rbp
  8048be:	48 89 e5             	mov    %rsp,%rbp
  8048c1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8048c5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8048c9:	48 89 c7             	mov    %rax,%rdi
  8048cc:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  8048d3:	00 00 00 
  8048d6:	ff d0                	callq  *%rax
  8048d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048df:	79 05                	jns    8048e6 <opencons+0x29>
		return r;
  8048e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048e4:	eb 5b                	jmp    804941 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8048e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048ea:	ba 07 04 00 00       	mov    $0x407,%edx
  8048ef:	48 89 c6             	mov    %rax,%rsi
  8048f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8048f7:	48 b8 54 24 80 00 00 	movabs $0x802454,%rax
  8048fe:	00 00 00 
  804901:	ff d0                	callq  *%rax
  804903:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804906:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80490a:	79 05                	jns    804911 <opencons+0x54>
		return r;
  80490c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80490f:	eb 30                	jmp    804941 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804911:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804915:	48 ba 80 71 80 00 00 	movabs $0x807180,%rdx
  80491c:	00 00 00 
  80491f:	8b 12                	mov    (%rdx),%edx
  804921:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804923:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804927:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80492e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804932:	48 89 c7             	mov    %rax,%rdi
  804935:	48 b8 94 27 80 00 00 	movabs $0x802794,%rax
  80493c:	00 00 00 
  80493f:	ff d0                	callq  *%rax
}
  804941:	c9                   	leaveq 
  804942:	c3                   	retq   

0000000000804943 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804943:	55                   	push   %rbp
  804944:	48 89 e5             	mov    %rsp,%rbp
  804947:	48 83 ec 30          	sub    $0x30,%rsp
  80494b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80494f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804953:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804957:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80495c:	75 13                	jne    804971 <devcons_read+0x2e>
		return 0;
  80495e:	b8 00 00 00 00       	mov    $0x0,%eax
  804963:	eb 49                	jmp    8049ae <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804965:	48 b8 16 24 80 00 00 	movabs $0x802416,%rax
  80496c:	00 00 00 
  80496f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804971:	48 b8 56 23 80 00 00 	movabs $0x802356,%rax
  804978:	00 00 00 
  80497b:	ff d0                	callq  *%rax
  80497d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804980:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804984:	74 df                	je     804965 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804986:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80498a:	79 05                	jns    804991 <devcons_read+0x4e>
		return c;
  80498c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80498f:	eb 1d                	jmp    8049ae <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804991:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804995:	75 07                	jne    80499e <devcons_read+0x5b>
		return 0;
  804997:	b8 00 00 00 00       	mov    $0x0,%eax
  80499c:	eb 10                	jmp    8049ae <devcons_read+0x6b>
	*(char*)vbuf = c;
  80499e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049a1:	89 c2                	mov    %eax,%edx
  8049a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049a7:	88 10                	mov    %dl,(%rax)
	return 1;
  8049a9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8049ae:	c9                   	leaveq 
  8049af:	c3                   	retq   

00000000008049b0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8049b0:	55                   	push   %rbp
  8049b1:	48 89 e5             	mov    %rsp,%rbp
  8049b4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8049bb:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8049c2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8049c9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8049d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8049d7:	eb 77                	jmp    804a50 <devcons_write+0xa0>
		m = n - tot;
  8049d9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8049e0:	89 c2                	mov    %eax,%edx
  8049e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049e5:	89 d1                	mov    %edx,%ecx
  8049e7:	29 c1                	sub    %eax,%ecx
  8049e9:	89 c8                	mov    %ecx,%eax
  8049eb:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8049ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8049f1:	83 f8 7f             	cmp    $0x7f,%eax
  8049f4:	76 07                	jbe    8049fd <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8049f6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8049fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a00:	48 63 d0             	movslq %eax,%rdx
  804a03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a06:	48 98                	cltq   
  804a08:	48 89 c1             	mov    %rax,%rcx
  804a0b:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  804a12:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804a19:	48 89 ce             	mov    %rcx,%rsi
  804a1c:	48 89 c7             	mov    %rax,%rdi
  804a1f:	48 b8 3e 1e 80 00 00 	movabs $0x801e3e,%rax
  804a26:	00 00 00 
  804a29:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804a2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a2e:	48 63 d0             	movslq %eax,%rdx
  804a31:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804a38:	48 89 d6             	mov    %rdx,%rsi
  804a3b:	48 89 c7             	mov    %rax,%rdi
  804a3e:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  804a45:	00 00 00 
  804a48:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804a4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a4d:	01 45 fc             	add    %eax,-0x4(%rbp)
  804a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a53:	48 98                	cltq   
  804a55:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804a5c:	0f 82 77 ff ff ff    	jb     8049d9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804a62:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804a65:	c9                   	leaveq 
  804a66:	c3                   	retq   

0000000000804a67 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804a67:	55                   	push   %rbp
  804a68:	48 89 e5             	mov    %rsp,%rbp
  804a6b:	48 83 ec 08          	sub    $0x8,%rsp
  804a6f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804a73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a78:	c9                   	leaveq 
  804a79:	c3                   	retq   

0000000000804a7a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804a7a:	55                   	push   %rbp
  804a7b:	48 89 e5             	mov    %rsp,%rbp
  804a7e:	48 83 ec 10          	sub    $0x10,%rsp
  804a82:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804a86:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804a8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a8e:	48 be 4c 5b 80 00 00 	movabs $0x805b4c,%rsi
  804a95:	00 00 00 
  804a98:	48 89 c7             	mov    %rax,%rdi
  804a9b:	48 b8 1c 1b 80 00 00 	movabs $0x801b1c,%rax
  804aa2:	00 00 00 
  804aa5:	ff d0                	callq  *%rax
	return 0;
  804aa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804aac:	c9                   	leaveq 
  804aad:	c3                   	retq   
	...

0000000000804ab0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804ab0:	55                   	push   %rbp
  804ab1:	48 89 e5             	mov    %rsp,%rbp
  804ab4:	48 83 ec 30          	sub    $0x30,%rsp
  804ab8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804abc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804ac0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  804ac4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804ac9:	74 18                	je     804ae3 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  804acb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804acf:	48 89 c7             	mov    %rax,%rdi
  804ad2:	48 b8 7d 26 80 00 00 	movabs $0x80267d,%rax
  804ad9:	00 00 00 
  804adc:	ff d0                	callq  *%rax
  804ade:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ae1:	eb 19                	jmp    804afc <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  804ae3:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  804aea:	00 00 00 
  804aed:	48 b8 7d 26 80 00 00 	movabs $0x80267d,%rax
  804af4:	00 00 00 
  804af7:	ff d0                	callq  *%rax
  804af9:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  804afc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b00:	79 19                	jns    804b1b <ipc_recv+0x6b>
	{
		*from_env_store=0;
  804b02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b06:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  804b0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b10:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  804b16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b19:	eb 53                	jmp    804b6e <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  804b1b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804b20:	74 19                	je     804b3b <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  804b22:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  804b29:	00 00 00 
  804b2c:	48 8b 00             	mov    (%rax),%rax
  804b2f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804b35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b39:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  804b3b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804b40:	74 19                	je     804b5b <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  804b42:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  804b49:	00 00 00 
  804b4c:	48 8b 00             	mov    (%rax),%rax
  804b4f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804b55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b59:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804b5b:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  804b62:	00 00 00 
  804b65:	48 8b 00             	mov    (%rax),%rax
  804b68:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  804b6e:	c9                   	leaveq 
  804b6f:	c3                   	retq   

0000000000804b70 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804b70:	55                   	push   %rbp
  804b71:	48 89 e5             	mov    %rsp,%rbp
  804b74:	48 83 ec 30          	sub    $0x30,%rsp
  804b78:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804b7b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804b7e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804b82:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  804b85:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  804b8c:	e9 96 00 00 00       	jmpq   804c27 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  804b91:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804b96:	74 20                	je     804bb8 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  804b98:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804b9b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804b9e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804ba2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804ba5:	89 c7                	mov    %eax,%edi
  804ba7:	48 b8 28 26 80 00 00 	movabs $0x802628,%rax
  804bae:	00 00 00 
  804bb1:	ff d0                	callq  *%rax
  804bb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804bb6:	eb 2d                	jmp    804be5 <ipc_send+0x75>
		else if(pg==NULL)
  804bb8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804bbd:	75 26                	jne    804be5 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  804bbf:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804bc2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804bc5:	b9 00 00 00 00       	mov    $0x0,%ecx
  804bca:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804bd1:	00 00 00 
  804bd4:	89 c7                	mov    %eax,%edi
  804bd6:	48 b8 28 26 80 00 00 	movabs $0x802628,%rax
  804bdd:	00 00 00 
  804be0:	ff d0                	callq  *%rax
  804be2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  804be5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804be9:	79 30                	jns    804c1b <ipc_send+0xab>
  804beb:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804bef:	74 2a                	je     804c1b <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  804bf1:	48 ba 53 5b 80 00 00 	movabs $0x805b53,%rdx
  804bf8:	00 00 00 
  804bfb:	be 40 00 00 00       	mov    $0x40,%esi
  804c00:	48 bf 6b 5b 80 00 00 	movabs $0x805b6b,%rdi
  804c07:	00 00 00 
  804c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  804c0f:	48 b9 24 0d 80 00 00 	movabs $0x800d24,%rcx
  804c16:	00 00 00 
  804c19:	ff d1                	callq  *%rcx
		}
		sys_yield();
  804c1b:	48 b8 16 24 80 00 00 	movabs $0x802416,%rax
  804c22:	00 00 00 
  804c25:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  804c27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c2b:	0f 85 60 ff ff ff    	jne    804b91 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  804c31:	c9                   	leaveq 
  804c32:	c3                   	retq   

0000000000804c33 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804c33:	55                   	push   %rbp
  804c34:	48 89 e5             	mov    %rsp,%rbp
  804c37:	48 83 ec 18          	sub    $0x18,%rsp
  804c3b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  804c3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804c45:	eb 5e                	jmp    804ca5 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804c47:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804c4e:	00 00 00 
  804c51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c54:	48 63 d0             	movslq %eax,%rdx
  804c57:	48 89 d0             	mov    %rdx,%rax
  804c5a:	48 c1 e0 03          	shl    $0x3,%rax
  804c5e:	48 01 d0             	add    %rdx,%rax
  804c61:	48 c1 e0 05          	shl    $0x5,%rax
  804c65:	48 01 c8             	add    %rcx,%rax
  804c68:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804c6e:	8b 00                	mov    (%rax),%eax
  804c70:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804c73:	75 2c                	jne    804ca1 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804c75:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804c7c:	00 00 00 
  804c7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c82:	48 63 d0             	movslq %eax,%rdx
  804c85:	48 89 d0             	mov    %rdx,%rax
  804c88:	48 c1 e0 03          	shl    $0x3,%rax
  804c8c:	48 01 d0             	add    %rdx,%rax
  804c8f:	48 c1 e0 05          	shl    $0x5,%rax
  804c93:	48 01 c8             	add    %rcx,%rax
  804c96:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804c9c:	8b 40 08             	mov    0x8(%rax),%eax
  804c9f:	eb 12                	jmp    804cb3 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804ca1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804ca5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804cac:	7e 99                	jle    804c47 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804cae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804cb3:	c9                   	leaveq 
  804cb4:	c3                   	retq   
  804cb5:	00 00                	add    %al,(%rax)
	...

0000000000804cb8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804cb8:	55                   	push   %rbp
  804cb9:	48 89 e5             	mov    %rsp,%rbp
  804cbc:	48 83 ec 18          	sub    $0x18,%rsp
  804cc0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804cc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804cc8:	48 89 c2             	mov    %rax,%rdx
  804ccb:	48 c1 ea 15          	shr    $0x15,%rdx
  804ccf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804cd6:	01 00 00 
  804cd9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804cdd:	83 e0 01             	and    $0x1,%eax
  804ce0:	48 85 c0             	test   %rax,%rax
  804ce3:	75 07                	jne    804cec <pageref+0x34>
		return 0;
  804ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  804cea:	eb 53                	jmp    804d3f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804cec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804cf0:	48 89 c2             	mov    %rax,%rdx
  804cf3:	48 c1 ea 0c          	shr    $0xc,%rdx
  804cf7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804cfe:	01 00 00 
  804d01:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804d09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d0d:	83 e0 01             	and    $0x1,%eax
  804d10:	48 85 c0             	test   %rax,%rax
  804d13:	75 07                	jne    804d1c <pageref+0x64>
		return 0;
  804d15:	b8 00 00 00 00       	mov    $0x0,%eax
  804d1a:	eb 23                	jmp    804d3f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804d1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d20:	48 89 c2             	mov    %rax,%rdx
  804d23:	48 c1 ea 0c          	shr    $0xc,%rdx
  804d27:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804d2e:	00 00 00 
  804d31:	48 c1 e2 04          	shl    $0x4,%rdx
  804d35:	48 01 d0             	add    %rdx,%rax
  804d38:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804d3c:	0f b7 c0             	movzwl %ax,%eax
}
  804d3f:	c9                   	leaveq 
  804d40:	c3                   	retq   
  804d41:	00 00                	add    %al,(%rax)
	...

0000000000804d44 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804d44:	55                   	push   %rbp
  804d45:	48 89 e5             	mov    %rsp,%rbp
  804d48:	48 83 ec 20          	sub    $0x20,%rsp
  804d4c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804d50:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804d54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d58:	48 89 d6             	mov    %rdx,%rsi
  804d5b:	48 89 c7             	mov    %rax,%rdi
  804d5e:	48 b8 7a 4d 80 00 00 	movabs $0x804d7a,%rax
  804d65:	00 00 00 
  804d68:	ff d0                	callq  *%rax
  804d6a:	85 c0                	test   %eax,%eax
  804d6c:	74 05                	je     804d73 <inet_addr+0x2f>
    return (val.s_addr);
  804d6e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804d71:	eb 05                	jmp    804d78 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  804d73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  804d78:	c9                   	leaveq 
  804d79:	c3                   	retq   

0000000000804d7a <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  804d7a:	55                   	push   %rbp
  804d7b:	48 89 e5             	mov    %rsp,%rbp
  804d7e:	53                   	push   %rbx
  804d7f:	48 83 ec 48          	sub    $0x48,%rsp
  804d83:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  804d87:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804d8b:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  804d8f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

  c = *cp;
  804d93:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804d97:	0f b6 00             	movzbl (%rax),%eax
  804d9a:	0f be c0             	movsbl %al,%eax
  804d9d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804da0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804da3:	3c 2f                	cmp    $0x2f,%al
  804da5:	76 07                	jbe    804dae <inet_aton+0x34>
  804da7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804daa:	3c 39                	cmp    $0x39,%al
  804dac:	76 0a                	jbe    804db8 <inet_aton+0x3e>
      return (0);
  804dae:	b8 00 00 00 00       	mov    $0x0,%eax
  804db3:	e9 6a 02 00 00       	jmpq   805022 <inet_aton+0x2a8>
    val = 0;
  804db8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    base = 10;
  804dbf:	c7 45 e8 0a 00 00 00 	movl   $0xa,-0x18(%rbp)
    if (c == '0') {
  804dc6:	83 7d e4 30          	cmpl   $0x30,-0x1c(%rbp)
  804dca:	75 40                	jne    804e0c <inet_aton+0x92>
      c = *++cp;
  804dcc:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804dd1:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804dd5:	0f b6 00             	movzbl (%rax),%eax
  804dd8:	0f be c0             	movsbl %al,%eax
  804ddb:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      if (c == 'x' || c == 'X') {
  804dde:	83 7d e4 78          	cmpl   $0x78,-0x1c(%rbp)
  804de2:	74 06                	je     804dea <inet_aton+0x70>
  804de4:	83 7d e4 58          	cmpl   $0x58,-0x1c(%rbp)
  804de8:	75 1b                	jne    804e05 <inet_aton+0x8b>
        base = 16;
  804dea:	c7 45 e8 10 00 00 00 	movl   $0x10,-0x18(%rbp)
        c = *++cp;
  804df1:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804df6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804dfa:	0f b6 00             	movzbl (%rax),%eax
  804dfd:	0f be c0             	movsbl %al,%eax
  804e00:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  804e03:	eb 07                	jmp    804e0c <inet_aton+0x92>
      } else
        base = 8;
  804e05:	c7 45 e8 08 00 00 00 	movl   $0x8,-0x18(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  804e0c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e0f:	3c 2f                	cmp    $0x2f,%al
  804e11:	76 2f                	jbe    804e42 <inet_aton+0xc8>
  804e13:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e16:	3c 39                	cmp    $0x39,%al
  804e18:	77 28                	ja     804e42 <inet_aton+0xc8>
        val = (val * base) + (int)(c - '0');
  804e1a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804e1d:	89 c2                	mov    %eax,%edx
  804e1f:	0f af 55 ec          	imul   -0x14(%rbp),%edx
  804e23:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e26:	01 d0                	add    %edx,%eax
  804e28:	83 e8 30             	sub    $0x30,%eax
  804e2b:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  804e2e:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804e33:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804e37:	0f b6 00             	movzbl (%rax),%eax
  804e3a:	0f be c0             	movsbl %al,%eax
  804e3d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  804e40:	eb ca                	jmp    804e0c <inet_aton+0x92>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804e42:	83 7d e8 10          	cmpl   $0x10,-0x18(%rbp)
  804e46:	75 74                	jne    804ebc <inet_aton+0x142>
  804e48:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e4b:	3c 2f                	cmp    $0x2f,%al
  804e4d:	76 07                	jbe    804e56 <inet_aton+0xdc>
  804e4f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e52:	3c 39                	cmp    $0x39,%al
  804e54:	76 1c                	jbe    804e72 <inet_aton+0xf8>
  804e56:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e59:	3c 60                	cmp    $0x60,%al
  804e5b:	76 07                	jbe    804e64 <inet_aton+0xea>
  804e5d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e60:	3c 66                	cmp    $0x66,%al
  804e62:	76 0e                	jbe    804e72 <inet_aton+0xf8>
  804e64:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e67:	3c 40                	cmp    $0x40,%al
  804e69:	76 51                	jbe    804ebc <inet_aton+0x142>
  804e6b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e6e:	3c 46                	cmp    $0x46,%al
  804e70:	77 4a                	ja     804ebc <inet_aton+0x142>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  804e72:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e75:	89 c2                	mov    %eax,%edx
  804e77:	c1 e2 04             	shl    $0x4,%edx
  804e7a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e7d:	8d 48 0a             	lea    0xa(%rax),%ecx
  804e80:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e83:	3c 60                	cmp    $0x60,%al
  804e85:	76 0e                	jbe    804e95 <inet_aton+0x11b>
  804e87:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804e8a:	3c 7a                	cmp    $0x7a,%al
  804e8c:	77 07                	ja     804e95 <inet_aton+0x11b>
  804e8e:	b8 61 00 00 00       	mov    $0x61,%eax
  804e93:	eb 05                	jmp    804e9a <inet_aton+0x120>
  804e95:	b8 41 00 00 00       	mov    $0x41,%eax
  804e9a:	89 cb                	mov    %ecx,%ebx
  804e9c:	29 c3                	sub    %eax,%ebx
  804e9e:	89 d8                	mov    %ebx,%eax
  804ea0:	09 d0                	or     %edx,%eax
  804ea2:	89 45 ec             	mov    %eax,-0x14(%rbp)
        c = *++cp;
  804ea5:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804eaa:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804eae:	0f b6 00             	movzbl (%rax),%eax
  804eb1:	0f be c0             	movsbl %al,%eax
  804eb4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
      } else
        break;
    }
  804eb7:	e9 50 ff ff ff       	jmpq   804e0c <inet_aton+0x92>
    if (c == '.') {
  804ebc:	83 7d e4 2e          	cmpl   $0x2e,-0x1c(%rbp)
  804ec0:	75 3d                	jne    804eff <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  804ec2:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  804ec6:	48 83 c0 0c          	add    $0xc,%rax
  804eca:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  804ece:	72 0a                	jb     804eda <inet_aton+0x160>
        return (0);
  804ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  804ed5:	e9 48 01 00 00       	jmpq   805022 <inet_aton+0x2a8>
      *pp++ = val;
  804eda:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ede:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804ee1:	89 10                	mov    %edx,(%rax)
  804ee3:	48 83 45 d8 04       	addq   $0x4,-0x28(%rbp)
      c = *++cp;
  804ee8:	48 83 45 b8 01       	addq   $0x1,-0x48(%rbp)
  804eed:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804ef1:	0f b6 00             	movzbl (%rax),%eax
  804ef4:	0f be c0             	movsbl %al,%eax
  804ef7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    } else
      break;
  }
  804efa:	e9 a1 fe ff ff       	jmpq   804da0 <inet_aton+0x26>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  804eff:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804f00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804f04:	74 3c                	je     804f42 <inet_aton+0x1c8>
  804f06:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804f09:	3c 1f                	cmp    $0x1f,%al
  804f0b:	76 2b                	jbe    804f38 <inet_aton+0x1be>
  804f0d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804f10:	84 c0                	test   %al,%al
  804f12:	78 24                	js     804f38 <inet_aton+0x1be>
  804f14:	83 7d e4 20          	cmpl   $0x20,-0x1c(%rbp)
  804f18:	74 28                	je     804f42 <inet_aton+0x1c8>
  804f1a:	83 7d e4 0c          	cmpl   $0xc,-0x1c(%rbp)
  804f1e:	74 22                	je     804f42 <inet_aton+0x1c8>
  804f20:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%rbp)
  804f24:	74 1c                	je     804f42 <inet_aton+0x1c8>
  804f26:	83 7d e4 0d          	cmpl   $0xd,-0x1c(%rbp)
  804f2a:	74 16                	je     804f42 <inet_aton+0x1c8>
  804f2c:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  804f30:	74 10                	je     804f42 <inet_aton+0x1c8>
  804f32:	83 7d e4 0b          	cmpl   $0xb,-0x1c(%rbp)
  804f36:	74 0a                	je     804f42 <inet_aton+0x1c8>
    return (0);
  804f38:	b8 00 00 00 00       	mov    $0x0,%eax
  804f3d:	e9 e0 00 00 00       	jmpq   805022 <inet_aton+0x2a8>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804f42:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804f46:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  804f4a:	48 89 d1             	mov    %rdx,%rcx
  804f4d:	48 29 c1             	sub    %rax,%rcx
  804f50:	48 89 c8             	mov    %rcx,%rax
  804f53:	48 c1 f8 02          	sar    $0x2,%rax
  804f57:	83 c0 01             	add    $0x1,%eax
  804f5a:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  switch (n) {
  804f5d:	83 7d d4 04          	cmpl   $0x4,-0x2c(%rbp)
  804f61:	0f 87 98 00 00 00    	ja     804fff <inet_aton+0x285>
  804f67:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804f6a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804f71:	00 
  804f72:	48 b8 78 5b 80 00 00 	movabs $0x805b78,%rax
  804f79:	00 00 00 
  804f7c:	48 01 d0             	add    %rdx,%rax
  804f7f:	48 8b 00             	mov    (%rax),%rax
  804f82:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  804f84:	b8 00 00 00 00       	mov    $0x0,%eax
  804f89:	e9 94 00 00 00       	jmpq   805022 <inet_aton+0x2a8>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804f8e:	81 7d ec ff ff ff 00 	cmpl   $0xffffff,-0x14(%rbp)
  804f95:	76 0a                	jbe    804fa1 <inet_aton+0x227>
      return (0);
  804f97:	b8 00 00 00 00       	mov    $0x0,%eax
  804f9c:	e9 81 00 00 00       	jmpq   805022 <inet_aton+0x2a8>
    val |= parts[0] << 24;
  804fa1:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804fa4:	c1 e0 18             	shl    $0x18,%eax
  804fa7:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804faa:	eb 53                	jmp    804fff <inet_aton+0x285>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  804fac:	81 7d ec ff ff 00 00 	cmpl   $0xffff,-0x14(%rbp)
  804fb3:	76 07                	jbe    804fbc <inet_aton+0x242>
      return (0);
  804fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  804fba:	eb 66                	jmp    805022 <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16);
  804fbc:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804fbf:	89 c2                	mov    %eax,%edx
  804fc1:	c1 e2 18             	shl    $0x18,%edx
  804fc4:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804fc7:	c1 e0 10             	shl    $0x10,%eax
  804fca:	09 d0                	or     %edx,%eax
  804fcc:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804fcf:	eb 2e                	jmp    804fff <inet_aton+0x285>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  804fd1:	81 7d ec ff 00 00 00 	cmpl   $0xff,-0x14(%rbp)
  804fd8:	76 07                	jbe    804fe1 <inet_aton+0x267>
      return (0);
  804fda:	b8 00 00 00 00       	mov    $0x0,%eax
  804fdf:	eb 41                	jmp    805022 <inet_aton+0x2a8>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804fe1:	8b 45 c0             	mov    -0x40(%rbp),%eax
  804fe4:	89 c2                	mov    %eax,%edx
  804fe6:	c1 e2 18             	shl    $0x18,%edx
  804fe9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804fec:	c1 e0 10             	shl    $0x10,%eax
  804fef:	09 c2                	or     %eax,%edx
  804ff1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  804ff4:	c1 e0 08             	shl    $0x8,%eax
  804ff7:	09 d0                	or     %edx,%eax
  804ff9:	09 45 ec             	or     %eax,-0x14(%rbp)
    break;
  804ffc:	eb 01                	jmp    804fff <inet_aton+0x285>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  804ffe:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  804fff:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  805004:	74 17                	je     80501d <inet_aton+0x2a3>
    addr->s_addr = htonl(val);
  805006:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805009:	89 c7                	mov    %eax,%edi
  80500b:	48 b8 91 51 80 00 00 	movabs $0x805191,%rax
  805012:	00 00 00 
  805015:	ff d0                	callq  *%rax
  805017:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80501b:	89 02                	mov    %eax,(%rdx)
  return (1);
  80501d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  805022:	48 83 c4 48          	add    $0x48,%rsp
  805026:	5b                   	pop    %rbx
  805027:	5d                   	pop    %rbp
  805028:	c3                   	retq   

0000000000805029 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  805029:	55                   	push   %rbp
  80502a:	48 89 e5             	mov    %rsp,%rbp
  80502d:	48 83 ec 30          	sub    $0x30,%rsp
  805031:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  805034:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805037:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  80503a:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  805041:	00 00 00 
  805044:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  805048:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80504c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  805050:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  805054:	e9 d1 00 00 00       	jmpq   80512a <inet_ntoa+0x101>
    i = 0;
  805059:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  80505d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805061:	0f b6 08             	movzbl (%rax),%ecx
  805064:	0f b6 d1             	movzbl %cl,%edx
  805067:	89 d0                	mov    %edx,%eax
  805069:	c1 e0 02             	shl    $0x2,%eax
  80506c:	01 d0                	add    %edx,%eax
  80506e:	c1 e0 03             	shl    $0x3,%eax
  805071:	01 d0                	add    %edx,%eax
  805073:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  80507a:	01 d0                	add    %edx,%eax
  80507c:	66 c1 e8 08          	shr    $0x8,%ax
  805080:	c0 e8 03             	shr    $0x3,%al
  805083:	88 45 ed             	mov    %al,-0x13(%rbp)
  805086:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  80508a:	89 d0                	mov    %edx,%eax
  80508c:	c1 e0 02             	shl    $0x2,%eax
  80508f:	01 d0                	add    %edx,%eax
  805091:	01 c0                	add    %eax,%eax
  805093:	89 ca                	mov    %ecx,%edx
  805095:	28 c2                	sub    %al,%dl
  805097:	89 d0                	mov    %edx,%eax
  805099:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  80509c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050a0:	0f b6 00             	movzbl (%rax),%eax
  8050a3:	0f b6 d0             	movzbl %al,%edx
  8050a6:	89 d0                	mov    %edx,%eax
  8050a8:	c1 e0 02             	shl    $0x2,%eax
  8050ab:	01 d0                	add    %edx,%eax
  8050ad:	c1 e0 03             	shl    $0x3,%eax
  8050b0:	01 d0                	add    %edx,%eax
  8050b2:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8050b9:	01 d0                	add    %edx,%eax
  8050bb:	66 c1 e8 08          	shr    $0x8,%ax
  8050bf:	89 c2                	mov    %eax,%edx
  8050c1:	c0 ea 03             	shr    $0x3,%dl
  8050c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050c8:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  8050ca:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8050ce:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8050d2:	83 c2 30             	add    $0x30,%edx
  8050d5:	48 98                	cltq   
  8050d7:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
  8050db:	80 45 ee 01          	addb   $0x1,-0x12(%rbp)
    } while(*ap);
  8050df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050e3:	0f b6 00             	movzbl (%rax),%eax
  8050e6:	84 c0                	test   %al,%al
  8050e8:	0f 85 6f ff ff ff    	jne    80505d <inet_ntoa+0x34>
    while(i--)
  8050ee:	eb 16                	jmp    805106 <inet_ntoa+0xdd>
      *rp++ = inv[i];
  8050f0:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8050f4:	48 98                	cltq   
  8050f6:	0f b6 54 05 e0       	movzbl -0x20(%rbp,%rax,1),%edx
  8050fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050ff:	88 10                	mov    %dl,(%rax)
  805101:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  805106:	80 7d ee 00          	cmpb   $0x0,-0x12(%rbp)
  80510a:	0f 95 c0             	setne  %al
  80510d:	80 6d ee 01          	subb   $0x1,-0x12(%rbp)
  805111:	84 c0                	test   %al,%al
  805113:	75 db                	jne    8050f0 <inet_ntoa+0xc7>
      *rp++ = inv[i];
    *rp++ = '.';
  805115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805119:	c6 00 2e             	movb   $0x2e,(%rax)
  80511c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    ap++;
  805121:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  805126:	80 45 ef 01          	addb   $0x1,-0x11(%rbp)
  80512a:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  80512e:	0f 86 25 ff ff ff    	jbe    805059 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  805134:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  805139:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80513d:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  805140:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  805147:	00 00 00 
}
  80514a:	c9                   	leaveq 
  80514b:	c3                   	retq   

000000000080514c <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80514c:	55                   	push   %rbp
  80514d:	48 89 e5             	mov    %rsp,%rbp
  805150:	48 83 ec 08          	sub    $0x8,%rsp
  805154:	89 f8                	mov    %edi,%eax
  805156:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80515a:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80515e:	c1 e0 08             	shl    $0x8,%eax
  805161:	89 c2                	mov    %eax,%edx
  805163:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  805167:	66 c1 e8 08          	shr    $0x8,%ax
  80516b:	09 d0                	or     %edx,%eax
}
  80516d:	c9                   	leaveq 
  80516e:	c3                   	retq   

000000000080516f <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80516f:	55                   	push   %rbp
  805170:	48 89 e5             	mov    %rsp,%rbp
  805173:	48 83 ec 08          	sub    $0x8,%rsp
  805177:	89 f8                	mov    %edi,%eax
  805179:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  80517d:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  805181:	89 c7                	mov    %eax,%edi
  805183:	48 b8 4c 51 80 00 00 	movabs $0x80514c,%rax
  80518a:	00 00 00 
  80518d:	ff d0                	callq  *%rax
}
  80518f:	c9                   	leaveq 
  805190:	c3                   	retq   

0000000000805191 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  805191:	55                   	push   %rbp
  805192:	48 89 e5             	mov    %rsp,%rbp
  805195:	48 83 ec 08          	sub    $0x8,%rsp
  805199:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  80519c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80519f:	89 c2                	mov    %eax,%edx
  8051a1:	c1 e2 18             	shl    $0x18,%edx
    ((n & 0xff00) << 8) |
  8051a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051a7:	25 00 ff 00 00       	and    $0xff00,%eax
  8051ac:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8051af:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  8051b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051b4:	25 00 00 ff 00       	and    $0xff0000,%eax
  8051b9:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8051bd:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8051bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051c2:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8051c5:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8051c7:	c9                   	leaveq 
  8051c8:	c3                   	retq   

00000000008051c9 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8051c9:	55                   	push   %rbp
  8051ca:	48 89 e5             	mov    %rsp,%rbp
  8051cd:	48 83 ec 08          	sub    $0x8,%rsp
  8051d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  8051d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051d7:	89 c7                	mov    %eax,%edi
  8051d9:	48 b8 91 51 80 00 00 	movabs $0x805191,%rax
  8051e0:	00 00 00 
  8051e3:	ff d0                	callq  *%rax
}
  8051e5:	c9                   	leaveq 
  8051e6:	c3                   	retq   
