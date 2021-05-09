
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	a8090913          	addi	s2,s2,-1408 # a90 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	384080e7          	jalr	900(ra) # 3a4 <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	378080e7          	jalr	888(ra) # 3ac <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	9e058593          	addi	a1,a1,-1568 # a20 <csem_up+0x4a>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	6e6080e7          	jalr	1766(ra) # 730 <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	338080e7          	jalr	824(ra) # 38c <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	9ca58593          	addi	a1,a1,-1590 # a38 <csem_up+0x62>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	6b8080e7          	jalr	1720(ra) # 730 <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	30a080e7          	jalr	778(ra) # 38c <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	ec26                	sd	s1,24(sp)
  92:	e84a                	sd	s2,16(sp)
  94:	e44e                	sd	s3,8(sp)
  96:	e052                	sd	s4,0(sp)
  98:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  9a:	4785                	li	a5,1
  9c:	04a7d763          	bge	a5,a0,ea <main+0x60>
  a0:	00858913          	addi	s2,a1,8
  a4:	ffe5099b          	addiw	s3,a0,-2
  a8:	02099793          	slli	a5,s3,0x20
  ac:	01d7d993          	srli	s3,a5,0x1d
  b0:	05c1                	addi	a1,a1,16
  b2:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b4:	4581                	li	a1,0
  b6:	00093503          	ld	a0,0(s2)
  ba:	00000097          	auipc	ra,0x0
  be:	312080e7          	jalr	786(ra) # 3cc <open>
  c2:	84aa                	mv	s1,a0
  c4:	02054d63          	bltz	a0,fe <main+0x74>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c8:	00000097          	auipc	ra,0x0
  cc:	f38080e7          	jalr	-200(ra) # 0 <cat>
    close(fd);
  d0:	8526                	mv	a0,s1
  d2:	00000097          	auipc	ra,0x0
  d6:	2e2080e7          	jalr	738(ra) # 3b4 <close>
  for(i = 1; i < argc; i++){
  da:	0921                	addi	s2,s2,8
  dc:	fd391ce3          	bne	s2,s3,b4 <main+0x2a>
  }
  exit(0);
  e0:	4501                	li	a0,0
  e2:	00000097          	auipc	ra,0x0
  e6:	2aa080e7          	jalr	682(ra) # 38c <exit>
    cat(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	f14080e7          	jalr	-236(ra) # 0 <cat>
    exit(0);
  f4:	4501                	li	a0,0
  f6:	00000097          	auipc	ra,0x0
  fa:	296080e7          	jalr	662(ra) # 38c <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  fe:	00093603          	ld	a2,0(s2)
 102:	00001597          	auipc	a1,0x1
 106:	94e58593          	addi	a1,a1,-1714 # a50 <csem_up+0x7a>
 10a:	4509                	li	a0,2
 10c:	00000097          	auipc	ra,0x0
 110:	624080e7          	jalr	1572(ra) # 730 <fprintf>
      exit(1);
 114:	4505                	li	a0,1
 116:	00000097          	auipc	ra,0x0
 11a:	276080e7          	jalr	630(ra) # 38c <exit>

000000000000011e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 124:	87aa                	mv	a5,a0
 126:	0585                	addi	a1,a1,1
 128:	0785                	addi	a5,a5,1
 12a:	fff5c703          	lbu	a4,-1(a1)
 12e:	fee78fa3          	sb	a4,-1(a5)
 132:	fb75                	bnez	a4,126 <strcpy+0x8>
    ;
  return os;
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret

000000000000013a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	cb91                	beqz	a5,158 <strcmp+0x1e>
 146:	0005c703          	lbu	a4,0(a1)
 14a:	00f71763          	bne	a4,a5,158 <strcmp+0x1e>
    p++, q++;
 14e:	0505                	addi	a0,a0,1
 150:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 152:	00054783          	lbu	a5,0(a0)
 156:	fbe5                	bnez	a5,146 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 158:	0005c503          	lbu	a0,0(a1)
}
 15c:	40a7853b          	subw	a0,a5,a0
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strlen>:

uint
strlen(const char *s)
{
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf91                	beqz	a5,18c <strlen+0x26>
 172:	0505                	addi	a0,a0,1
 174:	87aa                	mv	a5,a0
 176:	4685                	li	a3,1
 178:	9e89                	subw	a3,a3,a0
 17a:	00f6853b          	addw	a0,a3,a5
 17e:	0785                	addi	a5,a5,1
 180:	fff7c703          	lbu	a4,-1(a5)
 184:	fb7d                	bnez	a4,17a <strlen+0x14>
    ;
  return n;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  for(n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfe5                	j	186 <strlen+0x20>

0000000000000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 196:	ca19                	beqz	a2,1ac <memset+0x1c>
 198:	87aa                	mv	a5,a0
 19a:	1602                	slli	a2,a2,0x20
 19c:	9201                	srli	a2,a2,0x20
 19e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a6:	0785                	addi	a5,a5,1
 1a8:	fee79de3          	bne	a5,a4,1a2 <memset+0x12>
  }
  return dst;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strchr>:

char*
strchr(const char *s, char c)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb99                	beqz	a5,1d2 <strchr+0x20>
    if(*s == c)
 1be:	00f58763          	beq	a1,a5,1cc <strchr+0x1a>
  for(; *s; s++)
 1c2:	0505                	addi	a0,a0,1
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	fbfd                	bnez	a5,1be <strchr+0xc>
      return (char*)s;
  return 0;
 1ca:	4501                	li	a0,0
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  return 0;
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <strchr+0x1a>

00000000000001d6 <gets>:

char*
gets(char *buf, int max)
{
 1d6:	711d                	addi	sp,sp,-96
 1d8:	ec86                	sd	ra,88(sp)
 1da:	e8a2                	sd	s0,80(sp)
 1dc:	e4a6                	sd	s1,72(sp)
 1de:	e0ca                	sd	s2,64(sp)
 1e0:	fc4e                	sd	s3,56(sp)
 1e2:	f852                	sd	s4,48(sp)
 1e4:	f456                	sd	s5,40(sp)
 1e6:	f05a                	sd	s6,32(sp)
 1e8:	ec5e                	sd	s7,24(sp)
 1ea:	1080                	addi	s0,sp,96
 1ec:	8baa                	mv	s7,a0
 1ee:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f0:	892a                	mv	s2,a0
 1f2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f4:	4aa9                	li	s5,10
 1f6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f8:	89a6                	mv	s3,s1
 1fa:	2485                	addiw	s1,s1,1
 1fc:	0344d863          	bge	s1,s4,22c <gets+0x56>
    cc = read(0, &c, 1);
 200:	4605                	li	a2,1
 202:	faf40593          	addi	a1,s0,-81
 206:	4501                	li	a0,0
 208:	00000097          	auipc	ra,0x0
 20c:	19c080e7          	jalr	412(ra) # 3a4 <read>
    if(cc < 1)
 210:	00a05e63          	blez	a0,22c <gets+0x56>
    buf[i++] = c;
 214:	faf44783          	lbu	a5,-81(s0)
 218:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21c:	01578763          	beq	a5,s5,22a <gets+0x54>
 220:	0905                	addi	s2,s2,1
 222:	fd679be3          	bne	a5,s6,1f8 <gets+0x22>
  for(i=0; i+1 < max; ){
 226:	89a6                	mv	s3,s1
 228:	a011                	j	22c <gets+0x56>
 22a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 22c:	99de                	add	s3,s3,s7
 22e:	00098023          	sb	zero,0(s3)
  return buf;
}
 232:	855e                	mv	a0,s7
 234:	60e6                	ld	ra,88(sp)
 236:	6446                	ld	s0,80(sp)
 238:	64a6                	ld	s1,72(sp)
 23a:	6906                	ld	s2,64(sp)
 23c:	79e2                	ld	s3,56(sp)
 23e:	7a42                	ld	s4,48(sp)
 240:	7aa2                	ld	s5,40(sp)
 242:	7b02                	ld	s6,32(sp)
 244:	6be2                	ld	s7,24(sp)
 246:	6125                	addi	sp,sp,96
 248:	8082                	ret

000000000000024a <stat>:

int
stat(const char *n, struct stat *st)
{
 24a:	1101                	addi	sp,sp,-32
 24c:	ec06                	sd	ra,24(sp)
 24e:	e822                	sd	s0,16(sp)
 250:	e426                	sd	s1,8(sp)
 252:	e04a                	sd	s2,0(sp)
 254:	1000                	addi	s0,sp,32
 256:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 258:	4581                	li	a1,0
 25a:	00000097          	auipc	ra,0x0
 25e:	172080e7          	jalr	370(ra) # 3cc <open>
  if(fd < 0)
 262:	02054563          	bltz	a0,28c <stat+0x42>
 266:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 268:	85ca                	mv	a1,s2
 26a:	00000097          	auipc	ra,0x0
 26e:	17a080e7          	jalr	378(ra) # 3e4 <fstat>
 272:	892a                	mv	s2,a0
  close(fd);
 274:	8526                	mv	a0,s1
 276:	00000097          	auipc	ra,0x0
 27a:	13e080e7          	jalr	318(ra) # 3b4 <close>
  return r;
}
 27e:	854a                	mv	a0,s2
 280:	60e2                	ld	ra,24(sp)
 282:	6442                	ld	s0,16(sp)
 284:	64a2                	ld	s1,8(sp)
 286:	6902                	ld	s2,0(sp)
 288:	6105                	addi	sp,sp,32
 28a:	8082                	ret
    return -1;
 28c:	597d                	li	s2,-1
 28e:	bfc5                	j	27e <stat+0x34>

0000000000000290 <atoi>:

int
atoi(const char *s)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 296:	00054603          	lbu	a2,0(a0)
 29a:	fd06079b          	addiw	a5,a2,-48
 29e:	0ff7f793          	andi	a5,a5,255
 2a2:	4725                	li	a4,9
 2a4:	02f76963          	bltu	a4,a5,2d6 <atoi+0x46>
 2a8:	86aa                	mv	a3,a0
  n = 0;
 2aa:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2ac:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2ae:	0685                	addi	a3,a3,1
 2b0:	0025179b          	slliw	a5,a0,0x2
 2b4:	9fa9                	addw	a5,a5,a0
 2b6:	0017979b          	slliw	a5,a5,0x1
 2ba:	9fb1                	addw	a5,a5,a2
 2bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c0:	0006c603          	lbu	a2,0(a3)
 2c4:	fd06071b          	addiw	a4,a2,-48
 2c8:	0ff77713          	andi	a4,a4,255
 2cc:	fee5f1e3          	bgeu	a1,a4,2ae <atoi+0x1e>
  return n;
}
 2d0:	6422                	ld	s0,8(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
  n = 0;
 2d6:	4501                	li	a0,0
 2d8:	bfe5                	j	2d0 <atoi+0x40>

00000000000002da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e0:	02b57463          	bgeu	a0,a1,308 <memmove+0x2e>
    while(n-- > 0)
 2e4:	00c05f63          	blez	a2,302 <memmove+0x28>
 2e8:	1602                	slli	a2,a2,0x20
 2ea:	9201                	srli	a2,a2,0x20
 2ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f2:	0585                	addi	a1,a1,1
 2f4:	0705                	addi	a4,a4,1
 2f6:	fff5c683          	lbu	a3,-1(a1)
 2fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2fe:	fee79ae3          	bne	a5,a4,2f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret
    dst += n;
 308:	00c50733          	add	a4,a0,a2
    src += n;
 30c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 30e:	fec05ae3          	blez	a2,302 <memmove+0x28>
 312:	fff6079b          	addiw	a5,a2,-1
 316:	1782                	slli	a5,a5,0x20
 318:	9381                	srli	a5,a5,0x20
 31a:	fff7c793          	not	a5,a5
 31e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 320:	15fd                	addi	a1,a1,-1
 322:	177d                	addi	a4,a4,-1
 324:	0005c683          	lbu	a3,0(a1)
 328:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 32c:	fee79ae3          	bne	a5,a4,320 <memmove+0x46>
 330:	bfc9                	j	302 <memmove+0x28>

0000000000000332 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 332:	1141                	addi	sp,sp,-16
 334:	e422                	sd	s0,8(sp)
 336:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 338:	ca05                	beqz	a2,368 <memcmp+0x36>
 33a:	fff6069b          	addiw	a3,a2,-1
 33e:	1682                	slli	a3,a3,0x20
 340:	9281                	srli	a3,a3,0x20
 342:	0685                	addi	a3,a3,1
 344:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 346:	00054783          	lbu	a5,0(a0)
 34a:	0005c703          	lbu	a4,0(a1)
 34e:	00e79863          	bne	a5,a4,35e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 352:	0505                	addi	a0,a0,1
    p2++;
 354:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 356:	fed518e3          	bne	a0,a3,346 <memcmp+0x14>
  }
  return 0;
 35a:	4501                	li	a0,0
 35c:	a019                	j	362 <memcmp+0x30>
      return *p1 - *p2;
 35e:	40e7853b          	subw	a0,a5,a4
}
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret
  return 0;
 368:	4501                	li	a0,0
 36a:	bfe5                	j	362 <memcmp+0x30>

