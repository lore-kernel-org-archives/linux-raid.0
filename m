From: Youenn Gestin <youenn.gestin@grim-is-a-geek.fr>
Subject: strange mirror write perf
Date: Sun, 19 Mar 2017 16:14:03 +0100
Message-ID: <c0981a7c8b13facace1228ed0f99efdc@grim-is-a-geek.fr>
References: <eda41097b3c3a385f83041f0df372912@grim-is-a-geek.fr>
 <6ec5f2dbefa2b7489d9f39d4833d5113@grim-is-a-geek.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6ec5f2dbefa2b7489d9f39d4833d5113@grim-is-a-geek.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm encountering a drop of write performance after creating a mirror 
with two whole disk ( sdc and sdd ) and i'm not able to find where it 
come from:

Perf before :
abyss ~ # dd bs=1M count=2024 if=/dev/zero of=/dev/sdd conv=fdatasync
2024+0 records in
2024+0 records out
2122317824 bytes (2,1 GB, 2,0 GiB) copied, 14,1238 s, 150 MB/s
abyss ~ # dd bs=1M count=2024 if=/dev/zero of=/dev/sdc conv=fdatasync
2024+0 records in
2024+0 records out
2122317824 bytes (2,1 GB, 2,0 GiB) copied, 14,7046 s, 144 MB/s

Creating the mirror :
abyss ~ # mdadm --create --verbose /dev/md/md6to --level=1
--raid-devices=2 /dev/sdc /dev/sdd
mdadm: Note: this array has metadata at the start and
     may not be suitable as a boot device.  If you plan to
     store '/boot' on this device please ensure that
     your boot-loader understands md/v1.x metadata, or use
     --metadata=0.90
mdadm: size set to 5860391488K
mdadm: automatically enabling write-intent bitmap on large array
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/md6to started.

Perf after :
abyss ~ # dd bs=1M count=2024 if=/dev/zero of=/dev/md/md6to 
conv=fdatasync
2024+0 records in
2024+0 records out
2122317824 bytes (2,1 GB, 2,0 GiB) copied, 21,1528 s, 100 MB/s

I've also tried with a mirror created on two partition and the result
was the same.
I tried with a LVM mirror, the drop of performance was not so important 
:

abyss ~ # vgcreate data_vg /dev/sdc
   Physical volume "/dev/sdc" successfully created.
   Volume group "data_vg" successfully created
abyss ~ # vgextend data_vg /dev/sdd
   Physical volume "/dev/sdd" successfully created.
   Volume group "data_vg" successfully extended
abyss ~ # vgs
   VG      #PV #LV #SN Attr   VSize  VFree
   data_vg   2   0   0 wz--n- 10,92t 10,92t
abyss ~ # lvcreate -L 50G -m1 -n lv_mirror data_vg
   Logical volume "lv_mirror" created.
abyss ~ # dd bs=1M count=2024 if=/dev/zero of=/dev/data_vg/lv_mirror
conv=fdatasync
2024+0 records in
2024+0 records out
2122317824 bytes (2,1 GB, 2,0 GiB) copied, 16,3757 s, 130 MB/s

I didn't notice anything wrong while launching the dd test and watching 
top.

Here are the information from asked
https://raid.wiki.kernel.org/index.php/Asking_for_help

abyss lsdrv # smartctl --xall /dev/sdc
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.10.2-gentoo] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, 
www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD60EFRX-68L0BN1
Serial Number:    WD-WX11D76EPFJV
LU WWN Device Id: 5 0014ee 2b88cbb3d
Firmware Version: 82.00A82
User Capacity:    6 001 175 126 016 bytes [6,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5700 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Fri Mar 17 14:41:32 2017 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                         was never started.
                                         Auto Offline Data Collection: 
Disabled.
Self-test execution status:      (   0) The previous self-test routine 
completed
                                         without error or no self-test 
has ever
                                         been run.
Total time to complete Offline
data collection:                ( 8144) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                         Auto Offline data collection
on/off support.
                                         Suspend Offline collection upon 
new
                                         command.
                                         Offline surface scan supported.
                                         Self-test supported.
                                         Conveyance Self-test supported.
                                         Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                         power-saving mode.
                                         Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                         General Purpose Logging 
supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 735) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x303d) SCT Status supported.
                                         SCT Error Recovery Control 
