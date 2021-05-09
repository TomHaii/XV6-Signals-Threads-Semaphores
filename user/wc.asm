
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	adbd8d93          	addi	s11,s11,-1317 # b09 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	a60a0a13          	addi	s4,s4,-1440 # a98 <csem_up+0x4a>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1e4080e7          	jalr	484(ra) # 22a <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2b85                	addiw	s7,s7,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
        w++;
  68:	2c05                	addiw	s8,s8,1
        inword = 1;
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
      c++;
  6e:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	a9258593          	addi	a1,a1,-1390 # b08 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	39a080e7          	jalr	922(ra) # 41c <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
    for(i=0; i<n; i++){
  8e:	00001497          	auipc	s1,0x1
  92:	a7a48493          	addi	s1,s1,-1414 # b08 <buf>
  96:	00050d1b          	sext.w	s10,a0
  9a:	fff5091b          	addiw	s2,a0,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86e6                	mv	a3,s9
  b2:	8662                	mv	a2,s8
  b4:	85de                	mv	a1,s7
  b6:	00001517          	auipc	a0,0x1
  ba:	9fa50513          	addi	a0,a0,-1542 # ab0 <csem_up+0x62>
  be:	00000097          	auipc	ra,0x0
  c2:	718080e7          	jalr	1816(ra) # 7d6 <printf>
}
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
    printf("wc: read error\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	9bc50513          	addi	a0,a0,-1604 # aa0 <csem_up+0x52>
  ec:	00000097          	auipc	ra,0x0
  f0:	6ea080e7          	jalr	1770(ra) # 7d6 <printf>
    exit(1);
  f4:	4505                	li	a0,1
  f6:	00000097          	auipc	ra,0x0
  fa:	30e080e7          	jalr	782(ra) # 404 <exit>

00000000000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	7179                	addi	sp,sp,-48
 100:	f406                	sd	ra,40(sp)
 102:	f022                	sd	s0,32(sp)
 104:	ec26                	sd	s1,24(sp)
 106:	e84a                	sd	s2,16(sp)
 108:	e44e                	sd	s3,8(sp)
 10a:	e052                	sd	s4,0(sp)
 10c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 10e:	4785                	li	a5,1
 110:	04a7d763          	bge	a5,a0,15e <main+0x60>
 114:	00858493          	addi	s1,a1,8
 118:	ffe5099b          	addiw	s3,a0,-2
 11c:	02099793          	slli	a5,s3,0x20
 120:	01d7d993          	srli	s3,a5,0x1d
 124:	05c1                	addi	a1,a1,16
 126:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 128:	4581                	li	a1,0
 12a:	6088                	ld	a0,0(s1)
 12c:	00000097          	auipc	ra,0x0
 130:	318080e7          	jalr	792(ra) # 444 <open>
 134:	892a                	mv	s2,a0
 136:	04054263          	bltz	a0,17a <main+0x7c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 13a:	608c                	ld	a1,0(s1)
 13c:	00000097          	auipc	ra,0x0
 140:	ec4080e7          	jalr	-316(ra) # 0 <wc>
    close(fd);
 144:	854a                	mv	a0,s2
 146:	00000097          	auipc	ra,0x0
 14a:	2e6080e7          	jalr	742(ra) # 42c <close>
  for(i = 1; i < argc; i++){
 14e:	04a1                	addi	s1,s1,8
 150:	fd349ce3          	bne	s1,s3,128 <main+0x2a>
  }
  exit(0);
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	2ae080e7          	jalr	686(ra) # 404 <exit>
    wc(0, "");
 15e:	00001597          	auipc	a1,0x1
 162:	96258593          	addi	a1,a1,-1694 # ac0 <csem_up+0x72>
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	e98080e7          	jalr	-360(ra) # 0 <wc>
    exit(0);
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	292080e7          	jalr	658(ra) # 404 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 17a:	608c                	ld	a1,0(s1)
 17c:	00001517          	auipc	a0,0x1
 180:	94c50513          	addi	a0,a0,-1716 # ac8 <csem_up+0x7a>
 184:	00000097          	auipc	ra,0x0
 188:	652080e7          	jalr	1618(ra) # 7d6 <printf>
      exit(1);
 18c:	4505                	li	a0,1
 18e:	00000097          	auipc	ra,0x0
 192:	276080e7          	jalr	630(ra) # 404 <exit>

0000000000000196 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 19c:	87aa                	mv	a5,a0
 19e:	0585                	addi	a1,a1,1
 1a0:	0785                	addi	a5,a5,1
 1a2:	fff5c703          	lbu	a4,-1(a1)
 1a6:	fee78fa3          	sb	a4,-1(a5)
 1aa:	fb75                	bnez	a4,19e <strcpy+0x8>
    ;
  return os;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb91                	beqz	a5,1d0 <strcmp+0x1e>
 1be:	0005c703          	lbu	a4,0(a1)
 1c2:	00f71763          	bne	a4,a5,1d0 <strcmp+0x1e>
    p++, q++;
 1c6:	0505                	addi	a0,a0,1
 1c8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbe5                	bnez	a5,1be <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1d0:	0005c503          	lbu	a0,0(a1)
}
 1d4:	40a7853b          	subw	a0,a5,a0
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret

00000000000001de <strlen>:

uint
strlen(const char *s)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	cf91                	beqz	a5,204 <strlen+0x26>
 1ea:	0505                	addi	a0,a0,1
 1ec:	87aa                	mv	a5,a0
 1ee:	4685                	li	a3,1
 1f0:	9e89                	subw	a3,a3,a0
 1f2:	00f6853b          	addw	a0,a3,a5
 1f6:	0785                	addi	a5,a5,1
 1f8:	fff7c703          	lbu	a4,-1(a5)
 1fc:	fb7d                	bnez	a4,1f2 <strlen+0x14>
    ;
  return n;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret
  for(n = 0; s[n]; n++)
 204:	4501                	li	a0,0
 206:	bfe5                	j	1fe <strlen+0x20>

