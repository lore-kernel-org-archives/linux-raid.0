From: Cory Derenburger <cory.derenburger@gmail.com>
Subject: Re: Software RAID6 broke after power outage
Date: Wed, 22 Jul 2020 09:29:50 -0700
Message-ID: <CA+CBf3T_GtTwLqKrk4UWj_yPPL7vqJQzBD7Z_J34WWSwmudR5g@mail.gmail.com>
References: <CA+CBf3QZP4Yss0U=6Aa_5a+3D2Yy-WT545VazHiFWCZsreNOEg@mail.gmail.com>
 <CA+CBf3Q8sKv9k83dp38ekkBY1qgvOe2seQOYvxukg-X4__7JkA@mail.gmail.com> <5F180388.6020402@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5F180388.6020402@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Wols,

The version on Linux Mint I've been running is quite old.  Once the
server was last configured it did not have updates.  It was put on a
shelf and (mostly) left alone to serve files reliably for years.

$ mdadm --version
mdadm - v3.2.5 - 18th May 2012

uname -a
Linux LIZZY 3.16.0-38-generic #52~14.04.1-Ubuntu SMP Fri May 8
09:43:57 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

Here is the lsdrv information
./lsdrv
**Warning** The following utility(ies) failed to execute:
  sginfo
Some information may be missing.

Controller platform [None]
=E2=94=94platform floppy.0
 =E2=94=94fd0 0.00k [2:0] Empty/Unknown
PCI [ahci] 00:11.0 SATA controller: Advanced Micro Devices, Inc.
[AMD/ATI] SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
=E2=94=9Cscsi 0:0:0:0 ATA      MKNSSDEC60GB     {ME150901AS2073580}
=E2=94=82=E2=94=94sda 55.90g [8:0] Partitioned (dos)
=E2=94=82 =E2=94=9Csda1 7.92g [8:1] ext4 {ef60a590-af5c-41f6-9166-3988d6646=
092}
=E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/disk/by-uuid/ef60a590-af5c-41f6=
-9166-3988d6646092 @ /
=E2=94=82 =E2=94=9Csda2 1.00k [8:2] Partitioned (dos)
=E2=94=82 =E2=94=9Csda5 36.76g [8:5] ext4 {22fbf184-d791-45c9-8de9-62ee4f0a=
1776}
=E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sda5 @ /home
=E2=94=82 =E2=94=94sda6 1.91g [8:6] swap {4326b017-dea7-489d-850a-29c814ea6=
a99}
=E2=94=9Cscsi 1:0:0:0 ATA      Hitachi HUA72302 {YFGK3VXD}
=E2=94=82=E2=94=94sdb 1.82t [8:16] Partitioned (dos)
=E2=94=82 =E2=94=94sdb1 1.82t [8:17] MD  (none/) (w/ sdd1,sde1) spare 'LIZZ=
Y:0'
{605a2a08-65dc-e76a-967b-4f9e8fc79011}
=E2=94=82  =E2=94=94md0 0.00k [9:0] MD v1.2  () inactive, None (None) None =
{None}
=E2=94=82                   Empty/Unknown
=E2=94=9Cscsi 2:0:0:0 ATA      WDC WD20EARS-00M {WD-WCAZA1597296}
=E2=94=82=E2=94=94sdc 1.82t [8:32] Partitioned (dos)
=E2=94=82 =E2=94=94sdc1 1.82t [8:33] Empty/Unknown
=E2=94=9Cscsi 3:0:0:0 ATA      Hitachi HUA72302 {YFHK9JAA}
=E2=94=82=E2=94=94sdd 1.82t [8:48] Partitioned (dos)
=E2=94=82 =E2=94=94sdd1 1.82t [8:49] MD  (none/) (w/ sdb1,sde1) spare 'LIZZ=
Y:0'
{605a2a08-65dc-e76a-967b-4f9e8fc79011}
=E2=94=82  =E2=94=94md0 0.00k [9:0] MD v1.2  () inactive, None (None) None =
{None}
=E2=94=82                   Empty/Unknown
=E2=94=94scsi 5:0:0:0 ATA      Hitachi HUA72302 {YFG7LWBA}
 =E2=94=94sde 1.82t [8:64] Partitioned (dos)
  =E2=94=94sde1 1.82t [8:65] MD  (none/) (w/ sdb1,sdd1) spare 'LIZZY:0'
{605a2a08-65dc-e76a-967b-4f9e8fc79011}
   =E2=94=94md0 0.00k [9:0] MD v1.2  () inactive, None (None) None {None}
                    Empty/Unknown
PCI [pata_atiixp] 00:14.1 IDE interface: Advanced Micro Devices, Inc.
[AMD/ATI] SB7x0/SB8x0/SB9x0 IDE Controller
=E2=94=94scsi 6:0:0:0 PIONEER  DVD-RW  DVR-116D {PIONEER_DVD-RW_DVR-116D}
 =E2=94=94sr0 1.00g [11:0] Empty/Unknown
PCI [ahci] 02:00.0 SATA controller: Marvell Technology Group Ltd.
Device 9215 (rev 11)
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
=E2=94=94ram15 64.00m [1:15] Empty/Unknown


smartctrl for the drives
# smartctl --xall /dev/sdb
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-38-generic] (local build=
)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     Hitachi HUA723020ALA641
Serial Number:    YFGK3VXD
LU WWN Device Id: 5 000cca 223c7c8d4
Firmware Version: MK7OA840
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 2.6, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Tue Jul 21 12:43:42 2020 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Disabled
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activity
                                        was suspended by an
interrupting command from host.
                                        Auto Offline Data Collection: Enabl=
ed.
Self-test execution status:      (   0) The previous self-test routine comp=
leted
                                        without error or no self-test has e=
ver
                                        been run.
Total time to complete Offline
data collection:                (20116) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 336) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Error Recovery Control supporte=
d.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
  2 Throughput_Performance  P-S---   133   133   054    -    90
  3 Spin_Up_Time            POS---   100   100   024    -    492
  4 Start_Stop_Count        -O--C-   100   100   000    -    7
  5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
  7 Seek_Error_Rate         PO-R--   100   100   067    -    0
  8 Seek_Time_Performance   P-S---   123   123   020    -    31
  9 Power_On_Hours          -O--C-   096   096   000    -    32011
 10 Spin_Retry_Count        PO--C-   100   100   060    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    7
