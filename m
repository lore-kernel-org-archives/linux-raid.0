From: ilya@theIlya.com
Subject: Oops when doing mount on RAID-1 md
Date: Wed, 30 Oct 2002 17:54:42 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210301749470.14851-100000@ns2.total-knowledge.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,
I am getting Oops, when mounting newly created /dev/md0

alpha:~# uname -a
Linux alpha 2.4.20-pre9 #1 Tue Oct 8 11:45:27 PDT 2002 alpha unknown

alpha:~# cat</proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 sdc1[1] sdb1[0]
      17912384 blocks [2/2] [UU]

unused devices: <none>

alpha:~# cat</proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: COMPAQ   Model: BB00921B91       Rev: 3B05
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 04 Lun: 00
  Vendor: SEAGATE  Model: ST318452LW       Rev: 0004
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 12 Lun: 00
  Vendor: SEAGATE  Model: ST318452LW       Rev: 0004
  Type:   Direct-Access                    ANSI SCSI revision: 03

alpha:~# cat<oops.results
ksymoops 2.4.7 on alpha 2.4.20-pre9.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.4.20-pre9/ (default)
     -m /usr/src/linux/System.map (default)

mount(11398): Oops 0
pc = [raid1_read_balance+372/512]  ra = [raid1_make_request+460/1120]  ps
= 0000    Not tainted
v0 = fffffc0003591018  t0 = fffffffffffffffc  t1 = 0000000000000004
t2 = ffff70000ad64900  t3 = ffff6c000e2f58f8  t4 = ffff6c000e2f58fc
t5 = 0000000000000000  t6 = ffff6c000e2f58f4  t7 = fffffc000a218000
s0 = fffffc0000bd92e8  s1 = 0000000000000900  s2 = fffffc0003591000
s3 = fffffc00023c8100  s4 = fffffc0000bd92c0  s5 = 0000000000000000
s6 = fffffc00039bd4c0
a0 = fffffc0003591000  a1 = fffffc00023c8100  a2 = fffffc00023c8100
a3 = 0000000000001000  a4 = 0000000000000008  a5 = fffffc00004d1040
t8 = 0000000000000001  t9 = 0000000000000004  t10= fffffc0003591020
t11= fffffc000359101c  pv = fffffc00004074c0  at = 0000000000000000
gp = fffffc000053f6a8  sp = fffffc000a21bbb8
Trace:fffffc000040a1d0 fffffc000033a184 fffffc0000351240 fffffc00003d7a04
fffffc00003d7ae4 fffffc00003d7d5c fffffc0000350ed8 fffffc00003a53e0
fffffc0000356088 fffffc00003563e8 fffffc00003563bc fffffc000036f828
fffffc000036fc5c fffffc0000370230 fffffc0000370210 fffffc0000310c80
Code: 40780405  a2d003d8  40a49525  40e49527  40849524  42c03136
<a0250000> f420000c
Using defaults from ksymoops -t elf64-alpha -a alpha


Trace; fffffc000040a1d0 <md_make_request+90/120>
Trace; fffffc000033a184 <find_or_create_page+a4/180>
Trace; fffffc0000351240 <create_buffers+80/140>
Trace; fffffc00003d7a04 <generic_make_request+1e4/220>
Trace; fffffc00003d7ae4 <submit_bh+a4/100>
Trace; fffffc00003d7d5c <ll_rw_block+21c/2e0>
Trace; fffffc0000350ed8 <bread+38/80>
Trace; fffffc00003a53e0 <ext2_read_super+380/ae0>
Trace; fffffc0000356088 <get_sb_bdev+248/320>
Trace; fffffc00003563e8 <do_kern_mount+88/1e0>
Trace; fffffc00003563bc <do_kern_mount+5c/1e0>
Trace; fffffc000036f828 <do_add_mount+c8/220>
Trace; fffffc000036fc5c <do_mount+19c/1e0>
Trace; fffffc0000370230 <sys_mount+b0/140>
Trace; fffffc0000370210 <sys_mount+90/140>
Trace; fffffc0000310c80 <entSys+a8/c0>

Code;  ffffffffffffffe8 <END_OF_CODE+3ffd51ae9/????>
0000000000000000 <_PC>:
Code;  ffffffffffffffe8 <END_OF_CODE+3ffd51ae9/????>
   0:   05 04 78 40       addq t2,t10,t4
Code;  ffffffffffffffec <END_OF_CODE+3ffd51aed/????>
   4:   d8 03 d0 a2       ldl  t8,984(a0)
Code;  fffffffffffffff0 <END_OF_CODE+3ffd51af1/????>
   8:   25 95 a4 40       subq t4,0x24,t4
Code;  fffffffffffffff4 <END_OF_CODE+3ffd51af5/????>
   c:   27 95 e4 40       subq t6,0x24,t6
Code;  fffffffffffffff8 <END_OF_CODE+3ffd51af9/????>
  10:   24 95 84 40       subq t3,0x24,t3
Code;  fffffffffffffffc <END_OF_CODE+3ffd51afd/????>
  14:   36 31 c0 42       subl t8,0x1,t8
Code;  0000000000000000 Before first symbol
  18:   00 00 25 a0       ldl  t0,0(t4)
Code;  0000000000000004 Before first symbol
  1c:   0c 00 20 f4       bne  t0,50 <_PC+0x50> 0000000000000038 Before
first symbol



- --------------------------------------------
Ilya Volynets
Chief Technology Officer
Total Knowledge
http://www.total-knowledge.com/
|===|
|?!.|
|===|
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)
Comment: pgpenvelope 2.9.0 - http://pgpenvelope.sourceforge.net/

iD8DBQE9wI1s84S94bALfyURAp4zAKCDJUBYmx0cRSFC4cPKcI+1IRz2ogCg74yo
cj9ajy/mMtkcHBZM7jOTEOk=
=bDti
-----END PGP SIGNATURE-----

