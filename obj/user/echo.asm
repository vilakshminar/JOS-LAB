
obj/user/echo.debug:     file format elf64-x86-64


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
  80003c:	e8 03 01 00 00       	callq  800144 <libmain>
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
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, nflag;

	nflag = 0;
  800053:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80005a:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80005e:	7e 38                	jle    800098 <umain+0x54>
  800060:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800064:	48 83 c0 08          	add    $0x8,%rax
  800068:	48 8b 00             	mov    (%rax),%rax
  80006b:	48 be a0 3c 80 00 00 	movabs $0x803ca0,%rsi
  800072:	00 00 00 
  800075:	48 89 c7             	mov    %rax,%rdi
  800078:	48 b8 d3 03 80 00 00 	movabs $0x8003d3,%rax
  80007f:	00 00 00 
  800082:	ff d0                	callq  *%rax
  800084:	85 c0                	test   %eax,%eax
  800086:	75 10                	jne    800098 <umain+0x54>
		nflag = 1;
  800088:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
		argc--;
  80008f:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
		argv++;
  800093:	48 83 45 e0 08       	addq   $0x8,-0x20(%rbp)
	}
	for (i = 1; i < argc; i++) {
  800098:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  80009f:	eb 70                	jmp    800111 <umain+0xcd>
		if (i > 1)
  8000a1:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  8000a5:	7e 20                	jle    8000c7 <umain+0x83>
			write(1, " ", 1);
  8000a7:	ba 01 00 00 00       	mov    $0x1,%edx
  8000ac:	48 be a3 3c 80 00 00 	movabs $0x803ca3,%rsi
  8000b3:	00 00 00 
  8000b6:	bf 01 00 00 00       	mov    $0x1,%edi
  8000bb:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  8000c2:	00 00 00 
  8000c5:	ff d0                	callq  *%rax
		write(1, argv[i], strlen(argv[i]));
  8000c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000ca:	48 98                	cltq   
  8000cc:	48 c1 e0 03          	shl    $0x3,%rax
  8000d0:	48 03 45 e0          	add    -0x20(%rbp),%rax
  8000d4:	48 8b 00             	mov    (%rax),%rax
  8000d7:	48 89 c7             	mov    %rax,%rdi
  8000da:	48 b8 0c 02 80 00 00 	movabs $0x80020c,%rax
  8000e1:	00 00 00 
  8000e4:	ff d0                	callq  *%rax
  8000e6:	48 63 d0             	movslq %eax,%rdx
  8000e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000ec:	48 98                	cltq   
  8000ee:	48 c1 e0 03          	shl    $0x3,%rax
  8000f2:	48 03 45 e0          	add    -0x20(%rbp),%rax
  8000f6:	48 8b 00             	mov    (%rax),%rax
  8000f9:	48 89 c6             	mov    %rax,%rsi
  8000fc:	bf 01 00 00 00       	mov    $0x1,%edi
  800101:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  800108:	00 00 00 
  80010b:	ff d0                	callq  *%rax
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80010d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800111:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800114:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800117:	7c 88                	jl     8000a1 <umain+0x5d>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  800119:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80011d:	75 20                	jne    80013f <umain+0xfb>
		write(1, "\n", 1);
  80011f:	ba 01 00 00 00       	mov    $0x1,%edx
  800124:	48 be a5 3c 80 00 00 	movabs $0x803ca5,%rsi
  80012b:	00 00 00 
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
  800133:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  80013a:	00 00 00 
  80013d:	ff d0                	callq  *%rax
}
  80013f:	c9                   	leaveq 
  800140:	c3                   	retq   
  800141:	00 00                	add    %al,(%rax)
	...

0000000000800144 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800144:	55                   	push   %rbp
  800145:	48 89 e5             	mov    %rsp,%rbp
  800148:	48 83 ec 10          	sub    $0x10,%rsp
  80014c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80014f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800153:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80015a:	00 00 00 
  80015d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800164:	48 b8 34 0b 80 00 00 	movabs $0x800b34,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
  800170:	48 98                	cltq   
  800172:	48 89 c2             	mov    %rax,%rdx
  800175:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80017b:	48 89 d0             	mov    %rdx,%rax
  80017e:	48 c1 e0 03          	shl    $0x3,%rax
  800182:	48 01 d0             	add    %rdx,%rax
  800185:	48 c1 e0 05          	shl    $0x5,%rax
  800189:	48 89 c2             	mov    %rax,%rdx
  80018c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800193:	00 00 00 
  800196:	48 01 c2             	add    %rax,%rdx
  800199:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8001a0:	00 00 00 
  8001a3:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001aa:	7e 14                	jle    8001c0 <libmain+0x7c>
		binaryname = argv[0];
  8001ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b0:	48 8b 10             	mov    (%rax),%rdx
  8001b3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001ba:	00 00 00 
  8001bd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001c7:	48 89 d6             	mov    %rdx,%rsi
  8001ca:	89 c7                	mov    %eax,%edi
  8001cc:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8001d3:	00 00 00 
  8001d6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001d8:	48 b8 e8 01 80 00 00 	movabs $0x8001e8,%rax
  8001df:	00 00 00 
  8001e2:	ff d0                	callq  *%rax
}
  8001e4:	c9                   	leaveq 
  8001e5:	c3                   	retq   
	...

00000000008001e8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e8:	55                   	push   %rbp
  8001e9:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001ec:	48 b8 31 12 80 00 00 	movabs $0x801231,%rax
  8001f3:	00 00 00 
  8001f6:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fd:	48 b8 f0 0a 80 00 00 	movabs $0x800af0,%rax
  800204:	00 00 00 
  800207:	ff d0                	callq  *%rax
}
  800209:	5d                   	pop    %rbp
  80020a:	c3                   	retq   
	...

000000000080020c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80020c:	55                   	push   %rbp
  80020d:	48 89 e5             	mov    %rsp,%rbp
  800210:	48 83 ec 18          	sub    $0x18,%rsp
  800214:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800218:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80021f:	eb 09                	jmp    80022a <strlen+0x1e>
		n++;
  800221:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800225:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80022a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80022e:	0f b6 00             	movzbl (%rax),%eax
  800231:	84 c0                	test   %al,%al
  800233:	75 ec                	jne    800221 <strlen+0x15>
		n++;
	return n;
  800235:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800238:	c9                   	leaveq 
  800239:	c3                   	retq   

000000000080023a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80023a:	55                   	push   %rbp
  80023b:	48 89 e5             	mov    %rsp,%rbp
  80023e:	48 83 ec 20          	sub    $0x20,%rsp
  800242:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800246:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80024a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800251:	eb 0e                	jmp    800261 <strnlen+0x27>
		n++;
  800253:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800257:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80025c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800261:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800266:	74 0b                	je     800273 <strnlen+0x39>
  800268:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80026c:	0f b6 00             	movzbl (%rax),%eax
  80026f:	84 c0                	test   %al,%al
  800271:	75 e0                	jne    800253 <strnlen+0x19>
		n++;
	return n;
  800273:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800276:	c9                   	leaveq 
  800277:	c3                   	retq   

0000000000800278 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800278:	55                   	push   %rbp
  800279:	48 89 e5             	mov    %rsp,%rbp
  80027c:	48 83 ec 20          	sub    $0x20,%rsp
  800280:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800284:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800288:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80028c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800290:	90                   	nop
  800291:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800295:	0f b6 10             	movzbl (%rax),%edx
  800298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80029c:	88 10                	mov    %dl,(%rax)
  80029e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002a2:	0f b6 00             	movzbl (%rax),%eax
  8002a5:	84 c0                	test   %al,%al
  8002a7:	0f 95 c0             	setne  %al
  8002aa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8002af:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8002b4:	84 c0                	test   %al,%al
  8002b6:	75 d9                	jne    800291 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8002b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8002bc:	c9                   	leaveq 
  8002bd:	c3                   	retq   

00000000008002be <strcat>:

char *
strcat(char *dst, const char *src)
{
  8002be:	55                   	push   %rbp
  8002bf:	48 89 e5             	mov    %rsp,%rbp
  8002c2:	48 83 ec 20          	sub    $0x20,%rsp
  8002c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8002ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8002ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002d2:	48 89 c7             	mov    %rax,%rdi
  8002d5:	48 b8 0c 02 80 00 00 	movabs $0x80020c,%rax
  8002dc:	00 00 00 
  8002df:	ff d0                	callq  *%rax
  8002e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8002e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002e7:	48 98                	cltq   
  8002e9:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8002ed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002f1:	48 89 d6             	mov    %rdx,%rsi
  8002f4:	48 89 c7             	mov    %rax,%rdi
  8002f7:	48 b8 78 02 80 00 00 	movabs $0x800278,%rax
  8002fe:	00 00 00 
  800301:	ff d0                	callq  *%rax
	return dst;
  800303:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800307:	c9                   	leaveq 
  800308:	c3                   	retq   

0000000000800309 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800309:	55                   	push   %rbp
  80030a:	48 89 e5             	mov    %rsp,%rbp
  80030d:	48 83 ec 28          	sub    $0x28,%rsp
  800311:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800315:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800319:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80031d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800321:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800325:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80032c:	00 
  80032d:	eb 27                	jmp    800356 <strncpy+0x4d>
		*dst++ = *src;
  80032f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800333:	0f b6 10             	movzbl (%rax),%edx
  800336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80033a:	88 10                	mov    %dl,(%rax)
  80033c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800341:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800345:	0f b6 00             	movzbl (%rax),%eax
  800348:	84 c0                	test   %al,%al
  80034a:	74 05                	je     800351 <strncpy+0x48>
			src++;
  80034c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800351:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800356:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80035a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80035e:	72 cf                	jb     80032f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800360:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800364:	c9                   	leaveq 
  800365:	c3                   	retq   

0000000000800366 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800366:	55                   	push   %rbp
  800367:	48 89 e5             	mov    %rsp,%rbp
  80036a:	48 83 ec 28          	sub    $0x28,%rsp
  80036e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800372:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800376:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80037a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80037e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800382:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800387:	74 37                	je     8003c0 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  800389:	eb 17                	jmp    8003a2 <strlcpy+0x3c>
			*dst++ = *src++;
  80038b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80038f:	0f b6 10             	movzbl (%rax),%edx
  800392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800396:	88 10                	mov    %dl,(%rax)
  800398:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80039d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8003a2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8003a7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8003ac:	74 0b                	je     8003b9 <strlcpy+0x53>
  8003ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8003b2:	0f b6 00             	movzbl (%rax),%eax
  8003b5:	84 c0                	test   %al,%al
  8003b7:	75 d2                	jne    80038b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8003b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003bd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8003c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003c8:	48 89 d1             	mov    %rdx,%rcx
  8003cb:	48 29 c1             	sub    %rax,%rcx
  8003ce:	48 89 c8             	mov    %rcx,%rax
}
  8003d1:	c9                   	leaveq 
  8003d2:	c3                   	retq   

00000000008003d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8003d3:	55                   	push   %rbp
  8003d4:	48 89 e5             	mov    %rsp,%rbp
  8003d7:	48 83 ec 10          	sub    $0x10,%rsp
  8003db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8003e3:	eb 0a                	jmp    8003ef <strcmp+0x1c>
		p++, q++;
  8003e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8003ea:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8003ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f3:	0f b6 00             	movzbl (%rax),%eax
  8003f6:	84 c0                	test   %al,%al
  8003f8:	74 12                	je     80040c <strcmp+0x39>
  8003fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003fe:	0f b6 10             	movzbl (%rax),%edx
  800401:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800405:	0f b6 00             	movzbl (%rax),%eax
  800408:	38 c2                	cmp    %al,%dl
  80040a:	74 d9                	je     8003e5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80040c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800410:	0f b6 00             	movzbl (%rax),%eax
  800413:	0f b6 d0             	movzbl %al,%edx
  800416:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041a:	0f b6 00             	movzbl (%rax),%eax
  80041d:	0f b6 c0             	movzbl %al,%eax
  800420:	89 d1                	mov    %edx,%ecx
  800422:	29 c1                	sub    %eax,%ecx
  800424:	89 c8                	mov    %ecx,%eax
}
  800426:	c9                   	leaveq 
  800427:	c3                   	retq   

0000000000800428 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800428:	55                   	push   %rbp
  800429:	48 89 e5             	mov    %rsp,%rbp
  80042c:	48 83 ec 18          	sub    $0x18,%rsp
  800430:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800434:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800438:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80043c:	eb 0f                	jmp    80044d <strncmp+0x25>
		n--, p++, q++;
  80043e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800443:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800448:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80044d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800452:	74 1d                	je     800471 <strncmp+0x49>
  800454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800458:	0f b6 00             	movzbl (%rax),%eax
  80045b:	84 c0                	test   %al,%al
  80045d:	74 12                	je     800471 <strncmp+0x49>
  80045f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800463:	0f b6 10             	movzbl (%rax),%edx
  800466:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046a:	0f b6 00             	movzbl (%rax),%eax
  80046d:	38 c2                	cmp    %al,%dl
  80046f:	74 cd                	je     80043e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800471:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800476:	75 07                	jne    80047f <strncmp+0x57>
		return 0;
  800478:	b8 00 00 00 00       	mov    $0x0,%eax
  80047d:	eb 1a                	jmp    800499 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80047f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800483:	0f b6 00             	movzbl (%rax),%eax
  800486:	0f b6 d0             	movzbl %al,%edx
  800489:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80048d:	0f b6 00             	movzbl (%rax),%eax
  800490:	0f b6 c0             	movzbl %al,%eax
  800493:	89 d1                	mov    %edx,%ecx
  800495:	29 c1                	sub    %eax,%ecx
  800497:	89 c8                	mov    %ecx,%eax
}
  800499:	c9                   	leaveq 
  80049a:	c3                   	retq   

000000000080049b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80049b:	55                   	push   %rbp
  80049c:	48 89 e5             	mov    %rsp,%rbp
  80049f:	48 83 ec 10          	sub    $0x10,%rsp
  8004a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004a7:	89 f0                	mov    %esi,%eax
  8004a9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004ac:	eb 17                	jmp    8004c5 <strchr+0x2a>
		if (*s == c)
  8004ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004b2:	0f b6 00             	movzbl (%rax),%eax
  8004b5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004b8:	75 06                	jne    8004c0 <strchr+0x25>
			return (char *) s;
  8004ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004be:	eb 15                	jmp    8004d5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8004c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004c9:	0f b6 00             	movzbl (%rax),%eax
  8004cc:	84 c0                	test   %al,%al
  8004ce:	75 de                	jne    8004ae <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8004d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004d5:	c9                   	leaveq 
  8004d6:	c3                   	retq   

00000000008004d7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8004d7:	55                   	push   %rbp
  8004d8:	48 89 e5             	mov    %rsp,%rbp
  8004db:	48 83 ec 10          	sub    $0x10,%rsp
  8004df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004e3:	89 f0                	mov    %esi,%eax
  8004e5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004e8:	eb 11                	jmp    8004fb <strfind+0x24>
		if (*s == c)
  8004ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ee:	0f b6 00             	movzbl (%rax),%eax
  8004f1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004f4:	74 12                	je     800508 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8004f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ff:	0f b6 00             	movzbl (%rax),%eax
  800502:	84 c0                	test   %al,%al
  800504:	75 e4                	jne    8004ea <strfind+0x13>
  800506:	eb 01                	jmp    800509 <strfind+0x32>
		if (*s == c)
			break;
  800508:	90                   	nop
	return (char *) s;
  800509:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80050d:	c9                   	leaveq 
  80050e:	c3                   	retq   

000000000080050f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80050f:	55                   	push   %rbp
  800510:	48 89 e5             	mov    %rsp,%rbp
  800513:	48 83 ec 18          	sub    $0x18,%rsp
  800517:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80051b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80051e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  800522:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800527:	75 06                	jne    80052f <memset+0x20>
		return v;
  800529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80052d:	eb 69                	jmp    800598 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80052f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800533:	83 e0 03             	and    $0x3,%eax
  800536:	48 85 c0             	test   %rax,%rax
  800539:	75 48                	jne    800583 <memset+0x74>
  80053b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053f:	83 e0 03             	and    $0x3,%eax
  800542:	48 85 c0             	test   %rax,%rax
  800545:	75 3c                	jne    800583 <memset+0x74>
		c &= 0xFF;
  800547:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80054e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800551:	89 c2                	mov    %eax,%edx
  800553:	c1 e2 18             	shl    $0x18,%edx
  800556:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800559:	c1 e0 10             	shl    $0x10,%eax
  80055c:	09 c2                	or     %eax,%edx
  80055e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800561:	c1 e0 08             	shl    $0x8,%eax
  800564:	09 d0                	or     %edx,%eax
  800566:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056d:	48 89 c1             	mov    %rax,%rcx
  800570:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800574:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800578:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80057b:	48 89 d7             	mov    %rdx,%rdi
  80057e:	fc                   	cld    
  80057f:	f3 ab                	rep stos %eax,%es:(%rdi)
  800581:	eb 11                	jmp    800594 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800583:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800587:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80058a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80058e:	48 89 d7             	mov    %rdx,%rdi
  800591:	fc                   	cld    
  800592:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800598:	c9                   	leaveq 
  800599:	c3                   	retq   

000000000080059a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80059a:	55                   	push   %rbp
  80059b:	48 89 e5             	mov    %rsp,%rbp
  80059e:	48 83 ec 28          	sub    $0x28,%rsp
  8005a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8005ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8005b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8005be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005c2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005c6:	0f 83 88 00 00 00    	jae    800654 <memmove+0xba>
  8005cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8005d4:	48 01 d0             	add    %rdx,%rax
  8005d7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005db:	76 77                	jbe    800654 <memmove+0xba>
		s += n;
  8005dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005e1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8005e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005e9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8005ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005f1:	83 e0 03             	and    $0x3,%eax
  8005f4:	48 85 c0             	test   %rax,%rax
  8005f7:	75 3b                	jne    800634 <memmove+0x9a>
  8005f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005fd:	83 e0 03             	and    $0x3,%eax
  800600:	48 85 c0             	test   %rax,%rax
  800603:	75 2f                	jne    800634 <memmove+0x9a>
  800605:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800609:	83 e0 03             	and    $0x3,%eax
  80060c:	48 85 c0             	test   %rax,%rax
  80060f:	75 23                	jne    800634 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800611:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800615:	48 83 e8 04          	sub    $0x4,%rax
  800619:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80061d:	48 83 ea 04          	sub    $0x4,%rdx
  800621:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800625:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800629:	48 89 c7             	mov    %rax,%rdi
  80062c:	48 89 d6             	mov    %rdx,%rsi
  80062f:	fd                   	std    
  800630:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  800632:	eb 1d                	jmp    800651 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800634:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800638:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80063c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800640:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800648:	48 89 d7             	mov    %rdx,%rdi
  80064b:	48 89 c1             	mov    %rax,%rcx
  80064e:	fd                   	std    
  80064f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800651:	fc                   	cld    
  800652:	eb 57                	jmp    8006ab <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  800654:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800658:	83 e0 03             	and    $0x3,%eax
  80065b:	48 85 c0             	test   %rax,%rax
  80065e:	75 36                	jne    800696 <memmove+0xfc>
  800660:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800664:	83 e0 03             	and    $0x3,%eax
  800667:	48 85 c0             	test   %rax,%rax
  80066a:	75 2a                	jne    800696 <memmove+0xfc>
  80066c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800670:	83 e0 03             	and    $0x3,%eax
  800673:	48 85 c0             	test   %rax,%rax
  800676:	75 1e                	jne    800696 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80067c:	48 89 c1             	mov    %rax,%rcx
  80067f:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800683:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800687:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80068b:	48 89 c7             	mov    %rax,%rdi
  80068e:	48 89 d6             	mov    %rdx,%rsi
  800691:	fc                   	cld    
  800692:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  800694:	eb 15                	jmp    8006ab <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80069e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8006a2:	48 89 c7             	mov    %rax,%rdi
  8006a5:	48 89 d6             	mov    %rdx,%rsi
  8006a8:	fc                   	cld    
  8006a9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8006ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8006af:	c9                   	leaveq 
  8006b0:	c3                   	retq   

00000000008006b1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8006b1:	55                   	push   %rbp
  8006b2:	48 89 e5             	mov    %rsp,%rbp
  8006b5:	48 83 ec 18          	sub    $0x18,%rsp
  8006b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8006c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006d1:	48 89 ce             	mov    %rcx,%rsi
  8006d4:	48 89 c7             	mov    %rax,%rdi
  8006d7:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  8006de:	00 00 00 
  8006e1:	ff d0                	callq  *%rax
}
  8006e3:	c9                   	leaveq 
  8006e4:	c3                   	retq   

00000000008006e5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8006e5:	55                   	push   %rbp
  8006e6:	48 89 e5             	mov    %rsp,%rbp
  8006e9:	48 83 ec 28          	sub    $0x28,%rsp
  8006ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8006f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800701:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800705:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  800709:	eb 38                	jmp    800743 <memcmp+0x5e>
		if (*s1 != *s2)
  80070b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80070f:	0f b6 10             	movzbl (%rax),%edx
  800712:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800716:	0f b6 00             	movzbl (%rax),%eax
  800719:	38 c2                	cmp    %al,%dl
  80071b:	74 1c                	je     800739 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  80071d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800721:	0f b6 00             	movzbl (%rax),%eax
  800724:	0f b6 d0             	movzbl %al,%edx
  800727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80072b:	0f b6 00             	movzbl (%rax),%eax
  80072e:	0f b6 c0             	movzbl %al,%eax
  800731:	89 d1                	mov    %edx,%ecx
  800733:	29 c1                	sub    %eax,%ecx
  800735:	89 c8                	mov    %ecx,%eax
  800737:	eb 20                	jmp    800759 <memcmp+0x74>
		s1++, s2++;
  800739:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80073e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800743:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800748:	0f 95 c0             	setne  %al
  80074b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800750:	84 c0                	test   %al,%al
  800752:	75 b7                	jne    80070b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800754:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800759:	c9                   	leaveq 
  80075a:	c3                   	retq   