supported.
                                         SCT Feature Control supported.
                                         SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
   3 Spin_Up_Time            POS--K   208   208   021    -    8558
   4 Start_Stop_Count        -O--CK   100   100   000    -    12
   5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
   7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
   9 Power_On_Hours          -O--CK   100   100   000    -    274
  10 Spin_Retry_Count        -O--CK   100   253   000    -    0
  11 Calibration_Retry_Count -O--CK   100   253   000    -    0
  12 Power_Cycle_Count       -O--CK   100   100   000    -    12
192 Power-Off_Retract_Count -O--CK   200   200   000    -    6
193 Load_Cycle_Count        -O--CK   200   200   000    -    25
194 Temperature_Celsius     -O---K   119   111   000    -    33
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   100   253   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   100   253   000    -    0
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
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb6  GPL,SL  VS       1  Device vendor specific log
0xb7       GPL,SL  VS      54  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
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
If Selective self-test is pending on power-up, resume after 0 minute 
delay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    33 Celsius
Power Cycle Min/Max Temperature:     32/41 Celsius
Lifetime    Min/Max Temperature:     17/41 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (193)

Index    Estimated Time   Temperature Celsius
  194    2017-03-17 06:44    32  *************
  ...    ..(464 skipped).    ..  *************
  181    2017-03-17 14:29    32  *************
  182    2017-03-17 14:30    33  **************
  ...    ..( 10 skipped).    ..  **************
  193    2017-03-17 14:41    33  **************

SCT Error Recovery Control:
            Read:     70 (7,0 seconds)
           Write:     70 (7,0 seconds)

Device Statistics (GP/SMART Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2           13  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2           13  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2           15  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           30  Device-to-host register FISes sent due to a 
COMRESET
0x000b  2            8  CRC errors within host-to-device FIS
0x000d  2            5  Non-CRC errors within host-to-device FIS
0x000f  2            8  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, 
CRC
0x8000  4       318448  Vendor specific

-------------------------------------------------------------------------------

abyss lsdrv # smartctl --xall /dev/sdd
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-4.10.2-gentoo] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, 
www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD60EFRX-68L0BN1
Serial Number:    WD-WX41D964EZK9
LU WWN Device Id: 5 0014ee 263752a6e
Firmware Version: 82.00A82
User Capacity:    6 001 175 126 016 bytes [6,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5700 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Mar 17 14:41:57 2017 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                         was never started.
                                         Auto Offline Data Collection: 
Disabled.
Self-test execution status:      (   0) The previous self-test routine 
completed
                                         without error or no self-test 
has ever
                                         been run.
Total time to complete Offline
data collection:                ( 9344) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                         Auto Offline data collection
on/off support.
                                         Suspend Offline collection upon 
new
                                         command.
                                         Offline surface scan supported.
                                         Self-test supported.
                                         Conveyance Self-test supported.
                                         Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                         power-saving mode.
                                         Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                         General Purpose Logging 
supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 746) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x303d) SCT Status supported.
                                         SCT Error Recovery Control 
supported.
                                         SCT Feature Control supported.
                                         SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
   3 Spin_Up_Time            POS--K   100   253   021    -    0
   4 Start_Stop_Count        -O--CK   100   100   000    -    5
   5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
   7 Seek_Error_Rate         -OSR-K   100   253   000    -    0
   9 Power_On_Hours          -O--CK   100   100   000    -    246
  10 Spin_Retry_Count        -O--CK   100   253   000    -    0
  11 Calibration_Retry_Count -O--CK   100   253   000    -    0
  12 Power_Cycle_Count       -O--CK   100   100   000    -    5
192 Power-Off_Retract_Count -O--CK   200   200   000    -    1
193 Load_Cycle_Count        -O--CK   200   200   000    -    19
194 Temperature_Celsius     -O---K   121   116   000    -    31
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   100   253   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   100   253   000    -    0
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
0x04       GPL,SL  R/O      8  Device Statistics log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x0c       GPL     R/O   2048  Pending Defects log
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb6  GPL,SL  VS       1  Device vendor specific log
0xb7       GPL,SL  VS      54  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
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
If Selective self-test is pending on power-up, resume after 0 minute 
delay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    31 Celsius
Power Cycle Min/Max Temperature:     30/36 Celsius
Lifetime    Min/Max Temperature:     16/36 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (434)

