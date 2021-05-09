
user/_rm:     file format elf64-littleriscv


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
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d763          	bge	a5,a0,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	02091793          	slli	a5,s2,0x20
  20:	01d7d913          	srli	s2,a5,0x1d
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	30c080e7          	jalr	780(ra) # 336 <unlink>
  32:	02054463          	bltz	a0,5a <main+0x5a>
  for(i = 1; i < argc; i++){
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a80d                	j	6e <main+0x6e>
    fprintf(2, "Usage: rm files...\n");
  3e:	00001597          	auipc	a1,0x1
  42:	93a58593          	addi	a1,a1,-1734 # 978 <csem_up+0x48>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	642080e7          	jalr	1602(ra) # 68a <fprintf>
    exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	294080e7          	jalr	660(ra) # 2e6 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	6090                	ld	a2,0(s1)
  5c:	00001597          	auipc	a1,0x1
  60:	93458593          	addi	a1,a1,-1740 # 990 <csem_up+0x60>
  64:	4509                	li	a0,2
  66:	00000097          	auipc	ra,0x0
  6a:	624080e7          	jalr	1572(ra) # 68a <fprintf>
      break;
    }
  }

  exit(0);
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	276080e7          	jalr	630(ra) # 2e6 <exit>

0000000000000078 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0x8>
    ;
  return os;
}
  8e:	6422                	ld	s0,8(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	cb91                	beqz	a5,b2 <strcmp+0x1e>
  a0:	0005c703          	lbu	a4,0(a1)
  a4:	00f71763          	bne	a4,a5,b2 <strcmp+0x1e>
    p++, q++;
  a8:	0505                	addi	a0,a0,1
  aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	fbe5                	bnez	a5,a0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b2:	0005c503          	lbu	a0,0(a1)
}
  b6:	40a7853b          	subw	a0,a5,a0
  ba:	6422                	ld	s0,8(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cf91                	beqz	a5,e6 <strlen+0x26>
  cc:	0505                	addi	a0,a0,1
  ce:	87aa                	mv	a5,a0
  d0:	4685                	li	a3,1
  d2:	9e89                	subw	a3,a3,a0
  d4:	00f6853b          	addw	a0,a3,a5
  d8:	0785                	addi	a5,a5,1
  da:	fff7c703          	lbu	a4,-1(a5)
  de:	fb7d                	bnez	a4,d4 <strlen+0x14>
    ;
  return n;
}
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret
  for(n = 0; s[n]; n++)
  e6:	4501                	li	a0,0
  e8:	bfe5                	j	e0 <strlen+0x20>

00000000000000ea <memset>:

