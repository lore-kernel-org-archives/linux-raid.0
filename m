From: "Thomas C. Bishop" <bishop@latech.edu>
Subject: Re: raid5 messed up
Date: Wed, 6 Sep 2017 18:47:51 -0500
Message-ID: <42b3f75a-d93d-f20d-579b-901a305fb508@email.latech.edu>
References: <fdbb6bf6-357c-781e-beee-d8589cbb299d@email.latech.edu>
 <d08b6aaf-208e-f4bf-7d19-139103eb14cd@turmel.org>
Reply-To: bishop@latech.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d08b6aaf-208e-f4bf-7d19-139103eb14cd@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: bishop@latech.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks ya'll for assistance.
Here's complete report as suggested at
https://raid.wiki.kernel.org/index.php/Asking_for_help#lsdrv
but using Phils recommended smartctl command line
smartctl -iA -l scterc /dev/sdXn

The wiki recommends
  --xall is rather verbose - for a shorter report you can use "-H -i -l 
scterc" instead

Here's the tcsh script followed by the log

setenv LOG RAID5-info.log

date > $LOG
echo "  cat /etc/mdadm.conf  " >>  $LOG
cat /etc/mdadm.conf >>  $LOG
echo "************** " >>  $LOG

echo " mdadm --detail /dev/md127  "  >> $LOG
mdadm --detail /dev/md127 >> $LOG
echo "************** " >>  $LOG

echo " lsdrv "  >> $LOG
lsdrv/lsdrv/lsdrv >>  $LOG
echo "************** " >>  $LOG

echo "smartclt -iA -l scterc /dev/sd[b-z] " >> $LOG
foreach i (/dev/sd[b-z] )
    echo " **** $i  *** "   >> $LOG
     smartctl -iA -l scterc  $i >> $LOG
end
echo "************** " >>  $LOG

echo " mdadm --examine /dev/sd[b-z] " >> $LOG
foreach i (/dev/sd[b-z] )
    echo " **** $i  *** "   >> $LOG
     mdadm --examine $i >> $LOG
    echo " **** ${i}1  *** "   >> $LOG
     mdadm --examine ${i}1 >> $LOG
end

echo "************** " >>  $LOG



*************************************************************************

Wed Sep  6 18:42:15 CDT 2017
   cat /etc/mdadm.conf
DEVICE containers partitions
ARRAY /dev/md/raid5 UUID=2a235c2d:1ac674d3:7fd8bd23:1ff7e37b
**************
  mdadm --detail /dev/md127
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
**************
  lsdrv
