From: Matthew Tice <mjtice@gmail.com>
Subject: Problems with raid after reboot.
Date: Wed, 20 Jul 2011 15:24:49 -0600
Message-ID: <CA+taBv-V7HasgHFFaLV+Ppbgv=b-6CvLLkGHh3oN+GAO0wFHxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I had to shutdown my machine for moving - when I powered it back up my
raid-5 array is in a bad state:

# mdadm -A -s
mdadm: no devices found for /dev/md0
mdadm: /dev/md/0 assembled from 2 drives - not enough to start the array.

I ended up forcing the assembly:

# mdadm -A -s -f
mdadm: no devices found for /dev/md0
mdadm: forcing event count in /dev/sde(1) from 177 upto 181
mdadm: clearing FAULTY flag for device 1 in /dev/md/0 for /dev/sde
mdadm: /dev/md/0 has been started with 3 drives (out of 4).

Looking at the detailed output the missing disk (/dev/sdc) is "removed":


# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90
  Creation Time : Sat Mar 12 21:22:34 2011
     Raid Level : raid5
     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Jul 19 20:44:45 2011
          State : clean, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : daf06d5a:b80528b1:2e29483d:f114274d (local to host storage)
         Events : 0.181

    Number   Major   Minor   RaidDevice State
       0       8       80        0      active sync   /dev/sdf
       1       8       64        1      active sync   /dev/sde
       2       8       48        2      active sync   /dev/sdd
       3       0        0        3      removed


I can examine the disk but I'm unable to add it (I don't recall if it
needs to be removed first or not):

# mdadm --examine /dev/sdc
/dev/sdc:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : daf06d5a:b80528b1:2e29483d:f114274d (local to host storage)
  Creation Time : Sat Mar 12 21:22:34 2011
     Raid Level : raid5
  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Tue Jul 19 20:44:45 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 22ac1229 - correct
         Events : 181

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       32        3      active sync   /dev/sdc

   0     0       8       80        0      active sync   /dev/sdf
   1     1       0        0        1      faulty removed
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       32        3      active sync   /dev/sdc

# mdadm --add /dev/md0 /dev/sdc
mdadm: Cannot open /dev/sdc: Device or resource busy

So a couple questions.

1. Any thoughts on what would cause this?  I seem to have bad luck
with my raid arrays whenever I reboot.
2. How do I fix?  Everything *seems* to be as it should be . . .

Here is the mdadm.conf:

# cat /etc/mdadm/mdadm.conf  | grep -v ^#

DEVICE partitions
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>
MAILADDR root
ARRAY /dev/md0 level=raid5 num-devices=4
UUID=11c1cdd8:60ec9a90:2e29483d:f114274d

Any help is greatly appreciated.

Matt
