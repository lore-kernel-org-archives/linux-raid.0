From: "r23@anchordrop.net" <r23@anchordrop.net>
Subject: raid-1  starting with 1 drive after brief hiatus with cruddy
 controller.
Date: Sun, 18 Jun 2017 00:14:10 -0400
Message-ID: <20170618001410.6fa96469@e20>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all, I have (2) 4.6 TB drives in software Raid 1 
mdadm - v3.3.2  on debian jessie. A new controller
zapped something and I have reverted to the prior built in 
controller.  I think 1 of the 2 is salvagable but need
some help getting the array started with the 1 drive (sda2 )
that is responding with raid info. sda2 was the other
drive and does not respond to --examine.

I think i've boiled it down to this when trying to scan/run:

mdadm: failed to add /dev/sdb2 to /dev/md/debian:0: Invalid argument
mdadm: failed to RUN_ARRAY /dev/md/debian:0: Invalid argument

Also not clear on if the name should be /dev/md0 or /dev/md/debian:0,
when I run scan/run with a name of /dev/md/debian:0 it ends up in the
/dev directory as /dev/md0

All the info follows.

I would like to get it started with the single drive / sda2 , 
in read-only mode to capture a backup.



root@mars:/home/user14# lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0   4.6T  0 disk
-─sda1   8:1    0     1G  0 part
|-sda2   8:2    0   4.6T  0 part
sdb      8:16   0   4.6T  0 disk
-─sdb1   8:17   0     1G  0 part
|-sdb2   8:18   0   4.6T  0 part
sdc      8:32   0 149.1G  0 disk
-─sdc1   8:33   0  78.1G  0 part
-─sdc2   8:34   0     1K  0 part
-─sdc5   8:37   0  33.6G  0 part
-─sdc6   8:38   0  18.1G  0 part
|-sdc7   8:39   0  19.2G  0 part
sdd      8:48   0 232.9G  0 disk
-─sdd1   8:49   0   8.4G  0 part /
-─sdd2   8:50   0     1K  0 part
-─sdd5   8:53   0   2.8G  0 part
-─sdd6   8:54   0     4G  0 part [SWAP]
-─sdd7   8:55   0   380M  0 part
|-sdd8   8:56   0 217.4G  0 part /home
sr0     11:0    1  1024M  0 rom
sr1     11:1    1   7.8G  0 rom
root@mars:/home/user14#


root@mars:~/raid/bin# mdadm --misc --examine /dev/sda2
mdadm: No md superblock detected on /dev/sda2.