000000000000036c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e406                	sd	ra,8(sp)
 370:	e022                	sd	s0,0(sp)
 372:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 374:	00000097          	auipc	ra,0x0
 378:	f66080e7          	jalr	-154(ra) # 2da <memmove>
}
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 384:	4885                	li	a7,1
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <exit>:
.global exit
exit:
 li a7, SYS_exit
 38c:	4889                	li	a7,2
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <wait>:
.global wait
wait:
 li a7, SYS_wait
 394:	488d                	li	a7,3
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39c:	4891                	li	a7,4
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <read>:
.global read
read:
 li a7, SYS_read
 3a4:	4895                	li	a7,5
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <write>:
.global write
write:
 li a7, SYS_write
 3ac:	48c1                	li	a7,16
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <close>:
.global close
close:
 li a7, SYS_close
 3b4:	48d5                	li	a7,21
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3bc:	4899                	li	a7,6
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c4:	489d                	li	a7,7
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <open>:
.global open
open:
 li a7, SYS_open
 3cc:	48bd                	li	a7,15
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d4:	48c5                	li	a7,17
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3dc:	48c9                	li	a7,18
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e4:	48a1                	li	a7,8
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <link>:
.global link
link:
 li a7, SYS_link
 3ec:	48cd                	li	a7,19
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f4:	48d1                	li	a7,20
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fc:	48a5                	li	a7,9
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <dup>:
.global dup
dup:
 li a7, SYS_dup
 404:	48a9                	li	a7,10
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40c:	48ad                	li	a7,11
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 414:	48b1                	li	a7,12
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 41c:	48b5                	li	a7,13
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 424:	48b9                	li	a7,14
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 42c:	48d9                	li	a7,22
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 434:	48dd                	li	a7,23
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 43c:	48e1                	li	a7,24
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 444:	48e5                	li	a7,25
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 44c:	48e9                	li	a7,26
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 454:	48ed                	li	a7,27
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 45c:	48f1                	li	a7,28
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 464:	48f5                	li	a7,29
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 46c:	48f9                	li	a7,30
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 474:	48fd                	li	a7,31
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 47c:	02000893          	li	a7,32
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 486:	1101                	addi	sp,sp,-32
 488:	ec06                	sd	ra,24(sp)
 48a:	e822                	sd	s0,16(sp)
 48c:	1000                	addi	s0,sp,32
 48e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 492:	4605                	li	a2,1
 494:	fef40593          	addi	a1,s0,-17
 498:	00000097          	auipc	ra,0x0
 49c:	f14080e7          	jalr	-236(ra) # 3ac <write>
}
 4a0:	60e2                	ld	ra,24(sp)
 4a2:	6442                	ld	s0,16(sp)
 4a4:	6105                	addi	sp,sp,32
 4a6:	8082                	ret