PCI [mpt3sas] 03:00.0 Serial Attached SCSI controller: LSI Logic / 
Symbios Logic SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)
├scsi 0:0:0:0 SEAGATE  ST4000NM0023     {Z1Z4NYQ40000C45018BF}
│└sdb 3.64t [8:16] Partitioned (gpt)
│ └sdb1 3.64t [8:17] MD raid5 (0/7) (w/ sdc1,sdd1,sdf1,sdg1,sdh1) 
in_sync 'any:raid5' {2a235c2d-1ac6-74d3-7fd8-bd231ff7e37b}
│  └md127 0.00k [9:127] MD v1.0 raid5 (7) inactive, 128k Chunk, None 
(None) None {2a235c2d:1ac674d3:7fd8bd23:1ff7e37b}
│                       Empty/Unknown
├scsi 0:0:1:0 SEAGATE  ST4000NM0023     {Z1Z2JCK6000094175KML}
│└sdc 3.64t [8:32] Partitioned (gpt)
│ └sdc1 3.64t [8:33] MD raid5 (4/7) (w/ sdb1,sdd1,sdf1,sdg1,sdh1) 
in_sync 'any:raid5' {2a235c2d-1ac6-74d3-7fd8-bd231ff7e37b}
│  └md127 0.00k [9:127] MD v1.0 raid5 (7) inactive, 128k Chunk, None 
(None) None {2a235c2d:1ac674d3:7fd8bd23:1ff7e37b}
│                       Empty/Unknown
├scsi 0:0:2:0 SEAGATE  ST4000NM0023     {Z1Z0APPP0000931601QK}
│└sdd 3.64t [8:48] Partitioned (gpt)
│ └sdd1 3.64t [8:49] MD raid5 (1/7) (w/ sdb1,sdc1,sdf1,sdg1,sdh1) 
in_sync 'any:raid5' {2a235c2d-1ac6-74d3-7fd8-bd231ff7e37b}
│  └md127 0.00k [9:127] MD v1.0 raid5 (7) inactive, 128k Chunk, None 
(None) None {2a235c2d:1ac674d3:7fd8bd23:1ff7e37b}
│                       Empty/Unknown
├scsi 0:0:3:0 SEAGATE  ST4000NM0023     {Z1Z0AXBZ0000931612Q8}
│└sde 0.00k [8:64] Empty/Unknown
├scsi 0:0:4:0 SEAGATE  ST4000NM0023     {Z1Z3754K0000C42685HC}
│└sdf 3.64t [8:80] Partitioned (gpt)
│ └sdf1 3.64t [8:81] MD raid5 (3/7) (w/ sdb1,sdc1,sdd1,sdg1,sdh1) 
in_sync 'any:raid5' {2a235c2d-1ac6-74d3-7fd8-bd231ff7e37b}
│  └md127 0.00k [9:127] MD v1.0 raid5 (7) inactive, 128k Chunk, None 
(None) None {2a235c2d:1ac674d3:7fd8bd23:1ff7e37b}
│                       Empty/Unknown
├scsi 0:0:5:0 SEAGATE  ST4000NM0023     {Z1Z8L3760000C5407BQU}
│└sdg 3.64t [8:96] Partitioned (gpt)
│ └sdg1 3.64t [8:97] MD raid5 (none/7) (w/ sdb1,sdc1,sdd1,sdf1,sdh1) 
spare 'any:raid5' {2a235c2d-1ac6-74d3-7fd8-bd231ff7e37b}
│  └md127 0.00k [9:127] MD v1.0 raid5 (7) inactive, 128k Chunk, None 
(None) None {2a235c2d:1ac674d3:7fd8bd23:1ff7e37b}
│                       Empty/Unknown
├scsi 0:0:6:0 SEAGATE  ST4000NM0023     {Z1Z0AXFK0000931612EY}
│└sdh 3.64t [8:112] Partitioned (gpt)
│ └sdh1 3.64t [8:113] MD raid5 (5/7) (w/ sdb1,sdc1,sdd1,sdf1,sdg1) 
in_sync 'any:raid5' {2a235c2d-1ac6-74d3-7fd8-bd231ff7e37b}
│  └md127 0.00k [9:127] MD v1.0 raid5 (7) inactive, 128k Chunk, None 
(None) None {2a235c2d:1ac674d3:7fd8bd23:1ff7e37b}
│                       Empty/Unknown
├scsi 0:0:7:0 SEAGATE  ST4000NM0023     {Z1Z0AXA20000931723JE}
│└sdi 3.64t [8:128] Partitioned (gpt)
└scsi 0:x:x:x [Empty]
PCI [pata_atiixp] 00:14.1 IDE interface: Advanced Micro Devices, Inc. 
[AMD/ATI] SB7x0/SB8x0/SB9x0 IDE Controller
├scsi 1:x:x:x [Empty]
└scsi 2:x:x:x [Empty]
PCI [ahci] 00:11.0 SATA controller: Advanced Micro Devices, Inc. 
[AMD/ATI] SB7x0/SB8x0/SB9x0 SATA Controller [IDE mode]
├scsi 3:0:0:0 PIONEER  DVD-RW  DVR-219L {KEQC279436WL}
│└sr0 1.00g [11:0] Empty/Unknown
├scsi 4:x:x:x [Empty]
├scsi 5:0:0:0 ATA      INTEL SSDSC2CW12 {CVCV2026046T120BGN}
│└sda 111.79g [8:0] Partitioned (dos)
│ ├sda1 20.00g [8:1] Partitioned (dos) 
{d8eb06cd-b610-4595-87d1-690981b490c4}
│ │└Mounted as /dev/sda1 @ /
│ └sda2 91.79g [8:2] ext4 {03e3169d-9333-499a-96d6-c795f1d2ec64}
│  └Mounted as /dev/sda2 @ /ssd
└scsi 6:x:x:x [Empty]
**************
smartclt -iA -l scterc /dev/sd[b-z]
  **** /dev/sdb  ***
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
Local Time is:        Wed Sep  6 18:43:57 2017 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
Current Drive Temperature:     40 C
Drive Trip Temperature:        60 C

