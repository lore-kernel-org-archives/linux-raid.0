From: Olivier Swinkels <olivier.swinkels@gmail.com>
Subject: [RAID recovery] Unable to recover RAID5 array after disk failure
Date: Fri, 3 Mar 2017 22:35:03 +0100
Message-ID: <CAJ0QwkJqRbJtM9HiXL+cCj2TkQQRahGgWTwD9QKH_CBfbJeLKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm in quite a pickle here. I can't recover from a disk failure on my
6 disk raid 5 array.
Any help would really be appreciated!

Please bear with me as I lay out the the steps that got me here:

- I got a message my raid went down as 3 disks seemed to have failed.
I've dealt with this before and usually it meant that one disk failed
and took out the complete SATA controller.

- 1 of the disks was quite old and the 2 others quite new (<1 year).
So i removed the old drive and the controller can up again. I tried to
reassemble the RAID using:   sudo mdadm -v --assemble --force /dev/md0
 /dev/sdb /dev/sdc /dev/sdg /dev/sdf /dev/sde

- However I got the message :
mdadm: /dev/md0 assembled from 4 drives - not enough to start the array.

- This got me worried and this was the place I screwed up:

- Against the recommendations on the wiki I tried to recover the RAID
using a re-create:
sudo mdadm --verbose --create --assume-clean --level=3D5
--raid-devices=3D6 /dev/md0 /dev/sdb /dev/sdc missing /dev/sdg /dev/sdf
/dev/sde

- The second error I made was I forgot to add the correct superblock
version and chunksize.

- The resulting RAID did not seem correct as I couldn't find the LVM
which should be there.

- Subsequently the SATA controller went down again, so my assumption
on the failed disk was also incorrect and I disconnected the wrong
disk.

- After some trial and error I found out one of the newer disk was the
culprit and I tried to recover the RAID by re-creating the array with
the healthy disks and the correct superblock configuration using:
sudo mdadm --verbose --create --bitmap=3Dnone --chunk=3D64 --metadata=3D0.9=
0
--assume-clean --level=3D5 --raid-devices=3D6 /dev/md0 /dev/sdb missing
/dev/sdc /dev/sdf /dev/sde /dev/sdd

- This gives me a degraded array, but unfortunately the LVM is still
not available.

- Is this situation still rescue-able?


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
- Below is the output of "mdadm --examine /dev/sd*" BEFORE the first
create action.

/dev/sdb:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 7af7d0ad:b37b1b49:151db09a:a68c27d9 (local to host
horus-server)
  Creation Time : Sun Apr 10 17:59:16 2011
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 9767572480 (9315.08 GiB 10001.99 GB)
   Raid Devices : 6
  Total Devices : 3
Preferred Minor : 0

    Update Time : Fri Feb 24 16:31:02 2017
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 3
  Spare Devices : 0
       Checksum : ae0d0dec - correct
         Events : 51108

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       16        0      active sync   /dev/sdb

   0     0       8       16        0      active sync   /dev/sdb
   1     1       0        0        1      active sync
   2     2       0        0        2      faulty removed
   3     3       8       96        3      active sync   /dev/sdg
   4     4       8       80        4      active sync   /dev/sdf
   5     5       0        0        5      faulty removed
