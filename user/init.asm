
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	9ea50513          	addi	a0,a0,-1558 # 9f8 <csem_up+0x48>
  16:	00000097          	auipc	ra,0x0
  1a:	390080e7          	jalr	912(ra) # 3a6 <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3ba080e7          	jalr	954(ra) # 3de <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3b0080e7          	jalr	944(ra) # 3de <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	9ca90913          	addi	s2,s2,-1590 # a00 <csem_up+0x50>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6f8080e7          	jalr	1784(ra) # 738 <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	316080e7          	jalr	790(ra) # 35e <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.

      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	314080e7          	jalr	788(ra) # 36e <wait>

      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	9e650513          	addi	a0,a0,-1562 # a50 <csem_up+0xa0>
  72:	00000097          	auipc	ra,0x0
  76:	6c6080e7          	jalr	1734(ra) # 738 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	2ea080e7          	jalr	746(ra) # 366 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	97050513          	addi	a0,a0,-1680 # 9f8 <csem_up+0x48>
  90:	00000097          	auipc	ra,0x0
  94:	31e080e7          	jalr	798(ra) # 3ae <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	95e50513          	addi	a0,a0,-1698 # 9f8 <csem_up+0x48>
  a2:	00000097          	auipc	ra,0x0
  a6:	304080e7          	jalr	772(ra) # 3a6 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	96c50513          	addi	a0,a0,-1684 # a18 <csem_up+0x68>
  b4:	00000097          	auipc	ra,0x0
  b8:	684080e7          	jalr	1668(ra) # 738 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2a8080e7          	jalr	680(ra) # 366 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	9ca58593          	addi	a1,a1,-1590 # a90 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	96250513          	addi	a0,a0,-1694 # a30 <csem_up+0x80>
  d6:	00000097          	auipc	ra,0x0
  da:	2c8080e7          	jalr	712(ra) # 39e <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	95a50513          	addi	a0,a0,-1702 # a38 <csem_up+0x88>
  e6:	00000097          	auipc	ra,0x0
  ea:	652080e7          	jalr	1618(ra) # 738 <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	276080e7          	jalr	630(ra) # 366 <exit>

00000000000000f8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fe:	87aa                	mv	a5,a0
 100:	0585                	addi	a1,a1,1
 102:	0785                	addi	a5,a5,1
 104:	fff5c703          	lbu	a4,-1(a1)
 108:	fee78fa3          	sb	a4,-1(a5)
 10c:	fb75                	bnez	a4,100 <strcpy+0x8>
    ;
  return os;
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cb91                	beqz	a5,132 <strcmp+0x1e>
 120:	0005c703          	lbu	a4,0(a1)
 124:	00f71763          	bne	a4,a5,132 <strcmp+0x1e>
    p++, q++;
 128:	0505                	addi	a0,a0,1
 12a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbe5                	bnez	a5,120 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 132:	0005c503          	lbu	a0,0(a1)
}
 136:	40a7853b          	subw	a0,a5,a0
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strlen>:

uint
strlen(const char *s)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cf91                	beqz	a5,166 <strlen+0x26>
 14c:	0505                	addi	a0,a0,1
 14e:	87aa                	mv	a5,a0
 150:	4685                	li	a3,1
 152:	9e89                	subw	a3,a3,a0
 154:	00f6853b          	addw	a0,a3,a5
 158:	0785                	addi	a5,a5,1
 15a:	fff7c703          	lbu	a4,-1(a5)
 15e:	fb7d                	bnez	a4,154 <strlen+0x14>
    ;
  return n;
}
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret
  for(n = 0; s[n]; n++)
 166:	4501                	li	a0,0
 168:	bfe5                	j	160 <strlen+0x20>

000000000000016a <memset>:

void*
memset(void *dst, int c, uint n)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 170:	ca19                	beqz	a2,186 <memset+0x1c>
 172:	87aa                	mv	a5,a0
 174:	1602                	slli	a2,a2,0x20
 176:	9201                	srli	a2,a2,0x20
 178:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 180:	0785                	addi	a5,a5,1
 182:	fee79de3          	bne	a5,a4,17c <memset+0x12>
  }
  return dst;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret

000000000000018c <strchr>:

char*
strchr(const char *s, char c)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	addi	s0,sp,16
  for(; *s; s++)
 192:	00054783          	lbu	a5,0(a0)
 196:	cb99                	beqz	a5,1ac <strchr+0x20>
    if(*s == c)
 198:	00f58763          	beq	a1,a5,1a6 <strchr+0x1a>
  for(; *s; s++)
 19c:	0505                	addi	a0,a0,1
 19e:	00054783          	lbu	a5,0(a0)
 1a2:	fbfd                	bnez	a5,198 <strchr+0xc>
      return (char*)s;
  return 0;
 1a4:	4501                	li	a0,0
}
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret
  return 0;
 1ac:	4501                	li	a0,0
 1ae:	bfe5                	j	1a6 <strchr+0x1a>