00000000000004a8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a8:	7139                	addi	sp,sp,-64
 4aa:	fc06                	sd	ra,56(sp)
 4ac:	f822                	sd	s0,48(sp)
 4ae:	f426                	sd	s1,40(sp)
 4b0:	f04a                	sd	s2,32(sp)
 4b2:	ec4e                	sd	s3,24(sp)
 4b4:	0080                	addi	s0,sp,64
 4b6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4b8:	c299                	beqz	a3,4be <printint+0x16>
 4ba:	0805c863          	bltz	a1,54a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4be:	2581                	sext.w	a1,a1
  neg = 0;
 4c0:	4881                	li	a7,0
 4c2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4c6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4c8:	2601                	sext.w	a2,a2
 4ca:	00000517          	auipc	a0,0x0
 4ce:	5a650513          	addi	a0,a0,1446 # a70 <digits>
 4d2:	883a                	mv	a6,a4
 4d4:	2705                	addiw	a4,a4,1
 4d6:	02c5f7bb          	remuw	a5,a1,a2
 4da:	1782                	slli	a5,a5,0x20
 4dc:	9381                	srli	a5,a5,0x20
 4de:	97aa                	add	a5,a5,a0
 4e0:	0007c783          	lbu	a5,0(a5)
 4e4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4e8:	0005879b          	sext.w	a5,a1
 4ec:	02c5d5bb          	divuw	a1,a1,a2
 4f0:	0685                	addi	a3,a3,1
 4f2:	fec7f0e3          	bgeu	a5,a2,4d2 <printint+0x2a>
  if(neg)
 4f6:	00088b63          	beqz	a7,50c <printint+0x64>
    buf[i++] = '-';
 4fa:	fd040793          	addi	a5,s0,-48
 4fe:	973e                	add	a4,a4,a5
 500:	02d00793          	li	a5,45
 504:	fef70823          	sb	a5,-16(a4)
 508:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 50c:	02e05863          	blez	a4,53c <printint+0x94>
 510:	fc040793          	addi	a5,s0,-64
 514:	00e78933          	add	s2,a5,a4
 518:	fff78993          	addi	s3,a5,-1
 51c:	99ba                	add	s3,s3,a4
 51e:	377d                	addiw	a4,a4,-1
 520:	1702                	slli	a4,a4,0x20
 522:	9301                	srli	a4,a4,0x20
 524:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 528:	fff94583          	lbu	a1,-1(s2)
 52c:	8526                	mv	a0,s1
 52e:	00000097          	auipc	ra,0x0
 532:	f58080e7          	jalr	-168(ra) # 486 <putc>
  while(--i >= 0)
 536:	197d                	addi	s2,s2,-1
 538:	ff3918e3          	bne	s2,s3,528 <printint+0x80>
}
 53c:	70e2                	ld	ra,56(sp)
 53e:	7442                	ld	s0,48(sp)
 540:	74a2                	ld	s1,40(sp)
 542:	7902                	ld	s2,32(sp)
 544:	69e2                	ld	s3,24(sp)
 546:	6121                	addi	sp,sp,64
 548:	8082                	ret
    x = -xx;
 54a:	40b005bb          	negw	a1,a1
    neg = 1;
 54e:	4885                	li	a7,1
    x = -xx;
 550:	bf8d                	j	4c2 <printint+0x1a>

