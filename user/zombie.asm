
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	288080e7          	jalr	648(ra) # 290 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	282080e7          	jalr	642(ra) # 298 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	308080e7          	jalr	776(ra) # 328 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e422                	sd	s0,8(sp)
  2e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  30:	87aa                	mv	a5,a0
  32:	0585                	addi	a1,a1,1
  34:	0785                	addi	a5,a5,1
  36:	fff5c703          	lbu	a4,-1(a1)
  3a:	fee78fa3          	sb	a4,-1(a5)
  3e:	fb75                	bnez	a4,32 <strcpy+0x8>
    ;
  return os;
}
  40:	6422                	ld	s0,8(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret

0000000000000046 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  46:	1141                	addi	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	cb91                	beqz	a5,64 <strcmp+0x1e>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71763          	bne	a4,a5,64 <strcmp+0x1e>
    p++, q++;
  5a:	0505                	addi	a0,a0,1
  5c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	fbe5                	bnez	a5,52 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  64:	0005c503          	lbu	a0,0(a1)
}
  68:	40a7853b          	subw	a0,a5,a0
  6c:	6422                	ld	s0,8(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  78:	00054783          	lbu	a5,0(a0)
  7c:	cf91                	beqz	a5,98 <strlen+0x26>
  7e:	0505                	addi	a0,a0,1
  80:	87aa                	mv	a5,a0
  82:	4685                	li	a3,1
  84:	9e89                	subw	a3,a3,a0
  86:	00f6853b          	addw	a0,a3,a5
  8a:	0785                	addi	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	fb7d                	bnez	a4,86 <strlen+0x14>
    ;
  return n;
}
  92:	6422                	ld	s0,8(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret
  for(n = 0; s[n]; n++)
  98:	4501                	li	a0,0
  9a:	bfe5                	j	92 <strlen+0x20>

000000000000009c <memset>:

void*
memset(void *dst, int c, uint n)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a2:	ca19                	beqz	a2,b8 <memset+0x1c>
  a4:	87aa                	mv	a5,a0
  a6:	1602                	slli	a2,a2,0x20
  a8:	9201                	srli	a2,a2,0x20
  aa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b2:	0785                	addi	a5,a5,1
  b4:	fee79de3          	bne	a5,a4,ae <memset+0x12>
  }
  return dst;
}
  b8:	6422                	ld	s0,8(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret

00000000000000be <strchr>:

char*
strchr(const char *s, char c)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e422                	sd	s0,8(sp)
  c2:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb99                	beqz	a5,de <strchr+0x20>
    if(*s == c)
  ca:	00f58763          	beq	a1,a5,d8 <strchr+0x1a>
  for(; *s; s++)
  ce:	0505                	addi	a0,a0,1
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbfd                	bnez	a5,ca <strchr+0xc>
      return (char*)s;
  return 0;
  d6:	4501                	li	a0,0
}
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
  return 0;
  de:	4501                	li	a0,0
  e0:	bfe5                	j	d8 <strchr+0x1a>

00000000000000e2 <gets>:

char*
gets(char *buf, int max)
{
  e2:	711d                	addi	sp,sp,-96
  e4:	ec86                	sd	ra,88(sp)
  e6:	e8a2                	sd	s0,80(sp)
  e8:	e4a6                	sd	s1,72(sp)
  ea:	e0ca                	sd	s2,64(sp)
  ec:	fc4e                	sd	s3,56(sp)
  ee:	f852                	sd	s4,48(sp)
  f0:	f456                	sd	s5,40(sp)
  f2:	f05a                	sd	s6,32(sp)
  f4:	ec5e                	sd	s7,24(sp)
  f6:	1080                	addi	s0,sp,96
  f8:	8baa                	mv	s7,a0
  fa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fc:	892a                	mv	s2,a0
  fe:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 100:	4aa9                	li	s5,10
 102:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 104:	89a6                	mv	s3,s1
 106:	2485                	addiw	s1,s1,1
 108:	0344d863          	bge	s1,s4,138 <gets+0x56>
    cc = read(0, &c, 1);
 10c:	4605                	li	a2,1
 10e:	faf40593          	addi	a1,s0,-81
 112:	4501                	li	a0,0
 114:	00000097          	auipc	ra,0x0
 118:	19c080e7          	jalr	412(ra) # 2b0 <read>
    if(cc < 1)
 11c:	00a05e63          	blez	a0,138 <gets+0x56>
    buf[i++] = c;
 120:	faf44783          	lbu	a5,-81(s0)
 124:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 128:	01578763          	beq	a5,s5,136 <gets+0x54>
 12c:	0905                	addi	s2,s2,1
 12e:	fd679be3          	bne	a5,s6,104 <gets+0x22>
  for(i=0; i+1 < max; ){
 132:	89a6                	mv	s3,s1
 134:	a011                	j	138 <gets+0x56>
 136:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 138:	99de                	add	s3,s3,s7
 13a:	00098023          	sb	zero,0(s3)
  return buf;
}
 13e:	855e                	mv	a0,s7
 140:	60e6                	ld	ra,88(sp)
 142:	6446                	ld	s0,80(sp)
 144:	64a6                	ld	s1,72(sp)
 146:	6906                	ld	s2,64(sp)
 148:	79e2                	ld	s3,56(sp)
 14a:	7a42                	ld	s4,48(sp)
 14c:	7aa2                	ld	s5,40(sp)
 14e:	7b02                	ld	s6,32(sp)
 150:	6be2                	ld	s7,24(sp)
 152:	6125                	addi	sp,sp,96
 154:	8082                	ret

0000000000000156 <stat>:

int
stat(const char *n, struct stat *st)
{
 156:	1101                	addi	sp,sp,-32
 158:	ec06                	sd	ra,24(sp)
 15a:	e822                	sd	s0,16(sp)
 15c:	e426                	sd	s1,8(sp)
 15e:	e04a                	sd	s2,0(sp)
 160:	1000                	addi	s0,sp,32
 162:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 164:	4581                	li	a1,0
 166:	00000097          	auipc	ra,0x0
 16a:	172080e7          	jalr	370(ra) # 2d8 <open>
  if(fd < 0)
 16e:	02054563          	bltz	a0,198 <stat+0x42>
 172:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 174:	85ca                	mv	a1,s2
 176:	00000097          	auipc	ra,0x0
 17a:	17a080e7          	jalr	378(ra) # 2f0 <fstat>
 17e:	892a                	mv	s2,a0
  close(fd);
 180:	8526                	mv	a0,s1
 182:	00000097          	auipc	ra,0x0
 186:	13e080e7          	jalr	318(ra) # 2c0 <close>
  return r;
}
 18a:	854a                	mv	a0,s2
 18c:	60e2                	ld	ra,24(sp)
 18e:	6442                	ld	s0,16(sp)
 190:	64a2                	ld	s1,8(sp)
 192:	6902                	ld	s2,0(sp)
 194:	6105                	addi	sp,sp,32
 196:	8082                	ret
    return -1;
 198:	597d                	li	s2,-1
 19a:	bfc5                	j	18a <stat+0x34>

000000000000019c <atoi>:

int
atoi(const char *s)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a2:	00054603          	lbu	a2,0(a0)
 1a6:	fd06079b          	addiw	a5,a2,-48
 1aa:	0ff7f793          	andi	a5,a5,255
 1ae:	4725                	li	a4,9
 1b0:	02f76963          	bltu	a4,a5,1e2 <atoi+0x46>
 1b4:	86aa                	mv	a3,a0
  n = 0;
 1b6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1b8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1ba:	0685                	addi	a3,a3,1
 1bc:	0025179b          	slliw	a5,a0,0x2
 1c0:	9fa9                	addw	a5,a5,a0
 1c2:	0017979b          	slliw	a5,a5,0x1
 1c6:	9fb1                	addw	a5,a5,a2
 1c8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1cc:	0006c603          	lbu	a2,0(a3)
 1d0:	fd06071b          	addiw	a4,a2,-48
 1d4:	0ff77713          	andi	a4,a4,255
 1d8:	fee5f1e3          	bgeu	a1,a4,1ba <atoi+0x1e>
  return n;
}
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret
  n = 0;
 1e2:	4501                	li	a0,0
 1e4:	bfe5                	j	1dc <atoi+0x40>

00000000000001e6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1ec:	02b57463          	bgeu	a0,a1,214 <memmove+0x2e>
    while(n-- > 0)
 1f0:	00c05f63          	blez	a2,20e <memmove+0x28>
 1f4:	1602                	slli	a2,a2,0x20
 1f6:	9201                	srli	a2,a2,0x20
 1f8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1fc:	872a                	mv	a4,a0
      *dst++ = *src++;
 1fe:	0585                	addi	a1,a1,1
 200:	0705                	addi	a4,a4,1
 202:	fff5c683          	lbu	a3,-1(a1)
 206:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 20a:	fee79ae3          	bne	a5,a4,1fe <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
    dst += n;
 214:	00c50733          	add	a4,a0,a2
    src += n;
 218:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 21a:	fec05ae3          	blez	a2,20e <memmove+0x28>
 21e:	fff6079b          	addiw	a5,a2,-1
 222:	1782                	slli	a5,a5,0x20
 224:	9381                	srli	a5,a5,0x20
 226:	fff7c793          	not	a5,a5
 22a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 22c:	15fd                	addi	a1,a1,-1
 22e:	177d                	addi	a4,a4,-1
 230:	0005c683          	lbu	a3,0(a1)
 234:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 238:	fee79ae3          	bne	a5,a4,22c <memmove+0x46>
 23c:	bfc9                	j	20e <memmove+0x28>

000000000000023e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 244:	ca05                	beqz	a2,274 <memcmp+0x36>
 246:	fff6069b          	addiw	a3,a2,-1
 24a:	1682                	slli	a3,a3,0x20
 24c:	9281                	srli	a3,a3,0x20
 24e:	0685                	addi	a3,a3,1
 250:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 252:	00054783          	lbu	a5,0(a0)
 256:	0005c703          	lbu	a4,0(a1)
 25a:	00e79863          	bne	a5,a4,26a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 25e:	0505                	addi	a0,a0,1
    p2++;
 260:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 262:	fed518e3          	bne	a0,a3,252 <memcmp+0x14>
  }
  return 0;
 266:	4501                	li	a0,0
 268:	a019                	j	26e <memcmp+0x30>
      return *p1 - *p2;
 26a:	40e7853b          	subw	a0,a5,a4
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
  return 0;
 274:	4501                	li	a0,0
 276:	bfe5                	j	26e <memcmp+0x30>