00000000000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	711d                	addi	sp,sp,-96
 1b2:	ec86                	sd	ra,88(sp)
 1b4:	e8a2                	sd	s0,80(sp)
 1b6:	e4a6                	sd	s1,72(sp)
 1b8:	e0ca                	sd	s2,64(sp)
 1ba:	fc4e                	sd	s3,56(sp)
 1bc:	f852                	sd	s4,48(sp)
 1be:	f456                	sd	s5,40(sp)
 1c0:	f05a                	sd	s6,32(sp)
 1c2:	ec5e                	sd	s7,24(sp)
 1c4:	1080                	addi	s0,sp,96
 1c6:	8baa                	mv	s7,a0
 1c8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ca:	892a                	mv	s2,a0
 1cc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ce:	4aa9                	li	s5,10
 1d0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d2:	89a6                	mv	s3,s1
 1d4:	2485                	addiw	s1,s1,1
 1d6:	0344d863          	bge	s1,s4,206 <gets+0x56>
    cc = read(0, &c, 1);
 1da:	4605                	li	a2,1
 1dc:	faf40593          	addi	a1,s0,-81
 1e0:	4501                	li	a0,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	19c080e7          	jalr	412(ra) # 37e <read>
    if(cc < 1)
 1ea:	00a05e63          	blez	a0,206 <gets+0x56>
    buf[i++] = c;
 1ee:	faf44783          	lbu	a5,-81(s0)
 1f2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f6:	01578763          	beq	a5,s5,204 <gets+0x54>
 1fa:	0905                	addi	s2,s2,1
 1fc:	fd679be3          	bne	a5,s6,1d2 <gets+0x22>
  for(i=0; i+1 < max; ){
 200:	89a6                	mv	s3,s1
 202:	a011                	j	206 <gets+0x56>
 204:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 206:	99de                	add	s3,s3,s7
 208:	00098023          	sb	zero,0(s3)
  return buf;
}
 20c:	855e                	mv	a0,s7
 20e:	60e6                	ld	ra,88(sp)
 210:	6446                	ld	s0,80(sp)
 212:	64a6                	ld	s1,72(sp)
 214:	6906                	ld	s2,64(sp)
 216:	79e2                	ld	s3,56(sp)
 218:	7a42                	ld	s4,48(sp)
 21a:	7aa2                	ld	s5,40(sp)
 21c:	7b02                	ld	s6,32(sp)
 21e:	6be2                	ld	s7,24(sp)
 220:	6125                	addi	sp,sp,96
 222:	8082                	ret

0000000000000224 <stat>:

int
stat(const char *n, struct stat *st)
{
 224:	1101                	addi	sp,sp,-32
 226:	ec06                	sd	ra,24(sp)
 228:	e822                	sd	s0,16(sp)
 22a:	e426                	sd	s1,8(sp)
 22c:	e04a                	sd	s2,0(sp)
 22e:	1000                	addi	s0,sp,32
 230:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 232:	4581                	li	a1,0
 234:	00000097          	auipc	ra,0x0
 238:	172080e7          	jalr	370(ra) # 3a6 <open>
  if(fd < 0)
 23c:	02054563          	bltz	a0,266 <stat+0x42>
 240:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 242:	85ca                	mv	a1,s2
 244:	00000097          	auipc	ra,0x0
 248:	17a080e7          	jalr	378(ra) # 3be <fstat>
 24c:	892a                	mv	s2,a0
  close(fd);
 24e:	8526                	mv	a0,s1
 250:	00000097          	auipc	ra,0x0
 254:	13e080e7          	jalr	318(ra) # 38e <close>
  return r;
}
 258:	854a                	mv	a0,s2
 25a:	60e2                	ld	ra,24(sp)
 25c:	6442                	ld	s0,16(sp)
 25e:	64a2                	ld	s1,8(sp)
 260:	6902                	ld	s2,0(sp)
 262:	6105                	addi	sp,sp,32
 264:	8082                	ret
    return -1;
 266:	597d                	li	s2,-1
 268:	bfc5                	j	258 <stat+0x34>

000000000000026a <atoi>:

int
atoi(const char *s)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 270:	00054603          	lbu	a2,0(a0)
 274:	fd06079b          	addiw	a5,a2,-48
 278:	0ff7f793          	andi	a5,a5,255
 27c:	4725                	li	a4,9
 27e:	02f76963          	bltu	a4,a5,2b0 <atoi+0x46>
 282:	86aa                	mv	a3,a0
  n = 0;
 284:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 286:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 288:	0685                	addi	a3,a3,1
 28a:	0025179b          	slliw	a5,a0,0x2
 28e:	9fa9                	addw	a5,a5,a0
 290:	0017979b          	slliw	a5,a5,0x1
 294:	9fb1                	addw	a5,a5,a2
 296:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 29a:	0006c603          	lbu	a2,0(a3)
 29e:	fd06071b          	addiw	a4,a2,-48
 2a2:	0ff77713          	andi	a4,a4,255
 2a6:	fee5f1e3          	bgeu	a1,a4,288 <atoi+0x1e>
  return n;
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  n = 0;
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <atoi+0x40>

