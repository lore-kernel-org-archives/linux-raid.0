From: "Tomas Vondra" <wondra@volny.cz>
Subject: Bug in kernel 2.2.14
Date: Sun, 9 Nov 2003 21:24:00 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <002801c3a6ff$6981ee60$0100a8c0@trosc>
Reply-To: "Tomas Vondra" <wondra@volny.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0025_01C3A707.CA9E7DA0"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

------=_NextPart_000_0025_01C3A707.CA9E7DA0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit

I think I've just found a bug in Kernel 2.2.14 found in RedHat distribution.
As this is quite an old version of the RAID drivers, so I merely want to ask
if there is already a patch available.
The problem is: I've got two extended primary partitions with four logical
partitions each.(Experimental setup :-) ). I can add hdb5..12 to a linear
RAID array and it works just fine ( mkraid, raidstart, raidstop), until I
reboot. It's configured with persistent superblocks and kernel autostart.
After the reboot the array is not started and even raidstart doesn't work.
Looks like something wrong is done to the superblocks of the partitions
under the SECOND extended partition. (hdb3). If the array is made of the
partitions under the first extended partition, it works fine. If it's made
of those of the second it doesn't. In the kernel log is the message:
md: bug in file md.c, line 1570
I've included the crash dump, if it can help. I'm not (yet) a programmer
myself.
Thanks for any reply, wondra

------=_NextPart_000_0025_01C3A707.CA9E7DA0
Content-Type: application/octet-stream;
	name="kmsg"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="kmsg"

********=0A=
<4>md0: <hdb12><hdb11><hdb10><hdb9><hdb8><hdb7><hdb6><hdb5> array =
superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:7 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:7 FD:0 SD:0 CSUM:5cd14564 E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb10(3,74),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,[dev 00:00](0,0),R:5,S:9>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4> rdev hdb12: O:hdb12, SZ:00000000 F:0 DN:7 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd14564 E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4> rdev hdb11: O:hdb11, SZ:00000000 F:0 DN:6 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd14561 E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4> rdev hdb10: O:hdb9, SZ:00000000 F:0 DN:4 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd1455b E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:4,hdb10(3,74),R:4,S:6>=0A=
<4> rdev hdb9: O:hdb9, SZ:00000000 F:0 DN:4 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd1455b E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4> rdev hdb8: O:hdb8, SZ:00000000 F:0 DN:3 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd14558 E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4> rdev hdb7: O:hdb7, SZ:00000000 F:0 DN:2 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd14555 E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4> rdev hdb6: O:hdb6, SZ:00000000 F:0 DN:1 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd14552 E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4> rdev hdb5: O:hdb5, SZ:00000000 F:0 DN:0 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd1454f E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>       **********************************=0A=
<4>=0A=
<4>md: bug in file md.c, line 1570=0A=
<4>=0A=
<4>       **********************************=0A=
<4>       * <COMPLETE RAID STATE PRINTOUT> *=0A=
<4>       **********************************=0A=
<4>md0: <hdb12><hdb11><hdb10><hdb9><hdb8><hdb7><hdb6><hdb5> array =
superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:7 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:7 FD:0 SD:0 CSUM:5cd14564 E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb10(3,74),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,[dev 00:00](0,0),R:5,S:9>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4> rdev hdb12: O:hdb12, SZ:00000000 F:0 DN:7 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd14564 E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4> rdev hdb11: O:hdb11, SZ:00000000 F:0 DN:6 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd14561 E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4> rdev hdb10: O:hdb9, SZ:00000000 F:0 DN:4 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd1455b E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:4,hdb10(3,74),R:4,S:6>=0A=
<4> rdev hdb9: O:hdb9, SZ:00000000 F:0 DN:4 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd1455b E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4> rdev hdb8: O:hdb8, SZ:00000000 F:0 DN:3 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd14558 E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4> rdev hdb7: O:hdb7, SZ:00000000 F:0 DN:2 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd14555 E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4> rdev hdb6: O:hdb6, SZ:00000000 F:0 DN:1 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd14552 E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4> rdev hdb5: O:hdb5, SZ:00000000 F:0 DN:0 rdev superblock:=0A=
<4>  SB: (V:0.90.0) ID:<52e70d01.298db1c1.f00d8276.c7c6aef1> CT:3fae51f7=0A=
<4>     L-1 S00016000 ND:8 RD:8 md0 LO:0 CS:8192=0A=
<4>     UT:3fae5221 ST:1 AD:8 WD:8 FD:0 SD:0 CSUM:5cd1454f E:00000002=0A=
<4>     D  0:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>     D  1:  DISK<N:1,hdb6(3,70),R:1,S:6>=0A=
<4>     D  2:  DISK<N:2,hdb7(3,71),R:2,S:6>=0A=
<4>     D  3:  DISK<N:3,hdb8(3,72),R:3,S:6>=0A=
<4>     D  4:  DISK<N:4,hdb9(3,73),R:4,S:6>=0A=
<4>     D  5:  DISK<N:5,hdb10(3,74),R:5,S:6>=0A=
<4>     D  6:  DISK<N:6,hdb11(3,75),R:6,S:6>=0A=
<4>     D  7:  DISK<N:7,hdb12(3,76),R:7,S:6>=0A=
<4>     D  8:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D  9:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 10:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     D 11:  DISK<N:0,[dev 00:00](0,0),R:0,S:0>=0A=
<4>     THIS:  DISK<N:0,hdb5(3,69),R:0,S:6>=0A=
<4>       **********************************=0A=
<4>=0A=
<4>do_md_run() returned -22=0A=
<4>unbind<hdb12,7>=0A=
<4>export_rdev(hdb12)=0A=
<4>unbind<hdb11,6>=0A=
<4>export_rdev(hdb11)=0A=
<4>unbind<hdb10,5>=0A=
<4>export_rdev(hdb10)=0A=
<4>unbind<hdb9,4>=0A=
<4>export_rdev(hdb9)=0A=
<4>unbind<hdb8,3>=0A=
<4>export_rdev(hdb8)=0A=
<4>unbind<hdb7,2>=0A=
<4>export_rdev(hdb7)=0A=
<4>unbind<hdb6,1>=0A=
<4>export_rdev(hdb6)=0A=
<4>unbind<hdb5,0>=0A=
<4>export_rdev(hdb5)=0A=
<6>md0 stopped.=0A=
<4>... autorun DONE.=0A=
<4>VFS: Mounted root (ext2 filesystem) readonly.=0A=
<4>Freeing unused kernel memory: 44k freed=0A=
<6>Adding Swap: 36284k swap-space (priority -1)=0A=
<6>ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996=0A=
<3>[MSS: IRQ Conflict?]=0A=
<6>YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, Rob Hooft =
1993-1996=0A=

------=_NextPart_000_0025_01C3A707.CA9E7DA0--