000000000080075b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80075b:	55                   	push   %rbp
  80075c:	48 89 e5             	mov    %rsp,%rbp
  80075f:	48 83 ec 28          	sub    $0x28,%rsp
  800763:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800767:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80076a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80076e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800772:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800776:	48 01 d0             	add    %rdx,%rax
  800779:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80077d:	eb 13                	jmp    800792 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80077f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800783:	0f b6 10             	movzbl (%rax),%edx
  800786:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800789:	38 c2                	cmp    %al,%dl
  80078b:	74 11                	je     80079e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80078d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800796:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80079a:	72 e3                	jb     80077f <memfind+0x24>
  80079c:	eb 01                	jmp    80079f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80079e:	90                   	nop
	return (void *) s;
  80079f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8007a3:	c9                   	leaveq 
  8007a4:	c3                   	retq   

00000000008007a5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8007a5:	55                   	push   %rbp
  8007a6:	48 89 e5             	mov    %rsp,%rbp
  8007a9:	48 83 ec 38          	sub    $0x38,%rsp
  8007ad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8007b5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8007b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8007bf:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8007c6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007c7:	eb 05                	jmp    8007ce <strtol+0x29>
		s++;
  8007c9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d2:	0f b6 00             	movzbl (%rax),%eax
  8007d5:	3c 20                	cmp    $0x20,%al
  8007d7:	74 f0                	je     8007c9 <strtol+0x24>
  8007d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007dd:	0f b6 00             	movzbl (%rax),%eax
  8007e0:	3c 09                	cmp    $0x9,%al
  8007e2:	74 e5                	je     8007c9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8007e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007e8:	0f b6 00             	movzbl (%rax),%eax
  8007eb:	3c 2b                	cmp    $0x2b,%al
  8007ed:	75 07                	jne    8007f6 <strtol+0x51>
		s++;
  8007ef:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007f4:	eb 17                	jmp    80080d <strtol+0x68>
	else if (*s == '-')
  8007f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007fa:	0f b6 00             	movzbl (%rax),%eax
  8007fd:	3c 2d                	cmp    $0x2d,%al
  8007ff:	75 0c                	jne    80080d <strtol+0x68>
		s++, neg = 1;
  800801:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  800806:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80080d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800811:	74 06                	je     800819 <strtol+0x74>
  800813:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  800817:	75 28                	jne    800841 <strtol+0x9c>
  800819:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80081d:	0f b6 00             	movzbl (%rax),%eax
  800820:	3c 30                	cmp    $0x30,%al
  800822:	75 1d                	jne    800841 <strtol+0x9c>
  800824:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800828:	48 83 c0 01          	add    $0x1,%rax
  80082c:	0f b6 00             	movzbl (%rax),%eax
  80082f:	3c 78                	cmp    $0x78,%al
  800831:	75 0e                	jne    800841 <strtol+0x9c>
		s += 2, base = 16;
  800833:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  800838:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80083f:	eb 2c                	jmp    80086d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  800841:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800845:	75 19                	jne    800860 <strtol+0xbb>
  800847:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80084b:	0f b6 00             	movzbl (%rax),%eax
  80084e:	3c 30                	cmp    $0x30,%al
  800850:	75 0e                	jne    800860 <strtol+0xbb>
		s++, base = 8;
  800852:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  800857:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80085e:	eb 0d                	jmp    80086d <strtol+0xc8>
	else if (base == 0)
  800860:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800864:	75 07                	jne    80086d <strtol+0xc8>
		base = 10;
  800866:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80086d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800871:	0f b6 00             	movzbl (%rax),%eax
  800874:	3c 2f                	cmp    $0x2f,%al
  800876:	7e 1d                	jle    800895 <strtol+0xf0>
  800878:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80087c:	0f b6 00             	movzbl (%rax),%eax
  80087f:	3c 39                	cmp    $0x39,%al
  800881:	7f 12                	jg     800895 <strtol+0xf0>
			dig = *s - '0';
  800883:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800887:	0f b6 00             	movzbl (%rax),%eax
  80088a:	0f be c0             	movsbl %al,%eax
  80088d:	83 e8 30             	sub    $0x30,%eax
  800890:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800893:	eb 4e                	jmp    8008e3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  800895:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800899:	0f b6 00             	movzbl (%rax),%eax
  80089c:	3c 60                	cmp    $0x60,%al
  80089e:	7e 1d                	jle    8008bd <strtol+0x118>
  8008a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008a4:	0f b6 00             	movzbl (%rax),%eax
  8008a7:	3c 7a                	cmp    $0x7a,%al
  8008a9:	7f 12                	jg     8008bd <strtol+0x118>
			dig = *s - 'a' + 10;
  8008ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008af:	0f b6 00             	movzbl (%rax),%eax
  8008b2:	0f be c0             	movsbl %al,%eax
  8008b5:	83 e8 57             	sub    $0x57,%eax
  8008b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8008bb:	eb 26                	jmp    8008e3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8008bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008c1:	0f b6 00             	movzbl (%rax),%eax
  8008c4:	3c 40                	cmp    $0x40,%al
  8008c6:	7e 47                	jle    80090f <strtol+0x16a>
  8008c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008cc:	0f b6 00             	movzbl (%rax),%eax
  8008cf:	3c 5a                	cmp    $0x5a,%al
  8008d1:	7f 3c                	jg     80090f <strtol+0x16a>
			dig = *s - 'A' + 10;
  8008d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008d7:	0f b6 00             	movzbl (%rax),%eax
  8008da:	0f be c0             	movsbl %al,%eax
  8008dd:	83 e8 37             	sub    $0x37,%eax
  8008e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8008e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008e6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8008e9:	7d 23                	jge    80090e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8008eb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8008f0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008f3:	48 98                	cltq   
  8008f5:	48 89 c2             	mov    %rax,%rdx
  8008f8:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8008fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800900:	48 98                	cltq   
  800902:	48 01 d0             	add    %rdx,%rax
  800905:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  800909:	e9 5f ff ff ff       	jmpq   80086d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80090e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80090f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800914:	74 0b                	je     800921 <strtol+0x17c>
		*endptr = (char *) s;
  800916:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80091a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80091e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  800921:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800925:	74 09                	je     800930 <strtol+0x18b>
  800927:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80092b:	48 f7 d8             	neg    %rax
  80092e:	eb 04                	jmp    800934 <strtol+0x18f>
  800930:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800934:	c9                   	leaveq 
  800935:	c3                   	retq   

0000000000800936 <strstr>:

char * strstr(const char *in, const char *str)
{
  800936:	55                   	push   %rbp
  800937:	48 89 e5             	mov    %rsp,%rbp
  80093a:	48 83 ec 30          	sub    $0x30,%rsp
  80093e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800942:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  800946:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80094a:	0f b6 00             	movzbl (%rax),%eax
  80094d:	88 45 ff             	mov    %al,-0x1(%rbp)
  800950:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  800955:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  800959:	75 06                	jne    800961 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  80095b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80095f:	eb 68                	jmp    8009c9 <strstr+0x93>

    len = strlen(str);
  800961:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800965:	48 89 c7             	mov    %rax,%rdi
  800968:	48 b8 0c 02 80 00 00 	movabs $0x80020c,%rax
  80096f:	00 00 00 
  800972:	ff d0                	callq  *%rax
  800974:	48 98                	cltq   
  800976:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80097a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80097e:	0f b6 00             	movzbl (%rax),%eax
  800981:	88 45 ef             	mov    %al,-0x11(%rbp)
  800984:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  800989:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80098d:	75 07                	jne    800996 <strstr+0x60>
                return (char *) 0;
  80098f:	b8 00 00 00 00       	mov    $0x0,%eax
  800994:	eb 33                	jmp    8009c9 <strstr+0x93>
        } while (sc != c);
  800996:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80099a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80099d:	75 db                	jne    80097a <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  80099f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8009a3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8009a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009ab:	48 89 ce             	mov    %rcx,%rsi
  8009ae:	48 89 c7             	mov    %rax,%rdi
  8009b1:	48 b8 28 04 80 00 00 	movabs $0x800428,%rax
  8009b8:	00 00 00 
  8009bb:	ff d0                	callq  *%rax
  8009bd:	85 c0                	test   %eax,%eax
  8009bf:	75 b9                	jne    80097a <strstr+0x44>

    return (char *) (in - 1);
  8009c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009c5:	48 83 e8 01          	sub    $0x1,%rax
}
  8009c9:	c9                   	leaveq 
  8009ca:	c3                   	retq   
	...

00000000008009cc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8009cc:	55                   	push   %rbp
  8009cd:	48 89 e5             	mov    %rsp,%rbp
  8009d0:	53                   	push   %rbx
  8009d1:	48 83 ec 58          	sub    $0x58,%rsp
  8009d5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8009d8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8009db:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8009df:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8009e3:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8009e7:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009eb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8009ee:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8009f1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8009f5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8009f9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8009fd:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800a01:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800a05:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800a08:	4c 89 c3             	mov    %r8,%rbx
  800a0b:	cd 30                	int    $0x30
  800a0d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  800a11:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800a15:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800a19:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a1d:	74 3e                	je     800a5d <syscall+0x91>
  800a1f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800a24:	7e 37                	jle    800a5d <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  800a26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a2d:	49 89 d0             	mov    %rdx,%r8
  800a30:	89 c1                	mov    %eax,%ecx
  800a32:	48 ba b1 3c 80 00 00 	movabs $0x803cb1,%rdx
  800a39:	00 00 00 
  800a3c:	be 23 00 00 00       	mov    $0x23,%esi
  800a41:	48 bf ce 3c 80 00 00 	movabs $0x803cce,%rdi
  800a48:	00 00 00 
  800a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a50:	49 b9 80 2c 80 00 00 	movabs $0x802c80,%r9
  800a57:	00 00 00 
  800a5a:	41 ff d1             	callq  *%r9

	return ret;
  800a5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800a61:	48 83 c4 58          	add    $0x58,%rsp
  800a65:	5b                   	pop    %rbx
  800a66:	5d                   	pop    %rbp
  800a67:	c3                   	retq   

0000000000800a68 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a68:	55                   	push   %rbp
  800a69:	48 89 e5             	mov    %rsp,%rbp
  800a6c:	48 83 ec 20          	sub    $0x20,%rsp
  800a70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a74:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800a78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a80:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800a87:	00 
  800a88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800a8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800a94:	48 89 d1             	mov    %rdx,%rcx
  800a97:	48 89 c2             	mov    %rax,%rdx
  800a9a:	be 00 00 00 00       	mov    $0x0,%esi
  800a9f:	bf 00 00 00 00       	mov    $0x0,%edi
  800aa4:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800aab:	00 00 00 
  800aae:	ff d0                	callq  *%rax
}
  800ab0:	c9                   	leaveq 
  800ab1:	c3                   	retq   

0000000000800ab2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ab2:	55                   	push   %rbp
  800ab3:	48 89 e5             	mov    %rsp,%rbp
  800ab6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800aba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800ac1:	00 
  800ac2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ac8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ace:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ad3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad8:	be 00 00 00 00       	mov    $0x0,%esi
  800add:	bf 01 00 00 00       	mov    $0x1,%edi
  800ae2:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800ae9:	00 00 00 
  800aec:	ff d0                	callq  *%rax
}
  800aee:	c9                   	leaveq 
  800aef:	c3                   	retq   

0000000000800af0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800af0:	55                   	push   %rbp
  800af1:	48 89 e5             	mov    %rsp,%rbp
  800af4:	48 83 ec 20          	sub    $0x20,%rsp
  800af8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800afb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800afe:	48 98                	cltq   
  800b00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b07:	00 
  800b08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b14:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b19:	48 89 c2             	mov    %rax,%rdx
  800b1c:	be 01 00 00 00       	mov    $0x1,%esi
  800b21:	bf 03 00 00 00       	mov    $0x3,%edi
  800b26:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800b2d:	00 00 00 
  800b30:	ff d0                	callq  *%rax
}
  800b32:	c9                   	leaveq 
  800b33:	c3                   	retq   

0000000000800b34 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b34:	55                   	push   %rbp
  800b35:	48 89 e5             	mov    %rsp,%rbp
  800b38:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b3c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b43:	00 
  800b44:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b4a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b50:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b55:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5a:	be 00 00 00 00       	mov    $0x0,%esi
  800b5f:	bf 02 00 00 00       	mov    $0x2,%edi
  800b64:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800b6b:	00 00 00 
  800b6e:	ff d0                	callq  *%rax
}
  800b70:	c9                   	leaveq 
  800b71:	c3                   	retq   

0000000000800b72 <sys_yield>:

void
sys_yield(void)
{
  800b72:	55                   	push   %rbp
  800b73:	48 89 e5             	mov    %rsp,%rbp
  800b76:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b7a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b81:	00 
  800b82:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b88:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b93:	ba 00 00 00 00       	mov    $0x0,%edx
  800b98:	be 00 00 00 00       	mov    $0x0,%esi
  800b9d:	bf 0b 00 00 00       	mov    $0xb,%edi
  800ba2:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800ba9:	00 00 00 
  800bac:	ff d0                	callq  *%rax
}
  800bae:	c9                   	leaveq 
  800baf:	c3                   	retq   

0000000000800bb0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bb0:	55                   	push   %rbp
  800bb1:	48 89 e5             	mov    %rsp,%rbp
  800bb4:	48 83 ec 20          	sub    $0x20,%rsp
  800bb8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bbb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800bbf:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800bc2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bc5:	48 63 c8             	movslq %eax,%rcx
  800bc8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bcf:	48 98                	cltq   
  800bd1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800bd8:	00 
  800bd9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800bdf:	49 89 c8             	mov    %rcx,%r8
  800be2:	48 89 d1             	mov    %rdx,%rcx
  800be5:	48 89 c2             	mov    %rax,%rdx
  800be8:	be 01 00 00 00       	mov    $0x1,%esi
  800bed:	bf 04 00 00 00       	mov    $0x4,%edi
  800bf2:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800bf9:	00 00 00 
  800bfc:	ff d0                	callq  *%rax
}
  800bfe:	c9                   	leaveq 
  800bff:	c3                   	retq   

0000000000800c00 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c00:	55                   	push   %rbp
  800c01:	48 89 e5             	mov    %rsp,%rbp
  800c04:	48 83 ec 30          	sub    $0x30,%rsp
  800c08:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800c0f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800c12:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c16:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800c1a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c1d:	48 63 c8             	movslq %eax,%rcx
  800c20:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c27:	48 63 f0             	movslq %eax,%rsi
  800c2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c31:	48 98                	cltq   
  800c33:	48 89 0c 24          	mov    %rcx,(%rsp)
  800c37:	49 89 f9             	mov    %rdi,%r9
  800c3a:	49 89 f0             	mov    %rsi,%r8
  800c3d:	48 89 d1             	mov    %rdx,%rcx
  800c40:	48 89 c2             	mov    %rax,%rdx
  800c43:	be 01 00 00 00       	mov    $0x1,%esi
  800c48:	bf 05 00 00 00       	mov    $0x5,%edi
  800c4d:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800c54:	00 00 00 
  800c57:	ff d0                	callq  *%rax
}
  800c59:	c9                   	leaveq 
  800c5a:	c3                   	retq   

0000000000800c5b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c5b:	55                   	push   %rbp
  800c5c:	48 89 e5             	mov    %rsp,%rbp
  800c5f:	48 83 ec 20          	sub    $0x20,%rsp
  800c63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800c6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c71:	48 98                	cltq   
  800c73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800c7a:	00 
  800c7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800c81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800c87:	48 89 d1             	mov    %rdx,%rcx
  800c8a:	48 89 c2             	mov    %rax,%rdx
  800c8d:	be 01 00 00 00       	mov    $0x1,%esi
  800c92:	bf 06 00 00 00       	mov    $0x6,%edi
  800c97:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800c9e:	00 00 00 
  800ca1:	ff d0                	callq  *%rax
}
  800ca3:	c9                   	leaveq 
  800ca4:	c3                   	retq   

0000000000800ca5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ca5:	55                   	push   %rbp
  800ca6:	48 89 e5             	mov    %rsp,%rbp
  800ca9:	48 83 ec 20          	sub    $0x20,%rsp
  800cad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cb0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800cb3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800cb6:	48 63 d0             	movslq %eax,%rdx
  800cb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cbc:	48 98                	cltq   
  800cbe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800cc5:	00 
  800cc6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ccc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800cd2:	48 89 d1             	mov    %rdx,%rcx
  800cd5:	48 89 c2             	mov    %rax,%rdx
  800cd8:	be 01 00 00 00       	mov    $0x1,%esi
  800cdd:	bf 08 00 00 00       	mov    $0x8,%edi
  800ce2:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800ce9:	00 00 00 
  800cec:	ff d0                	callq  *%rax
}
  800cee:	c9                   	leaveq 
  800cef:	c3                   	retq   

0000000000800cf0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cf0:	55                   	push   %rbp
  800cf1:	48 89 e5             	mov    %rsp,%rbp
  800cf4:	48 83 ec 20          	sub    $0x20,%rsp
  800cf8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800cff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d06:	48 98                	cltq   
  800d08:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d0f:	00 
  800d10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d1c:	48 89 d1             	mov    %rdx,%rcx
  800d1f:	48 89 c2             	mov    %rax,%rdx
  800d22:	be 01 00 00 00       	mov    $0x1,%esi
  800d27:	bf 09 00 00 00       	mov    $0x9,%edi
  800d2c:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800d33:	00 00 00 
  800d36:	ff d0                	callq  *%rax
}
  800d38:	c9                   	leaveq 
  800d39:	c3                   	retq   

0000000000800d3a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d3a:	55                   	push   %rbp
  800d3b:	48 89 e5             	mov    %rsp,%rbp
  800d3e:	48 83 ec 20          	sub    $0x20,%rsp
  800d42:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800d49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d50:	48 98                	cltq   
  800d52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d59:	00 
  800d5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d66:	48 89 d1             	mov    %rdx,%rcx
  800d69:	48 89 c2             	mov    %rax,%rdx
  800d6c:	be 01 00 00 00       	mov    $0x1,%esi
  800d71:	bf 0a 00 00 00       	mov    $0xa,%edi
  800d76:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800d7d:	00 00 00 
  800d80:	ff d0                	callq  *%rax
}
  800d82:	c9                   	leaveq 
  800d83:	c3                   	retq   

0000000000800d84 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800d84:	55                   	push   %rbp
  800d85:	48 89 e5             	mov    %rsp,%rbp
  800d88:	48 83 ec 30          	sub    $0x30,%rsp
  800d8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800d93:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800d97:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800d9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d9d:	48 63 f0             	movslq %eax,%rsi
  800da0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800da4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800da7:	48 98                	cltq   
  800da9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800dad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800db4:	00 
  800db5:	49 89 f1             	mov    %rsi,%r9
  800db8:	49 89 c8             	mov    %rcx,%r8
  800dbb:	48 89 d1             	mov    %rdx,%rcx
  800dbe:	48 89 c2             	mov    %rax,%rdx
  800dc1:	be 00 00 00 00       	mov    $0x0,%esi
  800dc6:	bf 0c 00 00 00       	mov    $0xc,%edi
  800dcb:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800dd2:	00 00 00 
  800dd5:	ff d0                	callq  *%rax
}
  800dd7:	c9                   	leaveq 
  800dd8:	c3                   	retq   

0000000000800dd9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dd9:	55                   	push   %rbp
  800dda:	48 89 e5             	mov    %rsp,%rbp
  800ddd:	48 83 ec 20          	sub    $0x20,%rsp
  800de1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800de5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800de9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800df0:	00 
  800df1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800df7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800dfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e02:	48 89 c2             	mov    %rax,%rdx
  800e05:	be 01 00 00 00       	mov    $0x1,%esi
  800e0a:	bf 0d 00 00 00       	mov    $0xd,%edi
  800e0f:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800e16:	00 00 00 
  800e19:	ff d0                	callq  *%rax
}
  800e1b:	c9                   	leaveq 
  800e1c:	c3                   	retq   

0000000000800e1d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e1d:	55                   	push   %rbp
  800e1e:	48 89 e5             	mov    %rsp,%rbp
  800e21:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800e25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800e2c:	00 
  800e2d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800e33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e39:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e43:	be 00 00 00 00       	mov    $0x0,%esi
  800e48:	bf 0e 00 00 00       	mov    $0xe,%edi
  800e4d:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800e54:	00 00 00 
  800e57:	ff d0                	callq  *%rax
}
  800e59:	c9                   	leaveq 
  800e5a:	c3                   	retq   

0000000000800e5b <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  800e5b:	55                   	push   %rbp
  800e5c:	48 89 e5             	mov    %rsp,%rbp
  800e5f:	48 83 ec 20          	sub    $0x20,%rsp
  800e63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800e67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  800e6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800e7a:	00 
  800e7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800e81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e87:	48 89 d1             	mov    %rdx,%rcx
  800e8a:	48 89 c2             	mov    %rax,%rdx
  800e8d:	be 00 00 00 00       	mov    $0x0,%esi
  800e92:	bf 0f 00 00 00       	mov    $0xf,%edi
  800e97:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800e9e:	00 00 00 
  800ea1:	ff d0                	callq  *%rax
}
  800ea3:	c9                   	leaveq 
  800ea4:	c3                   	retq   