00000000000002b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ba:	02b57463          	bgeu	a0,a1,2e2 <memmove+0x2e>
    while(n-- > 0)
 2be:	00c05f63          	blez	a2,2dc <memmove+0x28>
 2c2:	1602                	slli	a2,a2,0x20
 2c4:	9201                	srli	a2,a2,0x20
 2c6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 2cc:	0585                	addi	a1,a1,1
 2ce:	0705                	addi	a4,a4,1
 2d0:	fff5c683          	lbu	a3,-1(a1)
 2d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2d8:	fee79ae3          	bne	a5,a4,2cc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
    dst += n;
 2e2:	00c50733          	add	a4,a0,a2
    src += n;
 2e6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2e8:	fec05ae3          	blez	a2,2dc <memmove+0x28>
 2ec:	fff6079b          	addiw	a5,a2,-1
 2f0:	1782                	slli	a5,a5,0x20
 2f2:	9381                	srli	a5,a5,0x20
 2f4:	fff7c793          	not	a5,a5
 2f8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2fa:	15fd                	addi	a1,a1,-1
 2fc:	177d                	addi	a4,a4,-1
 2fe:	0005c683          	lbu	a3,0(a1)
 302:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 306:	fee79ae3          	bne	a5,a4,2fa <memmove+0x46>
 30a:	bfc9                	j	2dc <memmove+0x28>

000000000000030c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 312:	ca05                	beqz	a2,342 <memcmp+0x36>
 314:	fff6069b          	addiw	a3,a2,-1
 318:	1682                	slli	a3,a3,0x20
 31a:	9281                	srli	a3,a3,0x20
 31c:	0685                	addi	a3,a3,1
 31e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 320:	00054783          	lbu	a5,0(a0)
 324:	0005c703          	lbu	a4,0(a1)
 328:	00e79863          	bne	a5,a4,338 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 32c:	0505                	addi	a0,a0,1
    p2++;
 32e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 330:	fed518e3          	bne	a0,a3,320 <memcmp+0x14>
  }
  return 0;
 334:	4501                	li	a0,0
 336:	a019                	j	33c <memcmp+0x30>
      return *p1 - *p2;
 338:	40e7853b          	subw	a0,a5,a4
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
  return 0;
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <memcmp+0x30>

0000000000000346 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e406                	sd	ra,8(sp)
 34a:	e022                	sd	s0,0(sp)
 34c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34e:	00000097          	auipc	ra,0x0
 352:	f66080e7          	jalr	-154(ra) # 2b4 <memmove>
}
 356:	60a2                	ld	ra,8(sp)
 358:	6402                	ld	s0,0(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret

000000000000035e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 35e:	4885                	li	a7,1
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <exit>:
.global exit
exit:
 li a7, SYS_exit
 366:	4889                	li	a7,2
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <wait>:
.global wait
wait:
 li a7, SYS_wait
 36e:	488d                	li	a7,3
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 376:	4891                	li	a7,4
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <read>:
.global read
read:
 li a7, SYS_read
 37e:	4895                	li	a7,5
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <write>:
.global write
write:
 li a7, SYS_write
 386:	48c1                	li	a7,16
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <close>:
.global close
close:
 li a7, SYS_close
 38e:	48d5                	li	a7,21
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <kill>:
.global kill
kill:
 li a7, SYS_kill
 396:	4899                	li	a7,6
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <exec>:
.global exec
exec:
 li a7, SYS_exec
 39e:	489d                	li	a7,7
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <open>:
.global open
open:
 li a7, SYS_open
 3a6:	48bd                	li	a7,15
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ae:	48c5                	li	a7,17
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3b6:	48c9                	li	a7,18
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3be:	48a1                	li	a7,8
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <link>:
.global link
link:
 li a7, SYS_link
 3c6:	48cd                	li	a7,19
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ce:	48d1                	li	a7,20
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d6:	48a5                	li	a7,9
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <dup>:
.global dup
dup:
 li a7, SYS_dup
 3de:	48a9                	li	a7,10
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3e6:	48ad                	li	a7,11
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ee:	48b1                	li	a7,12
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3f6:	48b5                	li	a7,13
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3fe:	48b9                	li	a7,14
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
 406:	48d9                	li	a7,22
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
 40e:	48dd                	li	a7,23
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
 416:	48e1                	li	a7,24
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
 41e:	48e5                	li	a7,25
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
 426:	48e9                	li	a7,26
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
 42e:	48ed                	li	a7,27
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
 436:	48f1                	li	a7,28
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
 43e:	48f5                	li	a7,29
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
 446:	48f9                	li	a7,30
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
 44e:	48fd                	li	a7,31
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
 456:	02000893          	li	a7,32
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 460:	1101                	addi	sp,sp,-32
 462:	ec06                	sd	ra,24(sp)
 464:	e822                	sd	s0,16(sp)
 466:	1000                	addi	s0,sp,32
 468:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46c:	4605                	li	a2,1
 46e:	fef40593          	addi	a1,s0,-17
 472:	00000097          	auipc	ra,0x0
 476:	f14080e7          	jalr	-236(ra) # 386 <write>
}
 47a:	60e2                	ld	ra,24(sp)
 47c:	6442                	ld	s0,16(sp)
 47e:	6105                	addi	sp,sp,32
 480:	8082                	ret

