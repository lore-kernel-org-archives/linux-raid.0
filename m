From: Kenneth Emerson <kenneth.emerson@gmail.com>
Subject: md metadata nightmare
Date: Tue, 22 Nov 2011 18:05:21 -0600
Message-ID: <CADzwnhXWvkVC13ZEJj8L0O6PLXLS6uhoBXqoLp67YwmeU60sQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am looking for any help I can get to explain what happened to me
this past week and what I can possibly do to really fix my problem.  I
apologize in advance for the long diatribe, but I don't want to be
accused of leaving out important details.  I am currently running
Ubuntu Lucid (10.4 LTS) 32 bit with mdadm version 3.1.4.

Original RAID configuration:

(4) 500GB drives partitioned into boot/root/swap/data
    sd[a-d]1 -> Boot
    sd[a-d]2 -> Root
    sd[a-d]3 -> Swap
    sd[a-d]4 -> LVM (data)

    sd[a-d][1-3] --> RAID1 (4 partitions) md[0-2]
    sd[a-d]4 --> RAID5 (4 partions) md3

1 year later:
Upgraded (4) 500GB drives to (4) 1000GB drives.
Replaced the 500GB drives one at a time, partitioned them and re-synced them.
After all drives replaced, did a grow operation on each of the RAID
devices (md[0-3]
Grew the file systems (md[0-1] -> ext3, md3 -> xfs)

1 year ago:
Added a fifth 1000GB drive as spare.
Upgraded mdadm to version 3.1.4 and performed a reshape of md3 from
RAID5 -> RAID6

3 months ago:
Upgraded (5) 1000GB drives to (5) 3000GB drives using the same
technique as the 500GB -> 1000GB replacement.
It was at this time that I experienced worrisome results.  The reshape
completed without a problem but after rebooting the kernel had
problems assembling the arrays.  I was dropped into the busybox
initramfs shell with strange arrays that were numbered something like
md125 -> md127.  I was able to stop the arrays (none were active) and
rebuild them manually by specifying the individual partitions for each
array.  After doing that and continuing the boot process, I updated my
mdadm.conf file (using mdadm --detail --scan) and then performed a
mkinitramfs to build a new initrd.img after which, I was able to boot
successfully with the correct md devices (md{0-3]).

This past week, one of the 3000GB drives began to fail.  The drives
are in a hot-swap cage and I removed the failed drive and
unintentionally powered down one of the other drives (sdb was the
failed drive sdd was the other drive that powered down).  Fortunately,
the array rebuilt the parity on sdd without any errors. At this time I
was running a degraded RAID6 missing one drive. I RMA'ed the drive and
used a spare 3000GB drive to restore the array to full health; no
problems here.

Several days later, it was necessary to reboot and things went to h,
e, double hockysticks in double time.  I ended up with the same md125
-> md127 arrays as I had seen previously, but the devices were even
more messed up.  Two of the devices (sda and sde) were in arrays as
the entire disk instead of  one of the five partitions I had made on
the disk (GPT style) and I was having trouble assembling them
manually.  Using the rescue CD, I tried to assemble the arrays and
then do a chroot to create a new initrd.img, but I found that my sda
drive was not being recognized as partitioned at all by the kernel;
however, if I went into parted and set one of the flags (that was
already set) and exit, the partitions did show up.  I was never
successful in building an initrd.img file that would boot successfully
building the arrays; always dropped into the busybox (BTW, my existing
kernel did see all of the sda partitions -- 2.6.32-33 lucid while the
rescuecd was 2.6.38).

Eventually, I was able to assemble all of the arrays in the busybox.
(aside: admitting that I had forgotten how to do a stop on the array
which led me to believe I couldn't rebuild them manually here).
However, loading LVM onto the RAID6 array failed.  Checking dmesg, the
kernel was complaining that the array was too small for the volume
group.  Checking the --examine on each of the partions, the size was
coming back at about 400+GB! It looked like I had the metadata (all
version 0.90) from the original RAID5 array with the 500GB drives.  It
was getting really late (2am), but I wanted to get this system mounted
and running, so, on a whim, I told mdadm to grow the array to maxsize
and (low and behold) the array size changed from the 1400GB to 7.5TB.
I thought all was well and good until I looked at mdstat on proc and
saw that the array was synch'ing.  My heart came into my throat as I
was thinking that it was wiping out everything above the 1400GB
original size, but I figured (correctly) better to let it finish than
try something foolish in the middle of the resync.  Getting some sleep
(resync took about 5 hours) came back to find the array healthy, still
7.4TB and all of the data was intact (better to be lucky than good
I've been told).

So here is the existing system: md0, md1 RAID1 with four drives; md3
RAID6 with 4 drives (one missing). I removed sda because it seemed to
be the most messed up and causing problems (just a guess).  Doing a
--examine on the drive (sda) and not any partition provided me with a
superblock and metadata.  The same for sde which I assume is why I saw
these drives in arrays (erroneously) by the kernel on a reboot.  I
intend to zero out the superblock(s) on the sda drive and re-add it to
the arrays, but I haven't done that yet (someone may want to see the
metadata on that drive first).

NOTE: I have set the linux-raid flag on all of the partitions in the
GPT. I think I have read in the linux-raid archives that this is not
recommended. Could this have had an affect on what transpired?

So my question is:

Is there a way, short of backing up the data, completely rebuilding
the arrays, and restoring the data (a real PIA) to rewrite the
metadata given the existing array configurations in the running
system?  Also, is there an explanation as to why the metadata seems so
screwed up that the arrays cannot be assembled automatically by the
kernel?

-- Ken Emerson

======================================================
Some current info:
mdadm.conf:
MAILADDR root
DEVICES /dev/sda* /dev/sdb* /dev/sdc* /dev/sdd* /dev/sde*
ARRAY /dev/md1 metadata=0.90 UUID=90f0aede:03a99d2a:bd811544:edcdae81
#ARRAY /dev/md2 metadata=0.90 UUID=bbb35b74:953e15e4:a6c431d9:d41e95bb
ARRAY /dev/md0 metadata=0.90 UUID=82ab6faa:6c2e2c2a:c44c77eb:7ee19756
ARRAY /dev/md3 metadata=0.90 UUID=bf3d03bc:87aa59eb:3381d0b6:242837d4

========================================================
from mdadm --examine (the four partitions are very similar):

/dev/sdd4:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : bf3d03bc:87aa59eb:3381d0b6:242837d4
  Creation Time : Mon Sep  3 15:11:50 2007
     Raid Level : raid6
  Used Dev Size : -1661870144 (2511.12 GiB 2696.29 GB)
     Array Size : 7899291456 (7533.35 GiB 8088.87 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 3

    Update Time : Tue Nov 22 17:45:42 2011
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 7ac29869 - correct
         Events : 3486116

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       52        4      active sync   /dev/sdd4

   0     0       0        0        0      removed
   1     1       8       20        1      active sync   /dev/sdb4
   2     2       8       36        2      active sync   /dev/sdc4
   3     3       8        4        3      active sync   /dev/sda4
   4     4       8       52        4      active sync   /dev/sdd4
======================================================
From mdadm --detail /dev/md3:
/dev/md3:
        Version : 0.90
  Creation Time : Mon Sep  3 15:11:50 2007
     Raid Level : raid6
     Array Size : 7899291456 (7533.35 GiB 8088.87 GB)
  Used Dev Size : -1
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Tue Nov 22 17:47:20 2011
          State : clean, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : bf3d03bc:87aa59eb:3381d0b6:242837d4
         Events : 0.3486294

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       20        1      active sync   /dev/sdb4
       2       8       36        2      active sync   /dev/sdc4
       3       8        4        3      active sync   /dev/sda4
       4       8       52        4      active sync   /dev/sdd4
