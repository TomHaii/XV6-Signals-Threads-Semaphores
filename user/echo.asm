
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i;

  for(i = 1; i < argc; i++){
  10:	4785                	li	a5,1
  12:	06a7d463          	bge	a5,a0,7a <main+0x7a>
  16:	00858493          	addi	s1,a1,8
  1a:	ffe5099b          	addiw	s3,a0,-2
  1e:	02099793          	slli	a5,s3,0x20
  22:	01d7d993          	srli	s3,a5,0x1d
  26:	05c1                	addi	a1,a1,16
  28:	99ae                	add	s3,s3,a1
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  2a:	00001a17          	auipc	s4,0x1
  2e:	95ea0a13          	addi	s4,s4,-1698 # 988 <csem_up+0x4c>
    write(1, argv[i], strlen(argv[i]));
  32:	0004b903          	ld	s2,0(s1)
  36:	854a                	mv	a0,s2
  38:	00000097          	auipc	ra,0x0
  3c:	094080e7          	jalr	148(ra) # cc <strlen>
  40:	0005061b          	sext.w	a2,a0
  44:	85ca                	mv	a1,s2
  46:	4505                	li	a0,1
  48:	00000097          	auipc	ra,0x0
  4c:	2ca080e7          	jalr	714(ra) # 312 <write>
    if(i + 1 < argc){
  50:	04a1                	addi	s1,s1,8
  52:	01348a63          	beq	s1,s3,66 <main+0x66>
      write(1, " ", 1);
  56:	4605                	li	a2,1
  58:	85d2                	mv	a1,s4
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2b6080e7          	jalr	694(ra) # 312 <write>
  for(i = 1; i < argc; i++){
  64:	b7f9                	j	32 <main+0x32>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	92858593          	addi	a1,a1,-1752 # 990 <csem_up+0x54>
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	2a0080e7          	jalr	672(ra) # 312 <write>
    }
  }
  exit(0);
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	276080e7          	jalr	630(ra) # 2f2 <exit>

0000000000000084 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8a:	87aa                	mv	a5,a0
  8c:	0585                	addi	a1,a1,1
  8e:	0785                	addi	a5,a5,1
  90:	fff5c703          	lbu	a4,-1(a1)
  94:	fee78fa3          	sb	a4,-1(a5)
  98:	fb75                	bnez	a4,8c <strcpy+0x8>
    ;
  return os;
}
  9a:	6422                	ld	s0,8(sp)
  9c:	0141                	addi	sp,sp,16
  9e:	8082                	ret

00000000000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a6:	00054783          	lbu	a5,0(a0)
  aa:	cb91                	beqz	a5,be <strcmp+0x1e>
  ac:	0005c703          	lbu	a4,0(a1)
  b0:	00f71763          	bne	a4,a5,be <strcmp+0x1e>
    p++, q++;
  b4:	0505                	addi	a0,a0,1
  b6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b8:	00054783          	lbu	a5,0(a0)
  bc:	fbe5                	bnez	a5,ac <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  be:	0005c503          	lbu	a0,0(a1)
}
  c2:	40a7853b          	subw	a0,a5,a0
  c6:	6422                	ld	s0,8(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <strlen>:

uint
strlen(const char *s)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cf91                	beqz	a5,f2 <strlen+0x26>
  d8:	0505                	addi	a0,a0,1
  da:	87aa                	mv	a5,a0
  dc:	4685                	li	a3,1
  de:	9e89                	subw	a3,a3,a0
  e0:	00f6853b          	addw	a0,a3,a5
  e4:	0785                	addi	a5,a5,1
  e6:	fff7c703          	lbu	a4,-1(a5)
  ea:	fb7d                	bnez	a4,e0 <strlen+0x14>
    ;
  return n;
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret
  for(n = 0; s[n]; n++)
  f2:	4501                	li	a0,0
  f4:	bfe5                	j	ec <strlen+0x20>

00000000000000f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fc:	ca19                	beqz	a2,112 <memset+0x1c>
  fe:	87aa                	mv	a5,a0
 100:	1602                	slli	a2,a2,0x20
 102:	9201                	srli	a2,a2,0x20
 104:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 108:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10c:	0785                	addi	a5,a5,1
 10e:	fee79de3          	bne	a5,a4,108 <memset+0x12>
  }
  return dst;
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strchr>:

