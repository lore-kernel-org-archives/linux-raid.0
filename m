From: David Mitchell <mr.david.mitchell@gmail.com>
Subject: Superblock Missing
Date: Fri, 1 Sep 2017 20:52:23 -0400
Message-ID: <CAANkkp+3WwZvKu60LkU_0VpxZvZuNrrE=qDt=4DPc80AO+sgEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Respectfully requesting some help.

Very similar to what MasterPrenium posted last month, I'm struggling
to recover from a lost superblock after a grow operation.

I had a raid 5 array running since 2012 (metadata version .90)   I
recently grew it from 2TB drives to 4TB.(metadata version 1.2)    The
grow was successful and the array ran for approximately 2 weeks.
After that I booted to a LiveCD, changed out a boot drive (not in the
array) reinstalled Grub, etc.
After doing the work I rebooted and attempted to load the array.
With the new boot drive I didn't realize it at the time, but I was
missing the raid456 module.   The array wouldn't load.    I fixed the
kernel & module issues, and attempted to load but it said missing
superblock info.  I was dumbfounded because the array had nothing to
do with the boot/OS drive.

Problem: Superblock not found

The hard drives are all good.  All the logs looked clean, and after
several troubleshooting steps I eventually I ran the command

#mdadm --assemble --force /dev/md0 /dev/sdc1 /dev/sdd1 /dev/sde1

The array immediately went into a sync which completed successfully
the next day.    Still no superblock.


The array starts fine now, but still no superblock.

mdadm --assemble  /dev/md0 /dev/sdc1 /dev/sdd1 /dev/sde1
mdadm: /dev/md0 has been started with 3 drives.
virtual raid # dmesg
[177604.370207] md: md0 stopped.
[177604.385059] md: bind<sdd1>
[177604.385425] md: bind<sde1>
[177604.385591] md: bind<sdc1>
[177604.415558] md/raid:md0: device sdc1 operational as raid disk 0
[177604.415561] md/raid:md0: device sde1 operational as raid disk 2
[177604.415562] md/raid:md0: device sdd1 operational as raid disk 1
[177604.415850] md/raid:md0: allocated 3316kB
[177604.417538] md/raid:md0: raid level 5 active with 3 out of 3
devices, algorithm 2
[177604.417540] RAID conf printout:
[177604.417541]  --- level:5 rd:3 wd:3
[177604.417543]  disk 0, o:1, dev:sdc1
[177604.417544]  disk 1, o:1, dev:sdd1
[177604.417545]  disk 2, o:1, dev:sde1
[177604.417637] created bitmap (30 pages) for device md0
[177604.418110] md0: bitmap initialized from disk: read 2 pages, set 0
of 59518 bits
[177605.200213] md0: detected capacity change from 0 to 7988370735104


# mdadm --examine /dev/md0
mdadm: No md superblock detected on /dev/md0.


As a troubleshooting step I tried:

mdadm --grow /dev/md0 --size max
mdadm: component size of /dev/md0 unchanged at 3900571648K

I believe this shows the pre-grow size of 4TB, not the current correct
amount of 8TB

Any ideas (other than restore) would be appreciated.



Requested from "When Things Go Wrong"