0000000000800ea5 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  800ea5:	55                   	push   %rbp
  800ea6:	48 89 e5             	mov    %rsp,%rbp
  800ea9:	48 83 ec 20          	sub    $0x20,%rsp
  800ead:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800eb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  800eb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800eb9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ebd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800ec4:	00 
  800ec5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ecb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ed1:	48 89 d1             	mov    %rdx,%rcx
  800ed4:	48 89 c2             	mov    %rax,%rdx
  800ed7:	be 00 00 00 00       	mov    $0x0,%esi
  800edc:	bf 10 00 00 00       	mov    $0x10,%edi
  800ee1:	48 b8 cc 09 80 00 00 	movabs $0x8009cc,%rax
  800ee8:	00 00 00 
  800eeb:	ff d0                	callq  *%rax
}
  800eed:	c9                   	leaveq 
  800eee:	c3                   	retq   
	...

0000000000800ef0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800ef0:	55                   	push   %rbp
  800ef1:	48 89 e5             	mov    %rsp,%rbp
  800ef4:	48 83 ec 08          	sub    $0x8,%rsp
  800ef8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800efc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800f00:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800f07:	ff ff ff 
  800f0a:	48 01 d0             	add    %rdx,%rax
  800f0d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800f11:	c9                   	leaveq 
  800f12:	c3                   	retq   

0000000000800f13 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f13:	55                   	push   %rbp
  800f14:	48 89 e5             	mov    %rsp,%rbp
  800f17:	48 83 ec 08          	sub    $0x8,%rsp
  800f1b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800f1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f23:	48 89 c7             	mov    %rax,%rdi
  800f26:	48 b8 f0 0e 80 00 00 	movabs $0x800ef0,%rax
  800f2d:	00 00 00 
  800f30:	ff d0                	callq  *%rax
  800f32:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800f38:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800f3c:	c9                   	leaveq 
  800f3d:	c3                   	retq   

0000000000800f3e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f3e:	55                   	push   %rbp
  800f3f:	48 89 e5             	mov    %rsp,%rbp
  800f42:	48 83 ec 18          	sub    $0x18,%rsp
  800f46:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f51:	eb 6b                	jmp    800fbe <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800f53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f56:	48 98                	cltq   
  800f58:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800f5e:	48 c1 e0 0c          	shl    $0xc,%rax
  800f62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6a:	48 89 c2             	mov    %rax,%rdx
  800f6d:	48 c1 ea 15          	shr    $0x15,%rdx
  800f71:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800f78:	01 00 00 
  800f7b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f7f:	83 e0 01             	and    $0x1,%eax
  800f82:	48 85 c0             	test   %rax,%rax
  800f85:	74 21                	je     800fa8 <fd_alloc+0x6a>
  800f87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f8b:	48 89 c2             	mov    %rax,%rdx
  800f8e:	48 c1 ea 0c          	shr    $0xc,%rdx
  800f92:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800f99:	01 00 00 
  800f9c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800fa0:	83 e0 01             	and    $0x1,%eax
  800fa3:	48 85 c0             	test   %rax,%rax
  800fa6:	75 12                	jne    800fba <fd_alloc+0x7c>
			*fd_store = fd;
  800fa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fb0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb8:	eb 1a                	jmp    800fd4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800fba:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800fbe:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800fc2:	7e 8f                	jle    800f53 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800fcf:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800fd4:	c9                   	leaveq 
  800fd5:	c3                   	retq   

0000000000800fd6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fd6:	55                   	push   %rbp
  800fd7:	48 89 e5             	mov    %rsp,%rbp
  800fda:	48 83 ec 20          	sub    $0x20,%rsp
  800fde:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800fe1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fe5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800fe9:	78 06                	js     800ff1 <fd_lookup+0x1b>
  800feb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800fef:	7e 07                	jle    800ff8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800ff1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff6:	eb 6c                	jmp    801064 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800ff8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ffb:	48 98                	cltq   
  800ffd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801003:	48 c1 e0 0c          	shl    $0xc,%rax
  801007:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80100b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80100f:	48 89 c2             	mov    %rax,%rdx
  801012:	48 c1 ea 15          	shr    $0x15,%rdx
  801016:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80101d:	01 00 00 
  801020:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801024:	83 e0 01             	and    $0x1,%eax
  801027:	48 85 c0             	test   %rax,%rax
  80102a:	74 21                	je     80104d <fd_lookup+0x77>
  80102c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801030:	48 89 c2             	mov    %rax,%rdx
  801033:	48 c1 ea 0c          	shr    $0xc,%rdx
  801037:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80103e:	01 00 00 
  801041:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801045:	83 e0 01             	and    $0x1,%eax
  801048:	48 85 c0             	test   %rax,%rax
  80104b:	75 07                	jne    801054 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80104d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801052:	eb 10                	jmp    801064 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801054:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801058:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80105c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80105f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801064:	c9                   	leaveq 
  801065:	c3                   	retq   

0000000000801066 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801066:	55                   	push   %rbp
  801067:	48 89 e5             	mov    %rsp,%rbp
  80106a:	48 83 ec 30          	sub    $0x30,%rsp
  80106e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801072:	89 f0                	mov    %esi,%eax
  801074:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801077:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80107b:	48 89 c7             	mov    %rax,%rdi
  80107e:	48 b8 f0 0e 80 00 00 	movabs $0x800ef0,%rax
  801085:	00 00 00 
  801088:	ff d0                	callq  *%rax
  80108a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80108e:	48 89 d6             	mov    %rdx,%rsi
  801091:	89 c7                	mov    %eax,%edi
  801093:	48 b8 d6 0f 80 00 00 	movabs $0x800fd6,%rax
  80109a:	00 00 00 
  80109d:	ff d0                	callq  *%rax
  80109f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010a6:	78 0a                	js     8010b2 <fd_close+0x4c>
	    || fd != fd2)
  8010a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ac:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8010b0:	74 12                	je     8010c4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8010b2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8010b6:	74 05                	je     8010bd <fd_close+0x57>
  8010b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010bb:	eb 05                	jmp    8010c2 <fd_close+0x5c>
  8010bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c2:	eb 69                	jmp    80112d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010c8:	8b 00                	mov    (%rax),%eax
  8010ca:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8010ce:	48 89 d6             	mov    %rdx,%rsi
  8010d1:	89 c7                	mov    %eax,%edi
  8010d3:	48 b8 2f 11 80 00 00 	movabs $0x80112f,%rax
  8010da:	00 00 00 
  8010dd:	ff d0                	callq  *%rax
  8010df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010e6:	78 2a                	js     801112 <fd_close+0xac>
		if (dev->dev_close)
  8010e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ec:	48 8b 40 20          	mov    0x20(%rax),%rax
  8010f0:	48 85 c0             	test   %rax,%rax
  8010f3:	74 16                	je     80110b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8010f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f9:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8010fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801101:	48 89 c7             	mov    %rax,%rdi
  801104:	ff d2                	callq  *%rdx
  801106:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801109:	eb 07                	jmp    801112 <fd_close+0xac>
		else
			r = 0;
  80110b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801112:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801116:	48 89 c6             	mov    %rax,%rsi
  801119:	bf 00 00 00 00       	mov    $0x0,%edi
  80111e:	48 b8 5b 0c 80 00 00 	movabs $0x800c5b,%rax
  801125:	00 00 00 
  801128:	ff d0                	callq  *%rax
	return r;
  80112a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80112d:	c9                   	leaveq 
  80112e:	c3                   	retq   

000000000080112f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80112f:	55                   	push   %rbp
  801130:	48 89 e5             	mov    %rsp,%rbp
  801133:	48 83 ec 20          	sub    $0x20,%rsp
  801137:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80113a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80113e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801145:	eb 41                	jmp    801188 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801147:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80114e:	00 00 00 
  801151:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801154:	48 63 d2             	movslq %edx,%rdx
  801157:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80115b:	8b 00                	mov    (%rax),%eax
  80115d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801160:	75 22                	jne    801184 <dev_lookup+0x55>
			*dev = devtab[i];
  801162:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801169:	00 00 00 
  80116c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80116f:	48 63 d2             	movslq %edx,%rdx
  801172:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801176:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80117a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80117d:	b8 00 00 00 00       	mov    $0x0,%eax
  801182:	eb 60                	jmp    8011e4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801184:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801188:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80118f:	00 00 00 
  801192:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801195:	48 63 d2             	movslq %edx,%rdx
  801198:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80119c:	48 85 c0             	test   %rax,%rax
  80119f:	75 a6                	jne    801147 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011a1:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8011a8:	00 00 00 
  8011ab:	48 8b 00             	mov    (%rax),%rax
  8011ae:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8011b4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8011b7:	89 c6                	mov    %eax,%esi
  8011b9:	48 bf e0 3c 80 00 00 	movabs $0x803ce0,%rdi
  8011c0:	00 00 00 
  8011c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c8:	48 b9 bb 2e 80 00 00 	movabs $0x802ebb,%rcx
  8011cf:	00 00 00 
  8011d2:	ff d1                	callq  *%rcx
	*dev = 0;
  8011d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8011df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011e4:	c9                   	leaveq 
  8011e5:	c3                   	retq   

00000000008011e6 <close>:

int
close(int fdnum)
{
  8011e6:	55                   	push   %rbp
  8011e7:	48 89 e5             	mov    %rsp,%rbp
  8011ea:	48 83 ec 20          	sub    $0x20,%rsp
  8011ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011f1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8011f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8011f8:	48 89 d6             	mov    %rdx,%rsi
  8011fb:	89 c7                	mov    %eax,%edi
  8011fd:	48 b8 d6 0f 80 00 00 	movabs $0x800fd6,%rax
  801204:	00 00 00 
  801207:	ff d0                	callq  *%rax
  801209:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80120c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801210:	79 05                	jns    801217 <close+0x31>
		return r;
  801212:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801215:	eb 18                	jmp    80122f <close+0x49>
	else
		return fd_close(fd, 1);
  801217:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121b:	be 01 00 00 00       	mov    $0x1,%esi
  801220:	48 89 c7             	mov    %rax,%rdi
  801223:	48 b8 66 10 80 00 00 	movabs $0x801066,%rax
  80122a:	00 00 00 
  80122d:	ff d0                	callq  *%rax
}
  80122f:	c9                   	leaveq 
  801230:	c3                   	retq   

0000000000801231 <close_all>:

void
close_all(void)
{
  801231:	55                   	push   %rbp
  801232:	48 89 e5             	mov    %rsp,%rbp
  801235:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801239:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801240:	eb 15                	jmp    801257 <close_all+0x26>
		close(i);
  801242:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801245:	89 c7                	mov    %eax,%edi
  801247:	48 b8 e6 11 80 00 00 	movabs $0x8011e6,%rax
  80124e:	00 00 00 
  801251:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801253:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801257:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80125b:	7e e5                	jle    801242 <close_all+0x11>
		close(i);
}
  80125d:	c9                   	leaveq 
  80125e:	c3                   	retq   

000000000080125f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80125f:	55                   	push   %rbp
  801260:	48 89 e5             	mov    %rsp,%rbp
  801263:	48 83 ec 40          	sub    $0x40,%rsp
  801267:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80126a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80126d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801271:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801274:	48 89 d6             	mov    %rdx,%rsi
  801277:	89 c7                	mov    %eax,%edi
  801279:	48 b8 d6 0f 80 00 00 	movabs $0x800fd6,%rax
  801280:	00 00 00 
  801283:	ff d0                	callq  *%rax
  801285:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801288:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80128c:	79 08                	jns    801296 <dup+0x37>
		return r;
  80128e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801291:	e9 70 01 00 00       	jmpq   801406 <dup+0x1a7>
	close(newfdnum);
  801296:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801299:	89 c7                	mov    %eax,%edi
  80129b:	48 b8 e6 11 80 00 00 	movabs $0x8011e6,%rax
  8012a2:	00 00 00 
  8012a5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8012a7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8012aa:	48 98                	cltq   
  8012ac:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8012b2:	48 c1 e0 0c          	shl    $0xc,%rax
  8012b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8012ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012be:	48 89 c7             	mov    %rax,%rdi
  8012c1:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  8012c8:	00 00 00 
  8012cb:	ff d0                	callq  *%rax
  8012cd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8012d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d5:	48 89 c7             	mov    %rax,%rdi
  8012d8:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  8012df:	00 00 00 
  8012e2:	ff d0                	callq  *%rax
  8012e4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ec:	48 89 c2             	mov    %rax,%rdx
  8012ef:	48 c1 ea 15          	shr    $0x15,%rdx
  8012f3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8012fa:	01 00 00 
  8012fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801301:	83 e0 01             	and    $0x1,%eax
  801304:	84 c0                	test   %al,%al
  801306:	74 71                	je     801379 <dup+0x11a>
  801308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130c:	48 89 c2             	mov    %rax,%rdx
  80130f:	48 c1 ea 0c          	shr    $0xc,%rdx
  801313:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80131a:	01 00 00 
  80131d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801321:	83 e0 01             	and    $0x1,%eax
  801324:	84 c0                	test   %al,%al
  801326:	74 51                	je     801379 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801328:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132c:	48 89 c2             	mov    %rax,%rdx
  80132f:	48 c1 ea 0c          	shr    $0xc,%rdx
  801333:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80133a:	01 00 00 
  80133d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801341:	89 c1                	mov    %eax,%ecx
  801343:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801349:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80134d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801351:	41 89 c8             	mov    %ecx,%r8d
  801354:	48 89 d1             	mov    %rdx,%rcx
  801357:	ba 00 00 00 00       	mov    $0x0,%edx
  80135c:	48 89 c6             	mov    %rax,%rsi
  80135f:	bf 00 00 00 00       	mov    $0x0,%edi
  801364:	48 b8 00 0c 80 00 00 	movabs $0x800c00,%rax
  80136b:	00 00 00 
  80136e:	ff d0                	callq  *%rax
  801370:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801373:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801377:	78 56                	js     8013cf <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801379:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137d:	48 89 c2             	mov    %rax,%rdx
  801380:	48 c1 ea 0c          	shr    $0xc,%rdx
  801384:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80138b:	01 00 00 
  80138e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801392:	89 c1                	mov    %eax,%ecx
  801394:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80139a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8013a2:	41 89 c8             	mov    %ecx,%r8d
  8013a5:	48 89 d1             	mov    %rdx,%rcx
  8013a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ad:	48 89 c6             	mov    %rax,%rsi
  8013b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8013b5:	48 b8 00 0c 80 00 00 	movabs $0x800c00,%rax
  8013bc:	00 00 00 
  8013bf:	ff d0                	callq  *%rax
  8013c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013c8:	78 08                	js     8013d2 <dup+0x173>
		goto err;

	return newfdnum;
  8013ca:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8013cd:	eb 37                	jmp    801406 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8013cf:	90                   	nop
  8013d0:	eb 01                	jmp    8013d3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8013d2:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d7:	48 89 c6             	mov    %rax,%rsi
  8013da:	bf 00 00 00 00       	mov    $0x0,%edi
  8013df:	48 b8 5b 0c 80 00 00 	movabs $0x800c5b,%rax
  8013e6:	00 00 00 
  8013e9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8013eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ef:	48 89 c6             	mov    %rax,%rsi
  8013f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8013f7:	48 b8 5b 0c 80 00 00 	movabs $0x800c5b,%rax
  8013fe:	00 00 00 
  801401:	ff d0                	callq  *%rax
	return r;
  801403:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801406:	c9                   	leaveq 
  801407:	c3                   	retq   

0000000000801408 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801408:	55                   	push   %rbp
  801409:	48 89 e5             	mov    %rsp,%rbp
  80140c:	48 83 ec 40          	sub    $0x40,%rsp
  801410:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801413:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801417:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80141b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80141f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801422:	48 89 d6             	mov    %rdx,%rsi
  801425:	89 c7                	mov    %eax,%edi
  801427:	48 b8 d6 0f 80 00 00 	movabs $0x800fd6,%rax
  80142e:	00 00 00 
  801431:	ff d0                	callq  *%rax
  801433:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801436:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80143a:	78 24                	js     801460 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801440:	8b 00                	mov    (%rax),%eax
  801442:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801446:	48 89 d6             	mov    %rdx,%rsi
  801449:	89 c7                	mov    %eax,%edi
  80144b:	48 b8 2f 11 80 00 00 	movabs $0x80112f,%rax
  801452:	00 00 00 
  801455:	ff d0                	callq  *%rax
  801457:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80145a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80145e:	79 05                	jns    801465 <read+0x5d>
		return r;
  801460:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801463:	eb 7a                	jmp    8014df <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801469:	8b 40 08             	mov    0x8(%rax),%eax
  80146c:	83 e0 03             	and    $0x3,%eax
  80146f:	83 f8 01             	cmp    $0x1,%eax
  801472:	75 3a                	jne    8014ae <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801474:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80147b:	00 00 00 
  80147e:	48 8b 00             	mov    (%rax),%rax
  801481:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801487:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80148a:	89 c6                	mov    %eax,%esi
  80148c:	48 bf ff 3c 80 00 00 	movabs $0x803cff,%rdi
  801493:	00 00 00 
  801496:	b8 00 00 00 00       	mov    $0x0,%eax
  80149b:	48 b9 bb 2e 80 00 00 	movabs $0x802ebb,%rcx
  8014a2:	00 00 00 
  8014a5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8014a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ac:	eb 31                	jmp    8014df <read+0xd7>
	}
	if (!dev->dev_read)
  8014ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8014b6:	48 85 c0             	test   %rax,%rax
  8014b9:	75 07                	jne    8014c2 <read+0xba>
		return -E_NOT_SUPP;
  8014bb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8014c0:	eb 1d                	jmp    8014df <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8014c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c6:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8014ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ce:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014d2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8014d6:	48 89 ce             	mov    %rcx,%rsi
  8014d9:	48 89 c7             	mov    %rax,%rdi
  8014dc:	41 ff d0             	callq  *%r8
}
  8014df:	c9                   	leaveq 
  8014e0:	c3                   	retq   

00000000008014e1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014e1:	55                   	push   %rbp
  8014e2:	48 89 e5             	mov    %rsp,%rbp
  8014e5:	48 83 ec 30          	sub    $0x30,%rsp
  8014e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8014ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014fb:	eb 46                	jmp    801543 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801500:	48 98                	cltq   
  801502:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801506:	48 29 c2             	sub    %rax,%rdx
  801509:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80150c:	48 98                	cltq   
  80150e:	48 89 c1             	mov    %rax,%rcx
  801511:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  801515:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801518:	48 89 ce             	mov    %rcx,%rsi
  80151b:	89 c7                	mov    %eax,%edi
  80151d:	48 b8 08 14 80 00 00 	movabs $0x801408,%rax
  801524:	00 00 00 
  801527:	ff d0                	callq  *%rax
  801529:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80152c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801530:	79 05                	jns    801537 <readn+0x56>
			return m;
  801532:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801535:	eb 1d                	jmp    801554 <readn+0x73>
		if (m == 0)
  801537:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80153b:	74 13                	je     801550 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80153d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801540:	01 45 fc             	add    %eax,-0x4(%rbp)
  801543:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801546:	48 98                	cltq   
  801548:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80154c:	72 af                	jb     8014fd <readn+0x1c>
  80154e:	eb 01                	jmp    801551 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  801550:	90                   	nop
	}
	return tot;
  801551:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801554:	c9                   	leaveq 
  801555:	c3                   	retq   

0000000000801556 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801556:	55                   	push   %rbp
  801557:	48 89 e5             	mov    %rsp,%rbp
  80155a:	48 83 ec 40          	sub    $0x40,%rsp
  80155e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801561:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801565:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801569:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80156d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801570:	48 89 d6             	mov    %rdx,%rsi
  801573:	89 c7                	mov    %eax,%edi
  801575:	48 b8 d6 0f 80 00 00 	movabs $0x800fd6,%rax
  80157c:	00 00 00 
  80157f:	ff d0                	callq  *%rax
  801581:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801584:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801588:	78 24                	js     8015ae <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80158a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158e:	8b 00                	mov    (%rax),%eax
  801590:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801594:	48 89 d6             	mov    %rdx,%rsi
  801597:	89 c7                	mov    %eax,%edi
  801599:	48 b8 2f 11 80 00 00 	movabs $0x80112f,%rax
  8015a0:	00 00 00 
  8015a3:	ff d0                	callq  *%rax
  8015a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015ac:	79 05                	jns    8015b3 <write+0x5d>
		return r;
  8015ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015b1:	eb 79                	jmp    80162c <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b7:	8b 40 08             	mov    0x8(%rax),%eax
  8015ba:	83 e0 03             	and    $0x3,%eax
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	75 3a                	jne    8015fb <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015c1:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8015c8:	00 00 00 
  8015cb:	48 8b 00             	mov    (%rax),%rax
  8015ce:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8015d4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8015d7:	89 c6                	mov    %eax,%esi
  8015d9:	48 bf 1b 3d 80 00 00 	movabs $0x803d1b,%rdi
  8015e0:	00 00 00 
  8015e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e8:	48 b9 bb 2e 80 00 00 	movabs $0x802ebb,%rcx
  8015ef:	00 00 00 
  8015f2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8015f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f9:	eb 31                	jmp    80162c <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ff:	48 8b 40 18          	mov    0x18(%rax),%rax
  801603:	48 85 c0             	test   %rax,%rax
  801606:	75 07                	jne    80160f <write+0xb9>
		return -E_NOT_SUPP;
  801608:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80160d:	eb 1d                	jmp    80162c <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80160f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801613:	4c 8b 40 18          	mov    0x18(%rax),%r8
  801617:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80161f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801623:	48 89 ce             	mov    %rcx,%rsi
  801626:	48 89 c7             	mov    %rax,%rdi
  801629:	41 ff d0             	callq  *%r8
}
  80162c:	c9                   	leaveq 
  80162d:	c3                   	retq   