char*
strchr(const char *s, char c)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 11e:	00054783          	lbu	a5,0(a0)
 122:	cb99                	beqz	a5,138 <strchr+0x20>
    if(*s == c)
 124:	00f58763          	beq	a1,a5,132 <strchr+0x1a>
  for(; *s; s++)
 128:	0505                	addi	a0,a0,1
 12a:	00054783          	lbu	a5,0(a0)
 12e:	fbfd                	bnez	a5,124 <strchr+0xc>
      return (char*)s;
  return 0;
 130:	4501                	li	a0,0
}
 132:	6422                	ld	s0,8(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret
  return 0;
 138:	4501                	li	a0,0
 13a:	bfe5                	j	132 <strchr+0x1a>

000000000000013c <gets>:

char*
gets(char *buf, int max)
{
 13c:	711d                	addi	sp,sp,-96
 13e:	ec86                	sd	ra,88(sp)
 140:	e8a2                	sd	s0,80(sp)
 142:	e4a6                	sd	s1,72(sp)
 144:	e0ca                	sd	s2,64(sp)
 146:	fc4e                	sd	s3,56(sp)
 148:	f852                	sd	s4,48(sp)
 14a:	f456                	sd	s5,40(sp)
 14c:	f05a                	sd	s6,32(sp)
 14e:	ec5e                	sd	s7,24(sp)
 150:	1080                	addi	s0,sp,96
 152:	8baa                	mv	s7,a0
 154:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 156:	892a                	mv	s2,a0
 158:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 15a:	4aa9                	li	s5,10
 15c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 15e:	89a6                	mv	s3,s1
 160:	2485                	addiw	s1,s1,1
 162:	0344d863          	bge	s1,s4,192 <gets+0x56>
    cc = read(0, &c, 1);
 166:	4605                	li	a2,1
 168:	faf40593          	addi	a1,s0,-81
 16c:	4501                	li	a0,0
 16e:	00000097          	auipc	ra,0x0
 172:	19c080e7          	jalr	412(ra) # 30a <read>
    if(cc < 1)
 176:	00a05e63          	blez	a0,192 <gets+0x56>
    buf[i++] = c;
 17a:	faf44783          	lbu	a5,-81(s0)
 17e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 182:	01578763          	beq	a5,s5,190 <gets+0x54>
 186:	0905                	addi	s2,s2,1
 188:	fd679be3          	bne	a5,s6,15e <gets+0x22>
  for(i=0; i+1 < max; ){
 18c:	89a6                	mv	s3,s1
 18e:	a011                	j	192 <gets+0x56>
 190:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 192:	99de                	add	s3,s3,s7
 194:	00098023          	sb	zero,0(s3)
  return buf;
}
 198:	855e                	mv	a0,s7
 19a:	60e6                	ld	ra,88(sp)
 19c:	6446                	ld	s0,80(sp)
 19e:	64a6                	ld	s1,72(sp)
 1a0:	6906                	ld	s2,64(sp)
 1a2:	79e2                	ld	s3,56(sp)
 1a4:	7a42                	ld	s4,48(sp)
 1a6:	7aa2                	ld	s5,40(sp)
 1a8:	7b02                	ld	s6,32(sp)
 1aa:	6be2                	ld	s7,24(sp)
 1ac:	6125                	addi	sp,sp,96
 1ae:	8082                	ret

00000000000001b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b0:	1101                	addi	sp,sp,-32
 1b2:	ec06                	sd	ra,24(sp)
 1b4:	e822                	sd	s0,16(sp)
 1b6:	e426                	sd	s1,8(sp)
 1b8:	e04a                	sd	s2,0(sp)
 1ba:	1000                	addi	s0,sp,32
 1bc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1be:	4581                	li	a1,0
 1c0:	00000097          	auipc	ra,0x0
 1c4:	172080e7          	jalr	370(ra) # 332 <open>
  if(fd < 0)
 1c8:	02054563          	bltz	a0,1f2 <stat+0x42>
 1cc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ce:	85ca                	mv	a1,s2
 1d0:	00000097          	auipc	ra,0x0
 1d4:	17a080e7          	jalr	378(ra) # 34a <fstat>
 1d8:	892a                	mv	s2,a0
  close(fd);
 1da:	8526                	mv	a0,s1
 1dc:	00000097          	auipc	ra,0x0
 1e0:	13e080e7          	jalr	318(ra) # 31a <close>
  return r;
}
 1e4:	854a                	mv	a0,s2
 1e6:	60e2                	ld	ra,24(sp)
 1e8:	6442                	ld	s0,16(sp)
 1ea:	64a2                	ld	s1,8(sp)
 1ec:	6902                	ld	s2,0(sp)
 1ee:	6105                	addi	sp,sp,32
 1f0:	8082                	ret
    return -1;
 1f2:	597d                	li	s2,-1
 1f4:	bfc5                	j	1e4 <stat+0x34>

00000000000001f6 <atoi>:

int
atoi(const char *s)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e422                	sd	s0,8(sp)
 1fa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1fc:	00054603          	lbu	a2,0(a0)
 200:	fd06079b          	addiw	a5,a2,-48
 204:	0ff7f793          	andi	a5,a5,255
 208:	4725                	li	a4,9
 20a:	02f76963          	bltu	a4,a5,23c <atoi+0x46>
 20e:	86aa                	mv	a3,a0
  n = 0;
 210:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 212:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 214:	0685                	addi	a3,a3,1
 216:	0025179b          	slliw	a5,a0,0x2
 21a:	9fa9                	addw	a5,a5,a0
 21c:	0017979b          	slliw	a5,a5,0x1
 220:	9fb1                	addw	a5,a5,a2
 222:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 226:	0006c603          	lbu	a2,0(a3)
 22a:	fd06071b          	addiw	a4,a2,-48
 22e:	0ff77713          	andi	a4,a4,255
 232:	fee5f1e3          	bgeu	a1,a4,214 <atoi+0x1e>
  return n;
}
 236:	6422                	ld	s0,8(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret
  n = 0;
 23c:	4501                	li	a0,0
 23e:	bfe5                	j	236 <atoi+0x40>

0000000000000240 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 240:	1141                	addi	sp,sp,-16
 242:	e422                	sd	s0,8(sp)
 244:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 246:	02b57463          	bgeu	a0,a1,26e <memmove+0x2e>
    while(n-- > 0)
 24a:	00c05f63          	blez	a2,268 <memmove+0x28>
 24e:	1602                	slli	a2,a2,0x20
 250:	9201                	srli	a2,a2,0x20
 252:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 256:	872a                	mv	a4,a0
      *dst++ = *src++;
 258:	0585                	addi	a1,a1,1
 25a:	0705                	addi	a4,a4,1
 25c:	fff5c683          	lbu	a3,-1(a1)
 260:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 264:	fee79ae3          	bne	a5,a4,258 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret
    dst += n;
 26e:	00c50733          	add	a4,a0,a2
    src += n;
 272:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 274:	fec05ae3          	blez	a2,268 <memmove+0x28>
 278:	fff6079b          	addiw	a5,a2,-1
 27c:	1782                	slli	a5,a5,0x20
 27e:	9381                	srli	a5,a5,0x20
 280:	fff7c793          	not	a5,a5
 284:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 286:	15fd                	addi	a1,a1,-1
 288:	177d                	addi	a4,a4,-1
 28a:	0005c683          	lbu	a3,0(a1)
 28e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 292:	fee79ae3          	bne	a5,a4,286 <memmove+0x46>
 296:	bfc9                	j	268 <memmove+0x28>

0000000000000298 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 29e:	ca05                	beqz	a2,2ce <memcmp+0x36>
 2a0:	fff6069b          	addiw	a3,a2,-1
 2a4:	1682                	slli	a3,a3,0x20
 2a6:	9281                	srli	a3,a3,0x20
 2a8:	0685                	addi	a3,a3,1
 2aa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	0005c703          	lbu	a4,0(a1)
 2b4:	00e79863          	bne	a5,a4,2c4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2b8:	0505                	addi	a0,a0,1
    p2++;
 2ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2bc:	fed518e3          	bne	a0,a3,2ac <memcmp+0x14>
  }
  return 0;
 2c0:	4501                	li	a0,0
 2c2:	a019                	j	2c8 <memcmp+0x30>
      return *p1 - *p2;
 2c4:	40e7853b          	subw	a0,a5,a4
}
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret
  return 0;
 2ce:	4501                	li	a0,0
 2d0:	bfe5                	j	2c8 <memcmp+0x30>

