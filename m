From: Jarmo =?iso-8859-1?Q?J=E4rvenp=E4=E4?=
	<Jarmo.Jarvenpaa@softers.net>
Subject: raidtools-20010914
Date: Thu, 19 Dec 2002 15:38:32 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E01CBD8.6A18B88F@softers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

- 3 RAID 1 devices with each having 2 partitions mirrored together.
- Kernel 2.4.20

I tried to remove /dev/hda1 from /dev/md0 by using raidhotgenerateerror
and got this:

md: trying to remove hda1 from md0 ...
md: bug in file md.c, line 2341

md:     **********************************
md:     * <COMPLETE RAID STATE PRINTOUT> *
md:     **********************************
md0: <hde1><hda1> array superblock:
md:  SB: (V:0.90.0) ID:<dafb19f4.cc607c07.b72647b4.6f585c6d> CT:3c18a44b
md:     L1 S01024000 ND:3 RD:2 md0 LO:0 CS:8192
md:     UT:3e01dcb3 ST:0 AD:2 WD:2 FD:1 SD:0 CSUM:f12faea4 E:00000050
     D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
     D  1:  DISK<N:1,hde1(33,1),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:1,hde1(33,1),R:1,S:6>
md: rdev hde1: O:hde1, SZ:01024000 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<dafb19f4.cc607c07.b72647b4.6f585c6d> CT:3c18a44b
md:     L1 S01024000 ND:3 RD:2 md0 LO:0 CS:8192
md:     UT:3e01dcb3 ST:0 AD:2 WD:2 FD:1 SD:0 CSUM:f12fcb99 E:00000050
     D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
     D  1:  DISK<N:1,hde1(33,1),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:1,hde1(33,1),R:1,S:6>
md: rdev hda1: O:hda1, SZ:01536064 F:0 DN:0 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<dafb19f4.cc607c07.b72647b4.6f585c6d> CT:3c18a44b
md:     L1 S01024000 ND:3 RD:2 md0 LO:0 CS:8192
md:     UT:3e01dcb3 ST:0 AD:2 WD:2 FD:1 SD:0 CSUM:f12fcb79 E:00000050
     D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
     D  1:  DISK<N:1,hde1(33,1),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:0,hda1(3,1),R:0,S:6>
md1: <hde5><hda5> array superblock:
md:  SB: (V:0.90.0) ID:<9f552c55.10d01053.7e6a40ae.e9160862> CT:3c18a58a
md:     L1 S05120000 ND:3 RD:2 md1 LO:0 CS:8192
md:     UT:3e01dcb3 ST:0 AD:2 WD:2 FD:1 SD:0 CSUM:3b397b89 E:0000004d
     D  0:  DISK<N:0,hda5(3,5),R:0,S:6>
     D  1:  DISK<N:1,hde5(33,5),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:1,hde5(33,5),R:1,S:6>
md: rdev hde5: O:hde5, SZ:05120000 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<9f552c55.10d01053.7e6a40ae.e9160862> CT:3c18a58a
md:     L1 S05120000 ND:3 RD:2 md1 LO:0 CS:8192
md:     UT:3e01dcb3 ST:0 AD:2 WD:2 FD:1 SD:0 CSUM:3b39987e E:0000004d
     D  0:  DISK<N:0,hda5(3,5),R:0,S:6>
     D  1:  DISK<N:1,hde5(33,5),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:1,hde5(33,5),R:1,S:6>
md: rdev hda5: O:hda5, SZ:05120000 F:0 DN:0 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<9f552c55.10d01053.7e6a40ae.e9160862> CT:3c18a58a
md:     L1 S05120000 ND:3 RD:2 md1 LO:0 CS:8192
md:     UT:3e01dcb3 ST:0 AD:2 WD:2 FD:1 SD:0 CSUM:3b39985e E:0000004d
     D  0:  DISK<N:0,hda5(3,5),R:0,S:6>
     D  1:  DISK<N:1,hde5(33,5),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:0,hda5(3,5),R:0,S:6>
md2: <hde6> array superblock:
md:  SB: (V:0.90.0) ID:<7db46cc6.da202531.4acfe1c3.0a02808b> CT:3c18a596
md:     L1 S53760064 ND:2 RD:2 md2 LO:0 CS:8192
md:     UT:3e01dcb3 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:d3211a5a E:0000004b
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:9>
     D  1:  DISK<N:1,hde6(33,6),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:1,hde6(33,6),R:1,S:6>
md: rdev hde6: O:hde6, SZ:53760064 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<7db46cc6.da202531.4acfe1c3.0a02808b> CT:3c18a596
md:     L1 S53760064 ND:2 RD:2 md2 LO:0 CS:8192
md:     UT:3e01dcb3 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:d32136ef E:0000004b
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:9>
     D  1:  DISK<N:1,hde6(33,6),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:1,hde6(33,6),R:1,S:6>
md:     **********************************

md: cannot remove active disk hda1 from md0 ...
md: trying to generate hda1 error in md0 ...
md: okay, generating error!
----------
> cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [multipath]
read_ahead 1024 sectors
md0 : active raid1 hde1[1] hda1[0]
      1024000 blocks [2/2] [UU]
...


So, it seems hotgenerateeror was not successful.

Any ideas?

Regards,
Jarmo