-------------------------------------
# mdadm --examine /dev/sd[cde]1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 964fd303:748b8f0e:58f384ce:3fde97cc
           Name : virtual:0  (local to host virtual)
  Creation Time : Sat Aug 26 16:21:20 2017
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 7801143296 (3719.88 GiB 3994.19 GB)
     Array Size : 7801143296 (7439.75 GiB 7988.37 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D0 sectors
          State : clean
    Device UUID : 77580f12:adf88476:d9c1448b:b041443f

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Aug 31 22:21:32 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : adbbd4f2 - correct
         Events : 6261

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D rep=
lacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 964fd303:748b8f0e:58f384ce:3fde97cc
           Name : virtual:0  (local to host virtual)
  Creation Time : Sat Aug 26 16:21:20 2017
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 7801143296 (3719.88 GiB 3994.19 GB)
     Array Size : 7801143296 (7439.75 GiB 7988.37 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D0 sectors
          State : clean
    Device UUID : 1cb11ccc:2aeb095d:6be1838b:7d7b33b7

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Aug 31 22:21:32 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c67c7975 - correct
         Events : 6261

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D rep=
lacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 964fd303:748b8f0e:58f384ce:3fde97cc
           Name : virtual:0  (local to host virtual)
  Creation Time : Sat Aug 26 16:21:20 2017
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 7801143296 (3719.88 GiB 3994.19 GB)
     Array Size : 7801143296 (7439.75 GiB 7988.37 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D0 sectors
          State : clean
    Device UUID : c322a4fb:ec99f835:0ce9cb45:ce6b376d

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Aug 31 22:21:32 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 3f3e91d2 - correct
         Events : 6261

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D rep=
lacing)

------------------------------------------------

# mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sat Aug 26 16:21:20 2017
     Raid Level : raid5
     Array Size : 7801143296 (7439.75 GiB 7988.37 GB)
  Used Dev Size : 3900571648 (3719.88 GiB 3994.19 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Aug 31 22:21:32 2017
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : virtual:0  (local to host virtual)
           UUID : 964fd303:748b8f0e:58f384ce:3fde97cc
         Events : 6261

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       3       8       65        2      active sync   /dev/sde1

---------------------------------------------------------------------------

# ./lsdrv
PCI [ahci] 00:17.0 SATA controller: Intel Corporation Sunrise Point-H
SATA controller [AHCI mode] (rev 31)
=E2=94=9Cscsi 0:0:0:0 ATA      HGST HTS541010A7 {S0A001SSGRU38K}
=E2=94=82=E2=94=94sda 931.51g [8:0] Partitioned (dos)
=E2=94=82 =E2=94=9Csda1 915.64g [8:1] ext4 {119f7409-bb57-4c82-a526-286a639=
779d6}
=E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sda1 @ /
=E2=94=82 =E2=94=9Csda2 1.00k [8:2] Partitioned (dos)
=E2=94=82 =E2=94=94sda5 15.87g [8:5] swap {f2217412-d4d6-4a6e-b699-7f2978db=
9423}
=E2=94=9Cscsi 1:0:0:0 ATA      ST500LM012 HN-M5 {S2SVJ9CC509140}
=E2=94=82=E2=94=94sdb 465.76g [8:16] Partitioned (dos)
=E2=94=82 =E2=94=94sdb1 465.76g [8:17] ext4 {f155bd77-8924-400c-bab4-04b641=
338282}
=E2=94=9Cscsi 2:0:0:0 ATA      WDC WD40EZRZ-00W {WD-WCC4E0XVVCXH}
=E2=94=82=E2=94=94sdc 3.64t [8:32] Partitioned (gpt)
=E2=94=82 =E2=94=94sdc1 3.63t [8:33] MD raid5 (0/3) (w/ sdd1,sde1) in_sync =
'virtual:0'
{964fd303-748b-8f0e-58f3-84ce3fde97cc}
=E2=94=82  =E2=94=94md0 7.27t [9:0] MD v1.2 raid5 (3) clean, 512k Chunk
{964fd303:748b8f0e:58f384ce:3fde97cc}
=E2=94=82                   Empty/Unknown
=E2=94=9Cscsi 3:x:x:x [Empty]
=E2=94=9Cscsi 4:0:0:0 ATA      WDC WD40EZRX-00S {WD-WCC4E0992649}
=E2=94=82=E2=94=94sdd 3.64t [8:48] Partitioned (gpt)
=E2=94=82 =E2=94=94sdd1 3.63t [8:49] MD raid5 (1/3) (w/ sdc1,sde1) in_sync =
'virtual:0'
{964fd303-748b-8f0e-58f3-84ce3fde97cc}
=E2=94=82  =E2=94=94md0 7.27t [9:0] MD v1.2 raid5 (3) clean, 512k Chunk
{964fd303:748b8f0e:58f384ce:3fde97cc}
=E2=94=82                   Empty/Unknown
=E2=94=94scsi 5:0:0:0 ATA      WDC WD40EZRZ-00W {WD-WCC4E6CV0S5R}
 =E2=94=94sde 3.64t [8:64] Partitioned (gpt)
  =E2=94=94sde1 3.63t [8:65] MD raid5 (2/3) (w/ sdc1,sdd1) in_sync 'virtual=
:0'
{964fd303-748b-8f0e-58f3-84ce3fde97cc}
   =E2=94=94md0 7.27t [9:0] MD v1.2 raid5 (3) clean, 512k Chunk
{964fd303:748b8f0e:58f384ce:3fde97cc}
                    Empty/Unknown
PCI [pata_pdc2027x] 04:01.0 Mass storage controller: Promise
Technology, Inc. 20269 (rev 02)
=E2=94=9Cscsi 6:0:0:0 LITE-ON  DVDRW SHW-160P6S {LITE-ON_DVDRW_SHW-160P6S}
=E2=94=82=E2=94=94sr0 1.00g [11:0] Empty/Unknown
=E2=94=94scsi 7:x:x:x [Empty]
Other Block Devices
=E2=94=9Cloop0 0.00k [7:0] Empty/Unknown
=E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
=E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
=E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
=E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
=E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
=E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
=E2=94=9Cloop7 0.00k [7:7] Empty/Unknown
=E2=94=9Cmd127 0.00k [9:127] MD vnone  () clear, None (None) None {None}
=E2=94=82                    Empty/Unknown
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
=E2=94=94ram15 64.00m [1:15] Empty/Unknown

-----------------------------------------------------------------

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
[raid1] [raid10]
md0 : active raid5 sdc1[0] sde1[3] sdd1[1]
      7801143296 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [U=
UU]
      bitmap: 0/30 pages [0KB], 65536KB chunk

unused devices: <none>

---------------------------------------------------------------
# smartctl --xall /dev/sdc
smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-21-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD40EZRZ-00WN9B0
Serial Number:    WD-WCC (removed)
LU WWN Device Id: 5 0014ee 261e42d67
Firmware Version: 80.00A80
User Capacity:    4,000,753,476,096 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Thu Aug 31 22:30:51 2017 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection activity
                    was completed without error.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (53280) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 532) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x7035)    SCT Status supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   204   181   021    -    6758
  4 Start_Stop_Count        -O--CK   100   100   000    -    120
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   079   079   000    -    15652
 10 Spin_Retry_Count        -O--CK   100   100   000    -    0
 11 Calibration_Retry_Count -O--CK   100   100   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    120
192 Power-Off_Retract_Count -O--CK   200   200   000    -    83
193 Load_Cycle_Count        -O--CK   170   170   000    -    92101
194 Temperature_Celsius     -O---K   123   109   000    -    29
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb6  GPL,SL  VS       1  Device vendor specific log
0xb7       GPL,SL  VS      39  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xcf       GPL     VS   65535  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%         0       =
  -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    29 Celsius
Power Cycle Min/Max Temperature:     29/32 Celsius
Lifetime    Min/Max Temperature:     19/43 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (109)

Index    Estimated Time   Temperature Celsius
 110    2017-08-31 14:33    29  **********
 ...    ..(476 skipped).    ..  **********
 109    2017-08-31 22:30    29  **********

SCT Error Recovery Control command not supported

Device Statistics (GP/SMART Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2           10  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           10  Device-to-host register FISes sent due to a COMRESE=
T
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4       178857  Vendor specific

# smartctl --xall /dev/sdd
smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-21-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Green
Device Model:     WDC WD40EZRX-00SPEB0
Serial Number:    WD-WCC(removed)
LU WWN Device Id: 5 0014ee 2b47635c2
Firmware Version: 80.00A80
User Capacity:    4,000,753,476,096 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Thu Aug 31 22:30:54 2017 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection activity
                    was completed without error.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (52020) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 520) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x7035)    SCT Status supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   202   171   021    -    6900
  4 Start_Stop_Count        -O--CK   092   092   000    -    8907
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   100   253   000    -    0
  9 Power_On_Hours          -O--CK   075   075   000    -    18350
 10 Spin_Retry_Count        -O--CK   100   100   000    -    0
 11 Calibration_Retry_Count -O--CK   100   100   000    -    0
 12 Power_Cycle_Count       -O--CK   099   099   000    -    1075