Manufactured in week 18 of year 2015
Specified cycle count over device lifetime:  10000
Accumulated start-stop cycles:  189
Specified load-unload count over device lifetime:  300000
Accumulated load-unload cycles:  923
Elements in grown defect list: 0

Vendor (Seagate) cache information
   Blocks sent to initiator = 6011066
   Blocks received from initiator = 169713
   Blocks read from cache and sent to initiator = 129432
   Number of read and write commands whose size <= segment size = 11047
   Number of read and write commands whose size > segment size = 0

Vendor (Seagate/Hitachi) factory information
   number of hours powered up = 18383.32
   number of minutes until next internal SMART test = 27

  **** /dev/sdc  ***
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
Local Time is:        Wed Sep  6 18:43:57 2017 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
Current Drive Temperature:     42 C
Drive Trip Temperature:        60 C

Manufactured in week 35 of year 2015
Specified cycle count over device lifetime:  10000
Accumulated start-stop cycles:  146
Specified load-unload count over device lifetime:  300000
Accumulated load-unload cycles:  822
Elements in grown defect list: 0

Vendor (Seagate) cache information
   Blocks sent to initiator = 6053619
   Blocks received from initiator = 156131
   Blocks read from cache and sent to initiator = 121766
   Number of read and write commands whose size <= segment size = 10997
   Number of read and write commands whose size > segment size = 0

Vendor (Seagate/Hitachi) factory information
   number of hours powered up = 16761.75
   number of minutes until next internal SMART test = 27

  **** /dev/sdd  ***
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
Local Time is:        Wed Sep  6 18:43:58 2017 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
Current Drive Temperature:     42 C
Drive Trip Temperature:        60 C

Manufactured in week 07 of year 2013
Specified cycle count over device lifetime:  10000
Accumulated start-stop cycles:  461
Specified load-unload count over device lifetime:  300000
Accumulated load-unload cycles:  34770
Elements in grown defect list: 0

Vendor (Seagate) cache information
   Blocks sent to initiator = 6069527
   Blocks received from initiator = 159843
   Blocks read from cache and sent to initiator = 121997
   Number of read and write commands whose size <= segment size = 11035
   Number of read and write commands whose size > segment size = 0

Vendor (Seagate/Hitachi) factory information
   number of hours powered up = 36609.20
   number of minutes until next internal SMART test = 12

  **** /dev/sde  ***
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
Local Time is:        Wed Sep  6 18:43:59 2017 CDT
device is NOT READY (e.g. spun down, busy)
A mandatory SMART command failed: exiting. To continue, add one or more 
'-T permissive' options.
  **** /dev/sdf  ***
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
Local Time is:        Wed Sep  6 18:43:59 2017 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
Current Drive Temperature:     42 C
Drive Trip Temperature:        60 C

Manufactured in week 41 of year 2014
Specified cycle count over device lifetime:  10000
Accumulated start-stop cycles:  172
Specified load-unload count over device lifetime:  300000
Accumulated load-unload cycles:  976
Elements in grown defect list: 0

Vendor (Seagate) cache information
   Blocks sent to initiator = 5924501
   Blocks received from initiator = 148739
   Blocks read from cache and sent to initiator = 117618
   Number of read and write commands whose size <= segment size = 10744
   Number of read and write commands whose size > segment size = 0