00000000000002d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2da:	00000097          	auipc	ra,0x0
 2de:	f66080e7          	jalr	-154(ra) # 240 <memmove>
}
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ea:	4885                	li	a7,1
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2f2:	4889                	li	a7,2
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <wait>:
.global wait
wait:
 li a7, SYS_wait
 2fa:	488d                	li	a7,3
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 302:	4891                	li	a7,4
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <read>:
.global read
read:
 li a7, SYS_read
 30a:	4895                	li	a7,5
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <write>:
.global write
write:
 li a7, SYS_write
 312:	48c1                	li	a7,16
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <close>:
.global close
close:
 li a7, SYS_close
 31a:	48d5                	li	a7,21
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <kill>:
.global kill
kill:
 li a7, SYS_kill
 322:	4899                	li	a7,6
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <exec>:
.global exec
exec:
 li a7, SYS_exec
 32a:	489d                	li	a7,7
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <open>:
.global open
open:
 li a7, SYS_open
 332:	48bd                	li	a7,15
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 33a:	48c5                	li	a7,17
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 342:	48c9                	li	a7,18
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 34a:	48a1                	li	a7,8
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <link>:
.global link
link:
 li a7, SYS_link
 352:	48cd                	li	a7,19
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 35a:	48d1                	li	a7,20
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 362:	48a5                	li	a7,9
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <dup>:
.global dup
dup:
 li a7, SYS_dup
 36a:	48a9                	li	a7,10
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 372:	48ad                	li	a7,11
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 37a:	48b1                	li	a7,12
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 382:	48b5                	li	a7,13
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 38a:	48b9                	li	a7,14
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 392:	48d9                	li	a7,22
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 39a:	48dd                	li	a7,23
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 3a2:	48e1                	li	a7,24
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 3aa:	48e5                	li	a7,25
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 3b2:	48e9                	li	a7,26
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 3ba:	48ed                	li	a7,27
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 3c2:	48f1                	li	a7,28
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 3ca:	48f5                	li	a7,29
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 3d2:	48f9                	li	a7,30
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 3da:	48fd                	li	a7,31
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 3e2:	02000893          	li	a7,32
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ec:	1101                	addi	sp,sp,-32
 3ee:	ec06                	sd	ra,24(sp)
 3f0:	e822                	sd	s0,16(sp)
 3f2:	1000                	addi	s0,sp,32
 3f4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f8:	4605                	li	a2,1
 3fa:	fef40593          	addi	a1,s0,-17
 3fe:	00000097          	auipc	ra,0x0
 402:	f14080e7          	jalr	-236(ra) # 312 <write>
}
 406:	60e2                	ld	ra,24(sp)
 408:	6442                	ld	s0,16(sp)
 40a:	6105                	addi	sp,sp,32
 40c:	8082                	ret

