From: Felipe Kich <fkich1977@gmail.com>
Subject: Help in recovering a RAID5 volume
Date: Thu, 10 Nov 2016 15:41:25 +0000
Message-ID: <CA+GmhESH-2hDJrOjvNzVBsgCP65BnUE2AbfOZ1Bbrp02jyBNUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have an Iomega IX4-200D bought in 2009 with 4 Seagate Barracuda LP
1TB drives that came pre-installed, and since then it's been working
fine, never had had real complaints about it in those 7 years. This
week, the samba shares disappeared. Accessing the web admin page, I
saw that the shares were gone, but the disk usage was correct (1,2TB
in use / 1,5TB free), and the status of the disks was the problem.
Disks 1, 2 and 4 had an alert and disk 3 was offline. Problem is that
until then, the unit never gave any warnings or signs that the disks
could fail. Well, doesn't really matter now. So, I turned off the unit
and started reading about what can be done to recover the files
inside.

I've set up a Linux PC, connected all disks, and began collecting
information about the condition of the HDDs, partitions, all I could
find. After reading the Linux Raid wiki and lots of threads on the
topic I'm still unable to mount the RAID5 volume in question. So, I'm
posting below the info I gathered from the RAID config in hopes
someone can give me some advice. Before posting the info, I've already
read about using hard disks designed for NAS usage, SCT Error Recovery
Control support, Desktop vs Enterprise drives, etc, but that's what we
could afford to buy at the time, unfortunately.

So, here's the info I got so far:

---------------------------------------------------------------------------=
-----
Index
---------------------------------------------------------------------------=
-----
1) smartctl -H -i -l scterc (for all disks)
2a) mdadm --examine /dev/sda (for the disk and both partitions)
2b) mdadm --examine /dev/sdb (for the disk and both partitions)
2c) mdadm --examine /dev/sdc (for the disk and both partitions)
2d) mdadm --examine /dev/sdd (for the disk and both partitions)
3) lsdrv
4) cat /proc/mdstat

