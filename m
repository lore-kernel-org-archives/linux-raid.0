From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: Persistent failures with simple md setup
Date: Wed, 27 Feb 2013 18:01:29 +0100
Message-ID: <4993918.JF2cWAHTeM@xrated>
References: <1565063.1kpR7lz4Ph@xrated> <2286786.BnthJ2WIKW@xrated> <20130205144448.2f40b306@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130205144448.2f40b306@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[I intentionally switched off line wrapping, since it renders the given information
 inedible]

Hi Neil,

sorry for the delay. Meanwhile, I updated to mdadm 3.2.6, and recreated the initrd.
Since I do the recreation on a regular base, no data salad appeared, but the initial
issue persists. I trigger checking the related md on each manual intervention.

Hence approaching this again. 

That's a typical boot sequence:

Feb 27 08:35:48 zaphkiel kernel: [    0.000000] Kernel command line: PROFILE=ibk root=/dev/disk/by-uuid/782b24f2-26f6-4ea9-ab8b-d377cd2ac97b console=ttyS0,19200 console=tty0 resume=/dev/md127 splash=silent  console=ttyS0,115200n8 vga=791
Feb 27 08:35:48 zaphkiel kernel: [    6.816164] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Feb 27 08:35:48 zaphkiel kernel: [    6.862240] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Feb 27 08:35:48 zaphkiel kernel: [    6.983157] sd 0:0:0:0: [sda] Write Protect is off
Feb 27 08:35:48 zaphkiel kernel: [    7.011914] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Feb 27 08:35:48 zaphkiel kernel: [    7.011932] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb 27 08:35:48 zaphkiel kernel: [    7.159045] sd 1:0:0:0: [sdb] Write Protect is off
Feb 27 08:35:48 zaphkiel kernel: [    7.187766] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Feb 27 08:35:48 zaphkiel kernel: [    7.187783] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Feb 27 08:35:48 zaphkiel kernel: [    7.319637]  sda: sda1 sda2 sda3 sda4
Feb 27 08:35:48 zaphkiel kernel: [    7.386469] sd 0:0:0:0: [sda] Attached SCSI disk
Feb 27 08:35:48 zaphkiel kernel: [    7.414335]  sdb: sdb1 sdb2 sdb3 sdb4
Feb 27 08:35:48 zaphkiel kernel: [    7.470597] sd 1:0:0:0: [sdb] Attached SCSI disk
Feb 27 08:35:48 zaphkiel kernel: [    9.676078] PM: Checking hibernation image partition /dev/md127
Feb 27 08:35:48 zaphkiel kernel: [    9.956010] sd 6:0:0:0: [sdc] Attached SCSI removable disk
Feb 27 08:35:48 zaphkiel kernel: [   10.175875] sd 6:0:0:1: [sdd] Attached SCSI removable disk
Feb 27 08:35:48 zaphkiel kernel: [   10.262999] sd 6:0:0:2: [sde] Attached SCSI removable disk
Feb 27 08:35:48 zaphkiel kernel: [   10.299000] sd 6:0:0:3: [sdf] Attached SCSI removable disk
Feb 27 08:35:48 zaphkiel kernel: [   10.618022] md: raid1 personality registered for level 1
Feb 27 08:35:48 zaphkiel kernel: [   11.139833] md: bind<sda3>
Feb 27 08:35:48 zaphkiel kernel: [   11.158438] md: bind<sdb3>
Feb 27 08:35:48 zaphkiel kernel: [   11.200897] md/raid1:md124: active with 2 out of 2 mirrors
Feb 27 08:35:48 zaphkiel kernel: [   11.233921] created bitmap (200 pages) for device md124
Feb 27 08:35:48 zaphkiel kernel: [   11.276742] md124: bitmap initialized from disk: read 13/13 pages, set 0 of 409595 bits
Feb 27 08:35:48 zaphkiel kernel: [   11.356796] md124: detected capacity change from 0 to 107372728320
Feb 27 08:35:48 zaphkiel kernel: [   11.395610]  md124: unknown partition table
Feb 27 08:35:48 zaphkiel kernel: [   11.543579] md: raid0 personality registered for level 0
Feb 27 08:35:48 zaphkiel kernel: [   11.583994] md: raid10 personality registered for level 10
Feb 27 08:35:48 zaphkiel kernel: [   12.188576] md: raid6 personality registered for level 6
Feb 27 08:35:48 zaphkiel kernel: [   12.220473] md: raid5 personality registered for level 5
Feb 27 08:35:48 zaphkiel kernel: [   12.252320] md: raid4 personality registered for level 4
Feb 27 08:35:48 zaphkiel kernel: [   12.318865] XFS (md124): Mounting Filesystem
Feb 27 08:35:48 zaphkiel kernel: [   12.535666] XFS (md124): Ending clean mount
Feb 27 08:35:48 zaphkiel kernel: [   22.720866] sd 0:0:0:0: Attached scsi generic sg0 type 0
Feb 27 08:35:48 zaphkiel kernel: [   23.126126] sd 1:0:0:0: Attached scsi generic sg1 type 0
Feb 27 08:35:48 zaphkiel kernel: [   23.203876] sd 6:0:0:0: Attached scsi generic sg2 type 0
Feb 27 08:35:48 zaphkiel kernel: [   23.402184] sd 6:0:0:1: Attached scsi generic sg3 type 0
Feb 27 08:35:48 zaphkiel kernel: [   23.725330] sd 6:0:0:2: Attached scsi generic sg4 type 0
Feb 27 08:35:48 zaphkiel kernel: [   23.917899] sd 6:0:0:3: Attached scsi generic sg5 type 0
Feb 27 08:35:48 zaphkiel kernel: [   24.492587] md: bind<sda2>
Feb 27 08:35:48 zaphkiel kernel: [   24.711804] md: bind<sda1>
Feb 27 08:35:48 zaphkiel kernel: [   24.821071] md: bind<sda4>
Feb 27 08:35:48 zaphkiel kernel: [   25.607192] md: bind<sdb2>
Feb 27 08:35:48 zaphkiel kernel: [   25.672335] md/raid1:md1: active with 2 out of 2 mirrors
Feb 27 08:35:48 zaphkiel kernel: [   25.723678] created bitmap (8 pages) for device md1
Feb 27 08:35:48 zaphkiel kernel: [   25.771764] md1: bitmap initialized from disk: read 1/1 pages, set 0 of 16379 bits
Feb 27 08:35:48 zaphkiel kernel: [   25.854963] md/raid1:md0: active with 1 out of 2 mirrors
Feb 27 08:35:48 zaphkiel kernel: [   25.886903] md1: detected capacity change from 0 to 2146783232
Feb 27 08:35:48 zaphkiel kernel: [   25.929142] created bitmap (6 pages) for device md0
Feb 27 08:35:48 zaphkiel kernel: [   25.958684]  md1: unknown partition table
Feb 27 08:35:48 zaphkiel kernel: [   25.995737] md: bind<sdb4>
Feb 27 08:35:48 zaphkiel kernel: [   26.012500] md0: bitmap initialized from disk: read 1/1 pages, set 0 of 12047 bits
Feb 27 08:35:48 zaphkiel kernel: [   26.077270] md0: detected capacity change from 0 to 98689024
Feb 27 08:35:48 zaphkiel kernel: [   26.168097] md/raid1:md3: active with 2 out of 2 mirrors
Feb 27 08:35:48 zaphkiel kernel: [   26.205258]  md0: unknown partition table
Feb 27 08:35:48 zaphkiel kernel: [   26.242295] created bitmap (415 pages) for device md3
Feb 27 08:35:48 zaphkiel kernel: [   26.304271] md3: bitmap initialized from disk: read 26/26 pages, set 1465 of 849320 bits
Feb 27 08:35:48 zaphkiel kernel: [   26.392578] md3: detected capacity change from 0 to 890575601664
Feb 27 08:35:48 zaphkiel kernel: [   26.575527]  md3: unknown partition table
Feb 27 08:35:48 zaphkiel kernel: [   26.763091] Adding 2096464k swap on /dev/md1.  Priority:0 extents:1 across:2096464k 
Feb 27 08:35:48 zaphkiel kernel: [   29.268318] XFS (md3): Mounting Filesystem
Feb 27 08:35:48 zaphkiel kernel: [   29.521844] EXT4-fs (md0): mounting ext2 file system using the ext4 subsystem
Feb 27 08:35:48 zaphkiel kernel: [   29.684176] EXT4-fs (md0): mounted filesystem without journal. Opts: acl,user_xattr
Feb 27 08:35:48 zaphkiel kernel: [   30.356255] XFS (md3): Ending clean mount

