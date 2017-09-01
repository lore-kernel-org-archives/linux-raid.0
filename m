From: "Thomas C. Bishop" <bishop@latech.edu>
Subject: raid5 messed up
Date: Fri, 1 Sep 2017 15:15:41 -0500
Message-ID: <fdbb6bf6-357c-781e-beee-d8589cbb299d@email.latech.edu>
Reply-To: bishop@latech.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I messed up my raid5 array . I know a two of HDs are "failure 
prediction" and one is out.. seagate is shipping me replacements.

This is my backup server so there's the actual copy of data but I'd 
prefer to recover the array because other data scripts/tools have crept 
into it ... mostly junk but would like to verify.

Here's out put as recommended at 
https://raid.wiki.kernel.org/index.php/Linux_Raid

Thanks in advance for any assistance,

TOm


  **************************************
cat-mdstat.txt
Personalities : [raid6] [raid5] [raid4]
md127 : inactive sdd1[1] sdh1[5] sdc1[8] sdg1[9](S) sdb1[0] sdf1[3]
       23442105036 blocks super 1.0

unused devices: <none>
  **************************************
lsdrv.log
PCI [mpt3sas]
├scsi 0:0:0:0 SEAGATE  ST4000NM0023
│└sdb 3.64t [8:16] Empty/Unknown
│ └sdb1 3.64t [8:17] Empty/Unknown
│  └md127 0.00k [9:127] MD v1.0 raid5 (7) inactive, 128k Chunk, None 
(None) None {None}
│                       Empty/Unknown
├scsi 0:0:1:0 SEAGATE  ST4000NM0023
│└sdc 3.64t [8:32] Empty/Unknown
│ └sdc1 3.64t [8:33] Empty/Unknown
│  └md127 0.00k [9:127] MD v1.0 raid5 (7) inactive, 128k Chunk, None 
(None) None {None}
│                       Empty/Unknown
├scsi 0:0:2:0 SEAGATE  ST4000NM0023
│└sdd 3.64t [8:48] Empty/Unknown
│ └sdd1 3.64t [8:49] Empty/Unknown
│  └md127 0.00k [9:127] MD v1.0 raid5 (7) inactive, 128k Chunk, None 
(None) None {None}
│                       Empty/Unknown
├scsi 0:0:3:0 SEAGATE  ST4000NM0023
│└sde 0.00k [8:64] Empty/Unknown
├scsi 0:0:4:0 SEAGATE  ST4000NM0023
│└sdf 3.64t [8:80] Empty/Unknown
│ └sdf1 3.64t [8:81] Empty/Unknown
│  └md127 0.00k [9:127] MD v1.0 raid5 (7) inactive, 128k Chunk, None 
(None) None {None}
│                       Empty/Unknown
├scsi 0:0:5:0 SEAGATE  ST4000NM0023
│└sdg 3.64t [8:96] Empty/Unknown
│ └sdg1 3.64t [8:97] Empty/Unknown
│  └md127 0.00k [9:127] MD v1.0 raid5 (7) inactive, 128k Chunk, None 
(None) None {None}
│                       Empty/Unknown
├scsi 0:0:6:0 SEAGATE  ST4000NM0023
│└sdh 3.64t [8:112] Empty/Unknown
│ └sdh1 3.64t [8:113] Empty/Unknown
│  └md127 0.00k [9:127] MD v1.0 raid5 (7) inactive, 128k Chunk, None 
(None) None {None}
│                       Empty/Unknown
├scsi 0:0:7:0 SEAGATE  ST4000NM0023
│└sdi 3.64t [8:128] Empty/Unknown
│ └sdi1 3.64t [8:129] Empty/Unknown
└scsi 0:x:x:x [Empty]
PCI [pata_atiixp]
├scsi 1:x:x:x [Empty]
└scsi 2:x:x:x [Empty]
PCI [ahci]
├scsi 3:0:0:0 PIONEER  DVD-RW  DVR-219L {KEQC279436WL}
│└sr0 1.00g [11:0] Empty/Unknown
├scsi 4:x:x:x [Empty]
├scsi 5:0:0:0 ATA      INTEL SSDSC2CW12
│└sda 111.79g [8:0] Empty/Unknown
│ ├sda1 20.00g [8:1] Empty/Unknown
│ │└Mounted as /dev/sda1 @ /
│ └sda2 91.79g [8:2] Empty/Unknown
│  └Mounted as /dev/sda2 @ /ssd
└scsi 6:x:x:x [Empty]
  **************************************
