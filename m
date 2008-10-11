From: "Trebor A. Rude" <treborrude@comcast.net>
Subject: Confused About Results of Constructing raid10 Array
Date: Sat, 11 Oct 2008 15:27:12 +0100
Message-ID: <200810111527.12594.treborrude@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello All,

I'm building a new Linux box, and I've decided to store the main portion of 
the data in an LVM-on-raid10. I have three identical disks, partitioned as so:

hyperion ~ # sfdisk -lL -uM /dev/sdc

Disk /dev/sdc: 121601 cylinders, 255 heads, 63 sectors/track
Units = mebibytes of 1048576 bytes, blocks of 1024 bytes, counting from 0

   Device Boot Start   End    MiB    #blocks   Id  System
/dev/sdc1   *     0+    94-    95-     96358+  fd  Linux raid autodetect
/dev/sdc2        94+  1066-   973-    996030   fd  Linux raid autodetect
/dev/sdc3      1066+  4973-  3907-   4000185   fd  Linux raid autodetect
/dev/sdc4      4973+ 577179- 572206- 585938745    5  Extended
/dev/sdc5      4973+ 577179- 572206- 585938713+  fd  Linux raid autodetect

The first three partitions are /boot, /, and swap. They're all raid1, and I'm 
happy with them.

The confusion starts with the last partition. I created them in cfdisk as a 
600000 MB (base 10, didn't realize that at the time) partition. I then created 
a raid10 using the sd[abc]5 partitions:

mdadm --create /dev/md3 --level=10 --layout=f2 --raid-devices=3 /dev/sda5 
/dev/sdb5 /dev/sdc5

After the re-sync finished, here's what /proc/mdstat has to say about it:

md3 : active raid10 sdc5[2] sdb5[1] sda5[0]
      878907840 blocks 64K chunks 2 far-copies [3/3] [UUU]

And here's the detail:

hyperion ~ # mdadm --detail /dev/md3
/dev/md3:
        Version : 00.90
  Creation Time : Wed Oct  8 23:41:22 2008
     Raid Level : raid10
     Array Size : 878907840 (838.19 GiB 900.00 GB)
  Used Dev Size : 585938560 (558.79 GiB 600.00 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Sat Oct 11 14:07:18 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=1, far=2
     Chunk Size : 64K

           UUID : b9141d0e:6beebd00:11e8198a:ff85a9d7
         Events : 0.4

    Number   Major   Minor   RaidDevice State
       0       8        5        0      active sync   /dev/sda5
       1       8       21        1      active sync   /dev/sdb5
       2       8       37        2      active sync   /dev/sdc5

There are two things I don't understand here:

Why does the "Layout" line say "near=1, far=2"? Does that indicate that there 
are three copies of every block? Even though I have three drives, I only 
wanted two copies of each block.

Where's the rest of my space? I put 1800 GB (again, base 10) of space into the 
array, but the total of "Array Size" and "Used Dev Size" is only 1500 GB. 
Where's the other 300 GB? Was it lost to formatting?

A few last details: I'm running x86_64 kernel 2.6.26 compiled from gentoo-
sources-2.6.26-r1, and I have mdadm version 2.6.7.

I haven't moved any data to this array yet, so if I've done something daft, I 
should be able to correct it easily, if you care to enlighten me. I'd also 
appreciate any advice on any other place I could have found the answers to 
these questions. My google searches weren't coming up with much.

Thank you,

Trebor

