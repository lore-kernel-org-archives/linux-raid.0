From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Help: very slow software RAID 5.
Date: Tue, 18 Sep 2007 16:09:14 -0700 (PDT)
Message-ID: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I'm not getting nearly the read speed I expected
from a newly defined software RAID 5 array
across three disk partitions (on the 3 drives,
of course!).

Would someone kindly point me straight?

After defining the RAID 5 I did `hdparm -t /dev/md0'
and got the abysmal read speed of ~65MB/sec.
The individual device speeds are ~55, ~70,
and ~75 MB/sec.

Shouldn't this array be running (at the slowest)
at about 55+70 = 125 MB/sec minus some overhead?
I defined a RAID0 on the ~55 and ~70 partitions
and got about 110 MB/sec.

Shouldn't adding a 3rd (faster!) drive into the
array make the RAID 5 speed at least this fast?


Here are the details of my setup:

Linux Fedora 7, kernel 2.6.22.

# fdisk -l /dev/sda

Disk /dev/sda: 160.0 GB, 160000000000 bytes
255 heads, 63 sectors/track, 19452 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1         127     1020096   82  Linux swap / Solaris
/dev/sda2   *         128         143      128520   83  Linux
/dev/sda3             144       19452   155099542+  fd  Linux raid autodetect


# fdisk -l /dev/sdb

Disk /dev/sdb: 160.0 GB, 160000000000 bytes
255 heads, 63 sectors/track, 19452 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1         127     1020096   82  Linux swap / Solaris
/dev/sdb2             128         143      128520   83  Linux
/dev/sdb3             144       19452   155099542+  fd  Linux raid autodetect



# fdisk -l /dev/sdc

Disk /dev/sdc: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1   *           1         127     1020096   82  Linux swap / Solaris
/dev/sdc2             128       19436   155099542+  fd  Linux raid autodetect
/dev/sdc3           19437       60801   332264362+  8e  Linux LVM


The RAID 5 consists of sda3, sdb3, and sdc2.
These partitions have these individual read speeds:

# hdparm -t /dev/sda3 /dev/sdb3 /dev/sdc2

/dev/sda3:
 Timing buffered disk reads:  168 MB in  3.03 seconds =  55.39 MB/sec

/dev/sdb3:
 Timing buffered disk reads:  216 MB in  3.03 seconds =  71.35 MB/sec

/dev/sdc2:
 Timing buffered disk reads:  228 MB in  3.02 seconds =  75.49 MB/sec


After defining RAID 5 with:

mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/sda3 /dev/sdb3 /dev/sdc2

and waiting the 50 minutes for /proc/mdstat to show it was finished,
I did `hdparm -t /dev/md0' and got ~65MB/sec.

Dean