mdadm-detail.txt
/dev/md127:
            Version : 1.0
      Creation Time : Fri Aug 28 10:59:49 2015
         Raid Level : raid5
      Used Dev Size : 18446744073709551615
       Raid Devices : 7
      Total Devices : 6
        Persistence : Superblock is persistent

        Update Time : Thu Aug 31 00:59:15 2017
              State : active, FAILED, Not Started
     Active Devices : 5
    Working Devices : 6
     Failed Devices : 0
      Spare Devices : 1

             Layout : left-symmetric
         Chunk Size : 128K

Consistency Policy : unknown

               Name : any:raid5
               UUID : 2a235c2d:1ac674d3:7fd8bd23:1ff7e37b
             Events : 20211

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
        1       8       49        1      active sync   /dev/sdd1
        -       0        0        2      removed
        3       8       81        3      active sync   /dev/sdf1
        8       8       33        4      active sync   /dev/sdc1
        5       8      113        5      active sync   /dev/sdh1
        -       0        0        6      removed

        9       8       97        -      spare   /dev/sdg1
  **************************************
mdadm-examine.txt
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x1
      Array UUID : 2a235c2d:1ac674d3:7fd8bd23:1ff7e37b
            Name : any:raid5
   Creation Time : Fri Aug 28 10:59:49 2015
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7814033128 (3726.02 GiB 4000.78 GB)
      Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
   Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
    Super Offset : 7814033392 sectors
    Unused Space : before=0 sectors, after=472 sectors
           State : clean
     Device UUID : fdd6f8fc:316b273c:78ae65ed:9b779577

Internal Bitmap : -24 sectors from superblock
     Update Time : Thu Aug 31 00:59:15 2017
   Bad Block Log : 512 entries available at offset -8 sectors
        Checksum : ab3cc85c - correct
          Events : 20211

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 0
    Array State : AA.AAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x1
      Array UUID : 2a235c2d:1ac674d3:7fd8bd23:1ff7e37b
            Name : any:raid5
   Creation Time : Fri Aug 28 10:59:49 2015
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7814036816 (3726.02 GiB 4000.79 GB)
      Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
   Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
    Super Offset : 7814037080 sectors
    Unused Space : before=0 sectors, after=4160 sectors
           State : clean
     Device UUID : 584fb131:a049ae6c:0ac2150d:d3a66665

Internal Bitmap : -24 sectors from superblock
     Update Time : Thu Aug 31 00:59:15 2017
   Bad Block Log : 512 entries available at offset -8 sectors
        Checksum : 1dfd7ec7 - correct
          Events : 20211

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 4
    Array State : AA.AAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x1
      Array UUID : 2a235c2d:1ac674d3:7fd8bd23:1ff7e37b
            Name : any:raid5
   Creation Time : Fri Aug 28 10:59:49 2015
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7814036816 (3726.02 GiB 4000.79 GB)
      Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
   Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
    Super Offset : 7814037080 sectors
    Unused Space : before=0 sectors, after=4160 sectors
           State : clean
     Device UUID : e5105c14:b165df48:a1c06442:dfb7b075

