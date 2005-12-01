From: Erich Newell <erich.newell@gmail.com>
Subject: Failed Recovery - Errors in Degraded Mode
Date: Thu, 1 Dec 2005 08:47:02 -0700
Message-ID: <d39ad6430512010747v3d221fa6m4eff494620c9d067@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I have a degraded 4 disk raid 5 array consisting of:

/dev/sdd3
/dev/sdc3
/dev/sdb3
/dev/sda3

Recently on boot the system crashed mid-boot for another unrelated (I
think) config issue. I then booted with a live cd and when I tried to
re-build /dev/md0, /dev/sdb3 came up as faulty. Upon inspection, there
were no errors for any of the aforementioned drives listed in the
syslogs so I thought the right thing to do was to simply hot-add
/dev/sdb3 back into the array.

When I woke up the next morning, I found that sdb3 was still not
added, and sda3 was now faulty as well.

After some homework, and much trepidation, I tried "mdadm --assemble
--force /dev/md0" which seemed to work, and I then mounted the device
read-only and copied off some important data. However, when I tried to
copy the entire device off-line, I received a lot of IO errors. The
odd bit is that if I do "mdadm --assemble --force" again, I can go in
an individually copy some of the files that seem to have caused the
erroring.

I have run fsck -n against the forceably assembled degraded raid,
which came back clean...and that's the last I could gleen as to what
to do from the documentation I've been able to find so far. Searching
this list found similar problems, but they all seemed to be solved by
simply running in degraded mode and fsck.

I 'm not sure how to proceed at this point.

Now that I already tried to hot-add the original 4th drive (sdb3) back
in, is the data on it truly lost? or could I possibly force the
re-creation of the superblocks thereby building the raid again with
all four drives, and simply mark it dirty and perform a re-sync?

Thanks!

Advice?

I've attached examin details from before and after below:

-----------------------BEFORE--------------------------------

/dev/md0:
       Version : 00.90.01
 Creation Time : Wed Apr 27 03:44:06 2005
    Raid Level : raid5
    Array Size : 725671872 (692.05 GiB 743.09 GB)
   Device Size : 241890624 (230.68 GiB 247.70 GB)
  Raid Devices : 4
 Total Devices : 4
Preferred Minor : 0
   Persistence : Superblock is persistent

   Update Time : Tue Nov 29 13:30:17 2005
         State : clean, degraded, recovering
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
 Spare Devices : 1

        Layout : left-symmetric
    Chunk Size : 64K

 Rebuild Status : 47% complete

          UUID : b22bea6d:62339cd7:0ce83b75:4ac59414
        Events : 0.8902455

   Number   Major   Minor   RaidDevice State
      0       8       51        0      active sync   /dev/sdd3
      1       8       35        1      active sync   /dev/sdc3
      2       0        0        -      removed
      3       8        3        3      active sync   /dev/sda3

      4       8       19        2      spare rebuilding   /dev/sdb3

------------------AFTER---------------------------------

/dev/md0:
       Version : 00.90.01
 Creation Time : Wed Apr 27 03:44:06 2005
    Raid Level : raid5
    Array Size : 725671872 (692.05 GiB 743.09 GB)
   Device Size : 241890624 (230.68 GiB 247.70 GB)
  Raid Devices : 4
 Total Devices : 4
Preferred Minor : 0
   Persistence : Superblock is persistent

   Update Time : Wed Nov 30 00:45:01 2005
         State : clean, degraded
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
 Spare Devices : 1

        Layout : left-symmetric
    Chunk Size : 64K

          UUID : b22bea6d:62339cd7:0ce83b75:4ac59414
        Events : 0.8902461

   Number   Major   Minor   RaidDevice State
      0       8       51        0      active sync   /dev/sdd3
      1       8       35        1      active sync   /dev/sdc3
      2       0        0        -      removed
      3       0        0        -      removed

      4       8       19        -      spare   /dev/sdb3
      5       8        3        -      faulty   /dev/sda3