0000000000000482 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 482:	7139                	addi	sp,sp,-64
 484:	fc06                	sd	ra,56(sp)
 486:	f822                	sd	s0,48(sp)
 488:	f426                	sd	s1,40(sp)
 48a:	f04a                	sd	s2,32(sp)
 48c:	ec4e                	sd	s3,24(sp)
 48e:	0080                	addi	s0,sp,64
 490:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 492:	c299                	beqz	a3,498 <printint+0x16>
 494:	0805c863          	bltz	a1,524 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 498:	2581                	sext.w	a1,a1
  neg = 0;
 49a:	4881                	li	a7,0
 49c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a2:	2601                	sext.w	a2,a2
 4a4:	00000517          	auipc	a0,0x0
 4a8:	5d450513          	addi	a0,a0,1492 # a78 <digits>
 4ac:	883a                	mv	a6,a4
 4ae:	2705                	addiw	a4,a4,1
 4b0:	02c5f7bb          	remuw	a5,a1,a2
 4b4:	1782                	slli	a5,a5,0x20
 4b6:	9381                	srli	a5,a5,0x20
 4b8:	97aa                	add	a5,a5,a0
 4ba:	0007c783          	lbu	a5,0(a5)
 4be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c2:	0005879b          	sext.w	a5,a1
 4c6:	02c5d5bb          	divuw	a1,a1,a2
 4ca:	0685                	addi	a3,a3,1
 4cc:	fec7f0e3          	bgeu	a5,a2,4ac <printint+0x2a>
  if(neg)
 4d0:	00088b63          	beqz	a7,4e6 <printint+0x64>
    buf[i++] = '-';
 4d4:	fd040793          	addi	a5,s0,-48
 4d8:	973e                	add	a4,a4,a5
 4da:	02d00793          	li	a5,45
 4de:	fef70823          	sb	a5,-16(a4)
 4e2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4e6:	02e05863          	blez	a4,516 <printint+0x94>
 4ea:	fc040793          	addi	a5,s0,-64
 4ee:	00e78933          	add	s2,a5,a4
 4f2:	fff78993          	addi	s3,a5,-1
 4f6:	99ba                	add	s3,s3,a4
 4f8:	377d                	addiw	a4,a4,-1
 4fa:	1702                	slli	a4,a4,0x20
 4fc:	9301                	srli	a4,a4,0x20
 4fe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 502:	fff94583          	lbu	a1,-1(s2)
 506:	8526                	mv	a0,s1
 508:	00000097          	auipc	ra,0x0
 50c:	f58080e7          	jalr	-168(ra) # 460 <putc>
  while(--i >= 0)
 510:	197d                	addi	s2,s2,-1
 512:	ff3918e3          	bne	s2,s3,502 <printint+0x80>
}
 516:	70e2                	ld	ra,56(sp)
 518:	7442                	ld	s0,48(sp)
 51a:	74a2                	ld	s1,40(sp)
 51c:	7902                	ld	s2,32(sp)
 51e:	69e2                	ld	s3,24(sp)
 520:	6121                	addi	sp,sp,64
 522:	8082                	ret
    x = -xx;
 524:	40b005bb          	negw	a1,a1
    neg = 1;
 528:	4885                	li	a7,1
    x = -xx;
 52a:	bf8d                	j	49c <printint+0x1a>