Internal Bitmap : -24 sectors from superblock
     Update Time : Thu Aug 31 00:59:15 2017
   Bad Block Log : 512 entries available at offset -8 sectors
        Checksum : 22726c01 - correct
          Events : 20211

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 1
    Array State : AA.AAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x1
      Array UUID : 2a235c2d:1ac674d3:7fd8bd23:1ff7e37b
            Name : any:raid5
   Creation Time : Fri Aug 28 10:59:49 2015
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7814033128 (3726.02 GiB 4000.78 GB)
      Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
   Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
    Super Offset : 7814033392 sectors
    Unused Space : before=0 sectors, after=472 sectors
           State : clean
     Device UUID : c0cbff05:4b24998c:4f1d290b:26cc9c6a

Internal Bitmap : -24 sectors from superblock
     Update Time : Thu Aug 31 00:59:15 2017
   Bad Block Log : 512 entries available at offset -8 sectors
        Checksum : 1580399d - correct
          Events : 20211

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 3
    Array State : AA.AAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x9
      Array UUID : 2a235c2d:1ac674d3:7fd8bd23:1ff7e37b
            Name : any:raid5
   Creation Time : Fri Aug 28 10:59:49 2015
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7814033368 (3726.02 GiB 4000.79 GB)
      Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
   Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
    Super Offset : 7814033392 sectors
    Unused Space : before=0 sectors, after=472 sectors
           State : clean
     Device UUID : 7896d45b:b7037e5d:e30ea8fc:d3f0503c

Internal Bitmap : -24 sectors from superblock
     Update Time : Thu Aug 31 00:59:15 2017
   Bad Block Log : 512 entries available at offset -8 sectors - bad 
blocks present.
        Checksum : ff6cfb00 - correct
          Events : 20211

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : spare
    Array State : AA.AAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x1
      Array UUID : 2a235c2d:1ac674d3:7fd8bd23:1ff7e37b
            Name : any:raid5
   Creation Time : Fri Aug 28 10:59:49 2015
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7814036816 (3726.02 GiB 4000.79 GB)
      Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
   Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
    Super Offset : 7814037080 sectors
    Unused Space : before=0 sectors, after=4160 sectors
           State : clean
     Device UUID : 11314133:cb254486:61591214:7e382352

Internal Bitmap : -24 sectors from superblock
     Update Time : Thu Aug 31 00:59:15 2017
   Bad Block Log : 512 entries available at offset -8 sectors
        Checksum : 2cdc65aa - correct
          Events : 20211

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 5
    Array State : AA.AAA. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdi1:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x9
      Array UUID : 2a235c2d:1ac674d3:7fd8bd23:1ff7e37b
            Name : any:raid5
   Creation Time : Fri Aug 28 10:59:49 2015
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7814036816 (3726.02 GiB 4000.79 GB)
      Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
   Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
    Super Offset : 7814037080 sectors
    Unused Space : before=0 sectors, after=4160 sectors
           State : clean
     Device UUID : b89e3aad:88e3459e:6a1131a0:2136e318

Internal Bitmap : -24 sectors from superblock
     Update Time : Thu Aug 31 00:56:04 2017
   Bad Block Log : 512 entries available at offset -8 sectors - bad 
blocks present.
        Checksum : 11c2a904 - correct
          Events : 20187

          Layout : left-symmetric
      Chunk Size : 128K

    Device Role : Active device 6
    Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  **************************************