000000000080162e <seek>:

int
seek(int fdnum, off_t offset)
{
  80162e:	55                   	push   %rbp
  80162f:	48 89 e5             	mov    %rsp,%rbp
  801632:	48 83 ec 18          	sub    $0x18,%rsp
  801636:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801639:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80163c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801640:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801643:	48 89 d6             	mov    %rdx,%rsi
  801646:	89 c7                	mov    %eax,%edi
  801648:	48 b8 d6 0f 80 00 00 	movabs $0x800fd6,%rax
  80164f:	00 00 00 
  801652:	ff d0                	callq  *%rax
  801654:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801657:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80165b:	79 05                	jns    801662 <seek+0x34>
		return r;
  80165d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801660:	eb 0f                	jmp    801671 <seek+0x43>
	fd->fd_offset = offset;
  801662:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801666:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801669:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80166c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801671:	c9                   	leaveq 
  801672:	c3                   	retq   

0000000000801673 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801673:	55                   	push   %rbp
  801674:	48 89 e5             	mov    %rsp,%rbp
  801677:	48 83 ec 30          	sub    $0x30,%rsp
  80167b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80167e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801681:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801685:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801688:	48 89 d6             	mov    %rdx,%rsi
  80168b:	89 c7                	mov    %eax,%edi
  80168d:	48 b8 d6 0f 80 00 00 	movabs $0x800fd6,%rax
  801694:	00 00 00 
  801697:	ff d0                	callq  *%rax
  801699:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80169c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016a0:	78 24                	js     8016c6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a6:	8b 00                	mov    (%rax),%eax
  8016a8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8016ac:	48 89 d6             	mov    %rdx,%rsi
  8016af:	89 c7                	mov    %eax,%edi
  8016b1:	48 b8 2f 11 80 00 00 	movabs $0x80112f,%rax
  8016b8:	00 00 00 
  8016bb:	ff d0                	callq  *%rax
  8016bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016c4:	79 05                	jns    8016cb <ftruncate+0x58>
		return r;
  8016c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016c9:	eb 72                	jmp    80173d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016cf:	8b 40 08             	mov    0x8(%rax),%eax
  8016d2:	83 e0 03             	and    $0x3,%eax
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	75 3a                	jne    801713 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8016d9:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8016e0:	00 00 00 
  8016e3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016e6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8016ec:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8016ef:	89 c6                	mov    %eax,%esi
  8016f1:	48 bf 38 3d 80 00 00 	movabs $0x803d38,%rdi
  8016f8:	00 00 00 
  8016fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801700:	48 b9 bb 2e 80 00 00 	movabs $0x802ebb,%rcx
  801707:	00 00 00 
  80170a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80170c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801711:	eb 2a                	jmp    80173d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  801713:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801717:	48 8b 40 30          	mov    0x30(%rax),%rax
  80171b:	48 85 c0             	test   %rax,%rax
  80171e:	75 07                	jne    801727 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  801720:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801725:	eb 16                	jmp    80173d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  801727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172b:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80172f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801733:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801736:	89 d6                	mov    %edx,%esi
  801738:	48 89 c7             	mov    %rax,%rdi
  80173b:	ff d1                	callq  *%rcx
}
  80173d:	c9                   	leaveq 
  80173e:	c3                   	retq   

000000000080173f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80173f:	55                   	push   %rbp
  801740:	48 89 e5             	mov    %rsp,%rbp
  801743:	48 83 ec 30          	sub    $0x30,%rsp
  801747:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80174a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80174e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801752:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801755:	48 89 d6             	mov    %rdx,%rsi
  801758:	89 c7                	mov    %eax,%edi
  80175a:	48 b8 d6 0f 80 00 00 	movabs $0x800fd6,%rax
  801761:	00 00 00 
  801764:	ff d0                	callq  *%rax
  801766:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801769:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80176d:	78 24                	js     801793 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80176f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801773:	8b 00                	mov    (%rax),%eax
  801775:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801779:	48 89 d6             	mov    %rdx,%rsi
  80177c:	89 c7                	mov    %eax,%edi
  80177e:	48 b8 2f 11 80 00 00 	movabs $0x80112f,%rax
  801785:	00 00 00 
  801788:	ff d0                	callq  *%rax
  80178a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80178d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801791:	79 05                	jns    801798 <fstat+0x59>
		return r;
  801793:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801796:	eb 5e                	jmp    8017f6 <fstat+0xb7>
	if (!dev->dev_stat)
  801798:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179c:	48 8b 40 28          	mov    0x28(%rax),%rax
  8017a0:	48 85 c0             	test   %rax,%rax
  8017a3:	75 07                	jne    8017ac <fstat+0x6d>
		return -E_NOT_SUPP;
  8017a5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8017aa:	eb 4a                	jmp    8017f6 <fstat+0xb7>
	stat->st_name[0] = 0;
  8017ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8017b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8017be:	00 00 00 
	stat->st_isdir = 0;
  8017c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017c5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8017cc:	00 00 00 
	stat->st_dev = dev;
  8017cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8017de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e2:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8017e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ea:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017ee:	48 89 d6             	mov    %rdx,%rsi
  8017f1:	48 89 c7             	mov    %rax,%rdi
  8017f4:	ff d1                	callq  *%rcx
}
  8017f6:	c9                   	leaveq 
  8017f7:	c3                   	retq   

00000000008017f8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017f8:	55                   	push   %rbp
  8017f9:	48 89 e5             	mov    %rsp,%rbp
  8017fc:	48 83 ec 20          	sub    $0x20,%rsp
  801800:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801804:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80180c:	be 00 00 00 00       	mov    $0x0,%esi
  801811:	48 89 c7             	mov    %rax,%rdi
  801814:	48 b8 e7 18 80 00 00 	movabs $0x8018e7,%rax
  80181b:	00 00 00 
  80181e:	ff d0                	callq  *%rax
  801820:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801823:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801827:	79 05                	jns    80182e <stat+0x36>
		return fd;
  801829:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80182c:	eb 2f                	jmp    80185d <stat+0x65>
	r = fstat(fd, stat);
  80182e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801832:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801835:	48 89 d6             	mov    %rdx,%rsi
  801838:	89 c7                	mov    %eax,%edi
  80183a:	48 b8 3f 17 80 00 00 	movabs $0x80173f,%rax
  801841:	00 00 00 
  801844:	ff d0                	callq  *%rax
  801846:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  801849:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80184c:	89 c7                	mov    %eax,%edi
  80184e:	48 b8 e6 11 80 00 00 	movabs $0x8011e6,%rax
  801855:	00 00 00 
  801858:	ff d0                	callq  *%rax
	return r;
  80185a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80185d:	c9                   	leaveq 
  80185e:	c3                   	retq   
	...

0000000000801860 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801860:	55                   	push   %rbp
  801861:	48 89 e5             	mov    %rsp,%rbp
  801864:	48 83 ec 10          	sub    $0x10,%rsp
  801868:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80186b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80186f:	48 b8 18 70 80 00 00 	movabs $0x807018,%rax
  801876:	00 00 00 
  801879:	8b 00                	mov    (%rax),%eax
  80187b:	85 c0                	test   %eax,%eax
  80187d:	75 1d                	jne    80189c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80187f:	bf 01 00 00 00       	mov    $0x1,%edi
  801884:	48 b8 8f 3b 80 00 00 	movabs $0x803b8f,%rax
  80188b:	00 00 00 
  80188e:	ff d0                	callq  *%rax
  801890:	48 ba 18 70 80 00 00 	movabs $0x807018,%rdx
  801897:	00 00 00 
  80189a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80189c:	48 b8 18 70 80 00 00 	movabs $0x807018,%rax
  8018a3:	00 00 00 
  8018a6:	8b 00                	mov    (%rax),%eax
  8018a8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8018ab:	b9 07 00 00 00       	mov    $0x7,%ecx
  8018b0:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8018b7:	00 00 00 
  8018ba:	89 c7                	mov    %eax,%edi
  8018bc:	48 b8 cc 3a 80 00 00 	movabs $0x803acc,%rax
  8018c3:	00 00 00 
  8018c6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8018c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d1:	48 89 c6             	mov    %rax,%rsi
  8018d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8018d9:	48 b8 0c 3a 80 00 00 	movabs $0x803a0c,%rax
  8018e0:	00 00 00 
  8018e3:	ff d0                	callq  *%rax
}
  8018e5:	c9                   	leaveq 
  8018e6:	c3                   	retq   

00000000008018e7 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018e7:	55                   	push   %rbp
  8018e8:	48 89 e5             	mov    %rsp,%rbp
  8018eb:	48 83 ec 20          	sub    $0x20,%rsp
  8018ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018f3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  8018f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018fa:	48 89 c7             	mov    %rax,%rdi
  8018fd:	48 b8 0c 02 80 00 00 	movabs $0x80020c,%rax
  801904:	00 00 00 
  801907:	ff d0                	callq  *%rax
  801909:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80190e:	7e 0a                	jle    80191a <open+0x33>
                return -E_BAD_PATH;
  801910:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801915:	e9 a5 00 00 00       	jmpq   8019bf <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  80191a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80191e:	48 89 c7             	mov    %rax,%rdi
  801921:	48 b8 3e 0f 80 00 00 	movabs $0x800f3e,%rax
  801928:	00 00 00 
  80192b:	ff d0                	callq  *%rax
  80192d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801930:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801934:	79 08                	jns    80193e <open+0x57>
		return r;
  801936:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801939:	e9 81 00 00 00       	jmpq   8019bf <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  80193e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801942:	48 89 c6             	mov    %rax,%rsi
  801945:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80194c:	00 00 00 
  80194f:	48 b8 78 02 80 00 00 	movabs $0x800278,%rax
  801956:	00 00 00 
  801959:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  80195b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801962:	00 00 00 
  801965:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801968:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  80196e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801972:	48 89 c6             	mov    %rax,%rsi
  801975:	bf 01 00 00 00       	mov    $0x1,%edi
  80197a:	48 b8 60 18 80 00 00 	movabs $0x801860,%rax
  801981:	00 00 00 
  801984:	ff d0                	callq  *%rax
  801986:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  801989:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80198d:	79 1d                	jns    8019ac <open+0xc5>
	{
		fd_close(fd,0);
  80198f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801993:	be 00 00 00 00       	mov    $0x0,%esi
  801998:	48 89 c7             	mov    %rax,%rdi
  80199b:	48 b8 66 10 80 00 00 	movabs $0x801066,%rax
  8019a2:	00 00 00 
  8019a5:	ff d0                	callq  *%rax
		return r;
  8019a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019aa:	eb 13                	jmp    8019bf <open+0xd8>
	}
	return fd2num(fd);
  8019ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019b0:	48 89 c7             	mov    %rax,%rdi
  8019b3:	48 b8 f0 0e 80 00 00 	movabs $0x800ef0,%rax
  8019ba:	00 00 00 
  8019bd:	ff d0                	callq  *%rax
	


}
  8019bf:	c9                   	leaveq 
  8019c0:	c3                   	retq   

00000000008019c1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019c1:	55                   	push   %rbp
  8019c2:	48 89 e5             	mov    %rsp,%rbp
  8019c5:	48 83 ec 10          	sub    $0x10,%rsp
  8019c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d1:	8b 50 0c             	mov    0xc(%rax),%edx
  8019d4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8019db:	00 00 00 
  8019de:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8019e0:	be 00 00 00 00       	mov    $0x0,%esi
  8019e5:	bf 06 00 00 00       	mov    $0x6,%edi
  8019ea:	48 b8 60 18 80 00 00 	movabs $0x801860,%rax
  8019f1:	00 00 00 
  8019f4:	ff d0                	callq  *%rax
}
  8019f6:	c9                   	leaveq 
  8019f7:	c3                   	retq   

00000000008019f8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8019f8:	55                   	push   %rbp
  8019f9:	48 89 e5             	mov    %rsp,%rbp
  8019fc:	48 83 ec 30          	sub    $0x30,%rsp
  801a00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a04:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a08:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a10:	8b 50 0c             	mov    0xc(%rax),%edx
  801a13:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801a1a:	00 00 00 
  801a1d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801a1f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801a26:	00 00 00 
  801a29:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a2d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a31:	be 00 00 00 00       	mov    $0x0,%esi
  801a36:	bf 03 00 00 00       	mov    $0x3,%edi
  801a3b:	48 b8 60 18 80 00 00 	movabs $0x801860,%rax
  801a42:	00 00 00 
  801a45:	ff d0                	callq  *%rax
  801a47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a4e:	79 05                	jns    801a55 <devfile_read+0x5d>
	{
		return r;
  801a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a53:	eb 2c                	jmp    801a81 <devfile_read+0x89>
	}
	if(r > 0)
  801a55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a59:	7e 23                	jle    801a7e <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  801a5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5e:	48 63 d0             	movslq %eax,%rdx
  801a61:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a65:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801a6c:	00 00 00 
  801a6f:	48 89 c7             	mov    %rax,%rdi
  801a72:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  801a79:	00 00 00 
  801a7c:	ff d0                	callq  *%rax
	return r;
  801a7e:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  801a81:	c9                   	leaveq 
  801a82:	c3                   	retq   

0000000000801a83 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801a83:	55                   	push   %rbp
  801a84:	48 89 e5             	mov    %rsp,%rbp
  801a87:	48 83 ec 30          	sub    $0x30,%rsp
  801a8b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a93:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  801a97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a9b:	8b 50 0c             	mov    0xc(%rax),%edx
  801a9e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801aa5:	00 00 00 
  801aa8:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  801aaa:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801ab1:	00 
  801ab2:	76 08                	jbe    801abc <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  801ab4:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  801abb:	00 
	fsipcbuf.write.req_n=n;
  801abc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801ac3:	00 00 00 
  801ac6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801aca:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  801ace:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ad2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ad6:	48 89 c6             	mov    %rax,%rsi
  801ad9:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  801ae0:	00 00 00 
  801ae3:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  801aea:	00 00 00 
  801aed:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  801aef:	be 00 00 00 00       	mov    $0x0,%esi
  801af4:	bf 04 00 00 00       	mov    $0x4,%edi
  801af9:	48 b8 60 18 80 00 00 	movabs $0x801860,%rax
  801b00:	00 00 00 
  801b03:	ff d0                	callq  *%rax
  801b05:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  801b08:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b0b:	c9                   	leaveq 
  801b0c:	c3                   	retq   

0000000000801b0d <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  801b0d:	55                   	push   %rbp
  801b0e:	48 89 e5             	mov    %rsp,%rbp
  801b11:	48 83 ec 10          	sub    $0x10,%rsp
  801b15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b19:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b20:	8b 50 0c             	mov    0xc(%rax),%edx
  801b23:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801b2a:	00 00 00 
  801b2d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  801b2f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801b36:	00 00 00 
  801b39:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801b3c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b3f:	be 00 00 00 00       	mov    $0x0,%esi
  801b44:	bf 02 00 00 00       	mov    $0x2,%edi
  801b49:	48 b8 60 18 80 00 00 	movabs $0x801860,%rax
  801b50:	00 00 00 
  801b53:	ff d0                	callq  *%rax
}
  801b55:	c9                   	leaveq 
  801b56:	c3                   	retq   

0000000000801b57 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b57:	55                   	push   %rbp
  801b58:	48 89 e5             	mov    %rsp,%rbp
  801b5b:	48 83 ec 20          	sub    $0x20,%rsp
  801b5f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b63:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b6b:	8b 50 0c             	mov    0xc(%rax),%edx
  801b6e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801b75:	00 00 00 
  801b78:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b7a:	be 00 00 00 00       	mov    $0x0,%esi
  801b7f:	bf 05 00 00 00       	mov    $0x5,%edi
  801b84:	48 b8 60 18 80 00 00 	movabs $0x801860,%rax
  801b8b:	00 00 00 
  801b8e:	ff d0                	callq  *%rax
  801b90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b97:	79 05                	jns    801b9e <devfile_stat+0x47>
		return r;
  801b99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b9c:	eb 56                	jmp    801bf4 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ba2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801ba9:	00 00 00 
  801bac:	48 89 c7             	mov    %rax,%rdi
  801baf:	48 b8 78 02 80 00 00 	movabs $0x800278,%rax
  801bb6:	00 00 00 
  801bb9:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801bbb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801bc2:	00 00 00 
  801bc5:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801bcb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bcf:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bd5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801bdc:	00 00 00 
  801bdf:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801be5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801be9:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801bef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf4:	c9                   	leaveq 
  801bf5:	c3                   	retq   
	...

0000000000801bf8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801bf8:	55                   	push   %rbp
  801bf9:	48 89 e5             	mov    %rsp,%rbp
  801bfc:	48 83 ec 20          	sub    $0x20,%rsp
  801c00:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c03:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801c07:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c0a:	48 89 d6             	mov    %rdx,%rsi
  801c0d:	89 c7                	mov    %eax,%edi
  801c0f:	48 b8 d6 0f 80 00 00 	movabs $0x800fd6,%rax
  801c16:	00 00 00 
  801c19:	ff d0                	callq  *%rax
  801c1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c22:	79 05                	jns    801c29 <fd2sockid+0x31>
		return r;
  801c24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c27:	eb 24                	jmp    801c4d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c2d:	8b 10                	mov    (%rax),%edx
  801c2f:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  801c36:	00 00 00 
  801c39:	8b 00                	mov    (%rax),%eax
  801c3b:	39 c2                	cmp    %eax,%edx
  801c3d:	74 07                	je     801c46 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  801c3f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801c44:	eb 07                	jmp    801c4d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  801c46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c4a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  801c4d:	c9                   	leaveq 
  801c4e:	c3                   	retq   

0000000000801c4f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801c4f:	55                   	push   %rbp
  801c50:	48 89 e5             	mov    %rsp,%rbp
  801c53:	48 83 ec 20          	sub    $0x20,%rsp
  801c57:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801c5a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801c5e:	48 89 c7             	mov    %rax,%rdi
  801c61:	48 b8 3e 0f 80 00 00 	movabs $0x800f3e,%rax
  801c68:	00 00 00 
  801c6b:	ff d0                	callq  *%rax
  801c6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c74:	78 26                	js     801c9c <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c7a:	ba 07 04 00 00       	mov    $0x407,%edx
  801c7f:	48 89 c6             	mov    %rax,%rsi
  801c82:	bf 00 00 00 00       	mov    $0x0,%edi
  801c87:	48 b8 b0 0b 80 00 00 	movabs $0x800bb0,%rax
  801c8e:	00 00 00 
  801c91:	ff d0                	callq  *%rax
  801c93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c9a:	79 16                	jns    801cb2 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  801c9c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c9f:	89 c7                	mov    %eax,%edi
  801ca1:	48 b8 5c 21 80 00 00 	movabs $0x80215c,%rax
  801ca8:	00 00 00 
  801cab:	ff d0                	callq  *%rax
		return r;
  801cad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb0:	eb 3a                	jmp    801cec <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801cb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb6:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  801cbd:	00 00 00 
  801cc0:	8b 12                	mov    (%rdx),%edx
  801cc2:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  801cc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  801ccf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cd3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801cd6:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  801cd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cdd:	48 89 c7             	mov    %rax,%rdi
  801ce0:	48 b8 f0 0e 80 00 00 	movabs $0x800ef0,%rax
  801ce7:	00 00 00 
  801cea:	ff d0                	callq  *%rax
}
  801cec:	c9                   	leaveq 
  801ced:	c3                   	retq   

0000000000801cee <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801cee:	55                   	push   %rbp
  801cef:	48 89 e5             	mov    %rsp,%rbp
  801cf2:	48 83 ec 30          	sub    $0x30,%rsp
  801cf6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cf9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801cfd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d01:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d04:	89 c7                	mov    %eax,%edi
  801d06:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  801d0d:	00 00 00 
  801d10:	ff d0                	callq  *%rax
  801d12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d19:	79 05                	jns    801d20 <accept+0x32>
		return r;
  801d1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1e:	eb 3b                	jmp    801d5b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d20:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d24:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801d28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d2b:	48 89 ce             	mov    %rcx,%rsi
  801d2e:	89 c7                	mov    %eax,%edi
  801d30:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  801d37:	00 00 00 
  801d3a:	ff d0                	callq  *%rax
  801d3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d43:	79 05                	jns    801d4a <accept+0x5c>
		return r;
  801d45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d48:	eb 11                	jmp    801d5b <accept+0x6d>
	return alloc_sockfd(r);
  801d4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d4d:	89 c7                	mov    %eax,%edi
  801d4f:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  801d56:	00 00 00 
  801d59:	ff d0                	callq  *%rax
}
  801d5b:	c9                   	leaveq 
  801d5c:	c3                   	retq   