000000000000040e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40e:	7139                	addi	sp,sp,-64
 410:	fc06                	sd	ra,56(sp)
 412:	f822                	sd	s0,48(sp)
 414:	f426                	sd	s1,40(sp)
 416:	f04a                	sd	s2,32(sp)
 418:	ec4e                	sd	s3,24(sp)
 41a:	0080                	addi	s0,sp,64
 41c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 41e:	c299                	beqz	a3,424 <printint+0x16>
 420:	0805c863          	bltz	a1,4b0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 424:	2581                	sext.w	a1,a1
  neg = 0;
 426:	4881                	li	a7,0
 428:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 42c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 42e:	2601                	sext.w	a2,a2
 430:	00000517          	auipc	a0,0x0
 434:	57050513          	addi	a0,a0,1392 # 9a0 <digits>
 438:	883a                	mv	a6,a4
 43a:	2705                	addiw	a4,a4,1
 43c:	02c5f7bb          	remuw	a5,a1,a2
 440:	1782                	slli	a5,a5,0x20
 442:	9381                	srli	a5,a5,0x20
 444:	97aa                	add	a5,a5,a0
 446:	0007c783          	lbu	a5,0(a5)
 44a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 44e:	0005879b          	sext.w	a5,a1
 452:	02c5d5bb          	divuw	a1,a1,a2
 456:	0685                	addi	a3,a3,1
 458:	fec7f0e3          	bgeu	a5,a2,438 <printint+0x2a>
  if(neg)
 45c:	00088b63          	beqz	a7,472 <printint+0x64>
    buf[i++] = '-';
 460:	fd040793          	addi	a5,s0,-48
 464:	973e                	add	a4,a4,a5
 466:	02d00793          	li	a5,45
 46a:	fef70823          	sb	a5,-16(a4)
 46e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 472:	02e05863          	blez	a4,4a2 <printint+0x94>
 476:	fc040793          	addi	a5,s0,-64
 47a:	00e78933          	add	s2,a5,a4
 47e:	fff78993          	addi	s3,a5,-1
 482:	99ba                	add	s3,s3,a4
 484:	377d                	addiw	a4,a4,-1
 486:	1702                	slli	a4,a4,0x20
 488:	9301                	srli	a4,a4,0x20
 48a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 48e:	fff94583          	lbu	a1,-1(s2)
 492:	8526                	mv	a0,s1
 494:	00000097          	auipc	ra,0x0
 498:	f58080e7          	jalr	-168(ra) # 3ec <putc>
  while(--i >= 0)
 49c:	197d                	addi	s2,s2,-1
 49e:	ff3918e3          	bne	s2,s3,48e <printint+0x80>
}
 4a2:	70e2                	ld	ra,56(sp)
 4a4:	7442                	ld	s0,48(sp)
 4a6:	74a2                	ld	s1,40(sp)
 4a8:	7902                	ld	s2,32(sp)
 4aa:	69e2                	ld	s3,24(sp)
 4ac:	6121                	addi	sp,sp,64
 4ae:	8082                	ret
    x = -xx;
 4b0:	40b005bb          	negw	a1,a1
    neg = 1;
 4b4:	4885                	li	a7,1
    x = -xx;
 4b6:	bf8d                	j	428 <printint+0x1a>