192 Power-Off_Retract_Count -O--CK   100   100   000    -    641
193 Load_Cycle_Count        -O--C-   100   100   000    -    641
194 Temperature_Celsius     -O----   176   176   000    -    34 (Min/Max 23=
/39)
196 Reallocated_Event_Count -O--CK   100   100   000    -    0
197 Current_Pending_Sector  -O---K   100   100   000    -    0
198 Offline_Uncorrectable   ---R--   100   100   000    -    0
199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    0
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
0x03       GPL     R/O      1  Ext. Comprehensive SMART error log
0x04       GPL     R/O      7  Device Statistics log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x08       GPL     R/O      2  Power Conditions log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x20       GPL     R/O      1  Streaming performance log [OBS-8]
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x24       GPL     R/O     63  Current Device Internal Status Data log
0x80       GPL     R/W     63  Host vendor specific log
0x81-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     31921       =
  -
# 2  Extended offline    Completed without error       00%     31753       =
  -
# 3  Extended offline    Completed without error       00%     31585       =
  -
# 4  Extended offline    Completed without error       00%     31417       =
  -
# 5  Extended offline    Completed without error       00%     31249       =
  -
# 6  Extended offline    Completed without error       00%     31081       =
  -
# 7  Extended offline    Completed without error       00%     30913       =
  -
# 8  Extended offline    Completed without error       00%     30745       =
  -
# 9  Extended offline    Completed without error       00%     30577       =
  -
#10  Extended offline    Completed without error       00%     30409       =
  -
#11  Extended offline    Completed without error       00%     30241       =
  -
#12  Extended offline    Completed without error       00%     30073       =
  -
#13  Extended offline    Completed without error       00%     29905       =
  -
#14  Extended offline    Completed without error       00%     29737       =
  -
#15  Extended offline    Completed without error       00%     29569       =
  -
#16  Extended offline    Completed without error       00%     29401       =
  -
#17  Extended offline    Completed without error       00%     29233       =
  -
#18  Extended offline    Completed without error       00%     29065       =
  -
#19  Extended offline    Completed without error       00%     28897       =
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
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        SMART Off-line Data Collection
executing in background (4)
Current Temperature:                    34 Celsius
Power Cycle Min/Max Temperature:     27/34 Celsius
Lifetime    Min/Max Temperature:     23/39 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -40/70 Celsius
Temperature History Size (Index):    128 (37)

Index    Estimated Time   Temperature Celsius
  38    2020-07-21 10:36    33  **************
 ...    ..(  3 skipped).    ..  **************
  42    2020-07-21 10:40    33  **************
  43    2020-07-21 10:41    34  ***************
  44    2020-07-21 10:42    33  **************
 ...    ..( 11 skipped).    ..  **************
  56    2020-07-21 10:54    33  **************
  57    2020-07-21 10:55    34  ***************
  58    2020-07-21 10:56    33  **************
 ...    ..(  5 skipped).    ..  **************
  64    2020-07-21 11:02    33  **************
  65    2020-07-21 11:03    34  ***************
  66    2020-07-21 11:04    33  **************
  67    2020-07-21 11:05    33  **************
  68    2020-07-21 11:06    34  ***************
  69    2020-07-21 11:07    33  **************
 ...    ..(  8 skipped).    ..  **************
  78    2020-07-21 11:16    33  **************
  79    2020-07-21 11:17    34  ***************
  80    2020-07-21 11:18    33  **************
  81    2020-07-21 11:19    33  **************
  82    2020-07-21 11:20    34  ***************
  83    2020-07-21 11:21    33  **************
 ...    ..( 11 skipped).    ..  **************
  95    2020-07-21 11:33    33  **************
  96    2020-07-21 11:34    34  ***************
  97    2020-07-21 11:35    33  **************
 ...    ..( 11 skipped).    ..  **************
 109    2020-07-21 11:47    33  **************
 110    2020-07-21 11:48    34  ***************
 111    2020-07-21 11:49    33  **************
 ...    ..( 10 skipped).    ..  **************
 122    2020-07-21 12:00    33  **************
 123    2020-07-21 12:01    34  ***************
 124    2020-07-21 12:02    33  **************
 125    2020-07-21 12:03    33  **************
 126    2020-07-21 12:04    34  ***************
 127    2020-07-21 12:05    33  **************
 ...    ..(  9 skipped).    ..  **************
   9    2020-07-21 12:15    33  **************
  10    2020-07-21 12:16    34  ***************
  11    2020-07-21 12:17    33  **************
 ...    ..(  2 skipped).    ..  **************
  14    2020-07-21 12:20    33  **************
  15    2020-07-21 12:21    34  ***************
  16    2020-07-21 12:22    33  **************
  17    2020-07-21 12:23    33  **************
  18    2020-07-21 12:24    34  ***************
  19    2020-07-21 12:25    33  **************
  20    2020-07-21 12:26    33  **************
  21    2020-07-21 12:27    34  ***************
  22    2020-07-21 12:28    33  **************
 ...    ..(  3 skipped).    ..  **************
  26    2020-07-21 12:32    33  **************
  27    2020-07-21 12:33    34  ***************
 ...    ..(  9 skipped).    ..  ***************
  37    2020-07-21 12:43    34  ***************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

Device Statistics (GP Log 0x04)
Page Offset Size         Value  Description
  1  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D General Statistics (re=
v 1) =3D=3D
  1  0x008  4                7  Lifetime Power-On Resets
  1  0x010  4            32011  Power-on Hours
  1  0x018  6       7094397844  Logical Sectors Written
  1  0x020  6         32420890  Number of Write Commands
  1  0x028  6     183722166461  Logical Sectors Read
  1  0x030  6        194678316  Number of Read Commands
  3  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D Rotating Media Statist=
ics (rev 1) =3D=3D
  3  0x008  4            32006  Spindle Motor Power-on Hours
  3  0x010  4            32006  Head Flying Hours
  3  0x018  4              641  Head Load Events
  3  0x020  4                0  Number of Reallocated Logical Sectors
  3  0x028  4               12  Read Recovery Attempts
  3  0x030  4                0  Number of Mechanical Start Failures
  4  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D General Errors Statist=
ics (rev 1) =3D=3D
  4  0x008  4                0  Number of Reported Uncorrectable Errors
  4  0x010  4                0  Resets Between Cmd Acceptance and Completio=