0000000000000208 <memset>:

void*
memset(void *dst, int c, uint n)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 20e:	ca19                	beqz	a2,224 <memset+0x1c>
 210:	87aa                	mv	a5,a0
 212:	1602                	slli	a2,a2,0x20
 214:	9201                	srli	a2,a2,0x20
 216:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 21a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 21e:	0785                	addi	a5,a5,1
 220:	fee79de3          	bne	a5,a4,21a <memset+0x12>
  }
  return dst;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret

000000000000022a <strchr>:

char*
strchr(const char *s, char c)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e422                	sd	s0,8(sp)
 22e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 230:	00054783          	lbu	a5,0(a0)
 234:	cb99                	beqz	a5,24a <strchr+0x20>
    if(*s == c)
 236:	00f58763          	beq	a1,a5,244 <strchr+0x1a>
  for(; *s; s++)
 23a:	0505                	addi	a0,a0,1
 23c:	00054783          	lbu	a5,0(a0)
 240:	fbfd                	bnez	a5,236 <strchr+0xc>
      return (char*)s;
  return 0;
 242:	4501                	li	a0,0
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  return 0;
 24a:	4501                	li	a0,0
 24c:	bfe5                	j	244 <strchr+0x1a>

000000000000024e <gets>:

char*
gets(char *buf, int max)
{
 24e:	711d                	addi	sp,sp,-96
 250:	ec86                	sd	ra,88(sp)
 252:	e8a2                	sd	s0,80(sp)
 254:	e4a6                	sd	s1,72(sp)
 256:	e0ca                	sd	s2,64(sp)
 258:	fc4e                	sd	s3,56(sp)
 25a:	f852                	sd	s4,48(sp)
 25c:	f456                	sd	s5,40(sp)
 25e:	f05a                	sd	s6,32(sp)
 260:	ec5e                	sd	s7,24(sp)
 262:	1080                	addi	s0,sp,96
 264:	8baa                	mv	s7,a0
 266:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 268:	892a                	mv	s2,a0
 26a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 26c:	4aa9                	li	s5,10
 26e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 270:	89a6                	mv	s3,s1
 272:	2485                	addiw	s1,s1,1
 274:	0344d863          	bge	s1,s4,2a4 <gets+0x56>
    cc = read(0, &c, 1);
 278:	4605                	li	a2,1
 27a:	faf40593          	addi	a1,s0,-81
 27e:	4501                	li	a0,0
 280:	00000097          	auipc	ra,0x0
 284:	19c080e7          	jalr	412(ra) # 41c <read>
    if(cc < 1)
 288:	00a05e63          	blez	a0,2a4 <gets+0x56>
    buf[i++] = c;
 28c:	faf44783          	lbu	a5,-81(s0)
 290:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 294:	01578763          	beq	a5,s5,2a2 <gets+0x54>
 298:	0905                	addi	s2,s2,1
 29a:	fd679be3          	bne	a5,s6,270 <gets+0x22>
  for(i=0; i+1 < max; ){
 29e:	89a6                	mv	s3,s1
 2a0:	a011                	j	2a4 <gets+0x56>
 2a2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2a4:	99de                	add	s3,s3,s7
 2a6:	00098023          	sb	zero,0(s3)
  return buf;
}
 2aa:	855e                	mv	a0,s7
 2ac:	60e6                	ld	ra,88(sp)
 2ae:	6446                	ld	s0,80(sp)
 2b0:	64a6                	ld	s1,72(sp)
 2b2:	6906                	ld	s2,64(sp)
 2b4:	79e2                	ld	s3,56(sp)
 2b6:	7a42                	ld	s4,48(sp)
 2b8:	7aa2                	ld	s5,40(sp)
 2ba:	7b02                	ld	s6,32(sp)
 2bc:	6be2                	ld	s7,24(sp)
 2be:	6125                	addi	sp,sp,96
 2c0:	8082                	ret

00000000000002c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c2:	1101                	addi	sp,sp,-32
 2c4:	ec06                	sd	ra,24(sp)
 2c6:	e822                	sd	s0,16(sp)
 2c8:	e426                	sd	s1,8(sp)
 2ca:	e04a                	sd	s2,0(sp)
 2cc:	1000                	addi	s0,sp,32
 2ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	4581                	li	a1,0
 2d2:	00000097          	auipc	ra,0x0
 2d6:	172080e7          	jalr	370(ra) # 444 <open>
  if(fd < 0)
 2da:	02054563          	bltz	a0,304 <stat+0x42>
 2de:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e0:	85ca                	mv	a1,s2
 2e2:	00000097          	auipc	ra,0x0
 2e6:	17a080e7          	jalr	378(ra) # 45c <fstat>
 2ea:	892a                	mv	s2,a0
  close(fd);
 2ec:	8526                	mv	a0,s1
 2ee:	00000097          	auipc	ra,0x0
 2f2:	13e080e7          	jalr	318(ra) # 42c <close>
  return r;
}
 2f6:	854a                	mv	a0,s2
 2f8:	60e2                	ld	ra,24(sp)
 2fa:	6442                	ld	s0,16(sp)
 2fc:	64a2                	ld	s1,8(sp)
 2fe:	6902                	ld	s2,0(sp)
 300:	6105                	addi	sp,sp,32
 302:	8082                	ret
    return -1;
 304:	597d                	li	s2,-1
 306:	bfc5                	j	2f6 <stat+0x34>

0000000000000308 <atoi>:

int
atoi(const char *s)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30e:	00054603          	lbu	a2,0(a0)
 312:	fd06079b          	addiw	a5,a2,-48
 316:	0ff7f793          	andi	a5,a5,255
 31a:	4725                	li	a4,9
 31c:	02f76963          	bltu	a4,a5,34e <atoi+0x46>
 320:	86aa                	mv	a3,a0
  n = 0;
 322:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 324:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 326:	0685                	addi	a3,a3,1
 328:	0025179b          	slliw	a5,a0,0x2
 32c:	9fa9                	addw	a5,a5,a0
 32e:	0017979b          	slliw	a5,a5,0x1
 332:	9fb1                	addw	a5,a5,a2
 334:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 338:	0006c603          	lbu	a2,0(a3)
 33c:	fd06071b          	addiw	a4,a2,-48
 340:	0ff77713          	andi	a4,a4,255
 344:	fee5f1e3          	bgeu	a1,a4,326 <atoi+0x1e>
  return n;
}
 348:	6422                	ld	s0,8(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
  n = 0;
 34e:	4501                	li	a0,0
 350:	bfe5                	j	348 <atoi+0x40>

0000000000000352 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 352:	1141                	addi	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 358:	02b57463          	bgeu	a0,a1,380 <memmove+0x2e>
    while(n-- > 0)
 35c:	00c05f63          	blez	a2,37a <memmove+0x28>
 360:	1602                	slli	a2,a2,0x20
 362:	9201                	srli	a2,a2,0x20
 364:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 368:	872a                	mv	a4,a0
      *dst++ = *src++;
 36a:	0585                	addi	a1,a1,1
 36c:	0705                	addi	a4,a4,1
 36e:	fff5c683          	lbu	a3,-1(a1)
 372:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 376:	fee79ae3          	bne	a5,a4,36a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
    dst += n;
 380:	00c50733          	add	a4,a0,a2
    src += n;
 384:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 386:	fec05ae3          	blez	a2,37a <memmove+0x28>
 38a:	fff6079b          	addiw	a5,a2,-1
 38e:	1782                	slli	a5,a5,0x20
 390:	9381                	srli	a5,a5,0x20
 392:	fff7c793          	not	a5,a5
 396:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 398:	15fd                	addi	a1,a1,-1
 39a:	177d                	addi	a4,a4,-1
 39c:	0005c683          	lbu	a3,0(a1)
 3a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3a4:	fee79ae3          	bne	a5,a4,398 <memmove+0x46>
 3a8:	bfc9                	j	37a <memmove+0x28>

00000000000003aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e422                	sd	s0,8(sp)
 3ae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3b0:	ca05                	beqz	a2,3e0 <memcmp+0x36>
 3b2:	fff6069b          	addiw	a3,a2,-1
 3b6:	1682                	slli	a3,a3,0x20
 3b8:	9281                	srli	a3,a3,0x20
 3ba:	0685                	addi	a3,a3,1
 3bc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3be:	00054783          	lbu	a5,0(a0)
 3c2:	0005c703          	lbu	a4,0(a1)
 3c6:	00e79863          	bne	a5,a4,3d6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3ca:	0505                	addi	a0,a0,1
    p2++;
 3cc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3ce:	fed518e3          	bne	a0,a3,3be <memcmp+0x14>
  }
  return 0;
 3d2:	4501                	li	a0,0
 3d4:	a019                	j	3da <memcmp+0x30>
      return *p1 - *p2;
 3d6:	40e7853b          	subw	a0,a5,a4
}
 3da:	6422                	ld	s0,8(sp)
 3dc:	0141                	addi	sp,sp,16
 3de:	8082                	ret
  return 0;
 3e0:	4501                	li	a0,0
 3e2:	bfe5                	j	3da <memcmp+0x30>

00000000000003e4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e406                	sd	ra,8(sp)
 3e8:	e022                	sd	s0,0(sp)
 3ea:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ec:	00000097          	auipc	ra,0x0
 3f0:	f66080e7          	jalr	-154(ra) # 352 <memmove>
}
 3f4:	60a2                	ld	ra,8(sp)
 3f6:	6402                	ld	s0,0(sp)
 3f8:	0141                	addi	sp,sp,16
 3fa:	8082                	ret

00000000000003fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3fc:	4885                	li	a7,1
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <exit>:
.global exit
exit:
 li a7, SYS_exit
 404:	4889                	li	a7,2
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <wait>:
.global wait
wait:
 li a7, SYS_wait
 40c:	488d                	li	a7,3
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 414:	4891                	li	a7,4
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <read>:
.global read
read:
 li a7, SYS_read
 41c:	4895                	li	a7,5
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <write>:
.global write
write:
 li a7, SYS_write
 424:	48c1                	li	a7,16
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <close>:
.global close
close:
 li a7, SYS_close
 42c:	48d5                	li	a7,21
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <kill>:
.global kill
kill:
 li a7, SYS_kill
 434:	4899                	li	a7,6
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <exec>:
.global exec
exec:
 li a7, SYS_exec
 43c:	489d                	li	a7,7
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <open>:
.global open
open:
 li a7, SYS_open
 444:	48bd                	li	a7,15
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 44c:	48c5                	li	a7,17
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 454:	48c9                	li	a7,18
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 45c:	48a1                	li	a7,8
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <link>:
.global link
link:
 li a7, SYS_link
 464:	48cd                	li	a7,19
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 46c:	48d1                	li	a7,20
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 474:	48a5                	li	a7,9
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <dup>:
.global dup
dup:
 li a7, SYS_dup
 47c:	48a9                	li	a7,10
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 484:	48ad                	li	a7,11
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 48c:	48b1                	li	a7,12
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 494:	48b5                	li	a7,13
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 49c:	48b9                	li	a7,14
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 4a4:	48d9                	li	a7,22
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 4ac:	48dd                	li	a7,23
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 4b4:	48e1                	li	a7,24
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 4bc:	48e5                	li	a7,25
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 4c4:	48e9                	li	a7,26
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 4cc:	48ed                	li	a7,27
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 4d4:	48f1                	li	a7,28
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 4dc:	48f5                	li	a7,29
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 4e4:	48f9                	li	a7,30
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 4ec:	48fd                	li	a7,31
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 4f4:	02000893          	li	a7,32
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4fe:	1101                	addi	sp,sp,-32
 500:	ec06                	sd	ra,24(sp)
 502:	e822                	sd	s0,16(sp)
 504:	1000                	addi	s0,sp,32
 506:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 50a:	4605                	li	a2,1
 50c:	fef40593          	addi	a1,s0,-17
 510:	00000097          	auipc	ra,0x0
 514:	f14080e7          	jalr	-236(ra) # 424 <write>
}
 518:	60e2                	ld	ra,24(sp)
 51a:	6442                	ld	s0,16(sp)
 51c:	6105                	addi	sp,sp,32
 51e:	8082                	ret