00000000000004b8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b8:	7119                	addi	sp,sp,-128
 4ba:	fc86                	sd	ra,120(sp)
 4bc:	f8a2                	sd	s0,112(sp)
 4be:	f4a6                	sd	s1,104(sp)
 4c0:	f0ca                	sd	s2,96(sp)
 4c2:	ecce                	sd	s3,88(sp)
 4c4:	e8d2                	sd	s4,80(sp)
 4c6:	e4d6                	sd	s5,72(sp)
 4c8:	e0da                	sd	s6,64(sp)
 4ca:	fc5e                	sd	s7,56(sp)
 4cc:	f862                	sd	s8,48(sp)
 4ce:	f466                	sd	s9,40(sp)
 4d0:	f06a                	sd	s10,32(sp)
 4d2:	ec6e                	sd	s11,24(sp)
 4d4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d6:	0005c903          	lbu	s2,0(a1)
 4da:	18090f63          	beqz	s2,678 <vprintf+0x1c0>
 4de:	8aaa                	mv	s5,a0
 4e0:	8b32                	mv	s6,a2
 4e2:	00158493          	addi	s1,a1,1
  state = 0;
 4e6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e8:	02500a13          	li	s4,37
      if(c == 'd'){
 4ec:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4f0:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4f4:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4f8:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4fc:	00000b97          	auipc	s7,0x0
 500:	4a4b8b93          	addi	s7,s7,1188 # 9a0 <digits>
 504:	a839                	j	522 <vprintf+0x6a>
        putc(fd, c);
 506:	85ca                	mv	a1,s2
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	ee2080e7          	jalr	-286(ra) # 3ec <putc>
 512:	a019                	j	518 <vprintf+0x60>
    } else if(state == '%'){
 514:	01498f63          	beq	s3,s4,532 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 518:	0485                	addi	s1,s1,1
 51a:	fff4c903          	lbu	s2,-1(s1)
 51e:	14090d63          	beqz	s2,678 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 522:	0009079b          	sext.w	a5,s2
    if(state == 0){
 526:	fe0997e3          	bnez	s3,514 <vprintf+0x5c>
      if(c == '%'){
 52a:	fd479ee3          	bne	a5,s4,506 <vprintf+0x4e>
        state = '%';
 52e:	89be                	mv	s3,a5
 530:	b7e5                	j	518 <vprintf+0x60>
      if(c == 'd'){
 532:	05878063          	beq	a5,s8,572 <vprintf+0xba>
      } else if(c == 'l') {
 536:	05978c63          	beq	a5,s9,58e <vprintf+0xd6>
      } else if(c == 'x') {
 53a:	07a78863          	beq	a5,s10,5aa <vprintf+0xf2>
      } else if(c == 'p') {
 53e:	09b78463          	beq	a5,s11,5c6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 542:	07300713          	li	a4,115
 546:	0ce78663          	beq	a5,a4,612 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 54a:	06300713          	li	a4,99
 54e:	0ee78e63          	beq	a5,a4,64a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 552:	11478863          	beq	a5,s4,662 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 556:	85d2                	mv	a1,s4
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e92080e7          	jalr	-366(ra) # 3ec <putc>
        putc(fd, c);
 562:	85ca                	mv	a1,s2
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	e86080e7          	jalr	-378(ra) # 3ec <putc>
      }
      state = 0;
 56e:	4981                	li	s3,0
 570:	b765                	j	518 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 572:	008b0913          	addi	s2,s6,8
 576:	4685                	li	a3,1
 578:	4629                	li	a2,10
 57a:	000b2583          	lw	a1,0(s6)
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	e8e080e7          	jalr	-370(ra) # 40e <printint>
 588:	8b4a                	mv	s6,s2
      state = 0;
 58a:	4981                	li	s3,0
 58c:	b771                	j	518 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58e:	008b0913          	addi	s2,s6,8
 592:	4681                	li	a3,0
 594:	4629                	li	a2,10
 596:	000b2583          	lw	a1,0(s6)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	e72080e7          	jalr	-398(ra) # 40e <printint>
 5a4:	8b4a                	mv	s6,s2
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	bf85                	j	518 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5aa:	008b0913          	addi	s2,s6,8
 5ae:	4681                	li	a3,0
 5b0:	4641                	li	a2,16
 5b2:	000b2583          	lw	a1,0(s6)
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e56080e7          	jalr	-426(ra) # 40e <printint>
 5c0:	8b4a                	mv	s6,s2
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	bf91                	j	518 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5c6:	008b0793          	addi	a5,s6,8
 5ca:	f8f43423          	sd	a5,-120(s0)
 5ce:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5d2:	03000593          	li	a1,48
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e14080e7          	jalr	-492(ra) # 3ec <putc>
  putc(fd, 'x');
 5e0:	85ea                	mv	a1,s10
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	e08080e7          	jalr	-504(ra) # 3ec <putc>
 5ec:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ee:	03c9d793          	srli	a5,s3,0x3c
 5f2:	97de                	add	a5,a5,s7
 5f4:	0007c583          	lbu	a1,0(a5)
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	df2080e7          	jalr	-526(ra) # 3ec <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 602:	0992                	slli	s3,s3,0x4
 604:	397d                	addiw	s2,s2,-1
 606:	fe0914e3          	bnez	s2,5ee <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 60a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 60e:	4981                	li	s3,0
 610:	b721                	j	518 <vprintf+0x60>
        s = va_arg(ap, char*);
 612:	008b0993          	addi	s3,s6,8
 616:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 61a:	02090163          	beqz	s2,63c <vprintf+0x184>
        while(*s != 0){
 61e:	00094583          	lbu	a1,0(s2)
 622:	c9a1                	beqz	a1,672 <vprintf+0x1ba>
          putc(fd, *s);
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	dc6080e7          	jalr	-570(ra) # 3ec <putc>
          s++;
 62e:	0905                	addi	s2,s2,1
        while(*s != 0){
 630:	00094583          	lbu	a1,0(s2)
 634:	f9e5                	bnez	a1,624 <vprintf+0x16c>
        s = va_arg(ap, char*);
 636:	8b4e                	mv	s6,s3
      state = 0;
 638:	4981                	li	s3,0
 63a:	bdf9                	j	518 <vprintf+0x60>
          s = "(null)";
 63c:	00000917          	auipc	s2,0x0
 640:	35c90913          	addi	s2,s2,860 # 998 <csem_up+0x5c>
        while(*s != 0){
 644:	02800593          	li	a1,40
 648:	bff1                	j	624 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 64a:	008b0913          	addi	s2,s6,8
 64e:	000b4583          	lbu	a1,0(s6)
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	d98080e7          	jalr	-616(ra) # 3ec <putc>
 65c:	8b4a                	mv	s6,s2
      state = 0;
 65e:	4981                	li	s3,0
 660:	bd65                	j	518 <vprintf+0x60>
        putc(fd, c);
 662:	85d2                	mv	a1,s4
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	d86080e7          	jalr	-634(ra) # 3ec <putc>
      state = 0;
 66e:	4981                	li	s3,0
 670:	b565                	j	518 <vprintf+0x60>
        s = va_arg(ap, char*);
 672:	8b4e                	mv	s6,s3
      state = 0;
 674:	4981                	li	s3,0
 676:	b54d                	j	518 <vprintf+0x60>
    }
  }
}
 678:	70e6                	ld	ra,120(sp)
 67a:	7446                	ld	s0,112(sp)
 67c:	74a6                	ld	s1,104(sp)
 67e:	7906                	ld	s2,96(sp)
 680:	69e6                	ld	s3,88(sp)
 682:	6a46                	ld	s4,80(sp)
 684:	6aa6                	ld	s5,72(sp)
 686:	6b06                	ld	s6,64(sp)
 688:	7be2                	ld	s7,56(sp)
 68a:	7c42                	ld	s8,48(sp)
 68c:	7ca2                	ld	s9,40(sp)
 68e:	7d02                	ld	s10,32(sp)
 690:	6de2                	ld	s11,24(sp)
 692:	6109                	addi	sp,sp,128
 694:	8082                	ret

0000000000000696 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 696:	715d                	addi	sp,sp,-80
 698:	ec06                	sd	ra,24(sp)
 69a:	e822                	sd	s0,16(sp)
 69c:	1000                	addi	s0,sp,32
 69e:	e010                	sd	a2,0(s0)
 6a0:	e414                	sd	a3,8(s0)
 6a2:	e818                	sd	a4,16(s0)
 6a4:	ec1c                	sd	a5,24(s0)
 6a6:	03043023          	sd	a6,32(s0)
 6aa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ae:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b2:	8622                	mv	a2,s0
 6b4:	00000097          	auipc	ra,0x0
 6b8:	e04080e7          	jalr	-508(ra) # 4b8 <vprintf>
}
 6bc:	60e2                	ld	ra,24(sp)
 6be:	6442                	ld	s0,16(sp)
 6c0:	6161                	addi	sp,sp,80
 6c2:	8082                	ret

00000000000006c4 <printf>:

void
printf(const char *fmt, ...)
{
 6c4:	711d                	addi	sp,sp,-96
 6c6:	ec06                	sd	ra,24(sp)
 6c8:	e822                	sd	s0,16(sp)
 6ca:	1000                	addi	s0,sp,32
 6cc:	e40c                	sd	a1,8(s0)
 6ce:	e810                	sd	a2,16(s0)
 6d0:	ec14                	sd	a3,24(s0)
 6d2:	f018                	sd	a4,32(s0)
 6d4:	f41c                	sd	a5,40(s0)
 6d6:	03043823          	sd	a6,48(s0)
 6da:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6de:	00840613          	addi	a2,s0,8
 6e2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e6:	85aa                	mv	a1,a0
 6e8:	4505                	li	a0,1
 6ea:	00000097          	auipc	ra,0x0
 6ee:	dce080e7          	jalr	-562(ra) # 4b8 <vprintf>
}
 6f2:	60e2                	ld	ra,24(sp)
 6f4:	6442                	ld	s0,16(sp)
 6f6:	6125                	addi	sp,sp,96
 6f8:	8082                	ret

00000000000006fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6fa:	1141                	addi	sp,sp,-16
 6fc:	e422                	sd	s0,8(sp)
 6fe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 700:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 704:	00000797          	auipc	a5,0x0
 708:	2b47b783          	ld	a5,692(a5) # 9b8 <freep>
 70c:	a805                	j	73c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 70e:	4618                	lw	a4,8(a2)
 710:	9db9                	addw	a1,a1,a4
 712:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 716:	6398                	ld	a4,0(a5)
 718:	6318                	ld	a4,0(a4)
 71a:	fee53823          	sd	a4,-16(a0)
 71e:	a091                	j	762 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 720:	ff852703          	lw	a4,-8(a0)
 724:	9e39                	addw	a2,a2,a4
 726:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 728:	ff053703          	ld	a4,-16(a0)
 72c:	e398                	sd	a4,0(a5)
 72e:	a099                	j	774 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	6398                	ld	a4,0(a5)
 732:	00e7e463          	bltu	a5,a4,73a <free+0x40>
 736:	00e6ea63          	bltu	a3,a4,74a <free+0x50>
{
 73a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73c:	fed7fae3          	bgeu	a5,a3,730 <free+0x36>
 740:	6398                	ld	a4,0(a5)
 742:	00e6e463          	bltu	a3,a4,74a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 746:	fee7eae3          	bltu	a5,a4,73a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 74a:	ff852583          	lw	a1,-8(a0)
 74e:	6390                	ld	a2,0(a5)
 750:	02059813          	slli	a6,a1,0x20
 754:	01c85713          	srli	a4,a6,0x1c
 758:	9736                	add	a4,a4,a3
 75a:	fae60ae3          	beq	a2,a4,70e <free+0x14>
    bp->s.ptr = p->s.ptr;
 75e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 762:	4790                	lw	a2,8(a5)
 764:	02061593          	slli	a1,a2,0x20
 768:	01c5d713          	srli	a4,a1,0x1c
 76c:	973e                	add	a4,a4,a5
 76e:	fae689e3          	beq	a3,a4,720 <free+0x26>
  } else
    p->s.ptr = bp;
 772:	e394                	sd	a3,0(a5)
  freep = p;
 774:	00000717          	auipc	a4,0x0
 778:	24f73223          	sd	a5,580(a4) # 9b8 <freep>
}
 77c:	6422                	ld	s0,8(sp)
 77e:	0141                	addi	sp,sp,16
 780:	8082                	ret

0000000000000782 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 782:	7139                	addi	sp,sp,-64
 784:	fc06                	sd	ra,56(sp)
 786:	f822                	sd	s0,48(sp)
 788:	f426                	sd	s1,40(sp)
 78a:	f04a                	sd	s2,32(sp)
 78c:	ec4e                	sd	s3,24(sp)
 78e:	e852                	sd	s4,16(sp)
 790:	e456                	sd	s5,8(sp)
 792:	e05a                	sd	s6,0(sp)
 794:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 796:	02051493          	slli	s1,a0,0x20
 79a:	9081                	srli	s1,s1,0x20
 79c:	04bd                	addi	s1,s1,15
 79e:	8091                	srli	s1,s1,0x4
 7a0:	0014899b          	addiw	s3,s1,1
 7a4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7a6:	00000517          	auipc	a0,0x0
 7aa:	21253503          	ld	a0,530(a0) # 9b8 <freep>
 7ae:	c515                	beqz	a0,7da <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b2:	4798                	lw	a4,8(a5)
 7b4:	02977f63          	bgeu	a4,s1,7f2 <malloc+0x70>
 7b8:	8a4e                	mv	s4,s3
 7ba:	0009871b          	sext.w	a4,s3
 7be:	6685                	lui	a3,0x1
 7c0:	00d77363          	bgeu	a4,a3,7c6 <malloc+0x44>
 7c4:	6a05                	lui	s4,0x1
 7c6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ca:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ce:	00000917          	auipc	s2,0x0
 7d2:	1ea90913          	addi	s2,s2,490 # 9b8 <freep>
  if(p == (char*)-1)
 7d6:	5afd                	li	s5,-1
 7d8:	a895                	j	84c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7da:	00000797          	auipc	a5,0x0
 7de:	1e678793          	addi	a5,a5,486 # 9c0 <base>
 7e2:	00000717          	auipc	a4,0x0
 7e6:	1cf73b23          	sd	a5,470(a4) # 9b8 <freep>
 7ea:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ec:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7f0:	b7e1                	j	7b8 <malloc+0x36>
      if(p->s.size == nunits)
 7f2:	02e48c63          	beq	s1,a4,82a <malloc+0xa8>
        p->s.size -= nunits;
 7f6:	4137073b          	subw	a4,a4,s3
 7fa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7fc:	02071693          	slli	a3,a4,0x20
 800:	01c6d713          	srli	a4,a3,0x1c
 804:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 806:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 80a:	00000717          	auipc	a4,0x0
 80e:	1aa73723          	sd	a0,430(a4) # 9b8 <freep>
      return (void*)(p + 1);
 812:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 816:	70e2                	ld	ra,56(sp)
 818:	7442                	ld	s0,48(sp)
 81a:	74a2                	ld	s1,40(sp)
 81c:	7902                	ld	s2,32(sp)
 81e:	69e2                	ld	s3,24(sp)
 820:	6a42                	ld	s4,16(sp)
 822:	6aa2                	ld	s5,8(sp)
 824:	6b02                	ld	s6,0(sp)
 826:	6121                	addi	sp,sp,64
 828:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 82a:	6398                	ld	a4,0(a5)
 82c:	e118                	sd	a4,0(a0)
 82e:	bff1                	j	80a <malloc+0x88>
  hp->s.size = nu;
 830:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 834:	0541                	addi	a0,a0,16
 836:	00000097          	auipc	ra,0x0
 83a:	ec4080e7          	jalr	-316(ra) # 6fa <free>
  return freep;
 83e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 842:	d971                	beqz	a0,816 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 844:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 846:	4798                	lw	a4,8(a5)
 848:	fa9775e3          	bgeu	a4,s1,7f2 <malloc+0x70>
    if(p == freep)
 84c:	00093703          	ld	a4,0(s2)
 850:	853e                	mv	a0,a5
 852:	fef719e3          	bne	a4,a5,844 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 856:	8552                	mv	a0,s4
 858:	00000097          	auipc	ra,0x0
 85c:	b22080e7          	jalr	-1246(ra) # 37a <sbrk>
  if(p == (char*)-1)
 860:	fd5518e3          	bne	a0,s5,830 <malloc+0xae>
        return 0;
 864:	4501                	li	a0,0
 866:	bf45                	j	816 <malloc+0x94>

0000000000000868 <csem_alloc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int csem_alloc(struct counting_semaphore *sem, int initial_value){
 868:	1101                	addi	sp,sp,-32
 86a:	ec06                	sd	ra,24(sp)
 86c:	e822                	sd	s0,16(sp)
 86e:	e426                	sd	s1,8(sp)
 870:	e04a                	sd	s2,0(sp)
 872:	1000                	addi	s0,sp,32
 874:	84aa                	mv	s1,a0
 876:	892e                	mv	s2,a1
    sem->binary_semaphore1 = bsem_alloc();
 878:	00000097          	auipc	ra,0x0
 87c:	b52080e7          	jalr	-1198(ra) # 3ca <bsem_alloc>
 880:	c088                	sw	a0,0(s1)
    sem->binary_semaphore2 = bsem_alloc();
 882:	00000097          	auipc	ra,0x0
 886:	b48080e7          	jalr	-1208(ra) # 3ca <bsem_alloc>
 88a:	87aa                	mv	a5,a0
 88c:	c0c8                	sw	a0,4(s1)
    if(sem->binary_semaphore1 == -1 || sem->binary_semaphore2 == -1)
 88e:	4088                	lw	a0,0(s1)
 890:	577d                	li	a4,-1
 892:	00e50963          	beq	a0,a4,8a4 <csem_alloc+0x3c>
 896:	02e78363          	beq	a5,a4,8bc <csem_alloc+0x54>
        return -1;
    if(initial_value == 0)
 89a:	00090b63          	beqz	s2,8b0 <csem_alloc+0x48>
        bsem_down(sem->binary_semaphore2);
    sem->value = initial_value;
 89e:	0124a423          	sw	s2,8(s1)
    return 0;
 8a2:	4501                	li	a0,0
}
 8a4:	60e2                	ld	ra,24(sp)
 8a6:	6442                	ld	s0,16(sp)
 8a8:	64a2                	ld	s1,8(sp)
 8aa:	6902                	ld	s2,0(sp)
 8ac:	6105                	addi	sp,sp,32
 8ae:	8082                	ret
        bsem_down(sem->binary_semaphore2);
 8b0:	853e                	mv	a0,a5
 8b2:	00000097          	auipc	ra,0x0
 8b6:	b28080e7          	jalr	-1240(ra) # 3da <bsem_down>
 8ba:	b7d5                	j	89e <csem_alloc+0x36>
        return -1;
 8bc:	853e                	mv	a0,a5
 8be:	b7dd                	j	8a4 <csem_alloc+0x3c>

00000000000008c0 <csem_free>:

void csem_free(struct counting_semaphore *sem){
 8c0:	1101                	addi	sp,sp,-32
 8c2:	ec06                	sd	ra,24(sp)
 8c4:	e822                	sd	s0,16(sp)
 8c6:	e426                	sd	s1,8(sp)
 8c8:	1000                	addi	s0,sp,32
 8ca:	84aa                	mv	s1,a0
    bsem_free(sem->binary_semaphore1);
 8cc:	4108                	lw	a0,0(a0)
 8ce:	00000097          	auipc	ra,0x0
 8d2:	b04080e7          	jalr	-1276(ra) # 3d2 <bsem_free>
    bsem_free(sem->binary_semaphore2);
 8d6:	40c8                	lw	a0,4(s1)
 8d8:	00000097          	auipc	ra,0x0
 8dc:	afa080e7          	jalr	-1286(ra) # 3d2 <bsem_free>
    sem->value = 0;
 8e0:	0004a423          	sw	zero,8(s1)
}
 8e4:	60e2                	ld	ra,24(sp)
 8e6:	6442                	ld	s0,16(sp)
 8e8:	64a2                	ld	s1,8(sp)
 8ea:	6105                	addi	sp,sp,32
 8ec:	8082                	ret

00000000000008ee <csem_down>:

void csem_down(struct counting_semaphore *sem){
 8ee:	1101                	addi	sp,sp,-32
 8f0:	ec06                	sd	ra,24(sp)
 8f2:	e822                	sd	s0,16(sp)
 8f4:	e426                	sd	s1,8(sp)
 8f6:	1000                	addi	s0,sp,32
 8f8:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore2);
 8fa:	4148                	lw	a0,4(a0)
 8fc:	00000097          	auipc	ra,0x0
 900:	ade080e7          	jalr	-1314(ra) # 3da <bsem_down>
    bsem_down(sem->binary_semaphore1);
 904:	4088                	lw	a0,0(s1)
 906:	00000097          	auipc	ra,0x0
 90a:	ad4080e7          	jalr	-1324(ra) # 3da <bsem_down>
    sem->value--;
 90e:	449c                	lw	a5,8(s1)
 910:	37fd                	addiw	a5,a5,-1
 912:	0007871b          	sext.w	a4,a5
 916:	c49c                	sw	a5,8(s1)
    if(sem->value > 0)
 918:	00e04c63          	bgtz	a4,930 <csem_down+0x42>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
 91c:	4088                	lw	a0,0(s1)
 91e:	00000097          	auipc	ra,0x0
 922:	ac4080e7          	jalr	-1340(ra) # 3e2 <bsem_up>
}
 926:	60e2                	ld	ra,24(sp)
 928:	6442                	ld	s0,16(sp)
 92a:	64a2                	ld	s1,8(sp)
 92c:	6105                	addi	sp,sp,32
 92e:	8082                	ret
        bsem_up(sem->binary_semaphore2);
 930:	40c8                	lw	a0,4(s1)
 932:	00000097          	auipc	ra,0x0
 936:	ab0080e7          	jalr	-1360(ra) # 3e2 <bsem_up>
 93a:	b7cd                	j	91c <csem_down+0x2e>

