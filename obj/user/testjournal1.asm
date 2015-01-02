
obj/user/testjournal1.debug:     file format elf64-x86-64


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
  80003c:	e8 ab 00 00 00       	callq  8000ec <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800050:	89 75 e4             	mov    %esi,-0x1c(%rbp)
        extern union Fsipc fsipcbuf;
        envid_t fsenv;

        strcpy(fsipcbuf.open.req_path, path);
  800053:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800057:	48 89 c6             	mov    %rax,%rsi
  80005a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  800061:	00 00 00 
  800064:	48 b8 20 02 80 00 00 	movabs $0x800220,%rax
  80006b:	00 00 00 
  80006e:	ff d0                	callq  *%rax
        fsipcbuf.open.req_omode = mode;
  800070:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800077:	00 00 00 
  80007a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80007d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

        fsenv = ipc_find_env(ENV_TYPE_FS);
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
  800088:	48 b8 1b 10 80 00 00 	movabs $0x80101b,%rax
  80008f:	00 00 00 
  800092:	ff d0                	callq  *%rax
  800094:	89 45 fc             	mov    %eax,-0x4(%rbp)
        ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800097:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80009a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80009f:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8000a6:	00 00 00 
  8000a9:	be 01 00 00 00       	mov    $0x1,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 58 0f 80 00 00 	movabs $0x800f58,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
        return ipc_recv(NULL, FVA, NULL);
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8000cb:	48 b8 98 0e 80 00 00 	movabs $0x800e98,%rax
  8000d2:	00 00 00 
  8000d5:	ff d0                	callq  *%rax
}
  8000d7:	c9                   	leaveq 
  8000d8:	c3                   	retq   

00000000008000d9 <umain>:

void
umain(int argc, char **argv)
{
  8000d9:	55                   	push   %rbp
  8000da:	48 89 e5             	mov    %rsp,%rbp
  8000dd:	48 83 ec 10          	sub    $0x10,%rsp
  8000e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)

}
  8000e8:	c9                   	leaveq 
  8000e9:	c3                   	retq   
	...

00000000008000ec <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ec:	55                   	push   %rbp
  8000ed:	48 89 e5             	mov    %rsp,%rbp
  8000f0:	48 83 ec 10          	sub    $0x10,%rsp
  8000f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000fb:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800102:	00 00 00 
  800105:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  80010c:	48 b8 dc 0a 80 00 00 	movabs $0x800adc,%rax
  800113:	00 00 00 
  800116:	ff d0                	callq  *%rax
  800118:	48 98                	cltq   
  80011a:	48 89 c2             	mov    %rax,%rdx
  80011d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800123:	48 89 d0             	mov    %rdx,%rax
  800126:	48 c1 e0 03          	shl    $0x3,%rax
  80012a:	48 01 d0             	add    %rdx,%rax
  80012d:	48 c1 e0 05          	shl    $0x5,%rax
  800131:	48 89 c2             	mov    %rax,%rdx
  800134:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80013b:	00 00 00 
  80013e:	48 01 c2             	add    %rax,%rdx
  800141:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800148:	00 00 00 
  80014b:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800152:	7e 14                	jle    800168 <libmain+0x7c>
		binaryname = argv[0];
  800154:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800158:	48 8b 10             	mov    (%rax),%rdx
  80015b:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800162:	00 00 00 
  800165:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800168:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80016c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80016f:	48 89 d6             	mov    %rdx,%rsi
  800172:	89 c7                	mov    %eax,%edi
  800174:	48 b8 d9 00 80 00 00 	movabs $0x8000d9,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800180:	48 b8 90 01 80 00 00 	movabs $0x800190,%rax
  800187:	00 00 00 
  80018a:	ff d0                	callq  *%rax
}
  80018c:	c9                   	leaveq 
  80018d:	c3                   	retq   
	...

0000000000800190 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800190:	55                   	push   %rbp
  800191:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800194:	48 b8 e1 13 80 00 00 	movabs $0x8013e1,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8001a5:	48 b8 98 0a 80 00 00 	movabs $0x800a98,%rax
  8001ac:	00 00 00 
  8001af:	ff d0                	callq  *%rax
}
  8001b1:	5d                   	pop    %rbp
  8001b2:	c3                   	retq   
	...

00000000008001b4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8001b4:	55                   	push   %rbp
  8001b5:	48 89 e5             	mov    %rsp,%rbp
  8001b8:	48 83 ec 18          	sub    $0x18,%rsp
  8001bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8001c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001c7:	eb 09                	jmp    8001d2 <strlen+0x1e>
		n++;
  8001c9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8001cd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8001d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001d6:	0f b6 00             	movzbl (%rax),%eax
  8001d9:	84 c0                	test   %al,%al
  8001db:	75 ec                	jne    8001c9 <strlen+0x15>
		n++;
	return n;
  8001dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8001e0:	c9                   	leaveq 
  8001e1:	c3                   	retq   

00000000008001e2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8001e2:	55                   	push   %rbp
  8001e3:	48 89 e5             	mov    %rsp,%rbp
  8001e6:	48 83 ec 20          	sub    $0x20,%rsp
  8001ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8001ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8001f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8001f9:	eb 0e                	jmp    800209 <strnlen+0x27>
		n++;
  8001fb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8001ff:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800204:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800209:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80020e:	74 0b                	je     80021b <strnlen+0x39>
  800210:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800214:	0f b6 00             	movzbl (%rax),%eax
  800217:	84 c0                	test   %al,%al
  800219:	75 e0                	jne    8001fb <strnlen+0x19>
		n++;
	return n;
  80021b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80021e:	c9                   	leaveq 
  80021f:	c3                   	retq   

0000000000800220 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800220:	55                   	push   %rbp
  800221:	48 89 e5             	mov    %rsp,%rbp
  800224:	48 83 ec 20          	sub    $0x20,%rsp
  800228:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80022c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800234:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800238:	90                   	nop
  800239:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80023d:	0f b6 10             	movzbl (%rax),%edx
  800240:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800244:	88 10                	mov    %dl,(%rax)
  800246:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80024a:	0f b6 00             	movzbl (%rax),%eax
  80024d:	84 c0                	test   %al,%al
  80024f:	0f 95 c0             	setne  %al
  800252:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800257:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80025c:	84 c0                	test   %al,%al
  80025e:	75 d9                	jne    800239 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800264:	c9                   	leaveq 
  800265:	c3                   	retq   

0000000000800266 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800266:	55                   	push   %rbp
  800267:	48 89 e5             	mov    %rsp,%rbp
  80026a:	48 83 ec 20          	sub    $0x20,%rsp
  80026e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800272:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800276:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80027a:	48 89 c7             	mov    %rax,%rdi
  80027d:	48 b8 b4 01 80 00 00 	movabs $0x8001b4,%rax
  800284:	00 00 00 
  800287:	ff d0                	callq  *%rax
  800289:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80028c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80028f:	48 98                	cltq   
  800291:	48 03 45 e8          	add    -0x18(%rbp),%rax
  800295:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800299:	48 89 d6             	mov    %rdx,%rsi
  80029c:	48 89 c7             	mov    %rax,%rdi
  80029f:	48 b8 20 02 80 00 00 	movabs $0x800220,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
	return dst;
  8002ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8002af:	c9                   	leaveq 
  8002b0:	c3                   	retq   

00000000008002b1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8002b1:	55                   	push   %rbp
  8002b2:	48 89 e5             	mov    %rsp,%rbp
  8002b5:	48 83 ec 28          	sub    $0x28,%rsp
  8002b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8002bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8002c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8002c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8002cd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8002d4:	00 
  8002d5:	eb 27                	jmp    8002fe <strncpy+0x4d>
		*dst++ = *src;
  8002d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002db:	0f b6 10             	movzbl (%rax),%edx
  8002de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002e2:	88 10                	mov    %dl,(%rax)
  8002e4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8002e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002ed:	0f b6 00             	movzbl (%rax),%eax
  8002f0:	84 c0                	test   %al,%al
  8002f2:	74 05                	je     8002f9 <strncpy+0x48>
			src++;
  8002f4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8002f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8002fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800302:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800306:	72 cf                	jb     8002d7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800308:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80030c:	c9                   	leaveq 
  80030d:	c3                   	retq   

000000000080030e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80030e:	55                   	push   %rbp
  80030f:	48 89 e5             	mov    %rsp,%rbp
  800312:	48 83 ec 28          	sub    $0x28,%rsp
  800316:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80031a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80031e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800326:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80032a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80032f:	74 37                	je     800368 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  800331:	eb 17                	jmp    80034a <strlcpy+0x3c>
			*dst++ = *src++;
  800333:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800337:	0f b6 10             	movzbl (%rax),%edx
  80033a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80033e:	88 10                	mov    %dl,(%rax)
  800340:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800345:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80034a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80034f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800354:	74 0b                	je     800361 <strlcpy+0x53>
  800356:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80035a:	0f b6 00             	movzbl (%rax),%eax
  80035d:	84 c0                	test   %al,%al
  80035f:	75 d2                	jne    800333 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800361:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800365:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800368:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80036c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800370:	48 89 d1             	mov    %rdx,%rcx
  800373:	48 29 c1             	sub    %rax,%rcx
  800376:	48 89 c8             	mov    %rcx,%rax
}
  800379:	c9                   	leaveq 
  80037a:	c3                   	retq   

000000000080037b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80037b:	55                   	push   %rbp
  80037c:	48 89 e5             	mov    %rsp,%rbp
  80037f:	48 83 ec 10          	sub    $0x10,%rsp
  800383:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800387:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80038b:	eb 0a                	jmp    800397 <strcmp+0x1c>
		p++, q++;
  80038d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800392:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800397:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80039b:	0f b6 00             	movzbl (%rax),%eax
  80039e:	84 c0                	test   %al,%al
  8003a0:	74 12                	je     8003b4 <strcmp+0x39>
  8003a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003a6:	0f b6 10             	movzbl (%rax),%edx
  8003a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ad:	0f b6 00             	movzbl (%rax),%eax
  8003b0:	38 c2                	cmp    %al,%dl
  8003b2:	74 d9                	je     80038d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8003b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003b8:	0f b6 00             	movzbl (%rax),%eax
  8003bb:	0f b6 d0             	movzbl %al,%edx
  8003be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c2:	0f b6 00             	movzbl (%rax),%eax
  8003c5:	0f b6 c0             	movzbl %al,%eax
  8003c8:	89 d1                	mov    %edx,%ecx
  8003ca:	29 c1                	sub    %eax,%ecx
  8003cc:	89 c8                	mov    %ecx,%eax
}
  8003ce:	c9                   	leaveq 
  8003cf:	c3                   	retq   

00000000008003d0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8003d0:	55                   	push   %rbp
  8003d1:	48 89 e5             	mov    %rsp,%rbp
  8003d4:	48 83 ec 18          	sub    $0x18,%rsp
  8003d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8003e0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8003e4:	eb 0f                	jmp    8003f5 <strncmp+0x25>
		n--, p++, q++;
  8003e6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8003eb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8003f0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8003f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8003fa:	74 1d                	je     800419 <strncmp+0x49>
  8003fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800400:	0f b6 00             	movzbl (%rax),%eax
  800403:	84 c0                	test   %al,%al
  800405:	74 12                	je     800419 <strncmp+0x49>
  800407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80040b:	0f b6 10             	movzbl (%rax),%edx
  80040e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800412:	0f b6 00             	movzbl (%rax),%eax
  800415:	38 c2                	cmp    %al,%dl
  800417:	74 cd                	je     8003e6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800419:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80041e:	75 07                	jne    800427 <strncmp+0x57>
		return 0;
  800420:	b8 00 00 00 00       	mov    $0x0,%eax
  800425:	eb 1a                	jmp    800441 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800427:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80042b:	0f b6 00             	movzbl (%rax),%eax
  80042e:	0f b6 d0             	movzbl %al,%edx
  800431:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800435:	0f b6 00             	movzbl (%rax),%eax
  800438:	0f b6 c0             	movzbl %al,%eax
  80043b:	89 d1                	mov    %edx,%ecx
  80043d:	29 c1                	sub    %eax,%ecx
  80043f:	89 c8                	mov    %ecx,%eax
}
  800441:	c9                   	leaveq 
  800442:	c3                   	retq   

0000000000800443 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800443:	55                   	push   %rbp
  800444:	48 89 e5             	mov    %rsp,%rbp
  800447:	48 83 ec 10          	sub    $0x10,%rsp
  80044b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80044f:	89 f0                	mov    %esi,%eax
  800451:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  800454:	eb 17                	jmp    80046d <strchr+0x2a>
		if (*s == c)
  800456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80045a:	0f b6 00             	movzbl (%rax),%eax
  80045d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  800460:	75 06                	jne    800468 <strchr+0x25>
			return (char *) s;
  800462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800466:	eb 15                	jmp    80047d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800468:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80046d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800471:	0f b6 00             	movzbl (%rax),%eax
  800474:	84 c0                	test   %al,%al
  800476:	75 de                	jne    800456 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  800478:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80047d:	c9                   	leaveq 
  80047e:	c3                   	retq   

000000000080047f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80047f:	55                   	push   %rbp
  800480:	48 89 e5             	mov    %rsp,%rbp
  800483:	48 83 ec 10          	sub    $0x10,%rsp
  800487:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80048b:	89 f0                	mov    %esi,%eax
  80048d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  800490:	eb 11                	jmp    8004a3 <strfind+0x24>
		if (*s == c)
  800492:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800496:	0f b6 00             	movzbl (%rax),%eax
  800499:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80049c:	74 12                	je     8004b0 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80049e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004a7:	0f b6 00             	movzbl (%rax),%eax
  8004aa:	84 c0                	test   %al,%al
  8004ac:	75 e4                	jne    800492 <strfind+0x13>
  8004ae:	eb 01                	jmp    8004b1 <strfind+0x32>
		if (*s == c)
			break;
  8004b0:	90                   	nop
	return (char *) s;
  8004b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004b5:	c9                   	leaveq 
  8004b6:	c3                   	retq   

00000000008004b7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8004b7:	55                   	push   %rbp
  8004b8:	48 89 e5             	mov    %rsp,%rbp
  8004bb:	48 83 ec 18          	sub    $0x18,%rsp
  8004bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004c3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8004c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8004ca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8004cf:	75 06                	jne    8004d7 <memset+0x20>
		return v;
  8004d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004d5:	eb 69                	jmp    800540 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8004d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004db:	83 e0 03             	and    $0x3,%eax
  8004de:	48 85 c0             	test   %rax,%rax
  8004e1:	75 48                	jne    80052b <memset+0x74>
  8004e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e7:	83 e0 03             	and    $0x3,%eax
  8004ea:	48 85 c0             	test   %rax,%rax
  8004ed:	75 3c                	jne    80052b <memset+0x74>
		c &= 0xFF;
  8004ef:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8004f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004f9:	89 c2                	mov    %eax,%edx
  8004fb:	c1 e2 18             	shl    $0x18,%edx
  8004fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800501:	c1 e0 10             	shl    $0x10,%eax
  800504:	09 c2                	or     %eax,%edx
  800506:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800509:	c1 e0 08             	shl    $0x8,%eax
  80050c:	09 d0                	or     %edx,%eax
  80050e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800515:	48 89 c1             	mov    %rax,%rcx
  800518:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80051c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800520:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800523:	48 89 d7             	mov    %rdx,%rdi
  800526:	fc                   	cld    
  800527:	f3 ab                	rep stos %eax,%es:(%rdi)
  800529:	eb 11                	jmp    80053c <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80052b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80052f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800532:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800536:	48 89 d7             	mov    %rdx,%rdi
  800539:	fc                   	cld    
  80053a:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80053c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800540:	c9                   	leaveq 
  800541:	c3                   	retq   

0000000000800542 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800542:	55                   	push   %rbp
  800543:	48 89 e5             	mov    %rsp,%rbp
  800546:	48 83 ec 28          	sub    $0x28,%rsp
  80054a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80054e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800552:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  800556:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80055a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80055e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800562:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  800566:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80056a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80056e:	0f 83 88 00 00 00    	jae    8005fc <memmove+0xba>
  800574:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800578:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80057c:	48 01 d0             	add    %rdx,%rax
  80057f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  800583:	76 77                	jbe    8005fc <memmove+0xba>
		s += n;
  800585:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800589:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80058d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800591:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  800595:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800599:	83 e0 03             	and    $0x3,%eax
  80059c:	48 85 c0             	test   %rax,%rax
  80059f:	75 3b                	jne    8005dc <memmove+0x9a>
  8005a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a5:	83 e0 03             	and    $0x3,%eax
  8005a8:	48 85 c0             	test   %rax,%rax
  8005ab:	75 2f                	jne    8005dc <memmove+0x9a>
  8005ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005b1:	83 e0 03             	and    $0x3,%eax
  8005b4:	48 85 c0             	test   %rax,%rax
  8005b7:	75 23                	jne    8005dc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8005b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005bd:	48 83 e8 04          	sub    $0x4,%rax
  8005c1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8005c5:	48 83 ea 04          	sub    $0x4,%rdx
  8005c9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8005cd:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8005d1:	48 89 c7             	mov    %rax,%rdi
  8005d4:	48 89 d6             	mov    %rdx,%rsi
  8005d7:	fd                   	std    
  8005d8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8005da:	eb 1d                	jmp    8005f9 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8005dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8005e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005e8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8005ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005f0:	48 89 d7             	mov    %rdx,%rdi
  8005f3:	48 89 c1             	mov    %rax,%rcx
  8005f6:	fd                   	std    
  8005f7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8005f9:	fc                   	cld    
  8005fa:	eb 57                	jmp    800653 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8005fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800600:	83 e0 03             	and    $0x3,%eax
  800603:	48 85 c0             	test   %rax,%rax
  800606:	75 36                	jne    80063e <memmove+0xfc>
  800608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80060c:	83 e0 03             	and    $0x3,%eax
  80060f:	48 85 c0             	test   %rax,%rax
  800612:	75 2a                	jne    80063e <memmove+0xfc>
  800614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800618:	83 e0 03             	and    $0x3,%eax
  80061b:	48 85 c0             	test   %rax,%rax
  80061e:	75 1e                	jne    80063e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800620:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800624:	48 89 c1             	mov    %rax,%rcx
  800627:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80062b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800633:	48 89 c7             	mov    %rax,%rdi
  800636:	48 89 d6             	mov    %rdx,%rsi
  800639:	fc                   	cld    
  80063a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80063c:	eb 15                	jmp    800653 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80063e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800642:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800646:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80064a:	48 89 c7             	mov    %rax,%rdi
  80064d:	48 89 d6             	mov    %rdx,%rsi
  800650:	fc                   	cld    
  800651:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800657:	c9                   	leaveq 
  800658:	c3                   	retq   

0000000000800659 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800659:	55                   	push   %rbp
  80065a:	48 89 e5             	mov    %rsp,%rbp
  80065d:	48 83 ec 18          	sub    $0x18,%rsp
  800661:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800665:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800669:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80066d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800671:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800675:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800679:	48 89 ce             	mov    %rcx,%rsi
  80067c:	48 89 c7             	mov    %rax,%rdi
  80067f:	48 b8 42 05 80 00 00 	movabs $0x800542,%rax
  800686:	00 00 00 
  800689:	ff d0                	callq  *%rax
}
  80068b:	c9                   	leaveq 
  80068c:	c3                   	retq   

000000000080068d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80068d:	55                   	push   %rbp
  80068e:	48 89 e5             	mov    %rsp,%rbp
  800691:	48 83 ec 28          	sub    $0x28,%rsp
  800695:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800699:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80069d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8006a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8006a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8006b1:	eb 38                	jmp    8006eb <memcmp+0x5e>
		if (*s1 != *s2)
  8006b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006b7:	0f b6 10             	movzbl (%rax),%edx
  8006ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006be:	0f b6 00             	movzbl (%rax),%eax
  8006c1:	38 c2                	cmp    %al,%dl
  8006c3:	74 1c                	je     8006e1 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8006c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006c9:	0f b6 00             	movzbl (%rax),%eax
  8006cc:	0f b6 d0             	movzbl %al,%edx
  8006cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006d3:	0f b6 00             	movzbl (%rax),%eax
  8006d6:	0f b6 c0             	movzbl %al,%eax
  8006d9:	89 d1                	mov    %edx,%ecx
  8006db:	29 c1                	sub    %eax,%ecx
  8006dd:	89 c8                	mov    %ecx,%eax
  8006df:	eb 20                	jmp    800701 <memcmp+0x74>
		s1++, s2++;
  8006e1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8006e6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8006eb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8006f0:	0f 95 c0             	setne  %al
  8006f3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8006f8:	84 c0                	test   %al,%al
  8006fa:	75 b7                	jne    8006b3 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8006fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800701:	c9                   	leaveq 
  800702:	c3                   	retq   

0000000000800703 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800703:	55                   	push   %rbp
  800704:	48 89 e5             	mov    %rsp,%rbp
  800707:	48 83 ec 28          	sub    $0x28,%rsp
  80070b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80070f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  800712:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  800716:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80071a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071e:	48 01 d0             	add    %rdx,%rax
  800721:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  800725:	eb 13                	jmp    80073a <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  800727:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072b:	0f b6 10             	movzbl (%rax),%edx
  80072e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800731:	38 c2                	cmp    %al,%dl
  800733:	74 11                	je     800746 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800735:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80073a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800742:	72 e3                	jb     800727 <memfind+0x24>
  800744:	eb 01                	jmp    800747 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800746:	90                   	nop
	return (void *) s;
  800747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80074b:	c9                   	leaveq 
  80074c:	c3                   	retq   