Today, /dev/sdb1 of /dev/md0 vanished. Re-adding and checking doesn't revealed 
any error, but it would be cool to get to the bottom of this, as re-adding some
lost partitions to the md every second day *is* a real PITA.

What could I do to help resolving this issue? 


Thanks in advance,
Pete


Usual system info (let me know, if something is missing):

# cat /etc/SuSE-release
openSUSE 12.1 (i586)
VERSION = 12.1
CODENAME = Asparagus


# uname -a (vendor kernel)
Linux zaphkiel 3.1.10-1.16-desktop #1 SMP PREEMPT Wed Jun 27 05:21:40 UTC 2012 (d016078) i686 athlon i386 GNU/Linux


# LANG=C fdisk -l /dev/sd{a,b}

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000c39ea

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *       16065      208844       96390   fd  Linux raid autodetect
/dev/sda2          208845     4401809     2096482+  fd  Linux raid autodetect
/dev/sda3         4401810   214114319   104856255   fd  Linux raid autodetect
/dev/sda4       214114320  1953520064   869702872+  fd  Linux raid autodetect

Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0005bc3f

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *       16065      208844       96390   fd  Linux raid autodetect
/dev/sdb2          208845     4401809     2096482+  fd  Linux raid autodetect
/dev/sdb3         4401810   214114319   104856255   fd  Linux raid autodetect
/dev/sdb4       214114320  1953520064   869702872+  fd  Linux raid autodetect


