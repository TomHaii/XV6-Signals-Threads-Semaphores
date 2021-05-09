
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	6dc080e7          	jalr	1756(ra) # 56ec <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	6ca080e7          	jalr	1738(ra) # 56ec <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	03250513          	addi	a0,a0,50 # 6070 <csem_up+0x37a>
      46:	00006097          	auipc	ra,0x6
      4a:	a38080e7          	jalr	-1480(ra) # 5a7e <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	65c080e7          	jalr	1628(ra) # 56ac <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	58878793          	addi	a5,a5,1416 # 95e0 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	c9068693          	addi	a3,a3,-880 # bcf0 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	01050513          	addi	a0,a0,16 # 6090 <csem_up+0x39a>
      88:	00006097          	auipc	ra,0x6
      8c:	9f6080e7          	jalr	-1546(ra) # 5a7e <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	61a080e7          	jalr	1562(ra) # 56ac <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	00050513          	mv	a0,a0
      b0:	00005097          	auipc	ra,0x5
      b4:	63c080e7          	jalr	1596(ra) # 56ec <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	618080e7          	jalr	1560(ra) # 56d4 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	00250513          	addi	a0,a0,2 # 60c8 <csem_up+0x3d2>
      ce:	00005097          	auipc	ra,0x5
      d2:	61e080e7          	jalr	1566(ra) # 56ec <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	fca50513          	addi	a0,a0,-54 # 60b0 <csem_up+0x3ba>
      ee:	00006097          	auipc	ra,0x6
      f2:	990080e7          	jalr	-1648(ra) # 5a7e <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	5b4080e7          	jalr	1460(ra) # 56ac <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	fd650513          	addi	a0,a0,-42 # 60d8 <csem_up+0x3e2>
     10a:	00006097          	auipc	ra,0x6
     10e:	974080e7          	jalr	-1676(ra) # 5a7e <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	598080e7          	jalr	1432(ra) # 56ac <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	fd450513          	addi	a0,a0,-44 # 6100 <csem_up+0x40a>
     134:	00005097          	auipc	ra,0x5
     138:	5c8080e7          	jalr	1480(ra) # 56fc <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	fc050513          	addi	a0,a0,-64 # 6100 <csem_up+0x40a>
     148:	00005097          	auipc	ra,0x5
     14c:	5a4080e7          	jalr	1444(ra) # 56ec <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	fbc58593          	addi	a1,a1,-68 # 6110 <csem_up+0x41a>
     15c:	00005097          	auipc	ra,0x5
     160:	570080e7          	jalr	1392(ra) # 56cc <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	f9850513          	addi	a0,a0,-104 # 6100 <csem_up+0x40a>
     170:	00005097          	auipc	ra,0x5
     174:	57c080e7          	jalr	1404(ra) # 56ec <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	f9c58593          	addi	a1,a1,-100 # 6118 <csem_up+0x422>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	546080e7          	jalr	1350(ra) # 56cc <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	f6c50513          	addi	a0,a0,-148 # 6100 <csem_up+0x40a>
     19c:	00005097          	auipc	ra,0x5
     1a0:	560080e7          	jalr	1376(ra) # 56fc <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	52e080e7          	jalr	1326(ra) # 56d4 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	524080e7          	jalr	1316(ra) # 56d4 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	f5650513          	addi	a0,a0,-170 # 6120 <csem_up+0x42a>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	8ac080e7          	jalr	-1876(ra) # 5a7e <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	4d0080e7          	jalr	1232(ra) # 56ac <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00005097          	auipc	ra,0x5
     214:	4dc080e7          	jalr	1244(ra) # 56ec <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	4bc080e7          	jalr	1212(ra) # 56d4 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	andi	s1,s1,255
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00005097          	auipc	ra,0x5
     24a:	4b6080e7          	jalr	1206(ra) # 56fc <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	andi	s1,s1,255
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	c9450513          	addi	a0,a0,-876 # 5f10 <csem_up+0x21a>
     284:	00005097          	auipc	ra,0x5
     288:	478080e7          	jalr	1144(ra) # 56fc <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	c80a8a93          	addi	s5,s5,-896 # 5f10 <csem_up+0x21a>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	a58a0a13          	addi	s4,s4,-1448 # bcf0 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x173>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	440080e7          	jalr	1088(ra) # 56ec <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	40e080e7          	jalr	1038(ra) # 56cc <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	3fa080e7          	jalr	1018(ra) # 56cc <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	3f4080e7          	jalr	1012(ra) # 56d4 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	412080e7          	jalr	1042(ra) # 56fc <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	e3650513          	addi	a0,a0,-458 # 6148 <csem_up+0x452>
     31a:	00005097          	auipc	ra,0x5
     31e:	764080e7          	jalr	1892(ra) # 5a7e <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	388080e7          	jalr	904(ra) # 56ac <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	e3250513          	addi	a0,a0,-462 # 6168 <csem_up+0x472>
     33e:	00005097          	auipc	ra,0x5
     342:	740080e7          	jalr	1856(ra) # 5a7e <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00005097          	auipc	ra,0x5
     34c:	364080e7          	jalr	868(ra) # 56ac <exit>

0000000000000350 <copyin>:
{
     350:	715d                	addi	sp,sp,-80
     352:	e486                	sd	ra,72(sp)
     354:	e0a2                	sd	s0,64(sp)
     356:	fc26                	sd	s1,56(sp)
     358:	f84a                	sd	s2,48(sp)
     35a:	f44e                	sd	s3,40(sp)
     35c:	f052                	sd	s4,32(sp)
     35e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     360:	4785                	li	a5,1
     362:	07fe                	slli	a5,a5,0x1f
     364:	fcf43023          	sd	a5,-64(s0)
     368:	57fd                	li	a5,-1
     36a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     36e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     372:	00006a17          	auipc	s4,0x6
     376:	e0ea0a13          	addi	s4,s4,-498 # 6180 <csem_up+0x48a>
    uint64 addr = addrs[ai];
     37a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37e:	20100593          	li	a1,513
     382:	8552                	mv	a0,s4
     384:	00005097          	auipc	ra,0x5
     388:	368080e7          	jalr	872(ra) # 56ec <open>
     38c:	84aa                	mv	s1,a0
    if(fd < 0){
     38e:	08054863          	bltz	a0,41e <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     392:	6609                	lui	a2,0x2
     394:	85ce                	mv	a1,s3
     396:	00005097          	auipc	ra,0x5
     39a:	336080e7          	jalr	822(ra) # 56cc <write>
    if(n >= 0){
     39e:	08055d63          	bgez	a0,438 <copyin+0xe8>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00005097          	auipc	ra,0x5
     3a8:	330080e7          	jalr	816(ra) # 56d4 <close>
    unlink("copyin1");
     3ac:	8552                	mv	a0,s4
     3ae:	00005097          	auipc	ra,0x5
     3b2:	34e080e7          	jalr	846(ra) # 56fc <unlink>
    n = write(1, (char*)addr, 8192);
     3b6:	6609                	lui	a2,0x2
     3b8:	85ce                	mv	a1,s3
     3ba:	4505                	li	a0,1
     3bc:	00005097          	auipc	ra,0x5
     3c0:	310080e7          	jalr	784(ra) # 56cc <write>
    if(n > 0){
     3c4:	08a04963          	bgtz	a0,456 <copyin+0x106>
    if(pipe(fds) < 0){
     3c8:	fb840513          	addi	a0,s0,-72
     3cc:	00005097          	auipc	ra,0x5
     3d0:	2f0080e7          	jalr	752(ra) # 56bc <pipe>
     3d4:	0a054063          	bltz	a0,474 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d8:	6609                	lui	a2,0x2
     3da:	85ce                	mv	a1,s3
     3dc:	fbc42503          	lw	a0,-68(s0)
     3e0:	00005097          	auipc	ra,0x5
     3e4:	2ec080e7          	jalr	748(ra) # 56cc <write>
    if(n > 0){
     3e8:	0aa04363          	bgtz	a0,48e <copyin+0x13e>
    close(fds[0]);
     3ec:	fb842503          	lw	a0,-72(s0)
     3f0:	00005097          	auipc	ra,0x5
     3f4:	2e4080e7          	jalr	740(ra) # 56d4 <close>
    close(fds[1]);
     3f8:	fbc42503          	lw	a0,-68(s0)
     3fc:	00005097          	auipc	ra,0x5
     400:	2d8080e7          	jalr	728(ra) # 56d4 <close>
  for(int ai = 0; ai < 2; ai++){
     404:	0921                	addi	s2,s2,8
     406:	fd040793          	addi	a5,s0,-48
     40a:	f6f918e3          	bne	s2,a5,37a <copyin+0x2a>
}
     40e:	60a6                	ld	ra,72(sp)
     410:	6406                	ld	s0,64(sp)
     412:	74e2                	ld	s1,56(sp)
     414:	7942                	ld	s2,48(sp)
     416:	79a2                	ld	s3,40(sp)
     418:	7a02                	ld	s4,32(sp)
     41a:	6161                	addi	sp,sp,80
     41c:	8082                	ret
      printf("open(copyin1) failed\n");
     41e:	00006517          	auipc	a0,0x6
     422:	d6a50513          	addi	a0,a0,-662 # 6188 <csem_up+0x492>
     426:	00005097          	auipc	ra,0x5
     42a:	658080e7          	jalr	1624(ra) # 5a7e <printf>
      exit(1);
     42e:	4505                	li	a0,1
     430:	00005097          	auipc	ra,0x5
     434:	27c080e7          	jalr	636(ra) # 56ac <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     438:	862a                	mv	a2,a0
     43a:	85ce                	mv	a1,s3
     43c:	00006517          	auipc	a0,0x6
     440:	d6450513          	addi	a0,a0,-668 # 61a0 <csem_up+0x4aa>
     444:	00005097          	auipc	ra,0x5
     448:	63a080e7          	jalr	1594(ra) # 5a7e <printf>
      exit(1);
     44c:	4505                	li	a0,1
     44e:	00005097          	auipc	ra,0x5
     452:	25e080e7          	jalr	606(ra) # 56ac <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     456:	862a                	mv	a2,a0
     458:	85ce                	mv	a1,s3
     45a:	00006517          	auipc	a0,0x6
     45e:	d7650513          	addi	a0,a0,-650 # 61d0 <csem_up+0x4da>
     462:	00005097          	auipc	ra,0x5
     466:	61c080e7          	jalr	1564(ra) # 5a7e <printf>
      exit(1);
     46a:	4505                	li	a0,1
     46c:	00005097          	auipc	ra,0x5
     470:	240080e7          	jalr	576(ra) # 56ac <exit>
      printf("pipe() failed\n");
     474:	00006517          	auipc	a0,0x6
     478:	d8c50513          	addi	a0,a0,-628 # 6200 <csem_up+0x50a>
     47c:	00005097          	auipc	ra,0x5
     480:	602080e7          	jalr	1538(ra) # 5a7e <printf>
      exit(1);
     484:	4505                	li	a0,1
     486:	00005097          	auipc	ra,0x5
     48a:	226080e7          	jalr	550(ra) # 56ac <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48e:	862a                	mv	a2,a0
     490:	85ce                	mv	a1,s3
     492:	00006517          	auipc	a0,0x6
     496:	d7e50513          	addi	a0,a0,-642 # 6210 <csem_up+0x51a>
     49a:	00005097          	auipc	ra,0x5
     49e:	5e4080e7          	jalr	1508(ra) # 5a7e <printf>
      exit(1);
     4a2:	4505                	li	a0,1
     4a4:	00005097          	auipc	ra,0x5
     4a8:	208080e7          	jalr	520(ra) # 56ac <exit>

00000000000004ac <copyout>:
{
     4ac:	711d                	addi	sp,sp,-96
     4ae:	ec86                	sd	ra,88(sp)
     4b0:	e8a2                	sd	s0,80(sp)
     4b2:	e4a6                	sd	s1,72(sp)
     4b4:	e0ca                	sd	s2,64(sp)
     4b6:	fc4e                	sd	s3,56(sp)
     4b8:	f852                	sd	s4,48(sp)
     4ba:	f456                	sd	s5,40(sp)
     4bc:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4be:	4785                	li	a5,1
     4c0:	07fe                	slli	a5,a5,0x1f
     4c2:	faf43823          	sd	a5,-80(s0)
     4c6:	57fd                	li	a5,-1
     4c8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4cc:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4d0:	00006a17          	auipc	s4,0x6
     4d4:	d70a0a13          	addi	s4,s4,-656 # 6240 <csem_up+0x54a>
    n = write(fds[1], "x", 1);
     4d8:	00006a97          	auipc	s5,0x6
     4dc:	c40a8a93          	addi	s5,s5,-960 # 6118 <csem_up+0x422>
    uint64 addr = addrs[ai];
     4e0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e4:	4581                	li	a1,0
     4e6:	8552                	mv	a0,s4
     4e8:	00005097          	auipc	ra,0x5
     4ec:	204080e7          	jalr	516(ra) # 56ec <open>
     4f0:	84aa                	mv	s1,a0
    if(fd < 0){
     4f2:	08054663          	bltz	a0,57e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f6:	6609                	lui	a2,0x2
     4f8:	85ce                	mv	a1,s3
     4fa:	00005097          	auipc	ra,0x5
     4fe:	1ca080e7          	jalr	458(ra) # 56c4 <read>
    if(n > 0){
     502:	08a04b63          	bgtz	a0,598 <copyout+0xec>
    close(fd);
     506:	8526                	mv	a0,s1
     508:	00005097          	auipc	ra,0x5
     50c:	1cc080e7          	jalr	460(ra) # 56d4 <close>
    if(pipe(fds) < 0){
     510:	fa840513          	addi	a0,s0,-88
     514:	00005097          	auipc	ra,0x5
     518:	1a8080e7          	jalr	424(ra) # 56bc <pipe>
     51c:	08054d63          	bltz	a0,5b6 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     520:	4605                	li	a2,1
     522:	85d6                	mv	a1,s5
     524:	fac42503          	lw	a0,-84(s0)
     528:	00005097          	auipc	ra,0x5
     52c:	1a4080e7          	jalr	420(ra) # 56cc <write>
    if(n != 1){
     530:	4785                	li	a5,1
     532:	08f51f63          	bne	a0,a5,5d0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     536:	6609                	lui	a2,0x2
     538:	85ce                	mv	a1,s3
     53a:	fa842503          	lw	a0,-88(s0)
     53e:	00005097          	auipc	ra,0x5
     542:	186080e7          	jalr	390(ra) # 56c4 <read>
    if(n > 0){
     546:	0aa04263          	bgtz	a0,5ea <copyout+0x13e>
    close(fds[0]);
     54a:	fa842503          	lw	a0,-88(s0)
     54e:	00005097          	auipc	ra,0x5
     552:	186080e7          	jalr	390(ra) # 56d4 <close>
    close(fds[1]);
     556:	fac42503          	lw	a0,-84(s0)
     55a:	00005097          	auipc	ra,0x5
     55e:	17a080e7          	jalr	378(ra) # 56d4 <close>
  for(int ai = 0; ai < 2; ai++){
     562:	0921                	addi	s2,s2,8
     564:	fc040793          	addi	a5,s0,-64
     568:	f6f91ce3          	bne	s2,a5,4e0 <copyout+0x34>
}
     56c:	60e6                	ld	ra,88(sp)
     56e:	6446                	ld	s0,80(sp)
     570:	64a6                	ld	s1,72(sp)
     572:	6906                	ld	s2,64(sp)
     574:	79e2                	ld	s3,56(sp)
     576:	7a42                	ld	s4,48(sp)
     578:	7aa2                	ld	s5,40(sp)
     57a:	6125                	addi	sp,sp,96
     57c:	8082                	ret
      printf("open(README) failed\n");
     57e:	00006517          	auipc	a0,0x6
     582:	cca50513          	addi	a0,a0,-822 # 6248 <csem_up+0x552>
     586:	00005097          	auipc	ra,0x5
     58a:	4f8080e7          	jalr	1272(ra) # 5a7e <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	00005097          	auipc	ra,0x5
     594:	11c080e7          	jalr	284(ra) # 56ac <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     598:	862a                	mv	a2,a0
     59a:	85ce                	mv	a1,s3
     59c:	00006517          	auipc	a0,0x6
     5a0:	cc450513          	addi	a0,a0,-828 # 6260 <csem_up+0x56a>
     5a4:	00005097          	auipc	ra,0x5
     5a8:	4da080e7          	jalr	1242(ra) # 5a7e <printf>
      exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00005097          	auipc	ra,0x5
     5b2:	0fe080e7          	jalr	254(ra) # 56ac <exit>
      printf("pipe() failed\n");
     5b6:	00006517          	auipc	a0,0x6
     5ba:	c4a50513          	addi	a0,a0,-950 # 6200 <csem_up+0x50a>
     5be:	00005097          	auipc	ra,0x5
     5c2:	4c0080e7          	jalr	1216(ra) # 5a7e <printf>
      exit(1);
     5c6:	4505                	li	a0,1
     5c8:	00005097          	auipc	ra,0x5
     5cc:	0e4080e7          	jalr	228(ra) # 56ac <exit>
      printf("pipe write failed\n");
     5d0:	00006517          	auipc	a0,0x6
     5d4:	cc050513          	addi	a0,a0,-832 # 6290 <csem_up+0x59a>
     5d8:	00005097          	auipc	ra,0x5
     5dc:	4a6080e7          	jalr	1190(ra) # 5a7e <printf>
      exit(1);
     5e0:	4505                	li	a0,1
     5e2:	00005097          	auipc	ra,0x5
     5e6:	0ca080e7          	jalr	202(ra) # 56ac <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ea:	862a                	mv	a2,a0
     5ec:	85ce                	mv	a1,s3
     5ee:	00006517          	auipc	a0,0x6
     5f2:	cba50513          	addi	a0,a0,-838 # 62a8 <csem_up+0x5b2>
     5f6:	00005097          	auipc	ra,0x5
     5fa:	488080e7          	jalr	1160(ra) # 5a7e <printf>
      exit(1);
     5fe:	4505                	li	a0,1
     600:	00005097          	auipc	ra,0x5
     604:	0ac080e7          	jalr	172(ra) # 56ac <exit>

0000000000000608 <truncate1>:
{
     608:	711d                	addi	sp,sp,-96
     60a:	ec86                	sd	ra,88(sp)
     60c:	e8a2                	sd	s0,80(sp)
     60e:	e4a6                	sd	s1,72(sp)
     610:	e0ca                	sd	s2,64(sp)
     612:	fc4e                	sd	s3,56(sp)
     614:	f852                	sd	s4,48(sp)
     616:	f456                	sd	s5,40(sp)
     618:	1080                	addi	s0,sp,96
     61a:	8aaa                	mv	s5,a0
  unlink("truncfile");
     61c:	00006517          	auipc	a0,0x6
     620:	ae450513          	addi	a0,a0,-1308 # 6100 <csem_up+0x40a>
     624:	00005097          	auipc	ra,0x5
     628:	0d8080e7          	jalr	216(ra) # 56fc <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62c:	60100593          	li	a1,1537
     630:	00006517          	auipc	a0,0x6
     634:	ad050513          	addi	a0,a0,-1328 # 6100 <csem_up+0x40a>
     638:	00005097          	auipc	ra,0x5
     63c:	0b4080e7          	jalr	180(ra) # 56ec <open>
     640:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     642:	4611                	li	a2,4
     644:	00006597          	auipc	a1,0x6
     648:	acc58593          	addi	a1,a1,-1332 # 6110 <csem_up+0x41a>
     64c:	00005097          	auipc	ra,0x5
     650:	080080e7          	jalr	128(ra) # 56cc <write>
  close(fd1);
     654:	8526                	mv	a0,s1
     656:	00005097          	auipc	ra,0x5
     65a:	07e080e7          	jalr	126(ra) # 56d4 <close>
  int fd2 = open("truncfile", O_RDONLY);
     65e:	4581                	li	a1,0
     660:	00006517          	auipc	a0,0x6
     664:	aa050513          	addi	a0,a0,-1376 # 6100 <csem_up+0x40a>
     668:	00005097          	auipc	ra,0x5
     66c:	084080e7          	jalr	132(ra) # 56ec <open>
     670:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     672:	02000613          	li	a2,32
     676:	fa040593          	addi	a1,s0,-96
     67a:	00005097          	auipc	ra,0x5
     67e:	04a080e7          	jalr	74(ra) # 56c4 <read>
  if(n != 4){
     682:	4791                	li	a5,4
     684:	0cf51e63          	bne	a0,a5,760 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     688:	40100593          	li	a1,1025
     68c:	00006517          	auipc	a0,0x6
     690:	a7450513          	addi	a0,a0,-1420 # 6100 <csem_up+0x40a>
     694:	00005097          	auipc	ra,0x5
     698:	058080e7          	jalr	88(ra) # 56ec <open>
     69c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69e:	4581                	li	a1,0
     6a0:	00006517          	auipc	a0,0x6
     6a4:	a6050513          	addi	a0,a0,-1440 # 6100 <csem_up+0x40a>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	044080e7          	jalr	68(ra) # 56ec <open>
     6b0:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b2:	02000613          	li	a2,32
     6b6:	fa040593          	addi	a1,s0,-96
     6ba:	00005097          	auipc	ra,0x5
     6be:	00a080e7          	jalr	10(ra) # 56c4 <read>
     6c2:	8a2a                	mv	s4,a0
  if(n != 0){
     6c4:	ed4d                	bnez	a0,77e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	8526                	mv	a0,s1
     6d0:	00005097          	auipc	ra,0x5
     6d4:	ff4080e7          	jalr	-12(ra) # 56c4 <read>
     6d8:	8a2a                	mv	s4,a0
  if(n != 0){
     6da:	e971                	bnez	a0,7ae <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6dc:	4619                	li	a2,6
     6de:	00006597          	auipc	a1,0x6
     6e2:	c5a58593          	addi	a1,a1,-934 # 6338 <csem_up+0x642>
     6e6:	854e                	mv	a0,s3
     6e8:	00005097          	auipc	ra,0x5
     6ec:	fe4080e7          	jalr	-28(ra) # 56cc <write>
  n = read(fd3, buf, sizeof(buf));
     6f0:	02000613          	li	a2,32
     6f4:	fa040593          	addi	a1,s0,-96
     6f8:	854a                	mv	a0,s2
     6fa:	00005097          	auipc	ra,0x5
     6fe:	fca080e7          	jalr	-54(ra) # 56c4 <read>
  if(n != 6){
     702:	4799                	li	a5,6
     704:	0cf51d63          	bne	a0,a5,7de <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     708:	02000613          	li	a2,32
     70c:	fa040593          	addi	a1,s0,-96
     710:	8526                	mv	a0,s1
     712:	00005097          	auipc	ra,0x5
     716:	fb2080e7          	jalr	-78(ra) # 56c4 <read>
  if(n != 2){
     71a:	4789                	li	a5,2
     71c:	0ef51063          	bne	a0,a5,7fc <truncate1+0x1f4>
  unlink("truncfile");
     720:	00006517          	auipc	a0,0x6
     724:	9e050513          	addi	a0,a0,-1568 # 6100 <csem_up+0x40a>
     728:	00005097          	auipc	ra,0x5
     72c:	fd4080e7          	jalr	-44(ra) # 56fc <unlink>
  close(fd1);
     730:	854e                	mv	a0,s3
     732:	00005097          	auipc	ra,0x5
     736:	fa2080e7          	jalr	-94(ra) # 56d4 <close>
  close(fd2);
     73a:	8526                	mv	a0,s1
     73c:	00005097          	auipc	ra,0x5
     740:	f98080e7          	jalr	-104(ra) # 56d4 <close>
  close(fd3);
     744:	854a                	mv	a0,s2
     746:	00005097          	auipc	ra,0x5
     74a:	f8e080e7          	jalr	-114(ra) # 56d4 <close>
}
     74e:	60e6                	ld	ra,88(sp)
     750:	6446                	ld	s0,80(sp)
     752:	64a6                	ld	s1,72(sp)
     754:	6906                	ld	s2,64(sp)
     756:	79e2                	ld	s3,56(sp)
     758:	7a42                	ld	s4,48(sp)
     75a:	7aa2                	ld	s5,40(sp)
     75c:	6125                	addi	sp,sp,96
     75e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     760:	862a                	mv	a2,a0
     762:	85d6                	mv	a1,s5
     764:	00006517          	auipc	a0,0x6
     768:	b7450513          	addi	a0,a0,-1164 # 62d8 <csem_up+0x5e2>
     76c:	00005097          	auipc	ra,0x5
     770:	312080e7          	jalr	786(ra) # 5a7e <printf>
    exit(1);
     774:	4505                	li	a0,1
     776:	00005097          	auipc	ra,0x5
     77a:	f36080e7          	jalr	-202(ra) # 56ac <exit>
    printf("aaa fd3=%d\n", fd3);
     77e:	85ca                	mv	a1,s2
     780:	00006517          	auipc	a0,0x6
     784:	b7850513          	addi	a0,a0,-1160 # 62f8 <csem_up+0x602>
     788:	00005097          	auipc	ra,0x5
     78c:	2f6080e7          	jalr	758(ra) # 5a7e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     790:	8652                	mv	a2,s4
     792:	85d6                	mv	a1,s5
     794:	00006517          	auipc	a0,0x6
     798:	b7450513          	addi	a0,a0,-1164 # 6308 <csem_up+0x612>
     79c:	00005097          	auipc	ra,0x5
     7a0:	2e2080e7          	jalr	738(ra) # 5a7e <printf>
    exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	f06080e7          	jalr	-250(ra) # 56ac <exit>
    printf("bbb fd2=%d\n", fd2);
     7ae:	85a6                	mv	a1,s1
     7b0:	00006517          	auipc	a0,0x6
     7b4:	b7850513          	addi	a0,a0,-1160 # 6328 <csem_up+0x632>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	2c6080e7          	jalr	710(ra) # 5a7e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7c0:	8652                	mv	a2,s4
     7c2:	85d6                	mv	a1,s5
     7c4:	00006517          	auipc	a0,0x6
     7c8:	b4450513          	addi	a0,a0,-1212 # 6308 <csem_up+0x612>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	2b2080e7          	jalr	690(ra) # 5a7e <printf>
    exit(1);
     7d4:	4505                	li	a0,1
     7d6:	00005097          	auipc	ra,0x5
     7da:	ed6080e7          	jalr	-298(ra) # 56ac <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7de:	862a                	mv	a2,a0
     7e0:	85d6                	mv	a1,s5
     7e2:	00006517          	auipc	a0,0x6
     7e6:	b5e50513          	addi	a0,a0,-1186 # 6340 <csem_up+0x64a>
     7ea:	00005097          	auipc	ra,0x5
     7ee:	294080e7          	jalr	660(ra) # 5a7e <printf>
    exit(1);
     7f2:	4505                	li	a0,1
     7f4:	00005097          	auipc	ra,0x5
     7f8:	eb8080e7          	jalr	-328(ra) # 56ac <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fc:	862a                	mv	a2,a0
     7fe:	85d6                	mv	a1,s5
     800:	00006517          	auipc	a0,0x6
     804:	b6050513          	addi	a0,a0,-1184 # 6360 <csem_up+0x66a>
     808:	00005097          	auipc	ra,0x5
     80c:	276080e7          	jalr	630(ra) # 5a7e <printf>
    exit(1);
     810:	4505                	li	a0,1
     812:	00005097          	auipc	ra,0x5
     816:	e9a080e7          	jalr	-358(ra) # 56ac <exit>

000000000000081a <writetest>:
{
     81a:	7139                	addi	sp,sp,-64
     81c:	fc06                	sd	ra,56(sp)
     81e:	f822                	sd	s0,48(sp)
     820:	f426                	sd	s1,40(sp)
     822:	f04a                	sd	s2,32(sp)
     824:	ec4e                	sd	s3,24(sp)
     826:	e852                	sd	s4,16(sp)
     828:	e456                	sd	s5,8(sp)
     82a:	e05a                	sd	s6,0(sp)
     82c:	0080                	addi	s0,sp,64
     82e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     830:	20200593          	li	a1,514
     834:	00006517          	auipc	a0,0x6
     838:	b4c50513          	addi	a0,a0,-1204 # 6380 <csem_up+0x68a>
     83c:	00005097          	auipc	ra,0x5
     840:	eb0080e7          	jalr	-336(ra) # 56ec <open>
  if(fd < 0){
     844:	0a054d63          	bltz	a0,8fe <writetest+0xe4>
     848:	892a                	mv	s2,a0
     84a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84c:	00006997          	auipc	s3,0x6
     850:	b5c98993          	addi	s3,s3,-1188 # 63a8 <csem_up+0x6b2>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     854:	00006a97          	auipc	s5,0x6
     858:	b8ca8a93          	addi	s5,s5,-1140 # 63e0 <csem_up+0x6ea>
  for(i = 0; i < N; i++){
     85c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     860:	4629                	li	a2,10
     862:	85ce                	mv	a1,s3
     864:	854a                	mv	a0,s2
     866:	00005097          	auipc	ra,0x5
     86a:	e66080e7          	jalr	-410(ra) # 56cc <write>
     86e:	47a9                	li	a5,10
     870:	0af51563          	bne	a0,a5,91a <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     874:	4629                	li	a2,10
     876:	85d6                	mv	a1,s5
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	e52080e7          	jalr	-430(ra) # 56cc <write>
     882:	47a9                	li	a5,10
     884:	0af51a63          	bne	a0,a5,938 <writetest+0x11e>
  for(i = 0; i < N; i++){
     888:	2485                	addiw	s1,s1,1
     88a:	fd449be3          	bne	s1,s4,860 <writetest+0x46>
  close(fd);
     88e:	854a                	mv	a0,s2
     890:	00005097          	auipc	ra,0x5
     894:	e44080e7          	jalr	-444(ra) # 56d4 <close>
  fd = open("small", O_RDONLY);
     898:	4581                	li	a1,0
     89a:	00006517          	auipc	a0,0x6
     89e:	ae650513          	addi	a0,a0,-1306 # 6380 <csem_up+0x68a>
     8a2:	00005097          	auipc	ra,0x5
     8a6:	e4a080e7          	jalr	-438(ra) # 56ec <open>
     8aa:	84aa                	mv	s1,a0
  if(fd < 0){
     8ac:	0a054563          	bltz	a0,956 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8b0:	7d000613          	li	a2,2000
     8b4:	0000b597          	auipc	a1,0xb
     8b8:	43c58593          	addi	a1,a1,1084 # bcf0 <buf>
     8bc:	00005097          	auipc	ra,0x5
     8c0:	e08080e7          	jalr	-504(ra) # 56c4 <read>
  if(i != N*SZ*2){
     8c4:	7d000793          	li	a5,2000
     8c8:	0af51563          	bne	a0,a5,972 <writetest+0x158>
  close(fd);
     8cc:	8526                	mv	a0,s1
     8ce:	00005097          	auipc	ra,0x5
     8d2:	e06080e7          	jalr	-506(ra) # 56d4 <close>
  if(unlink("small") < 0){
     8d6:	00006517          	auipc	a0,0x6
     8da:	aaa50513          	addi	a0,a0,-1366 # 6380 <csem_up+0x68a>
     8de:	00005097          	auipc	ra,0x5
     8e2:	e1e080e7          	jalr	-482(ra) # 56fc <unlink>
     8e6:	0a054463          	bltz	a0,98e <writetest+0x174>
}
     8ea:	70e2                	ld	ra,56(sp)
     8ec:	7442                	ld	s0,48(sp)
     8ee:	74a2                	ld	s1,40(sp)
     8f0:	7902                	ld	s2,32(sp)
     8f2:	69e2                	ld	s3,24(sp)
     8f4:	6a42                	ld	s4,16(sp)
     8f6:	6aa2                	ld	s5,8(sp)
     8f8:	6b02                	ld	s6,0(sp)
     8fa:	6121                	addi	sp,sp,64
     8fc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     8fe:	85da                	mv	a1,s6
     900:	00006517          	auipc	a0,0x6
     904:	a8850513          	addi	a0,a0,-1400 # 6388 <csem_up+0x692>
     908:	00005097          	auipc	ra,0x5
     90c:	176080e7          	jalr	374(ra) # 5a7e <printf>
    exit(1);
     910:	4505                	li	a0,1
     912:	00005097          	auipc	ra,0x5
     916:	d9a080e7          	jalr	-614(ra) # 56ac <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     91a:	8626                	mv	a2,s1
     91c:	85da                	mv	a1,s6
     91e:	00006517          	auipc	a0,0x6
     922:	a9a50513          	addi	a0,a0,-1382 # 63b8 <csem_up+0x6c2>
     926:	00005097          	auipc	ra,0x5
     92a:	158080e7          	jalr	344(ra) # 5a7e <printf>
      exit(1);
     92e:	4505                	li	a0,1
     930:	00005097          	auipc	ra,0x5
     934:	d7c080e7          	jalr	-644(ra) # 56ac <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     938:	8626                	mv	a2,s1
     93a:	85da                	mv	a1,s6
     93c:	00006517          	auipc	a0,0x6
     940:	ab450513          	addi	a0,a0,-1356 # 63f0 <csem_up+0x6fa>
     944:	00005097          	auipc	ra,0x5
     948:	13a080e7          	jalr	314(ra) # 5a7e <printf>
      exit(1);
     94c:	4505                	li	a0,1
     94e:	00005097          	auipc	ra,0x5
     952:	d5e080e7          	jalr	-674(ra) # 56ac <exit>
    printf("%s: error: open small failed!\n", s);
     956:	85da                	mv	a1,s6
     958:	00006517          	auipc	a0,0x6
     95c:	ac050513          	addi	a0,a0,-1344 # 6418 <csem_up+0x722>
     960:	00005097          	auipc	ra,0x5
     964:	11e080e7          	jalr	286(ra) # 5a7e <printf>
    exit(1);
     968:	4505                	li	a0,1
     96a:	00005097          	auipc	ra,0x5
     96e:	d42080e7          	jalr	-702(ra) # 56ac <exit>
    printf("%s: read failed\n", s);
     972:	85da                	mv	a1,s6
     974:	00006517          	auipc	a0,0x6
     978:	ac450513          	addi	a0,a0,-1340 # 6438 <csem_up+0x742>
     97c:	00005097          	auipc	ra,0x5
     980:	102080e7          	jalr	258(ra) # 5a7e <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	d26080e7          	jalr	-730(ra) # 56ac <exit>
    printf("%s: unlink small failed\n", s);
     98e:	85da                	mv	a1,s6
     990:	00006517          	auipc	a0,0x6
     994:	ac050513          	addi	a0,a0,-1344 # 6450 <csem_up+0x75a>
     998:	00005097          	auipc	ra,0x5
     99c:	0e6080e7          	jalr	230(ra) # 5a7e <printf>
    exit(1);
     9a0:	4505                	li	a0,1
     9a2:	00005097          	auipc	ra,0x5
     9a6:	d0a080e7          	jalr	-758(ra) # 56ac <exit>

00000000000009aa <writebig>:
{
     9aa:	7139                	addi	sp,sp,-64
     9ac:	fc06                	sd	ra,56(sp)
     9ae:	f822                	sd	s0,48(sp)
     9b0:	f426                	sd	s1,40(sp)
     9b2:	f04a                	sd	s2,32(sp)
     9b4:	ec4e                	sd	s3,24(sp)
     9b6:	e852                	sd	s4,16(sp)
     9b8:	e456                	sd	s5,8(sp)
     9ba:	0080                	addi	s0,sp,64
     9bc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9be:	20200593          	li	a1,514
     9c2:	00006517          	auipc	a0,0x6
     9c6:	aae50513          	addi	a0,a0,-1362 # 6470 <csem_up+0x77a>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	d22080e7          	jalr	-734(ra) # 56ec <open>
     9d2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9d4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9d6:	0000b917          	auipc	s2,0xb
     9da:	31a90913          	addi	s2,s2,794 # bcf0 <buf>
  for(i = 0; i < MAXFILE; i++){
     9de:	10c00a13          	li	s4,268
  if(fd < 0){
     9e2:	06054c63          	bltz	a0,a5a <writebig+0xb0>
    ((int*)buf)[0] = i;
     9e6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9ea:	40000613          	li	a2,1024
     9ee:	85ca                	mv	a1,s2
     9f0:	854e                	mv	a0,s3
     9f2:	00005097          	auipc	ra,0x5
     9f6:	cda080e7          	jalr	-806(ra) # 56cc <write>
     9fa:	40000793          	li	a5,1024
     9fe:	06f51c63          	bne	a0,a5,a76 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a02:	2485                	addiw	s1,s1,1
     a04:	ff4491e3          	bne	s1,s4,9e6 <writebig+0x3c>
  close(fd);
     a08:	854e                	mv	a0,s3
     a0a:	00005097          	auipc	ra,0x5
     a0e:	cca080e7          	jalr	-822(ra) # 56d4 <close>
  fd = open("big", O_RDONLY);
     a12:	4581                	li	a1,0
     a14:	00006517          	auipc	a0,0x6
     a18:	a5c50513          	addi	a0,a0,-1444 # 6470 <csem_up+0x77a>
     a1c:	00005097          	auipc	ra,0x5
     a20:	cd0080e7          	jalr	-816(ra) # 56ec <open>
     a24:	89aa                	mv	s3,a0
  n = 0;
     a26:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a28:	0000b917          	auipc	s2,0xb
     a2c:	2c890913          	addi	s2,s2,712 # bcf0 <buf>
  if(fd < 0){
     a30:	06054263          	bltz	a0,a94 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a34:	40000613          	li	a2,1024
     a38:	85ca                	mv	a1,s2
     a3a:	854e                	mv	a0,s3
     a3c:	00005097          	auipc	ra,0x5
     a40:	c88080e7          	jalr	-888(ra) # 56c4 <read>
    if(i == 0){
     a44:	c535                	beqz	a0,ab0 <writebig+0x106>
    } else if(i != BSIZE){
     a46:	40000793          	li	a5,1024
     a4a:	0af51f63          	bne	a0,a5,b08 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0c969a63          	bne	a3,s1,b26 <writebig+0x17c>
    n++;
     a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	bff1                	j	a34 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00006517          	auipc	a0,0x6
     a60:	a1c50513          	addi	a0,a0,-1508 # 6478 <csem_up+0x782>
     a64:	00005097          	auipc	ra,0x5
     a68:	01a080e7          	jalr	26(ra) # 5a7e <printf>
    exit(1);
     a6c:	4505                	li	a0,1
     a6e:	00005097          	auipc	ra,0x5
     a72:	c3e080e7          	jalr	-962(ra) # 56ac <exit>
      printf("%s: error: write big file failed\n", s, i);
     a76:	8626                	mv	a2,s1
     a78:	85d6                	mv	a1,s5
     a7a:	00006517          	auipc	a0,0x6
     a7e:	a1e50513          	addi	a0,a0,-1506 # 6498 <csem_up+0x7a2>
     a82:	00005097          	auipc	ra,0x5
     a86:	ffc080e7          	jalr	-4(ra) # 5a7e <printf>
      exit(1);
     a8a:	4505                	li	a0,1
     a8c:	00005097          	auipc	ra,0x5
     a90:	c20080e7          	jalr	-992(ra) # 56ac <exit>
    printf("%s: error: open big failed!\n", s);
     a94:	85d6                	mv	a1,s5
     a96:	00006517          	auipc	a0,0x6
     a9a:	a2a50513          	addi	a0,a0,-1494 # 64c0 <csem_up+0x7ca>
     a9e:	00005097          	auipc	ra,0x5
     aa2:	fe0080e7          	jalr	-32(ra) # 5a7e <printf>
    exit(1);
     aa6:	4505                	li	a0,1
     aa8:	00005097          	auipc	ra,0x5
     aac:	c04080e7          	jalr	-1020(ra) # 56ac <exit>
      if(n == MAXFILE - 1){
     ab0:	10b00793          	li	a5,267
     ab4:	02f48a63          	beq	s1,a5,ae8 <writebig+0x13e>
  close(fd);
     ab8:	854e                	mv	a0,s3
     aba:	00005097          	auipc	ra,0x5
     abe:	c1a080e7          	jalr	-998(ra) # 56d4 <close>
  if(unlink("big") < 0){
     ac2:	00006517          	auipc	a0,0x6
     ac6:	9ae50513          	addi	a0,a0,-1618 # 6470 <csem_up+0x77a>
     aca:	00005097          	auipc	ra,0x5
     ace:	c32080e7          	jalr	-974(ra) # 56fc <unlink>
     ad2:	06054963          	bltz	a0,b44 <writebig+0x19a>
}
     ad6:	70e2                	ld	ra,56(sp)
     ad8:	7442                	ld	s0,48(sp)
     ada:	74a2                	ld	s1,40(sp)
     adc:	7902                	ld	s2,32(sp)
     ade:	69e2                	ld	s3,24(sp)
     ae0:	6a42                	ld	s4,16(sp)
     ae2:	6aa2                	ld	s5,8(sp)
     ae4:	6121                	addi	sp,sp,64
     ae6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ae8:	10b00613          	li	a2,267
     aec:	85d6                	mv	a1,s5
     aee:	00006517          	auipc	a0,0x6
     af2:	9f250513          	addi	a0,a0,-1550 # 64e0 <csem_up+0x7ea>
     af6:	00005097          	auipc	ra,0x5
     afa:	f88080e7          	jalr	-120(ra) # 5a7e <printf>
        exit(1);
     afe:	4505                	li	a0,1
     b00:	00005097          	auipc	ra,0x5
     b04:	bac080e7          	jalr	-1108(ra) # 56ac <exit>
      printf("%s: read failed %d\n", s, i);
     b08:	862a                	mv	a2,a0
     b0a:	85d6                	mv	a1,s5
     b0c:	00006517          	auipc	a0,0x6
     b10:	9fc50513          	addi	a0,a0,-1540 # 6508 <csem_up+0x812>
     b14:	00005097          	auipc	ra,0x5
     b18:	f6a080e7          	jalr	-150(ra) # 5a7e <printf>
      exit(1);
     b1c:	4505                	li	a0,1
     b1e:	00005097          	auipc	ra,0x5
     b22:	b8e080e7          	jalr	-1138(ra) # 56ac <exit>
      printf("%s: read content of block %d is %d\n", s,
     b26:	8626                	mv	a2,s1
     b28:	85d6                	mv	a1,s5
     b2a:	00006517          	auipc	a0,0x6
     b2e:	9f650513          	addi	a0,a0,-1546 # 6520 <csem_up+0x82a>
     b32:	00005097          	auipc	ra,0x5
     b36:	f4c080e7          	jalr	-180(ra) # 5a7e <printf>
      exit(1);
     b3a:	4505                	li	a0,1
     b3c:	00005097          	auipc	ra,0x5
     b40:	b70080e7          	jalr	-1168(ra) # 56ac <exit>
    printf("%s: unlink big failed\n", s);
     b44:	85d6                	mv	a1,s5
     b46:	00006517          	auipc	a0,0x6
     b4a:	a0250513          	addi	a0,a0,-1534 # 6548 <csem_up+0x852>
     b4e:	00005097          	auipc	ra,0x5
     b52:	f30080e7          	jalr	-208(ra) # 5a7e <printf>
    exit(1);
     b56:	4505                	li	a0,1
     b58:	00005097          	auipc	ra,0x5
     b5c:	b54080e7          	jalr	-1196(ra) # 56ac <exit>

0000000000000b60 <unlinkread>:
{
     b60:	7179                	addi	sp,sp,-48
     b62:	f406                	sd	ra,40(sp)
     b64:	f022                	sd	s0,32(sp)
     b66:	ec26                	sd	s1,24(sp)
     b68:	e84a                	sd	s2,16(sp)
     b6a:	e44e                	sd	s3,8(sp)
     b6c:	1800                	addi	s0,sp,48
     b6e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b70:	20200593          	li	a1,514
     b74:	00005517          	auipc	a0,0x5
     b78:	32c50513          	addi	a0,a0,812 # 5ea0 <csem_up+0x1aa>
     b7c:	00005097          	auipc	ra,0x5
     b80:	b70080e7          	jalr	-1168(ra) # 56ec <open>
  if(fd < 0){
     b84:	0e054563          	bltz	a0,c6e <unlinkread+0x10e>
     b88:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b8a:	4615                	li	a2,5
     b8c:	00006597          	auipc	a1,0x6
     b90:	9f458593          	addi	a1,a1,-1548 # 6580 <csem_up+0x88a>
     b94:	00005097          	auipc	ra,0x5
     b98:	b38080e7          	jalr	-1224(ra) # 56cc <write>
  close(fd);
     b9c:	8526                	mv	a0,s1
     b9e:	00005097          	auipc	ra,0x5
     ba2:	b36080e7          	jalr	-1226(ra) # 56d4 <close>
  fd = open("unlinkread", O_RDWR);
     ba6:	4589                	li	a1,2
     ba8:	00005517          	auipc	a0,0x5
     bac:	2f850513          	addi	a0,a0,760 # 5ea0 <csem_up+0x1aa>
     bb0:	00005097          	auipc	ra,0x5
     bb4:	b3c080e7          	jalr	-1220(ra) # 56ec <open>
     bb8:	84aa                	mv	s1,a0
  if(fd < 0){
     bba:	0c054863          	bltz	a0,c8a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bbe:	00005517          	auipc	a0,0x5
     bc2:	2e250513          	addi	a0,a0,738 # 5ea0 <csem_up+0x1aa>
     bc6:	00005097          	auipc	ra,0x5
     bca:	b36080e7          	jalr	-1226(ra) # 56fc <unlink>
     bce:	ed61                	bnez	a0,ca6 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	2cc50513          	addi	a0,a0,716 # 5ea0 <csem_up+0x1aa>
     bdc:	00005097          	auipc	ra,0x5
     be0:	b10080e7          	jalr	-1264(ra) # 56ec <open>
     be4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be6:	460d                	li	a2,3
     be8:	00006597          	auipc	a1,0x6
     bec:	9e058593          	addi	a1,a1,-1568 # 65c8 <csem_up+0x8d2>
     bf0:	00005097          	auipc	ra,0x5
     bf4:	adc080e7          	jalr	-1316(ra) # 56cc <write>
  close(fd1);
     bf8:	854a                	mv	a0,s2
     bfa:	00005097          	auipc	ra,0x5
     bfe:	ada080e7          	jalr	-1318(ra) # 56d4 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c02:	660d                	lui	a2,0x3
     c04:	0000b597          	auipc	a1,0xb
     c08:	0ec58593          	addi	a1,a1,236 # bcf0 <buf>
     c0c:	8526                	mv	a0,s1
     c0e:	00005097          	auipc	ra,0x5
     c12:	ab6080e7          	jalr	-1354(ra) # 56c4 <read>
     c16:	4795                	li	a5,5
     c18:	0af51563          	bne	a0,a5,cc2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1c:	0000b717          	auipc	a4,0xb
     c20:	0d474703          	lbu	a4,212(a4) # bcf0 <buf>
     c24:	06800793          	li	a5,104
     c28:	0af71b63          	bne	a4,a5,cde <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2c:	4629                	li	a2,10
     c2e:	0000b597          	auipc	a1,0xb
     c32:	0c258593          	addi	a1,a1,194 # bcf0 <buf>
     c36:	8526                	mv	a0,s1
     c38:	00005097          	auipc	ra,0x5
     c3c:	a94080e7          	jalr	-1388(ra) # 56cc <write>
     c40:	47a9                	li	a5,10
     c42:	0af51c63          	bne	a0,a5,cfa <unlinkread+0x19a>
  close(fd);
     c46:	8526                	mv	a0,s1
     c48:	00005097          	auipc	ra,0x5
     c4c:	a8c080e7          	jalr	-1396(ra) # 56d4 <close>
  unlink("unlinkread");
     c50:	00005517          	auipc	a0,0x5
     c54:	25050513          	addi	a0,a0,592 # 5ea0 <csem_up+0x1aa>
     c58:	00005097          	auipc	ra,0x5
     c5c:	aa4080e7          	jalr	-1372(ra) # 56fc <unlink>
}
     c60:	70a2                	ld	ra,40(sp)
     c62:	7402                	ld	s0,32(sp)
     c64:	64e2                	ld	s1,24(sp)
     c66:	6942                	ld	s2,16(sp)
     c68:	69a2                	ld	s3,8(sp)
     c6a:	6145                	addi	sp,sp,48
     c6c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c6e:	85ce                	mv	a1,s3
     c70:	00006517          	auipc	a0,0x6
     c74:	8f050513          	addi	a0,a0,-1808 # 6560 <csem_up+0x86a>
     c78:	00005097          	auipc	ra,0x5
     c7c:	e06080e7          	jalr	-506(ra) # 5a7e <printf>
    exit(1);
     c80:	4505                	li	a0,1
     c82:	00005097          	auipc	ra,0x5
     c86:	a2a080e7          	jalr	-1494(ra) # 56ac <exit>
    printf("%s: open unlinkread failed\n", s);
     c8a:	85ce                	mv	a1,s3
     c8c:	00006517          	auipc	a0,0x6
     c90:	8fc50513          	addi	a0,a0,-1796 # 6588 <csem_up+0x892>
     c94:	00005097          	auipc	ra,0x5
     c98:	dea080e7          	jalr	-534(ra) # 5a7e <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	00005097          	auipc	ra,0x5
     ca2:	a0e080e7          	jalr	-1522(ra) # 56ac <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca6:	85ce                	mv	a1,s3
     ca8:	00006517          	auipc	a0,0x6
     cac:	90050513          	addi	a0,a0,-1792 # 65a8 <csem_up+0x8b2>
     cb0:	00005097          	auipc	ra,0x5
     cb4:	dce080e7          	jalr	-562(ra) # 5a7e <printf>
    exit(1);
     cb8:	4505                	li	a0,1
     cba:	00005097          	auipc	ra,0x5
     cbe:	9f2080e7          	jalr	-1550(ra) # 56ac <exit>
    printf("%s: unlinkread read failed", s);
     cc2:	85ce                	mv	a1,s3
     cc4:	00006517          	auipc	a0,0x6
     cc8:	90c50513          	addi	a0,a0,-1780 # 65d0 <csem_up+0x8da>
     ccc:	00005097          	auipc	ra,0x5
     cd0:	db2080e7          	jalr	-590(ra) # 5a7e <printf>
    exit(1);
     cd4:	4505                	li	a0,1
     cd6:	00005097          	auipc	ra,0x5
     cda:	9d6080e7          	jalr	-1578(ra) # 56ac <exit>
    printf("%s: unlinkread wrong data\n", s);
     cde:	85ce                	mv	a1,s3
     ce0:	00006517          	auipc	a0,0x6
     ce4:	91050513          	addi	a0,a0,-1776 # 65f0 <csem_up+0x8fa>
     ce8:	00005097          	auipc	ra,0x5
     cec:	d96080e7          	jalr	-618(ra) # 5a7e <printf>
    exit(1);
     cf0:	4505                	li	a0,1
     cf2:	00005097          	auipc	ra,0x5
     cf6:	9ba080e7          	jalr	-1606(ra) # 56ac <exit>
    printf("%s: unlinkread write failed\n", s);
     cfa:	85ce                	mv	a1,s3
     cfc:	00006517          	auipc	a0,0x6
     d00:	91450513          	addi	a0,a0,-1772 # 6610 <csem_up+0x91a>
     d04:	00005097          	auipc	ra,0x5
     d08:	d7a080e7          	jalr	-646(ra) # 5a7e <printf>
    exit(1);
     d0c:	4505                	li	a0,1
     d0e:	00005097          	auipc	ra,0x5
     d12:	99e080e7          	jalr	-1634(ra) # 56ac <exit>

0000000000000d16 <linktest>:
{
     d16:	1101                	addi	sp,sp,-32
     d18:	ec06                	sd	ra,24(sp)
     d1a:	e822                	sd	s0,16(sp)
     d1c:	e426                	sd	s1,8(sp)
     d1e:	e04a                	sd	s2,0(sp)
     d20:	1000                	addi	s0,sp,32
     d22:	892a                	mv	s2,a0
  unlink("lf1");
     d24:	00006517          	auipc	a0,0x6
     d28:	90c50513          	addi	a0,a0,-1780 # 6630 <csem_up+0x93a>
     d2c:	00005097          	auipc	ra,0x5
     d30:	9d0080e7          	jalr	-1584(ra) # 56fc <unlink>
  unlink("lf2");
     d34:	00006517          	auipc	a0,0x6
     d38:	90450513          	addi	a0,a0,-1788 # 6638 <csem_up+0x942>
     d3c:	00005097          	auipc	ra,0x5
     d40:	9c0080e7          	jalr	-1600(ra) # 56fc <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d44:	20200593          	li	a1,514
     d48:	00006517          	auipc	a0,0x6
     d4c:	8e850513          	addi	a0,a0,-1816 # 6630 <csem_up+0x93a>
     d50:	00005097          	auipc	ra,0x5
     d54:	99c080e7          	jalr	-1636(ra) # 56ec <open>
  if(fd < 0){
     d58:	10054763          	bltz	a0,e66 <linktest+0x150>
     d5c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d5e:	4615                	li	a2,5
     d60:	00006597          	auipc	a1,0x6
     d64:	82058593          	addi	a1,a1,-2016 # 6580 <csem_up+0x88a>
     d68:	00005097          	auipc	ra,0x5
     d6c:	964080e7          	jalr	-1692(ra) # 56cc <write>
     d70:	4795                	li	a5,5
     d72:	10f51863          	bne	a0,a5,e82 <linktest+0x16c>
  close(fd);
     d76:	8526                	mv	a0,s1
     d78:	00005097          	auipc	ra,0x5
     d7c:	95c080e7          	jalr	-1700(ra) # 56d4 <close>
  if(link("lf1", "lf2") < 0){
     d80:	00006597          	auipc	a1,0x6
     d84:	8b858593          	addi	a1,a1,-1864 # 6638 <csem_up+0x942>
     d88:	00006517          	auipc	a0,0x6
     d8c:	8a850513          	addi	a0,a0,-1880 # 6630 <csem_up+0x93a>
     d90:	00005097          	auipc	ra,0x5
     d94:	97c080e7          	jalr	-1668(ra) # 570c <link>
     d98:	10054363          	bltz	a0,e9e <linktest+0x188>
  unlink("lf1");
     d9c:	00006517          	auipc	a0,0x6
     da0:	89450513          	addi	a0,a0,-1900 # 6630 <csem_up+0x93a>
     da4:	00005097          	auipc	ra,0x5
     da8:	958080e7          	jalr	-1704(ra) # 56fc <unlink>
  if(open("lf1", 0) >= 0){
     dac:	4581                	li	a1,0
     dae:	00006517          	auipc	a0,0x6
     db2:	88250513          	addi	a0,a0,-1918 # 6630 <csem_up+0x93a>
     db6:	00005097          	auipc	ra,0x5
     dba:	936080e7          	jalr	-1738(ra) # 56ec <open>
     dbe:	0e055e63          	bgez	a0,eba <linktest+0x1a4>
  fd = open("lf2", 0);
     dc2:	4581                	li	a1,0
     dc4:	00006517          	auipc	a0,0x6
     dc8:	87450513          	addi	a0,a0,-1932 # 6638 <csem_up+0x942>
     dcc:	00005097          	auipc	ra,0x5
     dd0:	920080e7          	jalr	-1760(ra) # 56ec <open>
     dd4:	84aa                	mv	s1,a0
  if(fd < 0){
     dd6:	10054063          	bltz	a0,ed6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dda:	660d                	lui	a2,0x3
     ddc:	0000b597          	auipc	a1,0xb
     de0:	f1458593          	addi	a1,a1,-236 # bcf0 <buf>
     de4:	00005097          	auipc	ra,0x5
     de8:	8e0080e7          	jalr	-1824(ra) # 56c4 <read>
     dec:	4795                	li	a5,5
     dee:	10f51263          	bne	a0,a5,ef2 <linktest+0x1dc>
  close(fd);
     df2:	8526                	mv	a0,s1
     df4:	00005097          	auipc	ra,0x5
     df8:	8e0080e7          	jalr	-1824(ra) # 56d4 <close>
  if(link("lf2", "lf2") >= 0){
     dfc:	00006597          	auipc	a1,0x6
     e00:	83c58593          	addi	a1,a1,-1988 # 6638 <csem_up+0x942>
     e04:	852e                	mv	a0,a1
     e06:	00005097          	auipc	ra,0x5
     e0a:	906080e7          	jalr	-1786(ra) # 570c <link>
     e0e:	10055063          	bgez	a0,f0e <linktest+0x1f8>
  unlink("lf2");
     e12:	00006517          	auipc	a0,0x6
     e16:	82650513          	addi	a0,a0,-2010 # 6638 <csem_up+0x942>
     e1a:	00005097          	auipc	ra,0x5
     e1e:	8e2080e7          	jalr	-1822(ra) # 56fc <unlink>
  if(link("lf2", "lf1") >= 0){
     e22:	00006597          	auipc	a1,0x6
     e26:	80e58593          	addi	a1,a1,-2034 # 6630 <csem_up+0x93a>
     e2a:	00006517          	auipc	a0,0x6
     e2e:	80e50513          	addi	a0,a0,-2034 # 6638 <csem_up+0x942>
     e32:	00005097          	auipc	ra,0x5
     e36:	8da080e7          	jalr	-1830(ra) # 570c <link>
     e3a:	0e055863          	bgez	a0,f2a <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e3e:	00005597          	auipc	a1,0x5
     e42:	7f258593          	addi	a1,a1,2034 # 6630 <csem_up+0x93a>
     e46:	00006517          	auipc	a0,0x6
     e4a:	8fa50513          	addi	a0,a0,-1798 # 6740 <csem_up+0xa4a>
     e4e:	00005097          	auipc	ra,0x5
     e52:	8be080e7          	jalr	-1858(ra) # 570c <link>
     e56:	0e055863          	bgez	a0,f46 <linktest+0x230>
}
     e5a:	60e2                	ld	ra,24(sp)
     e5c:	6442                	ld	s0,16(sp)
     e5e:	64a2                	ld	s1,8(sp)
     e60:	6902                	ld	s2,0(sp)
     e62:	6105                	addi	sp,sp,32
     e64:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e66:	85ca                	mv	a1,s2
     e68:	00005517          	auipc	a0,0x5
     e6c:	7d850513          	addi	a0,a0,2008 # 6640 <csem_up+0x94a>
     e70:	00005097          	auipc	ra,0x5
     e74:	c0e080e7          	jalr	-1010(ra) # 5a7e <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	00005097          	auipc	ra,0x5
     e7e:	832080e7          	jalr	-1998(ra) # 56ac <exit>
    printf("%s: write lf1 failed\n", s);
     e82:	85ca                	mv	a1,s2
     e84:	00005517          	auipc	a0,0x5
     e88:	7d450513          	addi	a0,a0,2004 # 6658 <csem_up+0x962>
     e8c:	00005097          	auipc	ra,0x5
     e90:	bf2080e7          	jalr	-1038(ra) # 5a7e <printf>
    exit(1);
     e94:	4505                	li	a0,1
     e96:	00005097          	auipc	ra,0x5
     e9a:	816080e7          	jalr	-2026(ra) # 56ac <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e9e:	85ca                	mv	a1,s2
     ea0:	00005517          	auipc	a0,0x5
     ea4:	7d050513          	addi	a0,a0,2000 # 6670 <csem_up+0x97a>
     ea8:	00005097          	auipc	ra,0x5
     eac:	bd6080e7          	jalr	-1066(ra) # 5a7e <printf>
    exit(1);
     eb0:	4505                	li	a0,1
     eb2:	00004097          	auipc	ra,0x4
     eb6:	7fa080e7          	jalr	2042(ra) # 56ac <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eba:	85ca                	mv	a1,s2
     ebc:	00005517          	auipc	a0,0x5
     ec0:	7d450513          	addi	a0,a0,2004 # 6690 <csem_up+0x99a>
     ec4:	00005097          	auipc	ra,0x5
     ec8:	bba080e7          	jalr	-1094(ra) # 5a7e <printf>
    exit(1);
     ecc:	4505                	li	a0,1
     ece:	00004097          	auipc	ra,0x4
     ed2:	7de080e7          	jalr	2014(ra) # 56ac <exit>
    printf("%s: open lf2 failed\n", s);
     ed6:	85ca                	mv	a1,s2
     ed8:	00005517          	auipc	a0,0x5
     edc:	7e850513          	addi	a0,a0,2024 # 66c0 <csem_up+0x9ca>
     ee0:	00005097          	auipc	ra,0x5
     ee4:	b9e080e7          	jalr	-1122(ra) # 5a7e <printf>
    exit(1);
     ee8:	4505                	li	a0,1
     eea:	00004097          	auipc	ra,0x4
     eee:	7c2080e7          	jalr	1986(ra) # 56ac <exit>
    printf("%s: read lf2 failed\n", s);
     ef2:	85ca                	mv	a1,s2
     ef4:	00005517          	auipc	a0,0x5
     ef8:	7e450513          	addi	a0,a0,2020 # 66d8 <csem_up+0x9e2>
     efc:	00005097          	auipc	ra,0x5
     f00:	b82080e7          	jalr	-1150(ra) # 5a7e <printf>
    exit(1);
     f04:	4505                	li	a0,1
     f06:	00004097          	auipc	ra,0x4
     f0a:	7a6080e7          	jalr	1958(ra) # 56ac <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f0e:	85ca                	mv	a1,s2
     f10:	00005517          	auipc	a0,0x5
     f14:	7e050513          	addi	a0,a0,2016 # 66f0 <csem_up+0x9fa>
     f18:	00005097          	auipc	ra,0x5
     f1c:	b66080e7          	jalr	-1178(ra) # 5a7e <printf>
    exit(1);
     f20:	4505                	li	a0,1
     f22:	00004097          	auipc	ra,0x4
     f26:	78a080e7          	jalr	1930(ra) # 56ac <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f2a:	85ca                	mv	a1,s2
     f2c:	00005517          	auipc	a0,0x5
     f30:	7ec50513          	addi	a0,a0,2028 # 6718 <csem_up+0xa22>
     f34:	00005097          	auipc	ra,0x5
     f38:	b4a080e7          	jalr	-1206(ra) # 5a7e <printf>
    exit(1);
     f3c:	4505                	li	a0,1
     f3e:	00004097          	auipc	ra,0x4
     f42:	76e080e7          	jalr	1902(ra) # 56ac <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f46:	85ca                	mv	a1,s2
     f48:	00006517          	auipc	a0,0x6
     f4c:	80050513          	addi	a0,a0,-2048 # 6748 <csem_up+0xa52>
     f50:	00005097          	auipc	ra,0x5
     f54:	b2e080e7          	jalr	-1234(ra) # 5a7e <printf>
    exit(1);
     f58:	4505                	li	a0,1
     f5a:	00004097          	auipc	ra,0x4
     f5e:	752080e7          	jalr	1874(ra) # 56ac <exit>

0000000000000f62 <bigdir>:
{
     f62:	715d                	addi	sp,sp,-80
     f64:	e486                	sd	ra,72(sp)
     f66:	e0a2                	sd	s0,64(sp)
     f68:	fc26                	sd	s1,56(sp)
     f6a:	f84a                	sd	s2,48(sp)
     f6c:	f44e                	sd	s3,40(sp)
     f6e:	f052                	sd	s4,32(sp)
     f70:	ec56                	sd	s5,24(sp)
     f72:	e85a                	sd	s6,16(sp)
     f74:	0880                	addi	s0,sp,80
     f76:	89aa                	mv	s3,a0
  unlink("bd");
     f78:	00005517          	auipc	a0,0x5
     f7c:	7f050513          	addi	a0,a0,2032 # 6768 <csem_up+0xa72>
     f80:	00004097          	auipc	ra,0x4
     f84:	77c080e7          	jalr	1916(ra) # 56fc <unlink>
  fd = open("bd", O_CREATE);
     f88:	20000593          	li	a1,512
     f8c:	00005517          	auipc	a0,0x5
     f90:	7dc50513          	addi	a0,a0,2012 # 6768 <csem_up+0xa72>
     f94:	00004097          	auipc	ra,0x4
     f98:	758080e7          	jalr	1880(ra) # 56ec <open>
  if(fd < 0){
     f9c:	0c054963          	bltz	a0,106e <bigdir+0x10c>
  close(fd);
     fa0:	00004097          	auipc	ra,0x4
     fa4:	734080e7          	jalr	1844(ra) # 56d4 <close>
  for(i = 0; i < N; i++){
     fa8:	4901                	li	s2,0
    name[0] = 'x';
     faa:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fae:	00005a17          	auipc	s4,0x5
     fb2:	7baa0a13          	addi	s4,s4,1978 # 6768 <csem_up+0xa72>
  for(i = 0; i < N; i++){
     fb6:	1f400b13          	li	s6,500
    name[0] = 'x';
     fba:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fbe:	41f9579b          	sraiw	a5,s2,0x1f
     fc2:	01a7d71b          	srliw	a4,a5,0x1a
     fc6:	012707bb          	addw	a5,a4,s2
     fca:	4067d69b          	sraiw	a3,a5,0x6
     fce:	0306869b          	addiw	a3,a3,48
     fd2:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd6:	03f7f793          	andi	a5,a5,63
     fda:	9f99                	subw	a5,a5,a4
     fdc:	0307879b          	addiw	a5,a5,48
     fe0:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe4:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fe8:	fb040593          	addi	a1,s0,-80
     fec:	8552                	mv	a0,s4
     fee:	00004097          	auipc	ra,0x4
     ff2:	71e080e7          	jalr	1822(ra) # 570c <link>
     ff6:	84aa                	mv	s1,a0
     ff8:	e949                	bnez	a0,108a <bigdir+0x128>
  for(i = 0; i < N; i++){
     ffa:	2905                	addiw	s2,s2,1
     ffc:	fb691fe3          	bne	s2,s6,fba <bigdir+0x58>
  unlink("bd");
    1000:	00005517          	auipc	a0,0x5
    1004:	76850513          	addi	a0,a0,1896 # 6768 <csem_up+0xa72>
    1008:	00004097          	auipc	ra,0x4
    100c:	6f4080e7          	jalr	1780(ra) # 56fc <unlink>
    name[0] = 'x';
    1010:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1014:	1f400a13          	li	s4,500
    name[0] = 'x';
    1018:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101c:	41f4d79b          	sraiw	a5,s1,0x1f
    1020:	01a7d71b          	srliw	a4,a5,0x1a
    1024:	009707bb          	addw	a5,a4,s1
    1028:	4067d69b          	sraiw	a3,a5,0x6
    102c:	0306869b          	addiw	a3,a3,48
    1030:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1034:	03f7f793          	andi	a5,a5,63
    1038:	9f99                	subw	a5,a5,a4
    103a:	0307879b          	addiw	a5,a5,48
    103e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1042:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1046:	fb040513          	addi	a0,s0,-80
    104a:	00004097          	auipc	ra,0x4
    104e:	6b2080e7          	jalr	1714(ra) # 56fc <unlink>
    1052:	ed21                	bnez	a0,10aa <bigdir+0x148>
  for(i = 0; i < N; i++){
    1054:	2485                	addiw	s1,s1,1
    1056:	fd4491e3          	bne	s1,s4,1018 <bigdir+0xb6>
}
    105a:	60a6                	ld	ra,72(sp)
    105c:	6406                	ld	s0,64(sp)
    105e:	74e2                	ld	s1,56(sp)
    1060:	7942                	ld	s2,48(sp)
    1062:	79a2                	ld	s3,40(sp)
    1064:	7a02                	ld	s4,32(sp)
    1066:	6ae2                	ld	s5,24(sp)
    1068:	6b42                	ld	s6,16(sp)
    106a:	6161                	addi	sp,sp,80
    106c:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    106e:	85ce                	mv	a1,s3
    1070:	00005517          	auipc	a0,0x5
    1074:	70050513          	addi	a0,a0,1792 # 6770 <csem_up+0xa7a>
    1078:	00005097          	auipc	ra,0x5
    107c:	a06080e7          	jalr	-1530(ra) # 5a7e <printf>
    exit(1);
    1080:	4505                	li	a0,1
    1082:	00004097          	auipc	ra,0x4
    1086:	62a080e7          	jalr	1578(ra) # 56ac <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    108a:	fb040613          	addi	a2,s0,-80
    108e:	85ce                	mv	a1,s3
    1090:	00005517          	auipc	a0,0x5
    1094:	70050513          	addi	a0,a0,1792 # 6790 <csem_up+0xa9a>
    1098:	00005097          	auipc	ra,0x5
    109c:	9e6080e7          	jalr	-1562(ra) # 5a7e <printf>
      exit(1);
    10a0:	4505                	li	a0,1
    10a2:	00004097          	auipc	ra,0x4
    10a6:	60a080e7          	jalr	1546(ra) # 56ac <exit>
      printf("%s: bigdir unlink failed", s);
    10aa:	85ce                	mv	a1,s3
    10ac:	00005517          	auipc	a0,0x5
    10b0:	70450513          	addi	a0,a0,1796 # 67b0 <csem_up+0xaba>
    10b4:	00005097          	auipc	ra,0x5
    10b8:	9ca080e7          	jalr	-1590(ra) # 5a7e <printf>
      exit(1);
    10bc:	4505                	li	a0,1
    10be:	00004097          	auipc	ra,0x4
    10c2:	5ee080e7          	jalr	1518(ra) # 56ac <exit>

00000000000010c6 <validatetest>:
{
    10c6:	7139                	addi	sp,sp,-64
    10c8:	fc06                	sd	ra,56(sp)
    10ca:	f822                	sd	s0,48(sp)
    10cc:	f426                	sd	s1,40(sp)
    10ce:	f04a                	sd	s2,32(sp)
    10d0:	ec4e                	sd	s3,24(sp)
    10d2:	e852                	sd	s4,16(sp)
    10d4:	e456                	sd	s5,8(sp)
    10d6:	e05a                	sd	s6,0(sp)
    10d8:	0080                	addi	s0,sp,64
    10da:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10dc:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10de:	00005997          	auipc	s3,0x5
    10e2:	6f298993          	addi	s3,s3,1778 # 67d0 <csem_up+0xada>
    10e6:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e8:	6a85                	lui	s5,0x1
    10ea:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10ee:	85a6                	mv	a1,s1
    10f0:	854e                	mv	a0,s3
    10f2:	00004097          	auipc	ra,0x4
    10f6:	61a080e7          	jalr	1562(ra) # 570c <link>
    10fa:	01251f63          	bne	a0,s2,1118 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fe:	94d6                	add	s1,s1,s5
    1100:	ff4497e3          	bne	s1,s4,10ee <validatetest+0x28>
}
    1104:	70e2                	ld	ra,56(sp)
    1106:	7442                	ld	s0,48(sp)
    1108:	74a2                	ld	s1,40(sp)
    110a:	7902                	ld	s2,32(sp)
    110c:	69e2                	ld	s3,24(sp)
    110e:	6a42                	ld	s4,16(sp)
    1110:	6aa2                	ld	s5,8(sp)
    1112:	6b02                	ld	s6,0(sp)
    1114:	6121                	addi	sp,sp,64
    1116:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1118:	85da                	mv	a1,s6
    111a:	00005517          	auipc	a0,0x5
    111e:	6c650513          	addi	a0,a0,1734 # 67e0 <csem_up+0xaea>
    1122:	00005097          	auipc	ra,0x5
    1126:	95c080e7          	jalr	-1700(ra) # 5a7e <printf>
      exit(1);
    112a:	4505                	li	a0,1
    112c:	00004097          	auipc	ra,0x4
    1130:	580080e7          	jalr	1408(ra) # 56ac <exit>

0000000000001134 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1134:	7179                	addi	sp,sp,-48
    1136:	f406                	sd	ra,40(sp)
    1138:	f022                	sd	s0,32(sp)
    113a:	ec26                	sd	s1,24(sp)
    113c:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    113e:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1142:	00007497          	auipc	s1,0x7
    1146:	37e4b483          	ld	s1,894(s1) # 84c0 <__SDATA_BEGIN__>
    114a:	fd840593          	addi	a1,s0,-40
    114e:	8526                	mv	a0,s1
    1150:	00004097          	auipc	ra,0x4
    1154:	594080e7          	jalr	1428(ra) # 56e4 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1158:	8526                	mv	a0,s1
    115a:	00004097          	auipc	ra,0x4
    115e:	562080e7          	jalr	1378(ra) # 56bc <pipe>

  exit(0);
    1162:	4501                	li	a0,0
    1164:	00004097          	auipc	ra,0x4
    1168:	548080e7          	jalr	1352(ra) # 56ac <exit>

000000000000116c <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    116c:	7139                	addi	sp,sp,-64
    116e:	fc06                	sd	ra,56(sp)
    1170:	f822                	sd	s0,48(sp)
    1172:	f426                	sd	s1,40(sp)
    1174:	f04a                	sd	s2,32(sp)
    1176:	ec4e                	sd	s3,24(sp)
    1178:	0080                	addi	s0,sp,64
    117a:	64b1                	lui	s1,0xc
    117c:	35048493          	addi	s1,s1,848 # c350 <buf+0x660>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1180:	597d                	li	s2,-1
    1182:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1186:	00005997          	auipc	s3,0x5
    118a:	f2298993          	addi	s3,s3,-222 # 60a8 <csem_up+0x3b2>
    argv[0] = (char*)0xffffffff;
    118e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1192:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1196:	fc040593          	addi	a1,s0,-64
    119a:	854e                	mv	a0,s3
    119c:	00004097          	auipc	ra,0x4
    11a0:	548080e7          	jalr	1352(ra) # 56e4 <exec>
  for(int i = 0; i < 50000; i++){
    11a4:	34fd                	addiw	s1,s1,-1
    11a6:	f4e5                	bnez	s1,118e <badarg+0x22>
  }
  
  exit(0);
    11a8:	4501                	li	a0,0
    11aa:	00004097          	auipc	ra,0x4
    11ae:	502080e7          	jalr	1282(ra) # 56ac <exit>

00000000000011b2 <copyinstr2>:
{
    11b2:	7155                	addi	sp,sp,-208
    11b4:	e586                	sd	ra,200(sp)
    11b6:	e1a2                	sd	s0,192(sp)
    11b8:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11ba:	f6840793          	addi	a5,s0,-152
    11be:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11c2:	07800713          	li	a4,120
    11c6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11ca:	0785                	addi	a5,a5,1
    11cc:	fed79de3          	bne	a5,a3,11c6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11d4:	f6840513          	addi	a0,s0,-152
    11d8:	00004097          	auipc	ra,0x4
    11dc:	524080e7          	jalr	1316(ra) # 56fc <unlink>
  if(ret != -1){
    11e0:	57fd                	li	a5,-1
    11e2:	0ef51063          	bne	a0,a5,12c2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11e6:	20100593          	li	a1,513
    11ea:	f6840513          	addi	a0,s0,-152
    11ee:	00004097          	auipc	ra,0x4
    11f2:	4fe080e7          	jalr	1278(ra) # 56ec <open>
  if(fd != -1){
    11f6:	57fd                	li	a5,-1
    11f8:	0ef51563          	bne	a0,a5,12e2 <copyinstr2+0x130>
  ret = link(b, b);
    11fc:	f6840593          	addi	a1,s0,-152
    1200:	852e                	mv	a0,a1
    1202:	00004097          	auipc	ra,0x4
    1206:	50a080e7          	jalr	1290(ra) # 570c <link>
  if(ret != -1){
    120a:	57fd                	li	a5,-1
    120c:	0ef51b63          	bne	a0,a5,1302 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1210:	00006797          	auipc	a5,0x6
    1214:	7a078793          	addi	a5,a5,1952 # 79b0 <csem_up+0x1cba>
    1218:	f4f43c23          	sd	a5,-168(s0)
    121c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1220:	f5840593          	addi	a1,s0,-168
    1224:	f6840513          	addi	a0,s0,-152
    1228:	00004097          	auipc	ra,0x4
    122c:	4bc080e7          	jalr	1212(ra) # 56e4 <exec>
  if(ret != -1){
    1230:	57fd                	li	a5,-1
    1232:	0ef51963          	bne	a0,a5,1324 <copyinstr2+0x172>
  int pid = fork();
    1236:	00004097          	auipc	ra,0x4
    123a:	46e080e7          	jalr	1134(ra) # 56a4 <fork>
  if(pid < 0){
    123e:	10054363          	bltz	a0,1344 <copyinstr2+0x192>
  if(pid == 0){
    1242:	12051463          	bnez	a0,136a <copyinstr2+0x1b8>
    1246:	00007797          	auipc	a5,0x7
    124a:	39278793          	addi	a5,a5,914 # 85d8 <big.0>
    124e:	00008697          	auipc	a3,0x8
    1252:	38a68693          	addi	a3,a3,906 # 95d8 <__global_pointer$+0x918>
      big[i] = 'x';
    1256:	07800713          	li	a4,120
    125a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    125e:	0785                	addi	a5,a5,1
    1260:	fed79de3          	bne	a5,a3,125a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1264:	00008797          	auipc	a5,0x8
    1268:	36078a23          	sb	zero,884(a5) # 95d8 <__global_pointer$+0x918>
    char *args2[] = { big, big, big, 0 };
    126c:	00007797          	auipc	a5,0x7
    1270:	e5478793          	addi	a5,a5,-428 # 80c0 <csem_up+0x23ca>
    1274:	6390                	ld	a2,0(a5)
    1276:	6794                	ld	a3,8(a5)
    1278:	6b98                	ld	a4,16(a5)
    127a:	6f9c                	ld	a5,24(a5)
    127c:	f2c43823          	sd	a2,-208(s0)
    1280:	f2d43c23          	sd	a3,-200(s0)
    1284:	f4e43023          	sd	a4,-192(s0)
    1288:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    128c:	f3040593          	addi	a1,s0,-208
    1290:	00005517          	auipc	a0,0x5
    1294:	e1850513          	addi	a0,a0,-488 # 60a8 <csem_up+0x3b2>
    1298:	00004097          	auipc	ra,0x4
    129c:	44c080e7          	jalr	1100(ra) # 56e4 <exec>
    if(ret != -1){
    12a0:	57fd                	li	a5,-1
    12a2:	0af50e63          	beq	a0,a5,135e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12a6:	55fd                	li	a1,-1
    12a8:	00005517          	auipc	a0,0x5
    12ac:	5e050513          	addi	a0,a0,1504 # 6888 <csem_up+0xb92>
    12b0:	00004097          	auipc	ra,0x4
    12b4:	7ce080e7          	jalr	1998(ra) # 5a7e <printf>
      exit(1);
    12b8:	4505                	li	a0,1
    12ba:	00004097          	auipc	ra,0x4
    12be:	3f2080e7          	jalr	1010(ra) # 56ac <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c2:	862a                	mv	a2,a0
    12c4:	f6840593          	addi	a1,s0,-152
    12c8:	00005517          	auipc	a0,0x5
    12cc:	53850513          	addi	a0,a0,1336 # 6800 <csem_up+0xb0a>
    12d0:	00004097          	auipc	ra,0x4
    12d4:	7ae080e7          	jalr	1966(ra) # 5a7e <printf>
    exit(1);
    12d8:	4505                	li	a0,1
    12da:	00004097          	auipc	ra,0x4
    12de:	3d2080e7          	jalr	978(ra) # 56ac <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e2:	862a                	mv	a2,a0
    12e4:	f6840593          	addi	a1,s0,-152
    12e8:	00005517          	auipc	a0,0x5
    12ec:	53850513          	addi	a0,a0,1336 # 6820 <csem_up+0xb2a>
    12f0:	00004097          	auipc	ra,0x4
    12f4:	78e080e7          	jalr	1934(ra) # 5a7e <printf>
    exit(1);
    12f8:	4505                	li	a0,1
    12fa:	00004097          	auipc	ra,0x4
    12fe:	3b2080e7          	jalr	946(ra) # 56ac <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1302:	86aa                	mv	a3,a0
    1304:	f6840613          	addi	a2,s0,-152
    1308:	85b2                	mv	a1,a2
    130a:	00005517          	auipc	a0,0x5
    130e:	53650513          	addi	a0,a0,1334 # 6840 <csem_up+0xb4a>
    1312:	00004097          	auipc	ra,0x4
    1316:	76c080e7          	jalr	1900(ra) # 5a7e <printf>
    exit(1);
    131a:	4505                	li	a0,1
    131c:	00004097          	auipc	ra,0x4
    1320:	390080e7          	jalr	912(ra) # 56ac <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1324:	567d                	li	a2,-1
    1326:	f6840593          	addi	a1,s0,-152
    132a:	00005517          	auipc	a0,0x5
    132e:	53e50513          	addi	a0,a0,1342 # 6868 <csem_up+0xb72>
    1332:	00004097          	auipc	ra,0x4
    1336:	74c080e7          	jalr	1868(ra) # 5a7e <printf>
    exit(1);
    133a:	4505                	li	a0,1
    133c:	00004097          	auipc	ra,0x4
    1340:	370080e7          	jalr	880(ra) # 56ac <exit>
    printf("fork failed\n");
    1344:	00006517          	auipc	a0,0x6
    1348:	9a450513          	addi	a0,a0,-1628 # 6ce8 <csem_up+0xff2>
    134c:	00004097          	auipc	ra,0x4
    1350:	732080e7          	jalr	1842(ra) # 5a7e <printf>
    exit(1);
    1354:	4505                	li	a0,1
    1356:	00004097          	auipc	ra,0x4
    135a:	356080e7          	jalr	854(ra) # 56ac <exit>
    exit(747); // OK
    135e:	2eb00513          	li	a0,747
    1362:	00004097          	auipc	ra,0x4
    1366:	34a080e7          	jalr	842(ra) # 56ac <exit>
  int st = 0;
    136a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    136e:	f5440513          	addi	a0,s0,-172
    1372:	00004097          	auipc	ra,0x4
    1376:	342080e7          	jalr	834(ra) # 56b4 <wait>
  if(st != 747){
    137a:	f5442703          	lw	a4,-172(s0)
    137e:	2eb00793          	li	a5,747
    1382:	00f71663          	bne	a4,a5,138e <copyinstr2+0x1dc>
}
    1386:	60ae                	ld	ra,200(sp)
    1388:	640e                	ld	s0,192(sp)
    138a:	6169                	addi	sp,sp,208
    138c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    138e:	00005517          	auipc	a0,0x5
    1392:	52250513          	addi	a0,a0,1314 # 68b0 <csem_up+0xbba>
    1396:	00004097          	auipc	ra,0x4
    139a:	6e8080e7          	jalr	1768(ra) # 5a7e <printf>
    exit(1);
    139e:	4505                	li	a0,1
    13a0:	00004097          	auipc	ra,0x4
    13a4:	30c080e7          	jalr	780(ra) # 56ac <exit>

00000000000013a8 <truncate3>:
{
    13a8:	7159                	addi	sp,sp,-112
    13aa:	f486                	sd	ra,104(sp)
    13ac:	f0a2                	sd	s0,96(sp)
    13ae:	eca6                	sd	s1,88(sp)
    13b0:	e8ca                	sd	s2,80(sp)
    13b2:	e4ce                	sd	s3,72(sp)
    13b4:	e0d2                	sd	s4,64(sp)
    13b6:	fc56                	sd	s5,56(sp)
    13b8:	1880                	addi	s0,sp,112
    13ba:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13bc:	60100593          	li	a1,1537
    13c0:	00005517          	auipc	a0,0x5
    13c4:	d4050513          	addi	a0,a0,-704 # 6100 <csem_up+0x40a>
    13c8:	00004097          	auipc	ra,0x4
    13cc:	324080e7          	jalr	804(ra) # 56ec <open>
    13d0:	00004097          	auipc	ra,0x4
    13d4:	304080e7          	jalr	772(ra) # 56d4 <close>
  pid = fork();
    13d8:	00004097          	auipc	ra,0x4
    13dc:	2cc080e7          	jalr	716(ra) # 56a4 <fork>
  if(pid < 0){
    13e0:	08054063          	bltz	a0,1460 <truncate3+0xb8>
  if(pid == 0){
    13e4:	e969                	bnez	a0,14b6 <truncate3+0x10e>
    13e6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13ea:	00005a17          	auipc	s4,0x5
    13ee:	d16a0a13          	addi	s4,s4,-746 # 6100 <csem_up+0x40a>
      int n = write(fd, "1234567890", 10);
    13f2:	00005a97          	auipc	s5,0x5
    13f6:	51ea8a93          	addi	s5,s5,1310 # 6910 <csem_up+0xc1a>
      int fd = open("truncfile", O_WRONLY);
    13fa:	4585                	li	a1,1
    13fc:	8552                	mv	a0,s4
    13fe:	00004097          	auipc	ra,0x4
    1402:	2ee080e7          	jalr	750(ra) # 56ec <open>
    1406:	84aa                	mv	s1,a0
      if(fd < 0){
    1408:	06054a63          	bltz	a0,147c <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    140c:	4629                	li	a2,10
    140e:	85d6                	mv	a1,s5
    1410:	00004097          	auipc	ra,0x4
    1414:	2bc080e7          	jalr	700(ra) # 56cc <write>
      if(n != 10){
    1418:	47a9                	li	a5,10
    141a:	06f51f63          	bne	a0,a5,1498 <truncate3+0xf0>
      close(fd);
    141e:	8526                	mv	a0,s1
    1420:	00004097          	auipc	ra,0x4
    1424:	2b4080e7          	jalr	692(ra) # 56d4 <close>
      fd = open("truncfile", O_RDONLY);
    1428:	4581                	li	a1,0
    142a:	8552                	mv	a0,s4
    142c:	00004097          	auipc	ra,0x4
    1430:	2c0080e7          	jalr	704(ra) # 56ec <open>
    1434:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1436:	02000613          	li	a2,32
    143a:	f9840593          	addi	a1,s0,-104
    143e:	00004097          	auipc	ra,0x4
    1442:	286080e7          	jalr	646(ra) # 56c4 <read>
      close(fd);
    1446:	8526                	mv	a0,s1
    1448:	00004097          	auipc	ra,0x4
    144c:	28c080e7          	jalr	652(ra) # 56d4 <close>
    for(int i = 0; i < 100; i++){
    1450:	39fd                	addiw	s3,s3,-1
    1452:	fa0994e3          	bnez	s3,13fa <truncate3+0x52>
    exit(0);
    1456:	4501                	li	a0,0
    1458:	00004097          	auipc	ra,0x4
    145c:	254080e7          	jalr	596(ra) # 56ac <exit>
    printf("%s: fork failed\n", s);
    1460:	85ca                	mv	a1,s2
    1462:	00005517          	auipc	a0,0x5
    1466:	47e50513          	addi	a0,a0,1150 # 68e0 <csem_up+0xbea>
    146a:	00004097          	auipc	ra,0x4
    146e:	614080e7          	jalr	1556(ra) # 5a7e <printf>
    exit(1);
    1472:	4505                	li	a0,1
    1474:	00004097          	auipc	ra,0x4
    1478:	238080e7          	jalr	568(ra) # 56ac <exit>
        printf("%s: open failed\n", s);
    147c:	85ca                	mv	a1,s2
    147e:	00005517          	auipc	a0,0x5
    1482:	47a50513          	addi	a0,a0,1146 # 68f8 <csem_up+0xc02>
    1486:	00004097          	auipc	ra,0x4
    148a:	5f8080e7          	jalr	1528(ra) # 5a7e <printf>
        exit(1);
    148e:	4505                	li	a0,1
    1490:	00004097          	auipc	ra,0x4
    1494:	21c080e7          	jalr	540(ra) # 56ac <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1498:	862a                	mv	a2,a0
    149a:	85ca                	mv	a1,s2
    149c:	00005517          	auipc	a0,0x5
    14a0:	48450513          	addi	a0,a0,1156 # 6920 <csem_up+0xc2a>
    14a4:	00004097          	auipc	ra,0x4
    14a8:	5da080e7          	jalr	1498(ra) # 5a7e <printf>
        exit(1);
    14ac:	4505                	li	a0,1
    14ae:	00004097          	auipc	ra,0x4
    14b2:	1fe080e7          	jalr	510(ra) # 56ac <exit>
    14b6:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14ba:	00005a17          	auipc	s4,0x5
    14be:	c46a0a13          	addi	s4,s4,-954 # 6100 <csem_up+0x40a>
    int n = write(fd, "xxx", 3);
    14c2:	00005a97          	auipc	s5,0x5
    14c6:	47ea8a93          	addi	s5,s5,1150 # 6940 <csem_up+0xc4a>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14ca:	60100593          	li	a1,1537
    14ce:	8552                	mv	a0,s4
    14d0:	00004097          	auipc	ra,0x4
    14d4:	21c080e7          	jalr	540(ra) # 56ec <open>
    14d8:	84aa                	mv	s1,a0
    if(fd < 0){
    14da:	04054763          	bltz	a0,1528 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14de:	460d                	li	a2,3
    14e0:	85d6                	mv	a1,s5
    14e2:	00004097          	auipc	ra,0x4
    14e6:	1ea080e7          	jalr	490(ra) # 56cc <write>
    if(n != 3){
    14ea:	478d                	li	a5,3
    14ec:	04f51c63          	bne	a0,a5,1544 <truncate3+0x19c>
    close(fd);
    14f0:	8526                	mv	a0,s1
    14f2:	00004097          	auipc	ra,0x4
    14f6:	1e2080e7          	jalr	482(ra) # 56d4 <close>
  for(int i = 0; i < 150; i++){
    14fa:	39fd                	addiw	s3,s3,-1
    14fc:	fc0997e3          	bnez	s3,14ca <truncate3+0x122>
  wait(&xstatus);
    1500:	fbc40513          	addi	a0,s0,-68
    1504:	00004097          	auipc	ra,0x4
    1508:	1b0080e7          	jalr	432(ra) # 56b4 <wait>
  unlink("truncfile");
    150c:	00005517          	auipc	a0,0x5
    1510:	bf450513          	addi	a0,a0,-1036 # 6100 <csem_up+0x40a>
    1514:	00004097          	auipc	ra,0x4
    1518:	1e8080e7          	jalr	488(ra) # 56fc <unlink>
  exit(xstatus);
    151c:	fbc42503          	lw	a0,-68(s0)
    1520:	00004097          	auipc	ra,0x4
    1524:	18c080e7          	jalr	396(ra) # 56ac <exit>
      printf("%s: open failed\n", s);
    1528:	85ca                	mv	a1,s2
    152a:	00005517          	auipc	a0,0x5
    152e:	3ce50513          	addi	a0,a0,974 # 68f8 <csem_up+0xc02>
    1532:	00004097          	auipc	ra,0x4
    1536:	54c080e7          	jalr	1356(ra) # 5a7e <printf>
      exit(1);
    153a:	4505                	li	a0,1
    153c:	00004097          	auipc	ra,0x4
    1540:	170080e7          	jalr	368(ra) # 56ac <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1544:	862a                	mv	a2,a0
    1546:	85ca                	mv	a1,s2
    1548:	00005517          	auipc	a0,0x5
    154c:	40050513          	addi	a0,a0,1024 # 6948 <csem_up+0xc52>
    1550:	00004097          	auipc	ra,0x4
    1554:	52e080e7          	jalr	1326(ra) # 5a7e <printf>
      exit(1);
    1558:	4505                	li	a0,1
    155a:	00004097          	auipc	ra,0x4
    155e:	152080e7          	jalr	338(ra) # 56ac <exit>

0000000000001562 <exectest>:
{
    1562:	715d                	addi	sp,sp,-80
    1564:	e486                	sd	ra,72(sp)
    1566:	e0a2                	sd	s0,64(sp)
    1568:	fc26                	sd	s1,56(sp)
    156a:	f84a                	sd	s2,48(sp)
    156c:	0880                	addi	s0,sp,80
    156e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1570:	00005797          	auipc	a5,0x5
    1574:	b3878793          	addi	a5,a5,-1224 # 60a8 <csem_up+0x3b2>
    1578:	fcf43023          	sd	a5,-64(s0)
    157c:	00005797          	auipc	a5,0x5
    1580:	3ec78793          	addi	a5,a5,1004 # 6968 <csem_up+0xc72>
    1584:	fcf43423          	sd	a5,-56(s0)
    1588:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    158c:	00005517          	auipc	a0,0x5
    1590:	3e450513          	addi	a0,a0,996 # 6970 <csem_up+0xc7a>
    1594:	00004097          	auipc	ra,0x4
    1598:	168080e7          	jalr	360(ra) # 56fc <unlink>
  pid = fork();
    159c:	00004097          	auipc	ra,0x4
    15a0:	108080e7          	jalr	264(ra) # 56a4 <fork>
  if(pid < 0) {
    15a4:	04054663          	bltz	a0,15f0 <exectest+0x8e>
    15a8:	84aa                	mv	s1,a0
  if(pid == 0) {
    15aa:	e959                	bnez	a0,1640 <exectest+0xde>
    close(1);
    15ac:	4505                	li	a0,1
    15ae:	00004097          	auipc	ra,0x4
    15b2:	126080e7          	jalr	294(ra) # 56d4 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15b6:	20100593          	li	a1,513
    15ba:	00005517          	auipc	a0,0x5
    15be:	3b650513          	addi	a0,a0,950 # 6970 <csem_up+0xc7a>
    15c2:	00004097          	auipc	ra,0x4
    15c6:	12a080e7          	jalr	298(ra) # 56ec <open>
    if(fd < 0) {
    15ca:	04054163          	bltz	a0,160c <exectest+0xaa>
    if(fd != 1) {
    15ce:	4785                	li	a5,1
    15d0:	04f50c63          	beq	a0,a5,1628 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15d4:	85ca                	mv	a1,s2
    15d6:	00005517          	auipc	a0,0x5
    15da:	3ba50513          	addi	a0,a0,954 # 6990 <csem_up+0xc9a>
    15de:	00004097          	auipc	ra,0x4
    15e2:	4a0080e7          	jalr	1184(ra) # 5a7e <printf>
      exit(1);
    15e6:	4505                	li	a0,1
    15e8:	00004097          	auipc	ra,0x4
    15ec:	0c4080e7          	jalr	196(ra) # 56ac <exit>
     printf("%s: fork failed\n", s);
    15f0:	85ca                	mv	a1,s2
    15f2:	00005517          	auipc	a0,0x5
    15f6:	2ee50513          	addi	a0,a0,750 # 68e0 <csem_up+0xbea>
    15fa:	00004097          	auipc	ra,0x4
    15fe:	484080e7          	jalr	1156(ra) # 5a7e <printf>
     exit(1);
    1602:	4505                	li	a0,1
    1604:	00004097          	auipc	ra,0x4
    1608:	0a8080e7          	jalr	168(ra) # 56ac <exit>
      printf("%s: create failed\n", s);
    160c:	85ca                	mv	a1,s2
    160e:	00005517          	auipc	a0,0x5
    1612:	36a50513          	addi	a0,a0,874 # 6978 <csem_up+0xc82>
    1616:	00004097          	auipc	ra,0x4
    161a:	468080e7          	jalr	1128(ra) # 5a7e <printf>
      exit(1);
    161e:	4505                	li	a0,1
    1620:	00004097          	auipc	ra,0x4
    1624:	08c080e7          	jalr	140(ra) # 56ac <exit>
    if(exec("echo", echoargv) < 0){
    1628:	fc040593          	addi	a1,s0,-64
    162c:	00005517          	auipc	a0,0x5
    1630:	a7c50513          	addi	a0,a0,-1412 # 60a8 <csem_up+0x3b2>
    1634:	00004097          	auipc	ra,0x4
    1638:	0b0080e7          	jalr	176(ra) # 56e4 <exec>
    163c:	02054163          	bltz	a0,165e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1640:	fdc40513          	addi	a0,s0,-36
    1644:	00004097          	auipc	ra,0x4
    1648:	070080e7          	jalr	112(ra) # 56b4 <wait>
    164c:	02951763          	bne	a0,s1,167a <exectest+0x118>
  if(xstatus != 0)
    1650:	fdc42503          	lw	a0,-36(s0)
    1654:	cd0d                	beqz	a0,168e <exectest+0x12c>
    exit(xstatus);
    1656:	00004097          	auipc	ra,0x4
    165a:	056080e7          	jalr	86(ra) # 56ac <exit>
      printf("%s: exec echo failed\n", s);
    165e:	85ca                	mv	a1,s2
    1660:	00005517          	auipc	a0,0x5
    1664:	34050513          	addi	a0,a0,832 # 69a0 <csem_up+0xcaa>
    1668:	00004097          	auipc	ra,0x4
    166c:	416080e7          	jalr	1046(ra) # 5a7e <printf>
      exit(1);
    1670:	4505                	li	a0,1
    1672:	00004097          	auipc	ra,0x4
    1676:	03a080e7          	jalr	58(ra) # 56ac <exit>
    printf("%s: wait failed!\n", s);
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	33c50513          	addi	a0,a0,828 # 69b8 <csem_up+0xcc2>
    1684:	00004097          	auipc	ra,0x4
    1688:	3fa080e7          	jalr	1018(ra) # 5a7e <printf>
    168c:	b7d1                	j	1650 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    168e:	4581                	li	a1,0
    1690:	00005517          	auipc	a0,0x5
    1694:	2e050513          	addi	a0,a0,736 # 6970 <csem_up+0xc7a>
    1698:	00004097          	auipc	ra,0x4
    169c:	054080e7          	jalr	84(ra) # 56ec <open>
  if(fd < 0) {
    16a0:	02054a63          	bltz	a0,16d4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16a4:	4609                	li	a2,2
    16a6:	fb840593          	addi	a1,s0,-72
    16aa:	00004097          	auipc	ra,0x4
    16ae:	01a080e7          	jalr	26(ra) # 56c4 <read>
    16b2:	4789                	li	a5,2
    16b4:	02f50e63          	beq	a0,a5,16f0 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16b8:	85ca                	mv	a1,s2
    16ba:	00005517          	auipc	a0,0x5
    16be:	d7e50513          	addi	a0,a0,-642 # 6438 <csem_up+0x742>
    16c2:	00004097          	auipc	ra,0x4
    16c6:	3bc080e7          	jalr	956(ra) # 5a7e <printf>
    exit(1);
    16ca:	4505                	li	a0,1
    16cc:	00004097          	auipc	ra,0x4
    16d0:	fe0080e7          	jalr	-32(ra) # 56ac <exit>
    printf("%s: open failed\n", s);
    16d4:	85ca                	mv	a1,s2
    16d6:	00005517          	auipc	a0,0x5
    16da:	22250513          	addi	a0,a0,546 # 68f8 <csem_up+0xc02>
    16de:	00004097          	auipc	ra,0x4
    16e2:	3a0080e7          	jalr	928(ra) # 5a7e <printf>
    exit(1);
    16e6:	4505                	li	a0,1
    16e8:	00004097          	auipc	ra,0x4
    16ec:	fc4080e7          	jalr	-60(ra) # 56ac <exit>
  unlink("echo-ok");
    16f0:	00005517          	auipc	a0,0x5
    16f4:	28050513          	addi	a0,a0,640 # 6970 <csem_up+0xc7a>
    16f8:	00004097          	auipc	ra,0x4
    16fc:	004080e7          	jalr	4(ra) # 56fc <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1700:	fb844703          	lbu	a4,-72(s0)
    1704:	04f00793          	li	a5,79
    1708:	00f71863          	bne	a4,a5,1718 <exectest+0x1b6>
    170c:	fb944703          	lbu	a4,-71(s0)
    1710:	04b00793          	li	a5,75
    1714:	02f70063          	beq	a4,a5,1734 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1718:	85ca                	mv	a1,s2
    171a:	00005517          	auipc	a0,0x5
    171e:	2b650513          	addi	a0,a0,694 # 69d0 <csem_up+0xcda>
    1722:	00004097          	auipc	ra,0x4
    1726:	35c080e7          	jalr	860(ra) # 5a7e <printf>
    exit(1);
    172a:	4505                	li	a0,1
    172c:	00004097          	auipc	ra,0x4
    1730:	f80080e7          	jalr	-128(ra) # 56ac <exit>
    exit(0);
    1734:	4501                	li	a0,0
    1736:	00004097          	auipc	ra,0x4
    173a:	f76080e7          	jalr	-138(ra) # 56ac <exit>

000000000000173e <pipe1>:
{
    173e:	711d                	addi	sp,sp,-96
    1740:	ec86                	sd	ra,88(sp)
    1742:	e8a2                	sd	s0,80(sp)
    1744:	e4a6                	sd	s1,72(sp)
    1746:	e0ca                	sd	s2,64(sp)
    1748:	fc4e                	sd	s3,56(sp)
    174a:	f852                	sd	s4,48(sp)
    174c:	f456                	sd	s5,40(sp)
    174e:	f05a                	sd	s6,32(sp)
    1750:	ec5e                	sd	s7,24(sp)
    1752:	1080                	addi	s0,sp,96
    1754:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1756:	fa840513          	addi	a0,s0,-88
    175a:	00004097          	auipc	ra,0x4
    175e:	f62080e7          	jalr	-158(ra) # 56bc <pipe>
    1762:	ed25                	bnez	a0,17da <pipe1+0x9c>
    1764:	84aa                	mv	s1,a0
  pid = fork();
    1766:	00004097          	auipc	ra,0x4
    176a:	f3e080e7          	jalr	-194(ra) # 56a4 <fork>
    176e:	8a2a                	mv	s4,a0
  if(pid == 0){
    1770:	c159                	beqz	a0,17f6 <pipe1+0xb8>
  } else if(pid > 0){
    1772:	16a05e63          	blez	a0,18ee <pipe1+0x1b0>
    close(fds[1]);
    1776:	fac42503          	lw	a0,-84(s0)
    177a:	00004097          	auipc	ra,0x4
    177e:	f5a080e7          	jalr	-166(ra) # 56d4 <close>
    total = 0;
    1782:	8a26                	mv	s4,s1
    cc = 1;
    1784:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1786:	0000aa97          	auipc	s5,0xa
    178a:	56aa8a93          	addi	s5,s5,1386 # bcf0 <buf>
      if(cc > sizeof(buf))
    178e:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1790:	864e                	mv	a2,s3
    1792:	85d6                	mv	a1,s5
    1794:	fa842503          	lw	a0,-88(s0)
    1798:	00004097          	auipc	ra,0x4
    179c:	f2c080e7          	jalr	-212(ra) # 56c4 <read>
    17a0:	10a05263          	blez	a0,18a4 <pipe1+0x166>
      for(i = 0; i < n; i++){
    17a4:	0000a717          	auipc	a4,0xa
    17a8:	54c70713          	addi	a4,a4,1356 # bcf0 <buf>
    17ac:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b0:	00074683          	lbu	a3,0(a4)
    17b4:	0ff4f793          	andi	a5,s1,255
    17b8:	2485                	addiw	s1,s1,1
    17ba:	0cf69163          	bne	a3,a5,187c <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17be:	0705                	addi	a4,a4,1
    17c0:	fec498e3          	bne	s1,a2,17b0 <pipe1+0x72>
      total += n;
    17c4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17c8:	0019979b          	slliw	a5,s3,0x1
    17cc:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17d0:	013b7363          	bgeu	s6,s3,17d6 <pipe1+0x98>
        cc = sizeof(buf);
    17d4:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17d6:	84b2                	mv	s1,a2
    17d8:	bf65                	j	1790 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17da:	85ca                	mv	a1,s2
    17dc:	00005517          	auipc	a0,0x5
    17e0:	20c50513          	addi	a0,a0,524 # 69e8 <csem_up+0xcf2>
    17e4:	00004097          	auipc	ra,0x4
    17e8:	29a080e7          	jalr	666(ra) # 5a7e <printf>
    exit(1);
    17ec:	4505                	li	a0,1
    17ee:	00004097          	auipc	ra,0x4
    17f2:	ebe080e7          	jalr	-322(ra) # 56ac <exit>
    close(fds[0]);
    17f6:	fa842503          	lw	a0,-88(s0)
    17fa:	00004097          	auipc	ra,0x4
    17fe:	eda080e7          	jalr	-294(ra) # 56d4 <close>
    for(n = 0; n < N; n++){
    1802:	0000ab17          	auipc	s6,0xa
    1806:	4eeb0b13          	addi	s6,s6,1262 # bcf0 <buf>
    180a:	416004bb          	negw	s1,s6
    180e:	0ff4f493          	andi	s1,s1,255
    1812:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1816:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1818:	6a85                	lui	s5,0x1
    181a:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x85>
{
    181e:	87da                	mv	a5,s6
        buf[i] = seq++;
    1820:	0097873b          	addw	a4,a5,s1
    1824:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1828:	0785                	addi	a5,a5,1
    182a:	fef99be3          	bne	s3,a5,1820 <pipe1+0xe2>
        buf[i] = seq++;
    182e:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1832:	40900613          	li	a2,1033
    1836:	85de                	mv	a1,s7
    1838:	fac42503          	lw	a0,-84(s0)
    183c:	00004097          	auipc	ra,0x4
    1840:	e90080e7          	jalr	-368(ra) # 56cc <write>
    1844:	40900793          	li	a5,1033
    1848:	00f51c63          	bne	a0,a5,1860 <pipe1+0x122>
    for(n = 0; n < N; n++){
    184c:	24a5                	addiw	s1,s1,9
    184e:	0ff4f493          	andi	s1,s1,255
    1852:	fd5a16e3          	bne	s4,s5,181e <pipe1+0xe0>
    exit(0);
    1856:	4501                	li	a0,0
    1858:	00004097          	auipc	ra,0x4
    185c:	e54080e7          	jalr	-428(ra) # 56ac <exit>
        printf("%s: pipe1 oops 1\n", s);
    1860:	85ca                	mv	a1,s2
    1862:	00005517          	auipc	a0,0x5
    1866:	19e50513          	addi	a0,a0,414 # 6a00 <csem_up+0xd0a>
    186a:	00004097          	auipc	ra,0x4
    186e:	214080e7          	jalr	532(ra) # 5a7e <printf>
        exit(1);
    1872:	4505                	li	a0,1
    1874:	00004097          	auipc	ra,0x4
    1878:	e38080e7          	jalr	-456(ra) # 56ac <exit>
          printf("%s: pipe1 oops 2\n", s);
    187c:	85ca                	mv	a1,s2
    187e:	00005517          	auipc	a0,0x5
    1882:	19a50513          	addi	a0,a0,410 # 6a18 <csem_up+0xd22>
    1886:	00004097          	auipc	ra,0x4
    188a:	1f8080e7          	jalr	504(ra) # 5a7e <printf>
}
    188e:	60e6                	ld	ra,88(sp)
    1890:	6446                	ld	s0,80(sp)
    1892:	64a6                	ld	s1,72(sp)
    1894:	6906                	ld	s2,64(sp)
    1896:	79e2                	ld	s3,56(sp)
    1898:	7a42                	ld	s4,48(sp)
    189a:	7aa2                	ld	s5,40(sp)
    189c:	7b02                	ld	s6,32(sp)
    189e:	6be2                	ld	s7,24(sp)
    18a0:	6125                	addi	sp,sp,96
    18a2:	8082                	ret
    if(total != N * SZ){
    18a4:	6785                	lui	a5,0x1
    18a6:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x85>
    18aa:	02fa0063          	beq	s4,a5,18ca <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18ae:	85d2                	mv	a1,s4
    18b0:	00005517          	auipc	a0,0x5
    18b4:	18050513          	addi	a0,a0,384 # 6a30 <csem_up+0xd3a>
    18b8:	00004097          	auipc	ra,0x4
    18bc:	1c6080e7          	jalr	454(ra) # 5a7e <printf>
      exit(1);
    18c0:	4505                	li	a0,1
    18c2:	00004097          	auipc	ra,0x4
    18c6:	dea080e7          	jalr	-534(ra) # 56ac <exit>
    close(fds[0]);
    18ca:	fa842503          	lw	a0,-88(s0)
    18ce:	00004097          	auipc	ra,0x4
    18d2:	e06080e7          	jalr	-506(ra) # 56d4 <close>
    wait(&xstatus);
    18d6:	fa440513          	addi	a0,s0,-92
    18da:	00004097          	auipc	ra,0x4
    18de:	dda080e7          	jalr	-550(ra) # 56b4 <wait>
    exit(xstatus);
    18e2:	fa442503          	lw	a0,-92(s0)
    18e6:	00004097          	auipc	ra,0x4
    18ea:	dc6080e7          	jalr	-570(ra) # 56ac <exit>
    printf("%s: fork() failed\n", s);
    18ee:	85ca                	mv	a1,s2
    18f0:	00005517          	auipc	a0,0x5
    18f4:	16050513          	addi	a0,a0,352 # 6a50 <csem_up+0xd5a>
    18f8:	00004097          	auipc	ra,0x4
    18fc:	186080e7          	jalr	390(ra) # 5a7e <printf>
    exit(1);
    1900:	4505                	li	a0,1
    1902:	00004097          	auipc	ra,0x4
    1906:	daa080e7          	jalr	-598(ra) # 56ac <exit>

000000000000190a <exitwait>:
{
    190a:	7139                	addi	sp,sp,-64
    190c:	fc06                	sd	ra,56(sp)
    190e:	f822                	sd	s0,48(sp)
    1910:	f426                	sd	s1,40(sp)
    1912:	f04a                	sd	s2,32(sp)
    1914:	ec4e                	sd	s3,24(sp)
    1916:	e852                	sd	s4,16(sp)
    1918:	0080                	addi	s0,sp,64
    191a:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    191c:	4901                	li	s2,0
    191e:	06400993          	li	s3,100
    pid = fork();
    1922:	00004097          	auipc	ra,0x4
    1926:	d82080e7          	jalr	-638(ra) # 56a4 <fork>
    192a:	84aa                	mv	s1,a0
    if(pid < 0){
    192c:	02054a63          	bltz	a0,1960 <exitwait+0x56>
    if(pid){
    1930:	c151                	beqz	a0,19b4 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1932:	fcc40513          	addi	a0,s0,-52
    1936:	00004097          	auipc	ra,0x4
    193a:	d7e080e7          	jalr	-642(ra) # 56b4 <wait>
    193e:	02951f63          	bne	a0,s1,197c <exitwait+0x72>
      if(i != xstate) {
    1942:	fcc42783          	lw	a5,-52(s0)
    1946:	05279963          	bne	a5,s2,1998 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    194a:	2905                	addiw	s2,s2,1
    194c:	fd391be3          	bne	s2,s3,1922 <exitwait+0x18>
}
    1950:	70e2                	ld	ra,56(sp)
    1952:	7442                	ld	s0,48(sp)
    1954:	74a2                	ld	s1,40(sp)
    1956:	7902                	ld	s2,32(sp)
    1958:	69e2                	ld	s3,24(sp)
    195a:	6a42                	ld	s4,16(sp)
    195c:	6121                	addi	sp,sp,64
    195e:	8082                	ret
      printf("%s: fork failed\n", s);
    1960:	85d2                	mv	a1,s4
    1962:	00005517          	auipc	a0,0x5
    1966:	f7e50513          	addi	a0,a0,-130 # 68e0 <csem_up+0xbea>
    196a:	00004097          	auipc	ra,0x4
    196e:	114080e7          	jalr	276(ra) # 5a7e <printf>
      exit(1);
    1972:	4505                	li	a0,1
    1974:	00004097          	auipc	ra,0x4
    1978:	d38080e7          	jalr	-712(ra) # 56ac <exit>
        printf("%s: wait wrong pid\n", s);
    197c:	85d2                	mv	a1,s4
    197e:	00005517          	auipc	a0,0x5
    1982:	0ea50513          	addi	a0,a0,234 # 6a68 <csem_up+0xd72>
    1986:	00004097          	auipc	ra,0x4
    198a:	0f8080e7          	jalr	248(ra) # 5a7e <printf>
        exit(1);
    198e:	4505                	li	a0,1
    1990:	00004097          	auipc	ra,0x4
    1994:	d1c080e7          	jalr	-740(ra) # 56ac <exit>
        printf("%s: wait wrong exit status\n", s);
    1998:	85d2                	mv	a1,s4
    199a:	00005517          	auipc	a0,0x5
    199e:	0e650513          	addi	a0,a0,230 # 6a80 <csem_up+0xd8a>
    19a2:	00004097          	auipc	ra,0x4
    19a6:	0dc080e7          	jalr	220(ra) # 5a7e <printf>
        exit(1);
    19aa:	4505                	li	a0,1
    19ac:	00004097          	auipc	ra,0x4
    19b0:	d00080e7          	jalr	-768(ra) # 56ac <exit>
      exit(i);
    19b4:	854a                	mv	a0,s2
    19b6:	00004097          	auipc	ra,0x4
    19ba:	cf6080e7          	jalr	-778(ra) # 56ac <exit>

00000000000019be <twochildren>:
{
    19be:	1101                	addi	sp,sp,-32
    19c0:	ec06                	sd	ra,24(sp)
    19c2:	e822                	sd	s0,16(sp)
    19c4:	e426                	sd	s1,8(sp)
    19c6:	e04a                	sd	s2,0(sp)
    19c8:	1000                	addi	s0,sp,32
    19ca:	892a                	mv	s2,a0
    19cc:	3e800493          	li	s1,1000
    int pid1 = fork();
    19d0:	00004097          	auipc	ra,0x4
    19d4:	cd4080e7          	jalr	-812(ra) # 56a4 <fork>
    if(pid1 < 0){
    19d8:	02054c63          	bltz	a0,1a10 <twochildren+0x52>
    if(pid1 == 0){
    19dc:	c921                	beqz	a0,1a2c <twochildren+0x6e>
      int pid2 = fork();
    19de:	00004097          	auipc	ra,0x4
    19e2:	cc6080e7          	jalr	-826(ra) # 56a4 <fork>
      if(pid2 < 0){
    19e6:	04054763          	bltz	a0,1a34 <twochildren+0x76>
      if(pid2 == 0){
    19ea:	c13d                	beqz	a0,1a50 <twochildren+0x92>
        wait(0);
    19ec:	4501                	li	a0,0
    19ee:	00004097          	auipc	ra,0x4
    19f2:	cc6080e7          	jalr	-826(ra) # 56b4 <wait>
        wait(0);
    19f6:	4501                	li	a0,0
    19f8:	00004097          	auipc	ra,0x4
    19fc:	cbc080e7          	jalr	-836(ra) # 56b4 <wait>
  for(int i = 0; i < 1000; i++){
    1a00:	34fd                	addiw	s1,s1,-1
    1a02:	f4f9                	bnez	s1,19d0 <twochildren+0x12>
}
    1a04:	60e2                	ld	ra,24(sp)
    1a06:	6442                	ld	s0,16(sp)
    1a08:	64a2                	ld	s1,8(sp)
    1a0a:	6902                	ld	s2,0(sp)
    1a0c:	6105                	addi	sp,sp,32
    1a0e:	8082                	ret
      printf("%s: fork failed\n", s);
    1a10:	85ca                	mv	a1,s2
    1a12:	00005517          	auipc	a0,0x5
    1a16:	ece50513          	addi	a0,a0,-306 # 68e0 <csem_up+0xbea>
    1a1a:	00004097          	auipc	ra,0x4
    1a1e:	064080e7          	jalr	100(ra) # 5a7e <printf>
      exit(1);
    1a22:	4505                	li	a0,1
    1a24:	00004097          	auipc	ra,0x4
    1a28:	c88080e7          	jalr	-888(ra) # 56ac <exit>
      exit(0);
    1a2c:	00004097          	auipc	ra,0x4
    1a30:	c80080e7          	jalr	-896(ra) # 56ac <exit>
        printf("%s: fork failed\n", s);
    1a34:	85ca                	mv	a1,s2
    1a36:	00005517          	auipc	a0,0x5
    1a3a:	eaa50513          	addi	a0,a0,-342 # 68e0 <csem_up+0xbea>
    1a3e:	00004097          	auipc	ra,0x4
    1a42:	040080e7          	jalr	64(ra) # 5a7e <printf>
        exit(1);
    1a46:	4505                	li	a0,1
    1a48:	00004097          	auipc	ra,0x4
    1a4c:	c64080e7          	jalr	-924(ra) # 56ac <exit>
        exit(0);
    1a50:	00004097          	auipc	ra,0x4
    1a54:	c5c080e7          	jalr	-932(ra) # 56ac <exit>

0000000000001a58 <forkfork>:
{
    1a58:	7179                	addi	sp,sp,-48
    1a5a:	f406                	sd	ra,40(sp)
    1a5c:	f022                	sd	s0,32(sp)
    1a5e:	ec26                	sd	s1,24(sp)
    1a60:	1800                	addi	s0,sp,48
    1a62:	84aa                	mv	s1,a0
    int pid = fork();
    1a64:	00004097          	auipc	ra,0x4
    1a68:	c40080e7          	jalr	-960(ra) # 56a4 <fork>
    if(pid < 0){
    1a6c:	04054163          	bltz	a0,1aae <forkfork+0x56>
    if(pid == 0){
    1a70:	cd29                	beqz	a0,1aca <forkfork+0x72>
    int pid = fork();
    1a72:	00004097          	auipc	ra,0x4
    1a76:	c32080e7          	jalr	-974(ra) # 56a4 <fork>
    if(pid < 0){
    1a7a:	02054a63          	bltz	a0,1aae <forkfork+0x56>
    if(pid == 0){
    1a7e:	c531                	beqz	a0,1aca <forkfork+0x72>
    wait(&xstatus);
    1a80:	fdc40513          	addi	a0,s0,-36
    1a84:	00004097          	auipc	ra,0x4
    1a88:	c30080e7          	jalr	-976(ra) # 56b4 <wait>
    if(xstatus != 0) {
    1a8c:	fdc42783          	lw	a5,-36(s0)
    1a90:	ebbd                	bnez	a5,1b06 <forkfork+0xae>
    wait(&xstatus);
    1a92:	fdc40513          	addi	a0,s0,-36
    1a96:	00004097          	auipc	ra,0x4
    1a9a:	c1e080e7          	jalr	-994(ra) # 56b4 <wait>
    if(xstatus != 0) {
    1a9e:	fdc42783          	lw	a5,-36(s0)
    1aa2:	e3b5                	bnez	a5,1b06 <forkfork+0xae>
}
    1aa4:	70a2                	ld	ra,40(sp)
    1aa6:	7402                	ld	s0,32(sp)
    1aa8:	64e2                	ld	s1,24(sp)
    1aaa:	6145                	addi	sp,sp,48
    1aac:	8082                	ret
      printf("%s: fork failed", s);
    1aae:	85a6                	mv	a1,s1
    1ab0:	00005517          	auipc	a0,0x5
    1ab4:	ff050513          	addi	a0,a0,-16 # 6aa0 <csem_up+0xdaa>
    1ab8:	00004097          	auipc	ra,0x4
    1abc:	fc6080e7          	jalr	-58(ra) # 5a7e <printf>
      exit(1);
    1ac0:	4505                	li	a0,1
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	bea080e7          	jalr	-1046(ra) # 56ac <exit>
{
    1aca:	0c800493          	li	s1,200
        int pid1 = fork();
    1ace:	00004097          	auipc	ra,0x4
    1ad2:	bd6080e7          	jalr	-1066(ra) # 56a4 <fork>
        if(pid1 < 0){
    1ad6:	00054f63          	bltz	a0,1af4 <forkfork+0x9c>
        if(pid1 == 0){
    1ada:	c115                	beqz	a0,1afe <forkfork+0xa6>
        wait(0);
    1adc:	4501                	li	a0,0
    1ade:	00004097          	auipc	ra,0x4
    1ae2:	bd6080e7          	jalr	-1066(ra) # 56b4 <wait>
      for(int j = 0; j < 200; j++){
    1ae6:	34fd                	addiw	s1,s1,-1
    1ae8:	f0fd                	bnez	s1,1ace <forkfork+0x76>
      exit(0);
    1aea:	4501                	li	a0,0
    1aec:	00004097          	auipc	ra,0x4
    1af0:	bc0080e7          	jalr	-1088(ra) # 56ac <exit>
          exit(1);
    1af4:	4505                	li	a0,1
    1af6:	00004097          	auipc	ra,0x4
    1afa:	bb6080e7          	jalr	-1098(ra) # 56ac <exit>
          exit(0);
    1afe:	00004097          	auipc	ra,0x4
    1b02:	bae080e7          	jalr	-1106(ra) # 56ac <exit>
      printf("%s: fork in child failed", s);
    1b06:	85a6                	mv	a1,s1
    1b08:	00005517          	auipc	a0,0x5
    1b0c:	fa850513          	addi	a0,a0,-88 # 6ab0 <csem_up+0xdba>
    1b10:	00004097          	auipc	ra,0x4
    1b14:	f6e080e7          	jalr	-146(ra) # 5a7e <printf>
      exit(1);
    1b18:	4505                	li	a0,1
    1b1a:	00004097          	auipc	ra,0x4
    1b1e:	b92080e7          	jalr	-1134(ra) # 56ac <exit>

0000000000001b22 <reparent2>:
{
    1b22:	1101                	addi	sp,sp,-32
    1b24:	ec06                	sd	ra,24(sp)
    1b26:	e822                	sd	s0,16(sp)
    1b28:	e426                	sd	s1,8(sp)
    1b2a:	1000                	addi	s0,sp,32
    1b2c:	32000493          	li	s1,800
    int pid1 = fork();
    1b30:	00004097          	auipc	ra,0x4
    1b34:	b74080e7          	jalr	-1164(ra) # 56a4 <fork>
    if(pid1 < 0){
    1b38:	00054f63          	bltz	a0,1b56 <reparent2+0x34>
    if(pid1 == 0){
    1b3c:	c915                	beqz	a0,1b70 <reparent2+0x4e>
    wait(0);
    1b3e:	4501                	li	a0,0
    1b40:	00004097          	auipc	ra,0x4
    1b44:	b74080e7          	jalr	-1164(ra) # 56b4 <wait>
  for(int i = 0; i < 800; i++){
    1b48:	34fd                	addiw	s1,s1,-1
    1b4a:	f0fd                	bnez	s1,1b30 <reparent2+0xe>
  exit(0);
    1b4c:	4501                	li	a0,0
    1b4e:	00004097          	auipc	ra,0x4
    1b52:	b5e080e7          	jalr	-1186(ra) # 56ac <exit>
      printf("fork failed\n");
    1b56:	00005517          	auipc	a0,0x5
    1b5a:	19250513          	addi	a0,a0,402 # 6ce8 <csem_up+0xff2>
    1b5e:	00004097          	auipc	ra,0x4
    1b62:	f20080e7          	jalr	-224(ra) # 5a7e <printf>
      exit(1);
    1b66:	4505                	li	a0,1
    1b68:	00004097          	auipc	ra,0x4
    1b6c:	b44080e7          	jalr	-1212(ra) # 56ac <exit>
      fork();
    1b70:	00004097          	auipc	ra,0x4
    1b74:	b34080e7          	jalr	-1228(ra) # 56a4 <fork>
      fork();
    1b78:	00004097          	auipc	ra,0x4
    1b7c:	b2c080e7          	jalr	-1236(ra) # 56a4 <fork>
      exit(0);
    1b80:	4501                	li	a0,0
    1b82:	00004097          	auipc	ra,0x4
    1b86:	b2a080e7          	jalr	-1238(ra) # 56ac <exit>

0000000000001b8a <createdelete>:
{
    1b8a:	7175                	addi	sp,sp,-144
    1b8c:	e506                	sd	ra,136(sp)
    1b8e:	e122                	sd	s0,128(sp)
    1b90:	fca6                	sd	s1,120(sp)
    1b92:	f8ca                	sd	s2,112(sp)
    1b94:	f4ce                	sd	s3,104(sp)
    1b96:	f0d2                	sd	s4,96(sp)
    1b98:	ecd6                	sd	s5,88(sp)
    1b9a:	e8da                	sd	s6,80(sp)
    1b9c:	e4de                	sd	s7,72(sp)
    1b9e:	e0e2                	sd	s8,64(sp)
    1ba0:	fc66                	sd	s9,56(sp)
    1ba2:	0900                	addi	s0,sp,144
    1ba4:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1ba6:	4901                	li	s2,0
    1ba8:	4991                	li	s3,4
    pid = fork();
    1baa:	00004097          	auipc	ra,0x4
    1bae:	afa080e7          	jalr	-1286(ra) # 56a4 <fork>
    1bb2:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb4:	02054f63          	bltz	a0,1bf2 <createdelete+0x68>
    if(pid == 0){
    1bb8:	c939                	beqz	a0,1c0e <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bba:	2905                	addiw	s2,s2,1
    1bbc:	ff3917e3          	bne	s2,s3,1baa <createdelete+0x20>
    1bc0:	4491                	li	s1,4
    wait(&xstatus);
    1bc2:	f7c40513          	addi	a0,s0,-132
    1bc6:	00004097          	auipc	ra,0x4
    1bca:	aee080e7          	jalr	-1298(ra) # 56b4 <wait>
    if(xstatus != 0)
    1bce:	f7c42903          	lw	s2,-132(s0)
    1bd2:	0e091263          	bnez	s2,1cb6 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bd6:	34fd                	addiw	s1,s1,-1
    1bd8:	f4ed                	bnez	s1,1bc2 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bda:	f8040123          	sb	zero,-126(s0)
    1bde:	03000993          	li	s3,48
    1be2:	5a7d                	li	s4,-1
    1be4:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1be8:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bea:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bec:	07400a93          	li	s5,116
    1bf0:	a29d                	j	1d56 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bf2:	85e6                	mv	a1,s9
    1bf4:	00005517          	auipc	a0,0x5
    1bf8:	0f450513          	addi	a0,a0,244 # 6ce8 <csem_up+0xff2>
    1bfc:	00004097          	auipc	ra,0x4
    1c00:	e82080e7          	jalr	-382(ra) # 5a7e <printf>
      exit(1);
    1c04:	4505                	li	a0,1
    1c06:	00004097          	auipc	ra,0x4
    1c0a:	aa6080e7          	jalr	-1370(ra) # 56ac <exit>
      name[0] = 'p' + pi;
    1c0e:	0709091b          	addiw	s2,s2,112
    1c12:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c16:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c1a:	4951                	li	s2,20
    1c1c:	a015                	j	1c40 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c1e:	85e6                	mv	a1,s9
    1c20:	00005517          	auipc	a0,0x5
    1c24:	d5850513          	addi	a0,a0,-680 # 6978 <csem_up+0xc82>
    1c28:	00004097          	auipc	ra,0x4
    1c2c:	e56080e7          	jalr	-426(ra) # 5a7e <printf>
          exit(1);
    1c30:	4505                	li	a0,1
    1c32:	00004097          	auipc	ra,0x4
    1c36:	a7a080e7          	jalr	-1414(ra) # 56ac <exit>
      for(i = 0; i < N; i++){
    1c3a:	2485                	addiw	s1,s1,1
    1c3c:	07248863          	beq	s1,s2,1cac <createdelete+0x122>
        name[1] = '0' + i;
    1c40:	0304879b          	addiw	a5,s1,48
    1c44:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c48:	20200593          	li	a1,514
    1c4c:	f8040513          	addi	a0,s0,-128
    1c50:	00004097          	auipc	ra,0x4
    1c54:	a9c080e7          	jalr	-1380(ra) # 56ec <open>
        if(fd < 0){
    1c58:	fc0543e3          	bltz	a0,1c1e <createdelete+0x94>
        close(fd);
    1c5c:	00004097          	auipc	ra,0x4
    1c60:	a78080e7          	jalr	-1416(ra) # 56d4 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c64:	fc905be3          	blez	s1,1c3a <createdelete+0xb0>
    1c68:	0014f793          	andi	a5,s1,1
    1c6c:	f7f9                	bnez	a5,1c3a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c6e:	01f4d79b          	srliw	a5,s1,0x1f
    1c72:	9fa5                	addw	a5,a5,s1
    1c74:	4017d79b          	sraiw	a5,a5,0x1
    1c78:	0307879b          	addiw	a5,a5,48
    1c7c:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c80:	f8040513          	addi	a0,s0,-128
    1c84:	00004097          	auipc	ra,0x4
    1c88:	a78080e7          	jalr	-1416(ra) # 56fc <unlink>
    1c8c:	fa0557e3          	bgez	a0,1c3a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c90:	85e6                	mv	a1,s9
    1c92:	00005517          	auipc	a0,0x5
    1c96:	e3e50513          	addi	a0,a0,-450 # 6ad0 <csem_up+0xdda>
    1c9a:	00004097          	auipc	ra,0x4
    1c9e:	de4080e7          	jalr	-540(ra) # 5a7e <printf>
            exit(1);
    1ca2:	4505                	li	a0,1
    1ca4:	00004097          	auipc	ra,0x4
    1ca8:	a08080e7          	jalr	-1528(ra) # 56ac <exit>
      exit(0);
    1cac:	4501                	li	a0,0
    1cae:	00004097          	auipc	ra,0x4
    1cb2:	9fe080e7          	jalr	-1538(ra) # 56ac <exit>
      exit(1);
    1cb6:	4505                	li	a0,1
    1cb8:	00004097          	auipc	ra,0x4
    1cbc:	9f4080e7          	jalr	-1548(ra) # 56ac <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc0:	f8040613          	addi	a2,s0,-128
    1cc4:	85e6                	mv	a1,s9
    1cc6:	00005517          	auipc	a0,0x5
    1cca:	e2250513          	addi	a0,a0,-478 # 6ae8 <csem_up+0xdf2>
    1cce:	00004097          	auipc	ra,0x4
    1cd2:	db0080e7          	jalr	-592(ra) # 5a7e <printf>
        exit(1);
    1cd6:	4505                	li	a0,1
    1cd8:	00004097          	auipc	ra,0x4
    1cdc:	9d4080e7          	jalr	-1580(ra) # 56ac <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ce0:	054b7163          	bgeu	s6,s4,1d22 <createdelete+0x198>
      if(fd >= 0)
    1ce4:	02055a63          	bgez	a0,1d18 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ce8:	2485                	addiw	s1,s1,1
    1cea:	0ff4f493          	andi	s1,s1,255
    1cee:	05548c63          	beq	s1,s5,1d46 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cf2:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cf6:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cfa:	4581                	li	a1,0
    1cfc:	f8040513          	addi	a0,s0,-128
    1d00:	00004097          	auipc	ra,0x4
    1d04:	9ec080e7          	jalr	-1556(ra) # 56ec <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d08:	00090463          	beqz	s2,1d10 <createdelete+0x186>
    1d0c:	fd2bdae3          	bge	s7,s2,1ce0 <createdelete+0x156>
    1d10:	fa0548e3          	bltz	a0,1cc0 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d14:	014b7963          	bgeu	s6,s4,1d26 <createdelete+0x19c>
        close(fd);
    1d18:	00004097          	auipc	ra,0x4
    1d1c:	9bc080e7          	jalr	-1604(ra) # 56d4 <close>
    1d20:	b7e1                	j	1ce8 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d22:	fc0543e3          	bltz	a0,1ce8 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d26:	f8040613          	addi	a2,s0,-128
    1d2a:	85e6                	mv	a1,s9
    1d2c:	00005517          	auipc	a0,0x5
    1d30:	de450513          	addi	a0,a0,-540 # 6b10 <csem_up+0xe1a>
    1d34:	00004097          	auipc	ra,0x4
    1d38:	d4a080e7          	jalr	-694(ra) # 5a7e <printf>
        exit(1);
    1d3c:	4505                	li	a0,1
    1d3e:	00004097          	auipc	ra,0x4
    1d42:	96e080e7          	jalr	-1682(ra) # 56ac <exit>
  for(i = 0; i < N; i++){
    1d46:	2905                	addiw	s2,s2,1
    1d48:	2a05                	addiw	s4,s4,1
    1d4a:	2985                	addiw	s3,s3,1
    1d4c:	0ff9f993          	andi	s3,s3,255
    1d50:	47d1                	li	a5,20
    1d52:	02f90a63          	beq	s2,a5,1d86 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d56:	84e2                	mv	s1,s8
    1d58:	bf69                	j	1cf2 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d5a:	2905                	addiw	s2,s2,1
    1d5c:	0ff97913          	andi	s2,s2,255
    1d60:	2985                	addiw	s3,s3,1
    1d62:	0ff9f993          	andi	s3,s3,255
    1d66:	03490863          	beq	s2,s4,1d96 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d6a:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d6c:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d70:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d74:	f8040513          	addi	a0,s0,-128
    1d78:	00004097          	auipc	ra,0x4
    1d7c:	984080e7          	jalr	-1660(ra) # 56fc <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d80:	34fd                	addiw	s1,s1,-1
    1d82:	f4ed                	bnez	s1,1d6c <createdelete+0x1e2>
    1d84:	bfd9                	j	1d5a <createdelete+0x1d0>
    1d86:	03000993          	li	s3,48
    1d8a:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d8e:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d90:	08400a13          	li	s4,132
    1d94:	bfd9                	j	1d6a <createdelete+0x1e0>
}
    1d96:	60aa                	ld	ra,136(sp)
    1d98:	640a                	ld	s0,128(sp)
    1d9a:	74e6                	ld	s1,120(sp)
    1d9c:	7946                	ld	s2,112(sp)
    1d9e:	79a6                	ld	s3,104(sp)
    1da0:	7a06                	ld	s4,96(sp)
    1da2:	6ae6                	ld	s5,88(sp)
    1da4:	6b46                	ld	s6,80(sp)
    1da6:	6ba6                	ld	s7,72(sp)
    1da8:	6c06                	ld	s8,64(sp)
    1daa:	7ce2                	ld	s9,56(sp)
    1dac:	6149                	addi	sp,sp,144
    1dae:	8082                	ret

0000000000001db0 <linkunlink>:
{
    1db0:	711d                	addi	sp,sp,-96
    1db2:	ec86                	sd	ra,88(sp)
    1db4:	e8a2                	sd	s0,80(sp)
    1db6:	e4a6                	sd	s1,72(sp)
    1db8:	e0ca                	sd	s2,64(sp)
    1dba:	fc4e                	sd	s3,56(sp)
    1dbc:	f852                	sd	s4,48(sp)
    1dbe:	f456                	sd	s5,40(sp)
    1dc0:	f05a                	sd	s6,32(sp)
    1dc2:	ec5e                	sd	s7,24(sp)
    1dc4:	e862                	sd	s8,16(sp)
    1dc6:	e466                	sd	s9,8(sp)
    1dc8:	1080                	addi	s0,sp,96
    1dca:	84aa                	mv	s1,a0
  unlink("x");
    1dcc:	00004517          	auipc	a0,0x4
    1dd0:	34c50513          	addi	a0,a0,844 # 6118 <csem_up+0x422>
    1dd4:	00004097          	auipc	ra,0x4
    1dd8:	928080e7          	jalr	-1752(ra) # 56fc <unlink>
  pid = fork();
    1ddc:	00004097          	auipc	ra,0x4
    1de0:	8c8080e7          	jalr	-1848(ra) # 56a4 <fork>
  if(pid < 0){
    1de4:	02054b63          	bltz	a0,1e1a <linkunlink+0x6a>
    1de8:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1dea:	4c85                	li	s9,1
    1dec:	e119                	bnez	a0,1df2 <linkunlink+0x42>
    1dee:	06100c93          	li	s9,97
    1df2:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1df6:	41c659b7          	lui	s3,0x41c65
    1dfa:	e6d9899b          	addiw	s3,s3,-403
    1dfe:	690d                	lui	s2,0x3
    1e00:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e04:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e06:	4b05                	li	s6,1
      unlink("x");
    1e08:	00004a97          	auipc	s5,0x4
    1e0c:	310a8a93          	addi	s5,s5,784 # 6118 <csem_up+0x422>
      link("cat", "x");
    1e10:	00005b97          	auipc	s7,0x5
    1e14:	d28b8b93          	addi	s7,s7,-728 # 6b38 <csem_up+0xe42>
    1e18:	a825                	j	1e50 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e1a:	85a6                	mv	a1,s1
    1e1c:	00005517          	auipc	a0,0x5
    1e20:	ac450513          	addi	a0,a0,-1340 # 68e0 <csem_up+0xbea>
    1e24:	00004097          	auipc	ra,0x4
    1e28:	c5a080e7          	jalr	-934(ra) # 5a7e <printf>
    exit(1);
    1e2c:	4505                	li	a0,1
    1e2e:	00004097          	auipc	ra,0x4
    1e32:	87e080e7          	jalr	-1922(ra) # 56ac <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e36:	20200593          	li	a1,514
    1e3a:	8556                	mv	a0,s5
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	8b0080e7          	jalr	-1872(ra) # 56ec <open>
    1e44:	00004097          	auipc	ra,0x4
    1e48:	890080e7          	jalr	-1904(ra) # 56d4 <close>
  for(i = 0; i < 100; i++){
    1e4c:	34fd                	addiw	s1,s1,-1
    1e4e:	c88d                	beqz	s1,1e80 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e50:	033c87bb          	mulw	a5,s9,s3
    1e54:	012787bb          	addw	a5,a5,s2
    1e58:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e5c:	0347f7bb          	remuw	a5,a5,s4
    1e60:	dbf9                	beqz	a5,1e36 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e62:	01678863          	beq	a5,s6,1e72 <linkunlink+0xc2>
      unlink("x");
    1e66:	8556                	mv	a0,s5
    1e68:	00004097          	auipc	ra,0x4
    1e6c:	894080e7          	jalr	-1900(ra) # 56fc <unlink>
    1e70:	bff1                	j	1e4c <linkunlink+0x9c>
      link("cat", "x");
    1e72:	85d6                	mv	a1,s5
    1e74:	855e                	mv	a0,s7
    1e76:	00004097          	auipc	ra,0x4
    1e7a:	896080e7          	jalr	-1898(ra) # 570c <link>
    1e7e:	b7f9                	j	1e4c <linkunlink+0x9c>
  if(pid)
    1e80:	020c0463          	beqz	s8,1ea8 <linkunlink+0xf8>
    wait(0);
    1e84:	4501                	li	a0,0
    1e86:	00004097          	auipc	ra,0x4
    1e8a:	82e080e7          	jalr	-2002(ra) # 56b4 <wait>
}
    1e8e:	60e6                	ld	ra,88(sp)
    1e90:	6446                	ld	s0,80(sp)
    1e92:	64a6                	ld	s1,72(sp)
    1e94:	6906                	ld	s2,64(sp)
    1e96:	79e2                	ld	s3,56(sp)
    1e98:	7a42                	ld	s4,48(sp)
    1e9a:	7aa2                	ld	s5,40(sp)
    1e9c:	7b02                	ld	s6,32(sp)
    1e9e:	6be2                	ld	s7,24(sp)
    1ea0:	6c42                	ld	s8,16(sp)
    1ea2:	6ca2                	ld	s9,8(sp)
    1ea4:	6125                	addi	sp,sp,96
    1ea6:	8082                	ret
    exit(0);
    1ea8:	4501                	li	a0,0
    1eaa:	00004097          	auipc	ra,0x4
    1eae:	802080e7          	jalr	-2046(ra) # 56ac <exit>

0000000000001eb2 <manywrites>:
{
    1eb2:	711d                	addi	sp,sp,-96
    1eb4:	ec86                	sd	ra,88(sp)
    1eb6:	e8a2                	sd	s0,80(sp)
    1eb8:	e4a6                	sd	s1,72(sp)
    1eba:	e0ca                	sd	s2,64(sp)
    1ebc:	fc4e                	sd	s3,56(sp)
    1ebe:	f852                	sd	s4,48(sp)
    1ec0:	f456                	sd	s5,40(sp)
    1ec2:	f05a                	sd	s6,32(sp)
    1ec4:	ec5e                	sd	s7,24(sp)
    1ec6:	1080                	addi	s0,sp,96
    1ec8:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1eca:	4981                	li	s3,0
    1ecc:	4911                	li	s2,4
    int pid = fork();
    1ece:	00003097          	auipc	ra,0x3
    1ed2:	7d6080e7          	jalr	2006(ra) # 56a4 <fork>
    1ed6:	84aa                	mv	s1,a0
    if(pid < 0){
    1ed8:	02054963          	bltz	a0,1f0a <manywrites+0x58>
    if(pid == 0){
    1edc:	c521                	beqz	a0,1f24 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1ede:	2985                	addiw	s3,s3,1
    1ee0:	ff2997e3          	bne	s3,s2,1ece <manywrites+0x1c>
    1ee4:	4491                	li	s1,4
    int st = 0;
    1ee6:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1eea:	fa840513          	addi	a0,s0,-88
    1eee:	00003097          	auipc	ra,0x3
    1ef2:	7c6080e7          	jalr	1990(ra) # 56b4 <wait>
    if(st != 0)
    1ef6:	fa842503          	lw	a0,-88(s0)
    1efa:	ed6d                	bnez	a0,1ff4 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1efc:	34fd                	addiw	s1,s1,-1
    1efe:	f4e5                	bnez	s1,1ee6 <manywrites+0x34>
  exit(0);
    1f00:	4501                	li	a0,0
    1f02:	00003097          	auipc	ra,0x3
    1f06:	7aa080e7          	jalr	1962(ra) # 56ac <exit>
      printf("fork failed\n");
    1f0a:	00005517          	auipc	a0,0x5
    1f0e:	dde50513          	addi	a0,a0,-546 # 6ce8 <csem_up+0xff2>
    1f12:	00004097          	auipc	ra,0x4
    1f16:	b6c080e7          	jalr	-1172(ra) # 5a7e <printf>
      exit(1);
    1f1a:	4505                	li	a0,1
    1f1c:	00003097          	auipc	ra,0x3
    1f20:	790080e7          	jalr	1936(ra) # 56ac <exit>
      name[0] = 'b';
    1f24:	06200793          	li	a5,98
    1f28:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f2c:	0619879b          	addiw	a5,s3,97
    1f30:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f34:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f38:	fa840513          	addi	a0,s0,-88
    1f3c:	00003097          	auipc	ra,0x3
    1f40:	7c0080e7          	jalr	1984(ra) # 56fc <unlink>
    1f44:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1f46:	0000ab17          	auipc	s6,0xa
    1f4a:	daab0b13          	addi	s6,s6,-598 # bcf0 <buf>
        for(int i = 0; i < ci+1; i++){
    1f4e:	8a26                	mv	s4,s1
    1f50:	0209ce63          	bltz	s3,1f8c <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f54:	20200593          	li	a1,514
    1f58:	fa840513          	addi	a0,s0,-88
    1f5c:	00003097          	auipc	ra,0x3
    1f60:	790080e7          	jalr	1936(ra) # 56ec <open>
    1f64:	892a                	mv	s2,a0
          if(fd < 0){
    1f66:	04054763          	bltz	a0,1fb4 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f6a:	660d                	lui	a2,0x3
    1f6c:	85da                	mv	a1,s6
    1f6e:	00003097          	auipc	ra,0x3
    1f72:	75e080e7          	jalr	1886(ra) # 56cc <write>
          if(cc != sz){
    1f76:	678d                	lui	a5,0x3
    1f78:	04f51e63          	bne	a0,a5,1fd4 <manywrites+0x122>
          close(fd);
    1f7c:	854a                	mv	a0,s2
    1f7e:	00003097          	auipc	ra,0x3
    1f82:	756080e7          	jalr	1878(ra) # 56d4 <close>
        for(int i = 0; i < ci+1; i++){
    1f86:	2a05                	addiw	s4,s4,1
    1f88:	fd49d6e3          	bge	s3,s4,1f54 <manywrites+0xa2>
        unlink(name);
    1f8c:	fa840513          	addi	a0,s0,-88
    1f90:	00003097          	auipc	ra,0x3
    1f94:	76c080e7          	jalr	1900(ra) # 56fc <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f98:	3bfd                	addiw	s7,s7,-1
    1f9a:	fa0b9ae3          	bnez	s7,1f4e <manywrites+0x9c>
      unlink(name);
    1f9e:	fa840513          	addi	a0,s0,-88
    1fa2:	00003097          	auipc	ra,0x3
    1fa6:	75a080e7          	jalr	1882(ra) # 56fc <unlink>
      exit(0);
    1faa:	4501                	li	a0,0
    1fac:	00003097          	auipc	ra,0x3
    1fb0:	700080e7          	jalr	1792(ra) # 56ac <exit>
            printf("%s: cannot create %s\n", s, name);
    1fb4:	fa840613          	addi	a2,s0,-88
    1fb8:	85d6                	mv	a1,s5
    1fba:	00005517          	auipc	a0,0x5
    1fbe:	b8650513          	addi	a0,a0,-1146 # 6b40 <csem_up+0xe4a>
    1fc2:	00004097          	auipc	ra,0x4
    1fc6:	abc080e7          	jalr	-1348(ra) # 5a7e <printf>
            exit(1);
    1fca:	4505                	li	a0,1
    1fcc:	00003097          	auipc	ra,0x3
    1fd0:	6e0080e7          	jalr	1760(ra) # 56ac <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fd4:	86aa                	mv	a3,a0
    1fd6:	660d                	lui	a2,0x3
    1fd8:	85d6                	mv	a1,s5
    1fda:	00004517          	auipc	a0,0x4
    1fde:	18e50513          	addi	a0,a0,398 # 6168 <csem_up+0x472>
    1fe2:	00004097          	auipc	ra,0x4
    1fe6:	a9c080e7          	jalr	-1380(ra) # 5a7e <printf>
            exit(1);
    1fea:	4505                	li	a0,1
    1fec:	00003097          	auipc	ra,0x3
    1ff0:	6c0080e7          	jalr	1728(ra) # 56ac <exit>
      exit(st);
    1ff4:	00003097          	auipc	ra,0x3
    1ff8:	6b8080e7          	jalr	1720(ra) # 56ac <exit>

0000000000001ffc <forktest>:
{
    1ffc:	7179                	addi	sp,sp,-48
    1ffe:	f406                	sd	ra,40(sp)
    2000:	f022                	sd	s0,32(sp)
    2002:	ec26                	sd	s1,24(sp)
    2004:	e84a                	sd	s2,16(sp)
    2006:	e44e                	sd	s3,8(sp)
    2008:	1800                	addi	s0,sp,48
    200a:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    200c:	4481                	li	s1,0
    200e:	3e800913          	li	s2,1000
    pid = fork();
    2012:	00003097          	auipc	ra,0x3
    2016:	692080e7          	jalr	1682(ra) # 56a4 <fork>
    if(pid < 0)
    201a:	02054863          	bltz	a0,204a <forktest+0x4e>
    if(pid == 0)
    201e:	c115                	beqz	a0,2042 <forktest+0x46>
  for(n=0; n<N; n++){
    2020:	2485                	addiw	s1,s1,1
    2022:	ff2498e3          	bne	s1,s2,2012 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2026:	85ce                	mv	a1,s3
    2028:	00005517          	auipc	a0,0x5
    202c:	b4850513          	addi	a0,a0,-1208 # 6b70 <csem_up+0xe7a>
    2030:	00004097          	auipc	ra,0x4
    2034:	a4e080e7          	jalr	-1458(ra) # 5a7e <printf>
    exit(1);
    2038:	4505                	li	a0,1
    203a:	00003097          	auipc	ra,0x3
    203e:	672080e7          	jalr	1650(ra) # 56ac <exit>
      exit(0);
    2042:	00003097          	auipc	ra,0x3
    2046:	66a080e7          	jalr	1642(ra) # 56ac <exit>
  if (n == 0) {
    204a:	cc9d                	beqz	s1,2088 <forktest+0x8c>
  if(n == N){
    204c:	3e800793          	li	a5,1000
    2050:	fcf48be3          	beq	s1,a5,2026 <forktest+0x2a>
  for(; n > 0; n--){
    2054:	00905b63          	blez	s1,206a <forktest+0x6e>
    if(wait(0) < 0){
    2058:	4501                	li	a0,0
    205a:	00003097          	auipc	ra,0x3
    205e:	65a080e7          	jalr	1626(ra) # 56b4 <wait>
    2062:	04054163          	bltz	a0,20a4 <forktest+0xa8>
  for(; n > 0; n--){
    2066:	34fd                	addiw	s1,s1,-1
    2068:	f8e5                	bnez	s1,2058 <forktest+0x5c>
  if(wait(0) != -1){
    206a:	4501                	li	a0,0
    206c:	00003097          	auipc	ra,0x3
    2070:	648080e7          	jalr	1608(ra) # 56b4 <wait>
    2074:	57fd                	li	a5,-1
    2076:	04f51563          	bne	a0,a5,20c0 <forktest+0xc4>
}
    207a:	70a2                	ld	ra,40(sp)
    207c:	7402                	ld	s0,32(sp)
    207e:	64e2                	ld	s1,24(sp)
    2080:	6942                	ld	s2,16(sp)
    2082:	69a2                	ld	s3,8(sp)
    2084:	6145                	addi	sp,sp,48
    2086:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2088:	85ce                	mv	a1,s3
    208a:	00005517          	auipc	a0,0x5
    208e:	ace50513          	addi	a0,a0,-1330 # 6b58 <csem_up+0xe62>
    2092:	00004097          	auipc	ra,0x4
    2096:	9ec080e7          	jalr	-1556(ra) # 5a7e <printf>
    exit(1);
    209a:	4505                	li	a0,1
    209c:	00003097          	auipc	ra,0x3
    20a0:	610080e7          	jalr	1552(ra) # 56ac <exit>
      printf("%s: wait stopped early\n", s);
    20a4:	85ce                	mv	a1,s3
    20a6:	00005517          	auipc	a0,0x5
    20aa:	af250513          	addi	a0,a0,-1294 # 6b98 <csem_up+0xea2>
    20ae:	00004097          	auipc	ra,0x4
    20b2:	9d0080e7          	jalr	-1584(ra) # 5a7e <printf>
      exit(1);
    20b6:	4505                	li	a0,1
    20b8:	00003097          	auipc	ra,0x3
    20bc:	5f4080e7          	jalr	1524(ra) # 56ac <exit>
    printf("%s: wait got too many\n", s);
    20c0:	85ce                	mv	a1,s3
    20c2:	00005517          	auipc	a0,0x5
    20c6:	aee50513          	addi	a0,a0,-1298 # 6bb0 <csem_up+0xeba>
    20ca:	00004097          	auipc	ra,0x4
    20ce:	9b4080e7          	jalr	-1612(ra) # 5a7e <printf>
    exit(1);
    20d2:	4505                	li	a0,1
    20d4:	00003097          	auipc	ra,0x3
    20d8:	5d8080e7          	jalr	1496(ra) # 56ac <exit>

00000000000020dc <kernmem>:
{
    20dc:	715d                	addi	sp,sp,-80
    20de:	e486                	sd	ra,72(sp)
    20e0:	e0a2                	sd	s0,64(sp)
    20e2:	fc26                	sd	s1,56(sp)
    20e4:	f84a                	sd	s2,48(sp)
    20e6:	f44e                	sd	s3,40(sp)
    20e8:	f052                	sd	s4,32(sp)
    20ea:	ec56                	sd	s5,24(sp)
    20ec:	0880                	addi	s0,sp,80
    20ee:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f0:	4485                	li	s1,1
    20f2:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    20f4:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f6:	69b1                	lui	s3,0xc
    20f8:	35098993          	addi	s3,s3,848 # c350 <buf+0x660>
    20fc:	1003d937          	lui	s2,0x1003d
    2100:	090e                	slli	s2,s2,0x3
    2102:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e780>
    pid = fork();
    2106:	00003097          	auipc	ra,0x3
    210a:	59e080e7          	jalr	1438(ra) # 56a4 <fork>
    if(pid < 0){
    210e:	02054963          	bltz	a0,2140 <kernmem+0x64>
    if(pid == 0){
    2112:	c529                	beqz	a0,215c <kernmem+0x80>
    wait(&xstatus);
    2114:	fbc40513          	addi	a0,s0,-68
    2118:	00003097          	auipc	ra,0x3
    211c:	59c080e7          	jalr	1436(ra) # 56b4 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2120:	fbc42783          	lw	a5,-68(s0)
    2124:	05579d63          	bne	a5,s5,217e <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2128:	94ce                	add	s1,s1,s3
    212a:	fd249ee3          	bne	s1,s2,2106 <kernmem+0x2a>
}
    212e:	60a6                	ld	ra,72(sp)
    2130:	6406                	ld	s0,64(sp)
    2132:	74e2                	ld	s1,56(sp)
    2134:	7942                	ld	s2,48(sp)
    2136:	79a2                	ld	s3,40(sp)
    2138:	7a02                	ld	s4,32(sp)
    213a:	6ae2                	ld	s5,24(sp)
    213c:	6161                	addi	sp,sp,80
    213e:	8082                	ret
      printf("%s: fork failed\n", s);
    2140:	85d2                	mv	a1,s4
    2142:	00004517          	auipc	a0,0x4
    2146:	79e50513          	addi	a0,a0,1950 # 68e0 <csem_up+0xbea>
    214a:	00004097          	auipc	ra,0x4
    214e:	934080e7          	jalr	-1740(ra) # 5a7e <printf>
      exit(1);
    2152:	4505                	li	a0,1
    2154:	00003097          	auipc	ra,0x3
    2158:	558080e7          	jalr	1368(ra) # 56ac <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    215c:	0004c683          	lbu	a3,0(s1)
    2160:	8626                	mv	a2,s1
    2162:	85d2                	mv	a1,s4
    2164:	00005517          	auipc	a0,0x5
    2168:	a6450513          	addi	a0,a0,-1436 # 6bc8 <csem_up+0xed2>
    216c:	00004097          	auipc	ra,0x4
    2170:	912080e7          	jalr	-1774(ra) # 5a7e <printf>
      exit(1);
    2174:	4505                	li	a0,1
    2176:	00003097          	auipc	ra,0x3
    217a:	536080e7          	jalr	1334(ra) # 56ac <exit>
      exit(1);
    217e:	4505                	li	a0,1
    2180:	00003097          	auipc	ra,0x3
    2184:	52c080e7          	jalr	1324(ra) # 56ac <exit>

0000000000002188 <bigargtest>:
{
    2188:	7179                	addi	sp,sp,-48
    218a:	f406                	sd	ra,40(sp)
    218c:	f022                	sd	s0,32(sp)
    218e:	ec26                	sd	s1,24(sp)
    2190:	1800                	addi	s0,sp,48
    2192:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2194:	00005517          	auipc	a0,0x5
    2198:	a5450513          	addi	a0,a0,-1452 # 6be8 <csem_up+0xef2>
    219c:	00003097          	auipc	ra,0x3
    21a0:	560080e7          	jalr	1376(ra) # 56fc <unlink>
  pid = fork();
    21a4:	00003097          	auipc	ra,0x3
    21a8:	500080e7          	jalr	1280(ra) # 56a4 <fork>
  if(pid == 0){
    21ac:	c121                	beqz	a0,21ec <bigargtest+0x64>
  } else if(pid < 0){
    21ae:	0a054063          	bltz	a0,224e <bigargtest+0xc6>
  wait(&xstatus);
    21b2:	fdc40513          	addi	a0,s0,-36
    21b6:	00003097          	auipc	ra,0x3
    21ba:	4fe080e7          	jalr	1278(ra) # 56b4 <wait>
  if(xstatus != 0)
    21be:	fdc42503          	lw	a0,-36(s0)
    21c2:	e545                	bnez	a0,226a <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    21c4:	4581                	li	a1,0
    21c6:	00005517          	auipc	a0,0x5
    21ca:	a2250513          	addi	a0,a0,-1502 # 6be8 <csem_up+0xef2>
    21ce:	00003097          	auipc	ra,0x3
    21d2:	51e080e7          	jalr	1310(ra) # 56ec <open>
  if(fd < 0){
    21d6:	08054e63          	bltz	a0,2272 <bigargtest+0xea>
  close(fd);
    21da:	00003097          	auipc	ra,0x3
    21de:	4fa080e7          	jalr	1274(ra) # 56d4 <close>
}
    21e2:	70a2                	ld	ra,40(sp)
    21e4:	7402                	ld	s0,32(sp)
    21e6:	64e2                	ld	s1,24(sp)
    21e8:	6145                	addi	sp,sp,48
    21ea:	8082                	ret
    21ec:	00006797          	auipc	a5,0x6
    21f0:	2ec78793          	addi	a5,a5,748 # 84d8 <args.1>
    21f4:	00006697          	auipc	a3,0x6
    21f8:	3dc68693          	addi	a3,a3,988 # 85d0 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    21fc:	00005717          	auipc	a4,0x5
    2200:	9fc70713          	addi	a4,a4,-1540 # 6bf8 <csem_up+0xf02>
    2204:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2206:	07a1                	addi	a5,a5,8
    2208:	fed79ee3          	bne	a5,a3,2204 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    220c:	00006597          	auipc	a1,0x6
    2210:	2cc58593          	addi	a1,a1,716 # 84d8 <args.1>
    2214:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2218:	00004517          	auipc	a0,0x4
    221c:	e9050513          	addi	a0,a0,-368 # 60a8 <csem_up+0x3b2>
    2220:	00003097          	auipc	ra,0x3
    2224:	4c4080e7          	jalr	1220(ra) # 56e4 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2228:	20000593          	li	a1,512
    222c:	00005517          	auipc	a0,0x5
    2230:	9bc50513          	addi	a0,a0,-1604 # 6be8 <csem_up+0xef2>
    2234:	00003097          	auipc	ra,0x3
    2238:	4b8080e7          	jalr	1208(ra) # 56ec <open>
    close(fd);
    223c:	00003097          	auipc	ra,0x3
    2240:	498080e7          	jalr	1176(ra) # 56d4 <close>
    exit(0);
    2244:	4501                	li	a0,0
    2246:	00003097          	auipc	ra,0x3
    224a:	466080e7          	jalr	1126(ra) # 56ac <exit>
    printf("%s: bigargtest: fork failed\n", s);
    224e:	85a6                	mv	a1,s1
    2250:	00005517          	auipc	a0,0x5
    2254:	a8850513          	addi	a0,a0,-1400 # 6cd8 <csem_up+0xfe2>
    2258:	00004097          	auipc	ra,0x4
    225c:	826080e7          	jalr	-2010(ra) # 5a7e <printf>
    exit(1);
    2260:	4505                	li	a0,1
    2262:	00003097          	auipc	ra,0x3
    2266:	44a080e7          	jalr	1098(ra) # 56ac <exit>
    exit(xstatus);
    226a:	00003097          	auipc	ra,0x3
    226e:	442080e7          	jalr	1090(ra) # 56ac <exit>
    printf("%s: bigarg test failed!\n", s);
    2272:	85a6                	mv	a1,s1
    2274:	00005517          	auipc	a0,0x5
    2278:	a8450513          	addi	a0,a0,-1404 # 6cf8 <csem_up+0x1002>
    227c:	00004097          	auipc	ra,0x4
    2280:	802080e7          	jalr	-2046(ra) # 5a7e <printf>
    exit(1);
    2284:	4505                	li	a0,1
    2286:	00003097          	auipc	ra,0x3
    228a:	426080e7          	jalr	1062(ra) # 56ac <exit>

000000000000228e <stacktest>:
{
    228e:	7179                	addi	sp,sp,-48
    2290:	f406                	sd	ra,40(sp)
    2292:	f022                	sd	s0,32(sp)
    2294:	ec26                	sd	s1,24(sp)
    2296:	1800                	addi	s0,sp,48
    2298:	84aa                	mv	s1,a0
  pid = fork();
    229a:	00003097          	auipc	ra,0x3
    229e:	40a080e7          	jalr	1034(ra) # 56a4 <fork>
  if(pid == 0) {
    22a2:	c115                	beqz	a0,22c6 <stacktest+0x38>
  } else if(pid < 0){
    22a4:	04054463          	bltz	a0,22ec <stacktest+0x5e>
  wait(&xstatus);
    22a8:	fdc40513          	addi	a0,s0,-36
    22ac:	00003097          	auipc	ra,0x3
    22b0:	408080e7          	jalr	1032(ra) # 56b4 <wait>
  if(xstatus == -1)  // kernel killed child?
    22b4:	fdc42503          	lw	a0,-36(s0)
    22b8:	57fd                	li	a5,-1
    22ba:	04f50763          	beq	a0,a5,2308 <stacktest+0x7a>
    exit(xstatus);
    22be:	00003097          	auipc	ra,0x3
    22c2:	3ee080e7          	jalr	1006(ra) # 56ac <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    22c6:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    22c8:	77fd                	lui	a5,0xfffff
    22ca:	97ba                	add	a5,a5,a4
    22cc:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0300>
    22d0:	85a6                	mv	a1,s1
    22d2:	00005517          	auipc	a0,0x5
    22d6:	a4650513          	addi	a0,a0,-1466 # 6d18 <csem_up+0x1022>
    22da:	00003097          	auipc	ra,0x3
    22de:	7a4080e7          	jalr	1956(ra) # 5a7e <printf>
    exit(1);
    22e2:	4505                	li	a0,1
    22e4:	00003097          	auipc	ra,0x3
    22e8:	3c8080e7          	jalr	968(ra) # 56ac <exit>
    printf("%s: fork failed\n", s);
    22ec:	85a6                	mv	a1,s1
    22ee:	00004517          	auipc	a0,0x4
    22f2:	5f250513          	addi	a0,a0,1522 # 68e0 <csem_up+0xbea>
    22f6:	00003097          	auipc	ra,0x3
    22fa:	788080e7          	jalr	1928(ra) # 5a7e <printf>
    exit(1);
    22fe:	4505                	li	a0,1
    2300:	00003097          	auipc	ra,0x3
    2304:	3ac080e7          	jalr	940(ra) # 56ac <exit>
    exit(0);
    2308:	4501                	li	a0,0
    230a:	00003097          	auipc	ra,0x3
    230e:	3a2080e7          	jalr	930(ra) # 56ac <exit>

0000000000002312 <copyinstr3>:
{
    2312:	7179                	addi	sp,sp,-48
    2314:	f406                	sd	ra,40(sp)
    2316:	f022                	sd	s0,32(sp)
    2318:	ec26                	sd	s1,24(sp)
    231a:	1800                	addi	s0,sp,48
  sbrk(8192);
    231c:	6509                	lui	a0,0x2
    231e:	00003097          	auipc	ra,0x3
    2322:	416080e7          	jalr	1046(ra) # 5734 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2326:	4501                	li	a0,0
    2328:	00003097          	auipc	ra,0x3
    232c:	40c080e7          	jalr	1036(ra) # 5734 <sbrk>
  if((top % PGSIZE) != 0){
    2330:	03451793          	slli	a5,a0,0x34
    2334:	e3c9                	bnez	a5,23b6 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2336:	4501                	li	a0,0
    2338:	00003097          	auipc	ra,0x3
    233c:	3fc080e7          	jalr	1020(ra) # 5734 <sbrk>
  if(top % PGSIZE){
    2340:	03451793          	slli	a5,a0,0x34
    2344:	e3d9                	bnez	a5,23ca <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2346:	fff50493          	addi	s1,a0,-1 # 1fff <forktest+0x3>
  *b = 'x';
    234a:	07800793          	li	a5,120
    234e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2352:	8526                	mv	a0,s1
    2354:	00003097          	auipc	ra,0x3
    2358:	3a8080e7          	jalr	936(ra) # 56fc <unlink>
  if(ret != -1){
    235c:	57fd                	li	a5,-1
    235e:	08f51363          	bne	a0,a5,23e4 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2362:	20100593          	li	a1,513
    2366:	8526                	mv	a0,s1
    2368:	00003097          	auipc	ra,0x3
    236c:	384080e7          	jalr	900(ra) # 56ec <open>
  if(fd != -1){
    2370:	57fd                	li	a5,-1
    2372:	08f51863          	bne	a0,a5,2402 <copyinstr3+0xf0>
  ret = link(b, b);
    2376:	85a6                	mv	a1,s1
    2378:	8526                	mv	a0,s1
    237a:	00003097          	auipc	ra,0x3
    237e:	392080e7          	jalr	914(ra) # 570c <link>
  if(ret != -1){
    2382:	57fd                	li	a5,-1
    2384:	08f51e63          	bne	a0,a5,2420 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2388:	00005797          	auipc	a5,0x5
    238c:	62878793          	addi	a5,a5,1576 # 79b0 <csem_up+0x1cba>
    2390:	fcf43823          	sd	a5,-48(s0)
    2394:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2398:	fd040593          	addi	a1,s0,-48
    239c:	8526                	mv	a0,s1
    239e:	00003097          	auipc	ra,0x3
    23a2:	346080e7          	jalr	838(ra) # 56e4 <exec>
  if(ret != -1){
    23a6:	57fd                	li	a5,-1
    23a8:	08f51c63          	bne	a0,a5,2440 <copyinstr3+0x12e>
}
    23ac:	70a2                	ld	ra,40(sp)
    23ae:	7402                	ld	s0,32(sp)
    23b0:	64e2                	ld	s1,24(sp)
    23b2:	6145                	addi	sp,sp,48
    23b4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    23b6:	0347d513          	srli	a0,a5,0x34
    23ba:	6785                	lui	a5,0x1
    23bc:	40a7853b          	subw	a0,a5,a0
    23c0:	00003097          	auipc	ra,0x3
    23c4:	374080e7          	jalr	884(ra) # 5734 <sbrk>
    23c8:	b7bd                	j	2336 <copyinstr3+0x24>
    printf("oops\n");
    23ca:	00005517          	auipc	a0,0x5
    23ce:	97650513          	addi	a0,a0,-1674 # 6d40 <csem_up+0x104a>
    23d2:	00003097          	auipc	ra,0x3
    23d6:	6ac080e7          	jalr	1708(ra) # 5a7e <printf>
    exit(1);
    23da:	4505                	li	a0,1
    23dc:	00003097          	auipc	ra,0x3
    23e0:	2d0080e7          	jalr	720(ra) # 56ac <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    23e4:	862a                	mv	a2,a0
    23e6:	85a6                	mv	a1,s1
    23e8:	00004517          	auipc	a0,0x4
    23ec:	41850513          	addi	a0,a0,1048 # 6800 <csem_up+0xb0a>
    23f0:	00003097          	auipc	ra,0x3
    23f4:	68e080e7          	jalr	1678(ra) # 5a7e <printf>
    exit(1);
    23f8:	4505                	li	a0,1
    23fa:	00003097          	auipc	ra,0x3
    23fe:	2b2080e7          	jalr	690(ra) # 56ac <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2402:	862a                	mv	a2,a0
    2404:	85a6                	mv	a1,s1
    2406:	00004517          	auipc	a0,0x4
    240a:	41a50513          	addi	a0,a0,1050 # 6820 <csem_up+0xb2a>
    240e:	00003097          	auipc	ra,0x3
    2412:	670080e7          	jalr	1648(ra) # 5a7e <printf>
    exit(1);
    2416:	4505                	li	a0,1
    2418:	00003097          	auipc	ra,0x3
    241c:	294080e7          	jalr	660(ra) # 56ac <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2420:	86aa                	mv	a3,a0
    2422:	8626                	mv	a2,s1
    2424:	85a6                	mv	a1,s1
    2426:	00004517          	auipc	a0,0x4
    242a:	41a50513          	addi	a0,a0,1050 # 6840 <csem_up+0xb4a>
    242e:	00003097          	auipc	ra,0x3
    2432:	650080e7          	jalr	1616(ra) # 5a7e <printf>
    exit(1);
    2436:	4505                	li	a0,1
    2438:	00003097          	auipc	ra,0x3
    243c:	274080e7          	jalr	628(ra) # 56ac <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2440:	567d                	li	a2,-1
    2442:	85a6                	mv	a1,s1
    2444:	00004517          	auipc	a0,0x4
    2448:	42450513          	addi	a0,a0,1060 # 6868 <csem_up+0xb72>
    244c:	00003097          	auipc	ra,0x3
    2450:	632080e7          	jalr	1586(ra) # 5a7e <printf>
    exit(1);
    2454:	4505                	li	a0,1
    2456:	00003097          	auipc	ra,0x3
    245a:	256080e7          	jalr	598(ra) # 56ac <exit>

000000000000245e <rwsbrk>:
{
    245e:	1101                	addi	sp,sp,-32
    2460:	ec06                	sd	ra,24(sp)
    2462:	e822                	sd	s0,16(sp)
    2464:	e426                	sd	s1,8(sp)
    2466:	e04a                	sd	s2,0(sp)
    2468:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    246a:	6509                	lui	a0,0x2
    246c:	00003097          	auipc	ra,0x3
    2470:	2c8080e7          	jalr	712(ra) # 5734 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2474:	57fd                	li	a5,-1
    2476:	06f50363          	beq	a0,a5,24dc <rwsbrk+0x7e>
    247a:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    247c:	7579                	lui	a0,0xffffe
    247e:	00003097          	auipc	ra,0x3
    2482:	2b6080e7          	jalr	694(ra) # 5734 <sbrk>
    2486:	57fd                	li	a5,-1
    2488:	06f50763          	beq	a0,a5,24f6 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    248c:	20100593          	li	a1,513
    2490:	00004517          	auipc	a0,0x4
    2494:	92850513          	addi	a0,a0,-1752 # 5db8 <csem_up+0xc2>
    2498:	00003097          	auipc	ra,0x3
    249c:	254080e7          	jalr	596(ra) # 56ec <open>
    24a0:	892a                	mv	s2,a0
  if(fd < 0){
    24a2:	06054763          	bltz	a0,2510 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    24a6:	6505                	lui	a0,0x1
    24a8:	94aa                	add	s1,s1,a0
    24aa:	40000613          	li	a2,1024
    24ae:	85a6                	mv	a1,s1
    24b0:	854a                	mv	a0,s2
    24b2:	00003097          	auipc	ra,0x3
    24b6:	21a080e7          	jalr	538(ra) # 56cc <write>
    24ba:	862a                	mv	a2,a0
  if(n >= 0){
    24bc:	06054763          	bltz	a0,252a <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    24c0:	85a6                	mv	a1,s1
    24c2:	00005517          	auipc	a0,0x5
    24c6:	8d650513          	addi	a0,a0,-1834 # 6d98 <csem_up+0x10a2>
    24ca:	00003097          	auipc	ra,0x3
    24ce:	5b4080e7          	jalr	1460(ra) # 5a7e <printf>
    exit(1);
    24d2:	4505                	li	a0,1
    24d4:	00003097          	auipc	ra,0x3
    24d8:	1d8080e7          	jalr	472(ra) # 56ac <exit>
    printf("sbrk(rwsbrk) failed\n");
    24dc:	00005517          	auipc	a0,0x5
    24e0:	86c50513          	addi	a0,a0,-1940 # 6d48 <csem_up+0x1052>
    24e4:	00003097          	auipc	ra,0x3
    24e8:	59a080e7          	jalr	1434(ra) # 5a7e <printf>
    exit(1);
    24ec:	4505                	li	a0,1
    24ee:	00003097          	auipc	ra,0x3
    24f2:	1be080e7          	jalr	446(ra) # 56ac <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    24f6:	00005517          	auipc	a0,0x5
    24fa:	86a50513          	addi	a0,a0,-1942 # 6d60 <csem_up+0x106a>
    24fe:	00003097          	auipc	ra,0x3
    2502:	580080e7          	jalr	1408(ra) # 5a7e <printf>
    exit(1);
    2506:	4505                	li	a0,1
    2508:	00003097          	auipc	ra,0x3
    250c:	1a4080e7          	jalr	420(ra) # 56ac <exit>
    printf("open(rwsbrk) failed\n");
    2510:	00005517          	auipc	a0,0x5
    2514:	87050513          	addi	a0,a0,-1936 # 6d80 <csem_up+0x108a>
    2518:	00003097          	auipc	ra,0x3
    251c:	566080e7          	jalr	1382(ra) # 5a7e <printf>
    exit(1);
    2520:	4505                	li	a0,1
    2522:	00003097          	auipc	ra,0x3
    2526:	18a080e7          	jalr	394(ra) # 56ac <exit>
  close(fd);
    252a:	854a                	mv	a0,s2
    252c:	00003097          	auipc	ra,0x3
    2530:	1a8080e7          	jalr	424(ra) # 56d4 <close>
  unlink("rwsbrk");
    2534:	00004517          	auipc	a0,0x4
    2538:	88450513          	addi	a0,a0,-1916 # 5db8 <csem_up+0xc2>
    253c:	00003097          	auipc	ra,0x3
    2540:	1c0080e7          	jalr	448(ra) # 56fc <unlink>
  fd = open("README", O_RDONLY);
    2544:	4581                	li	a1,0
    2546:	00004517          	auipc	a0,0x4
    254a:	cfa50513          	addi	a0,a0,-774 # 6240 <csem_up+0x54a>
    254e:	00003097          	auipc	ra,0x3
    2552:	19e080e7          	jalr	414(ra) # 56ec <open>
    2556:	892a                	mv	s2,a0
  if(fd < 0){
    2558:	02054963          	bltz	a0,258a <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    255c:	4629                	li	a2,10
    255e:	85a6                	mv	a1,s1
    2560:	00003097          	auipc	ra,0x3
    2564:	164080e7          	jalr	356(ra) # 56c4 <read>
    2568:	862a                	mv	a2,a0
  if(n >= 0){
    256a:	02054d63          	bltz	a0,25a4 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    256e:	85a6                	mv	a1,s1
    2570:	00005517          	auipc	a0,0x5
    2574:	85850513          	addi	a0,a0,-1960 # 6dc8 <csem_up+0x10d2>
    2578:	00003097          	auipc	ra,0x3
    257c:	506080e7          	jalr	1286(ra) # 5a7e <printf>
    exit(1);
    2580:	4505                	li	a0,1
    2582:	00003097          	auipc	ra,0x3
    2586:	12a080e7          	jalr	298(ra) # 56ac <exit>
    printf("open(rwsbrk) failed\n");
    258a:	00004517          	auipc	a0,0x4
    258e:	7f650513          	addi	a0,a0,2038 # 6d80 <csem_up+0x108a>
    2592:	00003097          	auipc	ra,0x3
    2596:	4ec080e7          	jalr	1260(ra) # 5a7e <printf>
    exit(1);
    259a:	4505                	li	a0,1
    259c:	00003097          	auipc	ra,0x3
    25a0:	110080e7          	jalr	272(ra) # 56ac <exit>
  close(fd);
    25a4:	854a                	mv	a0,s2
    25a6:	00003097          	auipc	ra,0x3
    25aa:	12e080e7          	jalr	302(ra) # 56d4 <close>
  exit(0);
    25ae:	4501                	li	a0,0
    25b0:	00003097          	auipc	ra,0x3
    25b4:	0fc080e7          	jalr	252(ra) # 56ac <exit>

00000000000025b8 <sbrkbasic>:
{
    25b8:	7139                	addi	sp,sp,-64
    25ba:	fc06                	sd	ra,56(sp)
    25bc:	f822                	sd	s0,48(sp)
    25be:	f426                	sd	s1,40(sp)
    25c0:	f04a                	sd	s2,32(sp)
    25c2:	ec4e                	sd	s3,24(sp)
    25c4:	e852                	sd	s4,16(sp)
    25c6:	0080                	addi	s0,sp,64
    25c8:	8a2a                	mv	s4,a0
  pid = fork();
    25ca:	00003097          	auipc	ra,0x3
    25ce:	0da080e7          	jalr	218(ra) # 56a4 <fork>
  if(pid < 0){
    25d2:	02054c63          	bltz	a0,260a <sbrkbasic+0x52>
  if(pid == 0){
    25d6:	ed21                	bnez	a0,262e <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    25d8:	40000537          	lui	a0,0x40000
    25dc:	00003097          	auipc	ra,0x3
    25e0:	158080e7          	jalr	344(ra) # 5734 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    25e4:	57fd                	li	a5,-1
    25e6:	02f50f63          	beq	a0,a5,2624 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25ea:	400007b7          	lui	a5,0x40000
    25ee:	97aa                	add	a5,a5,a0
      *b = 99;
    25f0:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    25f4:	6705                	lui	a4,0x1
      *b = 99;
    25f6:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1300>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25fa:	953a                	add	a0,a0,a4
    25fc:	fef51de3          	bne	a0,a5,25f6 <sbrkbasic+0x3e>
    exit(1);
    2600:	4505                	li	a0,1
    2602:	00003097          	auipc	ra,0x3
    2606:	0aa080e7          	jalr	170(ra) # 56ac <exit>
    printf("fork failed in sbrkbasic\n");
    260a:	00004517          	auipc	a0,0x4
    260e:	7e650513          	addi	a0,a0,2022 # 6df0 <csem_up+0x10fa>
    2612:	00003097          	auipc	ra,0x3
    2616:	46c080e7          	jalr	1132(ra) # 5a7e <printf>
    exit(1);
    261a:	4505                	li	a0,1
    261c:	00003097          	auipc	ra,0x3
    2620:	090080e7          	jalr	144(ra) # 56ac <exit>
      exit(0);
    2624:	4501                	li	a0,0
    2626:	00003097          	auipc	ra,0x3
    262a:	086080e7          	jalr	134(ra) # 56ac <exit>
  wait(&xstatus);
    262e:	fcc40513          	addi	a0,s0,-52
    2632:	00003097          	auipc	ra,0x3
    2636:	082080e7          	jalr	130(ra) # 56b4 <wait>
  if(xstatus == 1){
    263a:	fcc42703          	lw	a4,-52(s0)
    263e:	4785                	li	a5,1
    2640:	00f70d63          	beq	a4,a5,265a <sbrkbasic+0xa2>
  a = sbrk(0);
    2644:	4501                	li	a0,0
    2646:	00003097          	auipc	ra,0x3
    264a:	0ee080e7          	jalr	238(ra) # 5734 <sbrk>
    264e:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2650:	4901                	li	s2,0
    2652:	6985                	lui	s3,0x1
    2654:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1d6>
    2658:	a005                	j	2678 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    265a:	85d2                	mv	a1,s4
    265c:	00004517          	auipc	a0,0x4
    2660:	7b450513          	addi	a0,a0,1972 # 6e10 <csem_up+0x111a>
    2664:	00003097          	auipc	ra,0x3
    2668:	41a080e7          	jalr	1050(ra) # 5a7e <printf>
    exit(1);
    266c:	4505                	li	a0,1
    266e:	00003097          	auipc	ra,0x3
    2672:	03e080e7          	jalr	62(ra) # 56ac <exit>
    a = b + 1;
    2676:	84be                	mv	s1,a5
    b = sbrk(1);
    2678:	4505                	li	a0,1
    267a:	00003097          	auipc	ra,0x3
    267e:	0ba080e7          	jalr	186(ra) # 5734 <sbrk>
    if(b != a){
    2682:	04951c63          	bne	a0,s1,26da <sbrkbasic+0x122>
    *b = 1;
    2686:	4785                	li	a5,1
    2688:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    268c:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2690:	2905                	addiw	s2,s2,1
    2692:	ff3912e3          	bne	s2,s3,2676 <sbrkbasic+0xbe>
  pid = fork();
    2696:	00003097          	auipc	ra,0x3
    269a:	00e080e7          	jalr	14(ra) # 56a4 <fork>
    269e:	892a                	mv	s2,a0
  if(pid < 0){
    26a0:	04054d63          	bltz	a0,26fa <sbrkbasic+0x142>
  c = sbrk(1);
    26a4:	4505                	li	a0,1
    26a6:	00003097          	auipc	ra,0x3
    26aa:	08e080e7          	jalr	142(ra) # 5734 <sbrk>
  c = sbrk(1);
    26ae:	4505                	li	a0,1
    26b0:	00003097          	auipc	ra,0x3
    26b4:	084080e7          	jalr	132(ra) # 5734 <sbrk>
  if(c != a + 1){
    26b8:	0489                	addi	s1,s1,2
    26ba:	04a48e63          	beq	s1,a0,2716 <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    26be:	85d2                	mv	a1,s4
    26c0:	00004517          	auipc	a0,0x4
    26c4:	7b050513          	addi	a0,a0,1968 # 6e70 <csem_up+0x117a>
    26c8:	00003097          	auipc	ra,0x3
    26cc:	3b6080e7          	jalr	950(ra) # 5a7e <printf>
    exit(1);
    26d0:	4505                	li	a0,1
    26d2:	00003097          	auipc	ra,0x3
    26d6:	fda080e7          	jalr	-38(ra) # 56ac <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    26da:	86aa                	mv	a3,a0
    26dc:	8626                	mv	a2,s1
    26de:	85ca                	mv	a1,s2
    26e0:	00004517          	auipc	a0,0x4
    26e4:	75050513          	addi	a0,a0,1872 # 6e30 <csem_up+0x113a>
    26e8:	00003097          	auipc	ra,0x3
    26ec:	396080e7          	jalr	918(ra) # 5a7e <printf>
      exit(1);
    26f0:	4505                	li	a0,1
    26f2:	00003097          	auipc	ra,0x3
    26f6:	fba080e7          	jalr	-70(ra) # 56ac <exit>
    printf("%s: sbrk test fork failed\n", s);
    26fa:	85d2                	mv	a1,s4
    26fc:	00004517          	auipc	a0,0x4
    2700:	75450513          	addi	a0,a0,1876 # 6e50 <csem_up+0x115a>
    2704:	00003097          	auipc	ra,0x3
    2708:	37a080e7          	jalr	890(ra) # 5a7e <printf>
    exit(1);
    270c:	4505                	li	a0,1
    270e:	00003097          	auipc	ra,0x3
    2712:	f9e080e7          	jalr	-98(ra) # 56ac <exit>
  if(pid == 0)
    2716:	00091763          	bnez	s2,2724 <sbrkbasic+0x16c>
    exit(0);
    271a:	4501                	li	a0,0
    271c:	00003097          	auipc	ra,0x3
    2720:	f90080e7          	jalr	-112(ra) # 56ac <exit>
  wait(&xstatus);
    2724:	fcc40513          	addi	a0,s0,-52
    2728:	00003097          	auipc	ra,0x3
    272c:	f8c080e7          	jalr	-116(ra) # 56b4 <wait>
  exit(xstatus);
    2730:	fcc42503          	lw	a0,-52(s0)
    2734:	00003097          	auipc	ra,0x3
    2738:	f78080e7          	jalr	-136(ra) # 56ac <exit>

000000000000273c <sbrkmuch>:
{
    273c:	7179                	addi	sp,sp,-48
    273e:	f406                	sd	ra,40(sp)
    2740:	f022                	sd	s0,32(sp)
    2742:	ec26                	sd	s1,24(sp)
    2744:	e84a                	sd	s2,16(sp)
    2746:	e44e                	sd	s3,8(sp)
    2748:	e052                	sd	s4,0(sp)
    274a:	1800                	addi	s0,sp,48
    274c:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    274e:	4501                	li	a0,0
    2750:	00003097          	auipc	ra,0x3
    2754:	fe4080e7          	jalr	-28(ra) # 5734 <sbrk>
    2758:	892a                	mv	s2,a0
  a = sbrk(0);
    275a:	4501                	li	a0,0
    275c:	00003097          	auipc	ra,0x3
    2760:	fd8080e7          	jalr	-40(ra) # 5734 <sbrk>
    2764:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2766:	06400537          	lui	a0,0x6400
    276a:	9d05                	subw	a0,a0,s1
    276c:	00003097          	auipc	ra,0x3
    2770:	fc8080e7          	jalr	-56(ra) # 5734 <sbrk>
  if (p != a) {
    2774:	0ca49863          	bne	s1,a0,2844 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2778:	4501                	li	a0,0
    277a:	00003097          	auipc	ra,0x3
    277e:	fba080e7          	jalr	-70(ra) # 5734 <sbrk>
    2782:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2784:	00a4f963          	bgeu	s1,a0,2796 <sbrkmuch+0x5a>
    *pp = 1;
    2788:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    278a:	6705                	lui	a4,0x1
    *pp = 1;
    278c:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2790:	94ba                	add	s1,s1,a4
    2792:	fef4ede3          	bltu	s1,a5,278c <sbrkmuch+0x50>
  *lastaddr = 99;
    2796:	064007b7          	lui	a5,0x6400
    279a:	06300713          	li	a4,99
    279e:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f12ff>
  a = sbrk(0);
    27a2:	4501                	li	a0,0
    27a4:	00003097          	auipc	ra,0x3
    27a8:	f90080e7          	jalr	-112(ra) # 5734 <sbrk>
    27ac:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    27ae:	757d                	lui	a0,0xfffff
    27b0:	00003097          	auipc	ra,0x3
    27b4:	f84080e7          	jalr	-124(ra) # 5734 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    27b8:	57fd                	li	a5,-1
    27ba:	0af50363          	beq	a0,a5,2860 <sbrkmuch+0x124>
  c = sbrk(0);
    27be:	4501                	li	a0,0
    27c0:	00003097          	auipc	ra,0x3
    27c4:	f74080e7          	jalr	-140(ra) # 5734 <sbrk>
  if(c != a - PGSIZE){
    27c8:	77fd                	lui	a5,0xfffff
    27ca:	97a6                	add	a5,a5,s1
    27cc:	0af51863          	bne	a0,a5,287c <sbrkmuch+0x140>
  a = sbrk(0);
    27d0:	4501                	li	a0,0
    27d2:	00003097          	auipc	ra,0x3
    27d6:	f62080e7          	jalr	-158(ra) # 5734 <sbrk>
    27da:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    27dc:	6505                	lui	a0,0x1
    27de:	00003097          	auipc	ra,0x3
    27e2:	f56080e7          	jalr	-170(ra) # 5734 <sbrk>
    27e6:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    27e8:	0aa49a63          	bne	s1,a0,289c <sbrkmuch+0x160>
    27ec:	4501                	li	a0,0
    27ee:	00003097          	auipc	ra,0x3
    27f2:	f46080e7          	jalr	-186(ra) # 5734 <sbrk>
    27f6:	6785                	lui	a5,0x1
    27f8:	97a6                	add	a5,a5,s1
    27fa:	0af51163          	bne	a0,a5,289c <sbrkmuch+0x160>
  if(*lastaddr == 99){
    27fe:	064007b7          	lui	a5,0x6400
    2802:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f12ff>
    2806:	06300793          	li	a5,99
    280a:	0af70963          	beq	a4,a5,28bc <sbrkmuch+0x180>
  a = sbrk(0);
    280e:	4501                	li	a0,0
    2810:	00003097          	auipc	ra,0x3
    2814:	f24080e7          	jalr	-220(ra) # 5734 <sbrk>
    2818:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    281a:	4501                	li	a0,0
    281c:	00003097          	auipc	ra,0x3
    2820:	f18080e7          	jalr	-232(ra) # 5734 <sbrk>
    2824:	40a9053b          	subw	a0,s2,a0
    2828:	00003097          	auipc	ra,0x3
    282c:	f0c080e7          	jalr	-244(ra) # 5734 <sbrk>
  if(c != a){
    2830:	0aa49463          	bne	s1,a0,28d8 <sbrkmuch+0x19c>
}
    2834:	70a2                	ld	ra,40(sp)
    2836:	7402                	ld	s0,32(sp)
    2838:	64e2                	ld	s1,24(sp)
    283a:	6942                	ld	s2,16(sp)
    283c:	69a2                	ld	s3,8(sp)
    283e:	6a02                	ld	s4,0(sp)
    2840:	6145                	addi	sp,sp,48
    2842:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2844:	85ce                	mv	a1,s3
    2846:	00004517          	auipc	a0,0x4
    284a:	64a50513          	addi	a0,a0,1610 # 6e90 <csem_up+0x119a>
    284e:	00003097          	auipc	ra,0x3
    2852:	230080e7          	jalr	560(ra) # 5a7e <printf>
    exit(1);
    2856:	4505                	li	a0,1
    2858:	00003097          	auipc	ra,0x3
    285c:	e54080e7          	jalr	-428(ra) # 56ac <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2860:	85ce                	mv	a1,s3
    2862:	00004517          	auipc	a0,0x4
    2866:	67650513          	addi	a0,a0,1654 # 6ed8 <csem_up+0x11e2>
    286a:	00003097          	auipc	ra,0x3
    286e:	214080e7          	jalr	532(ra) # 5a7e <printf>
    exit(1);
    2872:	4505                	li	a0,1
    2874:	00003097          	auipc	ra,0x3
    2878:	e38080e7          	jalr	-456(ra) # 56ac <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    287c:	86aa                	mv	a3,a0
    287e:	8626                	mv	a2,s1
    2880:	85ce                	mv	a1,s3
    2882:	00004517          	auipc	a0,0x4
    2886:	67650513          	addi	a0,a0,1654 # 6ef8 <csem_up+0x1202>
    288a:	00003097          	auipc	ra,0x3
    288e:	1f4080e7          	jalr	500(ra) # 5a7e <printf>
    exit(1);
    2892:	4505                	li	a0,1
    2894:	00003097          	auipc	ra,0x3
    2898:	e18080e7          	jalr	-488(ra) # 56ac <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    289c:	86d2                	mv	a3,s4
    289e:	8626                	mv	a2,s1
    28a0:	85ce                	mv	a1,s3
    28a2:	00004517          	auipc	a0,0x4
    28a6:	69650513          	addi	a0,a0,1686 # 6f38 <csem_up+0x1242>
    28aa:	00003097          	auipc	ra,0x3
    28ae:	1d4080e7          	jalr	468(ra) # 5a7e <printf>
    exit(1);
    28b2:	4505                	li	a0,1
    28b4:	00003097          	auipc	ra,0x3
    28b8:	df8080e7          	jalr	-520(ra) # 56ac <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    28bc:	85ce                	mv	a1,s3
    28be:	00004517          	auipc	a0,0x4
    28c2:	6aa50513          	addi	a0,a0,1706 # 6f68 <csem_up+0x1272>
    28c6:	00003097          	auipc	ra,0x3
    28ca:	1b8080e7          	jalr	440(ra) # 5a7e <printf>
    exit(1);
    28ce:	4505                	li	a0,1
    28d0:	00003097          	auipc	ra,0x3
    28d4:	ddc080e7          	jalr	-548(ra) # 56ac <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    28d8:	86aa                	mv	a3,a0
    28da:	8626                	mv	a2,s1
    28dc:	85ce                	mv	a1,s3
    28de:	00004517          	auipc	a0,0x4
    28e2:	6c250513          	addi	a0,a0,1730 # 6fa0 <csem_up+0x12aa>
    28e6:	00003097          	auipc	ra,0x3
    28ea:	198080e7          	jalr	408(ra) # 5a7e <printf>
    exit(1);
    28ee:	4505                	li	a0,1
    28f0:	00003097          	auipc	ra,0x3
    28f4:	dbc080e7          	jalr	-580(ra) # 56ac <exit>

00000000000028f8 <sbrkarg>:
{
    28f8:	7179                	addi	sp,sp,-48
    28fa:	f406                	sd	ra,40(sp)
    28fc:	f022                	sd	s0,32(sp)
    28fe:	ec26                	sd	s1,24(sp)
    2900:	e84a                	sd	s2,16(sp)
    2902:	e44e                	sd	s3,8(sp)
    2904:	1800                	addi	s0,sp,48
    2906:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2908:	6505                	lui	a0,0x1
    290a:	00003097          	auipc	ra,0x3
    290e:	e2a080e7          	jalr	-470(ra) # 5734 <sbrk>
    2912:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2914:	20100593          	li	a1,513
    2918:	00004517          	auipc	a0,0x4
    291c:	6b050513          	addi	a0,a0,1712 # 6fc8 <csem_up+0x12d2>
    2920:	00003097          	auipc	ra,0x3
    2924:	dcc080e7          	jalr	-564(ra) # 56ec <open>
    2928:	84aa                	mv	s1,a0
  unlink("sbrk");
    292a:	00004517          	auipc	a0,0x4
    292e:	69e50513          	addi	a0,a0,1694 # 6fc8 <csem_up+0x12d2>
    2932:	00003097          	auipc	ra,0x3
    2936:	dca080e7          	jalr	-566(ra) # 56fc <unlink>
  if(fd < 0)  {
    293a:	0404c163          	bltz	s1,297c <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    293e:	6605                	lui	a2,0x1
    2940:	85ca                	mv	a1,s2
    2942:	8526                	mv	a0,s1
    2944:	00003097          	auipc	ra,0x3
    2948:	d88080e7          	jalr	-632(ra) # 56cc <write>
    294c:	04054663          	bltz	a0,2998 <sbrkarg+0xa0>
  close(fd);
    2950:	8526                	mv	a0,s1
    2952:	00003097          	auipc	ra,0x3
    2956:	d82080e7          	jalr	-638(ra) # 56d4 <close>
  a = sbrk(PGSIZE);
    295a:	6505                	lui	a0,0x1
    295c:	00003097          	auipc	ra,0x3
    2960:	dd8080e7          	jalr	-552(ra) # 5734 <sbrk>
  if(pipe((int *) a) != 0){
    2964:	00003097          	auipc	ra,0x3
    2968:	d58080e7          	jalr	-680(ra) # 56bc <pipe>
    296c:	e521                	bnez	a0,29b4 <sbrkarg+0xbc>
}
    296e:	70a2                	ld	ra,40(sp)
    2970:	7402                	ld	s0,32(sp)
    2972:	64e2                	ld	s1,24(sp)
    2974:	6942                	ld	s2,16(sp)
    2976:	69a2                	ld	s3,8(sp)
    2978:	6145                	addi	sp,sp,48
    297a:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    297c:	85ce                	mv	a1,s3
    297e:	00004517          	auipc	a0,0x4
    2982:	65250513          	addi	a0,a0,1618 # 6fd0 <csem_up+0x12da>
    2986:	00003097          	auipc	ra,0x3
    298a:	0f8080e7          	jalr	248(ra) # 5a7e <printf>
    exit(1);
    298e:	4505                	li	a0,1
    2990:	00003097          	auipc	ra,0x3
    2994:	d1c080e7          	jalr	-740(ra) # 56ac <exit>
    printf("%s: write sbrk failed\n", s);
    2998:	85ce                	mv	a1,s3
    299a:	00004517          	auipc	a0,0x4
    299e:	64e50513          	addi	a0,a0,1614 # 6fe8 <csem_up+0x12f2>
    29a2:	00003097          	auipc	ra,0x3
    29a6:	0dc080e7          	jalr	220(ra) # 5a7e <printf>
    exit(1);
    29aa:	4505                	li	a0,1
    29ac:	00003097          	auipc	ra,0x3
    29b0:	d00080e7          	jalr	-768(ra) # 56ac <exit>
    printf("%s: pipe() failed\n", s);
    29b4:	85ce                	mv	a1,s3
    29b6:	00004517          	auipc	a0,0x4
    29ba:	03250513          	addi	a0,a0,50 # 69e8 <csem_up+0xcf2>
    29be:	00003097          	auipc	ra,0x3
    29c2:	0c0080e7          	jalr	192(ra) # 5a7e <printf>
    exit(1);
    29c6:	4505                	li	a0,1
    29c8:	00003097          	auipc	ra,0x3
    29cc:	ce4080e7          	jalr	-796(ra) # 56ac <exit>

00000000000029d0 <argptest>:
{
    29d0:	1101                	addi	sp,sp,-32
    29d2:	ec06                	sd	ra,24(sp)
    29d4:	e822                	sd	s0,16(sp)
    29d6:	e426                	sd	s1,8(sp)
    29d8:	e04a                	sd	s2,0(sp)
    29da:	1000                	addi	s0,sp,32
    29dc:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    29de:	4581                	li	a1,0
    29e0:	00004517          	auipc	a0,0x4
    29e4:	62050513          	addi	a0,a0,1568 # 7000 <csem_up+0x130a>
    29e8:	00003097          	auipc	ra,0x3
    29ec:	d04080e7          	jalr	-764(ra) # 56ec <open>
  if (fd < 0) {
    29f0:	02054b63          	bltz	a0,2a26 <argptest+0x56>
    29f4:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    29f6:	4501                	li	a0,0
    29f8:	00003097          	auipc	ra,0x3
    29fc:	d3c080e7          	jalr	-708(ra) # 5734 <sbrk>
    2a00:	567d                	li	a2,-1
    2a02:	fff50593          	addi	a1,a0,-1
    2a06:	8526                	mv	a0,s1
    2a08:	00003097          	auipc	ra,0x3
    2a0c:	cbc080e7          	jalr	-836(ra) # 56c4 <read>
  close(fd);
    2a10:	8526                	mv	a0,s1
    2a12:	00003097          	auipc	ra,0x3
    2a16:	cc2080e7          	jalr	-830(ra) # 56d4 <close>
}
    2a1a:	60e2                	ld	ra,24(sp)
    2a1c:	6442                	ld	s0,16(sp)
    2a1e:	64a2                	ld	s1,8(sp)
    2a20:	6902                	ld	s2,0(sp)
    2a22:	6105                	addi	sp,sp,32
    2a24:	8082                	ret
    printf("%s: open failed\n", s);
    2a26:	85ca                	mv	a1,s2
    2a28:	00004517          	auipc	a0,0x4
    2a2c:	ed050513          	addi	a0,a0,-304 # 68f8 <csem_up+0xc02>
    2a30:	00003097          	auipc	ra,0x3
    2a34:	04e080e7          	jalr	78(ra) # 5a7e <printf>
    exit(1);
    2a38:	4505                	li	a0,1
    2a3a:	00003097          	auipc	ra,0x3
    2a3e:	c72080e7          	jalr	-910(ra) # 56ac <exit>

0000000000002a42 <sbrkbugs>:
{
    2a42:	1141                	addi	sp,sp,-16
    2a44:	e406                	sd	ra,8(sp)
    2a46:	e022                	sd	s0,0(sp)
    2a48:	0800                	addi	s0,sp,16
  int pid = fork();
    2a4a:	00003097          	auipc	ra,0x3
    2a4e:	c5a080e7          	jalr	-934(ra) # 56a4 <fork>
  if(pid < 0){
    2a52:	02054263          	bltz	a0,2a76 <sbrkbugs+0x34>
  if(pid == 0){
    2a56:	ed0d                	bnez	a0,2a90 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2a58:	00003097          	auipc	ra,0x3
    2a5c:	cdc080e7          	jalr	-804(ra) # 5734 <sbrk>
    sbrk(-sz);
    2a60:	40a0053b          	negw	a0,a0
    2a64:	00003097          	auipc	ra,0x3
    2a68:	cd0080e7          	jalr	-816(ra) # 5734 <sbrk>
    exit(0);
    2a6c:	4501                	li	a0,0
    2a6e:	00003097          	auipc	ra,0x3
    2a72:	c3e080e7          	jalr	-962(ra) # 56ac <exit>
    printf("fork failed\n");
    2a76:	00004517          	auipc	a0,0x4
    2a7a:	27250513          	addi	a0,a0,626 # 6ce8 <csem_up+0xff2>
    2a7e:	00003097          	auipc	ra,0x3
    2a82:	000080e7          	jalr	ra # 5a7e <printf>
    exit(1);
    2a86:	4505                	li	a0,1
    2a88:	00003097          	auipc	ra,0x3
    2a8c:	c24080e7          	jalr	-988(ra) # 56ac <exit>
  wait(0);
    2a90:	4501                	li	a0,0
    2a92:	00003097          	auipc	ra,0x3
    2a96:	c22080e7          	jalr	-990(ra) # 56b4 <wait>
  pid = fork();
    2a9a:	00003097          	auipc	ra,0x3
    2a9e:	c0a080e7          	jalr	-1014(ra) # 56a4 <fork>
  if(pid < 0){
    2aa2:	02054563          	bltz	a0,2acc <sbrkbugs+0x8a>
  if(pid == 0){
    2aa6:	e121                	bnez	a0,2ae6 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2aa8:	00003097          	auipc	ra,0x3
    2aac:	c8c080e7          	jalr	-884(ra) # 5734 <sbrk>
    sbrk(-(sz - 3500));
    2ab0:	6785                	lui	a5,0x1
    2ab2:	dac7879b          	addiw	a5,a5,-596
    2ab6:	40a7853b          	subw	a0,a5,a0
    2aba:	00003097          	auipc	ra,0x3
    2abe:	c7a080e7          	jalr	-902(ra) # 5734 <sbrk>
    exit(0);
    2ac2:	4501                	li	a0,0
    2ac4:	00003097          	auipc	ra,0x3
    2ac8:	be8080e7          	jalr	-1048(ra) # 56ac <exit>
    printf("fork failed\n");
    2acc:	00004517          	auipc	a0,0x4
    2ad0:	21c50513          	addi	a0,a0,540 # 6ce8 <csem_up+0xff2>
    2ad4:	00003097          	auipc	ra,0x3
    2ad8:	faa080e7          	jalr	-86(ra) # 5a7e <printf>
    exit(1);
    2adc:	4505                	li	a0,1
    2ade:	00003097          	auipc	ra,0x3
    2ae2:	bce080e7          	jalr	-1074(ra) # 56ac <exit>
  wait(0);
    2ae6:	4501                	li	a0,0
    2ae8:	00003097          	auipc	ra,0x3
    2aec:	bcc080e7          	jalr	-1076(ra) # 56b4 <wait>
  pid = fork();
    2af0:	00003097          	auipc	ra,0x3
    2af4:	bb4080e7          	jalr	-1100(ra) # 56a4 <fork>
  if(pid < 0){
    2af8:	02054a63          	bltz	a0,2b2c <sbrkbugs+0xea>
  if(pid == 0){
    2afc:	e529                	bnez	a0,2b46 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2afe:	00003097          	auipc	ra,0x3
    2b02:	c36080e7          	jalr	-970(ra) # 5734 <sbrk>
    2b06:	67ad                	lui	a5,0xb
    2b08:	8007879b          	addiw	a5,a5,-2048
    2b0c:	40a7853b          	subw	a0,a5,a0
    2b10:	00003097          	auipc	ra,0x3
    2b14:	c24080e7          	jalr	-988(ra) # 5734 <sbrk>
    sbrk(-10);
    2b18:	5559                	li	a0,-10
    2b1a:	00003097          	auipc	ra,0x3
    2b1e:	c1a080e7          	jalr	-998(ra) # 5734 <sbrk>
    exit(0);
    2b22:	4501                	li	a0,0
    2b24:	00003097          	auipc	ra,0x3
    2b28:	b88080e7          	jalr	-1144(ra) # 56ac <exit>
    printf("fork failed\n");
    2b2c:	00004517          	auipc	a0,0x4
    2b30:	1bc50513          	addi	a0,a0,444 # 6ce8 <csem_up+0xff2>
    2b34:	00003097          	auipc	ra,0x3
    2b38:	f4a080e7          	jalr	-182(ra) # 5a7e <printf>
    exit(1);
    2b3c:	4505                	li	a0,1
    2b3e:	00003097          	auipc	ra,0x3
    2b42:	b6e080e7          	jalr	-1170(ra) # 56ac <exit>
  wait(0);
    2b46:	4501                	li	a0,0
    2b48:	00003097          	auipc	ra,0x3
    2b4c:	b6c080e7          	jalr	-1172(ra) # 56b4 <wait>
  exit(0);
    2b50:	4501                	li	a0,0
    2b52:	00003097          	auipc	ra,0x3
    2b56:	b5a080e7          	jalr	-1190(ra) # 56ac <exit>

0000000000002b5a <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2b5a:	715d                	addi	sp,sp,-80
    2b5c:	e486                	sd	ra,72(sp)
    2b5e:	e0a2                	sd	s0,64(sp)
    2b60:	fc26                	sd	s1,56(sp)
    2b62:	f84a                	sd	s2,48(sp)
    2b64:	f44e                	sd	s3,40(sp)
    2b66:	f052                	sd	s4,32(sp)
    2b68:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2b6a:	4901                	li	s2,0
    2b6c:	49bd                	li	s3,15
    int pid = fork();
    2b6e:	00003097          	auipc	ra,0x3
    2b72:	b36080e7          	jalr	-1226(ra) # 56a4 <fork>
    2b76:	84aa                	mv	s1,a0
    if(pid < 0){
    2b78:	02054063          	bltz	a0,2b98 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2b7c:	c91d                	beqz	a0,2bb2 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2b7e:	4501                	li	a0,0
    2b80:	00003097          	auipc	ra,0x3
    2b84:	b34080e7          	jalr	-1228(ra) # 56b4 <wait>
  for(int avail = 0; avail < 15; avail++){
    2b88:	2905                	addiw	s2,s2,1
    2b8a:	ff3912e3          	bne	s2,s3,2b6e <execout+0x14>
    }
  }

  exit(0);
    2b8e:	4501                	li	a0,0
    2b90:	00003097          	auipc	ra,0x3
    2b94:	b1c080e7          	jalr	-1252(ra) # 56ac <exit>
      printf("fork failed\n");
    2b98:	00004517          	auipc	a0,0x4
    2b9c:	15050513          	addi	a0,a0,336 # 6ce8 <csem_up+0xff2>
    2ba0:	00003097          	auipc	ra,0x3
    2ba4:	ede080e7          	jalr	-290(ra) # 5a7e <printf>
      exit(1);
    2ba8:	4505                	li	a0,1
    2baa:	00003097          	auipc	ra,0x3
    2bae:	b02080e7          	jalr	-1278(ra) # 56ac <exit>
        if(a == 0xffffffffffffffffLL)
    2bb2:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2bb4:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2bb6:	6505                	lui	a0,0x1
    2bb8:	00003097          	auipc	ra,0x3
    2bbc:	b7c080e7          	jalr	-1156(ra) # 5734 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2bc0:	01350763          	beq	a0,s3,2bce <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2bc4:	6785                	lui	a5,0x1
    2bc6:	953e                	add	a0,a0,a5
    2bc8:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x9d>
      while(1){
    2bcc:	b7ed                	j	2bb6 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2bce:	01205a63          	blez	s2,2be2 <execout+0x88>
        sbrk(-4096);
    2bd2:	757d                	lui	a0,0xfffff
    2bd4:	00003097          	auipc	ra,0x3
    2bd8:	b60080e7          	jalr	-1184(ra) # 5734 <sbrk>
      for(int i = 0; i < avail; i++)
    2bdc:	2485                	addiw	s1,s1,1
    2bde:	ff249ae3          	bne	s1,s2,2bd2 <execout+0x78>
      close(1);
    2be2:	4505                	li	a0,1
    2be4:	00003097          	auipc	ra,0x3
    2be8:	af0080e7          	jalr	-1296(ra) # 56d4 <close>
      char *args[] = { "echo", "x", 0 };
    2bec:	00003517          	auipc	a0,0x3
    2bf0:	4bc50513          	addi	a0,a0,1212 # 60a8 <csem_up+0x3b2>
    2bf4:	faa43c23          	sd	a0,-72(s0)
    2bf8:	00003797          	auipc	a5,0x3
    2bfc:	52078793          	addi	a5,a5,1312 # 6118 <csem_up+0x422>
    2c00:	fcf43023          	sd	a5,-64(s0)
    2c04:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2c08:	fb840593          	addi	a1,s0,-72
    2c0c:	00003097          	auipc	ra,0x3
    2c10:	ad8080e7          	jalr	-1320(ra) # 56e4 <exec>
      exit(0);
    2c14:	4501                	li	a0,0
    2c16:	00003097          	auipc	ra,0x3
    2c1a:	a96080e7          	jalr	-1386(ra) # 56ac <exit>

0000000000002c1e <fourteen>:
{
    2c1e:	1101                	addi	sp,sp,-32
    2c20:	ec06                	sd	ra,24(sp)
    2c22:	e822                	sd	s0,16(sp)
    2c24:	e426                	sd	s1,8(sp)
    2c26:	1000                	addi	s0,sp,32
    2c28:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2c2a:	00004517          	auipc	a0,0x4
    2c2e:	5ae50513          	addi	a0,a0,1454 # 71d8 <csem_up+0x14e2>
    2c32:	00003097          	auipc	ra,0x3
    2c36:	ae2080e7          	jalr	-1310(ra) # 5714 <mkdir>
    2c3a:	e165                	bnez	a0,2d1a <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2c3c:	00004517          	auipc	a0,0x4
    2c40:	3f450513          	addi	a0,a0,1012 # 7030 <csem_up+0x133a>
    2c44:	00003097          	auipc	ra,0x3
    2c48:	ad0080e7          	jalr	-1328(ra) # 5714 <mkdir>
    2c4c:	e56d                	bnez	a0,2d36 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2c4e:	20000593          	li	a1,512
    2c52:	00004517          	auipc	a0,0x4
    2c56:	43650513          	addi	a0,a0,1078 # 7088 <csem_up+0x1392>
    2c5a:	00003097          	auipc	ra,0x3
    2c5e:	a92080e7          	jalr	-1390(ra) # 56ec <open>
  if(fd < 0){
    2c62:	0e054863          	bltz	a0,2d52 <fourteen+0x134>
  close(fd);
    2c66:	00003097          	auipc	ra,0x3
    2c6a:	a6e080e7          	jalr	-1426(ra) # 56d4 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2c6e:	4581                	li	a1,0
    2c70:	00004517          	auipc	a0,0x4
    2c74:	49050513          	addi	a0,a0,1168 # 7100 <csem_up+0x140a>
    2c78:	00003097          	auipc	ra,0x3
    2c7c:	a74080e7          	jalr	-1420(ra) # 56ec <open>
  if(fd < 0){
    2c80:	0e054763          	bltz	a0,2d6e <fourteen+0x150>
  close(fd);
    2c84:	00003097          	auipc	ra,0x3
    2c88:	a50080e7          	jalr	-1456(ra) # 56d4 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2c8c:	00004517          	auipc	a0,0x4
    2c90:	4e450513          	addi	a0,a0,1252 # 7170 <csem_up+0x147a>
    2c94:	00003097          	auipc	ra,0x3
    2c98:	a80080e7          	jalr	-1408(ra) # 5714 <mkdir>
    2c9c:	c57d                	beqz	a0,2d8a <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2c9e:	00004517          	auipc	a0,0x4
    2ca2:	52a50513          	addi	a0,a0,1322 # 71c8 <csem_up+0x14d2>
    2ca6:	00003097          	auipc	ra,0x3
    2caa:	a6e080e7          	jalr	-1426(ra) # 5714 <mkdir>
    2cae:	cd65                	beqz	a0,2da6 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2cb0:	00004517          	auipc	a0,0x4
    2cb4:	51850513          	addi	a0,a0,1304 # 71c8 <csem_up+0x14d2>
    2cb8:	00003097          	auipc	ra,0x3
    2cbc:	a44080e7          	jalr	-1468(ra) # 56fc <unlink>
  unlink("12345678901234/12345678901234");
    2cc0:	00004517          	auipc	a0,0x4
    2cc4:	4b050513          	addi	a0,a0,1200 # 7170 <csem_up+0x147a>
    2cc8:	00003097          	auipc	ra,0x3
    2ccc:	a34080e7          	jalr	-1484(ra) # 56fc <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2cd0:	00004517          	auipc	a0,0x4
    2cd4:	43050513          	addi	a0,a0,1072 # 7100 <csem_up+0x140a>
    2cd8:	00003097          	auipc	ra,0x3
    2cdc:	a24080e7          	jalr	-1500(ra) # 56fc <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2ce0:	00004517          	auipc	a0,0x4
    2ce4:	3a850513          	addi	a0,a0,936 # 7088 <csem_up+0x1392>
    2ce8:	00003097          	auipc	ra,0x3
    2cec:	a14080e7          	jalr	-1516(ra) # 56fc <unlink>
  unlink("12345678901234/123456789012345");
    2cf0:	00004517          	auipc	a0,0x4
    2cf4:	34050513          	addi	a0,a0,832 # 7030 <csem_up+0x133a>
    2cf8:	00003097          	auipc	ra,0x3
    2cfc:	a04080e7          	jalr	-1532(ra) # 56fc <unlink>
  unlink("12345678901234");
    2d00:	00004517          	auipc	a0,0x4
    2d04:	4d850513          	addi	a0,a0,1240 # 71d8 <csem_up+0x14e2>
    2d08:	00003097          	auipc	ra,0x3
    2d0c:	9f4080e7          	jalr	-1548(ra) # 56fc <unlink>
}
    2d10:	60e2                	ld	ra,24(sp)
    2d12:	6442                	ld	s0,16(sp)
    2d14:	64a2                	ld	s1,8(sp)
    2d16:	6105                	addi	sp,sp,32
    2d18:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2d1a:	85a6                	mv	a1,s1
    2d1c:	00004517          	auipc	a0,0x4
    2d20:	2ec50513          	addi	a0,a0,748 # 7008 <csem_up+0x1312>
    2d24:	00003097          	auipc	ra,0x3
    2d28:	d5a080e7          	jalr	-678(ra) # 5a7e <printf>
    exit(1);
    2d2c:	4505                	li	a0,1
    2d2e:	00003097          	auipc	ra,0x3
    2d32:	97e080e7          	jalr	-1666(ra) # 56ac <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2d36:	85a6                	mv	a1,s1
    2d38:	00004517          	auipc	a0,0x4
    2d3c:	31850513          	addi	a0,a0,792 # 7050 <csem_up+0x135a>
    2d40:	00003097          	auipc	ra,0x3
    2d44:	d3e080e7          	jalr	-706(ra) # 5a7e <printf>
    exit(1);
    2d48:	4505                	li	a0,1
    2d4a:	00003097          	auipc	ra,0x3
    2d4e:	962080e7          	jalr	-1694(ra) # 56ac <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2d52:	85a6                	mv	a1,s1
    2d54:	00004517          	auipc	a0,0x4
    2d58:	36450513          	addi	a0,a0,868 # 70b8 <csem_up+0x13c2>
    2d5c:	00003097          	auipc	ra,0x3
    2d60:	d22080e7          	jalr	-734(ra) # 5a7e <printf>
    exit(1);
    2d64:	4505                	li	a0,1
    2d66:	00003097          	auipc	ra,0x3
    2d6a:	946080e7          	jalr	-1722(ra) # 56ac <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2d6e:	85a6                	mv	a1,s1
    2d70:	00004517          	auipc	a0,0x4
    2d74:	3c050513          	addi	a0,a0,960 # 7130 <csem_up+0x143a>
    2d78:	00003097          	auipc	ra,0x3
    2d7c:	d06080e7          	jalr	-762(ra) # 5a7e <printf>
    exit(1);
    2d80:	4505                	li	a0,1
    2d82:	00003097          	auipc	ra,0x3
    2d86:	92a080e7          	jalr	-1750(ra) # 56ac <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2d8a:	85a6                	mv	a1,s1
    2d8c:	00004517          	auipc	a0,0x4
    2d90:	40450513          	addi	a0,a0,1028 # 7190 <csem_up+0x149a>
    2d94:	00003097          	auipc	ra,0x3
    2d98:	cea080e7          	jalr	-790(ra) # 5a7e <printf>
    exit(1);
    2d9c:	4505                	li	a0,1
    2d9e:	00003097          	auipc	ra,0x3
    2da2:	90e080e7          	jalr	-1778(ra) # 56ac <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2da6:	85a6                	mv	a1,s1
    2da8:	00004517          	auipc	a0,0x4
    2dac:	44050513          	addi	a0,a0,1088 # 71e8 <csem_up+0x14f2>
    2db0:	00003097          	auipc	ra,0x3
    2db4:	cce080e7          	jalr	-818(ra) # 5a7e <printf>
    exit(1);
    2db8:	4505                	li	a0,1
    2dba:	00003097          	auipc	ra,0x3
    2dbe:	8f2080e7          	jalr	-1806(ra) # 56ac <exit>

0000000000002dc2 <iputtest>:
{
    2dc2:	1101                	addi	sp,sp,-32
    2dc4:	ec06                	sd	ra,24(sp)
    2dc6:	e822                	sd	s0,16(sp)
    2dc8:	e426                	sd	s1,8(sp)
    2dca:	1000                	addi	s0,sp,32
    2dcc:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2dce:	00004517          	auipc	a0,0x4
    2dd2:	45250513          	addi	a0,a0,1106 # 7220 <csem_up+0x152a>
    2dd6:	00003097          	auipc	ra,0x3
    2dda:	93e080e7          	jalr	-1730(ra) # 5714 <mkdir>
    2dde:	04054563          	bltz	a0,2e28 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2de2:	00004517          	auipc	a0,0x4
    2de6:	43e50513          	addi	a0,a0,1086 # 7220 <csem_up+0x152a>
    2dea:	00003097          	auipc	ra,0x3
    2dee:	932080e7          	jalr	-1742(ra) # 571c <chdir>
    2df2:	04054963          	bltz	a0,2e44 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2df6:	00004517          	auipc	a0,0x4
    2dfa:	46a50513          	addi	a0,a0,1130 # 7260 <csem_up+0x156a>
    2dfe:	00003097          	auipc	ra,0x3
    2e02:	8fe080e7          	jalr	-1794(ra) # 56fc <unlink>
    2e06:	04054d63          	bltz	a0,2e60 <iputtest+0x9e>
  if(chdir("/") < 0){
    2e0a:	00004517          	auipc	a0,0x4
    2e0e:	48650513          	addi	a0,a0,1158 # 7290 <csem_up+0x159a>
    2e12:	00003097          	auipc	ra,0x3
    2e16:	90a080e7          	jalr	-1782(ra) # 571c <chdir>
    2e1a:	06054163          	bltz	a0,2e7c <iputtest+0xba>
}
    2e1e:	60e2                	ld	ra,24(sp)
    2e20:	6442                	ld	s0,16(sp)
    2e22:	64a2                	ld	s1,8(sp)
    2e24:	6105                	addi	sp,sp,32
    2e26:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2e28:	85a6                	mv	a1,s1
    2e2a:	00004517          	auipc	a0,0x4
    2e2e:	3fe50513          	addi	a0,a0,1022 # 7228 <csem_up+0x1532>
    2e32:	00003097          	auipc	ra,0x3
    2e36:	c4c080e7          	jalr	-948(ra) # 5a7e <printf>
    exit(1);
    2e3a:	4505                	li	a0,1
    2e3c:	00003097          	auipc	ra,0x3
    2e40:	870080e7          	jalr	-1936(ra) # 56ac <exit>
    printf("%s: chdir iputdir failed\n", s);
    2e44:	85a6                	mv	a1,s1
    2e46:	00004517          	auipc	a0,0x4
    2e4a:	3fa50513          	addi	a0,a0,1018 # 7240 <csem_up+0x154a>
    2e4e:	00003097          	auipc	ra,0x3
    2e52:	c30080e7          	jalr	-976(ra) # 5a7e <printf>
    exit(1);
    2e56:	4505                	li	a0,1
    2e58:	00003097          	auipc	ra,0x3
    2e5c:	854080e7          	jalr	-1964(ra) # 56ac <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2e60:	85a6                	mv	a1,s1
    2e62:	00004517          	auipc	a0,0x4
    2e66:	40e50513          	addi	a0,a0,1038 # 7270 <csem_up+0x157a>
    2e6a:	00003097          	auipc	ra,0x3
    2e6e:	c14080e7          	jalr	-1004(ra) # 5a7e <printf>
    exit(1);
    2e72:	4505                	li	a0,1
    2e74:	00003097          	auipc	ra,0x3
    2e78:	838080e7          	jalr	-1992(ra) # 56ac <exit>
    printf("%s: chdir / failed\n", s);
    2e7c:	85a6                	mv	a1,s1
    2e7e:	00004517          	auipc	a0,0x4
    2e82:	41a50513          	addi	a0,a0,1050 # 7298 <csem_up+0x15a2>
    2e86:	00003097          	auipc	ra,0x3
    2e8a:	bf8080e7          	jalr	-1032(ra) # 5a7e <printf>
    exit(1);
    2e8e:	4505                	li	a0,1
    2e90:	00003097          	auipc	ra,0x3
    2e94:	81c080e7          	jalr	-2020(ra) # 56ac <exit>

0000000000002e98 <exitiputtest>:
{
    2e98:	7179                	addi	sp,sp,-48
    2e9a:	f406                	sd	ra,40(sp)
    2e9c:	f022                	sd	s0,32(sp)
    2e9e:	ec26                	sd	s1,24(sp)
    2ea0:	1800                	addi	s0,sp,48
    2ea2:	84aa                	mv	s1,a0
  pid = fork();
    2ea4:	00003097          	auipc	ra,0x3
    2ea8:	800080e7          	jalr	-2048(ra) # 56a4 <fork>
  if(pid < 0){
    2eac:	04054663          	bltz	a0,2ef8 <exitiputtest+0x60>
  if(pid == 0){
    2eb0:	ed45                	bnez	a0,2f68 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2eb2:	00004517          	auipc	a0,0x4
    2eb6:	36e50513          	addi	a0,a0,878 # 7220 <csem_up+0x152a>
    2eba:	00003097          	auipc	ra,0x3
    2ebe:	85a080e7          	jalr	-1958(ra) # 5714 <mkdir>
    2ec2:	04054963          	bltz	a0,2f14 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2ec6:	00004517          	auipc	a0,0x4
    2eca:	35a50513          	addi	a0,a0,858 # 7220 <csem_up+0x152a>
    2ece:	00003097          	auipc	ra,0x3
    2ed2:	84e080e7          	jalr	-1970(ra) # 571c <chdir>
    2ed6:	04054d63          	bltz	a0,2f30 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2eda:	00004517          	auipc	a0,0x4
    2ede:	38650513          	addi	a0,a0,902 # 7260 <csem_up+0x156a>
    2ee2:	00003097          	auipc	ra,0x3
    2ee6:	81a080e7          	jalr	-2022(ra) # 56fc <unlink>
    2eea:	06054163          	bltz	a0,2f4c <exitiputtest+0xb4>
    exit(0);
    2eee:	4501                	li	a0,0
    2ef0:	00002097          	auipc	ra,0x2
    2ef4:	7bc080e7          	jalr	1980(ra) # 56ac <exit>
    printf("%s: fork failed\n", s);
    2ef8:	85a6                	mv	a1,s1
    2efa:	00004517          	auipc	a0,0x4
    2efe:	9e650513          	addi	a0,a0,-1562 # 68e0 <csem_up+0xbea>
    2f02:	00003097          	auipc	ra,0x3
    2f06:	b7c080e7          	jalr	-1156(ra) # 5a7e <printf>
    exit(1);
    2f0a:	4505                	li	a0,1
    2f0c:	00002097          	auipc	ra,0x2
    2f10:	7a0080e7          	jalr	1952(ra) # 56ac <exit>
      printf("%s: mkdir failed\n", s);
    2f14:	85a6                	mv	a1,s1
    2f16:	00004517          	auipc	a0,0x4
    2f1a:	31250513          	addi	a0,a0,786 # 7228 <csem_up+0x1532>
    2f1e:	00003097          	auipc	ra,0x3
    2f22:	b60080e7          	jalr	-1184(ra) # 5a7e <printf>
      exit(1);
    2f26:	4505                	li	a0,1
    2f28:	00002097          	auipc	ra,0x2
    2f2c:	784080e7          	jalr	1924(ra) # 56ac <exit>
      printf("%s: child chdir failed\n", s);
    2f30:	85a6                	mv	a1,s1
    2f32:	00004517          	auipc	a0,0x4
    2f36:	37e50513          	addi	a0,a0,894 # 72b0 <csem_up+0x15ba>
    2f3a:	00003097          	auipc	ra,0x3
    2f3e:	b44080e7          	jalr	-1212(ra) # 5a7e <printf>
      exit(1);
    2f42:	4505                	li	a0,1
    2f44:	00002097          	auipc	ra,0x2
    2f48:	768080e7          	jalr	1896(ra) # 56ac <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2f4c:	85a6                	mv	a1,s1
    2f4e:	00004517          	auipc	a0,0x4
    2f52:	32250513          	addi	a0,a0,802 # 7270 <csem_up+0x157a>
    2f56:	00003097          	auipc	ra,0x3
    2f5a:	b28080e7          	jalr	-1240(ra) # 5a7e <printf>
      exit(1);
    2f5e:	4505                	li	a0,1
    2f60:	00002097          	auipc	ra,0x2
    2f64:	74c080e7          	jalr	1868(ra) # 56ac <exit>
  wait(&xstatus);
    2f68:	fdc40513          	addi	a0,s0,-36
    2f6c:	00002097          	auipc	ra,0x2
    2f70:	748080e7          	jalr	1864(ra) # 56b4 <wait>
  exit(xstatus);
    2f74:	fdc42503          	lw	a0,-36(s0)
    2f78:	00002097          	auipc	ra,0x2
    2f7c:	734080e7          	jalr	1844(ra) # 56ac <exit>

0000000000002f80 <dirtest>:
{
    2f80:	1101                	addi	sp,sp,-32
    2f82:	ec06                	sd	ra,24(sp)
    2f84:	e822                	sd	s0,16(sp)
    2f86:	e426                	sd	s1,8(sp)
    2f88:	1000                	addi	s0,sp,32
    2f8a:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2f8c:	00004517          	auipc	a0,0x4
    2f90:	33c50513          	addi	a0,a0,828 # 72c8 <csem_up+0x15d2>
    2f94:	00002097          	auipc	ra,0x2
    2f98:	780080e7          	jalr	1920(ra) # 5714 <mkdir>
    2f9c:	04054563          	bltz	a0,2fe6 <dirtest+0x66>
  if(chdir("dir0") < 0){
    2fa0:	00004517          	auipc	a0,0x4
    2fa4:	32850513          	addi	a0,a0,808 # 72c8 <csem_up+0x15d2>
    2fa8:	00002097          	auipc	ra,0x2
    2fac:	774080e7          	jalr	1908(ra) # 571c <chdir>
    2fb0:	04054963          	bltz	a0,3002 <dirtest+0x82>
  if(chdir("..") < 0){
    2fb4:	00004517          	auipc	a0,0x4
    2fb8:	33450513          	addi	a0,a0,820 # 72e8 <csem_up+0x15f2>
    2fbc:	00002097          	auipc	ra,0x2
    2fc0:	760080e7          	jalr	1888(ra) # 571c <chdir>
    2fc4:	04054d63          	bltz	a0,301e <dirtest+0x9e>
  if(unlink("dir0") < 0){
    2fc8:	00004517          	auipc	a0,0x4
    2fcc:	30050513          	addi	a0,a0,768 # 72c8 <csem_up+0x15d2>
    2fd0:	00002097          	auipc	ra,0x2
    2fd4:	72c080e7          	jalr	1836(ra) # 56fc <unlink>
    2fd8:	06054163          	bltz	a0,303a <dirtest+0xba>
}
    2fdc:	60e2                	ld	ra,24(sp)
    2fde:	6442                	ld	s0,16(sp)
    2fe0:	64a2                	ld	s1,8(sp)
    2fe2:	6105                	addi	sp,sp,32
    2fe4:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2fe6:	85a6                	mv	a1,s1
    2fe8:	00004517          	auipc	a0,0x4
    2fec:	24050513          	addi	a0,a0,576 # 7228 <csem_up+0x1532>
    2ff0:	00003097          	auipc	ra,0x3
    2ff4:	a8e080e7          	jalr	-1394(ra) # 5a7e <printf>
    exit(1);
    2ff8:	4505                	li	a0,1
    2ffa:	00002097          	auipc	ra,0x2
    2ffe:	6b2080e7          	jalr	1714(ra) # 56ac <exit>
    printf("%s: chdir dir0 failed\n", s);
    3002:	85a6                	mv	a1,s1
    3004:	00004517          	auipc	a0,0x4
    3008:	2cc50513          	addi	a0,a0,716 # 72d0 <csem_up+0x15da>
    300c:	00003097          	auipc	ra,0x3
    3010:	a72080e7          	jalr	-1422(ra) # 5a7e <printf>
    exit(1);
    3014:	4505                	li	a0,1
    3016:	00002097          	auipc	ra,0x2
    301a:	696080e7          	jalr	1686(ra) # 56ac <exit>
    printf("%s: chdir .. failed\n", s);
    301e:	85a6                	mv	a1,s1
    3020:	00004517          	auipc	a0,0x4
    3024:	2d050513          	addi	a0,a0,720 # 72f0 <csem_up+0x15fa>
    3028:	00003097          	auipc	ra,0x3
    302c:	a56080e7          	jalr	-1450(ra) # 5a7e <printf>
    exit(1);
    3030:	4505                	li	a0,1
    3032:	00002097          	auipc	ra,0x2
    3036:	67a080e7          	jalr	1658(ra) # 56ac <exit>
    printf("%s: unlink dir0 failed\n", s);
    303a:	85a6                	mv	a1,s1
    303c:	00004517          	auipc	a0,0x4
    3040:	2cc50513          	addi	a0,a0,716 # 7308 <csem_up+0x1612>
    3044:	00003097          	auipc	ra,0x3
    3048:	a3a080e7          	jalr	-1478(ra) # 5a7e <printf>
    exit(1);
    304c:	4505                	li	a0,1
    304e:	00002097          	auipc	ra,0x2
    3052:	65e080e7          	jalr	1630(ra) # 56ac <exit>

0000000000003056 <subdir>:
{
    3056:	1101                	addi	sp,sp,-32
    3058:	ec06                	sd	ra,24(sp)
    305a:	e822                	sd	s0,16(sp)
    305c:	e426                	sd	s1,8(sp)
    305e:	e04a                	sd	s2,0(sp)
    3060:	1000                	addi	s0,sp,32
    3062:	892a                	mv	s2,a0
  unlink("ff");
    3064:	00004517          	auipc	a0,0x4
    3068:	3ec50513          	addi	a0,a0,1004 # 7450 <csem_up+0x175a>
    306c:	00002097          	auipc	ra,0x2
    3070:	690080e7          	jalr	1680(ra) # 56fc <unlink>
  if(mkdir("dd") != 0){
    3074:	00004517          	auipc	a0,0x4
    3078:	2ac50513          	addi	a0,a0,684 # 7320 <csem_up+0x162a>
    307c:	00002097          	auipc	ra,0x2
    3080:	698080e7          	jalr	1688(ra) # 5714 <mkdir>
    3084:	38051663          	bnez	a0,3410 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3088:	20200593          	li	a1,514
    308c:	00004517          	auipc	a0,0x4
    3090:	2b450513          	addi	a0,a0,692 # 7340 <csem_up+0x164a>
    3094:	00002097          	auipc	ra,0x2
    3098:	658080e7          	jalr	1624(ra) # 56ec <open>
    309c:	84aa                	mv	s1,a0
  if(fd < 0){
    309e:	38054763          	bltz	a0,342c <subdir+0x3d6>
  write(fd, "ff", 2);
    30a2:	4609                	li	a2,2
    30a4:	00004597          	auipc	a1,0x4
    30a8:	3ac58593          	addi	a1,a1,940 # 7450 <csem_up+0x175a>
    30ac:	00002097          	auipc	ra,0x2
    30b0:	620080e7          	jalr	1568(ra) # 56cc <write>
  close(fd);
    30b4:	8526                	mv	a0,s1
    30b6:	00002097          	auipc	ra,0x2
    30ba:	61e080e7          	jalr	1566(ra) # 56d4 <close>
  if(unlink("dd") >= 0){
    30be:	00004517          	auipc	a0,0x4
    30c2:	26250513          	addi	a0,a0,610 # 7320 <csem_up+0x162a>
    30c6:	00002097          	auipc	ra,0x2
    30ca:	636080e7          	jalr	1590(ra) # 56fc <unlink>
    30ce:	36055d63          	bgez	a0,3448 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    30d2:	00004517          	auipc	a0,0x4
    30d6:	2c650513          	addi	a0,a0,710 # 7398 <csem_up+0x16a2>
    30da:	00002097          	auipc	ra,0x2
    30de:	63a080e7          	jalr	1594(ra) # 5714 <mkdir>
    30e2:	38051163          	bnez	a0,3464 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    30e6:	20200593          	li	a1,514
    30ea:	00004517          	auipc	a0,0x4
    30ee:	2d650513          	addi	a0,a0,726 # 73c0 <csem_up+0x16ca>
    30f2:	00002097          	auipc	ra,0x2
    30f6:	5fa080e7          	jalr	1530(ra) # 56ec <open>
    30fa:	84aa                	mv	s1,a0
  if(fd < 0){
    30fc:	38054263          	bltz	a0,3480 <subdir+0x42a>
  write(fd, "FF", 2);
    3100:	4609                	li	a2,2
    3102:	00004597          	auipc	a1,0x4
    3106:	2ee58593          	addi	a1,a1,750 # 73f0 <csem_up+0x16fa>
    310a:	00002097          	auipc	ra,0x2
    310e:	5c2080e7          	jalr	1474(ra) # 56cc <write>
  close(fd);
    3112:	8526                	mv	a0,s1
    3114:	00002097          	auipc	ra,0x2
    3118:	5c0080e7          	jalr	1472(ra) # 56d4 <close>
  fd = open("dd/dd/../ff", 0);
    311c:	4581                	li	a1,0
    311e:	00004517          	auipc	a0,0x4
    3122:	2da50513          	addi	a0,a0,730 # 73f8 <csem_up+0x1702>
    3126:	00002097          	auipc	ra,0x2
    312a:	5c6080e7          	jalr	1478(ra) # 56ec <open>
    312e:	84aa                	mv	s1,a0
  if(fd < 0){
    3130:	36054663          	bltz	a0,349c <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3134:	660d                	lui	a2,0x3
    3136:	00009597          	auipc	a1,0x9
    313a:	bba58593          	addi	a1,a1,-1094 # bcf0 <buf>
    313e:	00002097          	auipc	ra,0x2
    3142:	586080e7          	jalr	1414(ra) # 56c4 <read>
  if(cc != 2 || buf[0] != 'f'){
    3146:	4789                	li	a5,2
    3148:	36f51863          	bne	a0,a5,34b8 <subdir+0x462>
    314c:	00009717          	auipc	a4,0x9
    3150:	ba474703          	lbu	a4,-1116(a4) # bcf0 <buf>
    3154:	06600793          	li	a5,102
    3158:	36f71063          	bne	a4,a5,34b8 <subdir+0x462>
  close(fd);
    315c:	8526                	mv	a0,s1
    315e:	00002097          	auipc	ra,0x2
    3162:	576080e7          	jalr	1398(ra) # 56d4 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3166:	00004597          	auipc	a1,0x4
    316a:	2e258593          	addi	a1,a1,738 # 7448 <csem_up+0x1752>
    316e:	00004517          	auipc	a0,0x4
    3172:	25250513          	addi	a0,a0,594 # 73c0 <csem_up+0x16ca>
    3176:	00002097          	auipc	ra,0x2
    317a:	596080e7          	jalr	1430(ra) # 570c <link>
    317e:	34051b63          	bnez	a0,34d4 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3182:	00004517          	auipc	a0,0x4
    3186:	23e50513          	addi	a0,a0,574 # 73c0 <csem_up+0x16ca>
    318a:	00002097          	auipc	ra,0x2
    318e:	572080e7          	jalr	1394(ra) # 56fc <unlink>
    3192:	34051f63          	bnez	a0,34f0 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3196:	4581                	li	a1,0
    3198:	00004517          	auipc	a0,0x4
    319c:	22850513          	addi	a0,a0,552 # 73c0 <csem_up+0x16ca>
    31a0:	00002097          	auipc	ra,0x2
    31a4:	54c080e7          	jalr	1356(ra) # 56ec <open>
    31a8:	36055263          	bgez	a0,350c <subdir+0x4b6>
  if(chdir("dd") != 0){
    31ac:	00004517          	auipc	a0,0x4
    31b0:	17450513          	addi	a0,a0,372 # 7320 <csem_up+0x162a>
    31b4:	00002097          	auipc	ra,0x2
    31b8:	568080e7          	jalr	1384(ra) # 571c <chdir>
    31bc:	36051663          	bnez	a0,3528 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    31c0:	00004517          	auipc	a0,0x4
    31c4:	32050513          	addi	a0,a0,800 # 74e0 <csem_up+0x17ea>
    31c8:	00002097          	auipc	ra,0x2
    31cc:	554080e7          	jalr	1364(ra) # 571c <chdir>
    31d0:	36051a63          	bnez	a0,3544 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    31d4:	00004517          	auipc	a0,0x4
    31d8:	33c50513          	addi	a0,a0,828 # 7510 <csem_up+0x181a>
    31dc:	00002097          	auipc	ra,0x2
    31e0:	540080e7          	jalr	1344(ra) # 571c <chdir>
    31e4:	36051e63          	bnez	a0,3560 <subdir+0x50a>
  if(chdir("./..") != 0){
    31e8:	00004517          	auipc	a0,0x4
    31ec:	35850513          	addi	a0,a0,856 # 7540 <csem_up+0x184a>
    31f0:	00002097          	auipc	ra,0x2
    31f4:	52c080e7          	jalr	1324(ra) # 571c <chdir>
    31f8:	38051263          	bnez	a0,357c <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    31fc:	4581                	li	a1,0
    31fe:	00004517          	auipc	a0,0x4
    3202:	24a50513          	addi	a0,a0,586 # 7448 <csem_up+0x1752>
    3206:	00002097          	auipc	ra,0x2
    320a:	4e6080e7          	jalr	1254(ra) # 56ec <open>
    320e:	84aa                	mv	s1,a0
  if(fd < 0){
    3210:	38054463          	bltz	a0,3598 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3214:	660d                	lui	a2,0x3
    3216:	00009597          	auipc	a1,0x9
    321a:	ada58593          	addi	a1,a1,-1318 # bcf0 <buf>
    321e:	00002097          	auipc	ra,0x2
    3222:	4a6080e7          	jalr	1190(ra) # 56c4 <read>
    3226:	4789                	li	a5,2
    3228:	38f51663          	bne	a0,a5,35b4 <subdir+0x55e>
  close(fd);
    322c:	8526                	mv	a0,s1
    322e:	00002097          	auipc	ra,0x2
    3232:	4a6080e7          	jalr	1190(ra) # 56d4 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3236:	4581                	li	a1,0
    3238:	00004517          	auipc	a0,0x4
    323c:	18850513          	addi	a0,a0,392 # 73c0 <csem_up+0x16ca>
    3240:	00002097          	auipc	ra,0x2
    3244:	4ac080e7          	jalr	1196(ra) # 56ec <open>
    3248:	38055463          	bgez	a0,35d0 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    324c:	20200593          	li	a1,514
    3250:	00004517          	auipc	a0,0x4
    3254:	38050513          	addi	a0,a0,896 # 75d0 <csem_up+0x18da>
    3258:	00002097          	auipc	ra,0x2
    325c:	494080e7          	jalr	1172(ra) # 56ec <open>
    3260:	38055663          	bgez	a0,35ec <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3264:	20200593          	li	a1,514
    3268:	00004517          	auipc	a0,0x4
    326c:	39850513          	addi	a0,a0,920 # 7600 <csem_up+0x190a>
    3270:	00002097          	auipc	ra,0x2
    3274:	47c080e7          	jalr	1148(ra) # 56ec <open>
    3278:	38055863          	bgez	a0,3608 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    327c:	20000593          	li	a1,512
    3280:	00004517          	auipc	a0,0x4
    3284:	0a050513          	addi	a0,a0,160 # 7320 <csem_up+0x162a>
    3288:	00002097          	auipc	ra,0x2
    328c:	464080e7          	jalr	1124(ra) # 56ec <open>
    3290:	38055a63          	bgez	a0,3624 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3294:	4589                	li	a1,2
    3296:	00004517          	auipc	a0,0x4
    329a:	08a50513          	addi	a0,a0,138 # 7320 <csem_up+0x162a>
    329e:	00002097          	auipc	ra,0x2
    32a2:	44e080e7          	jalr	1102(ra) # 56ec <open>
    32a6:	38055d63          	bgez	a0,3640 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    32aa:	4585                	li	a1,1
    32ac:	00004517          	auipc	a0,0x4
    32b0:	07450513          	addi	a0,a0,116 # 7320 <csem_up+0x162a>
    32b4:	00002097          	auipc	ra,0x2
    32b8:	438080e7          	jalr	1080(ra) # 56ec <open>
    32bc:	3a055063          	bgez	a0,365c <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    32c0:	00004597          	auipc	a1,0x4
    32c4:	3d058593          	addi	a1,a1,976 # 7690 <csem_up+0x199a>
    32c8:	00004517          	auipc	a0,0x4
    32cc:	30850513          	addi	a0,a0,776 # 75d0 <csem_up+0x18da>
    32d0:	00002097          	auipc	ra,0x2
    32d4:	43c080e7          	jalr	1084(ra) # 570c <link>
    32d8:	3a050063          	beqz	a0,3678 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    32dc:	00004597          	auipc	a1,0x4
    32e0:	3b458593          	addi	a1,a1,948 # 7690 <csem_up+0x199a>
    32e4:	00004517          	auipc	a0,0x4
    32e8:	31c50513          	addi	a0,a0,796 # 7600 <csem_up+0x190a>
    32ec:	00002097          	auipc	ra,0x2
    32f0:	420080e7          	jalr	1056(ra) # 570c <link>
    32f4:	3a050063          	beqz	a0,3694 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    32f8:	00004597          	auipc	a1,0x4
    32fc:	15058593          	addi	a1,a1,336 # 7448 <csem_up+0x1752>
    3300:	00004517          	auipc	a0,0x4
    3304:	04050513          	addi	a0,a0,64 # 7340 <csem_up+0x164a>
    3308:	00002097          	auipc	ra,0x2
    330c:	404080e7          	jalr	1028(ra) # 570c <link>
    3310:	3a050063          	beqz	a0,36b0 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3314:	00004517          	auipc	a0,0x4
    3318:	2bc50513          	addi	a0,a0,700 # 75d0 <csem_up+0x18da>
    331c:	00002097          	auipc	ra,0x2
    3320:	3f8080e7          	jalr	1016(ra) # 5714 <mkdir>
    3324:	3a050463          	beqz	a0,36cc <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3328:	00004517          	auipc	a0,0x4
    332c:	2d850513          	addi	a0,a0,728 # 7600 <csem_up+0x190a>
    3330:	00002097          	auipc	ra,0x2
    3334:	3e4080e7          	jalr	996(ra) # 5714 <mkdir>
    3338:	3a050863          	beqz	a0,36e8 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    333c:	00004517          	auipc	a0,0x4
    3340:	10c50513          	addi	a0,a0,268 # 7448 <csem_up+0x1752>
    3344:	00002097          	auipc	ra,0x2
    3348:	3d0080e7          	jalr	976(ra) # 5714 <mkdir>
    334c:	3a050c63          	beqz	a0,3704 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3350:	00004517          	auipc	a0,0x4
    3354:	2b050513          	addi	a0,a0,688 # 7600 <csem_up+0x190a>
    3358:	00002097          	auipc	ra,0x2
    335c:	3a4080e7          	jalr	932(ra) # 56fc <unlink>
    3360:	3c050063          	beqz	a0,3720 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3364:	00004517          	auipc	a0,0x4
    3368:	26c50513          	addi	a0,a0,620 # 75d0 <csem_up+0x18da>
    336c:	00002097          	auipc	ra,0x2
    3370:	390080e7          	jalr	912(ra) # 56fc <unlink>
    3374:	3c050463          	beqz	a0,373c <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3378:	00004517          	auipc	a0,0x4
    337c:	fc850513          	addi	a0,a0,-56 # 7340 <csem_up+0x164a>
    3380:	00002097          	auipc	ra,0x2
    3384:	39c080e7          	jalr	924(ra) # 571c <chdir>
    3388:	3c050863          	beqz	a0,3758 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    338c:	00004517          	auipc	a0,0x4
    3390:	45450513          	addi	a0,a0,1108 # 77e0 <csem_up+0x1aea>
    3394:	00002097          	auipc	ra,0x2
    3398:	388080e7          	jalr	904(ra) # 571c <chdir>
    339c:	3c050c63          	beqz	a0,3774 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    33a0:	00004517          	auipc	a0,0x4
    33a4:	0a850513          	addi	a0,a0,168 # 7448 <csem_up+0x1752>
    33a8:	00002097          	auipc	ra,0x2
    33ac:	354080e7          	jalr	852(ra) # 56fc <unlink>
    33b0:	3e051063          	bnez	a0,3790 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    33b4:	00004517          	auipc	a0,0x4
    33b8:	f8c50513          	addi	a0,a0,-116 # 7340 <csem_up+0x164a>
    33bc:	00002097          	auipc	ra,0x2
    33c0:	340080e7          	jalr	832(ra) # 56fc <unlink>
    33c4:	3e051463          	bnez	a0,37ac <subdir+0x756>
  if(unlink("dd") == 0){
    33c8:	00004517          	auipc	a0,0x4
    33cc:	f5850513          	addi	a0,a0,-168 # 7320 <csem_up+0x162a>
    33d0:	00002097          	auipc	ra,0x2
    33d4:	32c080e7          	jalr	812(ra) # 56fc <unlink>
    33d8:	3e050863          	beqz	a0,37c8 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    33dc:	00004517          	auipc	a0,0x4
    33e0:	47450513          	addi	a0,a0,1140 # 7850 <csem_up+0x1b5a>
    33e4:	00002097          	auipc	ra,0x2
    33e8:	318080e7          	jalr	792(ra) # 56fc <unlink>
    33ec:	3e054c63          	bltz	a0,37e4 <subdir+0x78e>
  if(unlink("dd") < 0){
    33f0:	00004517          	auipc	a0,0x4
    33f4:	f3050513          	addi	a0,a0,-208 # 7320 <csem_up+0x162a>
    33f8:	00002097          	auipc	ra,0x2
    33fc:	304080e7          	jalr	772(ra) # 56fc <unlink>
    3400:	40054063          	bltz	a0,3800 <subdir+0x7aa>
}
    3404:	60e2                	ld	ra,24(sp)
    3406:	6442                	ld	s0,16(sp)
    3408:	64a2                	ld	s1,8(sp)
    340a:	6902                	ld	s2,0(sp)
    340c:	6105                	addi	sp,sp,32
    340e:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3410:	85ca                	mv	a1,s2
    3412:	00004517          	auipc	a0,0x4
    3416:	f1650513          	addi	a0,a0,-234 # 7328 <csem_up+0x1632>
    341a:	00002097          	auipc	ra,0x2
    341e:	664080e7          	jalr	1636(ra) # 5a7e <printf>
    exit(1);
    3422:	4505                	li	a0,1
    3424:	00002097          	auipc	ra,0x2
    3428:	288080e7          	jalr	648(ra) # 56ac <exit>
    printf("%s: create dd/ff failed\n", s);
    342c:	85ca                	mv	a1,s2
    342e:	00004517          	auipc	a0,0x4
    3432:	f1a50513          	addi	a0,a0,-230 # 7348 <csem_up+0x1652>
    3436:	00002097          	auipc	ra,0x2
    343a:	648080e7          	jalr	1608(ra) # 5a7e <printf>
    exit(1);
    343e:	4505                	li	a0,1
    3440:	00002097          	auipc	ra,0x2
    3444:	26c080e7          	jalr	620(ra) # 56ac <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3448:	85ca                	mv	a1,s2
    344a:	00004517          	auipc	a0,0x4
    344e:	f1e50513          	addi	a0,a0,-226 # 7368 <csem_up+0x1672>
    3452:	00002097          	auipc	ra,0x2
    3456:	62c080e7          	jalr	1580(ra) # 5a7e <printf>
    exit(1);
    345a:	4505                	li	a0,1
    345c:	00002097          	auipc	ra,0x2
    3460:	250080e7          	jalr	592(ra) # 56ac <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3464:	85ca                	mv	a1,s2
    3466:	00004517          	auipc	a0,0x4
    346a:	f3a50513          	addi	a0,a0,-198 # 73a0 <csem_up+0x16aa>
    346e:	00002097          	auipc	ra,0x2
    3472:	610080e7          	jalr	1552(ra) # 5a7e <printf>
    exit(1);
    3476:	4505                	li	a0,1
    3478:	00002097          	auipc	ra,0x2
    347c:	234080e7          	jalr	564(ra) # 56ac <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3480:	85ca                	mv	a1,s2
    3482:	00004517          	auipc	a0,0x4
    3486:	f4e50513          	addi	a0,a0,-178 # 73d0 <csem_up+0x16da>
    348a:	00002097          	auipc	ra,0x2
    348e:	5f4080e7          	jalr	1524(ra) # 5a7e <printf>
    exit(1);
    3492:	4505                	li	a0,1
    3494:	00002097          	auipc	ra,0x2
    3498:	218080e7          	jalr	536(ra) # 56ac <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    349c:	85ca                	mv	a1,s2
    349e:	00004517          	auipc	a0,0x4
    34a2:	f6a50513          	addi	a0,a0,-150 # 7408 <csem_up+0x1712>
    34a6:	00002097          	auipc	ra,0x2
    34aa:	5d8080e7          	jalr	1496(ra) # 5a7e <printf>
    exit(1);
    34ae:	4505                	li	a0,1
    34b0:	00002097          	auipc	ra,0x2
    34b4:	1fc080e7          	jalr	508(ra) # 56ac <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    34b8:	85ca                	mv	a1,s2
    34ba:	00004517          	auipc	a0,0x4
    34be:	f6e50513          	addi	a0,a0,-146 # 7428 <csem_up+0x1732>
    34c2:	00002097          	auipc	ra,0x2
    34c6:	5bc080e7          	jalr	1468(ra) # 5a7e <printf>
    exit(1);
    34ca:	4505                	li	a0,1
    34cc:	00002097          	auipc	ra,0x2
    34d0:	1e0080e7          	jalr	480(ra) # 56ac <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    34d4:	85ca                	mv	a1,s2
    34d6:	00004517          	auipc	a0,0x4
    34da:	f8250513          	addi	a0,a0,-126 # 7458 <csem_up+0x1762>
    34de:	00002097          	auipc	ra,0x2
    34e2:	5a0080e7          	jalr	1440(ra) # 5a7e <printf>
    exit(1);
    34e6:	4505                	li	a0,1
    34e8:	00002097          	auipc	ra,0x2
    34ec:	1c4080e7          	jalr	452(ra) # 56ac <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    34f0:	85ca                	mv	a1,s2
    34f2:	00004517          	auipc	a0,0x4
    34f6:	f8e50513          	addi	a0,a0,-114 # 7480 <csem_up+0x178a>
    34fa:	00002097          	auipc	ra,0x2
    34fe:	584080e7          	jalr	1412(ra) # 5a7e <printf>
    exit(1);
    3502:	4505                	li	a0,1
    3504:	00002097          	auipc	ra,0x2
    3508:	1a8080e7          	jalr	424(ra) # 56ac <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    350c:	85ca                	mv	a1,s2
    350e:	00004517          	auipc	a0,0x4
    3512:	f9250513          	addi	a0,a0,-110 # 74a0 <csem_up+0x17aa>
    3516:	00002097          	auipc	ra,0x2
    351a:	568080e7          	jalr	1384(ra) # 5a7e <printf>
    exit(1);
    351e:	4505                	li	a0,1
    3520:	00002097          	auipc	ra,0x2
    3524:	18c080e7          	jalr	396(ra) # 56ac <exit>
    printf("%s: chdir dd failed\n", s);
    3528:	85ca                	mv	a1,s2
    352a:	00004517          	auipc	a0,0x4
    352e:	f9e50513          	addi	a0,a0,-98 # 74c8 <csem_up+0x17d2>
    3532:	00002097          	auipc	ra,0x2
    3536:	54c080e7          	jalr	1356(ra) # 5a7e <printf>
    exit(1);
    353a:	4505                	li	a0,1
    353c:	00002097          	auipc	ra,0x2
    3540:	170080e7          	jalr	368(ra) # 56ac <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3544:	85ca                	mv	a1,s2
    3546:	00004517          	auipc	a0,0x4
    354a:	faa50513          	addi	a0,a0,-86 # 74f0 <csem_up+0x17fa>
    354e:	00002097          	auipc	ra,0x2
    3552:	530080e7          	jalr	1328(ra) # 5a7e <printf>
    exit(1);
    3556:	4505                	li	a0,1
    3558:	00002097          	auipc	ra,0x2
    355c:	154080e7          	jalr	340(ra) # 56ac <exit>
    printf("chdir dd/../../dd failed\n", s);
    3560:	85ca                	mv	a1,s2
    3562:	00004517          	auipc	a0,0x4
    3566:	fbe50513          	addi	a0,a0,-66 # 7520 <csem_up+0x182a>
    356a:	00002097          	auipc	ra,0x2
    356e:	514080e7          	jalr	1300(ra) # 5a7e <printf>
    exit(1);
    3572:	4505                	li	a0,1
    3574:	00002097          	auipc	ra,0x2
    3578:	138080e7          	jalr	312(ra) # 56ac <exit>
    printf("%s: chdir ./.. failed\n", s);
    357c:	85ca                	mv	a1,s2
    357e:	00004517          	auipc	a0,0x4
    3582:	fca50513          	addi	a0,a0,-54 # 7548 <csem_up+0x1852>
    3586:	00002097          	auipc	ra,0x2
    358a:	4f8080e7          	jalr	1272(ra) # 5a7e <printf>
    exit(1);
    358e:	4505                	li	a0,1
    3590:	00002097          	auipc	ra,0x2
    3594:	11c080e7          	jalr	284(ra) # 56ac <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3598:	85ca                	mv	a1,s2
    359a:	00004517          	auipc	a0,0x4
    359e:	fc650513          	addi	a0,a0,-58 # 7560 <csem_up+0x186a>
    35a2:	00002097          	auipc	ra,0x2
    35a6:	4dc080e7          	jalr	1244(ra) # 5a7e <printf>
    exit(1);
    35aa:	4505                	li	a0,1
    35ac:	00002097          	auipc	ra,0x2
    35b0:	100080e7          	jalr	256(ra) # 56ac <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    35b4:	85ca                	mv	a1,s2
    35b6:	00004517          	auipc	a0,0x4
    35ba:	fca50513          	addi	a0,a0,-54 # 7580 <csem_up+0x188a>
    35be:	00002097          	auipc	ra,0x2
    35c2:	4c0080e7          	jalr	1216(ra) # 5a7e <printf>
    exit(1);
    35c6:	4505                	li	a0,1
    35c8:	00002097          	auipc	ra,0x2
    35cc:	0e4080e7          	jalr	228(ra) # 56ac <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    35d0:	85ca                	mv	a1,s2
    35d2:	00004517          	auipc	a0,0x4
    35d6:	fce50513          	addi	a0,a0,-50 # 75a0 <csem_up+0x18aa>
    35da:	00002097          	auipc	ra,0x2
    35de:	4a4080e7          	jalr	1188(ra) # 5a7e <printf>
    exit(1);
    35e2:	4505                	li	a0,1
    35e4:	00002097          	auipc	ra,0x2
    35e8:	0c8080e7          	jalr	200(ra) # 56ac <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    35ec:	85ca                	mv	a1,s2
    35ee:	00004517          	auipc	a0,0x4
    35f2:	ff250513          	addi	a0,a0,-14 # 75e0 <csem_up+0x18ea>
    35f6:	00002097          	auipc	ra,0x2
    35fa:	488080e7          	jalr	1160(ra) # 5a7e <printf>
    exit(1);
    35fe:	4505                	li	a0,1
    3600:	00002097          	auipc	ra,0x2
    3604:	0ac080e7          	jalr	172(ra) # 56ac <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3608:	85ca                	mv	a1,s2
    360a:	00004517          	auipc	a0,0x4
    360e:	00650513          	addi	a0,a0,6 # 7610 <csem_up+0x191a>
    3612:	00002097          	auipc	ra,0x2
    3616:	46c080e7          	jalr	1132(ra) # 5a7e <printf>
    exit(1);
    361a:	4505                	li	a0,1
    361c:	00002097          	auipc	ra,0x2
    3620:	090080e7          	jalr	144(ra) # 56ac <exit>
    printf("%s: create dd succeeded!\n", s);
    3624:	85ca                	mv	a1,s2
    3626:	00004517          	auipc	a0,0x4
    362a:	00a50513          	addi	a0,a0,10 # 7630 <csem_up+0x193a>
    362e:	00002097          	auipc	ra,0x2
    3632:	450080e7          	jalr	1104(ra) # 5a7e <printf>
    exit(1);
    3636:	4505                	li	a0,1
    3638:	00002097          	auipc	ra,0x2
    363c:	074080e7          	jalr	116(ra) # 56ac <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3640:	85ca                	mv	a1,s2
    3642:	00004517          	auipc	a0,0x4
    3646:	00e50513          	addi	a0,a0,14 # 7650 <csem_up+0x195a>
    364a:	00002097          	auipc	ra,0x2
    364e:	434080e7          	jalr	1076(ra) # 5a7e <printf>
    exit(1);
    3652:	4505                	li	a0,1
    3654:	00002097          	auipc	ra,0x2
    3658:	058080e7          	jalr	88(ra) # 56ac <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    365c:	85ca                	mv	a1,s2
    365e:	00004517          	auipc	a0,0x4
    3662:	01250513          	addi	a0,a0,18 # 7670 <csem_up+0x197a>
    3666:	00002097          	auipc	ra,0x2
    366a:	418080e7          	jalr	1048(ra) # 5a7e <printf>
    exit(1);
    366e:	4505                	li	a0,1
    3670:	00002097          	auipc	ra,0x2
    3674:	03c080e7          	jalr	60(ra) # 56ac <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3678:	85ca                	mv	a1,s2
    367a:	00004517          	auipc	a0,0x4
    367e:	02650513          	addi	a0,a0,38 # 76a0 <csem_up+0x19aa>
    3682:	00002097          	auipc	ra,0x2
    3686:	3fc080e7          	jalr	1020(ra) # 5a7e <printf>
    exit(1);
    368a:	4505                	li	a0,1
    368c:	00002097          	auipc	ra,0x2
    3690:	020080e7          	jalr	32(ra) # 56ac <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3694:	85ca                	mv	a1,s2
    3696:	00004517          	auipc	a0,0x4
    369a:	03250513          	addi	a0,a0,50 # 76c8 <csem_up+0x19d2>
    369e:	00002097          	auipc	ra,0x2
    36a2:	3e0080e7          	jalr	992(ra) # 5a7e <printf>
    exit(1);
    36a6:	4505                	li	a0,1
    36a8:	00002097          	auipc	ra,0x2
    36ac:	004080e7          	jalr	4(ra) # 56ac <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    36b0:	85ca                	mv	a1,s2
    36b2:	00004517          	auipc	a0,0x4
    36b6:	03e50513          	addi	a0,a0,62 # 76f0 <csem_up+0x19fa>
    36ba:	00002097          	auipc	ra,0x2
    36be:	3c4080e7          	jalr	964(ra) # 5a7e <printf>
    exit(1);
    36c2:	4505                	li	a0,1
    36c4:	00002097          	auipc	ra,0x2
    36c8:	fe8080e7          	jalr	-24(ra) # 56ac <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    36cc:	85ca                	mv	a1,s2
    36ce:	00004517          	auipc	a0,0x4
    36d2:	04a50513          	addi	a0,a0,74 # 7718 <csem_up+0x1a22>
    36d6:	00002097          	auipc	ra,0x2
    36da:	3a8080e7          	jalr	936(ra) # 5a7e <printf>
    exit(1);
    36de:	4505                	li	a0,1
    36e0:	00002097          	auipc	ra,0x2
    36e4:	fcc080e7          	jalr	-52(ra) # 56ac <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    36e8:	85ca                	mv	a1,s2
    36ea:	00004517          	auipc	a0,0x4
    36ee:	04e50513          	addi	a0,a0,78 # 7738 <csem_up+0x1a42>
    36f2:	00002097          	auipc	ra,0x2
    36f6:	38c080e7          	jalr	908(ra) # 5a7e <printf>
    exit(1);
    36fa:	4505                	li	a0,1
    36fc:	00002097          	auipc	ra,0x2
    3700:	fb0080e7          	jalr	-80(ra) # 56ac <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3704:	85ca                	mv	a1,s2
    3706:	00004517          	auipc	a0,0x4
    370a:	05250513          	addi	a0,a0,82 # 7758 <csem_up+0x1a62>
    370e:	00002097          	auipc	ra,0x2
    3712:	370080e7          	jalr	880(ra) # 5a7e <printf>
    exit(1);
    3716:	4505                	li	a0,1
    3718:	00002097          	auipc	ra,0x2
    371c:	f94080e7          	jalr	-108(ra) # 56ac <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3720:	85ca                	mv	a1,s2
    3722:	00004517          	auipc	a0,0x4
    3726:	05e50513          	addi	a0,a0,94 # 7780 <csem_up+0x1a8a>
    372a:	00002097          	auipc	ra,0x2
    372e:	354080e7          	jalr	852(ra) # 5a7e <printf>
    exit(1);
    3732:	4505                	li	a0,1
    3734:	00002097          	auipc	ra,0x2
    3738:	f78080e7          	jalr	-136(ra) # 56ac <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    373c:	85ca                	mv	a1,s2
    373e:	00004517          	auipc	a0,0x4
    3742:	06250513          	addi	a0,a0,98 # 77a0 <csem_up+0x1aaa>
    3746:	00002097          	auipc	ra,0x2
    374a:	338080e7          	jalr	824(ra) # 5a7e <printf>
    exit(1);
    374e:	4505                	li	a0,1
    3750:	00002097          	auipc	ra,0x2
    3754:	f5c080e7          	jalr	-164(ra) # 56ac <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3758:	85ca                	mv	a1,s2
    375a:	00004517          	auipc	a0,0x4
    375e:	06650513          	addi	a0,a0,102 # 77c0 <csem_up+0x1aca>
    3762:	00002097          	auipc	ra,0x2
    3766:	31c080e7          	jalr	796(ra) # 5a7e <printf>
    exit(1);
    376a:	4505                	li	a0,1
    376c:	00002097          	auipc	ra,0x2
    3770:	f40080e7          	jalr	-192(ra) # 56ac <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3774:	85ca                	mv	a1,s2
    3776:	00004517          	auipc	a0,0x4
    377a:	07250513          	addi	a0,a0,114 # 77e8 <csem_up+0x1af2>
    377e:	00002097          	auipc	ra,0x2
    3782:	300080e7          	jalr	768(ra) # 5a7e <printf>
    exit(1);
    3786:	4505                	li	a0,1
    3788:	00002097          	auipc	ra,0x2
    378c:	f24080e7          	jalr	-220(ra) # 56ac <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3790:	85ca                	mv	a1,s2
    3792:	00004517          	auipc	a0,0x4
    3796:	cee50513          	addi	a0,a0,-786 # 7480 <csem_up+0x178a>
    379a:	00002097          	auipc	ra,0x2
    379e:	2e4080e7          	jalr	740(ra) # 5a7e <printf>
    exit(1);
    37a2:	4505                	li	a0,1
    37a4:	00002097          	auipc	ra,0x2
    37a8:	f08080e7          	jalr	-248(ra) # 56ac <exit>
    printf("%s: unlink dd/ff failed\n", s);
    37ac:	85ca                	mv	a1,s2
    37ae:	00004517          	auipc	a0,0x4
    37b2:	05a50513          	addi	a0,a0,90 # 7808 <csem_up+0x1b12>
    37b6:	00002097          	auipc	ra,0x2
    37ba:	2c8080e7          	jalr	712(ra) # 5a7e <printf>
    exit(1);
    37be:	4505                	li	a0,1
    37c0:	00002097          	auipc	ra,0x2
    37c4:	eec080e7          	jalr	-276(ra) # 56ac <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    37c8:	85ca                	mv	a1,s2
    37ca:	00004517          	auipc	a0,0x4
    37ce:	05e50513          	addi	a0,a0,94 # 7828 <csem_up+0x1b32>
    37d2:	00002097          	auipc	ra,0x2
    37d6:	2ac080e7          	jalr	684(ra) # 5a7e <printf>
    exit(1);
    37da:	4505                	li	a0,1
    37dc:	00002097          	auipc	ra,0x2
    37e0:	ed0080e7          	jalr	-304(ra) # 56ac <exit>
    printf("%s: unlink dd/dd failed\n", s);
    37e4:	85ca                	mv	a1,s2
    37e6:	00004517          	auipc	a0,0x4
    37ea:	07250513          	addi	a0,a0,114 # 7858 <csem_up+0x1b62>
    37ee:	00002097          	auipc	ra,0x2
    37f2:	290080e7          	jalr	656(ra) # 5a7e <printf>
    exit(1);
    37f6:	4505                	li	a0,1
    37f8:	00002097          	auipc	ra,0x2
    37fc:	eb4080e7          	jalr	-332(ra) # 56ac <exit>
    printf("%s: unlink dd failed\n", s);
    3800:	85ca                	mv	a1,s2
    3802:	00004517          	auipc	a0,0x4
    3806:	07650513          	addi	a0,a0,118 # 7878 <csem_up+0x1b82>
    380a:	00002097          	auipc	ra,0x2
    380e:	274080e7          	jalr	628(ra) # 5a7e <printf>
    exit(1);
    3812:	4505                	li	a0,1
    3814:	00002097          	auipc	ra,0x2
    3818:	e98080e7          	jalr	-360(ra) # 56ac <exit>

000000000000381c <rmdot>:
{
    381c:	1101                	addi	sp,sp,-32
    381e:	ec06                	sd	ra,24(sp)
    3820:	e822                	sd	s0,16(sp)
    3822:	e426                	sd	s1,8(sp)
    3824:	1000                	addi	s0,sp,32
    3826:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3828:	00004517          	auipc	a0,0x4
    382c:	06850513          	addi	a0,a0,104 # 7890 <csem_up+0x1b9a>
    3830:	00002097          	auipc	ra,0x2
    3834:	ee4080e7          	jalr	-284(ra) # 5714 <mkdir>
    3838:	e549                	bnez	a0,38c2 <rmdot+0xa6>
  if(chdir("dots") != 0){
    383a:	00004517          	auipc	a0,0x4
    383e:	05650513          	addi	a0,a0,86 # 7890 <csem_up+0x1b9a>
    3842:	00002097          	auipc	ra,0x2
    3846:	eda080e7          	jalr	-294(ra) # 571c <chdir>
    384a:	e951                	bnez	a0,38de <rmdot+0xc2>
  if(unlink(".") == 0){
    384c:	00003517          	auipc	a0,0x3
    3850:	ef450513          	addi	a0,a0,-268 # 6740 <csem_up+0xa4a>
    3854:	00002097          	auipc	ra,0x2
    3858:	ea8080e7          	jalr	-344(ra) # 56fc <unlink>
    385c:	cd59                	beqz	a0,38fa <rmdot+0xde>
  if(unlink("..") == 0){
    385e:	00004517          	auipc	a0,0x4
    3862:	a8a50513          	addi	a0,a0,-1398 # 72e8 <csem_up+0x15f2>
    3866:	00002097          	auipc	ra,0x2
    386a:	e96080e7          	jalr	-362(ra) # 56fc <unlink>
    386e:	c545                	beqz	a0,3916 <rmdot+0xfa>
  if(chdir("/") != 0){
    3870:	00004517          	auipc	a0,0x4
    3874:	a2050513          	addi	a0,a0,-1504 # 7290 <csem_up+0x159a>
    3878:	00002097          	auipc	ra,0x2
    387c:	ea4080e7          	jalr	-348(ra) # 571c <chdir>
    3880:	e94d                	bnez	a0,3932 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3882:	00004517          	auipc	a0,0x4
    3886:	07650513          	addi	a0,a0,118 # 78f8 <csem_up+0x1c02>
    388a:	00002097          	auipc	ra,0x2
    388e:	e72080e7          	jalr	-398(ra) # 56fc <unlink>
    3892:	cd55                	beqz	a0,394e <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3894:	00004517          	auipc	a0,0x4
    3898:	08c50513          	addi	a0,a0,140 # 7920 <csem_up+0x1c2a>
    389c:	00002097          	auipc	ra,0x2
    38a0:	e60080e7          	jalr	-416(ra) # 56fc <unlink>
    38a4:	c179                	beqz	a0,396a <rmdot+0x14e>
  if(unlink("dots") != 0){
    38a6:	00004517          	auipc	a0,0x4
    38aa:	fea50513          	addi	a0,a0,-22 # 7890 <csem_up+0x1b9a>
    38ae:	00002097          	auipc	ra,0x2
    38b2:	e4e080e7          	jalr	-434(ra) # 56fc <unlink>
    38b6:	e961                	bnez	a0,3986 <rmdot+0x16a>
}
    38b8:	60e2                	ld	ra,24(sp)
    38ba:	6442                	ld	s0,16(sp)
    38bc:	64a2                	ld	s1,8(sp)
    38be:	6105                	addi	sp,sp,32
    38c0:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    38c2:	85a6                	mv	a1,s1
    38c4:	00004517          	auipc	a0,0x4
    38c8:	fd450513          	addi	a0,a0,-44 # 7898 <csem_up+0x1ba2>
    38cc:	00002097          	auipc	ra,0x2
    38d0:	1b2080e7          	jalr	434(ra) # 5a7e <printf>
    exit(1);
    38d4:	4505                	li	a0,1
    38d6:	00002097          	auipc	ra,0x2
    38da:	dd6080e7          	jalr	-554(ra) # 56ac <exit>
    printf("%s: chdir dots failed\n", s);
    38de:	85a6                	mv	a1,s1
    38e0:	00004517          	auipc	a0,0x4
    38e4:	fd050513          	addi	a0,a0,-48 # 78b0 <csem_up+0x1bba>
    38e8:	00002097          	auipc	ra,0x2
    38ec:	196080e7          	jalr	406(ra) # 5a7e <printf>
    exit(1);
    38f0:	4505                	li	a0,1
    38f2:	00002097          	auipc	ra,0x2
    38f6:	dba080e7          	jalr	-582(ra) # 56ac <exit>
    printf("%s: rm . worked!\n", s);
    38fa:	85a6                	mv	a1,s1
    38fc:	00004517          	auipc	a0,0x4
    3900:	fcc50513          	addi	a0,a0,-52 # 78c8 <csem_up+0x1bd2>
    3904:	00002097          	auipc	ra,0x2
    3908:	17a080e7          	jalr	378(ra) # 5a7e <printf>
    exit(1);
    390c:	4505                	li	a0,1
    390e:	00002097          	auipc	ra,0x2
    3912:	d9e080e7          	jalr	-610(ra) # 56ac <exit>
    printf("%s: rm .. worked!\n", s);
    3916:	85a6                	mv	a1,s1
    3918:	00004517          	auipc	a0,0x4
    391c:	fc850513          	addi	a0,a0,-56 # 78e0 <csem_up+0x1bea>
    3920:	00002097          	auipc	ra,0x2
    3924:	15e080e7          	jalr	350(ra) # 5a7e <printf>
    exit(1);
    3928:	4505                	li	a0,1
    392a:	00002097          	auipc	ra,0x2
    392e:	d82080e7          	jalr	-638(ra) # 56ac <exit>
    printf("%s: chdir / failed\n", s);
    3932:	85a6                	mv	a1,s1
    3934:	00004517          	auipc	a0,0x4
    3938:	96450513          	addi	a0,a0,-1692 # 7298 <csem_up+0x15a2>
    393c:	00002097          	auipc	ra,0x2
    3940:	142080e7          	jalr	322(ra) # 5a7e <printf>
    exit(1);
    3944:	4505                	li	a0,1
    3946:	00002097          	auipc	ra,0x2
    394a:	d66080e7          	jalr	-666(ra) # 56ac <exit>
    printf("%s: unlink dots/. worked!\n", s);
    394e:	85a6                	mv	a1,s1
    3950:	00004517          	auipc	a0,0x4
    3954:	fb050513          	addi	a0,a0,-80 # 7900 <csem_up+0x1c0a>
    3958:	00002097          	auipc	ra,0x2
    395c:	126080e7          	jalr	294(ra) # 5a7e <printf>
    exit(1);
    3960:	4505                	li	a0,1
    3962:	00002097          	auipc	ra,0x2
    3966:	d4a080e7          	jalr	-694(ra) # 56ac <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    396a:	85a6                	mv	a1,s1
    396c:	00004517          	auipc	a0,0x4
    3970:	fbc50513          	addi	a0,a0,-68 # 7928 <csem_up+0x1c32>
    3974:	00002097          	auipc	ra,0x2
    3978:	10a080e7          	jalr	266(ra) # 5a7e <printf>
    exit(1);
    397c:	4505                	li	a0,1
    397e:	00002097          	auipc	ra,0x2
    3982:	d2e080e7          	jalr	-722(ra) # 56ac <exit>
    printf("%s: unlink dots failed!\n", s);
    3986:	85a6                	mv	a1,s1
    3988:	00004517          	auipc	a0,0x4
    398c:	fc050513          	addi	a0,a0,-64 # 7948 <csem_up+0x1c52>
    3990:	00002097          	auipc	ra,0x2
    3994:	0ee080e7          	jalr	238(ra) # 5a7e <printf>
    exit(1);
    3998:	4505                	li	a0,1
    399a:	00002097          	auipc	ra,0x2
    399e:	d12080e7          	jalr	-750(ra) # 56ac <exit>

00000000000039a2 <dirfile>:
{
    39a2:	1101                	addi	sp,sp,-32
    39a4:	ec06                	sd	ra,24(sp)
    39a6:	e822                	sd	s0,16(sp)
    39a8:	e426                	sd	s1,8(sp)
    39aa:	e04a                	sd	s2,0(sp)
    39ac:	1000                	addi	s0,sp,32
    39ae:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    39b0:	20000593          	li	a1,512
    39b4:	00002517          	auipc	a0,0x2
    39b8:	69450513          	addi	a0,a0,1684 # 6048 <csem_up+0x352>
    39bc:	00002097          	auipc	ra,0x2
    39c0:	d30080e7          	jalr	-720(ra) # 56ec <open>
  if(fd < 0){
    39c4:	0e054d63          	bltz	a0,3abe <dirfile+0x11c>
  close(fd);
    39c8:	00002097          	auipc	ra,0x2
    39cc:	d0c080e7          	jalr	-756(ra) # 56d4 <close>
  if(chdir("dirfile") == 0){
    39d0:	00002517          	auipc	a0,0x2
    39d4:	67850513          	addi	a0,a0,1656 # 6048 <csem_up+0x352>
    39d8:	00002097          	auipc	ra,0x2
    39dc:	d44080e7          	jalr	-700(ra) # 571c <chdir>
    39e0:	cd6d                	beqz	a0,3ada <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    39e2:	4581                	li	a1,0
    39e4:	00004517          	auipc	a0,0x4
    39e8:	fc450513          	addi	a0,a0,-60 # 79a8 <csem_up+0x1cb2>
    39ec:	00002097          	auipc	ra,0x2
    39f0:	d00080e7          	jalr	-768(ra) # 56ec <open>
  if(fd >= 0){
    39f4:	10055163          	bgez	a0,3af6 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    39f8:	20000593          	li	a1,512
    39fc:	00004517          	auipc	a0,0x4
    3a00:	fac50513          	addi	a0,a0,-84 # 79a8 <csem_up+0x1cb2>
    3a04:	00002097          	auipc	ra,0x2
    3a08:	ce8080e7          	jalr	-792(ra) # 56ec <open>
  if(fd >= 0){
    3a0c:	10055363          	bgez	a0,3b12 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3a10:	00004517          	auipc	a0,0x4
    3a14:	f9850513          	addi	a0,a0,-104 # 79a8 <csem_up+0x1cb2>
    3a18:	00002097          	auipc	ra,0x2
    3a1c:	cfc080e7          	jalr	-772(ra) # 5714 <mkdir>
    3a20:	10050763          	beqz	a0,3b2e <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3a24:	00004517          	auipc	a0,0x4
    3a28:	f8450513          	addi	a0,a0,-124 # 79a8 <csem_up+0x1cb2>
    3a2c:	00002097          	auipc	ra,0x2
    3a30:	cd0080e7          	jalr	-816(ra) # 56fc <unlink>
    3a34:	10050b63          	beqz	a0,3b4a <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3a38:	00004597          	auipc	a1,0x4
    3a3c:	f7058593          	addi	a1,a1,-144 # 79a8 <csem_up+0x1cb2>
    3a40:	00003517          	auipc	a0,0x3
    3a44:	80050513          	addi	a0,a0,-2048 # 6240 <csem_up+0x54a>
    3a48:	00002097          	auipc	ra,0x2
    3a4c:	cc4080e7          	jalr	-828(ra) # 570c <link>
    3a50:	10050b63          	beqz	a0,3b66 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3a54:	00002517          	auipc	a0,0x2
    3a58:	5f450513          	addi	a0,a0,1524 # 6048 <csem_up+0x352>
    3a5c:	00002097          	auipc	ra,0x2
    3a60:	ca0080e7          	jalr	-864(ra) # 56fc <unlink>
    3a64:	10051f63          	bnez	a0,3b82 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3a68:	4589                	li	a1,2
    3a6a:	00003517          	auipc	a0,0x3
    3a6e:	cd650513          	addi	a0,a0,-810 # 6740 <csem_up+0xa4a>
    3a72:	00002097          	auipc	ra,0x2
    3a76:	c7a080e7          	jalr	-902(ra) # 56ec <open>
  if(fd >= 0){
    3a7a:	12055263          	bgez	a0,3b9e <dirfile+0x1fc>
  fd = open(".", 0);
    3a7e:	4581                	li	a1,0
    3a80:	00003517          	auipc	a0,0x3
    3a84:	cc050513          	addi	a0,a0,-832 # 6740 <csem_up+0xa4a>
    3a88:	00002097          	auipc	ra,0x2
    3a8c:	c64080e7          	jalr	-924(ra) # 56ec <open>
    3a90:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3a92:	4605                	li	a2,1
    3a94:	00002597          	auipc	a1,0x2
    3a98:	68458593          	addi	a1,a1,1668 # 6118 <csem_up+0x422>
    3a9c:	00002097          	auipc	ra,0x2
    3aa0:	c30080e7          	jalr	-976(ra) # 56cc <write>
    3aa4:	10a04b63          	bgtz	a0,3bba <dirfile+0x218>
  close(fd);
    3aa8:	8526                	mv	a0,s1
    3aaa:	00002097          	auipc	ra,0x2
    3aae:	c2a080e7          	jalr	-982(ra) # 56d4 <close>
}
    3ab2:	60e2                	ld	ra,24(sp)
    3ab4:	6442                	ld	s0,16(sp)
    3ab6:	64a2                	ld	s1,8(sp)
    3ab8:	6902                	ld	s2,0(sp)
    3aba:	6105                	addi	sp,sp,32
    3abc:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3abe:	85ca                	mv	a1,s2
    3ac0:	00004517          	auipc	a0,0x4
    3ac4:	ea850513          	addi	a0,a0,-344 # 7968 <csem_up+0x1c72>
    3ac8:	00002097          	auipc	ra,0x2
    3acc:	fb6080e7          	jalr	-74(ra) # 5a7e <printf>
    exit(1);
    3ad0:	4505                	li	a0,1
    3ad2:	00002097          	auipc	ra,0x2
    3ad6:	bda080e7          	jalr	-1062(ra) # 56ac <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3ada:	85ca                	mv	a1,s2
    3adc:	00004517          	auipc	a0,0x4
    3ae0:	eac50513          	addi	a0,a0,-340 # 7988 <csem_up+0x1c92>
    3ae4:	00002097          	auipc	ra,0x2
    3ae8:	f9a080e7          	jalr	-102(ra) # 5a7e <printf>
    exit(1);
    3aec:	4505                	li	a0,1
    3aee:	00002097          	auipc	ra,0x2
    3af2:	bbe080e7          	jalr	-1090(ra) # 56ac <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3af6:	85ca                	mv	a1,s2
    3af8:	00004517          	auipc	a0,0x4
    3afc:	ec050513          	addi	a0,a0,-320 # 79b8 <csem_up+0x1cc2>
    3b00:	00002097          	auipc	ra,0x2
    3b04:	f7e080e7          	jalr	-130(ra) # 5a7e <printf>
    exit(1);
    3b08:	4505                	li	a0,1
    3b0a:	00002097          	auipc	ra,0x2
    3b0e:	ba2080e7          	jalr	-1118(ra) # 56ac <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b12:	85ca                	mv	a1,s2
    3b14:	00004517          	auipc	a0,0x4
    3b18:	ea450513          	addi	a0,a0,-348 # 79b8 <csem_up+0x1cc2>
    3b1c:	00002097          	auipc	ra,0x2
    3b20:	f62080e7          	jalr	-158(ra) # 5a7e <printf>
    exit(1);
    3b24:	4505                	li	a0,1
    3b26:	00002097          	auipc	ra,0x2
    3b2a:	b86080e7          	jalr	-1146(ra) # 56ac <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3b2e:	85ca                	mv	a1,s2
    3b30:	00004517          	auipc	a0,0x4
    3b34:	eb050513          	addi	a0,a0,-336 # 79e0 <csem_up+0x1cea>
    3b38:	00002097          	auipc	ra,0x2
    3b3c:	f46080e7          	jalr	-186(ra) # 5a7e <printf>
    exit(1);
    3b40:	4505                	li	a0,1
    3b42:	00002097          	auipc	ra,0x2
    3b46:	b6a080e7          	jalr	-1174(ra) # 56ac <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3b4a:	85ca                	mv	a1,s2
    3b4c:	00004517          	auipc	a0,0x4
    3b50:	ebc50513          	addi	a0,a0,-324 # 7a08 <csem_up+0x1d12>
    3b54:	00002097          	auipc	ra,0x2
    3b58:	f2a080e7          	jalr	-214(ra) # 5a7e <printf>
    exit(1);
    3b5c:	4505                	li	a0,1
    3b5e:	00002097          	auipc	ra,0x2
    3b62:	b4e080e7          	jalr	-1202(ra) # 56ac <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3b66:	85ca                	mv	a1,s2
    3b68:	00004517          	auipc	a0,0x4
    3b6c:	ec850513          	addi	a0,a0,-312 # 7a30 <csem_up+0x1d3a>
    3b70:	00002097          	auipc	ra,0x2
    3b74:	f0e080e7          	jalr	-242(ra) # 5a7e <printf>
    exit(1);
    3b78:	4505                	li	a0,1
    3b7a:	00002097          	auipc	ra,0x2
    3b7e:	b32080e7          	jalr	-1230(ra) # 56ac <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3b82:	85ca                	mv	a1,s2
    3b84:	00004517          	auipc	a0,0x4
    3b88:	ed450513          	addi	a0,a0,-300 # 7a58 <csem_up+0x1d62>
    3b8c:	00002097          	auipc	ra,0x2
    3b90:	ef2080e7          	jalr	-270(ra) # 5a7e <printf>
    exit(1);
    3b94:	4505                	li	a0,1
    3b96:	00002097          	auipc	ra,0x2
    3b9a:	b16080e7          	jalr	-1258(ra) # 56ac <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3b9e:	85ca                	mv	a1,s2
    3ba0:	00004517          	auipc	a0,0x4
    3ba4:	ed850513          	addi	a0,a0,-296 # 7a78 <csem_up+0x1d82>
    3ba8:	00002097          	auipc	ra,0x2
    3bac:	ed6080e7          	jalr	-298(ra) # 5a7e <printf>
    exit(1);
    3bb0:	4505                	li	a0,1
    3bb2:	00002097          	auipc	ra,0x2
    3bb6:	afa080e7          	jalr	-1286(ra) # 56ac <exit>
    printf("%s: write . succeeded!\n", s);
    3bba:	85ca                	mv	a1,s2
    3bbc:	00004517          	auipc	a0,0x4
    3bc0:	ee450513          	addi	a0,a0,-284 # 7aa0 <csem_up+0x1daa>
    3bc4:	00002097          	auipc	ra,0x2
    3bc8:	eba080e7          	jalr	-326(ra) # 5a7e <printf>
    exit(1);
    3bcc:	4505                	li	a0,1
    3bce:	00002097          	auipc	ra,0x2
    3bd2:	ade080e7          	jalr	-1314(ra) # 56ac <exit>

0000000000003bd6 <iref>:
{
    3bd6:	7139                	addi	sp,sp,-64
    3bd8:	fc06                	sd	ra,56(sp)
    3bda:	f822                	sd	s0,48(sp)
    3bdc:	f426                	sd	s1,40(sp)
    3bde:	f04a                	sd	s2,32(sp)
    3be0:	ec4e                	sd	s3,24(sp)
    3be2:	e852                	sd	s4,16(sp)
    3be4:	e456                	sd	s5,8(sp)
    3be6:	e05a                	sd	s6,0(sp)
    3be8:	0080                	addi	s0,sp,64
    3bea:	8b2a                	mv	s6,a0
    3bec:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3bf0:	00004a17          	auipc	s4,0x4
    3bf4:	ec8a0a13          	addi	s4,s4,-312 # 7ab8 <csem_up+0x1dc2>
    mkdir("");
    3bf8:	00004497          	auipc	s1,0x4
    3bfc:	9d048493          	addi	s1,s1,-1584 # 75c8 <csem_up+0x18d2>
    link("README", "");
    3c00:	00002a97          	auipc	s5,0x2
    3c04:	640a8a93          	addi	s5,s5,1600 # 6240 <csem_up+0x54a>
    fd = open("xx", O_CREATE);
    3c08:	00004997          	auipc	s3,0x4
    3c0c:	da898993          	addi	s3,s3,-600 # 79b0 <csem_up+0x1cba>
    3c10:	a891                	j	3c64 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3c12:	85da                	mv	a1,s6
    3c14:	00004517          	auipc	a0,0x4
    3c18:	eac50513          	addi	a0,a0,-340 # 7ac0 <csem_up+0x1dca>
    3c1c:	00002097          	auipc	ra,0x2
    3c20:	e62080e7          	jalr	-414(ra) # 5a7e <printf>
      exit(1);
    3c24:	4505                	li	a0,1
    3c26:	00002097          	auipc	ra,0x2
    3c2a:	a86080e7          	jalr	-1402(ra) # 56ac <exit>
      printf("%s: chdir irefd failed\n", s);
    3c2e:	85da                	mv	a1,s6
    3c30:	00004517          	auipc	a0,0x4
    3c34:	ea850513          	addi	a0,a0,-344 # 7ad8 <csem_up+0x1de2>
    3c38:	00002097          	auipc	ra,0x2
    3c3c:	e46080e7          	jalr	-442(ra) # 5a7e <printf>
      exit(1);
    3c40:	4505                	li	a0,1
    3c42:	00002097          	auipc	ra,0x2
    3c46:	a6a080e7          	jalr	-1430(ra) # 56ac <exit>
      close(fd);
    3c4a:	00002097          	auipc	ra,0x2
    3c4e:	a8a080e7          	jalr	-1398(ra) # 56d4 <close>
    3c52:	a889                	j	3ca4 <iref+0xce>
    unlink("xx");
    3c54:	854e                	mv	a0,s3
    3c56:	00002097          	auipc	ra,0x2
    3c5a:	aa6080e7          	jalr	-1370(ra) # 56fc <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3c5e:	397d                	addiw	s2,s2,-1
    3c60:	06090063          	beqz	s2,3cc0 <iref+0xea>
    if(mkdir("irefd") != 0){
    3c64:	8552                	mv	a0,s4
    3c66:	00002097          	auipc	ra,0x2
    3c6a:	aae080e7          	jalr	-1362(ra) # 5714 <mkdir>
    3c6e:	f155                	bnez	a0,3c12 <iref+0x3c>
    if(chdir("irefd") != 0){
    3c70:	8552                	mv	a0,s4
    3c72:	00002097          	auipc	ra,0x2
    3c76:	aaa080e7          	jalr	-1366(ra) # 571c <chdir>
    3c7a:	f955                	bnez	a0,3c2e <iref+0x58>
    mkdir("");
    3c7c:	8526                	mv	a0,s1
    3c7e:	00002097          	auipc	ra,0x2
    3c82:	a96080e7          	jalr	-1386(ra) # 5714 <mkdir>
    link("README", "");
    3c86:	85a6                	mv	a1,s1
    3c88:	8556                	mv	a0,s5
    3c8a:	00002097          	auipc	ra,0x2
    3c8e:	a82080e7          	jalr	-1406(ra) # 570c <link>
    fd = open("", O_CREATE);
    3c92:	20000593          	li	a1,512
    3c96:	8526                	mv	a0,s1
    3c98:	00002097          	auipc	ra,0x2
    3c9c:	a54080e7          	jalr	-1452(ra) # 56ec <open>
    if(fd >= 0)
    3ca0:	fa0555e3          	bgez	a0,3c4a <iref+0x74>
    fd = open("xx", O_CREATE);
    3ca4:	20000593          	li	a1,512
    3ca8:	854e                	mv	a0,s3
    3caa:	00002097          	auipc	ra,0x2
    3cae:	a42080e7          	jalr	-1470(ra) # 56ec <open>
    if(fd >= 0)
    3cb2:	fa0541e3          	bltz	a0,3c54 <iref+0x7e>
      close(fd);
    3cb6:	00002097          	auipc	ra,0x2
    3cba:	a1e080e7          	jalr	-1506(ra) # 56d4 <close>
    3cbe:	bf59                	j	3c54 <iref+0x7e>
    3cc0:	03300493          	li	s1,51
    chdir("..");
    3cc4:	00003997          	auipc	s3,0x3
    3cc8:	62498993          	addi	s3,s3,1572 # 72e8 <csem_up+0x15f2>
    unlink("irefd");
    3ccc:	00004917          	auipc	s2,0x4
    3cd0:	dec90913          	addi	s2,s2,-532 # 7ab8 <csem_up+0x1dc2>
    chdir("..");
    3cd4:	854e                	mv	a0,s3
    3cd6:	00002097          	auipc	ra,0x2
    3cda:	a46080e7          	jalr	-1466(ra) # 571c <chdir>
    unlink("irefd");
    3cde:	854a                	mv	a0,s2
    3ce0:	00002097          	auipc	ra,0x2
    3ce4:	a1c080e7          	jalr	-1508(ra) # 56fc <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3ce8:	34fd                	addiw	s1,s1,-1
    3cea:	f4ed                	bnez	s1,3cd4 <iref+0xfe>
  chdir("/");
    3cec:	00003517          	auipc	a0,0x3
    3cf0:	5a450513          	addi	a0,a0,1444 # 7290 <csem_up+0x159a>
    3cf4:	00002097          	auipc	ra,0x2
    3cf8:	a28080e7          	jalr	-1496(ra) # 571c <chdir>
}
    3cfc:	70e2                	ld	ra,56(sp)
    3cfe:	7442                	ld	s0,48(sp)
    3d00:	74a2                	ld	s1,40(sp)
    3d02:	7902                	ld	s2,32(sp)
    3d04:	69e2                	ld	s3,24(sp)
    3d06:	6a42                	ld	s4,16(sp)
    3d08:	6aa2                	ld	s5,8(sp)
    3d0a:	6b02                	ld	s6,0(sp)
    3d0c:	6121                	addi	sp,sp,64
    3d0e:	8082                	ret

0000000000003d10 <openiputtest>:
{
    3d10:	7179                	addi	sp,sp,-48
    3d12:	f406                	sd	ra,40(sp)
    3d14:	f022                	sd	s0,32(sp)
    3d16:	ec26                	sd	s1,24(sp)
    3d18:	1800                	addi	s0,sp,48
    3d1a:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3d1c:	00004517          	auipc	a0,0x4
    3d20:	dd450513          	addi	a0,a0,-556 # 7af0 <csem_up+0x1dfa>
    3d24:	00002097          	auipc	ra,0x2
    3d28:	9f0080e7          	jalr	-1552(ra) # 5714 <mkdir>
    3d2c:	04054263          	bltz	a0,3d70 <openiputtest+0x60>
  pid = fork();
    3d30:	00002097          	auipc	ra,0x2
    3d34:	974080e7          	jalr	-1676(ra) # 56a4 <fork>
  if(pid < 0){
    3d38:	04054a63          	bltz	a0,3d8c <openiputtest+0x7c>
  if(pid == 0){
    3d3c:	e93d                	bnez	a0,3db2 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3d3e:	4589                	li	a1,2
    3d40:	00004517          	auipc	a0,0x4
    3d44:	db050513          	addi	a0,a0,-592 # 7af0 <csem_up+0x1dfa>
    3d48:	00002097          	auipc	ra,0x2
    3d4c:	9a4080e7          	jalr	-1628(ra) # 56ec <open>
    if(fd >= 0){
    3d50:	04054c63          	bltz	a0,3da8 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3d54:	85a6                	mv	a1,s1
    3d56:	00004517          	auipc	a0,0x4
    3d5a:	dba50513          	addi	a0,a0,-582 # 7b10 <csem_up+0x1e1a>
    3d5e:	00002097          	auipc	ra,0x2
    3d62:	d20080e7          	jalr	-736(ra) # 5a7e <printf>
      exit(1);
    3d66:	4505                	li	a0,1
    3d68:	00002097          	auipc	ra,0x2
    3d6c:	944080e7          	jalr	-1724(ra) # 56ac <exit>
    printf("%s: mkdir oidir failed\n", s);
    3d70:	85a6                	mv	a1,s1
    3d72:	00004517          	auipc	a0,0x4
    3d76:	d8650513          	addi	a0,a0,-634 # 7af8 <csem_up+0x1e02>
    3d7a:	00002097          	auipc	ra,0x2
    3d7e:	d04080e7          	jalr	-764(ra) # 5a7e <printf>
    exit(1);
    3d82:	4505                	li	a0,1
    3d84:	00002097          	auipc	ra,0x2
    3d88:	928080e7          	jalr	-1752(ra) # 56ac <exit>
    printf("%s: fork failed\n", s);
    3d8c:	85a6                	mv	a1,s1
    3d8e:	00003517          	auipc	a0,0x3
    3d92:	b5250513          	addi	a0,a0,-1198 # 68e0 <csem_up+0xbea>
    3d96:	00002097          	auipc	ra,0x2
    3d9a:	ce8080e7          	jalr	-792(ra) # 5a7e <printf>
    exit(1);
    3d9e:	4505                	li	a0,1
    3da0:	00002097          	auipc	ra,0x2
    3da4:	90c080e7          	jalr	-1780(ra) # 56ac <exit>
    exit(0);
    3da8:	4501                	li	a0,0
    3daa:	00002097          	auipc	ra,0x2
    3dae:	902080e7          	jalr	-1790(ra) # 56ac <exit>
  sleep(1);
    3db2:	4505                	li	a0,1
    3db4:	00002097          	auipc	ra,0x2
    3db8:	988080e7          	jalr	-1656(ra) # 573c <sleep>
  if(unlink("oidir") != 0){
    3dbc:	00004517          	auipc	a0,0x4
    3dc0:	d3450513          	addi	a0,a0,-716 # 7af0 <csem_up+0x1dfa>
    3dc4:	00002097          	auipc	ra,0x2
    3dc8:	938080e7          	jalr	-1736(ra) # 56fc <unlink>
    3dcc:	cd19                	beqz	a0,3dea <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3dce:	85a6                	mv	a1,s1
    3dd0:	00003517          	auipc	a0,0x3
    3dd4:	d0050513          	addi	a0,a0,-768 # 6ad0 <csem_up+0xdda>
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	ca6080e7          	jalr	-858(ra) # 5a7e <printf>
    exit(1);
    3de0:	4505                	li	a0,1
    3de2:	00002097          	auipc	ra,0x2
    3de6:	8ca080e7          	jalr	-1846(ra) # 56ac <exit>
  wait(&xstatus);
    3dea:	fdc40513          	addi	a0,s0,-36
    3dee:	00002097          	auipc	ra,0x2
    3df2:	8c6080e7          	jalr	-1850(ra) # 56b4 <wait>
  exit(xstatus);
    3df6:	fdc42503          	lw	a0,-36(s0)
    3dfa:	00002097          	auipc	ra,0x2
    3dfe:	8b2080e7          	jalr	-1870(ra) # 56ac <exit>

0000000000003e02 <forkforkfork>:
{
    3e02:	1101                	addi	sp,sp,-32
    3e04:	ec06                	sd	ra,24(sp)
    3e06:	e822                	sd	s0,16(sp)
    3e08:	e426                	sd	s1,8(sp)
    3e0a:	1000                	addi	s0,sp,32
    3e0c:	84aa                	mv	s1,a0
  unlink("stopforking");
    3e0e:	00004517          	auipc	a0,0x4
    3e12:	d2a50513          	addi	a0,a0,-726 # 7b38 <csem_up+0x1e42>
    3e16:	00002097          	auipc	ra,0x2
    3e1a:	8e6080e7          	jalr	-1818(ra) # 56fc <unlink>
  int pid = fork();
    3e1e:	00002097          	auipc	ra,0x2
    3e22:	886080e7          	jalr	-1914(ra) # 56a4 <fork>
  if(pid < 0){
    3e26:	04054563          	bltz	a0,3e70 <forkforkfork+0x6e>
  if(pid == 0){
    3e2a:	c12d                	beqz	a0,3e8c <forkforkfork+0x8a>
  sleep(20); // two seconds
    3e2c:	4551                	li	a0,20
    3e2e:	00002097          	auipc	ra,0x2
    3e32:	90e080e7          	jalr	-1778(ra) # 573c <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3e36:	20200593          	li	a1,514
    3e3a:	00004517          	auipc	a0,0x4
    3e3e:	cfe50513          	addi	a0,a0,-770 # 7b38 <csem_up+0x1e42>
    3e42:	00002097          	auipc	ra,0x2
    3e46:	8aa080e7          	jalr	-1878(ra) # 56ec <open>
    3e4a:	00002097          	auipc	ra,0x2
    3e4e:	88a080e7          	jalr	-1910(ra) # 56d4 <close>
  wait(0);
    3e52:	4501                	li	a0,0
    3e54:	00002097          	auipc	ra,0x2
    3e58:	860080e7          	jalr	-1952(ra) # 56b4 <wait>
  sleep(10); // one second
    3e5c:	4529                	li	a0,10
    3e5e:	00002097          	auipc	ra,0x2
    3e62:	8de080e7          	jalr	-1826(ra) # 573c <sleep>
}
    3e66:	60e2                	ld	ra,24(sp)
    3e68:	6442                	ld	s0,16(sp)
    3e6a:	64a2                	ld	s1,8(sp)
    3e6c:	6105                	addi	sp,sp,32
    3e6e:	8082                	ret
    printf("%s: fork failed", s);
    3e70:	85a6                	mv	a1,s1
    3e72:	00003517          	auipc	a0,0x3
    3e76:	c2e50513          	addi	a0,a0,-978 # 6aa0 <csem_up+0xdaa>
    3e7a:	00002097          	auipc	ra,0x2
    3e7e:	c04080e7          	jalr	-1020(ra) # 5a7e <printf>
    exit(1);
    3e82:	4505                	li	a0,1
    3e84:	00002097          	auipc	ra,0x2
    3e88:	828080e7          	jalr	-2008(ra) # 56ac <exit>
      int fd = open("stopforking", 0);
    3e8c:	00004497          	auipc	s1,0x4
    3e90:	cac48493          	addi	s1,s1,-852 # 7b38 <csem_up+0x1e42>
    3e94:	4581                	li	a1,0
    3e96:	8526                	mv	a0,s1
    3e98:	00002097          	auipc	ra,0x2
    3e9c:	854080e7          	jalr	-1964(ra) # 56ec <open>
      if(fd >= 0){
    3ea0:	02055463          	bgez	a0,3ec8 <forkforkfork+0xc6>
      if(fork() < 0){
    3ea4:	00002097          	auipc	ra,0x2
    3ea8:	800080e7          	jalr	-2048(ra) # 56a4 <fork>
    3eac:	fe0554e3          	bgez	a0,3e94 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3eb0:	20200593          	li	a1,514
    3eb4:	8526                	mv	a0,s1
    3eb6:	00002097          	auipc	ra,0x2
    3eba:	836080e7          	jalr	-1994(ra) # 56ec <open>
    3ebe:	00002097          	auipc	ra,0x2
    3ec2:	816080e7          	jalr	-2026(ra) # 56d4 <close>
    3ec6:	b7f9                	j	3e94 <forkforkfork+0x92>
        exit(0);
    3ec8:	4501                	li	a0,0
    3eca:	00001097          	auipc	ra,0x1
    3ece:	7e2080e7          	jalr	2018(ra) # 56ac <exit>

0000000000003ed2 <killstatus>:
{
    3ed2:	7139                	addi	sp,sp,-64
    3ed4:	fc06                	sd	ra,56(sp)
    3ed6:	f822                	sd	s0,48(sp)
    3ed8:	f426                	sd	s1,40(sp)
    3eda:	f04a                	sd	s2,32(sp)
    3edc:	ec4e                	sd	s3,24(sp)
    3ede:	e852                	sd	s4,16(sp)
    3ee0:	0080                	addi	s0,sp,64
    3ee2:	8a2a                	mv	s4,a0
    3ee4:	06400913          	li	s2,100
    if(xst != -1) {
    3ee8:	59fd                	li	s3,-1
    int pid1 = fork();
    3eea:	00001097          	auipc	ra,0x1
    3eee:	7ba080e7          	jalr	1978(ra) # 56a4 <fork>
    3ef2:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3ef4:	04054063          	bltz	a0,3f34 <killstatus+0x62>
    if(pid1 == 0){
    3ef8:	cd21                	beqz	a0,3f50 <killstatus+0x7e>
    sleep(1);
    3efa:	4505                	li	a0,1
    3efc:	00002097          	auipc	ra,0x2
    3f00:	840080e7          	jalr	-1984(ra) # 573c <sleep>
    kill(pid1, SIGKILL);
    3f04:	45a5                	li	a1,9
    3f06:	8526                	mv	a0,s1
    3f08:	00001097          	auipc	ra,0x1
    3f0c:	7d4080e7          	jalr	2004(ra) # 56dc <kill>
    wait(&xst);
    3f10:	fcc40513          	addi	a0,s0,-52
    3f14:	00001097          	auipc	ra,0x1
    3f18:	7a0080e7          	jalr	1952(ra) # 56b4 <wait>
    if(xst != -1) {
    3f1c:	fcc42783          	lw	a5,-52(s0)
    3f20:	03379d63          	bne	a5,s3,3f5a <killstatus+0x88>
  for(int i = 0; i < 100; i++){
    3f24:	397d                	addiw	s2,s2,-1
    3f26:	fc0912e3          	bnez	s2,3eea <killstatus+0x18>
  exit(0);
    3f2a:	4501                	li	a0,0
    3f2c:	00001097          	auipc	ra,0x1
    3f30:	780080e7          	jalr	1920(ra) # 56ac <exit>
      printf("%s: fork failed\n", s);
    3f34:	85d2                	mv	a1,s4
    3f36:	00003517          	auipc	a0,0x3
    3f3a:	9aa50513          	addi	a0,a0,-1622 # 68e0 <csem_up+0xbea>
    3f3e:	00002097          	auipc	ra,0x2
    3f42:	b40080e7          	jalr	-1216(ra) # 5a7e <printf>
      exit(1);
    3f46:	4505                	li	a0,1
    3f48:	00001097          	auipc	ra,0x1
    3f4c:	764080e7          	jalr	1892(ra) # 56ac <exit>
        getpid();
    3f50:	00001097          	auipc	ra,0x1
    3f54:	7dc080e7          	jalr	2012(ra) # 572c <getpid>
      while(1) {
    3f58:	bfe5                	j	3f50 <killstatus+0x7e>
       printf("%s: status should be -1\n", s);
    3f5a:	85d2                	mv	a1,s4
    3f5c:	00004517          	auipc	a0,0x4
    3f60:	bec50513          	addi	a0,a0,-1044 # 7b48 <csem_up+0x1e52>
    3f64:	00002097          	auipc	ra,0x2
    3f68:	b1a080e7          	jalr	-1254(ra) # 5a7e <printf>
       exit(1);
    3f6c:	4505                	li	a0,1
    3f6e:	00001097          	auipc	ra,0x1
    3f72:	73e080e7          	jalr	1854(ra) # 56ac <exit>

0000000000003f76 <preempt>:
{
    3f76:	7139                	addi	sp,sp,-64
    3f78:	fc06                	sd	ra,56(sp)
    3f7a:	f822                	sd	s0,48(sp)
    3f7c:	f426                	sd	s1,40(sp)
    3f7e:	f04a                	sd	s2,32(sp)
    3f80:	ec4e                	sd	s3,24(sp)
    3f82:	e852                	sd	s4,16(sp)
    3f84:	0080                	addi	s0,sp,64
    3f86:	892a                	mv	s2,a0
  pid1 = fork();
    3f88:	00001097          	auipc	ra,0x1
    3f8c:	71c080e7          	jalr	1820(ra) # 56a4 <fork>
  if(pid1 < 0) {
    3f90:	00054563          	bltz	a0,3f9a <preempt+0x24>
    3f94:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3f96:	e105                	bnez	a0,3fb6 <preempt+0x40>
    for(;;)
    3f98:	a001                	j	3f98 <preempt+0x22>
    printf("%s: fork failed", s);
    3f9a:	85ca                	mv	a1,s2
    3f9c:	00003517          	auipc	a0,0x3
    3fa0:	b0450513          	addi	a0,a0,-1276 # 6aa0 <csem_up+0xdaa>
    3fa4:	00002097          	auipc	ra,0x2
    3fa8:	ada080e7          	jalr	-1318(ra) # 5a7e <printf>
    exit(1);
    3fac:	4505                	li	a0,1
    3fae:	00001097          	auipc	ra,0x1
    3fb2:	6fe080e7          	jalr	1790(ra) # 56ac <exit>
  pid2 = fork();
    3fb6:	00001097          	auipc	ra,0x1
    3fba:	6ee080e7          	jalr	1774(ra) # 56a4 <fork>
    3fbe:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3fc0:	00054463          	bltz	a0,3fc8 <preempt+0x52>
  if(pid2 == 0)
    3fc4:	e105                	bnez	a0,3fe4 <preempt+0x6e>
    for(;;)
    3fc6:	a001                	j	3fc6 <preempt+0x50>
    printf("%s: fork failed\n", s);
    3fc8:	85ca                	mv	a1,s2
    3fca:	00003517          	auipc	a0,0x3
    3fce:	91650513          	addi	a0,a0,-1770 # 68e0 <csem_up+0xbea>
    3fd2:	00002097          	auipc	ra,0x2
    3fd6:	aac080e7          	jalr	-1364(ra) # 5a7e <printf>
    exit(1);
    3fda:	4505                	li	a0,1
    3fdc:	00001097          	auipc	ra,0x1
    3fe0:	6d0080e7          	jalr	1744(ra) # 56ac <exit>
  pipe(pfds);
    3fe4:	fc840513          	addi	a0,s0,-56
    3fe8:	00001097          	auipc	ra,0x1
    3fec:	6d4080e7          	jalr	1748(ra) # 56bc <pipe>
  pid3 = fork();
    3ff0:	00001097          	auipc	ra,0x1
    3ff4:	6b4080e7          	jalr	1716(ra) # 56a4 <fork>
    3ff8:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3ffa:	02054e63          	bltz	a0,4036 <preempt+0xc0>
  if(pid3 == 0){
    3ffe:	e525                	bnez	a0,4066 <preempt+0xf0>
    close(pfds[0]);
    4000:	fc842503          	lw	a0,-56(s0)
    4004:	00001097          	auipc	ra,0x1
    4008:	6d0080e7          	jalr	1744(ra) # 56d4 <close>
    if(write(pfds[1], "x", 1) != 1)
    400c:	4605                	li	a2,1
    400e:	00002597          	auipc	a1,0x2
    4012:	10a58593          	addi	a1,a1,266 # 6118 <csem_up+0x422>
    4016:	fcc42503          	lw	a0,-52(s0)
    401a:	00001097          	auipc	ra,0x1
    401e:	6b2080e7          	jalr	1714(ra) # 56cc <write>
    4022:	4785                	li	a5,1
    4024:	02f51763          	bne	a0,a5,4052 <preempt+0xdc>
    close(pfds[1]);
    4028:	fcc42503          	lw	a0,-52(s0)
    402c:	00001097          	auipc	ra,0x1
    4030:	6a8080e7          	jalr	1704(ra) # 56d4 <close>
    for(;;)
    4034:	a001                	j	4034 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4036:	85ca                	mv	a1,s2
    4038:	00003517          	auipc	a0,0x3
    403c:	8a850513          	addi	a0,a0,-1880 # 68e0 <csem_up+0xbea>
    4040:	00002097          	auipc	ra,0x2
    4044:	a3e080e7          	jalr	-1474(ra) # 5a7e <printf>
     exit(1);
    4048:	4505                	li	a0,1
    404a:	00001097          	auipc	ra,0x1
    404e:	662080e7          	jalr	1634(ra) # 56ac <exit>
      printf("%s: preempt write error", s);
    4052:	85ca                	mv	a1,s2
    4054:	00004517          	auipc	a0,0x4
    4058:	b1450513          	addi	a0,a0,-1260 # 7b68 <csem_up+0x1e72>
    405c:	00002097          	auipc	ra,0x2
    4060:	a22080e7          	jalr	-1502(ra) # 5a7e <printf>
    4064:	b7d1                	j	4028 <preempt+0xb2>
  close(pfds[1]);
    4066:	fcc42503          	lw	a0,-52(s0)
    406a:	00001097          	auipc	ra,0x1
    406e:	66a080e7          	jalr	1642(ra) # 56d4 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4072:	660d                	lui	a2,0x3
    4074:	00008597          	auipc	a1,0x8
    4078:	c7c58593          	addi	a1,a1,-900 # bcf0 <buf>
    407c:	fc842503          	lw	a0,-56(s0)
    4080:	00001097          	auipc	ra,0x1
    4084:	644080e7          	jalr	1604(ra) # 56c4 <read>
    4088:	4785                	li	a5,1
    408a:	02f50363          	beq	a0,a5,40b0 <preempt+0x13a>
    printf("%s: preempt read error", s);
    408e:	85ca                	mv	a1,s2
    4090:	00004517          	auipc	a0,0x4
    4094:	af050513          	addi	a0,a0,-1296 # 7b80 <csem_up+0x1e8a>
    4098:	00002097          	auipc	ra,0x2
    409c:	9e6080e7          	jalr	-1562(ra) # 5a7e <printf>
}
    40a0:	70e2                	ld	ra,56(sp)
    40a2:	7442                	ld	s0,48(sp)
    40a4:	74a2                	ld	s1,40(sp)
    40a6:	7902                	ld	s2,32(sp)
    40a8:	69e2                	ld	s3,24(sp)
    40aa:	6a42                	ld	s4,16(sp)
    40ac:	6121                	addi	sp,sp,64
    40ae:	8082                	ret
  close(pfds[0]);
    40b0:	fc842503          	lw	a0,-56(s0)
    40b4:	00001097          	auipc	ra,0x1
    40b8:	620080e7          	jalr	1568(ra) # 56d4 <close>
  printf("kill... ");
    40bc:	00004517          	auipc	a0,0x4
    40c0:	adc50513          	addi	a0,a0,-1316 # 7b98 <csem_up+0x1ea2>
    40c4:	00002097          	auipc	ra,0x2
    40c8:	9ba080e7          	jalr	-1606(ra) # 5a7e <printf>
  kill(pid1, SIGKILL);
    40cc:	45a5                	li	a1,9
    40ce:	8526                	mv	a0,s1
    40d0:	00001097          	auipc	ra,0x1
    40d4:	60c080e7          	jalr	1548(ra) # 56dc <kill>
  kill(pid2, SIGKILL);
    40d8:	45a5                	li	a1,9
    40da:	854e                	mv	a0,s3
    40dc:	00001097          	auipc	ra,0x1
    40e0:	600080e7          	jalr	1536(ra) # 56dc <kill>
  kill(pid3, SIGKILL);
    40e4:	45a5                	li	a1,9
    40e6:	8552                	mv	a0,s4
    40e8:	00001097          	auipc	ra,0x1
    40ec:	5f4080e7          	jalr	1524(ra) # 56dc <kill>
  printf("wait... ");
    40f0:	00004517          	auipc	a0,0x4
    40f4:	ab850513          	addi	a0,a0,-1352 # 7ba8 <csem_up+0x1eb2>
    40f8:	00002097          	auipc	ra,0x2
    40fc:	986080e7          	jalr	-1658(ra) # 5a7e <printf>
  wait(0);
    4100:	4501                	li	a0,0
    4102:	00001097          	auipc	ra,0x1
    4106:	5b2080e7          	jalr	1458(ra) # 56b4 <wait>
  wait(0);
    410a:	4501                	li	a0,0
    410c:	00001097          	auipc	ra,0x1
    4110:	5a8080e7          	jalr	1448(ra) # 56b4 <wait>
  wait(0);
    4114:	4501                	li	a0,0
    4116:	00001097          	auipc	ra,0x1
    411a:	59e080e7          	jalr	1438(ra) # 56b4 <wait>
    411e:	b749                	j	40a0 <preempt+0x12a>

0000000000004120 <reparent>:
{
    4120:	7179                	addi	sp,sp,-48
    4122:	f406                	sd	ra,40(sp)
    4124:	f022                	sd	s0,32(sp)
    4126:	ec26                	sd	s1,24(sp)
    4128:	e84a                	sd	s2,16(sp)
    412a:	e44e                	sd	s3,8(sp)
    412c:	e052                	sd	s4,0(sp)
    412e:	1800                	addi	s0,sp,48
    4130:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4132:	00001097          	auipc	ra,0x1
    4136:	5fa080e7          	jalr	1530(ra) # 572c <getpid>
    413a:	8a2a                	mv	s4,a0
    413c:	0c800913          	li	s2,200
    int pid = fork();
    4140:	00001097          	auipc	ra,0x1
    4144:	564080e7          	jalr	1380(ra) # 56a4 <fork>
    4148:	84aa                	mv	s1,a0
    if(pid < 0){
    414a:	02054263          	bltz	a0,416e <reparent+0x4e>
    if(pid){
    414e:	cd21                	beqz	a0,41a6 <reparent+0x86>
      if(wait(0) != pid){
    4150:	4501                	li	a0,0
    4152:	00001097          	auipc	ra,0x1
    4156:	562080e7          	jalr	1378(ra) # 56b4 <wait>
    415a:	02951863          	bne	a0,s1,418a <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    415e:	397d                	addiw	s2,s2,-1
    4160:	fe0910e3          	bnez	s2,4140 <reparent+0x20>
  exit(0);
    4164:	4501                	li	a0,0
    4166:	00001097          	auipc	ra,0x1
    416a:	546080e7          	jalr	1350(ra) # 56ac <exit>
      printf("%s: fork failed\n", s);
    416e:	85ce                	mv	a1,s3
    4170:	00002517          	auipc	a0,0x2
    4174:	77050513          	addi	a0,a0,1904 # 68e0 <csem_up+0xbea>
    4178:	00002097          	auipc	ra,0x2
    417c:	906080e7          	jalr	-1786(ra) # 5a7e <printf>
      exit(1);
    4180:	4505                	li	a0,1
    4182:	00001097          	auipc	ra,0x1
    4186:	52a080e7          	jalr	1322(ra) # 56ac <exit>
        printf("%s: wait wrong pid\n", s);
    418a:	85ce                	mv	a1,s3
    418c:	00003517          	auipc	a0,0x3
    4190:	8dc50513          	addi	a0,a0,-1828 # 6a68 <csem_up+0xd72>
    4194:	00002097          	auipc	ra,0x2
    4198:	8ea080e7          	jalr	-1814(ra) # 5a7e <printf>
        exit(1);
    419c:	4505                	li	a0,1
    419e:	00001097          	auipc	ra,0x1
    41a2:	50e080e7          	jalr	1294(ra) # 56ac <exit>
      int pid2 = fork();
    41a6:	00001097          	auipc	ra,0x1
    41aa:	4fe080e7          	jalr	1278(ra) # 56a4 <fork>
      if(pid2 < 0){
    41ae:	00054763          	bltz	a0,41bc <reparent+0x9c>
      exit(0);
    41b2:	4501                	li	a0,0
    41b4:	00001097          	auipc	ra,0x1
    41b8:	4f8080e7          	jalr	1272(ra) # 56ac <exit>
        kill(master_pid, SIGKILL);
    41bc:	45a5                	li	a1,9
    41be:	8552                	mv	a0,s4
    41c0:	00001097          	auipc	ra,0x1
    41c4:	51c080e7          	jalr	1308(ra) # 56dc <kill>
        exit(1);
    41c8:	4505                	li	a0,1
    41ca:	00001097          	auipc	ra,0x1
    41ce:	4e2080e7          	jalr	1250(ra) # 56ac <exit>

00000000000041d2 <sbrkfail>:
{
    41d2:	7119                	addi	sp,sp,-128
    41d4:	fc86                	sd	ra,120(sp)
    41d6:	f8a2                	sd	s0,112(sp)
    41d8:	f4a6                	sd	s1,104(sp)
    41da:	f0ca                	sd	s2,96(sp)
    41dc:	ecce                	sd	s3,88(sp)
    41de:	e8d2                	sd	s4,80(sp)
    41e0:	e4d6                	sd	s5,72(sp)
    41e2:	0100                	addi	s0,sp,128
    41e4:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    41e6:	fb040513          	addi	a0,s0,-80
    41ea:	00001097          	auipc	ra,0x1
    41ee:	4d2080e7          	jalr	1234(ra) # 56bc <pipe>
    41f2:	e901                	bnez	a0,4202 <sbrkfail+0x30>
    41f4:	f8040493          	addi	s1,s0,-128
    41f8:	fa840993          	addi	s3,s0,-88
    41fc:	8926                	mv	s2,s1
    if(pids[i] != -1)
    41fe:	5a7d                	li	s4,-1
    4200:	a085                	j	4260 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4202:	85d6                	mv	a1,s5
    4204:	00002517          	auipc	a0,0x2
    4208:	7e450513          	addi	a0,a0,2020 # 69e8 <csem_up+0xcf2>
    420c:	00002097          	auipc	ra,0x2
    4210:	872080e7          	jalr	-1934(ra) # 5a7e <printf>
    exit(1);
    4214:	4505                	li	a0,1
    4216:	00001097          	auipc	ra,0x1
    421a:	496080e7          	jalr	1174(ra) # 56ac <exit>
      sbrk(BIG - (uint64)sbrk(0));
    421e:	00001097          	auipc	ra,0x1
    4222:	516080e7          	jalr	1302(ra) # 5734 <sbrk>
    4226:	064007b7          	lui	a5,0x6400
    422a:	40a7853b          	subw	a0,a5,a0
    422e:	00001097          	auipc	ra,0x1
    4232:	506080e7          	jalr	1286(ra) # 5734 <sbrk>
      write(fds[1], "x", 1);
    4236:	4605                	li	a2,1
    4238:	00002597          	auipc	a1,0x2
    423c:	ee058593          	addi	a1,a1,-288 # 6118 <csem_up+0x422>
    4240:	fb442503          	lw	a0,-76(s0)
    4244:	00001097          	auipc	ra,0x1
    4248:	488080e7          	jalr	1160(ra) # 56cc <write>
      for(;;) sleep(1000);
    424c:	3e800513          	li	a0,1000
    4250:	00001097          	auipc	ra,0x1
    4254:	4ec080e7          	jalr	1260(ra) # 573c <sleep>
    4258:	bfd5                	j	424c <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    425a:	0911                	addi	s2,s2,4
    425c:	03390563          	beq	s2,s3,4286 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4260:	00001097          	auipc	ra,0x1
    4264:	444080e7          	jalr	1092(ra) # 56a4 <fork>
    4268:	00a92023          	sw	a0,0(s2)
    426c:	d94d                	beqz	a0,421e <sbrkfail+0x4c>
    if(pids[i] != -1)
    426e:	ff4506e3          	beq	a0,s4,425a <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4272:	4605                	li	a2,1
    4274:	faf40593          	addi	a1,s0,-81
    4278:	fb042503          	lw	a0,-80(s0)
    427c:	00001097          	auipc	ra,0x1
    4280:	448080e7          	jalr	1096(ra) # 56c4 <read>
    4284:	bfd9                	j	425a <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    4286:	6505                	lui	a0,0x1
    4288:	00001097          	auipc	ra,0x1
    428c:	4ac080e7          	jalr	1196(ra) # 5734 <sbrk>
    4290:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4292:	597d                	li	s2,-1
    4294:	a021                	j	429c <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4296:	0491                	addi	s1,s1,4
    4298:	03348063          	beq	s1,s3,42b8 <sbrkfail+0xe6>
    if(pids[i] == -1)
    429c:	4088                	lw	a0,0(s1)
    429e:	ff250ce3          	beq	a0,s2,4296 <sbrkfail+0xc4>
    kill(pids[i], SIGKILL);
    42a2:	45a5                	li	a1,9
    42a4:	00001097          	auipc	ra,0x1
    42a8:	438080e7          	jalr	1080(ra) # 56dc <kill>
    wait(0);
    42ac:	4501                	li	a0,0
    42ae:	00001097          	auipc	ra,0x1
    42b2:	406080e7          	jalr	1030(ra) # 56b4 <wait>
    42b6:	b7c5                	j	4296 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    42b8:	57fd                	li	a5,-1
    42ba:	04fa0163          	beq	s4,a5,42fc <sbrkfail+0x12a>
  pid = fork();
    42be:	00001097          	auipc	ra,0x1
    42c2:	3e6080e7          	jalr	998(ra) # 56a4 <fork>
    42c6:	84aa                	mv	s1,a0
  if(pid < 0){
    42c8:	04054863          	bltz	a0,4318 <sbrkfail+0x146>
  if(pid == 0){
    42cc:	c525                	beqz	a0,4334 <sbrkfail+0x162>
  wait(&xstatus);
    42ce:	fbc40513          	addi	a0,s0,-68
    42d2:	00001097          	auipc	ra,0x1
    42d6:	3e2080e7          	jalr	994(ra) # 56b4 <wait>
  if(xstatus != -1 && xstatus != 2)
    42da:	fbc42783          	lw	a5,-68(s0)
    42de:	577d                	li	a4,-1
    42e0:	00e78563          	beq	a5,a4,42ea <sbrkfail+0x118>
    42e4:	4709                	li	a4,2
    42e6:	08e79d63          	bne	a5,a4,4380 <sbrkfail+0x1ae>
}
    42ea:	70e6                	ld	ra,120(sp)
    42ec:	7446                	ld	s0,112(sp)
    42ee:	74a6                	ld	s1,104(sp)
    42f0:	7906                	ld	s2,96(sp)
    42f2:	69e6                	ld	s3,88(sp)
    42f4:	6a46                	ld	s4,80(sp)
    42f6:	6aa6                	ld	s5,72(sp)
    42f8:	6109                	addi	sp,sp,128
    42fa:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    42fc:	85d6                	mv	a1,s5
    42fe:	00004517          	auipc	a0,0x4
    4302:	8ba50513          	addi	a0,a0,-1862 # 7bb8 <csem_up+0x1ec2>
    4306:	00001097          	auipc	ra,0x1
    430a:	778080e7          	jalr	1912(ra) # 5a7e <printf>
    exit(1);
    430e:	4505                	li	a0,1
    4310:	00001097          	auipc	ra,0x1
    4314:	39c080e7          	jalr	924(ra) # 56ac <exit>
    printf("%s: fork failed\n", s);
    4318:	85d6                	mv	a1,s5
    431a:	00002517          	auipc	a0,0x2
    431e:	5c650513          	addi	a0,a0,1478 # 68e0 <csem_up+0xbea>
    4322:	00001097          	auipc	ra,0x1
    4326:	75c080e7          	jalr	1884(ra) # 5a7e <printf>
    exit(1);
    432a:	4505                	li	a0,1
    432c:	00001097          	auipc	ra,0x1
    4330:	380080e7          	jalr	896(ra) # 56ac <exit>
    a = sbrk(0);
    4334:	4501                	li	a0,0
    4336:	00001097          	auipc	ra,0x1
    433a:	3fe080e7          	jalr	1022(ra) # 5734 <sbrk>
    433e:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4340:	3e800537          	lui	a0,0x3e800
    4344:	00001097          	auipc	ra,0x1
    4348:	3f0080e7          	jalr	1008(ra) # 5734 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    434c:	87ca                	mv	a5,s2
    434e:	3e800737          	lui	a4,0x3e800
    4352:	993a                	add	s2,s2,a4
    4354:	6705                	lui	a4,0x1
      n += *(a+i);
    4356:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f1300>
    435a:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    435c:	97ba                	add	a5,a5,a4
    435e:	ff279ce3          	bne	a5,s2,4356 <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4362:	8626                	mv	a2,s1
    4364:	85d6                	mv	a1,s5
    4366:	00004517          	auipc	a0,0x4
    436a:	87250513          	addi	a0,a0,-1934 # 7bd8 <csem_up+0x1ee2>
    436e:	00001097          	auipc	ra,0x1
    4372:	710080e7          	jalr	1808(ra) # 5a7e <printf>
    exit(1);
    4376:	4505                	li	a0,1
    4378:	00001097          	auipc	ra,0x1
    437c:	334080e7          	jalr	820(ra) # 56ac <exit>
    exit(1);
    4380:	4505                	li	a0,1
    4382:	00001097          	auipc	ra,0x1
    4386:	32a080e7          	jalr	810(ra) # 56ac <exit>

000000000000438a <mem>:
{
    438a:	7139                	addi	sp,sp,-64
    438c:	fc06                	sd	ra,56(sp)
    438e:	f822                	sd	s0,48(sp)
    4390:	f426                	sd	s1,40(sp)
    4392:	f04a                	sd	s2,32(sp)
    4394:	ec4e                	sd	s3,24(sp)
    4396:	0080                	addi	s0,sp,64
    4398:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    439a:	00001097          	auipc	ra,0x1
    439e:	30a080e7          	jalr	778(ra) # 56a4 <fork>
    m1 = 0;
    43a2:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    43a4:	6909                	lui	s2,0x2
    43a6:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x159>
  if((pid = fork()) == 0){
    43aa:	c115                	beqz	a0,43ce <mem+0x44>
    wait(&xstatus);
    43ac:	fcc40513          	addi	a0,s0,-52
    43b0:	00001097          	auipc	ra,0x1
    43b4:	304080e7          	jalr	772(ra) # 56b4 <wait>
    if(xstatus == -1){
    43b8:	fcc42503          	lw	a0,-52(s0)
    43bc:	57fd                	li	a5,-1
    43be:	06f50363          	beq	a0,a5,4424 <mem+0x9a>
    exit(xstatus);
    43c2:	00001097          	auipc	ra,0x1
    43c6:	2ea080e7          	jalr	746(ra) # 56ac <exit>
      *(char**)m2 = m1;
    43ca:	e104                	sd	s1,0(a0)
      m1 = m2;
    43cc:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    43ce:	854a                	mv	a0,s2
    43d0:	00001097          	auipc	ra,0x1
    43d4:	76c080e7          	jalr	1900(ra) # 5b3c <malloc>
    43d8:	f96d                	bnez	a0,43ca <mem+0x40>
    while(m1){
    43da:	c881                	beqz	s1,43ea <mem+0x60>
      m2 = *(char**)m1;
    43dc:	8526                	mv	a0,s1
    43de:	6084                	ld	s1,0(s1)
      free(m1);
    43e0:	00001097          	auipc	ra,0x1
    43e4:	6d4080e7          	jalr	1748(ra) # 5ab4 <free>
    while(m1){
    43e8:	f8f5                	bnez	s1,43dc <mem+0x52>
    m1 = malloc(1024*20);
    43ea:	6515                	lui	a0,0x5
    43ec:	00001097          	auipc	ra,0x1
    43f0:	750080e7          	jalr	1872(ra) # 5b3c <malloc>
    if(m1 == 0){
    43f4:	c911                	beqz	a0,4408 <mem+0x7e>
    free(m1);
    43f6:	00001097          	auipc	ra,0x1
    43fa:	6be080e7          	jalr	1726(ra) # 5ab4 <free>
    exit(0);
    43fe:	4501                	li	a0,0
    4400:	00001097          	auipc	ra,0x1
    4404:	2ac080e7          	jalr	684(ra) # 56ac <exit>
      printf("couldn't allocate mem?!!\n", s);
    4408:	85ce                	mv	a1,s3
    440a:	00003517          	auipc	a0,0x3
    440e:	7fe50513          	addi	a0,a0,2046 # 7c08 <csem_up+0x1f12>
    4412:	00001097          	auipc	ra,0x1
    4416:	66c080e7          	jalr	1644(ra) # 5a7e <printf>
      exit(1);
    441a:	4505                	li	a0,1
    441c:	00001097          	auipc	ra,0x1
    4420:	290080e7          	jalr	656(ra) # 56ac <exit>
      exit(0);
    4424:	4501                	li	a0,0
    4426:	00001097          	auipc	ra,0x1
    442a:	286080e7          	jalr	646(ra) # 56ac <exit>

000000000000442e <sharedfd>:
{
    442e:	7159                	addi	sp,sp,-112
    4430:	f486                	sd	ra,104(sp)
    4432:	f0a2                	sd	s0,96(sp)
    4434:	eca6                	sd	s1,88(sp)
    4436:	e8ca                	sd	s2,80(sp)
    4438:	e4ce                	sd	s3,72(sp)
    443a:	e0d2                	sd	s4,64(sp)
    443c:	fc56                	sd	s5,56(sp)
    443e:	f85a                	sd	s6,48(sp)
    4440:	f45e                	sd	s7,40(sp)
    4442:	1880                	addi	s0,sp,112
    4444:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4446:	00002517          	auipc	a0,0x2
    444a:	a9250513          	addi	a0,a0,-1390 # 5ed8 <csem_up+0x1e2>
    444e:	00001097          	auipc	ra,0x1
    4452:	2ae080e7          	jalr	686(ra) # 56fc <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4456:	20200593          	li	a1,514
    445a:	00002517          	auipc	a0,0x2
    445e:	a7e50513          	addi	a0,a0,-1410 # 5ed8 <csem_up+0x1e2>
    4462:	00001097          	auipc	ra,0x1
    4466:	28a080e7          	jalr	650(ra) # 56ec <open>
  if(fd < 0){
    446a:	04054a63          	bltz	a0,44be <sharedfd+0x90>
    446e:	892a                	mv	s2,a0
  pid = fork();
    4470:	00001097          	auipc	ra,0x1
    4474:	234080e7          	jalr	564(ra) # 56a4 <fork>
    4478:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    447a:	06300593          	li	a1,99
    447e:	c119                	beqz	a0,4484 <sharedfd+0x56>
    4480:	07000593          	li	a1,112
    4484:	4629                	li	a2,10
    4486:	fa040513          	addi	a0,s0,-96
    448a:	00001097          	auipc	ra,0x1
    448e:	026080e7          	jalr	38(ra) # 54b0 <memset>
    4492:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4496:	4629                	li	a2,10
    4498:	fa040593          	addi	a1,s0,-96
    449c:	854a                	mv	a0,s2
    449e:	00001097          	auipc	ra,0x1
    44a2:	22e080e7          	jalr	558(ra) # 56cc <write>
    44a6:	47a9                	li	a5,10
    44a8:	02f51963          	bne	a0,a5,44da <sharedfd+0xac>
  for(i = 0; i < N; i++){
    44ac:	34fd                	addiw	s1,s1,-1
    44ae:	f4e5                	bnez	s1,4496 <sharedfd+0x68>
  if(pid == 0) {
    44b0:	04099363          	bnez	s3,44f6 <sharedfd+0xc8>
    exit(0);
    44b4:	4501                	li	a0,0
    44b6:	00001097          	auipc	ra,0x1
    44ba:	1f6080e7          	jalr	502(ra) # 56ac <exit>
    printf("%s: cannot open sharedfd for writing", s);
    44be:	85d2                	mv	a1,s4
    44c0:	00003517          	auipc	a0,0x3
    44c4:	76850513          	addi	a0,a0,1896 # 7c28 <csem_up+0x1f32>
    44c8:	00001097          	auipc	ra,0x1
    44cc:	5b6080e7          	jalr	1462(ra) # 5a7e <printf>
    exit(1);
    44d0:	4505                	li	a0,1
    44d2:	00001097          	auipc	ra,0x1
    44d6:	1da080e7          	jalr	474(ra) # 56ac <exit>
      printf("%s: write sharedfd failed\n", s);
    44da:	85d2                	mv	a1,s4
    44dc:	00003517          	auipc	a0,0x3
    44e0:	77450513          	addi	a0,a0,1908 # 7c50 <csem_up+0x1f5a>
    44e4:	00001097          	auipc	ra,0x1
    44e8:	59a080e7          	jalr	1434(ra) # 5a7e <printf>
      exit(1);
    44ec:	4505                	li	a0,1
    44ee:	00001097          	auipc	ra,0x1
    44f2:	1be080e7          	jalr	446(ra) # 56ac <exit>
    wait(&xstatus);
    44f6:	f9c40513          	addi	a0,s0,-100
    44fa:	00001097          	auipc	ra,0x1
    44fe:	1ba080e7          	jalr	442(ra) # 56b4 <wait>
    if(xstatus != 0)
    4502:	f9c42983          	lw	s3,-100(s0)
    4506:	00098763          	beqz	s3,4514 <sharedfd+0xe6>
      exit(xstatus);
    450a:	854e                	mv	a0,s3
    450c:	00001097          	auipc	ra,0x1
    4510:	1a0080e7          	jalr	416(ra) # 56ac <exit>
  close(fd);
    4514:	854a                	mv	a0,s2
    4516:	00001097          	auipc	ra,0x1
    451a:	1be080e7          	jalr	446(ra) # 56d4 <close>
  fd = open("sharedfd", 0);
    451e:	4581                	li	a1,0
    4520:	00002517          	auipc	a0,0x2
    4524:	9b850513          	addi	a0,a0,-1608 # 5ed8 <csem_up+0x1e2>
    4528:	00001097          	auipc	ra,0x1
    452c:	1c4080e7          	jalr	452(ra) # 56ec <open>
    4530:	8baa                	mv	s7,a0
  nc = np = 0;
    4532:	8ace                	mv	s5,s3
  if(fd < 0){
    4534:	02054563          	bltz	a0,455e <sharedfd+0x130>
    4538:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    453c:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4540:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4544:	4629                	li	a2,10
    4546:	fa040593          	addi	a1,s0,-96
    454a:	855e                	mv	a0,s7
    454c:	00001097          	auipc	ra,0x1
    4550:	178080e7          	jalr	376(ra) # 56c4 <read>
    4554:	02a05f63          	blez	a0,4592 <sharedfd+0x164>
    4558:	fa040793          	addi	a5,s0,-96
    455c:	a01d                	j	4582 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    455e:	85d2                	mv	a1,s4
    4560:	00003517          	auipc	a0,0x3
    4564:	71050513          	addi	a0,a0,1808 # 7c70 <csem_up+0x1f7a>
    4568:	00001097          	auipc	ra,0x1
    456c:	516080e7          	jalr	1302(ra) # 5a7e <printf>
    exit(1);
    4570:	4505                	li	a0,1
    4572:	00001097          	auipc	ra,0x1
    4576:	13a080e7          	jalr	314(ra) # 56ac <exit>
        nc++;
    457a:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    457c:	0785                	addi	a5,a5,1
    457e:	fd2783e3          	beq	a5,s2,4544 <sharedfd+0x116>
      if(buf[i] == 'c')
    4582:	0007c703          	lbu	a4,0(a5)
    4586:	fe970ae3          	beq	a4,s1,457a <sharedfd+0x14c>
      if(buf[i] == 'p')
    458a:	ff6719e3          	bne	a4,s6,457c <sharedfd+0x14e>
        np++;
    458e:	2a85                	addiw	s5,s5,1
    4590:	b7f5                	j	457c <sharedfd+0x14e>
  close(fd);
    4592:	855e                	mv	a0,s7
    4594:	00001097          	auipc	ra,0x1
    4598:	140080e7          	jalr	320(ra) # 56d4 <close>
  unlink("sharedfd");
    459c:	00002517          	auipc	a0,0x2
    45a0:	93c50513          	addi	a0,a0,-1732 # 5ed8 <csem_up+0x1e2>
    45a4:	00001097          	auipc	ra,0x1
    45a8:	158080e7          	jalr	344(ra) # 56fc <unlink>
  if(nc == N*SZ && np == N*SZ){
    45ac:	6789                	lui	a5,0x2
    45ae:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x158>
    45b2:	00f99763          	bne	s3,a5,45c0 <sharedfd+0x192>
    45b6:	6789                	lui	a5,0x2
    45b8:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x158>
    45bc:	02fa8063          	beq	s5,a5,45dc <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    45c0:	85d2                	mv	a1,s4
    45c2:	00003517          	auipc	a0,0x3
    45c6:	6d650513          	addi	a0,a0,1750 # 7c98 <csem_up+0x1fa2>
    45ca:	00001097          	auipc	ra,0x1
    45ce:	4b4080e7          	jalr	1204(ra) # 5a7e <printf>
    exit(1);
    45d2:	4505                	li	a0,1
    45d4:	00001097          	auipc	ra,0x1
    45d8:	0d8080e7          	jalr	216(ra) # 56ac <exit>
    exit(0);
    45dc:	4501                	li	a0,0
    45de:	00001097          	auipc	ra,0x1
    45e2:	0ce080e7          	jalr	206(ra) # 56ac <exit>

00000000000045e6 <fourfiles>:
{
    45e6:	7171                	addi	sp,sp,-176
    45e8:	f506                	sd	ra,168(sp)
    45ea:	f122                	sd	s0,160(sp)
    45ec:	ed26                	sd	s1,152(sp)
    45ee:	e94a                	sd	s2,144(sp)
    45f0:	e54e                	sd	s3,136(sp)
    45f2:	e152                	sd	s4,128(sp)
    45f4:	fcd6                	sd	s5,120(sp)
    45f6:	f8da                	sd	s6,112(sp)
    45f8:	f4de                	sd	s7,104(sp)
    45fa:	f0e2                	sd	s8,96(sp)
    45fc:	ece6                	sd	s9,88(sp)
    45fe:	e8ea                	sd	s10,80(sp)
    4600:	e4ee                	sd	s11,72(sp)
    4602:	1900                	addi	s0,sp,176
    4604:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    4608:	00001797          	auipc	a5,0x1
    460c:	73878793          	addi	a5,a5,1848 # 5d40 <csem_up+0x4a>
    4610:	f6f43823          	sd	a5,-144(s0)
    4614:	00001797          	auipc	a5,0x1
    4618:	73478793          	addi	a5,a5,1844 # 5d48 <csem_up+0x52>
    461c:	f6f43c23          	sd	a5,-136(s0)
    4620:	00001797          	auipc	a5,0x1
    4624:	73078793          	addi	a5,a5,1840 # 5d50 <csem_up+0x5a>
    4628:	f8f43023          	sd	a5,-128(s0)
    462c:	00001797          	auipc	a5,0x1
    4630:	72c78793          	addi	a5,a5,1836 # 5d58 <csem_up+0x62>
    4634:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4638:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    463c:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    463e:	4481                	li	s1,0
    4640:	4a11                	li	s4,4
    fname = names[pi];
    4642:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4646:	854e                	mv	a0,s3
    4648:	00001097          	auipc	ra,0x1
    464c:	0b4080e7          	jalr	180(ra) # 56fc <unlink>
    pid = fork();
    4650:	00001097          	auipc	ra,0x1
    4654:	054080e7          	jalr	84(ra) # 56a4 <fork>
    if(pid < 0){
    4658:	04054463          	bltz	a0,46a0 <fourfiles+0xba>
    if(pid == 0){
    465c:	c12d                	beqz	a0,46be <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    465e:	2485                	addiw	s1,s1,1
    4660:	0921                	addi	s2,s2,8
    4662:	ff4490e3          	bne	s1,s4,4642 <fourfiles+0x5c>
    4666:	4491                	li	s1,4
    wait(&xstatus);
    4668:	f6c40513          	addi	a0,s0,-148
    466c:	00001097          	auipc	ra,0x1
    4670:	048080e7          	jalr	72(ra) # 56b4 <wait>
    if(xstatus != 0)
    4674:	f6c42b03          	lw	s6,-148(s0)
    4678:	0c0b1e63          	bnez	s6,4754 <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    467c:	34fd                	addiw	s1,s1,-1
    467e:	f4ed                	bnez	s1,4668 <fourfiles+0x82>
    4680:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4684:	00007a17          	auipc	s4,0x7
    4688:	66ca0a13          	addi	s4,s4,1644 # bcf0 <buf>
    468c:	00007a97          	auipc	s5,0x7
    4690:	665a8a93          	addi	s5,s5,1637 # bcf1 <buf+0x1>
    if(total != N*SZ){
    4694:	6d85                	lui	s11,0x1
    4696:	770d8d93          	addi	s11,s11,1904 # 1770 <pipe1+0x32>
  for(i = 0; i < NCHILD; i++){
    469a:	03400d13          	li	s10,52
    469e:	aa1d                	j	47d4 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    46a0:	f5843583          	ld	a1,-168(s0)
    46a4:	00002517          	auipc	a0,0x2
    46a8:	64450513          	addi	a0,a0,1604 # 6ce8 <csem_up+0xff2>
    46ac:	00001097          	auipc	ra,0x1
    46b0:	3d2080e7          	jalr	978(ra) # 5a7e <printf>
      exit(1);
    46b4:	4505                	li	a0,1
    46b6:	00001097          	auipc	ra,0x1
    46ba:	ff6080e7          	jalr	-10(ra) # 56ac <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    46be:	20200593          	li	a1,514
    46c2:	854e                	mv	a0,s3
    46c4:	00001097          	auipc	ra,0x1
    46c8:	028080e7          	jalr	40(ra) # 56ec <open>
    46cc:	892a                	mv	s2,a0
      if(fd < 0){
    46ce:	04054763          	bltz	a0,471c <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    46d2:	1f400613          	li	a2,500
    46d6:	0304859b          	addiw	a1,s1,48
    46da:	00007517          	auipc	a0,0x7
    46de:	61650513          	addi	a0,a0,1558 # bcf0 <buf>
    46e2:	00001097          	auipc	ra,0x1
    46e6:	dce080e7          	jalr	-562(ra) # 54b0 <memset>
    46ea:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    46ec:	00007997          	auipc	s3,0x7
    46f0:	60498993          	addi	s3,s3,1540 # bcf0 <buf>
    46f4:	1f400613          	li	a2,500
    46f8:	85ce                	mv	a1,s3
    46fa:	854a                	mv	a0,s2
    46fc:	00001097          	auipc	ra,0x1
    4700:	fd0080e7          	jalr	-48(ra) # 56cc <write>
    4704:	85aa                	mv	a1,a0
    4706:	1f400793          	li	a5,500
    470a:	02f51863          	bne	a0,a5,473a <fourfiles+0x154>
      for(i = 0; i < N; i++){
    470e:	34fd                	addiw	s1,s1,-1
    4710:	f0f5                	bnez	s1,46f4 <fourfiles+0x10e>
      exit(0);
    4712:	4501                	li	a0,0
    4714:	00001097          	auipc	ra,0x1
    4718:	f98080e7          	jalr	-104(ra) # 56ac <exit>
        printf("create failed\n", s);
    471c:	f5843583          	ld	a1,-168(s0)
    4720:	00003517          	auipc	a0,0x3
    4724:	59050513          	addi	a0,a0,1424 # 7cb0 <csem_up+0x1fba>
    4728:	00001097          	auipc	ra,0x1
    472c:	356080e7          	jalr	854(ra) # 5a7e <printf>
        exit(1);
    4730:	4505                	li	a0,1
    4732:	00001097          	auipc	ra,0x1
    4736:	f7a080e7          	jalr	-134(ra) # 56ac <exit>
          printf("write failed %d\n", n);
    473a:	00003517          	auipc	a0,0x3
    473e:	58650513          	addi	a0,a0,1414 # 7cc0 <csem_up+0x1fca>
    4742:	00001097          	auipc	ra,0x1
    4746:	33c080e7          	jalr	828(ra) # 5a7e <printf>
          exit(1);
    474a:	4505                	li	a0,1
    474c:	00001097          	auipc	ra,0x1
    4750:	f60080e7          	jalr	-160(ra) # 56ac <exit>
      exit(xstatus);
    4754:	855a                	mv	a0,s6
    4756:	00001097          	auipc	ra,0x1
    475a:	f56080e7          	jalr	-170(ra) # 56ac <exit>
          printf("wrong char\n", s);
    475e:	f5843583          	ld	a1,-168(s0)
    4762:	00003517          	auipc	a0,0x3
    4766:	57650513          	addi	a0,a0,1398 # 7cd8 <csem_up+0x1fe2>
    476a:	00001097          	auipc	ra,0x1
    476e:	314080e7          	jalr	788(ra) # 5a7e <printf>
          exit(1);
    4772:	4505                	li	a0,1
    4774:	00001097          	auipc	ra,0x1
    4778:	f38080e7          	jalr	-200(ra) # 56ac <exit>
      total += n;
    477c:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4780:	660d                	lui	a2,0x3
    4782:	85d2                	mv	a1,s4
    4784:	854e                	mv	a0,s3
    4786:	00001097          	auipc	ra,0x1
    478a:	f3e080e7          	jalr	-194(ra) # 56c4 <read>
    478e:	02a05363          	blez	a0,47b4 <fourfiles+0x1ce>
    4792:	00007797          	auipc	a5,0x7
    4796:	55e78793          	addi	a5,a5,1374 # bcf0 <buf>
    479a:	fff5069b          	addiw	a3,a0,-1
    479e:	1682                	slli	a3,a3,0x20
    47a0:	9281                	srli	a3,a3,0x20
    47a2:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    47a4:	0007c703          	lbu	a4,0(a5)
    47a8:	fa971be3          	bne	a4,s1,475e <fourfiles+0x178>
      for(j = 0; j < n; j++){
    47ac:	0785                	addi	a5,a5,1
    47ae:	fed79be3          	bne	a5,a3,47a4 <fourfiles+0x1be>
    47b2:	b7e9                	j	477c <fourfiles+0x196>
    close(fd);
    47b4:	854e                	mv	a0,s3
    47b6:	00001097          	auipc	ra,0x1
    47ba:	f1e080e7          	jalr	-226(ra) # 56d4 <close>
    if(total != N*SZ){
    47be:	03b91863          	bne	s2,s11,47ee <fourfiles+0x208>
    unlink(fname);
    47c2:	8566                	mv	a0,s9
    47c4:	00001097          	auipc	ra,0x1
    47c8:	f38080e7          	jalr	-200(ra) # 56fc <unlink>
  for(i = 0; i < NCHILD; i++){
    47cc:	0c21                	addi	s8,s8,8
    47ce:	2b85                	addiw	s7,s7,1
    47d0:	03ab8d63          	beq	s7,s10,480a <fourfiles+0x224>
    fname = names[i];
    47d4:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    47d8:	4581                	li	a1,0
    47da:	8566                	mv	a0,s9
    47dc:	00001097          	auipc	ra,0x1
    47e0:	f10080e7          	jalr	-240(ra) # 56ec <open>
    47e4:	89aa                	mv	s3,a0
    total = 0;
    47e6:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    47e8:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    47ec:	bf51                	j	4780 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    47ee:	85ca                	mv	a1,s2
    47f0:	00003517          	auipc	a0,0x3
    47f4:	4f850513          	addi	a0,a0,1272 # 7ce8 <csem_up+0x1ff2>
    47f8:	00001097          	auipc	ra,0x1
    47fc:	286080e7          	jalr	646(ra) # 5a7e <printf>
      exit(1);
    4800:	4505                	li	a0,1
    4802:	00001097          	auipc	ra,0x1
    4806:	eaa080e7          	jalr	-342(ra) # 56ac <exit>
}
    480a:	70aa                	ld	ra,168(sp)
    480c:	740a                	ld	s0,160(sp)
    480e:	64ea                	ld	s1,152(sp)
    4810:	694a                	ld	s2,144(sp)
    4812:	69aa                	ld	s3,136(sp)
    4814:	6a0a                	ld	s4,128(sp)
    4816:	7ae6                	ld	s5,120(sp)
    4818:	7b46                	ld	s6,112(sp)
    481a:	7ba6                	ld	s7,104(sp)
    481c:	7c06                	ld	s8,96(sp)
    481e:	6ce6                	ld	s9,88(sp)
    4820:	6d46                	ld	s10,80(sp)
    4822:	6da6                	ld	s11,72(sp)
    4824:	614d                	addi	sp,sp,176
    4826:	8082                	ret

0000000000004828 <concreate>:
{
    4828:	7135                	addi	sp,sp,-160
    482a:	ed06                	sd	ra,152(sp)
    482c:	e922                	sd	s0,144(sp)
    482e:	e526                	sd	s1,136(sp)
    4830:	e14a                	sd	s2,128(sp)
    4832:	fcce                	sd	s3,120(sp)
    4834:	f8d2                	sd	s4,112(sp)
    4836:	f4d6                	sd	s5,104(sp)
    4838:	f0da                	sd	s6,96(sp)
    483a:	ecde                	sd	s7,88(sp)
    483c:	1100                	addi	s0,sp,160
    483e:	89aa                	mv	s3,a0
  file[0] = 'C';
    4840:	04300793          	li	a5,67
    4844:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4848:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    484c:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    484e:	4b0d                	li	s6,3
    4850:	4a85                	li	s5,1
      link("C0", file);
    4852:	00003b97          	auipc	s7,0x3
    4856:	4aeb8b93          	addi	s7,s7,1198 # 7d00 <csem_up+0x200a>
  for(i = 0; i < N; i++){
    485a:	02800a13          	li	s4,40
    485e:	acc1                	j	4b2e <concreate+0x306>
      link("C0", file);
    4860:	fa840593          	addi	a1,s0,-88
    4864:	855e                	mv	a0,s7
    4866:	00001097          	auipc	ra,0x1
    486a:	ea6080e7          	jalr	-346(ra) # 570c <link>
    if(pid == 0) {
    486e:	a45d                	j	4b14 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4870:	4795                	li	a5,5
    4872:	02f9693b          	remw	s2,s2,a5
    4876:	4785                	li	a5,1
    4878:	02f90b63          	beq	s2,a5,48ae <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    487c:	20200593          	li	a1,514
    4880:	fa840513          	addi	a0,s0,-88
    4884:	00001097          	auipc	ra,0x1
    4888:	e68080e7          	jalr	-408(ra) # 56ec <open>
      if(fd < 0){
    488c:	26055b63          	bgez	a0,4b02 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4890:	fa840593          	addi	a1,s0,-88
    4894:	00003517          	auipc	a0,0x3
    4898:	47450513          	addi	a0,a0,1140 # 7d08 <csem_up+0x2012>
    489c:	00001097          	auipc	ra,0x1
    48a0:	1e2080e7          	jalr	482(ra) # 5a7e <printf>
        exit(1);
    48a4:	4505                	li	a0,1
    48a6:	00001097          	auipc	ra,0x1
    48aa:	e06080e7          	jalr	-506(ra) # 56ac <exit>
      link("C0", file);
    48ae:	fa840593          	addi	a1,s0,-88
    48b2:	00003517          	auipc	a0,0x3
    48b6:	44e50513          	addi	a0,a0,1102 # 7d00 <csem_up+0x200a>
    48ba:	00001097          	auipc	ra,0x1
    48be:	e52080e7          	jalr	-430(ra) # 570c <link>
      exit(0);
    48c2:	4501                	li	a0,0
    48c4:	00001097          	auipc	ra,0x1
    48c8:	de8080e7          	jalr	-536(ra) # 56ac <exit>
        exit(1);
    48cc:	4505                	li	a0,1
    48ce:	00001097          	auipc	ra,0x1
    48d2:	dde080e7          	jalr	-546(ra) # 56ac <exit>
  memset(fa, 0, sizeof(fa));
    48d6:	02800613          	li	a2,40
    48da:	4581                	li	a1,0
    48dc:	f8040513          	addi	a0,s0,-128
    48e0:	00001097          	auipc	ra,0x1
    48e4:	bd0080e7          	jalr	-1072(ra) # 54b0 <memset>
  fd = open(".", 0);
    48e8:	4581                	li	a1,0
    48ea:	00002517          	auipc	a0,0x2
    48ee:	e5650513          	addi	a0,a0,-426 # 6740 <csem_up+0xa4a>
    48f2:	00001097          	auipc	ra,0x1
    48f6:	dfa080e7          	jalr	-518(ra) # 56ec <open>
    48fa:	892a                	mv	s2,a0
  n = 0;
    48fc:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    48fe:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4902:	02700b13          	li	s6,39
      fa[i] = 1;
    4906:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4908:	4641                	li	a2,16
    490a:	f7040593          	addi	a1,s0,-144
    490e:	854a                	mv	a0,s2
    4910:	00001097          	auipc	ra,0x1
    4914:	db4080e7          	jalr	-588(ra) # 56c4 <read>
    4918:	08a05163          	blez	a0,499a <concreate+0x172>
    if(de.inum == 0)
    491c:	f7045783          	lhu	a5,-144(s0)
    4920:	d7e5                	beqz	a5,4908 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4922:	f7244783          	lbu	a5,-142(s0)
    4926:	ff4791e3          	bne	a5,s4,4908 <concreate+0xe0>
    492a:	f7444783          	lbu	a5,-140(s0)
    492e:	ffe9                	bnez	a5,4908 <concreate+0xe0>
      i = de.name[1] - '0';
    4930:	f7344783          	lbu	a5,-141(s0)
    4934:	fd07879b          	addiw	a5,a5,-48
    4938:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    493c:	00eb6f63          	bltu	s6,a4,495a <concreate+0x132>
      if(fa[i]){
    4940:	fb040793          	addi	a5,s0,-80
    4944:	97ba                	add	a5,a5,a4
    4946:	fd07c783          	lbu	a5,-48(a5)
    494a:	eb85                	bnez	a5,497a <concreate+0x152>
      fa[i] = 1;
    494c:	fb040793          	addi	a5,s0,-80
    4950:	973e                	add	a4,a4,a5
    4952:	fd770823          	sb	s7,-48(a4) # fd0 <bigdir+0x6e>
      n++;
    4956:	2a85                	addiw	s5,s5,1
    4958:	bf45                	j	4908 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    495a:	f7240613          	addi	a2,s0,-142
    495e:	85ce                	mv	a1,s3
    4960:	00003517          	auipc	a0,0x3
    4964:	3c850513          	addi	a0,a0,968 # 7d28 <csem_up+0x2032>
    4968:	00001097          	auipc	ra,0x1
    496c:	116080e7          	jalr	278(ra) # 5a7e <printf>
        exit(1);
    4970:	4505                	li	a0,1
    4972:	00001097          	auipc	ra,0x1
    4976:	d3a080e7          	jalr	-710(ra) # 56ac <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    497a:	f7240613          	addi	a2,s0,-142
    497e:	85ce                	mv	a1,s3
    4980:	00003517          	auipc	a0,0x3
    4984:	3c850513          	addi	a0,a0,968 # 7d48 <csem_up+0x2052>
    4988:	00001097          	auipc	ra,0x1
    498c:	0f6080e7          	jalr	246(ra) # 5a7e <printf>
        exit(1);
    4990:	4505                	li	a0,1
    4992:	00001097          	auipc	ra,0x1
    4996:	d1a080e7          	jalr	-742(ra) # 56ac <exit>
  close(fd);
    499a:	854a                	mv	a0,s2
    499c:	00001097          	auipc	ra,0x1
    49a0:	d38080e7          	jalr	-712(ra) # 56d4 <close>
  if(n != N){
    49a4:	02800793          	li	a5,40
    49a8:	00fa9763          	bne	s5,a5,49b6 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    49ac:	4a8d                	li	s5,3
    49ae:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    49b0:	02800a13          	li	s4,40
    49b4:	a8c9                	j	4a86 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    49b6:	85ce                	mv	a1,s3
    49b8:	00003517          	auipc	a0,0x3
    49bc:	3b850513          	addi	a0,a0,952 # 7d70 <csem_up+0x207a>
    49c0:	00001097          	auipc	ra,0x1
    49c4:	0be080e7          	jalr	190(ra) # 5a7e <printf>
    exit(1);
    49c8:	4505                	li	a0,1
    49ca:	00001097          	auipc	ra,0x1
    49ce:	ce2080e7          	jalr	-798(ra) # 56ac <exit>
      printf("%s: fork failed\n", s);
    49d2:	85ce                	mv	a1,s3
    49d4:	00002517          	auipc	a0,0x2
    49d8:	f0c50513          	addi	a0,a0,-244 # 68e0 <csem_up+0xbea>
    49dc:	00001097          	auipc	ra,0x1
    49e0:	0a2080e7          	jalr	162(ra) # 5a7e <printf>
      exit(1);
    49e4:	4505                	li	a0,1
    49e6:	00001097          	auipc	ra,0x1
    49ea:	cc6080e7          	jalr	-826(ra) # 56ac <exit>
      close(open(file, 0));
    49ee:	4581                	li	a1,0
    49f0:	fa840513          	addi	a0,s0,-88
    49f4:	00001097          	auipc	ra,0x1
    49f8:	cf8080e7          	jalr	-776(ra) # 56ec <open>
    49fc:	00001097          	auipc	ra,0x1
    4a00:	cd8080e7          	jalr	-808(ra) # 56d4 <close>
      close(open(file, 0));
    4a04:	4581                	li	a1,0
    4a06:	fa840513          	addi	a0,s0,-88
    4a0a:	00001097          	auipc	ra,0x1
    4a0e:	ce2080e7          	jalr	-798(ra) # 56ec <open>
    4a12:	00001097          	auipc	ra,0x1
    4a16:	cc2080e7          	jalr	-830(ra) # 56d4 <close>
      close(open(file, 0));
    4a1a:	4581                	li	a1,0
    4a1c:	fa840513          	addi	a0,s0,-88
    4a20:	00001097          	auipc	ra,0x1
    4a24:	ccc080e7          	jalr	-820(ra) # 56ec <open>
    4a28:	00001097          	auipc	ra,0x1
    4a2c:	cac080e7          	jalr	-852(ra) # 56d4 <close>
      close(open(file, 0));
    4a30:	4581                	li	a1,0
    4a32:	fa840513          	addi	a0,s0,-88
    4a36:	00001097          	auipc	ra,0x1
    4a3a:	cb6080e7          	jalr	-842(ra) # 56ec <open>
    4a3e:	00001097          	auipc	ra,0x1
    4a42:	c96080e7          	jalr	-874(ra) # 56d4 <close>
      close(open(file, 0));
    4a46:	4581                	li	a1,0
    4a48:	fa840513          	addi	a0,s0,-88
    4a4c:	00001097          	auipc	ra,0x1
    4a50:	ca0080e7          	jalr	-864(ra) # 56ec <open>
    4a54:	00001097          	auipc	ra,0x1
    4a58:	c80080e7          	jalr	-896(ra) # 56d4 <close>
      close(open(file, 0));
    4a5c:	4581                	li	a1,0
    4a5e:	fa840513          	addi	a0,s0,-88
    4a62:	00001097          	auipc	ra,0x1
    4a66:	c8a080e7          	jalr	-886(ra) # 56ec <open>
    4a6a:	00001097          	auipc	ra,0x1
    4a6e:	c6a080e7          	jalr	-918(ra) # 56d4 <close>
    if(pid == 0)
    4a72:	08090363          	beqz	s2,4af8 <concreate+0x2d0>
      wait(0);
    4a76:	4501                	li	a0,0
    4a78:	00001097          	auipc	ra,0x1
    4a7c:	c3c080e7          	jalr	-964(ra) # 56b4 <wait>
  for(i = 0; i < N; i++){
    4a80:	2485                	addiw	s1,s1,1
    4a82:	0f448563          	beq	s1,s4,4b6c <concreate+0x344>
    file[1] = '0' + i;
    4a86:	0304879b          	addiw	a5,s1,48
    4a8a:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4a8e:	00001097          	auipc	ra,0x1
    4a92:	c16080e7          	jalr	-1002(ra) # 56a4 <fork>
    4a96:	892a                	mv	s2,a0
    if(pid < 0){
    4a98:	f2054de3          	bltz	a0,49d2 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4a9c:	0354e73b          	remw	a4,s1,s5
    4aa0:	00a767b3          	or	a5,a4,a0
    4aa4:	2781                	sext.w	a5,a5
    4aa6:	d7a1                	beqz	a5,49ee <concreate+0x1c6>
    4aa8:	01671363          	bne	a4,s6,4aae <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4aac:	f129                	bnez	a0,49ee <concreate+0x1c6>
      unlink(file);
    4aae:	fa840513          	addi	a0,s0,-88
    4ab2:	00001097          	auipc	ra,0x1
    4ab6:	c4a080e7          	jalr	-950(ra) # 56fc <unlink>
      unlink(file);
    4aba:	fa840513          	addi	a0,s0,-88
    4abe:	00001097          	auipc	ra,0x1
    4ac2:	c3e080e7          	jalr	-962(ra) # 56fc <unlink>
      unlink(file);
    4ac6:	fa840513          	addi	a0,s0,-88
    4aca:	00001097          	auipc	ra,0x1
    4ace:	c32080e7          	jalr	-974(ra) # 56fc <unlink>
      unlink(file);
    4ad2:	fa840513          	addi	a0,s0,-88
    4ad6:	00001097          	auipc	ra,0x1
    4ada:	c26080e7          	jalr	-986(ra) # 56fc <unlink>
      unlink(file);
    4ade:	fa840513          	addi	a0,s0,-88
    4ae2:	00001097          	auipc	ra,0x1
    4ae6:	c1a080e7          	jalr	-998(ra) # 56fc <unlink>
      unlink(file);
    4aea:	fa840513          	addi	a0,s0,-88
    4aee:	00001097          	auipc	ra,0x1
    4af2:	c0e080e7          	jalr	-1010(ra) # 56fc <unlink>
    4af6:	bfb5                	j	4a72 <concreate+0x24a>
      exit(0);
    4af8:	4501                	li	a0,0
    4afa:	00001097          	auipc	ra,0x1
    4afe:	bb2080e7          	jalr	-1102(ra) # 56ac <exit>
      close(fd);
    4b02:	00001097          	auipc	ra,0x1
    4b06:	bd2080e7          	jalr	-1070(ra) # 56d4 <close>
    if(pid == 0) {
    4b0a:	bb65                	j	48c2 <concreate+0x9a>
      close(fd);
    4b0c:	00001097          	auipc	ra,0x1
    4b10:	bc8080e7          	jalr	-1080(ra) # 56d4 <close>
      wait(&xstatus);
    4b14:	f6c40513          	addi	a0,s0,-148
    4b18:	00001097          	auipc	ra,0x1
    4b1c:	b9c080e7          	jalr	-1124(ra) # 56b4 <wait>
      if(xstatus != 0)
    4b20:	f6c42483          	lw	s1,-148(s0)
    4b24:	da0494e3          	bnez	s1,48cc <concreate+0xa4>
  for(i = 0; i < N; i++){
    4b28:	2905                	addiw	s2,s2,1
    4b2a:	db4906e3          	beq	s2,s4,48d6 <concreate+0xae>
    file[1] = '0' + i;
    4b2e:	0309079b          	addiw	a5,s2,48
    4b32:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4b36:	fa840513          	addi	a0,s0,-88
    4b3a:	00001097          	auipc	ra,0x1
    4b3e:	bc2080e7          	jalr	-1086(ra) # 56fc <unlink>
    pid = fork();
    4b42:	00001097          	auipc	ra,0x1
    4b46:	b62080e7          	jalr	-1182(ra) # 56a4 <fork>
    if(pid && (i % 3) == 1){
    4b4a:	d20503e3          	beqz	a0,4870 <concreate+0x48>
    4b4e:	036967bb          	remw	a5,s2,s6
    4b52:	d15787e3          	beq	a5,s5,4860 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4b56:	20200593          	li	a1,514
    4b5a:	fa840513          	addi	a0,s0,-88
    4b5e:	00001097          	auipc	ra,0x1
    4b62:	b8e080e7          	jalr	-1138(ra) # 56ec <open>
      if(fd < 0){
    4b66:	fa0553e3          	bgez	a0,4b0c <concreate+0x2e4>
    4b6a:	b31d                	j	4890 <concreate+0x68>
}
    4b6c:	60ea                	ld	ra,152(sp)
    4b6e:	644a                	ld	s0,144(sp)
    4b70:	64aa                	ld	s1,136(sp)
    4b72:	690a                	ld	s2,128(sp)
    4b74:	79e6                	ld	s3,120(sp)
    4b76:	7a46                	ld	s4,112(sp)
    4b78:	7aa6                	ld	s5,104(sp)
    4b7a:	7b06                	ld	s6,96(sp)
    4b7c:	6be6                	ld	s7,88(sp)
    4b7e:	610d                	addi	sp,sp,160
    4b80:	8082                	ret

0000000000004b82 <bigfile>:
{
    4b82:	7139                	addi	sp,sp,-64
    4b84:	fc06                	sd	ra,56(sp)
    4b86:	f822                	sd	s0,48(sp)
    4b88:	f426                	sd	s1,40(sp)
    4b8a:	f04a                	sd	s2,32(sp)
    4b8c:	ec4e                	sd	s3,24(sp)
    4b8e:	e852                	sd	s4,16(sp)
    4b90:	e456                	sd	s5,8(sp)
    4b92:	0080                	addi	s0,sp,64
    4b94:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4b96:	00003517          	auipc	a0,0x3
    4b9a:	21250513          	addi	a0,a0,530 # 7da8 <csem_up+0x20b2>
    4b9e:	00001097          	auipc	ra,0x1
    4ba2:	b5e080e7          	jalr	-1186(ra) # 56fc <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4ba6:	20200593          	li	a1,514
    4baa:	00003517          	auipc	a0,0x3
    4bae:	1fe50513          	addi	a0,a0,510 # 7da8 <csem_up+0x20b2>
    4bb2:	00001097          	auipc	ra,0x1
    4bb6:	b3a080e7          	jalr	-1222(ra) # 56ec <open>
    4bba:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4bbc:	4481                	li	s1,0
    memset(buf, i, SZ);
    4bbe:	00007917          	auipc	s2,0x7
    4bc2:	13290913          	addi	s2,s2,306 # bcf0 <buf>
  for(i = 0; i < N; i++){
    4bc6:	4a51                	li	s4,20
  if(fd < 0){
    4bc8:	0a054063          	bltz	a0,4c68 <bigfile+0xe6>
    memset(buf, i, SZ);
    4bcc:	25800613          	li	a2,600
    4bd0:	85a6                	mv	a1,s1
    4bd2:	854a                	mv	a0,s2
    4bd4:	00001097          	auipc	ra,0x1
    4bd8:	8dc080e7          	jalr	-1828(ra) # 54b0 <memset>
    if(write(fd, buf, SZ) != SZ){
    4bdc:	25800613          	li	a2,600
    4be0:	85ca                	mv	a1,s2
    4be2:	854e                	mv	a0,s3
    4be4:	00001097          	auipc	ra,0x1
    4be8:	ae8080e7          	jalr	-1304(ra) # 56cc <write>
    4bec:	25800793          	li	a5,600
    4bf0:	08f51a63          	bne	a0,a5,4c84 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4bf4:	2485                	addiw	s1,s1,1
    4bf6:	fd449be3          	bne	s1,s4,4bcc <bigfile+0x4a>
  close(fd);
    4bfa:	854e                	mv	a0,s3
    4bfc:	00001097          	auipc	ra,0x1
    4c00:	ad8080e7          	jalr	-1320(ra) # 56d4 <close>
  fd = open("bigfile.dat", 0);
    4c04:	4581                	li	a1,0
    4c06:	00003517          	auipc	a0,0x3
    4c0a:	1a250513          	addi	a0,a0,418 # 7da8 <csem_up+0x20b2>
    4c0e:	00001097          	auipc	ra,0x1
    4c12:	ade080e7          	jalr	-1314(ra) # 56ec <open>
    4c16:	8a2a                	mv	s4,a0
  total = 0;
    4c18:	4981                	li	s3,0
  for(i = 0; ; i++){
    4c1a:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4c1c:	00007917          	auipc	s2,0x7
    4c20:	0d490913          	addi	s2,s2,212 # bcf0 <buf>
  if(fd < 0){
    4c24:	06054e63          	bltz	a0,4ca0 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4c28:	12c00613          	li	a2,300
    4c2c:	85ca                	mv	a1,s2
    4c2e:	8552                	mv	a0,s4
    4c30:	00001097          	auipc	ra,0x1
    4c34:	a94080e7          	jalr	-1388(ra) # 56c4 <read>
    if(cc < 0){
    4c38:	08054263          	bltz	a0,4cbc <bigfile+0x13a>
    if(cc == 0)
    4c3c:	c971                	beqz	a0,4d10 <bigfile+0x18e>
    if(cc != SZ/2){
    4c3e:	12c00793          	li	a5,300
    4c42:	08f51b63          	bne	a0,a5,4cd8 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4c46:	01f4d79b          	srliw	a5,s1,0x1f
    4c4a:	9fa5                	addw	a5,a5,s1
    4c4c:	4017d79b          	sraiw	a5,a5,0x1
    4c50:	00094703          	lbu	a4,0(s2)
    4c54:	0af71063          	bne	a4,a5,4cf4 <bigfile+0x172>
    4c58:	12b94703          	lbu	a4,299(s2)
    4c5c:	08f71c63          	bne	a4,a5,4cf4 <bigfile+0x172>
    total += cc;
    4c60:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4c64:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4c66:	b7c9                	j	4c28 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4c68:	85d6                	mv	a1,s5
    4c6a:	00003517          	auipc	a0,0x3
    4c6e:	14e50513          	addi	a0,a0,334 # 7db8 <csem_up+0x20c2>
    4c72:	00001097          	auipc	ra,0x1
    4c76:	e0c080e7          	jalr	-500(ra) # 5a7e <printf>
    exit(1);
    4c7a:	4505                	li	a0,1
    4c7c:	00001097          	auipc	ra,0x1
    4c80:	a30080e7          	jalr	-1488(ra) # 56ac <exit>
      printf("%s: write bigfile failed\n", s);
    4c84:	85d6                	mv	a1,s5
    4c86:	00003517          	auipc	a0,0x3
    4c8a:	15250513          	addi	a0,a0,338 # 7dd8 <csem_up+0x20e2>
    4c8e:	00001097          	auipc	ra,0x1
    4c92:	df0080e7          	jalr	-528(ra) # 5a7e <printf>
      exit(1);
    4c96:	4505                	li	a0,1
    4c98:	00001097          	auipc	ra,0x1
    4c9c:	a14080e7          	jalr	-1516(ra) # 56ac <exit>
    printf("%s: cannot open bigfile\n", s);
    4ca0:	85d6                	mv	a1,s5
    4ca2:	00003517          	auipc	a0,0x3
    4ca6:	15650513          	addi	a0,a0,342 # 7df8 <csem_up+0x2102>
    4caa:	00001097          	auipc	ra,0x1
    4cae:	dd4080e7          	jalr	-556(ra) # 5a7e <printf>
    exit(1);
    4cb2:	4505                	li	a0,1
    4cb4:	00001097          	auipc	ra,0x1
    4cb8:	9f8080e7          	jalr	-1544(ra) # 56ac <exit>
      printf("%s: read bigfile failed\n", s);
    4cbc:	85d6                	mv	a1,s5
    4cbe:	00003517          	auipc	a0,0x3
    4cc2:	15a50513          	addi	a0,a0,346 # 7e18 <csem_up+0x2122>
    4cc6:	00001097          	auipc	ra,0x1
    4cca:	db8080e7          	jalr	-584(ra) # 5a7e <printf>
      exit(1);
    4cce:	4505                	li	a0,1
    4cd0:	00001097          	auipc	ra,0x1
    4cd4:	9dc080e7          	jalr	-1572(ra) # 56ac <exit>
      printf("%s: short read bigfile\n", s);
    4cd8:	85d6                	mv	a1,s5
    4cda:	00003517          	auipc	a0,0x3
    4cde:	15e50513          	addi	a0,a0,350 # 7e38 <csem_up+0x2142>
    4ce2:	00001097          	auipc	ra,0x1
    4ce6:	d9c080e7          	jalr	-612(ra) # 5a7e <printf>
      exit(1);
    4cea:	4505                	li	a0,1
    4cec:	00001097          	auipc	ra,0x1
    4cf0:	9c0080e7          	jalr	-1600(ra) # 56ac <exit>
      printf("%s: read bigfile wrong data\n", s);
    4cf4:	85d6                	mv	a1,s5
    4cf6:	00003517          	auipc	a0,0x3
    4cfa:	15a50513          	addi	a0,a0,346 # 7e50 <csem_up+0x215a>
    4cfe:	00001097          	auipc	ra,0x1
    4d02:	d80080e7          	jalr	-640(ra) # 5a7e <printf>
      exit(1);
    4d06:	4505                	li	a0,1
    4d08:	00001097          	auipc	ra,0x1
    4d0c:	9a4080e7          	jalr	-1628(ra) # 56ac <exit>
  close(fd);
    4d10:	8552                	mv	a0,s4
    4d12:	00001097          	auipc	ra,0x1
    4d16:	9c2080e7          	jalr	-1598(ra) # 56d4 <close>
  if(total != N*SZ){
    4d1a:	678d                	lui	a5,0x3
    4d1c:	ee078793          	addi	a5,a5,-288 # 2ee0 <exitiputtest+0x48>
    4d20:	02f99363          	bne	s3,a5,4d46 <bigfile+0x1c4>
  unlink("bigfile.dat");
    4d24:	00003517          	auipc	a0,0x3
    4d28:	08450513          	addi	a0,a0,132 # 7da8 <csem_up+0x20b2>
    4d2c:	00001097          	auipc	ra,0x1
    4d30:	9d0080e7          	jalr	-1584(ra) # 56fc <unlink>
}
    4d34:	70e2                	ld	ra,56(sp)
    4d36:	7442                	ld	s0,48(sp)
    4d38:	74a2                	ld	s1,40(sp)
    4d3a:	7902                	ld	s2,32(sp)
    4d3c:	69e2                	ld	s3,24(sp)
    4d3e:	6a42                	ld	s4,16(sp)
    4d40:	6aa2                	ld	s5,8(sp)
    4d42:	6121                	addi	sp,sp,64
    4d44:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4d46:	85d6                	mv	a1,s5
    4d48:	00003517          	auipc	a0,0x3
    4d4c:	12850513          	addi	a0,a0,296 # 7e70 <csem_up+0x217a>
    4d50:	00001097          	auipc	ra,0x1
    4d54:	d2e080e7          	jalr	-722(ra) # 5a7e <printf>
    exit(1);
    4d58:	4505                	li	a0,1
    4d5a:	00001097          	auipc	ra,0x1
    4d5e:	952080e7          	jalr	-1710(ra) # 56ac <exit>

0000000000004d62 <fsfull>:
{
    4d62:	7171                	addi	sp,sp,-176
    4d64:	f506                	sd	ra,168(sp)
    4d66:	f122                	sd	s0,160(sp)
    4d68:	ed26                	sd	s1,152(sp)
    4d6a:	e94a                	sd	s2,144(sp)
    4d6c:	e54e                	sd	s3,136(sp)
    4d6e:	e152                	sd	s4,128(sp)
    4d70:	fcd6                	sd	s5,120(sp)
    4d72:	f8da                	sd	s6,112(sp)
    4d74:	f4de                	sd	s7,104(sp)
    4d76:	f0e2                	sd	s8,96(sp)
    4d78:	ece6                	sd	s9,88(sp)
    4d7a:	e8ea                	sd	s10,80(sp)
    4d7c:	e4ee                	sd	s11,72(sp)
    4d7e:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4d80:	00003517          	auipc	a0,0x3
    4d84:	11050513          	addi	a0,a0,272 # 7e90 <csem_up+0x219a>
    4d88:	00001097          	auipc	ra,0x1
    4d8c:	cf6080e7          	jalr	-778(ra) # 5a7e <printf>
  for(nfiles = 0; ; nfiles++){
    4d90:	4481                	li	s1,0
    name[0] = 'f';
    4d92:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4d96:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4d9a:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4d9e:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4da0:	00003c97          	auipc	s9,0x3
    4da4:	100c8c93          	addi	s9,s9,256 # 7ea0 <csem_up+0x21aa>
    int total = 0;
    4da8:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4daa:	00007a17          	auipc	s4,0x7
    4dae:	f46a0a13          	addi	s4,s4,-186 # bcf0 <buf>
    name[0] = 'f';
    4db2:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4db6:	0384c7bb          	divw	a5,s1,s8
    4dba:	0307879b          	addiw	a5,a5,48
    4dbe:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4dc2:	0384e7bb          	remw	a5,s1,s8
    4dc6:	0377c7bb          	divw	a5,a5,s7
    4dca:	0307879b          	addiw	a5,a5,48
    4dce:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4dd2:	0374e7bb          	remw	a5,s1,s7
    4dd6:	0367c7bb          	divw	a5,a5,s6
    4dda:	0307879b          	addiw	a5,a5,48
    4dde:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4de2:	0364e7bb          	remw	a5,s1,s6
    4de6:	0307879b          	addiw	a5,a5,48
    4dea:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4dee:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4df2:	f5040593          	addi	a1,s0,-176
    4df6:	8566                	mv	a0,s9
    4df8:	00001097          	auipc	ra,0x1
    4dfc:	c86080e7          	jalr	-890(ra) # 5a7e <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4e00:	20200593          	li	a1,514
    4e04:	f5040513          	addi	a0,s0,-176
    4e08:	00001097          	auipc	ra,0x1
    4e0c:	8e4080e7          	jalr	-1820(ra) # 56ec <open>
    4e10:	892a                	mv	s2,a0
    if(fd < 0){
    4e12:	0a055663          	bgez	a0,4ebe <fsfull+0x15c>
      printf("open %s failed\n", name);
    4e16:	f5040593          	addi	a1,s0,-176
    4e1a:	00003517          	auipc	a0,0x3
    4e1e:	09650513          	addi	a0,a0,150 # 7eb0 <csem_up+0x21ba>
    4e22:	00001097          	auipc	ra,0x1
    4e26:	c5c080e7          	jalr	-932(ra) # 5a7e <printf>
  while(nfiles >= 0){
    4e2a:	0604c363          	bltz	s1,4e90 <fsfull+0x12e>
    name[0] = 'f';
    4e2e:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4e32:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4e36:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4e3a:	4929                	li	s2,10
  while(nfiles >= 0){
    4e3c:	5afd                	li	s5,-1
    name[0] = 'f';
    4e3e:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4e42:	0344c7bb          	divw	a5,s1,s4
    4e46:	0307879b          	addiw	a5,a5,48
    4e4a:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4e4e:	0344e7bb          	remw	a5,s1,s4
    4e52:	0337c7bb          	divw	a5,a5,s3
    4e56:	0307879b          	addiw	a5,a5,48
    4e5a:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4e5e:	0334e7bb          	remw	a5,s1,s3
    4e62:	0327c7bb          	divw	a5,a5,s2
    4e66:	0307879b          	addiw	a5,a5,48
    4e6a:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4e6e:	0324e7bb          	remw	a5,s1,s2
    4e72:	0307879b          	addiw	a5,a5,48
    4e76:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4e7a:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4e7e:	f5040513          	addi	a0,s0,-176
    4e82:	00001097          	auipc	ra,0x1
    4e86:	87a080e7          	jalr	-1926(ra) # 56fc <unlink>
    nfiles--;
    4e8a:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4e8c:	fb5499e3          	bne	s1,s5,4e3e <fsfull+0xdc>
  printf("fsfull test finished\n");
    4e90:	00003517          	auipc	a0,0x3
    4e94:	04050513          	addi	a0,a0,64 # 7ed0 <csem_up+0x21da>
    4e98:	00001097          	auipc	ra,0x1
    4e9c:	be6080e7          	jalr	-1050(ra) # 5a7e <printf>
}
    4ea0:	70aa                	ld	ra,168(sp)
    4ea2:	740a                	ld	s0,160(sp)
    4ea4:	64ea                	ld	s1,152(sp)
    4ea6:	694a                	ld	s2,144(sp)
    4ea8:	69aa                	ld	s3,136(sp)
    4eaa:	6a0a                	ld	s4,128(sp)
    4eac:	7ae6                	ld	s5,120(sp)
    4eae:	7b46                	ld	s6,112(sp)
    4eb0:	7ba6                	ld	s7,104(sp)
    4eb2:	7c06                	ld	s8,96(sp)
    4eb4:	6ce6                	ld	s9,88(sp)
    4eb6:	6d46                	ld	s10,80(sp)
    4eb8:	6da6                	ld	s11,72(sp)
    4eba:	614d                	addi	sp,sp,176
    4ebc:	8082                	ret
    int total = 0;
    4ebe:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4ec0:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4ec4:	40000613          	li	a2,1024
    4ec8:	85d2                	mv	a1,s4
    4eca:	854a                	mv	a0,s2
    4ecc:	00001097          	auipc	ra,0x1
    4ed0:	800080e7          	jalr	-2048(ra) # 56cc <write>
      if(cc < BSIZE)
    4ed4:	00aad563          	bge	s5,a0,4ede <fsfull+0x17c>
      total += cc;
    4ed8:	00a989bb          	addw	s3,s3,a0
    while(1){
    4edc:	b7e5                	j	4ec4 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    4ede:	85ce                	mv	a1,s3
    4ee0:	00003517          	auipc	a0,0x3
    4ee4:	fe050513          	addi	a0,a0,-32 # 7ec0 <csem_up+0x21ca>
    4ee8:	00001097          	auipc	ra,0x1
    4eec:	b96080e7          	jalr	-1130(ra) # 5a7e <printf>
    close(fd);
    4ef0:	854a                	mv	a0,s2
    4ef2:	00000097          	auipc	ra,0x0
    4ef6:	7e2080e7          	jalr	2018(ra) # 56d4 <close>
    if(total == 0)
    4efa:	f20988e3          	beqz	s3,4e2a <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4efe:	2485                	addiw	s1,s1,1
    4f00:	bd4d                	j	4db2 <fsfull+0x50>

0000000000004f02 <rand>:
{
    4f02:	1141                	addi	sp,sp,-16
    4f04:	e422                	sd	s0,8(sp)
    4f06:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4f08:	00003717          	auipc	a4,0x3
    4f0c:	5c070713          	addi	a4,a4,1472 # 84c8 <randstate>
    4f10:	6308                	ld	a0,0(a4)
    4f12:	001967b7          	lui	a5,0x196
    4f16:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x18790d>
    4f1a:	02f50533          	mul	a0,a0,a5
    4f1e:	3c6ef7b7          	lui	a5,0x3c6ef
    4f22:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e065f>
    4f26:	953e                	add	a0,a0,a5
    4f28:	e308                	sd	a0,0(a4)
}
    4f2a:	2501                	sext.w	a0,a0
    4f2c:	6422                	ld	s0,8(sp)
    4f2e:	0141                	addi	sp,sp,16
    4f30:	8082                	ret

0000000000004f32 <badwrite>:
{
    4f32:	7179                	addi	sp,sp,-48
    4f34:	f406                	sd	ra,40(sp)
    4f36:	f022                	sd	s0,32(sp)
    4f38:	ec26                	sd	s1,24(sp)
    4f3a:	e84a                	sd	s2,16(sp)
    4f3c:	e44e                	sd	s3,8(sp)
    4f3e:	e052                	sd	s4,0(sp)
    4f40:	1800                	addi	s0,sp,48
  unlink("junk");
    4f42:	00003517          	auipc	a0,0x3
    4f46:	fa650513          	addi	a0,a0,-90 # 7ee8 <csem_up+0x21f2>
    4f4a:	00000097          	auipc	ra,0x0
    4f4e:	7b2080e7          	jalr	1970(ra) # 56fc <unlink>
    4f52:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4f56:	00003997          	auipc	s3,0x3
    4f5a:	f9298993          	addi	s3,s3,-110 # 7ee8 <csem_up+0x21f2>
    write(fd, (char*)0xffffffffffL, 1);
    4f5e:	5a7d                	li	s4,-1
    4f60:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4f64:	20100593          	li	a1,513
    4f68:	854e                	mv	a0,s3
    4f6a:	00000097          	auipc	ra,0x0
    4f6e:	782080e7          	jalr	1922(ra) # 56ec <open>
    4f72:	84aa                	mv	s1,a0
    if(fd < 0){
    4f74:	06054b63          	bltz	a0,4fea <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4f78:	4605                	li	a2,1
    4f7a:	85d2                	mv	a1,s4
    4f7c:	00000097          	auipc	ra,0x0
    4f80:	750080e7          	jalr	1872(ra) # 56cc <write>
    close(fd);
    4f84:	8526                	mv	a0,s1
    4f86:	00000097          	auipc	ra,0x0
    4f8a:	74e080e7          	jalr	1870(ra) # 56d4 <close>
    unlink("junk");
    4f8e:	854e                	mv	a0,s3
    4f90:	00000097          	auipc	ra,0x0
    4f94:	76c080e7          	jalr	1900(ra) # 56fc <unlink>
  for(int i = 0; i < assumed_free; i++){
    4f98:	397d                	addiw	s2,s2,-1
    4f9a:	fc0915e3          	bnez	s2,4f64 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4f9e:	20100593          	li	a1,513
    4fa2:	00003517          	auipc	a0,0x3
    4fa6:	f4650513          	addi	a0,a0,-186 # 7ee8 <csem_up+0x21f2>
    4faa:	00000097          	auipc	ra,0x0
    4fae:	742080e7          	jalr	1858(ra) # 56ec <open>
    4fb2:	84aa                	mv	s1,a0
  if(fd < 0){
    4fb4:	04054863          	bltz	a0,5004 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4fb8:	4605                	li	a2,1
    4fba:	00001597          	auipc	a1,0x1
    4fbe:	15e58593          	addi	a1,a1,350 # 6118 <csem_up+0x422>
    4fc2:	00000097          	auipc	ra,0x0
    4fc6:	70a080e7          	jalr	1802(ra) # 56cc <write>
    4fca:	4785                	li	a5,1
    4fcc:	04f50963          	beq	a0,a5,501e <badwrite+0xec>
    printf("write failed\n");
    4fd0:	00003517          	auipc	a0,0x3
    4fd4:	f3850513          	addi	a0,a0,-200 # 7f08 <csem_up+0x2212>
    4fd8:	00001097          	auipc	ra,0x1
    4fdc:	aa6080e7          	jalr	-1370(ra) # 5a7e <printf>
    exit(1);
    4fe0:	4505                	li	a0,1
    4fe2:	00000097          	auipc	ra,0x0
    4fe6:	6ca080e7          	jalr	1738(ra) # 56ac <exit>
      printf("open junk failed\n");
    4fea:	00003517          	auipc	a0,0x3
    4fee:	f0650513          	addi	a0,a0,-250 # 7ef0 <csem_up+0x21fa>
    4ff2:	00001097          	auipc	ra,0x1
    4ff6:	a8c080e7          	jalr	-1396(ra) # 5a7e <printf>
      exit(1);
    4ffa:	4505                	li	a0,1
    4ffc:	00000097          	auipc	ra,0x0
    5000:	6b0080e7          	jalr	1712(ra) # 56ac <exit>
    printf("open junk failed\n");
    5004:	00003517          	auipc	a0,0x3
    5008:	eec50513          	addi	a0,a0,-276 # 7ef0 <csem_up+0x21fa>
    500c:	00001097          	auipc	ra,0x1
    5010:	a72080e7          	jalr	-1422(ra) # 5a7e <printf>
    exit(1);
    5014:	4505                	li	a0,1
    5016:	00000097          	auipc	ra,0x0
    501a:	696080e7          	jalr	1686(ra) # 56ac <exit>
  close(fd);
    501e:	8526                	mv	a0,s1
    5020:	00000097          	auipc	ra,0x0
    5024:	6b4080e7          	jalr	1716(ra) # 56d4 <close>
  unlink("junk");
    5028:	00003517          	auipc	a0,0x3
    502c:	ec050513          	addi	a0,a0,-320 # 7ee8 <csem_up+0x21f2>
    5030:	00000097          	auipc	ra,0x0
    5034:	6cc080e7          	jalr	1740(ra) # 56fc <unlink>
  exit(0);
    5038:	4501                	li	a0,0
    503a:	00000097          	auipc	ra,0x0
    503e:	672080e7          	jalr	1650(ra) # 56ac <exit>

0000000000005042 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5042:	7139                	addi	sp,sp,-64
    5044:	fc06                	sd	ra,56(sp)
    5046:	f822                	sd	s0,48(sp)
    5048:	f426                	sd	s1,40(sp)
    504a:	f04a                	sd	s2,32(sp)
    504c:	ec4e                	sd	s3,24(sp)
    504e:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5050:	fc840513          	addi	a0,s0,-56
    5054:	00000097          	auipc	ra,0x0
    5058:	668080e7          	jalr	1640(ra) # 56bc <pipe>
    505c:	06054763          	bltz	a0,50ca <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5060:	00000097          	auipc	ra,0x0
    5064:	644080e7          	jalr	1604(ra) # 56a4 <fork>

  if(pid < 0){
    5068:	06054e63          	bltz	a0,50e4 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    506c:	ed51                	bnez	a0,5108 <countfree+0xc6>
    close(fds[0]);
    506e:	fc842503          	lw	a0,-56(s0)
    5072:	00000097          	auipc	ra,0x0
    5076:	662080e7          	jalr	1634(ra) # 56d4 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    507a:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    507c:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    507e:	00001997          	auipc	s3,0x1
    5082:	09a98993          	addi	s3,s3,154 # 6118 <csem_up+0x422>
      uint64 a = (uint64) sbrk(4096);
    5086:	6505                	lui	a0,0x1
    5088:	00000097          	auipc	ra,0x0
    508c:	6ac080e7          	jalr	1708(ra) # 5734 <sbrk>
      if(a == 0xffffffffffffffff){
    5090:	07250763          	beq	a0,s2,50fe <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    5094:	6785                	lui	a5,0x1
    5096:	953e                	add	a0,a0,a5
    5098:	fe950fa3          	sb	s1,-1(a0) # fff <bigdir+0x9d>
      if(write(fds[1], "x", 1) != 1){
    509c:	8626                	mv	a2,s1
    509e:	85ce                	mv	a1,s3
    50a0:	fcc42503          	lw	a0,-52(s0)
    50a4:	00000097          	auipc	ra,0x0
    50a8:	628080e7          	jalr	1576(ra) # 56cc <write>
    50ac:	fc950de3          	beq	a0,s1,5086 <countfree+0x44>
        printf("write() failed in countfree()\n");
    50b0:	00003517          	auipc	a0,0x3
    50b4:	ea850513          	addi	a0,a0,-344 # 7f58 <csem_up+0x2262>
    50b8:	00001097          	auipc	ra,0x1
    50bc:	9c6080e7          	jalr	-1594(ra) # 5a7e <printf>
        exit(1);
    50c0:	4505                	li	a0,1
    50c2:	00000097          	auipc	ra,0x0
    50c6:	5ea080e7          	jalr	1514(ra) # 56ac <exit>
    printf("pipe() failed in countfree()\n");
    50ca:	00003517          	auipc	a0,0x3
    50ce:	e4e50513          	addi	a0,a0,-434 # 7f18 <csem_up+0x2222>
    50d2:	00001097          	auipc	ra,0x1
    50d6:	9ac080e7          	jalr	-1620(ra) # 5a7e <printf>
    exit(1);
    50da:	4505                	li	a0,1
    50dc:	00000097          	auipc	ra,0x0
    50e0:	5d0080e7          	jalr	1488(ra) # 56ac <exit>
    printf("fork failed in countfree()\n");
    50e4:	00003517          	auipc	a0,0x3
    50e8:	e5450513          	addi	a0,a0,-428 # 7f38 <csem_up+0x2242>
    50ec:	00001097          	auipc	ra,0x1
    50f0:	992080e7          	jalr	-1646(ra) # 5a7e <printf>
    exit(1);
    50f4:	4505                	li	a0,1
    50f6:	00000097          	auipc	ra,0x0
    50fa:	5b6080e7          	jalr	1462(ra) # 56ac <exit>
      }
    }

    exit(0);
    50fe:	4501                	li	a0,0
    5100:	00000097          	auipc	ra,0x0
    5104:	5ac080e7          	jalr	1452(ra) # 56ac <exit>
  }

  close(fds[1]);
    5108:	fcc42503          	lw	a0,-52(s0)
    510c:	00000097          	auipc	ra,0x0
    5110:	5c8080e7          	jalr	1480(ra) # 56d4 <close>

  int n = 0;
    5114:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5116:	4605                	li	a2,1
    5118:	fc740593          	addi	a1,s0,-57
    511c:	fc842503          	lw	a0,-56(s0)
    5120:	00000097          	auipc	ra,0x0
    5124:	5a4080e7          	jalr	1444(ra) # 56c4 <read>
    if(cc < 0){
    5128:	00054563          	bltz	a0,5132 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    512c:	c105                	beqz	a0,514c <countfree+0x10a>
      break;
    n += 1;
    512e:	2485                	addiw	s1,s1,1
  while(1){
    5130:	b7dd                	j	5116 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5132:	00003517          	auipc	a0,0x3
    5136:	e4650513          	addi	a0,a0,-442 # 7f78 <csem_up+0x2282>
    513a:	00001097          	auipc	ra,0x1
    513e:	944080e7          	jalr	-1724(ra) # 5a7e <printf>
      exit(1);
    5142:	4505                	li	a0,1
    5144:	00000097          	auipc	ra,0x0
    5148:	568080e7          	jalr	1384(ra) # 56ac <exit>
  }

  close(fds[0]);
    514c:	fc842503          	lw	a0,-56(s0)
    5150:	00000097          	auipc	ra,0x0
    5154:	584080e7          	jalr	1412(ra) # 56d4 <close>
  wait((int*)0);
    5158:	4501                	li	a0,0
    515a:	00000097          	auipc	ra,0x0
    515e:	55a080e7          	jalr	1370(ra) # 56b4 <wait>
  
  return n;
}
    5162:	8526                	mv	a0,s1
    5164:	70e2                	ld	ra,56(sp)
    5166:	7442                	ld	s0,48(sp)
    5168:	74a2                	ld	s1,40(sp)
    516a:	7902                	ld	s2,32(sp)
    516c:	69e2                	ld	s3,24(sp)
    516e:	6121                	addi	sp,sp,64
    5170:	8082                	ret

0000000000005172 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5172:	7179                	addi	sp,sp,-48
    5174:	f406                	sd	ra,40(sp)
    5176:	f022                	sd	s0,32(sp)
    5178:	ec26                	sd	s1,24(sp)
    517a:	e84a                	sd	s2,16(sp)
    517c:	1800                	addi	s0,sp,48
    517e:	84aa                	mv	s1,a0
    5180:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5182:	00003517          	auipc	a0,0x3
    5186:	e1650513          	addi	a0,a0,-490 # 7f98 <csem_up+0x22a2>
    518a:	00001097          	auipc	ra,0x1
    518e:	8f4080e7          	jalr	-1804(ra) # 5a7e <printf>
  if((pid = fork()) < 0) {
    5192:	00000097          	auipc	ra,0x0
    5196:	512080e7          	jalr	1298(ra) # 56a4 <fork>
    519a:	02054e63          	bltz	a0,51d6 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    519e:	c929                	beqz	a0,51f0 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    51a0:	fdc40513          	addi	a0,s0,-36
    51a4:	00000097          	auipc	ra,0x0
    51a8:	510080e7          	jalr	1296(ra) # 56b4 <wait>
    if(xstatus != 0) 
    51ac:	fdc42783          	lw	a5,-36(s0)
    51b0:	c7b9                	beqz	a5,51fe <run+0x8c>
      printf("FAILED\n");
    51b2:	00003517          	auipc	a0,0x3
    51b6:	e0e50513          	addi	a0,a0,-498 # 7fc0 <csem_up+0x22ca>
    51ba:	00001097          	auipc	ra,0x1
    51be:	8c4080e7          	jalr	-1852(ra) # 5a7e <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    51c2:	fdc42503          	lw	a0,-36(s0)
  }
}
    51c6:	00153513          	seqz	a0,a0
    51ca:	70a2                	ld	ra,40(sp)
    51cc:	7402                	ld	s0,32(sp)
    51ce:	64e2                	ld	s1,24(sp)
    51d0:	6942                	ld	s2,16(sp)
    51d2:	6145                	addi	sp,sp,48
    51d4:	8082                	ret
    printf("runtest: fork error\n");
    51d6:	00003517          	auipc	a0,0x3
    51da:	dd250513          	addi	a0,a0,-558 # 7fa8 <csem_up+0x22b2>
    51de:	00001097          	auipc	ra,0x1
    51e2:	8a0080e7          	jalr	-1888(ra) # 5a7e <printf>
    exit(1);
    51e6:	4505                	li	a0,1
    51e8:	00000097          	auipc	ra,0x0
    51ec:	4c4080e7          	jalr	1220(ra) # 56ac <exit>
    f(s);
    51f0:	854a                	mv	a0,s2
    51f2:	9482                	jalr	s1
    exit(0);
    51f4:	4501                	li	a0,0
    51f6:	00000097          	auipc	ra,0x0
    51fa:	4b6080e7          	jalr	1206(ra) # 56ac <exit>
      printf("OK\n");
    51fe:	00003517          	auipc	a0,0x3
    5202:	dca50513          	addi	a0,a0,-566 # 7fc8 <csem_up+0x22d2>
    5206:	00001097          	auipc	ra,0x1
    520a:	878080e7          	jalr	-1928(ra) # 5a7e <printf>
    520e:	bf55                	j	51c2 <run+0x50>

0000000000005210 <main>:

int
main(int argc, char *argv[])
{
    5210:	c0010113          	addi	sp,sp,-1024
    5214:	3e113c23          	sd	ra,1016(sp)
    5218:	3e813823          	sd	s0,1008(sp)
    521c:	3e913423          	sd	s1,1000(sp)
    5220:	3f213023          	sd	s2,992(sp)
    5224:	3d313c23          	sd	s3,984(sp)
    5228:	3d413823          	sd	s4,976(sp)
    522c:	3d513423          	sd	s5,968(sp)
    5230:	3d613023          	sd	s6,960(sp)
    5234:	40010413          	addi	s0,sp,1024
    5238:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    523a:	4789                	li	a5,2
    523c:	08f50763          	beq	a0,a5,52ca <main+0xba>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5240:	4785                	li	a5,1
  char *justone = 0;
    5242:	4901                	li	s2,0
  } else if(argc > 1){
    5244:	0ca7c163          	blt	a5,a0,5306 <main+0xf6>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    5248:	00003797          	auipc	a5,0x3
    524c:	e9878793          	addi	a5,a5,-360 # 80e0 <csem_up+0x23ea>
    5250:	c0040713          	addi	a4,s0,-1024
    5254:	00003817          	auipc	a6,0x3
    5258:	24c80813          	addi	a6,a6,588 # 84a0 <csem_up+0x27aa>
    525c:	6388                	ld	a0,0(a5)
    525e:	678c                	ld	a1,8(a5)
    5260:	6b90                	ld	a2,16(a5)
    5262:	6f94                	ld	a3,24(a5)
    5264:	e308                	sd	a0,0(a4)
    5266:	e70c                	sd	a1,8(a4)
    5268:	eb10                	sd	a2,16(a4)
    526a:	ef14                	sd	a3,24(a4)
    526c:	02078793          	addi	a5,a5,32
    5270:	02070713          	addi	a4,a4,32
    5274:	ff0794e3          	bne	a5,a6,525c <main+0x4c>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    5278:	00003517          	auipc	a0,0x3
    527c:	e0850513          	addi	a0,a0,-504 # 8080 <csem_up+0x238a>
    5280:	00000097          	auipc	ra,0x0
    5284:	7fe080e7          	jalr	2046(ra) # 5a7e <printf>
  int free0 = countfree();
    5288:	00000097          	auipc	ra,0x0
    528c:	dba080e7          	jalr	-582(ra) # 5042 <countfree>
    5290:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5292:	c0843503          	ld	a0,-1016(s0)
    5296:	c0040493          	addi	s1,s0,-1024
  int fail = 0;
    529a:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    529c:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    529e:	e55d                	bnez	a0,534c <main+0x13c>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    52a0:	00000097          	auipc	ra,0x0
    52a4:	da2080e7          	jalr	-606(ra) # 5042 <countfree>
    52a8:	85aa                	mv	a1,a0
    52aa:	0f455163          	bge	a0,s4,538c <main+0x17c>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    52ae:	8652                	mv	a2,s4
    52b0:	00003517          	auipc	a0,0x3
    52b4:	d8850513          	addi	a0,a0,-632 # 8038 <csem_up+0x2342>
    52b8:	00000097          	auipc	ra,0x0
    52bc:	7c6080e7          	jalr	1990(ra) # 5a7e <printf>
    exit(1);
    52c0:	4505                	li	a0,1
    52c2:	00000097          	auipc	ra,0x0
    52c6:	3ea080e7          	jalr	1002(ra) # 56ac <exit>
    52ca:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    52cc:	00003597          	auipc	a1,0x3
    52d0:	d0458593          	addi	a1,a1,-764 # 7fd0 <csem_up+0x22da>
    52d4:	6488                	ld	a0,8(s1)
    52d6:	00000097          	auipc	ra,0x0
    52da:	184080e7          	jalr	388(ra) # 545a <strcmp>
    52de:	10050563          	beqz	a0,53e8 <main+0x1d8>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    52e2:	00003597          	auipc	a1,0x3
    52e6:	dd658593          	addi	a1,a1,-554 # 80b8 <csem_up+0x23c2>
    52ea:	6488                	ld	a0,8(s1)
    52ec:	00000097          	auipc	ra,0x0
    52f0:	16e080e7          	jalr	366(ra) # 545a <strcmp>
    52f4:	c97d                	beqz	a0,53ea <main+0x1da>
  } else if(argc == 2 && argv[1][0] != '-'){
    52f6:	0084b903          	ld	s2,8(s1)
    52fa:	00094703          	lbu	a4,0(s2)
    52fe:	02d00793          	li	a5,45
    5302:	f4f713e3          	bne	a4,a5,5248 <main+0x38>
    printf("Usage: usertests [-c] [testname]\n");
    5306:	00003517          	auipc	a0,0x3
    530a:	cd250513          	addi	a0,a0,-814 # 7fd8 <csem_up+0x22e2>
    530e:	00000097          	auipc	ra,0x0
    5312:	770080e7          	jalr	1904(ra) # 5a7e <printf>
    exit(1);
    5316:	4505                	li	a0,1
    5318:	00000097          	auipc	ra,0x0
    531c:	394080e7          	jalr	916(ra) # 56ac <exit>
          exit(1);
    5320:	4505                	li	a0,1
    5322:	00000097          	auipc	ra,0x0
    5326:	38a080e7          	jalr	906(ra) # 56ac <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    532a:	40a905bb          	subw	a1,s2,a0
    532e:	855a                	mv	a0,s6
    5330:	00000097          	auipc	ra,0x0
    5334:	74e080e7          	jalr	1870(ra) # 5a7e <printf>
        if(continuous != 2)
    5338:	09498463          	beq	s3,s4,53c0 <main+0x1b0>
          exit(1);
    533c:	4505                	li	a0,1
    533e:	00000097          	auipc	ra,0x0
    5342:	36e080e7          	jalr	878(ra) # 56ac <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    5346:	04c1                	addi	s1,s1,16
    5348:	6488                	ld	a0,8(s1)
    534a:	c115                	beqz	a0,536e <main+0x15e>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    534c:	00090863          	beqz	s2,535c <main+0x14c>
    5350:	85ca                	mv	a1,s2
    5352:	00000097          	auipc	ra,0x0
    5356:	108080e7          	jalr	264(ra) # 545a <strcmp>
    535a:	f575                	bnez	a0,5346 <main+0x136>
      if(!run(t->f, t->s))
    535c:	648c                	ld	a1,8(s1)
    535e:	6088                	ld	a0,0(s1)
    5360:	00000097          	auipc	ra,0x0
    5364:	e12080e7          	jalr	-494(ra) # 5172 <run>
    5368:	fd79                	bnez	a0,5346 <main+0x136>
        fail = 1;
    536a:	89d6                	mv	s3,s5
    536c:	bfe9                	j	5346 <main+0x136>
  if(fail){
    536e:	f20989e3          	beqz	s3,52a0 <main+0x90>
    printf("SOME TESTS FAILED\n");
    5372:	00003517          	auipc	a0,0x3
    5376:	cae50513          	addi	a0,a0,-850 # 8020 <csem_up+0x232a>
    537a:	00000097          	auipc	ra,0x0
    537e:	704080e7          	jalr	1796(ra) # 5a7e <printf>
    exit(1);
    5382:	4505                	li	a0,1
    5384:	00000097          	auipc	ra,0x0
    5388:	328080e7          	jalr	808(ra) # 56ac <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    538c:	00003517          	auipc	a0,0x3
    5390:	cdc50513          	addi	a0,a0,-804 # 8068 <csem_up+0x2372>
    5394:	00000097          	auipc	ra,0x0
    5398:	6ea080e7          	jalr	1770(ra) # 5a7e <printf>
    exit(0);
    539c:	4501                	li	a0,0
    539e:	00000097          	auipc	ra,0x0
    53a2:	30e080e7          	jalr	782(ra) # 56ac <exit>
        printf("SOME TESTS FAILED\n");
    53a6:	8556                	mv	a0,s5
    53a8:	00000097          	auipc	ra,0x0
    53ac:	6d6080e7          	jalr	1750(ra) # 5a7e <printf>
        if(continuous != 2)
    53b0:	f74998e3          	bne	s3,s4,5320 <main+0x110>
      int free1 = countfree();
    53b4:	00000097          	auipc	ra,0x0
    53b8:	c8e080e7          	jalr	-882(ra) # 5042 <countfree>
      if(free1 < free0){
    53bc:	f72547e3          	blt	a0,s2,532a <main+0x11a>
      int free0 = countfree();
    53c0:	00000097          	auipc	ra,0x0
    53c4:	c82080e7          	jalr	-894(ra) # 5042 <countfree>
    53c8:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    53ca:	c0843583          	ld	a1,-1016(s0)
    53ce:	d1fd                	beqz	a1,53b4 <main+0x1a4>
    53d0:	c0040493          	addi	s1,s0,-1024
        if(!run(t->f, t->s)){
    53d4:	6088                	ld	a0,0(s1)
    53d6:	00000097          	auipc	ra,0x0
    53da:	d9c080e7          	jalr	-612(ra) # 5172 <run>
    53de:	d561                	beqz	a0,53a6 <main+0x196>
      for (struct test *t = tests; t->s != 0; t++) {
    53e0:	04c1                	addi	s1,s1,16
    53e2:	648c                	ld	a1,8(s1)
    53e4:	f9e5                	bnez	a1,53d4 <main+0x1c4>
    53e6:	b7f9                	j	53b4 <main+0x1a4>
    continuous = 1;
    53e8:	4985                	li	s3,1
  } tests[] = {
    53ea:	00003797          	auipc	a5,0x3
    53ee:	cf678793          	addi	a5,a5,-778 # 80e0 <csem_up+0x23ea>
    53f2:	c0040713          	addi	a4,s0,-1024
    53f6:	00003817          	auipc	a6,0x3
    53fa:	0aa80813          	addi	a6,a6,170 # 84a0 <csem_up+0x27aa>
    53fe:	6388                	ld	a0,0(a5)
    5400:	678c                	ld	a1,8(a5)
    5402:	6b90                	ld	a2,16(a5)
    5404:	6f94                	ld	a3,24(a5)
    5406:	e308                	sd	a0,0(a4)
    5408:	e70c                	sd	a1,8(a4)
    540a:	eb10                	sd	a2,16(a4)
    540c:	ef14                	sd	a3,24(a4)
    540e:	02078793          	addi	a5,a5,32
    5412:	02070713          	addi	a4,a4,32
    5416:	ff0794e3          	bne	a5,a6,53fe <main+0x1ee>
    printf("continuous usertests starting\n");
    541a:	00003517          	auipc	a0,0x3
    541e:	c7e50513          	addi	a0,a0,-898 # 8098 <csem_up+0x23a2>
    5422:	00000097          	auipc	ra,0x0
    5426:	65c080e7          	jalr	1628(ra) # 5a7e <printf>
        printf("SOME TESTS FAILED\n");
    542a:	00003a97          	auipc	s5,0x3
    542e:	bf6a8a93          	addi	s5,s5,-1034 # 8020 <csem_up+0x232a>
        if(continuous != 2)
    5432:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5434:	00003b17          	auipc	s6,0x3
    5438:	bccb0b13          	addi	s6,s6,-1076 # 8000 <csem_up+0x230a>
    543c:	b751                	j	53c0 <main+0x1b0>

000000000000543e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    543e:	1141                	addi	sp,sp,-16
    5440:	e422                	sd	s0,8(sp)
    5442:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5444:	87aa                	mv	a5,a0
    5446:	0585                	addi	a1,a1,1
    5448:	0785                	addi	a5,a5,1
    544a:	fff5c703          	lbu	a4,-1(a1)
    544e:	fee78fa3          	sb	a4,-1(a5)
    5452:	fb75                	bnez	a4,5446 <strcpy+0x8>
    ;
  return os;
}
    5454:	6422                	ld	s0,8(sp)
    5456:	0141                	addi	sp,sp,16
    5458:	8082                	ret

000000000000545a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    545a:	1141                	addi	sp,sp,-16
    545c:	e422                	sd	s0,8(sp)
    545e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5460:	00054783          	lbu	a5,0(a0)
    5464:	cb91                	beqz	a5,5478 <strcmp+0x1e>
    5466:	0005c703          	lbu	a4,0(a1)
    546a:	00f71763          	bne	a4,a5,5478 <strcmp+0x1e>
    p++, q++;
    546e:	0505                	addi	a0,a0,1
    5470:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5472:	00054783          	lbu	a5,0(a0)
    5476:	fbe5                	bnez	a5,5466 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5478:	0005c503          	lbu	a0,0(a1)
}
    547c:	40a7853b          	subw	a0,a5,a0
    5480:	6422                	ld	s0,8(sp)
    5482:	0141                	addi	sp,sp,16
    5484:	8082                	ret

0000000000005486 <strlen>:

uint
strlen(const char *s)
{
    5486:	1141                	addi	sp,sp,-16
    5488:	e422                	sd	s0,8(sp)
    548a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    548c:	00054783          	lbu	a5,0(a0)
    5490:	cf91                	beqz	a5,54ac <strlen+0x26>
    5492:	0505                	addi	a0,a0,1
    5494:	87aa                	mv	a5,a0
    5496:	4685                	li	a3,1
    5498:	9e89                	subw	a3,a3,a0
    549a:	00f6853b          	addw	a0,a3,a5
    549e:	0785                	addi	a5,a5,1
    54a0:	fff7c703          	lbu	a4,-1(a5)
    54a4:	fb7d                	bnez	a4,549a <strlen+0x14>
    ;
  return n;
}
    54a6:	6422                	ld	s0,8(sp)
    54a8:	0141                	addi	sp,sp,16
    54aa:	8082                	ret
  for(n = 0; s[n]; n++)
    54ac:	4501                	li	a0,0
    54ae:	bfe5                	j	54a6 <strlen+0x20>

00000000000054b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    54b0:	1141                	addi	sp,sp,-16
    54b2:	e422                	sd	s0,8(sp)
    54b4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    54b6:	ca19                	beqz	a2,54cc <memset+0x1c>
    54b8:	87aa                	mv	a5,a0
    54ba:	1602                	slli	a2,a2,0x20
    54bc:	9201                	srli	a2,a2,0x20
    54be:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    54c2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    54c6:	0785                	addi	a5,a5,1
    54c8:	fee79de3          	bne	a5,a4,54c2 <memset+0x12>
  }
  return dst;
}
    54cc:	6422                	ld	s0,8(sp)
    54ce:	0141                	addi	sp,sp,16
    54d0:	8082                	ret

00000000000054d2 <strchr>:

char*
strchr(const char *s, char c)
{
    54d2:	1141                	addi	sp,sp,-16
    54d4:	e422                	sd	s0,8(sp)
    54d6:	0800                	addi	s0,sp,16
  for(; *s; s++)
    54d8:	00054783          	lbu	a5,0(a0)
    54dc:	cb99                	beqz	a5,54f2 <strchr+0x20>
    if(*s == c)
    54de:	00f58763          	beq	a1,a5,54ec <strchr+0x1a>
  for(; *s; s++)
    54e2:	0505                	addi	a0,a0,1
    54e4:	00054783          	lbu	a5,0(a0)
    54e8:	fbfd                	bnez	a5,54de <strchr+0xc>
      return (char*)s;
  return 0;
    54ea:	4501                	li	a0,0
}
    54ec:	6422                	ld	s0,8(sp)
    54ee:	0141                	addi	sp,sp,16
    54f0:	8082                	ret
  return 0;
    54f2:	4501                	li	a0,0
    54f4:	bfe5                	j	54ec <strchr+0x1a>

00000000000054f6 <gets>:

char*
gets(char *buf, int max)
{
    54f6:	711d                	addi	sp,sp,-96
    54f8:	ec86                	sd	ra,88(sp)
    54fa:	e8a2                	sd	s0,80(sp)
    54fc:	e4a6                	sd	s1,72(sp)
    54fe:	e0ca                	sd	s2,64(sp)
    5500:	fc4e                	sd	s3,56(sp)
    5502:	f852                	sd	s4,48(sp)
    5504:	f456                	sd	s5,40(sp)
    5506:	f05a                	sd	s6,32(sp)
    5508:	ec5e                	sd	s7,24(sp)
    550a:	1080                	addi	s0,sp,96
    550c:	8baa                	mv	s7,a0
    550e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5510:	892a                	mv	s2,a0
    5512:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5514:	4aa9                	li	s5,10
    5516:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5518:	89a6                	mv	s3,s1
    551a:	2485                	addiw	s1,s1,1
    551c:	0344d863          	bge	s1,s4,554c <gets+0x56>
    cc = read(0, &c, 1);
    5520:	4605                	li	a2,1
    5522:	faf40593          	addi	a1,s0,-81
    5526:	4501                	li	a0,0
    5528:	00000097          	auipc	ra,0x0
    552c:	19c080e7          	jalr	412(ra) # 56c4 <read>
    if(cc < 1)
    5530:	00a05e63          	blez	a0,554c <gets+0x56>
    buf[i++] = c;
    5534:	faf44783          	lbu	a5,-81(s0)
    5538:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    553c:	01578763          	beq	a5,s5,554a <gets+0x54>
    5540:	0905                	addi	s2,s2,1
    5542:	fd679be3          	bne	a5,s6,5518 <gets+0x22>
  for(i=0; i+1 < max; ){
    5546:	89a6                	mv	s3,s1
    5548:	a011                	j	554c <gets+0x56>
    554a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    554c:	99de                	add	s3,s3,s7
    554e:	00098023          	sb	zero,0(s3)
  return buf;
}
    5552:	855e                	mv	a0,s7
    5554:	60e6                	ld	ra,88(sp)
    5556:	6446                	ld	s0,80(sp)
    5558:	64a6                	ld	s1,72(sp)
    555a:	6906                	ld	s2,64(sp)
    555c:	79e2                	ld	s3,56(sp)
    555e:	7a42                	ld	s4,48(sp)
    5560:	7aa2                	ld	s5,40(sp)
    5562:	7b02                	ld	s6,32(sp)
    5564:	6be2                	ld	s7,24(sp)
    5566:	6125                	addi	sp,sp,96
    5568:	8082                	ret

000000000000556a <stat>:

int
stat(const char *n, struct stat *st)
{
    556a:	1101                	addi	sp,sp,-32
    556c:	ec06                	sd	ra,24(sp)
    556e:	e822                	sd	s0,16(sp)
    5570:	e426                	sd	s1,8(sp)
    5572:	e04a                	sd	s2,0(sp)
    5574:	1000                	addi	s0,sp,32
    5576:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5578:	4581                	li	a1,0
    557a:	00000097          	auipc	ra,0x0
    557e:	172080e7          	jalr	370(ra) # 56ec <open>
  if(fd < 0)
    5582:	02054563          	bltz	a0,55ac <stat+0x42>
    5586:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5588:	85ca                	mv	a1,s2
    558a:	00000097          	auipc	ra,0x0
    558e:	17a080e7          	jalr	378(ra) # 5704 <fstat>
    5592:	892a                	mv	s2,a0
  close(fd);
    5594:	8526                	mv	a0,s1
    5596:	00000097          	auipc	ra,0x0
    559a:	13e080e7          	jalr	318(ra) # 56d4 <close>
  return r;
}
    559e:	854a                	mv	a0,s2
    55a0:	60e2                	ld	ra,24(sp)
    55a2:	6442                	ld	s0,16(sp)
    55a4:	64a2                	ld	s1,8(sp)
    55a6:	6902                	ld	s2,0(sp)
    55a8:	6105                	addi	sp,sp,32
    55aa:	8082                	ret
    return -1;
    55ac:	597d                	li	s2,-1
    55ae:	bfc5                	j	559e <stat+0x34>

00000000000055b0 <atoi>:

int
atoi(const char *s)
{
    55b0:	1141                	addi	sp,sp,-16
    55b2:	e422                	sd	s0,8(sp)
    55b4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    55b6:	00054603          	lbu	a2,0(a0)
    55ba:	fd06079b          	addiw	a5,a2,-48
    55be:	0ff7f793          	andi	a5,a5,255
    55c2:	4725                	li	a4,9
    55c4:	02f76963          	bltu	a4,a5,55f6 <atoi+0x46>
    55c8:	86aa                	mv	a3,a0
  n = 0;
    55ca:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    55cc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    55ce:	0685                	addi	a3,a3,1
    55d0:	0025179b          	slliw	a5,a0,0x2
    55d4:	9fa9                	addw	a5,a5,a0
    55d6:	0017979b          	slliw	a5,a5,0x1
    55da:	9fb1                	addw	a5,a5,a2
    55dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    55e0:	0006c603          	lbu	a2,0(a3)
    55e4:	fd06071b          	addiw	a4,a2,-48
    55e8:	0ff77713          	andi	a4,a4,255
    55ec:	fee5f1e3          	bgeu	a1,a4,55ce <atoi+0x1e>
  return n;
}
    55f0:	6422                	ld	s0,8(sp)
    55f2:	0141                	addi	sp,sp,16
    55f4:	8082                	ret
  n = 0;
    55f6:	4501                	li	a0,0
    55f8:	bfe5                	j	55f0 <atoi+0x40>

00000000000055fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    55fa:	1141                	addi	sp,sp,-16
    55fc:	e422                	sd	s0,8(sp)
    55fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5600:	02b57463          	bgeu	a0,a1,5628 <memmove+0x2e>
    while(n-- > 0)
    5604:	00c05f63          	blez	a2,5622 <memmove+0x28>
    5608:	1602                	slli	a2,a2,0x20
    560a:	9201                	srli	a2,a2,0x20
    560c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5610:	872a                	mv	a4,a0
      *dst++ = *src++;
    5612:	0585                	addi	a1,a1,1
    5614:	0705                	addi	a4,a4,1
    5616:	fff5c683          	lbu	a3,-1(a1)
    561a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    561e:	fee79ae3          	bne	a5,a4,5612 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5622:	6422                	ld	s0,8(sp)
    5624:	0141                	addi	sp,sp,16
    5626:	8082                	ret
    dst += n;
    5628:	00c50733          	add	a4,a0,a2
    src += n;
    562c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    562e:	fec05ae3          	blez	a2,5622 <memmove+0x28>
    5632:	fff6079b          	addiw	a5,a2,-1
    5636:	1782                	slli	a5,a5,0x20
    5638:	9381                	srli	a5,a5,0x20
    563a:	fff7c793          	not	a5,a5
    563e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5640:	15fd                	addi	a1,a1,-1
    5642:	177d                	addi	a4,a4,-1
    5644:	0005c683          	lbu	a3,0(a1)
    5648:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    564c:	fee79ae3          	bne	a5,a4,5640 <memmove+0x46>
    5650:	bfc9                	j	5622 <memmove+0x28>

0000000000005652 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5652:	1141                	addi	sp,sp,-16
    5654:	e422                	sd	s0,8(sp)
    5656:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5658:	ca05                	beqz	a2,5688 <memcmp+0x36>
    565a:	fff6069b          	addiw	a3,a2,-1
    565e:	1682                	slli	a3,a3,0x20
    5660:	9281                	srli	a3,a3,0x20
    5662:	0685                	addi	a3,a3,1
    5664:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5666:	00054783          	lbu	a5,0(a0)
    566a:	0005c703          	lbu	a4,0(a1)
    566e:	00e79863          	bne	a5,a4,567e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5672:	0505                	addi	a0,a0,1
    p2++;
    5674:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5676:	fed518e3          	bne	a0,a3,5666 <memcmp+0x14>
  }
  return 0;
    567a:	4501                	li	a0,0
    567c:	a019                	j	5682 <memcmp+0x30>
      return *p1 - *p2;
    567e:	40e7853b          	subw	a0,a5,a4
}
    5682:	6422                	ld	s0,8(sp)
    5684:	0141                	addi	sp,sp,16
    5686:	8082                	ret
  return 0;
    5688:	4501                	li	a0,0
    568a:	bfe5                	j	5682 <memcmp+0x30>

000000000000568c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    568c:	1141                	addi	sp,sp,-16
    568e:	e406                	sd	ra,8(sp)
    5690:	e022                	sd	s0,0(sp)
    5692:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5694:	00000097          	auipc	ra,0x0
    5698:	f66080e7          	jalr	-154(ra) # 55fa <memmove>
}
    569c:	60a2                	ld	ra,8(sp)
    569e:	6402                	ld	s0,0(sp)
    56a0:	0141                	addi	sp,sp,16
    56a2:	8082                	ret

00000000000056a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    56a4:	4885                	li	a7,1
 ecall
    56a6:	00000073          	ecall
 ret
    56aa:	8082                	ret

00000000000056ac <exit>:
.global exit
exit:
 li a7, SYS_exit
    56ac:	4889                	li	a7,2
 ecall
    56ae:	00000073          	ecall
 ret
    56b2:	8082                	ret

00000000000056b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
    56b4:	488d                	li	a7,3
 ecall
    56b6:	00000073          	ecall
 ret
    56ba:	8082                	ret

00000000000056bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    56bc:	4891                	li	a7,4
 ecall
    56be:	00000073          	ecall
 ret
    56c2:	8082                	ret

00000000000056c4 <read>:
.global read
read:
 li a7, SYS_read
    56c4:	4895                	li	a7,5
 ecall
    56c6:	00000073          	ecall
 ret
    56ca:	8082                	ret

00000000000056cc <write>:
.global write
write:
 li a7, SYS_write
    56cc:	48c1                	li	a7,16
 ecall
    56ce:	00000073          	ecall
 ret
    56d2:	8082                	ret

00000000000056d4 <close>:
.global close
close:
 li a7, SYS_close
    56d4:	48d5                	li	a7,21
 ecall
    56d6:	00000073          	ecall
 ret
    56da:	8082                	ret

00000000000056dc <kill>:
.global kill
kill:
 li a7, SYS_kill
    56dc:	4899                	li	a7,6
 ecall
    56de:	00000073          	ecall
 ret
    56e2:	8082                	ret

00000000000056e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
    56e4:	489d                	li	a7,7
 ecall
    56e6:	00000073          	ecall
 ret
    56ea:	8082                	ret

00000000000056ec <open>:
.global open
open:
 li a7, SYS_open
    56ec:	48bd                	li	a7,15
 ecall
    56ee:	00000073          	ecall
 ret
    56f2:	8082                	ret

00000000000056f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    56f4:	48c5                	li	a7,17
 ecall
    56f6:	00000073          	ecall
 ret
    56fa:	8082                	ret

00000000000056fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    56fc:	48c9                	li	a7,18
 ecall
    56fe:	00000073          	ecall
 ret
    5702:	8082                	ret

0000000000005704 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5704:	48a1                	li	a7,8
 ecall
    5706:	00000073          	ecall
 ret
    570a:	8082                	ret

000000000000570c <link>:
.global link
link:
 li a7, SYS_link
    570c:	48cd                	li	a7,19
 ecall
    570e:	00000073          	ecall
 ret
    5712:	8082                	ret

0000000000005714 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5714:	48d1                	li	a7,20
 ecall
    5716:	00000073          	ecall
 ret
    571a:	8082                	ret

000000000000571c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    571c:	48a5                	li	a7,9
 ecall
    571e:	00000073          	ecall
 ret
    5722:	8082                	ret

0000000000005724 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5724:	48a9                	li	a7,10
 ecall
    5726:	00000073          	ecall
 ret
    572a:	8082                	ret

000000000000572c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    572c:	48ad                	li	a7,11
 ecall
    572e:	00000073          	ecall
 ret
    5732:	8082                	ret

0000000000005734 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5734:	48b1                	li	a7,12
 ecall
    5736:	00000073          	ecall
 ret
    573a:	8082                	ret

000000000000573c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    573c:	48b5                	li	a7,13
 ecall
    573e:	00000073          	ecall
 ret
    5742:	8082                	ret

0000000000005744 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5744:	48b9                	li	a7,14
 ecall
    5746:	00000073          	ecall
 ret
    574a:	8082                	ret

000000000000574c <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
    574c:	48d9                	li	a7,22
 ecall
    574e:	00000073          	ecall
 ret
    5752:	8082                	ret

0000000000005754 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
    5754:	48dd                	li	a7,23
 ecall
    5756:	00000073          	ecall
 ret
    575a:	8082                	ret

000000000000575c <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
    575c:	48e1                	li	a7,24
 ecall
    575e:	00000073          	ecall
 ret
    5762:	8082                	ret

0000000000005764 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
    5764:	48e5                	li	a7,25
 ecall
    5766:	00000073          	ecall
 ret
    576a:	8082                	ret

000000000000576c <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
    576c:	48e9                	li	a7,26
 ecall
    576e:	00000073          	ecall
 ret
    5772:	8082                	ret

0000000000005774 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
    5774:	48ed                	li	a7,27
 ecall
    5776:	00000073          	ecall
 ret
    577a:	8082                	ret

000000000000577c <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
    577c:	48f1                	li	a7,28
 ecall
    577e:	00000073          	ecall
 ret
    5782:	8082                	ret

0000000000005784 <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
    5784:	48f5                	li	a7,29
 ecall
    5786:	00000073          	ecall
 ret
    578a:	8082                	ret

000000000000578c <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
    578c:	48f9                	li	a7,30
 ecall
    578e:	00000073          	ecall
 ret
    5792:	8082                	ret

0000000000005794 <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
    5794:	48fd                	li	a7,31
 ecall
    5796:	00000073          	ecall
 ret
    579a:	8082                	ret

000000000000579c <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
    579c:	02000893          	li	a7,32
 ecall
    57a0:	00000073          	ecall
 ret
    57a4:	8082                	ret

00000000000057a6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    57a6:	1101                	addi	sp,sp,-32
    57a8:	ec06                	sd	ra,24(sp)
    57aa:	e822                	sd	s0,16(sp)
    57ac:	1000                	addi	s0,sp,32
    57ae:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    57b2:	4605                	li	a2,1
    57b4:	fef40593          	addi	a1,s0,-17
    57b8:	00000097          	auipc	ra,0x0
    57bc:	f14080e7          	jalr	-236(ra) # 56cc <write>
}
    57c0:	60e2                	ld	ra,24(sp)
    57c2:	6442                	ld	s0,16(sp)
    57c4:	6105                	addi	sp,sp,32
    57c6:	8082                	ret

00000000000057c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    57c8:	7139                	addi	sp,sp,-64
    57ca:	fc06                	sd	ra,56(sp)
    57cc:	f822                	sd	s0,48(sp)
    57ce:	f426                	sd	s1,40(sp)
    57d0:	f04a                	sd	s2,32(sp)
    57d2:	ec4e                	sd	s3,24(sp)
    57d4:	0080                	addi	s0,sp,64
    57d6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    57d8:	c299                	beqz	a3,57de <printint+0x16>
    57da:	0805c863          	bltz	a1,586a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    57de:	2581                	sext.w	a1,a1
  neg = 0;
    57e0:	4881                	li	a7,0
    57e2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    57e6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    57e8:	2601                	sext.w	a2,a2
    57ea:	00003517          	auipc	a0,0x3
    57ee:	cbe50513          	addi	a0,a0,-834 # 84a8 <digits>
    57f2:	883a                	mv	a6,a4
    57f4:	2705                	addiw	a4,a4,1
    57f6:	02c5f7bb          	remuw	a5,a1,a2
    57fa:	1782                	slli	a5,a5,0x20
    57fc:	9381                	srli	a5,a5,0x20
    57fe:	97aa                	add	a5,a5,a0
    5800:	0007c783          	lbu	a5,0(a5)
    5804:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5808:	0005879b          	sext.w	a5,a1
    580c:	02c5d5bb          	divuw	a1,a1,a2
    5810:	0685                	addi	a3,a3,1
    5812:	fec7f0e3          	bgeu	a5,a2,57f2 <printint+0x2a>
  if(neg)
    5816:	00088b63          	beqz	a7,582c <printint+0x64>
    buf[i++] = '-';
    581a:	fd040793          	addi	a5,s0,-48
    581e:	973e                	add	a4,a4,a5
    5820:	02d00793          	li	a5,45
    5824:	fef70823          	sb	a5,-16(a4)
    5828:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    582c:	02e05863          	blez	a4,585c <printint+0x94>
    5830:	fc040793          	addi	a5,s0,-64
    5834:	00e78933          	add	s2,a5,a4
    5838:	fff78993          	addi	s3,a5,-1
    583c:	99ba                	add	s3,s3,a4
    583e:	377d                	addiw	a4,a4,-1
    5840:	1702                	slli	a4,a4,0x20
    5842:	9301                	srli	a4,a4,0x20
    5844:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5848:	fff94583          	lbu	a1,-1(s2)
    584c:	8526                	mv	a0,s1
    584e:	00000097          	auipc	ra,0x0
    5852:	f58080e7          	jalr	-168(ra) # 57a6 <putc>
  while(--i >= 0)
    5856:	197d                	addi	s2,s2,-1
    5858:	ff3918e3          	bne	s2,s3,5848 <printint+0x80>
}
    585c:	70e2                	ld	ra,56(sp)
    585e:	7442                	ld	s0,48(sp)
    5860:	74a2                	ld	s1,40(sp)
    5862:	7902                	ld	s2,32(sp)
    5864:	69e2                	ld	s3,24(sp)
    5866:	6121                	addi	sp,sp,64
    5868:	8082                	ret
    x = -xx;
    586a:	40b005bb          	negw	a1,a1
    neg = 1;
    586e:	4885                	li	a7,1
    x = -xx;
    5870:	bf8d                	j	57e2 <printint+0x1a>

0000000000005872 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5872:	7119                	addi	sp,sp,-128
    5874:	fc86                	sd	ra,120(sp)
    5876:	f8a2                	sd	s0,112(sp)
    5878:	f4a6                	sd	s1,104(sp)
    587a:	f0ca                	sd	s2,96(sp)
    587c:	ecce                	sd	s3,88(sp)
    587e:	e8d2                	sd	s4,80(sp)
    5880:	e4d6                	sd	s5,72(sp)
    5882:	e0da                	sd	s6,64(sp)
    5884:	fc5e                	sd	s7,56(sp)
    5886:	f862                	sd	s8,48(sp)
    5888:	f466                	sd	s9,40(sp)
    588a:	f06a                	sd	s10,32(sp)
    588c:	ec6e                	sd	s11,24(sp)
    588e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5890:	0005c903          	lbu	s2,0(a1)
    5894:	18090f63          	beqz	s2,5a32 <vprintf+0x1c0>
    5898:	8aaa                	mv	s5,a0
    589a:	8b32                	mv	s6,a2
    589c:	00158493          	addi	s1,a1,1
  state = 0;
    58a0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    58a2:	02500a13          	li	s4,37
      if(c == 'd'){
    58a6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    58aa:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    58ae:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    58b2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    58b6:	00003b97          	auipc	s7,0x3
    58ba:	bf2b8b93          	addi	s7,s7,-1038 # 84a8 <digits>
    58be:	a839                	j	58dc <vprintf+0x6a>
        putc(fd, c);
    58c0:	85ca                	mv	a1,s2
    58c2:	8556                	mv	a0,s5
    58c4:	00000097          	auipc	ra,0x0
    58c8:	ee2080e7          	jalr	-286(ra) # 57a6 <putc>
    58cc:	a019                	j	58d2 <vprintf+0x60>
    } else if(state == '%'){
    58ce:	01498f63          	beq	s3,s4,58ec <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    58d2:	0485                	addi	s1,s1,1
    58d4:	fff4c903          	lbu	s2,-1(s1)
    58d8:	14090d63          	beqz	s2,5a32 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    58dc:	0009079b          	sext.w	a5,s2
    if(state == 0){
    58e0:	fe0997e3          	bnez	s3,58ce <vprintf+0x5c>
      if(c == '%'){
    58e4:	fd479ee3          	bne	a5,s4,58c0 <vprintf+0x4e>
        state = '%';
    58e8:	89be                	mv	s3,a5
    58ea:	b7e5                	j	58d2 <vprintf+0x60>
      if(c == 'd'){
    58ec:	05878063          	beq	a5,s8,592c <vprintf+0xba>
      } else if(c == 'l') {
    58f0:	05978c63          	beq	a5,s9,5948 <vprintf+0xd6>
      } else if(c == 'x') {
    58f4:	07a78863          	beq	a5,s10,5964 <vprintf+0xf2>
      } else if(c == 'p') {
    58f8:	09b78463          	beq	a5,s11,5980 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    58fc:	07300713          	li	a4,115
    5900:	0ce78663          	beq	a5,a4,59cc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5904:	06300713          	li	a4,99
    5908:	0ee78e63          	beq	a5,a4,5a04 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    590c:	11478863          	beq	a5,s4,5a1c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5910:	85d2                	mv	a1,s4
    5912:	8556                	mv	a0,s5
    5914:	00000097          	auipc	ra,0x0
    5918:	e92080e7          	jalr	-366(ra) # 57a6 <putc>
        putc(fd, c);
    591c:	85ca                	mv	a1,s2
    591e:	8556                	mv	a0,s5
    5920:	00000097          	auipc	ra,0x0
    5924:	e86080e7          	jalr	-378(ra) # 57a6 <putc>
      }
      state = 0;
    5928:	4981                	li	s3,0
    592a:	b765                	j	58d2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    592c:	008b0913          	addi	s2,s6,8
    5930:	4685                	li	a3,1
    5932:	4629                	li	a2,10
    5934:	000b2583          	lw	a1,0(s6)
    5938:	8556                	mv	a0,s5
    593a:	00000097          	auipc	ra,0x0
    593e:	e8e080e7          	jalr	-370(ra) # 57c8 <printint>
    5942:	8b4a                	mv	s6,s2
      state = 0;
    5944:	4981                	li	s3,0
    5946:	b771                	j	58d2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5948:	008b0913          	addi	s2,s6,8
    594c:	4681                	li	a3,0
    594e:	4629                	li	a2,10
    5950:	000b2583          	lw	a1,0(s6)
    5954:	8556                	mv	a0,s5
    5956:	00000097          	auipc	ra,0x0
    595a:	e72080e7          	jalr	-398(ra) # 57c8 <printint>
    595e:	8b4a                	mv	s6,s2
      state = 0;
    5960:	4981                	li	s3,0
    5962:	bf85                	j	58d2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5964:	008b0913          	addi	s2,s6,8
    5968:	4681                	li	a3,0
    596a:	4641                	li	a2,16
    596c:	000b2583          	lw	a1,0(s6)
    5970:	8556                	mv	a0,s5
    5972:	00000097          	auipc	ra,0x0
    5976:	e56080e7          	jalr	-426(ra) # 57c8 <printint>
    597a:	8b4a                	mv	s6,s2
      state = 0;
    597c:	4981                	li	s3,0
    597e:	bf91                	j	58d2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5980:	008b0793          	addi	a5,s6,8
    5984:	f8f43423          	sd	a5,-120(s0)
    5988:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    598c:	03000593          	li	a1,48
    5990:	8556                	mv	a0,s5
    5992:	00000097          	auipc	ra,0x0
    5996:	e14080e7          	jalr	-492(ra) # 57a6 <putc>
  putc(fd, 'x');
    599a:	85ea                	mv	a1,s10
    599c:	8556                	mv	a0,s5
    599e:	00000097          	auipc	ra,0x0
    59a2:	e08080e7          	jalr	-504(ra) # 57a6 <putc>
    59a6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    59a8:	03c9d793          	srli	a5,s3,0x3c
    59ac:	97de                	add	a5,a5,s7
    59ae:	0007c583          	lbu	a1,0(a5)
    59b2:	8556                	mv	a0,s5
    59b4:	00000097          	auipc	ra,0x0
    59b8:	df2080e7          	jalr	-526(ra) # 57a6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    59bc:	0992                	slli	s3,s3,0x4
    59be:	397d                	addiw	s2,s2,-1
    59c0:	fe0914e3          	bnez	s2,59a8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    59c4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    59c8:	4981                	li	s3,0
    59ca:	b721                	j	58d2 <vprintf+0x60>
        s = va_arg(ap, char*);
    59cc:	008b0993          	addi	s3,s6,8
    59d0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    59d4:	02090163          	beqz	s2,59f6 <vprintf+0x184>
        while(*s != 0){
    59d8:	00094583          	lbu	a1,0(s2)
    59dc:	c9a1                	beqz	a1,5a2c <vprintf+0x1ba>
          putc(fd, *s);
    59de:	8556                	mv	a0,s5
    59e0:	00000097          	auipc	ra,0x0
    59e4:	dc6080e7          	jalr	-570(ra) # 57a6 <putc>
          s++;
    59e8:	0905                	addi	s2,s2,1
        while(*s != 0){
    59ea:	00094583          	lbu	a1,0(s2)
    59ee:	f9e5                	bnez	a1,59de <vprintf+0x16c>
        s = va_arg(ap, char*);
    59f0:	8b4e                	mv	s6,s3
      state = 0;
    59f2:	4981                	li	s3,0
    59f4:	bdf9                	j	58d2 <vprintf+0x60>
          s = "(null)";
    59f6:	00003917          	auipc	s2,0x3
    59fa:	aaa90913          	addi	s2,s2,-1366 # 84a0 <csem_up+0x27aa>
        while(*s != 0){
    59fe:	02800593          	li	a1,40
    5a02:	bff1                	j	59de <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5a04:	008b0913          	addi	s2,s6,8
    5a08:	000b4583          	lbu	a1,0(s6)
    5a0c:	8556                	mv	a0,s5
    5a0e:	00000097          	auipc	ra,0x0
    5a12:	d98080e7          	jalr	-616(ra) # 57a6 <putc>
    5a16:	8b4a                	mv	s6,s2
      state = 0;
    5a18:	4981                	li	s3,0
    5a1a:	bd65                	j	58d2 <vprintf+0x60>
        putc(fd, c);
    5a1c:	85d2                	mv	a1,s4
    5a1e:	8556                	mv	a0,s5
    5a20:	00000097          	auipc	ra,0x0
    5a24:	d86080e7          	jalr	-634(ra) # 57a6 <putc>
      state = 0;
    5a28:	4981                	li	s3,0
    5a2a:	b565                	j	58d2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5a2c:	8b4e                	mv	s6,s3
      state = 0;
    5a2e:	4981                	li	s3,0
    5a30:	b54d                	j	58d2 <vprintf+0x60>
    }
  }
}
    5a32:	70e6                	ld	ra,120(sp)
    5a34:	7446                	ld	s0,112(sp)
    5a36:	74a6                	ld	s1,104(sp)
    5a38:	7906                	ld	s2,96(sp)
    5a3a:	69e6                	ld	s3,88(sp)
    5a3c:	6a46                	ld	s4,80(sp)
    5a3e:	6aa6                	ld	s5,72(sp)
    5a40:	6b06                	ld	s6,64(sp)
    5a42:	7be2                	ld	s7,56(sp)
    5a44:	7c42                	ld	s8,48(sp)
    5a46:	7ca2                	ld	s9,40(sp)
    5a48:	7d02                	ld	s10,32(sp)
    5a4a:	6de2                	ld	s11,24(sp)
    5a4c:	6109                	addi	sp,sp,128
    5a4e:	8082                	ret

0000000000005a50 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5a50:	715d                	addi	sp,sp,-80
    5a52:	ec06                	sd	ra,24(sp)
    5a54:	e822                	sd	s0,16(sp)
    5a56:	1000                	addi	s0,sp,32
    5a58:	e010                	sd	a2,0(s0)
    5a5a:	e414                	sd	a3,8(s0)
    5a5c:	e818                	sd	a4,16(s0)
    5a5e:	ec1c                	sd	a5,24(s0)
    5a60:	03043023          	sd	a6,32(s0)
    5a64:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5a68:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5a6c:	8622                	mv	a2,s0
    5a6e:	00000097          	auipc	ra,0x0
    5a72:	e04080e7          	jalr	-508(ra) # 5872 <vprintf>
}
    5a76:	60e2                	ld	ra,24(sp)
    5a78:	6442                	ld	s0,16(sp)
    5a7a:	6161                	addi	sp,sp,80
    5a7c:	8082                	ret

0000000000005a7e <printf>:

void
printf(const char *fmt, ...)
{
    5a7e:	711d                	addi	sp,sp,-96
    5a80:	ec06                	sd	ra,24(sp)
    5a82:	e822                	sd	s0,16(sp)
    5a84:	1000                	addi	s0,sp,32
    5a86:	e40c                	sd	a1,8(s0)
    5a88:	e810                	sd	a2,16(s0)
    5a8a:	ec14                	sd	a3,24(s0)
    5a8c:	f018                	sd	a4,32(s0)
    5a8e:	f41c                	sd	a5,40(s0)
    5a90:	03043823          	sd	a6,48(s0)
    5a94:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5a98:	00840613          	addi	a2,s0,8
    5a9c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5aa0:	85aa                	mv	a1,a0
    5aa2:	4505                	li	a0,1
    5aa4:	00000097          	auipc	ra,0x0
    5aa8:	dce080e7          	jalr	-562(ra) # 5872 <vprintf>
}
    5aac:	60e2                	ld	ra,24(sp)
    5aae:	6442                	ld	s0,16(sp)
    5ab0:	6125                	addi	sp,sp,96
    5ab2:	8082                	ret

0000000000005ab4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5ab4:	1141                	addi	sp,sp,-16
    5ab6:	e422                	sd	s0,8(sp)
    5ab8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5aba:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5abe:	00003797          	auipc	a5,0x3
    5ac2:	a127b783          	ld	a5,-1518(a5) # 84d0 <freep>
    5ac6:	a805                	j	5af6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5ac8:	4618                	lw	a4,8(a2)
    5aca:	9db9                	addw	a1,a1,a4
    5acc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5ad0:	6398                	ld	a4,0(a5)
    5ad2:	6318                	ld	a4,0(a4)
    5ad4:	fee53823          	sd	a4,-16(a0)
    5ad8:	a091                	j	5b1c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5ada:	ff852703          	lw	a4,-8(a0)
    5ade:	9e39                	addw	a2,a2,a4
    5ae0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5ae2:	ff053703          	ld	a4,-16(a0)
    5ae6:	e398                	sd	a4,0(a5)
    5ae8:	a099                	j	5b2e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5aea:	6398                	ld	a4,0(a5)
    5aec:	00e7e463          	bltu	a5,a4,5af4 <free+0x40>
    5af0:	00e6ea63          	bltu	a3,a4,5b04 <free+0x50>
{
    5af4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5af6:	fed7fae3          	bgeu	a5,a3,5aea <free+0x36>
    5afa:	6398                	ld	a4,0(a5)
    5afc:	00e6e463          	bltu	a3,a4,5b04 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5b00:	fee7eae3          	bltu	a5,a4,5af4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5b04:	ff852583          	lw	a1,-8(a0)
    5b08:	6390                	ld	a2,0(a5)
    5b0a:	02059813          	slli	a6,a1,0x20
    5b0e:	01c85713          	srli	a4,a6,0x1c
    5b12:	9736                	add	a4,a4,a3
    5b14:	fae60ae3          	beq	a2,a4,5ac8 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5b18:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5b1c:	4790                	lw	a2,8(a5)
    5b1e:	02061593          	slli	a1,a2,0x20
    5b22:	01c5d713          	srli	a4,a1,0x1c
    5b26:	973e                	add	a4,a4,a5
    5b28:	fae689e3          	beq	a3,a4,5ada <free+0x26>
  } else
    p->s.ptr = bp;
    5b2c:	e394                	sd	a3,0(a5)
  freep = p;
    5b2e:	00003717          	auipc	a4,0x3
    5b32:	9af73123          	sd	a5,-1630(a4) # 84d0 <freep>
}
    5b36:	6422                	ld	s0,8(sp)
    5b38:	0141                	addi	sp,sp,16
    5b3a:	8082                	ret

0000000000005b3c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5b3c:	7139                	addi	sp,sp,-64
    5b3e:	fc06                	sd	ra,56(sp)
    5b40:	f822                	sd	s0,48(sp)
    5b42:	f426                	sd	s1,40(sp)
    5b44:	f04a                	sd	s2,32(sp)
    5b46:	ec4e                	sd	s3,24(sp)
    5b48:	e852                	sd	s4,16(sp)
    5b4a:	e456                	sd	s5,8(sp)
    5b4c:	e05a                	sd	s6,0(sp)
    5b4e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5b50:	02051493          	slli	s1,a0,0x20
    5b54:	9081                	srli	s1,s1,0x20
    5b56:	04bd                	addi	s1,s1,15
    5b58:	8091                	srli	s1,s1,0x4
    5b5a:	0014899b          	addiw	s3,s1,1
    5b5e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5b60:	00003517          	auipc	a0,0x3
    5b64:	97053503          	ld	a0,-1680(a0) # 84d0 <freep>
    5b68:	c515                	beqz	a0,5b94 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5b6a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5b6c:	4798                	lw	a4,8(a5)
    5b6e:	02977f63          	bgeu	a4,s1,5bac <malloc+0x70>
    5b72:	8a4e                	mv	s4,s3
    5b74:	0009871b          	sext.w	a4,s3
    5b78:	6685                	lui	a3,0x1
    5b7a:	00d77363          	bgeu	a4,a3,5b80 <malloc+0x44>
    5b7e:	6a05                	lui	s4,0x1
    5b80:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5b84:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5b88:	00003917          	auipc	s2,0x3
    5b8c:	94890913          	addi	s2,s2,-1720 # 84d0 <freep>
  if(p == (char*)-1)
    5b90:	5afd                	li	s5,-1
    5b92:	a895                	j	5c06 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    5b94:	00009797          	auipc	a5,0x9
    5b98:	15c78793          	addi	a5,a5,348 # ecf0 <base>
    5b9c:	00003717          	auipc	a4,0x3
    5ba0:	92f73a23          	sd	a5,-1740(a4) # 84d0 <freep>
    5ba4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5ba6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5baa:	b7e1                	j	5b72 <malloc+0x36>
      if(p->s.size == nunits)
    5bac:	02e48c63          	beq	s1,a4,5be4 <malloc+0xa8>
        p->s.size -= nunits;
    5bb0:	4137073b          	subw	a4,a4,s3
    5bb4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5bb6:	02071693          	slli	a3,a4,0x20
    5bba:	01c6d713          	srli	a4,a3,0x1c
    5bbe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5bc0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5bc4:	00003717          	auipc	a4,0x3
    5bc8:	90a73623          	sd	a0,-1780(a4) # 84d0 <freep>
      return (void*)(p + 1);
    5bcc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5bd0:	70e2                	ld	ra,56(sp)
    5bd2:	7442                	ld	s0,48(sp)
    5bd4:	74a2                	ld	s1,40(sp)
    5bd6:	7902                	ld	s2,32(sp)
    5bd8:	69e2                	ld	s3,24(sp)
    5bda:	6a42                	ld	s4,16(sp)
    5bdc:	6aa2                	ld	s5,8(sp)
    5bde:	6b02                	ld	s6,0(sp)
    5be0:	6121                	addi	sp,sp,64
    5be2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5be4:	6398                	ld	a4,0(a5)
    5be6:	e118                	sd	a4,0(a0)
    5be8:	bff1                	j	5bc4 <malloc+0x88>
  hp->s.size = nu;
    5bea:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5bee:	0541                	addi	a0,a0,16
    5bf0:	00000097          	auipc	ra,0x0
    5bf4:	ec4080e7          	jalr	-316(ra) # 5ab4 <free>
  return freep;
    5bf8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5bfc:	d971                	beqz	a0,5bd0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5bfe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5c00:	4798                	lw	a4,8(a5)
    5c02:	fa9775e3          	bgeu	a4,s1,5bac <malloc+0x70>
    if(p == freep)
    5c06:	00093703          	ld	a4,0(s2)
    5c0a:	853e                	mv	a0,a5
    5c0c:	fef719e3          	bne	a4,a5,5bfe <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    5c10:	8552                	mv	a0,s4
    5c12:	00000097          	auipc	ra,0x0
    5c16:	b22080e7          	jalr	-1246(ra) # 5734 <sbrk>
  if(p == (char*)-1)
    5c1a:	fd5518e3          	bne	a0,s5,5bea <malloc+0xae>
        return 0;
    5c1e:	4501                	li	a0,0
    5c20:	bf45                	j	5bd0 <malloc+0x94>

0000000000005c22 <csem_alloc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int csem_alloc(struct counting_semaphore *sem, int initial_value){
    5c22:	1101                	addi	sp,sp,-32
    5c24:	ec06                	sd	ra,24(sp)
    5c26:	e822                	sd	s0,16(sp)
    5c28:	e426                	sd	s1,8(sp)
    5c2a:	e04a                	sd	s2,0(sp)
    5c2c:	1000                	addi	s0,sp,32
    5c2e:	84aa                	mv	s1,a0
    5c30:	892e                	mv	s2,a1
    sem->binary_semaphore1 = bsem_alloc();
    5c32:	00000097          	auipc	ra,0x0
    5c36:	b52080e7          	jalr	-1198(ra) # 5784 <bsem_alloc>
    5c3a:	c088                	sw	a0,0(s1)
    sem->binary_semaphore2 = bsem_alloc();
    5c3c:	00000097          	auipc	ra,0x0
    5c40:	b48080e7          	jalr	-1208(ra) # 5784 <bsem_alloc>
    5c44:	87aa                	mv	a5,a0
    5c46:	c0c8                	sw	a0,4(s1)
    if(sem->binary_semaphore1 == -1 || sem->binary_semaphore2 == -1)
    5c48:	4088                	lw	a0,0(s1)
    5c4a:	577d                	li	a4,-1
    5c4c:	00e50963          	beq	a0,a4,5c5e <csem_alloc+0x3c>
    5c50:	02e78363          	beq	a5,a4,5c76 <csem_alloc+0x54>
        return -1;
    if(initial_value == 0)
    5c54:	00090b63          	beqz	s2,5c6a <csem_alloc+0x48>
        bsem_down(sem->binary_semaphore2);
    sem->value = initial_value;
    5c58:	0124a423          	sw	s2,8(s1)
    return 0;
    5c5c:	4501                	li	a0,0
}
    5c5e:	60e2                	ld	ra,24(sp)
    5c60:	6442                	ld	s0,16(sp)
    5c62:	64a2                	ld	s1,8(sp)
    5c64:	6902                	ld	s2,0(sp)
    5c66:	6105                	addi	sp,sp,32
    5c68:	8082                	ret
        bsem_down(sem->binary_semaphore2);
    5c6a:	853e                	mv	a0,a5
    5c6c:	00000097          	auipc	ra,0x0
    5c70:	b28080e7          	jalr	-1240(ra) # 5794 <bsem_down>
    5c74:	b7d5                	j	5c58 <csem_alloc+0x36>
        return -1;
    5c76:	853e                	mv	a0,a5
    5c78:	b7dd                	j	5c5e <csem_alloc+0x3c>

0000000000005c7a <csem_free>:

void csem_free(struct counting_semaphore *sem){
    5c7a:	1101                	addi	sp,sp,-32
    5c7c:	ec06                	sd	ra,24(sp)
    5c7e:	e822                	sd	s0,16(sp)
    5c80:	e426                	sd	s1,8(sp)
    5c82:	1000                	addi	s0,sp,32
    5c84:	84aa                	mv	s1,a0
    bsem_free(sem->binary_semaphore1);
    5c86:	4108                	lw	a0,0(a0)
    5c88:	00000097          	auipc	ra,0x0
    5c8c:	b04080e7          	jalr	-1276(ra) # 578c <bsem_free>
    bsem_free(sem->binary_semaphore2);
    5c90:	40c8                	lw	a0,4(s1)
    5c92:	00000097          	auipc	ra,0x0
    5c96:	afa080e7          	jalr	-1286(ra) # 578c <bsem_free>
    sem->value = 0;
    5c9a:	0004a423          	sw	zero,8(s1)
}
    5c9e:	60e2                	ld	ra,24(sp)
    5ca0:	6442                	ld	s0,16(sp)
    5ca2:	64a2                	ld	s1,8(sp)
    5ca4:	6105                	addi	sp,sp,32
    5ca6:	8082                	ret

0000000000005ca8 <csem_down>:

void csem_down(struct counting_semaphore *sem){
    5ca8:	1101                	addi	sp,sp,-32
    5caa:	ec06                	sd	ra,24(sp)
    5cac:	e822                	sd	s0,16(sp)
    5cae:	e426                	sd	s1,8(sp)
    5cb0:	1000                	addi	s0,sp,32
    5cb2:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore2);
    5cb4:	4148                	lw	a0,4(a0)
    5cb6:	00000097          	auipc	ra,0x0
    5cba:	ade080e7          	jalr	-1314(ra) # 5794 <bsem_down>
    bsem_down(sem->binary_semaphore1);
    5cbe:	4088                	lw	a0,0(s1)
    5cc0:	00000097          	auipc	ra,0x0
    5cc4:	ad4080e7          	jalr	-1324(ra) # 5794 <bsem_down>
    sem->value--;
    5cc8:	449c                	lw	a5,8(s1)
    5cca:	37fd                	addiw	a5,a5,-1
    5ccc:	0007871b          	sext.w	a4,a5
    5cd0:	c49c                	sw	a5,8(s1)
    if(sem->value > 0)
    5cd2:	00e04c63          	bgtz	a4,5cea <csem_down+0x42>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
    5cd6:	4088                	lw	a0,0(s1)
    5cd8:	00000097          	auipc	ra,0x0
    5cdc:	ac4080e7          	jalr	-1340(ra) # 579c <bsem_up>
}
    5ce0:	60e2                	ld	ra,24(sp)
    5ce2:	6442                	ld	s0,16(sp)
    5ce4:	64a2                	ld	s1,8(sp)
    5ce6:	6105                	addi	sp,sp,32
    5ce8:	8082                	ret
        bsem_up(sem->binary_semaphore2);
    5cea:	40c8                	lw	a0,4(s1)
    5cec:	00000097          	auipc	ra,0x0
    5cf0:	ab0080e7          	jalr	-1360(ra) # 579c <bsem_up>
    5cf4:	b7cd                	j	5cd6 <csem_down+0x2e>

0000000000005cf6 <csem_up>:

void csem_up(struct counting_semaphore *sem){
    5cf6:	1101                	addi	sp,sp,-32
    5cf8:	ec06                	sd	ra,24(sp)
    5cfa:	e822                	sd	s0,16(sp)
    5cfc:	e426                	sd	s1,8(sp)
    5cfe:	1000                	addi	s0,sp,32
    5d00:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore1);
    5d02:	4108                	lw	a0,0(a0)
    5d04:	00000097          	auipc	ra,0x0
    5d08:	a90080e7          	jalr	-1392(ra) # 5794 <bsem_down>
    sem->value++;
    5d0c:	449c                	lw	a5,8(s1)
    5d0e:	2785                	addiw	a5,a5,1
    5d10:	0007871b          	sext.w	a4,a5
    5d14:	c49c                	sw	a5,8(s1)
    if(sem->value == 1)
    5d16:	4785                	li	a5,1
    5d18:	00f70c63          	beq	a4,a5,5d30 <csem_up+0x3a>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
    5d1c:	4088                	lw	a0,0(s1)
    5d1e:	00000097          	auipc	ra,0x0
    5d22:	a7e080e7          	jalr	-1410(ra) # 579c <bsem_up>
    5d26:	60e2                	ld	ra,24(sp)
    5d28:	6442                	ld	s0,16(sp)
    5d2a:	64a2                	ld	s1,8(sp)
    5d2c:	6105                	addi	sp,sp,32
    5d2e:	8082                	ret
        bsem_up(sem->binary_semaphore2);
    5d30:	40c8                	lw	a0,4(s1)
    5d32:	00000097          	auipc	ra,0x0
    5d36:	a6a080e7          	jalr	-1430(ra) # 579c <bsem_up>
    5d3a:	b7cd                	j	5d1c <csem_up+0x26>