000000000080074d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80074d:	55                   	push   %rbp
  80074e:	48 89 e5             	mov    %rsp,%rbp
  800751:	48 83 ec 38          	sub    $0x38,%rsp
  800755:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800759:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80075d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  800760:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  800767:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80076e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80076f:	eb 05                	jmp    800776 <strtol+0x29>
		s++;
  800771:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80077a:	0f b6 00             	movzbl (%rax),%eax
  80077d:	3c 20                	cmp    $0x20,%al
  80077f:	74 f0                	je     800771 <strtol+0x24>
  800781:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800785:	0f b6 00             	movzbl (%rax),%eax
  800788:	3c 09                	cmp    $0x9,%al
  80078a:	74 e5                	je     800771 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80078c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800790:	0f b6 00             	movzbl (%rax),%eax
  800793:	3c 2b                	cmp    $0x2b,%al
  800795:	75 07                	jne    80079e <strtol+0x51>
		s++;
  800797:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80079c:	eb 17                	jmp    8007b5 <strtol+0x68>
	else if (*s == '-')
  80079e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007a2:	0f b6 00             	movzbl (%rax),%eax
  8007a5:	3c 2d                	cmp    $0x2d,%al
  8007a7:	75 0c                	jne    8007b5 <strtol+0x68>
		s++, neg = 1;
  8007a9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007ae:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8007b5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8007b9:	74 06                	je     8007c1 <strtol+0x74>
  8007bb:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8007bf:	75 28                	jne    8007e9 <strtol+0x9c>
  8007c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007c5:	0f b6 00             	movzbl (%rax),%eax
  8007c8:	3c 30                	cmp    $0x30,%al
  8007ca:	75 1d                	jne    8007e9 <strtol+0x9c>
  8007cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d0:	48 83 c0 01          	add    $0x1,%rax
  8007d4:	0f b6 00             	movzbl (%rax),%eax
  8007d7:	3c 78                	cmp    $0x78,%al
  8007d9:	75 0e                	jne    8007e9 <strtol+0x9c>
		s += 2, base = 16;
  8007db:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8007e0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8007e7:	eb 2c                	jmp    800815 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8007e9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8007ed:	75 19                	jne    800808 <strtol+0xbb>
  8007ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007f3:	0f b6 00             	movzbl (%rax),%eax
  8007f6:	3c 30                	cmp    $0x30,%al
  8007f8:	75 0e                	jne    800808 <strtol+0xbb>
		s++, base = 8;
  8007fa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007ff:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  800806:	eb 0d                	jmp    800815 <strtol+0xc8>
	else if (base == 0)
  800808:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80080c:	75 07                	jne    800815 <strtol+0xc8>
		base = 10;
  80080e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800819:	0f b6 00             	movzbl (%rax),%eax
  80081c:	3c 2f                	cmp    $0x2f,%al
  80081e:	7e 1d                	jle    80083d <strtol+0xf0>
  800820:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800824:	0f b6 00             	movzbl (%rax),%eax
  800827:	3c 39                	cmp    $0x39,%al
  800829:	7f 12                	jg     80083d <strtol+0xf0>
			dig = *s - '0';
  80082b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80082f:	0f b6 00             	movzbl (%rax),%eax
  800832:	0f be c0             	movsbl %al,%eax
  800835:	83 e8 30             	sub    $0x30,%eax
  800838:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80083b:	eb 4e                	jmp    80088b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80083d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800841:	0f b6 00             	movzbl (%rax),%eax
  800844:	3c 60                	cmp    $0x60,%al
  800846:	7e 1d                	jle    800865 <strtol+0x118>
  800848:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80084c:	0f b6 00             	movzbl (%rax),%eax
  80084f:	3c 7a                	cmp    $0x7a,%al
  800851:	7f 12                	jg     800865 <strtol+0x118>
			dig = *s - 'a' + 10;
  800853:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800857:	0f b6 00             	movzbl (%rax),%eax
  80085a:	0f be c0             	movsbl %al,%eax
  80085d:	83 e8 57             	sub    $0x57,%eax
  800860:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800863:	eb 26                	jmp    80088b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  800865:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800869:	0f b6 00             	movzbl (%rax),%eax
  80086c:	3c 40                	cmp    $0x40,%al
  80086e:	7e 47                	jle    8008b7 <strtol+0x16a>
  800870:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800874:	0f b6 00             	movzbl (%rax),%eax
  800877:	3c 5a                	cmp    $0x5a,%al
  800879:	7f 3c                	jg     8008b7 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80087b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80087f:	0f b6 00             	movzbl (%rax),%eax
  800882:	0f be c0             	movsbl %al,%eax
  800885:	83 e8 37             	sub    $0x37,%eax
  800888:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80088b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80088e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  800891:	7d 23                	jge    8008b6 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  800893:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  800898:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80089b:	48 98                	cltq   
  80089d:	48 89 c2             	mov    %rax,%rdx
  8008a0:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8008a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008a8:	48 98                	cltq   
  8008aa:	48 01 d0             	add    %rdx,%rax
  8008ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8008b1:	e9 5f ff ff ff       	jmpq   800815 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8008b6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8008b7:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8008bc:	74 0b                	je     8008c9 <strtol+0x17c>
		*endptr = (char *) s;
  8008be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8008c2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8008c6:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8008c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008cd:	74 09                	je     8008d8 <strtol+0x18b>
  8008cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008d3:	48 f7 d8             	neg    %rax
  8008d6:	eb 04                	jmp    8008dc <strtol+0x18f>
  8008d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8008dc:	c9                   	leaveq 
  8008dd:	c3                   	retq   

00000000008008de <strstr>:

char * strstr(const char *in, const char *str)
{
  8008de:	55                   	push   %rbp
  8008df:	48 89 e5             	mov    %rsp,%rbp
  8008e2:	48 83 ec 30          	sub    $0x30,%rsp
  8008e6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8008ea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8008ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8008f2:	0f b6 00             	movzbl (%rax),%eax
  8008f5:	88 45 ff             	mov    %al,-0x1(%rbp)
  8008f8:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8008fd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  800901:	75 06                	jne    800909 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  800903:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800907:	eb 68                	jmp    800971 <strstr+0x93>

    len = strlen(str);
  800909:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80090d:	48 89 c7             	mov    %rax,%rdi
  800910:	48 b8 b4 01 80 00 00 	movabs $0x8001b4,%rax
  800917:	00 00 00 
  80091a:	ff d0                	callq  *%rax
  80091c:	48 98                	cltq   
  80091e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  800922:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800926:	0f b6 00             	movzbl (%rax),%eax
  800929:	88 45 ef             	mov    %al,-0x11(%rbp)
  80092c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  800931:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  800935:	75 07                	jne    80093e <strstr+0x60>
                return (char *) 0;
  800937:	b8 00 00 00 00       	mov    $0x0,%eax
  80093c:	eb 33                	jmp    800971 <strstr+0x93>
        } while (sc != c);
  80093e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800942:	3a 45 ff             	cmp    -0x1(%rbp),%al
  800945:	75 db                	jne    800922 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  800947:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80094b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80094f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800953:	48 89 ce             	mov    %rcx,%rsi
  800956:	48 89 c7             	mov    %rax,%rdi
  800959:	48 b8 d0 03 80 00 00 	movabs $0x8003d0,%rax
  800960:	00 00 00 
  800963:	ff d0                	callq  *%rax
  800965:	85 c0                	test   %eax,%eax
  800967:	75 b9                	jne    800922 <strstr+0x44>

    return (char *) (in - 1);
  800969:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80096d:	48 83 e8 01          	sub    $0x1,%rax
}
  800971:	c9                   	leaveq 
  800972:	c3                   	retq   
	...

0000000000800974 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800974:	55                   	push   %rbp
  800975:	48 89 e5             	mov    %rsp,%rbp
  800978:	53                   	push   %rbx
  800979:	48 83 ec 58          	sub    $0x58,%rsp
  80097d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800980:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800983:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800987:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80098b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80098f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800993:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800996:	89 45 ac             	mov    %eax,-0x54(%rbp)
  800999:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80099d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8009a1:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8009a5:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8009a9:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8009ad:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8009b0:	4c 89 c3             	mov    %r8,%rbx
  8009b3:	cd 30                	int    $0x30
  8009b5:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8009b9:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8009bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8009c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009c5:	74 3e                	je     800a05 <syscall+0x91>
  8009c7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8009cc:	7e 37                	jle    800a05 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8009ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8009d5:	49 89 d0             	mov    %rdx,%r8
  8009d8:	89 c1                	mov    %eax,%ecx
  8009da:	48 ba 19 40 80 00 00 	movabs $0x804019,%rdx
  8009e1:	00 00 00 
  8009e4:	be 23 00 00 00       	mov    $0x23,%esi
  8009e9:	48 bf 36 40 80 00 00 	movabs $0x804036,%rdi
  8009f0:	00 00 00 
  8009f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f8:	49 b9 30 2e 80 00 00 	movabs $0x802e30,%r9
  8009ff:	00 00 00 
  800a02:	41 ff d1             	callq  *%r9

	return ret;
  800a05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800a09:	48 83 c4 58          	add    $0x58,%rsp
  800a0d:	5b                   	pop    %rbx
  800a0e:	5d                   	pop    %rbp
  800a0f:	c3                   	retq   

0000000000800a10 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a10:	55                   	push   %rbp
  800a11:	48 89 e5             	mov    %rsp,%rbp
  800a14:	48 83 ec 20          	sub    $0x20,%rsp
  800a18:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800a20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a28:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800a2f:	00 
  800a30:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800a36:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800a3c:	48 89 d1             	mov    %rdx,%rcx
  800a3f:	48 89 c2             	mov    %rax,%rdx
  800a42:	be 00 00 00 00       	mov    $0x0,%esi
  800a47:	bf 00 00 00 00       	mov    $0x0,%edi
  800a4c:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800a53:	00 00 00 
  800a56:	ff d0                	callq  *%rax
}
  800a58:	c9                   	leaveq 
  800a59:	c3                   	retq   

0000000000800a5a <sys_cgetc>:

int
sys_cgetc(void)
{
  800a5a:	55                   	push   %rbp
  800a5b:	48 89 e5             	mov    %rsp,%rbp
  800a5e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800a62:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800a69:	00 
  800a6a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800a70:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800a76:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a80:	be 00 00 00 00       	mov    $0x0,%esi
  800a85:	bf 01 00 00 00       	mov    $0x1,%edi
  800a8a:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800a91:	00 00 00 
  800a94:	ff d0                	callq  *%rax
}
  800a96:	c9                   	leaveq 
  800a97:	c3                   	retq   

0000000000800a98 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800a98:	55                   	push   %rbp
  800a99:	48 89 e5             	mov    %rsp,%rbp
  800a9c:	48 83 ec 20          	sub    $0x20,%rsp
  800aa0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800aa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800aa6:	48 98                	cltq   
  800aa8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800aaf:	00 
  800ab0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ab6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800abc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ac1:	48 89 c2             	mov    %rax,%rdx
  800ac4:	be 01 00 00 00       	mov    $0x1,%esi
  800ac9:	bf 03 00 00 00       	mov    $0x3,%edi
  800ace:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800ad5:	00 00 00 
  800ad8:	ff d0                	callq  *%rax
}
  800ada:	c9                   	leaveq 
  800adb:	c3                   	retq   

0000000000800adc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800adc:	55                   	push   %rbp
  800add:	48 89 e5             	mov    %rsp,%rbp
  800ae0:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800ae4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800aeb:	00 
  800aec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800af2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800af8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800afd:	ba 00 00 00 00       	mov    $0x0,%edx
  800b02:	be 00 00 00 00       	mov    $0x0,%esi
  800b07:	bf 02 00 00 00       	mov    $0x2,%edi
  800b0c:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800b13:	00 00 00 
  800b16:	ff d0                	callq  *%rax
}
  800b18:	c9                   	leaveq 
  800b19:	c3                   	retq   

0000000000800b1a <sys_yield>:

void
sys_yield(void)
{
  800b1a:	55                   	push   %rbp
  800b1b:	48 89 e5             	mov    %rsp,%rbp
  800b1e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b29:	00 
  800b2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b36:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b40:	be 00 00 00 00       	mov    $0x0,%esi
  800b45:	bf 0b 00 00 00       	mov    $0xb,%edi
  800b4a:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800b51:	00 00 00 
  800b54:	ff d0                	callq  *%rax
}
  800b56:	c9                   	leaveq 
  800b57:	c3                   	retq   

0000000000800b58 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b58:	55                   	push   %rbp
  800b59:	48 89 e5             	mov    %rsp,%rbp
  800b5c:	48 83 ec 20          	sub    $0x20,%rsp
  800b60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800b63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800b67:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800b6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800b6d:	48 63 c8             	movslq %eax,%rcx
  800b70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b77:	48 98                	cltq   
  800b79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b80:	00 
  800b81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b87:	49 89 c8             	mov    %rcx,%r8
  800b8a:	48 89 d1             	mov    %rdx,%rcx
  800b8d:	48 89 c2             	mov    %rax,%rdx
  800b90:	be 01 00 00 00       	mov    $0x1,%esi
  800b95:	bf 04 00 00 00       	mov    $0x4,%edi
  800b9a:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800ba1:	00 00 00 
  800ba4:	ff d0                	callq  *%rax
}
  800ba6:	c9                   	leaveq 
  800ba7:	c3                   	retq   

0000000000800ba8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ba8:	55                   	push   %rbp
  800ba9:	48 89 e5             	mov    %rsp,%rbp
  800bac:	48 83 ec 30          	sub    $0x30,%rsp
  800bb0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bb3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800bb7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800bba:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800bbe:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800bc2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800bc5:	48 63 c8             	movslq %eax,%rcx
  800bc8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800bcc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bcf:	48 63 f0             	movslq %eax,%rsi
  800bd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bd9:	48 98                	cltq   
  800bdb:	48 89 0c 24          	mov    %rcx,(%rsp)
  800bdf:	49 89 f9             	mov    %rdi,%r9
  800be2:	49 89 f0             	mov    %rsi,%r8
  800be5:	48 89 d1             	mov    %rdx,%rcx
  800be8:	48 89 c2             	mov    %rax,%rdx
  800beb:	be 01 00 00 00       	mov    $0x1,%esi
  800bf0:	bf 05 00 00 00       	mov    $0x5,%edi
  800bf5:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800bfc:	00 00 00 
  800bff:	ff d0                	callq  *%rax
}
  800c01:	c9                   	leaveq 
  800c02:	c3                   	retq   

0000000000800c03 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c03:	55                   	push   %rbp
  800c04:	48 89 e5             	mov    %rsp,%rbp
  800c07:	48 83 ec 20          	sub    $0x20,%rsp
  800c0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800c12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c19:	48 98                	cltq   
  800c1b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800c22:	00 
  800c23:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800c29:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800c2f:	48 89 d1             	mov    %rdx,%rcx
  800c32:	48 89 c2             	mov    %rax,%rdx
  800c35:	be 01 00 00 00       	mov    $0x1,%esi
  800c3a:	bf 06 00 00 00       	mov    $0x6,%edi
  800c3f:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800c46:	00 00 00 
  800c49:	ff d0                	callq  *%rax
}
  800c4b:	c9                   	leaveq 
  800c4c:	c3                   	retq   

0000000000800c4d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c4d:	55                   	push   %rbp
  800c4e:	48 89 e5             	mov    %rsp,%rbp
  800c51:	48 83 ec 20          	sub    $0x20,%rsp
  800c55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c58:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c5e:	48 63 d0             	movslq %eax,%rdx
  800c61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c64:	48 98                	cltq   
  800c66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800c6d:	00 
  800c6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800c74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800c7a:	48 89 d1             	mov    %rdx,%rcx
  800c7d:	48 89 c2             	mov    %rax,%rdx
  800c80:	be 01 00 00 00       	mov    $0x1,%esi
  800c85:	bf 08 00 00 00       	mov    $0x8,%edi
  800c8a:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800c91:	00 00 00 
  800c94:	ff d0                	callq  *%rax
}
  800c96:	c9                   	leaveq 
  800c97:	c3                   	retq   

0000000000800c98 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c98:	55                   	push   %rbp
  800c99:	48 89 e5             	mov    %rsp,%rbp
  800c9c:	48 83 ec 20          	sub    $0x20,%rsp
  800ca0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ca3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800ca7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cae:	48 98                	cltq   
  800cb0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800cb7:	00 
  800cb8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800cbe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800cc4:	48 89 d1             	mov    %rdx,%rcx
  800cc7:	48 89 c2             	mov    %rax,%rdx
  800cca:	be 01 00 00 00       	mov    $0x1,%esi
  800ccf:	bf 09 00 00 00       	mov    $0x9,%edi
  800cd4:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800cdb:	00 00 00 
  800cde:	ff d0                	callq  *%rax
}
  800ce0:	c9                   	leaveq 
  800ce1:	c3                   	retq   

0000000000800ce2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ce2:	55                   	push   %rbp
  800ce3:	48 89 e5             	mov    %rsp,%rbp
  800ce6:	48 83 ec 20          	sub    $0x20,%rsp
  800cea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ced:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800cf1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cf8:	48 98                	cltq   
  800cfa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d01:	00 
  800d02:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d08:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d0e:	48 89 d1             	mov    %rdx,%rcx
  800d11:	48 89 c2             	mov    %rax,%rdx
  800d14:	be 01 00 00 00       	mov    $0x1,%esi
  800d19:	bf 0a 00 00 00       	mov    $0xa,%edi
  800d1e:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800d25:	00 00 00 
  800d28:	ff d0                	callq  *%rax
}
  800d2a:	c9                   	leaveq 
  800d2b:	c3                   	retq   

0000000000800d2c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800d2c:	55                   	push   %rbp
  800d2d:	48 89 e5             	mov    %rsp,%rbp
  800d30:	48 83 ec 30          	sub    $0x30,%rsp
  800d34:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d37:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800d3b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800d3f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800d42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d45:	48 63 f0             	movslq %eax,%rsi
  800d48:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d4f:	48 98                	cltq   
  800d51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d55:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d5c:	00 
  800d5d:	49 89 f1             	mov    %rsi,%r9
  800d60:	49 89 c8             	mov    %rcx,%r8
  800d63:	48 89 d1             	mov    %rdx,%rcx
  800d66:	48 89 c2             	mov    %rax,%rdx
  800d69:	be 00 00 00 00       	mov    $0x0,%esi
  800d6e:	bf 0c 00 00 00       	mov    $0xc,%edi
  800d73:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800d7a:	00 00 00 
  800d7d:	ff d0                	callq  *%rax
}
  800d7f:	c9                   	leaveq 
  800d80:	c3                   	retq   

0000000000800d81 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d81:	55                   	push   %rbp
  800d82:	48 89 e5             	mov    %rsp,%rbp
  800d85:	48 83 ec 20          	sub    $0x20,%rsp
  800d89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800d8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800d91:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d98:	00 
  800d99:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d9f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800da5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800daa:	48 89 c2             	mov    %rax,%rdx
  800dad:	be 01 00 00 00       	mov    $0x1,%esi
  800db2:	bf 0d 00 00 00       	mov    $0xd,%edi
  800db7:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800dbe:	00 00 00 
  800dc1:	ff d0                	callq  *%rax
}
  800dc3:	c9                   	leaveq 
  800dc4:	c3                   	retq   

0000000000800dc5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dc5:	55                   	push   %rbp
  800dc6:	48 89 e5             	mov    %rsp,%rbp
  800dc9:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800dcd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800dd4:	00 
  800dd5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ddb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800de1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de6:	ba 00 00 00 00       	mov    $0x0,%edx
  800deb:	be 00 00 00 00       	mov    $0x0,%esi
  800df0:	bf 0e 00 00 00       	mov    $0xe,%edi
  800df5:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800dfc:	00 00 00 
  800dff:	ff d0                	callq  *%rax
}
  800e01:	c9                   	leaveq 
  800e02:	c3                   	retq   

0000000000800e03 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  800e03:	55                   	push   %rbp
  800e04:	48 89 e5             	mov    %rsp,%rbp
  800e07:	48 83 ec 20          	sub    $0x20,%rsp
  800e0b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800e0f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  800e13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e17:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e1b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800e22:	00 
  800e23:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800e29:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e2f:	48 89 d1             	mov    %rdx,%rcx
  800e32:	48 89 c2             	mov    %rax,%rdx
  800e35:	be 00 00 00 00       	mov    $0x0,%esi
  800e3a:	bf 0f 00 00 00       	mov    $0xf,%edi
  800e3f:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800e46:	00 00 00 
  800e49:	ff d0                	callq  *%rax
}
  800e4b:	c9                   	leaveq 
  800e4c:	c3                   	retq   

0000000000800e4d <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  800e4d:	55                   	push   %rbp
  800e4e:	48 89 e5             	mov    %rsp,%rbp
  800e51:	48 83 ec 20          	sub    $0x20,%rsp
  800e55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800e59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  800e5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e65:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800e6c:	00 
  800e6d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800e73:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e79:	48 89 d1             	mov    %rdx,%rcx
  800e7c:	48 89 c2             	mov    %rax,%rdx
  800e7f:	be 00 00 00 00       	mov    $0x0,%esi
  800e84:	bf 10 00 00 00       	mov    $0x10,%edi
  800e89:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800e90:	00 00 00 
  800e93:	ff d0                	callq  *%rax
}
  800e95:	c9                   	leaveq 
  800e96:	c3                   	retq   
	...