0000000000000278 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e406                	sd	ra,8(sp)
 27c:	e022                	sd	s0,0(sp)
 27e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 280:	00000097          	auipc	ra,0x0
 284:	f66080e7          	jalr	-154(ra) # 1e6 <memmove>
}
 288:	60a2                	ld	ra,8(sp)
 28a:	6402                	ld	s0,0(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret

0000000000000290 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 290:	4885                	li	a7,1
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <exit>:
.global exit
exit:
 li a7, SYS_exit
 298:	4889                	li	a7,2
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2a0:	488d                	li	a7,3
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2a8:	4891                	li	a7,4
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <read>:
.global read
read:
 li a7, SYS_read
 2b0:	4895                	li	a7,5
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <write>:
.global write
write:
 li a7, SYS_write
 2b8:	48c1                	li	a7,16
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <close>:
.global close
close:
 li a7, SYS_close
 2c0:	48d5                	li	a7,21
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2c8:	4899                	li	a7,6
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2d0:	489d                	li	a7,7
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <open>:
.global open
open:
 li a7, SYS_open
 2d8:	48bd                	li	a7,15
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2e0:	48c5                	li	a7,17
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2e8:	48c9                	li	a7,18
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2f0:	48a1                	li	a7,8
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <link>:
.global link
link:
 li a7, SYS_link
 2f8:	48cd                	li	a7,19
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 300:	48d1                	li	a7,20
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 308:	48a5                	li	a7,9
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <dup>:
.global dup
dup:
 li a7, SYS_dup
 310:	48a9                	li	a7,10
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 318:	48ad                	li	a7,11
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 320:	48b1                	li	a7,12
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 328:	48b5                	li	a7,13
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 330:	48b9                	li	a7,14
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 338:	48d9                	li	a7,22
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 340:	48dd                	li	a7,23
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 348:	48e1                	li	a7,24
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 350:	48e5                	li	a7,25
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 358:	48e9                	li	a7,26
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 360:	48ed                	li	a7,27
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 368:	48f1                	li	a7,28
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 370:	48f5                	li	a7,29
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 378:	48f9                	li	a7,30
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 380:	48fd                	li	a7,31
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 388:	02000893          	li	a7,32
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 392:	1101                	addi	sp,sp,-32
 394:	ec06                	sd	ra,24(sp)
 396:	e822                	sd	s0,16(sp)
 398:	1000                	addi	s0,sp,32
 39a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 39e:	4605                	li	a2,1
 3a0:	fef40593          	addi	a1,s0,-17
 3a4:	00000097          	auipc	ra,0x0
 3a8:	f14080e7          	jalr	-236(ra) # 2b8 <write>
}
 3ac:	60e2                	ld	ra,24(sp)
 3ae:	6442                	ld	s0,16(sp)
 3b0:	6105                	addi	sp,sp,32
 3b2:	8082                	ret

00000000000003b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b4:	7139                	addi	sp,sp,-64
 3b6:	fc06                	sd	ra,56(sp)
 3b8:	f822                	sd	s0,48(sp)
 3ba:	f426                	sd	s1,40(sp)
 3bc:	f04a                	sd	s2,32(sp)
 3be:	ec4e                	sd	s3,24(sp)
 3c0:	0080                	addi	s0,sp,64
 3c2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c4:	c299                	beqz	a3,3ca <printint+0x16>
 3c6:	0805c863          	bltz	a1,456 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ca:	2581                	sext.w	a1,a1
  neg = 0;
 3cc:	4881                	li	a7,0
 3ce:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3d2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d4:	2601                	sext.w	a2,a2
 3d6:	00000517          	auipc	a0,0x0
 3da:	55a50513          	addi	a0,a0,1370 # 930 <digits>
 3de:	883a                	mv	a6,a4
 3e0:	2705                	addiw	a4,a4,1
 3e2:	02c5f7bb          	remuw	a5,a1,a2
 3e6:	1782                	slli	a5,a5,0x20
 3e8:	9381                	srli	a5,a5,0x20
 3ea:	97aa                	add	a5,a5,a0
 3ec:	0007c783          	lbu	a5,0(a5)
 3f0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f4:	0005879b          	sext.w	a5,a1
 3f8:	02c5d5bb          	divuw	a1,a1,a2
 3fc:	0685                	addi	a3,a3,1
 3fe:	fec7f0e3          	bgeu	a5,a2,3de <printint+0x2a>
  if(neg)
 402:	00088b63          	beqz	a7,418 <printint+0x64>
    buf[i++] = '-';
 406:	fd040793          	addi	a5,s0,-48
 40a:	973e                	add	a4,a4,a5
 40c:	02d00793          	li	a5,45
 410:	fef70823          	sb	a5,-16(a4)
 414:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 418:	02e05863          	blez	a4,448 <printint+0x94>
 41c:	fc040793          	addi	a5,s0,-64
 420:	00e78933          	add	s2,a5,a4
 424:	fff78993          	addi	s3,a5,-1
 428:	99ba                	add	s3,s3,a4
 42a:	377d                	addiw	a4,a4,-1
 42c:	1702                	slli	a4,a4,0x20
 42e:	9301                	srli	a4,a4,0x20
 430:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 434:	fff94583          	lbu	a1,-1(s2)
 438:	8526                	mv	a0,s1
 43a:	00000097          	auipc	ra,0x0
 43e:	f58080e7          	jalr	-168(ra) # 392 <putc>
  while(--i >= 0)
 442:	197d                	addi	s2,s2,-1
 444:	ff3918e3          	bne	s2,s3,434 <printint+0x80>
}
 448:	70e2                	ld	ra,56(sp)
 44a:	7442                	ld	s0,48(sp)
 44c:	74a2                	ld	s1,40(sp)
 44e:	7902                	ld	s2,32(sp)
 450:	69e2                	ld	s3,24(sp)
 452:	6121                	addi	sp,sp,64
 454:	8082                	ret
    x = -xx;
 456:	40b005bb          	negw	a1,a1
    neg = 1;
 45a:	4885                	li	a7,1
    x = -xx;
 45c:	bf8d                	j	3ce <printint+0x1a>