n
  5  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D Temperature Statistics=
 (rev 1) =3D=3D
  5  0x008  1               34  Current Temperature
  5  0x010  1               33~ Average Short Term Temperature
  5  0x018  1               31~ Average Long Term Temperature
  5  0x020  1               39  Highest Temperature
  5  0x028  1               23  Lowest Temperature
  5  0x030  1               37~ Highest Average Short Term Temperature
  5  0x038  1               25~ Lowest Average Short Term Temperature
  5  0x040  1               35~ Highest Average Long Term Temperature
  5  0x048  1               25~ Lowest Average Long Term Temperature
  5  0x050  4                0  Time in Over-Temperature
  5  0x058  1               60  Specified Maximum Operating Temperature
  5  0x060  4                0  Time in Under-Temperature
  5  0x068  1                0  Specified Minimum Operating Temperature
  6  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D Transport Statistics (=
rev 1) =3D=3D
  6  0x008  4              169  Number of Hardware Resets
  6  0x010  4              129  Number of ASR Events
  6  0x018  4                0  Number of Interface CRC Errors
                              |_ ~ normalized value

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0009  2           25  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           22  Device-to-host register FISes sent due to a COMRESE=
T
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS

# smartctl --xall /dev/sdc
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-38-generic] (local build=
)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Green (AF)
Device Model:     WDC WD20EARS-00MVWB0
Serial Number:    WD-WCAZA1597296
LU WWN Device Id: 5 0014ee 25a653961
Firmware Version: 51.0AB51
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Tue Jul 21 12:45:57 2020 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Disabled
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabl=
ed.
Self-test execution status:      (   0) The previous self-test routine comp=
leted
                                        without error or no self-test has e=
ver
                                        been run.
Total time to complete Offline
data collection:                (38460) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 371) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x3035) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   199   199   051    -    2027
  3 Spin_Up_Time            POS--K   167   167   021    -    6641
  4 Start_Stop_Count        -O--CK   100   100   000    -    16
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   057   057   000    -    31954
 10 Spin_Retry_Count        -O--CK   100   253   000    -    0
 11 Calibration_Retry_Count -O--CK   100   253   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    14
192 Power-Off_Retract_Count -O--CK   200   200   000    -    11
193 Load_Cycle_Count        -O--CK   001   001   000    -    1121775
194 Temperature_Celsius     -O---K   121   115   000    -    29
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   199   198   000    -    371
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
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
Device Error Count: 89 (device log contains only the most recent 24 errors)
        CR     =3D Command Register
        FEATR  =3D Features Register
        COUNT  =3D Count (was: Sector Count) Register
        LBA_48 =3D Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
        LH     =3D LBA High (was: Cylinder High) Register    ]   LBA
        LM     =3D LBA Mid (was: Cylinder Low) Register      ] Register
        LL     =3D LBA Low (was: Sector Number) Register     ]
        DV     =3D Device (was: Device/Head) Register
        DC     =3D Device Control Register
        ER     =3D Error register
        ST     =3D Status register
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
SS=3Dsec, and sss=3Dmillisec. It "wraps" after 49.710 days.