0000000000800e98 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800e98:	55                   	push   %rbp
  800e99:	48 89 e5             	mov    %rsp,%rbp
  800e9c:	48 83 ec 30          	sub    $0x30,%rsp
  800ea0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ea4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ea8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  800eac:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800eb1:	74 18                	je     800ecb <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  800eb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800eb7:	48 89 c7             	mov    %rax,%rdi
  800eba:	48 b8 81 0d 80 00 00 	movabs $0x800d81,%rax
  800ec1:	00 00 00 
  800ec4:	ff d0                	callq  *%rax
  800ec6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ec9:	eb 19                	jmp    800ee4 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  800ecb:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  800ed2:	00 00 00 
  800ed5:	48 b8 81 0d 80 00 00 	movabs $0x800d81,%rax
  800edc:	00 00 00 
  800edf:	ff d0                	callq  *%rax
  800ee1:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  800ee4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ee8:	79 19                	jns    800f03 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  800eea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eee:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  800ef4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ef8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  800efe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f01:	eb 53                	jmp    800f56 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  800f03:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800f08:	74 19                	je     800f23 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  800f0a:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800f11:	00 00 00 
  800f14:	48 8b 00             	mov    (%rax),%rax
  800f17:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  800f1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f21:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  800f23:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f28:	74 19                	je     800f43 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  800f2a:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800f31:	00 00 00 
  800f34:	48 8b 00             	mov    (%rax),%rax
  800f37:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  800f3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800f41:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  800f43:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800f4a:	00 00 00 
  800f4d:	48 8b 00             	mov    (%rax),%rax
  800f50:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  800f56:	c9                   	leaveq 
  800f57:	c3                   	retq   

0000000000800f58 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800f58:	55                   	push   %rbp
  800f59:	48 89 e5             	mov    %rsp,%rbp
  800f5c:	48 83 ec 30          	sub    $0x30,%rsp
  800f60:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800f63:	89 75 e8             	mov    %esi,-0x18(%rbp)
  800f66:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800f6a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  800f6d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  800f74:	e9 96 00 00 00       	jmpq   80100f <ipc_send+0xb7>
	{
		if(pg!=NULL)
  800f79:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f7e:	74 20                	je     800fa0 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  800f80:	8b 75 e8             	mov    -0x18(%rbp),%esi
  800f83:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800f86:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f8a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800f8d:	89 c7                	mov    %eax,%edi
  800f8f:	48 b8 2c 0d 80 00 00 	movabs $0x800d2c,%rax
  800f96:	00 00 00 
  800f99:	ff d0                	callq  *%rax
  800f9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f9e:	eb 2d                	jmp    800fcd <ipc_send+0x75>
		else if(pg==NULL)
  800fa0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800fa5:	75 26                	jne    800fcd <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  800fa7:	8b 75 e8             	mov    -0x18(%rbp),%esi
  800faa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800fad:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800fb9:	00 00 00 
  800fbc:	89 c7                	mov    %eax,%edi
  800fbe:	48 b8 2c 0d 80 00 00 	movabs $0x800d2c,%rax
  800fc5:	00 00 00 
  800fc8:	ff d0                	callq  *%rax
  800fca:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  800fcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fd1:	79 30                	jns    801003 <ipc_send+0xab>
  800fd3:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  800fd7:	74 2a                	je     801003 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  800fd9:	48 ba 44 40 80 00 00 	movabs $0x804044,%rdx
  800fe0:	00 00 00 
  800fe3:	be 40 00 00 00       	mov    $0x40,%esi
  800fe8:	48 bf 5c 40 80 00 00 	movabs $0x80405c,%rdi
  800fef:	00 00 00 
  800ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff7:	48 b9 30 2e 80 00 00 	movabs $0x802e30,%rcx
  800ffe:	00 00 00 
  801001:	ff d1                	callq  *%rcx
		}
		sys_yield();
  801003:	48 b8 1a 0b 80 00 00 	movabs $0x800b1a,%rax
  80100a:	00 00 00 
  80100d:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  80100f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801013:	0f 85 60 ff ff ff    	jne    800f79 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  801019:	c9                   	leaveq 
  80101a:	c3                   	retq   

000000000080101b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80101b:	55                   	push   %rbp
  80101c:	48 89 e5             	mov    %rsp,%rbp
  80101f:	48 83 ec 18          	sub    $0x18,%rsp
  801023:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  801026:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80102d:	eb 5e                	jmp    80108d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80102f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801036:	00 00 00 
  801039:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80103c:	48 63 d0             	movslq %eax,%rdx
  80103f:	48 89 d0             	mov    %rdx,%rax
  801042:	48 c1 e0 03          	shl    $0x3,%rax
  801046:	48 01 d0             	add    %rdx,%rax
  801049:	48 c1 e0 05          	shl    $0x5,%rax
  80104d:	48 01 c8             	add    %rcx,%rax
  801050:	48 05 d0 00 00 00    	add    $0xd0,%rax
  801056:	8b 00                	mov    (%rax),%eax
  801058:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80105b:	75 2c                	jne    801089 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80105d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801064:	00 00 00 
  801067:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80106a:	48 63 d0             	movslq %eax,%rdx
  80106d:	48 89 d0             	mov    %rdx,%rax
  801070:	48 c1 e0 03          	shl    $0x3,%rax
  801074:	48 01 d0             	add    %rdx,%rax
  801077:	48 c1 e0 05          	shl    $0x5,%rax
  80107b:	48 01 c8             	add    %rcx,%rax
  80107e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  801084:	8b 40 08             	mov    0x8(%rax),%eax
  801087:	eb 12                	jmp    80109b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801089:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80108d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801094:	7e 99                	jle    80102f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109b:	c9                   	leaveq 
  80109c:	c3                   	retq   
  80109d:	00 00                	add    %al,(%rax)
	...

00000000008010a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8010a0:	55                   	push   %rbp
  8010a1:	48 89 e5             	mov    %rsp,%rbp
  8010a4:	48 83 ec 08          	sub    $0x8,%rsp
  8010a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010b0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8010b7:	ff ff ff 
  8010ba:	48 01 d0             	add    %rdx,%rax
  8010bd:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8010c1:	c9                   	leaveq 
  8010c2:	c3                   	retq   

00000000008010c3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010c3:	55                   	push   %rbp
  8010c4:	48 89 e5             	mov    %rsp,%rbp
  8010c7:	48 83 ec 08          	sub    $0x8,%rsp
  8010cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8010cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d3:	48 89 c7             	mov    %rax,%rdi
  8010d6:	48 b8 a0 10 80 00 00 	movabs $0x8010a0,%rax
  8010dd:	00 00 00 
  8010e0:	ff d0                	callq  *%rax
  8010e2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8010e8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8010ec:	c9                   	leaveq 
  8010ed:	c3                   	retq   

00000000008010ee <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010ee:	55                   	push   %rbp
  8010ef:	48 89 e5             	mov    %rsp,%rbp
  8010f2:	48 83 ec 18          	sub    $0x18,%rsp
  8010f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801101:	eb 6b                	jmp    80116e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801103:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801106:	48 98                	cltq   
  801108:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80110e:	48 c1 e0 0c          	shl    $0xc,%rax
  801112:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801116:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80111a:	48 89 c2             	mov    %rax,%rdx
  80111d:	48 c1 ea 15          	shr    $0x15,%rdx
  801121:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801128:	01 00 00 
  80112b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80112f:	83 e0 01             	and    $0x1,%eax
  801132:	48 85 c0             	test   %rax,%rax
  801135:	74 21                	je     801158 <fd_alloc+0x6a>
  801137:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80113b:	48 89 c2             	mov    %rax,%rdx
  80113e:	48 c1 ea 0c          	shr    $0xc,%rdx
  801142:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801149:	01 00 00 
  80114c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801150:	83 e0 01             	and    $0x1,%eax
  801153:	48 85 c0             	test   %rax,%rax
  801156:	75 12                	jne    80116a <fd_alloc+0x7c>
			*fd_store = fd;
  801158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801160:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801163:	b8 00 00 00 00       	mov    $0x0,%eax
  801168:	eb 1a                	jmp    801184 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80116a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80116e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801172:	7e 8f                	jle    801103 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801174:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801178:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80117f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801184:	c9                   	leaveq 
  801185:	c3                   	retq   

0000000000801186 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801186:	55                   	push   %rbp
  801187:	48 89 e5             	mov    %rsp,%rbp
  80118a:	48 83 ec 20          	sub    $0x20,%rsp
  80118e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801191:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801195:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801199:	78 06                	js     8011a1 <fd_lookup+0x1b>
  80119b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80119f:	7e 07                	jle    8011a8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a6:	eb 6c                	jmp    801214 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8011a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8011ab:	48 98                	cltq   
  8011ad:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8011b3:	48 c1 e0 0c          	shl    $0xc,%rax
  8011b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bf:	48 89 c2             	mov    %rax,%rdx
  8011c2:	48 c1 ea 15          	shr    $0x15,%rdx
  8011c6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8011cd:	01 00 00 
  8011d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8011d4:	83 e0 01             	and    $0x1,%eax
  8011d7:	48 85 c0             	test   %rax,%rax
  8011da:	74 21                	je     8011fd <fd_lookup+0x77>
  8011dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e0:	48 89 c2             	mov    %rax,%rdx
  8011e3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8011e7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8011ee:	01 00 00 
  8011f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8011f5:	83 e0 01             	and    $0x1,%eax
  8011f8:	48 85 c0             	test   %rax,%rax
  8011fb:	75 07                	jne    801204 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801202:	eb 10                	jmp    801214 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801204:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801208:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80120c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801214:	c9                   	leaveq 
  801215:	c3                   	retq   

0000000000801216 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801216:	55                   	push   %rbp
  801217:	48 89 e5             	mov    %rsp,%rbp
  80121a:	48 83 ec 30          	sub    $0x30,%rsp
  80121e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801222:	89 f0                	mov    %esi,%eax
  801224:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801227:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80122b:	48 89 c7             	mov    %rax,%rdi
  80122e:	48 b8 a0 10 80 00 00 	movabs $0x8010a0,%rax
  801235:	00 00 00 
  801238:	ff d0                	callq  *%rax
  80123a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80123e:	48 89 d6             	mov    %rdx,%rsi
  801241:	89 c7                	mov    %eax,%edi
  801243:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  80124a:	00 00 00 
  80124d:	ff d0                	callq  *%rax
  80124f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801252:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801256:	78 0a                	js     801262 <fd_close+0x4c>
	    || fd != fd2)
  801258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801260:	74 12                	je     801274 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801262:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801266:	74 05                	je     80126d <fd_close+0x57>
  801268:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80126b:	eb 05                	jmp    801272 <fd_close+0x5c>
  80126d:	b8 00 00 00 00       	mov    $0x0,%eax
  801272:	eb 69                	jmp    8012dd <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801274:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801278:	8b 00                	mov    (%rax),%eax
  80127a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80127e:	48 89 d6             	mov    %rdx,%rsi
  801281:	89 c7                	mov    %eax,%edi
  801283:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  80128a:	00 00 00 
  80128d:	ff d0                	callq  *%rax
  80128f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801292:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801296:	78 2a                	js     8012c2 <fd_close+0xac>
		if (dev->dev_close)
  801298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129c:	48 8b 40 20          	mov    0x20(%rax),%rax
  8012a0:	48 85 c0             	test   %rax,%rax
  8012a3:	74 16                	je     8012bb <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8012a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a9:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8012ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b1:	48 89 c7             	mov    %rax,%rdi
  8012b4:	ff d2                	callq  *%rdx
  8012b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012b9:	eb 07                	jmp    8012c2 <fd_close+0xac>
		else
			r = 0;
  8012bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c6:	48 89 c6             	mov    %rax,%rsi
  8012c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8012ce:	48 b8 03 0c 80 00 00 	movabs $0x800c03,%rax
  8012d5:	00 00 00 
  8012d8:	ff d0                	callq  *%rax
	return r;
  8012da:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012dd:	c9                   	leaveq 
  8012de:	c3                   	retq   

00000000008012df <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012df:	55                   	push   %rbp
  8012e0:	48 89 e5             	mov    %rsp,%rbp
  8012e3:	48 83 ec 20          	sub    $0x20,%rsp
  8012e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8012ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8012ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012f5:	eb 41                	jmp    801338 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8012f7:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8012fe:	00 00 00 
  801301:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801304:	48 63 d2             	movslq %edx,%rdx
  801307:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80130b:	8b 00                	mov    (%rax),%eax
  80130d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801310:	75 22                	jne    801334 <dev_lookup+0x55>
			*dev = devtab[i];
  801312:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801319:	00 00 00 
  80131c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80131f:	48 63 d2             	movslq %edx,%rdx
  801322:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801326:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80132a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80132d:	b8 00 00 00 00       	mov    $0x0,%eax
  801332:	eb 60                	jmp    801394 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801334:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801338:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80133f:	00 00 00 
  801342:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801345:	48 63 d2             	movslq %edx,%rdx
  801348:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80134c:	48 85 c0             	test   %rax,%rax
  80134f:	75 a6                	jne    8012f7 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801351:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801358:	00 00 00 
  80135b:	48 8b 00             	mov    (%rax),%rax
  80135e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801364:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801367:	89 c6                	mov    %eax,%esi
  801369:	48 bf 68 40 80 00 00 	movabs $0x804068,%rdi
  801370:	00 00 00 
  801373:	b8 00 00 00 00       	mov    $0x0,%eax
  801378:	48 b9 6b 30 80 00 00 	movabs $0x80306b,%rcx
  80137f:	00 00 00 
  801382:	ff d1                	callq  *%rcx
	*dev = 0;
  801384:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801388:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80138f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801394:	c9                   	leaveq 
  801395:	c3                   	retq   

0000000000801396 <close>:

int
close(int fdnum)
{
  801396:	55                   	push   %rbp
  801397:	48 89 e5             	mov    %rsp,%rbp
  80139a:	48 83 ec 20          	sub    $0x20,%rsp
  80139e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013a1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8013a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8013a8:	48 89 d6             	mov    %rdx,%rsi
  8013ab:	89 c7                	mov    %eax,%edi
  8013ad:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  8013b4:	00 00 00 
  8013b7:	ff d0                	callq  *%rax
  8013b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013c0:	79 05                	jns    8013c7 <close+0x31>
		return r;
  8013c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013c5:	eb 18                	jmp    8013df <close+0x49>
	else
		return fd_close(fd, 1);
  8013c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013cb:	be 01 00 00 00       	mov    $0x1,%esi
  8013d0:	48 89 c7             	mov    %rax,%rdi
  8013d3:	48 b8 16 12 80 00 00 	movabs $0x801216,%rax
  8013da:	00 00 00 
  8013dd:	ff d0                	callq  *%rax
}
  8013df:	c9                   	leaveq 
  8013e0:	c3                   	retq   

00000000008013e1 <close_all>:

void
close_all(void)
{
  8013e1:	55                   	push   %rbp
  8013e2:	48 89 e5             	mov    %rsp,%rbp
  8013e5:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013f0:	eb 15                	jmp    801407 <close_all+0x26>
		close(i);
  8013f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013f5:	89 c7                	mov    %eax,%edi
  8013f7:	48 b8 96 13 80 00 00 	movabs $0x801396,%rax
  8013fe:	00 00 00 
  801401:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801403:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801407:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80140b:	7e e5                	jle    8013f2 <close_all+0x11>
		close(i);
}
  80140d:	c9                   	leaveq 
  80140e:	c3                   	retq   

000000000080140f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80140f:	55                   	push   %rbp
  801410:	48 89 e5             	mov    %rsp,%rbp
  801413:	48 83 ec 40          	sub    $0x40,%rsp
  801417:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80141a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80141d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801421:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801424:	48 89 d6             	mov    %rdx,%rsi
  801427:	89 c7                	mov    %eax,%edi
  801429:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  801430:	00 00 00 
  801433:	ff d0                	callq  *%rax
  801435:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801438:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80143c:	79 08                	jns    801446 <dup+0x37>
		return r;
  80143e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801441:	e9 70 01 00 00       	jmpq   8015b6 <dup+0x1a7>
	close(newfdnum);
  801446:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801449:	89 c7                	mov    %eax,%edi
  80144b:	48 b8 96 13 80 00 00 	movabs $0x801396,%rax
  801452:	00 00 00 
  801455:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801457:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80145a:	48 98                	cltq   
  80145c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801462:	48 c1 e0 0c          	shl    $0xc,%rax
  801466:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80146a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146e:	48 89 c7             	mov    %rax,%rdi
  801471:	48 b8 c3 10 80 00 00 	movabs $0x8010c3,%rax
  801478:	00 00 00 
  80147b:	ff d0                	callq  *%rax
  80147d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801485:	48 89 c7             	mov    %rax,%rdi
  801488:	48 b8 c3 10 80 00 00 	movabs $0x8010c3,%rax
  80148f:	00 00 00 
  801492:	ff d0                	callq  *%rax
  801494:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801498:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149c:	48 89 c2             	mov    %rax,%rdx
  80149f:	48 c1 ea 15          	shr    $0x15,%rdx
  8014a3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8014aa:	01 00 00 
  8014ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8014b1:	83 e0 01             	and    $0x1,%eax
  8014b4:	84 c0                	test   %al,%al
  8014b6:	74 71                	je     801529 <dup+0x11a>
  8014b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bc:	48 89 c2             	mov    %rax,%rdx
  8014bf:	48 c1 ea 0c          	shr    $0xc,%rdx
  8014c3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8014ca:	01 00 00 
  8014cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8014d1:	83 e0 01             	and    $0x1,%eax
  8014d4:	84 c0                	test   %al,%al
  8014d6:	74 51                	je     801529 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014dc:	48 89 c2             	mov    %rax,%rdx
  8014df:	48 c1 ea 0c          	shr    $0xc,%rdx
  8014e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8014ea:	01 00 00 
  8014ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8014f1:	89 c1                	mov    %eax,%ecx
  8014f3:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8014f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801501:	41 89 c8             	mov    %ecx,%r8d
  801504:	48 89 d1             	mov    %rdx,%rcx
  801507:	ba 00 00 00 00       	mov    $0x0,%edx
  80150c:	48 89 c6             	mov    %rax,%rsi
  80150f:	bf 00 00 00 00       	mov    $0x0,%edi
  801514:	48 b8 a8 0b 80 00 00 	movabs $0x800ba8,%rax
  80151b:	00 00 00 
  80151e:	ff d0                	callq  *%rax
  801520:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801523:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801527:	78 56                	js     80157f <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801529:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152d:	48 89 c2             	mov    %rax,%rdx
  801530:	48 c1 ea 0c          	shr    $0xc,%rdx
  801534:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80153b:	01 00 00 
  80153e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801542:	89 c1                	mov    %eax,%ecx
  801544:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80154a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801552:	41 89 c8             	mov    %ecx,%r8d
  801555:	48 89 d1             	mov    %rdx,%rcx
  801558:	ba 00 00 00 00       	mov    $0x0,%edx
  80155d:	48 89 c6             	mov    %rax,%rsi
  801560:	bf 00 00 00 00       	mov    $0x0,%edi
  801565:	48 b8 a8 0b 80 00 00 	movabs $0x800ba8,%rax
  80156c:	00 00 00 
  80156f:	ff d0                	callq  *%rax
  801571:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801574:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801578:	78 08                	js     801582 <dup+0x173>
		goto err;

	return newfdnum;
  80157a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80157d:	eb 37                	jmp    8015b6 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80157f:	90                   	nop
  801580:	eb 01                	jmp    801583 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  801582:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801583:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801587:	48 89 c6             	mov    %rax,%rsi
  80158a:	bf 00 00 00 00       	mov    $0x0,%edi
  80158f:	48 b8 03 0c 80 00 00 	movabs $0x800c03,%rax
  801596:	00 00 00 
  801599:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80159b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80159f:	48 89 c6             	mov    %rax,%rsi
  8015a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8015a7:	48 b8 03 0c 80 00 00 	movabs $0x800c03,%rax
  8015ae:	00 00 00 
  8015b1:	ff d0                	callq  *%rax
	return r;
  8015b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8015b6:	c9                   	leaveq 
  8015b7:	c3                   	retq   

00000000008015b8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015b8:	55                   	push   %rbp
  8015b9:	48 89 e5             	mov    %rsp,%rbp
  8015bc:	48 83 ec 40          	sub    $0x40,%rsp
  8015c0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015c3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015c7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015cb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8015cf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015d2:	48 89 d6             	mov    %rdx,%rsi
  8015d5:	89 c7                	mov    %eax,%edi
  8015d7:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  8015de:	00 00 00 
  8015e1:	ff d0                	callq  *%rax
  8015e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015ea:	78 24                	js     801610 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f0:	8b 00                	mov    (%rax),%eax
  8015f2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8015f6:	48 89 d6             	mov    %rdx,%rsi
  8015f9:	89 c7                	mov    %eax,%edi
  8015fb:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  801602:	00 00 00 
  801605:	ff d0                	callq  *%rax
  801607:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80160a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80160e:	79 05                	jns    801615 <read+0x5d>
		return r;
  801610:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801613:	eb 7a                	jmp    80168f <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801615:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801619:	8b 40 08             	mov    0x8(%rax),%eax
  80161c:	83 e0 03             	and    $0x3,%eax
  80161f:	83 f8 01             	cmp    $0x1,%eax
  801622:	75 3a                	jne    80165e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801624:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80162b:	00 00 00 
  80162e:	48 8b 00             	mov    (%rax),%rax
  801631:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801637:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80163a:	89 c6                	mov    %eax,%esi
  80163c:	48 bf 87 40 80 00 00 	movabs $0x804087,%rdi
  801643:	00 00 00 
  801646:	b8 00 00 00 00       	mov    $0x0,%eax
  80164b:	48 b9 6b 30 80 00 00 	movabs $0x80306b,%rcx
  801652:	00 00 00 
  801655:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801657:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80165c:	eb 31                	jmp    80168f <read+0xd7>
	}
	if (!dev->dev_read)
  80165e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801662:	48 8b 40 10          	mov    0x10(%rax),%rax
  801666:	48 85 c0             	test   %rax,%rax
  801669:	75 07                	jne    801672 <read+0xba>
		return -E_NOT_SUPP;
  80166b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801670:	eb 1d                	jmp    80168f <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  801672:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801676:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80167a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80167e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801682:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801686:	48 89 ce             	mov    %rcx,%rsi
  801689:	48 89 c7             	mov    %rax,%rdi
  80168c:	41 ff d0             	callq  *%r8
}
  80168f:	c9                   	leaveq 
  801690:	c3                   	retq   