000000000000045e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 45e:	7119                	addi	sp,sp,-128
 460:	fc86                	sd	ra,120(sp)
 462:	f8a2                	sd	s0,112(sp)
 464:	f4a6                	sd	s1,104(sp)
 466:	f0ca                	sd	s2,96(sp)
 468:	ecce                	sd	s3,88(sp)
 46a:	e8d2                	sd	s4,80(sp)
 46c:	e4d6                	sd	s5,72(sp)
 46e:	e0da                	sd	s6,64(sp)
 470:	fc5e                	sd	s7,56(sp)
 472:	f862                	sd	s8,48(sp)
 474:	f466                	sd	s9,40(sp)
 476:	f06a                	sd	s10,32(sp)
 478:	ec6e                	sd	s11,24(sp)
 47a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 47c:	0005c903          	lbu	s2,0(a1)
 480:	18090f63          	beqz	s2,61e <vprintf+0x1c0>
 484:	8aaa                	mv	s5,a0
 486:	8b32                	mv	s6,a2
 488:	00158493          	addi	s1,a1,1
  state = 0;
 48c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 48e:	02500a13          	li	s4,37
      if(c == 'd'){
 492:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 496:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 49a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 49e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4a2:	00000b97          	auipc	s7,0x0
 4a6:	48eb8b93          	addi	s7,s7,1166 # 930 <digits>
 4aa:	a839                	j	4c8 <vprintf+0x6a>
        putc(fd, c);
 4ac:	85ca                	mv	a1,s2
 4ae:	8556                	mv	a0,s5
 4b0:	00000097          	auipc	ra,0x0
 4b4:	ee2080e7          	jalr	-286(ra) # 392 <putc>
 4b8:	a019                	j	4be <vprintf+0x60>
    } else if(state == '%'){
 4ba:	01498f63          	beq	s3,s4,4d8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4be:	0485                	addi	s1,s1,1
 4c0:	fff4c903          	lbu	s2,-1(s1)
 4c4:	14090d63          	beqz	s2,61e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4c8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4cc:	fe0997e3          	bnez	s3,4ba <vprintf+0x5c>
      if(c == '%'){
 4d0:	fd479ee3          	bne	a5,s4,4ac <vprintf+0x4e>
        state = '%';
 4d4:	89be                	mv	s3,a5
 4d6:	b7e5                	j	4be <vprintf+0x60>
      if(c == 'd'){
 4d8:	05878063          	beq	a5,s8,518 <vprintf+0xba>
      } else if(c == 'l') {
 4dc:	05978c63          	beq	a5,s9,534 <vprintf+0xd6>
      } else if(c == 'x') {
 4e0:	07a78863          	beq	a5,s10,550 <vprintf+0xf2>
      } else if(c == 'p') {
 4e4:	09b78463          	beq	a5,s11,56c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4e8:	07300713          	li	a4,115
 4ec:	0ce78663          	beq	a5,a4,5b8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4f0:	06300713          	li	a4,99
 4f4:	0ee78e63          	beq	a5,a4,5f0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4f8:	11478863          	beq	a5,s4,608 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4fc:	85d2                	mv	a1,s4
 4fe:	8556                	mv	a0,s5
 500:	00000097          	auipc	ra,0x0
 504:	e92080e7          	jalr	-366(ra) # 392 <putc>
        putc(fd, c);
 508:	85ca                	mv	a1,s2
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	e86080e7          	jalr	-378(ra) # 392 <putc>
      }
      state = 0;
 514:	4981                	li	s3,0
 516:	b765                	j	4be <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 518:	008b0913          	addi	s2,s6,8
 51c:	4685                	li	a3,1
 51e:	4629                	li	a2,10
 520:	000b2583          	lw	a1,0(s6)
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	e8e080e7          	jalr	-370(ra) # 3b4 <printint>
 52e:	8b4a                	mv	s6,s2
      state = 0;
 530:	4981                	li	s3,0
 532:	b771                	j	4be <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 534:	008b0913          	addi	s2,s6,8
 538:	4681                	li	a3,0
 53a:	4629                	li	a2,10
 53c:	000b2583          	lw	a1,0(s6)
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	e72080e7          	jalr	-398(ra) # 3b4 <printint>
 54a:	8b4a                	mv	s6,s2
      state = 0;
 54c:	4981                	li	s3,0
 54e:	bf85                	j	4be <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 550:	008b0913          	addi	s2,s6,8
 554:	4681                	li	a3,0
 556:	4641                	li	a2,16
 558:	000b2583          	lw	a1,0(s6)
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	e56080e7          	jalr	-426(ra) # 3b4 <printint>
 566:	8b4a                	mv	s6,s2
      state = 0;
 568:	4981                	li	s3,0
 56a:	bf91                	j	4be <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 56c:	008b0793          	addi	a5,s6,8
 570:	f8f43423          	sd	a5,-120(s0)
 574:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 578:	03000593          	li	a1,48
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	e14080e7          	jalr	-492(ra) # 392 <putc>
  putc(fd, 'x');
 586:	85ea                	mv	a1,s10
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	e08080e7          	jalr	-504(ra) # 392 <putc>
 592:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 594:	03c9d793          	srli	a5,s3,0x3c
 598:	97de                	add	a5,a5,s7
 59a:	0007c583          	lbu	a1,0(a5)
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	df2080e7          	jalr	-526(ra) # 392 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5a8:	0992                	slli	s3,s3,0x4
 5aa:	397d                	addiw	s2,s2,-1
 5ac:	fe0914e3          	bnez	s2,594 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5b0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	b721                	j	4be <vprintf+0x60>
        s = va_arg(ap, char*);
 5b8:	008b0993          	addi	s3,s6,8
 5bc:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5c0:	02090163          	beqz	s2,5e2 <vprintf+0x184>
        while(*s != 0){
 5c4:	00094583          	lbu	a1,0(s2)
 5c8:	c9a1                	beqz	a1,618 <vprintf+0x1ba>
          putc(fd, *s);
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	dc6080e7          	jalr	-570(ra) # 392 <putc>
          s++;
 5d4:	0905                	addi	s2,s2,1
        while(*s != 0){
 5d6:	00094583          	lbu	a1,0(s2)
 5da:	f9e5                	bnez	a1,5ca <vprintf+0x16c>
        s = va_arg(ap, char*);
 5dc:	8b4e                	mv	s6,s3
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	bdf9                	j	4be <vprintf+0x60>
          s = "(null)";
 5e2:	00000917          	auipc	s2,0x0
 5e6:	34690913          	addi	s2,s2,838 # 928 <csem_up+0x46>
        while(*s != 0){
 5ea:	02800593          	li	a1,40
 5ee:	bff1                	j	5ca <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5f0:	008b0913          	addi	s2,s6,8
 5f4:	000b4583          	lbu	a1,0(s6)
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	d98080e7          	jalr	-616(ra) # 392 <putc>
 602:	8b4a                	mv	s6,s2
      state = 0;
 604:	4981                	li	s3,0
 606:	bd65                	j	4be <vprintf+0x60>
        putc(fd, c);
 608:	85d2                	mv	a1,s4
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	d86080e7          	jalr	-634(ra) # 392 <putc>
      state = 0;
 614:	4981                	li	s3,0
 616:	b565                	j	4be <vprintf+0x60>
        s = va_arg(ap, char*);
 618:	8b4e                	mv	s6,s3
      state = 0;
 61a:	4981                	li	s3,0
 61c:	b54d                	j	4be <vprintf+0x60>
    }
  }
}
 61e:	70e6                	ld	ra,120(sp)
 620:	7446                	ld	s0,112(sp)
 622:	74a6                	ld	s1,104(sp)
 624:	7906                	ld	s2,96(sp)
 626:	69e6                	ld	s3,88(sp)
 628:	6a46                	ld	s4,80(sp)
 62a:	6aa6                	ld	s5,72(sp)
 62c:	6b06                	ld	s6,64(sp)
 62e:	7be2                	ld	s7,56(sp)
 630:	7c42                	ld	s8,48(sp)
 632:	7ca2                	ld	s9,40(sp)
 634:	7d02                	ld	s10,32(sp)
 636:	6de2                	ld	s11,24(sp)
 638:	6109                	addi	sp,sp,128
 63a:	8082                	ret

000000000000063c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 63c:	715d                	addi	sp,sp,-80
 63e:	ec06                	sd	ra,24(sp)
 640:	e822                	sd	s0,16(sp)
 642:	1000                	addi	s0,sp,32
 644:	e010                	sd	a2,0(s0)
 646:	e414                	sd	a3,8(s0)
 648:	e818                	sd	a4,16(s0)
 64a:	ec1c                	sd	a5,24(s0)
 64c:	03043023          	sd	a6,32(s0)
 650:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 654:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 658:	8622                	mv	a2,s0
 65a:	00000097          	auipc	ra,0x0
 65e:	e04080e7          	jalr	-508(ra) # 45e <vprintf>
}
 662:	60e2                	ld	ra,24(sp)
 664:	6442                	ld	s0,16(sp)
 666:	6161                	addi	sp,sp,80
 668:	8082                	ret

000000000000066a <printf>:

void
printf(const char *fmt, ...)
{
 66a:	711d                	addi	sp,sp,-96
 66c:	ec06                	sd	ra,24(sp)
 66e:	e822                	sd	s0,16(sp)
 670:	1000                	addi	s0,sp,32
 672:	e40c                	sd	a1,8(s0)
 674:	e810                	sd	a2,16(s0)
 676:	ec14                	sd	a3,24(s0)
 678:	f018                	sd	a4,32(s0)
 67a:	f41c                	sd	a5,40(s0)
 67c:	03043823          	sd	a6,48(s0)
 680:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 684:	00840613          	addi	a2,s0,8
 688:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 68c:	85aa                	mv	a1,a0
 68e:	4505                	li	a0,1
 690:	00000097          	auipc	ra,0x0
 694:	dce080e7          	jalr	-562(ra) # 45e <vprintf>
}
 698:	60e2                	ld	ra,24(sp)
 69a:	6442                	ld	s0,16(sp)
 69c:	6125                	addi	sp,sp,96
 69e:	8082                	ret

00000000000006a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a0:	1141                	addi	sp,sp,-16
 6a2:	e422                	sd	s0,8(sp)
 6a4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6aa:	00000797          	auipc	a5,0x0
 6ae:	29e7b783          	ld	a5,670(a5) # 948 <freep>
 6b2:	a805                	j	6e2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6b4:	4618                	lw	a4,8(a2)
 6b6:	9db9                	addw	a1,a1,a4
 6b8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6bc:	6398                	ld	a4,0(a5)
 6be:	6318                	ld	a4,0(a4)
 6c0:	fee53823          	sd	a4,-16(a0)
 6c4:	a091                	j	708 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c6:	ff852703          	lw	a4,-8(a0)
 6ca:	9e39                	addw	a2,a2,a4
 6cc:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6ce:	ff053703          	ld	a4,-16(a0)
 6d2:	e398                	sd	a4,0(a5)
 6d4:	a099                	j	71a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d6:	6398                	ld	a4,0(a5)
 6d8:	00e7e463          	bltu	a5,a4,6e0 <free+0x40>
 6dc:	00e6ea63          	bltu	a3,a4,6f0 <free+0x50>
{
 6e0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e2:	fed7fae3          	bgeu	a5,a3,6d6 <free+0x36>
 6e6:	6398                	ld	a4,0(a5)
 6e8:	00e6e463          	bltu	a3,a4,6f0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ec:	fee7eae3          	bltu	a5,a4,6e0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6f0:	ff852583          	lw	a1,-8(a0)
 6f4:	6390                	ld	a2,0(a5)
 6f6:	02059813          	slli	a6,a1,0x20
 6fa:	01c85713          	srli	a4,a6,0x1c
 6fe:	9736                	add	a4,a4,a3
 700:	fae60ae3          	beq	a2,a4,6b4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 704:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 708:	4790                	lw	a2,8(a5)
 70a:	02061593          	slli	a1,a2,0x20
 70e:	01c5d713          	srli	a4,a1,0x1c
 712:	973e                	add	a4,a4,a5
 714:	fae689e3          	beq	a3,a4,6c6 <free+0x26>
  } else
    p->s.ptr = bp;
 718:	e394                	sd	a3,0(a5)
  freep = p;
 71a:	00000717          	auipc	a4,0x0
 71e:	22f73723          	sd	a5,558(a4) # 948 <freep>
}
 722:	6422                	ld	s0,8(sp)
 724:	0141                	addi	sp,sp,16
 726:	8082                	ret