Index    Estimated Time   Temperature Celsius
  435    2017-03-17 06:44    30  ***********
  ...    ..(463 skipped).    ..  ***********
  421    2017-03-17 14:28    30  ***********
  422    2017-03-17 14:29    31  ************
  ...    ..( 11 skipped).    ..  ************
  434    2017-03-17 14:41    31  ************

SCT Error Recovery Control:
            Read:     70 (7,0 seconds)
           Write:     70 (7,0 seconds)

Device Statistics (GP Log 0x04)
Page  Offset Size        Value Flags Description
0x01  =====  =               =  ===  == General Statistics (rev 2) ==
0x01  0x008  4               5  ---  Lifetime Power-On Resets
0x01  0x010  4             246  ---  Power-on Hours
0x01  0x018  6     23708519208  ---  Logical Sectors Written
0x01  0x020  6        24687968  ---  Number of Write Commands
0x01  0x028  6     11729201720  ---  Logical Sectors Read
0x01  0x030  6        22155003  ---  Number of Read Commands
0x03  =====  =               =  ===  == Rotating Media Statistics (rev 
1) ==
0x03  0x008  4             246  ---  Spindle Motor Power-on Hours
0x03  0x010  4              43  ---  Head Flying Hours
0x03  0x018  4              21  ---  Head Load Events
0x03  0x020  4               0  ---  Number of Reallocated Logical 
Sectors
0x03  0x028  4               0  ---  Read Recovery Attempts
0x03  0x030  4               0  ---  Number of Mechanical Start Failures
0x04  =====  =               =  ===  == General Errors Statistics (rev 
1) ==
0x04  0x008  4               0  ---  Number of Reported Uncorrectable 
Errors
0x04  0x010  4               0  ---  Resets Between Cmd Acceptance and
Completion
0x05  =====  =               =  ===  == Temperature Statistics (rev 1) 
==
0x05  0x008  1              31  ---  Current Temperature
0x05  0x010  1              30  ---  Average Short Term Temperature
0x05  0x018  1               -  ---  Average Long Term Temperature
0x05  0x020  1              36  ---  Highest Temperature
0x05  0x028  1              19  ---  Lowest Temperature
0x05  0x030  1              33  ---  Highest Average Short Term 
Temperature
0x05  0x038  1              30  ---  Lowest Average Short Term 
Temperature
0x05  0x040  1               -  ---  Highest Average Long Term 
Temperature
0x05  0x048  1               -  ---  Lowest Average Long Term 
Temperature
0x05  0x050  4               0  ---  Time in Over-Temperature
0x05  0x058  1              60  ---  Specified Maximum Operating 
Temperature
0x05  0x060  4               0  ---  Time in Under-Temperature
0x05  0x068  1               0  ---  Specified Minimum Operating 
Temperature
0x06  =====  =               =  ===  == Transport Statistics (rev 1) ==
0x06  0x008  4              22  ---  Number of Hardware Resets
0x06  0x010  4               3  ---  Number of ASR Events
0x06  0x018  4               0  ---  Number of Interface CRC Errors
                                 |||_ C monitored condition met
                                 ||__ D supports DSN
                                 |___ N normalized value

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
0x0009  2            2  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            4  Device-to-host register FISes sent due to a 
COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, 
CRC
0x8000  4       318477  Vendor specific


abyss lsdrv # mdadm --examine /dev/sdc
/dev/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 183ad93e:c604b817:7099c950:12d36bab
            Name : abyss:md6to  (local to host abyss)
   Creation Time : Mon Mar 13 22:11:47 2017
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 11720783024 (5588.90 GiB 6001.04 GB)
      Array Size : 5860391488 (5588.90 GiB 6001.04 GB)
   Used Dev Size : 11720782976 (5588.90 GiB 6001.04 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=48 sectors
           State : clean
     Device UUID : b55a87f4:15d145d1:19979cc5:e1eafc32

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Mar 17 14:24:32 2017
   Bad Block Log : 512 entries available at offset 32 sectors
        Checksum : b949b844 - correct
          Events : 9925


    Device Role : Active device 1
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)

-----------------------------------------------------------------------------