0000000000801691 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801691:	55                   	push   %rbp
  801692:	48 89 e5             	mov    %rsp,%rbp
  801695:	48 83 ec 30          	sub    $0x30,%rsp
  801699:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80169c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016ab:	eb 46                	jmp    8016f3 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016b0:	48 98                	cltq   
  8016b2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016b6:	48 29 c2             	sub    %rax,%rdx
  8016b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016bc:	48 98                	cltq   
  8016be:	48 89 c1             	mov    %rax,%rcx
  8016c1:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  8016c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016c8:	48 89 ce             	mov    %rcx,%rsi
  8016cb:	89 c7                	mov    %eax,%edi
  8016cd:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  8016d4:	00 00 00 
  8016d7:	ff d0                	callq  *%rax
  8016d9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8016dc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8016e0:	79 05                	jns    8016e7 <readn+0x56>
			return m;
  8016e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8016e5:	eb 1d                	jmp    801704 <readn+0x73>
		if (m == 0)
  8016e7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8016eb:	74 13                	je     801700 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8016f0:	01 45 fc             	add    %eax,-0x4(%rbp)
  8016f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016f6:	48 98                	cltq   
  8016f8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8016fc:	72 af                	jb     8016ad <readn+0x1c>
  8016fe:	eb 01                	jmp    801701 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  801700:	90                   	nop
	}
	return tot;
  801701:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801704:	c9                   	leaveq 
  801705:	c3                   	retq   

0000000000801706 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801706:	55                   	push   %rbp
  801707:	48 89 e5             	mov    %rsp,%rbp
  80170a:	48 83 ec 40          	sub    $0x40,%rsp
  80170e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801711:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801715:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801719:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80171d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801720:	48 89 d6             	mov    %rdx,%rsi
  801723:	89 c7                	mov    %eax,%edi
  801725:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  80172c:	00 00 00 
  80172f:	ff d0                	callq  *%rax
  801731:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801734:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801738:	78 24                	js     80175e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80173a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80173e:	8b 00                	mov    (%rax),%eax
  801740:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801744:	48 89 d6             	mov    %rdx,%rsi
  801747:	89 c7                	mov    %eax,%edi
  801749:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  801750:	00 00 00 
  801753:	ff d0                	callq  *%rax
  801755:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801758:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80175c:	79 05                	jns    801763 <write+0x5d>
		return r;
  80175e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801761:	eb 79                	jmp    8017dc <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801763:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801767:	8b 40 08             	mov    0x8(%rax),%eax
  80176a:	83 e0 03             	and    $0x3,%eax
  80176d:	85 c0                	test   %eax,%eax
  80176f:	75 3a                	jne    8017ab <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801771:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801778:	00 00 00 
  80177b:	48 8b 00             	mov    (%rax),%rax
  80177e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801784:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801787:	89 c6                	mov    %eax,%esi
  801789:	48 bf a3 40 80 00 00 	movabs $0x8040a3,%rdi
  801790:	00 00 00 
  801793:	b8 00 00 00 00       	mov    $0x0,%eax
  801798:	48 b9 6b 30 80 00 00 	movabs $0x80306b,%rcx
  80179f:	00 00 00 
  8017a2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8017a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a9:	eb 31                	jmp    8017dc <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017af:	48 8b 40 18          	mov    0x18(%rax),%rax
  8017b3:	48 85 c0             	test   %rax,%rax
  8017b6:	75 07                	jne    8017bf <write+0xb9>
		return -E_NOT_SUPP;
  8017b8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8017bd:	eb 1d                	jmp    8017dc <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  8017bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c3:	4c 8b 40 18          	mov    0x18(%rax),%r8
  8017c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017cb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8017cf:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017d3:	48 89 ce             	mov    %rcx,%rsi
  8017d6:	48 89 c7             	mov    %rax,%rdi
  8017d9:	41 ff d0             	callq  *%r8
}
  8017dc:	c9                   	leaveq 
  8017dd:	c3                   	retq   

00000000008017de <seek>:

int
seek(int fdnum, off_t offset)
{
  8017de:	55                   	push   %rbp
  8017df:	48 89 e5             	mov    %rsp,%rbp
  8017e2:	48 83 ec 18          	sub    $0x18,%rsp
  8017e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8017e9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017ec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8017f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017f3:	48 89 d6             	mov    %rdx,%rsi
  8017f6:	89 c7                	mov    %eax,%edi
  8017f8:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  8017ff:	00 00 00 
  801802:	ff d0                	callq  *%rax
  801804:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801807:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80180b:	79 05                	jns    801812 <seek+0x34>
		return r;
  80180d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801810:	eb 0f                	jmp    801821 <seek+0x43>
	fd->fd_offset = offset;
  801812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801816:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801819:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80181c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801821:	c9                   	leaveq 
  801822:	c3                   	retq   

0000000000801823 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801823:	55                   	push   %rbp
  801824:	48 89 e5             	mov    %rsp,%rbp
  801827:	48 83 ec 30          	sub    $0x30,%rsp
  80182b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80182e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801831:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801835:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801838:	48 89 d6             	mov    %rdx,%rsi
  80183b:	89 c7                	mov    %eax,%edi
  80183d:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  801844:	00 00 00 
  801847:	ff d0                	callq  *%rax
  801849:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80184c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801850:	78 24                	js     801876 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801856:	8b 00                	mov    (%rax),%eax
  801858:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80185c:	48 89 d6             	mov    %rdx,%rsi
  80185f:	89 c7                	mov    %eax,%edi
  801861:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  801868:	00 00 00 
  80186b:	ff d0                	callq  *%rax
  80186d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801870:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801874:	79 05                	jns    80187b <ftruncate+0x58>
		return r;
  801876:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801879:	eb 72                	jmp    8018ed <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80187b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80187f:	8b 40 08             	mov    0x8(%rax),%eax
  801882:	83 e0 03             	and    $0x3,%eax
  801885:	85 c0                	test   %eax,%eax
  801887:	75 3a                	jne    8018c3 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801889:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801890:	00 00 00 
  801893:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801896:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80189c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80189f:	89 c6                	mov    %eax,%esi
  8018a1:	48 bf c0 40 80 00 00 	movabs $0x8040c0,%rdi
  8018a8:	00 00 00 
  8018ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b0:	48 b9 6b 30 80 00 00 	movabs $0x80306b,%rcx
  8018b7:	00 00 00 
  8018ba:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c1:	eb 2a                	jmp    8018ed <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8018c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c7:	48 8b 40 30          	mov    0x30(%rax),%rax
  8018cb:	48 85 c0             	test   %rax,%rax
  8018ce:	75 07                	jne    8018d7 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8018d0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8018d5:	eb 16                	jmp    8018ed <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8018d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018db:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8018df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8018e6:	89 d6                	mov    %edx,%esi
  8018e8:	48 89 c7             	mov    %rax,%rdi
  8018eb:	ff d1                	callq  *%rcx
}
  8018ed:	c9                   	leaveq 
  8018ee:	c3                   	retq   

00000000008018ef <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018ef:	55                   	push   %rbp
  8018f0:	48 89 e5             	mov    %rsp,%rbp
  8018f3:	48 83 ec 30          	sub    $0x30,%rsp
  8018f7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018fa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018fe:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801902:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801905:	48 89 d6             	mov    %rdx,%rsi
  801908:	89 c7                	mov    %eax,%edi
  80190a:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  801911:	00 00 00 
  801914:	ff d0                	callq  *%rax
  801916:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801919:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80191d:	78 24                	js     801943 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80191f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801923:	8b 00                	mov    (%rax),%eax
  801925:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801929:	48 89 d6             	mov    %rdx,%rsi
  80192c:	89 c7                	mov    %eax,%edi
  80192e:	48 b8 df 12 80 00 00 	movabs $0x8012df,%rax
  801935:	00 00 00 
  801938:	ff d0                	callq  *%rax
  80193a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80193d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801941:	79 05                	jns    801948 <fstat+0x59>
		return r;
  801943:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801946:	eb 5e                	jmp    8019a6 <fstat+0xb7>
	if (!dev->dev_stat)
  801948:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80194c:	48 8b 40 28          	mov    0x28(%rax),%rax
  801950:	48 85 c0             	test   %rax,%rax
  801953:	75 07                	jne    80195c <fstat+0x6d>
		return -E_NOT_SUPP;
  801955:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80195a:	eb 4a                	jmp    8019a6 <fstat+0xb7>
	stat->st_name[0] = 0;
  80195c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801960:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  801963:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801967:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80196e:	00 00 00 
	stat->st_isdir = 0;
  801971:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801975:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80197c:	00 00 00 
	stat->st_dev = dev;
  80197f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801983:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801987:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80198e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801992:	48 8b 48 28          	mov    0x28(%rax),%rcx
  801996:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80199a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80199e:	48 89 d6             	mov    %rdx,%rsi
  8019a1:	48 89 c7             	mov    %rax,%rdi
  8019a4:	ff d1                	callq  *%rcx
}
  8019a6:	c9                   	leaveq 
  8019a7:	c3                   	retq   

00000000008019a8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019a8:	55                   	push   %rbp
  8019a9:	48 89 e5             	mov    %rsp,%rbp
  8019ac:	48 83 ec 20          	sub    $0x20,%rsp
  8019b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019bc:	be 00 00 00 00       	mov    $0x0,%esi
  8019c1:	48 89 c7             	mov    %rax,%rdi
  8019c4:	48 b8 97 1a 80 00 00 	movabs $0x801a97,%rax
  8019cb:	00 00 00 
  8019ce:	ff d0                	callq  *%rax
  8019d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019d7:	79 05                	jns    8019de <stat+0x36>
		return fd;
  8019d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019dc:	eb 2f                	jmp    801a0d <stat+0x65>
	r = fstat(fd, stat);
  8019de:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8019e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e5:	48 89 d6             	mov    %rdx,%rsi
  8019e8:	89 c7                	mov    %eax,%edi
  8019ea:	48 b8 ef 18 80 00 00 	movabs $0x8018ef,%rax
  8019f1:	00 00 00 
  8019f4:	ff d0                	callq  *%rax
  8019f6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8019f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fc:	89 c7                	mov    %eax,%edi
  8019fe:	48 b8 96 13 80 00 00 	movabs $0x801396,%rax
  801a05:	00 00 00 
  801a08:	ff d0                	callq  *%rax
	return r;
  801a0a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801a0d:	c9                   	leaveq 
  801a0e:	c3                   	retq   
	...

0000000000801a10 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a10:	55                   	push   %rbp
  801a11:	48 89 e5             	mov    %rsp,%rbp
  801a14:	48 83 ec 10          	sub    $0x10,%rsp
  801a18:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a1b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801a1f:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  801a26:	00 00 00 
  801a29:	8b 00                	mov    (%rax),%eax
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	75 1d                	jne    801a4c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a2f:	bf 01 00 00 00       	mov    $0x1,%edi
  801a34:	48 b8 1b 10 80 00 00 	movabs $0x80101b,%rax
  801a3b:	00 00 00 
  801a3e:	ff d0                	callq  *%rax
  801a40:	48 ba 1c 70 80 00 00 	movabs $0x80701c,%rdx
  801a47:	00 00 00 
  801a4a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a4c:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  801a53:	00 00 00 
  801a56:	8b 00                	mov    (%rax),%eax
  801a58:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801a5b:	b9 07 00 00 00       	mov    $0x7,%ecx
  801a60:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  801a67:	00 00 00 
  801a6a:	89 c7                	mov    %eax,%edi
  801a6c:	48 b8 58 0f 80 00 00 	movabs $0x800f58,%rax
  801a73:	00 00 00 
  801a76:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  801a78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a81:	48 89 c6             	mov    %rax,%rsi
  801a84:	bf 00 00 00 00       	mov    $0x0,%edi
  801a89:	48 b8 98 0e 80 00 00 	movabs $0x800e98,%rax
  801a90:	00 00 00 
  801a93:	ff d0                	callq  *%rax
}
  801a95:	c9                   	leaveq 
  801a96:	c3                   	retq   

0000000000801a97 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a97:	55                   	push   %rbp
  801a98:	48 89 e5             	mov    %rsp,%rbp
  801a9b:	48 83 ec 20          	sub    $0x20,%rsp
  801a9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801aa3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  801aa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aaa:	48 89 c7             	mov    %rax,%rdi
  801aad:	48 b8 b4 01 80 00 00 	movabs $0x8001b4,%rax
  801ab4:	00 00 00 
  801ab7:	ff d0                	callq  *%rax
  801ab9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801abe:	7e 0a                	jle    801aca <open+0x33>
                return -E_BAD_PATH;
  801ac0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801ac5:	e9 a5 00 00 00       	jmpq   801b6f <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  801aca:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801ace:	48 89 c7             	mov    %rax,%rdi
  801ad1:	48 b8 ee 10 80 00 00 	movabs $0x8010ee,%rax
  801ad8:	00 00 00 
  801adb:	ff d0                	callq  *%rax
  801add:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ae0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ae4:	79 08                	jns    801aee <open+0x57>
		return r;
  801ae6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae9:	e9 81 00 00 00       	jmpq   801b6f <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  801aee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801af2:	48 89 c6             	mov    %rax,%rsi
  801af5:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801afc:	00 00 00 
  801aff:	48 b8 20 02 80 00 00 	movabs $0x800220,%rax
  801b06:	00 00 00 
  801b09:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  801b0b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801b12:	00 00 00 
  801b15:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801b18:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  801b1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b22:	48 89 c6             	mov    %rax,%rsi
  801b25:	bf 01 00 00 00       	mov    $0x1,%edi
  801b2a:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  801b31:	00 00 00 
  801b34:	ff d0                	callq  *%rax
  801b36:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  801b39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b3d:	79 1d                	jns    801b5c <open+0xc5>
	{
		fd_close(fd,0);
  801b3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b43:	be 00 00 00 00       	mov    $0x0,%esi
  801b48:	48 89 c7             	mov    %rax,%rdi
  801b4b:	48 b8 16 12 80 00 00 	movabs $0x801216,%rax
  801b52:	00 00 00 
  801b55:	ff d0                	callq  *%rax
		return r;
  801b57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5a:	eb 13                	jmp    801b6f <open+0xd8>
	}
	return fd2num(fd);
  801b5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b60:	48 89 c7             	mov    %rax,%rdi
  801b63:	48 b8 a0 10 80 00 00 	movabs $0x8010a0,%rax
  801b6a:	00 00 00 
  801b6d:	ff d0                	callq  *%rax
	


}
  801b6f:	c9                   	leaveq 
  801b70:	c3                   	retq   

0000000000801b71 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b71:	55                   	push   %rbp
  801b72:	48 89 e5             	mov    %rsp,%rbp
  801b75:	48 83 ec 10          	sub    $0x10,%rsp
  801b79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b81:	8b 50 0c             	mov    0xc(%rax),%edx
  801b84:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801b8b:	00 00 00 
  801b8e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801b90:	be 00 00 00 00       	mov    $0x0,%esi
  801b95:	bf 06 00 00 00       	mov    $0x6,%edi
  801b9a:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  801ba1:	00 00 00 
  801ba4:	ff d0                	callq  *%rax
}
  801ba6:	c9                   	leaveq 
  801ba7:	c3                   	retq   

0000000000801ba8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801ba8:	55                   	push   %rbp
  801ba9:	48 89 e5             	mov    %rsp,%rbp
  801bac:	48 83 ec 30          	sub    $0x30,%rsp
  801bb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bb4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bb8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc0:	8b 50 0c             	mov    0xc(%rax),%edx
  801bc3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801bca:	00 00 00 
  801bcd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801bcf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801bd6:	00 00 00 
  801bd9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801bdd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801be1:	be 00 00 00 00       	mov    $0x0,%esi
  801be6:	bf 03 00 00 00       	mov    $0x3,%edi
  801beb:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  801bf2:	00 00 00 
  801bf5:	ff d0                	callq  *%rax
  801bf7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bfe:	79 05                	jns    801c05 <devfile_read+0x5d>
	{
		return r;
  801c00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c03:	eb 2c                	jmp    801c31 <devfile_read+0x89>
	}
	if(r > 0)
  801c05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c09:	7e 23                	jle    801c2e <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  801c0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0e:	48 63 d0             	movslq %eax,%rdx
  801c11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c15:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801c1c:	00 00 00 
  801c1f:	48 89 c7             	mov    %rax,%rdi
  801c22:	48 b8 42 05 80 00 00 	movabs $0x800542,%rax
  801c29:	00 00 00 
  801c2c:	ff d0                	callq  *%rax
	return r;
  801c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  801c31:	c9                   	leaveq 
  801c32:	c3                   	retq   

0000000000801c33 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801c33:	55                   	push   %rbp
  801c34:	48 89 e5             	mov    %rsp,%rbp
  801c37:	48 83 ec 30          	sub    $0x30,%rsp
  801c3b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c3f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c43:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  801c47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c4b:	8b 50 0c             	mov    0xc(%rax),%edx
  801c4e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801c55:	00 00 00 
  801c58:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  801c5a:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801c61:	00 
  801c62:	76 08                	jbe    801c6c <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  801c64:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  801c6b:	00 
	fsipcbuf.write.req_n=n;
  801c6c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801c73:	00 00 00 
  801c76:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801c7a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  801c7e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801c82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c86:	48 89 c6             	mov    %rax,%rsi
  801c89:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  801c90:	00 00 00 
  801c93:	48 b8 42 05 80 00 00 	movabs $0x800542,%rax
  801c9a:	00 00 00 
  801c9d:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  801c9f:	be 00 00 00 00       	mov    $0x0,%esi
  801ca4:	bf 04 00 00 00       	mov    $0x4,%edi
  801ca9:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  801cb0:	00 00 00 
  801cb3:	ff d0                	callq  *%rax
  801cb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  801cb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801cbb:	c9                   	leaveq 
  801cbc:	c3                   	retq   

0000000000801cbd <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  801cbd:	55                   	push   %rbp
  801cbe:	48 89 e5             	mov    %rsp,%rbp
  801cc1:	48 83 ec 10          	sub    $0x10,%rsp
  801cc5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cc9:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ccc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd0:	8b 50 0c             	mov    0xc(%rax),%edx
  801cd3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801cda:	00 00 00 
  801cdd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  801cdf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801ce6:	00 00 00 
  801ce9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801cec:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cef:	be 00 00 00 00       	mov    $0x0,%esi
  801cf4:	bf 02 00 00 00       	mov    $0x2,%edi
  801cf9:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  801d00:	00 00 00 
  801d03:	ff d0                	callq  *%rax
}
  801d05:	c9                   	leaveq 
  801d06:	c3                   	retq   

0000000000801d07 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801d07:	55                   	push   %rbp
  801d08:	48 89 e5             	mov    %rsp,%rbp
  801d0b:	48 83 ec 20          	sub    $0x20,%rsp
  801d0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d1b:	8b 50 0c             	mov    0xc(%rax),%edx
  801d1e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801d25:	00 00 00 
  801d28:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d2a:	be 00 00 00 00       	mov    $0x0,%esi
  801d2f:	bf 05 00 00 00       	mov    $0x5,%edi
  801d34:	48 b8 10 1a 80 00 00 	movabs $0x801a10,%rax
  801d3b:	00 00 00 
  801d3e:	ff d0                	callq  *%rax
  801d40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d47:	79 05                	jns    801d4e <devfile_stat+0x47>
		return r;
  801d49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d4c:	eb 56                	jmp    801da4 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d52:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801d59:	00 00 00 
  801d5c:	48 89 c7             	mov    %rax,%rdi
  801d5f:	48 b8 20 02 80 00 00 	movabs $0x800220,%rax
  801d66:	00 00 00 
  801d69:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801d6b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801d72:	00 00 00 
  801d75:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801d7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d7f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d85:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801d8c:	00 00 00 
  801d8f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801d95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d99:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801d9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da4:	c9                   	leaveq 
  801da5:	c3                   	retq   
	...

0000000000801da8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801da8:	55                   	push   %rbp
  801da9:	48 89 e5             	mov    %rsp,%rbp
  801dac:	48 83 ec 20          	sub    $0x20,%rsp
  801db0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801db3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801db7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dba:	48 89 d6             	mov    %rdx,%rsi
  801dbd:	89 c7                	mov    %eax,%edi
  801dbf:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  801dc6:	00 00 00 
  801dc9:	ff d0                	callq  *%rax
  801dcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dd2:	79 05                	jns    801dd9 <fd2sockid+0x31>
		return r;
  801dd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd7:	eb 24                	jmp    801dfd <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  801dd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ddd:	8b 10                	mov    (%rax),%edx
  801ddf:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  801de6:	00 00 00 
  801de9:	8b 00                	mov    (%rax),%eax
  801deb:	39 c2                	cmp    %eax,%edx
  801ded:	74 07                	je     801df6 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  801def:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801df4:	eb 07                	jmp    801dfd <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  801df6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dfa:	8b 40 0c             	mov    0xc(%rax),%eax
}
  801dfd:	c9                   	leaveq 
  801dfe:	c3                   	retq   

