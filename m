From: Fabrice LORRAIN <Fabrice.Lorrain@univ-mlv.fr>
Subject: mdadm drives me crazy
Date: Wed, 01 Dec 2004 12:22:12 +0100
Message-ID: <41ADA964.3030606@univ-mlv.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Following a crash of one of our raid5 pool last week I discover that 
most of our servers shows the same pb. Up to now I didn't find the 
explanation. So if someone from the list could explain the following 
output and more particularly why the "failed device" after an mdadm 
--create with 2.4.x kernel :

dd if=/dev/zero of=part[1-5] bs=1k count=20000
losetup /dev/loop[0-5] part[0-5]

$ uname -a
Linux fabtest1 2.4.27-1-686 #1 Fri Sep 3 06:28:00 UTC 2004 i686 GNU/Linux

debian kernel on this box but all the other test I did where with a 
vanilla kernel.

$ sudo mdadm --version
mdadm - v1.7.0 - 11 August 2004
The box is i386 with an up to date pre-sarge (debian).
(same pb with 0.7.2 on a woody box, with 1.4 woody backport and mdadm 
1.8.1 doesn't start the building of the raid pool on an mdadm --create)

$ /sbin/lsmod
Module                  Size  Used by    Not tainted
raid5                  17320   1
md                     60064   1 [raid5]
xor                     8932   0 [raid5]
loop                    9112  18
input                   3648   0 (autoclean)
i810                   62432   0
agpgart                46244   6 (autoclean)
apm                     9868   2 (autoclean)
af_packet              13032   1 (autoclean)
dm-mod                 46808   0 (unused)
i810_audio             24444   0
ac97_codec             13300   0 [i810_audio]
soundcore               3940   2 [i810_audio]
3c59x                  27152   1
rtc                     6440   0 (autoclean)
ext3                   81068   2 (autoclean)
jbd                    42468   2 (autoclean) [ext3]
ide-detect               288   0 (autoclean) (unused)
ide-disk               16736   3 (autoclean)
piix                    9096   1 (autoclean)
ide-core              108504   3 (autoclean) [ide-detect ide-disk piix]
unix                   14928  62 (autoclean)

$ sudo mdadm --zero-superblock /dev/loop[0-5]

$ sudo mdadm --create /dev/md0 --level=5 --raid-devices=6 /dev/loop[0-5]
build the array correctly and gives (once the build is finished) :

$ cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 [dev 07:05][5] [dev 07:04][4] [dev 07:03][3] [dev 
07:02][2] [dev 07:01][1] [dev 07:00][0]
       99520 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]

$ $ sudo mdadm -D /dev/md0
/dev/md0:
         Version : 00.90.00
   Creation Time : Wed Dec  1 11:39:43 2004
      Raid Level : raid5
      Array Size : 99520 (97.19 MiB 101.91 MB)
     Device Size : 19904 (19.44 MiB 20.38 MB)
    Raid Devices : 6
   Total Devices : 7
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Wed Dec  1 11:40:29 2004
           State : dirty
  Active Devices : 6
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 604b72e9:86d7ecd6:578bfb8c:ea071bbd
          Events : 0.1

     Number   Major   Minor   RaidDevice State
        0       7        0        0      active sync   /dev/loop0
        1       7        1        1      active sync   /dev/loop1
        2       7        2        2      active sync   /dev/loop2
        3       7        3        3      active sync   /dev/loop3
        4       7        4        4      active sync   /dev/loop4
        5       7        5        5      active sync   /dev/loop5

Why in hell do I get a Failed devices ? And what is the real status of 
the raid5 pool ?

I have this pb with raid5 pool on hd and sd hard drives with <> vanilla 
2.4.x kernel. 2.6.x doesn't show this feature.

raid1 pool doesn't have this problem either.

@+,

	Fab