void*
memset(void *dst, int c, uint n)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f0:	ca19                	beqz	a2,106 <memset+0x1c>
  f2:	87aa                	mv	a5,a0
  f4:	1602                	slli	a2,a2,0x20
  f6:	9201                	srli	a2,a2,0x20
  f8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 100:	0785                	addi	a5,a5,1
 102:	fee79de3          	bne	a5,a4,fc <memset+0x12>
  }
  return dst;
}
 106:	6422                	ld	s0,8(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret

000000000000010c <strchr>:

char*
strchr(const char *s, char c)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  for(; *s; s++)
 112:	00054783          	lbu	a5,0(a0)
 116:	cb99                	beqz	a5,12c <strchr+0x20>
    if(*s == c)
 118:	00f58763          	beq	a1,a5,126 <strchr+0x1a>
  for(; *s; s++)
 11c:	0505                	addi	a0,a0,1
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbfd                	bnez	a5,118 <strchr+0xc>
      return (char*)s;
  return 0;
 124:	4501                	li	a0,0
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret
  return 0;
 12c:	4501                	li	a0,0
 12e:	bfe5                	j	126 <strchr+0x1a>

0000000000000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	711d                	addi	sp,sp,-96
 132:	ec86                	sd	ra,88(sp)
 134:	e8a2                	sd	s0,80(sp)
 136:	e4a6                	sd	s1,72(sp)
 138:	e0ca                	sd	s2,64(sp)
 13a:	fc4e                	sd	s3,56(sp)
 13c:	f852                	sd	s4,48(sp)
 13e:	f456                	sd	s5,40(sp)
 140:	f05a                	sd	s6,32(sp)
 142:	ec5e                	sd	s7,24(sp)
 144:	1080                	addi	s0,sp,96
 146:	8baa                	mv	s7,a0
 148:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14a:	892a                	mv	s2,a0
 14c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14e:	4aa9                	li	s5,10
 150:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 152:	89a6                	mv	s3,s1
 154:	2485                	addiw	s1,s1,1
 156:	0344d863          	bge	s1,s4,186 <gets+0x56>
    cc = read(0, &c, 1);
 15a:	4605                	li	a2,1
 15c:	faf40593          	addi	a1,s0,-81
 160:	4501                	li	a0,0
 162:	00000097          	auipc	ra,0x0
 166:	19c080e7          	jalr	412(ra) # 2fe <read>
    if(cc < 1)
 16a:	00a05e63          	blez	a0,186 <gets+0x56>
    buf[i++] = c;
 16e:	faf44783          	lbu	a5,-81(s0)
 172:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 176:	01578763          	beq	a5,s5,184 <gets+0x54>
 17a:	0905                	addi	s2,s2,1
 17c:	fd679be3          	bne	a5,s6,152 <gets+0x22>
  for(i=0; i+1 < max; ){
 180:	89a6                	mv	s3,s1
 182:	a011                	j	186 <gets+0x56>
 184:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 186:	99de                	add	s3,s3,s7
 188:	00098023          	sb	zero,0(s3)
  return buf;
}
 18c:	855e                	mv	a0,s7
 18e:	60e6                	ld	ra,88(sp)
 190:	6446                	ld	s0,80(sp)
 192:	64a6                	ld	s1,72(sp)
 194:	6906                	ld	s2,64(sp)
 196:	79e2                	ld	s3,56(sp)
 198:	7a42                	ld	s4,48(sp)
 19a:	7aa2                	ld	s5,40(sp)
 19c:	7b02                	ld	s6,32(sp)
 19e:	6be2                	ld	s7,24(sp)
 1a0:	6125                	addi	sp,sp,96
 1a2:	8082                	ret

00000000000001a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a4:	1101                	addi	sp,sp,-32
 1a6:	ec06                	sd	ra,24(sp)
 1a8:	e822                	sd	s0,16(sp)
 1aa:	e426                	sd	s1,8(sp)
 1ac:	e04a                	sd	s2,0(sp)
 1ae:	1000                	addi	s0,sp,32
 1b0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b2:	4581                	li	a1,0
 1b4:	00000097          	auipc	ra,0x0
 1b8:	172080e7          	jalr	370(ra) # 326 <open>
  if(fd < 0)
 1bc:	02054563          	bltz	a0,1e6 <stat+0x42>
 1c0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c2:	85ca                	mv	a1,s2
 1c4:	00000097          	auipc	ra,0x0
 1c8:	17a080e7          	jalr	378(ra) # 33e <fstat>
 1cc:	892a                	mv	s2,a0
  close(fd);
 1ce:	8526                	mv	a0,s1
 1d0:	00000097          	auipc	ra,0x0
 1d4:	13e080e7          	jalr	318(ra) # 30e <close>
  return r;
}
 1d8:	854a                	mv	a0,s2
 1da:	60e2                	ld	ra,24(sp)
 1dc:	6442                	ld	s0,16(sp)
 1de:	64a2                	ld	s1,8(sp)
 1e0:	6902                	ld	s2,0(sp)
 1e2:	6105                	addi	sp,sp,32
 1e4:	8082                	ret
    return -1;
 1e6:	597d                	li	s2,-1
 1e8:	bfc5                	j	1d8 <stat+0x34>

00000000000001ea <atoi>:

int
atoi(const char *s)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e422                	sd	s0,8(sp)
 1ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f0:	00054603          	lbu	a2,0(a0)
 1f4:	fd06079b          	addiw	a5,a2,-48
 1f8:	0ff7f793          	andi	a5,a5,255
 1fc:	4725                	li	a4,9
 1fe:	02f76963          	bltu	a4,a5,230 <atoi+0x46>
 202:	86aa                	mv	a3,a0
  n = 0;
 204:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 206:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 208:	0685                	addi	a3,a3,1
 20a:	0025179b          	slliw	a5,a0,0x2
 20e:	9fa9                	addw	a5,a5,a0
 210:	0017979b          	slliw	a5,a5,0x1
 214:	9fb1                	addw	a5,a5,a2
 216:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21a:	0006c603          	lbu	a2,0(a3)
 21e:	fd06071b          	addiw	a4,a2,-48
 222:	0ff77713          	andi	a4,a4,255
 226:	fee5f1e3          	bgeu	a1,a4,208 <atoi+0x1e>
  return n;
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret
  n = 0;
 230:	4501                	li	a0,0
 232:	bfe5                	j	22a <atoi+0x40>

0000000000000234 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23a:	02b57463          	bgeu	a0,a1,262 <memmove+0x2e>
    while(n-- > 0)
 23e:	00c05f63          	blez	a2,25c <memmove+0x28>
 242:	1602                	slli	a2,a2,0x20
 244:	9201                	srli	a2,a2,0x20
 246:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24a:	872a                	mv	a4,a0
      *dst++ = *src++;
 24c:	0585                	addi	a1,a1,1
 24e:	0705                	addi	a4,a4,1
 250:	fff5c683          	lbu	a3,-1(a1)
 254:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 258:	fee79ae3          	bne	a5,a4,24c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
    dst += n;
 262:	00c50733          	add	a4,a0,a2
    src += n;
 266:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 268:	fec05ae3          	blez	a2,25c <memmove+0x28>
 26c:	fff6079b          	addiw	a5,a2,-1
 270:	1782                	slli	a5,a5,0x20
 272:	9381                	srli	a5,a5,0x20
 274:	fff7c793          	not	a5,a5
 278:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27a:	15fd                	addi	a1,a1,-1
 27c:	177d                	addi	a4,a4,-1
 27e:	0005c683          	lbu	a3,0(a1)
 282:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x46>
 28a:	bfc9                	j	25c <memmove+0x28>