192 Power-Off_Retract_Count -O--CK   200   200   000    -    88
193 Load_Cycle_Count        -O--CK   185   185   000    -    46420
194 Temperature_Celsius     -O---K   119   098   000    -    33
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xcf       GPL     VS   65535  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    33 Celsius
Power Cycle Min/Max Temperature:     33/36 Celsius
Lifetime    Min/Max Temperature:     13/54 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (443)

Index    Estimated Time   Temperature Celsius
 444    2017-08-31 14:33    34  ***************
 ...    ..(426 skipped).    ..  ***************
 393    2017-08-31 21:40    34  ***************
 394    2017-08-31 21:41    33  **************
 ...    ..(  6 skipped).    ..  **************
 401    2017-08-31 21:48    33  **************
 402    2017-08-31 21:49    34  ***************
 403    2017-08-31 21:50    34  ***************
 404    2017-08-31 21:51    33  **************
 ...    ..( 32 skipped).    ..  **************
 437    2017-08-31 22:24    33  **************
 438    2017-08-31 22:25    34  ***************
 ...    ..(  4 skipped).    ..  ***************
 443    2017-08-31 22:30    34  ***************

SCT Error Recovery Control command not supported

Device Statistics (GP/SMART Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2           10  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           10  Device-to-host register FISes sent due to a COMRESE=
T
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4       178859  Vendor specific

# smartctl --xall /dev/sde
smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-21-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD40EZRZ-00WN9B0
Serial Number:    WD-WCC(removed)
LU WWN Device Id: 5 0014ee 2b73a30c5
Firmware Version: 80.00A80
User Capacity:    4,000,753,476,096 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Thu Aug 31 22:30:56 2017 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection activity
                    was completed without error.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (50160) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 502) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x7035)    SCT Status supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   195   169   021    -    7208
  4 Start_Stop_Count        -O--CK   100   100   000    -    114
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   079   079   000    -    15651
 10 Spin_Retry_Count        -O--CK   100   100   000    -    0
 11 Calibration_Retry_Count -O--CK   100   100   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    114