0000000000801d5d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d5d:	55                   	push   %rbp
  801d5e:	48 89 e5             	mov    %rsp,%rbp
  801d61:	48 83 ec 20          	sub    $0x20,%rsp
  801d65:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d68:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d6c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d6f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d72:	89 c7                	mov    %eax,%edi
  801d74:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  801d7b:	00 00 00 
  801d7e:	ff d0                	callq  *%rax
  801d80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d87:	79 05                	jns    801d8e <bind+0x31>
		return r;
  801d89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d8c:	eb 1b                	jmp    801da9 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  801d8e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d91:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d98:	48 89 ce             	mov    %rcx,%rsi
  801d9b:	89 c7                	mov    %eax,%edi
  801d9d:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  801da4:	00 00 00 
  801da7:	ff d0                	callq  *%rax
}
  801da9:	c9                   	leaveq 
  801daa:	c3                   	retq   

0000000000801dab <shutdown>:

int
shutdown(int s, int how)
{
  801dab:	55                   	push   %rbp
  801dac:	48 89 e5             	mov    %rsp,%rbp
  801daf:	48 83 ec 20          	sub    $0x20,%rsp
  801db3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801db6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801db9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dbc:	89 c7                	mov    %eax,%edi
  801dbe:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  801dc5:	00 00 00 
  801dc8:	ff d0                	callq  *%rax
  801dca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dd1:	79 05                	jns    801dd8 <shutdown+0x2d>
		return r;
  801dd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd6:	eb 16                	jmp    801dee <shutdown+0x43>
	return nsipc_shutdown(r, how);
  801dd8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dde:	89 d6                	mov    %edx,%esi
  801de0:	89 c7                	mov    %eax,%edi
  801de2:	48 b8 1c 21 80 00 00 	movabs $0x80211c,%rax
  801de9:	00 00 00 
  801dec:	ff d0                	callq  *%rax
}
  801dee:	c9                   	leaveq 
  801def:	c3                   	retq   

0000000000801df0 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  801df0:	55                   	push   %rbp
  801df1:	48 89 e5             	mov    %rsp,%rbp
  801df4:	48 83 ec 10          	sub    $0x10,%rsp
  801df8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  801dfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e00:	48 89 c7             	mov    %rax,%rdi
  801e03:	48 b8 14 3c 80 00 00 	movabs $0x803c14,%rax
  801e0a:	00 00 00 
  801e0d:	ff d0                	callq  *%rax
  801e0f:	83 f8 01             	cmp    $0x1,%eax
  801e12:	75 17                	jne    801e2b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  801e14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e18:	8b 40 0c             	mov    0xc(%rax),%eax
  801e1b:	89 c7                	mov    %eax,%edi
  801e1d:	48 b8 5c 21 80 00 00 	movabs $0x80215c,%rax
  801e24:	00 00 00 
  801e27:	ff d0                	callq  *%rax
  801e29:	eb 05                	jmp    801e30 <devsock_close+0x40>
	else
		return 0;
  801e2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e30:	c9                   	leaveq 
  801e31:	c3                   	retq   

0000000000801e32 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e32:	55                   	push   %rbp
  801e33:	48 89 e5             	mov    %rsp,%rbp
  801e36:	48 83 ec 20          	sub    $0x20,%rsp
  801e3a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e3d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e41:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e44:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e47:	89 c7                	mov    %eax,%edi
  801e49:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  801e50:	00 00 00 
  801e53:	ff d0                	callq  *%rax
  801e55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e5c:	79 05                	jns    801e63 <connect+0x31>
		return r;
  801e5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e61:	eb 1b                	jmp    801e7e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  801e63:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e66:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801e6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e6d:	48 89 ce             	mov    %rcx,%rsi
  801e70:	89 c7                	mov    %eax,%edi
  801e72:	48 b8 89 21 80 00 00 	movabs $0x802189,%rax
  801e79:	00 00 00 
  801e7c:	ff d0                	callq  *%rax
}
  801e7e:	c9                   	leaveq 
  801e7f:	c3                   	retq   

0000000000801e80 <listen>:

int
listen(int s, int backlog)
{
  801e80:	55                   	push   %rbp
  801e81:	48 89 e5             	mov    %rsp,%rbp
  801e84:	48 83 ec 20          	sub    $0x20,%rsp
  801e88:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e8b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e91:	89 c7                	mov    %eax,%edi
  801e93:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  801e9a:	00 00 00 
  801e9d:	ff d0                	callq  *%rax
  801e9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ea2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ea6:	79 05                	jns    801ead <listen+0x2d>
		return r;
  801ea8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eab:	eb 16                	jmp    801ec3 <listen+0x43>
	return nsipc_listen(r, backlog);
  801ead:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801eb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb3:	89 d6                	mov    %edx,%esi
  801eb5:	89 c7                	mov    %eax,%edi
  801eb7:	48 b8 ed 21 80 00 00 	movabs $0x8021ed,%rax
  801ebe:	00 00 00 
  801ec1:	ff d0                	callq  *%rax
}
  801ec3:	c9                   	leaveq 
  801ec4:	c3                   	retq   

0000000000801ec5 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801ec5:	55                   	push   %rbp
  801ec6:	48 89 e5             	mov    %rsp,%rbp
  801ec9:	48 83 ec 20          	sub    $0x20,%rsp
  801ecd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ed1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ed5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ed9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801edd:	89 c2                	mov    %eax,%edx
  801edf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee3:	8b 40 0c             	mov    0xc(%rax),%eax
  801ee6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801eea:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eef:	89 c7                	mov    %eax,%edi
  801ef1:	48 b8 2d 22 80 00 00 	movabs $0x80222d,%rax
  801ef8:	00 00 00 
  801efb:	ff d0                	callq  *%rax
}
  801efd:	c9                   	leaveq 
  801efe:	c3                   	retq   

0000000000801eff <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801eff:	55                   	push   %rbp
  801f00:	48 89 e5             	mov    %rsp,%rbp
  801f03:	48 83 ec 20          	sub    $0x20,%rsp
  801f07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f0f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f17:	89 c2                	mov    %eax,%edx
  801f19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1d:	8b 40 0c             	mov    0xc(%rax),%eax
  801f20:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801f24:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f29:	89 c7                	mov    %eax,%edi
  801f2b:	48 b8 f9 22 80 00 00 	movabs $0x8022f9,%rax
  801f32:	00 00 00 
  801f35:	ff d0                	callq  *%rax
}
  801f37:	c9                   	leaveq 
  801f38:	c3                   	retq   

0000000000801f39 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f39:	55                   	push   %rbp
  801f3a:	48 89 e5             	mov    %rsp,%rbp
  801f3d:	48 83 ec 10          	sub    $0x10,%rsp
  801f41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  801f49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f4d:	48 be 63 3d 80 00 00 	movabs $0x803d63,%rsi
  801f54:	00 00 00 
  801f57:	48 89 c7             	mov    %rax,%rdi
  801f5a:	48 b8 78 02 80 00 00 	movabs $0x800278,%rax
  801f61:	00 00 00 
  801f64:	ff d0                	callq  *%rax
	return 0;
  801f66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6b:	c9                   	leaveq 
  801f6c:	c3                   	retq   

0000000000801f6d <socket>:

int
socket(int domain, int type, int protocol)
{
  801f6d:	55                   	push   %rbp
  801f6e:	48 89 e5             	mov    %rsp,%rbp
  801f71:	48 83 ec 20          	sub    $0x20,%rsp
  801f75:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f78:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801f7b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f7e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801f81:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801f84:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f87:	89 ce                	mov    %ecx,%esi
  801f89:	89 c7                	mov    %eax,%edi
  801f8b:	48 b8 b1 23 80 00 00 	movabs $0x8023b1,%rax
  801f92:	00 00 00 
  801f95:	ff d0                	callq  *%rax
  801f97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f9e:	79 05                	jns    801fa5 <socket+0x38>
		return r;
  801fa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa3:	eb 11                	jmp    801fb6 <socket+0x49>
	return alloc_sockfd(r);
  801fa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa8:	89 c7                	mov    %eax,%edi
  801faa:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  801fb1:	00 00 00 
  801fb4:	ff d0                	callq  *%rax
}
  801fb6:	c9                   	leaveq 
  801fb7:	c3                   	retq   

0000000000801fb8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fb8:	55                   	push   %rbp
  801fb9:	48 89 e5             	mov    %rsp,%rbp
  801fbc:	48 83 ec 10          	sub    $0x10,%rsp
  801fc0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  801fc3:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  801fca:	00 00 00 
  801fcd:	8b 00                	mov    (%rax),%eax
  801fcf:	85 c0                	test   %eax,%eax
  801fd1:	75 1d                	jne    801ff0 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fd3:	bf 02 00 00 00       	mov    $0x2,%edi
  801fd8:	48 b8 8f 3b 80 00 00 	movabs $0x803b8f,%rax
  801fdf:	00 00 00 
  801fe2:	ff d0                	callq  *%rax
  801fe4:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  801feb:	00 00 00 
  801fee:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ff0:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  801ff7:	00 00 00 
  801ffa:	8b 00                	mov    (%rax),%eax
  801ffc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801fff:	b9 07 00 00 00       	mov    $0x7,%ecx
  802004:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80200b:	00 00 00 
  80200e:	89 c7                	mov    %eax,%edi
  802010:	48 b8 cc 3a 80 00 00 	movabs $0x803acc,%rax
  802017:	00 00 00 
  80201a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80201c:	ba 00 00 00 00       	mov    $0x0,%edx
  802021:	be 00 00 00 00       	mov    $0x0,%esi
  802026:	bf 00 00 00 00       	mov    $0x0,%edi
  80202b:	48 b8 0c 3a 80 00 00 	movabs $0x803a0c,%rax
  802032:	00 00 00 
  802035:	ff d0                	callq  *%rax
}
  802037:	c9                   	leaveq 
  802038:	c3                   	retq   

0000000000802039 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802039:	55                   	push   %rbp
  80203a:	48 89 e5             	mov    %rsp,%rbp
  80203d:	48 83 ec 30          	sub    $0x30,%rsp
  802041:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802044:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802048:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80204c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802053:	00 00 00 
  802056:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802059:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80205b:	bf 01 00 00 00       	mov    $0x1,%edi
  802060:	48 b8 b8 1f 80 00 00 	movabs $0x801fb8,%rax
  802067:	00 00 00 
  80206a:	ff d0                	callq  *%rax
  80206c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802073:	78 3e                	js     8020b3 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802075:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80207c:	00 00 00 
  80207f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802083:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802087:	8b 40 10             	mov    0x10(%rax),%eax
  80208a:	89 c2                	mov    %eax,%edx
  80208c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802090:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802094:	48 89 ce             	mov    %rcx,%rsi
  802097:	48 89 c7             	mov    %rax,%rdi
  80209a:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  8020a1:	00 00 00 
  8020a4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8020a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020aa:	8b 50 10             	mov    0x10(%rax),%edx
  8020ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b1:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8020b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020b6:	c9                   	leaveq 
  8020b7:	c3                   	retq   

00000000008020b8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020b8:	55                   	push   %rbp
  8020b9:	48 89 e5             	mov    %rsp,%rbp
  8020bc:	48 83 ec 10          	sub    $0x10,%rsp
  8020c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020c7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8020ca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8020d1:	00 00 00 
  8020d4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020d7:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020d9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8020dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e0:	48 89 c6             	mov    %rax,%rsi
  8020e3:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8020ea:	00 00 00 
  8020ed:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  8020f4:	00 00 00 
  8020f7:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8020f9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802100:	00 00 00 
  802103:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802106:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802109:	bf 02 00 00 00       	mov    $0x2,%edi
  80210e:	48 b8 b8 1f 80 00 00 	movabs $0x801fb8,%rax
  802115:	00 00 00 
  802118:	ff d0                	callq  *%rax
}
  80211a:	c9                   	leaveq 
  80211b:	c3                   	retq   

000000000080211c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80211c:	55                   	push   %rbp
  80211d:	48 89 e5             	mov    %rsp,%rbp
  802120:	48 83 ec 10          	sub    $0x10,%rsp
  802124:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802127:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80212a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802131:	00 00 00 
  802134:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802137:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802139:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802140:	00 00 00 
  802143:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802146:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802149:	bf 03 00 00 00       	mov    $0x3,%edi
  80214e:	48 b8 b8 1f 80 00 00 	movabs $0x801fb8,%rax
  802155:	00 00 00 
  802158:	ff d0                	callq  *%rax
}
  80215a:	c9                   	leaveq 
  80215b:	c3                   	retq   

000000000080215c <nsipc_close>:

int
nsipc_close(int s)
{
  80215c:	55                   	push   %rbp
  80215d:	48 89 e5             	mov    %rsp,%rbp
  802160:	48 83 ec 10          	sub    $0x10,%rsp
  802164:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802167:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80216e:	00 00 00 
  802171:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802174:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802176:	bf 04 00 00 00       	mov    $0x4,%edi
  80217b:	48 b8 b8 1f 80 00 00 	movabs $0x801fb8,%rax
  802182:	00 00 00 
  802185:	ff d0                	callq  *%rax
}
  802187:	c9                   	leaveq 
  802188:	c3                   	retq   

0000000000802189 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802189:	55                   	push   %rbp
  80218a:	48 89 e5             	mov    %rsp,%rbp
  80218d:	48 83 ec 10          	sub    $0x10,%rsp
  802191:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802194:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802198:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80219b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8021a2:	00 00 00 
  8021a5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021a8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021aa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8021ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021b1:	48 89 c6             	mov    %rax,%rsi
  8021b4:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8021bb:	00 00 00 
  8021be:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  8021c5:	00 00 00 
  8021c8:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8021ca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8021d1:	00 00 00 
  8021d4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8021d7:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8021da:	bf 05 00 00 00       	mov    $0x5,%edi
  8021df:	48 b8 b8 1f 80 00 00 	movabs $0x801fb8,%rax
  8021e6:	00 00 00 
  8021e9:	ff d0                	callq  *%rax
}
  8021eb:	c9                   	leaveq 
  8021ec:	c3                   	retq   

00000000008021ed <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021ed:	55                   	push   %rbp
  8021ee:	48 89 e5             	mov    %rsp,%rbp
  8021f1:	48 83 ec 10          	sub    $0x10,%rsp
  8021f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021f8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8021fb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802202:	00 00 00 
  802205:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802208:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80220a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802211:	00 00 00 
  802214:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802217:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80221a:	bf 06 00 00 00       	mov    $0x6,%edi
  80221f:	48 b8 b8 1f 80 00 00 	movabs $0x801fb8,%rax
  802226:	00 00 00 
  802229:	ff d0                	callq  *%rax
}
  80222b:	c9                   	leaveq 
  80222c:	c3                   	retq   

000000000080222d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80222d:	55                   	push   %rbp
  80222e:	48 89 e5             	mov    %rsp,%rbp
  802231:	48 83 ec 30          	sub    $0x30,%rsp
  802235:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802238:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80223c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80223f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  802242:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802249:	00 00 00 
  80224c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80224f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  802251:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802258:	00 00 00 
  80225b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80225e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  802261:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802268:	00 00 00 
  80226b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80226e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802271:	bf 07 00 00 00       	mov    $0x7,%edi
  802276:	48 b8 b8 1f 80 00 00 	movabs $0x801fb8,%rax
  80227d:	00 00 00 
  802280:	ff d0                	callq  *%rax
  802282:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802285:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802289:	78 69                	js     8022f4 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80228b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  802292:	7f 08                	jg     80229c <nsipc_recv+0x6f>
  802294:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802297:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80229a:	7e 35                	jle    8022d1 <nsipc_recv+0xa4>
  80229c:	48 b9 6a 3d 80 00 00 	movabs $0x803d6a,%rcx
  8022a3:	00 00 00 
  8022a6:	48 ba 7f 3d 80 00 00 	movabs $0x803d7f,%rdx
  8022ad:	00 00 00 
  8022b0:	be 61 00 00 00       	mov    $0x61,%esi
  8022b5:	48 bf 94 3d 80 00 00 	movabs $0x803d94,%rdi
  8022bc:	00 00 00 
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c4:	49 b8 80 2c 80 00 00 	movabs $0x802c80,%r8
  8022cb:	00 00 00 
  8022ce:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022d4:	48 63 d0             	movslq %eax,%rdx
  8022d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022db:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8022e2:	00 00 00 
  8022e5:	48 89 c7             	mov    %rax,%rdi
  8022e8:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  8022ef:	00 00 00 
  8022f2:	ff d0                	callq  *%rax
	}

	return r;
  8022f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022f7:	c9                   	leaveq 
  8022f8:	c3                   	retq   

00000000008022f9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022f9:	55                   	push   %rbp
  8022fa:	48 89 e5             	mov    %rsp,%rbp
  8022fd:	48 83 ec 20          	sub    $0x20,%rsp
  802301:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802304:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802308:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80230b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80230e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802315:	00 00 00 
  802318:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80231b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80231d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  802324:	7e 35                	jle    80235b <nsipc_send+0x62>
  802326:	48 b9 a0 3d 80 00 00 	movabs $0x803da0,%rcx
  80232d:	00 00 00 
  802330:	48 ba 7f 3d 80 00 00 	movabs $0x803d7f,%rdx
  802337:	00 00 00 
  80233a:	be 6c 00 00 00       	mov    $0x6c,%esi
  80233f:	48 bf 94 3d 80 00 00 	movabs $0x803d94,%rdi
  802346:	00 00 00 
  802349:	b8 00 00 00 00       	mov    $0x0,%eax
  80234e:	49 b8 80 2c 80 00 00 	movabs $0x802c80,%r8
  802355:	00 00 00 
  802358:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80235b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80235e:	48 63 d0             	movslq %eax,%rdx
  802361:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802365:	48 89 c6             	mov    %rax,%rsi
  802368:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80236f:	00 00 00 
  802372:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  802379:	00 00 00 
  80237c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80237e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802385:	00 00 00 
  802388:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80238b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80238e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802395:	00 00 00 
  802398:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80239b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80239e:	bf 08 00 00 00       	mov    $0x8,%edi
  8023a3:	48 b8 b8 1f 80 00 00 	movabs $0x801fb8,%rax
  8023aa:	00 00 00 
  8023ad:	ff d0                	callq  *%rax
}
  8023af:	c9                   	leaveq 
  8023b0:	c3                   	retq   

00000000008023b1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023b1:	55                   	push   %rbp
  8023b2:	48 89 e5             	mov    %rsp,%rbp
  8023b5:	48 83 ec 10          	sub    $0x10,%rsp
  8023b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023bc:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8023bf:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8023c2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8023c9:	00 00 00 
  8023cc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023cf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8023d1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8023d8:	00 00 00 
  8023db:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8023de:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8023e1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8023e8:	00 00 00 
  8023eb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8023ee:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8023f1:	bf 09 00 00 00       	mov    $0x9,%edi
  8023f6:	48 b8 b8 1f 80 00 00 	movabs $0x801fb8,%rax
  8023fd:	00 00 00 
  802400:	ff d0                	callq  *%rax
}
  802402:	c9                   	leaveq 
  802403:	c3                   	retq   

0000000000802404 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802404:	55                   	push   %rbp
  802405:	48 89 e5             	mov    %rsp,%rbp
  802408:	53                   	push   %rbx
  802409:	48 83 ec 38          	sub    $0x38,%rsp
  80240d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802411:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802415:	48 89 c7             	mov    %rax,%rdi
  802418:	48 b8 3e 0f 80 00 00 	movabs $0x800f3e,%rax
  80241f:	00 00 00 
  802422:	ff d0                	callq  *%rax
  802424:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802427:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80242b:	0f 88 bf 01 00 00    	js     8025f0 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802431:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802435:	ba 07 04 00 00       	mov    $0x407,%edx
  80243a:	48 89 c6             	mov    %rax,%rsi
  80243d:	bf 00 00 00 00       	mov    $0x0,%edi
  802442:	48 b8 b0 0b 80 00 00 	movabs $0x800bb0,%rax
  802449:	00 00 00 
  80244c:	ff d0                	callq  *%rax
  80244e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802451:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802455:	0f 88 95 01 00 00    	js     8025f0 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80245b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80245f:	48 89 c7             	mov    %rax,%rdi
  802462:	48 b8 3e 0f 80 00 00 	movabs $0x800f3e,%rax
  802469:	00 00 00 
  80246c:	ff d0                	callq  *%rax
  80246e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802471:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802475:	0f 88 5d 01 00 00    	js     8025d8 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80247b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80247f:	ba 07 04 00 00       	mov    $0x407,%edx
  802484:	48 89 c6             	mov    %rax,%rsi
  802487:	bf 00 00 00 00       	mov    $0x0,%edi
  80248c:	48 b8 b0 0b 80 00 00 	movabs $0x800bb0,%rax
  802493:	00 00 00 
  802496:	ff d0                	callq  *%rax
  802498:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80249b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80249f:	0f 88 33 01 00 00    	js     8025d8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8024a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024a9:	48 89 c7             	mov    %rax,%rdi
  8024ac:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  8024b3:	00 00 00 
  8024b6:	ff d0                	callq  *%rax
  8024b8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024c0:	ba 07 04 00 00       	mov    $0x407,%edx
  8024c5:	48 89 c6             	mov    %rax,%rsi
  8024c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8024cd:	48 b8 b0 0b 80 00 00 	movabs $0x800bb0,%rax
  8024d4:	00 00 00 
  8024d7:	ff d0                	callq  *%rax
  8024d9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8024dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024e0:	0f 88 d9 00 00 00    	js     8025bf <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024ea:	48 89 c7             	mov    %rax,%rdi
  8024ed:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  8024f4:	00 00 00 
  8024f7:	ff d0                	callq  *%rax
  8024f9:	48 89 c2             	mov    %rax,%rdx
  8024fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802500:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802506:	48 89 d1             	mov    %rdx,%rcx
  802509:	ba 00 00 00 00       	mov    $0x0,%edx
  80250e:	48 89 c6             	mov    %rax,%rsi
  802511:	bf 00 00 00 00       	mov    $0x0,%edi
  802516:	48 b8 00 0c 80 00 00 	movabs $0x800c00,%rax
  80251d:	00 00 00 
  802520:	ff d0                	callq  *%rax
  802522:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802525:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802529:	78 79                	js     8025a4 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80252b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80252f:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802536:	00 00 00 
  802539:	8b 12                	mov    (%rdx),%edx
  80253b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80253d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802541:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802548:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80254c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802553:	00 00 00 
  802556:	8b 12                	mov    (%rdx),%edx
  802558:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80255a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80255e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802565:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802569:	48 89 c7             	mov    %rax,%rdi
  80256c:	48 b8 f0 0e 80 00 00 	movabs $0x800ef0,%rax
  802573:	00 00 00 
  802576:	ff d0                	callq  *%rax
  802578:	89 c2                	mov    %eax,%edx
  80257a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80257e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802580:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802584:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802588:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80258c:	48 89 c7             	mov    %rax,%rdi
  80258f:	48 b8 f0 0e 80 00 00 	movabs $0x800ef0,%rax
  802596:	00 00 00 
  802599:	ff d0                	callq  *%rax
  80259b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80259d:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a2:	eb 4f                	jmp    8025f3 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8025a4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8025a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025a9:	48 89 c6             	mov    %rax,%rsi
  8025ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b1:	48 b8 5b 0c 80 00 00 	movabs $0x800c5b,%rax
  8025b8:	00 00 00 
  8025bb:	ff d0                	callq  *%rax
  8025bd:	eb 01                	jmp    8025c0 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8025bf:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8025c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025c4:	48 89 c6             	mov    %rax,%rsi
  8025c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8025cc:	48 b8 5b 0c 80 00 00 	movabs $0x800c5b,%rax
  8025d3:	00 00 00 
  8025d6:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8025d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025dc:	48 89 c6             	mov    %rax,%rsi
  8025df:	bf 00 00 00 00       	mov    $0x0,%edi
  8025e4:	48 b8 5b 0c 80 00 00 	movabs $0x800c5b,%rax
  8025eb:	00 00 00 
  8025ee:	ff d0                	callq  *%rax
    err:
	return r;
  8025f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8025f3:	48 83 c4 38          	add    $0x38,%rsp
  8025f7:	5b                   	pop    %rbx
  8025f8:	5d                   	pop    %rbp
  8025f9:	c3                   	retq   