cat /proc/mdstat
Personalities : [raid1] [raid0] [raid10] [raid6] [raid5] [raid4] 
md3 : active raid1 sdb4[1] sda4[2]
      869702736 blocks super 1.0 [2/2] [UU]
      bitmap: 14/415 pages [56KB], 1024KB chunk

md0 : active raid1 sdb1[1] sda1[0]
      96376 blocks super 1.0 [2/2] [UU]
      bitmap: 0/6 pages [0KB], 8KB chunk

md1 : active raid1 sdb2[1] sda2[0]
      2096468 blocks super 1.0 [2/2] [UU]
      bitmap: 0/8 pages [0KB], 128KB chunk

md124 : active raid1 sdb3[1] sda3[0]
      104856180 blocks super 1.0 [2/2] [UU]
      bitmap: 6/200 pages [24KB], 256KB chunk

unused devices: <none>


# cat /etc/mdadm.conf
ARRAY /dev/md124 metadata=1.0 name=zaphkiel:2 UUID=4b91a798:7385d1ea:14128dab:9b09575e
ARRAY /dev/md/0 metadata=1.0 name=zaphkiel:0 UUID=a06939cd:1261d1ce:76eaa74c:db8ba5f9
ARRAY /dev/md/3 metadata=1.0 name=zaphkiel:3 UUID=8f2d01ee:035536bc:d23a6cf2:f0d863b8
ARRAY /dev/md1 metadata=1.0 name=zaphkiel:1 UUID=d6b3eadd:297b01f0:33860c88:9dc851cc
MAILADDR root


Note the silly naming..


# mdadm -Evvs
/dev/sdb4:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : 8f2d01ee:035536bc:d23a6cf2:f0d863b8
           Name : zaphkiel:3  (local to host zaphkiel)
  Creation Time : Thu Dec 31 14:04:04 2009
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1739405472 (829.41 GiB 890.58 GB)
     Array Size : 869702736 (829.41 GiB 890.58 GB)
   Super Offset : 1739405728 sectors
          State : clean
    Device UUID : 373b5269:1f407175:abd8f4f7:d8cba089

Internal Bitmap : -208 sectors from superblock
    Update Time : Wed Feb 27 17:18:21 2013
       Checksum : 6957806 - correct
         Events : 8320716


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)
/dev/sdb3:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : 4b91a798:7385d1ea:14128dab:9b09575e
           Name : zaphkiel:2  (local to host zaphkiel)
  Creation Time : Thu Dec 31 14:04:03 2009
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 209712360 (100.00 GiB 107.37 GB)
     Array Size : 104856180 (100.00 GiB 107.37 GB)
   Super Offset : 209712488 sectors
          State : active
    Device UUID : 42c13439:d288d793:f2468bba:19adbfd2

Internal Bitmap : -101 sectors from superblock
    Update Time : Wed Feb 27 17:18:21 2013
       Checksum : 26e2aafc - correct
         Events : 15267


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : d6b3eadd:297b01f0:33860c88:9dc851cc
           Name : zaphkiel:1  (local to host zaphkiel)
  Creation Time : Thu Dec 31 14:04:02 2009
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 4192936 (2047.68 MiB 2146.78 MB)
     Array Size : 2096468 (2047.68 MiB 2146.78 MB)
   Super Offset : 4192944 sectors
          State : clean
    Device UUID : dfd7f969:e9ce7838:8de84f6b:0b04acb5

