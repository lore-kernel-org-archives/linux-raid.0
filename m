From: Gavin Hamill <gdh@acentral.co.uk>
Subject: Rebuild after a drive replacement
Date: Sun, 08 Jun 2008 21:52:29 +0100
Message-ID: <1212958349.7596.14.camel@gdh-home>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi :)

I've had a drive die recently, and took the opportunity to upgrade my
aging Debian sarge box to etch. Once the new OS was running and I had
finished beating booting from /dev/md0 with a blunt instrument, I turned
my attention to the data raid-sets... there's only one I can't sort out,
and of course.. it's the biggest one :)

eddie:~# cat /proc/mdstat 
Personalities : [raid1] [raid6] [raid5] [raid4] 
md3 : active raid5 hda4[1] hdg4[2]
      349702144 blocks level 5, 1024k chunk, algorithm 0 [3/2] [_UU]

eddie:~# mdadm --add /dev/md3 /dev/hde5
mdadm: add new device failed for /dev/hde5 as 3: Invalid argument

hda and hdg are 200G drives. hde is the new one at 250G. I have
configured the partition sizes + types (0xFD) identically, but the
partition number is different on hde because I wanted to put extra stuff
in the 'spare' 50G.. so the set should be using hda4, hdg4, hde5.

eddie:~# mdadm -E /dev/hda4
/dev/hda4:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 788aae08:cdb33dda:d82c141f:f33b4b89
  Creation Time : Sat Apr  9 23:46:23 2005
     Raid Level : raid5
    Device Size : 174851072 (166.75 GiB 179.05 GB)
     Array Size : 349702144 (333.50 GiB 358.09 GB)
   Raid Devices : 3
  Total Devices : 2
Preferred Minor : 3

    Update Time : Sun Jun  8 21:38:02 2008
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 50a43565 - correct
         Events : 0.5864408

         Layout : left-asymmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     1       3        4        1      active sync   /dev/hda4

   0     0       0        0        0      removed
   1     1       3        4        1      active sync   /dev/hda4
   2     2      34        4        2      active sync   /dev/hdg4


eddie:~# mdadm -E /dev/hde5
/dev/hde5:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 788aae08:cdb33dda:d82c141f:f33b4b89
  Creation Time : Sat Apr  9 23:46:23 2005
     Raid Level : raid5
    Device Size : 174851072 (166.75 GiB 179.05 GB)
     Array Size : 349702144 (333.50 GiB 358.09 GB)
   Raid Devices : 3
  Total Devices : 2
Preferred Minor : 3

    Update Time : Sun Jun  8 19:05:11 2008
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 50a3f09d - correct
         Events : 0.5860156

         Layout : left-asymmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     3      33        5       -1      spare   /dev/hde5

   0     0       0        0        0      removed
   1     1       3        4        1      active sync   /dev/hda4
   2     2      34        4        2      active sync   /dev/hdg4



eddie:~# mdadm -E /dev/hdg4
/dev/hdg4:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 788aae08:cdb33dda:d82c141f:f33b4b89
  Creation Time : Sat Apr  9 23:46:23 2005
     Raid Level : raid5
    Device Size : 174851072 (166.75 GiB 179.05 GB)
     Array Size : 349702144 (333.50 GiB 358.09 GB)
   Raid Devices : 3
  Total Devices : 2
Preferred Minor : 3

    Update Time : Sun Jun  8 21:38:12 2008
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 50a43598 - correct
         Events : 0.5864412

         Layout : left-asymmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     2      34        4        2      active sync   /dev/hdg4

   0     0       0        0        0      removed
   1     1       3        4        1      active sync   /dev/hda4
   2     2      34        4        2      active sync   /dev/hdg4

As you can see, only hde thinks it's a spare, when I want it to replace
that 'removed' in all cases. What can I do?

Debian etch, so kernel 2.6.18 and mdadm 2.5.6.

Cheers,
Gavin.