smartctl.log
   **** /dev/sdb ***
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.4.79-19-default] (SUSE RPM)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               SEAGATE
Product:              ST4000NM0023
Revision:             0004
Compliance:           SPC-4
User Capacity:        4,000,787,030,016 bytes [4.00 TB]
Logical block size:   512 bytes
LU is fully provisioned
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000c5007408192f
Serial number:        Z1Z4NYQ40000C45018BF
Device type:          disk
Transport protocol:   SAS (SPL-3)
Local Time is:        Fri Sep  1 14:00:46 2017 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
SMART Health Status: OK

   **** /dev/sdc ***
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.4.79-19-default] (SUSE RPM)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               SEAGATE
Product:              ST4000NM0023
Revision:             0004
Compliance:           SPC-4
User Capacity:        4,000,787,030,016 bytes [4.00 TB]
Logical block size:   512 bytes
LU is fully provisioned
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000c50074219767
Serial number:        Z1Z2JCK6000094175KML
Device type:          disk
Transport protocol:   SAS (SPL-3)
Local Time is:        Fri Sep  1 14:00:46 2017 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
SMART Health Status: OK

   **** /dev/sdd ***
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.4.79-19-default] (SUSE RPM)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               SEAGATE
Product:              ST4000NM0023
Revision:             0004
Compliance:           SPC-4
User Capacity:        4,000,787,030,016 bytes [4.00 TB]
Logical block size:   512 bytes
LU is fully provisioned
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000c500560462f3
Serial number:        Z1Z0APPP0000931601QK
Device type:          disk
Transport protocol:   SAS (SPL-3)
Local Time is:        Fri Sep  1 14:00:46 2017 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
SMART Health Status: OK

   **** /dev/sde ***
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.4.79-19-default] (SUSE RPM)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               SEAGATE
Product:              ST4000NM0023
Revision:             0004
Compliance:           SPC-4
LU is fully provisioned
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000c50056055c0b
Serial number:        Z1Z0AXBZ0000931612Q8
Device type:          disk
Transport protocol:   SAS (SPL-3)
Local Time is:        Fri Sep  1 14:00:46 2017 CDT
device is NOT READY (e.g. spun down, busy)
A mandatory SMART command failed: exiting. To continue, add one or more 
'-T permissive' options.
   **** /dev/sdf ***
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.4.79-19-default] (SUSE RPM)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               SEAGATE
Product:              ST4000NM0023
Revision:             0004
Compliance:           SPC-4
User Capacity:        4,000,787,030,016 bytes [4.00 TB]
Logical block size:   512 bytes
LU is fully provisioned
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000c5005d7d83bf
Serial number:        Z1Z3754K0000C42685HC
Device type:          disk
Transport protocol:   SAS (SPL-3)
Local Time is:        Fri Sep  1 14:00:46 2017 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
SMART Health Status: OK

   **** /dev/sdg ***
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.4.79-19-default] (SUSE RPM)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               SEAGATE
Product:              ST4000NM0023
Revision:             0006
Compliance:           SPC-4
User Capacity:        4,000,787,030,016 bytes [4.00 TB]
Logical block size:   512 bytes
LU is fully provisioned
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000c5008d70f983
Serial number:        Z1Z8L3760000C5407BQU
Device type:          disk
Transport protocol:   SAS (SPL-3)
Local Time is:        Fri Sep  1 14:00:47 2017 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
SMART Health Status: OK

   **** /dev/sdh ***
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.4.79-19-default] (SUSE RPM)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               SEAGATE
Product:              ST4000NM0023
Revision:             0004
Compliance:           SPC-4
User Capacity:        4,000,787,030,016 bytes [4.00 TB]
Logical block size:   512 bytes
LU is fully provisioned
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000c500560559bb
Serial number:        Z1Z0AXFK0000931612EY
Device type:          disk
Transport protocol:   SAS (SPL-3)
Local Time is:        Fri Sep  1 14:00:47 2017 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
SMART Health Status: FAILURE PREDICTION THRESHOLD EXCEEDED: ascq=0x5 
[asc=5d, ascq=5]

   **** /dev/sdi ***
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.4.79-19-default] (SUSE RPM)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               SEAGATE
Product:              ST4000NM0023
Revision:             0004
Compliance:           SPC-4
User Capacity:        4,000,787,030,016 bytes [4.00 TB]
Logical block size:   512 bytes
LU is fully provisioned
Rotation Rate:        7200 rpm
Form Factor:          3.5 inches
Logical Unit id:      0x5000c50056055ddb
Serial number:        Z1Z0AXA20000931723JE
Device type:          disk
Transport protocol:   SAS (SPL-3)
Local Time is:        Fri Sep  1 14:00:47 2017 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
SMART Health Status: FAILURE PREDICTION THRESHOLD EXCEEDED: ascq=0x5 
[asc=5d, ascq=5]

gua admin3/RAID5#