Internal Bitmap : 2 sectors from superblock
    Update Time : Wed Feb 27 17:15:03 2013
       Checksum : 272647 - correct
         Events : 1764


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : a06939cd:1261d1ce:76eaa74c:db8ba5f9
           Name : zaphkiel:0  (local to host zaphkiel)
  Creation Time : Thu Dec 31 14:04:01 2009
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 192752 (94.13 MiB 98.69 MB)
     Array Size : 96376 (94.13 MiB 98.69 MB)
   Super Offset : 192760 sectors
          State : clean
    Device UUID : b8cd1539:9f294a42:710a79e1:c40a4ce0

Internal Bitmap : 2 sectors from superblock
    Update Time : Wed Feb 27 16:18:25 2013
       Checksum : 39343a85 - correct
         Events : 2609


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)
/dev/sdb:
   MBR Magic : aa55
Partition[0] :       192780 sectors at        16065 (type fd)
Partition[1] :      4192965 sectors at       208845 (type fd)
Partition[2] :    209712510 sectors at      4401810 (type fd)
Partition[3] :   1739405745 sectors at    214114320 (type fd)
/dev/sda4:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : 8f2d01ee:035536bc:d23a6cf2:f0d863b8
           Name : zaphkiel:3  (local to host zaphkiel)
  Creation Time : Thu Dec 31 14:04:04 2009
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1739405472 (829.41 GiB 890.58 GB)
     Array Size : 869702736 (829.41 GiB 890.58 GB)
   Super Offset : 1739405728 sectors
          State : clean
    Device UUID : 0b568d2a:c8e5a8e5:269188ba:22367205

Internal Bitmap : -208 sectors from superblock
    Update Time : Wed Feb 27 17:18:21 2013
       Checksum : 766d5b48 - correct
         Events : 8320716


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)
/dev/sda3:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : 4b91a798:7385d1ea:14128dab:9b09575e
           Name : zaphkiel:2  (local to host zaphkiel)
  Creation Time : Thu Dec 31 14:04:03 2009
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 209712360 (100.00 GiB 107.37 GB)
     Array Size : 104856180 (100.00 GiB 107.37 GB)
   Super Offset : 209712488 sectors
          State : active
    Device UUID : 0d0a5a95:cc454e60:fcea6dd4:ea6aabcd

Internal Bitmap : -101 sectors from superblock
    Update Time : Wed Feb 27 17:18:21 2013
       Checksum : 644d129b - correct
         Events : 15267

   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)
/dev/sda2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : d6b3eadd:297b01f0:33860c88:9dc851cc
           Name : zaphkiel:1  (local to host zaphkiel)
  Creation Time : Thu Dec 31 14:04:02 2009
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 4192936 (2047.68 MiB 2146.78 MB)
     Array Size : 2096468 (2047.68 MiB 2146.78 MB)
   Super Offset : 4192944 sectors
          State : clean
    Device UUID : 4c169220:335d3afc:d26ca91a:3ff38cd1

Internal Bitmap : 2 sectors from superblock
    Update Time : Wed Feb 27 17:15:03 2013
       Checksum : 45bb6676 - correct
         Events : 1764


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)
/dev/sda1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : a06939cd:1261d1ce:76eaa74c:db8ba5f9
           Name : zaphkiel:0  (local to host zaphkiel)
  Creation Time : Thu Dec 31 14:04:01 2009
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 192752 (94.13 MiB 98.69 MB)
     Array Size : 96376 (94.13 MiB 98.69 MB)
   Super Offset : 192760 sectors
          State : clean
    Device UUID : 7bc0a6ec:81f9494d:b5e55c6a:961bbccd

Internal Bitmap : 2 sectors from superblock
    Update Time : Wed Feb 27 16:18:25 2013
       Checksum : 6e18e93f - correct
         Events : 2609


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)
/dev/sda:
   MBR Magic : aa55
Partition[0] :       192780 sectors at        16065 (type fd)
Partition[1] :      4192965 sectors at       208845 (type fd)
Partition[2] :    209712510 sectors at      4401810 (type fd)
Partition[3] :   1739405745 sectors at    214114320 (type fd)