00000000008025fa <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8025fa:	55                   	push   %rbp
  8025fb:	48 89 e5             	mov    %rsp,%rbp
  8025fe:	53                   	push   %rbx
  8025ff:	48 83 ec 28          	sub    $0x28,%rsp
  802603:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802607:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80260b:	eb 01                	jmp    80260e <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  80260d:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80260e:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802615:	00 00 00 
  802618:	48 8b 00             	mov    (%rax),%rax
  80261b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802621:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802624:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802628:	48 89 c7             	mov    %rax,%rdi
  80262b:	48 b8 14 3c 80 00 00 	movabs $0x803c14,%rax
  802632:	00 00 00 
  802635:	ff d0                	callq  *%rax
  802637:	89 c3                	mov    %eax,%ebx
  802639:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80263d:	48 89 c7             	mov    %rax,%rdi
  802640:	48 b8 14 3c 80 00 00 	movabs $0x803c14,%rax
  802647:	00 00 00 
  80264a:	ff d0                	callq  *%rax
  80264c:	39 c3                	cmp    %eax,%ebx
  80264e:	0f 94 c0             	sete   %al
  802651:	0f b6 c0             	movzbl %al,%eax
  802654:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802657:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80265e:	00 00 00 
  802661:	48 8b 00             	mov    (%rax),%rax
  802664:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80266a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80266d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802670:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802673:	75 0a                	jne    80267f <_pipeisclosed+0x85>
			return ret;
  802675:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  802678:	48 83 c4 28          	add    $0x28,%rsp
  80267c:	5b                   	pop    %rbx
  80267d:	5d                   	pop    %rbp
  80267e:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80267f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802682:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802685:	74 86                	je     80260d <_pipeisclosed+0x13>
  802687:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80268b:	75 80                	jne    80260d <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80268d:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802694:	00 00 00 
  802697:	48 8b 00             	mov    (%rax),%rax
  80269a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8026a0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8026a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026a6:	89 c6                	mov    %eax,%esi
  8026a8:	48 bf b1 3d 80 00 00 	movabs $0x803db1,%rdi
  8026af:	00 00 00 
  8026b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b7:	49 b8 bb 2e 80 00 00 	movabs $0x802ebb,%r8
  8026be:	00 00 00 
  8026c1:	41 ff d0             	callq  *%r8
	}
  8026c4:	e9 44 ff ff ff       	jmpq   80260d <_pipeisclosed+0x13>

00000000008026c9 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  8026c9:	55                   	push   %rbp
  8026ca:	48 89 e5             	mov    %rsp,%rbp
  8026cd:	48 83 ec 30          	sub    $0x30,%rsp
  8026d1:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026d4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026d8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026db:	48 89 d6             	mov    %rdx,%rsi
  8026de:	89 c7                	mov    %eax,%edi
  8026e0:	48 b8 d6 0f 80 00 00 	movabs $0x800fd6,%rax
  8026e7:	00 00 00 
  8026ea:	ff d0                	callq  *%rax
  8026ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f3:	79 05                	jns    8026fa <pipeisclosed+0x31>
		return r;
  8026f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f8:	eb 31                	jmp    80272b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8026fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026fe:	48 89 c7             	mov    %rax,%rdi
  802701:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  802708:	00 00 00 
  80270b:	ff d0                	callq  *%rax
  80270d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802711:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802715:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802719:	48 89 d6             	mov    %rdx,%rsi
  80271c:	48 89 c7             	mov    %rax,%rdi
  80271f:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  802726:	00 00 00 
  802729:	ff d0                	callq  *%rax
}
  80272b:	c9                   	leaveq 
  80272c:	c3                   	retq   

000000000080272d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80272d:	55                   	push   %rbp
  80272e:	48 89 e5             	mov    %rsp,%rbp
  802731:	48 83 ec 40          	sub    $0x40,%rsp
  802735:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802739:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80273d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802741:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802745:	48 89 c7             	mov    %rax,%rdi
  802748:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  80274f:	00 00 00 
  802752:	ff d0                	callq  *%rax
  802754:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802758:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80275c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802760:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802767:	00 
  802768:	e9 97 00 00 00       	jmpq   802804 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80276d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802772:	74 09                	je     80277d <devpipe_read+0x50>
				return i;
  802774:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802778:	e9 95 00 00 00       	jmpq   802812 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80277d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802781:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802785:	48 89 d6             	mov    %rdx,%rsi
  802788:	48 89 c7             	mov    %rax,%rdi
  80278b:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  802792:	00 00 00 
  802795:	ff d0                	callq  *%rax
  802797:	85 c0                	test   %eax,%eax
  802799:	74 07                	je     8027a2 <devpipe_read+0x75>
				return 0;
  80279b:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a0:	eb 70                	jmp    802812 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8027a2:	48 b8 72 0b 80 00 00 	movabs $0x800b72,%rax
  8027a9:	00 00 00 
  8027ac:	ff d0                	callq  *%rax
  8027ae:	eb 01                	jmp    8027b1 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8027b0:	90                   	nop
  8027b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b5:	8b 10                	mov    (%rax),%edx
  8027b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027bb:	8b 40 04             	mov    0x4(%rax),%eax
  8027be:	39 c2                	cmp    %eax,%edx
  8027c0:	74 ab                	je     80276d <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8027c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027ca:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8027ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d2:	8b 00                	mov    (%rax),%eax
  8027d4:	89 c2                	mov    %eax,%edx
  8027d6:	c1 fa 1f             	sar    $0x1f,%edx
  8027d9:	c1 ea 1b             	shr    $0x1b,%edx
  8027dc:	01 d0                	add    %edx,%eax
  8027de:	83 e0 1f             	and    $0x1f,%eax
  8027e1:	29 d0                	sub    %edx,%eax
  8027e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027e7:	48 98                	cltq   
  8027e9:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8027ee:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8027f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f4:	8b 00                	mov    (%rax),%eax
  8027f6:	8d 50 01             	lea    0x1(%rax),%edx
  8027f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027fd:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027ff:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802804:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802808:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80280c:	72 a2                	jb     8027b0 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80280e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802812:	c9                   	leaveq 
  802813:	c3                   	retq   

0000000000802814 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802814:	55                   	push   %rbp
  802815:	48 89 e5             	mov    %rsp,%rbp
  802818:	48 83 ec 40          	sub    $0x40,%rsp
  80281c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802820:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802824:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802828:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80282c:	48 89 c7             	mov    %rax,%rdi
  80282f:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  802836:	00 00 00 
  802839:	ff d0                	callq  *%rax
  80283b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80283f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802843:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802847:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80284e:	00 
  80284f:	e9 93 00 00 00       	jmpq   8028e7 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802854:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80285c:	48 89 d6             	mov    %rdx,%rsi
  80285f:	48 89 c7             	mov    %rax,%rdi
  802862:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  802869:	00 00 00 
  80286c:	ff d0                	callq  *%rax
  80286e:	85 c0                	test   %eax,%eax
  802870:	74 07                	je     802879 <devpipe_write+0x65>
				return 0;
  802872:	b8 00 00 00 00       	mov    $0x0,%eax
  802877:	eb 7c                	jmp    8028f5 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802879:	48 b8 72 0b 80 00 00 	movabs $0x800b72,%rax
  802880:	00 00 00 
  802883:	ff d0                	callq  *%rax
  802885:	eb 01                	jmp    802888 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802887:	90                   	nop
  802888:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80288c:	8b 40 04             	mov    0x4(%rax),%eax
  80288f:	48 63 d0             	movslq %eax,%rdx
  802892:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802896:	8b 00                	mov    (%rax),%eax
  802898:	48 98                	cltq   
  80289a:	48 83 c0 20          	add    $0x20,%rax
  80289e:	48 39 c2             	cmp    %rax,%rdx
  8028a1:	73 b1                	jae    802854 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8028a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a7:	8b 40 04             	mov    0x4(%rax),%eax
  8028aa:	89 c2                	mov    %eax,%edx
  8028ac:	c1 fa 1f             	sar    $0x1f,%edx
  8028af:	c1 ea 1b             	shr    $0x1b,%edx
  8028b2:	01 d0                	add    %edx,%eax
  8028b4:	83 e0 1f             	and    $0x1f,%eax
  8028b7:	29 d0                	sub    %edx,%eax
  8028b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8028bd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028c1:	48 01 ca             	add    %rcx,%rdx
  8028c4:	0f b6 0a             	movzbl (%rdx),%ecx
  8028c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028cb:	48 98                	cltq   
  8028cd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8028d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d5:	8b 40 04             	mov    0x4(%rax),%eax
  8028d8:	8d 50 01             	lea    0x1(%rax),%edx
  8028db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028df:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8028e2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8028e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028eb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8028ef:	72 96                	jb     802887 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8028f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8028f5:	c9                   	leaveq 
  8028f6:	c3                   	retq   

00000000008028f7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8028f7:	55                   	push   %rbp
  8028f8:	48 89 e5             	mov    %rsp,%rbp
  8028fb:	48 83 ec 20          	sub    $0x20,%rsp
  8028ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802903:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80290b:	48 89 c7             	mov    %rax,%rdi
  80290e:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  802915:	00 00 00 
  802918:	ff d0                	callq  *%rax
  80291a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80291e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802922:	48 be c4 3d 80 00 00 	movabs $0x803dc4,%rsi
  802929:	00 00 00 
  80292c:	48 89 c7             	mov    %rax,%rdi
  80292f:	48 b8 78 02 80 00 00 	movabs $0x800278,%rax
  802936:	00 00 00 
  802939:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80293b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80293f:	8b 50 04             	mov    0x4(%rax),%edx
  802942:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802946:	8b 00                	mov    (%rax),%eax
  802948:	29 c2                	sub    %eax,%edx
  80294a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80294e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802954:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802958:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80295f:	00 00 00 
	stat->st_dev = &devpipe;
  802962:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802966:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80296d:	00 00 00 
  802970:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  802977:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80297c:	c9                   	leaveq 
  80297d:	c3                   	retq   

000000000080297e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80297e:	55                   	push   %rbp
  80297f:	48 89 e5             	mov    %rsp,%rbp
  802982:	48 83 ec 10          	sub    $0x10,%rsp
  802986:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80298a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80298e:	48 89 c6             	mov    %rax,%rsi
  802991:	bf 00 00 00 00       	mov    $0x0,%edi
  802996:	48 b8 5b 0c 80 00 00 	movabs $0x800c5b,%rax
  80299d:	00 00 00 
  8029a0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8029a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029a6:	48 89 c7             	mov    %rax,%rdi
  8029a9:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  8029b0:	00 00 00 
  8029b3:	ff d0                	callq  *%rax
  8029b5:	48 89 c6             	mov    %rax,%rsi
  8029b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8029bd:	48 b8 5b 0c 80 00 00 	movabs $0x800c5b,%rax
  8029c4:	00 00 00 
  8029c7:	ff d0                	callq  *%rax
}
  8029c9:	c9                   	leaveq 
  8029ca:	c3                   	retq   
	...

00000000008029cc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8029cc:	55                   	push   %rbp
  8029cd:	48 89 e5             	mov    %rsp,%rbp
  8029d0:	48 83 ec 20          	sub    $0x20,%rsp
  8029d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8029d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029da:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8029dd:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8029e1:	be 01 00 00 00       	mov    $0x1,%esi
  8029e6:	48 89 c7             	mov    %rax,%rdi
  8029e9:	48 b8 68 0a 80 00 00 	movabs $0x800a68,%rax
  8029f0:	00 00 00 
  8029f3:	ff d0                	callq  *%rax
}
  8029f5:	c9                   	leaveq 
  8029f6:	c3                   	retq   

00000000008029f7 <getchar>:

int
getchar(void)
{
  8029f7:	55                   	push   %rbp
  8029f8:	48 89 e5             	mov    %rsp,%rbp
  8029fb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8029ff:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802a03:	ba 01 00 00 00       	mov    $0x1,%edx
  802a08:	48 89 c6             	mov    %rax,%rsi
  802a0b:	bf 00 00 00 00       	mov    $0x0,%edi
  802a10:	48 b8 08 14 80 00 00 	movabs $0x801408,%rax
  802a17:	00 00 00 
  802a1a:	ff d0                	callq  *%rax
  802a1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802a1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a23:	79 05                	jns    802a2a <getchar+0x33>
		return r;
  802a25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a28:	eb 14                	jmp    802a3e <getchar+0x47>
	if (r < 1)
  802a2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a2e:	7f 07                	jg     802a37 <getchar+0x40>
		return -E_EOF;
  802a30:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802a35:	eb 07                	jmp    802a3e <getchar+0x47>
	return c;
  802a37:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802a3b:	0f b6 c0             	movzbl %al,%eax
}
  802a3e:	c9                   	leaveq 
  802a3f:	c3                   	retq   

0000000000802a40 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a40:	55                   	push   %rbp
  802a41:	48 89 e5             	mov    %rsp,%rbp
  802a44:	48 83 ec 20          	sub    $0x20,%rsp
  802a48:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a4b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a4f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a52:	48 89 d6             	mov    %rdx,%rsi
  802a55:	89 c7                	mov    %eax,%edi
  802a57:	48 b8 d6 0f 80 00 00 	movabs $0x800fd6,%rax
  802a5e:	00 00 00 
  802a61:	ff d0                	callq  *%rax
  802a63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6a:	79 05                	jns    802a71 <iscons+0x31>
		return r;
  802a6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6f:	eb 1a                	jmp    802a8b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802a71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a75:	8b 10                	mov    (%rax),%edx
  802a77:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  802a7e:	00 00 00 
  802a81:	8b 00                	mov    (%rax),%eax
  802a83:	39 c2                	cmp    %eax,%edx
  802a85:	0f 94 c0             	sete   %al
  802a88:	0f b6 c0             	movzbl %al,%eax
}
  802a8b:	c9                   	leaveq 
  802a8c:	c3                   	retq   

0000000000802a8d <opencons>:

int
opencons(void)
{
  802a8d:	55                   	push   %rbp
  802a8e:	48 89 e5             	mov    %rsp,%rbp
  802a91:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a95:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802a99:	48 89 c7             	mov    %rax,%rdi
  802a9c:	48 b8 3e 0f 80 00 00 	movabs $0x800f3e,%rax
  802aa3:	00 00 00 
  802aa6:	ff d0                	callq  *%rax
  802aa8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aaf:	79 05                	jns    802ab6 <opencons+0x29>
		return r;
  802ab1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab4:	eb 5b                	jmp    802b11 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802ab6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aba:	ba 07 04 00 00       	mov    $0x407,%edx
  802abf:	48 89 c6             	mov    %rax,%rsi
  802ac2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ac7:	48 b8 b0 0b 80 00 00 	movabs $0x800bb0,%rax
  802ace:	00 00 00 
  802ad1:	ff d0                	callq  *%rax
  802ad3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ada:	79 05                	jns    802ae1 <opencons+0x54>
		return r;
  802adc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802adf:	eb 30                	jmp    802b11 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802ae1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae5:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  802aec:	00 00 00 
  802aef:	8b 12                	mov    (%rdx),%edx
  802af1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802af3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802afe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b02:	48 89 c7             	mov    %rax,%rdi
  802b05:	48 b8 f0 0e 80 00 00 	movabs $0x800ef0,%rax
  802b0c:	00 00 00 
  802b0f:	ff d0                	callq  *%rax
}
  802b11:	c9                   	leaveq 
  802b12:	c3                   	retq   

0000000000802b13 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802b13:	55                   	push   %rbp
  802b14:	48 89 e5             	mov    %rsp,%rbp
  802b17:	48 83 ec 30          	sub    $0x30,%rsp
  802b1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b23:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802b27:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802b2c:	75 13                	jne    802b41 <devcons_read+0x2e>
		return 0;
  802b2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b33:	eb 49                	jmp    802b7e <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802b35:	48 b8 72 0b 80 00 00 	movabs $0x800b72,%rax
  802b3c:	00 00 00 
  802b3f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802b41:	48 b8 b2 0a 80 00 00 	movabs $0x800ab2,%rax
  802b48:	00 00 00 
  802b4b:	ff d0                	callq  *%rax
  802b4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b54:	74 df                	je     802b35 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  802b56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5a:	79 05                	jns    802b61 <devcons_read+0x4e>
		return c;
  802b5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5f:	eb 1d                	jmp    802b7e <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  802b61:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802b65:	75 07                	jne    802b6e <devcons_read+0x5b>
		return 0;
  802b67:	b8 00 00 00 00       	mov    $0x0,%eax
  802b6c:	eb 10                	jmp    802b7e <devcons_read+0x6b>
	*(char*)vbuf = c;
  802b6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b71:	89 c2                	mov    %eax,%edx
  802b73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b77:	88 10                	mov    %dl,(%rax)
	return 1;
  802b79:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802b7e:	c9                   	leaveq 
  802b7f:	c3                   	retq   

0000000000802b80 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802b80:	55                   	push   %rbp
  802b81:	48 89 e5             	mov    %rsp,%rbp
  802b84:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  802b8b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  802b92:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  802b99:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802ba0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ba7:	eb 77                	jmp    802c20 <devcons_write+0xa0>
		m = n - tot;
  802ba9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802bb0:	89 c2                	mov    %eax,%edx
  802bb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb5:	89 d1                	mov    %edx,%ecx
  802bb7:	29 c1                	sub    %eax,%ecx
  802bb9:	89 c8                	mov    %ecx,%eax
  802bbb:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802bbe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bc1:	83 f8 7f             	cmp    $0x7f,%eax
  802bc4:	76 07                	jbe    802bcd <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  802bc6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802bcd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bd0:	48 63 d0             	movslq %eax,%rdx
  802bd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd6:	48 98                	cltq   
  802bd8:	48 89 c1             	mov    %rax,%rcx
  802bdb:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  802be2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802be9:	48 89 ce             	mov    %rcx,%rsi
  802bec:	48 89 c7             	mov    %rax,%rdi
  802bef:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  802bf6:	00 00 00 
  802bf9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  802bfb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bfe:	48 63 d0             	movslq %eax,%rdx
  802c01:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802c08:	48 89 d6             	mov    %rdx,%rsi
  802c0b:	48 89 c7             	mov    %rax,%rdi
  802c0e:	48 b8 68 0a 80 00 00 	movabs $0x800a68,%rax
  802c15:	00 00 00 
  802c18:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802c1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c1d:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c23:	48 98                	cltq   
  802c25:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  802c2c:	0f 82 77 ff ff ff    	jb     802ba9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  802c32:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c35:	c9                   	leaveq 
  802c36:	c3                   	retq   

0000000000802c37 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802c37:	55                   	push   %rbp
  802c38:	48 89 e5             	mov    %rsp,%rbp
  802c3b:	48 83 ec 08          	sub    $0x8,%rsp
  802c3f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  802c43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c48:	c9                   	leaveq 
  802c49:	c3                   	retq   