0000000000000520 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 520:	7139                	addi	sp,sp,-64
 522:	fc06                	sd	ra,56(sp)
 524:	f822                	sd	s0,48(sp)
 526:	f426                	sd	s1,40(sp)
 528:	f04a                	sd	s2,32(sp)
 52a:	ec4e                	sd	s3,24(sp)
 52c:	0080                	addi	s0,sp,64
 52e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 530:	c299                	beqz	a3,536 <printint+0x16>
 532:	0805c863          	bltz	a1,5c2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 536:	2581                	sext.w	a1,a1
  neg = 0;
 538:	4881                	li	a7,0
 53a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 53e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 540:	2601                	sext.w	a2,a2
 542:	00000517          	auipc	a0,0x0
 546:	5a650513          	addi	a0,a0,1446 # ae8 <digits>
 54a:	883a                	mv	a6,a4
 54c:	2705                	addiw	a4,a4,1
 54e:	02c5f7bb          	remuw	a5,a1,a2
 552:	1782                	slli	a5,a5,0x20
 554:	9381                	srli	a5,a5,0x20
 556:	97aa                	add	a5,a5,a0
 558:	0007c783          	lbu	a5,0(a5)
 55c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 560:	0005879b          	sext.w	a5,a1
 564:	02c5d5bb          	divuw	a1,a1,a2
 568:	0685                	addi	a3,a3,1
 56a:	fec7f0e3          	bgeu	a5,a2,54a <printint+0x2a>
  if(neg)
 56e:	00088b63          	beqz	a7,584 <printint+0x64>
    buf[i++] = '-';
 572:	fd040793          	addi	a5,s0,-48
 576:	973e                	add	a4,a4,a5
 578:	02d00793          	li	a5,45
 57c:	fef70823          	sb	a5,-16(a4)
 580:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 584:	02e05863          	blez	a4,5b4 <printint+0x94>
 588:	fc040793          	addi	a5,s0,-64
 58c:	00e78933          	add	s2,a5,a4
 590:	fff78993          	addi	s3,a5,-1
 594:	99ba                	add	s3,s3,a4
 596:	377d                	addiw	a4,a4,-1
 598:	1702                	slli	a4,a4,0x20
 59a:	9301                	srli	a4,a4,0x20
 59c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5a0:	fff94583          	lbu	a1,-1(s2)
 5a4:	8526                	mv	a0,s1
 5a6:	00000097          	auipc	ra,0x0
 5aa:	f58080e7          	jalr	-168(ra) # 4fe <putc>
  while(--i >= 0)
 5ae:	197d                	addi	s2,s2,-1
 5b0:	ff3918e3          	bne	s2,s3,5a0 <printint+0x80>
}
 5b4:	70e2                	ld	ra,56(sp)
 5b6:	7442                	ld	s0,48(sp)
 5b8:	74a2                	ld	s1,40(sp)
 5ba:	7902                	ld	s2,32(sp)
 5bc:	69e2                	ld	s3,24(sp)
 5be:	6121                	addi	sp,sp,64
 5c0:	8082                	ret
    x = -xx;
 5c2:	40b005bb          	negw	a1,a1
    neg = 1;
 5c6:	4885                	li	a7,1
    x = -xx;
 5c8:	bf8d                	j	53a <printint+0x1a>