0000000000000552 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 552:	7119                	addi	sp,sp,-128
 554:	fc86                	sd	ra,120(sp)
 556:	f8a2                	sd	s0,112(sp)
 558:	f4a6                	sd	s1,104(sp)
 55a:	f0ca                	sd	s2,96(sp)
 55c:	ecce                	sd	s3,88(sp)
 55e:	e8d2                	sd	s4,80(sp)
 560:	e4d6                	sd	s5,72(sp)
 562:	e0da                	sd	s6,64(sp)
 564:	fc5e                	sd	s7,56(sp)
 566:	f862                	sd	s8,48(sp)
 568:	f466                	sd	s9,40(sp)
 56a:	f06a                	sd	s10,32(sp)
 56c:	ec6e                	sd	s11,24(sp)
 56e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 570:	0005c903          	lbu	s2,0(a1)
 574:	18090f63          	beqz	s2,712 <vprintf+0x1c0>
 578:	8aaa                	mv	s5,a0
 57a:	8b32                	mv	s6,a2
 57c:	00158493          	addi	s1,a1,1
  state = 0;
 580:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 582:	02500a13          	li	s4,37
      if(c == 'd'){
 586:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 58a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 58e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 592:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 596:	00000b97          	auipc	s7,0x0
 59a:	4dab8b93          	addi	s7,s7,1242 # a70 <digits>
 59e:	a839                	j	5bc <vprintf+0x6a>
        putc(fd, c);
 5a0:	85ca                	mv	a1,s2
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	ee2080e7          	jalr	-286(ra) # 486 <putc>
 5ac:	a019                	j	5b2 <vprintf+0x60>
    } else if(state == '%'){
 5ae:	01498f63          	beq	s3,s4,5cc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5b2:	0485                	addi	s1,s1,1
 5b4:	fff4c903          	lbu	s2,-1(s1)
 5b8:	14090d63          	beqz	s2,712 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5bc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5c0:	fe0997e3          	bnez	s3,5ae <vprintf+0x5c>
      if(c == '%'){
 5c4:	fd479ee3          	bne	a5,s4,5a0 <vprintf+0x4e>
        state = '%';
 5c8:	89be                	mv	s3,a5
 5ca:	b7e5                	j	5b2 <vprintf+0x60>
      if(c == 'd'){
 5cc:	05878063          	beq	a5,s8,60c <vprintf+0xba>
      } else if(c == 'l') {
 5d0:	05978c63          	beq	a5,s9,628 <vprintf+0xd6>
      } else if(c == 'x') {
 5d4:	07a78863          	beq	a5,s10,644 <vprintf+0xf2>
      } else if(c == 'p') {
 5d8:	09b78463          	beq	a5,s11,660 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5dc:	07300713          	li	a4,115
 5e0:	0ce78663          	beq	a5,a4,6ac <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e4:	06300713          	li	a4,99
 5e8:	0ee78e63          	beq	a5,a4,6e4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5ec:	11478863          	beq	a5,s4,6fc <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f0:	85d2                	mv	a1,s4
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e92080e7          	jalr	-366(ra) # 486 <putc>
        putc(fd, c);
 5fc:	85ca                	mv	a1,s2
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	e86080e7          	jalr	-378(ra) # 486 <putc>
      }
      state = 0;
 608:	4981                	li	s3,0
 60a:	b765                	j	5b2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 60c:	008b0913          	addi	s2,s6,8
 610:	4685                	li	a3,1
 612:	4629                	li	a2,10
 614:	000b2583          	lw	a1,0(s6)
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	e8e080e7          	jalr	-370(ra) # 4a8 <printint>
 622:	8b4a                	mv	s6,s2
      state = 0;
 624:	4981                	li	s3,0
 626:	b771                	j	5b2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 628:	008b0913          	addi	s2,s6,8
 62c:	4681                	li	a3,0
 62e:	4629                	li	a2,10
 630:	000b2583          	lw	a1,0(s6)
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	e72080e7          	jalr	-398(ra) # 4a8 <printint>
 63e:	8b4a                	mv	s6,s2
      state = 0;
 640:	4981                	li	s3,0
 642:	bf85                	j	5b2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 644:	008b0913          	addi	s2,s6,8
 648:	4681                	li	a3,0
 64a:	4641                	li	a2,16
 64c:	000b2583          	lw	a1,0(s6)
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	e56080e7          	jalr	-426(ra) # 4a8 <printint>
 65a:	8b4a                	mv	s6,s2
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bf91                	j	5b2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 660:	008b0793          	addi	a5,s6,8
 664:	f8f43423          	sd	a5,-120(s0)
 668:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 66c:	03000593          	li	a1,48
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	e14080e7          	jalr	-492(ra) # 486 <putc>
  putc(fd, 'x');
 67a:	85ea                	mv	a1,s10
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	e08080e7          	jalr	-504(ra) # 486 <putc>
 686:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 688:	03c9d793          	srli	a5,s3,0x3c
 68c:	97de                	add	a5,a5,s7
 68e:	0007c583          	lbu	a1,0(a5)
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	df2080e7          	jalr	-526(ra) # 486 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 69c:	0992                	slli	s3,s3,0x4
 69e:	397d                	addiw	s2,s2,-1
 6a0:	fe0914e3          	bnez	s2,688 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6a4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b721                	j	5b2 <vprintf+0x60>
        s = va_arg(ap, char*);
 6ac:	008b0993          	addi	s3,s6,8
 6b0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6b4:	02090163          	beqz	s2,6d6 <vprintf+0x184>
        while(*s != 0){
 6b8:	00094583          	lbu	a1,0(s2)
 6bc:	c9a1                	beqz	a1,70c <vprintf+0x1ba>
          putc(fd, *s);
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	dc6080e7          	jalr	-570(ra) # 486 <putc>
          s++;
 6c8:	0905                	addi	s2,s2,1
        while(*s != 0){
 6ca:	00094583          	lbu	a1,0(s2)
 6ce:	f9e5                	bnez	a1,6be <vprintf+0x16c>
        s = va_arg(ap, char*);
 6d0:	8b4e                	mv	s6,s3
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bdf9                	j	5b2 <vprintf+0x60>
          s = "(null)";
 6d6:	00000917          	auipc	s2,0x0
 6da:	39290913          	addi	s2,s2,914 # a68 <csem_up+0x92>
        while(*s != 0){
 6de:	02800593          	li	a1,40
 6e2:	bff1                	j	6be <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6e4:	008b0913          	addi	s2,s6,8
 6e8:	000b4583          	lbu	a1,0(s6)
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	d98080e7          	jalr	-616(ra) # 486 <putc>
 6f6:	8b4a                	mv	s6,s2
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	bd65                	j	5b2 <vprintf+0x60>
        putc(fd, c);
 6fc:	85d2                	mv	a1,s4
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	d86080e7          	jalr	-634(ra) # 486 <putc>
      state = 0;
 708:	4981                	li	s3,0
 70a:	b565                	j	5b2 <vprintf+0x60>
        s = va_arg(ap, char*);
 70c:	8b4e                	mv	s6,s3
      state = 0;
 70e:	4981                	li	s3,0
 710:	b54d                	j	5b2 <vprintf+0x60>
    }
  }
}
 712:	70e6                	ld	ra,120(sp)
 714:	7446                	ld	s0,112(sp)
 716:	74a6                	ld	s1,104(sp)
 718:	7906                	ld	s2,96(sp)
 71a:	69e6                	ld	s3,88(sp)
 71c:	6a46                	ld	s4,80(sp)
 71e:	6aa6                	ld	s5,72(sp)
 720:	6b06                	ld	s6,64(sp)
 722:	7be2                	ld	s7,56(sp)
 724:	7c42                	ld	s8,48(sp)
 726:	7ca2                	ld	s9,40(sp)
 728:	7d02                	ld	s10,32(sp)
 72a:	6de2                	ld	s11,24(sp)
 72c:	6109                	addi	sp,sp,128
 72e:	8082                	ret

0000000000000730 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 730:	715d                	addi	sp,sp,-80
 732:	ec06                	sd	ra,24(sp)
 734:	e822                	sd	s0,16(sp)
 736:	1000                	addi	s0,sp,32
 738:	e010                	sd	a2,0(s0)
 73a:	e414                	sd	a3,8(s0)
 73c:	e818                	sd	a4,16(s0)
 73e:	ec1c                	sd	a5,24(s0)
 740:	03043023          	sd	a6,32(s0)
 744:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 748:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 74c:	8622                	mv	a2,s0
 74e:	00000097          	auipc	ra,0x0
 752:	e04080e7          	jalr	-508(ra) # 552 <vprintf>
}
 756:	60e2                	ld	ra,24(sp)
 758:	6442                	ld	s0,16(sp)
 75a:	6161                	addi	sp,sp,80
 75c:	8082                	ret

000000000000075e <printf>:

void
printf(const char *fmt, ...)
{
 75e:	711d                	addi	sp,sp,-96
 760:	ec06                	sd	ra,24(sp)
 762:	e822                	sd	s0,16(sp)
 764:	1000                	addi	s0,sp,32
 766:	e40c                	sd	a1,8(s0)
 768:	e810                	sd	a2,16(s0)
 76a:	ec14                	sd	a3,24(s0)
 76c:	f018                	sd	a4,32(s0)
 76e:	f41c                	sd	a5,40(s0)
 770:	03043823          	sd	a6,48(s0)
 774:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 778:	00840613          	addi	a2,s0,8
 77c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 780:	85aa                	mv	a1,a0
 782:	4505                	li	a0,1
 784:	00000097          	auipc	ra,0x0
 788:	dce080e7          	jalr	-562(ra) # 552 <vprintf>
}
 78c:	60e2                	ld	ra,24(sp)
 78e:	6442                	ld	s0,16(sp)
 790:	6125                	addi	sp,sp,96
 792:	8082                	ret

0000000000000794 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 794:	1141                	addi	sp,sp,-16
 796:	e422                	sd	s0,8(sp)
 798:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	00000797          	auipc	a5,0x0
 7a2:	2ea7b783          	ld	a5,746(a5) # a88 <freep>
 7a6:	a805                	j	7d6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7a8:	4618                	lw	a4,8(a2)
 7aa:	9db9                	addw	a1,a1,a4
 7ac:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b0:	6398                	ld	a4,0(a5)
 7b2:	6318                	ld	a4,0(a4)
 7b4:	fee53823          	sd	a4,-16(a0)
 7b8:	a091                	j	7fc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ba:	ff852703          	lw	a4,-8(a0)
 7be:	9e39                	addw	a2,a2,a4
 7c0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7c2:	ff053703          	ld	a4,-16(a0)
 7c6:	e398                	sd	a4,0(a5)
 7c8:	a099                	j	80e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ca:	6398                	ld	a4,0(a5)
 7cc:	00e7e463          	bltu	a5,a4,7d4 <free+0x40>
 7d0:	00e6ea63          	bltu	a3,a4,7e4 <free+0x50>
{
 7d4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d6:	fed7fae3          	bgeu	a5,a3,7ca <free+0x36>
 7da:	6398                	ld	a4,0(a5)
 7dc:	00e6e463          	bltu	a3,a4,7e4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	fee7eae3          	bltu	a5,a4,7d4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7e4:	ff852583          	lw	a1,-8(a0)
 7e8:	6390                	ld	a2,0(a5)
 7ea:	02059813          	slli	a6,a1,0x20
 7ee:	01c85713          	srli	a4,a6,0x1c
 7f2:	9736                	add	a4,a4,a3
 7f4:	fae60ae3          	beq	a2,a4,7a8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7f8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7fc:	4790                	lw	a2,8(a5)
 7fe:	02061593          	slli	a1,a2,0x20
 802:	01c5d713          	srli	a4,a1,0x1c
 806:	973e                	add	a4,a4,a5
 808:	fae689e3          	beq	a3,a4,7ba <free+0x26>
  } else
    p->s.ptr = bp;
 80c:	e394                	sd	a3,0(a5)
  freep = p;
 80e:	00000717          	auipc	a4,0x0
 812:	26f73d23          	sd	a5,634(a4) # a88 <freep>
}
 816:	6422                	ld	s0,8(sp)
 818:	0141                	addi	sp,sp,16
 81a:	8082                	ret