---------------------------------------------------------------------------=
-----
1) smartcl -H -i -l scterc
---------------------------------------------------------------------------=
-----
root@it:/home/it/Desktop# smartctl -H -i -l scterc /dev/sda
smartctl 6.5 2016-01-24 r4214 [i686-linux-4.4.0-31-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Seagate Barracuda LP
Device Model:     ST31000520AS
Serial Number:    9VX0Y8JW
LU WWN Device Id: 5 000c50 026dca9fb
Firmware Version: CC37
User Capacity:    1.000.204.886.016 bytes [1,00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    5900 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Thu Nov 10 14:53:37 2016 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

root@it:/home/it/Desktop# smartctl -H -i -l scterc /dev/sdb
smartctl 6.5 2016-01-24 r4214 [i686-linux-4.4.0-31-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Seagate Barracuda LP
Device Model:     ST31000520AS
Serial Number:    9VX0WRVM
LU WWN Device Id: 5 000c50 026ca4019
Firmware Version: CC37
User Capacity:    1.000.204.886.016 bytes [1,00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    5900 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Thu Nov 10 14:54:07 2016 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

root@it:/home/it/Desktop# smartctl -H -i -l scterc /dev/sdc
smartctl 6.5 2016-01-24 r4214 [i686-linux-4.4.0-31-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Seagate Barracuda LP
Device Model:     ST31000520AS
Serial Number:    9VX0XD1S
LU WWN Device Id: 5 000c50 026dbdbf0
Firmware Version: CC38
User Capacity:    1.000.204.886.016 bytes [1,00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    5900 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Thu Nov 10 14:54:09 2016 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: FAILED!
Drive failure expected in less than 24 hours. SAVE ALL DATA.
Failed Attributes:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0033   002   002   036    Pre-fail
Always   FAILING_NOW 4033

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

root@it:/home/it/Desktop# smartctl -H -i -l scterc /dev/sdd
smartctl 6.5 2016-01-24 r4214 [i686-linux-4.4.0-31-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Seagate Barracuda LP
Device Model:     ST31000520AS
Serial Number:    9VX0Y9JW
LU WWN Device Id: 5 000c50 026d7169b
Firmware Version: CC38
User Capacity:    1.000.204.886.016 bytes [1,00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    5900 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Thu Nov 10 14:54:10 2016 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: FAILED!
Drive failure expected in less than 24 hours. SAVE ALL DATA.
Failed Attributes:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0033   003   003   036    Pre-fail
Always   FAILING_NOW 4013

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

---------------------------------------------------------------------------=
-----
2a) mdadm --examine /dev/sda (for the disk and both partitions)
---------------------------------------------------------------------------=
-----

root@it:/home/it/Desktop# mdadm --examine /dev/sda
/dev/sda:
   MBR Magic : aa55
Partition[0] :      4080509 sectors at            1 (type 83)
Partition[1] :   1949444658 sectors at      4080510 (type 83)


root@it:/home/it/Desktop# mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ab0d7fdf:373ee9f2:5d8fd52f:304e1b90
  Creation Time : Thu May  6 20:34:46 2010
     Raid Level : raid1
  Used Dev Size : 2040128 (1992.65 MiB 2089.09 MB)
     Array Size : 2040128 (1992.65 MiB 2089.09 MB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Wed Nov  9 16:49:29 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : bd7c68c8 - correct
         Events : 37056

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       0        0        2      faulty removed
   3     3       8       17        3      active sync   /dev/sdb1


root@it:/home/it/Desktop# mdadm --examine /dev/sda2
/dev/sda2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : b570d224:d61d7f45:8352223d:f9c68ac4
           Name : storage:1
  Creation Time : Thu Feb 17 10:22:16 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1949444384 (929.57 GiB 998.12 GB)
     Array Size : 2924166528 (2788.70 GiB 2994.35 GB)
  Used Dev Size : 1949444352 (929.57 GiB 998.12 GB)
   Super Offset : 1949444640 sectors
   Unused Space : before=3D0 sectors, after=3D288 sectors
          State : clean
    Device UUID : e0b08740:62497ceb:c107ad71:6bade30e

    Update Time : Wed Nov  9 16:05:03 2016
       Checksum : 70a9b667 - correct
         Events : 161174

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)

---------------------------------------------------------------------------=
-----
2b) mdadm --examine /dev/sdb (for the disk and both partitions)
---------------------------------------------------------------------------=
-----

root@it:/home/it/Desktop# mdadm --examine /dev/sdb
/dev/sdb:
   MBR Magic : aa55
Partition[0] :      4080447 sectors at           63 (type 83)
Partition[1] :   1949444658 sectors at      4080510 (type 83)


root@it:/home/it/Desktop# mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ab0d7fdf:373ee9f2:5d8fd52f:304e1b90
  Creation Time : Thu May  6 20:34:46 2010
     Raid Level : raid1
  Used Dev Size : 2040128 (1992.65 MiB 2089.09 MB)
     Array Size : 2040128 (1992.65 MiB 2089.09 MB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Wed Nov  9 16:49:29 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : bd7c68de - correct
         Events : 37056

      Number   Major   Minor   RaidDevice State
this     3       8       17        3      active sync   /dev/sdb1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       0        0        2      faulty removed
   3     3       8       17        3      active sync   /dev/sdb1


root@it:/home/it/Desktop# mdadm --examine /dev/sdb2
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : b570d224:d61d7f45:8352223d:f9c68ac4
           Name : storage:1
  Creation Time : Thu Feb 17 10:22:16 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1949444384 (929.57 GiB 998.12 GB)
     Array Size : 2924166528 (2788.70 GiB 2994.35 GB)
  Used Dev Size : 1949444352 (929.57 GiB 998.12 GB)
   Super Offset : 1949444640 sectors
   Unused Space : before=3D0 sectors, after=3D288 sectors
          State : clean
    Device UUID : c07ecc29:5939c5c0:dda4e6fd:343fbf57

    Update Time : Wed Nov  9 16:05:03 2016
       Checksum : 44ca328 - correct
         Events : 161174

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)

---------------------------------------------------------------------------=
-----
2c) mdadm --examine /dev/sdc (for the disk and both partitions)
---------------------------------------------------------------------------=
-----

root@it:/home/it/Desktop# mdadm --examine /dev/sdc
/dev/sdc:
   MBR Magic : aa55
Partition[0] :      4080509 sectors at            1 (type 83)
Partition[1] :   1949444658 sectors at      4080510 (type 83)


root@it:/home/it/Desktop# mdadm --examine /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ab0d7fdf:373ee9f2:5d8fd52f:304e1b90
  Creation Time : Thu May  6 20:34:46 2010
     Raid Level : raid1
  Used Dev Size : 2040128 (1992.65 MiB 2089.09 MB)
     Array Size : 2040128 (1992.65 MiB 2089.09 MB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Wed Nov  9 12:55:15 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : bd7c31b0 - correct
         Events : 37022

      Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       0        0        2      faulty removed
   3     3       8       17        3      active sync   /dev/sdb1


root@it:/home/it/Desktop# mdadm --examine /dev/sdc2
/dev/sdc2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : b570d224:d61d7f45:8352223d:f9c68ac4
           Name : storage:1
  Creation Time : Thu Feb 17 10:22:16 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1949444384 (929.57 GiB 998.12 GB)
     Array Size : 2924166528 (2788.70 GiB 2994.35 GB)
  Used Dev Size : 1949444352 (929.57 GiB 998.12 GB)
   Super Offset : 1949444640 sectors
   Unused Space : before=3D0 sectors, after=3D288 sectors
          State : active
    Device UUID : ceb844db:855e415a:cfc9efe5:4c2db02d

    Update Time : Wed Nov  9 12:55:49 2016
       Checksum : d39e909 - correct
         Events : 161163

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)

---------------------------------------------------------------------------=
-----
2d) mdadm --examine /dev/sdd (for the disk and both partitions)
---------------------------------------------------------------------------=
-----

root@it:/home/it/Desktop# mdadm --examine /dev/sdd
/dev/sdd:
   MBR Magic : aa55
Partition[0] :      4080509 sectors at            1 (type 83)
Partition[1] :   1949444658 sectors at      4080510 (type 83)


root@it:/home/it/Desktop# mdadm --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ab0d7fdf:373ee9f2:5d8fd52f:304e1b90
  Creation Time : Thu May  6 20:34:46 2010
     Raid Level : raid1
  Used Dev Size : 2040128 (1992.65 MiB 2089.09 MB)
     Array Size : 2040128 (1992.65 MiB 2089.09 MB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Wed Nov  9 16:49:29 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : bd7c68fa - correct
         Events : 37056

      Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync   /dev/sdd1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       0        0        2      faulty removed
   3     3       8       17        3      active sync   /dev/sdb1


root@it:/home/it/Desktop# mdadm --examine /dev/sdd2
/dev/sdd2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : b570d224:d61d7f45:8352223d:f9c68ac4
           Name : storage:1
  Creation Time : Thu Feb 17 10:22:16 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1949444384 (929.57 GiB 998.12 GB)
     Array Size : 2924166528 (2788.70 GiB 2994.35 GB)
  Used Dev Size : 1949444352 (929.57 GiB 998.12 GB)
   Super Offset : 1949444640 sectors
   Unused Space : before=3D0 sectors, after=3D288 sectors
          State : clean
    Device UUID : c95e2f61:d146c52c:dc6336fc:c2987aab

    Update Time : Wed Nov  9 16:05:03 2016
       Checksum : f9bab3b4 - correct
         Events : 161174

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : spare
   Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)

---------------------------------------------------------------------------=
-----
3) lsdrv
---------------------------------------------------------------------------=
-----

root@it:/home/it/Desktop# ./lsdrv
PCI [ahci] 00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD]
FCH SATA Controller [AHCI mode] (rev 40)
=E2=94=9Cscsi 0:0:0:0 ATA      ST31000520AS     {9VX0Y8JW}
=E2=94=82=E2=94=94sda 931.51g [8:0] Partitioned (dos)
=E2=94=82 =E2=94=9Csda1 1.95g [8:1] MD raid1 (4) inactive {ab0d7fdf-373e-e9=
f2-5d8f-d52f304e1b90}
=E2=94=82 =E2=94=94sda2 929.57g [8:2] MD raid5 (4) inactive 'storage:1'
{b570d224-d61d-7f45-8352-223df9c68ac4}
=E2=94=9Cscsi 1:0:0:0 ATA      ST31000520AS     {9VX0WRVM}
=E2=94=82=E2=94=94sdb 931.51g [8:16] Partitioned (dos)
=E2=94=82 =E2=94=9Csdb1 1.95g [8:17] MD raid1 (4) inactive
{ab0d7fdf-373e-e9f2-5d8f-d52f304e1b90}
=E2=94=82 =E2=94=94sdb2 929.57g [8:18] MD raid5 (4) inactive 'storage:1'
{b570d224-d61d-7f45-8352-223df9c68ac4}
=E2=94=9Cscsi 2:0:0:0 ATA      ST31000520AS     {9VX0XD1S}
=E2=94=82=E2=94=94sdc 931.51g [8:32] Partitioned (dos)
=E2=94=82 =E2=94=9Csdc1 1.95g [8:33] MD raid1 (4) inactive
{ab0d7fdf-373e-e9f2-5d8f-d52f304e1b90}
=E2=94=82 =E2=94=94sdc2 929.57g [8:34] MD raid5 (4) inactive 'storage:1'
{b570d224-d61d-7f45-8352-223df9c68ac4}
=E2=94=94scsi 3:0:0:0 ATA      ST31000520AS     {9VX0Y9JW}
 =E2=94=94sdd 931.51g [8:48] Partitioned (dos)
  =E2=94=9Csdd1 1.95g [8:49] MD raid1 (4) inactive
{ab0d7fdf-373e-e9f2-5d8f-d52f304e1b90}
  =E2=94=94sdd2 929.57g [8:50] MD raid5 (4) inactive 'storage:1'
{b570d224-d61d-7f45-8352-223df9c68ac4}
USB [usb-storage] Bus 002 Device 002: ID 0781:5530 SanDisk Corp.
Cruzer {2005244391081570854A}
=E2=94=94scsi 4:0:0:0 SanDisk  Cruzer
 =E2=94=94sde 14.91g [8:64] Partitioned (dos)
  =E2=94=94sde1 14.91g [8:65] vfat 'FK16GB_LIVE' {1214-3C58}
   =E2=94=94Mounted as /dev/sde1 @ /cdrom
Other Block Devices
=E2=94=9Cloop0 820.33m [7:0] squashfs
=E2=94=82=E2=94=94Mounted as /dev/loop0 @ /rofs
=E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
=E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
=E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
=E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
=E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
=E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
=E2=94=9Cloop7 0.00k [7:7] Empty/Unknown
=E2=94=9Cmd0 0.00k [9:0] MD vnone  () clear, None (None) None {None}
=E2=94=82                Empty/Unknown
=E2=94=9Cmd1 0.00k [9:1] MD vnone  () clear, None (None) None {None}
=E2=94=82                Empty/Unknown
=E2=94=9Cmd5 0.00k [9:5] MD vnone  () clear, None (None) None {None}
=E2=94=82                Empty/Unknown
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
=E2=94=9Cram15 64.00m [1:15] Empty/Unknown
=E2=94=9Czram0 910.69m [251:0] swap {dd565600-cbd9-4d3c-bfa8-d534f6b0edea}
=E2=94=9Czram1 910.69m [251:1] swap {6cc52777-6aef-4046-8acf-fd7b88eb5d74}
=E2=94=9Czram2 910.69m [251:2] swap {7d6eba27-e88b-46a9-9edc-b36fc273b63a}
=E2=94=94zram3 910.69m [251:3] swap {ce871e97-37f7-4a37-b09d-bef1f1e288b9}

---------------------------------------------------------------------------=
-----
4) cat /proc/mdstat
---------------------------------------------------------------------------=
-----

root@it:/home/it/Desktop# cat /proc/mdstat
Personalities : [raid1]
unused devices: <none>

---------------------------------------------------------------------------=
-----


So, with that info, I could verify some things that are frequently
mentioned on the posts:
- SCT Error Recovery Control is disabled for both Read and Write operations=
;
- Events counter in the devices are the same, except for one disk, but
the difference is small (<50);
- Magic Numbers and Checksums are all correct;

Hope someone can give some advice as how to proceed next.

Best regards.

-
Felipe Kich
51-9622-2067