0000000000801dff <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801dff:	55                   	push   %rbp
  801e00:	48 89 e5             	mov    %rsp,%rbp
  801e03:	48 83 ec 20          	sub    $0x20,%rsp
  801e07:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801e0a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801e0e:	48 89 c7             	mov    %rax,%rdi
  801e11:	48 b8 ee 10 80 00 00 	movabs $0x8010ee,%rax
  801e18:	00 00 00 
  801e1b:	ff d0                	callq  *%rax
  801e1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e24:	78 26                	js     801e4c <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e2a:	ba 07 04 00 00       	mov    $0x407,%edx
  801e2f:	48 89 c6             	mov    %rax,%rsi
  801e32:	bf 00 00 00 00       	mov    $0x0,%edi
  801e37:	48 b8 58 0b 80 00 00 	movabs $0x800b58,%rax
  801e3e:	00 00 00 
  801e41:	ff d0                	callq  *%rax
  801e43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e4a:	79 16                	jns    801e62 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  801e4c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e4f:	89 c7                	mov    %eax,%edi
  801e51:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  801e58:	00 00 00 
  801e5b:	ff d0                	callq  *%rax
		return r;
  801e5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e60:	eb 3a                	jmp    801e9c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801e62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e66:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  801e6d:	00 00 00 
  801e70:	8b 12                	mov    (%rdx),%edx
  801e72:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  801e74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e78:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  801e7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e83:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e86:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  801e89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e8d:	48 89 c7             	mov    %rax,%rdi
  801e90:	48 b8 a0 10 80 00 00 	movabs $0x8010a0,%rax
  801e97:	00 00 00 
  801e9a:	ff d0                	callq  *%rax
}
  801e9c:	c9                   	leaveq 
  801e9d:	c3                   	retq   

0000000000801e9e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e9e:	55                   	push   %rbp
  801e9f:	48 89 e5             	mov    %rsp,%rbp
  801ea2:	48 83 ec 30          	sub    $0x30,%rsp
  801ea6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ea9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ead:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eb1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801eb4:	89 c7                	mov    %eax,%edi
  801eb6:	48 b8 a8 1d 80 00 00 	movabs $0x801da8,%rax
  801ebd:	00 00 00 
  801ec0:	ff d0                	callq  *%rax
  801ec2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ec5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ec9:	79 05                	jns    801ed0 <accept+0x32>
		return r;
  801ecb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ece:	eb 3b                	jmp    801f0b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ed0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ed4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801ed8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801edb:	48 89 ce             	mov    %rcx,%rsi
  801ede:	89 c7                	mov    %eax,%edi
  801ee0:	48 b8 e9 21 80 00 00 	movabs $0x8021e9,%rax
  801ee7:	00 00 00 
  801eea:	ff d0                	callq  *%rax
  801eec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ef3:	79 05                	jns    801efa <accept+0x5c>
		return r;
  801ef5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef8:	eb 11                	jmp    801f0b <accept+0x6d>
	return alloc_sockfd(r);
  801efa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801efd:	89 c7                	mov    %eax,%edi
  801eff:	48 b8 ff 1d 80 00 00 	movabs $0x801dff,%rax
  801f06:	00 00 00 
  801f09:	ff d0                	callq  *%rax
}
  801f0b:	c9                   	leaveq 
  801f0c:	c3                   	retq   

0000000000801f0d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f0d:	55                   	push   %rbp
  801f0e:	48 89 e5             	mov    %rsp,%rbp
  801f11:	48 83 ec 20          	sub    $0x20,%rsp
  801f15:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f18:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f1c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f1f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f22:	89 c7                	mov    %eax,%edi
  801f24:	48 b8 a8 1d 80 00 00 	movabs $0x801da8,%rax
  801f2b:	00 00 00 
  801f2e:	ff d0                	callq  *%rax
  801f30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f37:	79 05                	jns    801f3e <bind+0x31>
		return r;
  801f39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f3c:	eb 1b                	jmp    801f59 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  801f3e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f41:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801f45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f48:	48 89 ce             	mov    %rcx,%rsi
  801f4b:	89 c7                	mov    %eax,%edi
  801f4d:	48 b8 68 22 80 00 00 	movabs $0x802268,%rax
  801f54:	00 00 00 
  801f57:	ff d0                	callq  *%rax
}
  801f59:	c9                   	leaveq 
  801f5a:	c3                   	retq   

0000000000801f5b <shutdown>:

int
shutdown(int s, int how)
{
  801f5b:	55                   	push   %rbp
  801f5c:	48 89 e5             	mov    %rsp,%rbp
  801f5f:	48 83 ec 20          	sub    $0x20,%rsp
  801f63:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f66:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f6c:	89 c7                	mov    %eax,%edi
  801f6e:	48 b8 a8 1d 80 00 00 	movabs $0x801da8,%rax
  801f75:	00 00 00 
  801f78:	ff d0                	callq  *%rax
  801f7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f81:	79 05                	jns    801f88 <shutdown+0x2d>
		return r;
  801f83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f86:	eb 16                	jmp    801f9e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  801f88:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f8e:	89 d6                	mov    %edx,%esi
  801f90:	89 c7                	mov    %eax,%edi
  801f92:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  801f99:	00 00 00 
  801f9c:	ff d0                	callq  *%rax
}
  801f9e:	c9                   	leaveq 
  801f9f:	c3                   	retq   

0000000000801fa0 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  801fa0:	55                   	push   %rbp
  801fa1:	48 89 e5             	mov    %rsp,%rbp
  801fa4:	48 83 ec 10          	sub    $0x10,%rsp
  801fa8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  801fac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb0:	48 89 c7             	mov    %rax,%rdi
  801fb3:	48 b8 bc 3b 80 00 00 	movabs $0x803bbc,%rax
  801fba:	00 00 00 
  801fbd:	ff d0                	callq  *%rax
  801fbf:	83 f8 01             	cmp    $0x1,%eax
  801fc2:	75 17                	jne    801fdb <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  801fc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc8:	8b 40 0c             	mov    0xc(%rax),%eax
  801fcb:	89 c7                	mov    %eax,%edi
  801fcd:	48 b8 0c 23 80 00 00 	movabs $0x80230c,%rax
  801fd4:	00 00 00 
  801fd7:	ff d0                	callq  *%rax
  801fd9:	eb 05                	jmp    801fe0 <devsock_close+0x40>
	else
		return 0;
  801fdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe0:	c9                   	leaveq 
  801fe1:	c3                   	retq   

0000000000801fe2 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fe2:	55                   	push   %rbp
  801fe3:	48 89 e5             	mov    %rsp,%rbp
  801fe6:	48 83 ec 20          	sub    $0x20,%rsp
  801fea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ff1:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ff4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ff7:	89 c7                	mov    %eax,%edi
  801ff9:	48 b8 a8 1d 80 00 00 	movabs $0x801da8,%rax
  802000:	00 00 00 
  802003:	ff d0                	callq  *%rax
  802005:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802008:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80200c:	79 05                	jns    802013 <connect+0x31>
		return r;
  80200e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802011:	eb 1b                	jmp    80202e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802013:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802016:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80201a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80201d:	48 89 ce             	mov    %rcx,%rsi
  802020:	89 c7                	mov    %eax,%edi
  802022:	48 b8 39 23 80 00 00 	movabs $0x802339,%rax
  802029:	00 00 00 
  80202c:	ff d0                	callq  *%rax
}
  80202e:	c9                   	leaveq 
  80202f:	c3                   	retq   

0000000000802030 <listen>:

int
listen(int s, int backlog)
{
  802030:	55                   	push   %rbp
  802031:	48 89 e5             	mov    %rsp,%rbp
  802034:	48 83 ec 20          	sub    $0x20,%rsp
  802038:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80203b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80203e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802041:	89 c7                	mov    %eax,%edi
  802043:	48 b8 a8 1d 80 00 00 	movabs $0x801da8,%rax
  80204a:	00 00 00 
  80204d:	ff d0                	callq  *%rax
  80204f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802052:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802056:	79 05                	jns    80205d <listen+0x2d>
		return r;
  802058:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80205b:	eb 16                	jmp    802073 <listen+0x43>
	return nsipc_listen(r, backlog);
  80205d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802060:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802063:	89 d6                	mov    %edx,%esi
  802065:	89 c7                	mov    %eax,%edi
  802067:	48 b8 9d 23 80 00 00 	movabs $0x80239d,%rax
  80206e:	00 00 00 
  802071:	ff d0                	callq  *%rax
}
  802073:	c9                   	leaveq 
  802074:	c3                   	retq   

0000000000802075 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802075:	55                   	push   %rbp
  802076:	48 89 e5             	mov    %rsp,%rbp
  802079:	48 83 ec 20          	sub    $0x20,%rsp
  80207d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802081:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802085:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802089:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208d:	89 c2                	mov    %eax,%edx
  80208f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802093:	8b 40 0c             	mov    0xc(%rax),%eax
  802096:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80209a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80209f:	89 c7                	mov    %eax,%edi
  8020a1:	48 b8 dd 23 80 00 00 	movabs $0x8023dd,%rax
  8020a8:	00 00 00 
  8020ab:	ff d0                	callq  *%rax
}
  8020ad:	c9                   	leaveq 
  8020ae:	c3                   	retq   

00000000008020af <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8020af:	55                   	push   %rbp
  8020b0:	48 89 e5             	mov    %rsp,%rbp
  8020b3:	48 83 ec 20          	sub    $0x20,%rsp
  8020b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020bf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c7:	89 c2                	mov    %eax,%edx
  8020c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020cd:	8b 40 0c             	mov    0xc(%rax),%eax
  8020d0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8020d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020d9:	89 c7                	mov    %eax,%edi
  8020db:	48 b8 a9 24 80 00 00 	movabs $0x8024a9,%rax
  8020e2:	00 00 00 
  8020e5:	ff d0                	callq  *%rax
}
  8020e7:	c9                   	leaveq 
  8020e8:	c3                   	retq   

00000000008020e9 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8020e9:	55                   	push   %rbp
  8020ea:	48 89 e5             	mov    %rsp,%rbp
  8020ed:	48 83 ec 10          	sub    $0x10,%rsp
  8020f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8020f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020fd:	48 be eb 40 80 00 00 	movabs $0x8040eb,%rsi
  802104:	00 00 00 
  802107:	48 89 c7             	mov    %rax,%rdi
  80210a:	48 b8 20 02 80 00 00 	movabs $0x800220,%rax
  802111:	00 00 00 
  802114:	ff d0                	callq  *%rax
	return 0;
  802116:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211b:	c9                   	leaveq 
  80211c:	c3                   	retq   

000000000080211d <socket>:

int
socket(int domain, int type, int protocol)
{
  80211d:	55                   	push   %rbp
  80211e:	48 89 e5             	mov    %rsp,%rbp
  802121:	48 83 ec 20          	sub    $0x20,%rsp
  802125:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802128:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80212b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80212e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802131:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802134:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802137:	89 ce                	mov    %ecx,%esi
  802139:	89 c7                	mov    %eax,%edi
  80213b:	48 b8 61 25 80 00 00 	movabs $0x802561,%rax
  802142:	00 00 00 
  802145:	ff d0                	callq  *%rax
  802147:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80214a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80214e:	79 05                	jns    802155 <socket+0x38>
		return r;
  802150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802153:	eb 11                	jmp    802166 <socket+0x49>
	return alloc_sockfd(r);
  802155:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802158:	89 c7                	mov    %eax,%edi
  80215a:	48 b8 ff 1d 80 00 00 	movabs $0x801dff,%rax
  802161:	00 00 00 
  802164:	ff d0                	callq  *%rax
}
  802166:	c9                   	leaveq 
  802167:	c3                   	retq   

0000000000802168 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802168:	55                   	push   %rbp
  802169:	48 89 e5             	mov    %rsp,%rbp
  80216c:	48 83 ec 10          	sub    $0x10,%rsp
  802170:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802173:	48 b8 28 70 80 00 00 	movabs $0x807028,%rax
  80217a:	00 00 00 
  80217d:	8b 00                	mov    (%rax),%eax
  80217f:	85 c0                	test   %eax,%eax
  802181:	75 1d                	jne    8021a0 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802183:	bf 02 00 00 00       	mov    $0x2,%edi
  802188:	48 b8 1b 10 80 00 00 	movabs $0x80101b,%rax
  80218f:	00 00 00 
  802192:	ff d0                	callq  *%rax
  802194:	48 ba 28 70 80 00 00 	movabs $0x807028,%rdx
  80219b:	00 00 00 
  80219e:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021a0:	48 b8 28 70 80 00 00 	movabs $0x807028,%rax
  8021a7:	00 00 00 
  8021aa:	8b 00                	mov    (%rax),%eax
  8021ac:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8021af:	b9 07 00 00 00       	mov    $0x7,%ecx
  8021b4:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8021bb:	00 00 00 
  8021be:	89 c7                	mov    %eax,%edi
  8021c0:	48 b8 58 0f 80 00 00 	movabs $0x800f58,%rax
  8021c7:	00 00 00 
  8021ca:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8021cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d1:	be 00 00 00 00       	mov    $0x0,%esi
  8021d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8021db:	48 b8 98 0e 80 00 00 	movabs $0x800e98,%rax
  8021e2:	00 00 00 
  8021e5:	ff d0                	callq  *%rax
}
  8021e7:	c9                   	leaveq 
  8021e8:	c3                   	retq   

00000000008021e9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021e9:	55                   	push   %rbp
  8021ea:	48 89 e5             	mov    %rsp,%rbp
  8021ed:	48 83 ec 30          	sub    $0x30,%rsp
  8021f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8021fc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802203:	00 00 00 
  802206:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802209:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80220b:	bf 01 00 00 00       	mov    $0x1,%edi
  802210:	48 b8 68 21 80 00 00 	movabs $0x802168,%rax
  802217:	00 00 00 
  80221a:	ff d0                	callq  *%rax
  80221c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80221f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802223:	78 3e                	js     802263 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802225:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80222c:	00 00 00 
  80222f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802233:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802237:	8b 40 10             	mov    0x10(%rax),%eax
  80223a:	89 c2                	mov    %eax,%edx
  80223c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802240:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802244:	48 89 ce             	mov    %rcx,%rsi
  802247:	48 89 c7             	mov    %rax,%rdi
  80224a:	48 b8 42 05 80 00 00 	movabs $0x800542,%rax
  802251:	00 00 00 
  802254:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802256:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225a:	8b 50 10             	mov    0x10(%rax),%edx
  80225d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802261:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802263:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802266:	c9                   	leaveq 
  802267:	c3                   	retq   

0000000000802268 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802268:	55                   	push   %rbp
  802269:	48 89 e5             	mov    %rsp,%rbp
  80226c:	48 83 ec 10          	sub    $0x10,%rsp
  802270:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802273:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802277:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80227a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802281:	00 00 00 
  802284:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802287:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802289:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80228c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802290:	48 89 c6             	mov    %rax,%rsi
  802293:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80229a:	00 00 00 
  80229d:	48 b8 42 05 80 00 00 	movabs $0x800542,%rax
  8022a4:	00 00 00 
  8022a7:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8022a9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8022b0:	00 00 00 
  8022b3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8022b6:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8022b9:	bf 02 00 00 00       	mov    $0x2,%edi
  8022be:	48 b8 68 21 80 00 00 	movabs $0x802168,%rax
  8022c5:	00 00 00 
  8022c8:	ff d0                	callq  *%rax
}
  8022ca:	c9                   	leaveq 
  8022cb:	c3                   	retq   

00000000008022cc <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022cc:	55                   	push   %rbp
  8022cd:	48 89 e5             	mov    %rsp,%rbp
  8022d0:	48 83 ec 10          	sub    $0x10,%rsp
  8022d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022d7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8022da:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8022e1:	00 00 00 
  8022e4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022e7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8022e9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8022f0:	00 00 00 
  8022f3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8022f6:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8022f9:	bf 03 00 00 00       	mov    $0x3,%edi
  8022fe:	48 b8 68 21 80 00 00 	movabs $0x802168,%rax
  802305:	00 00 00 
  802308:	ff d0                	callq  *%rax
}
  80230a:	c9                   	leaveq 
  80230b:	c3                   	retq   

000000000080230c <nsipc_close>:

int
nsipc_close(int s)
{
  80230c:	55                   	push   %rbp
  80230d:	48 89 e5             	mov    %rsp,%rbp
  802310:	48 83 ec 10          	sub    $0x10,%rsp
  802314:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802317:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80231e:	00 00 00 
  802321:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802324:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802326:	bf 04 00 00 00       	mov    $0x4,%edi
  80232b:	48 b8 68 21 80 00 00 	movabs $0x802168,%rax
  802332:	00 00 00 
  802335:	ff d0                	callq  *%rax
}
  802337:	c9                   	leaveq 
  802338:	c3                   	retq   

0000000000802339 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802339:	55                   	push   %rbp
  80233a:	48 89 e5             	mov    %rsp,%rbp
  80233d:	48 83 ec 10          	sub    $0x10,%rsp
  802341:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802344:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802348:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80234b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802352:	00 00 00 
  802355:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802358:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80235a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80235d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802361:	48 89 c6             	mov    %rax,%rsi
  802364:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80236b:	00 00 00 
  80236e:	48 b8 42 05 80 00 00 	movabs $0x800542,%rax
  802375:	00 00 00 
  802378:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80237a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802381:	00 00 00 
  802384:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802387:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80238a:	bf 05 00 00 00       	mov    $0x5,%edi
  80238f:	48 b8 68 21 80 00 00 	movabs $0x802168,%rax
  802396:	00 00 00 
  802399:	ff d0                	callq  *%rax
}
  80239b:	c9                   	leaveq 
  80239c:	c3                   	retq   

000000000080239d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80239d:	55                   	push   %rbp
  80239e:	48 89 e5             	mov    %rsp,%rbp
  8023a1:	48 83 ec 10          	sub    $0x10,%rsp
  8023a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023a8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8023ab:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8023b2:	00 00 00 
  8023b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023b8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8023ba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8023c1:	00 00 00 
  8023c4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8023c7:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8023ca:	bf 06 00 00 00       	mov    $0x6,%edi
  8023cf:	48 b8 68 21 80 00 00 	movabs $0x802168,%rax
  8023d6:	00 00 00 
  8023d9:	ff d0                	callq  *%rax
}
  8023db:	c9                   	leaveq 
  8023dc:	c3                   	retq   

00000000008023dd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023dd:	55                   	push   %rbp
  8023de:	48 89 e5             	mov    %rsp,%rbp
  8023e1:	48 83 ec 30          	sub    $0x30,%rsp
  8023e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023ec:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8023ef:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8023f2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8023f9:	00 00 00 
  8023fc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8023ff:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  802401:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802408:	00 00 00 
  80240b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80240e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  802411:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802418:	00 00 00 
  80241b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80241e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802421:	bf 07 00 00 00       	mov    $0x7,%edi
  802426:	48 b8 68 21 80 00 00 	movabs $0x802168,%rax
  80242d:	00 00 00 
  802430:	ff d0                	callq  *%rax
  802432:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802435:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802439:	78 69                	js     8024a4 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80243b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  802442:	7f 08                	jg     80244c <nsipc_recv+0x6f>
  802444:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802447:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80244a:	7e 35                	jle    802481 <nsipc_recv+0xa4>
  80244c:	48 b9 f2 40 80 00 00 	movabs $0x8040f2,%rcx
  802453:	00 00 00 
  802456:	48 ba 07 41 80 00 00 	movabs $0x804107,%rdx
  80245d:	00 00 00 
  802460:	be 61 00 00 00       	mov    $0x61,%esi
  802465:	48 bf 1c 41 80 00 00 	movabs $0x80411c,%rdi
  80246c:	00 00 00 
  80246f:	b8 00 00 00 00       	mov    $0x0,%eax
  802474:	49 b8 30 2e 80 00 00 	movabs $0x802e30,%r8
  80247b:	00 00 00 
  80247e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802481:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802484:	48 63 d0             	movslq %eax,%rdx
  802487:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80248b:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802492:	00 00 00 
  802495:	48 89 c7             	mov    %rax,%rdi
  802498:	48 b8 42 05 80 00 00 	movabs $0x800542,%rax
  80249f:	00 00 00 
  8024a2:	ff d0                	callq  *%rax
	}

	return r;
  8024a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024a7:	c9                   	leaveq 
  8024a8:	c3                   	retq   

