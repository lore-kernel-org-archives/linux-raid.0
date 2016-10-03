From: Marcus Fong <marcusfong42@gmail.com>
Subject: Corrupted FS after RAID5->6 reshape
Date: Mon, 3 Oct 2016 12:07:17 +1100
Message-ID: <4F572517-75C1-4501-B76B-65E3258A4D4E@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.0 \(3226\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, all.

I=E2=80=99ve had a 5-drive RAID5 mdraid array that=E2=80=99s been =
running fine for several years, but recently had a drive begin to fail =
with SMART errors. I replaced the drive, then decided to add another =
drive and reshape the array to RAID6 for added redundancy in case any of =
the other drives failed in future.

I put the backup file on an external USB drive without realising that =
mdraid would be writing to the backup file throughout the reshape =
operation, and the USB drive disconnected itself midway through the =
reshape. The reshape continued on without any apparent critical errors, =
though, so I left it rather than try to stop and resume it.

The reshape appeared to complete this morning without reporting any =
issues, but when I rebooted the machine it started in emergency mode =
because it failed to mount the filesystems on the RAID array. In one =
case mount can=E2=80=99t find the ext4 superblock at all, in two other =
cases the ext4 filesystem can be found but appears corrupted.

I=E2=80=99m just wondering if anyone might have any suggestions about =
how best to attempt recovery. There=E2=80=99s nothing on the array I =
ultimately can=E2=80=99t live without, but I=E2=80=99d like to retrieve =
any data I can.

/var/log/syslog output when starting the reshape operation:

Sep 28 11:19:22 bibliotheca kernel: [  706.039584] md/raid:md0: raid =
level 6 active with 5 out of 6 devices, algorithm 18
Sep 28 11:19:23 bibliotheca mdadm[889]: RebuildStarted event detected on =
md device /dev/md0
Sep 28 11:19:23 bibliotheca kernel: [  706.952130] md: reshape of RAID =
array md0
Sep 28 11:19:23 bibliotheca kernel: [  706.952136] md: minimum =
_guaranteed_  speed: 1000 KB/sec/disk.
Sep 28 11:19:23 bibliotheca kernel: [  706.952139] md: using maximum =
available idle IO bandwidth (but not more than 200000 KB/sec) for =
reshape.
Sep 28 11:19:23 bibliotheca kernel: [  706.952147] md: using 128k =
window, over a total of 3906885120k.
Sep 28 11:19:25 bibliotheca mdadm[889]: RebuildFinished event detected =
on md device /dev/md0
Sep 28 11:36:05 bibliotheca mdadm[889]: RebuildStarted event detected on =
md device /dev/md0

/var/log/syslog output when the USB drive disconnected:

Sep 29 16:54:00 bibliotheca kernel: [107184.545094] EXT4-fs warning =
(device sdh1): ext4_end_bio:329: I/O error -5 writing to inode 12 =
(offset 0 size 0 starting
block 35329)
Sep 29 16:54:00 bibliotheca kernel: [107184.545102] Buffer I/O error on =
device sdh1, logical block 34817
Sep 29 16:54:00 bibliotheca kernel: [107184.545149] Buffer I/O error on =
device sdh1, logical block 34818
Sep 29 16:54:00 bibliotheca kernel: [107184.545183] Buffer I/O error on =
device sdh1, logical block 34819
Sep 29 16:54:00 bibliotheca kernel: [107184.545217] Buffer I/O error on =
device sdh1, logical block 34820
=E2=80=A6
Sep 29 16:54:00 bibliotheca kernel: [107184.548901] Aborting journal on =
device sdh1-8.
Sep 29 16:54:00 bibliotheca kernel: [107184.549451] JBD2: Error -5 =
detected when updating journal superblock for sdh1-8.
Sep 29 16:54:00 bibliotheca kernel: [107184.550633] EXT4-fs error =
(device sdh1): ext4_journal_check_start:56: Detected aborted journal
Sep 29 16:54:00 bibliotheca kernel: [107184.551804] EXT4-fs (sdh1): =
Remounting filesystem read-only
Sep 29 16:54:00 bibliotheca kernel: [107184.552420] EXT4-fs (sdh1): =
previous I/O error to superblock detected
Sep 29 16:54:00 bibliotheca kernel: [107184.553155] EXT4-fs (sdh1): =
ext4_writepages: jbd2_start: 9223372036854775807 pages, ino 12; err -30

/var/log/syslog output when the reshape finished:

Oct  3 04:27:10 bibliotheca kernel: [404373.812923] md: md0: reshape =
done.
Oct  3 04:27:10 bibliotheca mdadm[889]: RebuildFinished event detected =
on md device /dev/md0
Oct  3 04:27:10 bibliotheca kernel: [404373.836909] md: recovery of RAID =
array md0
Oct  3 04:27:10 bibliotheca kernel: [404373.836915] md: minimum =
_guaranteed_  speed: 1000 KB/sec/disk.
Oct  3 04:27:10 bibliotheca kernel: [404373.836918] md: using maximum =
available idle IO bandwidth (but not more than 200000 KB/sec) for =
recovery.
Oct  3 04:27:10 bibliotheca kernel: [404373.836926] md: using 128k =
window, over a total of 3906885120k.
Oct  3 04:27:10 bibliotheca kernel: [404373.836930] md: resuming =
recovery of md0 from checkpoint.
Oct  3 04:27:10 bibliotheca kernel: [404373.836940] md: md0: recovery =
done.
Oct  3 04:27:10 bibliotheca kernel: [404373.837219] EXT4-fs error =
(device sdh1): ext4_wait_block_bitmap:503: comm mdadm: Cannot read block =
bitmap - block_group =3D 1, block_bitmap =3D 1026
Oct  3 04:27:10 bibliotheca kernel: [404373.839207] EXT4-fs error =
(device sdh1): ext4_discard_preallocations:4021: comm mdadm: Error =
loading buddy information for 1
Oct  3 04:27:11 bibliotheca mdadm[889]: RebuildStarted event detected on =
md device /dev/md0
Oct  3 04:27:11 bibliotheca mdadm[889]: RebuildFinished event detected =
on md device /dev/md0
Oct  3 04:27:11 bibliotheca mdadm[889]: SpareActive event detected on md =
device /dev/md0, component device /dev/sdg

mdadm and lsdrv output:

$ sudo mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Wed Jun 26 21:00:29 2013
     Raid Level : raid6
     Array Size : 15627540480 (14903.58 GiB 16002.60 GB)
  Used Dev Size : 3906885120 (3725.90 GiB 4000.65 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Mon Oct  3 10:57:44 2016
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric-6
     Chunk Size : 512K

           Name : bibliotheca:0  (local to host bibliotheca)
           UUID : d7c7fad6:fa50ed87:1d51f480:3d6405a5
         Events : 2565608

    Number   Major   Minor   RaidDevice State
       6       8       65        0      active sync   /dev/sde1
       1       8       49        1      active sync   /dev/sdd1
       2       8        1        2      active sync   /dev/sda1
       3       8       33        3      active sync   /dev/sdc1
       5       8       17        4      active sync   /dev/sdb1
       7       8       96        5      active sync   /dev/sdg

$ sudo mdadm -E /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d7c7fad6:fa50ed87:1d51f480:3d6405a5
           Name : bibliotheca:0  (local to host bibliotheca)
  Creation Time : Wed Jun 26 21:00:29 2013
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 7813771264 (3725.90 GiB 4000.65 GB)
     Array Size : 15627540480 (14903.58 GiB 16002.60 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262064 sectors, after=3D1024 sectors
          State : clean
    Device UUID : bf1149d3:6289a253:e441df54:9d8a41a8

    Update Time : Mon Oct  3 10:57:44 2016
       Checksum : f578645a - correct
         Events : 2565608

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)

$ sudo mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d7c7fad6:fa50ed87:1d51f480:3d6405a5
           Name : bibliotheca:0  (local to host bibliotheca)
  Creation Time : Wed Jun 26 21:00:29 2013
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 7813771264 (3725.90 GiB 4000.65 GB)
     Array Size : 15627540480 (14903.58 GiB 16002.60 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262064 sectors, after=3D1024 sectors
          State : clean
    Device UUID : a3233875:73036f81:b64b4098:e6244f43

    Update Time : Mon Oct  3 10:57:44 2016
       Checksum : a3a2946d - correct
         Events : 2565608

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)

$ sudo mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d7c7fad6:fa50ed87:1d51f480:3d6405a5
           Name : bibliotheca:0  (local to host bibliotheca)
  Creation Time : Wed Jun 26 21:00:29 2013
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 7813771264 (3725.90 GiB 4000.65 GB)
     Array Size : 15627540480 (14903.58 GiB 16002.60 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262064 sectors, after=3D1024 sectors
          State : clean
    Device UUID : 9d0277b9:c20b549a:40b6788c:5dbb7cfa

    Update Time : Mon Oct  3 10:57:44 2016
       Checksum : ac2c7cb6 - correct
         Events : 2565608

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)

$ sudo mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d7c7fad6:fa50ed87:1d51f480:3d6405a5
           Name : bibliotheca:0  (local to host bibliotheca)
  Creation Time : Wed Jun 26 21:00:29 2013
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 7813771264 (3725.90 GiB 4000.65 GB)
     Array Size : 15627540480 (14903.58 GiB 16002.60 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262064 sectors, after=3D1024 sectors
          State : clean
    Device UUID : b7da88c1:d3d78671:76a4b284:49530d65

    Update Time : Mon Oct  3 10:57:44 2016
       Checksum : ee3ba700 - correct
         Events : 2565608

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)

$ sudo mdadm -E /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d7c7fad6:fa50ed87:1d51f480:3d6405a5
           Name : bibliotheca:0  (local to host bibliotheca)
  Creation Time : Wed Jun 26 21:00:29 2013
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 7813771264 (3725.90 GiB 4000.65 GB)
     Array Size : 15627540480 (14903.58 GiB 16002.60 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D1024 sectors
          State : clean
    Device UUID : 8d552590:9541d3e9:bf926301:be485b84

    Update Time : Mon Oct  3 10:57:44 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : d12b6fa3 - correct
         Events : 2565608

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)

$ sudo mdadm -E /dev/sdg
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d7c7fad6:fa50ed87:1d51f480:3d6405a5
           Name : bibliotheca:0  (local to host bibliotheca)
  Creation Time : Wed Jun 26 21:00:29 2013
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 15627540480 (14903.58 GiB 16002.60 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D4784 sectors
          State : clean
    Device UUID : 1163b8d4:01cecee1:070f39f0:9562f32b

    Update Time : Mon Oct  3 10:57:44 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : a427ae64 - correct
         Events : 2565608

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)

$ python lsdrv
PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation 82801IB (ICH9) 2 =
port SATA Controller [IDE mode] (rev 02)
=E2=94=9Cscsi 0:0:0:0 ATA      ST4000DM000-1F21
=E2=94=82=E2=94=94sda 3.64t [8:0] Empty/Unknown
=E2=94=82 =E2=94=94sda1 3.64t [8:1] Empty/Unknown
=E2=94=82  =E2=94=94md0 14.55t [9:0] MD v1.2 raid6 (6) clean, 512k Chunk =
{None}
=E2=94=82   =E2=94=82                Empty/Unknown
=E2=94=82   =E2=94=9Cdm-2 10.00t [252:2] Empty/Unknown
=E2=94=82   =E2=94=9Cdm-3 4.00t [252:3] Empty/Unknown
=E2=94=82   =E2=94=82=E2=94=94dm-5 4.00t [252:5] Empty/Unknown
=E2=94=82   =E2=94=94dm-4 567.58g [252:4] Empty/Unknown
=E2=94=94scsi 1:0:0:0 ATA      ST4000DM000-1F21
 =E2=94=94sdb 3.64t [8:16] Empty/Unknown
  =E2=94=94sdb1 3.64t [8:17] Empty/Unknown
   =E2=94=94md0 14.55t [9:0] MD v1.2 raid6 (6) clean, 512k Chunk {None}
                     Empty/Unknown
PCI [ata_piix] 00:1f.5 IDE interface: Intel Corporation 82801I (ICH9 =
Family) 2 port SATA Controller [IDE mode] (rev 02)
=E2=94=9Cscsi 2:0:0:0 ATA      ST4000DM000-1F21
=E2=94=82=E2=94=94sdc 3.64t [8:32] Empty/Unknown
=E2=94=82 =E2=94=94sdc1 3.64t [8:33] Empty/Unknown
=E2=94=82  =E2=94=94md0 14.55t [9:0] MD v1.2 raid6 (6) clean, 512k Chunk =
{None}
=E2=94=82                    Empty/Unknown
=E2=94=94scsi 3:0:0:0 ATA      ST4000DM000-1F21
 =E2=94=94sdd 3.64t [8:48] Empty/Unknown
  =E2=94=94sdd1 3.64t [8:49] Empty/Unknown
   =E2=94=94md0 14.55t [9:0] MD v1.2 raid6 (6) clean, 512k Chunk {None}
                     Empty/Unknown
USB [usb-storage] Bus 001 Device 002: ID 0781:5580 SanDisk Corp. SDCZ80 =
Flash Drive {AA010803151943020344}
=E2=94=94scsi 4:0:0:0 SanDisk  Extreme
 =E2=94=94sdf 29.22g [8:80] Empty/Unknown
  =E2=94=9Csdf1 243.00m [8:81] Empty/Unknown
  =E2=94=82=E2=94=94Mounted as /dev/sdf1 @ /boot
  =E2=94=9Csdf2 1.00k [8:82] Empty/Unknown
  =E2=94=94sdf5 14.60g [8:85] Empty/Unknown
   =E2=94=9Cdm-0 12.72g [252:0] Empty/Unknown
   =E2=94=82=E2=94=94Mounted as /dev/mapper/bibliotheca-root @ /
   =E2=94=94dm-1 1.88g [252:1] Empty/Unknown
PCI [ahci] 03:00.0 SATA controller: ASMedia Technology Inc. ASM1062 =
Serial ATA Controller (rev 02)
=E2=94=9Cscsi 5:0:0:0 ATA      ST4000DM000-2AE1
=E2=94=82=E2=94=94sde 3.64t [8:64] Empty/Unknown
=E2=94=82 =E2=94=94sde1 3.64t [8:65] Empty/Unknown
=E2=94=82  =E2=94=94md0 14.55t [9:0] MD v1.2 raid6 (6) clean, 512k Chunk =
{None}
=E2=94=82                    Empty/Unknown
=E2=94=94scsi 6:0:0:0 ATA      ST4000DM000-2AE1
 =E2=94=94sdg 3.64t [8:96] Empty/Unknown
  =E2=94=94md0 14.55t [9:0] MD v1.2 raid6 (6) clean, 512k Chunk {None}
                    Empty/Unknown
PCI [pata_marvell] 04:00.0 IDE interface: Marvell Technology Group Ltd. =
88SE6121 SATA II / PATA Controller (rev b2)
=E2=94=9Cscsi 7:0:0:0 LITE-ON  DVDRW SOHW-832S  {2004062400030158}
=E2=94=82=E2=94=94sr0 1.00g [11:0] Empty/Unknown
=E2=94=94scsi 8:x:x:x [Empty]
Other Block Devices
=E2=94=9Cloop0 0.00k [7:0] Empty/Unknown
=E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
=E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
=E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
=E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
=E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
=E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
=E2=94=9Cloop7 0.00k [7:7] Empty/Unknown
=E2=94=9Cram0 64.00m [1:0] Empty/Unknown
=E2=94=9Cram1 64.00m [1:1] Empty/Unknown
=E2=94=9Cram2 64.00m [1:2] Empty/Unknown
=E2=94=9Cram3 64.00m [1:3] Empty/Unknown
=E2=94=9Cram4 64.00m [1:4] Empty/Unknown
=E2=94=9Cram5 64.00m [1:5] Empty/Unknown
=E2=94=9Cram6 64.00m [1:6] Empty/Unknown
=E2=94=9Cram7 64.00m [1:7] Empty/Unknown
=E2=94=9Cram8 64.00m [1:8] Empty/Unknown
=E2=94=9Cram9 64.00m [1:9] Empty/Unknown
=E2=94=9Cram10 64.00m [1:10] Empty/Unknown
=E2=94=9Cram11 64.00m [1:11] Empty/Unknown
=E2=94=9Cram12 64.00m [1:12] Empty/Unknown
=E2=94=9Cram13 64.00m [1:13] Empty/Unknown
=E2=94=9Cram14 64.00m [1:14] Empty/Unknown
=E2=94=94ram15 64.00m [1:15] Empty/Unknown=