00000000000005ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ca:	7119                	addi	sp,sp,-128
 5cc:	fc86                	sd	ra,120(sp)
 5ce:	f8a2                	sd	s0,112(sp)
 5d0:	f4a6                	sd	s1,104(sp)
 5d2:	f0ca                	sd	s2,96(sp)
 5d4:	ecce                	sd	s3,88(sp)
 5d6:	e8d2                	sd	s4,80(sp)
 5d8:	e4d6                	sd	s5,72(sp)
 5da:	e0da                	sd	s6,64(sp)
 5dc:	fc5e                	sd	s7,56(sp)
 5de:	f862                	sd	s8,48(sp)
 5e0:	f466                	sd	s9,40(sp)
 5e2:	f06a                	sd	s10,32(sp)
 5e4:	ec6e                	sd	s11,24(sp)
 5e6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5e8:	0005c903          	lbu	s2,0(a1)
 5ec:	18090f63          	beqz	s2,78a <vprintf+0x1c0>
 5f0:	8aaa                	mv	s5,a0
 5f2:	8b32                	mv	s6,a2
 5f4:	00158493          	addi	s1,a1,1
  state = 0;
 5f8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5fa:	02500a13          	li	s4,37
      if(c == 'd'){
 5fe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 602:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 606:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 60a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60e:	00000b97          	auipc	s7,0x0
 612:	4dab8b93          	addi	s7,s7,1242 # ae8 <digits>
 616:	a839                	j	634 <vprintf+0x6a>
        putc(fd, c);
 618:	85ca                	mv	a1,s2
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	ee2080e7          	jalr	-286(ra) # 4fe <putc>
 624:	a019                	j	62a <vprintf+0x60>
    } else if(state == '%'){
 626:	01498f63          	beq	s3,s4,644 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 62a:	0485                	addi	s1,s1,1
 62c:	fff4c903          	lbu	s2,-1(s1)
 630:	14090d63          	beqz	s2,78a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 634:	0009079b          	sext.w	a5,s2
    if(state == 0){
 638:	fe0997e3          	bnez	s3,626 <vprintf+0x5c>
      if(c == '%'){
 63c:	fd479ee3          	bne	a5,s4,618 <vprintf+0x4e>
        state = '%';
 640:	89be                	mv	s3,a5
 642:	b7e5                	j	62a <vprintf+0x60>
      if(c == 'd'){
 644:	05878063          	beq	a5,s8,684 <vprintf+0xba>
      } else if(c == 'l') {
 648:	05978c63          	beq	a5,s9,6a0 <vprintf+0xd6>
      } else if(c == 'x') {
 64c:	07a78863          	beq	a5,s10,6bc <vprintf+0xf2>
      } else if(c == 'p') {
 650:	09b78463          	beq	a5,s11,6d8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 654:	07300713          	li	a4,115
 658:	0ce78663          	beq	a5,a4,724 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 65c:	06300713          	li	a4,99
 660:	0ee78e63          	beq	a5,a4,75c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 664:	11478863          	beq	a5,s4,774 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 668:	85d2                	mv	a1,s4
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	e92080e7          	jalr	-366(ra) # 4fe <putc>
        putc(fd, c);
 674:	85ca                	mv	a1,s2
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	e86080e7          	jalr	-378(ra) # 4fe <putc>
      }
      state = 0;
 680:	4981                	li	s3,0
 682:	b765                	j	62a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 684:	008b0913          	addi	s2,s6,8
 688:	4685                	li	a3,1
 68a:	4629                	li	a2,10
 68c:	000b2583          	lw	a1,0(s6)
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e8e080e7          	jalr	-370(ra) # 520 <printint>
 69a:	8b4a                	mv	s6,s2
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b771                	j	62a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a0:	008b0913          	addi	s2,s6,8
 6a4:	4681                	li	a3,0
 6a6:	4629                	li	a2,10
 6a8:	000b2583          	lw	a1,0(s6)
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	e72080e7          	jalr	-398(ra) # 520 <printint>
 6b6:	8b4a                	mv	s6,s2
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bf85                	j	62a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6bc:	008b0913          	addi	s2,s6,8
 6c0:	4681                	li	a3,0
 6c2:	4641                	li	a2,16
 6c4:	000b2583          	lw	a1,0(s6)
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	e56080e7          	jalr	-426(ra) # 520 <printint>
 6d2:	8b4a                	mv	s6,s2
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bf91                	j	62a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6d8:	008b0793          	addi	a5,s6,8
 6dc:	f8f43423          	sd	a5,-120(s0)
 6e0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6e4:	03000593          	li	a1,48
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	e14080e7          	jalr	-492(ra) # 4fe <putc>
  putc(fd, 'x');
 6f2:	85ea                	mv	a1,s10
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	e08080e7          	jalr	-504(ra) # 4fe <putc>
 6fe:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 700:	03c9d793          	srli	a5,s3,0x3c
 704:	97de                	add	a5,a5,s7
 706:	0007c583          	lbu	a1,0(a5)
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	df2080e7          	jalr	-526(ra) # 4fe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 714:	0992                	slli	s3,s3,0x4
 716:	397d                	addiw	s2,s2,-1
 718:	fe0914e3          	bnez	s2,700 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 71c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 720:	4981                	li	s3,0
 722:	b721                	j	62a <vprintf+0x60>
        s = va_arg(ap, char*);
 724:	008b0993          	addi	s3,s6,8
 728:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 72c:	02090163          	beqz	s2,74e <vprintf+0x184>
        while(*s != 0){
 730:	00094583          	lbu	a1,0(s2)
 734:	c9a1                	beqz	a1,784 <vprintf+0x1ba>
          putc(fd, *s);
 736:	8556                	mv	a0,s5
 738:	00000097          	auipc	ra,0x0
 73c:	dc6080e7          	jalr	-570(ra) # 4fe <putc>
          s++;
 740:	0905                	addi	s2,s2,1
        while(*s != 0){
 742:	00094583          	lbu	a1,0(s2)
 746:	f9e5                	bnez	a1,736 <vprintf+0x16c>
        s = va_arg(ap, char*);
 748:	8b4e                	mv	s6,s3
      state = 0;
 74a:	4981                	li	s3,0
 74c:	bdf9                	j	62a <vprintf+0x60>
          s = "(null)";
 74e:	00000917          	auipc	s2,0x0
 752:	39290913          	addi	s2,s2,914 # ae0 <csem_up+0x92>
        while(*s != 0){
 756:	02800593          	li	a1,40
 75a:	bff1                	j	736 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 75c:	008b0913          	addi	s2,s6,8
 760:	000b4583          	lbu	a1,0(s6)
 764:	8556                	mv	a0,s5
 766:	00000097          	auipc	ra,0x0
 76a:	d98080e7          	jalr	-616(ra) # 4fe <putc>
 76e:	8b4a                	mv	s6,s2
      state = 0;
 770:	4981                	li	s3,0
 772:	bd65                	j	62a <vprintf+0x60>
        putc(fd, c);
 774:	85d2                	mv	a1,s4
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	d86080e7          	jalr	-634(ra) # 4fe <putc>
      state = 0;
 780:	4981                	li	s3,0
 782:	b565                	j	62a <vprintf+0x60>
        s = va_arg(ap, char*);
 784:	8b4e                	mv	s6,s3
      state = 0;
 786:	4981                	li	s3,0
 788:	b54d                	j	62a <vprintf+0x60>
    }
  }
}
 78a:	70e6                	ld	ra,120(sp)
 78c:	7446                	ld	s0,112(sp)
 78e:	74a6                	ld	s1,104(sp)
 790:	7906                	ld	s2,96(sp)
 792:	69e6                	ld	s3,88(sp)
 794:	6a46                	ld	s4,80(sp)
 796:	6aa6                	ld	s5,72(sp)
 798:	6b06                	ld	s6,64(sp)
 79a:	7be2                	ld	s7,56(sp)
 79c:	7c42                	ld	s8,48(sp)
 79e:	7ca2                	ld	s9,40(sp)
 7a0:	7d02                	ld	s10,32(sp)
 7a2:	6de2                	ld	s11,24(sp)
 7a4:	6109                	addi	sp,sp,128
 7a6:	8082                	ret

00000000000007a8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a8:	715d                	addi	sp,sp,-80
 7aa:	ec06                	sd	ra,24(sp)
 7ac:	e822                	sd	s0,16(sp)
 7ae:	1000                	addi	s0,sp,32
 7b0:	e010                	sd	a2,0(s0)
 7b2:	e414                	sd	a3,8(s0)
 7b4:	e818                	sd	a4,16(s0)
 7b6:	ec1c                	sd	a5,24(s0)
 7b8:	03043023          	sd	a6,32(s0)
 7bc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c4:	8622                	mv	a2,s0
 7c6:	00000097          	auipc	ra,0x0
 7ca:	e04080e7          	jalr	-508(ra) # 5ca <vprintf>
}
 7ce:	60e2                	ld	ra,24(sp)
 7d0:	6442                	ld	s0,16(sp)
 7d2:	6161                	addi	sp,sp,80
 7d4:	8082                	ret

00000000000007d6 <printf>:

void
printf(const char *fmt, ...)
{
 7d6:	711d                	addi	sp,sp,-96
 7d8:	ec06                	sd	ra,24(sp)
 7da:	e822                	sd	s0,16(sp)
 7dc:	1000                	addi	s0,sp,32
 7de:	e40c                	sd	a1,8(s0)
 7e0:	e810                	sd	a2,16(s0)
 7e2:	ec14                	sd	a3,24(s0)
 7e4:	f018                	sd	a4,32(s0)
 7e6:	f41c                	sd	a5,40(s0)
 7e8:	03043823          	sd	a6,48(s0)
 7ec:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f0:	00840613          	addi	a2,s0,8
 7f4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f8:	85aa                	mv	a1,a0
 7fa:	4505                	li	a0,1
 7fc:	00000097          	auipc	ra,0x0
 800:	dce080e7          	jalr	-562(ra) # 5ca <vprintf>
}
 804:	60e2                	ld	ra,24(sp)
 806:	6442                	ld	s0,16(sp)
 808:	6125                	addi	sp,sp,96
 80a:	8082                	ret

000000000000080c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 80c:	1141                	addi	sp,sp,-16
 80e:	e422                	sd	s0,8(sp)
 810:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 812:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 816:	00000797          	auipc	a5,0x0
 81a:	2ea7b783          	ld	a5,746(a5) # b00 <freep>
 81e:	a805                	j	84e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 820:	4618                	lw	a4,8(a2)
 822:	9db9                	addw	a1,a1,a4
 824:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 828:	6398                	ld	a4,0(a5)
 82a:	6318                	ld	a4,0(a4)
 82c:	fee53823          	sd	a4,-16(a0)
 830:	a091                	j	874 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 832:	ff852703          	lw	a4,-8(a0)
 836:	9e39                	addw	a2,a2,a4
 838:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 83a:	ff053703          	ld	a4,-16(a0)
 83e:	e398                	sd	a4,0(a5)
 840:	a099                	j	886 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 842:	6398                	ld	a4,0(a5)
 844:	00e7e463          	bltu	a5,a4,84c <free+0x40>
 848:	00e6ea63          	bltu	a3,a4,85c <free+0x50>
{
 84c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84e:	fed7fae3          	bgeu	a5,a3,842 <free+0x36>
 852:	6398                	ld	a4,0(a5)
 854:	00e6e463          	bltu	a3,a4,85c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 858:	fee7eae3          	bltu	a5,a4,84c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 85c:	ff852583          	lw	a1,-8(a0)
 860:	6390                	ld	a2,0(a5)
 862:	02059813          	slli	a6,a1,0x20
 866:	01c85713          	srli	a4,a6,0x1c
 86a:	9736                	add	a4,a4,a3
 86c:	fae60ae3          	beq	a2,a4,820 <free+0x14>
    bp->s.ptr = p->s.ptr;
 870:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 874:	4790                	lw	a2,8(a5)
 876:	02061593          	slli	a1,a2,0x20
 87a:	01c5d713          	srli	a4,a1,0x1c
 87e:	973e                	add	a4,a4,a5
 880:	fae689e3          	beq	a3,a4,832 <free+0x26>
  } else
    p->s.ptr = bp;
 884:	e394                	sd	a3,0(a5)
  freep = p;
 886:	00000717          	auipc	a4,0x0
 88a:	26f73d23          	sd	a5,634(a4) # b00 <freep>
}
 88e:	6422                	ld	s0,8(sp)
 890:	0141                	addi	sp,sp,16
 892:	8082                	ret

0000000000000894 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 894:	7139                	addi	sp,sp,-64
 896:	fc06                	sd	ra,56(sp)
 898:	f822                	sd	s0,48(sp)
 89a:	f426                	sd	s1,40(sp)
 89c:	f04a                	sd	s2,32(sp)
 89e:	ec4e                	sd	s3,24(sp)
 8a0:	e852                	sd	s4,16(sp)
 8a2:	e456                	sd	s5,8(sp)
 8a4:	e05a                	sd	s6,0(sp)
 8a6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a8:	02051493          	slli	s1,a0,0x20
 8ac:	9081                	srli	s1,s1,0x20
 8ae:	04bd                	addi	s1,s1,15
 8b0:	8091                	srli	s1,s1,0x4
 8b2:	0014899b          	addiw	s3,s1,1
 8b6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8b8:	00000517          	auipc	a0,0x0
 8bc:	24853503          	ld	a0,584(a0) # b00 <freep>
 8c0:	c515                	beqz	a0,8ec <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c4:	4798                	lw	a4,8(a5)
 8c6:	02977f63          	bgeu	a4,s1,904 <malloc+0x70>
 8ca:	8a4e                	mv	s4,s3
 8cc:	0009871b          	sext.w	a4,s3
 8d0:	6685                	lui	a3,0x1
 8d2:	00d77363          	bgeu	a4,a3,8d8 <malloc+0x44>
 8d6:	6a05                	lui	s4,0x1
 8d8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8dc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e0:	00000917          	auipc	s2,0x0
 8e4:	22090913          	addi	s2,s2,544 # b00 <freep>
  if(p == (char*)-1)
 8e8:	5afd                	li	s5,-1
 8ea:	a895                	j	95e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8ec:	00000797          	auipc	a5,0x0
 8f0:	41c78793          	addi	a5,a5,1052 # d08 <base>
 8f4:	00000717          	auipc	a4,0x0
 8f8:	20f73623          	sd	a5,524(a4) # b00 <freep>
 8fc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8fe:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 902:	b7e1                	j	8ca <malloc+0x36>
      if(p->s.size == nunits)
 904:	02e48c63          	beq	s1,a4,93c <malloc+0xa8>
        p->s.size -= nunits;
 908:	4137073b          	subw	a4,a4,s3
 90c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 90e:	02071693          	slli	a3,a4,0x20
 912:	01c6d713          	srli	a4,a3,0x1c
 916:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 918:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 91c:	00000717          	auipc	a4,0x0
 920:	1ea73223          	sd	a0,484(a4) # b00 <freep>
      return (void*)(p + 1);
 924:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 928:	70e2                	ld	ra,56(sp)
 92a:	7442                	ld	s0,48(sp)
 92c:	74a2                	ld	s1,40(sp)
 92e:	7902                	ld	s2,32(sp)
 930:	69e2                	ld	s3,24(sp)
 932:	6a42                	ld	s4,16(sp)
 934:	6aa2                	ld	s5,8(sp)
 936:	6b02                	ld	s6,0(sp)
 938:	6121                	addi	sp,sp,64
 93a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 93c:	6398                	ld	a4,0(a5)
 93e:	e118                	sd	a4,0(a0)
 940:	bff1                	j	91c <malloc+0x88>
  hp->s.size = nu;
 942:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 946:	0541                	addi	a0,a0,16
 948:	00000097          	auipc	ra,0x0
 94c:	ec4080e7          	jalr	-316(ra) # 80c <free>
  return freep;
 950:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 954:	d971                	beqz	a0,928 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 956:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 958:	4798                	lw	a4,8(a5)
 95a:	fa9775e3          	bgeu	a4,s1,904 <malloc+0x70>
    if(p == freep)
 95e:	00093703          	ld	a4,0(s2)
 962:	853e                	mv	a0,a5
 964:	fef719e3          	bne	a4,a5,956 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 968:	8552                	mv	a0,s4
 96a:	00000097          	auipc	ra,0x0
 96e:	b22080e7          	jalr	-1246(ra) # 48c <sbrk>
  if(p == (char*)-1)
 972:	fd5518e3          	bne	a0,s5,942 <malloc+0xae>
        return 0;
 976:	4501                	li	a0,0
 978:	bf45                	j	928 <malloc+0x94>

000000000000097a <csem_alloc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int csem_alloc(struct counting_semaphore *sem, int initial_value){
 97a:	1101                	addi	sp,sp,-32
 97c:	ec06                	sd	ra,24(sp)
 97e:	e822                	sd	s0,16(sp)
 980:	e426                	sd	s1,8(sp)
 982:	e04a                	sd	s2,0(sp)
 984:	1000                	addi	s0,sp,32
 986:	84aa                	mv	s1,a0
 988:	892e                	mv	s2,a1
    sem->binary_semaphore1 = bsem_alloc();
 98a:	00000097          	auipc	ra,0x0
 98e:	b52080e7          	jalr	-1198(ra) # 4dc <bsem_alloc>
 992:	c088                	sw	a0,0(s1)
    sem->binary_semaphore2 = bsem_alloc();
 994:	00000097          	auipc	ra,0x0
 998:	b48080e7          	jalr	-1208(ra) # 4dc <bsem_alloc>
 99c:	87aa                	mv	a5,a0
 99e:	c0c8                	sw	a0,4(s1)
    if(sem->binary_semaphore1 == -1 || sem->binary_semaphore2 == -1)
 9a0:	4088                	lw	a0,0(s1)
 9a2:	577d                	li	a4,-1
 9a4:	00e50963          	beq	a0,a4,9b6 <csem_alloc+0x3c>
 9a8:	02e78363          	beq	a5,a4,9ce <csem_alloc+0x54>
        return -1;
    if(initial_value == 0)
 9ac:	00090b63          	beqz	s2,9c2 <csem_alloc+0x48>
        bsem_down(sem->binary_semaphore2);
    sem->value = initial_value;
 9b0:	0124a423          	sw	s2,8(s1)
    return 0;
 9b4:	4501                	li	a0,0
}
 9b6:	60e2                	ld	ra,24(sp)
 9b8:	6442                	ld	s0,16(sp)
 9ba:	64a2                	ld	s1,8(sp)
 9bc:	6902                	ld	s2,0(sp)
 9be:	6105                	addi	sp,sp,32
 9c0:	8082                	ret
        bsem_down(sem->binary_semaphore2);
 9c2:	853e                	mv	a0,a5
 9c4:	00000097          	auipc	ra,0x0
 9c8:	b28080e7          	jalr	-1240(ra) # 4ec <bsem_down>
 9cc:	b7d5                	j	9b0 <csem_alloc+0x36>
        return -1;
 9ce:	853e                	mv	a0,a5
 9d0:	b7dd                	j	9b6 <csem_alloc+0x3c>

00000000000009d2 <csem_free>:

void csem_free(struct counting_semaphore *sem){
 9d2:	1101                	addi	sp,sp,-32
 9d4:	ec06                	sd	ra,24(sp)
 9d6:	e822                	sd	s0,16(sp)
 9d8:	e426                	sd	s1,8(sp)
 9da:	1000                	addi	s0,sp,32
 9dc:	84aa                	mv	s1,a0
    bsem_free(sem->binary_semaphore1);
 9de:	4108                	lw	a0,0(a0)
 9e0:	00000097          	auipc	ra,0x0
 9e4:	b04080e7          	jalr	-1276(ra) # 4e4 <bsem_free>
    bsem_free(sem->binary_semaphore2);
 9e8:	40c8                	lw	a0,4(s1)
 9ea:	00000097          	auipc	ra,0x0
 9ee:	afa080e7          	jalr	-1286(ra) # 4e4 <bsem_free>
    sem->value = 0;
 9f2:	0004a423          	sw	zero,8(s1)
}
 9f6:	60e2                	ld	ra,24(sp)
 9f8:	6442                	ld	s0,16(sp)
 9fa:	64a2                	ld	s1,8(sp)
 9fc:	6105                	addi	sp,sp,32
 9fe:	8082                	ret

0000000000000a00 <csem_down>:

void csem_down(struct counting_semaphore *sem){
 a00:	1101                	addi	sp,sp,-32
 a02:	ec06                	sd	ra,24(sp)
 a04:	e822                	sd	s0,16(sp)
 a06:	e426                	sd	s1,8(sp)
 a08:	1000                	addi	s0,sp,32
 a0a:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore2);
 a0c:	4148                	lw	a0,4(a0)
 a0e:	00000097          	auipc	ra,0x0
 a12:	ade080e7          	jalr	-1314(ra) # 4ec <bsem_down>
    bsem_down(sem->binary_semaphore1);
 a16:	4088                	lw	a0,0(s1)
 a18:	00000097          	auipc	ra,0x0
 a1c:	ad4080e7          	jalr	-1324(ra) # 4ec <bsem_down>
    sem->value--;
 a20:	449c                	lw	a5,8(s1)
 a22:	37fd                	addiw	a5,a5,-1
 a24:	0007871b          	sext.w	a4,a5
 a28:	c49c                	sw	a5,8(s1)
    if(sem->value > 0)
 a2a:	00e04c63          	bgtz	a4,a42 <csem_down+0x42>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
 a2e:	4088                	lw	a0,0(s1)
 a30:	00000097          	auipc	ra,0x0
 a34:	ac4080e7          	jalr	-1340(ra) # 4f4 <bsem_up>
}
 a38:	60e2                	ld	ra,24(sp)
 a3a:	6442                	ld	s0,16(sp)
 a3c:	64a2                	ld	s1,8(sp)
 a3e:	6105                	addi	sp,sp,32
 a40:	8082                	ret
        bsem_up(sem->binary_semaphore2);
 a42:	40c8                	lw	a0,4(s1)
 a44:	00000097          	auipc	ra,0x0
 a48:	ab0080e7          	jalr	-1360(ra) # 4f4 <bsem_up>
 a4c:	b7cd                	j	a2e <csem_down+0x2e>