00000000008024a9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8024a9:	55                   	push   %rbp
  8024aa:	48 89 e5             	mov    %rsp,%rbp
  8024ad:	48 83 ec 20          	sub    $0x20,%rsp
  8024b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8024b8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8024bb:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8024be:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8024c5:	00 00 00 
  8024c8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024cb:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8024cd:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8024d4:	7e 35                	jle    80250b <nsipc_send+0x62>
  8024d6:	48 b9 28 41 80 00 00 	movabs $0x804128,%rcx
  8024dd:	00 00 00 
  8024e0:	48 ba 07 41 80 00 00 	movabs $0x804107,%rdx
  8024e7:	00 00 00 
  8024ea:	be 6c 00 00 00       	mov    $0x6c,%esi
  8024ef:	48 bf 1c 41 80 00 00 	movabs $0x80411c,%rdi
  8024f6:	00 00 00 
  8024f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fe:	49 b8 30 2e 80 00 00 	movabs $0x802e30,%r8
  802505:	00 00 00 
  802508:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80250b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80250e:	48 63 d0             	movslq %eax,%rdx
  802511:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802515:	48 89 c6             	mov    %rax,%rsi
  802518:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80251f:	00 00 00 
  802522:	48 b8 42 05 80 00 00 	movabs $0x800542,%rax
  802529:	00 00 00 
  80252c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80252e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802535:	00 00 00 
  802538:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80253b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80253e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802545:	00 00 00 
  802548:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80254b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80254e:	bf 08 00 00 00       	mov    $0x8,%edi
  802553:	48 b8 68 21 80 00 00 	movabs $0x802168,%rax
  80255a:	00 00 00 
  80255d:	ff d0                	callq  *%rax
}
  80255f:	c9                   	leaveq 
  802560:	c3                   	retq   

0000000000802561 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802561:	55                   	push   %rbp
  802562:	48 89 e5             	mov    %rsp,%rbp
  802565:	48 83 ec 10          	sub    $0x10,%rsp
  802569:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80256c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80256f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  802572:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802579:	00 00 00 
  80257c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80257f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  802581:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802588:	00 00 00 
  80258b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80258e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  802591:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802598:	00 00 00 
  80259b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80259e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8025a1:	bf 09 00 00 00       	mov    $0x9,%edi
  8025a6:	48 b8 68 21 80 00 00 	movabs $0x802168,%rax
  8025ad:	00 00 00 
  8025b0:	ff d0                	callq  *%rax
}
  8025b2:	c9                   	leaveq 
  8025b3:	c3                   	retq   

00000000008025b4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025b4:	55                   	push   %rbp
  8025b5:	48 89 e5             	mov    %rsp,%rbp
  8025b8:	53                   	push   %rbx
  8025b9:	48 83 ec 38          	sub    $0x38,%rsp
  8025bd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8025c1:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8025c5:	48 89 c7             	mov    %rax,%rdi
  8025c8:	48 b8 ee 10 80 00 00 	movabs $0x8010ee,%rax
  8025cf:	00 00 00 
  8025d2:	ff d0                	callq  *%rax
  8025d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8025d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025db:	0f 88 bf 01 00 00    	js     8027a0 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025e5:	ba 07 04 00 00       	mov    $0x407,%edx
  8025ea:	48 89 c6             	mov    %rax,%rsi
  8025ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8025f2:	48 b8 58 0b 80 00 00 	movabs $0x800b58,%rax
  8025f9:	00 00 00 
  8025fc:	ff d0                	callq  *%rax
  8025fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802601:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802605:	0f 88 95 01 00 00    	js     8027a0 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80260b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80260f:	48 89 c7             	mov    %rax,%rdi
  802612:	48 b8 ee 10 80 00 00 	movabs $0x8010ee,%rax
  802619:	00 00 00 
  80261c:	ff d0                	callq  *%rax
  80261e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802621:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802625:	0f 88 5d 01 00 00    	js     802788 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80262b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80262f:	ba 07 04 00 00       	mov    $0x407,%edx
  802634:	48 89 c6             	mov    %rax,%rsi
  802637:	bf 00 00 00 00       	mov    $0x0,%edi
  80263c:	48 b8 58 0b 80 00 00 	movabs $0x800b58,%rax
  802643:	00 00 00 
  802646:	ff d0                	callq  *%rax
  802648:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80264b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80264f:	0f 88 33 01 00 00    	js     802788 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802655:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802659:	48 89 c7             	mov    %rax,%rdi
  80265c:	48 b8 c3 10 80 00 00 	movabs $0x8010c3,%rax
  802663:	00 00 00 
  802666:	ff d0                	callq  *%rax
  802668:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80266c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802670:	ba 07 04 00 00       	mov    $0x407,%edx
  802675:	48 89 c6             	mov    %rax,%rsi
  802678:	bf 00 00 00 00       	mov    $0x0,%edi
  80267d:	48 b8 58 0b 80 00 00 	movabs $0x800b58,%rax
  802684:	00 00 00 
  802687:	ff d0                	callq  *%rax
  802689:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80268c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802690:	0f 88 d9 00 00 00    	js     80276f <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802696:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80269a:	48 89 c7             	mov    %rax,%rdi
  80269d:	48 b8 c3 10 80 00 00 	movabs $0x8010c3,%rax
  8026a4:	00 00 00 
  8026a7:	ff d0                	callq  *%rax
  8026a9:	48 89 c2             	mov    %rax,%rdx
  8026ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026b0:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8026b6:	48 89 d1             	mov    %rdx,%rcx
  8026b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026be:	48 89 c6             	mov    %rax,%rsi
  8026c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c6:	48 b8 a8 0b 80 00 00 	movabs $0x800ba8,%rax
  8026cd:	00 00 00 
  8026d0:	ff d0                	callq  *%rax
  8026d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8026d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026d9:	78 79                	js     802754 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8026db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026df:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8026e6:	00 00 00 
  8026e9:	8b 12                	mov    (%rdx),%edx
  8026eb:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8026ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8026f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026fc:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802703:	00 00 00 
  802706:	8b 12                	mov    (%rdx),%edx
  802708:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80270a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80270e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802715:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802719:	48 89 c7             	mov    %rax,%rdi
  80271c:	48 b8 a0 10 80 00 00 	movabs $0x8010a0,%rax
  802723:	00 00 00 
  802726:	ff d0                	callq  *%rax
  802728:	89 c2                	mov    %eax,%edx
  80272a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80272e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802730:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802734:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802738:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80273c:	48 89 c7             	mov    %rax,%rdi
  80273f:	48 b8 a0 10 80 00 00 	movabs $0x8010a0,%rax
  802746:	00 00 00 
  802749:	ff d0                	callq  *%rax
  80274b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80274d:	b8 00 00 00 00       	mov    $0x0,%eax
  802752:	eb 4f                	jmp    8027a3 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  802754:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802755:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802759:	48 89 c6             	mov    %rax,%rsi
  80275c:	bf 00 00 00 00       	mov    $0x0,%edi
  802761:	48 b8 03 0c 80 00 00 	movabs $0x800c03,%rax
  802768:	00 00 00 
  80276b:	ff d0                	callq  *%rax
  80276d:	eb 01                	jmp    802770 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80276f:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802770:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802774:	48 89 c6             	mov    %rax,%rsi
  802777:	bf 00 00 00 00       	mov    $0x0,%edi
  80277c:	48 b8 03 0c 80 00 00 	movabs $0x800c03,%rax
  802783:	00 00 00 
  802786:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80278c:	48 89 c6             	mov    %rax,%rsi
  80278f:	bf 00 00 00 00       	mov    $0x0,%edi
  802794:	48 b8 03 0c 80 00 00 	movabs $0x800c03,%rax
  80279b:	00 00 00 
  80279e:	ff d0                	callq  *%rax
    err:
	return r;
  8027a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8027a3:	48 83 c4 38          	add    $0x38,%rsp
  8027a7:	5b                   	pop    %rbx
  8027a8:	5d                   	pop    %rbp
  8027a9:	c3                   	retq   

00000000008027aa <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8027aa:	55                   	push   %rbp
  8027ab:	48 89 e5             	mov    %rsp,%rbp
  8027ae:	53                   	push   %rbx
  8027af:	48 83 ec 28          	sub    $0x28,%rsp
  8027b3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8027b7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027bb:	eb 01                	jmp    8027be <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8027bd:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8027be:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8027c5:	00 00 00 
  8027c8:	48 8b 00             	mov    (%rax),%rax
  8027cb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8027d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8027d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d8:	48 89 c7             	mov    %rax,%rdi
  8027db:	48 b8 bc 3b 80 00 00 	movabs $0x803bbc,%rax
  8027e2:	00 00 00 
  8027e5:	ff d0                	callq  *%rax
  8027e7:	89 c3                	mov    %eax,%ebx
  8027e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027ed:	48 89 c7             	mov    %rax,%rdi
  8027f0:	48 b8 bc 3b 80 00 00 	movabs $0x803bbc,%rax
  8027f7:	00 00 00 
  8027fa:	ff d0                	callq  *%rax
  8027fc:	39 c3                	cmp    %eax,%ebx
  8027fe:	0f 94 c0             	sete   %al
  802801:	0f b6 c0             	movzbl %al,%eax
  802804:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802807:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80280e:	00 00 00 
  802811:	48 8b 00             	mov    (%rax),%rax
  802814:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80281a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80281d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802820:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802823:	75 0a                	jne    80282f <_pipeisclosed+0x85>
			return ret;
  802825:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  802828:	48 83 c4 28          	add    $0x28,%rsp
  80282c:	5b                   	pop    %rbx
  80282d:	5d                   	pop    %rbp
  80282e:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80282f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802832:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802835:	74 86                	je     8027bd <_pipeisclosed+0x13>
  802837:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80283b:	75 80                	jne    8027bd <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80283d:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802844:	00 00 00 
  802847:	48 8b 00             	mov    (%rax),%rax
  80284a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802850:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802853:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802856:	89 c6                	mov    %eax,%esi
  802858:	48 bf 39 41 80 00 00 	movabs $0x804139,%rdi
  80285f:	00 00 00 
  802862:	b8 00 00 00 00       	mov    $0x0,%eax
  802867:	49 b8 6b 30 80 00 00 	movabs $0x80306b,%r8
  80286e:	00 00 00 
  802871:	41 ff d0             	callq  *%r8
	}
  802874:	e9 44 ff ff ff       	jmpq   8027bd <_pipeisclosed+0x13>

0000000000802879 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  802879:	55                   	push   %rbp
  80287a:	48 89 e5             	mov    %rsp,%rbp
  80287d:	48 83 ec 30          	sub    $0x30,%rsp
  802881:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802884:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802888:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80288b:	48 89 d6             	mov    %rdx,%rsi
  80288e:	89 c7                	mov    %eax,%edi
  802890:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  802897:	00 00 00 
  80289a:	ff d0                	callq  *%rax
  80289c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80289f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a3:	79 05                	jns    8028aa <pipeisclosed+0x31>
		return r;
  8028a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a8:	eb 31                	jmp    8028db <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8028aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ae:	48 89 c7             	mov    %rax,%rdi
  8028b1:	48 b8 c3 10 80 00 00 	movabs $0x8010c3,%rax
  8028b8:	00 00 00 
  8028bb:	ff d0                	callq  *%rax
  8028bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8028c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028c9:	48 89 d6             	mov    %rdx,%rsi
  8028cc:	48 89 c7             	mov    %rax,%rdi
  8028cf:	48 b8 aa 27 80 00 00 	movabs $0x8027aa,%rax
  8028d6:	00 00 00 
  8028d9:	ff d0                	callq  *%rax
}
  8028db:	c9                   	leaveq 
  8028dc:	c3                   	retq   

00000000008028dd <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028dd:	55                   	push   %rbp
  8028de:	48 89 e5             	mov    %rsp,%rbp
  8028e1:	48 83 ec 40          	sub    $0x40,%rsp
  8028e5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8028e9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028ed:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8028f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028f5:	48 89 c7             	mov    %rax,%rdi
  8028f8:	48 b8 c3 10 80 00 00 	movabs $0x8010c3,%rax
  8028ff:	00 00 00 
  802902:	ff d0                	callq  *%rax
  802904:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802908:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80290c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802910:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802917:	00 
  802918:	e9 97 00 00 00       	jmpq   8029b4 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80291d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802922:	74 09                	je     80292d <devpipe_read+0x50>
				return i;
  802924:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802928:	e9 95 00 00 00       	jmpq   8029c2 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80292d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802931:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802935:	48 89 d6             	mov    %rdx,%rsi
  802938:	48 89 c7             	mov    %rax,%rdi
  80293b:	48 b8 aa 27 80 00 00 	movabs $0x8027aa,%rax
  802942:	00 00 00 
  802945:	ff d0                	callq  *%rax
  802947:	85 c0                	test   %eax,%eax
  802949:	74 07                	je     802952 <devpipe_read+0x75>
				return 0;
  80294b:	b8 00 00 00 00       	mov    $0x0,%eax
  802950:	eb 70                	jmp    8029c2 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802952:	48 b8 1a 0b 80 00 00 	movabs $0x800b1a,%rax
  802959:	00 00 00 
  80295c:	ff d0                	callq  *%rax
  80295e:	eb 01                	jmp    802961 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802960:	90                   	nop
  802961:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802965:	8b 10                	mov    (%rax),%edx
  802967:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80296b:	8b 40 04             	mov    0x4(%rax),%eax
  80296e:	39 c2                	cmp    %eax,%edx
  802970:	74 ab                	je     80291d <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802972:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802976:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80297a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80297e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802982:	8b 00                	mov    (%rax),%eax
  802984:	89 c2                	mov    %eax,%edx
  802986:	c1 fa 1f             	sar    $0x1f,%edx
  802989:	c1 ea 1b             	shr    $0x1b,%edx
  80298c:	01 d0                	add    %edx,%eax
  80298e:	83 e0 1f             	and    $0x1f,%eax
  802991:	29 d0                	sub    %edx,%eax
  802993:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802997:	48 98                	cltq   
  802999:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80299e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8029a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a4:	8b 00                	mov    (%rax),%eax
  8029a6:	8d 50 01             	lea    0x1(%rax),%edx
  8029a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ad:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8029af:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8029b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029b8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8029bc:	72 a2                	jb     802960 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8029be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8029c2:	c9                   	leaveq 
  8029c3:	c3                   	retq   

00000000008029c4 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8029c4:	55                   	push   %rbp
  8029c5:	48 89 e5             	mov    %rsp,%rbp
  8029c8:	48 83 ec 40          	sub    $0x40,%rsp
  8029cc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8029d0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029d4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8029d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029dc:	48 89 c7             	mov    %rax,%rdi
  8029df:	48 b8 c3 10 80 00 00 	movabs $0x8010c3,%rax
  8029e6:	00 00 00 
  8029e9:	ff d0                	callq  *%rax
  8029eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8029ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029f3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8029f7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8029fe:	00 
  8029ff:	e9 93 00 00 00       	jmpq   802a97 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802a04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a0c:	48 89 d6             	mov    %rdx,%rsi
  802a0f:	48 89 c7             	mov    %rax,%rdi
  802a12:	48 b8 aa 27 80 00 00 	movabs $0x8027aa,%rax
  802a19:	00 00 00 
  802a1c:	ff d0                	callq  *%rax
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	74 07                	je     802a29 <devpipe_write+0x65>
				return 0;
  802a22:	b8 00 00 00 00       	mov    $0x0,%eax
  802a27:	eb 7c                	jmp    802aa5 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802a29:	48 b8 1a 0b 80 00 00 	movabs $0x800b1a,%rax
  802a30:	00 00 00 
  802a33:	ff d0                	callq  *%rax
  802a35:	eb 01                	jmp    802a38 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a37:	90                   	nop
  802a38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a3c:	8b 40 04             	mov    0x4(%rax),%eax
  802a3f:	48 63 d0             	movslq %eax,%rdx
  802a42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a46:	8b 00                	mov    (%rax),%eax
  802a48:	48 98                	cltq   
  802a4a:	48 83 c0 20          	add    $0x20,%rax
  802a4e:	48 39 c2             	cmp    %rax,%rdx
  802a51:	73 b1                	jae    802a04 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a57:	8b 40 04             	mov    0x4(%rax),%eax
  802a5a:	89 c2                	mov    %eax,%edx
  802a5c:	c1 fa 1f             	sar    $0x1f,%edx
  802a5f:	c1 ea 1b             	shr    $0x1b,%edx
  802a62:	01 d0                	add    %edx,%eax
  802a64:	83 e0 1f             	and    $0x1f,%eax
  802a67:	29 d0                	sub    %edx,%eax
  802a69:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a6d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a71:	48 01 ca             	add    %rcx,%rdx
  802a74:	0f b6 0a             	movzbl (%rdx),%ecx
  802a77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a7b:	48 98                	cltq   
  802a7d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802a81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a85:	8b 40 04             	mov    0x4(%rax),%eax
  802a88:	8d 50 01             	lea    0x1(%rax),%edx
  802a8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a8f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a92:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802a97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a9b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802a9f:	72 96                	jb     802a37 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802aa1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802aa5:	c9                   	leaveq 
  802aa6:	c3                   	retq   

0000000000802aa7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802aa7:	55                   	push   %rbp
  802aa8:	48 89 e5             	mov    %rsp,%rbp
  802aab:	48 83 ec 20          	sub    $0x20,%rsp
  802aaf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ab3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802ab7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802abb:	48 89 c7             	mov    %rax,%rdi
  802abe:	48 b8 c3 10 80 00 00 	movabs $0x8010c3,%rax
  802ac5:	00 00 00 
  802ac8:	ff d0                	callq  *%rax
  802aca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802ace:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad2:	48 be 4c 41 80 00 00 	movabs $0x80414c,%rsi
  802ad9:	00 00 00 
  802adc:	48 89 c7             	mov    %rax,%rdi
  802adf:	48 b8 20 02 80 00 00 	movabs $0x800220,%rax
  802ae6:	00 00 00 
  802ae9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aef:	8b 50 04             	mov    0x4(%rax),%edx
  802af2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802af6:	8b 00                	mov    (%rax),%eax
  802af8:	29 c2                	sub    %eax,%edx
  802afa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802afe:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802b04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b08:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b0f:	00 00 00 
	stat->st_dev = &devpipe;
  802b12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b16:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802b1d:	00 00 00 
  802b20:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  802b27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b2c:	c9                   	leaveq 
  802b2d:	c3                   	retq   

0000000000802b2e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802b2e:	55                   	push   %rbp
  802b2f:	48 89 e5             	mov    %rsp,%rbp
  802b32:	48 83 ec 10          	sub    $0x10,%rsp
  802b36:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802b3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b3e:	48 89 c6             	mov    %rax,%rsi
  802b41:	bf 00 00 00 00       	mov    $0x0,%edi
  802b46:	48 b8 03 0c 80 00 00 	movabs $0x800c03,%rax
  802b4d:	00 00 00 
  802b50:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802b52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b56:	48 89 c7             	mov    %rax,%rdi
  802b59:	48 b8 c3 10 80 00 00 	movabs $0x8010c3,%rax
  802b60:	00 00 00 
  802b63:	ff d0                	callq  *%rax
  802b65:	48 89 c6             	mov    %rax,%rsi
  802b68:	bf 00 00 00 00       	mov    $0x0,%edi
  802b6d:	48 b8 03 0c 80 00 00 	movabs $0x800c03,%rax
  802b74:	00 00 00 
  802b77:	ff d0                	callq  *%rax
}
  802b79:	c9                   	leaveq 
  802b7a:	c3                   	retq   
	...

0000000000802b7c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802b7c:	55                   	push   %rbp
  802b7d:	48 89 e5             	mov    %rsp,%rbp
  802b80:	48 83 ec 20          	sub    $0x20,%rsp
  802b84:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802b87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b8a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802b8d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802b91:	be 01 00 00 00       	mov    $0x1,%esi
  802b96:	48 89 c7             	mov    %rax,%rdi
  802b99:	48 b8 10 0a 80 00 00 	movabs $0x800a10,%rax
  802ba0:	00 00 00 
  802ba3:	ff d0                	callq  *%rax
}
  802ba5:	c9                   	leaveq 
  802ba6:	c3                   	retq   

0000000000802ba7 <getchar>:

int
getchar(void)
{
  802ba7:	55                   	push   %rbp
  802ba8:	48 89 e5             	mov    %rsp,%rbp
  802bab:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802baf:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802bb3:	ba 01 00 00 00       	mov    $0x1,%edx
  802bb8:	48 89 c6             	mov    %rax,%rsi
  802bbb:	bf 00 00 00 00       	mov    $0x0,%edi
  802bc0:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  802bc7:	00 00 00 
  802bca:	ff d0                	callq  *%rax
  802bcc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802bcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd3:	79 05                	jns    802bda <getchar+0x33>
		return r;
  802bd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd8:	eb 14                	jmp    802bee <getchar+0x47>
	if (r < 1)
  802bda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bde:	7f 07                	jg     802be7 <getchar+0x40>
		return -E_EOF;
  802be0:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802be5:	eb 07                	jmp    802bee <getchar+0x47>
	return c;
  802be7:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802beb:	0f b6 c0             	movzbl %al,%eax
}
  802bee:	c9                   	leaveq 
  802bef:	c3                   	retq   

0000000000802bf0 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802bf0:	55                   	push   %rbp
  802bf1:	48 89 e5             	mov    %rsp,%rbp
  802bf4:	48 83 ec 20          	sub    $0x20,%rsp
  802bf8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bfb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c02:	48 89 d6             	mov    %rdx,%rsi
  802c05:	89 c7                	mov    %eax,%edi
  802c07:	48 b8 86 11 80 00 00 	movabs $0x801186,%rax
  802c0e:	00 00 00 
  802c11:	ff d0                	callq  *%rax
  802c13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1a:	79 05                	jns    802c21 <iscons+0x31>
		return r;
  802c1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1f:	eb 1a                	jmp    802c3b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802c21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c25:	8b 10                	mov    (%rax),%edx
  802c27:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  802c2e:	00 00 00 
  802c31:	8b 00                	mov    (%rax),%eax
  802c33:	39 c2                	cmp    %eax,%edx
  802c35:	0f 94 c0             	sete   %al
  802c38:	0f b6 c0             	movzbl %al,%eax
}
  802c3b:	c9                   	leaveq 
  802c3c:	c3                   	retq   