Error 89 [16] occurred at disk power-on lifetime: 31954 hours (1331
days + 10 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 00 00 08 09 40 00  Error: UNC at LBA =3D 0x00000809 =
=3D 2057

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 c8 00 00 00 00 08 08 40 08     04:18:54.610  READ FPDMA QUEUE=
D
  60 00 08 00 c0 00 00 00 00 08 00 40 08     04:18:54.610  READ FPDMA QUEUE=
D
  60 00 08 00 b8 00 00 e8 e0 88 a0 40 08     04:18:54.609  READ FPDMA QUEUE=
D
  60 00 08 00 b0 00 00 e8 e0 88 00 40 08     04:18:54.204  READ FPDMA QUEUE=
D
  b0 00 da 00 00 00 00 00 c2 4f 00 00 08     04:16:10.310  SMART RETURN STA=
TUS

Error 88 [15] occurred at disk power-on lifetime: 31953 hours (1331
days + 9 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 00 00 08 09 40 00  Error: UNC at LBA =3D 0x00000809 =
=3D 2057

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 30 00 00 00 00 08 08 40 08     03:55:50.295  READ FPDMA QUEUE=
D
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     03:55:50.295  SET
FEATURES [Enable SATA feature]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     03:55:50.293  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     03:55:50.290  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     03:55:50.290  SET
FEATURES [Set transfer mode]

Error 87 [14] occurred at disk power-on lifetime: 31953 hours (1331
days + 9 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 00 00 08 09 40 00  Error: UNC at LBA =3D 0x00000809 =
=3D 2057

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 28 00 00 00 00 08 08 40 08     03:55:50.136  READ FPDMA QUEUE=
D
  60 00 08 00 20 00 00 00 00 08 20 40 08     03:55:50.136  READ FPDMA QUEUE=
D
  60 00 08 00 18 00 00 00 00 0a 00 40 08     03:55:50.135  READ FPDMA QUEUE=
D
  60 00 08 00 10 00 00 00 00 0b f8 40 08     03:55:50.135  READ FPDMA QUEUE=
D
  60 00 08 00 08 00 00 00 00 0b f0 40 08     03:55:50.135  READ FPDMA QUEUE=
D

Error 86 [13] occurred at disk power-on lifetime: 31953 hours (1331
days + 9 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 00 00 08 09 40 00  Error: UNC at LBA =3D 0x00000809 =
=3D 2057

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 e0 00 00 00 00 08 08 40 08     03:55:49.960  READ FPDMA QUEUE=
D
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     03:55:49.960  SET
FEATURES [Enable SATA feature]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     03:55:49.958  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     03:55:49.955  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     03:55:49.955  SET
FEATURES [Set transfer mode]

Error 85 [12] occurred at disk power-on lifetime: 31953 hours (1331
days + 9 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 00 00 08 09 40 00  Error: UNC at LBA =3D 0x00000809 =
=3D 2057

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 d8 00 00 00 00 08 08 40 08     03:55:49.798  READ FPDMA QUEUE=
D
  60 00 08 00 d0 00 00 00 00 08 78 40 08     03:55:49.798  READ FPDMA QUEUE=
D
  60 00 08 00 c8 00 00 00 00 08 38 40 08     03:55:49.798  READ FPDMA QUEUE=
D
  60 00 08 00 c0 00 00 00 00 08 18 40 08     03:55:49.780  READ FPDMA QUEUE=
D
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     03:55:49.780  SET
FEATURES [Enable SATA feature]

Error 84 [11] occurred at disk power-on lifetime: 31953 hours (1331
days + 9 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 00 00 08 09 40 00  Error: UNC at LBA =3D 0x00000809 =
=3D 2057

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 b8 00 00 00 00 08 08 40 08     03:55:49.624  READ FPDMA QUEUE=
D
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     03:55:49.624  SET
FEATURES [Enable SATA feature]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     03:55:49.622  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     03:55:49.619  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     03:55:49.619  SET
FEATURES [Set transfer mode]

Error 83 [10] occurred at disk power-on lifetime: 31953 hours (1331
days + 9 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 00 00 08 09 40 00  Error: UNC at LBA =3D 0x00000809 =
=3D 2057

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 b0 00 00 00 00 08 08 40 08     03:55:49.468  READ FPDMA QUEUE=
D
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     03:55:49.468  SET
FEATURES [Enable SATA feature]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     03:55:49.466  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     03:55:49.463  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     03:55:49.463  SET
FEATURES [Set transfer mode]

Error 82 [9] occurred at disk power-on lifetime: 31953 hours (1331
days + 9 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 00 00 08 09 40 00  Error: UNC at LBA =3D 0x00000809 =
=3D 2057

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 a8 00 00 00 00 08 08 40 08     03:55:49.312  READ FPDMA QUEUE=
D
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     03:55:49.312  SET
FEATURES [Enable SATA feature]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     03:55:49.310  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     03:55:49.307  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     03:55:49.307  SET
FEATURES [Set transfer mode]

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     31866       =
  -
# 2  Extended offline    Completed without error       00%     31698       =
  -
# 3  Extended offline    Completed without error       00%     31530       =
  -
# 4  Extended offline    Completed without error       00%     31363       =
  -
# 5  Extended offline    Completed without error       00%     31195       =
  -
# 6  Extended offline    Completed without error       00%     31027       =
  -
# 7  Extended offline    Completed without error       00%     30859       =
  -
# 8  Extended offline    Completed without error       00%     30691       =
  -
# 9  Extended offline    Completed without error       00%     30523       =
  -
#10  Extended offline    Completed without error       00%     30356       =
  -
#11  Extended offline    Completed without error       00%     30188       =
  -
#12  Extended offline    Completed without error       00%     30020       =
  -
#13  Extended offline    Completed without error       00%     29852       =
  -
#14  Extended offline    Completed without error       00%     29685       =
  -
#15  Extended offline    Completed without error       00%     29517       =
  -
#16  Extended offline    Completed without error       00%     29349       =
  -
#17  Extended offline    Completed without error       00%     29182       =
  -
#18  Extended offline    Completed without error       00%     29014       =
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
Power Cycle Min/Max Temperature:     26/29 Celsius
Lifetime    Min/Max Temperature:     26/35 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (465)

Index    Estimated Time   Temperature Celsius
 466    2020-07-21 04:48    29  **********
 ...    ..( 14 skipped).    ..  **********
   3    2020-07-21 05:03    29  **********
   4    2020-07-21 05:04    31  ************
 ...    ..( 21 skipped).    ..  ************
  26    2020-07-21 05:26    31  ************
  27    2020-07-21 05:27    32  *************
 ...    ..(  3 skipped).    ..  *************
  31    2020-07-21 05:31    32  *************
  32    2020-07-21 05:32    31  ************
  33    2020-07-21 05:33    32  *************
  34    2020-07-21 05:34    31  ************
  35    2020-07-21 05:35    31  ************
  36    2020-07-21 05:36    32  *************
  37    2020-07-21 05:37    32  *************
  38    2020-07-21 05:38    31  ************
 ...    ..( 72 skipped).    ..  ************
 111    2020-07-21 06:51    31  ************
 112    2020-07-21 06:52    30  ***********
 113    2020-07-21 06:53    31  ************
 ...    ..( 18 skipped).    ..  ************
 132    2020-07-21 07:12    31  ************
 133    2020-07-21 07:13    30  ***********
 134    2020-07-21 07:14    31  ************
 ...    ..( 56 skipped).    ..  ************
 191    2020-07-21 08:11    31  ************
 192    2020-07-21 08:12    32  *************
 193    2020-07-21 08:13    31  ************
 194    2020-07-21 08:14    32  *************
 195    2020-07-21 08:15    31  ************
 196    2020-07-21 08:16    32  *************
 197    2020-07-21 08:17    32  *************
 198    2020-07-21 08:18    32  *************
 199    2020-07-21 08:19    31  ************
 200    2020-07-21 08:20    31  ************
 201    2020-07-21 08:21    32  *************
 202    2020-07-21 08:22    31  ************
 ...    ..(  2 skipped).    ..  ************
 205    2020-07-21 08:25    31  ************
 206    2020-07-21 08:26    32  *************
 207    2020-07-21 08:27    32  *************
 208    2020-07-21 08:28    31  ************
 209    2020-07-21 08:29    31  ************
 210    2020-07-21 08:30    31  ************
 211    2020-07-21 08:31    30  ***********
 212    2020-07-21 08:32    31  ************
 ...    ..(  6 skipped).    ..  ************
 219    2020-07-21 08:39    31  ************
 220    2020-07-21 08:40     ?  -
 221    2020-07-21 08:41    26  *******
 ...    ..( 13 skipped).    ..  *******
 235    2020-07-21 08:55    26  *******
 236    2020-07-21 08:56    27  ********
 ...    ..(  9 skipped).    ..  ********
 246    2020-07-21 09:06    27  ********
 247    2020-07-21 09:07    28  *********
 ...    ..( 29 skipped).    ..  *********
 277    2020-07-21 09:37    28  *********
 278    2020-07-21 09:38    29  **********
 279    2020-07-21 09:39    28  *********
 ...    ..( 37 skipped).    ..  *********
 317    2020-07-21 10:17    28  *********
 318    2020-07-21 10:18    29  **********
 319    2020-07-21 10:19    28  *********
 ...    ..(  7 skipped).    ..  *********
 327    2020-07-21 10:27    28  *********
 328    2020-07-21 10:28    29  **********
 329    2020-07-21 10:29    29  **********
 330    2020-07-21 10:30    29  **********
 331    2020-07-21 10:31    28  *********
 332    2020-07-21 10:32    28  *********
 333    2020-07-21 10:33    29  **********
 334    2020-07-21 10:34    29  **********
 335    2020-07-21 10:35    28  *********
 ...    ..(  2 skipped).    ..  *********
 338    2020-07-21 10:38    28  *********
 339    2020-07-21 10:39    29  **********
 340    2020-07-21 10:40    28  *********
 ...    ..( 58 skipped).    ..  *********
 399    2020-07-21 11:39    28  *********
 400    2020-07-21 11:40    29  **********
 401    2020-07-21 11:41    29  **********
 402    2020-07-21 11:42    28  *********
 ...    ..( 25 skipped).    ..  *********
 428    2020-07-21 12:08    28  *********
 429    2020-07-21 12:09    29  **********
 430    2020-07-21 12:10    28  *********
 431    2020-07-21 12:11    28  *********
 432    2020-07-21 12:12    29  **********
 433    2020-07-21 12:13    29  **********
 434    2020-07-21 12:14    29  **********
 435    2020-07-21 12:15    28  *********
 ...    ..(  3 skipped).    ..  *********
 439    2020-07-21 12:19    28  *********
 440    2020-07-21 12:20    29  **********
 441    2020-07-21 12:21    28  *********
 442    2020-07-21 12:22    29  **********
 ...    ..( 22 skipped).    ..  **********
 465    2020-07-21 12:45    29  **********

SCT Error Recovery Control command not supported

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x000a  2           23  Device-to-host register FISes sent due to a COMRESE=
T
0x000b  2            0  CRC errors within host-to-device FIS
0x8000  4        15858  Vendor specific

# smartctl --xall /dev/sdd
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-38-generic] (local build=
)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     Hitachi HUA723020ALA641
Serial Number:    YFHK9JAA
LU WWN Device Id: 5 000cca 223d5f593
Firmware Version: MK7OA840
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 2.6, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Tue Jul 21 12:47:13 2020 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Disabled
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activity
                                        was suspended by an
interrupting command from host.
                                        Auto Offline Data Collection: Enabl=
ed.
Self-test execution status:      (   0) The previous self-test routine comp=
leted
                                        without error or no self-test has e=
ver
                                        been run.
Total time to complete Offline
data collection:                (19618) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 327) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Error Recovery Control supporte=
d.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
  2 Throughput_Performance  P-S---   134   134   054    -    88
  3 Spin_Up_Time            POS---   100   100   024    -    498
  4 Start_Stop_Count        -O--C-   100   100   000    -    7
  5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
  7 Seek_Error_Rate         PO-R--   100   100   067    -    0
  8 Seek_Time_Performance   P-S---   125   125   020    -    30
  9 Power_On_Hours          -O--C-   096   096   000    -    32010
 10 Spin_Retry_Count        PO--C-   100   100   060    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    7
192 Power-Off_Retract_Count -O--CK   100   100   000    -    648
193 Load_Cycle_Count        -O--C-   100   100   000    -    648
194 Temperature_Celsius     -O----   181   181   000    -    33 (Min/Max 23=
/37)
196 Reallocated_Event_Count -O--CK   100   100   000    -    0
197 Current_Pending_Sector  -O---K   100   100   000    -    0
198 Offline_Uncorrectable   ---R--   100   100   000    -    0
199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    0
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
0x03       GPL     R/O      1  Ext. Comprehensive SMART error log
0x04       GPL     R/O      7  Device Statistics log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x08       GPL     R/O      2  Power Conditions log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x20       GPL     R/O      1  Streaming performance log [OBS-8]
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x24       GPL     R/O     63  Current Device Internal Status Data log
0x80       GPL     R/W     63  Host vendor specific log
0x81-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     31920       =
  -
# 2  Extended offline    Completed without error       00%     31752       =
  -
# 3  Extended offline    Completed without error       00%     31584       =
  -
# 4  Extended offline    Completed without error       00%     31416       =
  -
# 5  Extended offline    Completed without error       00%     31248       =
  -
# 6  Extended offline    Completed without error       00%     31080       =
  -
# 7  Extended offline    Completed without error       00%     30912       =
  -
# 8  Extended offline    Completed without error       00%     30744       =
  -
# 9  Extended offline    Completed without error       00%     30576       =
  -
#10  Extended offline    Completed without error       00%     30408       =
  -
#11  Extended offline    Completed without error       00%     30240       =
  -
#12  Extended offline    Completed without error       00%     30072       =
  -
#13  Extended offline    Completed without error       00%     29904       =
  -
#14  Extended offline    Completed without error       00%     29736       =
  -
#15  Extended offline    Completed without error       00%     29568       =
  -
#16  Extended offline    Completed without error       00%     29400       =
  -
#17  Extended offline    Completed without error       00%     29232       =
  -
#18  Extended offline    Completed without error       00%     29064       =
  -
#19  Extended offline    Completed without error       00%     28896       =
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
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        SMART Off-line Data Collection
executing in background (4)
Current Temperature:                    33 Celsius
Power Cycle Min/Max Temperature:     27/34 Celsius
Lifetime    Min/Max Temperature:     23/37 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -40/70 Celsius
Temperature History Size (Index):    128 (6)

Index    Estimated Time   Temperature Celsius
   7    2020-07-21 10:40    33  **************
   8    2020-07-21 10:41    33  **************
   9    2020-07-21 10:42    32  *************
  10    2020-07-21 10:43    33  **************
  11    2020-07-21 10:44    33  **************
  12    2020-07-21 10:45    32  *************
  13    2020-07-21 10:46    33  **************
  14    2020-07-21 10:47    32  *************
  15    2020-07-21 10:48    32  *************
  16    2020-07-21 10:49    33  **************
  17    2020-07-21 10:50    32  *************
  18    2020-07-21 10:51    33  **************
 ...    ..( 11 skipped).    ..  **************
  30    2020-07-21 11:03    33  **************
  31    2020-07-21 11:04    32  *************
  32    2020-07-21 11:05    33  **************
 ...    ..( 15 skipped).    ..  **************
  48    2020-07-21 11:21    33  **************
  49    2020-07-21 11:22    32  *************
  50    2020-07-21 11:23    33  **************
  51    2020-07-21 11:24    33  **************
  52    2020-07-21 11:25    33  **************
  53    2020-07-21 11:26    32  *************
  54    2020-07-21 11:27    32  *************
  55    2020-07-21 11:28    33  **************
 ...    ..(  2 skipped).    ..  **************
  58    2020-07-21 11:31    33  **************
  59    2020-07-21 11:32    32  *************
  60    2020-07-21 11:33    32  *************
  61    2020-07-21 11:34    33  **************
  62    2020-07-21 11:35    32  *************
  63    2020-07-21 11:36    32  *************
  64    2020-07-21 11:37    33  **************
  65    2020-07-21 11:38    32  *************
  66    2020-07-21 11:39    33  **************
  67    2020-07-21 11:40    32  *************
  68    2020-07-21 11:41    32  *************
  69    2020-07-21 11:42    33  **************
  70    2020-07-21 11:43    32  *************
  71    2020-07-21 11:44    32  *************
  72    2020-07-21 11:45    33  **************
  73    2020-07-21 11:46    33  **************
  74    2020-07-21 11:47    32  *************
  75    2020-07-21 11:48    33  **************
  76    2020-07-21 11:49    32  *************
  77    2020-07-21 11:50    33  **************
 ...    ..( 45 skipped).    ..  **************
 123    2020-07-21 12:36    33  **************
 124    2020-07-21 12:37    34  ***************
 125    2020-07-21 12:38    34  ***************
 126    2020-07-21 12:39    33  **************
 ...    ..(  7 skipped).    ..  **************
   6    2020-07-21 12:47    33  **************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

Device Statistics (GP Log 0x04)
Page Offset Size         Value  Description
  1  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D General Statistics (re=
v 1) =3D=3D
  1  0x008  4                7  Lifetime Power-On Resets
  1  0x010  4            32010  Power-on Hours
  1  0x018  6       7053496316  Logical Sectors Written
  1  0x020  6         30154975  Number of Write Commands
  1  0x028  6     183776882028  Logical Sectors Read
  1  0x030  6        197249758  Number of Read Commands
  3  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D Rotating Media Statist=
ics (rev 1) =3D=3D
  3  0x008  4            32005  Spindle Motor Power-on Hours
  3  0x010  4            32005  Head Flying Hours
  3  0x018  4              648  Head Load Events
  3  0x020  4                0  Number of Reallocated Logical Sectors
  3  0x028  4                0  Read Recovery Attempts
  3  0x030  4                0  Number of Mechanical Start Failures
  4  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D General Errors Statist=
ics (rev 1) =3D=3D
  4  0x008  4                0  Number of Reported Uncorrectable Errors
  4  0x010  4                0  Resets Between Cmd Acceptance and Completio=
n
  5  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D Temperature Statistics=
 (rev 1) =3D=3D
  5  0x008  1               33  Current Temperature
  5  0x010  1               33~ Average Short Term Temperature
  5  0x018  1               30~ Average Long Term Temperature
  5  0x020  1               37  Highest Temperature
  5  0x028  1               23  Lowest Temperature
  5  0x030  1               34~ Highest Average Short Term Temperature
  5  0x038  1               25~ Lowest Average Short Term Temperature
  5  0x040  1               33~ Highest Average Long Term Temperature
  5  0x048  1               25~ Lowest Average Long Term Temperature
  5  0x050  4                0  Time in Over-Temperature
  5  0x058  1               60  Specified Maximum Operating Temperature
  5  0x060  4                0  Time in Under-Temperature
  5  0x068  1                0  Specified Minimum Operating Temperature
  6  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D Transport Statistics (=
rev 1) =3D=3D
  6  0x008  4              175  Number of Hardware Resets
  6  0x010  4              130  Number of ASR Events
  6  0x018  4                0  Number of Interface CRC Errors
                              |_ ~ normalized value

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0009  2           25  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           22  Device-to-host register FISes sent due to a COMRESE=
T
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS



# smartctl --xall /dev/sde
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-38-generic] (local build=
)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     Hitachi HUA723020ALA641
Serial Number:    YFG7LWBA
LU WWN Device Id: 5 000cca 223c3757b
Firmware Version: MK7OA840
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 2.6, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Tue Jul 21 12:47:56 2020 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Disabled
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activity
                                        was suspended by an
interrupting command from host.
                                        Auto Offline Data Collection: Enabl=
ed.
Self-test execution status:      (   0) The previous self-test routine comp=
leted
                                        without error or no self-test has e=
ver
                                        been run.
Total time to complete Offline
data collection:                (20614) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 344) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Error Recovery Control supporte=
d.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
  2 Throughput_Performance  P-S---   134   134   054    -    87
  3 Spin_Up_Time            POS---   100   100   024    -    493
  4 Start_Stop_Count        -O--C-   100   100   000    -    7
  5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
  7 Seek_Error_Rate         PO-R--   100   100   067    -    0
  8 Seek_Time_Performance   P-S---   133   133   020    -    27
  9 Power_On_Hours          -O--C-   096   096   000    -    32010
 10 Spin_Retry_Count        PO--C-   100   100   060    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    7
192 Power-Off_Retract_Count -O--CK   100   100   000    -    647
193 Load_Cycle_Count        -O--C-   100   100   000    -    647
194 Temperature_Celsius     -O----   181   181   000    -    33 (Min/Max 23=
/37)
196 Reallocated_Event_Count -O--CK   100   100   000    -    0
197 Current_Pending_Sector  -O---K   100   100   000    -    0
198 Offline_Uncorrectable   ---R--   100   100   000    -    0
199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    0
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
0x03       GPL     R/O      1  Ext. Comprehensive SMART error log
0x04       GPL     R/O      7  Device Statistics log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x08       GPL     R/O      2  Power Conditions log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x20       GPL     R/O      1  Streaming performance log [OBS-8]
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x24       GPL     R/O     63  Current Device Internal Status Data log
0x80       GPL     R/W     63  Host vendor specific log
0x81-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
Device Error Count: 12 (device log contains only the most recent 4 errors)
        CR     =3D Command Register
        FEATR  =3D Features Register
        COUNT  =3D Count (was: Sector Count) Register
        LBA_48 =3D Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
        LH     =3D LBA High (was: Cylinder High) Register    ]   LBA
        LM     =3D LBA Mid (was: Cylinder Low) Register      ] Register
        LL     =3D LBA Low (was: Sector Number) Register     ]
        DV     =3D Device (was: Device/Head) Register
        DC     =3D Device Control Register
        ER     =3D Error register
        ST     =3D Status register
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
SS=3Dsec, and sss=3Dmillisec. It "wraps" after 49.710 days.

Error 12 [3] occurred at disk power-on lifetime: 14988 hours (624 days
+ 12 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 03 ba 00 00 15 53 13 7d 05 00  Error: UNC 954 sectors at
LBA =3D 0x1553137d =3D 357766013

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  25 00 00 04 00 00 00 15 53 13 37 e0 08  2d+22:13:36.175  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 08  2d+22:13:36.171  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]
  ec 03 00 00 00 00 00 00 00 00 00 a0 08  2d+22:13:36.168  IDENTIFY DEVICE
  ef 00 03 00 46 e0 88 af 00 00 00 a0 08  2d+22:13:36.165  SET
FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 08  2d+22:13:36.162  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]