0000000000000a4e <csem_up>:

void csem_up(struct counting_semaphore *sem){
 a4e:	1101                	addi	sp,sp,-32
 a50:	ec06                	sd	ra,24(sp)
 a52:	e822                	sd	s0,16(sp)
 a54:	e426                	sd	s1,8(sp)
 a56:	1000                	addi	s0,sp,32
 a58:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore1);
 a5a:	4108                	lw	a0,0(a0)
 a5c:	00000097          	auipc	ra,0x0
 a60:	a90080e7          	jalr	-1392(ra) # 4ec <bsem_down>
    sem->value++;
 a64:	449c                	lw	a5,8(s1)
 a66:	2785                	addiw	a5,a5,1
 a68:	0007871b          	sext.w	a4,a5
 a6c:	c49c                	sw	a5,8(s1)
    if(sem->value == 1)
 a6e:	4785                	li	a5,1
 a70:	00f70c63          	beq	a4,a5,a88 <csem_up+0x3a>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
 a74:	4088                	lw	a0,0(s1)
 a76:	00000097          	auipc	ra,0x0
 a7a:	a7e080e7          	jalr	-1410(ra) # 4f4 <bsem_up>
 a7e:	60e2                	ld	ra,24(sp)
 a80:	6442                	ld	s0,16(sp)
 a82:	64a2                	ld	s1,8(sp)
 a84:	6105                	addi	sp,sp,32
 a86:	8082                	ret
        bsem_up(sem->binary_semaphore2);
 a88:	40c8                	lw	a0,4(s1)
 a8a:	00000097          	auipc	ra,0x0
 a8e:	a6a080e7          	jalr	-1430(ra) # 4f4 <bsem_up>
 a92:	b7cd                	j	a74 <csem_up+0x26>