0000000000000728 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 728:	7139                	addi	sp,sp,-64
 72a:	fc06                	sd	ra,56(sp)
 72c:	f822                	sd	s0,48(sp)
 72e:	f426                	sd	s1,40(sp)
 730:	f04a                	sd	s2,32(sp)
 732:	ec4e                	sd	s3,24(sp)
 734:	e852                	sd	s4,16(sp)
 736:	e456                	sd	s5,8(sp)
 738:	e05a                	sd	s6,0(sp)
 73a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 73c:	02051493          	slli	s1,a0,0x20
 740:	9081                	srli	s1,s1,0x20
 742:	04bd                	addi	s1,s1,15
 744:	8091                	srli	s1,s1,0x4
 746:	0014899b          	addiw	s3,s1,1
 74a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 74c:	00000517          	auipc	a0,0x0
 750:	1fc53503          	ld	a0,508(a0) # 948 <freep>
 754:	c515                	beqz	a0,780 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 756:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 758:	4798                	lw	a4,8(a5)
 75a:	02977f63          	bgeu	a4,s1,798 <malloc+0x70>
 75e:	8a4e                	mv	s4,s3
 760:	0009871b          	sext.w	a4,s3
 764:	6685                	lui	a3,0x1
 766:	00d77363          	bgeu	a4,a3,76c <malloc+0x44>
 76a:	6a05                	lui	s4,0x1
 76c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 770:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 774:	00000917          	auipc	s2,0x0
 778:	1d490913          	addi	s2,s2,468 # 948 <freep>
  if(p == (char*)-1)
 77c:	5afd                	li	s5,-1
 77e:	a895                	j	7f2 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 780:	00000797          	auipc	a5,0x0
 784:	1d078793          	addi	a5,a5,464 # 950 <base>
 788:	00000717          	auipc	a4,0x0
 78c:	1cf73023          	sd	a5,448(a4) # 948 <freep>
 790:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 792:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 796:	b7e1                	j	75e <malloc+0x36>
      if(p->s.size == nunits)
 798:	02e48c63          	beq	s1,a4,7d0 <malloc+0xa8>
        p->s.size -= nunits;
 79c:	4137073b          	subw	a4,a4,s3
 7a0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7a2:	02071693          	slli	a3,a4,0x20
 7a6:	01c6d713          	srli	a4,a3,0x1c
 7aa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7ac:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7b0:	00000717          	auipc	a4,0x0
 7b4:	18a73c23          	sd	a0,408(a4) # 948 <freep>
      return (void*)(p + 1);
 7b8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7bc:	70e2                	ld	ra,56(sp)
 7be:	7442                	ld	s0,48(sp)
 7c0:	74a2                	ld	s1,40(sp)
 7c2:	7902                	ld	s2,32(sp)
 7c4:	69e2                	ld	s3,24(sp)
 7c6:	6a42                	ld	s4,16(sp)
 7c8:	6aa2                	ld	s5,8(sp)
 7ca:	6b02                	ld	s6,0(sp)
 7cc:	6121                	addi	sp,sp,64
 7ce:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7d0:	6398                	ld	a4,0(a5)
 7d2:	e118                	sd	a4,0(a0)
 7d4:	bff1                	j	7b0 <malloc+0x88>
  hp->s.size = nu;
 7d6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7da:	0541                	addi	a0,a0,16
 7dc:	00000097          	auipc	ra,0x0
 7e0:	ec4080e7          	jalr	-316(ra) # 6a0 <free>
  return freep;
 7e4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7e8:	d971                	beqz	a0,7bc <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ec:	4798                	lw	a4,8(a5)
 7ee:	fa9775e3          	bgeu	a4,s1,798 <malloc+0x70>
    if(p == freep)
 7f2:	00093703          	ld	a4,0(s2)
 7f6:	853e                	mv	a0,a5
 7f8:	fef719e3          	bne	a4,a5,7ea <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7fc:	8552                	mv	a0,s4
 7fe:	00000097          	auipc	ra,0x0
 802:	b22080e7          	jalr	-1246(ra) # 320 <sbrk>
  if(p == (char*)-1)
 806:	fd5518e3          	bne	a0,s5,7d6 <malloc+0xae>
        return 0;
 80a:	4501                	li	a0,0
 80c:	bf45                	j	7bc <malloc+0x94>