Error 11 [2] occurred at disk power-on lifetime: 14988 hours (624 days
+ 12 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 03 ba 00 00 15 53 13 7d 05 00  Error: UNC 954 sectors at
LBA =3D 0x1553137d =3D 357766013

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  25 00 00 04 00 00 00 15 53 13 37 e0 08  2d+22:13:32.148  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 08  2d+22:13:32.143  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]
  ec 03 00 00 00 00 00 00 00 00 00 a0 08  2d+22:13:32.140  IDENTIFY DEVICE
  ef 00 03 00 46 e0 88 af 00 00 00 a0 08  2d+22:13:32.137  SET
FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 08  2d+22:13:32.133  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]

Error 10 [1] occurred at disk power-on lifetime: 14988 hours (624 days
+ 12 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 03 ba 00 00 15 53 13 7d 05 00  Error: UNC 954 sectors at
LBA =3D 0x1553137d =3D 357766013

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  25 00 00 04 00 00 00 15 53 13 37 e0 08  2d+22:13:28.564  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 08  2d+22:13:28.560  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]
  ec 03 00 00 00 00 00 00 00 00 00 a0 08  2d+22:13:28.556  IDENTIFY DEVICE
  ef 00 03 00 46 e0 88 af 00 00 00 a0 08  2d+22:13:28.553  SET
FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 08  2d+22:13:28.550  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]

Error 9 [0] occurred at disk power-on lifetime: 14988 hours (624 days
+ 12 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 03 ba 00 00 15 53 13 7d 05 00  Error: UNC 954 sectors at
LBA =3D 0x1553137d =3D 357766013

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  25 00 00 04 00 00 00 15 53 13 37 e0 08  2d+22:13:24.974  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 08  2d+22:13:24.971  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]
  ec 03 00 00 00 00 00 00 00 00 00 a0 08  2d+22:13:24.967  IDENTIFY DEVICE
  ef 00 03 00 46 e0 88 af 00 00 00 a0 08  2d+22:13:24.967  SET
FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 08  2d+22:13:24.963  READ NATIVE
MAX ADDRESS EXT [OBS-ACS-3]

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     31921       =
  -
# 2  Extended offline    Completed without error       00%     31753       =
  -
# 3  Extended offline    Completed without error       00%     31585       =
  -
# 4  Extended offline    Completed without error       00%     31417       =
  -
# 5  Extended offline    Completed without error       00%     31249       =
  -
# 6  Extended offline    Completed without error       00%     31081       =
  -
# 7  Extended offline    Completed without error       00%     30913       =
  -
# 8  Extended offline    Completed without error       00%     30745       =
  -