000000000000081c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 81c:	7139                	addi	sp,sp,-64
 81e:	fc06                	sd	ra,56(sp)
 820:	f822                	sd	s0,48(sp)
 822:	f426                	sd	s1,40(sp)
 824:	f04a                	sd	s2,32(sp)
 826:	ec4e                	sd	s3,24(sp)
 828:	e852                	sd	s4,16(sp)
 82a:	e456                	sd	s5,8(sp)
 82c:	e05a                	sd	s6,0(sp)
 82e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 830:	02051493          	slli	s1,a0,0x20
 834:	9081                	srli	s1,s1,0x20
 836:	04bd                	addi	s1,s1,15
 838:	8091                	srli	s1,s1,0x4
 83a:	0014899b          	addiw	s3,s1,1
 83e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 840:	00000517          	auipc	a0,0x0
 844:	24853503          	ld	a0,584(a0) # a88 <freep>
 848:	c515                	beqz	a0,874 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84c:	4798                	lw	a4,8(a5)
 84e:	02977f63          	bgeu	a4,s1,88c <malloc+0x70>
 852:	8a4e                	mv	s4,s3
 854:	0009871b          	sext.w	a4,s3
 858:	6685                	lui	a3,0x1
 85a:	00d77363          	bgeu	a4,a3,860 <malloc+0x44>
 85e:	6a05                	lui	s4,0x1
 860:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 864:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 868:	00000917          	auipc	s2,0x0
 86c:	22090913          	addi	s2,s2,544 # a88 <freep>
  if(p == (char*)-1)
 870:	5afd                	li	s5,-1
 872:	a895                	j	8e6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 874:	00000797          	auipc	a5,0x0
 878:	41c78793          	addi	a5,a5,1052 # c90 <base>
 87c:	00000717          	auipc	a4,0x0
 880:	20f73623          	sd	a5,524(a4) # a88 <freep>
 884:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 886:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 88a:	b7e1                	j	852 <malloc+0x36>
      if(p->s.size == nunits)
 88c:	02e48c63          	beq	s1,a4,8c4 <malloc+0xa8>
        p->s.size -= nunits;
 890:	4137073b          	subw	a4,a4,s3
 894:	c798                	sw	a4,8(a5)
        p += p->s.size;
 896:	02071693          	slli	a3,a4,0x20
 89a:	01c6d713          	srli	a4,a3,0x1c
 89e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a4:	00000717          	auipc	a4,0x0
 8a8:	1ea73223          	sd	a0,484(a4) # a88 <freep>
      return (void*)(p + 1);
 8ac:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b0:	70e2                	ld	ra,56(sp)
 8b2:	7442                	ld	s0,48(sp)
 8b4:	74a2                	ld	s1,40(sp)
 8b6:	7902                	ld	s2,32(sp)
 8b8:	69e2                	ld	s3,24(sp)
 8ba:	6a42                	ld	s4,16(sp)
 8bc:	6aa2                	ld	s5,8(sp)
 8be:	6b02                	ld	s6,0(sp)
 8c0:	6121                	addi	sp,sp,64
 8c2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8c4:	6398                	ld	a4,0(a5)
 8c6:	e118                	sd	a4,0(a0)
 8c8:	bff1                	j	8a4 <malloc+0x88>
  hp->s.size = nu;
 8ca:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ce:	0541                	addi	a0,a0,16
 8d0:	00000097          	auipc	ra,0x0
 8d4:	ec4080e7          	jalr	-316(ra) # 794 <free>
  return freep;
 8d8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8dc:	d971                	beqz	a0,8b0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8de:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e0:	4798                	lw	a4,8(a5)
 8e2:	fa9775e3          	bgeu	a4,s1,88c <malloc+0x70>
    if(p == freep)
 8e6:	00093703          	ld	a4,0(s2)
 8ea:	853e                	mv	a0,a5
 8ec:	fef719e3          	bne	a4,a5,8de <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8f0:	8552                	mv	a0,s4
 8f2:	00000097          	auipc	ra,0x0
 8f6:	b22080e7          	jalr	-1246(ra) # 414 <sbrk>
  if(p == (char*)-1)
 8fa:	fd5518e3          	bne	a0,s5,8ca <malloc+0xae>
        return 0;
 8fe:	4501                	li	a0,0
 900:	bf45                	j	8b0 <malloc+0x94>