000000000000052c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52c:	7119                	addi	sp,sp,-128
 52e:	fc86                	sd	ra,120(sp)
 530:	f8a2                	sd	s0,112(sp)
 532:	f4a6                	sd	s1,104(sp)
 534:	f0ca                	sd	s2,96(sp)
 536:	ecce                	sd	s3,88(sp)
 538:	e8d2                	sd	s4,80(sp)
 53a:	e4d6                	sd	s5,72(sp)
 53c:	e0da                	sd	s6,64(sp)
 53e:	fc5e                	sd	s7,56(sp)
 540:	f862                	sd	s8,48(sp)
 542:	f466                	sd	s9,40(sp)
 544:	f06a                	sd	s10,32(sp)
 546:	ec6e                	sd	s11,24(sp)
 548:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 54a:	0005c903          	lbu	s2,0(a1)
 54e:	18090f63          	beqz	s2,6ec <vprintf+0x1c0>
 552:	8aaa                	mv	s5,a0
 554:	8b32                	mv	s6,a2
 556:	00158493          	addi	s1,a1,1
  state = 0;
 55a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 55c:	02500a13          	li	s4,37
      if(c == 'd'){
 560:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 564:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 568:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 56c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 570:	00000b97          	auipc	s7,0x0
 574:	508b8b93          	addi	s7,s7,1288 # a78 <digits>
 578:	a839                	j	596 <vprintf+0x6a>
        putc(fd, c);
 57a:	85ca                	mv	a1,s2
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	ee2080e7          	jalr	-286(ra) # 460 <putc>
 586:	a019                	j	58c <vprintf+0x60>
    } else if(state == '%'){
 588:	01498f63          	beq	s3,s4,5a6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 58c:	0485                	addi	s1,s1,1
 58e:	fff4c903          	lbu	s2,-1(s1)
 592:	14090d63          	beqz	s2,6ec <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 596:	0009079b          	sext.w	a5,s2
    if(state == 0){
 59a:	fe0997e3          	bnez	s3,588 <vprintf+0x5c>
      if(c == '%'){
 59e:	fd479ee3          	bne	a5,s4,57a <vprintf+0x4e>
        state = '%';
 5a2:	89be                	mv	s3,a5
 5a4:	b7e5                	j	58c <vprintf+0x60>
      if(c == 'd'){
 5a6:	05878063          	beq	a5,s8,5e6 <vprintf+0xba>
      } else if(c == 'l') {
 5aa:	05978c63          	beq	a5,s9,602 <vprintf+0xd6>
      } else if(c == 'x') {
 5ae:	07a78863          	beq	a5,s10,61e <vprintf+0xf2>
      } else if(c == 'p') {
 5b2:	09b78463          	beq	a5,s11,63a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5b6:	07300713          	li	a4,115
 5ba:	0ce78663          	beq	a5,a4,686 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5be:	06300713          	li	a4,99
 5c2:	0ee78e63          	beq	a5,a4,6be <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5c6:	11478863          	beq	a5,s4,6d6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ca:	85d2                	mv	a1,s4
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	e92080e7          	jalr	-366(ra) # 460 <putc>
        putc(fd, c);
 5d6:	85ca                	mv	a1,s2
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	e86080e7          	jalr	-378(ra) # 460 <putc>
      }
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b765                	j	58c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5e6:	008b0913          	addi	s2,s6,8
 5ea:	4685                	li	a3,1
 5ec:	4629                	li	a2,10
 5ee:	000b2583          	lw	a1,0(s6)
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e8e080e7          	jalr	-370(ra) # 482 <printint>
 5fc:	8b4a                	mv	s6,s2
      state = 0;
 5fe:	4981                	li	s3,0
 600:	b771                	j	58c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 602:	008b0913          	addi	s2,s6,8
 606:	4681                	li	a3,0
 608:	4629                	li	a2,10
 60a:	000b2583          	lw	a1,0(s6)
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	e72080e7          	jalr	-398(ra) # 482 <printint>
 618:	8b4a                	mv	s6,s2
      state = 0;
 61a:	4981                	li	s3,0
 61c:	bf85                	j	58c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 61e:	008b0913          	addi	s2,s6,8
 622:	4681                	li	a3,0
 624:	4641                	li	a2,16
 626:	000b2583          	lw	a1,0(s6)
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	e56080e7          	jalr	-426(ra) # 482 <printint>
 634:	8b4a                	mv	s6,s2
      state = 0;
 636:	4981                	li	s3,0
 638:	bf91                	j	58c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 63a:	008b0793          	addi	a5,s6,8
 63e:	f8f43423          	sd	a5,-120(s0)
 642:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 646:	03000593          	li	a1,48
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	e14080e7          	jalr	-492(ra) # 460 <putc>
  putc(fd, 'x');
 654:	85ea                	mv	a1,s10
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	e08080e7          	jalr	-504(ra) # 460 <putc>
 660:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 662:	03c9d793          	srli	a5,s3,0x3c
 666:	97de                	add	a5,a5,s7
 668:	0007c583          	lbu	a1,0(a5)
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	df2080e7          	jalr	-526(ra) # 460 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 676:	0992                	slli	s3,s3,0x4
 678:	397d                	addiw	s2,s2,-1
 67a:	fe0914e3          	bnez	s2,662 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 67e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 682:	4981                	li	s3,0
 684:	b721                	j	58c <vprintf+0x60>
        s = va_arg(ap, char*);
 686:	008b0993          	addi	s3,s6,8
 68a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 68e:	02090163          	beqz	s2,6b0 <vprintf+0x184>
        while(*s != 0){
 692:	00094583          	lbu	a1,0(s2)
 696:	c9a1                	beqz	a1,6e6 <vprintf+0x1ba>
          putc(fd, *s);
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	dc6080e7          	jalr	-570(ra) # 460 <putc>
          s++;
 6a2:	0905                	addi	s2,s2,1
        while(*s != 0){
 6a4:	00094583          	lbu	a1,0(s2)
 6a8:	f9e5                	bnez	a1,698 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6aa:	8b4e                	mv	s6,s3
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bdf9                	j	58c <vprintf+0x60>
          s = "(null)";
 6b0:	00000917          	auipc	s2,0x0
 6b4:	3c090913          	addi	s2,s2,960 # a70 <csem_up+0xc0>
        while(*s != 0){
 6b8:	02800593          	li	a1,40
 6bc:	bff1                	j	698 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6be:	008b0913          	addi	s2,s6,8
 6c2:	000b4583          	lbu	a1,0(s6)
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	d98080e7          	jalr	-616(ra) # 460 <putc>
 6d0:	8b4a                	mv	s6,s2
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bd65                	j	58c <vprintf+0x60>
        putc(fd, c);
 6d6:	85d2                	mv	a1,s4
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	d86080e7          	jalr	-634(ra) # 460 <putc>
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b565                	j	58c <vprintf+0x60>
        s = va_arg(ap, char*);
 6e6:	8b4e                	mv	s6,s3
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	b54d                	j	58c <vprintf+0x60>
    }
  }
}
 6ec:	70e6                	ld	ra,120(sp)
 6ee:	7446                	ld	s0,112(sp)
 6f0:	74a6                	ld	s1,104(sp)
 6f2:	7906                	ld	s2,96(sp)
 6f4:	69e6                	ld	s3,88(sp)
 6f6:	6a46                	ld	s4,80(sp)
 6f8:	6aa6                	ld	s5,72(sp)
 6fa:	6b06                	ld	s6,64(sp)
 6fc:	7be2                	ld	s7,56(sp)
 6fe:	7c42                	ld	s8,48(sp)
 700:	7ca2                	ld	s9,40(sp)
 702:	7d02                	ld	s10,32(sp)
 704:	6de2                	ld	s11,24(sp)
 706:	6109                	addi	sp,sp,128
 708:	8082                	ret

000000000000070a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 70a:	715d                	addi	sp,sp,-80
 70c:	ec06                	sd	ra,24(sp)
 70e:	e822                	sd	s0,16(sp)
 710:	1000                	addi	s0,sp,32
 712:	e010                	sd	a2,0(s0)
 714:	e414                	sd	a3,8(s0)
 716:	e818                	sd	a4,16(s0)
 718:	ec1c                	sd	a5,24(s0)
 71a:	03043023          	sd	a6,32(s0)
 71e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 722:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 726:	8622                	mv	a2,s0
 728:	00000097          	auipc	ra,0x0
 72c:	e04080e7          	jalr	-508(ra) # 52c <vprintf>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6161                	addi	sp,sp,80
 736:	8082                	ret

0000000000000738 <printf>:

void
printf(const char *fmt, ...)
{
 738:	711d                	addi	sp,sp,-96
 73a:	ec06                	sd	ra,24(sp)
 73c:	e822                	sd	s0,16(sp)
 73e:	1000                	addi	s0,sp,32
 740:	e40c                	sd	a1,8(s0)
 742:	e810                	sd	a2,16(s0)
 744:	ec14                	sd	a3,24(s0)
 746:	f018                	sd	a4,32(s0)
 748:	f41c                	sd	a5,40(s0)
 74a:	03043823          	sd	a6,48(s0)
 74e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	00840613          	addi	a2,s0,8
 756:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75a:	85aa                	mv	a1,a0
 75c:	4505                	li	a0,1
 75e:	00000097          	auipc	ra,0x0
 762:	dce080e7          	jalr	-562(ra) # 52c <vprintf>
}
 766:	60e2                	ld	ra,24(sp)
 768:	6442                	ld	s0,16(sp)
 76a:	6125                	addi	sp,sp,96
 76c:	8082                	ret

000000000000076e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76e:	1141                	addi	sp,sp,-16
 770:	e422                	sd	s0,8(sp)
 772:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 774:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 778:	00000797          	auipc	a5,0x0
 77c:	3287b783          	ld	a5,808(a5) # aa0 <freep>
 780:	a805                	j	7b0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 782:	4618                	lw	a4,8(a2)
 784:	9db9                	addw	a1,a1,a4
 786:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 78a:	6398                	ld	a4,0(a5)
 78c:	6318                	ld	a4,0(a4)
 78e:	fee53823          	sd	a4,-16(a0)
 792:	a091                	j	7d6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 794:	ff852703          	lw	a4,-8(a0)
 798:	9e39                	addw	a2,a2,a4
 79a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 79c:	ff053703          	ld	a4,-16(a0)
 7a0:	e398                	sd	a4,0(a5)
 7a2:	a099                	j	7e8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a4:	6398                	ld	a4,0(a5)
 7a6:	00e7e463          	bltu	a5,a4,7ae <free+0x40>
 7aa:	00e6ea63          	bltu	a3,a4,7be <free+0x50>
{
 7ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b0:	fed7fae3          	bgeu	a5,a3,7a4 <free+0x36>
 7b4:	6398                	ld	a4,0(a5)
 7b6:	00e6e463          	bltu	a3,a4,7be <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	fee7eae3          	bltu	a5,a4,7ae <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7be:	ff852583          	lw	a1,-8(a0)
 7c2:	6390                	ld	a2,0(a5)
 7c4:	02059813          	slli	a6,a1,0x20
 7c8:	01c85713          	srli	a4,a6,0x1c
 7cc:	9736                	add	a4,a4,a3
 7ce:	fae60ae3          	beq	a2,a4,782 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7d2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7d6:	4790                	lw	a2,8(a5)
 7d8:	02061593          	slli	a1,a2,0x20
 7dc:	01c5d713          	srli	a4,a1,0x1c
 7e0:	973e                	add	a4,a4,a5
 7e2:	fae689e3          	beq	a3,a4,794 <free+0x26>
  } else
    p->s.ptr = bp;
 7e6:	e394                	sd	a3,0(a5)
  freep = p;
 7e8:	00000717          	auipc	a4,0x0
 7ec:	2af73c23          	sd	a5,696(a4) # aa0 <freep>
}
 7f0:	6422                	ld	s0,8(sp)
 7f2:	0141                	addi	sp,sp,16
 7f4:	8082                	ret

00000000000007f6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f6:	7139                	addi	sp,sp,-64
 7f8:	fc06                	sd	ra,56(sp)
 7fa:	f822                	sd	s0,48(sp)
 7fc:	f426                	sd	s1,40(sp)
 7fe:	f04a                	sd	s2,32(sp)
 800:	ec4e                	sd	s3,24(sp)
 802:	e852                	sd	s4,16(sp)
 804:	e456                	sd	s5,8(sp)
 806:	e05a                	sd	s6,0(sp)
 808:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80a:	02051493          	slli	s1,a0,0x20
 80e:	9081                	srli	s1,s1,0x20
 810:	04bd                	addi	s1,s1,15
 812:	8091                	srli	s1,s1,0x4
 814:	0014899b          	addiw	s3,s1,1
 818:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 81a:	00000517          	auipc	a0,0x0
 81e:	28653503          	ld	a0,646(a0) # aa0 <freep>
 822:	c515                	beqz	a0,84e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 824:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 826:	4798                	lw	a4,8(a5)
 828:	02977f63          	bgeu	a4,s1,866 <malloc+0x70>
 82c:	8a4e                	mv	s4,s3
 82e:	0009871b          	sext.w	a4,s3
 832:	6685                	lui	a3,0x1
 834:	00d77363          	bgeu	a4,a3,83a <malloc+0x44>
 838:	6a05                	lui	s4,0x1
 83a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 83e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 842:	00000917          	auipc	s2,0x0
 846:	25e90913          	addi	s2,s2,606 # aa0 <freep>
  if(p == (char*)-1)
 84a:	5afd                	li	s5,-1
 84c:	a895                	j	8c0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 84e:	00000797          	auipc	a5,0x0
 852:	25a78793          	addi	a5,a5,602 # aa8 <base>
 856:	00000717          	auipc	a4,0x0
 85a:	24f73523          	sd	a5,586(a4) # aa0 <freep>
 85e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 860:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 864:	b7e1                	j	82c <malloc+0x36>
      if(p->s.size == nunits)
 866:	02e48c63          	beq	s1,a4,89e <malloc+0xa8>
        p->s.size -= nunits;
 86a:	4137073b          	subw	a4,a4,s3
 86e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 870:	02071693          	slli	a3,a4,0x20
 874:	01c6d713          	srli	a4,a3,0x1c
 878:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 87a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 87e:	00000717          	auipc	a4,0x0
 882:	22a73123          	sd	a0,546(a4) # aa0 <freep>
      return (void*)(p + 1);
 886:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 88a:	70e2                	ld	ra,56(sp)
 88c:	7442                	ld	s0,48(sp)
 88e:	74a2                	ld	s1,40(sp)
 890:	7902                	ld	s2,32(sp)
 892:	69e2                	ld	s3,24(sp)
 894:	6a42                	ld	s4,16(sp)
 896:	6aa2                	ld	s5,8(sp)
 898:	6b02                	ld	s6,0(sp)
 89a:	6121                	addi	sp,sp,64
 89c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 89e:	6398                	ld	a4,0(a5)
 8a0:	e118                	sd	a4,0(a0)
 8a2:	bff1                	j	87e <malloc+0x88>
  hp->s.size = nu;
 8a4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a8:	0541                	addi	a0,a0,16
 8aa:	00000097          	auipc	ra,0x0
 8ae:	ec4080e7          	jalr	-316(ra) # 76e <free>
  return freep;
 8b2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8b6:	d971                	beqz	a0,88a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ba:	4798                	lw	a4,8(a5)
 8bc:	fa9775e3          	bgeu	a4,s1,866 <malloc+0x70>
    if(p == freep)
 8c0:	00093703          	ld	a4,0(s2)
 8c4:	853e                	mv	a0,a5
 8c6:	fef719e3          	bne	a4,a5,8b8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8ca:	8552                	mv	a0,s4
 8cc:	00000097          	auipc	ra,0x0
 8d0:	b22080e7          	jalr	-1246(ra) # 3ee <sbrk>
  if(p == (char*)-1)
 8d4:	fd5518e3          	bne	a0,s5,8a4 <malloc+0xae>
        return 0;
 8d8:	4501                	li	a0,0
 8da:	bf45                	j	88a <malloc+0x94>

00000000000008dc <csem_alloc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int csem_alloc(struct counting_semaphore *sem, int initial_value){
 8dc:	1101                	addi	sp,sp,-32
 8de:	ec06                	sd	ra,24(sp)
 8e0:	e822                	sd	s0,16(sp)
 8e2:	e426                	sd	s1,8(sp)
 8e4:	e04a                	sd	s2,0(sp)
 8e6:	1000                	addi	s0,sp,32
 8e8:	84aa                	mv	s1,a0
 8ea:	892e                	mv	s2,a1
    sem->binary_semaphore1 = bsem_alloc();
 8ec:	00000097          	auipc	ra,0x0
 8f0:	b52080e7          	jalr	-1198(ra) # 43e <bsem_alloc>
 8f4:	c088                	sw	a0,0(s1)
    sem->binary_semaphore2 = bsem_alloc();
 8f6:	00000097          	auipc	ra,0x0
 8fa:	b48080e7          	jalr	-1208(ra) # 43e <bsem_alloc>
 8fe:	87aa                	mv	a5,a0
 900:	c0c8                	sw	a0,4(s1)
    if(sem->binary_semaphore1 == -1 || sem->binary_semaphore2 == -1)
 902:	4088                	lw	a0,0(s1)
 904:	577d                	li	a4,-1
 906:	00e50963          	beq	a0,a4,918 <csem_alloc+0x3c>
 90a:	02e78363          	beq	a5,a4,930 <csem_alloc+0x54>
        return -1;
    if(initial_value == 0)
 90e:	00090b63          	beqz	s2,924 <csem_alloc+0x48>
        bsem_down(sem->binary_semaphore2);
    sem->value = initial_value;
 912:	0124a423          	sw	s2,8(s1)
    return 0;
 916:	4501                	li	a0,0
}
 918:	60e2                	ld	ra,24(sp)
 91a:	6442                	ld	s0,16(sp)
 91c:	64a2                	ld	s1,8(sp)
 91e:	6902                	ld	s2,0(sp)
 920:	6105                	addi	sp,sp,32
 922:	8082                	ret
        bsem_down(sem->binary_semaphore2);
 924:	853e                	mv	a0,a5
 926:	00000097          	auipc	ra,0x0
 92a:	b28080e7          	jalr	-1240(ra) # 44e <bsem_down>
 92e:	b7d5                	j	912 <csem_alloc+0x36>
        return -1;
 930:	853e                	mv	a0,a5
 932:	b7dd                	j	918 <csem_alloc+0x3c>

0000000000000934 <csem_free>:

void csem_free(struct counting_semaphore *sem){
 934:	1101                	addi	sp,sp,-32
 936:	ec06                	sd	ra,24(sp)
 938:	e822                	sd	s0,16(sp)
 93a:	e426                	sd	s1,8(sp)
 93c:	1000                	addi	s0,sp,32
 93e:	84aa                	mv	s1,a0
    bsem_free(sem->binary_semaphore1);
 940:	4108                	lw	a0,0(a0)
 942:	00000097          	auipc	ra,0x0
 946:	b04080e7          	jalr	-1276(ra) # 446 <bsem_free>
    bsem_free(sem->binary_semaphore2);
 94a:	40c8                	lw	a0,4(s1)
 94c:	00000097          	auipc	ra,0x0
 950:	afa080e7          	jalr	-1286(ra) # 446 <bsem_free>
    sem->value = 0;
 954:	0004a423          	sw	zero,8(s1)
}
 958:	60e2                	ld	ra,24(sp)
 95a:	6442                	ld	s0,16(sp)
 95c:	64a2                	ld	s1,8(sp)
 95e:	6105                	addi	sp,sp,32
 960:	8082                	ret

0000000000000962 <csem_down>:

void csem_down(struct counting_semaphore *sem){
 962:	1101                	addi	sp,sp,-32
 964:	ec06                	sd	ra,24(sp)
 966:	e822                	sd	s0,16(sp)
 968:	e426                	sd	s1,8(sp)
 96a:	1000                	addi	s0,sp,32
 96c:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore2);
 96e:	4148                	lw	a0,4(a0)
 970:	00000097          	auipc	ra,0x0
 974:	ade080e7          	jalr	-1314(ra) # 44e <bsem_down>
    bsem_down(sem->binary_semaphore1);
 978:	4088                	lw	a0,0(s1)
 97a:	00000097          	auipc	ra,0x0
 97e:	ad4080e7          	jalr	-1324(ra) # 44e <bsem_down>
    sem->value--;
 982:	449c                	lw	a5,8(s1)
 984:	37fd                	addiw	a5,a5,-1
 986:	0007871b          	sext.w	a4,a5
 98a:	c49c                	sw	a5,8(s1)
    if(sem->value > 0)
 98c:	00e04c63          	bgtz	a4,9a4 <csem_down+0x42>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
 990:	4088                	lw	a0,0(s1)
 992:	00000097          	auipc	ra,0x0
 996:	ac4080e7          	jalr	-1340(ra) # 456 <bsem_up>
}
 99a:	60e2                	ld	ra,24(sp)
 99c:	6442                	ld	s0,16(sp)
 99e:	64a2                	ld	s1,8(sp)
 9a0:	6105                	addi	sp,sp,32
 9a2:	8082                	ret
        bsem_up(sem->binary_semaphore2);
 9a4:	40c8                	lw	a0,4(s1)
 9a6:	00000097          	auipc	ra,0x0
 9aa:	ab0080e7          	jalr	-1360(ra) # 456 <bsem_up>
 9ae:	b7cd                	j	990 <csem_down+0x2e>

00000000000009b0 <csem_up>:

void csem_up(struct counting_semaphore *sem){
 9b0:	1101                	addi	sp,sp,-32
 9b2:	ec06                	sd	ra,24(sp)
 9b4:	e822                	sd	s0,16(sp)
 9b6:	e426                	sd	s1,8(sp)
 9b8:	1000                	addi	s0,sp,32
 9ba:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore1);
 9bc:	4108                	lw	a0,0(a0)
 9be:	00000097          	auipc	ra,0x0
 9c2:	a90080e7          	jalr	-1392(ra) # 44e <bsem_down>
    sem->value++;
 9c6:	449c                	lw	a5,8(s1)
 9c8:	2785                	addiw	a5,a5,1
 9ca:	0007871b          	sext.w	a4,a5
 9ce:	c49c                	sw	a5,8(s1)
    if(sem->value == 1)
 9d0:	4785                	li	a5,1
 9d2:	00f70c63          	beq	a4,a5,9ea <csem_up+0x3a>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
 9d6:	4088                	lw	a0,0(s1)
 9d8:	00000097          	auipc	ra,0x0
 9dc:	a7e080e7          	jalr	-1410(ra) # 456 <bsem_up>
 9e0:	60e2                	ld	ra,24(sp)
 9e2:	6442                	ld	s0,16(sp)
 9e4:	64a2                	ld	s1,8(sp)
 9e6:	6105                	addi	sp,sp,32
 9e8:	8082                	ret
        bsem_up(sem->binary_semaphore2);
 9ea:	40c8                	lw	a0,4(s1)
 9ec:	00000097          	auipc	ra,0x0
 9f0:	a6a080e7          	jalr	-1430(ra) # 456 <bsem_up>
 9f4:	b7cd                	j	9d6 <csem_up+0x26>