root@mars:~/raid/bin# mdadm --misc --examine /dev/sdb2
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 2a3489a6:b430c744:2c89a792:98521913
           Name : debian:0
  Creation Time : Sat May  9 17:44:25 2015
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 9765179392 (4656.40 GiB 4999.77 GB)
     Array Size : 4882589696 (4656.40 GiB 4999.77 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 4697b088:5d3b1ae5:55d30f65:516df63d

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jun 14 23:53:27 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 1f245410 - expected 1f249410
         Events : 129099


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
root@mars:~/raid/bin# 


root@mars:~/raid/bin/util/lsdrv# ./lsdrv 
PCI [sata_via] 00:0f.0 IDE interface: VIA Technologies, Inc. VT8237A SATA 2-Port Controller (rev 80)
   scsi 0:0:0:0 ATA      TOSHIBA MD04ACA5 {75T8K3HXFS9A}
       sda 4.55t [8:0] Partitioned (gpt)
        sda1 1.00g [8:1] ext2 'skip_space' {b03b8699-d492-42b1-af9e-2a68b73b733d}
        sda2 4.55t [8:2] ext3 'for_raid' {5c93e223-8b7a-48b9-b4f0-6ef2990f22ae}
   scsi 1:0:0:0 ATA      TOSHIBA MD04ACA5 {84JHK4XKFS9A}
    sdb 4.55t [8:16] Partitioned (gpt)
     sdb1 1.00g [8:17] ext2 'fs_on_sdd1' {78546565-c92d-4008-b372-104c6337c11e}
     sdb2 4.55t [8:18] MD raid1 (2) inactive 'debian:0' {2a3489a6-b430-c744-2c89-a79298521913}
PCI [pata_via] 00:0f.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 07)
   scsi 2:0:0:0 PIONEER  DVD-RW  DVR-111D {PIONEER_DVD-RW_DVR-111D}
       sr0 1.00g [11:0] Empty/Unknown
   scsi 2:0:1:0 ATA      WDC WD1600JB-00G {WD-WCAL98126376}
       sdc 149.05g [8:32] Partitioned (dos)
        sdc1 78.13g [8:33] ntfs {72280E84280E4795}
        sdc2 1.00k [8:34] Partitioned (dos)
        sdc5 33.62g [8:37] vfat {04CA-B75D}
        sdc6 18.13g [8:38] ext2 'for_temp' {6cc1aa46-aaa3-4f93-8316-8924ac9ee3f2}
        sdc7 19.17g [8:39] ext4 'for_var' {8d865846-5827-4f51-b826-6f672d45285d}
   scsi 3:0:0:0 ATA      WDC WD2500JB-00G {WD-WCAL76218162}
    sdd 232.89g [8:48] Partitioned (dos)
     sdd1 8.38g [8:49] ext4 {7e42bfae-8af9-4c9a-b8c2-7e70c37435a1}
         Mounted as /dev/sdd1 @ /
     sdd2 1.00k [8:50] Partitioned (dos)
     sdd5 2.79g [8:53] ext4 {907474bc-cec7-4a80-afb0-daa963cef388}
     sdd6 3.99g [8:54] swap {cbe9107e-8503-4597-8f99-5121384dfd1b}
     sdd7 380.00m [8:55] ext4 {daf44546-1549-42be-b632-2be175962366}
     sdd8 217.34g [8:56] ext4 {9f3bfd18-92ac-4095-b512-cc2a0b88737c}
      Mounted as /dev/sdd8 @ /home
USB [usb-storage] Bus 002 Device 005: ID 0480:d010 Toshiba America Info. Systems, Inc.  {20121204025996}
   scsi 5:0:0:0 Toshiba  External USB 3.0 {66715465}
    sde 1.82t [8:64] Partitioned (dos)
     sde1 1.82t [8:65] ntfs 'ELLIS' {ACAC8FDBAC8F9E88}
      Mounted as /dev/sde1 @ /mnt/ellis
Other Block Devices
   md0 0.00k [9:0] MD v1.2  () clear, None (None) None {None}
                 Empty/Unknown
root@mars:~/raid/bin/util/lsdrv# 



root@mars:~/raid/bin/util/lsdrv# mdadm --manage --stop /dev/md0                  
mdadm: stopped /dev/md0

root@mars:~/raid/bin/util/lsdrv#  mdadm --assemble /dev/md/debian:0  -v /dev/sdb2 --run
mdadm: looking for devices for /dev/md/debian:0
mdadm: /dev/sdb2 is identified as a member of /dev/md/debian:0, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md/debian:0
mdadm: failed to add /dev/sdb2 to /dev/md/debian:0: Invalid argument
mdadm: failed to RUN_ARRAY /dev/md/debian:0: Invalid argument

root@mars:~/raid/bin/util/lsdrv# ls -lR /dev | grep md                                 
lrwxrwxrwx  1 root root            25 Jun 15 21:20 initctl -> /run/systemd/initctl/fifo
lrwxrwxrwx  1 root root            28 Jun 15 21:20 log -> /run/systemd/journal/dev-log
drwxr-xr-x  2 root root            40 Jun 15 17:20 md
brw-rw----  1 root disk        9,   0 Jun 17 21:54 md0
lrwxrwxrwx 1 root root 6 Jun 17 21:54 9:0 -> ../md0
/dev/md:

root@mars:~/raid/bin/util/lsdrv# mdadm --detail /dev/md0                               
/dev/md0:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 0
    Persistence : Superblock is persistent

          State : inactive

    Number   Major   Minor   RaidDevice
root@mars:~/raid/bin/util/lsdrv# 
root@mars:~/raid/bin/util/lsdrv# 

root@mars:~/raid/bin/util/lsdrv# cat /proc/mdstat
Personalities : 
unused devices: <none>
root@mars:~/raid/bin/util/lsdrv# 