0000000000000902 <csem_alloc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int csem_alloc(struct counting_semaphore *sem, int initial_value){
 902:	1101                	addi	sp,sp,-32
 904:	ec06                	sd	ra,24(sp)
 906:	e822                	sd	s0,16(sp)
 908:	e426                	sd	s1,8(sp)
 90a:	e04a                	sd	s2,0(sp)
 90c:	1000                	addi	s0,sp,32
 90e:	84aa                	mv	s1,a0
 910:	892e                	mv	s2,a1
    sem->binary_semaphore1 = bsem_alloc();
 912:	00000097          	auipc	ra,0x0
 916:	b52080e7          	jalr	-1198(ra) # 464 <bsem_alloc>
 91a:	c088                	sw	a0,0(s1)
    sem->binary_semaphore2 = bsem_alloc();
 91c:	00000097          	auipc	ra,0x0
 920:	b48080e7          	jalr	-1208(ra) # 464 <bsem_alloc>
 924:	87aa                	mv	a5,a0
 926:	c0c8                	sw	a0,4(s1)
    if(sem->binary_semaphore1 == -1 || sem->binary_semaphore2 == -1)
 928:	4088                	lw	a0,0(s1)
 92a:	577d                	li	a4,-1
 92c:	00e50963          	beq	a0,a4,93e <csem_alloc+0x3c>
 930:	02e78363          	beq	a5,a4,956 <csem_alloc+0x54>
        return -1;
    if(initial_value == 0)
 934:	00090b63          	beqz	s2,94a <csem_alloc+0x48>
        bsem_down(sem->binary_semaphore2);
    sem->value = initial_value;
 938:	0124a423          	sw	s2,8(s1)
    return 0;
 93c:	4501                	li	a0,0
}
 93e:	60e2                	ld	ra,24(sp)
 940:	6442                	ld	s0,16(sp)
 942:	64a2                	ld	s1,8(sp)
 944:	6902                	ld	s2,0(sp)
 946:	6105                	addi	sp,sp,32
 948:	8082                	ret
        bsem_down(sem->binary_semaphore2);
 94a:	853e                	mv	a0,a5
 94c:	00000097          	auipc	ra,0x0
 950:	b28080e7          	jalr	-1240(ra) # 474 <bsem_down>
 954:	b7d5                	j	938 <csem_alloc+0x36>
        return -1;
 956:	853e                	mv	a0,a5
 958:	b7dd                	j	93e <csem_alloc+0x3c>

