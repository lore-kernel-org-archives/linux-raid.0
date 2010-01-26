From: Maarten <maarten@ultratux.net>
Subject: woes with... mdadm ?
Date: Tue, 26 Jan 2010 23:27:41 +0100
Message-ID: <4B5F6C5D.8020202@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi Folks,

I'm having no end of trouble with a freshly built x86_64 system. After 
reboots checksums are corrupted, I cannot add drives back in, etc. I've 
downgraded from mdadm 3.0 to 2.6.8 but that doesn't change anything. 
First of all, maybe I'm missing something obvious. Does anyone spot an 
error in the following ?

I have made a raid-1 array of two members, /dev/sdd1 and /dev/sdg1. 
After reboot /dev/sdd1 was not part of the array anymore, but had not 
'quite' been rejected either looking at for instance the events counter:

mouse ~ # mdadm --examine /dev/sdd1
/dev/sdd1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 4eee1ddc:8bcacb4d:83e6059e:a5fcaf2c (local to host mouse)
   Creation Time : Mon Jan 25 20:52:23 2010
      Raid Level : raid1
   Used Dev Size : 311660864 (297.22 GiB 319.14 GB)
      Array Size : 311660864 (297.22 GiB 319.14 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 3

     Update Time : Tue Jan 26 21:49:21 2010
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 5717cb26 - expected 5717ca46
          Events : 18


       Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync   /dev/sdd1

    0     0       8       17        0      active sync   /dev/sdb1
    1     1       8       49        1      active sync   /dev/sdd1

mouse ~ # mdadm --examine /dev/sdg1
/dev/sdg1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 4eee1ddc:8bcacb4d:83e6059e:a5fcaf2c (local to host mouse)
   Creation Time : Mon Jan 25 20:52:23 2010
      Raid Level : raid1
   Used Dev Size : 311660864 (297.22 GiB 319.14 GB)
      Array Size : 311660864 (297.22 GiB 319.14 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 3

     Update Time : Tue Jan 26 21:49:21 2010
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 5717cb04 - correct
          Events : 18


       Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

    0     0       8       17        0      active sync   /dev/sdb1
    1     1       8       49        1      active sync   /dev/sdd1


Obviously, there now is a problem with the checksum. So I opted to 
reinsert the sdd1. Which proves impossible. I've tried to re-add it 
[fails], first remove+fail it [unnecessary since /proc/mdstat no longer 
lists it, but] and re-add it [fails], '--zero-superblock --force' it and 
re-add it [fails]. At all those times this is logged in syslog:

md: invalid superblock checksum on sdd1
md: sdd1 does not have a valid v0.90 superblock, not importing!
md: md_import_device returned -22

Getting more desperate, I googled around and found that other people 
reporting this error found their device was a tad smaller/too small. 
However that is not the case here, as witnessed by: (sdg1 is active 
member and is smaller than sdd1)

mouse ~ # fdisk -l /dev/sdg

Disk /dev/sdg: 320.1 GB, 320072933376 bytes
255 heads, 63 sectors/track, 38913 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdg1               1       38800   311660968+  fd  Linux raid 
autodetect
mouse ~ # fdisk -l /dev/sdd

Disk /dev/sdd: 320.1 GB, 320072933376 bytes
255 heads, 63 sectors/track, 38913 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       38890   312383893+  fd  Linux raid 
autodetect

Getting more desperate still: using fdisk to clear partitions and make a 
/dev/sdd2 instead of sdd1. Upon exiting fdisk I get NO warning about the 
kernel not using the new table, so there is nothing locking/using it.

Still mdadm categorically refuses to use the device:

mouse ~ # cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
md3 : active raid1 sdg1[0]
       311660864 blocks [2/1] [U_]

mouse ~ # mdadm -a /dev/md3 /dev/sdd2
mdadm: add new device failed for /dev/sdd2 as 2: Invalid argument


Further into despair: a reboot helps perhaps ? Nope, doesn't help.
Zero the drive with dd and retry ? Nope, no luck either...:

mouse ~ # dd if=/dev/zero of=/dev/sdd
^C
21733888 bytes (22 MB) copied, 1.29476 s, 16.8 MB/s

mouse ~ # fdisk  /dev/sdd

<snip>

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.

mouse ~ # fdisk -l /dev/sdd

Disk /dev/sdd: 320.1 GB, 320072933376 bytes
255 heads, 63 sectors/track, 38913 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xdb7c6eb0

    Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       38913   312568641   83  Linux


mouse ~ # mdadm -a /dev/md3 /dev/sdd1
mdadm: add new device failed for /dev/sdd1 as 2: Invalid argument

mouse ~ # cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
md3 : active raid1 sdg1[0]
       311660864 blocks [2/1] [U_]

mouse ~ # mdadm --detail /dev/md3
/dev/md3:
         Version : 0.90
   Creation Time : Mon Jan 25 20:52:23 2010
      Raid Level : raid1
      Array Size : 311660864 (297.22 GiB 319.14 GB)
   Used Dev Size : 311660864 (297.22 GiB 319.14 GB)
    Raid Devices : 2
   Total Devices : 1
Preferred Minor : 3
     Persistence : Superblock is persistent

     Update Time : Tue Jan 26 23:27:35 2010
           State : clean, degraded
  Active Devices : 1
Working Devices : 1
  Failed Devices : 0
   Spare Devices : 0

            UUID : 4eee1ddc:8bcacb4d:83e6059e:a5fcaf2c
          Events : 0.24

     Number   Major   Minor   RaidDevice State
        0       8       97        0      active sync   /dev/sdg1
        1       0        0        1      removed



Now what puzzles me further is the superblock behaviour I observe:

mouse ~ # mdadm --zero-superblock --force /dev/sdd1
mouse ~ # mdadm --examine /dev/sdd1
mdadm: No md superblock detected on /dev/sdd1.

So far so good. It's really gone now. Re-add the drive and reexamine:

mouse ~ # mdadm -a /dev/md3 /dev/sdd1
mdadm: add new device failed for /dev/sdd1 as 2: Invalid argument
mouse ~ # mdadm --examine /dev/sdd1
/dev/sdd1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 4eee1ddc:8bcacb4d:83e6059e:a5fcaf2c
   Creation Time : Mon Jan 25 20:52:23 2010
      Raid Level : raid1
   Used Dev Size : 311660864 (297.22 GiB 319.14 GB)
      Array Size : 311660864 (297.22 GiB 319.14 GB)
    Raid Devices : 2
   Total Devices : 1
Preferred Minor : 3

     Update Time : Tue Jan 26 23:55:00 2010
           State : clean
  Active Devices : 1
Working Devices : 1
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 5717e8f6 - correct
          Events : 26


       Number   Major   Minor   RaidDevice State
this     2       8       49       -1      spare   /dev/sdd1

    0     0       8       97        0      active sync   /dev/sdg1
    1     1       0        0        1      faulty removed

So what happened ? Re-adding failed but wrote the superblock, which upon 
examination is now exactly equal to the valid current array member sdg1:

  mouse ~ # mdadm --examine /dev/sdg1
/dev/sdg1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 4eee1ddc:8bcacb4d:83e6059e:a5fcaf2c
   Creation Time : Mon Jan 25 20:52:23 2010
      Raid Level : raid1
   Used Dev Size : 311660864 (297.22 GiB 319.14 GB)
      Array Size : 311660864 (297.22 GiB 319.14 GB)
    Raid Devices : 2
   Total Devices : 1
Preferred Minor : 3

     Update Time : Tue Jan 26 23:55:00 2010
           State : clean
  Active Devices : 1
Working Devices : 1
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 5717e8ef - correct
          Events : 26


       Number   Major   Minor   RaidDevice State
this     0       8       97        0      active sync   /dev/sdg1

    0     0       8       97        0      active sync   /dev/sdg1
    1     1       0        0        1      faulty removed

Magic: OK, UUID: OK, Events counter: both 26. Checksums: Correct. WTF ??

Still, not part of the array obviously:

mouse ~ # cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
md3 : active raid1 sdg1[0]
       311660864 blocks [2/1] [U_]

Now, if I try one more time to re-add it, no event counters are updated 
on either member, but the checksum of sdd1 now goes to

        Checksum : 5717e8f6 - expected 5717e896

I'm really at a loss here with this. The day before yesterday I had 
similar results with a much more complex raid-6 created-degraded array 
with 5 members. I'm sort of relieved I can reproduce it with a plain 
raid-1 array to avoid all that added complexity.

Now for the ''funny'' part. If I take another identical disk, sdc, 
partition it and add it to the array it works. Without waiting for the 
sync to finish I reboot. After, I find that sdc has suffered the same 
fate as sdd, ie.:
* It is not listed in /proc/mdstat
* mdadm --examine lists checksum as being wrong

In addition, stuff is now REALLY confused. /proc/mdstat lists no other 
members belonging to md3 and mdadm --detail agrees. However, mdadm 
--examine on all disks, active and otherwise, disagrees completely:

   mouse ~ # mdadm --detail /dev/md3
/dev/md3:
         Version : 0.90
   Creation Time : Mon Jan 25 20:52:23 2010
      Raid Level : raid1
      Array Size : 311660864 (297.22 GiB 319.14 GB)
   Used Dev Size : 311660864 (297.22 GiB 319.14 GB)
    Raid Devices : 2
   Total Devices : 1
Preferred Minor : 3
     Persistence : Superblock is persistent

     Update Time : Wed Jan 27 00:28:21 2010
           State : clean, degraded
  Active Devices : 1
Working Devices : 1
  Failed Devices : 0
   Spare Devices : 0

            UUID : 4eee1ddc:8bcacb4d:83e6059e:a5fcaf2c
          Events : 0.28

     Number   Major   Minor   RaidDevice State
        0       8       97        0      active sync   /dev/sdg1
        1       0        0        1      removed


mouse ~ # mdadm --examine /dev/sdg1
/dev/sdg1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 4eee1ddc:8bcacb4d:83e6059e:a5fcaf2c
   Creation Time : Mon Jan 25 20:52:23 2010
      Raid Level : raid1
   Used Dev Size : 311660864 (297.22 GiB 319.14 GB)
      Array Size : 311660864 (297.22 GiB 319.14 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 3

     Update Time : Wed Jan 27 00:28:21 2010
           State : clean
  Active Devices : 1
Working Devices : 2
  Failed Devices : 1
   Spare Devices : 1
        Checksum : 5717f0f4 - correct
          Events : 28


       Number   Major   Minor   RaidDevice State
this     0       8       97        0      active sync   /dev/sdg1

    0     0       8       97        0      active sync   /dev/sdg1
    1     1       0        0        1      faulty removed
    2     2       8       33        2      spare   /dev/sdc1
mouse ~ # mdadm --examine /dev/sdc1
/dev/sdc1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 4eee1ddc:8bcacb4d:83e6059e:a5fcaf2c
   Creation Time : Mon Jan 25 20:52:23 2010
      Raid Level : raid1
   Used Dev Size : 311660864 (297.22 GiB 319.14 GB)
      Array Size : 311660864 (297.22 GiB 319.14 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 3

     Update Time : Wed Jan 27 00:28:21 2010
           State : clean
  Active Devices : 1
Working Devices : 2
  Failed Devices : 1
   Spare Devices : 1
        Checksum : 5717f0b2 - expected 5717f072
          Events : 28


       Number   Major   Minor   RaidDevice State
this     2       8       33        2      spare   /dev/sdc1

    0     0       8       97        0      active sync   /dev/sdg1
    1     1       0        0        1      faulty removed
    2     2       8       33        2      spare   /dev/sdc1

How is it even possible that --detail on the array disagrees with 
--examine on its sole active member ? Is it not read from the same SB ?

Contrary to the expectations perhaps: mdadm refuses to add /dev/sdc1 to 
/dev/md3. However, /dev/sdd1 is now happily accepted... (yes, really!!)

mouse ~ # cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
md3 : active raid1 sdd1[2] sdg1[0]
       311660864 blocks [2/1] [U_]
       [>....................]  recovery =  2.4% (7567360/311660864) 
finish=75.9min speed=66768K/sec

I'm really hitting the wall. :-(
Can anyone even explain what I'm seeing, or help to find the cause ?


To finish off, some details about the system:
OS Gentoo, kernel 2.6.31-gentoo-r6, SMP, Athlon X2, x86_64.
All SATA controllers used are SIL, with one SATA port replicator
Initial mdadm version used: 3.0, current version 2.6.8
System was specially built for 15-disk operation but has currently only 
   6 disks attached. The 7-hour resync of the raid6 array (and the 
quicker raid1 resync) was succesfully passed without glitches. System 
was shut down properly, no crashes.
System is not in production, I can do/try whatever is necessary.
If anyone suspects the SATA port replicator I'm happy to take it out.
Neither onboard VIA nor Marvell SATA channels are used, only SIL.

mouse ~ # lspci |grep -i ata
00:0f.0 IDE interface: VIA Technologies, Inc. VT8237A SATA 2-Port 
Controller (rev 80)
05:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA 
Raid II Controller (rev 01)
06:00.0 SATA controller: Marvell Technology Group Ltd. 88SE6121 SATA II 
Controller (rev b0)
07:06.0 RAID bus controller: Silicon Image, Inc. SiI 3112 
[SATALink/SATARaid] Serial ATA Controller (rev 02)
07:07.0 RAID bus controller: Silicon Image, Inc. SiI 3112 
[SATALink/SATARaid] Serial ATA Controller (rev 02)
07:08.0 RAID bus controller: Silicon Image, Inc. SiI 3112 
[SATALink/SATARaid] Serial ATA Controller (rev 01)
07:09.0 RAID bus controller: Silicon Image, Inc. SiI 3124 PCI-X Serial 
ATA Controller (rev 02)

Regards,
Maarten