abyss lsdrv # mdadm --examine /dev/sdd
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 183ad93e:c604b817:7099c950:12d36bab
            Name : abyss:md6to  (local to host abyss)
   Creation Time : Mon Mar 13 22:11:47 2017
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 11720783024 (5588.90 GiB 6001.04 GB)
      Array Size : 5860391488 (5588.90 GiB 6001.04 GB)
   Used Dev Size : 11720782976 (5588.90 GiB 6001.04 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=48 sectors
           State : clean
     Device UUID : ddbae969:eae9cb91:fb7fa642:1932781a

Internal Bitmap : 8 sectors from superblock
     Update Time : Fri Mar 17 14:24:32 2017
   Bad Block Log : 512 entries available at offset 32 sectors
        Checksum : 53b76159 - correct
          Events : 9925


    Device Role : Active device 0
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)

-----------------------------------------------------------------------------

abyss lsdrv # mdadm --detail /dev/md127
/dev/md127:
         Version : 1.2
   Creation Time : Mon Mar 13 22:11:47 2017
      Raid Level : raid1
      Array Size : 5860391488 (5588.90 GiB 6001.04 GB)
   Used Dev Size : 5860391488 (5588.90 GiB 6001.04 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Fri Mar 17 14:24:32 2017
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : abyss:md6to  (local to host abyss)
            UUID : 183ad93e:c604b817:7099c950:12d36bab
          Events : 9925

     Number   Major   Minor   RaidDevice State
        0       8       48        0      active sync   /dev/sdd
        1       8       32        1      active sync   /dev/sdc

-----------------------------------------------------------------------------

abyss lsdrv # python2.7 lsdrv
PCI [hptiop] 01:00.0 RAID bus controller: HighPoint Technologies, Inc.
Device 3520 (rev 09)
└scsi 0:0:0:0 HPT      VD0-0            {}
  └sda 8.19t [8:0] Partitioned (gpt)
   └sda1 8.19t [8:1] ext4 {7262b140-e026-4b53-bc6b-2ac1c1cc4538}
    └Mounted as /dev/sda1 @ /mnt
PCI [ahci] 00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD]
FCH SATA Controller [AHCI mode] (rev 40)
├scsi 1:0:0:0 ATA      OCZ-VERTEX4      {OCZ-9NYS802X56U11736}
│└sdb 238.47g [8:16] Partitioned (dos)
│ └sdb1 238.47g [8:17] ext4 {6de79b5d-dc44-4362-86af-b483fbbe1c65}
│  └Mounted as /dev/sdb1 @ /
├scsi 2:0:0:0 ATA      WDC WD60EFRX-68L {WD-WX11D76EPFJV}
│└sdc 5.46t [8:32] MD raid1 (1/2) (w/ sdd) in_sync 'abyss:md6to'
{183ad93e-c604-b817-7099-c95012d36bab}
│ └md127 5.46t [9:127] MD v1.2 raid1 (2) clean
{183ad93e:c604b817:7099c950:12d36bab}
│                      Empty/Unknown
├scsi 3:0:0:0 ATA      WDC WD60EFRX-68L {WD-WX41D964EZK9}
│└sdd 5.46t [8:48] MD raid1 (0/2) (w/ sdc) in_sync 'abyss:md6to'
{183ad93e-c604-b817-7099-c95012d36bab}
│ └md127 5.46t [9:127] MD v1.2 raid1 (2) clean
{183ad93e:c604b817:7099c950:12d36bab}
│                      Empty/Unknown
├scsi 4:x:x:x [Empty]

-----------------------------------------------------------------------------

abyss lsdrv # cat /proc/mdstat
Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]
md127 : active raid1 sdd[0] sdc[1]
       5860391488 blocks super 1.2 [2/2] [UU]
       bitmap: 0/44 pages [0KB], 65536KB chunk

unused devices: <none>

-----------------------------------------------------------------------------

abyss lsdrv # mdadm --version
mdadm - v4.0 - 2017-01-09

-----------------------------------------------------------------------------

abyss lsdrv # uname -a
Linux abyss 4.10.2-gentoo #2 SMP Mon Mar 13 21:46:37 CET 2017 x86_64
AMD A8-5600K APU with Radeon(tm) HD Graphics AuthenticAMD GNU/Linux


Thanks for your help.

Youenn.