000000000000095a <csem_free>:

void csem_free(struct counting_semaphore *sem){
 95a:	1101                	addi	sp,sp,-32
 95c:	ec06                	sd	ra,24(sp)
 95e:	e822                	sd	s0,16(sp)
 960:	e426                	sd	s1,8(sp)
 962:	1000                	addi	s0,sp,32
 964:	84aa                	mv	s1,a0
    bsem_free(sem->binary_semaphore1);
 966:	4108                	lw	a0,0(a0)
 968:	00000097          	auipc	ra,0x0
 96c:	b04080e7          	jalr	-1276(ra) # 46c <bsem_free>
    bsem_free(sem->binary_semaphore2);
 970:	40c8                	lw	a0,4(s1)
 972:	00000097          	auipc	ra,0x0
 976:	afa080e7          	jalr	-1286(ra) # 46c <bsem_free>
    sem->value = 0;
 97a:	0004a423          	sw	zero,8(s1)
}
 97e:	60e2                	ld	ra,24(sp)
 980:	6442                	ld	s0,16(sp)
 982:	64a2                	ld	s1,8(sp)
 984:	6105                	addi	sp,sp,32
 986:	8082                	ret

0000000000000988 <csem_down>:

void csem_down(struct counting_semaphore *sem){
 988:	1101                	addi	sp,sp,-32
 98a:	ec06                	sd	ra,24(sp)
 98c:	e822                	sd	s0,16(sp)
 98e:	e426                	sd	s1,8(sp)
 990:	1000                	addi	s0,sp,32
 992:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore2);
 994:	4148                	lw	a0,4(a0)
 996:	00000097          	auipc	ra,0x0
 99a:	ade080e7          	jalr	-1314(ra) # 474 <bsem_down>
    bsem_down(sem->binary_semaphore1);
 99e:	4088                	lw	a0,0(s1)
 9a0:	00000097          	auipc	ra,0x0
 9a4:	ad4080e7          	jalr	-1324(ra) # 474 <bsem_down>
    sem->value--;
 9a8:	449c                	lw	a5,8(s1)
 9aa:	37fd                	addiw	a5,a5,-1
 9ac:	0007871b          	sext.w	a4,a5
 9b0:	c49c                	sw	a5,8(s1)
    if(sem->value > 0)
 9b2:	00e04c63          	bgtz	a4,9ca <csem_down+0x42>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
 9b6:	4088                	lw	a0,0(s1)
 9b8:	00000097          	auipc	ra,0x0
 9bc:	ac4080e7          	jalr	-1340(ra) # 47c <bsem_up>
}
 9c0:	60e2                	ld	ra,24(sp)
 9c2:	6442                	ld	s0,16(sp)
 9c4:	64a2                	ld	s1,8(sp)
 9c6:	6105                	addi	sp,sp,32
 9c8:	8082                	ret
        bsem_up(sem->binary_semaphore2);
 9ca:	40c8                	lw	a0,4(s1)
 9cc:	00000097          	auipc	ra,0x0
 9d0:	ab0080e7          	jalr	-1360(ra) # 47c <bsem_up>
 9d4:	b7cd                	j	9b6 <csem_down+0x2e>

00000000000009d6 <csem_up>:

void csem_up(struct counting_semaphore *sem){
 9d6:	1101                	addi	sp,sp,-32
 9d8:	ec06                	sd	ra,24(sp)
 9da:	e822                	sd	s0,16(sp)
 9dc:	e426                	sd	s1,8(sp)
 9de:	1000                	addi	s0,sp,32
 9e0:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore1);
 9e2:	4108                	lw	a0,0(a0)
 9e4:	00000097          	auipc	ra,0x0
 9e8:	a90080e7          	jalr	-1392(ra) # 474 <bsem_down>
    sem->value++;
 9ec:	449c                	lw	a5,8(s1)
 9ee:	2785                	addiw	a5,a5,1
 9f0:	0007871b          	sext.w	a4,a5
 9f4:	c49c                	sw	a5,8(s1)
    if(sem->value == 1)
 9f6:	4785                	li	a5,1
 9f8:	00f70c63          	beq	a4,a5,a10 <csem_up+0x3a>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
 9fc:	4088                	lw	a0,0(s1)
 9fe:	00000097          	auipc	ra,0x0
 a02:	a7e080e7          	jalr	-1410(ra) # 47c <bsem_up>
 a06:	60e2                	ld	ra,24(sp)
 a08:	6442                	ld	s0,16(sp)
 a0a:	64a2                	ld	s1,8(sp)
 a0c:	6105                	addi	sp,sp,32
 a0e:	8082                	ret
        bsem_up(sem->binary_semaphore2);
 a10:	40c8                	lw	a0,4(s1)
 a12:	00000097          	auipc	ra,0x0
 a16:	a6a080e7          	jalr	-1430(ra) # 47c <bsem_up>
 a1a:	b7cd                	j	9fc <csem_up+0x26>