192 Power-Off_Retract_Count -O--CK   200   200   000    -    77
193 Load_Cycle_Count        -O--CK   170   170   000    -    92696
194 Temperature_Celsius     -O---K   122   107   000    -    30
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb6  GPL,SL  VS       1  Device vendor specific log
0xb7       GPL,SL  VS      39  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xcf       GPL     VS   65535  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%         0       =
  -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    30 Celsius
Power Cycle Min/Max Temperature:     30/33 Celsius
Lifetime    Min/Max Temperature:     20/45 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (52)

Index    Estimated Time   Temperature Celsius
  53    2017-08-31 14:33    31  ************
 ...    ..( 87 skipped).    ..  ************
 141    2017-08-31 16:01    31  ************
 142    2017-08-31 16:02    32  *************
 ...    ..( 18 skipped).    ..  *************
 161    2017-08-31 16:21    32  *************
 162    2017-08-31 16:22    31  ************
 ...    ..( 93 skipped).    ..  ************
 256    2017-08-31 17:56    31  ************
 257    2017-08-31 17:57    30  ***********
 ...    ..(  7 skipped).    ..  ***********
 265    2017-08-31 18:05    30  ***********
 266    2017-08-31 18:06    31  ************
 267    2017-08-31 18:07    31  ************
 268    2017-08-31 18:08    30  ***********
 ...    ..(  5 skipped).    ..  ***********
 274    2017-08-31 18:14    30  ***********
 275    2017-08-31 18:15    31  ************
 ...    ..(254 skipped).    ..  ************
  52    2017-08-31 22:30    31  ************

SCT Error Recovery Control command not supported

Device Statistics (GP/SMART Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2            9  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           10  Device-to-host register FISes sent due to a COMRESE=
T
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4       178860  Vendor specific


Sincerely,

David
