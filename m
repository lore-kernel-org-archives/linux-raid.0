From: Andrew Beresford <beezly@beezly.org.uk>
Subject: raid1 oops in raid1_read_balance on Sparc64
Date: Thu, 25 Apr 2002 00:14:06 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020424231406.GD8249@monkey.beezly.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: mingo@redhat.com, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been trying to get my sparc64 machine to use raid1 but each time I
set up the md config with one good disk and one failed disk (so I can
get the data off the "failed" disk and into the md device before I do a
raidhotadd) I get the following oops (after ksymoops mangling)

The kernel is 2.4.19-pre7. md and raid1 are compiled as modules. If any more information is needed please don't hesitate to contact me.

 \|/ ____ \|/
 "@'/ .. \`@"
 /_| \__/ |_\
    \__U_/
                                      CPU[0]: local_irq_count[0]
irqs_running[0]
                                      TSTATE: 0000004411009602 TPC:
0000000002014dbc TNPC: 0000000002014dc0 Y: 07000000    Not tainted
Using defaults from ksymoops -t elf32-sparc -a sparc
                                      g0: fffff800038aabf1 g1:
fffff80013087818 g2: 0000000000000001 g3: ffffffffffffffd0
                                      g4: fffff80000000000 g5:
fffee0006b634600 g6: fffff800038a8000 g7: 0000000000000000
                                      o0: 0000000000000ed8 o1:
fffff8001308781c o2: fffff80013859bc0 o3: fffff80002fba580
                                      o4: 0000000000000008 o5:
00000000006b7e20 sp: fffff800038aac41 ret_pc: fffff80013087820
                                      l0: fffff80013087800 l1:
fffff80013087c48 l2: 00000000005eec00 l3: fffff80013087c18
                                      l4: 0000000000000002 l5:
00000000000002b9 l6: 0000000070053130 l7: 00000000700283a8
                                      i0: 0000000000000030 i1:
fffee0006b6345dc i2: 0000000000000000 i3: 0000000000000000
                                      i4: 0000000000000002 i5:
fffff80013087800 i6: fffff800038aad01 i7: 0000000002014fd0
                                      Caller[0000000002014fd0]
                                      Caller[00000000020003c0]
                                      Caller[0000000000503f70]
                                      Caller[000000000050406c]
                                      Caller[0000000000504250]
                                      Caller[00000000004a04f8]
                                      Caller[00000000004a077c]
                                      Caller[0000000000477190]
                                      Caller[0000000000477d6c]
                                      Caller[00000000004780ac]
                                      Caller[0000000000478708]
                                      Caller[000000000047402c]
                                      Caller[00000000004112f4]
                                      Caller[0000000070120c8c]
                                      Instruction DUMP: f84763d8
b2067fdc  84073fff <c606400f> 80a0e000  12480013  b938a000  c4064009
80a0a000 


>>PC;  02014dbc <[raid1]raid1_read_balance+19c/240>   <=====

>>g0; fffff800038aabf1 <END_OF_CODE+fffff8000188dfae/????>
>>g1; fffff80013087818 <END_OF_CODE+fffff8001106abd5/????>
>>g3; ffffffffffffffd0 <END_OF_CODE+fffffffffdfe338d/????>
>>g4; fffff80000000000 <END_OF_CODE+fffff7fffdfe33bd/????>
>>g5; fffee0006b634600 <END_OF_CODE+fffee000696179bd/????>
>>g6; fffff800038a8000 <END_OF_CODE+fffff8000188b3bd/????>
>>o0; 00000ed8 Before first symbol
>>o1; fffff8001308781c <END_OF_CODE+fffff8001106abd9/????>
>>o2; fffff80013859bc0 <END_OF_CODE+fffff8001183cf7d/????>
>>o3; fffff80002fba580 <END_OF_CODE+fffff80000f9d93d/????>
>>o5; 006b7e20 <inactive_list+0/10>
>>sp; fffff800038aac41 <END_OF_CODE+fffff8000188dffe/????>
>>ret_pc; fffff80013087820 <END_OF_CODE+fffff8001106abdd/????>
>>l0; fffff80013087800 <END_OF_CODE+fffff8001106abbd/????>
>>l1; fffff80013087c48 <END_OF_CODE+fffff8001106b005/????>
>>l2; 005eec00 <sysrq_reboot_op+10/18>
>>l3; fffff80013087c18 <END_OF_CODE+fffff8001106afd5/????>
>>l6; 70053130 <END_OF_CODE+6e0364ed/????>
>>l7; 700283a8 <END_OF_CODE+6e00b765/????>
>>i1; fffee0006b6345dc <END_OF_CODE+fffee00069617999/????>
>>i5; fffff80013087800 <END_OF_CODE+fffff8001106abbd/????>
>>i6; fffff800038aad01 <END_OF_CODE+fffff8000188e0be/????>
>>i7; 02014fd0 <[raid1]raid1_make_request+170/3a0>

Trace; 02014fd0 <[raid1]raid1_make_request+170/3a0>
Trace; 020003c0 <[md]md_make_request+40/a0>
Trace; 00503f70 <generic_make_request+d0/180>
Trace; 0050406c <submit_bh+4c/a0>
Trace; 00504250 <ll_rw_block+190/220>
Trace; 004a04f8 <ext3_find_entry+b8/320>
Trace; 004a077c <ext3_lookup+1c/c0>
Trace; 00477190 <real_lookup+90/180>
Trace; 00477d6c <link_path_walk+90c/c40>
Trace; 004780ac <path_walk+c/20>
Trace; 00478708 <__user_walk+48/80>
Trace; 0047402c <sys_lstat64+c/80>
Trace; 004112f4 <linux_sparc_syscall32+34/40>
Trace; 70120c8c <END_OF_CODE+6e104049/????>

Code;  02014db0 <[raid1]raid1_read_balance+190/240>
00000000 <_PC>:
Code;  02014db0 <[raid1]raid1_read_balance+190/240>
   0:   f8 47 63 d8       unknown
Code;  02014db4 <[raid1]raid1_read_balance+194/240>
   4:   b2 06 7f dc       add  %i1, -36, %i1
Code;  02014db8 <[raid1]raid1_read_balance+198/240>
   8:   84 07 3f ff       add  %i4, -1, %g2
Code;  02014dbc <[raid1]raid1_read_balance+19c/240>   <=====
   c:   c6 06 40 0f       ld  [ %i1 + %o7 ], %g3   <=====
Code;  02014dc0 <[raid1]raid1_read_balance+1a0/240>
  10:   80 a0 e0 00       cmp  %g3, 0
Code;  02014dc4 <[raid1]raid1_read_balance+1a4/240>
  14:   12 48 00 13       unknown
Code;  02014dc8 <[raid1]raid1_read_balance+1a8/240>
  18:   b9 38 a0 00       sra  %g2, 0, %i4
Code;  02014dcc <[raid1]raid1_read_balance+1ac/240>
  1c:   c4 06 40 09       ld  [ %i1 + %o1 ], %g2
Code;  02014dd0 <[raid1]raid1_read_balance+1b0/240>
  20:   80 a0 a0 00       cmp  %g2, 0


1 warning issued.  Results may not be reliable.

