
user/_usertests2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test_handler>:
char buf[BUFSZ];


int wait_sig = 0;

void test_handler(int signum){
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
    wait_sig = 1;
       8:	4785                	li	a5,1
       a:	00008717          	auipc	a4,0x8
       e:	7af72323          	sw	a5,1958(a4) # 87b0 <wait_sig>
    printf("Received sigtest\n");
      12:	00006517          	auipc	a0,0x6
      16:	2b650513          	addi	a0,a0,694 # 62c8 <csem_up+0x294>
      1a:	00006097          	auipc	ra,0x6
      1e:	da2080e7          	jalr	-606(ra) # 5dbc <printf>
}
      22:	60a2                	ld	ra,8(sp)
      24:	6402                	ld	s0,0(sp)
      26:	0141                	addi	sp,sp,16
      28:	8082                	ret

000000000000002a <test_thread>:

void test_thread(){
      2a:	1141                	addi	sp,sp,-16
      2c:	e406                	sd	ra,8(sp)
      2e:	e022                	sd	s0,0(sp)
      30:	0800                	addi	s0,sp,16
    printf("Thread is now running\n");
      32:	00006517          	auipc	a0,0x6
      36:	2ae50513          	addi	a0,a0,686 # 62e0 <csem_up+0x2ac>
      3a:	00006097          	auipc	ra,0x6
      3e:	d82080e7          	jalr	-638(ra) # 5dbc <printf>
    kthread_exit(0);
      42:	4501                	li	a0,0
      44:	00006097          	auipc	ra,0x6
      48:	a6e080e7          	jalr	-1426(ra) # 5ab2 <kthread_exit>
}
      4c:	60a2                	ld	ra,8(sp)
      4e:	6402                	ld	s0,0(sp)
      50:	0141                	addi	sp,sp,16
      52:	8082                	ret

0000000000000054 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      54:	0000a797          	auipc	a5,0xa
      58:	87478793          	addi	a5,a5,-1932 # 98c8 <uninit>
      5c:	0000c697          	auipc	a3,0xc
      60:	f7c68693          	addi	a3,a3,-132 # bfd8 <buf>
    if(uninit[i] != '\0'){
      64:	0007c703          	lbu	a4,0(a5)
      68:	e709                	bnez	a4,72 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6a:	0785                	addi	a5,a5,1
      6c:	fed79ce3          	bne	a5,a3,64 <bsstest+0x10>
      70:	8082                	ret
{
      72:	1141                	addi	sp,sp,-16
      74:	e406                	sd	ra,8(sp)
      76:	e022                	sd	s0,0(sp)
      78:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7a:	85aa                	mv	a1,a0
      7c:	00006517          	auipc	a0,0x6
      80:	27c50513          	addi	a0,a0,636 # 62f8 <csem_up+0x2c4>
      84:	00006097          	auipc	ra,0x6
      88:	d38080e7          	jalr	-712(ra) # 5dbc <printf>
      exit(1);
      8c:	4505                	li	a0,1
      8e:	00006097          	auipc	ra,0x6
      92:	95c080e7          	jalr	-1700(ra) # 59ea <exit>

0000000000000096 <signal_test>:
void signal_test(char *s){
      96:	715d                	addi	sp,sp,-80
      98:	e486                	sd	ra,72(sp)
      9a:	e0a2                	sd	s0,64(sp)
      9c:	fc26                	sd	s1,56(sp)
      9e:	0880                	addi	s0,sp,80
    struct sigaction act = {test_handler, (uint)(1 << 29)};
      a0:	00000797          	auipc	a5,0x0
      a4:	f6078793          	addi	a5,a5,-160 # 0 <test_handler>
      a8:	fcf43423          	sd	a5,-56(s0)
      ac:	200007b7          	lui	a5,0x20000
      b0:	fcf42823          	sw	a5,-48(s0)
    sigprocmask(0);
      b4:	4501                	li	a0,0
      b6:	00006097          	auipc	ra,0x6
      ba:	9d4080e7          	jalr	-1580(ra) # 5a8a <sigprocmask>
    sigaction(testsig, &act, &old);
      be:	fb840613          	addi	a2,s0,-72
      c2:	fc840593          	addi	a1,s0,-56
      c6:	453d                	li	a0,15
      c8:	00006097          	auipc	ra,0x6
      cc:	9ca080e7          	jalr	-1590(ra) # 5a92 <sigaction>
    if((pid = fork()) == 0){
      d0:	00006097          	auipc	ra,0x6
      d4:	912080e7          	jalr	-1774(ra) # 59e2 <fork>
      d8:	fca42e23          	sw	a0,-36(s0)
      dc:	c90d                	beqz	a0,10e <signal_test+0x78>
    kill(pid, testsig);
      de:	45bd                	li	a1,15
      e0:	00006097          	auipc	ra,0x6
      e4:	93a080e7          	jalr	-1734(ra) # 5a1a <kill>
    wait(&pid);
      e8:	fdc40513          	addi	a0,s0,-36
      ec:	00006097          	auipc	ra,0x6
      f0:	906080e7          	jalr	-1786(ra) # 59f2 <wait>
    printf("Finished testing signals\n");
      f4:	00006517          	auipc	a0,0x6
      f8:	21c50513          	addi	a0,a0,540 # 6310 <csem_up+0x2dc>
      fc:	00006097          	auipc	ra,0x6
     100:	cc0080e7          	jalr	-832(ra) # 5dbc <printf>
}
     104:	60a6                	ld	ra,72(sp)
     106:	6406                	ld	s0,64(sp)
     108:	74e2                	ld	s1,56(sp)
     10a:	6161                	addi	sp,sp,80
     10c:	8082                	ret
        while(!wait_sig)
     10e:	00008797          	auipc	a5,0x8
     112:	6a27a783          	lw	a5,1698(a5) # 87b0 <wait_sig>
     116:	ef81                	bnez	a5,12e <signal_test+0x98>
     118:	00008497          	auipc	s1,0x8
     11c:	69848493          	addi	s1,s1,1688 # 87b0 <wait_sig>
            sleep(1);
     120:	4505                	li	a0,1
     122:	00006097          	auipc	ra,0x6
     126:	958080e7          	jalr	-1704(ra) # 5a7a <sleep>
        while(!wait_sig)
     12a:	409c                	lw	a5,0(s1)
     12c:	dbf5                	beqz	a5,120 <signal_test+0x8a>
        exit(0);
     12e:	4501                	li	a0,0
     130:	00006097          	auipc	ra,0x6
     134:	8ba080e7          	jalr	-1862(ra) # 59ea <exit>

0000000000000138 <exitwait>:
{
     138:	7139                	addi	sp,sp,-64
     13a:	fc06                	sd	ra,56(sp)
     13c:	f822                	sd	s0,48(sp)
     13e:	f426                	sd	s1,40(sp)
     140:	f04a                	sd	s2,32(sp)
     142:	ec4e                	sd	s3,24(sp)
     144:	e852                	sd	s4,16(sp)
     146:	0080                	addi	s0,sp,64
     148:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
     14a:	4901                	li	s2,0
     14c:	06400993          	li	s3,100
    pid = fork();
     150:	00006097          	auipc	ra,0x6
     154:	892080e7          	jalr	-1902(ra) # 59e2 <fork>
     158:	84aa                	mv	s1,a0
    if(pid < 0){
     15a:	02054a63          	bltz	a0,18e <exitwait+0x56>
    if(pid){
     15e:	c151                	beqz	a0,1e2 <exitwait+0xaa>
      if(wait(&xstate) != pid){
     160:	fcc40513          	addi	a0,s0,-52
     164:	00006097          	auipc	ra,0x6
     168:	88e080e7          	jalr	-1906(ra) # 59f2 <wait>
     16c:	02951f63          	bne	a0,s1,1aa <exitwait+0x72>
      if(i != xstate) {
     170:	fcc42783          	lw	a5,-52(s0)
     174:	05279963          	bne	a5,s2,1c6 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
     178:	2905                	addiw	s2,s2,1
     17a:	fd391be3          	bne	s2,s3,150 <exitwait+0x18>
}
     17e:	70e2                	ld	ra,56(sp)
     180:	7442                	ld	s0,48(sp)
     182:	74a2                	ld	s1,40(sp)
     184:	7902                	ld	s2,32(sp)
     186:	69e2                	ld	s3,24(sp)
     188:	6a42                	ld	s4,16(sp)
     18a:	6121                	addi	sp,sp,64
     18c:	8082                	ret
      printf("%s: fork failed\n", s);
     18e:	85d2                	mv	a1,s4
     190:	00006517          	auipc	a0,0x6
     194:	1a050513          	addi	a0,a0,416 # 6330 <csem_up+0x2fc>
     198:	00006097          	auipc	ra,0x6
     19c:	c24080e7          	jalr	-988(ra) # 5dbc <printf>
      exit(1);
     1a0:	4505                	li	a0,1
     1a2:	00006097          	auipc	ra,0x6
     1a6:	848080e7          	jalr	-1976(ra) # 59ea <exit>
        printf("%s: wait wrong pid\n", s);
     1aa:	85d2                	mv	a1,s4
     1ac:	00006517          	auipc	a0,0x6
     1b0:	19c50513          	addi	a0,a0,412 # 6348 <csem_up+0x314>
     1b4:	00006097          	auipc	ra,0x6
     1b8:	c08080e7          	jalr	-1016(ra) # 5dbc <printf>
        exit(1);
     1bc:	4505                	li	a0,1
     1be:	00006097          	auipc	ra,0x6
     1c2:	82c080e7          	jalr	-2004(ra) # 59ea <exit>
        printf("%s: wait wrong exit status\n", s);
     1c6:	85d2                	mv	a1,s4
     1c8:	00006517          	auipc	a0,0x6
     1cc:	19850513          	addi	a0,a0,408 # 6360 <csem_up+0x32c>
     1d0:	00006097          	auipc	ra,0x6
     1d4:	bec080e7          	jalr	-1044(ra) # 5dbc <printf>
        exit(1);
     1d8:	4505                	li	a0,1
     1da:	00006097          	auipc	ra,0x6
     1de:	810080e7          	jalr	-2032(ra) # 59ea <exit>
      exit(i);
     1e2:	854a                	mv	a0,s2
     1e4:	00006097          	auipc	ra,0x6
     1e8:	806080e7          	jalr	-2042(ra) # 59ea <exit>

00000000000001ec <twochildren>:
{
     1ec:	1101                	addi	sp,sp,-32
     1ee:	ec06                	sd	ra,24(sp)
     1f0:	e822                	sd	s0,16(sp)
     1f2:	e426                	sd	s1,8(sp)
     1f4:	e04a                	sd	s2,0(sp)
     1f6:	1000                	addi	s0,sp,32
     1f8:	892a                	mv	s2,a0
     1fa:	3e800493          	li	s1,1000
    int pid1 = fork();
     1fe:	00005097          	auipc	ra,0x5
     202:	7e4080e7          	jalr	2020(ra) # 59e2 <fork>
    if(pid1 < 0){
     206:	02054c63          	bltz	a0,23e <twochildren+0x52>
    if(pid1 == 0){
     20a:	c921                	beqz	a0,25a <twochildren+0x6e>
      int pid2 = fork();
     20c:	00005097          	auipc	ra,0x5
     210:	7d6080e7          	jalr	2006(ra) # 59e2 <fork>
      if(pid2 < 0){
     214:	04054763          	bltz	a0,262 <twochildren+0x76>
      if(pid2 == 0){
     218:	c13d                	beqz	a0,27e <twochildren+0x92>
        wait(0);
     21a:	4501                	li	a0,0
     21c:	00005097          	auipc	ra,0x5
     220:	7d6080e7          	jalr	2006(ra) # 59f2 <wait>
        wait(0);
     224:	4501                	li	a0,0
     226:	00005097          	auipc	ra,0x5
     22a:	7cc080e7          	jalr	1996(ra) # 59f2 <wait>
  for(int i = 0; i < 1000; i++){
     22e:	34fd                	addiw	s1,s1,-1
     230:	f4f9                	bnez	s1,1fe <twochildren+0x12>
}
     232:	60e2                	ld	ra,24(sp)
     234:	6442                	ld	s0,16(sp)
     236:	64a2                	ld	s1,8(sp)
     238:	6902                	ld	s2,0(sp)
     23a:	6105                	addi	sp,sp,32
     23c:	8082                	ret
      printf("%s: fork failed\n", s);
     23e:	85ca                	mv	a1,s2
     240:	00006517          	auipc	a0,0x6
     244:	0f050513          	addi	a0,a0,240 # 6330 <csem_up+0x2fc>
     248:	00006097          	auipc	ra,0x6
     24c:	b74080e7          	jalr	-1164(ra) # 5dbc <printf>
      exit(1);
     250:	4505                	li	a0,1
     252:	00005097          	auipc	ra,0x5
     256:	798080e7          	jalr	1944(ra) # 59ea <exit>
      exit(0);
     25a:	00005097          	auipc	ra,0x5
     25e:	790080e7          	jalr	1936(ra) # 59ea <exit>
        printf("%s: fork failed\n", s);
     262:	85ca                	mv	a1,s2
     264:	00006517          	auipc	a0,0x6
     268:	0cc50513          	addi	a0,a0,204 # 6330 <csem_up+0x2fc>
     26c:	00006097          	auipc	ra,0x6
     270:	b50080e7          	jalr	-1200(ra) # 5dbc <printf>
        exit(1);
     274:	4505                	li	a0,1
     276:	00005097          	auipc	ra,0x5
     27a:	774080e7          	jalr	1908(ra) # 59ea <exit>
        exit(0);
     27e:	00005097          	auipc	ra,0x5
     282:	76c080e7          	jalr	1900(ra) # 59ea <exit>

0000000000000286 <forkfork>:
{
     286:	7179                	addi	sp,sp,-48
     288:	f406                	sd	ra,40(sp)
     28a:	f022                	sd	s0,32(sp)
     28c:	ec26                	sd	s1,24(sp)
     28e:	1800                	addi	s0,sp,48
     290:	84aa                	mv	s1,a0
    int pid = fork();
     292:	00005097          	auipc	ra,0x5
     296:	750080e7          	jalr	1872(ra) # 59e2 <fork>
    if(pid < 0){
     29a:	04054163          	bltz	a0,2dc <forkfork+0x56>
    if(pid == 0){
     29e:	cd29                	beqz	a0,2f8 <forkfork+0x72>
    int pid = fork();
     2a0:	00005097          	auipc	ra,0x5
     2a4:	742080e7          	jalr	1858(ra) # 59e2 <fork>
    if(pid < 0){
     2a8:	02054a63          	bltz	a0,2dc <forkfork+0x56>
    if(pid == 0){
     2ac:	c531                	beqz	a0,2f8 <forkfork+0x72>
    wait(&xstatus);
     2ae:	fdc40513          	addi	a0,s0,-36
     2b2:	00005097          	auipc	ra,0x5
     2b6:	740080e7          	jalr	1856(ra) # 59f2 <wait>
    if(xstatus != 0) {
     2ba:	fdc42783          	lw	a5,-36(s0)
     2be:	ebbd                	bnez	a5,334 <forkfork+0xae>
    wait(&xstatus);
     2c0:	fdc40513          	addi	a0,s0,-36
     2c4:	00005097          	auipc	ra,0x5
     2c8:	72e080e7          	jalr	1838(ra) # 59f2 <wait>
    if(xstatus != 0) {
     2cc:	fdc42783          	lw	a5,-36(s0)
     2d0:	e3b5                	bnez	a5,334 <forkfork+0xae>
}
     2d2:	70a2                	ld	ra,40(sp)
     2d4:	7402                	ld	s0,32(sp)
     2d6:	64e2                	ld	s1,24(sp)
     2d8:	6145                	addi	sp,sp,48
     2da:	8082                	ret
      printf("%s: fork failed", s);
     2dc:	85a6                	mv	a1,s1
     2de:	00006517          	auipc	a0,0x6
     2e2:	0a250513          	addi	a0,a0,162 # 6380 <csem_up+0x34c>
     2e6:	00006097          	auipc	ra,0x6
     2ea:	ad6080e7          	jalr	-1322(ra) # 5dbc <printf>
      exit(1);
     2ee:	4505                	li	a0,1
     2f0:	00005097          	auipc	ra,0x5
     2f4:	6fa080e7          	jalr	1786(ra) # 59ea <exit>
{
     2f8:	0c800493          	li	s1,200
        int pid1 = fork();
     2fc:	00005097          	auipc	ra,0x5
     300:	6e6080e7          	jalr	1766(ra) # 59e2 <fork>
        if(pid1 < 0){
     304:	00054f63          	bltz	a0,322 <forkfork+0x9c>
        if(pid1 == 0){
     308:	c115                	beqz	a0,32c <forkfork+0xa6>
        wait(0);
     30a:	4501                	li	a0,0
     30c:	00005097          	auipc	ra,0x5
     310:	6e6080e7          	jalr	1766(ra) # 59f2 <wait>
      for(int j = 0; j < 200; j++){
     314:	34fd                	addiw	s1,s1,-1
     316:	f0fd                	bnez	s1,2fc <forkfork+0x76>
      exit(0);
     318:	4501                	li	a0,0
     31a:	00005097          	auipc	ra,0x5
     31e:	6d0080e7          	jalr	1744(ra) # 59ea <exit>
          exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	6c6080e7          	jalr	1734(ra) # 59ea <exit>
          exit(0);
     32c:	00005097          	auipc	ra,0x5
     330:	6be080e7          	jalr	1726(ra) # 59ea <exit>
      printf("%s: fork in child failed", s);
     334:	85a6                	mv	a1,s1
     336:	00006517          	auipc	a0,0x6
     33a:	05a50513          	addi	a0,a0,90 # 6390 <csem_up+0x35c>
     33e:	00006097          	auipc	ra,0x6
     342:	a7e080e7          	jalr	-1410(ra) # 5dbc <printf>
      exit(1);
     346:	4505                	li	a0,1
     348:	00005097          	auipc	ra,0x5
     34c:	6a2080e7          	jalr	1698(ra) # 59ea <exit>

0000000000000350 <forktest>:
{
     350:	7179                	addi	sp,sp,-48
     352:	f406                	sd	ra,40(sp)
     354:	f022                	sd	s0,32(sp)
     356:	ec26                	sd	s1,24(sp)
     358:	e84a                	sd	s2,16(sp)
     35a:	e44e                	sd	s3,8(sp)
     35c:	1800                	addi	s0,sp,48
     35e:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
     360:	4481                	li	s1,0
     362:	3e800913          	li	s2,1000
    pid = fork();
     366:	00005097          	auipc	ra,0x5
     36a:	67c080e7          	jalr	1660(ra) # 59e2 <fork>
    if(pid < 0)
     36e:	02054863          	bltz	a0,39e <forktest+0x4e>
    if(pid == 0)
     372:	c115                	beqz	a0,396 <forktest+0x46>
  for(n=0; n<N; n++){
     374:	2485                	addiw	s1,s1,1
     376:	ff2498e3          	bne	s1,s2,366 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
     37a:	85ce                	mv	a1,s3
     37c:	00006517          	auipc	a0,0x6
     380:	04c50513          	addi	a0,a0,76 # 63c8 <csem_up+0x394>
     384:	00006097          	auipc	ra,0x6
     388:	a38080e7          	jalr	-1480(ra) # 5dbc <printf>
    exit(1);
     38c:	4505                	li	a0,1
     38e:	00005097          	auipc	ra,0x5
     392:	65c080e7          	jalr	1628(ra) # 59ea <exit>
      exit(0);
     396:	00005097          	auipc	ra,0x5
     39a:	654080e7          	jalr	1620(ra) # 59ea <exit>
  if (n == 0) {
     39e:	cc9d                	beqz	s1,3dc <forktest+0x8c>
  if(n == N){
     3a0:	3e800793          	li	a5,1000
     3a4:	fcf48be3          	beq	s1,a5,37a <forktest+0x2a>
  for(; n > 0; n--){
     3a8:	00905b63          	blez	s1,3be <forktest+0x6e>
    if(wait(0) < 0){
     3ac:	4501                	li	a0,0
     3ae:	00005097          	auipc	ra,0x5
     3b2:	644080e7          	jalr	1604(ra) # 59f2 <wait>
     3b6:	04054163          	bltz	a0,3f8 <forktest+0xa8>
  for(; n > 0; n--){
     3ba:	34fd                	addiw	s1,s1,-1
     3bc:	f8e5                	bnez	s1,3ac <forktest+0x5c>
  if(wait(0) != -1){
     3be:	4501                	li	a0,0
     3c0:	00005097          	auipc	ra,0x5
     3c4:	632080e7          	jalr	1586(ra) # 59f2 <wait>
     3c8:	57fd                	li	a5,-1
     3ca:	04f51563          	bne	a0,a5,414 <forktest+0xc4>
}
     3ce:	70a2                	ld	ra,40(sp)
     3d0:	7402                	ld	s0,32(sp)
     3d2:	64e2                	ld	s1,24(sp)
     3d4:	6942                	ld	s2,16(sp)
     3d6:	69a2                	ld	s3,8(sp)
     3d8:	6145                	addi	sp,sp,48
     3da:	8082                	ret
    printf("%s: no fork at all!\n", s);
     3dc:	85ce                	mv	a1,s3
     3de:	00006517          	auipc	a0,0x6
     3e2:	fd250513          	addi	a0,a0,-46 # 63b0 <csem_up+0x37c>
     3e6:	00006097          	auipc	ra,0x6
     3ea:	9d6080e7          	jalr	-1578(ra) # 5dbc <printf>
    exit(1);
     3ee:	4505                	li	a0,1
     3f0:	00005097          	auipc	ra,0x5
     3f4:	5fa080e7          	jalr	1530(ra) # 59ea <exit>
      printf("%s: wait stopped early\n", s);
     3f8:	85ce                	mv	a1,s3
     3fa:	00006517          	auipc	a0,0x6
     3fe:	ff650513          	addi	a0,a0,-10 # 63f0 <csem_up+0x3bc>
     402:	00006097          	auipc	ra,0x6
     406:	9ba080e7          	jalr	-1606(ra) # 5dbc <printf>
      exit(1);
     40a:	4505                	li	a0,1
     40c:	00005097          	auipc	ra,0x5
     410:	5de080e7          	jalr	1502(ra) # 59ea <exit>
    printf("%s: wait got too many\n", s);
     414:	85ce                	mv	a1,s3
     416:	00006517          	auipc	a0,0x6
     41a:	ff250513          	addi	a0,a0,-14 # 6408 <csem_up+0x3d4>
     41e:	00006097          	auipc	ra,0x6
     422:	99e080e7          	jalr	-1634(ra) # 5dbc <printf>
    exit(1);
     426:	4505                	li	a0,1
     428:	00005097          	auipc	ra,0x5
     42c:	5c2080e7          	jalr	1474(ra) # 59ea <exit>

0000000000000430 <thread_test>:
void thread_test(char *s){
     430:	7179                	addi	sp,sp,-48
     432:	f406                	sd	ra,40(sp)
     434:	f022                	sd	s0,32(sp)
     436:	ec26                	sd	s1,24(sp)
     438:	e84a                	sd	s2,16(sp)
     43a:	1800                	addi	s0,sp,48
    void* stack = malloc(MAX_STACK_SIZE);
     43c:	6505                	lui	a0,0x1
     43e:	fa050513          	addi	a0,a0,-96 # fa0 <pipe1+0x116>
     442:	00006097          	auipc	ra,0x6
     446:	a38080e7          	jalr	-1480(ra) # 5e7a <malloc>
     44a:	84aa                	mv	s1,a0
    tid = kthread_create(test_thread, stack);
     44c:	85aa                	mv	a1,a0
     44e:	00000517          	auipc	a0,0x0
     452:	bdc50513          	addi	a0,a0,-1060 # 2a <test_thread>
     456:	00005097          	auipc	ra,0x5
     45a:	64c080e7          	jalr	1612(ra) # 5aa2 <kthread_create>
    kthread_join(tid,&status);
     45e:	fdc40593          	addi	a1,s0,-36
     462:	00005097          	auipc	ra,0x5
     466:	658080e7          	jalr	1624(ra) # 5aba <kthread_join>
    tid = kthread_id();
     46a:	00005097          	auipc	ra,0x5
     46e:	640080e7          	jalr	1600(ra) # 5aaa <kthread_id>
     472:	892a                	mv	s2,a0
    free(stack);
     474:	8526                	mv	a0,s1
     476:	00006097          	auipc	ra,0x6
     47a:	97c080e7          	jalr	-1668(ra) # 5df2 <free>
    printf("Finished testing threads, main thread id: %d, %d\n", tid,status);
     47e:	fdc42603          	lw	a2,-36(s0)
     482:	85ca                	mv	a1,s2
     484:	00006517          	auipc	a0,0x6
     488:	f9c50513          	addi	a0,a0,-100 # 6420 <csem_up+0x3ec>
     48c:	00006097          	auipc	ra,0x6
     490:	930080e7          	jalr	-1744(ra) # 5dbc <printf>
}
     494:	70a2                	ld	ra,40(sp)
     496:	7402                	ld	s0,32(sp)
     498:	64e2                	ld	s1,24(sp)
     49a:	6942                	ld	s2,16(sp)
     49c:	6145                	addi	sp,sp,48
     49e:	8082                	ret

00000000000004a0 <bsem_test>:
void bsem_test(char *s){
     4a0:	7179                	addi	sp,sp,-48
     4a2:	f406                	sd	ra,40(sp)
     4a4:	f022                	sd	s0,32(sp)
     4a6:	ec26                	sd	s1,24(sp)
     4a8:	1800                	addi	s0,sp,48
    int bid = bsem_alloc();
     4aa:	00005097          	auipc	ra,0x5
     4ae:	618080e7          	jalr	1560(ra) # 5ac2 <bsem_alloc>
     4b2:	84aa                	mv	s1,a0
    bsem_down(bid);
     4b4:	00005097          	auipc	ra,0x5
     4b8:	61e080e7          	jalr	1566(ra) # 5ad2 <bsem_down>
    printf("1. Parent downing semaphore\n");
     4bc:	00006517          	auipc	a0,0x6
     4c0:	f9c50513          	addi	a0,a0,-100 # 6458 <csem_up+0x424>
     4c4:	00006097          	auipc	ra,0x6
     4c8:	8f8080e7          	jalr	-1800(ra) # 5dbc <printf>
    if((pid = fork()) == 0){
     4cc:	00005097          	auipc	ra,0x5
     4d0:	516080e7          	jalr	1302(ra) # 59e2 <fork>
     4d4:	fca42e23          	sw	a0,-36(s0)
     4d8:	c125                	beqz	a0,538 <bsem_test+0x98>
    sleep(5);
     4da:	4515                	li	a0,5
     4dc:	00005097          	auipc	ra,0x5
     4e0:	59e080e7          	jalr	1438(ra) # 5a7a <sleep>
    printf("3. Let the child wait on the semaphore...\n");
     4e4:	00006517          	auipc	a0,0x6
     4e8:	fcc50513          	addi	a0,a0,-52 # 64b0 <csem_up+0x47c>
     4ec:	00006097          	auipc	ra,0x6
     4f0:	8d0080e7          	jalr	-1840(ra) # 5dbc <printf>
    sleep(10);
     4f4:	4529                	li	a0,10
     4f6:	00005097          	auipc	ra,0x5
     4fa:	584080e7          	jalr	1412(ra) # 5a7a <sleep>
    bsem_up(bid);
     4fe:	8526                	mv	a0,s1
     500:	00005097          	auipc	ra,0x5
     504:	5da080e7          	jalr	1498(ra) # 5ada <bsem_up>
    bsem_free(bid);
     508:	8526                	mv	a0,s1
     50a:	00005097          	auipc	ra,0x5
     50e:	5c0080e7          	jalr	1472(ra) # 5aca <bsem_free>
    wait(&pid);
     512:	fdc40513          	addi	a0,s0,-36
     516:	00005097          	auipc	ra,0x5
     51a:	4dc080e7          	jalr	1244(ra) # 59f2 <wait>
    printf("Finished bsem test, make sure that the order of the prints is alright. Meaning (1...2...3...4)\n");
     51e:	00006517          	auipc	a0,0x6
     522:	fc250513          	addi	a0,a0,-62 # 64e0 <csem_up+0x4ac>
     526:	00006097          	auipc	ra,0x6
     52a:	896080e7          	jalr	-1898(ra) # 5dbc <printf>
}
     52e:	70a2                	ld	ra,40(sp)
     530:	7402                	ld	s0,32(sp)
     532:	64e2                	ld	s1,24(sp)
     534:	6145                	addi	sp,sp,48
     536:	8082                	ret
        printf("2. Child downing semaphore\n");
     538:	00006517          	auipc	a0,0x6
     53c:	f4050513          	addi	a0,a0,-192 # 6478 <csem_up+0x444>
     540:	00006097          	auipc	ra,0x6
     544:	87c080e7          	jalr	-1924(ra) # 5dbc <printf>
        bsem_down(bid);
     548:	8526                	mv	a0,s1
     54a:	00005097          	auipc	ra,0x5
     54e:	588080e7          	jalr	1416(ra) # 5ad2 <bsem_down>
        printf("4. Child woke up\n");
     552:	00006517          	auipc	a0,0x6
     556:	f4650513          	addi	a0,a0,-186 # 6498 <csem_up+0x464>
     55a:	00006097          	auipc	ra,0x6
     55e:	862080e7          	jalr	-1950(ra) # 5dbc <printf>
        exit(0);
     562:	4501                	li	a0,0
     564:	00005097          	auipc	ra,0x5
     568:	486080e7          	jalr	1158(ra) # 59ea <exit>

000000000000056c <Csem_test>:
void Csem_test(char *s){
     56c:	7179                	addi	sp,sp,-48
     56e:	f406                	sd	ra,40(sp)
     570:	f022                	sd	s0,32(sp)
     572:	1800                	addi	s0,sp,48
    retval = csem_alloc(&csem,1);
     574:	4585                	li	a1,1
     576:	fe040513          	addi	a0,s0,-32
     57a:	00006097          	auipc	ra,0x6
     57e:	9e6080e7          	jalr	-1562(ra) # 5f60 <csem_alloc>
    if(retval==-1)
     582:	57fd                	li	a5,-1
     584:	08f50763          	beq	a0,a5,612 <Csem_test+0xa6>
    csem_down(&csem);
     588:	fe040513          	addi	a0,s0,-32
     58c:	00006097          	auipc	ra,0x6
     590:	a5a080e7          	jalr	-1446(ra) # 5fe6 <csem_down>
    printf("1. Parent downing semaphore\n");
     594:	00006517          	auipc	a0,0x6
     598:	ec450513          	addi	a0,a0,-316 # 6458 <csem_up+0x424>
     59c:	00006097          	auipc	ra,0x6
     5a0:	820080e7          	jalr	-2016(ra) # 5dbc <printf>
    if((pid = fork()) == 0){
     5a4:	00005097          	auipc	ra,0x5
     5a8:	43e080e7          	jalr	1086(ra) # 59e2 <fork>
     5ac:	fca42e23          	sw	a0,-36(s0)
     5b0:	cd35                	beqz	a0,62c <Csem_test+0xc0>
    sleep(5);
     5b2:	4515                	li	a0,5
     5b4:	00005097          	auipc	ra,0x5
     5b8:	4c6080e7          	jalr	1222(ra) # 5a7a <sleep>
    printf("3. Let the child wait on the semaphore...\n");
     5bc:	00006517          	auipc	a0,0x6
     5c0:	ef450513          	addi	a0,a0,-268 # 64b0 <csem_up+0x47c>
     5c4:	00005097          	auipc	ra,0x5
     5c8:	7f8080e7          	jalr	2040(ra) # 5dbc <printf>
    sleep(10);
     5cc:	4529                	li	a0,10
     5ce:	00005097          	auipc	ra,0x5
     5d2:	4ac080e7          	jalr	1196(ra) # 5a7a <sleep>
    csem_up(&csem);
     5d6:	fe040513          	addi	a0,s0,-32
     5da:	00006097          	auipc	ra,0x6
     5de:	a5a080e7          	jalr	-1446(ra) # 6034 <csem_up>
    csem_free(&csem);
     5e2:	fe040513          	addi	a0,s0,-32
     5e6:	00006097          	auipc	ra,0x6
     5ea:	9d2080e7          	jalr	-1582(ra) # 5fb8 <csem_free>
    wait(&pid);
     5ee:	fdc40513          	addi	a0,s0,-36
     5f2:	00005097          	auipc	ra,0x5
     5f6:	400080e7          	jalr	1024(ra) # 59f2 <wait>
    printf("Finished bsem test, make sure that the order of the prints is alright. Meaning (1...2...3...4)\n");
     5fa:	00006517          	auipc	a0,0x6
     5fe:	ee650513          	addi	a0,a0,-282 # 64e0 <csem_up+0x4ac>
     602:	00005097          	auipc	ra,0x5
     606:	7ba080e7          	jalr	1978(ra) # 5dbc <printf>
}
     60a:	70a2                	ld	ra,40(sp)
     60c:	7402                	ld	s0,32(sp)
     60e:	6145                	addi	sp,sp,48
     610:	8082                	ret
		printf("failed csem alloc");
     612:	00006517          	auipc	a0,0x6
     616:	f2e50513          	addi	a0,a0,-210 # 6540 <csem_up+0x50c>
     61a:	00005097          	auipc	ra,0x5
     61e:	7a2080e7          	jalr	1954(ra) # 5dbc <printf>
		exit(-1);
     622:	557d                	li	a0,-1
     624:	00005097          	auipc	ra,0x5
     628:	3c6080e7          	jalr	966(ra) # 59ea <exit>
        printf("2. Child downing semaphore\n");
     62c:	00006517          	auipc	a0,0x6
     630:	e4c50513          	addi	a0,a0,-436 # 6478 <csem_up+0x444>
     634:	00005097          	auipc	ra,0x5
     638:	788080e7          	jalr	1928(ra) # 5dbc <printf>
        csem_down(&csem);
     63c:	fe040513          	addi	a0,s0,-32
     640:	00006097          	auipc	ra,0x6
     644:	9a6080e7          	jalr	-1626(ra) # 5fe6 <csem_down>
        printf("4. Child woke up\n");
     648:	00006517          	auipc	a0,0x6
     64c:	e5050513          	addi	a0,a0,-432 # 6498 <csem_up+0x464>
     650:	00005097          	auipc	ra,0x5
     654:	76c080e7          	jalr	1900(ra) # 5dbc <printf>
        exit(0);
     658:	4501                	li	a0,0
     65a:	00005097          	auipc	ra,0x5
     65e:	390080e7          	jalr	912(ra) # 59ea <exit>

0000000000000662 <copyinstr1>:
{
     662:	1141                	addi	sp,sp,-16
     664:	e406                	sd	ra,8(sp)
     666:	e022                	sd	s0,0(sp)
     668:	0800                	addi	s0,sp,16
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
     66a:	20100593          	li	a1,513
     66e:	4505                	li	a0,1
     670:	057e                	slli	a0,a0,0x1f
     672:	00005097          	auipc	ra,0x5
     676:	3b8080e7          	jalr	952(ra) # 5a2a <open>
    if(fd >= 0){
     67a:	02055063          	bgez	a0,69a <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
     67e:	20100593          	li	a1,513
     682:	557d                	li	a0,-1
     684:	00005097          	auipc	ra,0x5
     688:	3a6080e7          	jalr	934(ra) # 5a2a <open>
    uint64 addr = addrs[ai];
     68c:	55fd                	li	a1,-1
    if(fd >= 0){
     68e:	00055863          	bgez	a0,69e <copyinstr1+0x3c>
}
     692:	60a2                	ld	ra,8(sp)
     694:	6402                	ld	s0,0(sp)
     696:	0141                	addi	sp,sp,16
     698:	8082                	ret
    uint64 addr = addrs[ai];
     69a:	4585                	li	a1,1
     69c:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
     69e:	862a                	mv	a2,a0
     6a0:	00006517          	auipc	a0,0x6
     6a4:	eb850513          	addi	a0,a0,-328 # 6558 <csem_up+0x524>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	714080e7          	jalr	1812(ra) # 5dbc <printf>
      exit(1);
     6b0:	4505                	li	a0,1
     6b2:	00005097          	auipc	ra,0x5
     6b6:	338080e7          	jalr	824(ra) # 59ea <exit>

00000000000006ba <opentest>:
{
     6ba:	1101                	addi	sp,sp,-32
     6bc:	ec06                	sd	ra,24(sp)
     6be:	e822                	sd	s0,16(sp)
     6c0:	e426                	sd	s1,8(sp)
     6c2:	1000                	addi	s0,sp,32
     6c4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
     6c6:	4581                	li	a1,0
     6c8:	00006517          	auipc	a0,0x6
     6cc:	eb050513          	addi	a0,a0,-336 # 6578 <csem_up+0x544>
     6d0:	00005097          	auipc	ra,0x5
     6d4:	35a080e7          	jalr	858(ra) # 5a2a <open>
  if(fd < 0){
     6d8:	02054663          	bltz	a0,704 <opentest+0x4a>
  close(fd);
     6dc:	00005097          	auipc	ra,0x5
     6e0:	336080e7          	jalr	822(ra) # 5a12 <close>
  fd = open("doesnotexist", 0);
     6e4:	4581                	li	a1,0
     6e6:	00006517          	auipc	a0,0x6
     6ea:	eb250513          	addi	a0,a0,-334 # 6598 <csem_up+0x564>
     6ee:	00005097          	auipc	ra,0x5
     6f2:	33c080e7          	jalr	828(ra) # 5a2a <open>
  if(fd >= 0){
     6f6:	02055563          	bgez	a0,720 <opentest+0x66>
}
     6fa:	60e2                	ld	ra,24(sp)
     6fc:	6442                	ld	s0,16(sp)
     6fe:	64a2                	ld	s1,8(sp)
     700:	6105                	addi	sp,sp,32
     702:	8082                	ret
    printf("%s: open echo failed!\n", s);
     704:	85a6                	mv	a1,s1
     706:	00006517          	auipc	a0,0x6
     70a:	e7a50513          	addi	a0,a0,-390 # 6580 <csem_up+0x54c>
     70e:	00005097          	auipc	ra,0x5
     712:	6ae080e7          	jalr	1710(ra) # 5dbc <printf>
    exit(1);
     716:	4505                	li	a0,1
     718:	00005097          	auipc	ra,0x5
     71c:	2d2080e7          	jalr	722(ra) # 59ea <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     720:	85a6                	mv	a1,s1
     722:	00006517          	auipc	a0,0x6
     726:	e8650513          	addi	a0,a0,-378 # 65a8 <csem_up+0x574>
     72a:	00005097          	auipc	ra,0x5
     72e:	692080e7          	jalr	1682(ra) # 5dbc <printf>
    exit(1);
     732:	4505                	li	a0,1
     734:	00005097          	auipc	ra,0x5
     738:	2b6080e7          	jalr	694(ra) # 59ea <exit>

000000000000073c <truncate2>:
{
     73c:	7179                	addi	sp,sp,-48
     73e:	f406                	sd	ra,40(sp)
     740:	f022                	sd	s0,32(sp)
     742:	ec26                	sd	s1,24(sp)
     744:	e84a                	sd	s2,16(sp)
     746:	e44e                	sd	s3,8(sp)
     748:	1800                	addi	s0,sp,48
     74a:	89aa                	mv	s3,a0
  unlink("truncfile");
     74c:	00006517          	auipc	a0,0x6
     750:	e8450513          	addi	a0,a0,-380 # 65d0 <csem_up+0x59c>
     754:	00005097          	auipc	ra,0x5
     758:	2e6080e7          	jalr	742(ra) # 5a3a <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     75c:	60100593          	li	a1,1537
     760:	00006517          	auipc	a0,0x6
     764:	e7050513          	addi	a0,a0,-400 # 65d0 <csem_up+0x59c>
     768:	00005097          	auipc	ra,0x5
     76c:	2c2080e7          	jalr	706(ra) # 5a2a <open>
     770:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     772:	4611                	li	a2,4
     774:	00006597          	auipc	a1,0x6
     778:	e6c58593          	addi	a1,a1,-404 # 65e0 <csem_up+0x5ac>
     77c:	00005097          	auipc	ra,0x5
     780:	28e080e7          	jalr	654(ra) # 5a0a <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     784:	40100593          	li	a1,1025
     788:	00006517          	auipc	a0,0x6
     78c:	e4850513          	addi	a0,a0,-440 # 65d0 <csem_up+0x59c>
     790:	00005097          	auipc	ra,0x5
     794:	29a080e7          	jalr	666(ra) # 5a2a <open>
     798:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     79a:	4605                	li	a2,1
     79c:	00006597          	auipc	a1,0x6
     7a0:	e4c58593          	addi	a1,a1,-436 # 65e8 <csem_up+0x5b4>
     7a4:	8526                	mv	a0,s1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	264080e7          	jalr	612(ra) # 5a0a <write>
  if(n != -1){
     7ae:	57fd                	li	a5,-1
     7b0:	02f51b63          	bne	a0,a5,7e6 <truncate2+0xaa>
  unlink("truncfile");
     7b4:	00006517          	auipc	a0,0x6
     7b8:	e1c50513          	addi	a0,a0,-484 # 65d0 <csem_up+0x59c>
     7bc:	00005097          	auipc	ra,0x5
     7c0:	27e080e7          	jalr	638(ra) # 5a3a <unlink>
  close(fd1);
     7c4:	8526                	mv	a0,s1
     7c6:	00005097          	auipc	ra,0x5
     7ca:	24c080e7          	jalr	588(ra) # 5a12 <close>
  close(fd2);
     7ce:	854a                	mv	a0,s2
     7d0:	00005097          	auipc	ra,0x5
     7d4:	242080e7          	jalr	578(ra) # 5a12 <close>
}
     7d8:	70a2                	ld	ra,40(sp)
     7da:	7402                	ld	s0,32(sp)
     7dc:	64e2                	ld	s1,24(sp)
     7de:	6942                	ld	s2,16(sp)
     7e0:	69a2                	ld	s3,8(sp)
     7e2:	6145                	addi	sp,sp,48
     7e4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     7e6:	862a                	mv	a2,a0
     7e8:	85ce                	mv	a1,s3
     7ea:	00006517          	auipc	a0,0x6
     7ee:	e0650513          	addi	a0,a0,-506 # 65f0 <csem_up+0x5bc>
     7f2:	00005097          	auipc	ra,0x5
     7f6:	5ca080e7          	jalr	1482(ra) # 5dbc <printf>
    exit(1);
     7fa:	4505                	li	a0,1
     7fc:	00005097          	auipc	ra,0x5
     800:	1ee080e7          	jalr	494(ra) # 59ea <exit>

0000000000000804 <forkforkfork>:
{
     804:	1101                	addi	sp,sp,-32
     806:	ec06                	sd	ra,24(sp)
     808:	e822                	sd	s0,16(sp)
     80a:	e426                	sd	s1,8(sp)
     80c:	1000                	addi	s0,sp,32
     80e:	84aa                	mv	s1,a0
  unlink("stopforking");
     810:	00006517          	auipc	a0,0x6
     814:	e0850513          	addi	a0,a0,-504 # 6618 <csem_up+0x5e4>
     818:	00005097          	auipc	ra,0x5
     81c:	222080e7          	jalr	546(ra) # 5a3a <unlink>
  int pid = fork();
     820:	00005097          	auipc	ra,0x5
     824:	1c2080e7          	jalr	450(ra) # 59e2 <fork>
  if(pid < 0){
     828:	04054563          	bltz	a0,872 <forkforkfork+0x6e>
  if(pid == 0){
     82c:	c12d                	beqz	a0,88e <forkforkfork+0x8a>
  sleep(20); // two seconds
     82e:	4551                	li	a0,20
     830:	00005097          	auipc	ra,0x5
     834:	24a080e7          	jalr	586(ra) # 5a7a <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
     838:	20200593          	li	a1,514
     83c:	00006517          	auipc	a0,0x6
     840:	ddc50513          	addi	a0,a0,-548 # 6618 <csem_up+0x5e4>
     844:	00005097          	auipc	ra,0x5
     848:	1e6080e7          	jalr	486(ra) # 5a2a <open>
     84c:	00005097          	auipc	ra,0x5
     850:	1c6080e7          	jalr	454(ra) # 5a12 <close>
  wait(0);
     854:	4501                	li	a0,0
     856:	00005097          	auipc	ra,0x5
     85a:	19c080e7          	jalr	412(ra) # 59f2 <wait>
  sleep(10); // one second
     85e:	4529                	li	a0,10
     860:	00005097          	auipc	ra,0x5
     864:	21a080e7          	jalr	538(ra) # 5a7a <sleep>
}
     868:	60e2                	ld	ra,24(sp)
     86a:	6442                	ld	s0,16(sp)
     86c:	64a2                	ld	s1,8(sp)
     86e:	6105                	addi	sp,sp,32
     870:	8082                	ret
    printf("%s: fork failed", s);
     872:	85a6                	mv	a1,s1
     874:	00006517          	auipc	a0,0x6
     878:	b0c50513          	addi	a0,a0,-1268 # 6380 <csem_up+0x34c>
     87c:	00005097          	auipc	ra,0x5
     880:	540080e7          	jalr	1344(ra) # 5dbc <printf>
    exit(1);
     884:	4505                	li	a0,1
     886:	00005097          	auipc	ra,0x5
     88a:	164080e7          	jalr	356(ra) # 59ea <exit>
      int fd = open("stopforking", 0);
     88e:	00006497          	auipc	s1,0x6
     892:	d8a48493          	addi	s1,s1,-630 # 6618 <csem_up+0x5e4>
     896:	4581                	li	a1,0
     898:	8526                	mv	a0,s1
     89a:	00005097          	auipc	ra,0x5
     89e:	190080e7          	jalr	400(ra) # 5a2a <open>
      if(fd >= 0){
     8a2:	02055463          	bgez	a0,8ca <forkforkfork+0xc6>
      if(fork() < 0){
     8a6:	00005097          	auipc	ra,0x5
     8aa:	13c080e7          	jalr	316(ra) # 59e2 <fork>
     8ae:	fe0554e3          	bgez	a0,896 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
     8b2:	20200593          	li	a1,514
     8b6:	8526                	mv	a0,s1
     8b8:	00005097          	auipc	ra,0x5
     8bc:	172080e7          	jalr	370(ra) # 5a2a <open>
     8c0:	00005097          	auipc	ra,0x5
     8c4:	152080e7          	jalr	338(ra) # 5a12 <close>
     8c8:	b7f9                	j	896 <forkforkfork+0x92>
        exit(0);
     8ca:	4501                	li	a0,0
     8cc:	00005097          	auipc	ra,0x5
     8d0:	11e080e7          	jalr	286(ra) # 59ea <exit>

00000000000008d4 <bigwrite>:
{
     8d4:	715d                	addi	sp,sp,-80
     8d6:	e486                	sd	ra,72(sp)
     8d8:	e0a2                	sd	s0,64(sp)
     8da:	fc26                	sd	s1,56(sp)
     8dc:	f84a                	sd	s2,48(sp)
     8de:	f44e                	sd	s3,40(sp)
     8e0:	f052                	sd	s4,32(sp)
     8e2:	ec56                	sd	s5,24(sp)
     8e4:	e85a                	sd	s6,16(sp)
     8e6:	e45e                	sd	s7,8(sp)
     8e8:	0880                	addi	s0,sp,80
     8ea:	8baa                	mv	s7,a0
  unlink("bigwrite");
     8ec:	00006517          	auipc	a0,0x6
     8f0:	91c50513          	addi	a0,a0,-1764 # 6208 <csem_up+0x1d4>
     8f4:	00005097          	auipc	ra,0x5
     8f8:	146080e7          	jalr	326(ra) # 5a3a <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     8fc:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     900:	00006a97          	auipc	s5,0x6
     904:	908a8a93          	addi	s5,s5,-1784 # 6208 <csem_up+0x1d4>
      int cc = write(fd, buf, sz);
     908:	0000ba17          	auipc	s4,0xb
     90c:	6d0a0a13          	addi	s4,s4,1744 # bfd8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     910:	6b0d                	lui	s6,0x3
     912:	1c9b0b13          	addi	s6,s6,457 # 31c9 <fourfiles+0xb7>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     916:	20200593          	li	a1,514
     91a:	8556                	mv	a0,s5
     91c:	00005097          	auipc	ra,0x5
     920:	10e080e7          	jalr	270(ra) # 5a2a <open>
     924:	892a                	mv	s2,a0
    if(fd < 0){
     926:	04054d63          	bltz	a0,980 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     92a:	8626                	mv	a2,s1
     92c:	85d2                	mv	a1,s4
     92e:	00005097          	auipc	ra,0x5
     932:	0dc080e7          	jalr	220(ra) # 5a0a <write>
     936:	89aa                	mv	s3,a0
      if(cc != sz){
     938:	06a49463          	bne	s1,a0,9a0 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     93c:	8626                	mv	a2,s1
     93e:	85d2                	mv	a1,s4
     940:	854a                	mv	a0,s2
     942:	00005097          	auipc	ra,0x5
     946:	0c8080e7          	jalr	200(ra) # 5a0a <write>
      if(cc != sz){
     94a:	04951963          	bne	a0,s1,99c <bigwrite+0xc8>
    close(fd);
     94e:	854a                	mv	a0,s2
     950:	00005097          	auipc	ra,0x5
     954:	0c2080e7          	jalr	194(ra) # 5a12 <close>
    unlink("bigwrite");
     958:	8556                	mv	a0,s5
     95a:	00005097          	auipc	ra,0x5
     95e:	0e0080e7          	jalr	224(ra) # 5a3a <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     962:	1d74849b          	addiw	s1,s1,471
     966:	fb6498e3          	bne	s1,s6,916 <bigwrite+0x42>
}
     96a:	60a6                	ld	ra,72(sp)
     96c:	6406                	ld	s0,64(sp)
     96e:	74e2                	ld	s1,56(sp)
     970:	7942                	ld	s2,48(sp)
     972:	79a2                	ld	s3,40(sp)
     974:	7a02                	ld	s4,32(sp)
     976:	6ae2                	ld	s5,24(sp)
     978:	6b42                	ld	s6,16(sp)
     97a:	6ba2                	ld	s7,8(sp)
     97c:	6161                	addi	sp,sp,80
     97e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     980:	85de                	mv	a1,s7
     982:	00006517          	auipc	a0,0x6
     986:	ca650513          	addi	a0,a0,-858 # 6628 <csem_up+0x5f4>
     98a:	00005097          	auipc	ra,0x5
     98e:	432080e7          	jalr	1074(ra) # 5dbc <printf>
      exit(1);
     992:	4505                	li	a0,1
     994:	00005097          	auipc	ra,0x5
     998:	056080e7          	jalr	86(ra) # 59ea <exit>
     99c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     99e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     9a0:	86ce                	mv	a3,s3
     9a2:	8626                	mv	a2,s1
     9a4:	85de                	mv	a1,s7
     9a6:	00006517          	auipc	a0,0x6
     9aa:	ca250513          	addi	a0,a0,-862 # 6648 <csem_up+0x614>
     9ae:	00005097          	auipc	ra,0x5
     9b2:	40e080e7          	jalr	1038(ra) # 5dbc <printf>
        exit(1);
     9b6:	4505                	li	a0,1
     9b8:	00005097          	auipc	ra,0x5
     9bc:	032080e7          	jalr	50(ra) # 59ea <exit>

00000000000009c0 <copyin>:
{
     9c0:	715d                	addi	sp,sp,-80
     9c2:	e486                	sd	ra,72(sp)
     9c4:	e0a2                	sd	s0,64(sp)
     9c6:	fc26                	sd	s1,56(sp)
     9c8:	f84a                	sd	s2,48(sp)
     9ca:	f44e                	sd	s3,40(sp)
     9cc:	f052                	sd	s4,32(sp)
     9ce:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     9d0:	4785                	li	a5,1
     9d2:	07fe                	slli	a5,a5,0x1f
     9d4:	fcf43023          	sd	a5,-64(s0)
     9d8:	57fd                	li	a5,-1
     9da:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     9de:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     9e2:	00006a17          	auipc	s4,0x6
     9e6:	c7ea0a13          	addi	s4,s4,-898 # 6660 <csem_up+0x62c>
    uint64 addr = addrs[ai];
     9ea:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     9ee:	20100593          	li	a1,513
     9f2:	8552                	mv	a0,s4
     9f4:	00005097          	auipc	ra,0x5
     9f8:	036080e7          	jalr	54(ra) # 5a2a <open>
     9fc:	84aa                	mv	s1,a0
    if(fd < 0){
     9fe:	08054863          	bltz	a0,a8e <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     a02:	6609                	lui	a2,0x2
     a04:	85ce                	mv	a1,s3
     a06:	00005097          	auipc	ra,0x5
     a0a:	004080e7          	jalr	4(ra) # 5a0a <write>
    if(n >= 0){
     a0e:	08055d63          	bgez	a0,aa8 <copyin+0xe8>
    close(fd);
     a12:	8526                	mv	a0,s1
     a14:	00005097          	auipc	ra,0x5
     a18:	ffe080e7          	jalr	-2(ra) # 5a12 <close>
    unlink("copyin1");
     a1c:	8552                	mv	a0,s4
     a1e:	00005097          	auipc	ra,0x5
     a22:	01c080e7          	jalr	28(ra) # 5a3a <unlink>
    n = write(1, (char*)addr, 8192);
     a26:	6609                	lui	a2,0x2
     a28:	85ce                	mv	a1,s3
     a2a:	4505                	li	a0,1
     a2c:	00005097          	auipc	ra,0x5
     a30:	fde080e7          	jalr	-34(ra) # 5a0a <write>
    if(n > 0){
     a34:	08a04963          	bgtz	a0,ac6 <copyin+0x106>
    if(pipe(fds) < 0){
     a38:	fb840513          	addi	a0,s0,-72
     a3c:	00005097          	auipc	ra,0x5
     a40:	fbe080e7          	jalr	-66(ra) # 59fa <pipe>
     a44:	0a054063          	bltz	a0,ae4 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     a48:	6609                	lui	a2,0x2
     a4a:	85ce                	mv	a1,s3
     a4c:	fbc42503          	lw	a0,-68(s0)
     a50:	00005097          	auipc	ra,0x5
     a54:	fba080e7          	jalr	-70(ra) # 5a0a <write>
    if(n > 0){
     a58:	0aa04363          	bgtz	a0,afe <copyin+0x13e>
    close(fds[0]);
     a5c:	fb842503          	lw	a0,-72(s0)
     a60:	00005097          	auipc	ra,0x5
     a64:	fb2080e7          	jalr	-78(ra) # 5a12 <close>
    close(fds[1]);
     a68:	fbc42503          	lw	a0,-68(s0)
     a6c:	00005097          	auipc	ra,0x5
     a70:	fa6080e7          	jalr	-90(ra) # 5a12 <close>
  for(int ai = 0; ai < 2; ai++){
     a74:	0921                	addi	s2,s2,8
     a76:	fd040793          	addi	a5,s0,-48
     a7a:	f6f918e3          	bne	s2,a5,9ea <copyin+0x2a>
}
     a7e:	60a6                	ld	ra,72(sp)
     a80:	6406                	ld	s0,64(sp)
     a82:	74e2                	ld	s1,56(sp)
     a84:	7942                	ld	s2,48(sp)
     a86:	79a2                	ld	s3,40(sp)
     a88:	7a02                	ld	s4,32(sp)
     a8a:	6161                	addi	sp,sp,80
     a8c:	8082                	ret
      printf("open(copyin1) failed\n");
     a8e:	00006517          	auipc	a0,0x6
     a92:	bda50513          	addi	a0,a0,-1062 # 6668 <csem_up+0x634>
     a96:	00005097          	auipc	ra,0x5
     a9a:	326080e7          	jalr	806(ra) # 5dbc <printf>
      exit(1);
     a9e:	4505                	li	a0,1
     aa0:	00005097          	auipc	ra,0x5
     aa4:	f4a080e7          	jalr	-182(ra) # 59ea <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     aa8:	862a                	mv	a2,a0
     aaa:	85ce                	mv	a1,s3
     aac:	00006517          	auipc	a0,0x6
     ab0:	bd450513          	addi	a0,a0,-1068 # 6680 <csem_up+0x64c>
     ab4:	00005097          	auipc	ra,0x5
     ab8:	308080e7          	jalr	776(ra) # 5dbc <printf>
      exit(1);
     abc:	4505                	li	a0,1
     abe:	00005097          	auipc	ra,0x5
     ac2:	f2c080e7          	jalr	-212(ra) # 59ea <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     ac6:	862a                	mv	a2,a0
     ac8:	85ce                	mv	a1,s3
     aca:	00006517          	auipc	a0,0x6
     ace:	be650513          	addi	a0,a0,-1050 # 66b0 <csem_up+0x67c>
     ad2:	00005097          	auipc	ra,0x5
     ad6:	2ea080e7          	jalr	746(ra) # 5dbc <printf>
      exit(1);
     ada:	4505                	li	a0,1
     adc:	00005097          	auipc	ra,0x5
     ae0:	f0e080e7          	jalr	-242(ra) # 59ea <exit>
      printf("pipe() failed\n");
     ae4:	00006517          	auipc	a0,0x6
     ae8:	bfc50513          	addi	a0,a0,-1028 # 66e0 <csem_up+0x6ac>
     aec:	00005097          	auipc	ra,0x5
     af0:	2d0080e7          	jalr	720(ra) # 5dbc <printf>
      exit(1);
     af4:	4505                	li	a0,1
     af6:	00005097          	auipc	ra,0x5
     afa:	ef4080e7          	jalr	-268(ra) # 59ea <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     afe:	862a                	mv	a2,a0
     b00:	85ce                	mv	a1,s3
     b02:	00006517          	auipc	a0,0x6
     b06:	bee50513          	addi	a0,a0,-1042 # 66f0 <csem_up+0x6bc>
     b0a:	00005097          	auipc	ra,0x5
     b0e:	2b2080e7          	jalr	690(ra) # 5dbc <printf>
      exit(1);
     b12:	4505                	li	a0,1
     b14:	00005097          	auipc	ra,0x5
     b18:	ed6080e7          	jalr	-298(ra) # 59ea <exit>

0000000000000b1c <copyout>:
{
     b1c:	711d                	addi	sp,sp,-96
     b1e:	ec86                	sd	ra,88(sp)
     b20:	e8a2                	sd	s0,80(sp)
     b22:	e4a6                	sd	s1,72(sp)
     b24:	e0ca                	sd	s2,64(sp)
     b26:	fc4e                	sd	s3,56(sp)
     b28:	f852                	sd	s4,48(sp)
     b2a:	f456                	sd	s5,40(sp)
     b2c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     b2e:	4785                	li	a5,1
     b30:	07fe                	slli	a5,a5,0x1f
     b32:	faf43823          	sd	a5,-80(s0)
     b36:	57fd                	li	a5,-1
     b38:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     b3c:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     b40:	00006a17          	auipc	s4,0x6
     b44:	be0a0a13          	addi	s4,s4,-1056 # 6720 <csem_up+0x6ec>
    n = write(fds[1], "x", 1);
     b48:	00006a97          	auipc	s5,0x6
     b4c:	aa0a8a93          	addi	s5,s5,-1376 # 65e8 <csem_up+0x5b4>
    uint64 addr = addrs[ai];
     b50:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     b54:	4581                	li	a1,0
     b56:	8552                	mv	a0,s4
     b58:	00005097          	auipc	ra,0x5
     b5c:	ed2080e7          	jalr	-302(ra) # 5a2a <open>
     b60:	84aa                	mv	s1,a0
    if(fd < 0){
     b62:	08054663          	bltz	a0,bee <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     b66:	6609                	lui	a2,0x2
     b68:	85ce                	mv	a1,s3
     b6a:	00005097          	auipc	ra,0x5
     b6e:	e98080e7          	jalr	-360(ra) # 5a02 <read>
    if(n > 0){
     b72:	08a04b63          	bgtz	a0,c08 <copyout+0xec>
    close(fd);
     b76:	8526                	mv	a0,s1
     b78:	00005097          	auipc	ra,0x5
     b7c:	e9a080e7          	jalr	-358(ra) # 5a12 <close>
    if(pipe(fds) < 0){
     b80:	fa840513          	addi	a0,s0,-88
     b84:	00005097          	auipc	ra,0x5
     b88:	e76080e7          	jalr	-394(ra) # 59fa <pipe>
     b8c:	08054d63          	bltz	a0,c26 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     b90:	4605                	li	a2,1
     b92:	85d6                	mv	a1,s5
     b94:	fac42503          	lw	a0,-84(s0)
     b98:	00005097          	auipc	ra,0x5
     b9c:	e72080e7          	jalr	-398(ra) # 5a0a <write>
    if(n != 1){
     ba0:	4785                	li	a5,1
     ba2:	08f51f63          	bne	a0,a5,c40 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     ba6:	6609                	lui	a2,0x2
     ba8:	85ce                	mv	a1,s3
     baa:	fa842503          	lw	a0,-88(s0)
     bae:	00005097          	auipc	ra,0x5
     bb2:	e54080e7          	jalr	-428(ra) # 5a02 <read>
    if(n > 0){
     bb6:	0aa04263          	bgtz	a0,c5a <copyout+0x13e>
    close(fds[0]);
     bba:	fa842503          	lw	a0,-88(s0)
     bbe:	00005097          	auipc	ra,0x5
     bc2:	e54080e7          	jalr	-428(ra) # 5a12 <close>
    close(fds[1]);
     bc6:	fac42503          	lw	a0,-84(s0)
     bca:	00005097          	auipc	ra,0x5
     bce:	e48080e7          	jalr	-440(ra) # 5a12 <close>
  for(int ai = 0; ai < 2; ai++){
     bd2:	0921                	addi	s2,s2,8
     bd4:	fc040793          	addi	a5,s0,-64
     bd8:	f6f91ce3          	bne	s2,a5,b50 <copyout+0x34>
}
     bdc:	60e6                	ld	ra,88(sp)
     bde:	6446                	ld	s0,80(sp)
     be0:	64a6                	ld	s1,72(sp)
     be2:	6906                	ld	s2,64(sp)
     be4:	79e2                	ld	s3,56(sp)
     be6:	7a42                	ld	s4,48(sp)
     be8:	7aa2                	ld	s5,40(sp)
     bea:	6125                	addi	sp,sp,96
     bec:	8082                	ret
      printf("open(README) failed\n");
     bee:	00006517          	auipc	a0,0x6
     bf2:	b3a50513          	addi	a0,a0,-1222 # 6728 <csem_up+0x6f4>
     bf6:	00005097          	auipc	ra,0x5
     bfa:	1c6080e7          	jalr	454(ra) # 5dbc <printf>
      exit(1);
     bfe:	4505                	li	a0,1
     c00:	00005097          	auipc	ra,0x5
     c04:	dea080e7          	jalr	-534(ra) # 59ea <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     c08:	862a                	mv	a2,a0
     c0a:	85ce                	mv	a1,s3
     c0c:	00006517          	auipc	a0,0x6
     c10:	b3450513          	addi	a0,a0,-1228 # 6740 <csem_up+0x70c>
     c14:	00005097          	auipc	ra,0x5
     c18:	1a8080e7          	jalr	424(ra) # 5dbc <printf>
      exit(1);
     c1c:	4505                	li	a0,1
     c1e:	00005097          	auipc	ra,0x5
     c22:	dcc080e7          	jalr	-564(ra) # 59ea <exit>
      printf("pipe() failed\n");
     c26:	00006517          	auipc	a0,0x6
     c2a:	aba50513          	addi	a0,a0,-1350 # 66e0 <csem_up+0x6ac>
     c2e:	00005097          	auipc	ra,0x5
     c32:	18e080e7          	jalr	398(ra) # 5dbc <printf>
      exit(1);
     c36:	4505                	li	a0,1
     c38:	00005097          	auipc	ra,0x5
     c3c:	db2080e7          	jalr	-590(ra) # 59ea <exit>
      printf("pipe write failed\n");
     c40:	00006517          	auipc	a0,0x6
     c44:	b3050513          	addi	a0,a0,-1232 # 6770 <csem_up+0x73c>
     c48:	00005097          	auipc	ra,0x5
     c4c:	174080e7          	jalr	372(ra) # 5dbc <printf>
      exit(1);
     c50:	4505                	li	a0,1
     c52:	00005097          	auipc	ra,0x5
     c56:	d98080e7          	jalr	-616(ra) # 59ea <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     c5a:	862a                	mv	a2,a0
     c5c:	85ce                	mv	a1,s3
     c5e:	00006517          	auipc	a0,0x6
     c62:	b2a50513          	addi	a0,a0,-1238 # 6788 <csem_up+0x754>
     c66:	00005097          	auipc	ra,0x5
     c6a:	156080e7          	jalr	342(ra) # 5dbc <printf>
      exit(1);
     c6e:	4505                	li	a0,1
     c70:	00005097          	auipc	ra,0x5
     c74:	d7a080e7          	jalr	-646(ra) # 59ea <exit>

0000000000000c78 <truncate1>:
{
     c78:	711d                	addi	sp,sp,-96
     c7a:	ec86                	sd	ra,88(sp)
     c7c:	e8a2                	sd	s0,80(sp)
     c7e:	e4a6                	sd	s1,72(sp)
     c80:	e0ca                	sd	s2,64(sp)
     c82:	fc4e                	sd	s3,56(sp)
     c84:	f852                	sd	s4,48(sp)
     c86:	f456                	sd	s5,40(sp)
     c88:	1080                	addi	s0,sp,96
     c8a:	8aaa                	mv	s5,a0
  unlink("truncfile");
     c8c:	00006517          	auipc	a0,0x6
     c90:	94450513          	addi	a0,a0,-1724 # 65d0 <csem_up+0x59c>
     c94:	00005097          	auipc	ra,0x5
     c98:	da6080e7          	jalr	-602(ra) # 5a3a <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     c9c:	60100593          	li	a1,1537
     ca0:	00006517          	auipc	a0,0x6
     ca4:	93050513          	addi	a0,a0,-1744 # 65d0 <csem_up+0x59c>
     ca8:	00005097          	auipc	ra,0x5
     cac:	d82080e7          	jalr	-638(ra) # 5a2a <open>
     cb0:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     cb2:	4611                	li	a2,4
     cb4:	00006597          	auipc	a1,0x6
     cb8:	92c58593          	addi	a1,a1,-1748 # 65e0 <csem_up+0x5ac>
     cbc:	00005097          	auipc	ra,0x5
     cc0:	d4e080e7          	jalr	-690(ra) # 5a0a <write>
  close(fd1);
     cc4:	8526                	mv	a0,s1
     cc6:	00005097          	auipc	ra,0x5
     cca:	d4c080e7          	jalr	-692(ra) # 5a12 <close>
  int fd2 = open("truncfile", O_RDONLY);
     cce:	4581                	li	a1,0
     cd0:	00006517          	auipc	a0,0x6
     cd4:	90050513          	addi	a0,a0,-1792 # 65d0 <csem_up+0x59c>
     cd8:	00005097          	auipc	ra,0x5
     cdc:	d52080e7          	jalr	-686(ra) # 5a2a <open>
     ce0:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     ce2:	02000613          	li	a2,32
     ce6:	fa040593          	addi	a1,s0,-96
     cea:	00005097          	auipc	ra,0x5
     cee:	d18080e7          	jalr	-744(ra) # 5a02 <read>
  if(n != 4){
     cf2:	4791                	li	a5,4
     cf4:	0cf51e63          	bne	a0,a5,dd0 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     cf8:	40100593          	li	a1,1025
     cfc:	00006517          	auipc	a0,0x6
     d00:	8d450513          	addi	a0,a0,-1836 # 65d0 <csem_up+0x59c>
     d04:	00005097          	auipc	ra,0x5
     d08:	d26080e7          	jalr	-730(ra) # 5a2a <open>
     d0c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     d0e:	4581                	li	a1,0
     d10:	00006517          	auipc	a0,0x6
     d14:	8c050513          	addi	a0,a0,-1856 # 65d0 <csem_up+0x59c>
     d18:	00005097          	auipc	ra,0x5
     d1c:	d12080e7          	jalr	-750(ra) # 5a2a <open>
     d20:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     d22:	02000613          	li	a2,32
     d26:	fa040593          	addi	a1,s0,-96
     d2a:	00005097          	auipc	ra,0x5
     d2e:	cd8080e7          	jalr	-808(ra) # 5a02 <read>
     d32:	8a2a                	mv	s4,a0
  if(n != 0){
     d34:	ed4d                	bnez	a0,dee <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     d36:	02000613          	li	a2,32
     d3a:	fa040593          	addi	a1,s0,-96
     d3e:	8526                	mv	a0,s1
     d40:	00005097          	auipc	ra,0x5
     d44:	cc2080e7          	jalr	-830(ra) # 5a02 <read>
     d48:	8a2a                	mv	s4,a0
  if(n != 0){
     d4a:	e971                	bnez	a0,e1e <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     d4c:	4619                	li	a2,6
     d4e:	00006597          	auipc	a1,0x6
     d52:	aca58593          	addi	a1,a1,-1334 # 6818 <csem_up+0x7e4>
     d56:	854e                	mv	a0,s3
     d58:	00005097          	auipc	ra,0x5
     d5c:	cb2080e7          	jalr	-846(ra) # 5a0a <write>
  n = read(fd3, buf, sizeof(buf));
     d60:	02000613          	li	a2,32
     d64:	fa040593          	addi	a1,s0,-96
     d68:	854a                	mv	a0,s2
     d6a:	00005097          	auipc	ra,0x5
     d6e:	c98080e7          	jalr	-872(ra) # 5a02 <read>
  if(n != 6){
     d72:	4799                	li	a5,6
     d74:	0cf51d63          	bne	a0,a5,e4e <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     d78:	02000613          	li	a2,32
     d7c:	fa040593          	addi	a1,s0,-96
     d80:	8526                	mv	a0,s1
     d82:	00005097          	auipc	ra,0x5
     d86:	c80080e7          	jalr	-896(ra) # 5a02 <read>
  if(n != 2){
     d8a:	4789                	li	a5,2
     d8c:	0ef51063          	bne	a0,a5,e6c <truncate1+0x1f4>
  unlink("truncfile");
     d90:	00006517          	auipc	a0,0x6
     d94:	84050513          	addi	a0,a0,-1984 # 65d0 <csem_up+0x59c>
     d98:	00005097          	auipc	ra,0x5
     d9c:	ca2080e7          	jalr	-862(ra) # 5a3a <unlink>
  close(fd1);
     da0:	854e                	mv	a0,s3
     da2:	00005097          	auipc	ra,0x5
     da6:	c70080e7          	jalr	-912(ra) # 5a12 <close>
  close(fd2);
     daa:	8526                	mv	a0,s1
     dac:	00005097          	auipc	ra,0x5
     db0:	c66080e7          	jalr	-922(ra) # 5a12 <close>
  close(fd3);
     db4:	854a                	mv	a0,s2
     db6:	00005097          	auipc	ra,0x5
     dba:	c5c080e7          	jalr	-932(ra) # 5a12 <close>
}
     dbe:	60e6                	ld	ra,88(sp)
     dc0:	6446                	ld	s0,80(sp)
     dc2:	64a6                	ld	s1,72(sp)
     dc4:	6906                	ld	s2,64(sp)
     dc6:	79e2                	ld	s3,56(sp)
     dc8:	7a42                	ld	s4,48(sp)
     dca:	7aa2                	ld	s5,40(sp)
     dcc:	6125                	addi	sp,sp,96
     dce:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     dd0:	862a                	mv	a2,a0
     dd2:	85d6                	mv	a1,s5
     dd4:	00006517          	auipc	a0,0x6
     dd8:	9e450513          	addi	a0,a0,-1564 # 67b8 <csem_up+0x784>
     ddc:	00005097          	auipc	ra,0x5
     de0:	fe0080e7          	jalr	-32(ra) # 5dbc <printf>
    exit(1);
     de4:	4505                	li	a0,1
     de6:	00005097          	auipc	ra,0x5
     dea:	c04080e7          	jalr	-1020(ra) # 59ea <exit>
    printf("aaa fd3=%d\n", fd3);
     dee:	85ca                	mv	a1,s2
     df0:	00006517          	auipc	a0,0x6
     df4:	9e850513          	addi	a0,a0,-1560 # 67d8 <csem_up+0x7a4>
     df8:	00005097          	auipc	ra,0x5
     dfc:	fc4080e7          	jalr	-60(ra) # 5dbc <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     e00:	8652                	mv	a2,s4
     e02:	85d6                	mv	a1,s5
     e04:	00006517          	auipc	a0,0x6
     e08:	9e450513          	addi	a0,a0,-1564 # 67e8 <csem_up+0x7b4>
     e0c:	00005097          	auipc	ra,0x5
     e10:	fb0080e7          	jalr	-80(ra) # 5dbc <printf>
    exit(1);
     e14:	4505                	li	a0,1
     e16:	00005097          	auipc	ra,0x5
     e1a:	bd4080e7          	jalr	-1068(ra) # 59ea <exit>
    printf("bbb fd2=%d\n", fd2);
     e1e:	85a6                	mv	a1,s1
     e20:	00006517          	auipc	a0,0x6
     e24:	9e850513          	addi	a0,a0,-1560 # 6808 <csem_up+0x7d4>
     e28:	00005097          	auipc	ra,0x5
     e2c:	f94080e7          	jalr	-108(ra) # 5dbc <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     e30:	8652                	mv	a2,s4
     e32:	85d6                	mv	a1,s5
     e34:	00006517          	auipc	a0,0x6
     e38:	9b450513          	addi	a0,a0,-1612 # 67e8 <csem_up+0x7b4>
     e3c:	00005097          	auipc	ra,0x5
     e40:	f80080e7          	jalr	-128(ra) # 5dbc <printf>
    exit(1);
     e44:	4505                	li	a0,1
     e46:	00005097          	auipc	ra,0x5
     e4a:	ba4080e7          	jalr	-1116(ra) # 59ea <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     e4e:	862a                	mv	a2,a0
     e50:	85d6                	mv	a1,s5
     e52:	00006517          	auipc	a0,0x6
     e56:	9ce50513          	addi	a0,a0,-1586 # 6820 <csem_up+0x7ec>
     e5a:	00005097          	auipc	ra,0x5
     e5e:	f62080e7          	jalr	-158(ra) # 5dbc <printf>
    exit(1);
     e62:	4505                	li	a0,1
     e64:	00005097          	auipc	ra,0x5
     e68:	b86080e7          	jalr	-1146(ra) # 59ea <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     e6c:	862a                	mv	a2,a0
     e6e:	85d6                	mv	a1,s5
     e70:	00006517          	auipc	a0,0x6
     e74:	9d050513          	addi	a0,a0,-1584 # 6840 <csem_up+0x80c>
     e78:	00005097          	auipc	ra,0x5
     e7c:	f44080e7          	jalr	-188(ra) # 5dbc <printf>
    exit(1);
     e80:	4505                	li	a0,1
     e82:	00005097          	auipc	ra,0x5
     e86:	b68080e7          	jalr	-1176(ra) # 59ea <exit>

0000000000000e8a <pipe1>:
{
     e8a:	711d                	addi	sp,sp,-96
     e8c:	ec86                	sd	ra,88(sp)
     e8e:	e8a2                	sd	s0,80(sp)
     e90:	e4a6                	sd	s1,72(sp)
     e92:	e0ca                	sd	s2,64(sp)
     e94:	fc4e                	sd	s3,56(sp)
     e96:	f852                	sd	s4,48(sp)
     e98:	f456                	sd	s5,40(sp)
     e9a:	f05a                	sd	s6,32(sp)
     e9c:	ec5e                	sd	s7,24(sp)
     e9e:	1080                	addi	s0,sp,96
     ea0:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
     ea2:	fa840513          	addi	a0,s0,-88
     ea6:	00005097          	auipc	ra,0x5
     eaa:	b54080e7          	jalr	-1196(ra) # 59fa <pipe>
     eae:	ed25                	bnez	a0,f26 <pipe1+0x9c>
     eb0:	84aa                	mv	s1,a0
  pid = fork();
     eb2:	00005097          	auipc	ra,0x5
     eb6:	b30080e7          	jalr	-1232(ra) # 59e2 <fork>
     eba:	8a2a                	mv	s4,a0
  if(pid == 0){
     ebc:	c159                	beqz	a0,f42 <pipe1+0xb8>
  } else if(pid > 0){
     ebe:	16a05e63          	blez	a0,103a <pipe1+0x1b0>
    close(fds[1]);
     ec2:	fac42503          	lw	a0,-84(s0)
     ec6:	00005097          	auipc	ra,0x5
     eca:	b4c080e7          	jalr	-1204(ra) # 5a12 <close>
    total = 0;
     ece:	8a26                	mv	s4,s1
    cc = 1;
     ed0:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
     ed2:	0000ba97          	auipc	s5,0xb
     ed6:	106a8a93          	addi	s5,s5,262 # bfd8 <buf>
      if(cc > sizeof(buf))
     eda:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
     edc:	864e                	mv	a2,s3
     ede:	85d6                	mv	a1,s5
     ee0:	fa842503          	lw	a0,-88(s0)
     ee4:	00005097          	auipc	ra,0x5
     ee8:	b1e080e7          	jalr	-1250(ra) # 5a02 <read>
     eec:	10a05263          	blez	a0,ff0 <pipe1+0x166>
      for(i = 0; i < n; i++){
     ef0:	0000b717          	auipc	a4,0xb
     ef4:	0e870713          	addi	a4,a4,232 # bfd8 <buf>
     ef8:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     efc:	00074683          	lbu	a3,0(a4)
     f00:	0ff4f793          	andi	a5,s1,255
     f04:	2485                	addiw	s1,s1,1
     f06:	0cf69163          	bne	a3,a5,fc8 <pipe1+0x13e>
      for(i = 0; i < n; i++){
     f0a:	0705                	addi	a4,a4,1
     f0c:	fec498e3          	bne	s1,a2,efc <pipe1+0x72>
      total += n;
     f10:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
     f14:	0019979b          	slliw	a5,s3,0x1
     f18:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
     f1c:	013b7363          	bgeu	s6,s3,f22 <pipe1+0x98>
        cc = sizeof(buf);
     f20:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     f22:	84b2                	mv	s1,a2
     f24:	bf65                	j	edc <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
     f26:	85ca                	mv	a1,s2
     f28:	00006517          	auipc	a0,0x6
     f2c:	93850513          	addi	a0,a0,-1736 # 6860 <csem_up+0x82c>
     f30:	00005097          	auipc	ra,0x5
     f34:	e8c080e7          	jalr	-372(ra) # 5dbc <printf>
    exit(1);
     f38:	4505                	li	a0,1
     f3a:	00005097          	auipc	ra,0x5
     f3e:	ab0080e7          	jalr	-1360(ra) # 59ea <exit>
    close(fds[0]);
     f42:	fa842503          	lw	a0,-88(s0)
     f46:	00005097          	auipc	ra,0x5
     f4a:	acc080e7          	jalr	-1332(ra) # 5a12 <close>
    for(n = 0; n < N; n++){
     f4e:	0000bb17          	auipc	s6,0xb
     f52:	08ab0b13          	addi	s6,s6,138 # bfd8 <buf>
     f56:	416004bb          	negw	s1,s6
     f5a:	0ff4f493          	andi	s1,s1,255
     f5e:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
     f62:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
     f64:	6a85                	lui	s5,0x1
     f66:	42da8a93          	addi	s5,s5,1069 # 142d <linktest+0x77>
{
     f6a:	87da                	mv	a5,s6
        buf[i] = seq++;
     f6c:	0097873b          	addw	a4,a5,s1
     f70:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
     f74:	0785                	addi	a5,a5,1
     f76:	fef99be3          	bne	s3,a5,f6c <pipe1+0xe2>
        buf[i] = seq++;
     f7a:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
     f7e:	40900613          	li	a2,1033
     f82:	85de                	mv	a1,s7
     f84:	fac42503          	lw	a0,-84(s0)
     f88:	00005097          	auipc	ra,0x5
     f8c:	a82080e7          	jalr	-1406(ra) # 5a0a <write>
     f90:	40900793          	li	a5,1033
     f94:	00f51c63          	bne	a0,a5,fac <pipe1+0x122>
    for(n = 0; n < N; n++){
     f98:	24a5                	addiw	s1,s1,9
     f9a:	0ff4f493          	andi	s1,s1,255
     f9e:	fd5a16e3          	bne	s4,s5,f6a <pipe1+0xe0>
    exit(0);
     fa2:	4501                	li	a0,0
     fa4:	00005097          	auipc	ra,0x5
     fa8:	a46080e7          	jalr	-1466(ra) # 59ea <exit>
        printf("%s: pipe1 oops 1\n", s);
     fac:	85ca                	mv	a1,s2
     fae:	00006517          	auipc	a0,0x6
     fb2:	8ca50513          	addi	a0,a0,-1846 # 6878 <csem_up+0x844>
     fb6:	00005097          	auipc	ra,0x5
     fba:	e06080e7          	jalr	-506(ra) # 5dbc <printf>
        exit(1);
     fbe:	4505                	li	a0,1
     fc0:	00005097          	auipc	ra,0x5
     fc4:	a2a080e7          	jalr	-1494(ra) # 59ea <exit>
          printf("%s: pipe1 oops 2\n", s);
     fc8:	85ca                	mv	a1,s2
     fca:	00006517          	auipc	a0,0x6
     fce:	8c650513          	addi	a0,a0,-1850 # 6890 <csem_up+0x85c>
     fd2:	00005097          	auipc	ra,0x5
     fd6:	dea080e7          	jalr	-534(ra) # 5dbc <printf>
}
     fda:	60e6                	ld	ra,88(sp)
     fdc:	6446                	ld	s0,80(sp)
     fde:	64a6                	ld	s1,72(sp)
     fe0:	6906                	ld	s2,64(sp)
     fe2:	79e2                	ld	s3,56(sp)
     fe4:	7a42                	ld	s4,48(sp)
     fe6:	7aa2                	ld	s5,40(sp)
     fe8:	7b02                	ld	s6,32(sp)
     fea:	6be2                	ld	s7,24(sp)
     fec:	6125                	addi	sp,sp,96
     fee:	8082                	ret
    if(total != N * SZ){
     ff0:	6785                	lui	a5,0x1
     ff2:	42d78793          	addi	a5,a5,1069 # 142d <linktest+0x77>
     ff6:	02fa0063          	beq	s4,a5,1016 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
     ffa:	85d2                	mv	a1,s4
     ffc:	00006517          	auipc	a0,0x6
    1000:	8ac50513          	addi	a0,a0,-1876 # 68a8 <csem_up+0x874>
    1004:	00005097          	auipc	ra,0x5
    1008:	db8080e7          	jalr	-584(ra) # 5dbc <printf>
      exit(1);
    100c:	4505                	li	a0,1
    100e:	00005097          	auipc	ra,0x5
    1012:	9dc080e7          	jalr	-1572(ra) # 59ea <exit>
    close(fds[0]);
    1016:	fa842503          	lw	a0,-88(s0)
    101a:	00005097          	auipc	ra,0x5
    101e:	9f8080e7          	jalr	-1544(ra) # 5a12 <close>
    wait(&xstatus);
    1022:	fa440513          	addi	a0,s0,-92
    1026:	00005097          	auipc	ra,0x5
    102a:	9cc080e7          	jalr	-1588(ra) # 59f2 <wait>
    exit(xstatus);
    102e:	fa442503          	lw	a0,-92(s0)
    1032:	00005097          	auipc	ra,0x5
    1036:	9b8080e7          	jalr	-1608(ra) # 59ea <exit>
    printf("%s: fork() failed\n", s);
    103a:	85ca                	mv	a1,s2
    103c:	00006517          	auipc	a0,0x6
    1040:	88c50513          	addi	a0,a0,-1908 # 68c8 <csem_up+0x894>
    1044:	00005097          	auipc	ra,0x5
    1048:	d78080e7          	jalr	-648(ra) # 5dbc <printf>
    exit(1);
    104c:	4505                	li	a0,1
    104e:	00005097          	auipc	ra,0x5
    1052:	99c080e7          	jalr	-1636(ra) # 59ea <exit>

0000000000001056 <preempt>:
{
    1056:	7139                	addi	sp,sp,-64
    1058:	fc06                	sd	ra,56(sp)
    105a:	f822                	sd	s0,48(sp)
    105c:	f426                	sd	s1,40(sp)
    105e:	f04a                	sd	s2,32(sp)
    1060:	ec4e                	sd	s3,24(sp)
    1062:	e852                	sd	s4,16(sp)
    1064:	0080                	addi	s0,sp,64
    1066:	892a                	mv	s2,a0
  pid1 = fork();
    1068:	00005097          	auipc	ra,0x5
    106c:	97a080e7          	jalr	-1670(ra) # 59e2 <fork>
  if(pid1 < 0) {
    1070:	00054563          	bltz	a0,107a <preempt+0x24>
    1074:	84aa                	mv	s1,a0
  if(pid1 == 0)
    1076:	e105                	bnez	a0,1096 <preempt+0x40>
    for(;;)
    1078:	a001                	j	1078 <preempt+0x22>
    printf("%s: fork failed", s);
    107a:	85ca                	mv	a1,s2
    107c:	00005517          	auipc	a0,0x5
    1080:	30450513          	addi	a0,a0,772 # 6380 <csem_up+0x34c>
    1084:	00005097          	auipc	ra,0x5
    1088:	d38080e7          	jalr	-712(ra) # 5dbc <printf>
    exit(1);
    108c:	4505                	li	a0,1
    108e:	00005097          	auipc	ra,0x5
    1092:	95c080e7          	jalr	-1700(ra) # 59ea <exit>
  pid2 = fork();
    1096:	00005097          	auipc	ra,0x5
    109a:	94c080e7          	jalr	-1716(ra) # 59e2 <fork>
    109e:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    10a0:	00054463          	bltz	a0,10a8 <preempt+0x52>
  if(pid2 == 0)
    10a4:	e105                	bnez	a0,10c4 <preempt+0x6e>
    for(;;)
    10a6:	a001                	j	10a6 <preempt+0x50>
    printf("%s: fork failed\n", s);
    10a8:	85ca                	mv	a1,s2
    10aa:	00005517          	auipc	a0,0x5
    10ae:	28650513          	addi	a0,a0,646 # 6330 <csem_up+0x2fc>
    10b2:	00005097          	auipc	ra,0x5
    10b6:	d0a080e7          	jalr	-758(ra) # 5dbc <printf>
    exit(1);
    10ba:	4505                	li	a0,1
    10bc:	00005097          	auipc	ra,0x5
    10c0:	92e080e7          	jalr	-1746(ra) # 59ea <exit>
  pipe(pfds);
    10c4:	fc840513          	addi	a0,s0,-56
    10c8:	00005097          	auipc	ra,0x5
    10cc:	932080e7          	jalr	-1742(ra) # 59fa <pipe>
  pid3 = fork();
    10d0:	00005097          	auipc	ra,0x5
    10d4:	912080e7          	jalr	-1774(ra) # 59e2 <fork>
    10d8:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    10da:	02054e63          	bltz	a0,1116 <preempt+0xc0>
  if(pid3 == 0){
    10de:	e525                	bnez	a0,1146 <preempt+0xf0>
    close(pfds[0]);
    10e0:	fc842503          	lw	a0,-56(s0)
    10e4:	00005097          	auipc	ra,0x5
    10e8:	92e080e7          	jalr	-1746(ra) # 5a12 <close>
    if(write(pfds[1], "x", 1) != 1)
    10ec:	4605                	li	a2,1
    10ee:	00005597          	auipc	a1,0x5
    10f2:	4fa58593          	addi	a1,a1,1274 # 65e8 <csem_up+0x5b4>
    10f6:	fcc42503          	lw	a0,-52(s0)
    10fa:	00005097          	auipc	ra,0x5
    10fe:	910080e7          	jalr	-1776(ra) # 5a0a <write>
    1102:	4785                	li	a5,1
    1104:	02f51763          	bne	a0,a5,1132 <preempt+0xdc>
    close(pfds[1]);
    1108:	fcc42503          	lw	a0,-52(s0)
    110c:	00005097          	auipc	ra,0x5
    1110:	906080e7          	jalr	-1786(ra) # 5a12 <close>
    for(;;)
    1114:	a001                	j	1114 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    1116:	85ca                	mv	a1,s2
    1118:	00005517          	auipc	a0,0x5
    111c:	21850513          	addi	a0,a0,536 # 6330 <csem_up+0x2fc>
    1120:	00005097          	auipc	ra,0x5
    1124:	c9c080e7          	jalr	-868(ra) # 5dbc <printf>
     exit(1);
    1128:	4505                	li	a0,1
    112a:	00005097          	auipc	ra,0x5
    112e:	8c0080e7          	jalr	-1856(ra) # 59ea <exit>
      printf("%s: preempt write error", s);
    1132:	85ca                	mv	a1,s2
    1134:	00005517          	auipc	a0,0x5
    1138:	7ac50513          	addi	a0,a0,1964 # 68e0 <csem_up+0x8ac>
    113c:	00005097          	auipc	ra,0x5
    1140:	c80080e7          	jalr	-896(ra) # 5dbc <printf>
    1144:	b7d1                	j	1108 <preempt+0xb2>
  close(pfds[1]);
    1146:	fcc42503          	lw	a0,-52(s0)
    114a:	00005097          	auipc	ra,0x5
    114e:	8c8080e7          	jalr	-1848(ra) # 5a12 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    1152:	660d                	lui	a2,0x3
    1154:	0000b597          	auipc	a1,0xb
    1158:	e8458593          	addi	a1,a1,-380 # bfd8 <buf>
    115c:	fc842503          	lw	a0,-56(s0)
    1160:	00005097          	auipc	ra,0x5
    1164:	8a2080e7          	jalr	-1886(ra) # 5a02 <read>
    1168:	4785                	li	a5,1
    116a:	02f50363          	beq	a0,a5,1190 <preempt+0x13a>
    printf("%s: preempt read error", s);
    116e:	85ca                	mv	a1,s2
    1170:	00005517          	auipc	a0,0x5
    1174:	78850513          	addi	a0,a0,1928 # 68f8 <csem_up+0x8c4>
    1178:	00005097          	auipc	ra,0x5
    117c:	c44080e7          	jalr	-956(ra) # 5dbc <printf>
}
    1180:	70e2                	ld	ra,56(sp)
    1182:	7442                	ld	s0,48(sp)
    1184:	74a2                	ld	s1,40(sp)
    1186:	7902                	ld	s2,32(sp)
    1188:	69e2                	ld	s3,24(sp)
    118a:	6a42                	ld	s4,16(sp)
    118c:	6121                	addi	sp,sp,64
    118e:	8082                	ret
  close(pfds[0]);
    1190:	fc842503          	lw	a0,-56(s0)
    1194:	00005097          	auipc	ra,0x5
    1198:	87e080e7          	jalr	-1922(ra) # 5a12 <close>
  printf("kill... ");
    119c:	00005517          	auipc	a0,0x5
    11a0:	77450513          	addi	a0,a0,1908 # 6910 <csem_up+0x8dc>
    11a4:	00005097          	auipc	ra,0x5
    11a8:	c18080e7          	jalr	-1000(ra) # 5dbc <printf>
  kill(pid1, SIGKILL);
    11ac:	45a5                	li	a1,9
    11ae:	8526                	mv	a0,s1
    11b0:	00005097          	auipc	ra,0x5
    11b4:	86a080e7          	jalr	-1942(ra) # 5a1a <kill>
  kill(pid2, SIGKILL);
    11b8:	45a5                	li	a1,9
    11ba:	854e                	mv	a0,s3
    11bc:	00005097          	auipc	ra,0x5
    11c0:	85e080e7          	jalr	-1954(ra) # 5a1a <kill>
  kill(pid3, SIGKILL);
    11c4:	45a5                	li	a1,9
    11c6:	8552                	mv	a0,s4
    11c8:	00005097          	auipc	ra,0x5
    11cc:	852080e7          	jalr	-1966(ra) # 5a1a <kill>
  printf("wait... ");
    11d0:	00005517          	auipc	a0,0x5
    11d4:	75050513          	addi	a0,a0,1872 # 6920 <csem_up+0x8ec>
    11d8:	00005097          	auipc	ra,0x5
    11dc:	be4080e7          	jalr	-1052(ra) # 5dbc <printf>
  wait(0);
    11e0:	4501                	li	a0,0
    11e2:	00005097          	auipc	ra,0x5
    11e6:	810080e7          	jalr	-2032(ra) # 59f2 <wait>
  wait(0);
    11ea:	4501                	li	a0,0
    11ec:	00005097          	auipc	ra,0x5
    11f0:	806080e7          	jalr	-2042(ra) # 59f2 <wait>
  wait(0);
    11f4:	4501                	li	a0,0
    11f6:	00004097          	auipc	ra,0x4
    11fa:	7fc080e7          	jalr	2044(ra) # 59f2 <wait>
    11fe:	b749                	j	1180 <preempt+0x12a>

0000000000001200 <unlinkread>:
{
    1200:	7179                	addi	sp,sp,-48
    1202:	f406                	sd	ra,40(sp)
    1204:	f022                	sd	s0,32(sp)
    1206:	ec26                	sd	s1,24(sp)
    1208:	e84a                	sd	s2,16(sp)
    120a:	e44e                	sd	s3,8(sp)
    120c:	1800                	addi	s0,sp,48
    120e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1210:	20200593          	li	a1,514
    1214:	00005517          	auipc	a0,0x5
    1218:	fa450513          	addi	a0,a0,-92 # 61b8 <csem_up+0x184>
    121c:	00005097          	auipc	ra,0x5
    1220:	80e080e7          	jalr	-2034(ra) # 5a2a <open>
  if(fd < 0){
    1224:	0e054563          	bltz	a0,130e <unlinkread+0x10e>
    1228:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
    122a:	4615                	li	a2,5
    122c:	00005597          	auipc	a1,0x5
    1230:	72458593          	addi	a1,a1,1828 # 6950 <csem_up+0x91c>
    1234:	00004097          	auipc	ra,0x4
    1238:	7d6080e7          	jalr	2006(ra) # 5a0a <write>
  close(fd);
    123c:	8526                	mv	a0,s1
    123e:	00004097          	auipc	ra,0x4
    1242:	7d4080e7          	jalr	2004(ra) # 5a12 <close>
  fd = open("unlinkread", O_RDWR);
    1246:	4589                	li	a1,2
    1248:	00005517          	auipc	a0,0x5
    124c:	f7050513          	addi	a0,a0,-144 # 61b8 <csem_up+0x184>
    1250:	00004097          	auipc	ra,0x4
    1254:	7da080e7          	jalr	2010(ra) # 5a2a <open>
    1258:	84aa                	mv	s1,a0
  if(fd < 0){
    125a:	0c054863          	bltz	a0,132a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
    125e:	00005517          	auipc	a0,0x5
    1262:	f5a50513          	addi	a0,a0,-166 # 61b8 <csem_up+0x184>
    1266:	00004097          	auipc	ra,0x4
    126a:	7d4080e7          	jalr	2004(ra) # 5a3a <unlink>
    126e:	ed61                	bnez	a0,1346 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1270:	20200593          	li	a1,514
    1274:	00005517          	auipc	a0,0x5
    1278:	f4450513          	addi	a0,a0,-188 # 61b8 <csem_up+0x184>
    127c:	00004097          	auipc	ra,0x4
    1280:	7ae080e7          	jalr	1966(ra) # 5a2a <open>
    1284:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
    1286:	460d                	li	a2,3
    1288:	00005597          	auipc	a1,0x5
    128c:	71058593          	addi	a1,a1,1808 # 6998 <csem_up+0x964>
    1290:	00004097          	auipc	ra,0x4
    1294:	77a080e7          	jalr	1914(ra) # 5a0a <write>
  close(fd1);
    1298:	854a                	mv	a0,s2
    129a:	00004097          	auipc	ra,0x4
    129e:	778080e7          	jalr	1912(ra) # 5a12 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
    12a2:	660d                	lui	a2,0x3
    12a4:	0000b597          	auipc	a1,0xb
    12a8:	d3458593          	addi	a1,a1,-716 # bfd8 <buf>
    12ac:	8526                	mv	a0,s1
    12ae:	00004097          	auipc	ra,0x4
    12b2:	754080e7          	jalr	1876(ra) # 5a02 <read>
    12b6:	4795                	li	a5,5
    12b8:	0af51563          	bne	a0,a5,1362 <unlinkread+0x162>
  if(buf[0] != 'h'){
    12bc:	0000b717          	auipc	a4,0xb
    12c0:	d1c74703          	lbu	a4,-740(a4) # bfd8 <buf>
    12c4:	06800793          	li	a5,104
    12c8:	0af71b63          	bne	a4,a5,137e <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
    12cc:	4629                	li	a2,10
    12ce:	0000b597          	auipc	a1,0xb
    12d2:	d0a58593          	addi	a1,a1,-758 # bfd8 <buf>
    12d6:	8526                	mv	a0,s1
    12d8:	00004097          	auipc	ra,0x4
    12dc:	732080e7          	jalr	1842(ra) # 5a0a <write>
    12e0:	47a9                	li	a5,10
    12e2:	0af51c63          	bne	a0,a5,139a <unlinkread+0x19a>
  close(fd);
    12e6:	8526                	mv	a0,s1
    12e8:	00004097          	auipc	ra,0x4
    12ec:	72a080e7          	jalr	1834(ra) # 5a12 <close>
  unlink("unlinkread");
    12f0:	00005517          	auipc	a0,0x5
    12f4:	ec850513          	addi	a0,a0,-312 # 61b8 <csem_up+0x184>
    12f8:	00004097          	auipc	ra,0x4
    12fc:	742080e7          	jalr	1858(ra) # 5a3a <unlink>
}
    1300:	70a2                	ld	ra,40(sp)
    1302:	7402                	ld	s0,32(sp)
    1304:	64e2                	ld	s1,24(sp)
    1306:	6942                	ld	s2,16(sp)
    1308:	69a2                	ld	s3,8(sp)
    130a:	6145                	addi	sp,sp,48
    130c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
    130e:	85ce                	mv	a1,s3
    1310:	00005517          	auipc	a0,0x5
    1314:	62050513          	addi	a0,a0,1568 # 6930 <csem_up+0x8fc>
    1318:	00005097          	auipc	ra,0x5
    131c:	aa4080e7          	jalr	-1372(ra) # 5dbc <printf>
    exit(1);
    1320:	4505                	li	a0,1
    1322:	00004097          	auipc	ra,0x4
    1326:	6c8080e7          	jalr	1736(ra) # 59ea <exit>
    printf("%s: open unlinkread failed\n", s);
    132a:	85ce                	mv	a1,s3
    132c:	00005517          	auipc	a0,0x5
    1330:	62c50513          	addi	a0,a0,1580 # 6958 <csem_up+0x924>
    1334:	00005097          	auipc	ra,0x5
    1338:	a88080e7          	jalr	-1400(ra) # 5dbc <printf>
    exit(1);
    133c:	4505                	li	a0,1
    133e:	00004097          	auipc	ra,0x4
    1342:	6ac080e7          	jalr	1708(ra) # 59ea <exit>
    printf("%s: unlink unlinkread failed\n", s);
    1346:	85ce                	mv	a1,s3
    1348:	00005517          	auipc	a0,0x5
    134c:	63050513          	addi	a0,a0,1584 # 6978 <csem_up+0x944>
    1350:	00005097          	auipc	ra,0x5
    1354:	a6c080e7          	jalr	-1428(ra) # 5dbc <printf>
    exit(1);
    1358:	4505                	li	a0,1
    135a:	00004097          	auipc	ra,0x4
    135e:	690080e7          	jalr	1680(ra) # 59ea <exit>
    printf("%s: unlinkread read failed", s);
    1362:	85ce                	mv	a1,s3
    1364:	00005517          	auipc	a0,0x5
    1368:	63c50513          	addi	a0,a0,1596 # 69a0 <csem_up+0x96c>
    136c:	00005097          	auipc	ra,0x5
    1370:	a50080e7          	jalr	-1456(ra) # 5dbc <printf>
    exit(1);
    1374:	4505                	li	a0,1
    1376:	00004097          	auipc	ra,0x4
    137a:	674080e7          	jalr	1652(ra) # 59ea <exit>
    printf("%s: unlinkread wrong data\n", s);
    137e:	85ce                	mv	a1,s3
    1380:	00005517          	auipc	a0,0x5
    1384:	64050513          	addi	a0,a0,1600 # 69c0 <csem_up+0x98c>
    1388:	00005097          	auipc	ra,0x5
    138c:	a34080e7          	jalr	-1484(ra) # 5dbc <printf>
    exit(1);
    1390:	4505                	li	a0,1
    1392:	00004097          	auipc	ra,0x4
    1396:	658080e7          	jalr	1624(ra) # 59ea <exit>
    printf("%s: unlinkread write failed\n", s);
    139a:	85ce                	mv	a1,s3
    139c:	00005517          	auipc	a0,0x5
    13a0:	64450513          	addi	a0,a0,1604 # 69e0 <csem_up+0x9ac>
    13a4:	00005097          	auipc	ra,0x5
    13a8:	a18080e7          	jalr	-1512(ra) # 5dbc <printf>
    exit(1);
    13ac:	4505                	li	a0,1
    13ae:	00004097          	auipc	ra,0x4
    13b2:	63c080e7          	jalr	1596(ra) # 59ea <exit>

00000000000013b6 <linktest>:
{
    13b6:	1101                	addi	sp,sp,-32
    13b8:	ec06                	sd	ra,24(sp)
    13ba:	e822                	sd	s0,16(sp)
    13bc:	e426                	sd	s1,8(sp)
    13be:	e04a                	sd	s2,0(sp)
    13c0:	1000                	addi	s0,sp,32
    13c2:	892a                	mv	s2,a0
  unlink("lf1");
    13c4:	00005517          	auipc	a0,0x5
    13c8:	63c50513          	addi	a0,a0,1596 # 6a00 <csem_up+0x9cc>
    13cc:	00004097          	auipc	ra,0x4
    13d0:	66e080e7          	jalr	1646(ra) # 5a3a <unlink>
  unlink("lf2");
    13d4:	00005517          	auipc	a0,0x5
    13d8:	63450513          	addi	a0,a0,1588 # 6a08 <csem_up+0x9d4>
    13dc:	00004097          	auipc	ra,0x4
    13e0:	65e080e7          	jalr	1630(ra) # 5a3a <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    13e4:	20200593          	li	a1,514
    13e8:	00005517          	auipc	a0,0x5
    13ec:	61850513          	addi	a0,a0,1560 # 6a00 <csem_up+0x9cc>
    13f0:	00004097          	auipc	ra,0x4
    13f4:	63a080e7          	jalr	1594(ra) # 5a2a <open>
  if(fd < 0){
    13f8:	10054763          	bltz	a0,1506 <linktest+0x150>
    13fc:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
    13fe:	4615                	li	a2,5
    1400:	00005597          	auipc	a1,0x5
    1404:	55058593          	addi	a1,a1,1360 # 6950 <csem_up+0x91c>
    1408:	00004097          	auipc	ra,0x4
    140c:	602080e7          	jalr	1538(ra) # 5a0a <write>
    1410:	4795                	li	a5,5
    1412:	10f51863          	bne	a0,a5,1522 <linktest+0x16c>
  close(fd);
    1416:	8526                	mv	a0,s1
    1418:	00004097          	auipc	ra,0x4
    141c:	5fa080e7          	jalr	1530(ra) # 5a12 <close>
  if(link("lf1", "lf2") < 0){
    1420:	00005597          	auipc	a1,0x5
    1424:	5e858593          	addi	a1,a1,1512 # 6a08 <csem_up+0x9d4>
    1428:	00005517          	auipc	a0,0x5
    142c:	5d850513          	addi	a0,a0,1496 # 6a00 <csem_up+0x9cc>
    1430:	00004097          	auipc	ra,0x4
    1434:	61a080e7          	jalr	1562(ra) # 5a4a <link>
    1438:	10054363          	bltz	a0,153e <linktest+0x188>
  unlink("lf1");
    143c:	00005517          	auipc	a0,0x5
    1440:	5c450513          	addi	a0,a0,1476 # 6a00 <csem_up+0x9cc>
    1444:	00004097          	auipc	ra,0x4
    1448:	5f6080e7          	jalr	1526(ra) # 5a3a <unlink>
  if(open("lf1", 0) >= 0){
    144c:	4581                	li	a1,0
    144e:	00005517          	auipc	a0,0x5
    1452:	5b250513          	addi	a0,a0,1458 # 6a00 <csem_up+0x9cc>
    1456:	00004097          	auipc	ra,0x4
    145a:	5d4080e7          	jalr	1492(ra) # 5a2a <open>
    145e:	0e055e63          	bgez	a0,155a <linktest+0x1a4>
  fd = open("lf2", 0);
    1462:	4581                	li	a1,0
    1464:	00005517          	auipc	a0,0x5
    1468:	5a450513          	addi	a0,a0,1444 # 6a08 <csem_up+0x9d4>
    146c:	00004097          	auipc	ra,0x4
    1470:	5be080e7          	jalr	1470(ra) # 5a2a <open>
    1474:	84aa                	mv	s1,a0
  if(fd < 0){
    1476:	10054063          	bltz	a0,1576 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    147a:	660d                	lui	a2,0x3
    147c:	0000b597          	auipc	a1,0xb
    1480:	b5c58593          	addi	a1,a1,-1188 # bfd8 <buf>
    1484:	00004097          	auipc	ra,0x4
    1488:	57e080e7          	jalr	1406(ra) # 5a02 <read>
    148c:	4795                	li	a5,5
    148e:	10f51263          	bne	a0,a5,1592 <linktest+0x1dc>
  close(fd);
    1492:	8526                	mv	a0,s1
    1494:	00004097          	auipc	ra,0x4
    1498:	57e080e7          	jalr	1406(ra) # 5a12 <close>
  if(link("lf2", "lf2") >= 0){
    149c:	00005597          	auipc	a1,0x5
    14a0:	56c58593          	addi	a1,a1,1388 # 6a08 <csem_up+0x9d4>
    14a4:	852e                	mv	a0,a1
    14a6:	00004097          	auipc	ra,0x4
    14aa:	5a4080e7          	jalr	1444(ra) # 5a4a <link>
    14ae:	10055063          	bgez	a0,15ae <linktest+0x1f8>
  unlink("lf2");
    14b2:	00005517          	auipc	a0,0x5
    14b6:	55650513          	addi	a0,a0,1366 # 6a08 <csem_up+0x9d4>
    14ba:	00004097          	auipc	ra,0x4
    14be:	580080e7          	jalr	1408(ra) # 5a3a <unlink>
  if(link("lf2", "lf1") >= 0){
    14c2:	00005597          	auipc	a1,0x5
    14c6:	53e58593          	addi	a1,a1,1342 # 6a00 <csem_up+0x9cc>
    14ca:	00005517          	auipc	a0,0x5
    14ce:	53e50513          	addi	a0,a0,1342 # 6a08 <csem_up+0x9d4>
    14d2:	00004097          	auipc	ra,0x4
    14d6:	578080e7          	jalr	1400(ra) # 5a4a <link>
    14da:	0e055863          	bgez	a0,15ca <linktest+0x214>
  if(link(".", "lf1") >= 0){
    14de:	00005597          	auipc	a1,0x5
    14e2:	52258593          	addi	a1,a1,1314 # 6a00 <csem_up+0x9cc>
    14e6:	00005517          	auipc	a0,0x5
    14ea:	62a50513          	addi	a0,a0,1578 # 6b10 <csem_up+0xadc>
    14ee:	00004097          	auipc	ra,0x4
    14f2:	55c080e7          	jalr	1372(ra) # 5a4a <link>
    14f6:	0e055863          	bgez	a0,15e6 <linktest+0x230>
}
    14fa:	60e2                	ld	ra,24(sp)
    14fc:	6442                	ld	s0,16(sp)
    14fe:	64a2                	ld	s1,8(sp)
    1500:	6902                	ld	s2,0(sp)
    1502:	6105                	addi	sp,sp,32
    1504:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1506:	85ca                	mv	a1,s2
    1508:	00005517          	auipc	a0,0x5
    150c:	50850513          	addi	a0,a0,1288 # 6a10 <csem_up+0x9dc>
    1510:	00005097          	auipc	ra,0x5
    1514:	8ac080e7          	jalr	-1876(ra) # 5dbc <printf>
    exit(1);
    1518:	4505                	li	a0,1
    151a:	00004097          	auipc	ra,0x4
    151e:	4d0080e7          	jalr	1232(ra) # 59ea <exit>
    printf("%s: write lf1 failed\n", s);
    1522:	85ca                	mv	a1,s2
    1524:	00005517          	auipc	a0,0x5
    1528:	50450513          	addi	a0,a0,1284 # 6a28 <csem_up+0x9f4>
    152c:	00005097          	auipc	ra,0x5
    1530:	890080e7          	jalr	-1904(ra) # 5dbc <printf>
    exit(1);
    1534:	4505                	li	a0,1
    1536:	00004097          	auipc	ra,0x4
    153a:	4b4080e7          	jalr	1204(ra) # 59ea <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    153e:	85ca                	mv	a1,s2
    1540:	00005517          	auipc	a0,0x5
    1544:	50050513          	addi	a0,a0,1280 # 6a40 <csem_up+0xa0c>
    1548:	00005097          	auipc	ra,0x5
    154c:	874080e7          	jalr	-1932(ra) # 5dbc <printf>
    exit(1);
    1550:	4505                	li	a0,1
    1552:	00004097          	auipc	ra,0x4
    1556:	498080e7          	jalr	1176(ra) # 59ea <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    155a:	85ca                	mv	a1,s2
    155c:	00005517          	auipc	a0,0x5
    1560:	50450513          	addi	a0,a0,1284 # 6a60 <csem_up+0xa2c>
    1564:	00005097          	auipc	ra,0x5
    1568:	858080e7          	jalr	-1960(ra) # 5dbc <printf>
    exit(1);
    156c:	4505                	li	a0,1
    156e:	00004097          	auipc	ra,0x4
    1572:	47c080e7          	jalr	1148(ra) # 59ea <exit>
    printf("%s: open lf2 failed\n", s);
    1576:	85ca                	mv	a1,s2
    1578:	00005517          	auipc	a0,0x5
    157c:	51850513          	addi	a0,a0,1304 # 6a90 <csem_up+0xa5c>
    1580:	00005097          	auipc	ra,0x5
    1584:	83c080e7          	jalr	-1988(ra) # 5dbc <printf>
    exit(1);
    1588:	4505                	li	a0,1
    158a:	00004097          	auipc	ra,0x4
    158e:	460080e7          	jalr	1120(ra) # 59ea <exit>
    printf("%s: read lf2 failed\n", s);
    1592:	85ca                	mv	a1,s2
    1594:	00005517          	auipc	a0,0x5
    1598:	51450513          	addi	a0,a0,1300 # 6aa8 <csem_up+0xa74>
    159c:	00005097          	auipc	ra,0x5
    15a0:	820080e7          	jalr	-2016(ra) # 5dbc <printf>
    exit(1);
    15a4:	4505                	li	a0,1
    15a6:	00004097          	auipc	ra,0x4
    15aa:	444080e7          	jalr	1092(ra) # 59ea <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    15ae:	85ca                	mv	a1,s2
    15b0:	00005517          	auipc	a0,0x5
    15b4:	51050513          	addi	a0,a0,1296 # 6ac0 <csem_up+0xa8c>
    15b8:	00005097          	auipc	ra,0x5
    15bc:	804080e7          	jalr	-2044(ra) # 5dbc <printf>
    exit(1);
    15c0:	4505                	li	a0,1
    15c2:	00004097          	auipc	ra,0x4
    15c6:	428080e7          	jalr	1064(ra) # 59ea <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
    15ca:	85ca                	mv	a1,s2
    15cc:	00005517          	auipc	a0,0x5
    15d0:	51c50513          	addi	a0,a0,1308 # 6ae8 <csem_up+0xab4>
    15d4:	00004097          	auipc	ra,0x4
    15d8:	7e8080e7          	jalr	2024(ra) # 5dbc <printf>
    exit(1);
    15dc:	4505                	li	a0,1
    15de:	00004097          	auipc	ra,0x4
    15e2:	40c080e7          	jalr	1036(ra) # 59ea <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    15e6:	85ca                	mv	a1,s2
    15e8:	00005517          	auipc	a0,0x5
    15ec:	53050513          	addi	a0,a0,1328 # 6b18 <csem_up+0xae4>
    15f0:	00004097          	auipc	ra,0x4
    15f4:	7cc080e7          	jalr	1996(ra) # 5dbc <printf>
    exit(1);
    15f8:	4505                	li	a0,1
    15fa:	00004097          	auipc	ra,0x4
    15fe:	3f0080e7          	jalr	1008(ra) # 59ea <exit>

0000000000001602 <validatetest>:
{
    1602:	7139                	addi	sp,sp,-64
    1604:	fc06                	sd	ra,56(sp)
    1606:	f822                	sd	s0,48(sp)
    1608:	f426                	sd	s1,40(sp)
    160a:	f04a                	sd	s2,32(sp)
    160c:	ec4e                	sd	s3,24(sp)
    160e:	e852                	sd	s4,16(sp)
    1610:	e456                	sd	s5,8(sp)
    1612:	e05a                	sd	s6,0(sp)
    1614:	0080                	addi	s0,sp,64
    1616:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1618:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    161a:	00005997          	auipc	s3,0x5
    161e:	51e98993          	addi	s3,s3,1310 # 6b38 <csem_up+0xb04>
    1622:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1624:	6a85                	lui	s5,0x1
    1626:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    162a:	85a6                	mv	a1,s1
    162c:	854e                	mv	a0,s3
    162e:	00004097          	auipc	ra,0x4
    1632:	41c080e7          	jalr	1052(ra) # 5a4a <link>
    1636:	01251f63          	bne	a0,s2,1654 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    163a:	94d6                	add	s1,s1,s5
    163c:	ff4497e3          	bne	s1,s4,162a <validatetest+0x28>
}
    1640:	70e2                	ld	ra,56(sp)
    1642:	7442                	ld	s0,48(sp)
    1644:	74a2                	ld	s1,40(sp)
    1646:	7902                	ld	s2,32(sp)
    1648:	69e2                	ld	s3,24(sp)
    164a:	6a42                	ld	s4,16(sp)
    164c:	6aa2                	ld	s5,8(sp)
    164e:	6b02                	ld	s6,0(sp)
    1650:	6121                	addi	sp,sp,64
    1652:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1654:	85da                	mv	a1,s6
    1656:	00005517          	auipc	a0,0x5
    165a:	4f250513          	addi	a0,a0,1266 # 6b48 <csem_up+0xb14>
    165e:	00004097          	auipc	ra,0x4
    1662:	75e080e7          	jalr	1886(ra) # 5dbc <printf>
      exit(1);
    1666:	4505                	li	a0,1
    1668:	00004097          	auipc	ra,0x4
    166c:	382080e7          	jalr	898(ra) # 59ea <exit>

0000000000001670 <copyinstr2>:
{
    1670:	7155                	addi	sp,sp,-208
    1672:	e586                	sd	ra,200(sp)
    1674:	e1a2                	sd	s0,192(sp)
    1676:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1678:	f6840793          	addi	a5,s0,-152
    167c:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    1680:	07800713          	li	a4,120
    1684:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1688:	0785                	addi	a5,a5,1
    168a:	fed79de3          	bne	a5,a3,1684 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    168e:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1692:	f6840513          	addi	a0,s0,-152
    1696:	00004097          	auipc	ra,0x4
    169a:	3a4080e7          	jalr	932(ra) # 5a3a <unlink>
  if(ret != -1){
    169e:	57fd                	li	a5,-1
    16a0:	0ef51063          	bne	a0,a5,1780 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    16a4:	20100593          	li	a1,513
    16a8:	f6840513          	addi	a0,s0,-152
    16ac:	00004097          	auipc	ra,0x4
    16b0:	37e080e7          	jalr	894(ra) # 5a2a <open>
  if(fd != -1){
    16b4:	57fd                	li	a5,-1
    16b6:	0ef51563          	bne	a0,a5,17a0 <copyinstr2+0x130>
  ret = link(b, b);
    16ba:	f6840593          	addi	a1,s0,-152
    16be:	852e                	mv	a0,a1
    16c0:	00004097          	auipc	ra,0x4
    16c4:	38a080e7          	jalr	906(ra) # 5a4a <link>
  if(ret != -1){
    16c8:	57fd                	li	a5,-1
    16ca:	0ef51b63          	bne	a0,a5,17c0 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    16ce:	00006797          	auipc	a5,0x6
    16d2:	25278793          	addi	a5,a5,594 # 7920 <csem_up+0x18ec>
    16d6:	f4f43c23          	sd	a5,-168(s0)
    16da:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    16de:	f5840593          	addi	a1,s0,-168
    16e2:	f6840513          	addi	a0,s0,-152
    16e6:	00004097          	auipc	ra,0x4
    16ea:	33c080e7          	jalr	828(ra) # 5a22 <exec>
  if(ret != -1){
    16ee:	57fd                	li	a5,-1
    16f0:	0ef51963          	bne	a0,a5,17e2 <copyinstr2+0x172>
  int pid = fork();
    16f4:	00004097          	auipc	ra,0x4
    16f8:	2ee080e7          	jalr	750(ra) # 59e2 <fork>
  if(pid < 0){
    16fc:	10054363          	bltz	a0,1802 <copyinstr2+0x192>
  if(pid == 0){
    1700:	12051463          	bnez	a0,1828 <copyinstr2+0x1b8>
    1704:	00007797          	auipc	a5,0x7
    1708:	1bc78793          	addi	a5,a5,444 # 88c0 <big.0>
    170c:	00008697          	auipc	a3,0x8
    1710:	1b468693          	addi	a3,a3,436 # 98c0 <__global_pointer$+0x920>
      big[i] = 'x';
    1714:	07800713          	li	a4,120
    1718:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    171c:	0785                	addi	a5,a5,1
    171e:	fed79de3          	bne	a5,a3,1718 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1722:	00008797          	auipc	a5,0x8
    1726:	18078f23          	sb	zero,414(a5) # 98c0 <__global_pointer$+0x920>
    char *args2[] = { big, big, big, 0 };
    172a:	00007797          	auipc	a5,0x7
    172e:	d8678793          	addi	a5,a5,-634 # 84b0 <csem_up+0x247c>
    1732:	6390                	ld	a2,0(a5)
    1734:	6794                	ld	a3,8(a5)
    1736:	6b98                	ld	a4,16(a5)
    1738:	6f9c                	ld	a5,24(a5)
    173a:	f2c43823          	sd	a2,-208(s0)
    173e:	f2d43c23          	sd	a3,-200(s0)
    1742:	f4e43023          	sd	a4,-192(s0)
    1746:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    174a:	f3040593          	addi	a1,s0,-208
    174e:	00005517          	auipc	a0,0x5
    1752:	e2a50513          	addi	a0,a0,-470 # 6578 <csem_up+0x544>
    1756:	00004097          	auipc	ra,0x4
    175a:	2cc080e7          	jalr	716(ra) # 5a22 <exec>
    if(ret != -1){
    175e:	57fd                	li	a5,-1
    1760:	0af50e63          	beq	a0,a5,181c <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1764:	55fd                	li	a1,-1
    1766:	00005517          	auipc	a0,0x5
    176a:	48a50513          	addi	a0,a0,1162 # 6bf0 <csem_up+0xbbc>
    176e:	00004097          	auipc	ra,0x4
    1772:	64e080e7          	jalr	1614(ra) # 5dbc <printf>
      exit(1);
    1776:	4505                	li	a0,1
    1778:	00004097          	auipc	ra,0x4
    177c:	272080e7          	jalr	626(ra) # 59ea <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1780:	862a                	mv	a2,a0
    1782:	f6840593          	addi	a1,s0,-152
    1786:	00005517          	auipc	a0,0x5
    178a:	3e250513          	addi	a0,a0,994 # 6b68 <csem_up+0xb34>
    178e:	00004097          	auipc	ra,0x4
    1792:	62e080e7          	jalr	1582(ra) # 5dbc <printf>
    exit(1);
    1796:	4505                	li	a0,1
    1798:	00004097          	auipc	ra,0x4
    179c:	252080e7          	jalr	594(ra) # 59ea <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    17a0:	862a                	mv	a2,a0
    17a2:	f6840593          	addi	a1,s0,-152
    17a6:	00005517          	auipc	a0,0x5
    17aa:	3e250513          	addi	a0,a0,994 # 6b88 <csem_up+0xb54>
    17ae:	00004097          	auipc	ra,0x4
    17b2:	60e080e7          	jalr	1550(ra) # 5dbc <printf>
    exit(1);
    17b6:	4505                	li	a0,1
    17b8:	00004097          	auipc	ra,0x4
    17bc:	232080e7          	jalr	562(ra) # 59ea <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    17c0:	86aa                	mv	a3,a0
    17c2:	f6840613          	addi	a2,s0,-152
    17c6:	85b2                	mv	a1,a2
    17c8:	00005517          	auipc	a0,0x5
    17cc:	3e050513          	addi	a0,a0,992 # 6ba8 <csem_up+0xb74>
    17d0:	00004097          	auipc	ra,0x4
    17d4:	5ec080e7          	jalr	1516(ra) # 5dbc <printf>
    exit(1);
    17d8:	4505                	li	a0,1
    17da:	00004097          	auipc	ra,0x4
    17de:	210080e7          	jalr	528(ra) # 59ea <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    17e2:	567d                	li	a2,-1
    17e4:	f6840593          	addi	a1,s0,-152
    17e8:	00005517          	auipc	a0,0x5
    17ec:	3e850513          	addi	a0,a0,1000 # 6bd0 <csem_up+0xb9c>
    17f0:	00004097          	auipc	ra,0x4
    17f4:	5cc080e7          	jalr	1484(ra) # 5dbc <printf>
    exit(1);
    17f8:	4505                	li	a0,1
    17fa:	00004097          	auipc	ra,0x4
    17fe:	1f0080e7          	jalr	496(ra) # 59ea <exit>
    printf("fork failed\n");
    1802:	00005517          	auipc	a0,0x5
    1806:	5f650513          	addi	a0,a0,1526 # 6df8 <csem_up+0xdc4>
    180a:	00004097          	auipc	ra,0x4
    180e:	5b2080e7          	jalr	1458(ra) # 5dbc <printf>
    exit(1);
    1812:	4505                	li	a0,1
    1814:	00004097          	auipc	ra,0x4
    1818:	1d6080e7          	jalr	470(ra) # 59ea <exit>
    exit(747); // OK
    181c:	2eb00513          	li	a0,747
    1820:	00004097          	auipc	ra,0x4
    1824:	1ca080e7          	jalr	458(ra) # 59ea <exit>
  int st = 0;
    1828:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    182c:	f5440513          	addi	a0,s0,-172
    1830:	00004097          	auipc	ra,0x4
    1834:	1c2080e7          	jalr	450(ra) # 59f2 <wait>
  if(st != 747){
    1838:	f5442703          	lw	a4,-172(s0)
    183c:	2eb00793          	li	a5,747
    1840:	00f71663          	bne	a4,a5,184c <copyinstr2+0x1dc>
}
    1844:	60ae                	ld	ra,200(sp)
    1846:	640e                	ld	s0,192(sp)
    1848:	6169                	addi	sp,sp,208
    184a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    184c:	00005517          	auipc	a0,0x5
    1850:	3cc50513          	addi	a0,a0,972 # 6c18 <csem_up+0xbe4>
    1854:	00004097          	auipc	ra,0x4
    1858:	568080e7          	jalr	1384(ra) # 5dbc <printf>
    exit(1);
    185c:	4505                	li	a0,1
    185e:	00004097          	auipc	ra,0x4
    1862:	18c080e7          	jalr	396(ra) # 59ea <exit>

0000000000001866 <exectest>:
{
    1866:	715d                	addi	sp,sp,-80
    1868:	e486                	sd	ra,72(sp)
    186a:	e0a2                	sd	s0,64(sp)
    186c:	fc26                	sd	s1,56(sp)
    186e:	f84a                	sd	s2,48(sp)
    1870:	0880                	addi	s0,sp,80
    1872:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1874:	00005797          	auipc	a5,0x5
    1878:	d0478793          	addi	a5,a5,-764 # 6578 <csem_up+0x544>
    187c:	fcf43023          	sd	a5,-64(s0)
    1880:	00005797          	auipc	a5,0x5
    1884:	3c878793          	addi	a5,a5,968 # 6c48 <csem_up+0xc14>
    1888:	fcf43423          	sd	a5,-56(s0)
    188c:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1890:	00005517          	auipc	a0,0x5
    1894:	3c050513          	addi	a0,a0,960 # 6c50 <csem_up+0xc1c>
    1898:	00004097          	auipc	ra,0x4
    189c:	1a2080e7          	jalr	418(ra) # 5a3a <unlink>
  pid = fork();
    18a0:	00004097          	auipc	ra,0x4
    18a4:	142080e7          	jalr	322(ra) # 59e2 <fork>
  if(pid < 0) {
    18a8:	04054663          	bltz	a0,18f4 <exectest+0x8e>
    18ac:	84aa                	mv	s1,a0
  if(pid == 0) {
    18ae:	e959                	bnez	a0,1944 <exectest+0xde>
    close(1);
    18b0:	4505                	li	a0,1
    18b2:	00004097          	auipc	ra,0x4
    18b6:	160080e7          	jalr	352(ra) # 5a12 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    18ba:	20100593          	li	a1,513
    18be:	00005517          	auipc	a0,0x5
    18c2:	39250513          	addi	a0,a0,914 # 6c50 <csem_up+0xc1c>
    18c6:	00004097          	auipc	ra,0x4
    18ca:	164080e7          	jalr	356(ra) # 5a2a <open>
    if(fd < 0) {
    18ce:	04054163          	bltz	a0,1910 <exectest+0xaa>
    if(fd != 1) {
    18d2:	4785                	li	a5,1
    18d4:	04f50c63          	beq	a0,a5,192c <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    18d8:	85ca                	mv	a1,s2
    18da:	00005517          	auipc	a0,0x5
    18de:	39650513          	addi	a0,a0,918 # 6c70 <csem_up+0xc3c>
    18e2:	00004097          	auipc	ra,0x4
    18e6:	4da080e7          	jalr	1242(ra) # 5dbc <printf>
      exit(1);
    18ea:	4505                	li	a0,1
    18ec:	00004097          	auipc	ra,0x4
    18f0:	0fe080e7          	jalr	254(ra) # 59ea <exit>
     printf("%s: fork failed\n", s);
    18f4:	85ca                	mv	a1,s2
    18f6:	00005517          	auipc	a0,0x5
    18fa:	a3a50513          	addi	a0,a0,-1478 # 6330 <csem_up+0x2fc>
    18fe:	00004097          	auipc	ra,0x4
    1902:	4be080e7          	jalr	1214(ra) # 5dbc <printf>
     exit(1);
    1906:	4505                	li	a0,1
    1908:	00004097          	auipc	ra,0x4
    190c:	0e2080e7          	jalr	226(ra) # 59ea <exit>
      printf("%s: create failed\n", s);
    1910:	85ca                	mv	a1,s2
    1912:	00005517          	auipc	a0,0x5
    1916:	34650513          	addi	a0,a0,838 # 6c58 <csem_up+0xc24>
    191a:	00004097          	auipc	ra,0x4
    191e:	4a2080e7          	jalr	1186(ra) # 5dbc <printf>
      exit(1);
    1922:	4505                	li	a0,1
    1924:	00004097          	auipc	ra,0x4
    1928:	0c6080e7          	jalr	198(ra) # 59ea <exit>
    if(exec("echo", echoargv) < 0){
    192c:	fc040593          	addi	a1,s0,-64
    1930:	00005517          	auipc	a0,0x5
    1934:	c4850513          	addi	a0,a0,-952 # 6578 <csem_up+0x544>
    1938:	00004097          	auipc	ra,0x4
    193c:	0ea080e7          	jalr	234(ra) # 5a22 <exec>
    1940:	02054163          	bltz	a0,1962 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1944:	fdc40513          	addi	a0,s0,-36
    1948:	00004097          	auipc	ra,0x4
    194c:	0aa080e7          	jalr	170(ra) # 59f2 <wait>
    1950:	02951763          	bne	a0,s1,197e <exectest+0x118>
  if(xstatus != 0)
    1954:	fdc42503          	lw	a0,-36(s0)
    1958:	cd0d                	beqz	a0,1992 <exectest+0x12c>
    exit(xstatus);
    195a:	00004097          	auipc	ra,0x4
    195e:	090080e7          	jalr	144(ra) # 59ea <exit>
      printf("%s: exec echo failed\n", s);
    1962:	85ca                	mv	a1,s2
    1964:	00005517          	auipc	a0,0x5
    1968:	31c50513          	addi	a0,a0,796 # 6c80 <csem_up+0xc4c>
    196c:	00004097          	auipc	ra,0x4
    1970:	450080e7          	jalr	1104(ra) # 5dbc <printf>
      exit(1);
    1974:	4505                	li	a0,1
    1976:	00004097          	auipc	ra,0x4
    197a:	074080e7          	jalr	116(ra) # 59ea <exit>
    printf("%s: wait failed!\n", s);
    197e:	85ca                	mv	a1,s2
    1980:	00005517          	auipc	a0,0x5
    1984:	31850513          	addi	a0,a0,792 # 6c98 <csem_up+0xc64>
    1988:	00004097          	auipc	ra,0x4
    198c:	434080e7          	jalr	1076(ra) # 5dbc <printf>
    1990:	b7d1                	j	1954 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1992:	4581                	li	a1,0
    1994:	00005517          	auipc	a0,0x5
    1998:	2bc50513          	addi	a0,a0,700 # 6c50 <csem_up+0xc1c>
    199c:	00004097          	auipc	ra,0x4
    19a0:	08e080e7          	jalr	142(ra) # 5a2a <open>
  if(fd < 0) {
    19a4:	02054a63          	bltz	a0,19d8 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    19a8:	4609                	li	a2,2
    19aa:	fb840593          	addi	a1,s0,-72
    19ae:	00004097          	auipc	ra,0x4
    19b2:	054080e7          	jalr	84(ra) # 5a02 <read>
    19b6:	4789                	li	a5,2
    19b8:	02f50e63          	beq	a0,a5,19f4 <exectest+0x18e>
    printf("%s: read failed\n", s);
    19bc:	85ca                	mv	a1,s2
    19be:	00005517          	auipc	a0,0x5
    19c2:	30a50513          	addi	a0,a0,778 # 6cc8 <csem_up+0xc94>
    19c6:	00004097          	auipc	ra,0x4
    19ca:	3f6080e7          	jalr	1014(ra) # 5dbc <printf>
    exit(1);
    19ce:	4505                	li	a0,1
    19d0:	00004097          	auipc	ra,0x4
    19d4:	01a080e7          	jalr	26(ra) # 59ea <exit>
    printf("%s: open failed\n", s);
    19d8:	85ca                	mv	a1,s2
    19da:	00005517          	auipc	a0,0x5
    19de:	2d650513          	addi	a0,a0,726 # 6cb0 <csem_up+0xc7c>
    19e2:	00004097          	auipc	ra,0x4
    19e6:	3da080e7          	jalr	986(ra) # 5dbc <printf>
    exit(1);
    19ea:	4505                	li	a0,1
    19ec:	00004097          	auipc	ra,0x4
    19f0:	ffe080e7          	jalr	-2(ra) # 59ea <exit>
  unlink("echo-ok");
    19f4:	00005517          	auipc	a0,0x5
    19f8:	25c50513          	addi	a0,a0,604 # 6c50 <csem_up+0xc1c>
    19fc:	00004097          	auipc	ra,0x4
    1a00:	03e080e7          	jalr	62(ra) # 5a3a <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1a04:	fb844703          	lbu	a4,-72(s0)
    1a08:	04f00793          	li	a5,79
    1a0c:	00f71863          	bne	a4,a5,1a1c <exectest+0x1b6>
    1a10:	fb944703          	lbu	a4,-71(s0)
    1a14:	04b00793          	li	a5,75
    1a18:	02f70063          	beq	a4,a5,1a38 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1a1c:	85ca                	mv	a1,s2
    1a1e:	00005517          	auipc	a0,0x5
    1a22:	2c250513          	addi	a0,a0,706 # 6ce0 <csem_up+0xcac>
    1a26:	00004097          	auipc	ra,0x4
    1a2a:	396080e7          	jalr	918(ra) # 5dbc <printf>
    exit(1);
    1a2e:	4505                	li	a0,1
    1a30:	00004097          	auipc	ra,0x4
    1a34:	fba080e7          	jalr	-70(ra) # 59ea <exit>
    exit(0);
    1a38:	4501                	li	a0,0
    1a3a:	00004097          	auipc	ra,0x4
    1a3e:	fb0080e7          	jalr	-80(ra) # 59ea <exit>

0000000000001a42 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(char *s)
{
    1a42:	7179                	addi	sp,sp,-48
    1a44:	f406                	sd	ra,40(sp)
    1a46:	f022                	sd	s0,32(sp)
    1a48:	ec26                	sd	s1,24(sp)
    1a4a:	1800                	addi	s0,sp,48
    1a4c:	84aa                	mv	s1,a0
  int pid, fd, xstatus;

  unlink("bigarg-ok");
    1a4e:	00005517          	auipc	a0,0x5
    1a52:	2aa50513          	addi	a0,a0,682 # 6cf8 <csem_up+0xcc4>
    1a56:	00004097          	auipc	ra,0x4
    1a5a:	fe4080e7          	jalr	-28(ra) # 5a3a <unlink>
  pid = fork();
    1a5e:	00004097          	auipc	ra,0x4
    1a62:	f84080e7          	jalr	-124(ra) # 59e2 <fork>
  if(pid == 0){
    1a66:	c121                	beqz	a0,1aa6 <bigargtest+0x64>
    args[MAXARG-1] = 0;
    exec("echo", args);
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit(0);
  } else if(pid < 0){
    1a68:	0a054063          	bltz	a0,1b08 <bigargtest+0xc6>
    printf("%s: bigargtest: fork failed\n", s);
    exit(1);
  }
  
  wait(&xstatus);
    1a6c:	fdc40513          	addi	a0,s0,-36
    1a70:	00004097          	auipc	ra,0x4
    1a74:	f82080e7          	jalr	-126(ra) # 59f2 <wait>
  if(xstatus != 0)
    1a78:	fdc42503          	lw	a0,-36(s0)
    1a7c:	e545                	bnez	a0,1b24 <bigargtest+0xe2>
    exit(xstatus);
  fd = open("bigarg-ok", 0);
    1a7e:	4581                	li	a1,0
    1a80:	00005517          	auipc	a0,0x5
    1a84:	27850513          	addi	a0,a0,632 # 6cf8 <csem_up+0xcc4>
    1a88:	00004097          	auipc	ra,0x4
    1a8c:	fa2080e7          	jalr	-94(ra) # 5a2a <open>
  if(fd < 0){
    1a90:	08054e63          	bltz	a0,1b2c <bigargtest+0xea>
    printf("%s: bigarg test failed!\n", s);
    exit(1);
  }
  close(fd);
    1a94:	00004097          	auipc	ra,0x4
    1a98:	f7e080e7          	jalr	-130(ra) # 5a12 <close>
}
    1a9c:	70a2                	ld	ra,40(sp)
    1a9e:	7402                	ld	s0,32(sp)
    1aa0:	64e2                	ld	s1,24(sp)
    1aa2:	6145                	addi	sp,sp,48
    1aa4:	8082                	ret
    1aa6:	00007797          	auipc	a5,0x7
    1aaa:	d1a78793          	addi	a5,a5,-742 # 87c0 <args.1>
    1aae:	00007697          	auipc	a3,0x7
    1ab2:	e0a68693          	addi	a3,a3,-502 # 88b8 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    1ab6:	00005717          	auipc	a4,0x5
    1aba:	25270713          	addi	a4,a4,594 # 6d08 <csem_up+0xcd4>
    1abe:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    1ac0:	07a1                	addi	a5,a5,8
    1ac2:	fed79ee3          	bne	a5,a3,1abe <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    1ac6:	00007597          	auipc	a1,0x7
    1aca:	cfa58593          	addi	a1,a1,-774 # 87c0 <args.1>
    1ace:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    1ad2:	00005517          	auipc	a0,0x5
    1ad6:	aa650513          	addi	a0,a0,-1370 # 6578 <csem_up+0x544>
    1ada:	00004097          	auipc	ra,0x4
    1ade:	f48080e7          	jalr	-184(ra) # 5a22 <exec>
    fd = open("bigarg-ok", O_CREATE);
    1ae2:	20000593          	li	a1,512
    1ae6:	00005517          	auipc	a0,0x5
    1aea:	21250513          	addi	a0,a0,530 # 6cf8 <csem_up+0xcc4>
    1aee:	00004097          	auipc	ra,0x4
    1af2:	f3c080e7          	jalr	-196(ra) # 5a2a <open>
    close(fd);
    1af6:	00004097          	auipc	ra,0x4
    1afa:	f1c080e7          	jalr	-228(ra) # 5a12 <close>
    exit(0);
    1afe:	4501                	li	a0,0
    1b00:	00004097          	auipc	ra,0x4
    1b04:	eea080e7          	jalr	-278(ra) # 59ea <exit>
    printf("%s: bigargtest: fork failed\n", s);
    1b08:	85a6                	mv	a1,s1
    1b0a:	00005517          	auipc	a0,0x5
    1b0e:	2de50513          	addi	a0,a0,734 # 6de8 <csem_up+0xdb4>
    1b12:	00004097          	auipc	ra,0x4
    1b16:	2aa080e7          	jalr	682(ra) # 5dbc <printf>
    exit(1);
    1b1a:	4505                	li	a0,1
    1b1c:	00004097          	auipc	ra,0x4
    1b20:	ece080e7          	jalr	-306(ra) # 59ea <exit>
    exit(xstatus);
    1b24:	00004097          	auipc	ra,0x4
    1b28:	ec6080e7          	jalr	-314(ra) # 59ea <exit>
    printf("%s: bigarg test failed!\n", s);
    1b2c:	85a6                	mv	a1,s1
    1b2e:	00005517          	auipc	a0,0x5
    1b32:	2da50513          	addi	a0,a0,730 # 6e08 <csem_up+0xdd4>
    1b36:	00004097          	auipc	ra,0x4
    1b3a:	286080e7          	jalr	646(ra) # 5dbc <printf>
    exit(1);
    1b3e:	4505                	li	a0,1
    1b40:	00004097          	auipc	ra,0x4
    1b44:	eaa080e7          	jalr	-342(ra) # 59ea <exit>

0000000000001b48 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1b48:	7179                	addi	sp,sp,-48
    1b4a:	f406                	sd	ra,40(sp)
    1b4c:	f022                	sd	s0,32(sp)
    1b4e:	ec26                	sd	s1,24(sp)
    1b50:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1b52:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1b56:	00007497          	auipc	s1,0x7
    1b5a:	c4a4b483          	ld	s1,-950(s1) # 87a0 <__SDATA_BEGIN__>
    1b5e:	fd840593          	addi	a1,s0,-40
    1b62:	8526                	mv	a0,s1
    1b64:	00004097          	auipc	ra,0x4
    1b68:	ebe080e7          	jalr	-322(ra) # 5a22 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1b6c:	8526                	mv	a0,s1
    1b6e:	00004097          	auipc	ra,0x4
    1b72:	e8c080e7          	jalr	-372(ra) # 59fa <pipe>

  exit(0);
    1b76:	4501                	li	a0,0
    1b78:	00004097          	auipc	ra,0x4
    1b7c:	e72080e7          	jalr	-398(ra) # 59ea <exit>

0000000000001b80 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1b80:	7139                	addi	sp,sp,-64
    1b82:	fc06                	sd	ra,56(sp)
    1b84:	f822                	sd	s0,48(sp)
    1b86:	f426                	sd	s1,40(sp)
    1b88:	f04a                	sd	s2,32(sp)
    1b8a:	ec4e                	sd	s3,24(sp)
    1b8c:	0080                	addi	s0,sp,64
    1b8e:	64b1                	lui	s1,0xc
    1b90:	35048493          	addi	s1,s1,848 # c350 <buf+0x378>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1b94:	597d                	li	s2,-1
    1b96:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1b9a:	00005997          	auipc	s3,0x5
    1b9e:	9de98993          	addi	s3,s3,-1570 # 6578 <csem_up+0x544>
    argv[0] = (char*)0xffffffff;
    1ba2:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1ba6:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1baa:	fc040593          	addi	a1,s0,-64
    1bae:	854e                	mv	a0,s3
    1bb0:	00004097          	auipc	ra,0x4
    1bb4:	e72080e7          	jalr	-398(ra) # 5a22 <exec>
  for(int i = 0; i < 50000; i++){
    1bb8:	34fd                	addiw	s1,s1,-1
    1bba:	f4e5                	bnez	s1,1ba2 <badarg+0x22>
  }
  
  exit(0);
    1bbc:	4501                	li	a0,0
    1bbe:	00004097          	auipc	ra,0x4
    1bc2:	e2c080e7          	jalr	-468(ra) # 59ea <exit>

0000000000001bc6 <copyinstr3>:
{
    1bc6:	7179                	addi	sp,sp,-48
    1bc8:	f406                	sd	ra,40(sp)
    1bca:	f022                	sd	s0,32(sp)
    1bcc:	ec26                	sd	s1,24(sp)
    1bce:	1800                	addi	s0,sp,48
  sbrk(8192);
    1bd0:	6509                	lui	a0,0x2
    1bd2:	00004097          	auipc	ra,0x4
    1bd6:	ea0080e7          	jalr	-352(ra) # 5a72 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1bda:	4501                	li	a0,0
    1bdc:	00004097          	auipc	ra,0x4
    1be0:	e96080e7          	jalr	-362(ra) # 5a72 <sbrk>
  if((top % PGSIZE) != 0){
    1be4:	03451793          	slli	a5,a0,0x34
    1be8:	e3c9                	bnez	a5,1c6a <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    1bea:	4501                	li	a0,0
    1bec:	00004097          	auipc	ra,0x4
    1bf0:	e86080e7          	jalr	-378(ra) # 5a72 <sbrk>
  if(top % PGSIZE){
    1bf4:	03451793          	slli	a5,a0,0x34
    1bf8:	e3d9                	bnez	a5,1c7e <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    1bfa:	fff50493          	addi	s1,a0,-1 # 1fff <openiputtest+0x49>
  *b = 'x';
    1bfe:	07800793          	li	a5,120
    1c02:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1c06:	8526                	mv	a0,s1
    1c08:	00004097          	auipc	ra,0x4
    1c0c:	e32080e7          	jalr	-462(ra) # 5a3a <unlink>
  if(ret != -1){
    1c10:	57fd                	li	a5,-1
    1c12:	08f51363          	bne	a0,a5,1c98 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    1c16:	20100593          	li	a1,513
    1c1a:	8526                	mv	a0,s1
    1c1c:	00004097          	auipc	ra,0x4
    1c20:	e0e080e7          	jalr	-498(ra) # 5a2a <open>
  if(fd != -1){
    1c24:	57fd                	li	a5,-1
    1c26:	08f51863          	bne	a0,a5,1cb6 <copyinstr3+0xf0>
  ret = link(b, b);
    1c2a:	85a6                	mv	a1,s1
    1c2c:	8526                	mv	a0,s1
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	e1c080e7          	jalr	-484(ra) # 5a4a <link>
  if(ret != -1){
    1c36:	57fd                	li	a5,-1
    1c38:	08f51e63          	bne	a0,a5,1cd4 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    1c3c:	00006797          	auipc	a5,0x6
    1c40:	ce478793          	addi	a5,a5,-796 # 7920 <csem_up+0x18ec>
    1c44:	fcf43823          	sd	a5,-48(s0)
    1c48:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1c4c:	fd040593          	addi	a1,s0,-48
    1c50:	8526                	mv	a0,s1
    1c52:	00004097          	auipc	ra,0x4
    1c56:	dd0080e7          	jalr	-560(ra) # 5a22 <exec>
  if(ret != -1){
    1c5a:	57fd                	li	a5,-1
    1c5c:	08f51c63          	bne	a0,a5,1cf4 <copyinstr3+0x12e>
}
    1c60:	70a2                	ld	ra,40(sp)
    1c62:	7402                	ld	s0,32(sp)
    1c64:	64e2                	ld	s1,24(sp)
    1c66:	6145                	addi	sp,sp,48
    1c68:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1c6a:	0347d513          	srli	a0,a5,0x34
    1c6e:	6785                	lui	a5,0x1
    1c70:	40a7853b          	subw	a0,a5,a0
    1c74:	00004097          	auipc	ra,0x4
    1c78:	dfe080e7          	jalr	-514(ra) # 5a72 <sbrk>
    1c7c:	b7bd                	j	1bea <copyinstr3+0x24>
    printf("oops\n");
    1c7e:	00005517          	auipc	a0,0x5
    1c82:	1aa50513          	addi	a0,a0,426 # 6e28 <csem_up+0xdf4>
    1c86:	00004097          	auipc	ra,0x4
    1c8a:	136080e7          	jalr	310(ra) # 5dbc <printf>
    exit(1);
    1c8e:	4505                	li	a0,1
    1c90:	00004097          	auipc	ra,0x4
    1c94:	d5a080e7          	jalr	-678(ra) # 59ea <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1c98:	862a                	mv	a2,a0
    1c9a:	85a6                	mv	a1,s1
    1c9c:	00005517          	auipc	a0,0x5
    1ca0:	ecc50513          	addi	a0,a0,-308 # 6b68 <csem_up+0xb34>
    1ca4:	00004097          	auipc	ra,0x4
    1ca8:	118080e7          	jalr	280(ra) # 5dbc <printf>
    exit(1);
    1cac:	4505                	li	a0,1
    1cae:	00004097          	auipc	ra,0x4
    1cb2:	d3c080e7          	jalr	-708(ra) # 59ea <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1cb6:	862a                	mv	a2,a0
    1cb8:	85a6                	mv	a1,s1
    1cba:	00005517          	auipc	a0,0x5
    1cbe:	ece50513          	addi	a0,a0,-306 # 6b88 <csem_up+0xb54>
    1cc2:	00004097          	auipc	ra,0x4
    1cc6:	0fa080e7          	jalr	250(ra) # 5dbc <printf>
    exit(1);
    1cca:	4505                	li	a0,1
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	d1e080e7          	jalr	-738(ra) # 59ea <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1cd4:	86aa                	mv	a3,a0
    1cd6:	8626                	mv	a2,s1
    1cd8:	85a6                	mv	a1,s1
    1cda:	00005517          	auipc	a0,0x5
    1cde:	ece50513          	addi	a0,a0,-306 # 6ba8 <csem_up+0xb74>
    1ce2:	00004097          	auipc	ra,0x4
    1ce6:	0da080e7          	jalr	218(ra) # 5dbc <printf>
    exit(1);
    1cea:	4505                	li	a0,1
    1cec:	00004097          	auipc	ra,0x4
    1cf0:	cfe080e7          	jalr	-770(ra) # 59ea <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1cf4:	567d                	li	a2,-1
    1cf6:	85a6                	mv	a1,s1
    1cf8:	00005517          	auipc	a0,0x5
    1cfc:	ed850513          	addi	a0,a0,-296 # 6bd0 <csem_up+0xb9c>
    1d00:	00004097          	auipc	ra,0x4
    1d04:	0bc080e7          	jalr	188(ra) # 5dbc <printf>
    exit(1);
    1d08:	4505                	li	a0,1
    1d0a:	00004097          	auipc	ra,0x4
    1d0e:	ce0080e7          	jalr	-800(ra) # 59ea <exit>

0000000000001d12 <rwsbrk>:
{
    1d12:	1101                	addi	sp,sp,-32
    1d14:	ec06                	sd	ra,24(sp)
    1d16:	e822                	sd	s0,16(sp)
    1d18:	e426                	sd	s1,8(sp)
    1d1a:	e04a                	sd	s2,0(sp)
    1d1c:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    1d1e:	6509                	lui	a0,0x2
    1d20:	00004097          	auipc	ra,0x4
    1d24:	d52080e7          	jalr	-686(ra) # 5a72 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    1d28:	57fd                	li	a5,-1
    1d2a:	06f50363          	beq	a0,a5,1d90 <rwsbrk+0x7e>
    1d2e:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    1d30:	7579                	lui	a0,0xffffe
    1d32:	00004097          	auipc	ra,0x4
    1d36:	d40080e7          	jalr	-704(ra) # 5a72 <sbrk>
    1d3a:	57fd                	li	a5,-1
    1d3c:	06f50763          	beq	a0,a5,1daa <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    1d40:	20100593          	li	a1,513
    1d44:	00004517          	auipc	a0,0x4
    1d48:	3dc50513          	addi	a0,a0,988 # 6120 <csem_up+0xec>
    1d4c:	00004097          	auipc	ra,0x4
    1d50:	cde080e7          	jalr	-802(ra) # 5a2a <open>
    1d54:	892a                	mv	s2,a0
  if(fd < 0){
    1d56:	06054763          	bltz	a0,1dc4 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    1d5a:	6505                	lui	a0,0x1
    1d5c:	94aa                	add	s1,s1,a0
    1d5e:	40000613          	li	a2,1024
    1d62:	85a6                	mv	a1,s1
    1d64:	854a                	mv	a0,s2
    1d66:	00004097          	auipc	ra,0x4
    1d6a:	ca4080e7          	jalr	-860(ra) # 5a0a <write>
    1d6e:	862a                	mv	a2,a0
  if(n >= 0){
    1d70:	06054763          	bltz	a0,1dde <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    1d74:	85a6                	mv	a1,s1
    1d76:	00005517          	auipc	a0,0x5
    1d7a:	10a50513          	addi	a0,a0,266 # 6e80 <csem_up+0xe4c>
    1d7e:	00004097          	auipc	ra,0x4
    1d82:	03e080e7          	jalr	62(ra) # 5dbc <printf>
    exit(1);
    1d86:	4505                	li	a0,1
    1d88:	00004097          	auipc	ra,0x4
    1d8c:	c62080e7          	jalr	-926(ra) # 59ea <exit>
    printf("sbrk(rwsbrk) failed\n");
    1d90:	00005517          	auipc	a0,0x5
    1d94:	0a050513          	addi	a0,a0,160 # 6e30 <csem_up+0xdfc>
    1d98:	00004097          	auipc	ra,0x4
    1d9c:	024080e7          	jalr	36(ra) # 5dbc <printf>
    exit(1);
    1da0:	4505                	li	a0,1
    1da2:	00004097          	auipc	ra,0x4
    1da6:	c48080e7          	jalr	-952(ra) # 59ea <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    1daa:	00005517          	auipc	a0,0x5
    1dae:	09e50513          	addi	a0,a0,158 # 6e48 <csem_up+0xe14>
    1db2:	00004097          	auipc	ra,0x4
    1db6:	00a080e7          	jalr	10(ra) # 5dbc <printf>
    exit(1);
    1dba:	4505                	li	a0,1
    1dbc:	00004097          	auipc	ra,0x4
    1dc0:	c2e080e7          	jalr	-978(ra) # 59ea <exit>
    printf("open(rwsbrk) failed\n");
    1dc4:	00005517          	auipc	a0,0x5
    1dc8:	0a450513          	addi	a0,a0,164 # 6e68 <csem_up+0xe34>
    1dcc:	00004097          	auipc	ra,0x4
    1dd0:	ff0080e7          	jalr	-16(ra) # 5dbc <printf>
    exit(1);
    1dd4:	4505                	li	a0,1
    1dd6:	00004097          	auipc	ra,0x4
    1dda:	c14080e7          	jalr	-1004(ra) # 59ea <exit>
  close(fd);
    1dde:	854a                	mv	a0,s2
    1de0:	00004097          	auipc	ra,0x4
    1de4:	c32080e7          	jalr	-974(ra) # 5a12 <close>
  unlink("rwsbrk");
    1de8:	00004517          	auipc	a0,0x4
    1dec:	33850513          	addi	a0,a0,824 # 6120 <csem_up+0xec>
    1df0:	00004097          	auipc	ra,0x4
    1df4:	c4a080e7          	jalr	-950(ra) # 5a3a <unlink>
  fd = open("README", O_RDONLY);
    1df8:	4581                	li	a1,0
    1dfa:	00005517          	auipc	a0,0x5
    1dfe:	92650513          	addi	a0,a0,-1754 # 6720 <csem_up+0x6ec>
    1e02:	00004097          	auipc	ra,0x4
    1e06:	c28080e7          	jalr	-984(ra) # 5a2a <open>
    1e0a:	892a                	mv	s2,a0
  if(fd < 0){
    1e0c:	02054963          	bltz	a0,1e3e <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    1e10:	4629                	li	a2,10
    1e12:	85a6                	mv	a1,s1
    1e14:	00004097          	auipc	ra,0x4
    1e18:	bee080e7          	jalr	-1042(ra) # 5a02 <read>
    1e1c:	862a                	mv	a2,a0
  if(n >= 0){
    1e1e:	02054d63          	bltz	a0,1e58 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    1e22:	85a6                	mv	a1,s1
    1e24:	00005517          	auipc	a0,0x5
    1e28:	08c50513          	addi	a0,a0,140 # 6eb0 <csem_up+0xe7c>
    1e2c:	00004097          	auipc	ra,0x4
    1e30:	f90080e7          	jalr	-112(ra) # 5dbc <printf>
    exit(1);
    1e34:	4505                	li	a0,1
    1e36:	00004097          	auipc	ra,0x4
    1e3a:	bb4080e7          	jalr	-1100(ra) # 59ea <exit>
    printf("open(rwsbrk) failed\n");
    1e3e:	00005517          	auipc	a0,0x5
    1e42:	02a50513          	addi	a0,a0,42 # 6e68 <csem_up+0xe34>
    1e46:	00004097          	auipc	ra,0x4
    1e4a:	f76080e7          	jalr	-138(ra) # 5dbc <printf>
    exit(1);
    1e4e:	4505                	li	a0,1
    1e50:	00004097          	auipc	ra,0x4
    1e54:	b9a080e7          	jalr	-1126(ra) # 59ea <exit>
  close(fd);
    1e58:	854a                	mv	a0,s2
    1e5a:	00004097          	auipc	ra,0x4
    1e5e:	bb8080e7          	jalr	-1096(ra) # 5a12 <close>
  exit(0);
    1e62:	4501                	li	a0,0
    1e64:	00004097          	auipc	ra,0x4
    1e68:	b86080e7          	jalr	-1146(ra) # 59ea <exit>

0000000000001e6c <sbrkarg>:
{
    1e6c:	7179                	addi	sp,sp,-48
    1e6e:	f406                	sd	ra,40(sp)
    1e70:	f022                	sd	s0,32(sp)
    1e72:	ec26                	sd	s1,24(sp)
    1e74:	e84a                	sd	s2,16(sp)
    1e76:	e44e                	sd	s3,8(sp)
    1e78:	1800                	addi	s0,sp,48
    1e7a:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    1e7c:	6505                	lui	a0,0x1
    1e7e:	00004097          	auipc	ra,0x4
    1e82:	bf4080e7          	jalr	-1036(ra) # 5a72 <sbrk>
    1e86:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    1e88:	20100593          	li	a1,513
    1e8c:	00005517          	auipc	a0,0x5
    1e90:	04c50513          	addi	a0,a0,76 # 6ed8 <csem_up+0xea4>
    1e94:	00004097          	auipc	ra,0x4
    1e98:	b96080e7          	jalr	-1130(ra) # 5a2a <open>
    1e9c:	84aa                	mv	s1,a0
  unlink("sbrk");
    1e9e:	00005517          	auipc	a0,0x5
    1ea2:	03a50513          	addi	a0,a0,58 # 6ed8 <csem_up+0xea4>
    1ea6:	00004097          	auipc	ra,0x4
    1eaa:	b94080e7          	jalr	-1132(ra) # 5a3a <unlink>
  if(fd < 0)  {
    1eae:	0404c163          	bltz	s1,1ef0 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    1eb2:	6605                	lui	a2,0x1
    1eb4:	85ca                	mv	a1,s2
    1eb6:	8526                	mv	a0,s1
    1eb8:	00004097          	auipc	ra,0x4
    1ebc:	b52080e7          	jalr	-1198(ra) # 5a0a <write>
    1ec0:	04054663          	bltz	a0,1f0c <sbrkarg+0xa0>
  close(fd);
    1ec4:	8526                	mv	a0,s1
    1ec6:	00004097          	auipc	ra,0x4
    1eca:	b4c080e7          	jalr	-1204(ra) # 5a12 <close>
  a = sbrk(PGSIZE);
    1ece:	6505                	lui	a0,0x1
    1ed0:	00004097          	auipc	ra,0x4
    1ed4:	ba2080e7          	jalr	-1118(ra) # 5a72 <sbrk>
  if(pipe((int *) a) != 0){
    1ed8:	00004097          	auipc	ra,0x4
    1edc:	b22080e7          	jalr	-1246(ra) # 59fa <pipe>
    1ee0:	e521                	bnez	a0,1f28 <sbrkarg+0xbc>
}
    1ee2:	70a2                	ld	ra,40(sp)
    1ee4:	7402                	ld	s0,32(sp)
    1ee6:	64e2                	ld	s1,24(sp)
    1ee8:	6942                	ld	s2,16(sp)
    1eea:	69a2                	ld	s3,8(sp)
    1eec:	6145                	addi	sp,sp,48
    1eee:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    1ef0:	85ce                	mv	a1,s3
    1ef2:	00005517          	auipc	a0,0x5
    1ef6:	fee50513          	addi	a0,a0,-18 # 6ee0 <csem_up+0xeac>
    1efa:	00004097          	auipc	ra,0x4
    1efe:	ec2080e7          	jalr	-318(ra) # 5dbc <printf>
    exit(1);
    1f02:	4505                	li	a0,1
    1f04:	00004097          	auipc	ra,0x4
    1f08:	ae6080e7          	jalr	-1306(ra) # 59ea <exit>
    printf("%s: write sbrk failed\n", s);
    1f0c:	85ce                	mv	a1,s3
    1f0e:	00005517          	auipc	a0,0x5
    1f12:	fea50513          	addi	a0,a0,-22 # 6ef8 <csem_up+0xec4>
    1f16:	00004097          	auipc	ra,0x4
    1f1a:	ea6080e7          	jalr	-346(ra) # 5dbc <printf>
    exit(1);
    1f1e:	4505                	li	a0,1
    1f20:	00004097          	auipc	ra,0x4
    1f24:	aca080e7          	jalr	-1334(ra) # 59ea <exit>
    printf("%s: pipe() failed\n", s);
    1f28:	85ce                	mv	a1,s3
    1f2a:	00005517          	auipc	a0,0x5
    1f2e:	93650513          	addi	a0,a0,-1738 # 6860 <csem_up+0x82c>
    1f32:	00004097          	auipc	ra,0x4
    1f36:	e8a080e7          	jalr	-374(ra) # 5dbc <printf>
    exit(1);
    1f3a:	4505                	li	a0,1
    1f3c:	00004097          	auipc	ra,0x4
    1f40:	aae080e7          	jalr	-1362(ra) # 59ea <exit>

0000000000001f44 <argptest>:
{
    1f44:	1101                	addi	sp,sp,-32
    1f46:	ec06                	sd	ra,24(sp)
    1f48:	e822                	sd	s0,16(sp)
    1f4a:	e426                	sd	s1,8(sp)
    1f4c:	e04a                	sd	s2,0(sp)
    1f4e:	1000                	addi	s0,sp,32
    1f50:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    1f52:	4581                	li	a1,0
    1f54:	00005517          	auipc	a0,0x5
    1f58:	fbc50513          	addi	a0,a0,-68 # 6f10 <csem_up+0xedc>
    1f5c:	00004097          	auipc	ra,0x4
    1f60:	ace080e7          	jalr	-1330(ra) # 5a2a <open>
  if (fd < 0) {
    1f64:	02054b63          	bltz	a0,1f9a <argptest+0x56>
    1f68:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    1f6a:	4501                	li	a0,0
    1f6c:	00004097          	auipc	ra,0x4
    1f70:	b06080e7          	jalr	-1274(ra) # 5a72 <sbrk>
    1f74:	567d                	li	a2,-1
    1f76:	fff50593          	addi	a1,a0,-1
    1f7a:	8526                	mv	a0,s1
    1f7c:	00004097          	auipc	ra,0x4
    1f80:	a86080e7          	jalr	-1402(ra) # 5a02 <read>
  close(fd);
    1f84:	8526                	mv	a0,s1
    1f86:	00004097          	auipc	ra,0x4
    1f8a:	a8c080e7          	jalr	-1396(ra) # 5a12 <close>
}
    1f8e:	60e2                	ld	ra,24(sp)
    1f90:	6442                	ld	s0,16(sp)
    1f92:	64a2                	ld	s1,8(sp)
    1f94:	6902                	ld	s2,0(sp)
    1f96:	6105                	addi	sp,sp,32
    1f98:	8082                	ret
    printf("%s: open failed\n", s);
    1f9a:	85ca                	mv	a1,s2
    1f9c:	00005517          	auipc	a0,0x5
    1fa0:	d1450513          	addi	a0,a0,-748 # 6cb0 <csem_up+0xc7c>
    1fa4:	00004097          	auipc	ra,0x4
    1fa8:	e18080e7          	jalr	-488(ra) # 5dbc <printf>
    exit(1);
    1fac:	4505                	li	a0,1
    1fae:	00004097          	auipc	ra,0x4
    1fb2:	a3c080e7          	jalr	-1476(ra) # 59ea <exit>

0000000000001fb6 <openiputtest>:
{
    1fb6:	7179                	addi	sp,sp,-48
    1fb8:	f406                	sd	ra,40(sp)
    1fba:	f022                	sd	s0,32(sp)
    1fbc:	ec26                	sd	s1,24(sp)
    1fbe:	1800                	addi	s0,sp,48
    1fc0:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    1fc2:	00005517          	auipc	a0,0x5
    1fc6:	f5650513          	addi	a0,a0,-170 # 6f18 <csem_up+0xee4>
    1fca:	00004097          	auipc	ra,0x4
    1fce:	a88080e7          	jalr	-1400(ra) # 5a52 <mkdir>
    1fd2:	04054263          	bltz	a0,2016 <openiputtest+0x60>
  pid = fork();
    1fd6:	00004097          	auipc	ra,0x4
    1fda:	a0c080e7          	jalr	-1524(ra) # 59e2 <fork>
  if(pid < 0){
    1fde:	04054a63          	bltz	a0,2032 <openiputtest+0x7c>
  if(pid == 0){
    1fe2:	e93d                	bnez	a0,2058 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    1fe4:	4589                	li	a1,2
    1fe6:	00005517          	auipc	a0,0x5
    1fea:	f3250513          	addi	a0,a0,-206 # 6f18 <csem_up+0xee4>
    1fee:	00004097          	auipc	ra,0x4
    1ff2:	a3c080e7          	jalr	-1476(ra) # 5a2a <open>
    if(fd >= 0){
    1ff6:	04054c63          	bltz	a0,204e <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    1ffa:	85a6                	mv	a1,s1
    1ffc:	00005517          	auipc	a0,0x5
    2000:	f3c50513          	addi	a0,a0,-196 # 6f38 <csem_up+0xf04>
    2004:	00004097          	auipc	ra,0x4
    2008:	db8080e7          	jalr	-584(ra) # 5dbc <printf>
      exit(1);
    200c:	4505                	li	a0,1
    200e:	00004097          	auipc	ra,0x4
    2012:	9dc080e7          	jalr	-1572(ra) # 59ea <exit>
    printf("%s: mkdir oidir failed\n", s);
    2016:	85a6                	mv	a1,s1
    2018:	00005517          	auipc	a0,0x5
    201c:	f0850513          	addi	a0,a0,-248 # 6f20 <csem_up+0xeec>
    2020:	00004097          	auipc	ra,0x4
    2024:	d9c080e7          	jalr	-612(ra) # 5dbc <printf>
    exit(1);
    2028:	4505                	li	a0,1
    202a:	00004097          	auipc	ra,0x4
    202e:	9c0080e7          	jalr	-1600(ra) # 59ea <exit>
    printf("%s: fork failed\n", s);
    2032:	85a6                	mv	a1,s1
    2034:	00004517          	auipc	a0,0x4
    2038:	2fc50513          	addi	a0,a0,764 # 6330 <csem_up+0x2fc>
    203c:	00004097          	auipc	ra,0x4
    2040:	d80080e7          	jalr	-640(ra) # 5dbc <printf>
    exit(1);
    2044:	4505                	li	a0,1
    2046:	00004097          	auipc	ra,0x4
    204a:	9a4080e7          	jalr	-1628(ra) # 59ea <exit>
    exit(0);
    204e:	4501                	li	a0,0
    2050:	00004097          	auipc	ra,0x4
    2054:	99a080e7          	jalr	-1638(ra) # 59ea <exit>
  sleep(1);
    2058:	4505                	li	a0,1
    205a:	00004097          	auipc	ra,0x4
    205e:	a20080e7          	jalr	-1504(ra) # 5a7a <sleep>
  if(unlink("oidir") != 0){
    2062:	00005517          	auipc	a0,0x5
    2066:	eb650513          	addi	a0,a0,-330 # 6f18 <csem_up+0xee4>
    206a:	00004097          	auipc	ra,0x4
    206e:	9d0080e7          	jalr	-1584(ra) # 5a3a <unlink>
    2072:	cd19                	beqz	a0,2090 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    2074:	85a6                	mv	a1,s1
    2076:	00005517          	auipc	a0,0x5
    207a:	eea50513          	addi	a0,a0,-278 # 6f60 <csem_up+0xf2c>
    207e:	00004097          	auipc	ra,0x4
    2082:	d3e080e7          	jalr	-706(ra) # 5dbc <printf>
    exit(1);
    2086:	4505                	li	a0,1
    2088:	00004097          	auipc	ra,0x4
    208c:	962080e7          	jalr	-1694(ra) # 59ea <exit>
  wait(&xstatus);
    2090:	fdc40513          	addi	a0,s0,-36
    2094:	00004097          	auipc	ra,0x4
    2098:	95e080e7          	jalr	-1698(ra) # 59f2 <wait>
  exit(xstatus);
    209c:	fdc42503          	lw	a0,-36(s0)
    20a0:	00004097          	auipc	ra,0x4
    20a4:	94a080e7          	jalr	-1718(ra) # 59ea <exit>

00000000000020a8 <fourteen>:
{
    20a8:	1101                	addi	sp,sp,-32
    20aa:	ec06                	sd	ra,24(sp)
    20ac:	e822                	sd	s0,16(sp)
    20ae:	e426                	sd	s1,8(sp)
    20b0:	1000                	addi	s0,sp,32
    20b2:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    20b4:	00005517          	auipc	a0,0x5
    20b8:	09450513          	addi	a0,a0,148 # 7148 <csem_up+0x1114>
    20bc:	00004097          	auipc	ra,0x4
    20c0:	996080e7          	jalr	-1642(ra) # 5a52 <mkdir>
    20c4:	e165                	bnez	a0,21a4 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    20c6:	00005517          	auipc	a0,0x5
    20ca:	eda50513          	addi	a0,a0,-294 # 6fa0 <csem_up+0xf6c>
    20ce:	00004097          	auipc	ra,0x4
    20d2:	984080e7          	jalr	-1660(ra) # 5a52 <mkdir>
    20d6:	e56d                	bnez	a0,21c0 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    20d8:	20000593          	li	a1,512
    20dc:	00005517          	auipc	a0,0x5
    20e0:	f1c50513          	addi	a0,a0,-228 # 6ff8 <csem_up+0xfc4>
    20e4:	00004097          	auipc	ra,0x4
    20e8:	946080e7          	jalr	-1722(ra) # 5a2a <open>
  if(fd < 0){
    20ec:	0e054863          	bltz	a0,21dc <fourteen+0x134>
  close(fd);
    20f0:	00004097          	auipc	ra,0x4
    20f4:	922080e7          	jalr	-1758(ra) # 5a12 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    20f8:	4581                	li	a1,0
    20fa:	00005517          	auipc	a0,0x5
    20fe:	f7650513          	addi	a0,a0,-138 # 7070 <csem_up+0x103c>
    2102:	00004097          	auipc	ra,0x4
    2106:	928080e7          	jalr	-1752(ra) # 5a2a <open>
  if(fd < 0){
    210a:	0e054763          	bltz	a0,21f8 <fourteen+0x150>
  close(fd);
    210e:	00004097          	auipc	ra,0x4
    2112:	904080e7          	jalr	-1788(ra) # 5a12 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2116:	00005517          	auipc	a0,0x5
    211a:	fca50513          	addi	a0,a0,-54 # 70e0 <csem_up+0x10ac>
    211e:	00004097          	auipc	ra,0x4
    2122:	934080e7          	jalr	-1740(ra) # 5a52 <mkdir>
    2126:	c57d                	beqz	a0,2214 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2128:	00005517          	auipc	a0,0x5
    212c:	01050513          	addi	a0,a0,16 # 7138 <csem_up+0x1104>
    2130:	00004097          	auipc	ra,0x4
    2134:	922080e7          	jalr	-1758(ra) # 5a52 <mkdir>
    2138:	cd65                	beqz	a0,2230 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    213a:	00005517          	auipc	a0,0x5
    213e:	ffe50513          	addi	a0,a0,-2 # 7138 <csem_up+0x1104>
    2142:	00004097          	auipc	ra,0x4
    2146:	8f8080e7          	jalr	-1800(ra) # 5a3a <unlink>
  unlink("12345678901234/12345678901234");
    214a:	00005517          	auipc	a0,0x5
    214e:	f9650513          	addi	a0,a0,-106 # 70e0 <csem_up+0x10ac>
    2152:	00004097          	auipc	ra,0x4
    2156:	8e8080e7          	jalr	-1816(ra) # 5a3a <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    215a:	00005517          	auipc	a0,0x5
    215e:	f1650513          	addi	a0,a0,-234 # 7070 <csem_up+0x103c>
    2162:	00004097          	auipc	ra,0x4
    2166:	8d8080e7          	jalr	-1832(ra) # 5a3a <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    216a:	00005517          	auipc	a0,0x5
    216e:	e8e50513          	addi	a0,a0,-370 # 6ff8 <csem_up+0xfc4>
    2172:	00004097          	auipc	ra,0x4
    2176:	8c8080e7          	jalr	-1848(ra) # 5a3a <unlink>
  unlink("12345678901234/123456789012345");
    217a:	00005517          	auipc	a0,0x5
    217e:	e2650513          	addi	a0,a0,-474 # 6fa0 <csem_up+0xf6c>
    2182:	00004097          	auipc	ra,0x4
    2186:	8b8080e7          	jalr	-1864(ra) # 5a3a <unlink>
  unlink("12345678901234");
    218a:	00005517          	auipc	a0,0x5
    218e:	fbe50513          	addi	a0,a0,-66 # 7148 <csem_up+0x1114>
    2192:	00004097          	auipc	ra,0x4
    2196:	8a8080e7          	jalr	-1880(ra) # 5a3a <unlink>
}
    219a:	60e2                	ld	ra,24(sp)
    219c:	6442                	ld	s0,16(sp)
    219e:	64a2                	ld	s1,8(sp)
    21a0:	6105                	addi	sp,sp,32
    21a2:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    21a4:	85a6                	mv	a1,s1
    21a6:	00005517          	auipc	a0,0x5
    21aa:	dd250513          	addi	a0,a0,-558 # 6f78 <csem_up+0xf44>
    21ae:	00004097          	auipc	ra,0x4
    21b2:	c0e080e7          	jalr	-1010(ra) # 5dbc <printf>
    exit(1);
    21b6:	4505                	li	a0,1
    21b8:	00004097          	auipc	ra,0x4
    21bc:	832080e7          	jalr	-1998(ra) # 59ea <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    21c0:	85a6                	mv	a1,s1
    21c2:	00005517          	auipc	a0,0x5
    21c6:	dfe50513          	addi	a0,a0,-514 # 6fc0 <csem_up+0xf8c>
    21ca:	00004097          	auipc	ra,0x4
    21ce:	bf2080e7          	jalr	-1038(ra) # 5dbc <printf>
    exit(1);
    21d2:	4505                	li	a0,1
    21d4:	00004097          	auipc	ra,0x4
    21d8:	816080e7          	jalr	-2026(ra) # 59ea <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    21dc:	85a6                	mv	a1,s1
    21de:	00005517          	auipc	a0,0x5
    21e2:	e4a50513          	addi	a0,a0,-438 # 7028 <csem_up+0xff4>
    21e6:	00004097          	auipc	ra,0x4
    21ea:	bd6080e7          	jalr	-1066(ra) # 5dbc <printf>
    exit(1);
    21ee:	4505                	li	a0,1
    21f0:	00003097          	auipc	ra,0x3
    21f4:	7fa080e7          	jalr	2042(ra) # 59ea <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    21f8:	85a6                	mv	a1,s1
    21fa:	00005517          	auipc	a0,0x5
    21fe:	ea650513          	addi	a0,a0,-346 # 70a0 <csem_up+0x106c>
    2202:	00004097          	auipc	ra,0x4
    2206:	bba080e7          	jalr	-1094(ra) # 5dbc <printf>
    exit(1);
    220a:	4505                	li	a0,1
    220c:	00003097          	auipc	ra,0x3
    2210:	7de080e7          	jalr	2014(ra) # 59ea <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2214:	85a6                	mv	a1,s1
    2216:	00005517          	auipc	a0,0x5
    221a:	eea50513          	addi	a0,a0,-278 # 7100 <csem_up+0x10cc>
    221e:	00004097          	auipc	ra,0x4
    2222:	b9e080e7          	jalr	-1122(ra) # 5dbc <printf>
    exit(1);
    2226:	4505                	li	a0,1
    2228:	00003097          	auipc	ra,0x3
    222c:	7c2080e7          	jalr	1986(ra) # 59ea <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2230:	85a6                	mv	a1,s1
    2232:	00005517          	auipc	a0,0x5
    2236:	f2650513          	addi	a0,a0,-218 # 7158 <csem_up+0x1124>
    223a:	00004097          	auipc	ra,0x4
    223e:	b82080e7          	jalr	-1150(ra) # 5dbc <printf>
    exit(1);
    2242:	4505                	li	a0,1
    2244:	00003097          	auipc	ra,0x3
    2248:	7a6080e7          	jalr	1958(ra) # 59ea <exit>

000000000000224c <iputtest>:
{
    224c:	1101                	addi	sp,sp,-32
    224e:	ec06                	sd	ra,24(sp)
    2250:	e822                	sd	s0,16(sp)
    2252:	e426                	sd	s1,8(sp)
    2254:	1000                	addi	s0,sp,32
    2256:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2258:	00005517          	auipc	a0,0x5
    225c:	f3850513          	addi	a0,a0,-200 # 7190 <csem_up+0x115c>
    2260:	00003097          	auipc	ra,0x3
    2264:	7f2080e7          	jalr	2034(ra) # 5a52 <mkdir>
    2268:	04054563          	bltz	a0,22b2 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    226c:	00005517          	auipc	a0,0x5
    2270:	f2450513          	addi	a0,a0,-220 # 7190 <csem_up+0x115c>
    2274:	00003097          	auipc	ra,0x3
    2278:	7e6080e7          	jalr	2022(ra) # 5a5a <chdir>
    227c:	04054963          	bltz	a0,22ce <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2280:	00005517          	auipc	a0,0x5
    2284:	f5050513          	addi	a0,a0,-176 # 71d0 <csem_up+0x119c>
    2288:	00003097          	auipc	ra,0x3
    228c:	7b2080e7          	jalr	1970(ra) # 5a3a <unlink>
    2290:	04054d63          	bltz	a0,22ea <iputtest+0x9e>
  if(chdir("/") < 0){
    2294:	00005517          	auipc	a0,0x5
    2298:	f6c50513          	addi	a0,a0,-148 # 7200 <csem_up+0x11cc>
    229c:	00003097          	auipc	ra,0x3
    22a0:	7be080e7          	jalr	1982(ra) # 5a5a <chdir>
    22a4:	06054163          	bltz	a0,2306 <iputtest+0xba>
}
    22a8:	60e2                	ld	ra,24(sp)
    22aa:	6442                	ld	s0,16(sp)
    22ac:	64a2                	ld	s1,8(sp)
    22ae:	6105                	addi	sp,sp,32
    22b0:	8082                	ret
    printf("%s: mkdir failed\n", s);
    22b2:	85a6                	mv	a1,s1
    22b4:	00005517          	auipc	a0,0x5
    22b8:	ee450513          	addi	a0,a0,-284 # 7198 <csem_up+0x1164>
    22bc:	00004097          	auipc	ra,0x4
    22c0:	b00080e7          	jalr	-1280(ra) # 5dbc <printf>
    exit(1);
    22c4:	4505                	li	a0,1
    22c6:	00003097          	auipc	ra,0x3
    22ca:	724080e7          	jalr	1828(ra) # 59ea <exit>
    printf("%s: chdir iputdir failed\n", s);
    22ce:	85a6                	mv	a1,s1
    22d0:	00005517          	auipc	a0,0x5
    22d4:	ee050513          	addi	a0,a0,-288 # 71b0 <csem_up+0x117c>
    22d8:	00004097          	auipc	ra,0x4
    22dc:	ae4080e7          	jalr	-1308(ra) # 5dbc <printf>
    exit(1);
    22e0:	4505                	li	a0,1
    22e2:	00003097          	auipc	ra,0x3
    22e6:	708080e7          	jalr	1800(ra) # 59ea <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    22ea:	85a6                	mv	a1,s1
    22ec:	00005517          	auipc	a0,0x5
    22f0:	ef450513          	addi	a0,a0,-268 # 71e0 <csem_up+0x11ac>
    22f4:	00004097          	auipc	ra,0x4
    22f8:	ac8080e7          	jalr	-1336(ra) # 5dbc <printf>
    exit(1);
    22fc:	4505                	li	a0,1
    22fe:	00003097          	auipc	ra,0x3
    2302:	6ec080e7          	jalr	1772(ra) # 59ea <exit>
    printf("%s: chdir / failed\n", s);
    2306:	85a6                	mv	a1,s1
    2308:	00005517          	auipc	a0,0x5
    230c:	f0050513          	addi	a0,a0,-256 # 7208 <csem_up+0x11d4>
    2310:	00004097          	auipc	ra,0x4
    2314:	aac080e7          	jalr	-1364(ra) # 5dbc <printf>
    exit(1);
    2318:	4505                	li	a0,1
    231a:	00003097          	auipc	ra,0x3
    231e:	6d0080e7          	jalr	1744(ra) # 59ea <exit>

0000000000002322 <exitiputtest>:
{
    2322:	7179                	addi	sp,sp,-48
    2324:	f406                	sd	ra,40(sp)
    2326:	f022                	sd	s0,32(sp)
    2328:	ec26                	sd	s1,24(sp)
    232a:	1800                	addi	s0,sp,48
    232c:	84aa                	mv	s1,a0
  pid = fork();
    232e:	00003097          	auipc	ra,0x3
    2332:	6b4080e7          	jalr	1716(ra) # 59e2 <fork>
  if(pid < 0){
    2336:	04054663          	bltz	a0,2382 <exitiputtest+0x60>
  if(pid == 0){
    233a:	ed45                	bnez	a0,23f2 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    233c:	00005517          	auipc	a0,0x5
    2340:	e5450513          	addi	a0,a0,-428 # 7190 <csem_up+0x115c>
    2344:	00003097          	auipc	ra,0x3
    2348:	70e080e7          	jalr	1806(ra) # 5a52 <mkdir>
    234c:	04054963          	bltz	a0,239e <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2350:	00005517          	auipc	a0,0x5
    2354:	e4050513          	addi	a0,a0,-448 # 7190 <csem_up+0x115c>
    2358:	00003097          	auipc	ra,0x3
    235c:	702080e7          	jalr	1794(ra) # 5a5a <chdir>
    2360:	04054d63          	bltz	a0,23ba <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2364:	00005517          	auipc	a0,0x5
    2368:	e6c50513          	addi	a0,a0,-404 # 71d0 <csem_up+0x119c>
    236c:	00003097          	auipc	ra,0x3
    2370:	6ce080e7          	jalr	1742(ra) # 5a3a <unlink>
    2374:	06054163          	bltz	a0,23d6 <exitiputtest+0xb4>
    exit(0);
    2378:	4501                	li	a0,0
    237a:	00003097          	auipc	ra,0x3
    237e:	670080e7          	jalr	1648(ra) # 59ea <exit>
    printf("%s: fork failed\n", s);
    2382:	85a6                	mv	a1,s1
    2384:	00004517          	auipc	a0,0x4
    2388:	fac50513          	addi	a0,a0,-84 # 6330 <csem_up+0x2fc>
    238c:	00004097          	auipc	ra,0x4
    2390:	a30080e7          	jalr	-1488(ra) # 5dbc <printf>
    exit(1);
    2394:	4505                	li	a0,1
    2396:	00003097          	auipc	ra,0x3
    239a:	654080e7          	jalr	1620(ra) # 59ea <exit>
      printf("%s: mkdir failed\n", s);
    239e:	85a6                	mv	a1,s1
    23a0:	00005517          	auipc	a0,0x5
    23a4:	df850513          	addi	a0,a0,-520 # 7198 <csem_up+0x1164>
    23a8:	00004097          	auipc	ra,0x4
    23ac:	a14080e7          	jalr	-1516(ra) # 5dbc <printf>
      exit(1);
    23b0:	4505                	li	a0,1
    23b2:	00003097          	auipc	ra,0x3
    23b6:	638080e7          	jalr	1592(ra) # 59ea <exit>
      printf("%s: child chdir failed\n", s);
    23ba:	85a6                	mv	a1,s1
    23bc:	00005517          	auipc	a0,0x5
    23c0:	e6450513          	addi	a0,a0,-412 # 7220 <csem_up+0x11ec>
    23c4:	00004097          	auipc	ra,0x4
    23c8:	9f8080e7          	jalr	-1544(ra) # 5dbc <printf>
      exit(1);
    23cc:	4505                	li	a0,1
    23ce:	00003097          	auipc	ra,0x3
    23d2:	61c080e7          	jalr	1564(ra) # 59ea <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    23d6:	85a6                	mv	a1,s1
    23d8:	00005517          	auipc	a0,0x5
    23dc:	e0850513          	addi	a0,a0,-504 # 71e0 <csem_up+0x11ac>
    23e0:	00004097          	auipc	ra,0x4
    23e4:	9dc080e7          	jalr	-1572(ra) # 5dbc <printf>
      exit(1);
    23e8:	4505                	li	a0,1
    23ea:	00003097          	auipc	ra,0x3
    23ee:	600080e7          	jalr	1536(ra) # 59ea <exit>
  wait(&xstatus);
    23f2:	fdc40513          	addi	a0,s0,-36
    23f6:	00003097          	auipc	ra,0x3
    23fa:	5fc080e7          	jalr	1532(ra) # 59f2 <wait>
  exit(xstatus);
    23fe:	fdc42503          	lw	a0,-36(s0)
    2402:	00003097          	auipc	ra,0x3
    2406:	5e8080e7          	jalr	1512(ra) # 59ea <exit>

000000000000240a <dirtest>:
{
    240a:	1101                	addi	sp,sp,-32
    240c:	ec06                	sd	ra,24(sp)
    240e:	e822                	sd	s0,16(sp)
    2410:	e426                	sd	s1,8(sp)
    2412:	1000                	addi	s0,sp,32
    2414:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2416:	00005517          	auipc	a0,0x5
    241a:	e2250513          	addi	a0,a0,-478 # 7238 <csem_up+0x1204>
    241e:	00003097          	auipc	ra,0x3
    2422:	634080e7          	jalr	1588(ra) # 5a52 <mkdir>
    2426:	04054563          	bltz	a0,2470 <dirtest+0x66>
  if(chdir("dir0") < 0){
    242a:	00005517          	auipc	a0,0x5
    242e:	e0e50513          	addi	a0,a0,-498 # 7238 <csem_up+0x1204>
    2432:	00003097          	auipc	ra,0x3
    2436:	628080e7          	jalr	1576(ra) # 5a5a <chdir>
    243a:	04054963          	bltz	a0,248c <dirtest+0x82>
  if(chdir("..") < 0){
    243e:	00005517          	auipc	a0,0x5
    2442:	e1a50513          	addi	a0,a0,-486 # 7258 <csem_up+0x1224>
    2446:	00003097          	auipc	ra,0x3
    244a:	614080e7          	jalr	1556(ra) # 5a5a <chdir>
    244e:	04054d63          	bltz	a0,24a8 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    2452:	00005517          	auipc	a0,0x5
    2456:	de650513          	addi	a0,a0,-538 # 7238 <csem_up+0x1204>
    245a:	00003097          	auipc	ra,0x3
    245e:	5e0080e7          	jalr	1504(ra) # 5a3a <unlink>
    2462:	06054163          	bltz	a0,24c4 <dirtest+0xba>
}
    2466:	60e2                	ld	ra,24(sp)
    2468:	6442                	ld	s0,16(sp)
    246a:	64a2                	ld	s1,8(sp)
    246c:	6105                	addi	sp,sp,32
    246e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2470:	85a6                	mv	a1,s1
    2472:	00005517          	auipc	a0,0x5
    2476:	d2650513          	addi	a0,a0,-730 # 7198 <csem_up+0x1164>
    247a:	00004097          	auipc	ra,0x4
    247e:	942080e7          	jalr	-1726(ra) # 5dbc <printf>
    exit(1);
    2482:	4505                	li	a0,1
    2484:	00003097          	auipc	ra,0x3
    2488:	566080e7          	jalr	1382(ra) # 59ea <exit>
    printf("%s: chdir dir0 failed\n", s);
    248c:	85a6                	mv	a1,s1
    248e:	00005517          	auipc	a0,0x5
    2492:	db250513          	addi	a0,a0,-590 # 7240 <csem_up+0x120c>
    2496:	00004097          	auipc	ra,0x4
    249a:	926080e7          	jalr	-1754(ra) # 5dbc <printf>
    exit(1);
    249e:	4505                	li	a0,1
    24a0:	00003097          	auipc	ra,0x3
    24a4:	54a080e7          	jalr	1354(ra) # 59ea <exit>
    printf("%s: chdir .. failed\n", s);
    24a8:	85a6                	mv	a1,s1
    24aa:	00005517          	auipc	a0,0x5
    24ae:	db650513          	addi	a0,a0,-586 # 7260 <csem_up+0x122c>
    24b2:	00004097          	auipc	ra,0x4
    24b6:	90a080e7          	jalr	-1782(ra) # 5dbc <printf>
    exit(1);
    24ba:	4505                	li	a0,1
    24bc:	00003097          	auipc	ra,0x3
    24c0:	52e080e7          	jalr	1326(ra) # 59ea <exit>
    printf("%s: unlink dir0 failed\n", s);
    24c4:	85a6                	mv	a1,s1
    24c6:	00005517          	auipc	a0,0x5
    24ca:	db250513          	addi	a0,a0,-590 # 7278 <csem_up+0x1244>
    24ce:	00004097          	auipc	ra,0x4
    24d2:	8ee080e7          	jalr	-1810(ra) # 5dbc <printf>
    exit(1);
    24d6:	4505                	li	a0,1
    24d8:	00003097          	auipc	ra,0x3
    24dc:	512080e7          	jalr	1298(ra) # 59ea <exit>

00000000000024e0 <subdir>:
{
    24e0:	1101                	addi	sp,sp,-32
    24e2:	ec06                	sd	ra,24(sp)
    24e4:	e822                	sd	s0,16(sp)
    24e6:	e426                	sd	s1,8(sp)
    24e8:	e04a                	sd	s2,0(sp)
    24ea:	1000                	addi	s0,sp,32
    24ec:	892a                	mv	s2,a0
  unlink("ff");
    24ee:	00005517          	auipc	a0,0x5
    24f2:	ed250513          	addi	a0,a0,-302 # 73c0 <csem_up+0x138c>
    24f6:	00003097          	auipc	ra,0x3
    24fa:	544080e7          	jalr	1348(ra) # 5a3a <unlink>
  if(mkdir("dd") != 0){
    24fe:	00005517          	auipc	a0,0x5
    2502:	d9250513          	addi	a0,a0,-622 # 7290 <csem_up+0x125c>
    2506:	00003097          	auipc	ra,0x3
    250a:	54c080e7          	jalr	1356(ra) # 5a52 <mkdir>
    250e:	38051663          	bnez	a0,289a <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2512:	20200593          	li	a1,514
    2516:	00005517          	auipc	a0,0x5
    251a:	d9a50513          	addi	a0,a0,-614 # 72b0 <csem_up+0x127c>
    251e:	00003097          	auipc	ra,0x3
    2522:	50c080e7          	jalr	1292(ra) # 5a2a <open>
    2526:	84aa                	mv	s1,a0
  if(fd < 0){
    2528:	38054763          	bltz	a0,28b6 <subdir+0x3d6>
  write(fd, "ff", 2);
    252c:	4609                	li	a2,2
    252e:	00005597          	auipc	a1,0x5
    2532:	e9258593          	addi	a1,a1,-366 # 73c0 <csem_up+0x138c>
    2536:	00003097          	auipc	ra,0x3
    253a:	4d4080e7          	jalr	1236(ra) # 5a0a <write>
  close(fd);
    253e:	8526                	mv	a0,s1
    2540:	00003097          	auipc	ra,0x3
    2544:	4d2080e7          	jalr	1234(ra) # 5a12 <close>
  if(unlink("dd") >= 0){
    2548:	00005517          	auipc	a0,0x5
    254c:	d4850513          	addi	a0,a0,-696 # 7290 <csem_up+0x125c>
    2550:	00003097          	auipc	ra,0x3
    2554:	4ea080e7          	jalr	1258(ra) # 5a3a <unlink>
    2558:	36055d63          	bgez	a0,28d2 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    255c:	00005517          	auipc	a0,0x5
    2560:	dac50513          	addi	a0,a0,-596 # 7308 <csem_up+0x12d4>
    2564:	00003097          	auipc	ra,0x3
    2568:	4ee080e7          	jalr	1262(ra) # 5a52 <mkdir>
    256c:	38051163          	bnez	a0,28ee <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2570:	20200593          	li	a1,514
    2574:	00005517          	auipc	a0,0x5
    2578:	dbc50513          	addi	a0,a0,-580 # 7330 <csem_up+0x12fc>
    257c:	00003097          	auipc	ra,0x3
    2580:	4ae080e7          	jalr	1198(ra) # 5a2a <open>
    2584:	84aa                	mv	s1,a0
  if(fd < 0){
    2586:	38054263          	bltz	a0,290a <subdir+0x42a>
  write(fd, "FF", 2);
    258a:	4609                	li	a2,2
    258c:	00005597          	auipc	a1,0x5
    2590:	dd458593          	addi	a1,a1,-556 # 7360 <csem_up+0x132c>
    2594:	00003097          	auipc	ra,0x3
    2598:	476080e7          	jalr	1142(ra) # 5a0a <write>
  close(fd);
    259c:	8526                	mv	a0,s1
    259e:	00003097          	auipc	ra,0x3
    25a2:	474080e7          	jalr	1140(ra) # 5a12 <close>
  fd = open("dd/dd/../ff", 0);
    25a6:	4581                	li	a1,0
    25a8:	00005517          	auipc	a0,0x5
    25ac:	dc050513          	addi	a0,a0,-576 # 7368 <csem_up+0x1334>
    25b0:	00003097          	auipc	ra,0x3
    25b4:	47a080e7          	jalr	1146(ra) # 5a2a <open>
    25b8:	84aa                	mv	s1,a0
  if(fd < 0){
    25ba:	36054663          	bltz	a0,2926 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    25be:	660d                	lui	a2,0x3
    25c0:	0000a597          	auipc	a1,0xa
    25c4:	a1858593          	addi	a1,a1,-1512 # bfd8 <buf>
    25c8:	00003097          	auipc	ra,0x3
    25cc:	43a080e7          	jalr	1082(ra) # 5a02 <read>
  if(cc != 2 || buf[0] != 'f'){
    25d0:	4789                	li	a5,2
    25d2:	36f51863          	bne	a0,a5,2942 <subdir+0x462>
    25d6:	0000a717          	auipc	a4,0xa
    25da:	a0274703          	lbu	a4,-1534(a4) # bfd8 <buf>
    25de:	06600793          	li	a5,102
    25e2:	36f71063          	bne	a4,a5,2942 <subdir+0x462>
  close(fd);
    25e6:	8526                	mv	a0,s1
    25e8:	00003097          	auipc	ra,0x3
    25ec:	42a080e7          	jalr	1066(ra) # 5a12 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    25f0:	00005597          	auipc	a1,0x5
    25f4:	dc858593          	addi	a1,a1,-568 # 73b8 <csem_up+0x1384>
    25f8:	00005517          	auipc	a0,0x5
    25fc:	d3850513          	addi	a0,a0,-712 # 7330 <csem_up+0x12fc>
    2600:	00003097          	auipc	ra,0x3
    2604:	44a080e7          	jalr	1098(ra) # 5a4a <link>
    2608:	34051b63          	bnez	a0,295e <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    260c:	00005517          	auipc	a0,0x5
    2610:	d2450513          	addi	a0,a0,-732 # 7330 <csem_up+0x12fc>
    2614:	00003097          	auipc	ra,0x3
    2618:	426080e7          	jalr	1062(ra) # 5a3a <unlink>
    261c:	34051f63          	bnez	a0,297a <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2620:	4581                	li	a1,0
    2622:	00005517          	auipc	a0,0x5
    2626:	d0e50513          	addi	a0,a0,-754 # 7330 <csem_up+0x12fc>
    262a:	00003097          	auipc	ra,0x3
    262e:	400080e7          	jalr	1024(ra) # 5a2a <open>
    2632:	36055263          	bgez	a0,2996 <subdir+0x4b6>
  if(chdir("dd") != 0){
    2636:	00005517          	auipc	a0,0x5
    263a:	c5a50513          	addi	a0,a0,-934 # 7290 <csem_up+0x125c>
    263e:	00003097          	auipc	ra,0x3
    2642:	41c080e7          	jalr	1052(ra) # 5a5a <chdir>
    2646:	36051663          	bnez	a0,29b2 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    264a:	00005517          	auipc	a0,0x5
    264e:	e0650513          	addi	a0,a0,-506 # 7450 <csem_up+0x141c>
    2652:	00003097          	auipc	ra,0x3
    2656:	408080e7          	jalr	1032(ra) # 5a5a <chdir>
    265a:	36051a63          	bnez	a0,29ce <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    265e:	00005517          	auipc	a0,0x5
    2662:	e2250513          	addi	a0,a0,-478 # 7480 <csem_up+0x144c>
    2666:	00003097          	auipc	ra,0x3
    266a:	3f4080e7          	jalr	1012(ra) # 5a5a <chdir>
    266e:	36051e63          	bnez	a0,29ea <subdir+0x50a>
  if(chdir("./..") != 0){
    2672:	00005517          	auipc	a0,0x5
    2676:	e3e50513          	addi	a0,a0,-450 # 74b0 <csem_up+0x147c>
    267a:	00003097          	auipc	ra,0x3
    267e:	3e0080e7          	jalr	992(ra) # 5a5a <chdir>
    2682:	38051263          	bnez	a0,2a06 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2686:	4581                	li	a1,0
    2688:	00005517          	auipc	a0,0x5
    268c:	d3050513          	addi	a0,a0,-720 # 73b8 <csem_up+0x1384>
    2690:	00003097          	auipc	ra,0x3
    2694:	39a080e7          	jalr	922(ra) # 5a2a <open>
    2698:	84aa                	mv	s1,a0
  if(fd < 0){
    269a:	38054463          	bltz	a0,2a22 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    269e:	660d                	lui	a2,0x3
    26a0:	0000a597          	auipc	a1,0xa
    26a4:	93858593          	addi	a1,a1,-1736 # bfd8 <buf>
    26a8:	00003097          	auipc	ra,0x3
    26ac:	35a080e7          	jalr	858(ra) # 5a02 <read>
    26b0:	4789                	li	a5,2
    26b2:	38f51663          	bne	a0,a5,2a3e <subdir+0x55e>
  close(fd);
    26b6:	8526                	mv	a0,s1
    26b8:	00003097          	auipc	ra,0x3
    26bc:	35a080e7          	jalr	858(ra) # 5a12 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    26c0:	4581                	li	a1,0
    26c2:	00005517          	auipc	a0,0x5
    26c6:	c6e50513          	addi	a0,a0,-914 # 7330 <csem_up+0x12fc>
    26ca:	00003097          	auipc	ra,0x3
    26ce:	360080e7          	jalr	864(ra) # 5a2a <open>
    26d2:	38055463          	bgez	a0,2a5a <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    26d6:	20200593          	li	a1,514
    26da:	00005517          	auipc	a0,0x5
    26de:	e6650513          	addi	a0,a0,-410 # 7540 <csem_up+0x150c>
    26e2:	00003097          	auipc	ra,0x3
    26e6:	348080e7          	jalr	840(ra) # 5a2a <open>
    26ea:	38055663          	bgez	a0,2a76 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    26ee:	20200593          	li	a1,514
    26f2:	00005517          	auipc	a0,0x5
    26f6:	e7e50513          	addi	a0,a0,-386 # 7570 <csem_up+0x153c>
    26fa:	00003097          	auipc	ra,0x3
    26fe:	330080e7          	jalr	816(ra) # 5a2a <open>
    2702:	38055863          	bgez	a0,2a92 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    2706:	20000593          	li	a1,512
    270a:	00005517          	auipc	a0,0x5
    270e:	b8650513          	addi	a0,a0,-1146 # 7290 <csem_up+0x125c>
    2712:	00003097          	auipc	ra,0x3
    2716:	318080e7          	jalr	792(ra) # 5a2a <open>
    271a:	38055a63          	bgez	a0,2aae <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    271e:	4589                	li	a1,2
    2720:	00005517          	auipc	a0,0x5
    2724:	b7050513          	addi	a0,a0,-1168 # 7290 <csem_up+0x125c>
    2728:	00003097          	auipc	ra,0x3
    272c:	302080e7          	jalr	770(ra) # 5a2a <open>
    2730:	38055d63          	bgez	a0,2aca <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    2734:	4585                	li	a1,1
    2736:	00005517          	auipc	a0,0x5
    273a:	b5a50513          	addi	a0,a0,-1190 # 7290 <csem_up+0x125c>
    273e:	00003097          	auipc	ra,0x3
    2742:	2ec080e7          	jalr	748(ra) # 5a2a <open>
    2746:	3a055063          	bgez	a0,2ae6 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    274a:	00005597          	auipc	a1,0x5
    274e:	eb658593          	addi	a1,a1,-330 # 7600 <csem_up+0x15cc>
    2752:	00005517          	auipc	a0,0x5
    2756:	dee50513          	addi	a0,a0,-530 # 7540 <csem_up+0x150c>
    275a:	00003097          	auipc	ra,0x3
    275e:	2f0080e7          	jalr	752(ra) # 5a4a <link>
    2762:	3a050063          	beqz	a0,2b02 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2766:	00005597          	auipc	a1,0x5
    276a:	e9a58593          	addi	a1,a1,-358 # 7600 <csem_up+0x15cc>
    276e:	00005517          	auipc	a0,0x5
    2772:	e0250513          	addi	a0,a0,-510 # 7570 <csem_up+0x153c>
    2776:	00003097          	auipc	ra,0x3
    277a:	2d4080e7          	jalr	724(ra) # 5a4a <link>
    277e:	3a050063          	beqz	a0,2b1e <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2782:	00005597          	auipc	a1,0x5
    2786:	c3658593          	addi	a1,a1,-970 # 73b8 <csem_up+0x1384>
    278a:	00005517          	auipc	a0,0x5
    278e:	b2650513          	addi	a0,a0,-1242 # 72b0 <csem_up+0x127c>
    2792:	00003097          	auipc	ra,0x3
    2796:	2b8080e7          	jalr	696(ra) # 5a4a <link>
    279a:	3a050063          	beqz	a0,2b3a <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    279e:	00005517          	auipc	a0,0x5
    27a2:	da250513          	addi	a0,a0,-606 # 7540 <csem_up+0x150c>
    27a6:	00003097          	auipc	ra,0x3
    27aa:	2ac080e7          	jalr	684(ra) # 5a52 <mkdir>
    27ae:	3a050463          	beqz	a0,2b56 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    27b2:	00005517          	auipc	a0,0x5
    27b6:	dbe50513          	addi	a0,a0,-578 # 7570 <csem_up+0x153c>
    27ba:	00003097          	auipc	ra,0x3
    27be:	298080e7          	jalr	664(ra) # 5a52 <mkdir>
    27c2:	3a050863          	beqz	a0,2b72 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    27c6:	00005517          	auipc	a0,0x5
    27ca:	bf250513          	addi	a0,a0,-1038 # 73b8 <csem_up+0x1384>
    27ce:	00003097          	auipc	ra,0x3
    27d2:	284080e7          	jalr	644(ra) # 5a52 <mkdir>
    27d6:	3a050c63          	beqz	a0,2b8e <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    27da:	00005517          	auipc	a0,0x5
    27de:	d9650513          	addi	a0,a0,-618 # 7570 <csem_up+0x153c>
    27e2:	00003097          	auipc	ra,0x3
    27e6:	258080e7          	jalr	600(ra) # 5a3a <unlink>
    27ea:	3c050063          	beqz	a0,2baa <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    27ee:	00005517          	auipc	a0,0x5
    27f2:	d5250513          	addi	a0,a0,-686 # 7540 <csem_up+0x150c>
    27f6:	00003097          	auipc	ra,0x3
    27fa:	244080e7          	jalr	580(ra) # 5a3a <unlink>
    27fe:	3c050463          	beqz	a0,2bc6 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    2802:	00005517          	auipc	a0,0x5
    2806:	aae50513          	addi	a0,a0,-1362 # 72b0 <csem_up+0x127c>
    280a:	00003097          	auipc	ra,0x3
    280e:	250080e7          	jalr	592(ra) # 5a5a <chdir>
    2812:	3c050863          	beqz	a0,2be2 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    2816:	00005517          	auipc	a0,0x5
    281a:	f3a50513          	addi	a0,a0,-198 # 7750 <csem_up+0x171c>
    281e:	00003097          	auipc	ra,0x3
    2822:	23c080e7          	jalr	572(ra) # 5a5a <chdir>
    2826:	3c050c63          	beqz	a0,2bfe <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    282a:	00005517          	auipc	a0,0x5
    282e:	b8e50513          	addi	a0,a0,-1138 # 73b8 <csem_up+0x1384>
    2832:	00003097          	auipc	ra,0x3
    2836:	208080e7          	jalr	520(ra) # 5a3a <unlink>
    283a:	3e051063          	bnez	a0,2c1a <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    283e:	00005517          	auipc	a0,0x5
    2842:	a7250513          	addi	a0,a0,-1422 # 72b0 <csem_up+0x127c>
    2846:	00003097          	auipc	ra,0x3
    284a:	1f4080e7          	jalr	500(ra) # 5a3a <unlink>
    284e:	3e051463          	bnez	a0,2c36 <subdir+0x756>
  if(unlink("dd") == 0){
    2852:	00005517          	auipc	a0,0x5
    2856:	a3e50513          	addi	a0,a0,-1474 # 7290 <csem_up+0x125c>
    285a:	00003097          	auipc	ra,0x3
    285e:	1e0080e7          	jalr	480(ra) # 5a3a <unlink>
    2862:	3e050863          	beqz	a0,2c52 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    2866:	00005517          	auipc	a0,0x5
    286a:	f5a50513          	addi	a0,a0,-166 # 77c0 <csem_up+0x178c>
    286e:	00003097          	auipc	ra,0x3
    2872:	1cc080e7          	jalr	460(ra) # 5a3a <unlink>
    2876:	3e054c63          	bltz	a0,2c6e <subdir+0x78e>
  if(unlink("dd") < 0){
    287a:	00005517          	auipc	a0,0x5
    287e:	a1650513          	addi	a0,a0,-1514 # 7290 <csem_up+0x125c>
    2882:	00003097          	auipc	ra,0x3
    2886:	1b8080e7          	jalr	440(ra) # 5a3a <unlink>
    288a:	40054063          	bltz	a0,2c8a <subdir+0x7aa>
}
    288e:	60e2                	ld	ra,24(sp)
    2890:	6442                	ld	s0,16(sp)
    2892:	64a2                	ld	s1,8(sp)
    2894:	6902                	ld	s2,0(sp)
    2896:	6105                	addi	sp,sp,32
    2898:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    289a:	85ca                	mv	a1,s2
    289c:	00005517          	auipc	a0,0x5
    28a0:	9fc50513          	addi	a0,a0,-1540 # 7298 <csem_up+0x1264>
    28a4:	00003097          	auipc	ra,0x3
    28a8:	518080e7          	jalr	1304(ra) # 5dbc <printf>
    exit(1);
    28ac:	4505                	li	a0,1
    28ae:	00003097          	auipc	ra,0x3
    28b2:	13c080e7          	jalr	316(ra) # 59ea <exit>
    printf("%s: create dd/ff failed\n", s);
    28b6:	85ca                	mv	a1,s2
    28b8:	00005517          	auipc	a0,0x5
    28bc:	a0050513          	addi	a0,a0,-1536 # 72b8 <csem_up+0x1284>
    28c0:	00003097          	auipc	ra,0x3
    28c4:	4fc080e7          	jalr	1276(ra) # 5dbc <printf>
    exit(1);
    28c8:	4505                	li	a0,1
    28ca:	00003097          	auipc	ra,0x3
    28ce:	120080e7          	jalr	288(ra) # 59ea <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    28d2:	85ca                	mv	a1,s2
    28d4:	00005517          	auipc	a0,0x5
    28d8:	a0450513          	addi	a0,a0,-1532 # 72d8 <csem_up+0x12a4>
    28dc:	00003097          	auipc	ra,0x3
    28e0:	4e0080e7          	jalr	1248(ra) # 5dbc <printf>
    exit(1);
    28e4:	4505                	li	a0,1
    28e6:	00003097          	auipc	ra,0x3
    28ea:	104080e7          	jalr	260(ra) # 59ea <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    28ee:	85ca                	mv	a1,s2
    28f0:	00005517          	auipc	a0,0x5
    28f4:	a2050513          	addi	a0,a0,-1504 # 7310 <csem_up+0x12dc>
    28f8:	00003097          	auipc	ra,0x3
    28fc:	4c4080e7          	jalr	1220(ra) # 5dbc <printf>
    exit(1);
    2900:	4505                	li	a0,1
    2902:	00003097          	auipc	ra,0x3
    2906:	0e8080e7          	jalr	232(ra) # 59ea <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    290a:	85ca                	mv	a1,s2
    290c:	00005517          	auipc	a0,0x5
    2910:	a3450513          	addi	a0,a0,-1484 # 7340 <csem_up+0x130c>
    2914:	00003097          	auipc	ra,0x3
    2918:	4a8080e7          	jalr	1192(ra) # 5dbc <printf>
    exit(1);
    291c:	4505                	li	a0,1
    291e:	00003097          	auipc	ra,0x3
    2922:	0cc080e7          	jalr	204(ra) # 59ea <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2926:	85ca                	mv	a1,s2
    2928:	00005517          	auipc	a0,0x5
    292c:	a5050513          	addi	a0,a0,-1456 # 7378 <csem_up+0x1344>
    2930:	00003097          	auipc	ra,0x3
    2934:	48c080e7          	jalr	1164(ra) # 5dbc <printf>
    exit(1);
    2938:	4505                	li	a0,1
    293a:	00003097          	auipc	ra,0x3
    293e:	0b0080e7          	jalr	176(ra) # 59ea <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2942:	85ca                	mv	a1,s2
    2944:	00005517          	auipc	a0,0x5
    2948:	a5450513          	addi	a0,a0,-1452 # 7398 <csem_up+0x1364>
    294c:	00003097          	auipc	ra,0x3
    2950:	470080e7          	jalr	1136(ra) # 5dbc <printf>
    exit(1);
    2954:	4505                	li	a0,1
    2956:	00003097          	auipc	ra,0x3
    295a:	094080e7          	jalr	148(ra) # 59ea <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    295e:	85ca                	mv	a1,s2
    2960:	00005517          	auipc	a0,0x5
    2964:	a6850513          	addi	a0,a0,-1432 # 73c8 <csem_up+0x1394>
    2968:	00003097          	auipc	ra,0x3
    296c:	454080e7          	jalr	1108(ra) # 5dbc <printf>
    exit(1);
    2970:	4505                	li	a0,1
    2972:	00003097          	auipc	ra,0x3
    2976:	078080e7          	jalr	120(ra) # 59ea <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    297a:	85ca                	mv	a1,s2
    297c:	00005517          	auipc	a0,0x5
    2980:	a7450513          	addi	a0,a0,-1420 # 73f0 <csem_up+0x13bc>
    2984:	00003097          	auipc	ra,0x3
    2988:	438080e7          	jalr	1080(ra) # 5dbc <printf>
    exit(1);
    298c:	4505                	li	a0,1
    298e:	00003097          	auipc	ra,0x3
    2992:	05c080e7          	jalr	92(ra) # 59ea <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2996:	85ca                	mv	a1,s2
    2998:	00005517          	auipc	a0,0x5
    299c:	a7850513          	addi	a0,a0,-1416 # 7410 <csem_up+0x13dc>
    29a0:	00003097          	auipc	ra,0x3
    29a4:	41c080e7          	jalr	1052(ra) # 5dbc <printf>
    exit(1);
    29a8:	4505                	li	a0,1
    29aa:	00003097          	auipc	ra,0x3
    29ae:	040080e7          	jalr	64(ra) # 59ea <exit>
    printf("%s: chdir dd failed\n", s);
    29b2:	85ca                	mv	a1,s2
    29b4:	00005517          	auipc	a0,0x5
    29b8:	a8450513          	addi	a0,a0,-1404 # 7438 <csem_up+0x1404>
    29bc:	00003097          	auipc	ra,0x3
    29c0:	400080e7          	jalr	1024(ra) # 5dbc <printf>
    exit(1);
    29c4:	4505                	li	a0,1
    29c6:	00003097          	auipc	ra,0x3
    29ca:	024080e7          	jalr	36(ra) # 59ea <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    29ce:	85ca                	mv	a1,s2
    29d0:	00005517          	auipc	a0,0x5
    29d4:	a9050513          	addi	a0,a0,-1392 # 7460 <csem_up+0x142c>
    29d8:	00003097          	auipc	ra,0x3
    29dc:	3e4080e7          	jalr	996(ra) # 5dbc <printf>
    exit(1);
    29e0:	4505                	li	a0,1
    29e2:	00003097          	auipc	ra,0x3
    29e6:	008080e7          	jalr	8(ra) # 59ea <exit>
    printf("chdir dd/../../dd failed\n", s);
    29ea:	85ca                	mv	a1,s2
    29ec:	00005517          	auipc	a0,0x5
    29f0:	aa450513          	addi	a0,a0,-1372 # 7490 <csem_up+0x145c>
    29f4:	00003097          	auipc	ra,0x3
    29f8:	3c8080e7          	jalr	968(ra) # 5dbc <printf>
    exit(1);
    29fc:	4505                	li	a0,1
    29fe:	00003097          	auipc	ra,0x3
    2a02:	fec080e7          	jalr	-20(ra) # 59ea <exit>
    printf("%s: chdir ./.. failed\n", s);
    2a06:	85ca                	mv	a1,s2
    2a08:	00005517          	auipc	a0,0x5
    2a0c:	ab050513          	addi	a0,a0,-1360 # 74b8 <csem_up+0x1484>
    2a10:	00003097          	auipc	ra,0x3
    2a14:	3ac080e7          	jalr	940(ra) # 5dbc <printf>
    exit(1);
    2a18:	4505                	li	a0,1
    2a1a:	00003097          	auipc	ra,0x3
    2a1e:	fd0080e7          	jalr	-48(ra) # 59ea <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2a22:	85ca                	mv	a1,s2
    2a24:	00005517          	auipc	a0,0x5
    2a28:	aac50513          	addi	a0,a0,-1364 # 74d0 <csem_up+0x149c>
    2a2c:	00003097          	auipc	ra,0x3
    2a30:	390080e7          	jalr	912(ra) # 5dbc <printf>
    exit(1);
    2a34:	4505                	li	a0,1
    2a36:	00003097          	auipc	ra,0x3
    2a3a:	fb4080e7          	jalr	-76(ra) # 59ea <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2a3e:	85ca                	mv	a1,s2
    2a40:	00005517          	auipc	a0,0x5
    2a44:	ab050513          	addi	a0,a0,-1360 # 74f0 <csem_up+0x14bc>
    2a48:	00003097          	auipc	ra,0x3
    2a4c:	374080e7          	jalr	884(ra) # 5dbc <printf>
    exit(1);
    2a50:	4505                	li	a0,1
    2a52:	00003097          	auipc	ra,0x3
    2a56:	f98080e7          	jalr	-104(ra) # 59ea <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2a5a:	85ca                	mv	a1,s2
    2a5c:	00005517          	auipc	a0,0x5
    2a60:	ab450513          	addi	a0,a0,-1356 # 7510 <csem_up+0x14dc>
    2a64:	00003097          	auipc	ra,0x3
    2a68:	358080e7          	jalr	856(ra) # 5dbc <printf>
    exit(1);
    2a6c:	4505                	li	a0,1
    2a6e:	00003097          	auipc	ra,0x3
    2a72:	f7c080e7          	jalr	-132(ra) # 59ea <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2a76:	85ca                	mv	a1,s2
    2a78:	00005517          	auipc	a0,0x5
    2a7c:	ad850513          	addi	a0,a0,-1320 # 7550 <csem_up+0x151c>
    2a80:	00003097          	auipc	ra,0x3
    2a84:	33c080e7          	jalr	828(ra) # 5dbc <printf>
    exit(1);
    2a88:	4505                	li	a0,1
    2a8a:	00003097          	auipc	ra,0x3
    2a8e:	f60080e7          	jalr	-160(ra) # 59ea <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2a92:	85ca                	mv	a1,s2
    2a94:	00005517          	auipc	a0,0x5
    2a98:	aec50513          	addi	a0,a0,-1300 # 7580 <csem_up+0x154c>
    2a9c:	00003097          	auipc	ra,0x3
    2aa0:	320080e7          	jalr	800(ra) # 5dbc <printf>
    exit(1);
    2aa4:	4505                	li	a0,1
    2aa6:	00003097          	auipc	ra,0x3
    2aaa:	f44080e7          	jalr	-188(ra) # 59ea <exit>
    printf("%s: create dd succeeded!\n", s);
    2aae:	85ca                	mv	a1,s2
    2ab0:	00005517          	auipc	a0,0x5
    2ab4:	af050513          	addi	a0,a0,-1296 # 75a0 <csem_up+0x156c>
    2ab8:	00003097          	auipc	ra,0x3
    2abc:	304080e7          	jalr	772(ra) # 5dbc <printf>
    exit(1);
    2ac0:	4505                	li	a0,1
    2ac2:	00003097          	auipc	ra,0x3
    2ac6:	f28080e7          	jalr	-216(ra) # 59ea <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    2aca:	85ca                	mv	a1,s2
    2acc:	00005517          	auipc	a0,0x5
    2ad0:	af450513          	addi	a0,a0,-1292 # 75c0 <csem_up+0x158c>
    2ad4:	00003097          	auipc	ra,0x3
    2ad8:	2e8080e7          	jalr	744(ra) # 5dbc <printf>
    exit(1);
    2adc:	4505                	li	a0,1
    2ade:	00003097          	auipc	ra,0x3
    2ae2:	f0c080e7          	jalr	-244(ra) # 59ea <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    2ae6:	85ca                	mv	a1,s2
    2ae8:	00005517          	auipc	a0,0x5
    2aec:	af850513          	addi	a0,a0,-1288 # 75e0 <csem_up+0x15ac>
    2af0:	00003097          	auipc	ra,0x3
    2af4:	2cc080e7          	jalr	716(ra) # 5dbc <printf>
    exit(1);
    2af8:	4505                	li	a0,1
    2afa:	00003097          	auipc	ra,0x3
    2afe:	ef0080e7          	jalr	-272(ra) # 59ea <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    2b02:	85ca                	mv	a1,s2
    2b04:	00005517          	auipc	a0,0x5
    2b08:	b0c50513          	addi	a0,a0,-1268 # 7610 <csem_up+0x15dc>
    2b0c:	00003097          	auipc	ra,0x3
    2b10:	2b0080e7          	jalr	688(ra) # 5dbc <printf>
    exit(1);
    2b14:	4505                	li	a0,1
    2b16:	00003097          	auipc	ra,0x3
    2b1a:	ed4080e7          	jalr	-300(ra) # 59ea <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    2b1e:	85ca                	mv	a1,s2
    2b20:	00005517          	auipc	a0,0x5
    2b24:	b1850513          	addi	a0,a0,-1256 # 7638 <csem_up+0x1604>
    2b28:	00003097          	auipc	ra,0x3
    2b2c:	294080e7          	jalr	660(ra) # 5dbc <printf>
    exit(1);
    2b30:	4505                	li	a0,1
    2b32:	00003097          	auipc	ra,0x3
    2b36:	eb8080e7          	jalr	-328(ra) # 59ea <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    2b3a:	85ca                	mv	a1,s2
    2b3c:	00005517          	auipc	a0,0x5
    2b40:	b2450513          	addi	a0,a0,-1244 # 7660 <csem_up+0x162c>
    2b44:	00003097          	auipc	ra,0x3
    2b48:	278080e7          	jalr	632(ra) # 5dbc <printf>
    exit(1);
    2b4c:	4505                	li	a0,1
    2b4e:	00003097          	auipc	ra,0x3
    2b52:	e9c080e7          	jalr	-356(ra) # 59ea <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    2b56:	85ca                	mv	a1,s2
    2b58:	00005517          	auipc	a0,0x5
    2b5c:	b3050513          	addi	a0,a0,-1232 # 7688 <csem_up+0x1654>
    2b60:	00003097          	auipc	ra,0x3
    2b64:	25c080e7          	jalr	604(ra) # 5dbc <printf>
    exit(1);
    2b68:	4505                	li	a0,1
    2b6a:	00003097          	auipc	ra,0x3
    2b6e:	e80080e7          	jalr	-384(ra) # 59ea <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    2b72:	85ca                	mv	a1,s2
    2b74:	00005517          	auipc	a0,0x5
    2b78:	b3450513          	addi	a0,a0,-1228 # 76a8 <csem_up+0x1674>
    2b7c:	00003097          	auipc	ra,0x3
    2b80:	240080e7          	jalr	576(ra) # 5dbc <printf>
    exit(1);
    2b84:	4505                	li	a0,1
    2b86:	00003097          	auipc	ra,0x3
    2b8a:	e64080e7          	jalr	-412(ra) # 59ea <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    2b8e:	85ca                	mv	a1,s2
    2b90:	00005517          	auipc	a0,0x5
    2b94:	b3850513          	addi	a0,a0,-1224 # 76c8 <csem_up+0x1694>
    2b98:	00003097          	auipc	ra,0x3
    2b9c:	224080e7          	jalr	548(ra) # 5dbc <printf>
    exit(1);
    2ba0:	4505                	li	a0,1
    2ba2:	00003097          	auipc	ra,0x3
    2ba6:	e48080e7          	jalr	-440(ra) # 59ea <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    2baa:	85ca                	mv	a1,s2
    2bac:	00005517          	auipc	a0,0x5
    2bb0:	b4450513          	addi	a0,a0,-1212 # 76f0 <csem_up+0x16bc>
    2bb4:	00003097          	auipc	ra,0x3
    2bb8:	208080e7          	jalr	520(ra) # 5dbc <printf>
    exit(1);
    2bbc:	4505                	li	a0,1
    2bbe:	00003097          	auipc	ra,0x3
    2bc2:	e2c080e7          	jalr	-468(ra) # 59ea <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    2bc6:	85ca                	mv	a1,s2
    2bc8:	00005517          	auipc	a0,0x5
    2bcc:	b4850513          	addi	a0,a0,-1208 # 7710 <csem_up+0x16dc>
    2bd0:	00003097          	auipc	ra,0x3
    2bd4:	1ec080e7          	jalr	492(ra) # 5dbc <printf>
    exit(1);
    2bd8:	4505                	li	a0,1
    2bda:	00003097          	auipc	ra,0x3
    2bde:	e10080e7          	jalr	-496(ra) # 59ea <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    2be2:	85ca                	mv	a1,s2
    2be4:	00005517          	auipc	a0,0x5
    2be8:	b4c50513          	addi	a0,a0,-1204 # 7730 <csem_up+0x16fc>
    2bec:	00003097          	auipc	ra,0x3
    2bf0:	1d0080e7          	jalr	464(ra) # 5dbc <printf>
    exit(1);
    2bf4:	4505                	li	a0,1
    2bf6:	00003097          	auipc	ra,0x3
    2bfa:	df4080e7          	jalr	-524(ra) # 59ea <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    2bfe:	85ca                	mv	a1,s2
    2c00:	00005517          	auipc	a0,0x5
    2c04:	b5850513          	addi	a0,a0,-1192 # 7758 <csem_up+0x1724>
    2c08:	00003097          	auipc	ra,0x3
    2c0c:	1b4080e7          	jalr	436(ra) # 5dbc <printf>
    exit(1);
    2c10:	4505                	li	a0,1
    2c12:	00003097          	auipc	ra,0x3
    2c16:	dd8080e7          	jalr	-552(ra) # 59ea <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2c1a:	85ca                	mv	a1,s2
    2c1c:	00004517          	auipc	a0,0x4
    2c20:	7d450513          	addi	a0,a0,2004 # 73f0 <csem_up+0x13bc>
    2c24:	00003097          	auipc	ra,0x3
    2c28:	198080e7          	jalr	408(ra) # 5dbc <printf>
    exit(1);
    2c2c:	4505                	li	a0,1
    2c2e:	00003097          	auipc	ra,0x3
    2c32:	dbc080e7          	jalr	-580(ra) # 59ea <exit>
    printf("%s: unlink dd/ff failed\n", s);
    2c36:	85ca                	mv	a1,s2
    2c38:	00005517          	auipc	a0,0x5
    2c3c:	b4050513          	addi	a0,a0,-1216 # 7778 <csem_up+0x1744>
    2c40:	00003097          	auipc	ra,0x3
    2c44:	17c080e7          	jalr	380(ra) # 5dbc <printf>
    exit(1);
    2c48:	4505                	li	a0,1
    2c4a:	00003097          	auipc	ra,0x3
    2c4e:	da0080e7          	jalr	-608(ra) # 59ea <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    2c52:	85ca                	mv	a1,s2
    2c54:	00005517          	auipc	a0,0x5
    2c58:	b4450513          	addi	a0,a0,-1212 # 7798 <csem_up+0x1764>
    2c5c:	00003097          	auipc	ra,0x3
    2c60:	160080e7          	jalr	352(ra) # 5dbc <printf>
    exit(1);
    2c64:	4505                	li	a0,1
    2c66:	00003097          	auipc	ra,0x3
    2c6a:	d84080e7          	jalr	-636(ra) # 59ea <exit>
    printf("%s: unlink dd/dd failed\n", s);
    2c6e:	85ca                	mv	a1,s2
    2c70:	00005517          	auipc	a0,0x5
    2c74:	b5850513          	addi	a0,a0,-1192 # 77c8 <csem_up+0x1794>
    2c78:	00003097          	auipc	ra,0x3
    2c7c:	144080e7          	jalr	324(ra) # 5dbc <printf>
    exit(1);
    2c80:	4505                	li	a0,1
    2c82:	00003097          	auipc	ra,0x3
    2c86:	d68080e7          	jalr	-664(ra) # 59ea <exit>
    printf("%s: unlink dd failed\n", s);
    2c8a:	85ca                	mv	a1,s2
    2c8c:	00005517          	auipc	a0,0x5
    2c90:	b5c50513          	addi	a0,a0,-1188 # 77e8 <csem_up+0x17b4>
    2c94:	00003097          	auipc	ra,0x3
    2c98:	128080e7          	jalr	296(ra) # 5dbc <printf>
    exit(1);
    2c9c:	4505                	li	a0,1
    2c9e:	00003097          	auipc	ra,0x3
    2ca2:	d4c080e7          	jalr	-692(ra) # 59ea <exit>

0000000000002ca6 <rmdot>:
{
    2ca6:	1101                	addi	sp,sp,-32
    2ca8:	ec06                	sd	ra,24(sp)
    2caa:	e822                	sd	s0,16(sp)
    2cac:	e426                	sd	s1,8(sp)
    2cae:	1000                	addi	s0,sp,32
    2cb0:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    2cb2:	00005517          	auipc	a0,0x5
    2cb6:	b4e50513          	addi	a0,a0,-1202 # 7800 <csem_up+0x17cc>
    2cba:	00003097          	auipc	ra,0x3
    2cbe:	d98080e7          	jalr	-616(ra) # 5a52 <mkdir>
    2cc2:	e549                	bnez	a0,2d4c <rmdot+0xa6>
  if(chdir("dots") != 0){
    2cc4:	00005517          	auipc	a0,0x5
    2cc8:	b3c50513          	addi	a0,a0,-1220 # 7800 <csem_up+0x17cc>
    2ccc:	00003097          	auipc	ra,0x3
    2cd0:	d8e080e7          	jalr	-626(ra) # 5a5a <chdir>
    2cd4:	e951                	bnez	a0,2d68 <rmdot+0xc2>
  if(unlink(".") == 0){
    2cd6:	00004517          	auipc	a0,0x4
    2cda:	e3a50513          	addi	a0,a0,-454 # 6b10 <csem_up+0xadc>
    2cde:	00003097          	auipc	ra,0x3
    2ce2:	d5c080e7          	jalr	-676(ra) # 5a3a <unlink>
    2ce6:	cd59                	beqz	a0,2d84 <rmdot+0xde>
  if(unlink("..") == 0){
    2ce8:	00004517          	auipc	a0,0x4
    2cec:	57050513          	addi	a0,a0,1392 # 7258 <csem_up+0x1224>
    2cf0:	00003097          	auipc	ra,0x3
    2cf4:	d4a080e7          	jalr	-694(ra) # 5a3a <unlink>
    2cf8:	c545                	beqz	a0,2da0 <rmdot+0xfa>
  if(chdir("/") != 0){
    2cfa:	00004517          	auipc	a0,0x4
    2cfe:	50650513          	addi	a0,a0,1286 # 7200 <csem_up+0x11cc>
    2d02:	00003097          	auipc	ra,0x3
    2d06:	d58080e7          	jalr	-680(ra) # 5a5a <chdir>
    2d0a:	e94d                	bnez	a0,2dbc <rmdot+0x116>
  if(unlink("dots/.") == 0){
    2d0c:	00005517          	auipc	a0,0x5
    2d10:	b5c50513          	addi	a0,a0,-1188 # 7868 <csem_up+0x1834>
    2d14:	00003097          	auipc	ra,0x3
    2d18:	d26080e7          	jalr	-730(ra) # 5a3a <unlink>
    2d1c:	cd55                	beqz	a0,2dd8 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    2d1e:	00005517          	auipc	a0,0x5
    2d22:	b7250513          	addi	a0,a0,-1166 # 7890 <csem_up+0x185c>
    2d26:	00003097          	auipc	ra,0x3
    2d2a:	d14080e7          	jalr	-748(ra) # 5a3a <unlink>
    2d2e:	c179                	beqz	a0,2df4 <rmdot+0x14e>
  if(unlink("dots") != 0){
    2d30:	00005517          	auipc	a0,0x5
    2d34:	ad050513          	addi	a0,a0,-1328 # 7800 <csem_up+0x17cc>
    2d38:	00003097          	auipc	ra,0x3
    2d3c:	d02080e7          	jalr	-766(ra) # 5a3a <unlink>
    2d40:	e961                	bnez	a0,2e10 <rmdot+0x16a>
}
    2d42:	60e2                	ld	ra,24(sp)
    2d44:	6442                	ld	s0,16(sp)
    2d46:	64a2                	ld	s1,8(sp)
    2d48:	6105                	addi	sp,sp,32
    2d4a:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    2d4c:	85a6                	mv	a1,s1
    2d4e:	00005517          	auipc	a0,0x5
    2d52:	aba50513          	addi	a0,a0,-1350 # 7808 <csem_up+0x17d4>
    2d56:	00003097          	auipc	ra,0x3
    2d5a:	066080e7          	jalr	102(ra) # 5dbc <printf>
    exit(1);
    2d5e:	4505                	li	a0,1
    2d60:	00003097          	auipc	ra,0x3
    2d64:	c8a080e7          	jalr	-886(ra) # 59ea <exit>
    printf("%s: chdir dots failed\n", s);
    2d68:	85a6                	mv	a1,s1
    2d6a:	00005517          	auipc	a0,0x5
    2d6e:	ab650513          	addi	a0,a0,-1354 # 7820 <csem_up+0x17ec>
    2d72:	00003097          	auipc	ra,0x3
    2d76:	04a080e7          	jalr	74(ra) # 5dbc <printf>
    exit(1);
    2d7a:	4505                	li	a0,1
    2d7c:	00003097          	auipc	ra,0x3
    2d80:	c6e080e7          	jalr	-914(ra) # 59ea <exit>
    printf("%s: rm . worked!\n", s);
    2d84:	85a6                	mv	a1,s1
    2d86:	00005517          	auipc	a0,0x5
    2d8a:	ab250513          	addi	a0,a0,-1358 # 7838 <csem_up+0x1804>
    2d8e:	00003097          	auipc	ra,0x3
    2d92:	02e080e7          	jalr	46(ra) # 5dbc <printf>
    exit(1);
    2d96:	4505                	li	a0,1
    2d98:	00003097          	auipc	ra,0x3
    2d9c:	c52080e7          	jalr	-942(ra) # 59ea <exit>
    printf("%s: rm .. worked!\n", s);
    2da0:	85a6                	mv	a1,s1
    2da2:	00005517          	auipc	a0,0x5
    2da6:	aae50513          	addi	a0,a0,-1362 # 7850 <csem_up+0x181c>
    2daa:	00003097          	auipc	ra,0x3
    2dae:	012080e7          	jalr	18(ra) # 5dbc <printf>
    exit(1);
    2db2:	4505                	li	a0,1
    2db4:	00003097          	auipc	ra,0x3
    2db8:	c36080e7          	jalr	-970(ra) # 59ea <exit>
    printf("%s: chdir / failed\n", s);
    2dbc:	85a6                	mv	a1,s1
    2dbe:	00004517          	auipc	a0,0x4
    2dc2:	44a50513          	addi	a0,a0,1098 # 7208 <csem_up+0x11d4>
    2dc6:	00003097          	auipc	ra,0x3
    2dca:	ff6080e7          	jalr	-10(ra) # 5dbc <printf>
    exit(1);
    2dce:	4505                	li	a0,1
    2dd0:	00003097          	auipc	ra,0x3
    2dd4:	c1a080e7          	jalr	-998(ra) # 59ea <exit>
    printf("%s: unlink dots/. worked!\n", s);
    2dd8:	85a6                	mv	a1,s1
    2dda:	00005517          	auipc	a0,0x5
    2dde:	a9650513          	addi	a0,a0,-1386 # 7870 <csem_up+0x183c>
    2de2:	00003097          	auipc	ra,0x3
    2de6:	fda080e7          	jalr	-38(ra) # 5dbc <printf>
    exit(1);
    2dea:	4505                	li	a0,1
    2dec:	00003097          	auipc	ra,0x3
    2df0:	bfe080e7          	jalr	-1026(ra) # 59ea <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    2df4:	85a6                	mv	a1,s1
    2df6:	00005517          	auipc	a0,0x5
    2dfa:	aa250513          	addi	a0,a0,-1374 # 7898 <csem_up+0x1864>
    2dfe:	00003097          	auipc	ra,0x3
    2e02:	fbe080e7          	jalr	-66(ra) # 5dbc <printf>
    exit(1);
    2e06:	4505                	li	a0,1
    2e08:	00003097          	auipc	ra,0x3
    2e0c:	be2080e7          	jalr	-1054(ra) # 59ea <exit>
    printf("%s: unlink dots failed!\n", s);
    2e10:	85a6                	mv	a1,s1
    2e12:	00005517          	auipc	a0,0x5
    2e16:	aa650513          	addi	a0,a0,-1370 # 78b8 <csem_up+0x1884>
    2e1a:	00003097          	auipc	ra,0x3
    2e1e:	fa2080e7          	jalr	-94(ra) # 5dbc <printf>
    exit(1);
    2e22:	4505                	li	a0,1
    2e24:	00003097          	auipc	ra,0x3
    2e28:	bc6080e7          	jalr	-1082(ra) # 59ea <exit>

0000000000002e2c <dirfile>:
{
    2e2c:	1101                	addi	sp,sp,-32
    2e2e:	ec06                	sd	ra,24(sp)
    2e30:	e822                	sd	s0,16(sp)
    2e32:	e426                	sd	s1,8(sp)
    2e34:	e04a                	sd	s2,0(sp)
    2e36:	1000                	addi	s0,sp,32
    2e38:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    2e3a:	20000593          	li	a1,512
    2e3e:	00003517          	auipc	a0,0x3
    2e42:	47250513          	addi	a0,a0,1138 # 62b0 <csem_up+0x27c>
    2e46:	00003097          	auipc	ra,0x3
    2e4a:	be4080e7          	jalr	-1052(ra) # 5a2a <open>
  if(fd < 0){
    2e4e:	0e054d63          	bltz	a0,2f48 <dirfile+0x11c>
  close(fd);
    2e52:	00003097          	auipc	ra,0x3
    2e56:	bc0080e7          	jalr	-1088(ra) # 5a12 <close>
  if(chdir("dirfile") == 0){
    2e5a:	00003517          	auipc	a0,0x3
    2e5e:	45650513          	addi	a0,a0,1110 # 62b0 <csem_up+0x27c>
    2e62:	00003097          	auipc	ra,0x3
    2e66:	bf8080e7          	jalr	-1032(ra) # 5a5a <chdir>
    2e6a:	cd6d                	beqz	a0,2f64 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    2e6c:	4581                	li	a1,0
    2e6e:	00005517          	auipc	a0,0x5
    2e72:	aaa50513          	addi	a0,a0,-1366 # 7918 <csem_up+0x18e4>
    2e76:	00003097          	auipc	ra,0x3
    2e7a:	bb4080e7          	jalr	-1100(ra) # 5a2a <open>
  if(fd >= 0){
    2e7e:	10055163          	bgez	a0,2f80 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    2e82:	20000593          	li	a1,512
    2e86:	00005517          	auipc	a0,0x5
    2e8a:	a9250513          	addi	a0,a0,-1390 # 7918 <csem_up+0x18e4>
    2e8e:	00003097          	auipc	ra,0x3
    2e92:	b9c080e7          	jalr	-1124(ra) # 5a2a <open>
  if(fd >= 0){
    2e96:	10055363          	bgez	a0,2f9c <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    2e9a:	00005517          	auipc	a0,0x5
    2e9e:	a7e50513          	addi	a0,a0,-1410 # 7918 <csem_up+0x18e4>
    2ea2:	00003097          	auipc	ra,0x3
    2ea6:	bb0080e7          	jalr	-1104(ra) # 5a52 <mkdir>
    2eaa:	10050763          	beqz	a0,2fb8 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    2eae:	00005517          	auipc	a0,0x5
    2eb2:	a6a50513          	addi	a0,a0,-1430 # 7918 <csem_up+0x18e4>
    2eb6:	00003097          	auipc	ra,0x3
    2eba:	b84080e7          	jalr	-1148(ra) # 5a3a <unlink>
    2ebe:	10050b63          	beqz	a0,2fd4 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    2ec2:	00005597          	auipc	a1,0x5
    2ec6:	a5658593          	addi	a1,a1,-1450 # 7918 <csem_up+0x18e4>
    2eca:	00004517          	auipc	a0,0x4
    2ece:	85650513          	addi	a0,a0,-1962 # 6720 <csem_up+0x6ec>
    2ed2:	00003097          	auipc	ra,0x3
    2ed6:	b78080e7          	jalr	-1160(ra) # 5a4a <link>
    2eda:	10050b63          	beqz	a0,2ff0 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    2ede:	00003517          	auipc	a0,0x3
    2ee2:	3d250513          	addi	a0,a0,978 # 62b0 <csem_up+0x27c>
    2ee6:	00003097          	auipc	ra,0x3
    2eea:	b54080e7          	jalr	-1196(ra) # 5a3a <unlink>
    2eee:	10051f63          	bnez	a0,300c <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    2ef2:	4589                	li	a1,2
    2ef4:	00004517          	auipc	a0,0x4
    2ef8:	c1c50513          	addi	a0,a0,-996 # 6b10 <csem_up+0xadc>
    2efc:	00003097          	auipc	ra,0x3
    2f00:	b2e080e7          	jalr	-1234(ra) # 5a2a <open>
  if(fd >= 0){
    2f04:	12055263          	bgez	a0,3028 <dirfile+0x1fc>
  fd = open(".", 0);
    2f08:	4581                	li	a1,0
    2f0a:	00004517          	auipc	a0,0x4
    2f0e:	c0650513          	addi	a0,a0,-1018 # 6b10 <csem_up+0xadc>
    2f12:	00003097          	auipc	ra,0x3
    2f16:	b18080e7          	jalr	-1256(ra) # 5a2a <open>
    2f1a:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    2f1c:	4605                	li	a2,1
    2f1e:	00003597          	auipc	a1,0x3
    2f22:	6ca58593          	addi	a1,a1,1738 # 65e8 <csem_up+0x5b4>
    2f26:	00003097          	auipc	ra,0x3
    2f2a:	ae4080e7          	jalr	-1308(ra) # 5a0a <write>
    2f2e:	10a04b63          	bgtz	a0,3044 <dirfile+0x218>
  close(fd);
    2f32:	8526                	mv	a0,s1
    2f34:	00003097          	auipc	ra,0x3
    2f38:	ade080e7          	jalr	-1314(ra) # 5a12 <close>
}
    2f3c:	60e2                	ld	ra,24(sp)
    2f3e:	6442                	ld	s0,16(sp)
    2f40:	64a2                	ld	s1,8(sp)
    2f42:	6902                	ld	s2,0(sp)
    2f44:	6105                	addi	sp,sp,32
    2f46:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    2f48:	85ca                	mv	a1,s2
    2f4a:	00005517          	auipc	a0,0x5
    2f4e:	98e50513          	addi	a0,a0,-1650 # 78d8 <csem_up+0x18a4>
    2f52:	00003097          	auipc	ra,0x3
    2f56:	e6a080e7          	jalr	-406(ra) # 5dbc <printf>
    exit(1);
    2f5a:	4505                	li	a0,1
    2f5c:	00003097          	auipc	ra,0x3
    2f60:	a8e080e7          	jalr	-1394(ra) # 59ea <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    2f64:	85ca                	mv	a1,s2
    2f66:	00005517          	auipc	a0,0x5
    2f6a:	99250513          	addi	a0,a0,-1646 # 78f8 <csem_up+0x18c4>
    2f6e:	00003097          	auipc	ra,0x3
    2f72:	e4e080e7          	jalr	-434(ra) # 5dbc <printf>
    exit(1);
    2f76:	4505                	li	a0,1
    2f78:	00003097          	auipc	ra,0x3
    2f7c:	a72080e7          	jalr	-1422(ra) # 59ea <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    2f80:	85ca                	mv	a1,s2
    2f82:	00005517          	auipc	a0,0x5
    2f86:	9a650513          	addi	a0,a0,-1626 # 7928 <csem_up+0x18f4>
    2f8a:	00003097          	auipc	ra,0x3
    2f8e:	e32080e7          	jalr	-462(ra) # 5dbc <printf>
    exit(1);
    2f92:	4505                	li	a0,1
    2f94:	00003097          	auipc	ra,0x3
    2f98:	a56080e7          	jalr	-1450(ra) # 59ea <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    2f9c:	85ca                	mv	a1,s2
    2f9e:	00005517          	auipc	a0,0x5
    2fa2:	98a50513          	addi	a0,a0,-1654 # 7928 <csem_up+0x18f4>
    2fa6:	00003097          	auipc	ra,0x3
    2faa:	e16080e7          	jalr	-490(ra) # 5dbc <printf>
    exit(1);
    2fae:	4505                	li	a0,1
    2fb0:	00003097          	auipc	ra,0x3
    2fb4:	a3a080e7          	jalr	-1478(ra) # 59ea <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    2fb8:	85ca                	mv	a1,s2
    2fba:	00005517          	auipc	a0,0x5
    2fbe:	99650513          	addi	a0,a0,-1642 # 7950 <csem_up+0x191c>
    2fc2:	00003097          	auipc	ra,0x3
    2fc6:	dfa080e7          	jalr	-518(ra) # 5dbc <printf>
    exit(1);
    2fca:	4505                	li	a0,1
    2fcc:	00003097          	auipc	ra,0x3
    2fd0:	a1e080e7          	jalr	-1506(ra) # 59ea <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    2fd4:	85ca                	mv	a1,s2
    2fd6:	00005517          	auipc	a0,0x5
    2fda:	9a250513          	addi	a0,a0,-1630 # 7978 <csem_up+0x1944>
    2fde:	00003097          	auipc	ra,0x3
    2fe2:	dde080e7          	jalr	-546(ra) # 5dbc <printf>
    exit(1);
    2fe6:	4505                	li	a0,1
    2fe8:	00003097          	auipc	ra,0x3
    2fec:	a02080e7          	jalr	-1534(ra) # 59ea <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    2ff0:	85ca                	mv	a1,s2
    2ff2:	00005517          	auipc	a0,0x5
    2ff6:	9ae50513          	addi	a0,a0,-1618 # 79a0 <csem_up+0x196c>
    2ffa:	00003097          	auipc	ra,0x3
    2ffe:	dc2080e7          	jalr	-574(ra) # 5dbc <printf>
    exit(1);
    3002:	4505                	li	a0,1
    3004:	00003097          	auipc	ra,0x3
    3008:	9e6080e7          	jalr	-1562(ra) # 59ea <exit>
    printf("%s: unlink dirfile failed!\n", s);
    300c:	85ca                	mv	a1,s2
    300e:	00005517          	auipc	a0,0x5
    3012:	9ba50513          	addi	a0,a0,-1606 # 79c8 <csem_up+0x1994>
    3016:	00003097          	auipc	ra,0x3
    301a:	da6080e7          	jalr	-602(ra) # 5dbc <printf>
    exit(1);
    301e:	4505                	li	a0,1
    3020:	00003097          	auipc	ra,0x3
    3024:	9ca080e7          	jalr	-1590(ra) # 59ea <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3028:	85ca                	mv	a1,s2
    302a:	00005517          	auipc	a0,0x5
    302e:	9be50513          	addi	a0,a0,-1602 # 79e8 <csem_up+0x19b4>
    3032:	00003097          	auipc	ra,0x3
    3036:	d8a080e7          	jalr	-630(ra) # 5dbc <printf>
    exit(1);
    303a:	4505                	li	a0,1
    303c:	00003097          	auipc	ra,0x3
    3040:	9ae080e7          	jalr	-1618(ra) # 59ea <exit>
    printf("%s: write . succeeded!\n", s);
    3044:	85ca                	mv	a1,s2
    3046:	00005517          	auipc	a0,0x5
    304a:	9ca50513          	addi	a0,a0,-1590 # 7a10 <csem_up+0x19dc>
    304e:	00003097          	auipc	ra,0x3
    3052:	d6e080e7          	jalr	-658(ra) # 5dbc <printf>
    exit(1);
    3056:	4505                	li	a0,1
    3058:	00003097          	auipc	ra,0x3
    305c:	992080e7          	jalr	-1646(ra) # 59ea <exit>

0000000000003060 <reparent>:
{
    3060:	7179                	addi	sp,sp,-48
    3062:	f406                	sd	ra,40(sp)
    3064:	f022                	sd	s0,32(sp)
    3066:	ec26                	sd	s1,24(sp)
    3068:	e84a                	sd	s2,16(sp)
    306a:	e44e                	sd	s3,8(sp)
    306c:	e052                	sd	s4,0(sp)
    306e:	1800                	addi	s0,sp,48
    3070:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3072:	00003097          	auipc	ra,0x3
    3076:	9f8080e7          	jalr	-1544(ra) # 5a6a <getpid>
    307a:	8a2a                	mv	s4,a0
    307c:	0c800913          	li	s2,200
    int pid = fork();
    3080:	00003097          	auipc	ra,0x3
    3084:	962080e7          	jalr	-1694(ra) # 59e2 <fork>
    3088:	84aa                	mv	s1,a0
    if(pid < 0){
    308a:	02054263          	bltz	a0,30ae <reparent+0x4e>
    if(pid){
    308e:	cd21                	beqz	a0,30e6 <reparent+0x86>
      if(wait(0) != pid){
    3090:	4501                	li	a0,0
    3092:	00003097          	auipc	ra,0x3
    3096:	960080e7          	jalr	-1696(ra) # 59f2 <wait>
    309a:	02951863          	bne	a0,s1,30ca <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    309e:	397d                	addiw	s2,s2,-1
    30a0:	fe0910e3          	bnez	s2,3080 <reparent+0x20>
  exit(0);
    30a4:	4501                	li	a0,0
    30a6:	00003097          	auipc	ra,0x3
    30aa:	944080e7          	jalr	-1724(ra) # 59ea <exit>
      printf("%s: fork failed\n", s);
    30ae:	85ce                	mv	a1,s3
    30b0:	00003517          	auipc	a0,0x3
    30b4:	28050513          	addi	a0,a0,640 # 6330 <csem_up+0x2fc>
    30b8:	00003097          	auipc	ra,0x3
    30bc:	d04080e7          	jalr	-764(ra) # 5dbc <printf>
      exit(1);
    30c0:	4505                	li	a0,1
    30c2:	00003097          	auipc	ra,0x3
    30c6:	928080e7          	jalr	-1752(ra) # 59ea <exit>
        printf("%s: wait wrong pid\n", s);
    30ca:	85ce                	mv	a1,s3
    30cc:	00003517          	auipc	a0,0x3
    30d0:	27c50513          	addi	a0,a0,636 # 6348 <csem_up+0x314>
    30d4:	00003097          	auipc	ra,0x3
    30d8:	ce8080e7          	jalr	-792(ra) # 5dbc <printf>
        exit(1);
    30dc:	4505                	li	a0,1
    30de:	00003097          	auipc	ra,0x3
    30e2:	90c080e7          	jalr	-1780(ra) # 59ea <exit>
      int pid2 = fork();
    30e6:	00003097          	auipc	ra,0x3
    30ea:	8fc080e7          	jalr	-1796(ra) # 59e2 <fork>
      if(pid2 < 0){
    30ee:	00054763          	bltz	a0,30fc <reparent+0x9c>
      exit(0);
    30f2:	4501                	li	a0,0
    30f4:	00003097          	auipc	ra,0x3
    30f8:	8f6080e7          	jalr	-1802(ra) # 59ea <exit>
        kill(master_pid, SIGKILL);
    30fc:	45a5                	li	a1,9
    30fe:	8552                	mv	a0,s4
    3100:	00003097          	auipc	ra,0x3
    3104:	91a080e7          	jalr	-1766(ra) # 5a1a <kill>
        exit(1);
    3108:	4505                	li	a0,1
    310a:	00003097          	auipc	ra,0x3
    310e:	8e0080e7          	jalr	-1824(ra) # 59ea <exit>

0000000000003112 <fourfiles>:
{
    3112:	7171                	addi	sp,sp,-176
    3114:	f506                	sd	ra,168(sp)
    3116:	f122                	sd	s0,160(sp)
    3118:	ed26                	sd	s1,152(sp)
    311a:	e94a                	sd	s2,144(sp)
    311c:	e54e                	sd	s3,136(sp)
    311e:	e152                	sd	s4,128(sp)
    3120:	fcd6                	sd	s5,120(sp)
    3122:	f8da                	sd	s6,112(sp)
    3124:	f4de                	sd	s7,104(sp)
    3126:	f0e2                	sd	s8,96(sp)
    3128:	ece6                	sd	s9,88(sp)
    312a:	e8ea                	sd	s10,80(sp)
    312c:	e4ee                	sd	s11,72(sp)
    312e:	1900                	addi	s0,sp,176
    3130:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    3134:	00003797          	auipc	a5,0x3
    3138:	f4c78793          	addi	a5,a5,-180 # 6080 <csem_up+0x4c>
    313c:	f6f43823          	sd	a5,-144(s0)
    3140:	00003797          	auipc	a5,0x3
    3144:	f4878793          	addi	a5,a5,-184 # 6088 <csem_up+0x54>
    3148:	f6f43c23          	sd	a5,-136(s0)
    314c:	00003797          	auipc	a5,0x3
    3150:	f4478793          	addi	a5,a5,-188 # 6090 <csem_up+0x5c>
    3154:	f8f43023          	sd	a5,-128(s0)
    3158:	00003797          	auipc	a5,0x3
    315c:	f4078793          	addi	a5,a5,-192 # 6098 <csem_up+0x64>
    3160:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3164:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3168:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    316a:	4481                	li	s1,0
    316c:	4a11                	li	s4,4
    fname = names[pi];
    316e:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3172:	854e                	mv	a0,s3
    3174:	00003097          	auipc	ra,0x3
    3178:	8c6080e7          	jalr	-1850(ra) # 5a3a <unlink>
    pid = fork();
    317c:	00003097          	auipc	ra,0x3
    3180:	866080e7          	jalr	-1946(ra) # 59e2 <fork>
    if(pid < 0){
    3184:	04054463          	bltz	a0,31cc <fourfiles+0xba>
    if(pid == 0){
    3188:	c12d                	beqz	a0,31ea <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    318a:	2485                	addiw	s1,s1,1
    318c:	0921                	addi	s2,s2,8
    318e:	ff4490e3          	bne	s1,s4,316e <fourfiles+0x5c>
    3192:	4491                	li	s1,4
    wait(&xstatus);
    3194:	f6c40513          	addi	a0,s0,-148
    3198:	00003097          	auipc	ra,0x3
    319c:	85a080e7          	jalr	-1958(ra) # 59f2 <wait>
    if(xstatus != 0)
    31a0:	f6c42b03          	lw	s6,-148(s0)
    31a4:	0c0b1e63          	bnez	s6,3280 <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    31a8:	34fd                	addiw	s1,s1,-1
    31aa:	f4ed                	bnez	s1,3194 <fourfiles+0x82>
    31ac:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    31b0:	00009a17          	auipc	s4,0x9
    31b4:	e28a0a13          	addi	s4,s4,-472 # bfd8 <buf>
    31b8:	00009a97          	auipc	s5,0x9
    31bc:	e21a8a93          	addi	s5,s5,-479 # bfd9 <buf+0x1>
    if(total != N*SZ){
    31c0:	6d85                	lui	s11,0x1
    31c2:	770d8d93          	addi	s11,s11,1904 # 1770 <copyinstr2+0x100>
  for(i = 0; i < NCHILD; i++){
    31c6:	03400d13          	li	s10,52
    31ca:	aa1d                	j	3300 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    31cc:	f5843583          	ld	a1,-168(s0)
    31d0:	00004517          	auipc	a0,0x4
    31d4:	c2850513          	addi	a0,a0,-984 # 6df8 <csem_up+0xdc4>
    31d8:	00003097          	auipc	ra,0x3
    31dc:	be4080e7          	jalr	-1052(ra) # 5dbc <printf>
      exit(1);
    31e0:	4505                	li	a0,1
    31e2:	00003097          	auipc	ra,0x3
    31e6:	808080e7          	jalr	-2040(ra) # 59ea <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    31ea:	20200593          	li	a1,514
    31ee:	854e                	mv	a0,s3
    31f0:	00003097          	auipc	ra,0x3
    31f4:	83a080e7          	jalr	-1990(ra) # 5a2a <open>
    31f8:	892a                	mv	s2,a0
      if(fd < 0){
    31fa:	04054763          	bltz	a0,3248 <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    31fe:	1f400613          	li	a2,500
    3202:	0304859b          	addiw	a1,s1,48
    3206:	00009517          	auipc	a0,0x9
    320a:	dd250513          	addi	a0,a0,-558 # bfd8 <buf>
    320e:	00002097          	auipc	ra,0x2
    3212:	5e0080e7          	jalr	1504(ra) # 57ee <memset>
    3216:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3218:	00009997          	auipc	s3,0x9
    321c:	dc098993          	addi	s3,s3,-576 # bfd8 <buf>
    3220:	1f400613          	li	a2,500
    3224:	85ce                	mv	a1,s3
    3226:	854a                	mv	a0,s2
    3228:	00002097          	auipc	ra,0x2
    322c:	7e2080e7          	jalr	2018(ra) # 5a0a <write>
    3230:	85aa                	mv	a1,a0
    3232:	1f400793          	li	a5,500
    3236:	02f51863          	bne	a0,a5,3266 <fourfiles+0x154>
      for(i = 0; i < N; i++){
    323a:	34fd                	addiw	s1,s1,-1
    323c:	f0f5                	bnez	s1,3220 <fourfiles+0x10e>
      exit(0);
    323e:	4501                	li	a0,0
    3240:	00002097          	auipc	ra,0x2
    3244:	7aa080e7          	jalr	1962(ra) # 59ea <exit>
        printf("create failed\n", s);
    3248:	f5843583          	ld	a1,-168(s0)
    324c:	00004517          	auipc	a0,0x4
    3250:	7dc50513          	addi	a0,a0,2012 # 7a28 <csem_up+0x19f4>
    3254:	00003097          	auipc	ra,0x3
    3258:	b68080e7          	jalr	-1176(ra) # 5dbc <printf>
        exit(1);
    325c:	4505                	li	a0,1
    325e:	00002097          	auipc	ra,0x2
    3262:	78c080e7          	jalr	1932(ra) # 59ea <exit>
          printf("write failed %d\n", n);
    3266:	00004517          	auipc	a0,0x4
    326a:	7d250513          	addi	a0,a0,2002 # 7a38 <csem_up+0x1a04>
    326e:	00003097          	auipc	ra,0x3
    3272:	b4e080e7          	jalr	-1202(ra) # 5dbc <printf>
          exit(1);
    3276:	4505                	li	a0,1
    3278:	00002097          	auipc	ra,0x2
    327c:	772080e7          	jalr	1906(ra) # 59ea <exit>
      exit(xstatus);
    3280:	855a                	mv	a0,s6
    3282:	00002097          	auipc	ra,0x2
    3286:	768080e7          	jalr	1896(ra) # 59ea <exit>
          printf("wrong char\n", s);
    328a:	f5843583          	ld	a1,-168(s0)
    328e:	00004517          	auipc	a0,0x4
    3292:	7c250513          	addi	a0,a0,1986 # 7a50 <csem_up+0x1a1c>
    3296:	00003097          	auipc	ra,0x3
    329a:	b26080e7          	jalr	-1242(ra) # 5dbc <printf>
          exit(1);
    329e:	4505                	li	a0,1
    32a0:	00002097          	auipc	ra,0x2
    32a4:	74a080e7          	jalr	1866(ra) # 59ea <exit>
      total += n;
    32a8:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    32ac:	660d                	lui	a2,0x3
    32ae:	85d2                	mv	a1,s4
    32b0:	854e                	mv	a0,s3
    32b2:	00002097          	auipc	ra,0x2
    32b6:	750080e7          	jalr	1872(ra) # 5a02 <read>
    32ba:	02a05363          	blez	a0,32e0 <fourfiles+0x1ce>
    32be:	00009797          	auipc	a5,0x9
    32c2:	d1a78793          	addi	a5,a5,-742 # bfd8 <buf>
    32c6:	fff5069b          	addiw	a3,a0,-1
    32ca:	1682                	slli	a3,a3,0x20
    32cc:	9281                	srli	a3,a3,0x20
    32ce:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    32d0:	0007c703          	lbu	a4,0(a5)
    32d4:	fa971be3          	bne	a4,s1,328a <fourfiles+0x178>
      for(j = 0; j < n; j++){
    32d8:	0785                	addi	a5,a5,1
    32da:	fed79be3          	bne	a5,a3,32d0 <fourfiles+0x1be>
    32de:	b7e9                	j	32a8 <fourfiles+0x196>
    close(fd);
    32e0:	854e                	mv	a0,s3
    32e2:	00002097          	auipc	ra,0x2
    32e6:	730080e7          	jalr	1840(ra) # 5a12 <close>
    if(total != N*SZ){
    32ea:	03b91863          	bne	s2,s11,331a <fourfiles+0x208>
    unlink(fname);
    32ee:	8566                	mv	a0,s9
    32f0:	00002097          	auipc	ra,0x2
    32f4:	74a080e7          	jalr	1866(ra) # 5a3a <unlink>
  for(i = 0; i < NCHILD; i++){
    32f8:	0c21                	addi	s8,s8,8
    32fa:	2b85                	addiw	s7,s7,1
    32fc:	03ab8d63          	beq	s7,s10,3336 <fourfiles+0x224>
    fname = names[i];
    3300:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    3304:	4581                	li	a1,0
    3306:	8566                	mv	a0,s9
    3308:	00002097          	auipc	ra,0x2
    330c:	722080e7          	jalr	1826(ra) # 5a2a <open>
    3310:	89aa                	mv	s3,a0
    total = 0;
    3312:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    3314:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3318:	bf51                	j	32ac <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    331a:	85ca                	mv	a1,s2
    331c:	00004517          	auipc	a0,0x4
    3320:	74450513          	addi	a0,a0,1860 # 7a60 <csem_up+0x1a2c>
    3324:	00003097          	auipc	ra,0x3
    3328:	a98080e7          	jalr	-1384(ra) # 5dbc <printf>
      exit(1);
    332c:	4505                	li	a0,1
    332e:	00002097          	auipc	ra,0x2
    3332:	6bc080e7          	jalr	1724(ra) # 59ea <exit>
}
    3336:	70aa                	ld	ra,168(sp)
    3338:	740a                	ld	s0,160(sp)
    333a:	64ea                	ld	s1,152(sp)
    333c:	694a                	ld	s2,144(sp)
    333e:	69aa                	ld	s3,136(sp)
    3340:	6a0a                	ld	s4,128(sp)
    3342:	7ae6                	ld	s5,120(sp)
    3344:	7b46                	ld	s6,112(sp)
    3346:	7ba6                	ld	s7,104(sp)
    3348:	7c06                	ld	s8,96(sp)
    334a:	6ce6                	ld	s9,88(sp)
    334c:	6d46                	ld	s10,80(sp)
    334e:	6da6                	ld	s11,72(sp)
    3350:	614d                	addi	sp,sp,176
    3352:	8082                	ret

0000000000003354 <bigfile>:
{
    3354:	7139                	addi	sp,sp,-64
    3356:	fc06                	sd	ra,56(sp)
    3358:	f822                	sd	s0,48(sp)
    335a:	f426                	sd	s1,40(sp)
    335c:	f04a                	sd	s2,32(sp)
    335e:	ec4e                	sd	s3,24(sp)
    3360:	e852                	sd	s4,16(sp)
    3362:	e456                	sd	s5,8(sp)
    3364:	0080                	addi	s0,sp,64
    3366:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    3368:	00004517          	auipc	a0,0x4
    336c:	71050513          	addi	a0,a0,1808 # 7a78 <csem_up+0x1a44>
    3370:	00002097          	auipc	ra,0x2
    3374:	6ca080e7          	jalr	1738(ra) # 5a3a <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    3378:	20200593          	li	a1,514
    337c:	00004517          	auipc	a0,0x4
    3380:	6fc50513          	addi	a0,a0,1788 # 7a78 <csem_up+0x1a44>
    3384:	00002097          	auipc	ra,0x2
    3388:	6a6080e7          	jalr	1702(ra) # 5a2a <open>
    338c:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    338e:	4481                	li	s1,0
    memset(buf, i, SZ);
    3390:	00009917          	auipc	s2,0x9
    3394:	c4890913          	addi	s2,s2,-952 # bfd8 <buf>
  for(i = 0; i < N; i++){
    3398:	4a51                	li	s4,20
  if(fd < 0){
    339a:	0a054063          	bltz	a0,343a <bigfile+0xe6>
    memset(buf, i, SZ);
    339e:	25800613          	li	a2,600
    33a2:	85a6                	mv	a1,s1
    33a4:	854a                	mv	a0,s2
    33a6:	00002097          	auipc	ra,0x2
    33aa:	448080e7          	jalr	1096(ra) # 57ee <memset>
    if(write(fd, buf, SZ) != SZ){
    33ae:	25800613          	li	a2,600
    33b2:	85ca                	mv	a1,s2
    33b4:	854e                	mv	a0,s3
    33b6:	00002097          	auipc	ra,0x2
    33ba:	654080e7          	jalr	1620(ra) # 5a0a <write>
    33be:	25800793          	li	a5,600
    33c2:	08f51a63          	bne	a0,a5,3456 <bigfile+0x102>
  for(i = 0; i < N; i++){
    33c6:	2485                	addiw	s1,s1,1
    33c8:	fd449be3          	bne	s1,s4,339e <bigfile+0x4a>
  close(fd);
    33cc:	854e                	mv	a0,s3
    33ce:	00002097          	auipc	ra,0x2
    33d2:	644080e7          	jalr	1604(ra) # 5a12 <close>
  fd = open("bigfile.dat", 0);
    33d6:	4581                	li	a1,0
    33d8:	00004517          	auipc	a0,0x4
    33dc:	6a050513          	addi	a0,a0,1696 # 7a78 <csem_up+0x1a44>
    33e0:	00002097          	auipc	ra,0x2
    33e4:	64a080e7          	jalr	1610(ra) # 5a2a <open>
    33e8:	8a2a                	mv	s4,a0
  total = 0;
    33ea:	4981                	li	s3,0
  for(i = 0; ; i++){
    33ec:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    33ee:	00009917          	auipc	s2,0x9
    33f2:	bea90913          	addi	s2,s2,-1046 # bfd8 <buf>
  if(fd < 0){
    33f6:	06054e63          	bltz	a0,3472 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    33fa:	12c00613          	li	a2,300
    33fe:	85ca                	mv	a1,s2
    3400:	8552                	mv	a0,s4
    3402:	00002097          	auipc	ra,0x2
    3406:	600080e7          	jalr	1536(ra) # 5a02 <read>
    if(cc < 0){
    340a:	08054263          	bltz	a0,348e <bigfile+0x13a>
    if(cc == 0)
    340e:	c971                	beqz	a0,34e2 <bigfile+0x18e>
    if(cc != SZ/2){
    3410:	12c00793          	li	a5,300
    3414:	08f51b63          	bne	a0,a5,34aa <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    3418:	01f4d79b          	srliw	a5,s1,0x1f
    341c:	9fa5                	addw	a5,a5,s1
    341e:	4017d79b          	sraiw	a5,a5,0x1
    3422:	00094703          	lbu	a4,0(s2)
    3426:	0af71063          	bne	a4,a5,34c6 <bigfile+0x172>
    342a:	12b94703          	lbu	a4,299(s2)
    342e:	08f71c63          	bne	a4,a5,34c6 <bigfile+0x172>
    total += cc;
    3432:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    3436:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    3438:	b7c9                	j	33fa <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    343a:	85d6                	mv	a1,s5
    343c:	00004517          	auipc	a0,0x4
    3440:	64c50513          	addi	a0,a0,1612 # 7a88 <csem_up+0x1a54>
    3444:	00003097          	auipc	ra,0x3
    3448:	978080e7          	jalr	-1672(ra) # 5dbc <printf>
    exit(1);
    344c:	4505                	li	a0,1
    344e:	00002097          	auipc	ra,0x2
    3452:	59c080e7          	jalr	1436(ra) # 59ea <exit>
      printf("%s: write bigfile failed\n", s);
    3456:	85d6                	mv	a1,s5
    3458:	00004517          	auipc	a0,0x4
    345c:	65050513          	addi	a0,a0,1616 # 7aa8 <csem_up+0x1a74>
    3460:	00003097          	auipc	ra,0x3
    3464:	95c080e7          	jalr	-1700(ra) # 5dbc <printf>
      exit(1);
    3468:	4505                	li	a0,1
    346a:	00002097          	auipc	ra,0x2
    346e:	580080e7          	jalr	1408(ra) # 59ea <exit>
    printf("%s: cannot open bigfile\n", s);
    3472:	85d6                	mv	a1,s5
    3474:	00004517          	auipc	a0,0x4
    3478:	65450513          	addi	a0,a0,1620 # 7ac8 <csem_up+0x1a94>
    347c:	00003097          	auipc	ra,0x3
    3480:	940080e7          	jalr	-1728(ra) # 5dbc <printf>
    exit(1);
    3484:	4505                	li	a0,1
    3486:	00002097          	auipc	ra,0x2
    348a:	564080e7          	jalr	1380(ra) # 59ea <exit>
      printf("%s: read bigfile failed\n", s);
    348e:	85d6                	mv	a1,s5
    3490:	00004517          	auipc	a0,0x4
    3494:	65850513          	addi	a0,a0,1624 # 7ae8 <csem_up+0x1ab4>
    3498:	00003097          	auipc	ra,0x3
    349c:	924080e7          	jalr	-1756(ra) # 5dbc <printf>
      exit(1);
    34a0:	4505                	li	a0,1
    34a2:	00002097          	auipc	ra,0x2
    34a6:	548080e7          	jalr	1352(ra) # 59ea <exit>
      printf("%s: short read bigfile\n", s);
    34aa:	85d6                	mv	a1,s5
    34ac:	00004517          	auipc	a0,0x4
    34b0:	65c50513          	addi	a0,a0,1628 # 7b08 <csem_up+0x1ad4>
    34b4:	00003097          	auipc	ra,0x3
    34b8:	908080e7          	jalr	-1784(ra) # 5dbc <printf>
      exit(1);
    34bc:	4505                	li	a0,1
    34be:	00002097          	auipc	ra,0x2
    34c2:	52c080e7          	jalr	1324(ra) # 59ea <exit>
      printf("%s: read bigfile wrong data\n", s);
    34c6:	85d6                	mv	a1,s5
    34c8:	00004517          	auipc	a0,0x4
    34cc:	65850513          	addi	a0,a0,1624 # 7b20 <csem_up+0x1aec>
    34d0:	00003097          	auipc	ra,0x3
    34d4:	8ec080e7          	jalr	-1812(ra) # 5dbc <printf>
      exit(1);
    34d8:	4505                	li	a0,1
    34da:	00002097          	auipc	ra,0x2
    34de:	510080e7          	jalr	1296(ra) # 59ea <exit>
  close(fd);
    34e2:	8552                	mv	a0,s4
    34e4:	00002097          	auipc	ra,0x2
    34e8:	52e080e7          	jalr	1326(ra) # 5a12 <close>
  if(total != N*SZ){
    34ec:	678d                	lui	a5,0x3
    34ee:	ee078793          	addi	a5,a5,-288 # 2ee0 <dirfile+0xb4>
    34f2:	02f99363          	bne	s3,a5,3518 <bigfile+0x1c4>
  unlink("bigfile.dat");
    34f6:	00004517          	auipc	a0,0x4
    34fa:	58250513          	addi	a0,a0,1410 # 7a78 <csem_up+0x1a44>
    34fe:	00002097          	auipc	ra,0x2
    3502:	53c080e7          	jalr	1340(ra) # 5a3a <unlink>
}
    3506:	70e2                	ld	ra,56(sp)
    3508:	7442                	ld	s0,48(sp)
    350a:	74a2                	ld	s1,40(sp)
    350c:	7902                	ld	s2,32(sp)
    350e:	69e2                	ld	s3,24(sp)
    3510:	6a42                	ld	s4,16(sp)
    3512:	6aa2                	ld	s5,8(sp)
    3514:	6121                	addi	sp,sp,64
    3516:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    3518:	85d6                	mv	a1,s5
    351a:	00004517          	auipc	a0,0x4
    351e:	62650513          	addi	a0,a0,1574 # 7b40 <csem_up+0x1b0c>
    3522:	00003097          	auipc	ra,0x3
    3526:	89a080e7          	jalr	-1894(ra) # 5dbc <printf>
    exit(1);
    352a:	4505                	li	a0,1
    352c:	00002097          	auipc	ra,0x2
    3530:	4be080e7          	jalr	1214(ra) # 59ea <exit>

0000000000003534 <truncate3>:
{
    3534:	7159                	addi	sp,sp,-112
    3536:	f486                	sd	ra,104(sp)
    3538:	f0a2                	sd	s0,96(sp)
    353a:	eca6                	sd	s1,88(sp)
    353c:	e8ca                	sd	s2,80(sp)
    353e:	e4ce                	sd	s3,72(sp)
    3540:	e0d2                	sd	s4,64(sp)
    3542:	fc56                	sd	s5,56(sp)
    3544:	1880                	addi	s0,sp,112
    3546:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    3548:	60100593          	li	a1,1537
    354c:	00003517          	auipc	a0,0x3
    3550:	08450513          	addi	a0,a0,132 # 65d0 <csem_up+0x59c>
    3554:	00002097          	auipc	ra,0x2
    3558:	4d6080e7          	jalr	1238(ra) # 5a2a <open>
    355c:	00002097          	auipc	ra,0x2
    3560:	4b6080e7          	jalr	1206(ra) # 5a12 <close>
  pid = fork();
    3564:	00002097          	auipc	ra,0x2
    3568:	47e080e7          	jalr	1150(ra) # 59e2 <fork>
  if(pid < 0){
    356c:	08054063          	bltz	a0,35ec <truncate3+0xb8>
  if(pid == 0){
    3570:	e969                	bnez	a0,3642 <truncate3+0x10e>
    3572:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    3576:	00003a17          	auipc	s4,0x3
    357a:	05aa0a13          	addi	s4,s4,90 # 65d0 <csem_up+0x59c>
      int n = write(fd, "1234567890", 10);
    357e:	00004a97          	auipc	s5,0x4
    3582:	5e2a8a93          	addi	s5,s5,1506 # 7b60 <csem_up+0x1b2c>
      int fd = open("truncfile", O_WRONLY);
    3586:	4585                	li	a1,1
    3588:	8552                	mv	a0,s4
    358a:	00002097          	auipc	ra,0x2
    358e:	4a0080e7          	jalr	1184(ra) # 5a2a <open>
    3592:	84aa                	mv	s1,a0
      if(fd < 0){
    3594:	06054a63          	bltz	a0,3608 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    3598:	4629                	li	a2,10
    359a:	85d6                	mv	a1,s5
    359c:	00002097          	auipc	ra,0x2
    35a0:	46e080e7          	jalr	1134(ra) # 5a0a <write>
      if(n != 10){
    35a4:	47a9                	li	a5,10
    35a6:	06f51f63          	bne	a0,a5,3624 <truncate3+0xf0>
      close(fd);
    35aa:	8526                	mv	a0,s1
    35ac:	00002097          	auipc	ra,0x2
    35b0:	466080e7          	jalr	1126(ra) # 5a12 <close>
      fd = open("truncfile", O_RDONLY);
    35b4:	4581                	li	a1,0
    35b6:	8552                	mv	a0,s4
    35b8:	00002097          	auipc	ra,0x2
    35bc:	472080e7          	jalr	1138(ra) # 5a2a <open>
    35c0:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    35c2:	02000613          	li	a2,32
    35c6:	f9840593          	addi	a1,s0,-104
    35ca:	00002097          	auipc	ra,0x2
    35ce:	438080e7          	jalr	1080(ra) # 5a02 <read>
      close(fd);
    35d2:	8526                	mv	a0,s1
    35d4:	00002097          	auipc	ra,0x2
    35d8:	43e080e7          	jalr	1086(ra) # 5a12 <close>
    for(int i = 0; i < 100; i++){
    35dc:	39fd                	addiw	s3,s3,-1
    35de:	fa0994e3          	bnez	s3,3586 <truncate3+0x52>
    exit(0);
    35e2:	4501                	li	a0,0
    35e4:	00002097          	auipc	ra,0x2
    35e8:	406080e7          	jalr	1030(ra) # 59ea <exit>
    printf("%s: fork failed\n", s);
    35ec:	85ca                	mv	a1,s2
    35ee:	00003517          	auipc	a0,0x3
    35f2:	d4250513          	addi	a0,a0,-702 # 6330 <csem_up+0x2fc>
    35f6:	00002097          	auipc	ra,0x2
    35fa:	7c6080e7          	jalr	1990(ra) # 5dbc <printf>
    exit(1);
    35fe:	4505                	li	a0,1
    3600:	00002097          	auipc	ra,0x2
    3604:	3ea080e7          	jalr	1002(ra) # 59ea <exit>
        printf("%s: open failed\n", s);
    3608:	85ca                	mv	a1,s2
    360a:	00003517          	auipc	a0,0x3
    360e:	6a650513          	addi	a0,a0,1702 # 6cb0 <csem_up+0xc7c>
    3612:	00002097          	auipc	ra,0x2
    3616:	7aa080e7          	jalr	1962(ra) # 5dbc <printf>
        exit(1);
    361a:	4505                	li	a0,1
    361c:	00002097          	auipc	ra,0x2
    3620:	3ce080e7          	jalr	974(ra) # 59ea <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    3624:	862a                	mv	a2,a0
    3626:	85ca                	mv	a1,s2
    3628:	00004517          	auipc	a0,0x4
    362c:	54850513          	addi	a0,a0,1352 # 7b70 <csem_up+0x1b3c>
    3630:	00002097          	auipc	ra,0x2
    3634:	78c080e7          	jalr	1932(ra) # 5dbc <printf>
        exit(1);
    3638:	4505                	li	a0,1
    363a:	00002097          	auipc	ra,0x2
    363e:	3b0080e7          	jalr	944(ra) # 59ea <exit>
    3642:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    3646:	00003a17          	auipc	s4,0x3
    364a:	f8aa0a13          	addi	s4,s4,-118 # 65d0 <csem_up+0x59c>
    int n = write(fd, "xxx", 3);
    364e:	00004a97          	auipc	s5,0x4
    3652:	542a8a93          	addi	s5,s5,1346 # 7b90 <csem_up+0x1b5c>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    3656:	60100593          	li	a1,1537
    365a:	8552                	mv	a0,s4
    365c:	00002097          	auipc	ra,0x2
    3660:	3ce080e7          	jalr	974(ra) # 5a2a <open>
    3664:	84aa                	mv	s1,a0
    if(fd < 0){
    3666:	04054763          	bltz	a0,36b4 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    366a:	460d                	li	a2,3
    366c:	85d6                	mv	a1,s5
    366e:	00002097          	auipc	ra,0x2
    3672:	39c080e7          	jalr	924(ra) # 5a0a <write>
    if(n != 3){
    3676:	478d                	li	a5,3
    3678:	04f51c63          	bne	a0,a5,36d0 <truncate3+0x19c>
    close(fd);
    367c:	8526                	mv	a0,s1
    367e:	00002097          	auipc	ra,0x2
    3682:	394080e7          	jalr	916(ra) # 5a12 <close>
  for(int i = 0; i < 150; i++){
    3686:	39fd                	addiw	s3,s3,-1
    3688:	fc0997e3          	bnez	s3,3656 <truncate3+0x122>
  wait(&xstatus);
    368c:	fbc40513          	addi	a0,s0,-68
    3690:	00002097          	auipc	ra,0x2
    3694:	362080e7          	jalr	866(ra) # 59f2 <wait>
  unlink("truncfile");
    3698:	00003517          	auipc	a0,0x3
    369c:	f3850513          	addi	a0,a0,-200 # 65d0 <csem_up+0x59c>
    36a0:	00002097          	auipc	ra,0x2
    36a4:	39a080e7          	jalr	922(ra) # 5a3a <unlink>
  exit(xstatus);
    36a8:	fbc42503          	lw	a0,-68(s0)
    36ac:	00002097          	auipc	ra,0x2
    36b0:	33e080e7          	jalr	830(ra) # 59ea <exit>
      printf("%s: open failed\n", s);
    36b4:	85ca                	mv	a1,s2
    36b6:	00003517          	auipc	a0,0x3
    36ba:	5fa50513          	addi	a0,a0,1530 # 6cb0 <csem_up+0xc7c>
    36be:	00002097          	auipc	ra,0x2
    36c2:	6fe080e7          	jalr	1790(ra) # 5dbc <printf>
      exit(1);
    36c6:	4505                	li	a0,1
    36c8:	00002097          	auipc	ra,0x2
    36cc:	322080e7          	jalr	802(ra) # 59ea <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    36d0:	862a                	mv	a2,a0
    36d2:	85ca                	mv	a1,s2
    36d4:	00004517          	auipc	a0,0x4
    36d8:	4c450513          	addi	a0,a0,1220 # 7b98 <csem_up+0x1b64>
    36dc:	00002097          	auipc	ra,0x2
    36e0:	6e0080e7          	jalr	1760(ra) # 5dbc <printf>
      exit(1);
    36e4:	4505                	li	a0,1
    36e6:	00002097          	auipc	ra,0x2
    36ea:	304080e7          	jalr	772(ra) # 59ea <exit>

00000000000036ee <writetest>:
{
    36ee:	7139                	addi	sp,sp,-64
    36f0:	fc06                	sd	ra,56(sp)
    36f2:	f822                	sd	s0,48(sp)
    36f4:	f426                	sd	s1,40(sp)
    36f6:	f04a                	sd	s2,32(sp)
    36f8:	ec4e                	sd	s3,24(sp)
    36fa:	e852                	sd	s4,16(sp)
    36fc:	e456                	sd	s5,8(sp)
    36fe:	e05a                	sd	s6,0(sp)
    3700:	0080                	addi	s0,sp,64
    3702:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
    3704:	20200593          	li	a1,514
    3708:	00004517          	auipc	a0,0x4
    370c:	4b050513          	addi	a0,a0,1200 # 7bb8 <csem_up+0x1b84>
    3710:	00002097          	auipc	ra,0x2
    3714:	31a080e7          	jalr	794(ra) # 5a2a <open>
  if(fd < 0){
    3718:	0a054d63          	bltz	a0,37d2 <writetest+0xe4>
    371c:	892a                	mv	s2,a0
    371e:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
    3720:	00004997          	auipc	s3,0x4
    3724:	4c098993          	addi	s3,s3,1216 # 7be0 <csem_up+0x1bac>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
    3728:	00004a97          	auipc	s5,0x4
    372c:	4f0a8a93          	addi	s5,s5,1264 # 7c18 <csem_up+0x1be4>
  for(i = 0; i < N; i++){
    3730:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
    3734:	4629                	li	a2,10
    3736:	85ce                	mv	a1,s3
    3738:	854a                	mv	a0,s2
    373a:	00002097          	auipc	ra,0x2
    373e:	2d0080e7          	jalr	720(ra) # 5a0a <write>
    3742:	47a9                	li	a5,10
    3744:	0af51563          	bne	a0,a5,37ee <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
    3748:	4629                	li	a2,10
    374a:	85d6                	mv	a1,s5
    374c:	854a                	mv	a0,s2
    374e:	00002097          	auipc	ra,0x2
    3752:	2bc080e7          	jalr	700(ra) # 5a0a <write>
    3756:	47a9                	li	a5,10
    3758:	0af51a63          	bne	a0,a5,380c <writetest+0x11e>
  for(i = 0; i < N; i++){
    375c:	2485                	addiw	s1,s1,1
    375e:	fd449be3          	bne	s1,s4,3734 <writetest+0x46>
  close(fd);
    3762:	854a                	mv	a0,s2
    3764:	00002097          	auipc	ra,0x2
    3768:	2ae080e7          	jalr	686(ra) # 5a12 <close>
  fd = open("small", O_RDONLY);
    376c:	4581                	li	a1,0
    376e:	00004517          	auipc	a0,0x4
    3772:	44a50513          	addi	a0,a0,1098 # 7bb8 <csem_up+0x1b84>
    3776:	00002097          	auipc	ra,0x2
    377a:	2b4080e7          	jalr	692(ra) # 5a2a <open>
    377e:	84aa                	mv	s1,a0
  if(fd < 0){
    3780:	0a054563          	bltz	a0,382a <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
    3784:	7d000613          	li	a2,2000
    3788:	00009597          	auipc	a1,0x9
    378c:	85058593          	addi	a1,a1,-1968 # bfd8 <buf>
    3790:	00002097          	auipc	ra,0x2
    3794:	272080e7          	jalr	626(ra) # 5a02 <read>
  if(i != N*SZ*2){
    3798:	7d000793          	li	a5,2000
    379c:	0af51563          	bne	a0,a5,3846 <writetest+0x158>
  close(fd);
    37a0:	8526                	mv	a0,s1
    37a2:	00002097          	auipc	ra,0x2
    37a6:	270080e7          	jalr	624(ra) # 5a12 <close>
  if(unlink("small") < 0){
    37aa:	00004517          	auipc	a0,0x4
    37ae:	40e50513          	addi	a0,a0,1038 # 7bb8 <csem_up+0x1b84>
    37b2:	00002097          	auipc	ra,0x2
    37b6:	288080e7          	jalr	648(ra) # 5a3a <unlink>
    37ba:	0a054463          	bltz	a0,3862 <writetest+0x174>
}
    37be:	70e2                	ld	ra,56(sp)
    37c0:	7442                	ld	s0,48(sp)
    37c2:	74a2                	ld	s1,40(sp)
    37c4:	7902                	ld	s2,32(sp)
    37c6:	69e2                	ld	s3,24(sp)
    37c8:	6a42                	ld	s4,16(sp)
    37ca:	6aa2                	ld	s5,8(sp)
    37cc:	6b02                	ld	s6,0(sp)
    37ce:	6121                	addi	sp,sp,64
    37d0:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
    37d2:	85da                	mv	a1,s6
    37d4:	00004517          	auipc	a0,0x4
    37d8:	3ec50513          	addi	a0,a0,1004 # 7bc0 <csem_up+0x1b8c>
    37dc:	00002097          	auipc	ra,0x2
    37e0:	5e0080e7          	jalr	1504(ra) # 5dbc <printf>
    exit(1);
    37e4:	4505                	li	a0,1
    37e6:	00002097          	auipc	ra,0x2
    37ea:	204080e7          	jalr	516(ra) # 59ea <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
    37ee:	8626                	mv	a2,s1
    37f0:	85da                	mv	a1,s6
    37f2:	00004517          	auipc	a0,0x4
    37f6:	3fe50513          	addi	a0,a0,1022 # 7bf0 <csem_up+0x1bbc>
    37fa:	00002097          	auipc	ra,0x2
    37fe:	5c2080e7          	jalr	1474(ra) # 5dbc <printf>
      exit(1);
    3802:	4505                	li	a0,1
    3804:	00002097          	auipc	ra,0x2
    3808:	1e6080e7          	jalr	486(ra) # 59ea <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
    380c:	8626                	mv	a2,s1
    380e:	85da                	mv	a1,s6
    3810:	00004517          	auipc	a0,0x4
    3814:	41850513          	addi	a0,a0,1048 # 7c28 <csem_up+0x1bf4>
    3818:	00002097          	auipc	ra,0x2
    381c:	5a4080e7          	jalr	1444(ra) # 5dbc <printf>
      exit(1);
    3820:	4505                	li	a0,1
    3822:	00002097          	auipc	ra,0x2
    3826:	1c8080e7          	jalr	456(ra) # 59ea <exit>
    printf("%s: error: open small failed!\n", s);
    382a:	85da                	mv	a1,s6
    382c:	00004517          	auipc	a0,0x4
    3830:	42450513          	addi	a0,a0,1060 # 7c50 <csem_up+0x1c1c>
    3834:	00002097          	auipc	ra,0x2
    3838:	588080e7          	jalr	1416(ra) # 5dbc <printf>
    exit(1);
    383c:	4505                	li	a0,1
    383e:	00002097          	auipc	ra,0x2
    3842:	1ac080e7          	jalr	428(ra) # 59ea <exit>
    printf("%s: read failed\n", s);
    3846:	85da                	mv	a1,s6
    3848:	00003517          	auipc	a0,0x3
    384c:	48050513          	addi	a0,a0,1152 # 6cc8 <csem_up+0xc94>
    3850:	00002097          	auipc	ra,0x2
    3854:	56c080e7          	jalr	1388(ra) # 5dbc <printf>
    exit(1);
    3858:	4505                	li	a0,1
    385a:	00002097          	auipc	ra,0x2
    385e:	190080e7          	jalr	400(ra) # 59ea <exit>
    printf("%s: unlink small failed\n", s);
    3862:	85da                	mv	a1,s6
    3864:	00004517          	auipc	a0,0x4
    3868:	40c50513          	addi	a0,a0,1036 # 7c70 <csem_up+0x1c3c>
    386c:	00002097          	auipc	ra,0x2
    3870:	550080e7          	jalr	1360(ra) # 5dbc <printf>
    exit(1);
    3874:	4505                	li	a0,1
    3876:	00002097          	auipc	ra,0x2
    387a:	174080e7          	jalr	372(ra) # 59ea <exit>

000000000000387e <writebig>:
{
    387e:	7139                	addi	sp,sp,-64
    3880:	fc06                	sd	ra,56(sp)
    3882:	f822                	sd	s0,48(sp)
    3884:	f426                	sd	s1,40(sp)
    3886:	f04a                	sd	s2,32(sp)
    3888:	ec4e                	sd	s3,24(sp)
    388a:	e852                	sd	s4,16(sp)
    388c:	e456                	sd	s5,8(sp)
    388e:	0080                	addi	s0,sp,64
    3890:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
    3892:	20200593          	li	a1,514
    3896:	00004517          	auipc	a0,0x4
    389a:	3fa50513          	addi	a0,a0,1018 # 7c90 <csem_up+0x1c5c>
    389e:	00002097          	auipc	ra,0x2
    38a2:	18c080e7          	jalr	396(ra) # 5a2a <open>
    38a6:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
    38a8:	4481                	li	s1,0
    ((int*)buf)[0] = i;
    38aa:	00008917          	auipc	s2,0x8
    38ae:	72e90913          	addi	s2,s2,1838 # bfd8 <buf>
  for(i = 0; i < MAXFILE; i++){
    38b2:	10c00a13          	li	s4,268
  if(fd < 0){
    38b6:	06054c63          	bltz	a0,392e <writebig+0xb0>
    ((int*)buf)[0] = i;
    38ba:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
    38be:	40000613          	li	a2,1024
    38c2:	85ca                	mv	a1,s2
    38c4:	854e                	mv	a0,s3
    38c6:	00002097          	auipc	ra,0x2
    38ca:	144080e7          	jalr	324(ra) # 5a0a <write>
    38ce:	40000793          	li	a5,1024
    38d2:	06f51c63          	bne	a0,a5,394a <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
    38d6:	2485                	addiw	s1,s1,1
    38d8:	ff4491e3          	bne	s1,s4,38ba <writebig+0x3c>
  close(fd);
    38dc:	854e                	mv	a0,s3
    38de:	00002097          	auipc	ra,0x2
    38e2:	134080e7          	jalr	308(ra) # 5a12 <close>
  fd = open("big", O_RDONLY);
    38e6:	4581                	li	a1,0
    38e8:	00004517          	auipc	a0,0x4
    38ec:	3a850513          	addi	a0,a0,936 # 7c90 <csem_up+0x1c5c>
    38f0:	00002097          	auipc	ra,0x2
    38f4:	13a080e7          	jalr	314(ra) # 5a2a <open>
    38f8:	89aa                	mv	s3,a0
  n = 0;
    38fa:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
    38fc:	00008917          	auipc	s2,0x8
    3900:	6dc90913          	addi	s2,s2,1756 # bfd8 <buf>
  if(fd < 0){
    3904:	06054263          	bltz	a0,3968 <writebig+0xea>
    i = read(fd, buf, BSIZE);
    3908:	40000613          	li	a2,1024
    390c:	85ca                	mv	a1,s2
    390e:	854e                	mv	a0,s3
    3910:	00002097          	auipc	ra,0x2
    3914:	0f2080e7          	jalr	242(ra) # 5a02 <read>
    if(i == 0){
    3918:	c535                	beqz	a0,3984 <writebig+0x106>
    } else if(i != BSIZE){
    391a:	40000793          	li	a5,1024
    391e:	0af51f63          	bne	a0,a5,39dc <writebig+0x15e>
    if(((int*)buf)[0] != n){
    3922:	00092683          	lw	a3,0(s2)
    3926:	0c969a63          	bne	a3,s1,39fa <writebig+0x17c>
    n++;
    392a:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
    392c:	bff1                	j	3908 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
    392e:	85d6                	mv	a1,s5
    3930:	00004517          	auipc	a0,0x4
    3934:	36850513          	addi	a0,a0,872 # 7c98 <csem_up+0x1c64>
    3938:	00002097          	auipc	ra,0x2
    393c:	484080e7          	jalr	1156(ra) # 5dbc <printf>
    exit(1);
    3940:	4505                	li	a0,1
    3942:	00002097          	auipc	ra,0x2
    3946:	0a8080e7          	jalr	168(ra) # 59ea <exit>
      printf("%s: error: write big file failed\n", s, i);
    394a:	8626                	mv	a2,s1
    394c:	85d6                	mv	a1,s5
    394e:	00004517          	auipc	a0,0x4
    3952:	36a50513          	addi	a0,a0,874 # 7cb8 <csem_up+0x1c84>
    3956:	00002097          	auipc	ra,0x2
    395a:	466080e7          	jalr	1126(ra) # 5dbc <printf>
      exit(1);
    395e:	4505                	li	a0,1
    3960:	00002097          	auipc	ra,0x2
    3964:	08a080e7          	jalr	138(ra) # 59ea <exit>
    printf("%s: error: open big failed!\n", s);
    3968:	85d6                	mv	a1,s5
    396a:	00004517          	auipc	a0,0x4
    396e:	37650513          	addi	a0,a0,886 # 7ce0 <csem_up+0x1cac>
    3972:	00002097          	auipc	ra,0x2
    3976:	44a080e7          	jalr	1098(ra) # 5dbc <printf>
    exit(1);
    397a:	4505                	li	a0,1
    397c:	00002097          	auipc	ra,0x2
    3980:	06e080e7          	jalr	110(ra) # 59ea <exit>
      if(n == MAXFILE - 1){
    3984:	10b00793          	li	a5,267
    3988:	02f48a63          	beq	s1,a5,39bc <writebig+0x13e>
  close(fd);
    398c:	854e                	mv	a0,s3
    398e:	00002097          	auipc	ra,0x2
    3992:	084080e7          	jalr	132(ra) # 5a12 <close>
  if(unlink("big") < 0){
    3996:	00004517          	auipc	a0,0x4
    399a:	2fa50513          	addi	a0,a0,762 # 7c90 <csem_up+0x1c5c>
    399e:	00002097          	auipc	ra,0x2
    39a2:	09c080e7          	jalr	156(ra) # 5a3a <unlink>
    39a6:	06054963          	bltz	a0,3a18 <writebig+0x19a>
}
    39aa:	70e2                	ld	ra,56(sp)
    39ac:	7442                	ld	s0,48(sp)
    39ae:	74a2                	ld	s1,40(sp)
    39b0:	7902                	ld	s2,32(sp)
    39b2:	69e2                	ld	s3,24(sp)
    39b4:	6a42                	ld	s4,16(sp)
    39b6:	6aa2                	ld	s5,8(sp)
    39b8:	6121                	addi	sp,sp,64
    39ba:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
    39bc:	10b00613          	li	a2,267
    39c0:	85d6                	mv	a1,s5
    39c2:	00004517          	auipc	a0,0x4
    39c6:	33e50513          	addi	a0,a0,830 # 7d00 <csem_up+0x1ccc>
    39ca:	00002097          	auipc	ra,0x2
    39ce:	3f2080e7          	jalr	1010(ra) # 5dbc <printf>
        exit(1);
    39d2:	4505                	li	a0,1
    39d4:	00002097          	auipc	ra,0x2
    39d8:	016080e7          	jalr	22(ra) # 59ea <exit>
      printf("%s: read failed %d\n", s, i);
    39dc:	862a                	mv	a2,a0
    39de:	85d6                	mv	a1,s5
    39e0:	00004517          	auipc	a0,0x4
    39e4:	34850513          	addi	a0,a0,840 # 7d28 <csem_up+0x1cf4>
    39e8:	00002097          	auipc	ra,0x2
    39ec:	3d4080e7          	jalr	980(ra) # 5dbc <printf>
      exit(1);
    39f0:	4505                	li	a0,1
    39f2:	00002097          	auipc	ra,0x2
    39f6:	ff8080e7          	jalr	-8(ra) # 59ea <exit>
      printf("%s: read content of block %d is %d\n", s,
    39fa:	8626                	mv	a2,s1
    39fc:	85d6                	mv	a1,s5
    39fe:	00004517          	auipc	a0,0x4
    3a02:	34250513          	addi	a0,a0,834 # 7d40 <csem_up+0x1d0c>
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	3b6080e7          	jalr	950(ra) # 5dbc <printf>
      exit(1);
    3a0e:	4505                	li	a0,1
    3a10:	00002097          	auipc	ra,0x2
    3a14:	fda080e7          	jalr	-38(ra) # 59ea <exit>
    printf("%s: unlink big failed\n", s);
    3a18:	85d6                	mv	a1,s5
    3a1a:	00004517          	auipc	a0,0x4
    3a1e:	34e50513          	addi	a0,a0,846 # 7d68 <csem_up+0x1d34>
    3a22:	00002097          	auipc	ra,0x2
    3a26:	39a080e7          	jalr	922(ra) # 5dbc <printf>
    exit(1);
    3a2a:	4505                	li	a0,1
    3a2c:	00002097          	auipc	ra,0x2
    3a30:	fbe080e7          	jalr	-66(ra) # 59ea <exit>

0000000000003a34 <createtest>:
{
    3a34:	7179                	addi	sp,sp,-48
    3a36:	f406                	sd	ra,40(sp)
    3a38:	f022                	sd	s0,32(sp)
    3a3a:	ec26                	sd	s1,24(sp)
    3a3c:	e84a                	sd	s2,16(sp)
    3a3e:	1800                	addi	s0,sp,48
  name[0] = 'a';
    3a40:	06100793          	li	a5,97
    3a44:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
    3a48:	fc040d23          	sb	zero,-38(s0)
    3a4c:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
    3a50:	06400913          	li	s2,100
    name[1] = '0' + i;
    3a54:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
    3a58:	20200593          	li	a1,514
    3a5c:	fd840513          	addi	a0,s0,-40
    3a60:	00002097          	auipc	ra,0x2
    3a64:	fca080e7          	jalr	-54(ra) # 5a2a <open>
    close(fd);
    3a68:	00002097          	auipc	ra,0x2
    3a6c:	faa080e7          	jalr	-86(ra) # 5a12 <close>
  for(i = 0; i < N; i++){
    3a70:	2485                	addiw	s1,s1,1
    3a72:	0ff4f493          	andi	s1,s1,255
    3a76:	fd249fe3          	bne	s1,s2,3a54 <createtest+0x20>
  name[0] = 'a';
    3a7a:	06100793          	li	a5,97
    3a7e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
    3a82:	fc040d23          	sb	zero,-38(s0)
    3a86:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
    3a8a:	06400913          	li	s2,100
    name[1] = '0' + i;
    3a8e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
    3a92:	fd840513          	addi	a0,s0,-40
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	fa4080e7          	jalr	-92(ra) # 5a3a <unlink>
  for(i = 0; i < N; i++){
    3a9e:	2485                	addiw	s1,s1,1
    3aa0:	0ff4f493          	andi	s1,s1,255
    3aa4:	ff2495e3          	bne	s1,s2,3a8e <createtest+0x5a>
}
    3aa8:	70a2                	ld	ra,40(sp)
    3aaa:	7402                	ld	s0,32(sp)
    3aac:	64e2                	ld	s1,24(sp)
    3aae:	6942                	ld	s2,16(sp)
    3ab0:	6145                	addi	sp,sp,48
    3ab2:	8082                	ret

0000000000003ab4 <killstatus>:
{
    3ab4:	7139                	addi	sp,sp,-64
    3ab6:	fc06                	sd	ra,56(sp)
    3ab8:	f822                	sd	s0,48(sp)
    3aba:	f426                	sd	s1,40(sp)
    3abc:	f04a                	sd	s2,32(sp)
    3abe:	ec4e                	sd	s3,24(sp)
    3ac0:	e852                	sd	s4,16(sp)
    3ac2:	0080                	addi	s0,sp,64
    3ac4:	8a2a                	mv	s4,a0
    3ac6:	06400913          	li	s2,100
    if(xst != -1) {
    3aca:	59fd                	li	s3,-1
    int pid1 = fork();
    3acc:	00002097          	auipc	ra,0x2
    3ad0:	f16080e7          	jalr	-234(ra) # 59e2 <fork>
    3ad4:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3ad6:	04054063          	bltz	a0,3b16 <killstatus+0x62>
    if(pid1 == 0){
    3ada:	cd21                	beqz	a0,3b32 <killstatus+0x7e>
    sleep(1);
    3adc:	4505                	li	a0,1
    3ade:	00002097          	auipc	ra,0x2
    3ae2:	f9c080e7          	jalr	-100(ra) # 5a7a <sleep>
    kill(pid1, SIGKILL);
    3ae6:	45a5                	li	a1,9
    3ae8:	8526                	mv	a0,s1
    3aea:	00002097          	auipc	ra,0x2
    3aee:	f30080e7          	jalr	-208(ra) # 5a1a <kill>
    wait(&xst);
    3af2:	fcc40513          	addi	a0,s0,-52
    3af6:	00002097          	auipc	ra,0x2
    3afa:	efc080e7          	jalr	-260(ra) # 59f2 <wait>
    if(xst != -1) {
    3afe:	fcc42783          	lw	a5,-52(s0)
    3b02:	03379d63          	bne	a5,s3,3b3c <killstatus+0x88>
  for(int i = 0; i < 100; i++){
    3b06:	397d                	addiw	s2,s2,-1
    3b08:	fc0912e3          	bnez	s2,3acc <killstatus+0x18>
  exit(0);
    3b0c:	4501                	li	a0,0
    3b0e:	00002097          	auipc	ra,0x2
    3b12:	edc080e7          	jalr	-292(ra) # 59ea <exit>
      printf("%s: fork failed\n", s);
    3b16:	85d2                	mv	a1,s4
    3b18:	00003517          	auipc	a0,0x3
    3b1c:	81850513          	addi	a0,a0,-2024 # 6330 <csem_up+0x2fc>
    3b20:	00002097          	auipc	ra,0x2
    3b24:	29c080e7          	jalr	668(ra) # 5dbc <printf>
      exit(1);
    3b28:	4505                	li	a0,1
    3b2a:	00002097          	auipc	ra,0x2
    3b2e:	ec0080e7          	jalr	-320(ra) # 59ea <exit>
        getpid();
    3b32:	00002097          	auipc	ra,0x2
    3b36:	f38080e7          	jalr	-200(ra) # 5a6a <getpid>
      while(1) {
    3b3a:	bfe5                	j	3b32 <killstatus+0x7e>
       printf("%s: status should be -1\n", s);
    3b3c:	85d2                	mv	a1,s4
    3b3e:	00004517          	auipc	a0,0x4
    3b42:	24250513          	addi	a0,a0,578 # 7d80 <csem_up+0x1d4c>
    3b46:	00002097          	auipc	ra,0x2
    3b4a:	276080e7          	jalr	630(ra) # 5dbc <printf>
       exit(1);
    3b4e:	4505                	li	a0,1
    3b50:	00002097          	auipc	ra,0x2
    3b54:	e9a080e7          	jalr	-358(ra) # 59ea <exit>

0000000000003b58 <reparent2>:
{
    3b58:	1101                	addi	sp,sp,-32
    3b5a:	ec06                	sd	ra,24(sp)
    3b5c:	e822                	sd	s0,16(sp)
    3b5e:	e426                	sd	s1,8(sp)
    3b60:	1000                	addi	s0,sp,32
    3b62:	32000493          	li	s1,800
    int pid1 = fork();
    3b66:	00002097          	auipc	ra,0x2
    3b6a:	e7c080e7          	jalr	-388(ra) # 59e2 <fork>
    if(pid1 < 0){
    3b6e:	00054f63          	bltz	a0,3b8c <reparent2+0x34>
    if(pid1 == 0){
    3b72:	c915                	beqz	a0,3ba6 <reparent2+0x4e>
    wait(0);
    3b74:	4501                	li	a0,0
    3b76:	00002097          	auipc	ra,0x2
    3b7a:	e7c080e7          	jalr	-388(ra) # 59f2 <wait>
  for(int i = 0; i < 800; i++){
    3b7e:	34fd                	addiw	s1,s1,-1
    3b80:	f0fd                	bnez	s1,3b66 <reparent2+0xe>
  exit(0);
    3b82:	4501                	li	a0,0
    3b84:	00002097          	auipc	ra,0x2
    3b88:	e66080e7          	jalr	-410(ra) # 59ea <exit>
      printf("fork failed\n");
    3b8c:	00003517          	auipc	a0,0x3
    3b90:	26c50513          	addi	a0,a0,620 # 6df8 <csem_up+0xdc4>
    3b94:	00002097          	auipc	ra,0x2
    3b98:	228080e7          	jalr	552(ra) # 5dbc <printf>
      exit(1);
    3b9c:	4505                	li	a0,1
    3b9e:	00002097          	auipc	ra,0x2
    3ba2:	e4c080e7          	jalr	-436(ra) # 59ea <exit>
      fork();
    3ba6:	00002097          	auipc	ra,0x2
    3baa:	e3c080e7          	jalr	-452(ra) # 59e2 <fork>
      fork();
    3bae:	00002097          	auipc	ra,0x2
    3bb2:	e34080e7          	jalr	-460(ra) # 59e2 <fork>
      exit(0);
    3bb6:	4501                	li	a0,0
    3bb8:	00002097          	auipc	ra,0x2
    3bbc:	e32080e7          	jalr	-462(ra) # 59ea <exit>

0000000000003bc0 <mem>:
{
    3bc0:	7139                	addi	sp,sp,-64
    3bc2:	fc06                	sd	ra,56(sp)
    3bc4:	f822                	sd	s0,48(sp)
    3bc6:	f426                	sd	s1,40(sp)
    3bc8:	f04a                	sd	s2,32(sp)
    3bca:	ec4e                	sd	s3,24(sp)
    3bcc:	0080                	addi	s0,sp,64
    3bce:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3bd0:	00002097          	auipc	ra,0x2
    3bd4:	e12080e7          	jalr	-494(ra) # 59e2 <fork>
    m1 = 0;
    3bd8:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3bda:	6909                	lui	s2,0x2
    3bdc:	71190913          	addi	s2,s2,1809 # 2711 <subdir+0x231>
  if((pid = fork()) == 0){
    3be0:	c115                	beqz	a0,3c04 <mem+0x44>
    wait(&xstatus);
    3be2:	fcc40513          	addi	a0,s0,-52
    3be6:	00002097          	auipc	ra,0x2
    3bea:	e0c080e7          	jalr	-500(ra) # 59f2 <wait>
    if(xstatus == -1){
    3bee:	fcc42503          	lw	a0,-52(s0)
    3bf2:	57fd                	li	a5,-1
    3bf4:	06f50363          	beq	a0,a5,3c5a <mem+0x9a>
    exit(xstatus);
    3bf8:	00002097          	auipc	ra,0x2
    3bfc:	df2080e7          	jalr	-526(ra) # 59ea <exit>
      *(char**)m2 = m1;
    3c00:	e104                	sd	s1,0(a0)
      m1 = m2;
    3c02:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3c04:	854a                	mv	a0,s2
    3c06:	00002097          	auipc	ra,0x2
    3c0a:	274080e7          	jalr	628(ra) # 5e7a <malloc>
    3c0e:	f96d                	bnez	a0,3c00 <mem+0x40>
    while(m1){
    3c10:	c881                	beqz	s1,3c20 <mem+0x60>
      m2 = *(char**)m1;
    3c12:	8526                	mv	a0,s1
    3c14:	6084                	ld	s1,0(s1)
      free(m1);
    3c16:	00002097          	auipc	ra,0x2
    3c1a:	1dc080e7          	jalr	476(ra) # 5df2 <free>
    while(m1){
    3c1e:	f8f5                	bnez	s1,3c12 <mem+0x52>
    m1 = malloc(1024*20);
    3c20:	6515                	lui	a0,0x5
    3c22:	00002097          	auipc	ra,0x2
    3c26:	258080e7          	jalr	600(ra) # 5e7a <malloc>
    if(m1 == 0){
    3c2a:	c911                	beqz	a0,3c3e <mem+0x7e>
    free(m1);
    3c2c:	00002097          	auipc	ra,0x2
    3c30:	1c6080e7          	jalr	454(ra) # 5df2 <free>
    exit(0);
    3c34:	4501                	li	a0,0
    3c36:	00002097          	auipc	ra,0x2
    3c3a:	db4080e7          	jalr	-588(ra) # 59ea <exit>
      printf("couldn't allocate mem?!!\n", s);
    3c3e:	85ce                	mv	a1,s3
    3c40:	00004517          	auipc	a0,0x4
    3c44:	16050513          	addi	a0,a0,352 # 7da0 <csem_up+0x1d6c>
    3c48:	00002097          	auipc	ra,0x2
    3c4c:	174080e7          	jalr	372(ra) # 5dbc <printf>
      exit(1);
    3c50:	4505                	li	a0,1
    3c52:	00002097          	auipc	ra,0x2
    3c56:	d98080e7          	jalr	-616(ra) # 59ea <exit>
      exit(0);
    3c5a:	4501                	li	a0,0
    3c5c:	00002097          	auipc	ra,0x2
    3c60:	d8e080e7          	jalr	-626(ra) # 59ea <exit>

0000000000003c64 <sharedfd>:
{
    3c64:	7159                	addi	sp,sp,-112
    3c66:	f486                	sd	ra,104(sp)
    3c68:	f0a2                	sd	s0,96(sp)
    3c6a:	eca6                	sd	s1,88(sp)
    3c6c:	e8ca                	sd	s2,80(sp)
    3c6e:	e4ce                	sd	s3,72(sp)
    3c70:	e0d2                	sd	s4,64(sp)
    3c72:	fc56                	sd	s5,56(sp)
    3c74:	f85a                	sd	s6,48(sp)
    3c76:	f45e                	sd	s7,40(sp)
    3c78:	1880                	addi	s0,sp,112
    3c7a:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3c7c:	00004517          	auipc	a0,0x4
    3c80:	14450513          	addi	a0,a0,324 # 7dc0 <csem_up+0x1d8c>
    3c84:	00002097          	auipc	ra,0x2
    3c88:	db6080e7          	jalr	-586(ra) # 5a3a <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3c8c:	20200593          	li	a1,514
    3c90:	00004517          	auipc	a0,0x4
    3c94:	13050513          	addi	a0,a0,304 # 7dc0 <csem_up+0x1d8c>
    3c98:	00002097          	auipc	ra,0x2
    3c9c:	d92080e7          	jalr	-622(ra) # 5a2a <open>
  if(fd < 0){
    3ca0:	04054a63          	bltz	a0,3cf4 <sharedfd+0x90>
    3ca4:	892a                	mv	s2,a0
  pid = fork();
    3ca6:	00002097          	auipc	ra,0x2
    3caa:	d3c080e7          	jalr	-708(ra) # 59e2 <fork>
    3cae:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3cb0:	06300593          	li	a1,99
    3cb4:	c119                	beqz	a0,3cba <sharedfd+0x56>
    3cb6:	07000593          	li	a1,112
    3cba:	4629                	li	a2,10
    3cbc:	fa040513          	addi	a0,s0,-96
    3cc0:	00002097          	auipc	ra,0x2
    3cc4:	b2e080e7          	jalr	-1234(ra) # 57ee <memset>
    3cc8:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3ccc:	4629                	li	a2,10
    3cce:	fa040593          	addi	a1,s0,-96
    3cd2:	854a                	mv	a0,s2
    3cd4:	00002097          	auipc	ra,0x2
    3cd8:	d36080e7          	jalr	-714(ra) # 5a0a <write>
    3cdc:	47a9                	li	a5,10
    3cde:	02f51963          	bne	a0,a5,3d10 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    3ce2:	34fd                	addiw	s1,s1,-1
    3ce4:	f4e5                	bnez	s1,3ccc <sharedfd+0x68>
  if(pid == 0) {
    3ce6:	04099363          	bnez	s3,3d2c <sharedfd+0xc8>
    exit(0);
    3cea:	4501                	li	a0,0
    3cec:	00002097          	auipc	ra,0x2
    3cf0:	cfe080e7          	jalr	-770(ra) # 59ea <exit>
    printf("%s: cannot open sharedfd for writing", s);
    3cf4:	85d2                	mv	a1,s4
    3cf6:	00004517          	auipc	a0,0x4
    3cfa:	0da50513          	addi	a0,a0,218 # 7dd0 <csem_up+0x1d9c>
    3cfe:	00002097          	auipc	ra,0x2
    3d02:	0be080e7          	jalr	190(ra) # 5dbc <printf>
    exit(1);
    3d06:	4505                	li	a0,1
    3d08:	00002097          	auipc	ra,0x2
    3d0c:	ce2080e7          	jalr	-798(ra) # 59ea <exit>
      printf("%s: write sharedfd failed\n", s);
    3d10:	85d2                	mv	a1,s4
    3d12:	00004517          	auipc	a0,0x4
    3d16:	0e650513          	addi	a0,a0,230 # 7df8 <csem_up+0x1dc4>
    3d1a:	00002097          	auipc	ra,0x2
    3d1e:	0a2080e7          	jalr	162(ra) # 5dbc <printf>
      exit(1);
    3d22:	4505                	li	a0,1
    3d24:	00002097          	auipc	ra,0x2
    3d28:	cc6080e7          	jalr	-826(ra) # 59ea <exit>
    wait(&xstatus);
    3d2c:	f9c40513          	addi	a0,s0,-100
    3d30:	00002097          	auipc	ra,0x2
    3d34:	cc2080e7          	jalr	-830(ra) # 59f2 <wait>
    if(xstatus != 0)
    3d38:	f9c42983          	lw	s3,-100(s0)
    3d3c:	00098763          	beqz	s3,3d4a <sharedfd+0xe6>
      exit(xstatus);
    3d40:	854e                	mv	a0,s3
    3d42:	00002097          	auipc	ra,0x2
    3d46:	ca8080e7          	jalr	-856(ra) # 59ea <exit>
  close(fd);
    3d4a:	854a                	mv	a0,s2
    3d4c:	00002097          	auipc	ra,0x2
    3d50:	cc6080e7          	jalr	-826(ra) # 5a12 <close>
  fd = open("sharedfd", 0);
    3d54:	4581                	li	a1,0
    3d56:	00004517          	auipc	a0,0x4
    3d5a:	06a50513          	addi	a0,a0,106 # 7dc0 <csem_up+0x1d8c>
    3d5e:	00002097          	auipc	ra,0x2
    3d62:	ccc080e7          	jalr	-820(ra) # 5a2a <open>
    3d66:	8baa                	mv	s7,a0
  nc = np = 0;
    3d68:	8ace                	mv	s5,s3
  if(fd < 0){
    3d6a:	02054563          	bltz	a0,3d94 <sharedfd+0x130>
    3d6e:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3d72:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3d76:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3d7a:	4629                	li	a2,10
    3d7c:	fa040593          	addi	a1,s0,-96
    3d80:	855e                	mv	a0,s7
    3d82:	00002097          	auipc	ra,0x2
    3d86:	c80080e7          	jalr	-896(ra) # 5a02 <read>
    3d8a:	02a05f63          	blez	a0,3dc8 <sharedfd+0x164>
    3d8e:	fa040793          	addi	a5,s0,-96
    3d92:	a01d                	j	3db8 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    3d94:	85d2                	mv	a1,s4
    3d96:	00004517          	auipc	a0,0x4
    3d9a:	08250513          	addi	a0,a0,130 # 7e18 <csem_up+0x1de4>
    3d9e:	00002097          	auipc	ra,0x2
    3da2:	01e080e7          	jalr	30(ra) # 5dbc <printf>
    exit(1);
    3da6:	4505                	li	a0,1
    3da8:	00002097          	auipc	ra,0x2
    3dac:	c42080e7          	jalr	-958(ra) # 59ea <exit>
        nc++;
    3db0:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    3db2:	0785                	addi	a5,a5,1
    3db4:	fd2783e3          	beq	a5,s2,3d7a <sharedfd+0x116>
      if(buf[i] == 'c')
    3db8:	0007c703          	lbu	a4,0(a5)
    3dbc:	fe970ae3          	beq	a4,s1,3db0 <sharedfd+0x14c>
      if(buf[i] == 'p')
    3dc0:	ff6719e3          	bne	a4,s6,3db2 <sharedfd+0x14e>
        np++;
    3dc4:	2a85                	addiw	s5,s5,1
    3dc6:	b7f5                	j	3db2 <sharedfd+0x14e>
  close(fd);
    3dc8:	855e                	mv	a0,s7
    3dca:	00002097          	auipc	ra,0x2
    3dce:	c48080e7          	jalr	-952(ra) # 5a12 <close>
  unlink("sharedfd");
    3dd2:	00004517          	auipc	a0,0x4
    3dd6:	fee50513          	addi	a0,a0,-18 # 7dc0 <csem_up+0x1d8c>
    3dda:	00002097          	auipc	ra,0x2
    3dde:	c60080e7          	jalr	-928(ra) # 5a3a <unlink>
  if(nc == N*SZ && np == N*SZ){
    3de2:	6789                	lui	a5,0x2
    3de4:	71078793          	addi	a5,a5,1808 # 2710 <subdir+0x230>
    3de8:	00f99763          	bne	s3,a5,3df6 <sharedfd+0x192>
    3dec:	6789                	lui	a5,0x2
    3dee:	71078793          	addi	a5,a5,1808 # 2710 <subdir+0x230>
    3df2:	02fa8063          	beq	s5,a5,3e12 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    3df6:	85d2                	mv	a1,s4
    3df8:	00004517          	auipc	a0,0x4
    3dfc:	04850513          	addi	a0,a0,72 # 7e40 <csem_up+0x1e0c>
    3e00:	00002097          	auipc	ra,0x2
    3e04:	fbc080e7          	jalr	-68(ra) # 5dbc <printf>
    exit(1);
    3e08:	4505                	li	a0,1
    3e0a:	00002097          	auipc	ra,0x2
    3e0e:	be0080e7          	jalr	-1056(ra) # 59ea <exit>
    exit(0);
    3e12:	4501                	li	a0,0
    3e14:	00002097          	auipc	ra,0x2
    3e18:	bd6080e7          	jalr	-1066(ra) # 59ea <exit>

0000000000003e1c <createdelete>:
{
    3e1c:	7175                	addi	sp,sp,-144
    3e1e:	e506                	sd	ra,136(sp)
    3e20:	e122                	sd	s0,128(sp)
    3e22:	fca6                	sd	s1,120(sp)
    3e24:	f8ca                	sd	s2,112(sp)
    3e26:	f4ce                	sd	s3,104(sp)
    3e28:	f0d2                	sd	s4,96(sp)
    3e2a:	ecd6                	sd	s5,88(sp)
    3e2c:	e8da                	sd	s6,80(sp)
    3e2e:	e4de                	sd	s7,72(sp)
    3e30:	e0e2                	sd	s8,64(sp)
    3e32:	fc66                	sd	s9,56(sp)
    3e34:	0900                	addi	s0,sp,144
    3e36:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    3e38:	4901                	li	s2,0
    3e3a:	4991                	li	s3,4
    pid = fork();
    3e3c:	00002097          	auipc	ra,0x2
    3e40:	ba6080e7          	jalr	-1114(ra) # 59e2 <fork>
    3e44:	84aa                	mv	s1,a0
    if(pid < 0){
    3e46:	02054f63          	bltz	a0,3e84 <createdelete+0x68>
    if(pid == 0){
    3e4a:	c939                	beqz	a0,3ea0 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    3e4c:	2905                	addiw	s2,s2,1
    3e4e:	ff3917e3          	bne	s2,s3,3e3c <createdelete+0x20>
    3e52:	4491                	li	s1,4
    wait(&xstatus);
    3e54:	f7c40513          	addi	a0,s0,-132
    3e58:	00002097          	auipc	ra,0x2
    3e5c:	b9a080e7          	jalr	-1126(ra) # 59f2 <wait>
    if(xstatus != 0)
    3e60:	f7c42903          	lw	s2,-132(s0)
    3e64:	0e091263          	bnez	s2,3f48 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    3e68:	34fd                	addiw	s1,s1,-1
    3e6a:	f4ed                	bnez	s1,3e54 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    3e6c:	f8040123          	sb	zero,-126(s0)
    3e70:	03000993          	li	s3,48
    3e74:	5a7d                	li	s4,-1
    3e76:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    3e7a:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    3e7c:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    3e7e:	07400a93          	li	s5,116
    3e82:	a29d                	j	3fe8 <createdelete+0x1cc>
      printf("fork failed\n", s);
    3e84:	85e6                	mv	a1,s9
    3e86:	00003517          	auipc	a0,0x3
    3e8a:	f7250513          	addi	a0,a0,-142 # 6df8 <csem_up+0xdc4>
    3e8e:	00002097          	auipc	ra,0x2
    3e92:	f2e080e7          	jalr	-210(ra) # 5dbc <printf>
      exit(1);
    3e96:	4505                	li	a0,1
    3e98:	00002097          	auipc	ra,0x2
    3e9c:	b52080e7          	jalr	-1198(ra) # 59ea <exit>
      name[0] = 'p' + pi;
    3ea0:	0709091b          	addiw	s2,s2,112
    3ea4:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    3ea8:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    3eac:	4951                	li	s2,20
    3eae:	a015                	j	3ed2 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    3eb0:	85e6                	mv	a1,s9
    3eb2:	00003517          	auipc	a0,0x3
    3eb6:	da650513          	addi	a0,a0,-602 # 6c58 <csem_up+0xc24>
    3eba:	00002097          	auipc	ra,0x2
    3ebe:	f02080e7          	jalr	-254(ra) # 5dbc <printf>
          exit(1);
    3ec2:	4505                	li	a0,1
    3ec4:	00002097          	auipc	ra,0x2
    3ec8:	b26080e7          	jalr	-1242(ra) # 59ea <exit>
      for(i = 0; i < N; i++){
    3ecc:	2485                	addiw	s1,s1,1
    3ece:	07248863          	beq	s1,s2,3f3e <createdelete+0x122>
        name[1] = '0' + i;
    3ed2:	0304879b          	addiw	a5,s1,48
    3ed6:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    3eda:	20200593          	li	a1,514
    3ede:	f8040513          	addi	a0,s0,-128
    3ee2:	00002097          	auipc	ra,0x2
    3ee6:	b48080e7          	jalr	-1208(ra) # 5a2a <open>
        if(fd < 0){
    3eea:	fc0543e3          	bltz	a0,3eb0 <createdelete+0x94>
        close(fd);
    3eee:	00002097          	auipc	ra,0x2
    3ef2:	b24080e7          	jalr	-1244(ra) # 5a12 <close>
        if(i > 0 && (i % 2 ) == 0){
    3ef6:	fc905be3          	blez	s1,3ecc <createdelete+0xb0>
    3efa:	0014f793          	andi	a5,s1,1
    3efe:	f7f9                	bnez	a5,3ecc <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    3f00:	01f4d79b          	srliw	a5,s1,0x1f
    3f04:	9fa5                	addw	a5,a5,s1
    3f06:	4017d79b          	sraiw	a5,a5,0x1
    3f0a:	0307879b          	addiw	a5,a5,48
    3f0e:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    3f12:	f8040513          	addi	a0,s0,-128
    3f16:	00002097          	auipc	ra,0x2
    3f1a:	b24080e7          	jalr	-1244(ra) # 5a3a <unlink>
    3f1e:	fa0557e3          	bgez	a0,3ecc <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    3f22:	85e6                	mv	a1,s9
    3f24:	00003517          	auipc	a0,0x3
    3f28:	03c50513          	addi	a0,a0,60 # 6f60 <csem_up+0xf2c>
    3f2c:	00002097          	auipc	ra,0x2
    3f30:	e90080e7          	jalr	-368(ra) # 5dbc <printf>
            exit(1);
    3f34:	4505                	li	a0,1
    3f36:	00002097          	auipc	ra,0x2
    3f3a:	ab4080e7          	jalr	-1356(ra) # 59ea <exit>
      exit(0);
    3f3e:	4501                	li	a0,0
    3f40:	00002097          	auipc	ra,0x2
    3f44:	aaa080e7          	jalr	-1366(ra) # 59ea <exit>
      exit(1);
    3f48:	4505                	li	a0,1
    3f4a:	00002097          	auipc	ra,0x2
    3f4e:	aa0080e7          	jalr	-1376(ra) # 59ea <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    3f52:	f8040613          	addi	a2,s0,-128
    3f56:	85e6                	mv	a1,s9
    3f58:	00004517          	auipc	a0,0x4
    3f5c:	f0050513          	addi	a0,a0,-256 # 7e58 <csem_up+0x1e24>
    3f60:	00002097          	auipc	ra,0x2
    3f64:	e5c080e7          	jalr	-420(ra) # 5dbc <printf>
        exit(1);
    3f68:	4505                	li	a0,1
    3f6a:	00002097          	auipc	ra,0x2
    3f6e:	a80080e7          	jalr	-1408(ra) # 59ea <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    3f72:	054b7163          	bgeu	s6,s4,3fb4 <createdelete+0x198>
      if(fd >= 0)
    3f76:	02055a63          	bgez	a0,3faa <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    3f7a:	2485                	addiw	s1,s1,1
    3f7c:	0ff4f493          	andi	s1,s1,255
    3f80:	05548c63          	beq	s1,s5,3fd8 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    3f84:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    3f88:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    3f8c:	4581                	li	a1,0
    3f8e:	f8040513          	addi	a0,s0,-128
    3f92:	00002097          	auipc	ra,0x2
    3f96:	a98080e7          	jalr	-1384(ra) # 5a2a <open>
      if((i == 0 || i >= N/2) && fd < 0){
    3f9a:	00090463          	beqz	s2,3fa2 <createdelete+0x186>
    3f9e:	fd2bdae3          	bge	s7,s2,3f72 <createdelete+0x156>
    3fa2:	fa0548e3          	bltz	a0,3f52 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    3fa6:	014b7963          	bgeu	s6,s4,3fb8 <createdelete+0x19c>
        close(fd);
    3faa:	00002097          	auipc	ra,0x2
    3fae:	a68080e7          	jalr	-1432(ra) # 5a12 <close>
    3fb2:	b7e1                	j	3f7a <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    3fb4:	fc0543e3          	bltz	a0,3f7a <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    3fb8:	f8040613          	addi	a2,s0,-128
    3fbc:	85e6                	mv	a1,s9
    3fbe:	00004517          	auipc	a0,0x4
    3fc2:	ec250513          	addi	a0,a0,-318 # 7e80 <csem_up+0x1e4c>
    3fc6:	00002097          	auipc	ra,0x2
    3fca:	df6080e7          	jalr	-522(ra) # 5dbc <printf>
        exit(1);
    3fce:	4505                	li	a0,1
    3fd0:	00002097          	auipc	ra,0x2
    3fd4:	a1a080e7          	jalr	-1510(ra) # 59ea <exit>
  for(i = 0; i < N; i++){
    3fd8:	2905                	addiw	s2,s2,1
    3fda:	2a05                	addiw	s4,s4,1
    3fdc:	2985                	addiw	s3,s3,1
    3fde:	0ff9f993          	andi	s3,s3,255
    3fe2:	47d1                	li	a5,20
    3fe4:	02f90a63          	beq	s2,a5,4018 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    3fe8:	84e2                	mv	s1,s8
    3fea:	bf69                	j	3f84 <createdelete+0x168>
  for(i = 0; i < N; i++){
    3fec:	2905                	addiw	s2,s2,1
    3fee:	0ff97913          	andi	s2,s2,255
    3ff2:	2985                	addiw	s3,s3,1
    3ff4:	0ff9f993          	andi	s3,s3,255
    3ff8:	03490863          	beq	s2,s4,4028 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    3ffc:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    3ffe:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    4002:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    4006:	f8040513          	addi	a0,s0,-128
    400a:	00002097          	auipc	ra,0x2
    400e:	a30080e7          	jalr	-1488(ra) # 5a3a <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    4012:	34fd                	addiw	s1,s1,-1
    4014:	f4ed                	bnez	s1,3ffe <createdelete+0x1e2>
    4016:	bfd9                	j	3fec <createdelete+0x1d0>
    4018:	03000993          	li	s3,48
    401c:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    4020:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    4022:	08400a13          	li	s4,132
    4026:	bfd9                	j	3ffc <createdelete+0x1e0>
}
    4028:	60aa                	ld	ra,136(sp)
    402a:	640a                	ld	s0,128(sp)
    402c:	74e6                	ld	s1,120(sp)
    402e:	7946                	ld	s2,112(sp)
    4030:	79a6                	ld	s3,104(sp)
    4032:	7a06                	ld	s4,96(sp)
    4034:	6ae6                	ld	s5,88(sp)
    4036:	6b46                	ld	s6,80(sp)
    4038:	6ba6                	ld	s7,72(sp)
    403a:	6c06                	ld	s8,64(sp)
    403c:	7ce2                	ld	s9,56(sp)
    403e:	6149                	addi	sp,sp,144
    4040:	8082                	ret

0000000000004042 <concreate>:
{
    4042:	7135                	addi	sp,sp,-160
    4044:	ed06                	sd	ra,152(sp)
    4046:	e922                	sd	s0,144(sp)
    4048:	e526                	sd	s1,136(sp)
    404a:	e14a                	sd	s2,128(sp)
    404c:	fcce                	sd	s3,120(sp)
    404e:	f8d2                	sd	s4,112(sp)
    4050:	f4d6                	sd	s5,104(sp)
    4052:	f0da                	sd	s6,96(sp)
    4054:	ecde                	sd	s7,88(sp)
    4056:	1100                	addi	s0,sp,160
    4058:	89aa                	mv	s3,a0
  file[0] = 'C';
    405a:	04300793          	li	a5,67
    405e:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4062:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4066:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4068:	4b0d                	li	s6,3
    406a:	4a85                	li	s5,1
      link("C0", file);
    406c:	00004b97          	auipc	s7,0x4
    4070:	e3cb8b93          	addi	s7,s7,-452 # 7ea8 <csem_up+0x1e74>
  for(i = 0; i < N; i++){
    4074:	02800a13          	li	s4,40
    4078:	acc1                	j	4348 <concreate+0x306>
      link("C0", file);
    407a:	fa840593          	addi	a1,s0,-88
    407e:	855e                	mv	a0,s7
    4080:	00002097          	auipc	ra,0x2
    4084:	9ca080e7          	jalr	-1590(ra) # 5a4a <link>
    if(pid == 0) {
    4088:	a45d                	j	432e <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    408a:	4795                	li	a5,5
    408c:	02f9693b          	remw	s2,s2,a5
    4090:	4785                	li	a5,1
    4092:	02f90b63          	beq	s2,a5,40c8 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4096:	20200593          	li	a1,514
    409a:	fa840513          	addi	a0,s0,-88
    409e:	00002097          	auipc	ra,0x2
    40a2:	98c080e7          	jalr	-1652(ra) # 5a2a <open>
      if(fd < 0){
    40a6:	26055b63          	bgez	a0,431c <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    40aa:	fa840593          	addi	a1,s0,-88
    40ae:	00004517          	auipc	a0,0x4
    40b2:	e0250513          	addi	a0,a0,-510 # 7eb0 <csem_up+0x1e7c>
    40b6:	00002097          	auipc	ra,0x2
    40ba:	d06080e7          	jalr	-762(ra) # 5dbc <printf>
        exit(1);
    40be:	4505                	li	a0,1
    40c0:	00002097          	auipc	ra,0x2
    40c4:	92a080e7          	jalr	-1750(ra) # 59ea <exit>
      link("C0", file);
    40c8:	fa840593          	addi	a1,s0,-88
    40cc:	00004517          	auipc	a0,0x4
    40d0:	ddc50513          	addi	a0,a0,-548 # 7ea8 <csem_up+0x1e74>
    40d4:	00002097          	auipc	ra,0x2
    40d8:	976080e7          	jalr	-1674(ra) # 5a4a <link>
      exit(0);
    40dc:	4501                	li	a0,0
    40de:	00002097          	auipc	ra,0x2
    40e2:	90c080e7          	jalr	-1780(ra) # 59ea <exit>
        exit(1);
    40e6:	4505                	li	a0,1
    40e8:	00002097          	auipc	ra,0x2
    40ec:	902080e7          	jalr	-1790(ra) # 59ea <exit>
  memset(fa, 0, sizeof(fa));
    40f0:	02800613          	li	a2,40
    40f4:	4581                	li	a1,0
    40f6:	f8040513          	addi	a0,s0,-128
    40fa:	00001097          	auipc	ra,0x1
    40fe:	6f4080e7          	jalr	1780(ra) # 57ee <memset>
  fd = open(".", 0);
    4102:	4581                	li	a1,0
    4104:	00003517          	auipc	a0,0x3
    4108:	a0c50513          	addi	a0,a0,-1524 # 6b10 <csem_up+0xadc>
    410c:	00002097          	auipc	ra,0x2
    4110:	91e080e7          	jalr	-1762(ra) # 5a2a <open>
    4114:	892a                	mv	s2,a0
  n = 0;
    4116:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4118:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    411c:	02700b13          	li	s6,39
      fa[i] = 1;
    4120:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4122:	4641                	li	a2,16
    4124:	f7040593          	addi	a1,s0,-144
    4128:	854a                	mv	a0,s2
    412a:	00002097          	auipc	ra,0x2
    412e:	8d8080e7          	jalr	-1832(ra) # 5a02 <read>
    4132:	08a05163          	blez	a0,41b4 <concreate+0x172>
    if(de.inum == 0)
    4136:	f7045783          	lhu	a5,-144(s0)
    413a:	d7e5                	beqz	a5,4122 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    413c:	f7244783          	lbu	a5,-142(s0)
    4140:	ff4791e3          	bne	a5,s4,4122 <concreate+0xe0>
    4144:	f7444783          	lbu	a5,-140(s0)
    4148:	ffe9                	bnez	a5,4122 <concreate+0xe0>
      i = de.name[1] - '0';
    414a:	f7344783          	lbu	a5,-141(s0)
    414e:	fd07879b          	addiw	a5,a5,-48
    4152:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4156:	00eb6f63          	bltu	s6,a4,4174 <concreate+0x132>
      if(fa[i]){
    415a:	fb040793          	addi	a5,s0,-80
    415e:	97ba                	add	a5,a5,a4
    4160:	fd07c783          	lbu	a5,-48(a5)
    4164:	eb85                	bnez	a5,4194 <concreate+0x152>
      fa[i] = 1;
    4166:	fb040793          	addi	a5,s0,-80
    416a:	973e                	add	a4,a4,a5
    416c:	fd770823          	sb	s7,-48(a4)
      n++;
    4170:	2a85                	addiw	s5,s5,1
    4172:	bf45                	j	4122 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4174:	f7240613          	addi	a2,s0,-142
    4178:	85ce                	mv	a1,s3
    417a:	00004517          	auipc	a0,0x4
    417e:	d5650513          	addi	a0,a0,-682 # 7ed0 <csem_up+0x1e9c>
    4182:	00002097          	auipc	ra,0x2
    4186:	c3a080e7          	jalr	-966(ra) # 5dbc <printf>
        exit(1);
    418a:	4505                	li	a0,1
    418c:	00002097          	auipc	ra,0x2
    4190:	85e080e7          	jalr	-1954(ra) # 59ea <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4194:	f7240613          	addi	a2,s0,-142
    4198:	85ce                	mv	a1,s3
    419a:	00004517          	auipc	a0,0x4
    419e:	d5650513          	addi	a0,a0,-682 # 7ef0 <csem_up+0x1ebc>
    41a2:	00002097          	auipc	ra,0x2
    41a6:	c1a080e7          	jalr	-998(ra) # 5dbc <printf>
        exit(1);
    41aa:	4505                	li	a0,1
    41ac:	00002097          	auipc	ra,0x2
    41b0:	83e080e7          	jalr	-1986(ra) # 59ea <exit>
  close(fd);
    41b4:	854a                	mv	a0,s2
    41b6:	00002097          	auipc	ra,0x2
    41ba:	85c080e7          	jalr	-1956(ra) # 5a12 <close>
  if(n != N){
    41be:	02800793          	li	a5,40
    41c2:	00fa9763          	bne	s5,a5,41d0 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    41c6:	4a8d                	li	s5,3
    41c8:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    41ca:	02800a13          	li	s4,40
    41ce:	a8c9                	j	42a0 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    41d0:	85ce                	mv	a1,s3
    41d2:	00004517          	auipc	a0,0x4
    41d6:	d4650513          	addi	a0,a0,-698 # 7f18 <csem_up+0x1ee4>
    41da:	00002097          	auipc	ra,0x2
    41de:	be2080e7          	jalr	-1054(ra) # 5dbc <printf>
    exit(1);
    41e2:	4505                	li	a0,1
    41e4:	00002097          	auipc	ra,0x2
    41e8:	806080e7          	jalr	-2042(ra) # 59ea <exit>
      printf("%s: fork failed\n", s);
    41ec:	85ce                	mv	a1,s3
    41ee:	00002517          	auipc	a0,0x2
    41f2:	14250513          	addi	a0,a0,322 # 6330 <csem_up+0x2fc>
    41f6:	00002097          	auipc	ra,0x2
    41fa:	bc6080e7          	jalr	-1082(ra) # 5dbc <printf>
      exit(1);
    41fe:	4505                	li	a0,1
    4200:	00001097          	auipc	ra,0x1
    4204:	7ea080e7          	jalr	2026(ra) # 59ea <exit>
      close(open(file, 0));
    4208:	4581                	li	a1,0
    420a:	fa840513          	addi	a0,s0,-88
    420e:	00002097          	auipc	ra,0x2
    4212:	81c080e7          	jalr	-2020(ra) # 5a2a <open>
    4216:	00001097          	auipc	ra,0x1
    421a:	7fc080e7          	jalr	2044(ra) # 5a12 <close>
      close(open(file, 0));
    421e:	4581                	li	a1,0
    4220:	fa840513          	addi	a0,s0,-88
    4224:	00002097          	auipc	ra,0x2
    4228:	806080e7          	jalr	-2042(ra) # 5a2a <open>
    422c:	00001097          	auipc	ra,0x1
    4230:	7e6080e7          	jalr	2022(ra) # 5a12 <close>
      close(open(file, 0));
    4234:	4581                	li	a1,0
    4236:	fa840513          	addi	a0,s0,-88
    423a:	00001097          	auipc	ra,0x1
    423e:	7f0080e7          	jalr	2032(ra) # 5a2a <open>
    4242:	00001097          	auipc	ra,0x1
    4246:	7d0080e7          	jalr	2000(ra) # 5a12 <close>
      close(open(file, 0));
    424a:	4581                	li	a1,0
    424c:	fa840513          	addi	a0,s0,-88
    4250:	00001097          	auipc	ra,0x1
    4254:	7da080e7          	jalr	2010(ra) # 5a2a <open>
    4258:	00001097          	auipc	ra,0x1
    425c:	7ba080e7          	jalr	1978(ra) # 5a12 <close>
      close(open(file, 0));
    4260:	4581                	li	a1,0
    4262:	fa840513          	addi	a0,s0,-88
    4266:	00001097          	auipc	ra,0x1
    426a:	7c4080e7          	jalr	1988(ra) # 5a2a <open>
    426e:	00001097          	auipc	ra,0x1
    4272:	7a4080e7          	jalr	1956(ra) # 5a12 <close>
      close(open(file, 0));
    4276:	4581                	li	a1,0
    4278:	fa840513          	addi	a0,s0,-88
    427c:	00001097          	auipc	ra,0x1
    4280:	7ae080e7          	jalr	1966(ra) # 5a2a <open>
    4284:	00001097          	auipc	ra,0x1
    4288:	78e080e7          	jalr	1934(ra) # 5a12 <close>
    if(pid == 0)
    428c:	08090363          	beqz	s2,4312 <concreate+0x2d0>
      wait(0);
    4290:	4501                	li	a0,0
    4292:	00001097          	auipc	ra,0x1
    4296:	760080e7          	jalr	1888(ra) # 59f2 <wait>
  for(i = 0; i < N; i++){
    429a:	2485                	addiw	s1,s1,1
    429c:	0f448563          	beq	s1,s4,4386 <concreate+0x344>
    file[1] = '0' + i;
    42a0:	0304879b          	addiw	a5,s1,48
    42a4:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    42a8:	00001097          	auipc	ra,0x1
    42ac:	73a080e7          	jalr	1850(ra) # 59e2 <fork>
    42b0:	892a                	mv	s2,a0
    if(pid < 0){
    42b2:	f2054de3          	bltz	a0,41ec <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    42b6:	0354e73b          	remw	a4,s1,s5
    42ba:	00a767b3          	or	a5,a4,a0
    42be:	2781                	sext.w	a5,a5
    42c0:	d7a1                	beqz	a5,4208 <concreate+0x1c6>
    42c2:	01671363          	bne	a4,s6,42c8 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    42c6:	f129                	bnez	a0,4208 <concreate+0x1c6>
      unlink(file);
    42c8:	fa840513          	addi	a0,s0,-88
    42cc:	00001097          	auipc	ra,0x1
    42d0:	76e080e7          	jalr	1902(ra) # 5a3a <unlink>
      unlink(file);
    42d4:	fa840513          	addi	a0,s0,-88
    42d8:	00001097          	auipc	ra,0x1
    42dc:	762080e7          	jalr	1890(ra) # 5a3a <unlink>
      unlink(file);
    42e0:	fa840513          	addi	a0,s0,-88
    42e4:	00001097          	auipc	ra,0x1
    42e8:	756080e7          	jalr	1878(ra) # 5a3a <unlink>
      unlink(file);
    42ec:	fa840513          	addi	a0,s0,-88
    42f0:	00001097          	auipc	ra,0x1
    42f4:	74a080e7          	jalr	1866(ra) # 5a3a <unlink>
      unlink(file);
    42f8:	fa840513          	addi	a0,s0,-88
    42fc:	00001097          	auipc	ra,0x1
    4300:	73e080e7          	jalr	1854(ra) # 5a3a <unlink>
      unlink(file);
    4304:	fa840513          	addi	a0,s0,-88
    4308:	00001097          	auipc	ra,0x1
    430c:	732080e7          	jalr	1842(ra) # 5a3a <unlink>
    4310:	bfb5                	j	428c <concreate+0x24a>
      exit(0);
    4312:	4501                	li	a0,0
    4314:	00001097          	auipc	ra,0x1
    4318:	6d6080e7          	jalr	1750(ra) # 59ea <exit>
      close(fd);
    431c:	00001097          	auipc	ra,0x1
    4320:	6f6080e7          	jalr	1782(ra) # 5a12 <close>
    if(pid == 0) {
    4324:	bb65                	j	40dc <concreate+0x9a>
      close(fd);
    4326:	00001097          	auipc	ra,0x1
    432a:	6ec080e7          	jalr	1772(ra) # 5a12 <close>
      wait(&xstatus);
    432e:	f6c40513          	addi	a0,s0,-148
    4332:	00001097          	auipc	ra,0x1
    4336:	6c0080e7          	jalr	1728(ra) # 59f2 <wait>
      if(xstatus != 0)
    433a:	f6c42483          	lw	s1,-148(s0)
    433e:	da0494e3          	bnez	s1,40e6 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4342:	2905                	addiw	s2,s2,1
    4344:	db4906e3          	beq	s2,s4,40f0 <concreate+0xae>
    file[1] = '0' + i;
    4348:	0309079b          	addiw	a5,s2,48
    434c:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4350:	fa840513          	addi	a0,s0,-88
    4354:	00001097          	auipc	ra,0x1
    4358:	6e6080e7          	jalr	1766(ra) # 5a3a <unlink>
    pid = fork();
    435c:	00001097          	auipc	ra,0x1
    4360:	686080e7          	jalr	1670(ra) # 59e2 <fork>
    if(pid && (i % 3) == 1){
    4364:	d20503e3          	beqz	a0,408a <concreate+0x48>
    4368:	036967bb          	remw	a5,s2,s6
    436c:	d15787e3          	beq	a5,s5,407a <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4370:	20200593          	li	a1,514
    4374:	fa840513          	addi	a0,s0,-88
    4378:	00001097          	auipc	ra,0x1
    437c:	6b2080e7          	jalr	1714(ra) # 5a2a <open>
      if(fd < 0){
    4380:	fa0553e3          	bgez	a0,4326 <concreate+0x2e4>
    4384:	b31d                	j	40aa <concreate+0x68>
}
    4386:	60ea                	ld	ra,152(sp)
    4388:	644a                	ld	s0,144(sp)
    438a:	64aa                	ld	s1,136(sp)
    438c:	690a                	ld	s2,128(sp)
    438e:	79e6                	ld	s3,120(sp)
    4390:	7a46                	ld	s4,112(sp)
    4392:	7aa6                	ld	s5,104(sp)
    4394:	7b06                	ld	s6,96(sp)
    4396:	6be6                	ld	s7,88(sp)
    4398:	610d                	addi	sp,sp,160
    439a:	8082                	ret

000000000000439c <linkunlink>:
{
    439c:	711d                	addi	sp,sp,-96
    439e:	ec86                	sd	ra,88(sp)
    43a0:	e8a2                	sd	s0,80(sp)
    43a2:	e4a6                	sd	s1,72(sp)
    43a4:	e0ca                	sd	s2,64(sp)
    43a6:	fc4e                	sd	s3,56(sp)
    43a8:	f852                	sd	s4,48(sp)
    43aa:	f456                	sd	s5,40(sp)
    43ac:	f05a                	sd	s6,32(sp)
    43ae:	ec5e                	sd	s7,24(sp)
    43b0:	e862                	sd	s8,16(sp)
    43b2:	e466                	sd	s9,8(sp)
    43b4:	1080                	addi	s0,sp,96
    43b6:	84aa                	mv	s1,a0
  unlink("x");
    43b8:	00002517          	auipc	a0,0x2
    43bc:	23050513          	addi	a0,a0,560 # 65e8 <csem_up+0x5b4>
    43c0:	00001097          	auipc	ra,0x1
    43c4:	67a080e7          	jalr	1658(ra) # 5a3a <unlink>
  pid = fork();
    43c8:	00001097          	auipc	ra,0x1
    43cc:	61a080e7          	jalr	1562(ra) # 59e2 <fork>
  if(pid < 0){
    43d0:	02054b63          	bltz	a0,4406 <linkunlink+0x6a>
    43d4:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    43d6:	4c85                	li	s9,1
    43d8:	e119                	bnez	a0,43de <linkunlink+0x42>
    43da:	06100c93          	li	s9,97
    43de:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    43e2:	41c659b7          	lui	s3,0x41c65
    43e6:	e6d9899b          	addiw	s3,s3,-403
    43ea:	690d                	lui	s2,0x3
    43ec:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    43f0:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    43f2:	4b05                	li	s6,1
      unlink("x");
    43f4:	00002a97          	auipc	s5,0x2
    43f8:	1f4a8a93          	addi	s5,s5,500 # 65e8 <csem_up+0x5b4>
      link("cat", "x");
    43fc:	00004b97          	auipc	s7,0x4
    4400:	b54b8b93          	addi	s7,s7,-1196 # 7f50 <csem_up+0x1f1c>
    4404:	a825                	j	443c <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    4406:	85a6                	mv	a1,s1
    4408:	00002517          	auipc	a0,0x2
    440c:	f2850513          	addi	a0,a0,-216 # 6330 <csem_up+0x2fc>
    4410:	00002097          	auipc	ra,0x2
    4414:	9ac080e7          	jalr	-1620(ra) # 5dbc <printf>
    exit(1);
    4418:	4505                	li	a0,1
    441a:	00001097          	auipc	ra,0x1
    441e:	5d0080e7          	jalr	1488(ra) # 59ea <exit>
      close(open("x", O_RDWR | O_CREATE));
    4422:	20200593          	li	a1,514
    4426:	8556                	mv	a0,s5
    4428:	00001097          	auipc	ra,0x1
    442c:	602080e7          	jalr	1538(ra) # 5a2a <open>
    4430:	00001097          	auipc	ra,0x1
    4434:	5e2080e7          	jalr	1506(ra) # 5a12 <close>
  for(i = 0; i < 100; i++){
    4438:	34fd                	addiw	s1,s1,-1
    443a:	c88d                	beqz	s1,446c <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    443c:	033c87bb          	mulw	a5,s9,s3
    4440:	012787bb          	addw	a5,a5,s2
    4444:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    4448:	0347f7bb          	remuw	a5,a5,s4
    444c:	dbf9                	beqz	a5,4422 <linkunlink+0x86>
    } else if((x % 3) == 1){
    444e:	01678863          	beq	a5,s6,445e <linkunlink+0xc2>
      unlink("x");
    4452:	8556                	mv	a0,s5
    4454:	00001097          	auipc	ra,0x1
    4458:	5e6080e7          	jalr	1510(ra) # 5a3a <unlink>
    445c:	bff1                	j	4438 <linkunlink+0x9c>
      link("cat", "x");
    445e:	85d6                	mv	a1,s5
    4460:	855e                	mv	a0,s7
    4462:	00001097          	auipc	ra,0x1
    4466:	5e8080e7          	jalr	1512(ra) # 5a4a <link>
    446a:	b7f9                	j	4438 <linkunlink+0x9c>
  if(pid)
    446c:	020c0463          	beqz	s8,4494 <linkunlink+0xf8>
    wait(0);
    4470:	4501                	li	a0,0
    4472:	00001097          	auipc	ra,0x1
    4476:	580080e7          	jalr	1408(ra) # 59f2 <wait>
}
    447a:	60e6                	ld	ra,88(sp)
    447c:	6446                	ld	s0,80(sp)
    447e:	64a6                	ld	s1,72(sp)
    4480:	6906                	ld	s2,64(sp)
    4482:	79e2                	ld	s3,56(sp)
    4484:	7a42                	ld	s4,48(sp)
    4486:	7aa2                	ld	s5,40(sp)
    4488:	7b02                	ld	s6,32(sp)
    448a:	6be2                	ld	s7,24(sp)
    448c:	6c42                	ld	s8,16(sp)
    448e:	6ca2                	ld	s9,8(sp)
    4490:	6125                	addi	sp,sp,96
    4492:	8082                	ret
    exit(0);
    4494:	4501                	li	a0,0
    4496:	00001097          	auipc	ra,0x1
    449a:	554080e7          	jalr	1364(ra) # 59ea <exit>

000000000000449e <bigdir>:
{
    449e:	715d                	addi	sp,sp,-80
    44a0:	e486                	sd	ra,72(sp)
    44a2:	e0a2                	sd	s0,64(sp)
    44a4:	fc26                	sd	s1,56(sp)
    44a6:	f84a                	sd	s2,48(sp)
    44a8:	f44e                	sd	s3,40(sp)
    44aa:	f052                	sd	s4,32(sp)
    44ac:	ec56                	sd	s5,24(sp)
    44ae:	e85a                	sd	s6,16(sp)
    44b0:	0880                	addi	s0,sp,80
    44b2:	89aa                	mv	s3,a0
  unlink("bd");
    44b4:	00004517          	auipc	a0,0x4
    44b8:	aa450513          	addi	a0,a0,-1372 # 7f58 <csem_up+0x1f24>
    44bc:	00001097          	auipc	ra,0x1
    44c0:	57e080e7          	jalr	1406(ra) # 5a3a <unlink>
  fd = open("bd", O_CREATE);
    44c4:	20000593          	li	a1,512
    44c8:	00004517          	auipc	a0,0x4
    44cc:	a9050513          	addi	a0,a0,-1392 # 7f58 <csem_up+0x1f24>
    44d0:	00001097          	auipc	ra,0x1
    44d4:	55a080e7          	jalr	1370(ra) # 5a2a <open>
  if(fd < 0){
    44d8:	0c054963          	bltz	a0,45aa <bigdir+0x10c>
  close(fd);
    44dc:	00001097          	auipc	ra,0x1
    44e0:	536080e7          	jalr	1334(ra) # 5a12 <close>
  for(i = 0; i < N; i++){
    44e4:	4901                	li	s2,0
    name[0] = 'x';
    44e6:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    44ea:	00004a17          	auipc	s4,0x4
    44ee:	a6ea0a13          	addi	s4,s4,-1426 # 7f58 <csem_up+0x1f24>
  for(i = 0; i < N; i++){
    44f2:	1f400b13          	li	s6,500
    name[0] = 'x';
    44f6:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    44fa:	41f9579b          	sraiw	a5,s2,0x1f
    44fe:	01a7d71b          	srliw	a4,a5,0x1a
    4502:	012707bb          	addw	a5,a4,s2
    4506:	4067d69b          	sraiw	a3,a5,0x6
    450a:	0306869b          	addiw	a3,a3,48
    450e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    4512:	03f7f793          	andi	a5,a5,63
    4516:	9f99                	subw	a5,a5,a4
    4518:	0307879b          	addiw	a5,a5,48
    451c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    4520:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    4524:	fb040593          	addi	a1,s0,-80
    4528:	8552                	mv	a0,s4
    452a:	00001097          	auipc	ra,0x1
    452e:	520080e7          	jalr	1312(ra) # 5a4a <link>
    4532:	84aa                	mv	s1,a0
    4534:	e949                	bnez	a0,45c6 <bigdir+0x128>
  for(i = 0; i < N; i++){
    4536:	2905                	addiw	s2,s2,1
    4538:	fb691fe3          	bne	s2,s6,44f6 <bigdir+0x58>
  unlink("bd");
    453c:	00004517          	auipc	a0,0x4
    4540:	a1c50513          	addi	a0,a0,-1508 # 7f58 <csem_up+0x1f24>
    4544:	00001097          	auipc	ra,0x1
    4548:	4f6080e7          	jalr	1270(ra) # 5a3a <unlink>
    name[0] = 'x';
    454c:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    4550:	1f400a13          	li	s4,500
    name[0] = 'x';
    4554:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    4558:	41f4d79b          	sraiw	a5,s1,0x1f
    455c:	01a7d71b          	srliw	a4,a5,0x1a
    4560:	009707bb          	addw	a5,a4,s1
    4564:	4067d69b          	sraiw	a3,a5,0x6
    4568:	0306869b          	addiw	a3,a3,48
    456c:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    4570:	03f7f793          	andi	a5,a5,63
    4574:	9f99                	subw	a5,a5,a4
    4576:	0307879b          	addiw	a5,a5,48
    457a:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    457e:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    4582:	fb040513          	addi	a0,s0,-80
    4586:	00001097          	auipc	ra,0x1
    458a:	4b4080e7          	jalr	1204(ra) # 5a3a <unlink>
    458e:	ed21                	bnez	a0,45e6 <bigdir+0x148>
  for(i = 0; i < N; i++){
    4590:	2485                	addiw	s1,s1,1
    4592:	fd4491e3          	bne	s1,s4,4554 <bigdir+0xb6>
}
    4596:	60a6                	ld	ra,72(sp)
    4598:	6406                	ld	s0,64(sp)
    459a:	74e2                	ld	s1,56(sp)
    459c:	7942                	ld	s2,48(sp)
    459e:	79a2                	ld	s3,40(sp)
    45a0:	7a02                	ld	s4,32(sp)
    45a2:	6ae2                	ld	s5,24(sp)
    45a4:	6b42                	ld	s6,16(sp)
    45a6:	6161                	addi	sp,sp,80
    45a8:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    45aa:	85ce                	mv	a1,s3
    45ac:	00004517          	auipc	a0,0x4
    45b0:	9b450513          	addi	a0,a0,-1612 # 7f60 <csem_up+0x1f2c>
    45b4:	00002097          	auipc	ra,0x2
    45b8:	808080e7          	jalr	-2040(ra) # 5dbc <printf>
    exit(1);
    45bc:	4505                	li	a0,1
    45be:	00001097          	auipc	ra,0x1
    45c2:	42c080e7          	jalr	1068(ra) # 59ea <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    45c6:	fb040613          	addi	a2,s0,-80
    45ca:	85ce                	mv	a1,s3
    45cc:	00004517          	auipc	a0,0x4
    45d0:	9b450513          	addi	a0,a0,-1612 # 7f80 <csem_up+0x1f4c>
    45d4:	00001097          	auipc	ra,0x1
    45d8:	7e8080e7          	jalr	2024(ra) # 5dbc <printf>
      exit(1);
    45dc:	4505                	li	a0,1
    45de:	00001097          	auipc	ra,0x1
    45e2:	40c080e7          	jalr	1036(ra) # 59ea <exit>
      printf("%s: bigdir unlink failed", s);
    45e6:	85ce                	mv	a1,s3
    45e8:	00004517          	auipc	a0,0x4
    45ec:	9b850513          	addi	a0,a0,-1608 # 7fa0 <csem_up+0x1f6c>
    45f0:	00001097          	auipc	ra,0x1
    45f4:	7cc080e7          	jalr	1996(ra) # 5dbc <printf>
      exit(1);
    45f8:	4505                	li	a0,1
    45fa:	00001097          	auipc	ra,0x1
    45fe:	3f0080e7          	jalr	1008(ra) # 59ea <exit>

0000000000004602 <manywrites>:
{
    4602:	711d                	addi	sp,sp,-96
    4604:	ec86                	sd	ra,88(sp)
    4606:	e8a2                	sd	s0,80(sp)
    4608:	e4a6                	sd	s1,72(sp)
    460a:	e0ca                	sd	s2,64(sp)
    460c:	fc4e                	sd	s3,56(sp)
    460e:	f852                	sd	s4,48(sp)
    4610:	f456                	sd	s5,40(sp)
    4612:	f05a                	sd	s6,32(sp)
    4614:	ec5e                	sd	s7,24(sp)
    4616:	1080                	addi	s0,sp,96
    4618:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    461a:	4981                	li	s3,0
    461c:	4911                	li	s2,4
    int pid = fork();
    461e:	00001097          	auipc	ra,0x1
    4622:	3c4080e7          	jalr	964(ra) # 59e2 <fork>
    4626:	84aa                	mv	s1,a0
    if(pid < 0){
    4628:	02054963          	bltz	a0,465a <manywrites+0x58>
    if(pid == 0){
    462c:	c521                	beqz	a0,4674 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    462e:	2985                	addiw	s3,s3,1
    4630:	ff2997e3          	bne	s3,s2,461e <manywrites+0x1c>
    4634:	4491                	li	s1,4
    int st = 0;
    4636:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    463a:	fa840513          	addi	a0,s0,-88
    463e:	00001097          	auipc	ra,0x1
    4642:	3b4080e7          	jalr	948(ra) # 59f2 <wait>
    if(st != 0)
    4646:	fa842503          	lw	a0,-88(s0)
    464a:	ed6d                	bnez	a0,4744 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    464c:	34fd                	addiw	s1,s1,-1
    464e:	f4e5                	bnez	s1,4636 <manywrites+0x34>
  exit(0);
    4650:	4501                	li	a0,0
    4652:	00001097          	auipc	ra,0x1
    4656:	398080e7          	jalr	920(ra) # 59ea <exit>
      printf("fork failed\n");
    465a:	00002517          	auipc	a0,0x2
    465e:	79e50513          	addi	a0,a0,1950 # 6df8 <csem_up+0xdc4>
    4662:	00001097          	auipc	ra,0x1
    4666:	75a080e7          	jalr	1882(ra) # 5dbc <printf>
      exit(1);
    466a:	4505                	li	a0,1
    466c:	00001097          	auipc	ra,0x1
    4670:	37e080e7          	jalr	894(ra) # 59ea <exit>
      name[0] = 'b';
    4674:	06200793          	li	a5,98
    4678:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    467c:	0619879b          	addiw	a5,s3,97
    4680:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    4684:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    4688:	fa840513          	addi	a0,s0,-88
    468c:	00001097          	auipc	ra,0x1
    4690:	3ae080e7          	jalr	942(ra) # 5a3a <unlink>
    4694:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    4696:	00008b17          	auipc	s6,0x8
    469a:	942b0b13          	addi	s6,s6,-1726 # bfd8 <buf>
        for(int i = 0; i < ci+1; i++){
    469e:	8a26                	mv	s4,s1
    46a0:	0209ce63          	bltz	s3,46dc <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    46a4:	20200593          	li	a1,514
    46a8:	fa840513          	addi	a0,s0,-88
    46ac:	00001097          	auipc	ra,0x1
    46b0:	37e080e7          	jalr	894(ra) # 5a2a <open>
    46b4:	892a                	mv	s2,a0
          if(fd < 0){
    46b6:	04054763          	bltz	a0,4704 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    46ba:	660d                	lui	a2,0x3
    46bc:	85da                	mv	a1,s6
    46be:	00001097          	auipc	ra,0x1
    46c2:	34c080e7          	jalr	844(ra) # 5a0a <write>
          if(cc != sz){
    46c6:	678d                	lui	a5,0x3
    46c8:	04f51e63          	bne	a0,a5,4724 <manywrites+0x122>
          close(fd);
    46cc:	854a                	mv	a0,s2
    46ce:	00001097          	auipc	ra,0x1
    46d2:	344080e7          	jalr	836(ra) # 5a12 <close>
        for(int i = 0; i < ci+1; i++){
    46d6:	2a05                	addiw	s4,s4,1
    46d8:	fd49d6e3          	bge	s3,s4,46a4 <manywrites+0xa2>
        unlink(name);
    46dc:	fa840513          	addi	a0,s0,-88
    46e0:	00001097          	auipc	ra,0x1
    46e4:	35a080e7          	jalr	858(ra) # 5a3a <unlink>
      for(int iters = 0; iters < howmany; iters++){
    46e8:	3bfd                	addiw	s7,s7,-1
    46ea:	fa0b9ae3          	bnez	s7,469e <manywrites+0x9c>
      unlink(name);
    46ee:	fa840513          	addi	a0,s0,-88
    46f2:	00001097          	auipc	ra,0x1
    46f6:	348080e7          	jalr	840(ra) # 5a3a <unlink>
      exit(0);
    46fa:	4501                	li	a0,0
    46fc:	00001097          	auipc	ra,0x1
    4700:	2ee080e7          	jalr	750(ra) # 59ea <exit>
            printf("%s: cannot create %s\n", s, name);
    4704:	fa840613          	addi	a2,s0,-88
    4708:	85d6                	mv	a1,s5
    470a:	00004517          	auipc	a0,0x4
    470e:	8b650513          	addi	a0,a0,-1866 # 7fc0 <csem_up+0x1f8c>
    4712:	00001097          	auipc	ra,0x1
    4716:	6aa080e7          	jalr	1706(ra) # 5dbc <printf>
            exit(1);
    471a:	4505                	li	a0,1
    471c:	00001097          	auipc	ra,0x1
    4720:	2ce080e7          	jalr	718(ra) # 59ea <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    4724:	86aa                	mv	a3,a0
    4726:	660d                	lui	a2,0x3
    4728:	85d6                	mv	a1,s5
    472a:	00002517          	auipc	a0,0x2
    472e:	f1e50513          	addi	a0,a0,-226 # 6648 <csem_up+0x614>
    4732:	00001097          	auipc	ra,0x1
    4736:	68a080e7          	jalr	1674(ra) # 5dbc <printf>
            exit(1);
    473a:	4505                	li	a0,1
    473c:	00001097          	auipc	ra,0x1
    4740:	2ae080e7          	jalr	686(ra) # 59ea <exit>
      exit(st);
    4744:	00001097          	auipc	ra,0x1
    4748:	2a6080e7          	jalr	678(ra) # 59ea <exit>

000000000000474c <iref>:
{
    474c:	7139                	addi	sp,sp,-64
    474e:	fc06                	sd	ra,56(sp)
    4750:	f822                	sd	s0,48(sp)
    4752:	f426                	sd	s1,40(sp)
    4754:	f04a                	sd	s2,32(sp)
    4756:	ec4e                	sd	s3,24(sp)
    4758:	e852                	sd	s4,16(sp)
    475a:	e456                	sd	s5,8(sp)
    475c:	e05a                	sd	s6,0(sp)
    475e:	0080                	addi	s0,sp,64
    4760:	8b2a                	mv	s6,a0
    4762:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4766:	00004a17          	auipc	s4,0x4
    476a:	872a0a13          	addi	s4,s4,-1934 # 7fd8 <csem_up+0x1fa4>
    mkdir("");
    476e:	00003497          	auipc	s1,0x3
    4772:	dca48493          	addi	s1,s1,-566 # 7538 <csem_up+0x1504>
    link("README", "");
    4776:	00002a97          	auipc	s5,0x2
    477a:	faaa8a93          	addi	s5,s5,-86 # 6720 <csem_up+0x6ec>
    fd = open("xx", O_CREATE);
    477e:	00003997          	auipc	s3,0x3
    4782:	1a298993          	addi	s3,s3,418 # 7920 <csem_up+0x18ec>
    4786:	a891                	j	47da <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    4788:	85da                	mv	a1,s6
    478a:	00004517          	auipc	a0,0x4
    478e:	85650513          	addi	a0,a0,-1962 # 7fe0 <csem_up+0x1fac>
    4792:	00001097          	auipc	ra,0x1
    4796:	62a080e7          	jalr	1578(ra) # 5dbc <printf>
      exit(1);
    479a:	4505                	li	a0,1
    479c:	00001097          	auipc	ra,0x1
    47a0:	24e080e7          	jalr	590(ra) # 59ea <exit>
      printf("%s: chdir irefd failed\n", s);
    47a4:	85da                	mv	a1,s6
    47a6:	00004517          	auipc	a0,0x4
    47aa:	85250513          	addi	a0,a0,-1966 # 7ff8 <csem_up+0x1fc4>
    47ae:	00001097          	auipc	ra,0x1
    47b2:	60e080e7          	jalr	1550(ra) # 5dbc <printf>
      exit(1);
    47b6:	4505                	li	a0,1
    47b8:	00001097          	auipc	ra,0x1
    47bc:	232080e7          	jalr	562(ra) # 59ea <exit>
      close(fd);
    47c0:	00001097          	auipc	ra,0x1
    47c4:	252080e7          	jalr	594(ra) # 5a12 <close>
    47c8:	a889                	j	481a <iref+0xce>
    unlink("xx");
    47ca:	854e                	mv	a0,s3
    47cc:	00001097          	auipc	ra,0x1
    47d0:	26e080e7          	jalr	622(ra) # 5a3a <unlink>
  for(i = 0; i < NINODE + 1; i++){
    47d4:	397d                	addiw	s2,s2,-1
    47d6:	06090063          	beqz	s2,4836 <iref+0xea>
    if(mkdir("irefd") != 0){
    47da:	8552                	mv	a0,s4
    47dc:	00001097          	auipc	ra,0x1
    47e0:	276080e7          	jalr	630(ra) # 5a52 <mkdir>
    47e4:	f155                	bnez	a0,4788 <iref+0x3c>
    if(chdir("irefd") != 0){
    47e6:	8552                	mv	a0,s4
    47e8:	00001097          	auipc	ra,0x1
    47ec:	272080e7          	jalr	626(ra) # 5a5a <chdir>
    47f0:	f955                	bnez	a0,47a4 <iref+0x58>
    mkdir("");
    47f2:	8526                	mv	a0,s1
    47f4:	00001097          	auipc	ra,0x1
    47f8:	25e080e7          	jalr	606(ra) # 5a52 <mkdir>
    link("README", "");
    47fc:	85a6                	mv	a1,s1
    47fe:	8556                	mv	a0,s5
    4800:	00001097          	auipc	ra,0x1
    4804:	24a080e7          	jalr	586(ra) # 5a4a <link>
    fd = open("", O_CREATE);
    4808:	20000593          	li	a1,512
    480c:	8526                	mv	a0,s1
    480e:	00001097          	auipc	ra,0x1
    4812:	21c080e7          	jalr	540(ra) # 5a2a <open>
    if(fd >= 0)
    4816:	fa0555e3          	bgez	a0,47c0 <iref+0x74>
    fd = open("xx", O_CREATE);
    481a:	20000593          	li	a1,512
    481e:	854e                	mv	a0,s3
    4820:	00001097          	auipc	ra,0x1
    4824:	20a080e7          	jalr	522(ra) # 5a2a <open>
    if(fd >= 0)
    4828:	fa0541e3          	bltz	a0,47ca <iref+0x7e>
      close(fd);
    482c:	00001097          	auipc	ra,0x1
    4830:	1e6080e7          	jalr	486(ra) # 5a12 <close>
    4834:	bf59                	j	47ca <iref+0x7e>
    4836:	03300493          	li	s1,51
    chdir("..");
    483a:	00003997          	auipc	s3,0x3
    483e:	a1e98993          	addi	s3,s3,-1506 # 7258 <csem_up+0x1224>
    unlink("irefd");
    4842:	00003917          	auipc	s2,0x3
    4846:	79690913          	addi	s2,s2,1942 # 7fd8 <csem_up+0x1fa4>
    chdir("..");
    484a:	854e                	mv	a0,s3
    484c:	00001097          	auipc	ra,0x1
    4850:	20e080e7          	jalr	526(ra) # 5a5a <chdir>
    unlink("irefd");
    4854:	854a                	mv	a0,s2
    4856:	00001097          	auipc	ra,0x1
    485a:	1e4080e7          	jalr	484(ra) # 5a3a <unlink>
  for(i = 0; i < NINODE + 1; i++){
    485e:	34fd                	addiw	s1,s1,-1
    4860:	f4ed                	bnez	s1,484a <iref+0xfe>
  chdir("/");
    4862:	00003517          	auipc	a0,0x3
    4866:	99e50513          	addi	a0,a0,-1634 # 7200 <csem_up+0x11cc>
    486a:	00001097          	auipc	ra,0x1
    486e:	1f0080e7          	jalr	496(ra) # 5a5a <chdir>
}
    4872:	70e2                	ld	ra,56(sp)
    4874:	7442                	ld	s0,48(sp)
    4876:	74a2                	ld	s1,40(sp)
    4878:	7902                	ld	s2,32(sp)
    487a:	69e2                	ld	s3,24(sp)
    487c:	6a42                	ld	s4,16(sp)
    487e:	6aa2                	ld	s5,8(sp)
    4880:	6b02                	ld	s6,0(sp)
    4882:	6121                	addi	sp,sp,64
    4884:	8082                	ret

0000000000004886 <sbrkbasic>:
{
    4886:	7139                	addi	sp,sp,-64
    4888:	fc06                	sd	ra,56(sp)
    488a:	f822                	sd	s0,48(sp)
    488c:	f426                	sd	s1,40(sp)
    488e:	f04a                	sd	s2,32(sp)
    4890:	ec4e                	sd	s3,24(sp)
    4892:	e852                	sd	s4,16(sp)
    4894:	0080                	addi	s0,sp,64
    4896:	8a2a                	mv	s4,a0
  pid = fork();
    4898:	00001097          	auipc	ra,0x1
    489c:	14a080e7          	jalr	330(ra) # 59e2 <fork>
  if(pid < 0){
    48a0:	02054c63          	bltz	a0,48d8 <sbrkbasic+0x52>
  if(pid == 0){
    48a4:	ed21                	bnez	a0,48fc <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    48a6:	40000537          	lui	a0,0x40000
    48aa:	00001097          	auipc	ra,0x1
    48ae:	1c8080e7          	jalr	456(ra) # 5a72 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    48b2:	57fd                	li	a5,-1
    48b4:	02f50f63          	beq	a0,a5,48f2 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    48b8:	400007b7          	lui	a5,0x40000
    48bc:	97aa                	add	a5,a5,a0
      *b = 99;
    48be:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    48c2:	6705                	lui	a4,0x1
      *b = 99;
    48c4:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1018>
    for(b = a; b < a+TOOMUCH; b += 4096){
    48c8:	953a                	add	a0,a0,a4
    48ca:	fef51de3          	bne	a0,a5,48c4 <sbrkbasic+0x3e>
    exit(1);
    48ce:	4505                	li	a0,1
    48d0:	00001097          	auipc	ra,0x1
    48d4:	11a080e7          	jalr	282(ra) # 59ea <exit>
    printf("fork failed in sbrkbasic\n");
    48d8:	00003517          	auipc	a0,0x3
    48dc:	73850513          	addi	a0,a0,1848 # 8010 <csem_up+0x1fdc>
    48e0:	00001097          	auipc	ra,0x1
    48e4:	4dc080e7          	jalr	1244(ra) # 5dbc <printf>
    exit(1);
    48e8:	4505                	li	a0,1
    48ea:	00001097          	auipc	ra,0x1
    48ee:	100080e7          	jalr	256(ra) # 59ea <exit>
      exit(0);
    48f2:	4501                	li	a0,0
    48f4:	00001097          	auipc	ra,0x1
    48f8:	0f6080e7          	jalr	246(ra) # 59ea <exit>
  wait(&xstatus);
    48fc:	fcc40513          	addi	a0,s0,-52
    4900:	00001097          	auipc	ra,0x1
    4904:	0f2080e7          	jalr	242(ra) # 59f2 <wait>
  if(xstatus == 1){
    4908:	fcc42703          	lw	a4,-52(s0)
    490c:	4785                	li	a5,1
    490e:	00f70d63          	beq	a4,a5,4928 <sbrkbasic+0xa2>
  a = sbrk(0);
    4912:	4501                	li	a0,0
    4914:	00001097          	auipc	ra,0x1
    4918:	15e080e7          	jalr	350(ra) # 5a72 <sbrk>
    491c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    491e:	4901                	li	s2,0
    4920:	6985                	lui	s3,0x1
    4922:	38898993          	addi	s3,s3,904 # 1388 <unlinkread+0x188>
    4926:	a005                	j	4946 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    4928:	85d2                	mv	a1,s4
    492a:	00003517          	auipc	a0,0x3
    492e:	70650513          	addi	a0,a0,1798 # 8030 <csem_up+0x1ffc>
    4932:	00001097          	auipc	ra,0x1
    4936:	48a080e7          	jalr	1162(ra) # 5dbc <printf>
    exit(1);
    493a:	4505                	li	a0,1
    493c:	00001097          	auipc	ra,0x1
    4940:	0ae080e7          	jalr	174(ra) # 59ea <exit>
    a = b + 1;
    4944:	84be                	mv	s1,a5
    b = sbrk(1);
    4946:	4505                	li	a0,1
    4948:	00001097          	auipc	ra,0x1
    494c:	12a080e7          	jalr	298(ra) # 5a72 <sbrk>
    if(b != a){
    4950:	04951c63          	bne	a0,s1,49a8 <sbrkbasic+0x122>
    *b = 1;
    4954:	4785                	li	a5,1
    4956:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    495a:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    495e:	2905                	addiw	s2,s2,1
    4960:	ff3912e3          	bne	s2,s3,4944 <sbrkbasic+0xbe>
  pid = fork();
    4964:	00001097          	auipc	ra,0x1
    4968:	07e080e7          	jalr	126(ra) # 59e2 <fork>
    496c:	892a                	mv	s2,a0
  if(pid < 0){
    496e:	04054d63          	bltz	a0,49c8 <sbrkbasic+0x142>
  c = sbrk(1);
    4972:	4505                	li	a0,1
    4974:	00001097          	auipc	ra,0x1
    4978:	0fe080e7          	jalr	254(ra) # 5a72 <sbrk>
  c = sbrk(1);
    497c:	4505                	li	a0,1
    497e:	00001097          	auipc	ra,0x1
    4982:	0f4080e7          	jalr	244(ra) # 5a72 <sbrk>
  if(c != a + 1){
    4986:	0489                	addi	s1,s1,2
    4988:	04a48e63          	beq	s1,a0,49e4 <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    498c:	85d2                	mv	a1,s4
    498e:	00003517          	auipc	a0,0x3
    4992:	70250513          	addi	a0,a0,1794 # 8090 <csem_up+0x205c>
    4996:	00001097          	auipc	ra,0x1
    499a:	426080e7          	jalr	1062(ra) # 5dbc <printf>
    exit(1);
    499e:	4505                	li	a0,1
    49a0:	00001097          	auipc	ra,0x1
    49a4:	04a080e7          	jalr	74(ra) # 59ea <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    49a8:	86aa                	mv	a3,a0
    49aa:	8626                	mv	a2,s1
    49ac:	85ca                	mv	a1,s2
    49ae:	00003517          	auipc	a0,0x3
    49b2:	6a250513          	addi	a0,a0,1698 # 8050 <csem_up+0x201c>
    49b6:	00001097          	auipc	ra,0x1
    49ba:	406080e7          	jalr	1030(ra) # 5dbc <printf>
      exit(1);
    49be:	4505                	li	a0,1
    49c0:	00001097          	auipc	ra,0x1
    49c4:	02a080e7          	jalr	42(ra) # 59ea <exit>
    printf("%s: sbrk test fork failed\n", s);
    49c8:	85d2                	mv	a1,s4
    49ca:	00003517          	auipc	a0,0x3
    49ce:	6a650513          	addi	a0,a0,1702 # 8070 <csem_up+0x203c>
    49d2:	00001097          	auipc	ra,0x1
    49d6:	3ea080e7          	jalr	1002(ra) # 5dbc <printf>
    exit(1);
    49da:	4505                	li	a0,1
    49dc:	00001097          	auipc	ra,0x1
    49e0:	00e080e7          	jalr	14(ra) # 59ea <exit>
  if(pid == 0)
    49e4:	00091763          	bnez	s2,49f2 <sbrkbasic+0x16c>
    exit(0);
    49e8:	4501                	li	a0,0
    49ea:	00001097          	auipc	ra,0x1
    49ee:	000080e7          	jalr	ra # 59ea <exit>
  wait(&xstatus);
    49f2:	fcc40513          	addi	a0,s0,-52
    49f6:	00001097          	auipc	ra,0x1
    49fa:	ffc080e7          	jalr	-4(ra) # 59f2 <wait>
  exit(xstatus);
    49fe:	fcc42503          	lw	a0,-52(s0)
    4a02:	00001097          	auipc	ra,0x1
    4a06:	fe8080e7          	jalr	-24(ra) # 59ea <exit>

0000000000004a0a <sbrkmuch>:
{
    4a0a:	7179                	addi	sp,sp,-48
    4a0c:	f406                	sd	ra,40(sp)
    4a0e:	f022                	sd	s0,32(sp)
    4a10:	ec26                	sd	s1,24(sp)
    4a12:	e84a                	sd	s2,16(sp)
    4a14:	e44e                	sd	s3,8(sp)
    4a16:	e052                	sd	s4,0(sp)
    4a18:	1800                	addi	s0,sp,48
    4a1a:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    4a1c:	4501                	li	a0,0
    4a1e:	00001097          	auipc	ra,0x1
    4a22:	054080e7          	jalr	84(ra) # 5a72 <sbrk>
    4a26:	892a                	mv	s2,a0
  a = sbrk(0);
    4a28:	4501                	li	a0,0
    4a2a:	00001097          	auipc	ra,0x1
    4a2e:	048080e7          	jalr	72(ra) # 5a72 <sbrk>
    4a32:	84aa                	mv	s1,a0
  p = sbrk(amt);
    4a34:	06400537          	lui	a0,0x6400
    4a38:	9d05                	subw	a0,a0,s1
    4a3a:	00001097          	auipc	ra,0x1
    4a3e:	038080e7          	jalr	56(ra) # 5a72 <sbrk>
  if (p != a) {
    4a42:	0ca49863          	bne	s1,a0,4b12 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    4a46:	4501                	li	a0,0
    4a48:	00001097          	auipc	ra,0x1
    4a4c:	02a080e7          	jalr	42(ra) # 5a72 <sbrk>
    4a50:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    4a52:	00a4f963          	bgeu	s1,a0,4a64 <sbrkmuch+0x5a>
    *pp = 1;
    4a56:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    4a58:	6705                	lui	a4,0x1
    *pp = 1;
    4a5a:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    4a5e:	94ba                	add	s1,s1,a4
    4a60:	fef4ede3          	bltu	s1,a5,4a5a <sbrkmuch+0x50>
  *lastaddr = 99;
    4a64:	064007b7          	lui	a5,0x6400
    4a68:	06300713          	li	a4,99
    4a6c:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1017>
  a = sbrk(0);
    4a70:	4501                	li	a0,0
    4a72:	00001097          	auipc	ra,0x1
    4a76:	000080e7          	jalr	ra # 5a72 <sbrk>
    4a7a:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    4a7c:	757d                	lui	a0,0xfffff
    4a7e:	00001097          	auipc	ra,0x1
    4a82:	ff4080e7          	jalr	-12(ra) # 5a72 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    4a86:	57fd                	li	a5,-1
    4a88:	0af50363          	beq	a0,a5,4b2e <sbrkmuch+0x124>
  c = sbrk(0);
    4a8c:	4501                	li	a0,0
    4a8e:	00001097          	auipc	ra,0x1
    4a92:	fe4080e7          	jalr	-28(ra) # 5a72 <sbrk>
  if(c != a - PGSIZE){
    4a96:	77fd                	lui	a5,0xfffff
    4a98:	97a6                	add	a5,a5,s1
    4a9a:	0af51863          	bne	a0,a5,4b4a <sbrkmuch+0x140>
  a = sbrk(0);
    4a9e:	4501                	li	a0,0
    4aa0:	00001097          	auipc	ra,0x1
    4aa4:	fd2080e7          	jalr	-46(ra) # 5a72 <sbrk>
    4aa8:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    4aaa:	6505                	lui	a0,0x1
    4aac:	00001097          	auipc	ra,0x1
    4ab0:	fc6080e7          	jalr	-58(ra) # 5a72 <sbrk>
    4ab4:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    4ab6:	0aa49a63          	bne	s1,a0,4b6a <sbrkmuch+0x160>
    4aba:	4501                	li	a0,0
    4abc:	00001097          	auipc	ra,0x1
    4ac0:	fb6080e7          	jalr	-74(ra) # 5a72 <sbrk>
    4ac4:	6785                	lui	a5,0x1
    4ac6:	97a6                	add	a5,a5,s1
    4ac8:	0af51163          	bne	a0,a5,4b6a <sbrkmuch+0x160>
  if(*lastaddr == 99){
    4acc:	064007b7          	lui	a5,0x6400
    4ad0:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1017>
    4ad4:	06300793          	li	a5,99
    4ad8:	0af70963          	beq	a4,a5,4b8a <sbrkmuch+0x180>
  a = sbrk(0);
    4adc:	4501                	li	a0,0
    4ade:	00001097          	auipc	ra,0x1
    4ae2:	f94080e7          	jalr	-108(ra) # 5a72 <sbrk>
    4ae6:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    4ae8:	4501                	li	a0,0
    4aea:	00001097          	auipc	ra,0x1
    4aee:	f88080e7          	jalr	-120(ra) # 5a72 <sbrk>
    4af2:	40a9053b          	subw	a0,s2,a0
    4af6:	00001097          	auipc	ra,0x1
    4afa:	f7c080e7          	jalr	-132(ra) # 5a72 <sbrk>
  if(c != a){
    4afe:	0aa49463          	bne	s1,a0,4ba6 <sbrkmuch+0x19c>
}
    4b02:	70a2                	ld	ra,40(sp)
    4b04:	7402                	ld	s0,32(sp)
    4b06:	64e2                	ld	s1,24(sp)
    4b08:	6942                	ld	s2,16(sp)
    4b0a:	69a2                	ld	s3,8(sp)
    4b0c:	6a02                	ld	s4,0(sp)
    4b0e:	6145                	addi	sp,sp,48
    4b10:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    4b12:	85ce                	mv	a1,s3
    4b14:	00003517          	auipc	a0,0x3
    4b18:	59c50513          	addi	a0,a0,1436 # 80b0 <csem_up+0x207c>
    4b1c:	00001097          	auipc	ra,0x1
    4b20:	2a0080e7          	jalr	672(ra) # 5dbc <printf>
    exit(1);
    4b24:	4505                	li	a0,1
    4b26:	00001097          	auipc	ra,0x1
    4b2a:	ec4080e7          	jalr	-316(ra) # 59ea <exit>
    printf("%s: sbrk could not deallocate\n", s);
    4b2e:	85ce                	mv	a1,s3
    4b30:	00003517          	auipc	a0,0x3
    4b34:	5c850513          	addi	a0,a0,1480 # 80f8 <csem_up+0x20c4>
    4b38:	00001097          	auipc	ra,0x1
    4b3c:	284080e7          	jalr	644(ra) # 5dbc <printf>
    exit(1);
    4b40:	4505                	li	a0,1
    4b42:	00001097          	auipc	ra,0x1
    4b46:	ea8080e7          	jalr	-344(ra) # 59ea <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    4b4a:	86aa                	mv	a3,a0
    4b4c:	8626                	mv	a2,s1
    4b4e:	85ce                	mv	a1,s3
    4b50:	00003517          	auipc	a0,0x3
    4b54:	5c850513          	addi	a0,a0,1480 # 8118 <csem_up+0x20e4>
    4b58:	00001097          	auipc	ra,0x1
    4b5c:	264080e7          	jalr	612(ra) # 5dbc <printf>
    exit(1);
    4b60:	4505                	li	a0,1
    4b62:	00001097          	auipc	ra,0x1
    4b66:	e88080e7          	jalr	-376(ra) # 59ea <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    4b6a:	86d2                	mv	a3,s4
    4b6c:	8626                	mv	a2,s1
    4b6e:	85ce                	mv	a1,s3
    4b70:	00003517          	auipc	a0,0x3
    4b74:	5e850513          	addi	a0,a0,1512 # 8158 <csem_up+0x2124>
    4b78:	00001097          	auipc	ra,0x1
    4b7c:	244080e7          	jalr	580(ra) # 5dbc <printf>
    exit(1);
    4b80:	4505                	li	a0,1
    4b82:	00001097          	auipc	ra,0x1
    4b86:	e68080e7          	jalr	-408(ra) # 59ea <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    4b8a:	85ce                	mv	a1,s3
    4b8c:	00003517          	auipc	a0,0x3
    4b90:	5fc50513          	addi	a0,a0,1532 # 8188 <csem_up+0x2154>
    4b94:	00001097          	auipc	ra,0x1
    4b98:	228080e7          	jalr	552(ra) # 5dbc <printf>
    exit(1);
    4b9c:	4505                	li	a0,1
    4b9e:	00001097          	auipc	ra,0x1
    4ba2:	e4c080e7          	jalr	-436(ra) # 59ea <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    4ba6:	86aa                	mv	a3,a0
    4ba8:	8626                	mv	a2,s1
    4baa:	85ce                	mv	a1,s3
    4bac:	00003517          	auipc	a0,0x3
    4bb0:	61450513          	addi	a0,a0,1556 # 81c0 <csem_up+0x218c>
    4bb4:	00001097          	auipc	ra,0x1
    4bb8:	208080e7          	jalr	520(ra) # 5dbc <printf>
    exit(1);
    4bbc:	4505                	li	a0,1
    4bbe:	00001097          	auipc	ra,0x1
    4bc2:	e2c080e7          	jalr	-468(ra) # 59ea <exit>

0000000000004bc6 <kernmem>:
{
    4bc6:	715d                	addi	sp,sp,-80
    4bc8:	e486                	sd	ra,72(sp)
    4bca:	e0a2                	sd	s0,64(sp)
    4bcc:	fc26                	sd	s1,56(sp)
    4bce:	f84a                	sd	s2,48(sp)
    4bd0:	f44e                	sd	s3,40(sp)
    4bd2:	f052                	sd	s4,32(sp)
    4bd4:	ec56                	sd	s5,24(sp)
    4bd6:	0880                	addi	s0,sp,80
    4bd8:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    4bda:	4485                	li	s1,1
    4bdc:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    4bde:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    4be0:	69b1                	lui	s3,0xc
    4be2:	35098993          	addi	s3,s3,848 # c350 <buf+0x378>
    4be6:	1003d937          	lui	s2,0x1003d
    4bea:	090e                	slli	s2,s2,0x3
    4bec:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e498>
    pid = fork();
    4bf0:	00001097          	auipc	ra,0x1
    4bf4:	df2080e7          	jalr	-526(ra) # 59e2 <fork>
    if(pid < 0){
    4bf8:	02054963          	bltz	a0,4c2a <kernmem+0x64>
    if(pid == 0){
    4bfc:	c529                	beqz	a0,4c46 <kernmem+0x80>
    wait(&xstatus);
    4bfe:	fbc40513          	addi	a0,s0,-68
    4c02:	00001097          	auipc	ra,0x1
    4c06:	df0080e7          	jalr	-528(ra) # 59f2 <wait>
    if(xstatus != -1)  // did kernel kill child?
    4c0a:	fbc42783          	lw	a5,-68(s0)
    4c0e:	05579d63          	bne	a5,s5,4c68 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    4c12:	94ce                	add	s1,s1,s3
    4c14:	fd249ee3          	bne	s1,s2,4bf0 <kernmem+0x2a>
}
    4c18:	60a6                	ld	ra,72(sp)
    4c1a:	6406                	ld	s0,64(sp)
    4c1c:	74e2                	ld	s1,56(sp)
    4c1e:	7942                	ld	s2,48(sp)
    4c20:	79a2                	ld	s3,40(sp)
    4c22:	7a02                	ld	s4,32(sp)
    4c24:	6ae2                	ld	s5,24(sp)
    4c26:	6161                	addi	sp,sp,80
    4c28:	8082                	ret
      printf("%s: fork failed\n", s);
    4c2a:	85d2                	mv	a1,s4
    4c2c:	00001517          	auipc	a0,0x1
    4c30:	70450513          	addi	a0,a0,1796 # 6330 <csem_up+0x2fc>
    4c34:	00001097          	auipc	ra,0x1
    4c38:	188080e7          	jalr	392(ra) # 5dbc <printf>
      exit(1);
    4c3c:	4505                	li	a0,1
    4c3e:	00001097          	auipc	ra,0x1
    4c42:	dac080e7          	jalr	-596(ra) # 59ea <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    4c46:	0004c683          	lbu	a3,0(s1)
    4c4a:	8626                	mv	a2,s1
    4c4c:	85d2                	mv	a1,s4
    4c4e:	00003517          	auipc	a0,0x3
    4c52:	59a50513          	addi	a0,a0,1434 # 81e8 <csem_up+0x21b4>
    4c56:	00001097          	auipc	ra,0x1
    4c5a:	166080e7          	jalr	358(ra) # 5dbc <printf>
      exit(1);
    4c5e:	4505                	li	a0,1
    4c60:	00001097          	auipc	ra,0x1
    4c64:	d8a080e7          	jalr	-630(ra) # 59ea <exit>
      exit(1);
    4c68:	4505                	li	a0,1
    4c6a:	00001097          	auipc	ra,0x1
    4c6e:	d80080e7          	jalr	-640(ra) # 59ea <exit>

0000000000004c72 <sbrkfail>:
{
    4c72:	7119                	addi	sp,sp,-128
    4c74:	fc86                	sd	ra,120(sp)
    4c76:	f8a2                	sd	s0,112(sp)
    4c78:	f4a6                	sd	s1,104(sp)
    4c7a:	f0ca                	sd	s2,96(sp)
    4c7c:	ecce                	sd	s3,88(sp)
    4c7e:	e8d2                	sd	s4,80(sp)
    4c80:	e4d6                	sd	s5,72(sp)
    4c82:	0100                	addi	s0,sp,128
    4c84:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    4c86:	fb040513          	addi	a0,s0,-80
    4c8a:	00001097          	auipc	ra,0x1
    4c8e:	d70080e7          	jalr	-656(ra) # 59fa <pipe>
    4c92:	e901                	bnez	a0,4ca2 <sbrkfail+0x30>
    4c94:	f8040493          	addi	s1,s0,-128
    4c98:	fa840993          	addi	s3,s0,-88
    4c9c:	8926                	mv	s2,s1
    if(pids[i] != -1)
    4c9e:	5a7d                	li	s4,-1
    4ca0:	a085                	j	4d00 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4ca2:	85d6                	mv	a1,s5
    4ca4:	00002517          	auipc	a0,0x2
    4ca8:	bbc50513          	addi	a0,a0,-1092 # 6860 <csem_up+0x82c>
    4cac:	00001097          	auipc	ra,0x1
    4cb0:	110080e7          	jalr	272(ra) # 5dbc <printf>
    exit(1);
    4cb4:	4505                	li	a0,1
    4cb6:	00001097          	auipc	ra,0x1
    4cba:	d34080e7          	jalr	-716(ra) # 59ea <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4cbe:	00001097          	auipc	ra,0x1
    4cc2:	db4080e7          	jalr	-588(ra) # 5a72 <sbrk>
    4cc6:	064007b7          	lui	a5,0x6400
    4cca:	40a7853b          	subw	a0,a5,a0
    4cce:	00001097          	auipc	ra,0x1
    4cd2:	da4080e7          	jalr	-604(ra) # 5a72 <sbrk>
      write(fds[1], "x", 1);
    4cd6:	4605                	li	a2,1
    4cd8:	00002597          	auipc	a1,0x2
    4cdc:	91058593          	addi	a1,a1,-1776 # 65e8 <csem_up+0x5b4>
    4ce0:	fb442503          	lw	a0,-76(s0)
    4ce4:	00001097          	auipc	ra,0x1
    4ce8:	d26080e7          	jalr	-730(ra) # 5a0a <write>
      for(;;) sleep(1000);
    4cec:	3e800513          	li	a0,1000
    4cf0:	00001097          	auipc	ra,0x1
    4cf4:	d8a080e7          	jalr	-630(ra) # 5a7a <sleep>
    4cf8:	bfd5                	j	4cec <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4cfa:	0911                	addi	s2,s2,4
    4cfc:	03390563          	beq	s2,s3,4d26 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4d00:	00001097          	auipc	ra,0x1
    4d04:	ce2080e7          	jalr	-798(ra) # 59e2 <fork>
    4d08:	00a92023          	sw	a0,0(s2)
    4d0c:	d94d                	beqz	a0,4cbe <sbrkfail+0x4c>
    if(pids[i] != -1)
    4d0e:	ff4506e3          	beq	a0,s4,4cfa <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4d12:	4605                	li	a2,1
    4d14:	faf40593          	addi	a1,s0,-81
    4d18:	fb042503          	lw	a0,-80(s0)
    4d1c:	00001097          	auipc	ra,0x1
    4d20:	ce6080e7          	jalr	-794(ra) # 5a02 <read>
    4d24:	bfd9                	j	4cfa <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    4d26:	6505                	lui	a0,0x1
    4d28:	00001097          	auipc	ra,0x1
    4d2c:	d4a080e7          	jalr	-694(ra) # 5a72 <sbrk>
    4d30:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4d32:	597d                	li	s2,-1
    4d34:	a021                	j	4d3c <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4d36:	0491                	addi	s1,s1,4
    4d38:	03348063          	beq	s1,s3,4d58 <sbrkfail+0xe6>
    if(pids[i] == -1)
    4d3c:	4088                	lw	a0,0(s1)
    4d3e:	ff250ce3          	beq	a0,s2,4d36 <sbrkfail+0xc4>
    kill(pids[i], SIGKILL);
    4d42:	45a5                	li	a1,9
    4d44:	00001097          	auipc	ra,0x1
    4d48:	cd6080e7          	jalr	-810(ra) # 5a1a <kill>
    wait(0);
    4d4c:	4501                	li	a0,0
    4d4e:	00001097          	auipc	ra,0x1
    4d52:	ca4080e7          	jalr	-860(ra) # 59f2 <wait>
    4d56:	b7c5                	j	4d36 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    4d58:	57fd                	li	a5,-1
    4d5a:	04fa0163          	beq	s4,a5,4d9c <sbrkfail+0x12a>
  pid = fork();
    4d5e:	00001097          	auipc	ra,0x1
    4d62:	c84080e7          	jalr	-892(ra) # 59e2 <fork>
    4d66:	84aa                	mv	s1,a0
  if(pid < 0){
    4d68:	04054863          	bltz	a0,4db8 <sbrkfail+0x146>
  if(pid == 0){
    4d6c:	c525                	beqz	a0,4dd4 <sbrkfail+0x162>
  wait(&xstatus);
    4d6e:	fbc40513          	addi	a0,s0,-68
    4d72:	00001097          	auipc	ra,0x1
    4d76:	c80080e7          	jalr	-896(ra) # 59f2 <wait>
  if(xstatus != -1 && xstatus != 2)
    4d7a:	fbc42783          	lw	a5,-68(s0)
    4d7e:	577d                	li	a4,-1
    4d80:	00e78563          	beq	a5,a4,4d8a <sbrkfail+0x118>
    4d84:	4709                	li	a4,2
    4d86:	08e79d63          	bne	a5,a4,4e20 <sbrkfail+0x1ae>
}
    4d8a:	70e6                	ld	ra,120(sp)
    4d8c:	7446                	ld	s0,112(sp)
    4d8e:	74a6                	ld	s1,104(sp)
    4d90:	7906                	ld	s2,96(sp)
    4d92:	69e6                	ld	s3,88(sp)
    4d94:	6a46                	ld	s4,80(sp)
    4d96:	6aa6                	ld	s5,72(sp)
    4d98:	6109                	addi	sp,sp,128
    4d9a:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4d9c:	85d6                	mv	a1,s5
    4d9e:	00003517          	auipc	a0,0x3
    4da2:	46a50513          	addi	a0,a0,1130 # 8208 <csem_up+0x21d4>
    4da6:	00001097          	auipc	ra,0x1
    4daa:	016080e7          	jalr	22(ra) # 5dbc <printf>
    exit(1);
    4dae:	4505                	li	a0,1
    4db0:	00001097          	auipc	ra,0x1
    4db4:	c3a080e7          	jalr	-966(ra) # 59ea <exit>
    printf("%s: fork failed\n", s);
    4db8:	85d6                	mv	a1,s5
    4dba:	00001517          	auipc	a0,0x1
    4dbe:	57650513          	addi	a0,a0,1398 # 6330 <csem_up+0x2fc>
    4dc2:	00001097          	auipc	ra,0x1
    4dc6:	ffa080e7          	jalr	-6(ra) # 5dbc <printf>
    exit(1);
    4dca:	4505                	li	a0,1
    4dcc:	00001097          	auipc	ra,0x1
    4dd0:	c1e080e7          	jalr	-994(ra) # 59ea <exit>
    a = sbrk(0);
    4dd4:	4501                	li	a0,0
    4dd6:	00001097          	auipc	ra,0x1
    4dda:	c9c080e7          	jalr	-868(ra) # 5a72 <sbrk>
    4dde:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4de0:	3e800537          	lui	a0,0x3e800
    4de4:	00001097          	auipc	ra,0x1
    4de8:	c8e080e7          	jalr	-882(ra) # 5a72 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4dec:	87ca                	mv	a5,s2
    4dee:	3e800737          	lui	a4,0x3e800
    4df2:	993a                	add	s2,s2,a4
    4df4:	6705                	lui	a4,0x1
      n += *(a+i);
    4df6:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f1018>
    4dfa:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4dfc:	97ba                	add	a5,a5,a4
    4dfe:	ff279ce3          	bne	a5,s2,4df6 <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4e02:	8626                	mv	a2,s1
    4e04:	85d6                	mv	a1,s5
    4e06:	00003517          	auipc	a0,0x3
    4e0a:	42250513          	addi	a0,a0,1058 # 8228 <csem_up+0x21f4>
    4e0e:	00001097          	auipc	ra,0x1
    4e12:	fae080e7          	jalr	-82(ra) # 5dbc <printf>
    exit(1);
    4e16:	4505                	li	a0,1
    4e18:	00001097          	auipc	ra,0x1
    4e1c:	bd2080e7          	jalr	-1070(ra) # 59ea <exit>
    exit(1);
    4e20:	4505                	li	a0,1
    4e22:	00001097          	auipc	ra,0x1
    4e26:	bc8080e7          	jalr	-1080(ra) # 59ea <exit>

0000000000004e2a <fsfull>:
{
    4e2a:	7171                	addi	sp,sp,-176
    4e2c:	f506                	sd	ra,168(sp)
    4e2e:	f122                	sd	s0,160(sp)
    4e30:	ed26                	sd	s1,152(sp)
    4e32:	e94a                	sd	s2,144(sp)
    4e34:	e54e                	sd	s3,136(sp)
    4e36:	e152                	sd	s4,128(sp)
    4e38:	fcd6                	sd	s5,120(sp)
    4e3a:	f8da                	sd	s6,112(sp)
    4e3c:	f4de                	sd	s7,104(sp)
    4e3e:	f0e2                	sd	s8,96(sp)
    4e40:	ece6                	sd	s9,88(sp)
    4e42:	e8ea                	sd	s10,80(sp)
    4e44:	e4ee                	sd	s11,72(sp)
    4e46:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4e48:	00003517          	auipc	a0,0x3
    4e4c:	41050513          	addi	a0,a0,1040 # 8258 <csem_up+0x2224>
    4e50:	00001097          	auipc	ra,0x1
    4e54:	f6c080e7          	jalr	-148(ra) # 5dbc <printf>
  for(nfiles = 0; ; nfiles++){
    4e58:	4481                	li	s1,0
    name[0] = 'f';
    4e5a:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4e5e:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4e62:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4e66:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4e68:	00003c97          	auipc	s9,0x3
    4e6c:	400c8c93          	addi	s9,s9,1024 # 8268 <csem_up+0x2234>
    int total = 0;
    4e70:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4e72:	00007a17          	auipc	s4,0x7
    4e76:	166a0a13          	addi	s4,s4,358 # bfd8 <buf>
    name[0] = 'f';
    4e7a:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4e7e:	0384c7bb          	divw	a5,s1,s8
    4e82:	0307879b          	addiw	a5,a5,48
    4e86:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4e8a:	0384e7bb          	remw	a5,s1,s8
    4e8e:	0377c7bb          	divw	a5,a5,s7
    4e92:	0307879b          	addiw	a5,a5,48
    4e96:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4e9a:	0374e7bb          	remw	a5,s1,s7
    4e9e:	0367c7bb          	divw	a5,a5,s6
    4ea2:	0307879b          	addiw	a5,a5,48
    4ea6:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4eaa:	0364e7bb          	remw	a5,s1,s6
    4eae:	0307879b          	addiw	a5,a5,48
    4eb2:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4eb6:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4eba:	f5040593          	addi	a1,s0,-176
    4ebe:	8566                	mv	a0,s9
    4ec0:	00001097          	auipc	ra,0x1
    4ec4:	efc080e7          	jalr	-260(ra) # 5dbc <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4ec8:	20200593          	li	a1,514
    4ecc:	f5040513          	addi	a0,s0,-176
    4ed0:	00001097          	auipc	ra,0x1
    4ed4:	b5a080e7          	jalr	-1190(ra) # 5a2a <open>
    4ed8:	892a                	mv	s2,a0
    if(fd < 0){
    4eda:	0a055663          	bgez	a0,4f86 <fsfull+0x15c>
      printf("open %s failed\n", name);
    4ede:	f5040593          	addi	a1,s0,-176
    4ee2:	00003517          	auipc	a0,0x3
    4ee6:	39650513          	addi	a0,a0,918 # 8278 <csem_up+0x2244>
    4eea:	00001097          	auipc	ra,0x1
    4eee:	ed2080e7          	jalr	-302(ra) # 5dbc <printf>
  while(nfiles >= 0){
    4ef2:	0604c363          	bltz	s1,4f58 <fsfull+0x12e>
    name[0] = 'f';
    4ef6:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4efa:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4efe:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4f02:	4929                	li	s2,10
  while(nfiles >= 0){
    4f04:	5afd                	li	s5,-1
    name[0] = 'f';
    4f06:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4f0a:	0344c7bb          	divw	a5,s1,s4
    4f0e:	0307879b          	addiw	a5,a5,48
    4f12:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4f16:	0344e7bb          	remw	a5,s1,s4
    4f1a:	0337c7bb          	divw	a5,a5,s3
    4f1e:	0307879b          	addiw	a5,a5,48
    4f22:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4f26:	0334e7bb          	remw	a5,s1,s3
    4f2a:	0327c7bb          	divw	a5,a5,s2
    4f2e:	0307879b          	addiw	a5,a5,48
    4f32:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4f36:	0324e7bb          	remw	a5,s1,s2
    4f3a:	0307879b          	addiw	a5,a5,48
    4f3e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4f42:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4f46:	f5040513          	addi	a0,s0,-176
    4f4a:	00001097          	auipc	ra,0x1
    4f4e:	af0080e7          	jalr	-1296(ra) # 5a3a <unlink>
    nfiles--;
    4f52:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4f54:	fb5499e3          	bne	s1,s5,4f06 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4f58:	00003517          	auipc	a0,0x3
    4f5c:	34050513          	addi	a0,a0,832 # 8298 <csem_up+0x2264>
    4f60:	00001097          	auipc	ra,0x1
    4f64:	e5c080e7          	jalr	-420(ra) # 5dbc <printf>
}
    4f68:	70aa                	ld	ra,168(sp)
    4f6a:	740a                	ld	s0,160(sp)
    4f6c:	64ea                	ld	s1,152(sp)
    4f6e:	694a                	ld	s2,144(sp)
    4f70:	69aa                	ld	s3,136(sp)
    4f72:	6a0a                	ld	s4,128(sp)
    4f74:	7ae6                	ld	s5,120(sp)
    4f76:	7b46                	ld	s6,112(sp)
    4f78:	7ba6                	ld	s7,104(sp)
    4f7a:	7c06                	ld	s8,96(sp)
    4f7c:	6ce6                	ld	s9,88(sp)
    4f7e:	6d46                	ld	s10,80(sp)
    4f80:	6da6                	ld	s11,72(sp)
    4f82:	614d                	addi	sp,sp,176
    4f84:	8082                	ret
    int total = 0;
    4f86:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4f88:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4f8c:	40000613          	li	a2,1024
    4f90:	85d2                	mv	a1,s4
    4f92:	854a                	mv	a0,s2
    4f94:	00001097          	auipc	ra,0x1
    4f98:	a76080e7          	jalr	-1418(ra) # 5a0a <write>
      if(cc < BSIZE)
    4f9c:	00aad563          	bge	s5,a0,4fa6 <fsfull+0x17c>
      total += cc;
    4fa0:	00a989bb          	addw	s3,s3,a0
    while(1){
    4fa4:	b7e5                	j	4f8c <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    4fa6:	85ce                	mv	a1,s3
    4fa8:	00003517          	auipc	a0,0x3
    4fac:	2e050513          	addi	a0,a0,736 # 8288 <csem_up+0x2254>
    4fb0:	00001097          	auipc	ra,0x1
    4fb4:	e0c080e7          	jalr	-500(ra) # 5dbc <printf>
    close(fd);
    4fb8:	854a                	mv	a0,s2
    4fba:	00001097          	auipc	ra,0x1
    4fbe:	a58080e7          	jalr	-1448(ra) # 5a12 <close>
    if(total == 0)
    4fc2:	f20988e3          	beqz	s3,4ef2 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4fc6:	2485                	addiw	s1,s1,1
    4fc8:	bd4d                	j	4e7a <fsfull+0x50>

0000000000004fca <rand>:
{
    4fca:	1141                	addi	sp,sp,-16
    4fcc:	e422                	sd	s0,8(sp)
    4fce:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4fd0:	00003717          	auipc	a4,0x3
    4fd4:	7d870713          	addi	a4,a4,2008 # 87a8 <randstate>
    4fd8:	6308                	ld	a0,0(a4)
    4fda:	001967b7          	lui	a5,0x196
    4fde:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x187625>
    4fe2:	02f50533          	mul	a0,a0,a5
    4fe6:	3c6ef7b7          	lui	a5,0x3c6ef
    4fea:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e0377>
    4fee:	953e                	add	a0,a0,a5
    4ff0:	e308                	sd	a0,0(a4)
}
    4ff2:	2501                	sext.w	a0,a0
    4ff4:	6422                	ld	s0,8(sp)
    4ff6:	0141                	addi	sp,sp,16
    4ff8:	8082                	ret

0000000000004ffa <stacktest>:
{
    4ffa:	7179                	addi	sp,sp,-48
    4ffc:	f406                	sd	ra,40(sp)
    4ffe:	f022                	sd	s0,32(sp)
    5000:	ec26                	sd	s1,24(sp)
    5002:	1800                	addi	s0,sp,48
    5004:	84aa                	mv	s1,a0
  pid = fork();
    5006:	00001097          	auipc	ra,0x1
    500a:	9dc080e7          	jalr	-1572(ra) # 59e2 <fork>
  if(pid == 0) {
    500e:	c115                	beqz	a0,5032 <stacktest+0x38>
  } else if(pid < 0){
    5010:	04054463          	bltz	a0,5058 <stacktest+0x5e>
  wait(&xstatus);
    5014:	fdc40513          	addi	a0,s0,-36
    5018:	00001097          	auipc	ra,0x1
    501c:	9da080e7          	jalr	-1574(ra) # 59f2 <wait>
  if(xstatus == -1)  // kernel killed child?
    5020:	fdc42503          	lw	a0,-36(s0)
    5024:	57fd                	li	a5,-1
    5026:	04f50763          	beq	a0,a5,5074 <stacktest+0x7a>
    exit(xstatus);
    502a:	00001097          	auipc	ra,0x1
    502e:	9c0080e7          	jalr	-1600(ra) # 59ea <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    5032:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    5034:	77fd                	lui	a5,0xfffff
    5036:	97ba                	add	a5,a5,a4
    5038:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0018>
    503c:	85a6                	mv	a1,s1
    503e:	00003517          	auipc	a0,0x3
    5042:	27250513          	addi	a0,a0,626 # 82b0 <csem_up+0x227c>
    5046:	00001097          	auipc	ra,0x1
    504a:	d76080e7          	jalr	-650(ra) # 5dbc <printf>
    exit(1);
    504e:	4505                	li	a0,1
    5050:	00001097          	auipc	ra,0x1
    5054:	99a080e7          	jalr	-1638(ra) # 59ea <exit>
    printf("%s: fork failed\n", s);
    5058:	85a6                	mv	a1,s1
    505a:	00001517          	auipc	a0,0x1
    505e:	2d650513          	addi	a0,a0,726 # 6330 <csem_up+0x2fc>
    5062:	00001097          	auipc	ra,0x1
    5066:	d5a080e7          	jalr	-678(ra) # 5dbc <printf>
    exit(1);
    506a:	4505                	li	a0,1
    506c:	00001097          	auipc	ra,0x1
    5070:	97e080e7          	jalr	-1666(ra) # 59ea <exit>
    exit(0);
    5074:	4501                	li	a0,0
    5076:	00001097          	auipc	ra,0x1
    507a:	974080e7          	jalr	-1676(ra) # 59ea <exit>

000000000000507e <sbrkbugs>:
{
    507e:	1141                	addi	sp,sp,-16
    5080:	e406                	sd	ra,8(sp)
    5082:	e022                	sd	s0,0(sp)
    5084:	0800                	addi	s0,sp,16
  int pid = fork();
    5086:	00001097          	auipc	ra,0x1
    508a:	95c080e7          	jalr	-1700(ra) # 59e2 <fork>
  if(pid < 0){
    508e:	02054263          	bltz	a0,50b2 <sbrkbugs+0x34>
  if(pid == 0){
    5092:	ed0d                	bnez	a0,50cc <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    5094:	00001097          	auipc	ra,0x1
    5098:	9de080e7          	jalr	-1570(ra) # 5a72 <sbrk>
    sbrk(-sz);
    509c:	40a0053b          	negw	a0,a0
    50a0:	00001097          	auipc	ra,0x1
    50a4:	9d2080e7          	jalr	-1582(ra) # 5a72 <sbrk>
    exit(0);
    50a8:	4501                	li	a0,0
    50aa:	00001097          	auipc	ra,0x1
    50ae:	940080e7          	jalr	-1728(ra) # 59ea <exit>
    printf("fork failed\n");
    50b2:	00002517          	auipc	a0,0x2
    50b6:	d4650513          	addi	a0,a0,-698 # 6df8 <csem_up+0xdc4>
    50ba:	00001097          	auipc	ra,0x1
    50be:	d02080e7          	jalr	-766(ra) # 5dbc <printf>
    exit(1);
    50c2:	4505                	li	a0,1
    50c4:	00001097          	auipc	ra,0x1
    50c8:	926080e7          	jalr	-1754(ra) # 59ea <exit>
  wait(0);
    50cc:	4501                	li	a0,0
    50ce:	00001097          	auipc	ra,0x1
    50d2:	924080e7          	jalr	-1756(ra) # 59f2 <wait>
  pid = fork();
    50d6:	00001097          	auipc	ra,0x1
    50da:	90c080e7          	jalr	-1780(ra) # 59e2 <fork>
  if(pid < 0){
    50de:	02054563          	bltz	a0,5108 <sbrkbugs+0x8a>
  if(pid == 0){
    50e2:	e121                	bnez	a0,5122 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    50e4:	00001097          	auipc	ra,0x1
    50e8:	98e080e7          	jalr	-1650(ra) # 5a72 <sbrk>
    sbrk(-(sz - 3500));
    50ec:	6785                	lui	a5,0x1
    50ee:	dac7879b          	addiw	a5,a5,-596
    50f2:	40a7853b          	subw	a0,a5,a0
    50f6:	00001097          	auipc	ra,0x1
    50fa:	97c080e7          	jalr	-1668(ra) # 5a72 <sbrk>
    exit(0);
    50fe:	4501                	li	a0,0
    5100:	00001097          	auipc	ra,0x1
    5104:	8ea080e7          	jalr	-1814(ra) # 59ea <exit>
    printf("fork failed\n");
    5108:	00002517          	auipc	a0,0x2
    510c:	cf050513          	addi	a0,a0,-784 # 6df8 <csem_up+0xdc4>
    5110:	00001097          	auipc	ra,0x1
    5114:	cac080e7          	jalr	-852(ra) # 5dbc <printf>
    exit(1);
    5118:	4505                	li	a0,1
    511a:	00001097          	auipc	ra,0x1
    511e:	8d0080e7          	jalr	-1840(ra) # 59ea <exit>
  wait(0);
    5122:	4501                	li	a0,0
    5124:	00001097          	auipc	ra,0x1
    5128:	8ce080e7          	jalr	-1842(ra) # 59f2 <wait>
  pid = fork();
    512c:	00001097          	auipc	ra,0x1
    5130:	8b6080e7          	jalr	-1866(ra) # 59e2 <fork>
  if(pid < 0){
    5134:	02054a63          	bltz	a0,5168 <sbrkbugs+0xea>
  if(pid == 0){
    5138:	e529                	bnez	a0,5182 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    513a:	00001097          	auipc	ra,0x1
    513e:	938080e7          	jalr	-1736(ra) # 5a72 <sbrk>
    5142:	67ad                	lui	a5,0xb
    5144:	8007879b          	addiw	a5,a5,-2048
    5148:	40a7853b          	subw	a0,a5,a0
    514c:	00001097          	auipc	ra,0x1
    5150:	926080e7          	jalr	-1754(ra) # 5a72 <sbrk>
    sbrk(-10);
    5154:	5559                	li	a0,-10
    5156:	00001097          	auipc	ra,0x1
    515a:	91c080e7          	jalr	-1764(ra) # 5a72 <sbrk>
    exit(0);
    515e:	4501                	li	a0,0
    5160:	00001097          	auipc	ra,0x1
    5164:	88a080e7          	jalr	-1910(ra) # 59ea <exit>
    printf("fork failed\n");
    5168:	00002517          	auipc	a0,0x2
    516c:	c9050513          	addi	a0,a0,-880 # 6df8 <csem_up+0xdc4>
    5170:	00001097          	auipc	ra,0x1
    5174:	c4c080e7          	jalr	-948(ra) # 5dbc <printf>
    exit(1);
    5178:	4505                	li	a0,1
    517a:	00001097          	auipc	ra,0x1
    517e:	870080e7          	jalr	-1936(ra) # 59ea <exit>
  wait(0);
    5182:	4501                	li	a0,0
    5184:	00001097          	auipc	ra,0x1
    5188:	86e080e7          	jalr	-1938(ra) # 59f2 <wait>
  exit(0);
    518c:	4501                	li	a0,0
    518e:	00001097          	auipc	ra,0x1
    5192:	85c080e7          	jalr	-1956(ra) # 59ea <exit>

0000000000005196 <badwrite>:
{
    5196:	7179                	addi	sp,sp,-48
    5198:	f406                	sd	ra,40(sp)
    519a:	f022                	sd	s0,32(sp)
    519c:	ec26                	sd	s1,24(sp)
    519e:	e84a                	sd	s2,16(sp)
    51a0:	e44e                	sd	s3,8(sp)
    51a2:	e052                	sd	s4,0(sp)
    51a4:	1800                	addi	s0,sp,48
  unlink("junk");
    51a6:	00003517          	auipc	a0,0x3
    51aa:	13250513          	addi	a0,a0,306 # 82d8 <csem_up+0x22a4>
    51ae:	00001097          	auipc	ra,0x1
    51b2:	88c080e7          	jalr	-1908(ra) # 5a3a <unlink>
    51b6:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    51ba:	00003997          	auipc	s3,0x3
    51be:	11e98993          	addi	s3,s3,286 # 82d8 <csem_up+0x22a4>
    write(fd, (char*)0xffffffffffL, 1);
    51c2:	5a7d                	li	s4,-1
    51c4:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    51c8:	20100593          	li	a1,513
    51cc:	854e                	mv	a0,s3
    51ce:	00001097          	auipc	ra,0x1
    51d2:	85c080e7          	jalr	-1956(ra) # 5a2a <open>
    51d6:	84aa                	mv	s1,a0
    if(fd < 0){
    51d8:	06054b63          	bltz	a0,524e <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    51dc:	4605                	li	a2,1
    51de:	85d2                	mv	a1,s4
    51e0:	00001097          	auipc	ra,0x1
    51e4:	82a080e7          	jalr	-2006(ra) # 5a0a <write>
    close(fd);
    51e8:	8526                	mv	a0,s1
    51ea:	00001097          	auipc	ra,0x1
    51ee:	828080e7          	jalr	-2008(ra) # 5a12 <close>
    unlink("junk");
    51f2:	854e                	mv	a0,s3
    51f4:	00001097          	auipc	ra,0x1
    51f8:	846080e7          	jalr	-1978(ra) # 5a3a <unlink>
  for(int i = 0; i < assumed_free; i++){
    51fc:	397d                	addiw	s2,s2,-1
    51fe:	fc0915e3          	bnez	s2,51c8 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    5202:	20100593          	li	a1,513
    5206:	00003517          	auipc	a0,0x3
    520a:	0d250513          	addi	a0,a0,210 # 82d8 <csem_up+0x22a4>
    520e:	00001097          	auipc	ra,0x1
    5212:	81c080e7          	jalr	-2020(ra) # 5a2a <open>
    5216:	84aa                	mv	s1,a0
  if(fd < 0){
    5218:	04054863          	bltz	a0,5268 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    521c:	4605                	li	a2,1
    521e:	00001597          	auipc	a1,0x1
    5222:	3ca58593          	addi	a1,a1,970 # 65e8 <csem_up+0x5b4>
    5226:	00000097          	auipc	ra,0x0
    522a:	7e4080e7          	jalr	2020(ra) # 5a0a <write>
    522e:	4785                	li	a5,1
    5230:	04f50963          	beq	a0,a5,5282 <badwrite+0xec>
    printf("write failed\n");
    5234:	00003517          	auipc	a0,0x3
    5238:	0c450513          	addi	a0,a0,196 # 82f8 <csem_up+0x22c4>
    523c:	00001097          	auipc	ra,0x1
    5240:	b80080e7          	jalr	-1152(ra) # 5dbc <printf>
    exit(1);
    5244:	4505                	li	a0,1
    5246:	00000097          	auipc	ra,0x0
    524a:	7a4080e7          	jalr	1956(ra) # 59ea <exit>
      printf("open junk failed\n");
    524e:	00003517          	auipc	a0,0x3
    5252:	09250513          	addi	a0,a0,146 # 82e0 <csem_up+0x22ac>
    5256:	00001097          	auipc	ra,0x1
    525a:	b66080e7          	jalr	-1178(ra) # 5dbc <printf>
      exit(1);
    525e:	4505                	li	a0,1
    5260:	00000097          	auipc	ra,0x0
    5264:	78a080e7          	jalr	1930(ra) # 59ea <exit>
    printf("open junk failed\n");
    5268:	00003517          	auipc	a0,0x3
    526c:	07850513          	addi	a0,a0,120 # 82e0 <csem_up+0x22ac>
    5270:	00001097          	auipc	ra,0x1
    5274:	b4c080e7          	jalr	-1204(ra) # 5dbc <printf>
    exit(1);
    5278:	4505                	li	a0,1
    527a:	00000097          	auipc	ra,0x0
    527e:	770080e7          	jalr	1904(ra) # 59ea <exit>
  close(fd);
    5282:	8526                	mv	a0,s1
    5284:	00000097          	auipc	ra,0x0
    5288:	78e080e7          	jalr	1934(ra) # 5a12 <close>
  unlink("junk");
    528c:	00003517          	auipc	a0,0x3
    5290:	04c50513          	addi	a0,a0,76 # 82d8 <csem_up+0x22a4>
    5294:	00000097          	auipc	ra,0x0
    5298:	7a6080e7          	jalr	1958(ra) # 5a3a <unlink>
  exit(0);
    529c:	4501                	li	a0,0
    529e:	00000097          	auipc	ra,0x0
    52a2:	74c080e7          	jalr	1868(ra) # 59ea <exit>

00000000000052a6 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    52a6:	715d                	addi	sp,sp,-80
    52a8:	e486                	sd	ra,72(sp)
    52aa:	e0a2                	sd	s0,64(sp)
    52ac:	fc26                	sd	s1,56(sp)
    52ae:	f84a                	sd	s2,48(sp)
    52b0:	f44e                	sd	s3,40(sp)
    52b2:	f052                	sd	s4,32(sp)
    52b4:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    52b6:	4901                	li	s2,0
    52b8:	49bd                	li	s3,15
    int pid = fork();
    52ba:	00000097          	auipc	ra,0x0
    52be:	728080e7          	jalr	1832(ra) # 59e2 <fork>
    52c2:	84aa                	mv	s1,a0
    if(pid < 0){
    52c4:	02054063          	bltz	a0,52e4 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    52c8:	c91d                	beqz	a0,52fe <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    52ca:	4501                	li	a0,0
    52cc:	00000097          	auipc	ra,0x0
    52d0:	726080e7          	jalr	1830(ra) # 59f2 <wait>
  for(int avail = 0; avail < 15; avail++){
    52d4:	2905                	addiw	s2,s2,1
    52d6:	ff3912e3          	bne	s2,s3,52ba <execout+0x14>
    }
  }

  exit(0);
    52da:	4501                	li	a0,0
    52dc:	00000097          	auipc	ra,0x0
    52e0:	70e080e7          	jalr	1806(ra) # 59ea <exit>
      printf("fork failed\n");
    52e4:	00002517          	auipc	a0,0x2
    52e8:	b1450513          	addi	a0,a0,-1260 # 6df8 <csem_up+0xdc4>
    52ec:	00001097          	auipc	ra,0x1
    52f0:	ad0080e7          	jalr	-1328(ra) # 5dbc <printf>
      exit(1);
    52f4:	4505                	li	a0,1
    52f6:	00000097          	auipc	ra,0x0
    52fa:	6f4080e7          	jalr	1780(ra) # 59ea <exit>
        if(a == 0xffffffffffffffffLL)
    52fe:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    5300:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    5302:	6505                	lui	a0,0x1
    5304:	00000097          	auipc	ra,0x0
    5308:	76e080e7          	jalr	1902(ra) # 5a72 <sbrk>
        if(a == 0xffffffffffffffffLL)
    530c:	01350763          	beq	a0,s3,531a <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    5310:	6785                	lui	a5,0x1
    5312:	953e                	add	a0,a0,a5
    5314:	ff450fa3          	sb	s4,-1(a0) # fff <pipe1+0x175>
      while(1){
    5318:	b7ed                	j	5302 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    531a:	01205a63          	blez	s2,532e <execout+0x88>
        sbrk(-4096);
    531e:	757d                	lui	a0,0xfffff
    5320:	00000097          	auipc	ra,0x0
    5324:	752080e7          	jalr	1874(ra) # 5a72 <sbrk>
      for(int i = 0; i < avail; i++)
    5328:	2485                	addiw	s1,s1,1
    532a:	ff249ae3          	bne	s1,s2,531e <execout+0x78>
      close(1);
    532e:	4505                	li	a0,1
    5330:	00000097          	auipc	ra,0x0
    5334:	6e2080e7          	jalr	1762(ra) # 5a12 <close>
      char *args[] = { "echo", "x", 0 };
    5338:	00001517          	auipc	a0,0x1
    533c:	24050513          	addi	a0,a0,576 # 6578 <csem_up+0x544>
    5340:	faa43c23          	sd	a0,-72(s0)
    5344:	00001797          	auipc	a5,0x1
    5348:	2a478793          	addi	a5,a5,676 # 65e8 <csem_up+0x5b4>
    534c:	fcf43023          	sd	a5,-64(s0)
    5350:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    5354:	fb840593          	addi	a1,s0,-72
    5358:	00000097          	auipc	ra,0x0
    535c:	6ca080e7          	jalr	1738(ra) # 5a22 <exec>
      exit(0);
    5360:	4501                	li	a0,0
    5362:	00000097          	auipc	ra,0x0
    5366:	688080e7          	jalr	1672(ra) # 59ea <exit>

000000000000536a <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    536a:	7139                	addi	sp,sp,-64
    536c:	fc06                	sd	ra,56(sp)
    536e:	f822                	sd	s0,48(sp)
    5370:	f426                	sd	s1,40(sp)
    5372:	f04a                	sd	s2,32(sp)
    5374:	ec4e                	sd	s3,24(sp)
    5376:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5378:	fc840513          	addi	a0,s0,-56
    537c:	00000097          	auipc	ra,0x0
    5380:	67e080e7          	jalr	1662(ra) # 59fa <pipe>
    5384:	06054763          	bltz	a0,53f2 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5388:	00000097          	auipc	ra,0x0
    538c:	65a080e7          	jalr	1626(ra) # 59e2 <fork>

  if(pid < 0){
    5390:	06054e63          	bltz	a0,540c <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5394:	ed51                	bnez	a0,5430 <countfree+0xc6>
    close(fds[0]);
    5396:	fc842503          	lw	a0,-56(s0)
    539a:	00000097          	auipc	ra,0x0
    539e:	678080e7          	jalr	1656(ra) # 5a12 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    53a2:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    53a4:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    53a6:	00001997          	auipc	s3,0x1
    53aa:	24298993          	addi	s3,s3,578 # 65e8 <csem_up+0x5b4>
      uint64 a = (uint64) sbrk(4096);
    53ae:	6505                	lui	a0,0x1
    53b0:	00000097          	auipc	ra,0x0
    53b4:	6c2080e7          	jalr	1730(ra) # 5a72 <sbrk>
      if(a == 0xffffffffffffffff){
    53b8:	07250763          	beq	a0,s2,5426 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    53bc:	6785                	lui	a5,0x1
    53be:	953e                	add	a0,a0,a5
    53c0:	fe950fa3          	sb	s1,-1(a0) # fff <pipe1+0x175>
      if(write(fds[1], "x", 1) != 1){
    53c4:	8626                	mv	a2,s1
    53c6:	85ce                	mv	a1,s3
    53c8:	fcc42503          	lw	a0,-52(s0)
    53cc:	00000097          	auipc	ra,0x0
    53d0:	63e080e7          	jalr	1598(ra) # 5a0a <write>
    53d4:	fc950de3          	beq	a0,s1,53ae <countfree+0x44>
        printf("write() failed in countfree()\n");
    53d8:	00003517          	auipc	a0,0x3
    53dc:	f7050513          	addi	a0,a0,-144 # 8348 <csem_up+0x2314>
    53e0:	00001097          	auipc	ra,0x1
    53e4:	9dc080e7          	jalr	-1572(ra) # 5dbc <printf>
        exit(1);
    53e8:	4505                	li	a0,1
    53ea:	00000097          	auipc	ra,0x0
    53ee:	600080e7          	jalr	1536(ra) # 59ea <exit>
    printf("pipe() failed in countfree()\n");
    53f2:	00003517          	auipc	a0,0x3
    53f6:	f1650513          	addi	a0,a0,-234 # 8308 <csem_up+0x22d4>
    53fa:	00001097          	auipc	ra,0x1
    53fe:	9c2080e7          	jalr	-1598(ra) # 5dbc <printf>
    exit(1);
    5402:	4505                	li	a0,1
    5404:	00000097          	auipc	ra,0x0
    5408:	5e6080e7          	jalr	1510(ra) # 59ea <exit>
    printf("fork failed in countfree()\n");
    540c:	00003517          	auipc	a0,0x3
    5410:	f1c50513          	addi	a0,a0,-228 # 8328 <csem_up+0x22f4>
    5414:	00001097          	auipc	ra,0x1
    5418:	9a8080e7          	jalr	-1624(ra) # 5dbc <printf>
    exit(1);
    541c:	4505                	li	a0,1
    541e:	00000097          	auipc	ra,0x0
    5422:	5cc080e7          	jalr	1484(ra) # 59ea <exit>
      }
    }

    exit(0);
    5426:	4501                	li	a0,0
    5428:	00000097          	auipc	ra,0x0
    542c:	5c2080e7          	jalr	1474(ra) # 59ea <exit>
  }

  close(fds[1]);
    5430:	fcc42503          	lw	a0,-52(s0)
    5434:	00000097          	auipc	ra,0x0
    5438:	5de080e7          	jalr	1502(ra) # 5a12 <close>

  int n = 0;
    543c:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    543e:	4605                	li	a2,1
    5440:	fc740593          	addi	a1,s0,-57
    5444:	fc842503          	lw	a0,-56(s0)
    5448:	00000097          	auipc	ra,0x0
    544c:	5ba080e7          	jalr	1466(ra) # 5a02 <read>
    if(cc < 0){
    5450:	00054563          	bltz	a0,545a <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5454:	c105                	beqz	a0,5474 <countfree+0x10a>
      break;
    n += 1;
    5456:	2485                	addiw	s1,s1,1
  while(1){
    5458:	b7dd                	j	543e <countfree+0xd4>
      printf("read() failed in countfree()\n");
    545a:	00003517          	auipc	a0,0x3
    545e:	f0e50513          	addi	a0,a0,-242 # 8368 <csem_up+0x2334>
    5462:	00001097          	auipc	ra,0x1
    5466:	95a080e7          	jalr	-1702(ra) # 5dbc <printf>
      exit(1);
    546a:	4505                	li	a0,1
    546c:	00000097          	auipc	ra,0x0
    5470:	57e080e7          	jalr	1406(ra) # 59ea <exit>
  }

  close(fds[0]);
    5474:	fc842503          	lw	a0,-56(s0)
    5478:	00000097          	auipc	ra,0x0
    547c:	59a080e7          	jalr	1434(ra) # 5a12 <close>
  wait((int*)0);
    5480:	4501                	li	a0,0
    5482:	00000097          	auipc	ra,0x0
    5486:	570080e7          	jalr	1392(ra) # 59f2 <wait>
  
  return n;
}
    548a:	8526                	mv	a0,s1
    548c:	70e2                	ld	ra,56(sp)
    548e:	7442                	ld	s0,48(sp)
    5490:	74a2                	ld	s1,40(sp)
    5492:	7902                	ld	s2,32(sp)
    5494:	69e2                	ld	s3,24(sp)
    5496:	6121                	addi	sp,sp,64
    5498:	8082                	ret

000000000000549a <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    549a:	7179                	addi	sp,sp,-48
    549c:	f406                	sd	ra,40(sp)
    549e:	f022                	sd	s0,32(sp)
    54a0:	ec26                	sd	s1,24(sp)
    54a2:	e84a                	sd	s2,16(sp)
    54a4:	1800                	addi	s0,sp,48
    54a6:	84aa                	mv	s1,a0
    54a8:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    54aa:	00003517          	auipc	a0,0x3
    54ae:	ede50513          	addi	a0,a0,-290 # 8388 <csem_up+0x2354>
    54b2:	00001097          	auipc	ra,0x1
    54b6:	90a080e7          	jalr	-1782(ra) # 5dbc <printf>
  if((pid = fork()) < 0) {
    54ba:	00000097          	auipc	ra,0x0
    54be:	528080e7          	jalr	1320(ra) # 59e2 <fork>
    54c2:	02054e63          	bltz	a0,54fe <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    54c6:	c929                	beqz	a0,5518 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    54c8:	fdc40513          	addi	a0,s0,-36
    54cc:	00000097          	auipc	ra,0x0
    54d0:	526080e7          	jalr	1318(ra) # 59f2 <wait>
    if(xstatus != 0) 
    54d4:	fdc42783          	lw	a5,-36(s0)
    54d8:	c7b9                	beqz	a5,5526 <run+0x8c>
      printf("FAILED\n");
    54da:	00003517          	auipc	a0,0x3
    54de:	ed650513          	addi	a0,a0,-298 # 83b0 <csem_up+0x237c>
    54e2:	00001097          	auipc	ra,0x1
    54e6:	8da080e7          	jalr	-1830(ra) # 5dbc <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    54ea:	fdc42503          	lw	a0,-36(s0)
  }
}
    54ee:	00153513          	seqz	a0,a0
    54f2:	70a2                	ld	ra,40(sp)
    54f4:	7402                	ld	s0,32(sp)
    54f6:	64e2                	ld	s1,24(sp)
    54f8:	6942                	ld	s2,16(sp)
    54fa:	6145                	addi	sp,sp,48
    54fc:	8082                	ret
    printf("runtest: fork error\n");
    54fe:	00003517          	auipc	a0,0x3
    5502:	e9a50513          	addi	a0,a0,-358 # 8398 <csem_up+0x2364>
    5506:	00001097          	auipc	ra,0x1
    550a:	8b6080e7          	jalr	-1866(ra) # 5dbc <printf>
    exit(1);
    550e:	4505                	li	a0,1
    5510:	00000097          	auipc	ra,0x0
    5514:	4da080e7          	jalr	1242(ra) # 59ea <exit>
    f(s);
    5518:	854a                	mv	a0,s2
    551a:	9482                	jalr	s1
    exit(0);
    551c:	4501                	li	a0,0
    551e:	00000097          	auipc	ra,0x0
    5522:	4cc080e7          	jalr	1228(ra) # 59ea <exit>
      printf("OK\n");
    5526:	00003517          	auipc	a0,0x3
    552a:	e9250513          	addi	a0,a0,-366 # 83b8 <csem_up+0x2384>
    552e:	00001097          	auipc	ra,0x1
    5532:	88e080e7          	jalr	-1906(ra) # 5dbc <printf>
    5536:	bf55                	j	54ea <run+0x50>

0000000000005538 <main>:

int
main(int argc, char *argv[])
{
    5538:	d1010113          	addi	sp,sp,-752
    553c:	2e113423          	sd	ra,744(sp)
    5540:	2e813023          	sd	s0,736(sp)
    5544:	2c913c23          	sd	s1,728(sp)
    5548:	2d213823          	sd	s2,720(sp)
    554c:	2d313423          	sd	s3,712(sp)
    5550:	2d413023          	sd	s4,704(sp)
    5554:	2b513c23          	sd	s5,696(sp)
    5558:	2b613823          	sd	s6,688(sp)
    555c:	1d80                	addi	s0,sp,752
    555e:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5560:	4789                	li	a5,2
    5562:	08f50d63          	beq	a0,a5,55fc <main+0xc4>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5566:	4785                	li	a5,1
  char *justone = 0;
    5568:	4901                	li	s2,0
  } else if(argc > 1){
    556a:	0ca7c763          	blt	a5,a0,5638 <main+0x100>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    556e:	00003797          	auipc	a5,0x3
    5572:	f6278793          	addi	a5,a5,-158 # 84d0 <csem_up+0x249c>
    5576:	d1040713          	addi	a4,s0,-752
    557a:	00003897          	auipc	a7,0x3
    557e:	1fe88893          	addi	a7,a7,510 # 8778 <csem_up+0x2744>
    5582:	0007b803          	ld	a6,0(a5)
    5586:	6788                	ld	a0,8(a5)
    5588:	6b8c                	ld	a1,16(a5)
    558a:	6f90                	ld	a2,24(a5)
    558c:	7394                	ld	a3,32(a5)
    558e:	01073023          	sd	a6,0(a4)
    5592:	e708                	sd	a0,8(a4)
    5594:	eb0c                	sd	a1,16(a4)
    5596:	ef10                	sd	a2,24(a4)
    5598:	f314                	sd	a3,32(a4)
    559a:	02878793          	addi	a5,a5,40
    559e:	02870713          	addi	a4,a4,40
    55a2:	ff1790e3          	bne	a5,a7,5582 <main+0x4a>
    55a6:	639c                	ld	a5,0(a5)
    55a8:	e31c                	sd	a5,0(a4)
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    55aa:	00003517          	auipc	a0,0x3
    55ae:	ec650513          	addi	a0,a0,-314 # 8470 <csem_up+0x243c>
    55b2:	00001097          	auipc	ra,0x1
    55b6:	80a080e7          	jalr	-2038(ra) # 5dbc <printf>
  int free0 = countfree();
    55ba:	00000097          	auipc	ra,0x0
    55be:	db0080e7          	jalr	-592(ra) # 536a <countfree>
    55c2:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    55c4:	d1843503          	ld	a0,-744(s0)
    55c8:	d1040493          	addi	s1,s0,-752
  int fail = 0;
    55cc:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    55ce:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    55d0:	e55d                	bnez	a0,567e <main+0x146>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    55d2:	00000097          	auipc	ra,0x0
    55d6:	d98080e7          	jalr	-616(ra) # 536a <countfree>
    55da:	85aa                	mv	a1,a0
    55dc:	0f455163          	bge	a0,s4,56be <main+0x186>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    55e0:	8652                	mv	a2,s4
    55e2:	00003517          	auipc	a0,0x3
    55e6:	e4650513          	addi	a0,a0,-442 # 8428 <csem_up+0x23f4>
    55ea:	00000097          	auipc	ra,0x0
    55ee:	7d2080e7          	jalr	2002(ra) # 5dbc <printf>
    exit(1);
    55f2:	4505                	li	a0,1
    55f4:	00000097          	auipc	ra,0x0
    55f8:	3f6080e7          	jalr	1014(ra) # 59ea <exit>
    55fc:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    55fe:	00003597          	auipc	a1,0x3
    5602:	dc258593          	addi	a1,a1,-574 # 83c0 <csem_up+0x238c>
    5606:	6488                	ld	a0,8(s1)
    5608:	00000097          	auipc	ra,0x0
    560c:	190080e7          	jalr	400(ra) # 5798 <strcmp>
    5610:	10050563          	beqz	a0,571a <main+0x1e2>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5614:	00003597          	auipc	a1,0x3
    5618:	e9458593          	addi	a1,a1,-364 # 84a8 <csem_up+0x2474>
    561c:	6488                	ld	a0,8(s1)
    561e:	00000097          	auipc	ra,0x0
    5622:	17a080e7          	jalr	378(ra) # 5798 <strcmp>
    5626:	c97d                	beqz	a0,571c <main+0x1e4>
  } else if(argc == 2 && argv[1][0] != '-'){
    5628:	0084b903          	ld	s2,8(s1)
    562c:	00094703          	lbu	a4,0(s2)
    5630:	02d00793          	li	a5,45
    5634:	f2f71de3          	bne	a4,a5,556e <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    5638:	00003517          	auipc	a0,0x3
    563c:	d9050513          	addi	a0,a0,-624 # 83c8 <csem_up+0x2394>
    5640:	00000097          	auipc	ra,0x0
    5644:	77c080e7          	jalr	1916(ra) # 5dbc <printf>
    exit(1);
    5648:	4505                	li	a0,1
    564a:	00000097          	auipc	ra,0x0
    564e:	3a0080e7          	jalr	928(ra) # 59ea <exit>
          exit(1);
    5652:	4505                	li	a0,1
    5654:	00000097          	auipc	ra,0x0
    5658:	396080e7          	jalr	918(ra) # 59ea <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    565c:	40a905bb          	subw	a1,s2,a0
    5660:	855a                	mv	a0,s6
    5662:	00000097          	auipc	ra,0x0
    5666:	75a080e7          	jalr	1882(ra) # 5dbc <printf>
        if(continuous != 2)
    566a:	09498463          	beq	s3,s4,56f2 <main+0x1ba>
          exit(1);
    566e:	4505                	li	a0,1
    5670:	00000097          	auipc	ra,0x0
    5674:	37a080e7          	jalr	890(ra) # 59ea <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    5678:	04c1                	addi	s1,s1,16
    567a:	6488                	ld	a0,8(s1)
    567c:	c115                	beqz	a0,56a0 <main+0x168>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    567e:	00090863          	beqz	s2,568e <main+0x156>
    5682:	85ca                	mv	a1,s2
    5684:	00000097          	auipc	ra,0x0
    5688:	114080e7          	jalr	276(ra) # 5798 <strcmp>
    568c:	f575                	bnez	a0,5678 <main+0x140>
      if(!run(t->f, t->s))
    568e:	648c                	ld	a1,8(s1)
    5690:	6088                	ld	a0,0(s1)
    5692:	00000097          	auipc	ra,0x0
    5696:	e08080e7          	jalr	-504(ra) # 549a <run>
    569a:	fd79                	bnez	a0,5678 <main+0x140>
        fail = 1;
    569c:	89d6                	mv	s3,s5
    569e:	bfe9                	j	5678 <main+0x140>
  if(fail){
    56a0:	f20989e3          	beqz	s3,55d2 <main+0x9a>
    printf("SOME TESTS FAILED\n");
    56a4:	00003517          	auipc	a0,0x3
    56a8:	d6c50513          	addi	a0,a0,-660 # 8410 <csem_up+0x23dc>
    56ac:	00000097          	auipc	ra,0x0
    56b0:	710080e7          	jalr	1808(ra) # 5dbc <printf>
    exit(1);
    56b4:	4505                	li	a0,1
    56b6:	00000097          	auipc	ra,0x0
    56ba:	334080e7          	jalr	820(ra) # 59ea <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    56be:	00003517          	auipc	a0,0x3
    56c2:	d9a50513          	addi	a0,a0,-614 # 8458 <csem_up+0x2424>
    56c6:	00000097          	auipc	ra,0x0
    56ca:	6f6080e7          	jalr	1782(ra) # 5dbc <printf>
    exit(0);
    56ce:	4501                	li	a0,0
    56d0:	00000097          	auipc	ra,0x0
    56d4:	31a080e7          	jalr	794(ra) # 59ea <exit>
        printf("SOME TESTS FAILED\n");
    56d8:	8556                	mv	a0,s5
    56da:	00000097          	auipc	ra,0x0
    56de:	6e2080e7          	jalr	1762(ra) # 5dbc <printf>
        if(continuous != 2)
    56e2:	f74998e3          	bne	s3,s4,5652 <main+0x11a>
      int free1 = countfree();
    56e6:	00000097          	auipc	ra,0x0
    56ea:	c84080e7          	jalr	-892(ra) # 536a <countfree>
      if(free1 < free0){
    56ee:	f72547e3          	blt	a0,s2,565c <main+0x124>
      int free0 = countfree();
    56f2:	00000097          	auipc	ra,0x0
    56f6:	c78080e7          	jalr	-904(ra) # 536a <countfree>
    56fa:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    56fc:	d1843583          	ld	a1,-744(s0)
    5700:	d1fd                	beqz	a1,56e6 <main+0x1ae>
    5702:	d1040493          	addi	s1,s0,-752
        if(!run(t->f, t->s)){
    5706:	6088                	ld	a0,0(s1)
    5708:	00000097          	auipc	ra,0x0
    570c:	d92080e7          	jalr	-622(ra) # 549a <run>
    5710:	d561                	beqz	a0,56d8 <main+0x1a0>
      for (struct test *t = tests; t->s != 0; t++) {
    5712:	04c1                	addi	s1,s1,16
    5714:	648c                	ld	a1,8(s1)
    5716:	f9e5                	bnez	a1,5706 <main+0x1ce>
    5718:	b7f9                	j	56e6 <main+0x1ae>
    continuous = 1;
    571a:	4985                	li	s3,1
  } tests[] = {
    571c:	00003797          	auipc	a5,0x3
    5720:	db478793          	addi	a5,a5,-588 # 84d0 <csem_up+0x249c>
    5724:	d1040713          	addi	a4,s0,-752
    5728:	00003897          	auipc	a7,0x3
    572c:	05088893          	addi	a7,a7,80 # 8778 <csem_up+0x2744>
    5730:	0007b803          	ld	a6,0(a5)
    5734:	6788                	ld	a0,8(a5)
    5736:	6b8c                	ld	a1,16(a5)
    5738:	6f90                	ld	a2,24(a5)
    573a:	7394                	ld	a3,32(a5)
    573c:	01073023          	sd	a6,0(a4)
    5740:	e708                	sd	a0,8(a4)
    5742:	eb0c                	sd	a1,16(a4)
    5744:	ef10                	sd	a2,24(a4)
    5746:	f314                	sd	a3,32(a4)
    5748:	02878793          	addi	a5,a5,40
    574c:	02870713          	addi	a4,a4,40
    5750:	ff1790e3          	bne	a5,a7,5730 <main+0x1f8>
    5754:	639c                	ld	a5,0(a5)
    5756:	e31c                	sd	a5,0(a4)
    printf("continuous usertests starting\n");
    5758:	00003517          	auipc	a0,0x3
    575c:	d3050513          	addi	a0,a0,-720 # 8488 <csem_up+0x2454>
    5760:	00000097          	auipc	ra,0x0
    5764:	65c080e7          	jalr	1628(ra) # 5dbc <printf>
        printf("SOME TESTS FAILED\n");
    5768:	00003a97          	auipc	s5,0x3
    576c:	ca8a8a93          	addi	s5,s5,-856 # 8410 <csem_up+0x23dc>
        if(continuous != 2)
    5770:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5772:	00003b17          	auipc	s6,0x3
    5776:	c7eb0b13          	addi	s6,s6,-898 # 83f0 <csem_up+0x23bc>
    577a:	bfa5                	j	56f2 <main+0x1ba>

000000000000577c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    577c:	1141                	addi	sp,sp,-16
    577e:	e422                	sd	s0,8(sp)
    5780:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5782:	87aa                	mv	a5,a0
    5784:	0585                	addi	a1,a1,1
    5786:	0785                	addi	a5,a5,1
    5788:	fff5c703          	lbu	a4,-1(a1)
    578c:	fee78fa3          	sb	a4,-1(a5)
    5790:	fb75                	bnez	a4,5784 <strcpy+0x8>
    ;
  return os;
}
    5792:	6422                	ld	s0,8(sp)
    5794:	0141                	addi	sp,sp,16
    5796:	8082                	ret

0000000000005798 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5798:	1141                	addi	sp,sp,-16
    579a:	e422                	sd	s0,8(sp)
    579c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    579e:	00054783          	lbu	a5,0(a0)
    57a2:	cb91                	beqz	a5,57b6 <strcmp+0x1e>
    57a4:	0005c703          	lbu	a4,0(a1)
    57a8:	00f71763          	bne	a4,a5,57b6 <strcmp+0x1e>
    p++, q++;
    57ac:	0505                	addi	a0,a0,1
    57ae:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    57b0:	00054783          	lbu	a5,0(a0)
    57b4:	fbe5                	bnez	a5,57a4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    57b6:	0005c503          	lbu	a0,0(a1)
}
    57ba:	40a7853b          	subw	a0,a5,a0
    57be:	6422                	ld	s0,8(sp)
    57c0:	0141                	addi	sp,sp,16
    57c2:	8082                	ret

00000000000057c4 <strlen>:

uint
strlen(const char *s)
{
    57c4:	1141                	addi	sp,sp,-16
    57c6:	e422                	sd	s0,8(sp)
    57c8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    57ca:	00054783          	lbu	a5,0(a0)
    57ce:	cf91                	beqz	a5,57ea <strlen+0x26>
    57d0:	0505                	addi	a0,a0,1
    57d2:	87aa                	mv	a5,a0
    57d4:	4685                	li	a3,1
    57d6:	9e89                	subw	a3,a3,a0
    57d8:	00f6853b          	addw	a0,a3,a5
    57dc:	0785                	addi	a5,a5,1
    57de:	fff7c703          	lbu	a4,-1(a5)
    57e2:	fb7d                	bnez	a4,57d8 <strlen+0x14>
    ;
  return n;
}
    57e4:	6422                	ld	s0,8(sp)
    57e6:	0141                	addi	sp,sp,16
    57e8:	8082                	ret
  for(n = 0; s[n]; n++)
    57ea:	4501                	li	a0,0
    57ec:	bfe5                	j	57e4 <strlen+0x20>

00000000000057ee <memset>:

void*
memset(void *dst, int c, uint n)
{
    57ee:	1141                	addi	sp,sp,-16
    57f0:	e422                	sd	s0,8(sp)
    57f2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    57f4:	ca19                	beqz	a2,580a <memset+0x1c>
    57f6:	87aa                	mv	a5,a0
    57f8:	1602                	slli	a2,a2,0x20
    57fa:	9201                	srli	a2,a2,0x20
    57fc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5800:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5804:	0785                	addi	a5,a5,1
    5806:	fee79de3          	bne	a5,a4,5800 <memset+0x12>
  }
  return dst;
}
    580a:	6422                	ld	s0,8(sp)
    580c:	0141                	addi	sp,sp,16
    580e:	8082                	ret

0000000000005810 <strchr>:

char*
strchr(const char *s, char c)
{
    5810:	1141                	addi	sp,sp,-16
    5812:	e422                	sd	s0,8(sp)
    5814:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5816:	00054783          	lbu	a5,0(a0)
    581a:	cb99                	beqz	a5,5830 <strchr+0x20>
    if(*s == c)
    581c:	00f58763          	beq	a1,a5,582a <strchr+0x1a>
  for(; *s; s++)
    5820:	0505                	addi	a0,a0,1
    5822:	00054783          	lbu	a5,0(a0)
    5826:	fbfd                	bnez	a5,581c <strchr+0xc>
      return (char*)s;
  return 0;
    5828:	4501                	li	a0,0
}
    582a:	6422                	ld	s0,8(sp)
    582c:	0141                	addi	sp,sp,16
    582e:	8082                	ret
  return 0;
    5830:	4501                	li	a0,0
    5832:	bfe5                	j	582a <strchr+0x1a>

0000000000005834 <gets>:

char*
gets(char *buf, int max)
{
    5834:	711d                	addi	sp,sp,-96
    5836:	ec86                	sd	ra,88(sp)
    5838:	e8a2                	sd	s0,80(sp)
    583a:	e4a6                	sd	s1,72(sp)
    583c:	e0ca                	sd	s2,64(sp)
    583e:	fc4e                	sd	s3,56(sp)
    5840:	f852                	sd	s4,48(sp)
    5842:	f456                	sd	s5,40(sp)
    5844:	f05a                	sd	s6,32(sp)
    5846:	ec5e                	sd	s7,24(sp)
    5848:	1080                	addi	s0,sp,96
    584a:	8baa                	mv	s7,a0
    584c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    584e:	892a                	mv	s2,a0
    5850:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5852:	4aa9                	li	s5,10
    5854:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5856:	89a6                	mv	s3,s1
    5858:	2485                	addiw	s1,s1,1
    585a:	0344d863          	bge	s1,s4,588a <gets+0x56>
    cc = read(0, &c, 1);
    585e:	4605                	li	a2,1
    5860:	faf40593          	addi	a1,s0,-81
    5864:	4501                	li	a0,0
    5866:	00000097          	auipc	ra,0x0
    586a:	19c080e7          	jalr	412(ra) # 5a02 <read>
    if(cc < 1)
    586e:	00a05e63          	blez	a0,588a <gets+0x56>
    buf[i++] = c;
    5872:	faf44783          	lbu	a5,-81(s0)
    5876:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    587a:	01578763          	beq	a5,s5,5888 <gets+0x54>
    587e:	0905                	addi	s2,s2,1
    5880:	fd679be3          	bne	a5,s6,5856 <gets+0x22>
  for(i=0; i+1 < max; ){
    5884:	89a6                	mv	s3,s1
    5886:	a011                	j	588a <gets+0x56>
    5888:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    588a:	99de                	add	s3,s3,s7
    588c:	00098023          	sb	zero,0(s3)
  return buf;
}
    5890:	855e                	mv	a0,s7
    5892:	60e6                	ld	ra,88(sp)
    5894:	6446                	ld	s0,80(sp)
    5896:	64a6                	ld	s1,72(sp)
    5898:	6906                	ld	s2,64(sp)
    589a:	79e2                	ld	s3,56(sp)
    589c:	7a42                	ld	s4,48(sp)
    589e:	7aa2                	ld	s5,40(sp)
    58a0:	7b02                	ld	s6,32(sp)
    58a2:	6be2                	ld	s7,24(sp)
    58a4:	6125                	addi	sp,sp,96
    58a6:	8082                	ret

00000000000058a8 <stat>:

int
stat(const char *n, struct stat *st)
{
    58a8:	1101                	addi	sp,sp,-32
    58aa:	ec06                	sd	ra,24(sp)
    58ac:	e822                	sd	s0,16(sp)
    58ae:	e426                	sd	s1,8(sp)
    58b0:	e04a                	sd	s2,0(sp)
    58b2:	1000                	addi	s0,sp,32
    58b4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    58b6:	4581                	li	a1,0
    58b8:	00000097          	auipc	ra,0x0
    58bc:	172080e7          	jalr	370(ra) # 5a2a <open>
  if(fd < 0)
    58c0:	02054563          	bltz	a0,58ea <stat+0x42>
    58c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    58c6:	85ca                	mv	a1,s2
    58c8:	00000097          	auipc	ra,0x0
    58cc:	17a080e7          	jalr	378(ra) # 5a42 <fstat>
    58d0:	892a                	mv	s2,a0
  close(fd);
    58d2:	8526                	mv	a0,s1
    58d4:	00000097          	auipc	ra,0x0
    58d8:	13e080e7          	jalr	318(ra) # 5a12 <close>
  return r;
}
    58dc:	854a                	mv	a0,s2
    58de:	60e2                	ld	ra,24(sp)
    58e0:	6442                	ld	s0,16(sp)
    58e2:	64a2                	ld	s1,8(sp)
    58e4:	6902                	ld	s2,0(sp)
    58e6:	6105                	addi	sp,sp,32
    58e8:	8082                	ret
    return -1;
    58ea:	597d                	li	s2,-1
    58ec:	bfc5                	j	58dc <stat+0x34>

00000000000058ee <atoi>:

int
atoi(const char *s)
{
    58ee:	1141                	addi	sp,sp,-16
    58f0:	e422                	sd	s0,8(sp)
    58f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    58f4:	00054603          	lbu	a2,0(a0)
    58f8:	fd06079b          	addiw	a5,a2,-48
    58fc:	0ff7f793          	andi	a5,a5,255
    5900:	4725                	li	a4,9
    5902:	02f76963          	bltu	a4,a5,5934 <atoi+0x46>
    5906:	86aa                	mv	a3,a0
  n = 0;
    5908:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    590a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    590c:	0685                	addi	a3,a3,1
    590e:	0025179b          	slliw	a5,a0,0x2
    5912:	9fa9                	addw	a5,a5,a0
    5914:	0017979b          	slliw	a5,a5,0x1
    5918:	9fb1                	addw	a5,a5,a2
    591a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    591e:	0006c603          	lbu	a2,0(a3)
    5922:	fd06071b          	addiw	a4,a2,-48
    5926:	0ff77713          	andi	a4,a4,255
    592a:	fee5f1e3          	bgeu	a1,a4,590c <atoi+0x1e>
  return n;
}
    592e:	6422                	ld	s0,8(sp)
    5930:	0141                	addi	sp,sp,16
    5932:	8082                	ret
  n = 0;
    5934:	4501                	li	a0,0
    5936:	bfe5                	j	592e <atoi+0x40>

0000000000005938 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5938:	1141                	addi	sp,sp,-16
    593a:	e422                	sd	s0,8(sp)
    593c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    593e:	02b57463          	bgeu	a0,a1,5966 <memmove+0x2e>
    while(n-- > 0)
    5942:	00c05f63          	blez	a2,5960 <memmove+0x28>
    5946:	1602                	slli	a2,a2,0x20
    5948:	9201                	srli	a2,a2,0x20
    594a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    594e:	872a                	mv	a4,a0
      *dst++ = *src++;
    5950:	0585                	addi	a1,a1,1
    5952:	0705                	addi	a4,a4,1
    5954:	fff5c683          	lbu	a3,-1(a1)
    5958:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    595c:	fee79ae3          	bne	a5,a4,5950 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5960:	6422                	ld	s0,8(sp)
    5962:	0141                	addi	sp,sp,16
    5964:	8082                	ret
    dst += n;
    5966:	00c50733          	add	a4,a0,a2
    src += n;
    596a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    596c:	fec05ae3          	blez	a2,5960 <memmove+0x28>
    5970:	fff6079b          	addiw	a5,a2,-1
    5974:	1782                	slli	a5,a5,0x20
    5976:	9381                	srli	a5,a5,0x20
    5978:	fff7c793          	not	a5,a5
    597c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    597e:	15fd                	addi	a1,a1,-1
    5980:	177d                	addi	a4,a4,-1
    5982:	0005c683          	lbu	a3,0(a1)
    5986:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    598a:	fee79ae3          	bne	a5,a4,597e <memmove+0x46>
    598e:	bfc9                	j	5960 <memmove+0x28>

0000000000005990 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5990:	1141                	addi	sp,sp,-16
    5992:	e422                	sd	s0,8(sp)
    5994:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5996:	ca05                	beqz	a2,59c6 <memcmp+0x36>
    5998:	fff6069b          	addiw	a3,a2,-1
    599c:	1682                	slli	a3,a3,0x20
    599e:	9281                	srli	a3,a3,0x20
    59a0:	0685                	addi	a3,a3,1
    59a2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    59a4:	00054783          	lbu	a5,0(a0)
    59a8:	0005c703          	lbu	a4,0(a1)
    59ac:	00e79863          	bne	a5,a4,59bc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    59b0:	0505                	addi	a0,a0,1
    p2++;
    59b2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    59b4:	fed518e3          	bne	a0,a3,59a4 <memcmp+0x14>
  }
  return 0;
    59b8:	4501                	li	a0,0
    59ba:	a019                	j	59c0 <memcmp+0x30>
      return *p1 - *p2;
    59bc:	40e7853b          	subw	a0,a5,a4
}
    59c0:	6422                	ld	s0,8(sp)
    59c2:	0141                	addi	sp,sp,16
    59c4:	8082                	ret
  return 0;
    59c6:	4501                	li	a0,0
    59c8:	bfe5                	j	59c0 <memcmp+0x30>

00000000000059ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    59ca:	1141                	addi	sp,sp,-16
    59cc:	e406                	sd	ra,8(sp)
    59ce:	e022                	sd	s0,0(sp)
    59d0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    59d2:	00000097          	auipc	ra,0x0
    59d6:	f66080e7          	jalr	-154(ra) # 5938 <memmove>
}
    59da:	60a2                	ld	ra,8(sp)
    59dc:	6402                	ld	s0,0(sp)
    59de:	0141                	addi	sp,sp,16
    59e0:	8082                	ret

00000000000059e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    59e2:	4885                	li	a7,1
 ecall
    59e4:	00000073          	ecall
 ret
    59e8:	8082                	ret

00000000000059ea <exit>:
.global exit
exit:
 li a7, SYS_exit
    59ea:	4889                	li	a7,2
 ecall
    59ec:	00000073          	ecall
 ret
    59f0:	8082                	ret

00000000000059f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
    59f2:	488d                	li	a7,3
 ecall
    59f4:	00000073          	ecall
 ret
    59f8:	8082                	ret

00000000000059fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    59fa:	4891                	li	a7,4
 ecall
    59fc:	00000073          	ecall
 ret
    5a00:	8082                	ret

0000000000005a02 <read>:
.global read
read:
 li a7, SYS_read
    5a02:	4895                	li	a7,5
 ecall
    5a04:	00000073          	ecall
 ret
    5a08:	8082                	ret

0000000000005a0a <write>:
.global write
write:
 li a7, SYS_write
    5a0a:	48c1                	li	a7,16
 ecall
    5a0c:	00000073          	ecall
 ret
    5a10:	8082                	ret

0000000000005a12 <close>:
.global close
close:
 li a7, SYS_close
    5a12:	48d5                	li	a7,21
 ecall
    5a14:	00000073          	ecall
 ret
    5a18:	8082                	ret

0000000000005a1a <kill>:
.global kill
kill:
 li a7, SYS_kill
    5a1a:	4899                	li	a7,6
 ecall
    5a1c:	00000073          	ecall
 ret
    5a20:	8082                	ret

0000000000005a22 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5a22:	489d                	li	a7,7
 ecall
    5a24:	00000073          	ecall
 ret
    5a28:	8082                	ret

0000000000005a2a <open>:
.global open
open:
 li a7, SYS_open
    5a2a:	48bd                	li	a7,15
 ecall
    5a2c:	00000073          	ecall
 ret
    5a30:	8082                	ret

0000000000005a32 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5a32:	48c5                	li	a7,17
 ecall
    5a34:	00000073          	ecall
 ret
    5a38:	8082                	ret

0000000000005a3a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5a3a:	48c9                	li	a7,18
 ecall
    5a3c:	00000073          	ecall
 ret
    5a40:	8082                	ret

0000000000005a42 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5a42:	48a1                	li	a7,8
 ecall
    5a44:	00000073          	ecall
 ret
    5a48:	8082                	ret

0000000000005a4a <link>:
.global link
link:
 li a7, SYS_link
    5a4a:	48cd                	li	a7,19
 ecall
    5a4c:	00000073          	ecall
 ret
    5a50:	8082                	ret

0000000000005a52 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5a52:	48d1                	li	a7,20
 ecall
    5a54:	00000073          	ecall
 ret
    5a58:	8082                	ret

0000000000005a5a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5a5a:	48a5                	li	a7,9
 ecall
    5a5c:	00000073          	ecall
 ret
    5a60:	8082                	ret

0000000000005a62 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5a62:	48a9                	li	a7,10
 ecall
    5a64:	00000073          	ecall
 ret
    5a68:	8082                	ret

0000000000005a6a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5a6a:	48ad                	li	a7,11
 ecall
    5a6c:	00000073          	ecall
 ret
    5a70:	8082                	ret

0000000000005a72 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5a72:	48b1                	li	a7,12
 ecall
    5a74:	00000073          	ecall
 ret
    5a78:	8082                	ret

0000000000005a7a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5a7a:	48b5                	li	a7,13
 ecall
    5a7c:	00000073          	ecall
 ret
    5a80:	8082                	ret

0000000000005a82 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5a82:	48b9                	li	a7,14
 ecall
    5a84:	00000073          	ecall
 ret
    5a88:	8082                	ret

0000000000005a8a <sigprocmask>:
.global sigprocmask
sigprocmask:
 li a7, SYS_sigprocmask
    5a8a:	48d9                	li	a7,22
 ecall
    5a8c:	00000073          	ecall
 ret
    5a90:	8082                	ret

0000000000005a92 <sigaction>:
.global sigaction
sigaction:
 li a7, SYS_sigaction
    5a92:	48dd                	li	a7,23
 ecall
    5a94:	00000073          	ecall
 ret
    5a98:	8082                	ret

0000000000005a9a <sigret>:
.global sigret
sigret:
 li a7, SYS_sigret
    5a9a:	48e1                	li	a7,24
 ecall
    5a9c:	00000073          	ecall
 ret
    5aa0:	8082                	ret

0000000000005aa2 <kthread_create>:
.global kthread_create
kthread_create:
 li a7, SYS_kthread_create
    5aa2:	48e5                	li	a7,25
 ecall
    5aa4:	00000073          	ecall
 ret
    5aa8:	8082                	ret

0000000000005aaa <kthread_id>:
.global kthread_id
kthread_id:
 li a7, SYS_kthread_id
    5aaa:	48e9                	li	a7,26
 ecall
    5aac:	00000073          	ecall
 ret
    5ab0:	8082                	ret

0000000000005ab2 <kthread_exit>:
.global kthread_exit
kthread_exit:
 li a7, SYS_kthread_exit
    5ab2:	48ed                	li	a7,27
 ecall
    5ab4:	00000073          	ecall
 ret
    5ab8:	8082                	ret

0000000000005aba <kthread_join>:
.global kthread_join
kthread_join:
 li a7, SYS_kthread_join
    5aba:	48f1                	li	a7,28
 ecall
    5abc:	00000073          	ecall
 ret
    5ac0:	8082                	ret

0000000000005ac2 <bsem_alloc>:
.global bsem_alloc
bsem_alloc:
 li a7, SYS_bsem_alloc
    5ac2:	48f5                	li	a7,29
 ecall
    5ac4:	00000073          	ecall
 ret
    5ac8:	8082                	ret

0000000000005aca <bsem_free>:
.global bsem_free
bsem_free:
 li a7, SYS_bsem_free
    5aca:	48f9                	li	a7,30
 ecall
    5acc:	00000073          	ecall
 ret
    5ad0:	8082                	ret

0000000000005ad2 <bsem_down>:
.global bsem_down
bsem_down:
 li a7, SYS_bsem_down
    5ad2:	48fd                	li	a7,31
 ecall
    5ad4:	00000073          	ecall
 ret
    5ad8:	8082                	ret

0000000000005ada <bsem_up>:
.global bsem_up
bsem_up:
 li a7, SYS_bsem_up
    5ada:	02000893          	li	a7,32
 ecall
    5ade:	00000073          	ecall
 ret
    5ae2:	8082                	ret

0000000000005ae4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5ae4:	1101                	addi	sp,sp,-32
    5ae6:	ec06                	sd	ra,24(sp)
    5ae8:	e822                	sd	s0,16(sp)
    5aea:	1000                	addi	s0,sp,32
    5aec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5af0:	4605                	li	a2,1
    5af2:	fef40593          	addi	a1,s0,-17
    5af6:	00000097          	auipc	ra,0x0
    5afa:	f14080e7          	jalr	-236(ra) # 5a0a <write>
}
    5afe:	60e2                	ld	ra,24(sp)
    5b00:	6442                	ld	s0,16(sp)
    5b02:	6105                	addi	sp,sp,32
    5b04:	8082                	ret

0000000000005b06 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5b06:	7139                	addi	sp,sp,-64
    5b08:	fc06                	sd	ra,56(sp)
    5b0a:	f822                	sd	s0,48(sp)
    5b0c:	f426                	sd	s1,40(sp)
    5b0e:	f04a                	sd	s2,32(sp)
    5b10:	ec4e                	sd	s3,24(sp)
    5b12:	0080                	addi	s0,sp,64
    5b14:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5b16:	c299                	beqz	a3,5b1c <printint+0x16>
    5b18:	0805c863          	bltz	a1,5ba8 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5b1c:	2581                	sext.w	a1,a1
  neg = 0;
    5b1e:	4881                	li	a7,0
    5b20:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5b24:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5b26:	2601                	sext.w	a2,a2
    5b28:	00003517          	auipc	a0,0x3
    5b2c:	c6050513          	addi	a0,a0,-928 # 8788 <digits>
    5b30:	883a                	mv	a6,a4
    5b32:	2705                	addiw	a4,a4,1
    5b34:	02c5f7bb          	remuw	a5,a1,a2
    5b38:	1782                	slli	a5,a5,0x20
    5b3a:	9381                	srli	a5,a5,0x20
    5b3c:	97aa                	add	a5,a5,a0
    5b3e:	0007c783          	lbu	a5,0(a5)
    5b42:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5b46:	0005879b          	sext.w	a5,a1
    5b4a:	02c5d5bb          	divuw	a1,a1,a2
    5b4e:	0685                	addi	a3,a3,1
    5b50:	fec7f0e3          	bgeu	a5,a2,5b30 <printint+0x2a>
  if(neg)
    5b54:	00088b63          	beqz	a7,5b6a <printint+0x64>
    buf[i++] = '-';
    5b58:	fd040793          	addi	a5,s0,-48
    5b5c:	973e                	add	a4,a4,a5
    5b5e:	02d00793          	li	a5,45
    5b62:	fef70823          	sb	a5,-16(a4)
    5b66:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5b6a:	02e05863          	blez	a4,5b9a <printint+0x94>
    5b6e:	fc040793          	addi	a5,s0,-64
    5b72:	00e78933          	add	s2,a5,a4
    5b76:	fff78993          	addi	s3,a5,-1
    5b7a:	99ba                	add	s3,s3,a4
    5b7c:	377d                	addiw	a4,a4,-1
    5b7e:	1702                	slli	a4,a4,0x20
    5b80:	9301                	srli	a4,a4,0x20
    5b82:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5b86:	fff94583          	lbu	a1,-1(s2)
    5b8a:	8526                	mv	a0,s1
    5b8c:	00000097          	auipc	ra,0x0
    5b90:	f58080e7          	jalr	-168(ra) # 5ae4 <putc>
  while(--i >= 0)
    5b94:	197d                	addi	s2,s2,-1
    5b96:	ff3918e3          	bne	s2,s3,5b86 <printint+0x80>
}
    5b9a:	70e2                	ld	ra,56(sp)
    5b9c:	7442                	ld	s0,48(sp)
    5b9e:	74a2                	ld	s1,40(sp)
    5ba0:	7902                	ld	s2,32(sp)
    5ba2:	69e2                	ld	s3,24(sp)
    5ba4:	6121                	addi	sp,sp,64
    5ba6:	8082                	ret
    x = -xx;
    5ba8:	40b005bb          	negw	a1,a1
    neg = 1;
    5bac:	4885                	li	a7,1
    x = -xx;
    5bae:	bf8d                	j	5b20 <printint+0x1a>

0000000000005bb0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5bb0:	7119                	addi	sp,sp,-128
    5bb2:	fc86                	sd	ra,120(sp)
    5bb4:	f8a2                	sd	s0,112(sp)
    5bb6:	f4a6                	sd	s1,104(sp)
    5bb8:	f0ca                	sd	s2,96(sp)
    5bba:	ecce                	sd	s3,88(sp)
    5bbc:	e8d2                	sd	s4,80(sp)
    5bbe:	e4d6                	sd	s5,72(sp)
    5bc0:	e0da                	sd	s6,64(sp)
    5bc2:	fc5e                	sd	s7,56(sp)
    5bc4:	f862                	sd	s8,48(sp)
    5bc6:	f466                	sd	s9,40(sp)
    5bc8:	f06a                	sd	s10,32(sp)
    5bca:	ec6e                	sd	s11,24(sp)
    5bcc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5bce:	0005c903          	lbu	s2,0(a1)
    5bd2:	18090f63          	beqz	s2,5d70 <vprintf+0x1c0>
    5bd6:	8aaa                	mv	s5,a0
    5bd8:	8b32                	mv	s6,a2
    5bda:	00158493          	addi	s1,a1,1
  state = 0;
    5bde:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5be0:	02500a13          	li	s4,37
      if(c == 'd'){
    5be4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5be8:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5bec:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5bf0:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5bf4:	00003b97          	auipc	s7,0x3
    5bf8:	b94b8b93          	addi	s7,s7,-1132 # 8788 <digits>
    5bfc:	a839                	j	5c1a <vprintf+0x6a>
        putc(fd, c);
    5bfe:	85ca                	mv	a1,s2
    5c00:	8556                	mv	a0,s5
    5c02:	00000097          	auipc	ra,0x0
    5c06:	ee2080e7          	jalr	-286(ra) # 5ae4 <putc>
    5c0a:	a019                	j	5c10 <vprintf+0x60>
    } else if(state == '%'){
    5c0c:	01498f63          	beq	s3,s4,5c2a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5c10:	0485                	addi	s1,s1,1
    5c12:	fff4c903          	lbu	s2,-1(s1)
    5c16:	14090d63          	beqz	s2,5d70 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5c1a:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5c1e:	fe0997e3          	bnez	s3,5c0c <vprintf+0x5c>
      if(c == '%'){
    5c22:	fd479ee3          	bne	a5,s4,5bfe <vprintf+0x4e>
        state = '%';
    5c26:	89be                	mv	s3,a5
    5c28:	b7e5                	j	5c10 <vprintf+0x60>
      if(c == 'd'){
    5c2a:	05878063          	beq	a5,s8,5c6a <vprintf+0xba>
      } else if(c == 'l') {
    5c2e:	05978c63          	beq	a5,s9,5c86 <vprintf+0xd6>
      } else if(c == 'x') {
    5c32:	07a78863          	beq	a5,s10,5ca2 <vprintf+0xf2>
      } else if(c == 'p') {
    5c36:	09b78463          	beq	a5,s11,5cbe <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5c3a:	07300713          	li	a4,115
    5c3e:	0ce78663          	beq	a5,a4,5d0a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5c42:	06300713          	li	a4,99
    5c46:	0ee78e63          	beq	a5,a4,5d42 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5c4a:	11478863          	beq	a5,s4,5d5a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5c4e:	85d2                	mv	a1,s4
    5c50:	8556                	mv	a0,s5
    5c52:	00000097          	auipc	ra,0x0
    5c56:	e92080e7          	jalr	-366(ra) # 5ae4 <putc>
        putc(fd, c);
    5c5a:	85ca                	mv	a1,s2
    5c5c:	8556                	mv	a0,s5
    5c5e:	00000097          	auipc	ra,0x0
    5c62:	e86080e7          	jalr	-378(ra) # 5ae4 <putc>
      }
      state = 0;
    5c66:	4981                	li	s3,0
    5c68:	b765                	j	5c10 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5c6a:	008b0913          	addi	s2,s6,8
    5c6e:	4685                	li	a3,1
    5c70:	4629                	li	a2,10
    5c72:	000b2583          	lw	a1,0(s6)
    5c76:	8556                	mv	a0,s5
    5c78:	00000097          	auipc	ra,0x0
    5c7c:	e8e080e7          	jalr	-370(ra) # 5b06 <printint>
    5c80:	8b4a                	mv	s6,s2
      state = 0;
    5c82:	4981                	li	s3,0
    5c84:	b771                	j	5c10 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5c86:	008b0913          	addi	s2,s6,8
    5c8a:	4681                	li	a3,0
    5c8c:	4629                	li	a2,10
    5c8e:	000b2583          	lw	a1,0(s6)
    5c92:	8556                	mv	a0,s5
    5c94:	00000097          	auipc	ra,0x0
    5c98:	e72080e7          	jalr	-398(ra) # 5b06 <printint>
    5c9c:	8b4a                	mv	s6,s2
      state = 0;
    5c9e:	4981                	li	s3,0
    5ca0:	bf85                	j	5c10 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5ca2:	008b0913          	addi	s2,s6,8
    5ca6:	4681                	li	a3,0
    5ca8:	4641                	li	a2,16
    5caa:	000b2583          	lw	a1,0(s6)
    5cae:	8556                	mv	a0,s5
    5cb0:	00000097          	auipc	ra,0x0
    5cb4:	e56080e7          	jalr	-426(ra) # 5b06 <printint>
    5cb8:	8b4a                	mv	s6,s2
      state = 0;
    5cba:	4981                	li	s3,0
    5cbc:	bf91                	j	5c10 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5cbe:	008b0793          	addi	a5,s6,8
    5cc2:	f8f43423          	sd	a5,-120(s0)
    5cc6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5cca:	03000593          	li	a1,48
    5cce:	8556                	mv	a0,s5
    5cd0:	00000097          	auipc	ra,0x0
    5cd4:	e14080e7          	jalr	-492(ra) # 5ae4 <putc>
  putc(fd, 'x');
    5cd8:	85ea                	mv	a1,s10
    5cda:	8556                	mv	a0,s5
    5cdc:	00000097          	auipc	ra,0x0
    5ce0:	e08080e7          	jalr	-504(ra) # 5ae4 <putc>
    5ce4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5ce6:	03c9d793          	srli	a5,s3,0x3c
    5cea:	97de                	add	a5,a5,s7
    5cec:	0007c583          	lbu	a1,0(a5)
    5cf0:	8556                	mv	a0,s5
    5cf2:	00000097          	auipc	ra,0x0
    5cf6:	df2080e7          	jalr	-526(ra) # 5ae4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5cfa:	0992                	slli	s3,s3,0x4
    5cfc:	397d                	addiw	s2,s2,-1
    5cfe:	fe0914e3          	bnez	s2,5ce6 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5d02:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5d06:	4981                	li	s3,0
    5d08:	b721                	j	5c10 <vprintf+0x60>
        s = va_arg(ap, char*);
    5d0a:	008b0993          	addi	s3,s6,8
    5d0e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5d12:	02090163          	beqz	s2,5d34 <vprintf+0x184>
        while(*s != 0){
    5d16:	00094583          	lbu	a1,0(s2)
    5d1a:	c9a1                	beqz	a1,5d6a <vprintf+0x1ba>
          putc(fd, *s);
    5d1c:	8556                	mv	a0,s5
    5d1e:	00000097          	auipc	ra,0x0
    5d22:	dc6080e7          	jalr	-570(ra) # 5ae4 <putc>
          s++;
    5d26:	0905                	addi	s2,s2,1
        while(*s != 0){
    5d28:	00094583          	lbu	a1,0(s2)
    5d2c:	f9e5                	bnez	a1,5d1c <vprintf+0x16c>
        s = va_arg(ap, char*);
    5d2e:	8b4e                	mv	s6,s3
      state = 0;
    5d30:	4981                	li	s3,0
    5d32:	bdf9                	j	5c10 <vprintf+0x60>
          s = "(null)";
    5d34:	00003917          	auipc	s2,0x3
    5d38:	a4c90913          	addi	s2,s2,-1460 # 8780 <csem_up+0x274c>
        while(*s != 0){
    5d3c:	02800593          	li	a1,40
    5d40:	bff1                	j	5d1c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5d42:	008b0913          	addi	s2,s6,8
    5d46:	000b4583          	lbu	a1,0(s6)
    5d4a:	8556                	mv	a0,s5
    5d4c:	00000097          	auipc	ra,0x0
    5d50:	d98080e7          	jalr	-616(ra) # 5ae4 <putc>
    5d54:	8b4a                	mv	s6,s2
      state = 0;
    5d56:	4981                	li	s3,0
    5d58:	bd65                	j	5c10 <vprintf+0x60>
        putc(fd, c);
    5d5a:	85d2                	mv	a1,s4
    5d5c:	8556                	mv	a0,s5
    5d5e:	00000097          	auipc	ra,0x0
    5d62:	d86080e7          	jalr	-634(ra) # 5ae4 <putc>
      state = 0;
    5d66:	4981                	li	s3,0
    5d68:	b565                	j	5c10 <vprintf+0x60>
        s = va_arg(ap, char*);
    5d6a:	8b4e                	mv	s6,s3
      state = 0;
    5d6c:	4981                	li	s3,0
    5d6e:	b54d                	j	5c10 <vprintf+0x60>
    }
  }
}
    5d70:	70e6                	ld	ra,120(sp)
    5d72:	7446                	ld	s0,112(sp)
    5d74:	74a6                	ld	s1,104(sp)
    5d76:	7906                	ld	s2,96(sp)
    5d78:	69e6                	ld	s3,88(sp)
    5d7a:	6a46                	ld	s4,80(sp)
    5d7c:	6aa6                	ld	s5,72(sp)
    5d7e:	6b06                	ld	s6,64(sp)
    5d80:	7be2                	ld	s7,56(sp)
    5d82:	7c42                	ld	s8,48(sp)
    5d84:	7ca2                	ld	s9,40(sp)
    5d86:	7d02                	ld	s10,32(sp)
    5d88:	6de2                	ld	s11,24(sp)
    5d8a:	6109                	addi	sp,sp,128
    5d8c:	8082                	ret

0000000000005d8e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5d8e:	715d                	addi	sp,sp,-80
    5d90:	ec06                	sd	ra,24(sp)
    5d92:	e822                	sd	s0,16(sp)
    5d94:	1000                	addi	s0,sp,32
    5d96:	e010                	sd	a2,0(s0)
    5d98:	e414                	sd	a3,8(s0)
    5d9a:	e818                	sd	a4,16(s0)
    5d9c:	ec1c                	sd	a5,24(s0)
    5d9e:	03043023          	sd	a6,32(s0)
    5da2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5da6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5daa:	8622                	mv	a2,s0
    5dac:	00000097          	auipc	ra,0x0
    5db0:	e04080e7          	jalr	-508(ra) # 5bb0 <vprintf>
}
    5db4:	60e2                	ld	ra,24(sp)
    5db6:	6442                	ld	s0,16(sp)
    5db8:	6161                	addi	sp,sp,80
    5dba:	8082                	ret

0000000000005dbc <printf>:

void
printf(const char *fmt, ...)
{
    5dbc:	711d                	addi	sp,sp,-96
    5dbe:	ec06                	sd	ra,24(sp)
    5dc0:	e822                	sd	s0,16(sp)
    5dc2:	1000                	addi	s0,sp,32
    5dc4:	e40c                	sd	a1,8(s0)
    5dc6:	e810                	sd	a2,16(s0)
    5dc8:	ec14                	sd	a3,24(s0)
    5dca:	f018                	sd	a4,32(s0)
    5dcc:	f41c                	sd	a5,40(s0)
    5dce:	03043823          	sd	a6,48(s0)
    5dd2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5dd6:	00840613          	addi	a2,s0,8
    5dda:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5dde:	85aa                	mv	a1,a0
    5de0:	4505                	li	a0,1
    5de2:	00000097          	auipc	ra,0x0
    5de6:	dce080e7          	jalr	-562(ra) # 5bb0 <vprintf>
}
    5dea:	60e2                	ld	ra,24(sp)
    5dec:	6442                	ld	s0,16(sp)
    5dee:	6125                	addi	sp,sp,96
    5df0:	8082                	ret

0000000000005df2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5df2:	1141                	addi	sp,sp,-16
    5df4:	e422                	sd	s0,8(sp)
    5df6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5df8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5dfc:	00003797          	auipc	a5,0x3
    5e00:	9bc7b783          	ld	a5,-1604(a5) # 87b8 <freep>
    5e04:	a805                	j	5e34 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5e06:	4618                	lw	a4,8(a2)
    5e08:	9db9                	addw	a1,a1,a4
    5e0a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5e0e:	6398                	ld	a4,0(a5)
    5e10:	6318                	ld	a4,0(a4)
    5e12:	fee53823          	sd	a4,-16(a0)
    5e16:	a091                	j	5e5a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5e18:	ff852703          	lw	a4,-8(a0)
    5e1c:	9e39                	addw	a2,a2,a4
    5e1e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5e20:	ff053703          	ld	a4,-16(a0)
    5e24:	e398                	sd	a4,0(a5)
    5e26:	a099                	j	5e6c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5e28:	6398                	ld	a4,0(a5)
    5e2a:	00e7e463          	bltu	a5,a4,5e32 <free+0x40>
    5e2e:	00e6ea63          	bltu	a3,a4,5e42 <free+0x50>
{
    5e32:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5e34:	fed7fae3          	bgeu	a5,a3,5e28 <free+0x36>
    5e38:	6398                	ld	a4,0(a5)
    5e3a:	00e6e463          	bltu	a3,a4,5e42 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5e3e:	fee7eae3          	bltu	a5,a4,5e32 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5e42:	ff852583          	lw	a1,-8(a0)
    5e46:	6390                	ld	a2,0(a5)
    5e48:	02059813          	slli	a6,a1,0x20
    5e4c:	01c85713          	srli	a4,a6,0x1c
    5e50:	9736                	add	a4,a4,a3
    5e52:	fae60ae3          	beq	a2,a4,5e06 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5e56:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5e5a:	4790                	lw	a2,8(a5)
    5e5c:	02061593          	slli	a1,a2,0x20
    5e60:	01c5d713          	srli	a4,a1,0x1c
    5e64:	973e                	add	a4,a4,a5
    5e66:	fae689e3          	beq	a3,a4,5e18 <free+0x26>
  } else
    p->s.ptr = bp;
    5e6a:	e394                	sd	a3,0(a5)
  freep = p;
    5e6c:	00003717          	auipc	a4,0x3
    5e70:	94f73623          	sd	a5,-1716(a4) # 87b8 <freep>
}
    5e74:	6422                	ld	s0,8(sp)
    5e76:	0141                	addi	sp,sp,16
    5e78:	8082                	ret

0000000000005e7a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5e7a:	7139                	addi	sp,sp,-64
    5e7c:	fc06                	sd	ra,56(sp)
    5e7e:	f822                	sd	s0,48(sp)
    5e80:	f426                	sd	s1,40(sp)
    5e82:	f04a                	sd	s2,32(sp)
    5e84:	ec4e                	sd	s3,24(sp)
    5e86:	e852                	sd	s4,16(sp)
    5e88:	e456                	sd	s5,8(sp)
    5e8a:	e05a                	sd	s6,0(sp)
    5e8c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5e8e:	02051493          	slli	s1,a0,0x20
    5e92:	9081                	srli	s1,s1,0x20
    5e94:	04bd                	addi	s1,s1,15
    5e96:	8091                	srli	s1,s1,0x4
    5e98:	0014899b          	addiw	s3,s1,1
    5e9c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5e9e:	00003517          	auipc	a0,0x3
    5ea2:	91a53503          	ld	a0,-1766(a0) # 87b8 <freep>
    5ea6:	c515                	beqz	a0,5ed2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5ea8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5eaa:	4798                	lw	a4,8(a5)
    5eac:	02977f63          	bgeu	a4,s1,5eea <malloc+0x70>
    5eb0:	8a4e                	mv	s4,s3
    5eb2:	0009871b          	sext.w	a4,s3
    5eb6:	6685                	lui	a3,0x1
    5eb8:	00d77363          	bgeu	a4,a3,5ebe <malloc+0x44>
    5ebc:	6a05                	lui	s4,0x1
    5ebe:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5ec2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5ec6:	00003917          	auipc	s2,0x3
    5eca:	8f290913          	addi	s2,s2,-1806 # 87b8 <freep>
  if(p == (char*)-1)
    5ece:	5afd                	li	s5,-1
    5ed0:	a895                	j	5f44 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    5ed2:	00009797          	auipc	a5,0x9
    5ed6:	10678793          	addi	a5,a5,262 # efd8 <base>
    5eda:	00003717          	auipc	a4,0x3
    5ede:	8cf73f23          	sd	a5,-1826(a4) # 87b8 <freep>
    5ee2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5ee4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5ee8:	b7e1                	j	5eb0 <malloc+0x36>
      if(p->s.size == nunits)
    5eea:	02e48c63          	beq	s1,a4,5f22 <malloc+0xa8>
        p->s.size -= nunits;
    5eee:	4137073b          	subw	a4,a4,s3
    5ef2:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5ef4:	02071693          	slli	a3,a4,0x20
    5ef8:	01c6d713          	srli	a4,a3,0x1c
    5efc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5efe:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5f02:	00003717          	auipc	a4,0x3
    5f06:	8aa73b23          	sd	a0,-1866(a4) # 87b8 <freep>
      return (void*)(p + 1);
    5f0a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5f0e:	70e2                	ld	ra,56(sp)
    5f10:	7442                	ld	s0,48(sp)
    5f12:	74a2                	ld	s1,40(sp)
    5f14:	7902                	ld	s2,32(sp)
    5f16:	69e2                	ld	s3,24(sp)
    5f18:	6a42                	ld	s4,16(sp)
    5f1a:	6aa2                	ld	s5,8(sp)
    5f1c:	6b02                	ld	s6,0(sp)
    5f1e:	6121                	addi	sp,sp,64
    5f20:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5f22:	6398                	ld	a4,0(a5)
    5f24:	e118                	sd	a4,0(a0)
    5f26:	bff1                	j	5f02 <malloc+0x88>
  hp->s.size = nu;
    5f28:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5f2c:	0541                	addi	a0,a0,16
    5f2e:	00000097          	auipc	ra,0x0
    5f32:	ec4080e7          	jalr	-316(ra) # 5df2 <free>
  return freep;
    5f36:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5f3a:	d971                	beqz	a0,5f0e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5f3c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5f3e:	4798                	lw	a4,8(a5)
    5f40:	fa9775e3          	bgeu	a4,s1,5eea <malloc+0x70>
    if(p == freep)
    5f44:	00093703          	ld	a4,0(s2)
    5f48:	853e                	mv	a0,a5
    5f4a:	fef719e3          	bne	a4,a5,5f3c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    5f4e:	8552                	mv	a0,s4
    5f50:	00000097          	auipc	ra,0x0
    5f54:	b22080e7          	jalr	-1246(ra) # 5a72 <sbrk>
  if(p == (char*)-1)
    5f58:	fd5518e3          	bne	a0,s5,5f28 <malloc+0xae>
        return 0;
    5f5c:	4501                	li	a0,0
    5f5e:	bf45                	j	5f0e <malloc+0x94>

0000000000005f60 <csem_alloc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int csem_alloc(struct counting_semaphore *sem, int initial_value){
    5f60:	1101                	addi	sp,sp,-32
    5f62:	ec06                	sd	ra,24(sp)
    5f64:	e822                	sd	s0,16(sp)
    5f66:	e426                	sd	s1,8(sp)
    5f68:	e04a                	sd	s2,0(sp)
    5f6a:	1000                	addi	s0,sp,32
    5f6c:	84aa                	mv	s1,a0
    5f6e:	892e                	mv	s2,a1
    sem->binary_semaphore1 = bsem_alloc();
    5f70:	00000097          	auipc	ra,0x0
    5f74:	b52080e7          	jalr	-1198(ra) # 5ac2 <bsem_alloc>
    5f78:	c088                	sw	a0,0(s1)
    sem->binary_semaphore2 = bsem_alloc();
    5f7a:	00000097          	auipc	ra,0x0
    5f7e:	b48080e7          	jalr	-1208(ra) # 5ac2 <bsem_alloc>
    5f82:	87aa                	mv	a5,a0
    5f84:	c0c8                	sw	a0,4(s1)
    if(sem->binary_semaphore1 == -1 || sem->binary_semaphore2 == -1)
    5f86:	4088                	lw	a0,0(s1)
    5f88:	577d                	li	a4,-1
    5f8a:	00e50963          	beq	a0,a4,5f9c <csem_alloc+0x3c>
    5f8e:	02e78363          	beq	a5,a4,5fb4 <csem_alloc+0x54>
        return -1;
    if(initial_value == 0)
    5f92:	00090b63          	beqz	s2,5fa8 <csem_alloc+0x48>
        bsem_down(sem->binary_semaphore2);
    sem->value = initial_value;
    5f96:	0124a423          	sw	s2,8(s1)
    return 0;
    5f9a:	4501                	li	a0,0
}
    5f9c:	60e2                	ld	ra,24(sp)
    5f9e:	6442                	ld	s0,16(sp)
    5fa0:	64a2                	ld	s1,8(sp)
    5fa2:	6902                	ld	s2,0(sp)
    5fa4:	6105                	addi	sp,sp,32
    5fa6:	8082                	ret
        bsem_down(sem->binary_semaphore2);
    5fa8:	853e                	mv	a0,a5
    5faa:	00000097          	auipc	ra,0x0
    5fae:	b28080e7          	jalr	-1240(ra) # 5ad2 <bsem_down>
    5fb2:	b7d5                	j	5f96 <csem_alloc+0x36>
        return -1;
    5fb4:	853e                	mv	a0,a5
    5fb6:	b7dd                	j	5f9c <csem_alloc+0x3c>

0000000000005fb8 <csem_free>:

void csem_free(struct counting_semaphore *sem){
    5fb8:	1101                	addi	sp,sp,-32
    5fba:	ec06                	sd	ra,24(sp)
    5fbc:	e822                	sd	s0,16(sp)
    5fbe:	e426                	sd	s1,8(sp)
    5fc0:	1000                	addi	s0,sp,32
    5fc2:	84aa                	mv	s1,a0
    bsem_free(sem->binary_semaphore1);
    5fc4:	4108                	lw	a0,0(a0)
    5fc6:	00000097          	auipc	ra,0x0
    5fca:	b04080e7          	jalr	-1276(ra) # 5aca <bsem_free>
    bsem_free(sem->binary_semaphore2);
    5fce:	40c8                	lw	a0,4(s1)
    5fd0:	00000097          	auipc	ra,0x0
    5fd4:	afa080e7          	jalr	-1286(ra) # 5aca <bsem_free>
    sem->value = 0;
    5fd8:	0004a423          	sw	zero,8(s1)
}
    5fdc:	60e2                	ld	ra,24(sp)
    5fde:	6442                	ld	s0,16(sp)
    5fe0:	64a2                	ld	s1,8(sp)
    5fe2:	6105                	addi	sp,sp,32
    5fe4:	8082                	ret

0000000000005fe6 <csem_down>:

void csem_down(struct counting_semaphore *sem){
    5fe6:	1101                	addi	sp,sp,-32
    5fe8:	ec06                	sd	ra,24(sp)
    5fea:	e822                	sd	s0,16(sp)
    5fec:	e426                	sd	s1,8(sp)
    5fee:	1000                	addi	s0,sp,32
    5ff0:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore2);
    5ff2:	4148                	lw	a0,4(a0)
    5ff4:	00000097          	auipc	ra,0x0
    5ff8:	ade080e7          	jalr	-1314(ra) # 5ad2 <bsem_down>
    bsem_down(sem->binary_semaphore1);
    5ffc:	4088                	lw	a0,0(s1)
    5ffe:	00000097          	auipc	ra,0x0
    6002:	ad4080e7          	jalr	-1324(ra) # 5ad2 <bsem_down>
    sem->value--;
    6006:	449c                	lw	a5,8(s1)
    6008:	37fd                	addiw	a5,a5,-1
    600a:	0007871b          	sext.w	a4,a5
    600e:	c49c                	sw	a5,8(s1)
    if(sem->value > 0)
    6010:	00e04c63          	bgtz	a4,6028 <csem_down+0x42>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
    6014:	4088                	lw	a0,0(s1)
    6016:	00000097          	auipc	ra,0x0
    601a:	ac4080e7          	jalr	-1340(ra) # 5ada <bsem_up>
}
    601e:	60e2                	ld	ra,24(sp)
    6020:	6442                	ld	s0,16(sp)
    6022:	64a2                	ld	s1,8(sp)
    6024:	6105                	addi	sp,sp,32
    6026:	8082                	ret
        bsem_up(sem->binary_semaphore2);
    6028:	40c8                	lw	a0,4(s1)
    602a:	00000097          	auipc	ra,0x0
    602e:	ab0080e7          	jalr	-1360(ra) # 5ada <bsem_up>
    6032:	b7cd                	j	6014 <csem_down+0x2e>

0000000000006034 <csem_up>:

void csem_up(struct counting_semaphore *sem){
    6034:	1101                	addi	sp,sp,-32
    6036:	ec06                	sd	ra,24(sp)
    6038:	e822                	sd	s0,16(sp)
    603a:	e426                	sd	s1,8(sp)
    603c:	1000                	addi	s0,sp,32
    603e:	84aa                	mv	s1,a0
    bsem_down(sem->binary_semaphore1);
    6040:	4108                	lw	a0,0(a0)
    6042:	00000097          	auipc	ra,0x0
    6046:	a90080e7          	jalr	-1392(ra) # 5ad2 <bsem_down>
    sem->value++;
    604a:	449c                	lw	a5,8(s1)
    604c:	2785                	addiw	a5,a5,1
    604e:	0007871b          	sext.w	a4,a5
    6052:	c49c                	sw	a5,8(s1)
    if(sem->value == 1)
    6054:	4785                	li	a5,1
    6056:	00f70c63          	beq	a4,a5,606e <csem_up+0x3a>
        bsem_up(sem->binary_semaphore2);
    bsem_up(sem->binary_semaphore1);
    605a:	4088                	lw	a0,0(s1)
    605c:	00000097          	auipc	ra,0x0
    6060:	a7e080e7          	jalr	-1410(ra) # 5ada <bsem_up>
    6064:	60e2                	ld	ra,24(sp)
    6066:	6442                	ld	s0,16(sp)
    6068:	64a2                	ld	s1,8(sp)
    606a:	6105                	addi	sp,sp,32
    606c:	8082                	ret
        bsem_up(sem->binary_semaphore2);
    606e:	40c8                	lw	a0,4(s1)
    6070:	00000097          	auipc	ra,0x0
    6074:	a6a080e7          	jalr	-1430(ra) # 5ada <bsem_up>
    6078:	b7cd                	j	605a <csem_up+0x26>