Vendor (Seagate/Hitachi) factory information
   number of hours powered up = 20110.87
   number of minutes until next internal SMART test = 27

  **** /dev/sdg  ***
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
Local Time is:        Wed Sep  6 18:43:59 2017 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
Current Drive Temperature:     41 C
Drive Trip Temperature:        60 C

Manufactured in week 30 of year 2016
Specified cycle count over device lifetime:  10000
Accumulated start-stop cycles:  188
Specified load-unload count over device lifetime:  300000
Accumulated load-unload cycles:  13607
Elements in grown defect list: 0

Vendor (Seagate) cache information
   Blocks sent to initiator = 62016
   Blocks received from initiator = 0
   Blocks read from cache and sent to initiator = 171909
   Number of read and write commands whose size <= segment size = 72
   Number of read and write commands whose size > segment size = 0

Vendor (Seagate/Hitachi) factory information
   number of hours powered up = 7598.68
   number of minutes until next internal SMART test = 10

  **** /dev/sdh  ***
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
Local Time is:        Wed Sep  6 18:44:00 2017 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
Current Drive Temperature:     38 C
Drive Trip Temperature:        60 C

Manufactured in week 07 of year 2013
Specified cycle count over device lifetime:  10000
Accumulated start-stop cycles:  383
Specified load-unload count over device lifetime:  300000
Accumulated load-unload cycles:  34000
Elements in grown defect list: 4393

Vendor (Seagate) cache information
   Blocks sent to initiator = 5970316
   Blocks received from initiator = 175474
   Blocks read from cache and sent to initiator = 122528
   Number of read and write commands whose size <= segment size = 11025
   Number of read and write commands whose size > segment size = 0

Vendor (Seagate/Hitachi) factory information
   number of hours powered up = 36470.55
   number of minutes until next internal SMART test = 9

  **** /dev/sdi  ***
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
Local Time is:        Wed Sep  6 18:44:01 2017 CDT
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

=== START OF READ SMART DATA SECTION ===
Current Drive Temperature:     36 C
Drive Trip Temperature:        60 C

Manufactured in week 07 of year 2013
Specified cycle count over device lifetime:  10000
Accumulated start-stop cycles:  499
Specified load-unload count over device lifetime:  300000
Accumulated load-unload cycles:  27883
Elements in grown defect list: 1271

Vendor (Seagate) cache information
   Blocks sent to initiator = 3324560
   Blocks received from initiator = 14542227
   Blocks read from cache and sent to initiator = 132487
   Number of read and write commands whose size <= segment size = 12734
   Number of read and write commands whose size > segment size = 0

Vendor (Seagate/Hitachi) factory information
   number of hours powered up = 36476.02
   number of minutes until next internal SMART test = 40

**************
  mdadm --examine /dev/sd[b-z]
  **** /dev/sdb  ***
/dev/sdb:
    MBR Magic : aa55
Partition[3] :            1 sectors at            1 (type ee)
  **** /dev/sdb1  ***
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
  **** /dev/sdc  ***
/dev/sdc:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
  **** /dev/sdc1  ***
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
  **** /dev/sdd  ***
/dev/sdd:
    MBR Magic : aa55
Partition[3] :            1 sectors at            1 (type ee)
  **** /dev/sdd1  ***
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
  **** /dev/sde  ***
  **** /dev/sde1  ***
  **** /dev/sdf  ***
/dev/sdf:
    MBR Magic : aa55
Partition[3] :            1 sectors at            1 (type ee)
  **** /dev/sdf1  ***
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
  **** /dev/sdg  ***
/dev/sdg:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
  **** /dev/sdg1  ***
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
  **** /dev/sdh  ***
/dev/sdh:
    MBR Magic : aa55
Partition[3] :            1 sectors at            1 (type ee)
  **** /dev/sdh1  ***
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
  **** /dev/sdi  ***
/dev/sdi:
    MBR Magic : aa55
Partition[3] :            1 sectors at            1 (type ee)
  **** /dev/sdi1  ***
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
**************