000000000000028c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 292:	ca05                	beqz	a2,2c2 <memcmp+0x36>
 294:	fff6069b          	addiw	a3,a2,-1
 298:	1682                	slli	a3,a3,0x20
 29a:	9281                	srli	a3,a3,0x20
 29c:	0685                	addi	a3,a3,1
 29e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	0005c703          	lbu	a4,0(a1)
 2a8:	00e79863          	bne	a5,a4,2b8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ac:	0505                	addi	a0,a0,1
    p2++;
 2ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b0:	fed518e3          	bne	a0,a3,2a0 <memcmp+0x14>
  }
  return 0;
 2b4:	4501                	li	a0,0
 2b6:	a019                	j	2bc <memcmp+0x30>
      return *p1 - *p2;
 2b8:	40e7853b          	subw	a0,a5,a4
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
  return 0;
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <memcmp+0x30>

00000000000002c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ce:	00000097          	auipc	ra,0x0
 2d2:	f66080e7          	jalr	-154(ra) # 234 <memmove>
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2de:	4885                	li	a7,1
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e6:	4889                	li	a7,2
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ee:	488d                	li	a7,3
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f6:	4891                	li	a7,4
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <read>:
.global read
read:
 li a7, SYS_read
 2fe:	4895                	li	a7,5
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <write>:
.global write
write:
 li a7, SYS_write
 306:	48c1                	li	a7,16
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <close>:
.global close
close:
 li a7, SYS_close
 30e:	48d5                	li	a7,21
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <kill>:
.global kill
kill:
 li a7, SYS_kill
 316:	4899                	li	a7,6
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <exec>:
.global exec
exec:
 li a7, SYS_exec
 31e:	489d                	li	a7,7
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <open>:
.global open
open:
 li a7, SYS_open
 326:	48bd                	li	a7,15
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 32e:	48c5                	li	a7,17
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 336:	48c9                	li	a7,18
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 33e:	48a1                	li	a7,8
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <link>:
.global link
link:
 li a7, SYS_link
 346:	48cd                	li	a7,19
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 34e:	48d1                	li	a7,20
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 356:	48a5                	li	a7,9
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <dup>:
.global dup
dup:
 li a7, SYS_dup
 35e:	48a9                	li	a7,10
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 366:	48ad                	li	a7,11
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 36e:	48b1                	li	a7,12
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 376:	48b5                	li	a7,13
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 37e:	48b9                	li	a7,14
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 386:	48d9                	li	a7,22
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 38e:	48dd                	li	a7,23
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 396:	48e1                	li	a7,24
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 39e:	48e5                	li	a7,25
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 3a6:	48e9                	li	a7,26
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 3ae:	48ed                	li	a7,27
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 3b6:	48f1                	li	a7,28
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 3be:	48f5                	li	a7,29
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 3c6:	48f9                	li	a7,30
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 3ce:	48fd                	li	a7,31
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 3d6:	02000893          	li	a7,32
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e0:	1101                	addi	sp,sp,-32
 3e2:	ec06                	sd	ra,24(sp)
 3e4:	e822                	sd	s0,16(sp)
 3e6:	1000                	addi	s0,sp,32
 3e8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ec:	4605                	li	a2,1
 3ee:	fef40593          	addi	a1,s0,-17
 3f2:	00000097          	auipc	ra,0x0
 3f6:	f14080e7          	jalr	-236(ra) # 306 <write>
}
 3fa:	60e2                	ld	ra,24(sp)
 3fc:	6442                	ld	s0,16(sp)
 3fe:	6105                	addi	sp,sp,32
 400:	8082                	ret

0000000000000402 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 402:	7139                	addi	sp,sp,-64
 404:	fc06                	sd	ra,56(sp)
 406:	f822                	sd	s0,48(sp)
 408:	f426                	sd	s1,40(sp)
 40a:	f04a                	sd	s2,32(sp)
 40c:	ec4e                	sd	s3,24(sp)
 40e:	0080                	addi	s0,sp,64
 410:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 412:	c299                	beqz	a3,418 <printint+0x16>
 414:	0805c863          	bltz	a1,4a4 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 418:	2581                	sext.w	a1,a1
  neg = 0;
 41a:	4881                	li	a7,0
 41c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 420:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 422:	2601                	sext.w	a2,a2
 424:	00000517          	auipc	a0,0x0
 428:	59450513          	addi	a0,a0,1428 # 9b8 <digits>
 42c:	883a                	mv	a6,a4
 42e:	2705                	addiw	a4,a4,1
 430:	02c5f7bb          	remuw	a5,a1,a2
 434:	1782                	slli	a5,a5,0x20
 436:	9381                	srli	a5,a5,0x20
 438:	97aa                	add	a5,a5,a0
 43a:	0007c783          	lbu	a5,0(a5)
 43e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 442:	0005879b          	sext.w	a5,a1
 446:	02c5d5bb          	divuw	a1,a1,a2
 44a:	0685                	addi	a3,a3,1
 44c:	fec7f0e3          	bgeu	a5,a2,42c <printint+0x2a>
  if(neg)
 450:	00088b63          	beqz	a7,466 <printint+0x64>
    buf[i++] = '-';
 454:	fd040793          	addi	a5,s0,-48
 458:	973e                	add	a4,a4,a5
 45a:	02d00793          	li	a5,45
 45e:	fef70823          	sb	a5,-16(a4)
 462:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 466:	02e05863          	blez	a4,496 <printint+0x94>
 46a:	fc040793          	addi	a5,s0,-64
 46e:	00e78933          	add	s2,a5,a4
 472:	fff78993          	addi	s3,a5,-1
 476:	99ba                	add	s3,s3,a4
 478:	377d                	addiw	a4,a4,-1
 47a:	1702                	slli	a4,a4,0x20
 47c:	9301                	srli	a4,a4,0x20
 47e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 482:	fff94583          	lbu	a1,-1(s2)
 486:	8526                	mv	a0,s1
 488:	00000097          	auipc	ra,0x0
 48c:	f58080e7          	jalr	-168(ra) # 3e0 <putc>
  while(--i >= 0)
 490:	197d                	addi	s2,s2,-1
 492:	ff3918e3          	bne	s2,s3,482 <printint+0x80>
}
 496:	70e2                	ld	ra,56(sp)
 498:	7442                	ld	s0,48(sp)
 49a:	74a2                	ld	s1,40(sp)
 49c:	7902                	ld	s2,32(sp)
 49e:	69e2                	ld	s3,24(sp)
 4a0:	6121                	addi	sp,sp,64
 4a2:	8082                	ret
    x = -xx;
 4a4:	40b005bb          	negw	a1,a1
    neg = 1;
 4a8:	4885                	li	a7,1
    x = -xx;
 4aa:	bf8d                	j	41c <printint+0x1a>