0000000000802c4a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802c4a:	55                   	push   %rbp
  802c4b:	48 89 e5             	mov    %rsp,%rbp
  802c4e:	48 83 ec 10          	sub    $0x10,%rsp
  802c52:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  802c5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c5e:	48 be d0 3d 80 00 00 	movabs $0x803dd0,%rsi
  802c65:	00 00 00 
  802c68:	48 89 c7             	mov    %rax,%rdi
  802c6b:	48 b8 78 02 80 00 00 	movabs $0x800278,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
	return 0;
  802c77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c7c:	c9                   	leaveq 
  802c7d:	c3                   	retq   
	...

0000000000802c80 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802c80:	55                   	push   %rbp
  802c81:	48 89 e5             	mov    %rsp,%rbp
  802c84:	53                   	push   %rbx
  802c85:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802c8c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802c93:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802c99:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802ca0:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802ca7:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802cae:	84 c0                	test   %al,%al
  802cb0:	74 23                	je     802cd5 <_panic+0x55>
  802cb2:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802cb9:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802cbd:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802cc1:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802cc5:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802cc9:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802ccd:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802cd1:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802cd5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802cdc:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802ce3:	00 00 00 
  802ce6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802ced:	00 00 00 
  802cf0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802cf4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802cfb:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802d02:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802d09:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802d10:	00 00 00 
  802d13:	48 8b 18             	mov    (%rax),%rbx
  802d16:	48 b8 34 0b 80 00 00 	movabs $0x800b34,%rax
  802d1d:	00 00 00 
  802d20:	ff d0                	callq  *%rax
  802d22:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  802d28:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802d2f:	41 89 c8             	mov    %ecx,%r8d
  802d32:	48 89 d1             	mov    %rdx,%rcx
  802d35:	48 89 da             	mov    %rbx,%rdx
  802d38:	89 c6                	mov    %eax,%esi
  802d3a:	48 bf d8 3d 80 00 00 	movabs $0x803dd8,%rdi
  802d41:	00 00 00 
  802d44:	b8 00 00 00 00       	mov    $0x0,%eax
  802d49:	49 b9 bb 2e 80 00 00 	movabs $0x802ebb,%r9
  802d50:	00 00 00 
  802d53:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802d56:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  802d5d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802d64:	48 89 d6             	mov    %rdx,%rsi
  802d67:	48 89 c7             	mov    %rax,%rdi
  802d6a:	48 b8 0f 2e 80 00 00 	movabs $0x802e0f,%rax
  802d71:	00 00 00 
  802d74:	ff d0                	callq  *%rax
	cprintf("\n");
  802d76:	48 bf fb 3d 80 00 00 	movabs $0x803dfb,%rdi
  802d7d:	00 00 00 
  802d80:	b8 00 00 00 00       	mov    $0x0,%eax
  802d85:	48 ba bb 2e 80 00 00 	movabs $0x802ebb,%rdx
  802d8c:	00 00 00 
  802d8f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802d91:	cc                   	int3   
  802d92:	eb fd                	jmp    802d91 <_panic+0x111>

0000000000802d94 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  802d94:	55                   	push   %rbp
  802d95:	48 89 e5             	mov    %rsp,%rbp
  802d98:	48 83 ec 10          	sub    $0x10,%rsp
  802d9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d9f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  802da3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da7:	8b 00                	mov    (%rax),%eax
  802da9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802dac:	89 d6                	mov    %edx,%esi
  802dae:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802db2:	48 63 d0             	movslq %eax,%rdx
  802db5:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  802dba:	8d 50 01             	lea    0x1(%rax),%edx
  802dbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc1:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  802dc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc7:	8b 00                	mov    (%rax),%eax
  802dc9:	3d ff 00 00 00       	cmp    $0xff,%eax
  802dce:	75 2c                	jne    802dfc <putch+0x68>
		sys_cputs(b->buf, b->idx);
  802dd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd4:	8b 00                	mov    (%rax),%eax
  802dd6:	48 98                	cltq   
  802dd8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ddc:	48 83 c2 08          	add    $0x8,%rdx
  802de0:	48 89 c6             	mov    %rax,%rsi
  802de3:	48 89 d7             	mov    %rdx,%rdi
  802de6:	48 b8 68 0a 80 00 00 	movabs $0x800a68,%rax
  802ded:	00 00 00 
  802df0:	ff d0                	callq  *%rax
		b->idx = 0;
  802df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  802dfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e00:	8b 40 04             	mov    0x4(%rax),%eax
  802e03:	8d 50 01             	lea    0x1(%rax),%edx
  802e06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0a:	89 50 04             	mov    %edx,0x4(%rax)
}
  802e0d:	c9                   	leaveq 
  802e0e:	c3                   	retq   

0000000000802e0f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  802e0f:	55                   	push   %rbp
  802e10:	48 89 e5             	mov    %rsp,%rbp
  802e13:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802e1a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  802e21:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  802e28:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  802e2f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802e36:	48 8b 0a             	mov    (%rdx),%rcx
  802e39:	48 89 08             	mov    %rcx,(%rax)
  802e3c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802e40:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802e44:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802e48:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  802e4c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  802e53:	00 00 00 
	b.cnt = 0;
  802e56:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802e5d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  802e60:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802e67:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802e6e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802e75:	48 89 c6             	mov    %rax,%rsi
  802e78:	48 bf 94 2d 80 00 00 	movabs $0x802d94,%rdi
  802e7f:	00 00 00 
  802e82:	48 b8 6c 32 80 00 00 	movabs $0x80326c,%rax
  802e89:	00 00 00 
  802e8c:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  802e8e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802e94:	48 98                	cltq   
  802e96:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802e9d:	48 83 c2 08          	add    $0x8,%rdx
  802ea1:	48 89 c6             	mov    %rax,%rsi
  802ea4:	48 89 d7             	mov    %rdx,%rdi
  802ea7:	48 b8 68 0a 80 00 00 	movabs $0x800a68,%rax
  802eae:	00 00 00 
  802eb1:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  802eb3:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802eb9:	c9                   	leaveq 
  802eba:	c3                   	retq   

0000000000802ebb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  802ebb:	55                   	push   %rbp
  802ebc:	48 89 e5             	mov    %rsp,%rbp
  802ebf:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802ec6:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802ecd:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802ed4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802edb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802ee2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802ee9:	84 c0                	test   %al,%al
  802eeb:	74 20                	je     802f0d <cprintf+0x52>
  802eed:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802ef1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802ef5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802ef9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802efd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802f01:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802f05:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802f09:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802f0d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  802f14:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802f1b:	00 00 00 
  802f1e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802f25:	00 00 00 
  802f28:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f2c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802f33:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802f3a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802f41:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802f48:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802f4f:	48 8b 0a             	mov    (%rdx),%rcx
  802f52:	48 89 08             	mov    %rcx,(%rax)
  802f55:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802f59:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802f5d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802f61:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  802f65:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802f6c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802f73:	48 89 d6             	mov    %rdx,%rsi
  802f76:	48 89 c7             	mov    %rax,%rdi
  802f79:	48 b8 0f 2e 80 00 00 	movabs $0x802e0f,%rax
  802f80:	00 00 00 
  802f83:	ff d0                	callq  *%rax
  802f85:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  802f8b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802f91:	c9                   	leaveq 
  802f92:	c3                   	retq   
	...

0000000000802f94 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802f94:	55                   	push   %rbp
  802f95:	48 89 e5             	mov    %rsp,%rbp
  802f98:	48 83 ec 30          	sub    $0x30,%rsp
  802f9c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fa0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fa4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802fa8:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  802fab:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  802faf:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802fb3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802fb6:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  802fba:	77 52                	ja     80300e <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802fbc:	8b 45 e0             	mov    -0x20(%rbp),%eax
  802fbf:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802fc3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802fc6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802fca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fce:	ba 00 00 00 00       	mov    $0x0,%edx
  802fd3:	48 f7 75 d0          	divq   -0x30(%rbp)
  802fd7:	48 89 c2             	mov    %rax,%rdx
  802fda:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802fdd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802fe0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802fe4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fe8:	41 89 f9             	mov    %edi,%r9d
  802feb:	48 89 c7             	mov    %rax,%rdi
  802fee:	48 b8 94 2f 80 00 00 	movabs $0x802f94,%rax
  802ff5:	00 00 00 
  802ff8:	ff d0                	callq  *%rax
  802ffa:	eb 1c                	jmp    803018 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  802ffc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803000:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803003:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803007:	48 89 d6             	mov    %rdx,%rsi
  80300a:	89 c7                	mov    %eax,%edi
  80300c:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80300e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  803012:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  803016:	7f e4                	jg     802ffc <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  803018:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80301b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301f:	ba 00 00 00 00       	mov    $0x0,%edx
  803024:	48 f7 f1             	div    %rcx
  803027:	48 89 d0             	mov    %rdx,%rax
  80302a:	48 ba c8 3f 80 00 00 	movabs $0x803fc8,%rdx
  803031:	00 00 00 
  803034:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  803038:	0f be c0             	movsbl %al,%eax
  80303b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80303f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803043:	48 89 d6             	mov    %rdx,%rsi
  803046:	89 c7                	mov    %eax,%edi
  803048:	ff d1                	callq  *%rcx
}
  80304a:	c9                   	leaveq 
  80304b:	c3                   	retq   

000000000080304c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80304c:	55                   	push   %rbp
  80304d:	48 89 e5             	mov    %rsp,%rbp
  803050:	48 83 ec 20          	sub    $0x20,%rsp
  803054:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803058:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80305b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80305f:	7e 52                	jle    8030b3 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  803061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803065:	8b 00                	mov    (%rax),%eax
  803067:	83 f8 30             	cmp    $0x30,%eax
  80306a:	73 24                	jae    803090 <getuint+0x44>
  80306c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803070:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803078:	8b 00                	mov    (%rax),%eax
  80307a:	89 c0                	mov    %eax,%eax
  80307c:	48 01 d0             	add    %rdx,%rax
  80307f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803083:	8b 12                	mov    (%rdx),%edx
  803085:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803088:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80308c:	89 0a                	mov    %ecx,(%rdx)
  80308e:	eb 17                	jmp    8030a7 <getuint+0x5b>
  803090:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803094:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803098:	48 89 d0             	mov    %rdx,%rax
  80309b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80309f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8030a7:	48 8b 00             	mov    (%rax),%rax
  8030aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8030ae:	e9 a3 00 00 00       	jmpq   803156 <getuint+0x10a>
	else if (lflag)
  8030b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8030b7:	74 4f                	je     803108 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8030b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030bd:	8b 00                	mov    (%rax),%eax
  8030bf:	83 f8 30             	cmp    $0x30,%eax
  8030c2:	73 24                	jae    8030e8 <getuint+0x9c>
  8030c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8030cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d0:	8b 00                	mov    (%rax),%eax
  8030d2:	89 c0                	mov    %eax,%eax
  8030d4:	48 01 d0             	add    %rdx,%rax
  8030d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030db:	8b 12                	mov    (%rdx),%edx
  8030dd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8030e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030e4:	89 0a                	mov    %ecx,(%rdx)
  8030e6:	eb 17                	jmp    8030ff <getuint+0xb3>
  8030e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ec:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8030f0:	48 89 d0             	mov    %rdx,%rax
  8030f3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8030f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030fb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8030ff:	48 8b 00             	mov    (%rax),%rax
  803102:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803106:	eb 4e                	jmp    803156 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  803108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80310c:	8b 00                	mov    (%rax),%eax
  80310e:	83 f8 30             	cmp    $0x30,%eax
  803111:	73 24                	jae    803137 <getuint+0xeb>
  803113:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803117:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80311b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311f:	8b 00                	mov    (%rax),%eax
  803121:	89 c0                	mov    %eax,%eax
  803123:	48 01 d0             	add    %rdx,%rax
  803126:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80312a:	8b 12                	mov    (%rdx),%edx
  80312c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80312f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803133:	89 0a                	mov    %ecx,(%rdx)
  803135:	eb 17                	jmp    80314e <getuint+0x102>
  803137:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80313f:	48 89 d0             	mov    %rdx,%rax
  803142:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803146:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80314a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80314e:	8b 00                	mov    (%rax),%eax
  803150:	89 c0                	mov    %eax,%eax
  803152:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803156:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80315a:	c9                   	leaveq 
  80315b:	c3                   	retq   

000000000080315c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80315c:	55                   	push   %rbp
  80315d:	48 89 e5             	mov    %rsp,%rbp
  803160:	48 83 ec 20          	sub    $0x20,%rsp
  803164:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803168:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80316b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80316f:	7e 52                	jle    8031c3 <getint+0x67>
		x=va_arg(*ap, long long);
  803171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803175:	8b 00                	mov    (%rax),%eax
  803177:	83 f8 30             	cmp    $0x30,%eax
  80317a:	73 24                	jae    8031a0 <getint+0x44>
  80317c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803180:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803184:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803188:	8b 00                	mov    (%rax),%eax
  80318a:	89 c0                	mov    %eax,%eax
  80318c:	48 01 d0             	add    %rdx,%rax
  80318f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803193:	8b 12                	mov    (%rdx),%edx
  803195:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803198:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80319c:	89 0a                	mov    %ecx,(%rdx)
  80319e:	eb 17                	jmp    8031b7 <getint+0x5b>
  8031a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8031a8:	48 89 d0             	mov    %rdx,%rax
  8031ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8031af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8031b7:	48 8b 00             	mov    (%rax),%rax
  8031ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8031be:	e9 a3 00 00 00       	jmpq   803266 <getint+0x10a>
	else if (lflag)
  8031c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8031c7:	74 4f                	je     803218 <getint+0xbc>
		x=va_arg(*ap, long);
  8031c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031cd:	8b 00                	mov    (%rax),%eax
  8031cf:	83 f8 30             	cmp    $0x30,%eax
  8031d2:	73 24                	jae    8031f8 <getint+0x9c>
  8031d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031d8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8031dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031e0:	8b 00                	mov    (%rax),%eax
  8031e2:	89 c0                	mov    %eax,%eax
  8031e4:	48 01 d0             	add    %rdx,%rax
  8031e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031eb:	8b 12                	mov    (%rdx),%edx
  8031ed:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8031f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031f4:	89 0a                	mov    %ecx,(%rdx)
  8031f6:	eb 17                	jmp    80320f <getint+0xb3>
  8031f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031fc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803200:	48 89 d0             	mov    %rdx,%rax
  803203:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803207:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80320b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80320f:	48 8b 00             	mov    (%rax),%rax
  803212:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803216:	eb 4e                	jmp    803266 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  803218:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80321c:	8b 00                	mov    (%rax),%eax
  80321e:	83 f8 30             	cmp    $0x30,%eax
  803221:	73 24                	jae    803247 <getint+0xeb>
  803223:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803227:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80322b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80322f:	8b 00                	mov    (%rax),%eax
  803231:	89 c0                	mov    %eax,%eax
  803233:	48 01 d0             	add    %rdx,%rax
  803236:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80323a:	8b 12                	mov    (%rdx),%edx
  80323c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80323f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803243:	89 0a                	mov    %ecx,(%rdx)
  803245:	eb 17                	jmp    80325e <getint+0x102>
  803247:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80324b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80324f:	48 89 d0             	mov    %rdx,%rax
  803252:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803256:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80325a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80325e:	8b 00                	mov    (%rax),%eax
  803260:	48 98                	cltq   
  803262:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80326a:	c9                   	leaveq 
  80326b:	c3                   	retq   

