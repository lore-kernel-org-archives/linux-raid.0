From: Siegfried Thoma <thoma.siegfried@yahoo.de>
Subject: Assemble array: failed to create bitmap (-5)
Date: Sat, 12 Sep 2009 01:43:39 +0000 (GMT)
Message-ID: <374260.32665.qm@web24702.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

currently I'm completly confused about what happened to my RAID 5 array.

After a crash (don't know why) I tried to reboot and start the array, but I only get the following:
linux:/mnt/raidcmds # mdadm /dev/md0 --assemble /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 --force --verbose
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb1 is identified as a member of /dev/md/0, slot 3.
mdadm: /dev/sdc1 is identified as a member of /dev/md/0, slot 0.
mdadm: /dev/sdd1 is identified as a member of /dev/md/0, slot 1.
mdadm: /dev/sde1 is identified as a member of /dev/md/0, slot 2.
mdadm: added /dev/sdd1 to /dev/md/0 as 1
mdadm: added /dev/sde1 to /dev/md/0 as 2
mdadm: added /dev/sdb1 to /dev/md/0 as 3
mdadm: added /dev/sdc1 to /dev/md/0 as 0
mdadm: failed to RUN_ARRAY /dev/md/0: Input/output error
linux:/mnt/raidcmds #

Dmesg gives you:

md: bind<sdd1>
md: bind<sde1>
md: bind<sdb1>
md: bind<sdc1>
md: md0: raid array is not clean -- starting background reconstruction
raid5: device sdc1 operational as raid disk 0
raid5: device sdb1 operational as raid disk 3
raid5: device sde1 operational as raid disk 2
raid5: device sdd1 operational as raid disk 1
raid5: allocated 4219kB for md0
raid5: raid level 5 set md0 active with 4 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:4
 disk 0, o:1, dev:sdc1
 disk 1, o:1, dev:sdd1
 disk 2, o:1, dev:sde1
 disk 3, o:1, dev:sdb1
md0: bitmap file is out of date, doing full recovery
md0: bitmap initialisation failed: -5
md0: failed to create bitmap (-5)


The individual komponents look like:


linux:/mnt/raidcmds # mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : ce761731:79e9d64a:d6f6e817:791dc8f3
           Name : 0
  Creation Time : Mon Jul 28 12:24:21 2008
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953519728 (931.51 GiB 1000.20 GB)
     Array Size : 5860558848 (2794.53 GiB 3000.61 GB)
  Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
   Super Offset : 1953519984 sectors
          State : clean
    Device UUID : 50f883b3:4e2b85a2:4683fb8d:52843dc4

Internal Bitmap : -234 sectors from superblock
    Update Time : Sun Sep  6 10:27:19 2009
       Checksum : 26ec807e - correct
         Events : 635952

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 4 (0, 1, failed, 2, 3)
   Array State : uuuU 1 failed
linux:/mnt/raidcmds # mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : ce761731:79e9d64a:d6f6e817:791dc8f3
           Name : 0
  Creation Time : Mon Jul 28 12:24:21 2008
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953519728 (931.51 GiB 1000.20 GB)
     Array Size : 5860558848 (2794.53 GiB 3000.61 GB)
  Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
   Super Offset : 1953519984 sectors
          State : clean
    Device UUID : c74c2f5b:e55bdc9c:79d6d477:1a8f8073

Internal Bitmap : -234 sectors from superblock
    Update Time : Sun Sep  6 10:27:19 2009
       Checksum : 620b6382 - correct
         Events : 635952

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 0 (0, 1, failed, 2, 3)
   Array State : Uuuu 1 failed
linux:/mnt/raidcmds #


linux:/mnt/raidcmds # mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : ce761731:79e9d64a:d6f6e817:791dc8f3
           Name : 0
  Creation Time : Mon Jul 28 12:24:21 2008
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953519728 (931.51 GiB 1000.20 GB)
     Array Size : 5860558848 (2794.53 GiB 3000.61 GB)
  Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
   Super Offset : 1953519984 sectors
          State : active
    Device UUID : f3f8c901:1754c385:83751837:e436d87e

Internal Bitmap : -234 sectors from superblock
    Update Time : Sun Sep  6 10:27:19 2009
       Checksum : bc284fad - correct
         Events : 635953

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 1 (0, 1, failed, 2, 3)
   Array State : uUuu 1 failed
linux:/mnt/raidcmds # mdadm -E /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : ce761731:79e9d64a:d6f6e817:791dc8f3
           Name : 0
  Creation Time : Mon Jul 28 12:24:21 2008
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953519728 (931.51 GiB 1000.20 GB)
     Array Size : 5860558848 (2794.53 GiB 3000.61 GB)
  Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
   Super Offset : 1953519984 sectors
          State : active
    Device UUID : 6f1caf60:af57a73e:bba7287d:55bd20ee

Internal Bitmap : -234 sectors from superblock
    Update Time : Sun Sep  6 10:27:19 2009
       Checksum : 894a2e75 - correct
         Events : 635953

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 3 (0, 1, failed, 2, 3)
   Array State : uuUu 1 failed
linux:/mnt/raidcmds #

Proc/mdstat tells you:
linux:/mnt/raidcmds # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : inactive sdc1[0] sdb1[4] sde1[3] sdd1[1]
      3907039232 blocks super 1.0

unused devices: <none>
linux:/mnt/raidcmds #

The array is not started looking like this:



linux:/mnt/raidcmds # mdadm -D /dev/md0
/dev/md0:
        Version : 1.00
  Creation Time : Mon Jul 28 12:24:21 2008
     Raid Level : raid5
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Sun Sep  6 10:27:19 2009
          State : active, Not Started
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           Name : 0
           UUID : ce761731:79e9d64a:d6f6e817:791dc8f3
         Events : 635952

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       3       8       65        2      active sync   /dev/sde1
       4       8       17        3      active sync   /dev/sdb1
linux:/mnt/raidcmds #

And finally the bitmaps looking like this:



linux:/mnt/raidcmds # mdadm -S /dev/md0
mdadm: stopped /dev/md0
linux:/mnt/raidcmds # mdadm -X /dev/sdb1
        Filename : /dev/sdb1
           Magic : 6d746962
         Version : 4
            UUID : ce761731:79e9d64a:d6f6e817:791dc8f3
          Events : 635953
  Events Cleared : 635952
           State : Out of date
       Chunksize : 1 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 976759808 (931.51 GiB 1000.20 GB)
          Bitmap : 953867 bits (chunks), 948224 dirty (99.4%)
linux:/mnt/raidcmds # mdadm -X /dev/sdc1
        Filename : /dev/sdc1
           Magic : 6d746962
         Version : 4
            UUID : ce761731:79e9d64a:d6f6e817:791dc8f3
          Events : 635953
  Events Cleared : 635952
           State : Out of date
       Chunksize : 1 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 976759808 (931.51 GiB 1000.20 GB)
          Bitmap : 953867 bits (chunks), 948224 dirty (99.4%)
linux:/mnt/raidcmds # mdadm -X /dev/sdd1
        Filename : /dev/sdd1
           Magic : 6d746962
         Version : 4
            UUID : ce761731:79e9d64a:d6f6e817:791dc8f3
          Events : 635953
  Events Cleared : 635952
           State : Out of date
       Chunksize : 1 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 976759808 (931.51 GiB 1000.20 GB)
          Bitmap : 953867 bits (chunks), 948224 dirty (99.4%)
linux:/mnt/raidcmds # mdadm -X /dev/sde1
        Filename : /dev/sde1
           Magic : 6d746962
         Version : 4
            UUID : ce761731:79e9d64a:d6f6e817:791dc8f3
          Events : 635953
  Events Cleared : 635952
           State : Out of date
       Chunksize : 1 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 976759808 (931.51 GiB 1000.20 GB)
          Bitmap : 953867 bits (chunks), 948224 dirty (99.4%)
linux:/mnt/raidcmds #


The array was originally build as RAID 5 with three drives. Then I added a fourth drive and issued something like mdadm  --grow .... (I can not exactly remember). But as far is I know this bitmap is completly new to me. I don't think I ever defined using a bitmap for this array.

It seems to me the drives look quite good. But what is this bitmap error all about. Is it possible to simply delete the bitmap. What will happen to the data in the array?

Does this show a hardware problem with one of the disks, meaning mdadm can not write to the disk blocks, where the bitmap files need to stored (some further hardware info: the motherboard is a Asus A8N-SLI, with Athlon X2 3800, All drives are SATA and software SUSE 11.1 with uname -a:Linux linux 2.6.27.7-9-pae #1 SMP 2008-12-04 18:10:04 +0100 i686 athlon i386 GNU/Linux, mdadm --version: mdadm - v3.0-devel2 - 5th November 2008).

In the past I made some very good experience with mkraid --force but currently I do not have any /etc/raidtab file. Is it possible to use the values shown in mdadm -E or mdadm -D to recreate /etc/raidtab and to a mkraid --force?

What would you suggest as next steps?

Kind regards

Siggi




      