000000000000080e <csem_alloc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int csem_alloc(struct counting_semaphore *sem, int initial_value){
 80e:	1101                	addi	sp,sp,-32
 810:	ec06                	sd	ra,24(sp)
 812:	e822                	sd	s0,16(sp)
 814:	e426                	sd	s1,8(sp)
 816:	e04a                	sd	s2,0(sp)
 818:	1000                	addi	s0,sp,32
 81a:	84aa                	mv	s1,a0
 81c:	892e                	mv	s2,a1
    sem->binary_semaphore1 = bsem_alloc();
 81e:	00000097          	auipc	ra,0x0
 822:	b52080e7          	jalr	-1198(ra) # 370 <bsem_alloc>
 826:	c088                	sw	a0,0(s1)
    sem->binary_semaphore2 = bsem_alloc();
 828:	00000097          	auipc	ra,0x0
 82c:	b48080e7          	jalr	-1208(ra) # 370 <bsem_alloc>
 830:	87aa                	mv	a5,a0
 832:	c0c8                	sw	a0,4(s1)
    if(sem->binary_semaphore1 == -1 || sem->binary_semaphore2 == -1)
 834:	4088                	lw	a0,0(s1)
 836:	577d                	li	a4,-1
 838:	00e50963          	beq	a0,a4,84a <csem_alloc+0x3c>
 83c:	02e78363          	beq	a5,a4,862 <csem_alloc+0x54>
        return -1;
    if(initial_value == 0)
 840:	00090b63          	beqz	s2,856 <csem_alloc+0x48>
        bsem_down(sem->binary_semaphore2);
    sem->value = initial_value;
 844:	0124a423          	sw	s2,8(s1)
    return 0;
 848:	4501                	li	a0,0
}
 84a:	60e2                	ld	ra,24(sp)
 84c:	6442                	ld	s0,16(sp)
 84e:	64a2                	ld	s1,8(sp)
 850:	6902                	ld	s2,0(sp)
 852:	6105                	addi	sp,sp,32
 854:	8082                	ret
        bsem_down(sem->binary_semaphore2);
 856:	853e                	mv	a0,a5
 858:	00000097          	auipc	ra,0x0
 85c:	b28080e7          	jalr	-1240(ra) # 380 <bsem_down>
 860:	b7d5                	j	844 <csem_alloc+0x36>
        return -1;
 862:	853e                	mv	a0,a5
 864:	b7dd                	j	84a <csem_alloc+0x3c>