0000000000802c3d <opencons>:

int
opencons(void)
{
  802c3d:	55                   	push   %rbp
  802c3e:	48 89 e5             	mov    %rsp,%rbp
  802c41:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802c45:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c49:	48 89 c7             	mov    %rax,%rdi
  802c4c:	48 b8 ee 10 80 00 00 	movabs $0x8010ee,%rax
  802c53:	00 00 00 
  802c56:	ff d0                	callq  *%rax
  802c58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5f:	79 05                	jns    802c66 <opencons+0x29>
		return r;
  802c61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c64:	eb 5b                	jmp    802cc1 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802c66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c6a:	ba 07 04 00 00       	mov    $0x407,%edx
  802c6f:	48 89 c6             	mov    %rax,%rsi
  802c72:	bf 00 00 00 00       	mov    $0x0,%edi
  802c77:	48 b8 58 0b 80 00 00 	movabs $0x800b58,%rax
  802c7e:	00 00 00 
  802c81:	ff d0                	callq  *%rax
  802c83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8a:	79 05                	jns    802c91 <opencons+0x54>
		return r;
  802c8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8f:	eb 30                	jmp    802cc1 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802c91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c95:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  802c9c:	00 00 00 
  802c9f:	8b 12                	mov    (%rdx),%edx
  802ca1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802ca3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802cae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb2:	48 89 c7             	mov    %rax,%rdi
  802cb5:	48 b8 a0 10 80 00 00 	movabs $0x8010a0,%rax
  802cbc:	00 00 00 
  802cbf:	ff d0                	callq  *%rax
}
  802cc1:	c9                   	leaveq 
  802cc2:	c3                   	retq   

0000000000802cc3 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802cc3:	55                   	push   %rbp
  802cc4:	48 89 e5             	mov    %rsp,%rbp
  802cc7:	48 83 ec 30          	sub    $0x30,%rsp
  802ccb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ccf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cd3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802cd7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802cdc:	75 13                	jne    802cf1 <devcons_read+0x2e>
		return 0;
  802cde:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce3:	eb 49                	jmp    802d2e <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802ce5:	48 b8 1a 0b 80 00 00 	movabs $0x800b1a,%rax
  802cec:	00 00 00 
  802cef:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802cf1:	48 b8 5a 0a 80 00 00 	movabs $0x800a5a,%rax
  802cf8:	00 00 00 
  802cfb:	ff d0                	callq  *%rax
  802cfd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d04:	74 df                	je     802ce5 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  802d06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0a:	79 05                	jns    802d11 <devcons_read+0x4e>
		return c;
  802d0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0f:	eb 1d                	jmp    802d2e <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  802d11:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802d15:	75 07                	jne    802d1e <devcons_read+0x5b>
		return 0;
  802d17:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1c:	eb 10                	jmp    802d2e <devcons_read+0x6b>
	*(char*)vbuf = c;
  802d1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d21:	89 c2                	mov    %eax,%edx
  802d23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d27:	88 10                	mov    %dl,(%rax)
	return 1;
  802d29:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802d2e:	c9                   	leaveq 
  802d2f:	c3                   	retq   

0000000000802d30 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802d30:	55                   	push   %rbp
  802d31:	48 89 e5             	mov    %rsp,%rbp
  802d34:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  802d3b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  802d42:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  802d49:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802d50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d57:	eb 77                	jmp    802dd0 <devcons_write+0xa0>
		m = n - tot;
  802d59:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802d60:	89 c2                	mov    %eax,%edx
  802d62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d65:	89 d1                	mov    %edx,%ecx
  802d67:	29 c1                	sub    %eax,%ecx
  802d69:	89 c8                	mov    %ecx,%eax
  802d6b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802d6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d71:	83 f8 7f             	cmp    $0x7f,%eax
  802d74:	76 07                	jbe    802d7d <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  802d76:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802d7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d80:	48 63 d0             	movslq %eax,%rdx
  802d83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d86:	48 98                	cltq   
  802d88:	48 89 c1             	mov    %rax,%rcx
  802d8b:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  802d92:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802d99:	48 89 ce             	mov    %rcx,%rsi
  802d9c:	48 89 c7             	mov    %rax,%rdi
  802d9f:	48 b8 42 05 80 00 00 	movabs $0x800542,%rax
  802da6:	00 00 00 
  802da9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  802dab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dae:	48 63 d0             	movslq %eax,%rdx
  802db1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802db8:	48 89 d6             	mov    %rdx,%rsi
  802dbb:	48 89 c7             	mov    %rax,%rdi
  802dbe:	48 b8 10 0a 80 00 00 	movabs $0x800a10,%rax
  802dc5:	00 00 00 
  802dc8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802dca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dcd:	01 45 fc             	add    %eax,-0x4(%rbp)
  802dd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd3:	48 98                	cltq   
  802dd5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  802ddc:	0f 82 77 ff ff ff    	jb     802d59 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  802de2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802de5:	c9                   	leaveq 
  802de6:	c3                   	retq   

0000000000802de7 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802de7:	55                   	push   %rbp
  802de8:	48 89 e5             	mov    %rsp,%rbp
  802deb:	48 83 ec 08          	sub    $0x8,%rsp
  802def:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  802df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df8:	c9                   	leaveq 
  802df9:	c3                   	retq   

0000000000802dfa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802dfa:	55                   	push   %rbp
  802dfb:	48 89 e5             	mov    %rsp,%rbp
  802dfe:	48 83 ec 10          	sub    $0x10,%rsp
  802e02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  802e0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0e:	48 be 58 41 80 00 00 	movabs $0x804158,%rsi
  802e15:	00 00 00 
  802e18:	48 89 c7             	mov    %rax,%rdi
  802e1b:	48 b8 20 02 80 00 00 	movabs $0x800220,%rax
  802e22:	00 00 00 
  802e25:	ff d0                	callq  *%rax
	return 0;
  802e27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e2c:	c9                   	leaveq 
  802e2d:	c3                   	retq   
	...

0000000000802e30 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802e30:	55                   	push   %rbp
  802e31:	48 89 e5             	mov    %rsp,%rbp
  802e34:	53                   	push   %rbx
  802e35:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802e3c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802e43:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802e49:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802e50:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802e57:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802e5e:	84 c0                	test   %al,%al
  802e60:	74 23                	je     802e85 <_panic+0x55>
  802e62:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802e69:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802e6d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802e71:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802e75:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802e79:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802e7d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802e81:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802e85:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802e8c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802e93:	00 00 00 
  802e96:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802e9d:	00 00 00 
  802ea0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802ea4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802eab:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802eb2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802eb9:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  802ec0:	00 00 00 
  802ec3:	48 8b 18             	mov    (%rax),%rbx
  802ec6:	48 b8 dc 0a 80 00 00 	movabs $0x800adc,%rax
  802ecd:	00 00 00 
  802ed0:	ff d0                	callq  *%rax
  802ed2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  802ed8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802edf:	41 89 c8             	mov    %ecx,%r8d
  802ee2:	48 89 d1             	mov    %rdx,%rcx
  802ee5:	48 89 da             	mov    %rbx,%rdx
  802ee8:	89 c6                	mov    %eax,%esi
  802eea:	48 bf 60 41 80 00 00 	movabs $0x804160,%rdi
  802ef1:	00 00 00 
  802ef4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef9:	49 b9 6b 30 80 00 00 	movabs $0x80306b,%r9
  802f00:	00 00 00 
  802f03:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802f06:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  802f0d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802f14:	48 89 d6             	mov    %rdx,%rsi
  802f17:	48 89 c7             	mov    %rax,%rdi
  802f1a:	48 b8 bf 2f 80 00 00 	movabs $0x802fbf,%rax
  802f21:	00 00 00 
  802f24:	ff d0                	callq  *%rax
	cprintf("\n");
  802f26:	48 bf 83 41 80 00 00 	movabs $0x804183,%rdi
  802f2d:	00 00 00 
  802f30:	b8 00 00 00 00       	mov    $0x0,%eax
  802f35:	48 ba 6b 30 80 00 00 	movabs $0x80306b,%rdx
  802f3c:	00 00 00 
  802f3f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802f41:	cc                   	int3   
  802f42:	eb fd                	jmp    802f41 <_panic+0x111>

0000000000802f44 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  802f44:	55                   	push   %rbp
  802f45:	48 89 e5             	mov    %rsp,%rbp
  802f48:	48 83 ec 10          	sub    $0x10,%rsp
  802f4c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f4f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  802f53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f57:	8b 00                	mov    (%rax),%eax
  802f59:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f5c:	89 d6                	mov    %edx,%esi
  802f5e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802f62:	48 63 d0             	movslq %eax,%rdx
  802f65:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  802f6a:	8d 50 01             	lea    0x1(%rax),%edx
  802f6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f71:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  802f73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f77:	8b 00                	mov    (%rax),%eax
  802f79:	3d ff 00 00 00       	cmp    $0xff,%eax
  802f7e:	75 2c                	jne    802fac <putch+0x68>
		sys_cputs(b->buf, b->idx);
  802f80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f84:	8b 00                	mov    (%rax),%eax
  802f86:	48 98                	cltq   
  802f88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f8c:	48 83 c2 08          	add    $0x8,%rdx
  802f90:	48 89 c6             	mov    %rax,%rsi
  802f93:	48 89 d7             	mov    %rdx,%rdi
  802f96:	48 b8 10 0a 80 00 00 	movabs $0x800a10,%rax
  802f9d:	00 00 00 
  802fa0:	ff d0                	callq  *%rax
		b->idx = 0;
  802fa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  802fac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb0:	8b 40 04             	mov    0x4(%rax),%eax
  802fb3:	8d 50 01             	lea    0x1(%rax),%edx
  802fb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fba:	89 50 04             	mov    %edx,0x4(%rax)
}
  802fbd:	c9                   	leaveq 
  802fbe:	c3                   	retq   

0000000000802fbf <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  802fbf:	55                   	push   %rbp
  802fc0:	48 89 e5             	mov    %rsp,%rbp
  802fc3:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802fca:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  802fd1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  802fd8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  802fdf:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802fe6:	48 8b 0a             	mov    (%rdx),%rcx
  802fe9:	48 89 08             	mov    %rcx,(%rax)
  802fec:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802ff0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802ff4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802ff8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  802ffc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  803003:	00 00 00 
	b.cnt = 0;
  803006:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80300d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  803010:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  803017:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80301e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803025:	48 89 c6             	mov    %rax,%rsi
  803028:	48 bf 44 2f 80 00 00 	movabs $0x802f44,%rdi
  80302f:	00 00 00 
  803032:	48 b8 1c 34 80 00 00 	movabs $0x80341c,%rax
  803039:	00 00 00 
  80303c:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80303e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  803044:	48 98                	cltq   
  803046:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80304d:	48 83 c2 08          	add    $0x8,%rdx
  803051:	48 89 c6             	mov    %rax,%rsi
  803054:	48 89 d7             	mov    %rdx,%rdi
  803057:	48 b8 10 0a 80 00 00 	movabs $0x800a10,%rax
  80305e:	00 00 00 
  803061:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  803063:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  803069:	c9                   	leaveq 
  80306a:	c3                   	retq   

000000000080306b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80306b:	55                   	push   %rbp
  80306c:	48 89 e5             	mov    %rsp,%rbp
  80306f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  803076:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80307d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803084:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80308b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803092:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803099:	84 c0                	test   %al,%al
  80309b:	74 20                	je     8030bd <cprintf+0x52>
  80309d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8030a1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8030a5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8030a9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8030ad:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8030b1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8030b5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8030b9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8030bd:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8030c4:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8030cb:	00 00 00 
  8030ce:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8030d5:	00 00 00 
  8030d8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030dc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8030e3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8030ea:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8030f1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8030f8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8030ff:	48 8b 0a             	mov    (%rdx),%rcx
  803102:	48 89 08             	mov    %rcx,(%rax)
  803105:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803109:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80310d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803111:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  803115:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80311c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803123:	48 89 d6             	mov    %rdx,%rsi
  803126:	48 89 c7             	mov    %rax,%rdi
  803129:	48 b8 bf 2f 80 00 00 	movabs $0x802fbf,%rax
  803130:	00 00 00 
  803133:	ff d0                	callq  *%rax
  803135:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80313b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803141:	c9                   	leaveq 
  803142:	c3                   	retq   
	...

0000000000803144 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  803144:	55                   	push   %rbp
  803145:	48 89 e5             	mov    %rsp,%rbp
  803148:	48 83 ec 30          	sub    $0x30,%rsp
  80314c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803150:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803154:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803158:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80315b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80315f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  803163:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803166:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80316a:	77 52                	ja     8031be <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80316c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80316f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  803173:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803176:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80317a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80317e:	ba 00 00 00 00       	mov    $0x0,%edx
  803183:	48 f7 75 d0          	divq   -0x30(%rbp)
  803187:	48 89 c2             	mov    %rax,%rdx
  80318a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80318d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803190:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803194:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803198:	41 89 f9             	mov    %edi,%r9d
  80319b:	48 89 c7             	mov    %rax,%rdi
  80319e:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  8031a5:	00 00 00 
  8031a8:	ff d0                	callq  *%rax
  8031aa:	eb 1c                	jmp    8031c8 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8031ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031b0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031b3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8031b7:	48 89 d6             	mov    %rdx,%rsi
  8031ba:	89 c7                	mov    %eax,%edi
  8031bc:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8031be:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8031c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8031c6:	7f e4                	jg     8031ac <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8031c8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8031cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8031d4:	48 f7 f1             	div    %rcx
  8031d7:	48 89 d0             	mov    %rdx,%rax
  8031da:	48 ba 68 43 80 00 00 	movabs $0x804368,%rdx
  8031e1:	00 00 00 
  8031e4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8031e8:	0f be c0             	movsbl %al,%eax
  8031eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031ef:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8031f3:	48 89 d6             	mov    %rdx,%rsi
  8031f6:	89 c7                	mov    %eax,%edi
  8031f8:	ff d1                	callq  *%rcx
}
  8031fa:	c9                   	leaveq 
  8031fb:	c3                   	retq   

00000000008031fc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8031fc:	55                   	push   %rbp
  8031fd:	48 89 e5             	mov    %rsp,%rbp
  803200:	48 83 ec 20          	sub    $0x20,%rsp
  803204:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803208:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80320b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80320f:	7e 52                	jle    803263 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  803211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803215:	8b 00                	mov    (%rax),%eax
  803217:	83 f8 30             	cmp    $0x30,%eax
  80321a:	73 24                	jae    803240 <getuint+0x44>
  80321c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803220:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803228:	8b 00                	mov    (%rax),%eax
  80322a:	89 c0                	mov    %eax,%eax
  80322c:	48 01 d0             	add    %rdx,%rax
  80322f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803233:	8b 12                	mov    (%rdx),%edx
  803235:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803238:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80323c:	89 0a                	mov    %ecx,(%rdx)
  80323e:	eb 17                	jmp    803257 <getuint+0x5b>
  803240:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803244:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803248:	48 89 d0             	mov    %rdx,%rax
  80324b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80324f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803253:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803257:	48 8b 00             	mov    (%rax),%rax
  80325a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80325e:	e9 a3 00 00 00       	jmpq   803306 <getuint+0x10a>
	else if (lflag)
  803263:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803267:	74 4f                	je     8032b8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  803269:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80326d:	8b 00                	mov    (%rax),%eax
  80326f:	83 f8 30             	cmp    $0x30,%eax
  803272:	73 24                	jae    803298 <getuint+0x9c>
  803274:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803278:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80327c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803280:	8b 00                	mov    (%rax),%eax
  803282:	89 c0                	mov    %eax,%eax
  803284:	48 01 d0             	add    %rdx,%rax
  803287:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80328b:	8b 12                	mov    (%rdx),%edx
  80328d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803290:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803294:	89 0a                	mov    %ecx,(%rdx)
  803296:	eb 17                	jmp    8032af <getuint+0xb3>
  803298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80329c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8032a0:	48 89 d0             	mov    %rdx,%rax
  8032a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8032a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8032af:	48 8b 00             	mov    (%rax),%rax
  8032b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8032b6:	eb 4e                	jmp    803306 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8032b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032bc:	8b 00                	mov    (%rax),%eax
  8032be:	83 f8 30             	cmp    $0x30,%eax
  8032c1:	73 24                	jae    8032e7 <getuint+0xeb>
  8032c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8032cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032cf:	8b 00                	mov    (%rax),%eax
  8032d1:	89 c0                	mov    %eax,%eax
  8032d3:	48 01 d0             	add    %rdx,%rax
  8032d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032da:	8b 12                	mov    (%rdx),%edx
  8032dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8032df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032e3:	89 0a                	mov    %ecx,(%rdx)
  8032e5:	eb 17                	jmp    8032fe <getuint+0x102>
  8032e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032eb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8032ef:	48 89 d0             	mov    %rdx,%rax
  8032f2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8032f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032fa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8032fe:	8b 00                	mov    (%rax),%eax
  803300:	89 c0                	mov    %eax,%eax
  803302:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803306:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80330a:	c9                   	leaveq 
  80330b:	c3                   	retq   

000000000080330c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80330c:	55                   	push   %rbp
  80330d:	48 89 e5             	mov    %rsp,%rbp
  803310:	48 83 ec 20          	sub    $0x20,%rsp
  803314:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803318:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80331b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80331f:	7e 52                	jle    803373 <getint+0x67>
		x=va_arg(*ap, long long);
  803321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803325:	8b 00                	mov    (%rax),%eax
  803327:	83 f8 30             	cmp    $0x30,%eax
  80332a:	73 24                	jae    803350 <getint+0x44>
  80332c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803330:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803338:	8b 00                	mov    (%rax),%eax
  80333a:	89 c0                	mov    %eax,%eax
  80333c:	48 01 d0             	add    %rdx,%rax
  80333f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803343:	8b 12                	mov    (%rdx),%edx
  803345:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803348:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80334c:	89 0a                	mov    %ecx,(%rdx)
  80334e:	eb 17                	jmp    803367 <getint+0x5b>
  803350:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803354:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803358:	48 89 d0             	mov    %rdx,%rax
  80335b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80335f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803363:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803367:	48 8b 00             	mov    (%rax),%rax
  80336a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80336e:	e9 a3 00 00 00       	jmpq   803416 <getint+0x10a>
	else if (lflag)
  803373:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803377:	74 4f                	je     8033c8 <getint+0xbc>
		x=va_arg(*ap, long);
  803379:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80337d:	8b 00                	mov    (%rax),%eax
  80337f:	83 f8 30             	cmp    $0x30,%eax
  803382:	73 24                	jae    8033a8 <getint+0x9c>
  803384:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803388:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80338c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803390:	8b 00                	mov    (%rax),%eax
  803392:	89 c0                	mov    %eax,%eax
  803394:	48 01 d0             	add    %rdx,%rax
  803397:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80339b:	8b 12                	mov    (%rdx),%edx
  80339d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8033a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033a4:	89 0a                	mov    %ecx,(%rdx)
  8033a6:	eb 17                	jmp    8033bf <getint+0xb3>
  8033a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8033b0:	48 89 d0             	mov    %rdx,%rax
  8033b3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8033b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033bb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8033bf:	48 8b 00             	mov    (%rax),%rax
  8033c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8033c6:	eb 4e                	jmp    803416 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8033c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033cc:	8b 00                	mov    (%rax),%eax
  8033ce:	83 f8 30             	cmp    $0x30,%eax
  8033d1:	73 24                	jae    8033f7 <getint+0xeb>
  8033d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033d7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8033db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033df:	8b 00                	mov    (%rax),%eax
  8033e1:	89 c0                	mov    %eax,%eax
  8033e3:	48 01 d0             	add    %rdx,%rax
  8033e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033ea:	8b 12                	mov    (%rdx),%edx
  8033ec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8033ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033f3:	89 0a                	mov    %ecx,(%rdx)
  8033f5:	eb 17                	jmp    80340e <getint+0x102>
  8033f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033fb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8033ff:	48 89 d0             	mov    %rdx,%rax
  803402:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803406:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80340a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80340e:	8b 00                	mov    (%rax),%eax
  803410:	48 98                	cltq   
  803412:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803416:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80341a:	c9                   	leaveq 
  80341b:	c3                   	retq   