# 9  Extended offline    Completed without error       00%     30576       =
  -
#10  Extended offline    Completed without error       00%     30409       =
  -
#11  Extended offline    Completed without error       00%     30241       =
  -
#12  Extended offline    Completed without error       00%     30073       =
  -
#13  Extended offline    Completed without error       00%     29905       =
  -
#14  Extended offline    Completed without error       00%     29737       =
  -
#15  Extended offline    Completed without error       00%     29569       =
  -
#16  Extended offline    Completed without error       00%     29401       =
  -
#17  Extended offline    Completed without error       00%     29233       =
  -
#18  Extended offline    Completed without error       00%     29065       =
  -
#19  Extended offline    Completed without error       00%     28897       =
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
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        SMART Off-line Data Collection
executing in background (4)
Current Temperature:                    33 Celsius
Power Cycle Min/Max Temperature:     27/34 Celsius
Lifetime    Min/Max Temperature:     23/37 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -40/70 Celsius
Temperature History Size (Index):    128 (111)

Index    Estimated Time   Temperature Celsius
 112    2020-07-21 10:40    33  **************
 ...    ..(111 skipped).    ..  **************
  96    2020-07-21 12:32    33  **************
  97    2020-07-21 12:33    34  ***************
 ...    ..(  5 skipped).    ..  ***************
 103    2020-07-21 12:39    34  ***************
 104    2020-07-21 12:40    33  **************
 ...    ..(  6 skipped).    ..  **************
 111    2020-07-21 12:47    33  **************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

Device Statistics (GP Log 0x04)
Page Offset Size         Value  Description
  1  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D General Statistics (re=
v 1) =3D=3D
  1  0x008  4                7  Lifetime Power-On Resets
  1  0x010  4            32010  Power-on Hours
  1  0x018  6       7079444176  Logical Sectors Written
  1  0x020  6         32145267  Number of Write Commands
  1  0x028  6     183726144100  Logical Sectors Read
  1  0x030  6        193643146  Number of Read Commands
  3  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D Rotating Media Statist=
ics (rev 1) =3D=3D
  3  0x008  4            32005  Spindle Motor Power-on Hours
  3  0x010  4            32005  Head Flying Hours
  3  0x018  4              647  Head Load Events
  3  0x020  4                0  Number of Reallocated Logical Sectors
  3  0x028  4              176  Read Recovery Attempts
  3  0x030  4                0  Number of Mechanical Start Failures
  4  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D General Errors Statist=
ics (rev 1) =3D=3D
  4  0x008  4                0  Number of Reported Uncorrectable Errors
  4  0x010  4                0  Resets Between Cmd Acceptance and Completio=
n
  5  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D Temperature Statistics=
 (rev 1) =3D=3D
  5  0x008  1               33  Current Temperature
  5  0x010  1               33~ Average Short Term Temperature
  5  0x018  1               31~ Average Long Term Temperature
  5  0x020  1               37  Highest Temperature
  5  0x028  1               23  Lowest Temperature
  5  0x030  1               35~ Highest Average Short Term Temperature
  5  0x038  1               25~ Lowest Average Short Term Temperature
  5  0x040  1               33~ Highest Average Long Term Temperature
  5  0x048  1               25~ Lowest Average Long Term Temperature
  5  0x050  4                0  Time in Over-Temperature
  5  0x058  1               60  Specified Maximum Operating Temperature
  5  0x060  4                0  Time in Under-Temperature
  5  0x068  1                0  Specified Minimum Operating Temperature
  6  =3D=3D=3D=3D=3D  =3D                =3D  =3D=3D Transport Statistics (=
rev 1) =3D=3D
  6  0x008  4              184  Number of Hardware Resets
  6  0x010  4              129  Number of ASR Events
  6  0x018  4                0  Number of Interface CRC Errors
                              |_ ~ normalized value

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0009  2           25  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           22  Device-to-host register FISes sent due to a COMRESE=
T
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS






On Wed, Jul 22, 2020 at 2:14 AM Wols Lists <antlists@youngman.org.uk> wrote=
:
>
> On 22/07/20 08:41, Cory Derenburger wrote:
> > My server lost power this morning. The server is running Linux Mint
> > (14?) on a battery backup and I believe it shutdown before losing
> > power. Upon restarting the server the computer hung for a while, and
> > after resetting and booting up in recovery mode my RAID is now
> > nonfunctional.
> >
> > The server was set up years ago with a RAID 6 array built with mdadm.
> > To be honest I don't really know what is wrong with the array, it
> > seems to be an issue with disk sdc. I wanted to reach out for help to
> > confirm the issue and get some guidance before proceeding (or making
> > things worse).
> >
> > Any assistance that can help me determine what steps to take to get
> > this server back up and running would be greatly appreciated. It's
> > been 4+ since I have touched RAID, and only attempted a recovery once.
> > If anyone can help I would be super appreciative.
>
> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
> https://raid.wiki.kernel.org/index.php/Asking_for_help
>
> I see you've included some stuff which is helpful, but can you do
> everything that last page asks for. In particular, lsdrv.
> >
> > Below I'm including outputs from various commands for the 3rd disk
> > which seems to be the culprit
> >
> > dmesg - boot section section where first errors begin occurring
> > [    2.637856] md: bind<sdd1>
> > [    2.646987] random: nonblocking pool is initialized
> > [    2.647432] md: bind<sde1>
> > [    2.651429] md: bind<sdb1>
> > [    2.863538] ata3.00: exception Emask 0x0 SAct 0x10 SErr 0x0 action 0=
x0
> > [    2.863594] ata3.00: irq_stat 0x40000008
> > [    2.863643] ata3.00: failed command: READ FPDMA QUEUED
> > [    2.863695] ata3.00: cmd 60/08:20:08:08:00/00:00:00:00:00/40 tag 4
> > ncq 4096 in
> > [    2.863695]          res 41/40:00:09:08:00/00:00:00:00:00/40 Emask
> > 0x409 (media error) <F>
> > [    2.863775] ata3.00: status: { DRDY ERR }
> > [    2.863822] ata3.00: error: { UNC }
> > [    2.873407] ata3.00: configured for UDMA/133
> > [    2.873476] sd 2:0:0:0: [sdc] Unhandled sense code
> > [    2.873525] sd 2:0:0:0: [sdc]
> > [    2.873571] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> > [    2.873619] sd 2:0:0:0: [sdc]
> > [    2.873665] Sense Key : Medium Error [current] [descriptor]
> > [    2.873819] Descriptor sense data with sense descriptors (in hex):
> > [    2.873901]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> > [    2.874544]         00 00 08 09
> > [    2.874764] sd 2:0:0:0: [sdc]
> > [    2.874811] Add. Sense: Unrecovered read error - auto reallocate fai=
led
> > [    2.874895] sd 2:0:0:0: [sdc] CDB:
> > [    2.874941] Read(10): 28 00 00 00 08 08 00 00 08 00
> > [    2.875428] end_request: I/O error, dev sdc, sector 2057
> > [    2.875478] Buffer I/O error on device sdc1, logical block 1
> >
> > cat /proc/mdstat
> > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> > [raid4] [raid10]
> > md0 : inactive sdb1[0](S) sde1[3](S) sdd1[2](S)
> >       5860147464 blocks super 1.2
> >
> > {not sure why these drives are now showing as spares}
>
> This is very common when an array fails to assemble properly.
> Unfortunately, when there's one error, it often triggers a cascade of
> fake errors, and this is probably the case here.
> >
> > Below running mdstat for sdc.  Checking sdb, sdd, sde appear fine.
> >
> > mdadm --examine /dev/sdc
> > /dev/sdc:   MBR Magic : aa55
> > Partition[0] :   3907027120 sectors at         2048 (type fd)
> >
> > mdadm --examine /dev/sdc1
> > mdadm: No md superblock detected on /dev/sdc1.
> >
> > fdisk -l
> > Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
> > 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
> > Units =3D sectors of 1 * 512 =3D 512 bytes
> > Sector size (logical/physical): 512 bytes / 512 bytes
> > I/O size (minimum/optimal): 512 bytes / 512 bytes
> > Disk identifier: 0x38389fdc
> >
> >    Device Boot      Start         End      Blocks   Id  System
> > /dev/sdb1            2048  3907029167  1953513560   fd  Linux raid auto=
detect
> >
> > Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
> > 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
> > Units =3D sectors of 1 * 512 =3D 512 bytes
> > Sector size (logical/physical): 512 bytes / 512 bytes
> > I/O size (minimum/optimal): 512 bytes / 512 bytes
> > Disk identifier: 0xd108824d
> >
> >    Device Boot      Start         End      Blocks   Id  System
> > /dev/sdc1            2048  3907029167  1953513560   fd  Linux raid auto=
detect
> >
> > Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
> > 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
> > Units =3D sectors of 1 * 512 =3D 512 bytes
> > Sector size (logical/physical): 512 bytes / 512 bytes
> > I/O size (minimum/optimal): 512 bytes / 512 bytes
> > Disk identifier: 0x6207659a
> >
> >    Device Boot      Start         End      Blocks   Id  System
> > /dev/sdd1            2048  3907029167  1953513560   fd  Linux raid auto=
detect
> >
> > Disk /dev/sde: 2000.4 GB, 2000398934016 bytes
> > 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
> > Units =3D sectors of 1 * 512 =3D 512 bytes
> > Sector size (logical/physical): 512 bytes / 512 bytes
> > I/O size (minimum/optimal): 512 bytes / 512 bytes
> > Disk identifier: 0xd9a4afcf
> >
> >    Device Boot      Start         End      Blocks   Id  System
> > /dev/sde1            2048  3907029167  1953513560   fd  Linux raid auto=
detect
> >
> >
> > Is there other information needed to determine the issue?  Where do I
> > go from here?
> >
> How old is linux mint? Have you kept it up-to-date? Unfortunately, it
> seems a lot of older systems suffer issues when the kernel is heavily
> patched and mdadm is not updated, and this regularly surfaces on this
> list where Ubuntu is concerned ...
>
> mdadm --version
> uname -a
>
> Make sure you have a "latest and greatest" rescue disk to hand, and
> we'll see what the others say.
>
> Cheers,
> Wol
>
