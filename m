From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: a word of caution: mdadm/kernel/gcc
Date: Mon, 16 Jun 2003 21:30:11 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EEE6F23.AE8EAB76@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You may already know this, or you may have discovered it (as I did)
through trial and error, but if you're using mdadm it is advisable to
compile mdadm with the same compiler as the kernel. 

I was using an mdadm compiled with gcc 2.96 on a gcc 3.2-compiled 2.4.19
kernel, and getting very strange errors. I looked at the kernel and
mdadm code, but couldn't see any bugs. Finally, I realized that I must
be seeing structure alignment differences between the two compilers. I
recompiled mdadm with gcc 3.2 and voila, everything works now...


--
Paul



sophocles:~ # cat /proc/version
Linux version 2.4.19-md-64GB-SMP (clemep@fenric) (gcc version 3.2
20020903 (Red Hat Linux 8.0 3.2-7)) #1 SMP Thu May 1 16:01:16 EDT 2003



[output from md driver PRINT_RAID_DEBUG ioctl:]

Jun 16 20:53:18 sophocles kernel: md: rdev hda5: O:hda5, SZ:02104320 F:0
DN:0
Jun 16 20:53:18 sophocles kernel: md: rdev superblock:
Jun 16 20:53:18 sophocles kernel: md:  SB: (V:0.90.0)
ID:<d6c5272a.dba72f74.4425
6768.25075ca6> CT:3e9d9217
Jun 16 20:53:18 sophocles kernel: md:     L5 S02104320 ND:3 RD:3 md0
LO:2 CS:131
072
Jun 16 20:53:18 sophocles kernel: md:     UT:3ee5de36 ST:0 AD:3 WD:3
FD:0 SD:0 C
SUM:426a1dc5 E:000026bf
Jun 16 20:53:18 sophocles kernel:      D  0: 
DISK<N:0,hda5(3,5),R:0,S:6>
Jun 16 20:53:18 sophocles kernel:      D  1: 
DISK<N:1,hda6(3,6),R:1,S:6>
Jun 16 20:53:18 sophocles kernel:      D  2: 
DISK<N:2,hda7(3,7),R:2,S:6>
Jun 16 20:53:18 sophocles kernel: md:     THIS: 
DISK<N:0,hda5(3,5),R:0,S:6>
Jun 16 20:53:18 sophocles kernel: md:  
**********************************
Jun 16 20:53:18 sophocles kernel: 



[gcc 2.96-compiled mdadm:]

sophocles:~ # mdadm --examine /dev/hda5 | tail -12
  Spare Devices : 0
       Checksum : 426a1dc5 - expected 814ffbfe
         Events : 9919.0

         Layout : left-asymmetric
     Chunk Size : 0K

      Number   Major   Minor   RaidDevice State
this     0       0        0        3      faulty sync
   0     0       0        0        3      faulty sync
   1     0       0        1        3      active sync
   2     0       0        2        3      faulty active sync



[gcc 3.2-compiled mdadm:]

sophocles:~ # /export/public/clemep/tmp/mdadm --examine /dev/hda5 | tail
-12
  Spare Devices : 0
       Checksum : 426a1dc5 - correct
         Events : 9919.0

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       3        5        0      active sync   /dev/hda5
   0     0       3        5        0      active sync   /dev/hda5
   1     1       3        6        1      active sync   /dev/hda6
   2     2       3        7        2      active sync   /dev/hda7