000000000080341c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80341c:	55                   	push   %rbp
  80341d:	48 89 e5             	mov    %rsp,%rbp
  803420:	41 54                	push   %r12
  803422:	53                   	push   %rbx
  803423:	48 83 ec 60          	sub    $0x60,%rsp
  803427:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80342b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80342f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803433:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803437:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80343b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80343f:	48 8b 0a             	mov    (%rdx),%rcx
  803442:	48 89 08             	mov    %rcx,(%rax)
  803445:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803449:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80344d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803451:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803455:	eb 17                	jmp    80346e <vprintfmt+0x52>
			if (ch == '\0')
  803457:	85 db                	test   %ebx,%ebx
  803459:	0f 84 d7 04 00 00    	je     803936 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  80345f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803463:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803467:	48 89 c6             	mov    %rax,%rsi
  80346a:	89 df                	mov    %ebx,%edi
  80346c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80346e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803472:	0f b6 00             	movzbl (%rax),%eax
  803475:	0f b6 d8             	movzbl %al,%ebx
  803478:	83 fb 25             	cmp    $0x25,%ebx
  80347b:	0f 95 c0             	setne  %al
  80347e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  803483:	84 c0                	test   %al,%al
  803485:	75 d0                	jne    803457 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  803487:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80348b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  803492:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  803499:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8034a0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8034a7:	eb 04                	jmp    8034ad <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8034a9:	90                   	nop
  8034aa:	eb 01                	jmp    8034ad <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8034ac:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8034ad:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8034b1:	0f b6 00             	movzbl (%rax),%eax
  8034b4:	0f b6 d8             	movzbl %al,%ebx
  8034b7:	89 d8                	mov    %ebx,%eax
  8034b9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8034be:	83 e8 23             	sub    $0x23,%eax
  8034c1:	83 f8 55             	cmp    $0x55,%eax
  8034c4:	0f 87 38 04 00 00    	ja     803902 <vprintfmt+0x4e6>
  8034ca:	89 c0                	mov    %eax,%eax
  8034cc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8034d3:	00 
  8034d4:	48 b8 90 43 80 00 00 	movabs $0x804390,%rax
  8034db:	00 00 00 
  8034de:	48 01 d0             	add    %rdx,%rax
  8034e1:	48 8b 00             	mov    (%rax),%rax
  8034e4:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8034e6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8034ea:	eb c1                	jmp    8034ad <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8034ec:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8034f0:	eb bb                	jmp    8034ad <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8034f2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8034f9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8034fc:	89 d0                	mov    %edx,%eax
  8034fe:	c1 e0 02             	shl    $0x2,%eax
  803501:	01 d0                	add    %edx,%eax
  803503:	01 c0                	add    %eax,%eax
  803505:	01 d8                	add    %ebx,%eax
  803507:	83 e8 30             	sub    $0x30,%eax
  80350a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80350d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803511:	0f b6 00             	movzbl (%rax),%eax
  803514:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  803517:	83 fb 2f             	cmp    $0x2f,%ebx
  80351a:	7e 63                	jle    80357f <vprintfmt+0x163>
  80351c:	83 fb 39             	cmp    $0x39,%ebx
  80351f:	7f 5e                	jg     80357f <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803521:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  803526:	eb d1                	jmp    8034f9 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  803528:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80352b:	83 f8 30             	cmp    $0x30,%eax
  80352e:	73 17                	jae    803547 <vprintfmt+0x12b>
  803530:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803534:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803537:	89 c0                	mov    %eax,%eax
  803539:	48 01 d0             	add    %rdx,%rax
  80353c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80353f:	83 c2 08             	add    $0x8,%edx
  803542:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803545:	eb 0f                	jmp    803556 <vprintfmt+0x13a>
  803547:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80354b:	48 89 d0             	mov    %rdx,%rax
  80354e:	48 83 c2 08          	add    $0x8,%rdx
  803552:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803556:	8b 00                	mov    (%rax),%eax
  803558:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80355b:	eb 23                	jmp    803580 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  80355d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803561:	0f 89 42 ff ff ff    	jns    8034a9 <vprintfmt+0x8d>
				width = 0;
  803567:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80356e:	e9 36 ff ff ff       	jmpq   8034a9 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  803573:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80357a:	e9 2e ff ff ff       	jmpq   8034ad <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80357f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  803580:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803584:	0f 89 22 ff ff ff    	jns    8034ac <vprintfmt+0x90>
				width = precision, precision = -1;
  80358a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80358d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  803590:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  803597:	e9 10 ff ff ff       	jmpq   8034ac <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80359c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8035a0:	e9 08 ff ff ff       	jmpq   8034ad <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8035a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8035a8:	83 f8 30             	cmp    $0x30,%eax
  8035ab:	73 17                	jae    8035c4 <vprintfmt+0x1a8>
  8035ad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8035b1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8035b4:	89 c0                	mov    %eax,%eax
  8035b6:	48 01 d0             	add    %rdx,%rax
  8035b9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8035bc:	83 c2 08             	add    $0x8,%edx
  8035bf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8035c2:	eb 0f                	jmp    8035d3 <vprintfmt+0x1b7>
  8035c4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8035c8:	48 89 d0             	mov    %rdx,%rax
  8035cb:	48 83 c2 08          	add    $0x8,%rdx
  8035cf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8035d3:	8b 00                	mov    (%rax),%eax
  8035d5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8035d9:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8035dd:	48 89 d6             	mov    %rdx,%rsi
  8035e0:	89 c7                	mov    %eax,%edi
  8035e2:	ff d1                	callq  *%rcx
			break;
  8035e4:	e9 47 03 00 00       	jmpq   803930 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8035e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8035ec:	83 f8 30             	cmp    $0x30,%eax
  8035ef:	73 17                	jae    803608 <vprintfmt+0x1ec>
  8035f1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8035f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8035f8:	89 c0                	mov    %eax,%eax
  8035fa:	48 01 d0             	add    %rdx,%rax
  8035fd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803600:	83 c2 08             	add    $0x8,%edx
  803603:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803606:	eb 0f                	jmp    803617 <vprintfmt+0x1fb>
  803608:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80360c:	48 89 d0             	mov    %rdx,%rax
  80360f:	48 83 c2 08          	add    $0x8,%rdx
  803613:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803617:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803619:	85 db                	test   %ebx,%ebx
  80361b:	79 02                	jns    80361f <vprintfmt+0x203>
				err = -err;
  80361d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80361f:	83 fb 10             	cmp    $0x10,%ebx
  803622:	7f 16                	jg     80363a <vprintfmt+0x21e>
  803624:	48 b8 e0 42 80 00 00 	movabs $0x8042e0,%rax
  80362b:	00 00 00 
  80362e:	48 63 d3             	movslq %ebx,%rdx
  803631:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803635:	4d 85 e4             	test   %r12,%r12
  803638:	75 2e                	jne    803668 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80363a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80363e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803642:	89 d9                	mov    %ebx,%ecx
  803644:	48 ba 79 43 80 00 00 	movabs $0x804379,%rdx
  80364b:	00 00 00 
  80364e:	48 89 c7             	mov    %rax,%rdi
  803651:	b8 00 00 00 00       	mov    $0x0,%eax
  803656:	49 b8 40 39 80 00 00 	movabs $0x803940,%r8
  80365d:	00 00 00 
  803660:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  803663:	e9 c8 02 00 00       	jmpq   803930 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803668:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80366c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803670:	4c 89 e1             	mov    %r12,%rcx
  803673:	48 ba 82 43 80 00 00 	movabs $0x804382,%rdx
  80367a:	00 00 00 
  80367d:	48 89 c7             	mov    %rax,%rdi
  803680:	b8 00 00 00 00       	mov    $0x0,%eax
  803685:	49 b8 40 39 80 00 00 	movabs $0x803940,%r8
  80368c:	00 00 00 
  80368f:	41 ff d0             	callq  *%r8
			break;
  803692:	e9 99 02 00 00       	jmpq   803930 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  803697:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80369a:	83 f8 30             	cmp    $0x30,%eax
  80369d:	73 17                	jae    8036b6 <vprintfmt+0x29a>
  80369f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8036a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8036a6:	89 c0                	mov    %eax,%eax
  8036a8:	48 01 d0             	add    %rdx,%rax
  8036ab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8036ae:	83 c2 08             	add    $0x8,%edx
  8036b1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8036b4:	eb 0f                	jmp    8036c5 <vprintfmt+0x2a9>
  8036b6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8036ba:	48 89 d0             	mov    %rdx,%rax
  8036bd:	48 83 c2 08          	add    $0x8,%rdx
  8036c1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8036c5:	4c 8b 20             	mov    (%rax),%r12
  8036c8:	4d 85 e4             	test   %r12,%r12
  8036cb:	75 0a                	jne    8036d7 <vprintfmt+0x2bb>
				p = "(null)";
  8036cd:	49 bc 85 43 80 00 00 	movabs $0x804385,%r12
  8036d4:	00 00 00 
			if (width > 0 && padc != '-')
  8036d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8036db:	7e 7a                	jle    803757 <vprintfmt+0x33b>
  8036dd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8036e1:	74 74                	je     803757 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8036e3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8036e6:	48 98                	cltq   
  8036e8:	48 89 c6             	mov    %rax,%rsi
  8036eb:	4c 89 e7             	mov    %r12,%rdi
  8036ee:	48 b8 e2 01 80 00 00 	movabs $0x8001e2,%rax
  8036f5:	00 00 00 
  8036f8:	ff d0                	callq  *%rax
  8036fa:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8036fd:	eb 17                	jmp    803716 <vprintfmt+0x2fa>
					putch(padc, putdat);
  8036ff:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  803703:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803707:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80370b:	48 89 d6             	mov    %rdx,%rsi
  80370e:	89 c7                	mov    %eax,%edi
  803710:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803712:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803716:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80371a:	7f e3                	jg     8036ff <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80371c:	eb 39                	jmp    803757 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  80371e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803722:	74 1e                	je     803742 <vprintfmt+0x326>
  803724:	83 fb 1f             	cmp    $0x1f,%ebx
  803727:	7e 05                	jle    80372e <vprintfmt+0x312>
  803729:	83 fb 7e             	cmp    $0x7e,%ebx
  80372c:	7e 14                	jle    803742 <vprintfmt+0x326>
					putch('?', putdat);
  80372e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803732:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803736:	48 89 c6             	mov    %rax,%rsi
  803739:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80373e:	ff d2                	callq  *%rdx
  803740:	eb 0f                	jmp    803751 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  803742:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803746:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80374a:	48 89 c6             	mov    %rax,%rsi
  80374d:	89 df                	mov    %ebx,%edi
  80374f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803751:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803755:	eb 01                	jmp    803758 <vprintfmt+0x33c>
  803757:	90                   	nop
  803758:	41 0f b6 04 24       	movzbl (%r12),%eax
  80375d:	0f be d8             	movsbl %al,%ebx
  803760:	85 db                	test   %ebx,%ebx
  803762:	0f 95 c0             	setne  %al
  803765:	49 83 c4 01          	add    $0x1,%r12
  803769:	84 c0                	test   %al,%al
  80376b:	74 28                	je     803795 <vprintfmt+0x379>
  80376d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803771:	78 ab                	js     80371e <vprintfmt+0x302>
  803773:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803777:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80377b:	79 a1                	jns    80371e <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80377d:	eb 16                	jmp    803795 <vprintfmt+0x379>
				putch(' ', putdat);
  80377f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803783:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803787:	48 89 c6             	mov    %rax,%rsi
  80378a:	bf 20 00 00 00       	mov    $0x20,%edi
  80378f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803791:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803795:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803799:	7f e4                	jg     80377f <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  80379b:	e9 90 01 00 00       	jmpq   803930 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8037a0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8037a4:	be 03 00 00 00       	mov    $0x3,%esi
  8037a9:	48 89 c7             	mov    %rax,%rdi
  8037ac:	48 b8 0c 33 80 00 00 	movabs $0x80330c,%rax
  8037b3:	00 00 00 
  8037b6:	ff d0                	callq  *%rax
  8037b8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8037bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c0:	48 85 c0             	test   %rax,%rax
  8037c3:	79 1d                	jns    8037e2 <vprintfmt+0x3c6>
				putch('-', putdat);
  8037c5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8037c9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8037cd:	48 89 c6             	mov    %rax,%rsi
  8037d0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8037d5:	ff d2                	callq  *%rdx
				num = -(long long) num;
  8037d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037db:	48 f7 d8             	neg    %rax
  8037de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8037e2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8037e9:	e9 d5 00 00 00       	jmpq   8038c3 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8037ee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8037f2:	be 03 00 00 00       	mov    $0x3,%esi
  8037f7:	48 89 c7             	mov    %rax,%rdi
  8037fa:	48 b8 fc 31 80 00 00 	movabs $0x8031fc,%rax
  803801:	00 00 00 
  803804:	ff d0                	callq  *%rax
  803806:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80380a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803811:	e9 ad 00 00 00       	jmpq   8038c3 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  803816:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80381a:	be 03 00 00 00       	mov    $0x3,%esi
  80381f:	48 89 c7             	mov    %rax,%rdi
  803822:	48 b8 fc 31 80 00 00 	movabs $0x8031fc,%rax
  803829:	00 00 00 
  80382c:	ff d0                	callq  *%rax
  80382e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  803832:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  803839:	e9 85 00 00 00       	jmpq   8038c3 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  80383e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803842:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803846:	48 89 c6             	mov    %rax,%rsi
  803849:	bf 30 00 00 00       	mov    $0x30,%edi
  80384e:	ff d2                	callq  *%rdx
			putch('x', putdat);
  803850:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803854:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  803858:	48 89 c6             	mov    %rax,%rsi
  80385b:	bf 78 00 00 00       	mov    $0x78,%edi
  803860:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803862:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803865:	83 f8 30             	cmp    $0x30,%eax
  803868:	73 17                	jae    803881 <vprintfmt+0x465>
  80386a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80386e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803871:	89 c0                	mov    %eax,%eax
  803873:	48 01 d0             	add    %rdx,%rax
  803876:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803879:	83 c2 08             	add    $0x8,%edx
  80387c:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80387f:	eb 0f                	jmp    803890 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  803881:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803885:	48 89 d0             	mov    %rdx,%rax
  803888:	48 83 c2 08          	add    $0x8,%rdx
  80388c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803890:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803893:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803897:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80389e:	eb 23                	jmp    8038c3 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8038a0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8038a4:	be 03 00 00 00       	mov    $0x3,%esi
  8038a9:	48 89 c7             	mov    %rax,%rdi
  8038ac:	48 b8 fc 31 80 00 00 	movabs $0x8031fc,%rax
  8038b3:	00 00 00 
  8038b6:	ff d0                	callq  *%rax
  8038b8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8038bc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8038c3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8038c8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8038cb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8038ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038d2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8038d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8038da:	45 89 c1             	mov    %r8d,%r9d
  8038dd:	41 89 f8             	mov    %edi,%r8d
  8038e0:	48 89 c7             	mov    %rax,%rdi
  8038e3:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  8038ea:	00 00 00 
  8038ed:	ff d0                	callq  *%rax
			break;
  8038ef:	eb 3f                	jmp    803930 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8038f1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8038f5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8038f9:	48 89 c6             	mov    %rax,%rsi
  8038fc:	89 df                	mov    %ebx,%edi
  8038fe:	ff d2                	callq  *%rdx
			break;
  803900:	eb 2e                	jmp    803930 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803902:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  803906:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80390a:	48 89 c6             	mov    %rax,%rsi
  80390d:	bf 25 00 00 00       	mov    $0x25,%edi
  803912:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  803914:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803919:	eb 05                	jmp    803920 <vprintfmt+0x504>
  80391b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803920:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803924:	48 83 e8 01          	sub    $0x1,%rax
  803928:	0f b6 00             	movzbl (%rax),%eax
  80392b:	3c 25                	cmp    $0x25,%al
  80392d:	75 ec                	jne    80391b <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  80392f:	90                   	nop
		}
	}
  803930:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803931:	e9 38 fb ff ff       	jmpq   80346e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  803936:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  803937:	48 83 c4 60          	add    $0x60,%rsp
  80393b:	5b                   	pop    %rbx
  80393c:	41 5c                	pop    %r12
  80393e:	5d                   	pop    %rbp
  80393f:	c3                   	retq   

0000000000803940 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803940:	55                   	push   %rbp
  803941:	48 89 e5             	mov    %rsp,%rbp
  803944:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80394b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803952:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803959:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803960:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803967:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80396e:	84 c0                	test   %al,%al
  803970:	74 20                	je     803992 <printfmt+0x52>
  803972:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803976:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80397a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80397e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803982:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803986:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80398a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80398e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803992:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803999:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8039a0:	00 00 00 
  8039a3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8039aa:	00 00 00 
  8039ad:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8039b1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8039b8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8039bf:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8039c6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8039cd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8039d4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8039db:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8039e2:	48 89 c7             	mov    %rax,%rdi
  8039e5:	48 b8 1c 34 80 00 00 	movabs $0x80341c,%rax
  8039ec:	00 00 00 
  8039ef:	ff d0                	callq  *%rax
	va_end(ap);
}
  8039f1:	c9                   	leaveq 
  8039f2:	c3                   	retq   

00000000008039f3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8039f3:	55                   	push   %rbp
  8039f4:	48 89 e5             	mov    %rsp,%rbp
  8039f7:	48 83 ec 10          	sub    $0x10,%rsp
  8039fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803a02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a06:	8b 40 10             	mov    0x10(%rax),%eax
  803a09:	8d 50 01             	lea    0x1(%rax),%edx
  803a0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a10:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803a13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a17:	48 8b 10             	mov    (%rax),%rdx
  803a1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a1e:	48 8b 40 08          	mov    0x8(%rax),%rax
  803a22:	48 39 c2             	cmp    %rax,%rdx
  803a25:	73 17                	jae    803a3e <sprintputch+0x4b>
		*b->buf++ = ch;
  803a27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a2b:	48 8b 00             	mov    (%rax),%rax
  803a2e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a31:	88 10                	mov    %dl,(%rax)
  803a33:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803a37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a3b:	48 89 10             	mov    %rdx,(%rax)
}
  803a3e:	c9                   	leaveq 
  803a3f:	c3                   	retq   

0000000000803a40 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803a40:	55                   	push   %rbp
  803a41:	48 89 e5             	mov    %rsp,%rbp
  803a44:	48 83 ec 50          	sub    $0x50,%rsp
  803a48:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803a4c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803a4f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803a53:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803a57:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803a5b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803a5f:	48 8b 0a             	mov    (%rdx),%rcx
  803a62:	48 89 08             	mov    %rcx,(%rax)
  803a65:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803a69:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803a6d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803a71:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803a75:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a79:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803a7d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803a80:	48 98                	cltq   
  803a82:	48 83 e8 01          	sub    $0x1,%rax
  803a86:	48 03 45 c8          	add    -0x38(%rbp),%rax
  803a8a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803a8e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803a95:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803a9a:	74 06                	je     803aa2 <vsnprintf+0x62>
  803a9c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803aa0:	7f 07                	jg     803aa9 <vsnprintf+0x69>
		return -E_INVAL;
  803aa2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803aa7:	eb 2f                	jmp    803ad8 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803aa9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803aad:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803ab1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803ab5:	48 89 c6             	mov    %rax,%rsi
  803ab8:	48 bf f3 39 80 00 00 	movabs $0x8039f3,%rdi
  803abf:	00 00 00 
  803ac2:	48 b8 1c 34 80 00 00 	movabs $0x80341c,%rax
  803ac9:	00 00 00 
  803acc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803ace:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ad2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803ad5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803ad8:	c9                   	leaveq 
  803ad9:	c3                   	retq   

0000000000803ada <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803ada:	55                   	push   %rbp
  803adb:	48 89 e5             	mov    %rsp,%rbp
  803ade:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803ae5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803aec:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803af2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803af9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803b00:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803b07:	84 c0                	test   %al,%al
  803b09:	74 20                	je     803b2b <snprintf+0x51>
  803b0b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803b0f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803b13:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803b17:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803b1b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803b1f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803b23:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803b27:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803b2b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803b32:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803b39:	00 00 00 
  803b3c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803b43:	00 00 00 
  803b46:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b4a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803b51:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803b58:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803b5f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803b66:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803b6d:	48 8b 0a             	mov    (%rdx),%rcx
  803b70:	48 89 08             	mov    %rcx,(%rax)
  803b73:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803b77:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803b7b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803b7f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803b83:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803b8a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803b91:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803b97:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803b9e:	48 89 c7             	mov    %rax,%rdi
  803ba1:	48 b8 40 3a 80 00 00 	movabs $0x803a40,%rax
  803ba8:	00 00 00 
  803bab:	ff d0                	callq  *%rax
  803bad:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803bb3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803bb9:	c9                   	leaveq 
  803bba:	c3                   	retq   
	...

0000000000803bbc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803bbc:	55                   	push   %rbp
  803bbd:	48 89 e5             	mov    %rsp,%rbp
  803bc0:	48 83 ec 18          	sub    $0x18,%rsp
  803bc4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803bc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bcc:	48 89 c2             	mov    %rax,%rdx
  803bcf:	48 c1 ea 15          	shr    $0x15,%rdx
  803bd3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803bda:	01 00 00 
  803bdd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803be1:	83 e0 01             	and    $0x1,%eax
  803be4:	48 85 c0             	test   %rax,%rax
  803be7:	75 07                	jne    803bf0 <pageref+0x34>
		return 0;
  803be9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bee:	eb 53                	jmp    803c43 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803bf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bf4:	48 89 c2             	mov    %rax,%rdx
  803bf7:	48 c1 ea 0c          	shr    $0xc,%rdx
  803bfb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c02:	01 00 00 
  803c05:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c09:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c11:	83 e0 01             	and    $0x1,%eax
  803c14:	48 85 c0             	test   %rax,%rax
  803c17:	75 07                	jne    803c20 <pageref+0x64>
		return 0;
  803c19:	b8 00 00 00 00       	mov    $0x0,%eax
  803c1e:	eb 23                	jmp    803c43 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c24:	48 89 c2             	mov    %rax,%rdx
  803c27:	48 c1 ea 0c          	shr    $0xc,%rdx
  803c2b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c32:	00 00 00 
  803c35:	48 c1 e2 04          	shl    $0x4,%rdx
  803c39:	48 01 d0             	add    %rdx,%rax
  803c3c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c40:	0f b7 c0             	movzwl %ax,%eax
}
  803c43:	c9                   	leaveq 
  803c44:	c3                   	retq   