0000000000000866 <csem_free>:

void csem_free(struct counting_semaphore *sem){
 866:	1101                	addi	sp,sp,-32
 868:	ec06                	sd	ra,24(sp)
 86a:	e822                	sd	s0,16(sp)
 86c:	e426                	sd	s1,8(sp)
 86e:	1000                	addi	s0,sp,32
 870:	84aa                	mv	s1,a0
    bsem_free(sem->binary_semaphore1);
 872:	4108                	lw	a0,0(a0)
 874:	00000097          	auipc	ra,0x0
 878:	b04080e7          	jalr	-1276(ra) # 378 <bsem_free>
    bsem_free(sem->binary_semaphore2);
 87c:	40c8                	lw	a0,4(s1)
 87e:	00000097          	auipc	ra,0x0
 882:	afa080e7          	jalr	-1286(ra) # 378 <bsem_free>
    sem->value = 0;
 886:	0004a423          	sw	zero,8(s1)
}
 88a:	60e2                	ld	ra,24(sp)
 88c:	6442                	ld	s0,16(sp)
 88e:	64a2                	ld	s1,8(sp)
 890:	6105                	addi	sp,sp,32
 892:	8082                	ret

0000000000000894 <csem_down>:

void csem_down(struct counting_semaphore *sem){
 894:	1101                	addi	sp,sp,-32
 896:	ec06                	sd	ra,24(sp)
 898:	e822                	sd	s0,16(sp)
 89a:	e426                	sd	s1,8(sp)
 89c:	1000                	addi	s0,sp,32
 89e:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore2);
 8a0:	4148                	lw	a0,4(a0)
 8a2:	00000097          	auipc	ra,0x0
 8a6:	ade080e7          	jalr	-1314(ra) # 380 <bsem_down>
    bsem_down(sem->binary_semaphore1);
 8aa:	4088                	lw	a0,0(s1)
 8ac:	00000097          	auipc	ra,0x0
 8b0:	ad4080e7          	jalr	-1324(ra) # 380 <bsem_down>
    sem->value--;
 8b4:	449c                	lw	a5,8(s1)
 8b6:	37fd                	addiw	a5,a5,-1
 8b8:	0007871b          	sext.w	a4,a5
 8bc:	c49c                	sw	a5,8(s1)
    if(sem->value > 0)
 8be:	00e04c63          	bgtz	a4,8d6 <csem_down+0x42>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
 8c2:	4088                	lw	a0,0(s1)
 8c4:	00000097          	auipc	ra,0x0
 8c8:	ac4080e7          	jalr	-1340(ra) # 388 <bsem_up>
}
 8cc:	60e2                	ld	ra,24(sp)
 8ce:	6442                	ld	s0,16(sp)
 8d0:	64a2                	ld	s1,8(sp)
 8d2:	6105                	addi	sp,sp,32
 8d4:	8082                	ret
        bsem_up(sem->binary_semaphore2);
 8d6:	40c8                	lw	a0,4(s1)
 8d8:	00000097          	auipc	ra,0x0
 8dc:	ab0080e7          	jalr	-1360(ra) # 388 <bsem_up>
 8e0:	b7cd                	j	8c2 <csem_down+0x2e>