00000000000004ac <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ac:	7119                	addi	sp,sp,-128
 4ae:	fc86                	sd	ra,120(sp)
 4b0:	f8a2                	sd	s0,112(sp)
 4b2:	f4a6                	sd	s1,104(sp)
 4b4:	f0ca                	sd	s2,96(sp)
 4b6:	ecce                	sd	s3,88(sp)
 4b8:	e8d2                	sd	s4,80(sp)
 4ba:	e4d6                	sd	s5,72(sp)
 4bc:	e0da                	sd	s6,64(sp)
 4be:	fc5e                	sd	s7,56(sp)
 4c0:	f862                	sd	s8,48(sp)
 4c2:	f466                	sd	s9,40(sp)
 4c4:	f06a                	sd	s10,32(sp)
 4c6:	ec6e                	sd	s11,24(sp)
 4c8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ca:	0005c903          	lbu	s2,0(a1)
 4ce:	18090f63          	beqz	s2,66c <vprintf+0x1c0>
 4d2:	8aaa                	mv	s5,a0
 4d4:	8b32                	mv	s6,a2
 4d6:	00158493          	addi	s1,a1,1
  state = 0;
 4da:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4dc:	02500a13          	li	s4,37
      if(c == 'd'){
 4e0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4e4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4e8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4ec:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4f0:	00000b97          	auipc	s7,0x0
 4f4:	4c8b8b93          	addi	s7,s7,1224 # 9b8 <digits>
 4f8:	a839                	j	516 <vprintf+0x6a>
        putc(fd, c);
 4fa:	85ca                	mv	a1,s2
 4fc:	8556                	mv	a0,s5
 4fe:	00000097          	auipc	ra,0x0
 502:	ee2080e7          	jalr	-286(ra) # 3e0 <putc>
 506:	a019                	j	50c <vprintf+0x60>
    } else if(state == '%'){
 508:	01498f63          	beq	s3,s4,526 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 50c:	0485                	addi	s1,s1,1
 50e:	fff4c903          	lbu	s2,-1(s1)
 512:	14090d63          	beqz	s2,66c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 516:	0009079b          	sext.w	a5,s2
    if(state == 0){
 51a:	fe0997e3          	bnez	s3,508 <vprintf+0x5c>
      if(c == '%'){
 51e:	fd479ee3          	bne	a5,s4,4fa <vprintf+0x4e>
        state = '%';
 522:	89be                	mv	s3,a5
 524:	b7e5                	j	50c <vprintf+0x60>
      if(c == 'd'){
 526:	05878063          	beq	a5,s8,566 <vprintf+0xba>
      } else if(c == 'l') {
 52a:	05978c63          	beq	a5,s9,582 <vprintf+0xd6>
      } else if(c == 'x') {
 52e:	07a78863          	beq	a5,s10,59e <vprintf+0xf2>
      } else if(c == 'p') {
 532:	09b78463          	beq	a5,s11,5ba <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 536:	07300713          	li	a4,115
 53a:	0ce78663          	beq	a5,a4,606 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 53e:	06300713          	li	a4,99
 542:	0ee78e63          	beq	a5,a4,63e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 546:	11478863          	beq	a5,s4,656 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 54a:	85d2                	mv	a1,s4
 54c:	8556                	mv	a0,s5
 54e:	00000097          	auipc	ra,0x0
 552:	e92080e7          	jalr	-366(ra) # 3e0 <putc>
        putc(fd, c);
 556:	85ca                	mv	a1,s2
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e86080e7          	jalr	-378(ra) # 3e0 <putc>
      }
      state = 0;
 562:	4981                	li	s3,0
 564:	b765                	j	50c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 566:	008b0913          	addi	s2,s6,8
 56a:	4685                	li	a3,1
 56c:	4629                	li	a2,10
 56e:	000b2583          	lw	a1,0(s6)
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	e8e080e7          	jalr	-370(ra) # 402 <printint>
 57c:	8b4a                	mv	s6,s2
      state = 0;
 57e:	4981                	li	s3,0
 580:	b771                	j	50c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 582:	008b0913          	addi	s2,s6,8
 586:	4681                	li	a3,0
 588:	4629                	li	a2,10
 58a:	000b2583          	lw	a1,0(s6)
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	e72080e7          	jalr	-398(ra) # 402 <printint>
 598:	8b4a                	mv	s6,s2
      state = 0;
 59a:	4981                	li	s3,0
 59c:	bf85                	j	50c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 59e:	008b0913          	addi	s2,s6,8
 5a2:	4681                	li	a3,0
 5a4:	4641                	li	a2,16
 5a6:	000b2583          	lw	a1,0(s6)
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	e56080e7          	jalr	-426(ra) # 402 <printint>
 5b4:	8b4a                	mv	s6,s2
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	bf91                	j	50c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5ba:	008b0793          	addi	a5,s6,8
 5be:	f8f43423          	sd	a5,-120(s0)
 5c2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5c6:	03000593          	li	a1,48
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	e14080e7          	jalr	-492(ra) # 3e0 <putc>
  putc(fd, 'x');
 5d4:	85ea                	mv	a1,s10
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e08080e7          	jalr	-504(ra) # 3e0 <putc>
 5e0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e2:	03c9d793          	srli	a5,s3,0x3c
 5e6:	97de                	add	a5,a5,s7
 5e8:	0007c583          	lbu	a1,0(a5)
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	df2080e7          	jalr	-526(ra) # 3e0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f6:	0992                	slli	s3,s3,0x4
 5f8:	397d                	addiw	s2,s2,-1
 5fa:	fe0914e3          	bnez	s2,5e2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5fe:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 602:	4981                	li	s3,0
 604:	b721                	j	50c <vprintf+0x60>
        s = va_arg(ap, char*);
 606:	008b0993          	addi	s3,s6,8
 60a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 60e:	02090163          	beqz	s2,630 <vprintf+0x184>
        while(*s != 0){
 612:	00094583          	lbu	a1,0(s2)
 616:	c9a1                	beqz	a1,666 <vprintf+0x1ba>
          putc(fd, *s);
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	dc6080e7          	jalr	-570(ra) # 3e0 <putc>
          s++;
 622:	0905                	addi	s2,s2,1
        while(*s != 0){
 624:	00094583          	lbu	a1,0(s2)
 628:	f9e5                	bnez	a1,618 <vprintf+0x16c>
        s = va_arg(ap, char*);
 62a:	8b4e                	mv	s6,s3
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bdf9                	j	50c <vprintf+0x60>
          s = "(null)";
 630:	00000917          	auipc	s2,0x0
 634:	38090913          	addi	s2,s2,896 # 9b0 <csem_up+0x80>
        while(*s != 0){
 638:	02800593          	li	a1,40
 63c:	bff1                	j	618 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 63e:	008b0913          	addi	s2,s6,8
 642:	000b4583          	lbu	a1,0(s6)
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	d98080e7          	jalr	-616(ra) # 3e0 <putc>
 650:	8b4a                	mv	s6,s2
      state = 0;
 652:	4981                	li	s3,0
 654:	bd65                	j	50c <vprintf+0x60>
        putc(fd, c);
 656:	85d2                	mv	a1,s4
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	d86080e7          	jalr	-634(ra) # 3e0 <putc>
      state = 0;
 662:	4981                	li	s3,0
 664:	b565                	j	50c <vprintf+0x60>
        s = va_arg(ap, char*);
 666:	8b4e                	mv	s6,s3
      state = 0;
 668:	4981                	li	s3,0
 66a:	b54d                	j	50c <vprintf+0x60>
    }
  }
}
 66c:	70e6                	ld	ra,120(sp)
 66e:	7446                	ld	s0,112(sp)
 670:	74a6                	ld	s1,104(sp)
 672:	7906                	ld	s2,96(sp)
 674:	69e6                	ld	s3,88(sp)
 676:	6a46                	ld	s4,80(sp)
 678:	6aa6                	ld	s5,72(sp)
 67a:	6b06                	ld	s6,64(sp)
 67c:	7be2                	ld	s7,56(sp)
 67e:	7c42                	ld	s8,48(sp)
 680:	7ca2                	ld	s9,40(sp)
 682:	7d02                	ld	s10,32(sp)
 684:	6de2                	ld	s11,24(sp)
 686:	6109                	addi	sp,sp,128
 688:	8082                	ret

000000000000068a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 68a:	715d                	addi	sp,sp,-80
 68c:	ec06                	sd	ra,24(sp)
 68e:	e822                	sd	s0,16(sp)
 690:	1000                	addi	s0,sp,32
 692:	e010                	sd	a2,0(s0)
 694:	e414                	sd	a3,8(s0)
 696:	e818                	sd	a4,16(s0)
 698:	ec1c                	sd	a5,24(s0)
 69a:	03043023          	sd	a6,32(s0)
 69e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a6:	8622                	mv	a2,s0
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e04080e7          	jalr	-508(ra) # 4ac <vprintf>
}
 6b0:	60e2                	ld	ra,24(sp)
 6b2:	6442                	ld	s0,16(sp)
 6b4:	6161                	addi	sp,sp,80
 6b6:	8082                	ret

00000000000006b8 <printf>:

void
printf(const char *fmt, ...)
{
 6b8:	711d                	addi	sp,sp,-96
 6ba:	ec06                	sd	ra,24(sp)
 6bc:	e822                	sd	s0,16(sp)
 6be:	1000                	addi	s0,sp,32
 6c0:	e40c                	sd	a1,8(s0)
 6c2:	e810                	sd	a2,16(s0)
 6c4:	ec14                	sd	a3,24(s0)
 6c6:	f018                	sd	a4,32(s0)
 6c8:	f41c                	sd	a5,40(s0)
 6ca:	03043823          	sd	a6,48(s0)
 6ce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d2:	00840613          	addi	a2,s0,8
 6d6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6da:	85aa                	mv	a1,a0
 6dc:	4505                	li	a0,1
 6de:	00000097          	auipc	ra,0x0
 6e2:	dce080e7          	jalr	-562(ra) # 4ac <vprintf>
}
 6e6:	60e2                	ld	ra,24(sp)
 6e8:	6442                	ld	s0,16(sp)
 6ea:	6125                	addi	sp,sp,96
 6ec:	8082                	ret

00000000000006ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ee:	1141                	addi	sp,sp,-16
 6f0:	e422                	sd	s0,8(sp)
 6f2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f8:	00000797          	auipc	a5,0x0
 6fc:	2d87b783          	ld	a5,728(a5) # 9d0 <freep>
 700:	a805                	j	730 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 702:	4618                	lw	a4,8(a2)
 704:	9db9                	addw	a1,a1,a4
 706:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 70a:	6398                	ld	a4,0(a5)
 70c:	6318                	ld	a4,0(a4)
 70e:	fee53823          	sd	a4,-16(a0)
 712:	a091                	j	756 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 714:	ff852703          	lw	a4,-8(a0)
 718:	9e39                	addw	a2,a2,a4
 71a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 71c:	ff053703          	ld	a4,-16(a0)
 720:	e398                	sd	a4,0(a5)
 722:	a099                	j	768 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 724:	6398                	ld	a4,0(a5)
 726:	00e7e463          	bltu	a5,a4,72e <free+0x40>
 72a:	00e6ea63          	bltu	a3,a4,73e <free+0x50>
{
 72e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	fed7fae3          	bgeu	a5,a3,724 <free+0x36>
 734:	6398                	ld	a4,0(a5)
 736:	00e6e463          	bltu	a3,a4,73e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73a:	fee7eae3          	bltu	a5,a4,72e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 73e:	ff852583          	lw	a1,-8(a0)
 742:	6390                	ld	a2,0(a5)
 744:	02059813          	slli	a6,a1,0x20
 748:	01c85713          	srli	a4,a6,0x1c
 74c:	9736                	add	a4,a4,a3
 74e:	fae60ae3          	beq	a2,a4,702 <free+0x14>
    bp->s.ptr = p->s.ptr;
 752:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 756:	4790                	lw	a2,8(a5)
 758:	02061593          	slli	a1,a2,0x20
 75c:	01c5d713          	srli	a4,a1,0x1c
 760:	973e                	add	a4,a4,a5
 762:	fae689e3          	beq	a3,a4,714 <free+0x26>
  } else
    p->s.ptr = bp;
 766:	e394                	sd	a3,0(a5)
  freep = p;
 768:	00000717          	auipc	a4,0x0
 76c:	26f73423          	sd	a5,616(a4) # 9d0 <freep>
}
 770:	6422                	ld	s0,8(sp)
 772:	0141                	addi	sp,sp,16
 774:	8082                	ret

0000000000000776 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 776:	7139                	addi	sp,sp,-64
 778:	fc06                	sd	ra,56(sp)
 77a:	f822                	sd	s0,48(sp)
 77c:	f426                	sd	s1,40(sp)
 77e:	f04a                	sd	s2,32(sp)
 780:	ec4e                	sd	s3,24(sp)
 782:	e852                	sd	s4,16(sp)
 784:	e456                	sd	s5,8(sp)
 786:	e05a                	sd	s6,0(sp)
 788:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78a:	02051493          	slli	s1,a0,0x20
 78e:	9081                	srli	s1,s1,0x20
 790:	04bd                	addi	s1,s1,15
 792:	8091                	srli	s1,s1,0x4
 794:	0014899b          	addiw	s3,s1,1
 798:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 79a:	00000517          	auipc	a0,0x0
 79e:	23653503          	ld	a0,566(a0) # 9d0 <freep>
 7a2:	c515                	beqz	a0,7ce <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a6:	4798                	lw	a4,8(a5)
 7a8:	02977f63          	bgeu	a4,s1,7e6 <malloc+0x70>
 7ac:	8a4e                	mv	s4,s3
 7ae:	0009871b          	sext.w	a4,s3
 7b2:	6685                	lui	a3,0x1
 7b4:	00d77363          	bgeu	a4,a3,7ba <malloc+0x44>
 7b8:	6a05                	lui	s4,0x1
 7ba:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7be:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c2:	00000917          	auipc	s2,0x0
 7c6:	20e90913          	addi	s2,s2,526 # 9d0 <freep>
  if(p == (char*)-1)
 7ca:	5afd                	li	s5,-1
 7cc:	a895                	j	840 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7ce:	00000797          	auipc	a5,0x0
 7d2:	20a78793          	addi	a5,a5,522 # 9d8 <base>
 7d6:	00000717          	auipc	a4,0x0
 7da:	1ef73d23          	sd	a5,506(a4) # 9d0 <freep>
 7de:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7e4:	b7e1                	j	7ac <malloc+0x36>
      if(p->s.size == nunits)
 7e6:	02e48c63          	beq	s1,a4,81e <malloc+0xa8>
        p->s.size -= nunits;
 7ea:	4137073b          	subw	a4,a4,s3
 7ee:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7f0:	02071693          	slli	a3,a4,0x20
 7f4:	01c6d713          	srli	a4,a3,0x1c
 7f8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7fa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7fe:	00000717          	auipc	a4,0x0
 802:	1ca73923          	sd	a0,466(a4) # 9d0 <freep>
      return (void*)(p + 1);
 806:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 80a:	70e2                	ld	ra,56(sp)
 80c:	7442                	ld	s0,48(sp)
 80e:	74a2                	ld	s1,40(sp)
 810:	7902                	ld	s2,32(sp)
 812:	69e2                	ld	s3,24(sp)
 814:	6a42                	ld	s4,16(sp)
 816:	6aa2                	ld	s5,8(sp)
 818:	6b02                	ld	s6,0(sp)
 81a:	6121                	addi	sp,sp,64
 81c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 81e:	6398                	ld	a4,0(a5)
 820:	e118                	sd	a4,0(a0)
 822:	bff1                	j	7fe <malloc+0x88>
  hp->s.size = nu;
 824:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 828:	0541                	addi	a0,a0,16
 82a:	00000097          	auipc	ra,0x0
 82e:	ec4080e7          	jalr	-316(ra) # 6ee <free>
  return freep;
 832:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 836:	d971                	beqz	a0,80a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 838:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83a:	4798                	lw	a4,8(a5)
 83c:	fa9775e3          	bgeu	a4,s1,7e6 <malloc+0x70>
    if(p == freep)
 840:	00093703          	ld	a4,0(s2)
 844:	853e                	mv	a0,a5
 846:	fef719e3          	bne	a4,a5,838 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 84a:	8552                	mv	a0,s4
 84c:	00000097          	auipc	ra,0x0
 850:	b22080e7          	jalr	-1246(ra) # 36e <sbrk>
  if(p == (char*)-1)
 854:	fd5518e3          	bne	a0,s5,824 <malloc+0xae>
        return 0;
 858:	4501                	li	a0,0
 85a:	bf45                	j	80a <malloc+0x94>

000000000000085c <csem_alloc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int csem_alloc(struct counting_semaphore *sem, int initial_value){
 85c:	1101                	addi	sp,sp,-32
 85e:	ec06                	sd	ra,24(sp)
 860:	e822                	sd	s0,16(sp)
 862:	e426                	sd	s1,8(sp)
 864:	e04a                	sd	s2,0(sp)
 866:	1000                	addi	s0,sp,32
 868:	84aa                	mv	s1,a0
 86a:	892e                	mv	s2,a1
    sem->binary_semaphore1 = bsem_alloc();
 86c:	00000097          	auipc	ra,0x0
 870:	b52080e7          	jalr	-1198(ra) # 3be <bsem_alloc>
 874:	c088                	sw	a0,0(s1)
    sem->binary_semaphore2 = bsem_alloc();
 876:	00000097          	auipc	ra,0x0
 87a:	b48080e7          	jalr	-1208(ra) # 3be <bsem_alloc>
 87e:	87aa                	mv	a5,a0
 880:	c0c8                	sw	a0,4(s1)
    if(sem->binary_semaphore1 == -1 || sem->binary_semaphore2 == -1)
 882:	4088                	lw	a0,0(s1)
 884:	577d                	li	a4,-1
 886:	00e50963          	beq	a0,a4,898 <csem_alloc+0x3c>
 88a:	02e78363          	beq	a5,a4,8b0 <csem_alloc+0x54>
        return -1;
    if(initial_value == 0)
 88e:	00090b63          	beqz	s2,8a4 <csem_alloc+0x48>
        bsem_down(sem->binary_semaphore2);
    sem->value = initial_value;
 892:	0124a423          	sw	s2,8(s1)
    return 0;
 896:	4501                	li	a0,0
}
 898:	60e2                	ld	ra,24(sp)
 89a:	6442                	ld	s0,16(sp)
 89c:	64a2                	ld	s1,8(sp)
 89e:	6902                	ld	s2,0(sp)
 8a0:	6105                	addi	sp,sp,32
 8a2:	8082                	ret
        bsem_down(sem->binary_semaphore2);
 8a4:	853e                	mv	a0,a5
 8a6:	00000097          	auipc	ra,0x0
 8aa:	b28080e7          	jalr	-1240(ra) # 3ce <bsem_down>
 8ae:	b7d5                	j	892 <csem_alloc+0x36>
        return -1;
 8b0:	853e                	mv	a0,a5
 8b2:	b7dd                	j	898 <csem_alloc+0x3c>

00000000000008b4 <csem_free>:

void csem_free(struct counting_semaphore *sem){
 8b4:	1101                	addi	sp,sp,-32
 8b6:	ec06                	sd	ra,24(sp)
 8b8:	e822                	sd	s0,16(sp)
 8ba:	e426                	sd	s1,8(sp)
 8bc:	1000                	addi	s0,sp,32
 8be:	84aa                	mv	s1,a0
    bsem_free(sem->binary_semaphore1);
 8c0:	4108                	lw	a0,0(a0)
 8c2:	00000097          	auipc	ra,0x0
 8c6:	b04080e7          	jalr	-1276(ra) # 3c6 <bsem_free>
    bsem_free(sem->binary_semaphore2);
 8ca:	40c8                	lw	a0,4(s1)
 8cc:	00000097          	auipc	ra,0x0
 8d0:	afa080e7          	jalr	-1286(ra) # 3c6 <bsem_free>
    sem->value = 0;
 8d4:	0004a423          	sw	zero,8(s1)
}
 8d8:	60e2                	ld	ra,24(sp)
 8da:	6442                	ld	s0,16(sp)
 8dc:	64a2                	ld	s1,8(sp)
 8de:	6105                	addi	sp,sp,32
 8e0:	8082                	ret

00000000000008e2 <csem_down>:

void csem_down(struct counting_semaphore *sem){
 8e2:	1101                	addi	sp,sp,-32
 8e4:	ec06                	sd	ra,24(sp)
 8e6:	e822                	sd	s0,16(sp)
 8e8:	e426                	sd	s1,8(sp)
 8ea:	1000                	addi	s0,sp,32
 8ec:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore2);
 8ee:	4148                	lw	a0,4(a0)
 8f0:	00000097          	auipc	ra,0x0
 8f4:	ade080e7          	jalr	-1314(ra) # 3ce <bsem_down>
    bsem_down(sem->binary_semaphore1);
 8f8:	4088                	lw	a0,0(s1)
 8fa:	00000097          	auipc	ra,0x0
 8fe:	ad4080e7          	jalr	-1324(ra) # 3ce <bsem_down>
    sem->value--;
 902:	449c                	lw	a5,8(s1)
 904:	37fd                	addiw	a5,a5,-1
 906:	0007871b          	sext.w	a4,a5
 90a:	c49c                	sw	a5,8(s1)
    if(sem->value > 0)
 90c:	00e04c63          	bgtz	a4,924 <csem_down+0x42>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
 910:	4088                	lw	a0,0(s1)
 912:	00000097          	auipc	ra,0x0
 916:	ac4080e7          	jalr	-1340(ra) # 3d6 <bsem_up>
}
 91a:	60e2                	ld	ra,24(sp)
 91c:	6442                	ld	s0,16(sp)
 91e:	64a2                	ld	s1,8(sp)
 920:	6105                	addi	sp,sp,32
 922:	8082                	ret
        bsem_up(sem->binary_semaphore2);
 924:	40c8                	lw	a0,4(s1)
 926:	00000097          	auipc	ra,0x0
 92a:	ab0080e7          	jalr	-1360(ra) # 3d6 <bsem_up>
 92e:	b7cd                	j	910 <csem_down+0x2e>