000000000000093c <csem_up>:

void csem_up(struct counting_semaphore *sem){
 93c:	1101                	addi	sp,sp,-32
 93e:	ec06                	sd	ra,24(sp)
 940:	e822                	sd	s0,16(sp)
 942:	e426                	sd	s1,8(sp)
 944:	1000                	addi	s0,sp,32
 946:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore1);
 948:	4108                	lw	a0,0(a0)
 94a:	00000097          	auipc	ra,0x0
 94e:	a90080e7          	jalr	-1392(ra) # 3da <bsem_down>
    sem->value++;
 952:	449c                	lw	a5,8(s1)
 954:	2785                	addiw	a5,a5,1
 956:	0007871b          	sext.w	a4,a5
 95a:	c49c                	sw	a5,8(s1)
    if(sem->value == 1)
 95c:	4785                	li	a5,1
 95e:	00f70c63          	beq	a4,a5,976 <csem_up+0x3a>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
 962:	4088                	lw	a0,0(s1)
 964:	00000097          	auipc	ra,0x0
 968:	a7e080e7          	jalr	-1410(ra) # 3e2 <bsem_up>
 96c:	60e2                	ld	ra,24(sp)
 96e:	6442                	ld	s0,16(sp)
 970:	64a2                	ld	s1,8(sp)
 972:	6105                	addi	sp,sp,32
 974:	8082                	ret
        bsem_up(sem->binary_semaphore2);
 976:	40c8                	lw	a0,4(s1)
 978:	00000097          	auipc	ra,0x0
 97c:	a6a080e7          	jalr	-1430(ra) # 3e2 <bsem_up>
 980:	b7cd                	j	962 <csem_up+0x26>