/dev/sdc:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 7af7d0ad:b37b1b49:151db09a:a68c27d9 (local to host
horus-server)
  Creation Time : Sun Apr 10 17:59:16 2011
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 9767572480 (9315.08 GiB 10001.99 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Fri Feb 24 02:01:04 2017
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ae0c42ac - correct
         Events : 51108

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       32        1      active sync   /dev/sdc

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       96        3      active sync   /dev/sdg
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       64        5      active sync   /dev/sde
/dev/sde:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 7af7d0ad:b37b1b49:151db09a:a68c27d9 (local to host
horus-server)
  Creation Time : Sun Apr 10 17:59:16 2011
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 9767572480 (9315.08 GiB 10001.99 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Fri Feb 24 02:01:04 2017
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ae0c42c0 - correct
         Events : 51088

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       64        5      active sync   /dev/sde

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       96        3      active sync   /dev/sdg
   4     4       8       80        4      active sync   /dev/sdf
   5     5       8       64        5      active sync   /dev/sde
/dev/sdf:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 7af7d0ad:b37b1b49:151db09a:a68c27d9 (local to host
horus-server)
  Creation Time : Sun Apr 10 17:59:16 2011
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 9767572480 (9315.08 GiB 10001.99 GB)
   Raid Devices : 6
  Total Devices : 3
Preferred Minor : 0

    Update Time : Fri Feb 24 16:31:02 2017
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 3
  Spare Devices : 0
       Checksum : ae0d0e37 - correct
         Events : 51108

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       80        4      active sync   /dev/sdf

   0     0       8       16        0      active sync   /dev/sdb
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       8       96        3      active sync   /dev/sdg
   4     4       8       80        4      active sync   /dev/sdf
   5     5       0        0        5      faulty removed
/dev/sdg:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 7af7d0ad:b37b1b49:151db09a:a68c27d9 (local to host
horus-server)
  Creation Time : Sun Apr 10 17:59:16 2011
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 9767572480 (9315.08 GiB 10001.99 GB)
   Raid Devices : 6
  Total Devices : 3
Preferred Minor : 0

    Update Time : Fri Feb 24 16:31:02 2017
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 3
  Spare Devices : 0
       Checksum : ae0d0e45 - correct
         Events : 51108

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       96        3      active sync   /dev/sdg

   0     0       8       16        0      active sync   /dev/sdb
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       8       96        3      active sync   /dev/sdg
   4     4       8       80        4      active sync   /dev/sdf
   5     5       0        0        5      faulty removed

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
- below is status of the current situation:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

- Phil Turmel's lsdrv:

sudo ./lsdrv
[sudo] password for horus:
PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation NM10/ICH7
Family SATA Controller [IDE mode] (rev 02)
=E2=94=9Cscsi 0:0:0:0 ATA      Samsung SSD 850  {S21UNX0H601730R}
=E2=94=82=E2=94=94sda 111.79g [8:0] Partitioned (dos)
=E2=94=82 =E2=94=94sda1 97.66g [8:1] Partitioned (dos) {a2d2e5b3-cef5-44f8-=
83a7-3c25f285c7b4}
=E2=94=82  =E2=94=94Mounted as /dev/sda1 @ /
=E2=94=94scsi 1:0:0:0 ATA      SAMSUNG HD204UI  {S2H7JD2B201244}
 =E2=94=94sdb 1.82t [8:16] MD raid5 (0/6) (w/ sdc,sdd,sde,sdf) in_sync
{4c0518af-d198-d804-151d-b09aa68c27d9}
  =E2=94=94md0 9.10t [9:0] MD v0.90 raid5 (6) clean DEGRADED, 64k Chunk
{4c0518af:d198d804:151db09a:a68c27d9}
                   PV LVM2_member (inactive)
{DWv51O-lg9s-Dl4w-EBp9-QeIF-Vv60-8wt2uS}
PCI [pata_jmicron] 01:00.1 IDE interface: JMicron Technology Corp.
JMB363 SATA/IDE Controller (rev 03)
=E2=94=9Cscsi 2:x:x:x [Empty]
=E2=94=94scsi 3:x:x:x [Empty]
PCI [ahci] 01:00.0 SATA controller: JMicron Technology Corp. JMB363
SATA/IDE Controller (rev 03)
=E2=94=9Cscsi 4:0:0:0 ATA      SAMSUNG HD204UI  {S2H7JD2B201246}
=E2=94=82=E2=94=94sdc 1.82t [8:32] MD raid5 (2/6) (w/ sdb,sdd,sde,sdf) in_s=
ync
{4c0518af-d198-d804-151d-b09aa68c27d9}
=E2=94=82 =E2=94=94md0 9.10t [9:0] MD v0.90 raid5 (6) clean DEGRADED, 64k C=
hunk
{4c0518af:d198d804:151db09a:a68c27d9}
=E2=94=82                  PV LVM2_member (inactive)
{DWv51O-lg9s-Dl4w-EBp9-QeIF-Vv60-8wt2uS}
=E2=94=9Cscsi 4:1:0:0 ATA      WDC WD40EFRX-68W {WD-WCC4E6JF3EE3}
=E2=94=82=E2=94=94sdd 3.64t [8:48] MD raid5 (5/6) (w/ sdb,sdc,sde,sdf) in_s=
ync
{4c0518af-d198-d804-151d-b09aa68c27d9}
=E2=94=82 =E2=94=9Cmd0 9.10t [9:0] MD v0.90 raid5 (6) clean DEGRADED, 64k C=
hunk
{4c0518af:d198d804:151db09a:a68c27d9}
=E2=94=82 =E2=94=82                PV LVM2_member (inactive)
{DWv51O-lg9s-Dl4w-EBp9-QeIF-Vv60-8wt2uS}
=E2=94=94scsi 5:x:x:x [Empty]
PCI [ahci] 05:00.0 SATA controller: Marvell Technology Group Ltd.
88SE9120 SATA 6Gb/s Controller (rev 12)
=E2=94=9Cscsi 6:0:0:0 ATA      Hitachi HDS72202 {JK11A1YAJN30GV}
=E2=94=82=E2=94=94sde 1.82t [8:64] MD raid5 (4/6) (w/ sdb,sdc,sdd,sdf) in_s=
ync
{4c0518af-d198-d804-151d-b09aa68c27d9}
=E2=94=82 =E2=94=94md0 9.10t [9:0] MD v0.90 raid5 (6) clean DEGRADED, 64k C=
hunk
{4c0518af:d198d804:151db09a:a68c27d9}
=E2=94=82                  PV LVM2_member (inactive)
{DWv51O-lg9s-Dl4w-EBp9-QeIF-Vv60-8wt2uS}
=E2=94=94scsi 7:0:0:0 ATA      Hitachi HDS72202 {JK1174YAH779AW}
 =E2=94=94sdf 1.82t [8:80] MD raid5 (3/6) (w/ sdb,sdc,sdd,sde) in_sync
{4c0518af-d198-d804-151d-b09aa68c27d9}
  =E2=94=94md0 9.10t [9:0] MD v0.90 raid5 (6) clean DEGRADED, 64k Chunk
{4c0518af:d198d804:151db09a:a68c27d9}
                   PV LVM2_member (inactive)
{DWv51O-lg9s-Dl4w-EBp9-QeIF-Vv60-8wt2uS}

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid5 sdd[5] sde[4] sdf[3] sdc[2] sdb[0]
      9767572480 blocks level 5, 64k chunk, algorithm 2 [6/5] [U_UUUU]

unused devices: <none>

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
This is the current none functional RAID.
sudo mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Fri Mar  3 21:09:22 2017
     Raid Level : raid5
     Array Size : 9767572480 (9315.08 GiB 10001.99 GB)
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Mar  3 21:09:22 2017
          State : clean, degraded
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 4c0518af:d198d804:151db09a:a68c27d9 (local to host
horus-server)
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       2       0        0        2      removed
       2       8       32        2      active sync   /dev/sdc
       3       8       80        3      active sync   /dev/sdf
       4       8       64        4      active sync   /dev/sde
       5       8       48        5      active sync   /dev/sdd


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

sudo mdadm --examine /dev/sd*
/dev/sda:
   MBR Magic : aa55
Partition[0] :    204800000 sectors at         2048 (type 83)
/dev/sda1:
   MBR Magic : aa55
/dev/sdb:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 4c0518af:d198d804:151db09a:a68c27d9 (local to host
horus-server)
  Creation Time : Fri Mar  3 21:09:22 2017
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 9767572480 (9315.08 GiB 10001.99 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Fri Mar  3 21:09:22 2017
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : a857f8f3 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       16        0      active sync   /dev/sdb

   0     0       8       16        0      active sync   /dev/sdb
   1     0       0        0        0      spare
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       80        3      active sync   /dev/sdf
   4     4       8       64        4      active sync   /dev/sde
   5     5       8       48        5      active sync   /dev/sdd
/dev/sdc:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 4c0518af:d198d804:151db09a:a68c27d9 (local to host
horus-server)
  Creation Time : Fri Mar  3 21:09:22 2017
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 9767572480 (9315.08 GiB 10001.99 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Fri Mar  3 21:09:22 2017
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : a857f907 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       32        2      active sync   /dev/sdc

   0     0       8       16        0      active sync   /dev/sdb
   1     0       0        0        0      spare
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       80        3      active sync   /dev/sdf
   4     4       8       64        4      active sync   /dev/sde
   5     5       8       48        5      active sync   /dev/sdd
/dev/sdd:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 4c0518af:d198d804:151db09a:a68c27d9 (local to host
horus-server)
  Creation Time : Fri Mar  3 21:09:22 2017
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 9767572480 (9315.08 GiB 10001.99 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Fri Mar  3 21:09:22 2017
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : a857f91d - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       48        5      active sync   /dev/sdd

   0     0       8       16        0      active sync   /dev/sdb
   1     0       0        0        0      spare
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       80        3      active sync   /dev/sdf
   4     4       8       64        4      active sync   /dev/sde
   5     5       8       48        5      active sync   /dev/sdd
mdadm: No md superblock detected on /dev/sdd1.
/dev/sde:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 4c0518af:d198d804:151db09a:a68c27d9 (local to host
horus-server)
  Creation Time : Fri Mar  3 21:09:22 2017
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 9767572480 (9315.08 GiB 10001.99 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Fri Mar  3 21:09:22 2017
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : a857f92b - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       64        4      active sync   /dev/sde

   0     0       8       16        0      active sync   /dev/sdb
   1     0       0        0        0      spare
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       80        3      active sync   /dev/sdf
   4     4       8       64        4      active sync   /dev/sde
   5     5       8       48        5      active sync   /dev/sdd
/dev/sdf:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 4c0518af:d198d804:151db09a:a68c27d9 (local to host
horus-server)
  Creation Time : Fri Mar  3 21:09:22 2017
     Raid Level : raid5
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 9767572480 (9315.08 GiB 10001.99 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Fri Mar  3 21:09:22 2017
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : a857f939 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       80        3      active sync   /dev/sdf

   0     0       8       16        0      active sync   /dev/sdb
   1     0       0        0        0      spare
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       80        3      active sync   /dev/sdf
   4     4       8       64        4      active sync   /dev/sde
   5     5       8       48        5      active sync   /dev/sdd