0000000000000930 <csem_up>:

void csem_up(struct counting_semaphore *sem){
 930:	1101                	addi	sp,sp,-32
 932:	ec06                	sd	ra,24(sp)
 934:	e822                	sd	s0,16(sp)
 936:	e426                	sd	s1,8(sp)
 938:	1000                	addi	s0,sp,32
 93a:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore1);
 93c:	4108                	lw	a0,0(a0)
 93e:	00000097          	auipc	ra,0x0
 942:	a90080e7          	jalr	-1392(ra) # 3ce <bsem_down>
    sem->value++;
 946:	449c                	lw	a5,8(s1)
 948:	2785                	addiw	a5,a5,1
 94a:	0007871b          	sext.w	a4,a5
 94e:	c49c                	sw	a5,8(s1)
    if(sem->value == 1)
 950:	4785                	li	a5,1
 952:	00f70c63          	beq	a4,a5,96a <csem_up+0x3a>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
 956:	4088                	lw	a0,0(s1)
 958:	00000097          	auipc	ra,0x0
 95c:	a7e080e7          	jalr	-1410(ra) # 3d6 <bsem_up>
 960:	60e2                	ld	ra,24(sp)
 962:	6442                	ld	s0,16(sp)
 964:	64a2                	ld	s1,8(sp)
 966:	6105                	addi	sp,sp,32
 968:	8082                	ret
        bsem_up(sem->binary_semaphore2);
 96a:	40c8                	lw	a0,4(s1)
 96c:	00000097          	auipc	ra,0x0
 970:	a6a080e7          	jalr	-1430(ra) # 3d6 <bsem_up>
 974:	b7cd                	j	956 <csem_up+0x26>