00000000000008e2 <csem_up>:

void csem_up(struct counting_semaphore *sem){
 8e2:	1101                	addi	sp,sp,-32
 8e4:	ec06                	sd	ra,24(sp)
 8e6:	e822                	sd	s0,16(sp)
 8e8:	e426                	sd	s1,8(sp)
 8ea:	1000                	addi	s0,sp,32
 8ec:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore1);
 8ee:	4108                	lw	a0,0(a0)
 8f0:	00000097          	auipc	ra,0x0
 8f4:	a90080e7          	jalr	-1392(ra) # 380 <bsem_down>
    sem->value++;
 8f8:	449c                	lw	a5,8(s1)
 8fa:	2785                	addiw	a5,a5,1
 8fc:	0007871b          	sext.w	a4,a5
 900:	c49c                	sw	a5,8(s1)
    if(sem->value == 1)
 902:	4785                	li	a5,1
 904:	00f70c63          	beq	a4,a5,91c <csem_up+0x3a>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
 908:	4088                	lw	a0,0(s1)
 90a:	00000097          	auipc	ra,0x0
 90e:	a7e080e7          	jalr	-1410(ra) # 388 <bsem_up>
 912:	60e2                	ld	ra,24(sp)
 914:	6442                	ld	s0,16(sp)
 916:	64a2                	ld	s1,8(sp)
 918:	6105                	addi	sp,sp,32
 91a:	8082                	ret
        bsem_up(sem->binary_semaphore2);
 91c:	40c8                	lw	a0,4(s1)
 91e:	00000097          	auipc	ra,0x0
 922:	a6a080e7          	jalr	-1430(ra) # 388 <bsem_up>
 926:	b7cd                	j	908 <csem_up+0x26>
