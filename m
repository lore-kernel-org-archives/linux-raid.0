From: Tobias Gunkel <tobias.gunkel@cloud-it-services.com>
Subject: decreasing array --re-add fails
Date: Tue, 12 Feb 2013 12:29:14 +0100
Message-ID: <511A278A.7090802@cloud-it-services.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone,

I want to split a large raid1 array (1TB, mounted on /) on my dedicated
server into two smaller arrays (50GB for / and 950GB for /srv).
Therefore I booted into the rescue system and perfomed the following steps:

# md0 was already assembled
$ e2fsck -f /dev/md0
$ resize2fs /dev/md0 40G
$ mdadm --grow /dev/md0 -z 50000000
$ resize2fs /dev/md0
$ mdadm /dev/md0 -f /dev/sda2 -r /dev/sda2
$ cfdisk /dev/sda

In cfdisk I removed the sda2 partition and re-created it with the
smaller size (plus a little bit extra space for metadata).

But if I try to re-add sda2, I get the following error:

$ mdadm -a /dev/md0 /dev/sda2
mdadm: /dev/sda2 reports being an active member for /dev/md0, but a
--re-add fails.
mdadm: not performing --add as that would convert /dev/sda2 in to a spare.
mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sda2" first.

dmesg says:

md: sda2 does not have a valid v1.2 superblock, not importing!
md: md_import_device returned -22

The mdadm version on the rescue system is 3.1.5, but on the actual
system (on which the array probably was created) it is 3.1.4.

I successfully tested these steps on my VM before. After I decreased the
partion size of sda2, re-added it to md0 (wait for re-sync) ... same
with sdb2 ... I booted in my smaller / partiton.

What went wrong here?


Thanks in advance and best regards,
Tobias



Here is some more info (sdb is still untouched):

$ mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sat Feb  9 12:05:33 2013
     Raid Level : raid1
     Array Size : 50000000 (47.68 GiB 51.20 GB)
  Used Dev Size : 50000000 (47.68 GiB 51.20 GB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Tue Feb 12 10:53:47 2013
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : 1350:0
           UUID : c7ce3900:ac8a1438:a7e72dbb:16708643
         Events : 83

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       18        1      active sync   /dev/sdb2


$ blockdev --getsz /dev/sda /dev/sdb /dev/sda2 /dev/sdb2
1953525168
1953525168
117194175
1940668065


$ mdadm --examine /dev/sd[ab]2
/dev/sda2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : c7ce3900:ac8a1438:a7e72dbb:16708643
           Name : 1350:0
  Creation Time : Sat Feb  9 12:05:33 2013
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1940666017 (925.38 GiB 993.62 GB)
     Array Size : 100000000 (47.68 GiB 51.20 GB)
  Used Dev Size : 100000000 (47.68 GiB 51.20 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 1138ef85:f279a537:c358a4ac:1ed3949d

    Update Time : Tue Feb 12 09:13:10 2013
       Checksum : 3345a566 - correct
         Events : 69


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)

/dev/sdb2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : c7ce3900:ac8a1438:a7e72dbb:16708643
           Name : 1350:0
  Creation Time : Sat Feb  9 12:05:33 2013
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1940666017 (925.38 GiB 993.62 GB)
     Array Size : 100000000 (47.68 GiB 51.20 GB)
  Used Dev Size : 100000000 (47.68 GiB 51.20 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 6953a768:f643948d:7df649d7:3dfb69c9

    Update Time : Tue Feb 12 11:05:54 2013
       Checksum : c2686b16 - correct
         Events : 85


   Device Role : Active device 1
   Array State : .A ('A' == active, '.' == missing)


$ fdisk -l /dev/sd[ab]

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x34e04fde

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1          128520    12851999     6361740   82  Linux swap / Solaris
/dev/sda2   *    12852000   114414929    50781465   fd  Linux raid
autodetect

Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x72b56b83

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1          128520    12851999     6361740   82  Linux swap / Solaris
/dev/sdb2   *    12852000  1953520064   970334032+  fd  Linux raid
autodetect