000000000080326c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80326c:	55                   	push   %rbp
  80326d:	48 89 e5             	mov    %rsp,%rbp
  803270:	41 54                	push   %r12
  803272:	53                   	push   %rbx
  803273:	48 83 ec 60          	sub    $0x60,%rsp
  803277:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80327b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80327f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803283:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803287:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80328b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80328f:	48 8b 0a             	mov    (%rdx),%rcx
  803292:	48 89 08             	mov    %rcx,(%rax)
  803295:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803299:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80329d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8032a1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8032a5:	eb 17                	jmp    8032be <vprintfmt+0x52>
			if (ch == '\0')
  8032a7:	85 db                	test   %ebx,%ebx
  8032a9:	0f 84 d7 04 00 00    	je     803786 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  8032af:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8032b3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8032b7:	48 89 c6             	mov    %rax,%rsi
  8032ba:	89 df                	mov    %ebx,%edi
  8032bc:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8032be:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8032c2:	0f b6 00             	movzbl (%rax),%eax
  8032c5:	0f b6 d8             	movzbl %al,%ebx
  8032c8:	83 fb 25             	cmp    $0x25,%ebx
  8032cb:	0f 95 c0             	setne  %al
  8032ce:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8032d3:	84 c0                	test   %al,%al
  8032d5:	75 d0                	jne    8032a7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8032d7:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8032db:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8032e2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8032e9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8032f0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8032f7:	eb 04                	jmp    8032fd <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8032f9:	90                   	nop
  8032fa:	eb 01                	jmp    8032fd <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8032fc:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8032fd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803301:	0f b6 00             	movzbl (%rax),%eax
  803304:	0f b6 d8             	movzbl %al,%ebx
  803307:	89 d8                	mov    %ebx,%eax
  803309:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80330e:	83 e8 23             	sub    $0x23,%eax
  803311:	83 f8 55             	cmp    $0x55,%eax
  803314:	0f 87 38 04 00 00    	ja     803752 <vprintfmt+0x4e6>
  80331a:	89 c0                	mov    %eax,%eax
  80331c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803323:	00 
  803324:	48 b8 f0 3f 80 00 00 	movabs $0x803ff0,%rax
  80332b:	00 00 00 
  80332e:	48 01 d0             	add    %rdx,%rax
  803331:	48 8b 00             	mov    (%rax),%rax
  803334:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  803336:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80333a:	eb c1                	jmp    8032fd <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80333c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  803340:	eb bb                	jmp    8032fd <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803342:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  803349:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80334c:	89 d0                	mov    %edx,%eax
  80334e:	c1 e0 02             	shl    $0x2,%eax
  803351:	01 d0                	add    %edx,%eax
  803353:	01 c0                	add    %eax,%eax
  803355:	01 d8                	add    %ebx,%eax
  803357:	83 e8 30             	sub    $0x30,%eax
  80335a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80335d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803361:	0f b6 00             	movzbl (%rax),%eax
  803364:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  803367:	83 fb 2f             	cmp    $0x2f,%ebx
  80336a:	7e 63                	jle    8033cf <vprintfmt+0x163>
  80336c:	83 fb 39             	cmp    $0x39,%ebx
  80336f:	7f 5e                	jg     8033cf <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803371:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  803376:	eb d1                	jmp    803349 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  803378:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80337b:	83 f8 30             	cmp    $0x30,%eax
  80337e:	73 17                	jae    803397 <vprintfmt+0x12b>
  803380:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803384:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803387:	89 c0                	mov    %eax,%eax
  803389:	48 01 d0             	add    %rdx,%rax
  80338c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80338f:	83 c2 08             	add    $0x8,%edx
  803392:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803395:	eb 0f                	jmp    8033a6 <vprintfmt+0x13a>
  803397:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80339b:	48 89 d0             	mov    %rdx,%rax
  80339e:	48 83 c2 08          	add    $0x8,%rdx
  8033a2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8033a6:	8b 00                	mov    (%rax),%eax
  8033a8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8033ab:	eb 23                	jmp    8033d0 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8033ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8033b1:	0f 89 42 ff ff ff    	jns    8032f9 <vprintfmt+0x8d>
				width = 0;
  8033b7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8033be:	e9 36 ff ff ff       	jmpq   8032f9 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  8033c3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8033ca:	e9 2e ff ff ff       	jmpq   8032fd <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8033cf:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8033d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8033d4:	0f 89 22 ff ff ff    	jns    8032fc <vprintfmt+0x90>
				width = precision, precision = -1;
  8033da:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8033dd:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8033e0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8033e7:	e9 10 ff ff ff       	jmpq   8032fc <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8033ec:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8033f0:	e9 08 ff ff ff       	jmpq   8032fd <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8033f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8033f8:	83 f8 30             	cmp    $0x30,%eax
  8033fb:	73 17                	jae    803414 <vprintfmt+0x1a8>
  8033fd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803401:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803404:	89 c0                	mov    %eax,%eax
  803406:	48 01 d0             	add    %rdx,%rax
  803409:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80340c:	83 c2 08             	add    $0x8,%edx
  80340f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803412:	eb 0f                	jmp    803423 <vprintfmt+0x1b7>
  803414:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803418:	48 89 d0             	mov    %rdx,%rax
  80341b:	48 83 c2 08          	add    $0x8,%rdx
  80341f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803423:	8b 00                	mov    (%rax),%eax
  803425:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803429:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80342d:	48 89 d6             	mov    %rdx,%rsi
  803430:	89 c7                	mov    %eax,%edi
  803432:	ff d1                	callq  *%rcx
			break;
  803434:	e9 47 03 00 00       	jmpq   803780 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  803439:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80343c:	83 f8 30             	cmp    $0x30,%eax
  80343f:	73 17                	jae    803458 <vprintfmt+0x1ec>
  803441:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803445:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803448:	89 c0                	mov    %eax,%eax
  80344a:	48 01 d0             	add    %rdx,%rax
  80344d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803450:	83 c2 08             	add    $0x8,%edx
  803453:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803456:	eb 0f                	jmp    803467 <vprintfmt+0x1fb>
  803458:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80345c:	48 89 d0             	mov    %rdx,%rax
  80345f:	48 83 c2 08          	add    $0x8,%rdx
  803463:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803467:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803469:	85 db                	test   %ebx,%ebx
  80346b:	79 02                	jns    80346f <vprintfmt+0x203>
				err = -err;
  80346d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80346f:	83 fb 10             	cmp    $0x10,%ebx
  803472:	7f 16                	jg     80348a <vprintfmt+0x21e>
  803474:	48 b8 40 3f 80 00 00 	movabs $0x803f40,%rax
  80347b:	00 00 00 
  80347e:	48 63 d3             	movslq %ebx,%rdx
  803481:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803485:	4d 85 e4             	test   %r12,%r12
  803488:	75 2e                	jne    8034b8 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80348a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80348e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803492:	89 d9                	mov    %ebx,%ecx
  803494:	48 ba d9 3f 80 00 00 	movabs $0x803fd9,%rdx
  80349b:	00 00 00 
  80349e:	48 89 c7             	mov    %rax,%rdi
  8034a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a6:	49 b8 90 37 80 00 00 	movabs $0x803790,%r8
  8034ad:	00 00 00 
  8034b0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8034b3:	e9 c8 02 00 00       	jmpq   803780 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8034b8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8034bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8034c0:	4c 89 e1             	mov    %r12,%rcx
  8034c3:	48 ba e2 3f 80 00 00 	movabs $0x803fe2,%rdx
  8034ca:	00 00 00 
  8034cd:	48 89 c7             	mov    %rax,%rdi
  8034d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d5:	49 b8 90 37 80 00 00 	movabs $0x803790,%r8
  8034dc:	00 00 00 
  8034df:	41 ff d0             	callq  *%r8
			break;
  8034e2:	e9 99 02 00 00       	jmpq   803780 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8034e7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8034ea:	83 f8 30             	cmp    $0x30,%eax
  8034ed:	73 17                	jae    803506 <vprintfmt+0x29a>
  8034ef:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8034f3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8034f6:	89 c0                	mov    %eax,%eax
  8034f8:	48 01 d0             	add    %rdx,%rax
  8034fb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8034fe:	83 c2 08             	add    $0x8,%edx
  803501:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803504:	eb 0f                	jmp    803515 <vprintfmt+0x2a9>
  803506:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80350a:	48 89 d0             	mov    %rdx,%rax
  80350d:	48 83 c2 08          	add    $0x8,%rdx
  803511:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803515:	4c 8b 20             	mov    (%rax),%r12
  803518:	4d 85 e4             	test   %r12,%r12
  80351b:	75 0a                	jne    803527 <vprintfmt+0x2bb>
				p = "(null)";
  80351d:	49 bc e5 3f 80 00 00 	movabs $0x803fe5,%r12
  803524:	00 00 00 
			if (width > 0 && padc != '-')
  803527:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80352b:	7e 7a                	jle    8035a7 <vprintfmt+0x33b>
  80352d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803531:	74 74                	je     8035a7 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  803533:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803536:	48 98                	cltq   
  803538:	48 89 c6             	mov    %rax,%rsi
  80353b:	4c 89 e7             	mov    %r12,%rdi
  80353e:	48 b8 3a 02 80 00 00 	movabs $0x80023a,%rax
  803545:	00 00 00 
  803548:	ff d0                	callq  *%rax
  80354a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80354d:	eb 17                	jmp    803566 <vprintfmt+0x2fa>
					putch(padc, putdat);
  80354f:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  803553:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803557:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80355b:	48 89 d6             	mov    %rdx,%rsi
  80355e:	89 c7                	mov    %eax,%edi
  803560:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803562:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803566:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80356a:	7f e3                	jg     80354f <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80356c:	eb 39                	jmp    8035a7 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  80356e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803572:	74 1e                	je     803592 <vprintfmt+0x326>
  803574:	83 fb 1f             	cmp    $0x1f,%ebx
  803577:	7e 05                	jle    80357e <vprintfmt+0x312>
  803579:	83 fb 7e             	cmp    $0x7e,%ebx
  80357c:	7e 14                	jle    803592 <vprintfmt+0x326>
					putch('?', putdat);
  80357e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803582:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803586:	48 89 c6             	mov    %rax,%rsi
  803589:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80358e:	ff d2                	callq  *%rdx
  803590:	eb 0f                	jmp    8035a1 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  803592:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803596:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80359a:	48 89 c6             	mov    %rax,%rsi
  80359d:	89 df                	mov    %ebx,%edi
  80359f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8035a1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8035a5:	eb 01                	jmp    8035a8 <vprintfmt+0x33c>
  8035a7:	90                   	nop
  8035a8:	41 0f b6 04 24       	movzbl (%r12),%eax
  8035ad:	0f be d8             	movsbl %al,%ebx
  8035b0:	85 db                	test   %ebx,%ebx
  8035b2:	0f 95 c0             	setne  %al
  8035b5:	49 83 c4 01          	add    $0x1,%r12
  8035b9:	84 c0                	test   %al,%al
  8035bb:	74 28                	je     8035e5 <vprintfmt+0x379>
  8035bd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8035c1:	78 ab                	js     80356e <vprintfmt+0x302>
  8035c3:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8035c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8035cb:	79 a1                	jns    80356e <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8035cd:	eb 16                	jmp    8035e5 <vprintfmt+0x379>
				putch(' ', putdat);
  8035cf:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8035d3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8035d7:	48 89 c6             	mov    %rax,%rsi
  8035da:	bf 20 00 00 00       	mov    $0x20,%edi
  8035df:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8035e1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8035e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8035e9:	7f e4                	jg     8035cf <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  8035eb:	e9 90 01 00 00       	jmpq   803780 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8035f0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8035f4:	be 03 00 00 00       	mov    $0x3,%esi
  8035f9:	48 89 c7             	mov    %rax,%rdi
  8035fc:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  803603:	00 00 00 
  803606:	ff d0                	callq  *%rax
  803608:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80360c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803610:	48 85 c0             	test   %rax,%rax
  803613:	79 1d                	jns    803632 <vprintfmt+0x3c6>
				putch('-', putdat);
  803615:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803619:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80361d:	48 89 c6             	mov    %rax,%rsi
  803620:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803625:	ff d2                	callq  *%rdx
				num = -(long long) num;
  803627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80362b:	48 f7 d8             	neg    %rax
  80362e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803632:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803639:	e9 d5 00 00 00       	jmpq   803713 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80363e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803642:	be 03 00 00 00       	mov    $0x3,%esi
  803647:	48 89 c7             	mov    %rax,%rdi
  80364a:	48 b8 4c 30 80 00 00 	movabs $0x80304c,%rax
  803651:	00 00 00 
  803654:	ff d0                	callq  *%rax
  803656:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80365a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803661:	e9 ad 00 00 00       	jmpq   803713 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  803666:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80366a:	be 03 00 00 00       	mov    $0x3,%esi
  80366f:	48 89 c7             	mov    %rax,%rdi
  803672:	48 b8 4c 30 80 00 00 	movabs $0x80304c,%rax
  803679:	00 00 00 
  80367c:	ff d0                	callq  *%rax
  80367e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  803682:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  803689:	e9 85 00 00 00       	jmpq   803713 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  80368e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803692:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803696:	48 89 c6             	mov    %rax,%rsi
  803699:	bf 30 00 00 00       	mov    $0x30,%edi
  80369e:	ff d2                	callq  *%rdx
			putch('x', putdat);
  8036a0:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8036a4:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8036a8:	48 89 c6             	mov    %rax,%rsi
  8036ab:	bf 78 00 00 00       	mov    $0x78,%edi
  8036b0:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8036b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8036b5:	83 f8 30             	cmp    $0x30,%eax
  8036b8:	73 17                	jae    8036d1 <vprintfmt+0x465>
  8036ba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8036be:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8036c1:	89 c0                	mov    %eax,%eax
  8036c3:	48 01 d0             	add    %rdx,%rax
  8036c6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8036c9:	83 c2 08             	add    $0x8,%edx
  8036cc:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8036cf:	eb 0f                	jmp    8036e0 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  8036d1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8036d5:	48 89 d0             	mov    %rdx,%rax
  8036d8:	48 83 c2 08          	add    $0x8,%rdx
  8036dc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8036e0:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8036e3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8036e7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8036ee:	eb 23                	jmp    803713 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8036f0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8036f4:	be 03 00 00 00       	mov    $0x3,%esi
  8036f9:	48 89 c7             	mov    %rax,%rdi
  8036fc:	48 b8 4c 30 80 00 00 	movabs $0x80304c,%rax
  803703:	00 00 00 
  803706:	ff d0                	callq  *%rax
  803708:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80370c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803713:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803718:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80371b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80371e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803722:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803726:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80372a:	45 89 c1             	mov    %r8d,%r9d
  80372d:	41 89 f8             	mov    %edi,%r8d
  803730:	48 89 c7             	mov    %rax,%rdi
  803733:	48 b8 94 2f 80 00 00 	movabs $0x802f94,%rax
  80373a:	00 00 00 
  80373d:	ff d0                	callq  *%rax
			break;
  80373f:	eb 3f                	jmp    803780 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  803741:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803745:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803749:	48 89 c6             	mov    %rax,%rsi
  80374c:	89 df                	mov    %ebx,%edi
  80374e:	ff d2                	callq  *%rdx
			break;
  803750:	eb 2e                	jmp    803780 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803752:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803756:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80375a:	48 89 c6             	mov    %rax,%rsi
  80375d:	bf 25 00 00 00       	mov    $0x25,%edi
  803762:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  803764:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803769:	eb 05                	jmp    803770 <vprintfmt+0x504>
  80376b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803770:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803774:	48 83 e8 01          	sub    $0x1,%rax
  803778:	0f b6 00             	movzbl (%rax),%eax
  80377b:	3c 25                	cmp    $0x25,%al
  80377d:	75 ec                	jne    80376b <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  80377f:	90                   	nop
		}
	}
  803780:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803781:	e9 38 fb ff ff       	jmpq   8032be <vprintfmt+0x52>
			if (ch == '\0')
				return;
  803786:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  803787:	48 83 c4 60          	add    $0x60,%rsp
  80378b:	5b                   	pop    %rbx
  80378c:	41 5c                	pop    %r12
  80378e:	5d                   	pop    %rbp
  80378f:	c3                   	retq   

0000000000803790 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803790:	55                   	push   %rbp
  803791:	48 89 e5             	mov    %rsp,%rbp
  803794:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80379b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8037a2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8037a9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8037b0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8037b7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8037be:	84 c0                	test   %al,%al
  8037c0:	74 20                	je     8037e2 <printfmt+0x52>
  8037c2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8037c6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8037ca:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8037ce:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8037d2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8037d6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8037da:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8037de:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8037e2:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8037e9:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8037f0:	00 00 00 
  8037f3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8037fa:	00 00 00 
  8037fd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803801:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803808:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80380f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803816:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80381d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803824:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80382b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803832:	48 89 c7             	mov    %rax,%rdi
  803835:	48 b8 6c 32 80 00 00 	movabs $0x80326c,%rax
  80383c:	00 00 00 
  80383f:	ff d0                	callq  *%rax
	va_end(ap);
}
  803841:	c9                   	leaveq 
  803842:	c3                   	retq   

0000000000803843 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803843:	55                   	push   %rbp
  803844:	48 89 e5             	mov    %rsp,%rbp
  803847:	48 83 ec 10          	sub    $0x10,%rsp
  80384b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80384e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803852:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803856:	8b 40 10             	mov    0x10(%rax),%eax
  803859:	8d 50 01             	lea    0x1(%rax),%edx
  80385c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803860:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803863:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803867:	48 8b 10             	mov    (%rax),%rdx
  80386a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80386e:	48 8b 40 08          	mov    0x8(%rax),%rax
  803872:	48 39 c2             	cmp    %rax,%rdx
  803875:	73 17                	jae    80388e <sprintputch+0x4b>
		*b->buf++ = ch;
  803877:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387b:	48 8b 00             	mov    (%rax),%rax
  80387e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803881:	88 10                	mov    %dl,(%rax)
  803883:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803887:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80388b:	48 89 10             	mov    %rdx,(%rax)
}
  80388e:	c9                   	leaveq 
  80388f:	c3                   	retq   

0000000000803890 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803890:	55                   	push   %rbp
  803891:	48 89 e5             	mov    %rsp,%rbp
  803894:	48 83 ec 50          	sub    $0x50,%rsp
  803898:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80389c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80389f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8038a3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8038a7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8038ab:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8038af:	48 8b 0a             	mov    (%rdx),%rcx
  8038b2:	48 89 08             	mov    %rcx,(%rax)
  8038b5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8038b9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8038bd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8038c1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8038c5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038c9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8038cd:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8038d0:	48 98                	cltq   
  8038d2:	48 83 e8 01          	sub    $0x1,%rax
  8038d6:	48 03 45 c8          	add    -0x38(%rbp),%rax
  8038da:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8038de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8038e5:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8038ea:	74 06                	je     8038f2 <vsnprintf+0x62>
  8038ec:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8038f0:	7f 07                	jg     8038f9 <vsnprintf+0x69>
		return -E_INVAL;
  8038f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8038f7:	eb 2f                	jmp    803928 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8038f9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8038fd:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803901:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803905:	48 89 c6             	mov    %rax,%rsi
  803908:	48 bf 43 38 80 00 00 	movabs $0x803843,%rdi
  80390f:	00 00 00 
  803912:	48 b8 6c 32 80 00 00 	movabs $0x80326c,%rax
  803919:	00 00 00 
  80391c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80391e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803922:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803925:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803928:	c9                   	leaveq 
  803929:	c3                   	retq   

000000000080392a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80392a:	55                   	push   %rbp
  80392b:	48 89 e5             	mov    %rsp,%rbp
  80392e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803935:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80393c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803942:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803949:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803950:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803957:	84 c0                	test   %al,%al
  803959:	74 20                	je     80397b <snprintf+0x51>
  80395b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80395f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803963:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803967:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80396b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80396f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803973:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803977:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80397b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803982:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803989:	00 00 00 
  80398c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803993:	00 00 00 
  803996:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80399a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8039a1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8039a8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8039af:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8039b6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8039bd:	48 8b 0a             	mov    (%rdx),%rcx
  8039c0:	48 89 08             	mov    %rcx,(%rax)
  8039c3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8039c7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8039cb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8039cf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8039d3:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8039da:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8039e1:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8039e7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8039ee:	48 89 c7             	mov    %rax,%rdi
  8039f1:	48 b8 90 38 80 00 00 	movabs $0x803890,%rax
  8039f8:	00 00 00 
  8039fb:	ff d0                	callq  *%rax
  8039fd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803a03:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803a09:	c9                   	leaveq 
  803a0a:	c3                   	retq   
	...

0000000000803a0c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803a0c:	55                   	push   %rbp
  803a0d:	48 89 e5             	mov    %rsp,%rbp
  803a10:	48 83 ec 30          	sub    $0x30,%rsp
  803a14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a18:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a1c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  803a20:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a25:	74 18                	je     803a3f <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  803a27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a2b:	48 89 c7             	mov    %rax,%rdi
  803a2e:	48 b8 d9 0d 80 00 00 	movabs $0x800dd9,%rax
  803a35:	00 00 00 
  803a38:	ff d0                	callq  *%rax
  803a3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a3d:	eb 19                	jmp    803a58 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  803a3f:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803a46:	00 00 00 
  803a49:	48 b8 d9 0d 80 00 00 	movabs $0x800dd9,%rax
  803a50:	00 00 00 
  803a53:	ff d0                	callq  *%rax
  803a55:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  803a58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a5c:	79 19                	jns    803a77 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  803a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a62:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  803a68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a6c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  803a72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a75:	eb 53                	jmp    803aca <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  803a77:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a7c:	74 19                	je     803a97 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  803a7e:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803a85:	00 00 00 
  803a88:	48 8b 00             	mov    (%rax),%rax
  803a8b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803a91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a95:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  803a97:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a9c:	74 19                	je     803ab7 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  803a9e:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803aa5:	00 00 00 
  803aa8:	48 8b 00             	mov    (%rax),%rax
  803aab:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ab1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ab5:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803ab7:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803abe:	00 00 00 
  803ac1:	48 8b 00             	mov    (%rax),%rax
  803ac4:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803aca:	c9                   	leaveq 
  803acb:	c3                   	retq   

0000000000803acc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803acc:	55                   	push   %rbp
  803acd:	48 89 e5             	mov    %rsp,%rbp
  803ad0:	48 83 ec 30          	sub    $0x30,%rsp
  803ad4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ad7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ada:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803ade:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803ae1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803ae8:	e9 96 00 00 00       	jmpq   803b83 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803aed:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803af2:	74 20                	je     803b14 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803af4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803af7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803afa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803afe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b01:	89 c7                	mov    %eax,%edi
  803b03:	48 b8 84 0d 80 00 00 	movabs $0x800d84,%rax
  803b0a:	00 00 00 
  803b0d:	ff d0                	callq  *%rax
  803b0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b12:	eb 2d                	jmp    803b41 <ipc_send+0x75>
		else if(pg==NULL)
  803b14:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b19:	75 26                	jne    803b41 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803b1b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803b1e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b21:	b9 00 00 00 00       	mov    $0x0,%ecx
  803b26:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803b2d:	00 00 00 
  803b30:	89 c7                	mov    %eax,%edi
  803b32:	48 b8 84 0d 80 00 00 	movabs $0x800d84,%rax
  803b39:	00 00 00 
  803b3c:	ff d0                	callq  *%rax
  803b3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803b41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b45:	79 30                	jns    803b77 <ipc_send+0xab>
  803b47:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b4b:	74 2a                	je     803b77 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803b4d:	48 ba a0 42 80 00 00 	movabs $0x8042a0,%rdx
  803b54:	00 00 00 
  803b57:	be 40 00 00 00       	mov    $0x40,%esi
  803b5c:	48 bf b8 42 80 00 00 	movabs $0x8042b8,%rdi
  803b63:	00 00 00 
  803b66:	b8 00 00 00 00       	mov    $0x0,%eax
  803b6b:	48 b9 80 2c 80 00 00 	movabs $0x802c80,%rcx
  803b72:	00 00 00 
  803b75:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803b77:	48 b8 72 0b 80 00 00 	movabs $0x800b72,%rax
  803b7e:	00 00 00 
  803b81:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  803b83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b87:	0f 85 60 ff ff ff    	jne    803aed <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  803b8d:	c9                   	leaveq 
  803b8e:	c3                   	retq   

0000000000803b8f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b8f:	55                   	push   %rbp
  803b90:	48 89 e5             	mov    %rsp,%rbp
  803b93:	48 83 ec 18          	sub    $0x18,%rsp
  803b97:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803b9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ba1:	eb 5e                	jmp    803c01 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803ba3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803baa:	00 00 00 
  803bad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bb0:	48 63 d0             	movslq %eax,%rdx
  803bb3:	48 89 d0             	mov    %rdx,%rax
  803bb6:	48 c1 e0 03          	shl    $0x3,%rax
  803bba:	48 01 d0             	add    %rdx,%rax
  803bbd:	48 c1 e0 05          	shl    $0x5,%rax
  803bc1:	48 01 c8             	add    %rcx,%rax
  803bc4:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803bca:	8b 00                	mov    (%rax),%eax
  803bcc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803bcf:	75 2c                	jne    803bfd <ipc_find_env+0x6e>
			return envs[i].env_id;
  803bd1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803bd8:	00 00 00 
  803bdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bde:	48 63 d0             	movslq %eax,%rdx
  803be1:	48 89 d0             	mov    %rdx,%rax
  803be4:	48 c1 e0 03          	shl    $0x3,%rax
  803be8:	48 01 d0             	add    %rdx,%rax
  803beb:	48 c1 e0 05          	shl    $0x5,%rax
  803bef:	48 01 c8             	add    %rcx,%rax
  803bf2:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803bf8:	8b 40 08             	mov    0x8(%rax),%eax
  803bfb:	eb 12                	jmp    803c0f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803bfd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c01:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803c08:	7e 99                	jle    803ba3 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c0f:	c9                   	leaveq 
  803c10:	c3                   	retq   
  803c11:	00 00                	add    %al,(%rax)
	...

0000000000803c14 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c14:	55                   	push   %rbp
  803c15:	48 89 e5             	mov    %rsp,%rbp
  803c18:	48 83 ec 18          	sub    $0x18,%rsp
  803c1c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803c20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c24:	48 89 c2             	mov    %rax,%rdx
  803c27:	48 c1 ea 15          	shr    $0x15,%rdx
  803c2b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c32:	01 00 00 
  803c35:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c39:	83 e0 01             	and    $0x1,%eax
  803c3c:	48 85 c0             	test   %rax,%rax
  803c3f:	75 07                	jne    803c48 <pageref+0x34>
		return 0;
  803c41:	b8 00 00 00 00       	mov    $0x0,%eax
  803c46:	eb 53                	jmp    803c9b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c4c:	48 89 c2             	mov    %rax,%rdx
  803c4f:	48 c1 ea 0c          	shr    $0xc,%rdx
  803c53:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c5a:	01 00 00 
  803c5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c61:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c69:	83 e0 01             	and    $0x1,%eax
  803c6c:	48 85 c0             	test   %rax,%rax
  803c6f:	75 07                	jne    803c78 <pageref+0x64>
		return 0;
  803c71:	b8 00 00 00 00       	mov    $0x0,%eax
  803c76:	eb 23                	jmp    803c9b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c7c:	48 89 c2             	mov    %rax,%rdx
  803c7f:	48 c1 ea 0c          	shr    $0xc,%rdx
  803c83:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c8a:	00 00 00 
  803c8d:	48 c1 e2 04          	shl    $0x4,%rdx
  803c91:	48 01 d0             	add    %rdx,%rax
  803c94:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c98:	0f b7 c0             	movzwl %ax,%eax
}
  803c9b:	c9                   	leaveq 
  803c9c:	c3                   	retq   
