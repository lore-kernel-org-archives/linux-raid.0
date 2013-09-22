From: Dave Gomboc <dave_gomboc@acm.org>
Subject: Re: raid10 recovery assistance requested
Date: Sun, 22 Sep 2013 22:45:01 +0000
Message-ID: <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com>
 <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com>
 <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com>
 <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com> <523F6692.9090407@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523F6692.9090407@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yikes.  The data had been accessible on the evening of Sat. Sept 14.
I had (apparently falsely) hoped that there were two complete copies
of all the data, and that to restore access it would be enough to
assign the correct drives to position 1 and 2 based on what matched
against the contents of positions 0 and 3.

I have ran these commands on the four 4TB drives that are the copies.
I think the smartctl -x commands in particular you want to see run
against the original set of drives, so after sending this message, I
will take down the machine, swap out the four copied drives for the
four original drives, then run these commands again on the original
drives.

I'm not knowledgeable about the LVM backup file.  Would one typically
happen to be stored in /boot?  That was the only directory I had that
was not part of the raid10 system.  I had distinct logical volumes for
home, opt, usr, var, srv, root (/), and tmp.


Results from the copied drives:


root@sysresccd /root % mdadm -E /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3c76af95:fa16ca54:330b7547:b9040b8a
           Name : cheap:teramooch
  Creation Time : Mon Jan  3 05:47:11 2011
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
     Array Size : 7814041600 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907020800 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 45ffddf1:080172d2:ff5db863:5f6d84e8

    Update Time : Sun Sep 15 09:54:22 2013
       Checksum : 1cbfeaea - correct
         Events : 599

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : .AAA ('A' == active, '.' == missing)


root@sysresccd /root % mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3c76af95:fa16ca54:330b7547:b9040b8a
           Name : cheap:teramooch
  Creation Time : Mon Jan  3 05:47:11 2011
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
     Array Size : 7814041600 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907020800 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 66806913:402f8cfb:a74e11fd:5ca17fee

    Update Time : Sat Sep 14 06:14:13 2013
       Checksum : 6b7397f - correct
         Events : 520

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)


root@sysresccd /root % mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3c76af95:fa16ca54:330b7547:b9040b8a
           Name : cheap:teramooch
  Creation Time : Mon Jan  3 05:47:11 2011
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
     Array Size : 7814041600 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907020800 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 66806913:402f8cfb:a74e11fd:5ca17fee

    Update Time : Sat Sep 14 06:14:13 2013
       Checksum : 6b7397f - correct
         Events : 520

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)


root@sysresccd /root % mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3c76af95:fa16ca54:330b7547:b9040b8a
           Name : cheap:teramooch
  Creation Time : Mon Jan  3 05:47:11 2011
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
     Array Size : 7814041600 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907020800 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 45ffddf1:080172d2:ff5db863:5f6d84e8

    Update Time : Sun Sep 15 09:54:22 2013
       Checksum : 1cbfeaea - correct
         Events : 599

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : .AAA ('A' == active, '.' == missing)


smartctl -x results from the copy drives:

root@sysresccd /root % smartctl -x /dev/sda
smartctl 5.42 2011-10-20 r3458 [x86_64-linux-3.4.52-std371-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     Hitachi HDS724040ALE640
Serial Number:    PK1310PAG62T2J
LU WWN Device Id: 5 000cca 22bc2c4a6
Firmware Version: MJAOA3B0
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Sep 22 15:28:46 2013 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80) Offline data collection activity
was never started.
Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (   24) seconds.
Offline data collection
capabilities: (0x5b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
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
recommended polling time: (   1) minutes.
Extended self-test routine
recommended polling time: ( 255) minutes.
SCT capabilities:       (0x003d) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
  2 Throughput_Performance  P-S---   136   136   054    -    81
  3 Spin_Up_Time            POS---   133   133   024    -    541 (Average 624)
  4 Start_Stop_Count        -O--C-   100   100   000    -    25
  5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
  7 Seek_Error_Rate         PO-R--   100   100   067    -    0
  8 Seek_Time_Performance   P-S---   117   117   020    -    36
  9 Power_On_Hours          -O--C-   100   100   000    -    203
 10 Spin_Retry_Count        PO--C-   100   100   060    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    25
192 Power-Off_Retract_Count -O--CK   100   100   000    -    29
193 Load_Cycle_Count        -O--C-   100   100   000    -    29
194 Temperature_Celsius     -O----   181   181   000    -    33 (Min/Max 19/57)
196 Reallocated_Event_Count -O--CK   100   100   000    -    0
197 Current_Pending_Sector  -O---K   100   100   000    -    0
198 Offline_Uncorrectable   ---R--   100   100   000    -    0
199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    30
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
GP    Log at address 0x03 has    1 sectors [Ext. Comprehensive SMART error log]
GP    Log at address 0x04 has    7 sectors [Device Statistics log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    1 sectors [Extended self-test log]
GP    Log at address 0x08 has    2 sectors [Power Conditions log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error log]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP    Log at address 0x20 has    1 sectors [Streaming performance log]
GP    Log at address 0x21 has    1 sectors [Write stream error log]
GP    Log at address 0x22 has    1 sectors [Read stream error log]
GP/S  Log at address 0x80 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x81 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x82 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x83 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x84 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x85 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x86 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x87 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x88 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x89 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x90 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x91 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x92 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x93 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x94 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x95 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x96 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x97 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x98 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x99 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
Device Error Count: 30 (device log contains only the most recent 4 errors)
CR     = Command Register
FEATR  = Features Register
COUNT  = Count (was: Sector Count) Register
LBA_48 = Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
LH     = LBA High (was: Cylinder High) Register    ]   LBA
LM     = LBA Mid (was: Cylinder Low) Register      ] Register
LL     = LBA Low (was: Sector Number) Register     ]
DV     = Device (was: Device/Head) Register
DC     = Device Control Register
ER     = Error register
ST     = Status register
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 30 [1] occurred at disk power-on lifetime: 60 hours (2 days + 12 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  84 -- 51 00 70 00 00 ca 27 03 10 0a 00  Error: ICRC, ABRT 112
sectors at LBA = 0xca270310 = 3391554320

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  35 00 00 00 80 00 00 ca 27 03 00 e0 00  1d+01:00:14.036  WRITE DMA EXT
  35 00 00 00 80 00 00 ca 27 02 80 e0 00  1d+01:00:14.035  WRITE DMA EXT
  35 00 00 00 80 00 00 ca 27 02 00 e0 00  1d+01:00:14.034  WRITE DMA EXT
  35 00 00 00 80 00 00 ca 27 01 80 e0 00  1d+01:00:14.032  WRITE DMA EXT
  35 00 00 00 80 00 00 ca 27 01 00 e0 00  1d+01:00:14.031  WRITE DMA EXT

Error 29 [0] occurred at disk power-on lifetime: 35 hours (1 days + 11 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  84 -- 51 00 01 00 00 00 00 03 37 00 00  Error: ICRC, ABRT 1 sectors
at LBA = 0x00000337 = 823

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  c8 00 00 00 08 00 03 2f 00 03 30 e0 08     00:15:42.040  READ DMA
  c8 00 00 00 08 00 03 27 00 03 28 e0 08     00:15:42.040  READ DMA
  c8 00 00 00 08 00 03 1f 00 03 20 e0 08     00:15:42.040  READ DMA
  c8 00 00 00 08 00 03 17 00 03 18 e0 08     00:15:42.040  READ DMA
  c8 00 00 00 08 00 03 0f 00 03 10 e0 08     00:15:42.040  READ DMA

Error 28 [3] occurred at disk power-on lifetime: 35 hours (1 days + 11 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  84 -- 51 00 01 00 00 00 00 00 87 00 00  Error: ICRC, ABRT 1 sectors
at LBA = 0x00000087 = 135

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  c8 00 00 00 08 00 00 17 00 00 80 e0 08     00:15:41.223  READ DMA
  c8 00 00 00 08 00 00 7f 00 00 10 e0 08     00:15:41.223  READ DMA
  c8 00 00 00 08 00 00 3f 00 00 78 e0 08     00:15:41.223  READ DMA
  c8 00 00 00 08 00 00 1f 00 00 38 e0 08     00:15:41.223  READ DMA
  c8 00 00 00 08 00 08 07 00 00 18 e0 08     00:15:41.219  READ DMA

Error 27 [2] occurred at disk power-on lifetime: 35 hours (1 days + 11 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  84 -- 51 00 01 00 01 d1 c0 be af 01 00  Error: ICRC, ABRT 1 sectors
at LBA = 0x1d1c0beaf = 7814037167

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 01 d1 c0 be a8 e0 08     00:15:40.351  READ DMA EXT
  c8 00 00 00 08 00 00 07 00 00 08 e0 08     00:15:40.351  READ DMA
  c8 00 00 00 08 c0 be a7 00 00 00 e0 08     00:15:40.326  READ DMA
  25 00 00 00 08 00 01 d1 c0 be a0 e0 08     00:15:40.325  READ DMA EXT
  25 00 00 00 08 00 01 d1 c0 be 00 e0 08     00:15:40.321  READ DMA EXT

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
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    33 Celsius
Power Cycle Min/Max Temperature:     26/34 Celsius
Lifetime    Min/Max Temperature:     19/57 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -40/70 Celsius
Temperature History Size (Index):    128 (52)

Index    Estimated Time   Temperature Celsius
  53    2013-09-22 13:21    43  ************************
 ...    ..( 18 skipped).    ..  ************************
  72    2013-09-22 13:40    43  ************************
  73    2013-09-22 13:41    42  ***********************
 ...    ..(  3 skipped).    ..  ***********************
  77    2013-09-22 13:45    42  ***********************
  78    2013-09-22 13:46    43  ************************
  79    2013-09-22 13:47    43  ************************
  80    2013-09-22 13:48    43  ************************
  81    2013-09-22 13:49    42  ***********************
 ...    ..(  5 skipped).    ..  ***********************
  87    2013-09-22 13:55    42  ***********************
  88    2013-09-22 13:56    43  ************************
  89    2013-09-22 13:57    42  ***********************
  90    2013-09-22 13:58    42  ***********************
  91    2013-09-22 13:59    42  ***********************
  92    2013-09-22 14:00    43  ************************
  93    2013-09-22 14:01    42  ***********************
 ...    ..(  8 skipped).    ..  ***********************
 102    2013-09-22 14:10    42  ***********************
 103    2013-09-22 14:11    43  ************************
 ...    ..(  4 skipped).    ..  ************************
 108    2013-09-22 14:16    43  ************************
 109    2013-09-22 14:17    44  *************************
 110    2013-09-22 14:18    43  ************************
 ...    ..(  3 skipped).    ..  ************************
 114    2013-09-22 14:22    43  ************************
 115    2013-09-22 14:23    44  *************************
 ...    ..(  5 skipped).    ..  *************************
 121    2013-09-22 14:29    44  *************************
 122    2013-09-22 14:30    43  ************************
 ...    ..( 28 skipped).    ..  ************************
  23    2013-09-22 14:59    43  ************************
  24    2013-09-22 15:00    42  ***********************
  25    2013-09-22 15:01    42  ***********************
  26    2013-09-22 15:02    43  ************************
  27    2013-09-22 15:03    42  ***********************
  28    2013-09-22 15:04    43  ************************
  29    2013-09-22 15:05    43  ************************
  30    2013-09-22 15:06    43  ************************
  31    2013-09-22 15:07    42  ***********************
  32    2013-09-22 15:08    42  ***********************
  33    2013-09-22 15:09    43  ************************
 ...    ..(  2 skipped).    ..  ************************
  36    2013-09-22 15:12    43  ************************
  37    2013-09-22 15:13    42  ***********************
  38    2013-09-22 15:14    43  ************************
  39    2013-09-22 15:15     ?  -
  40    2013-09-22 15:16    27  ********
  41    2013-09-22 15:17    27  ********
  42    2013-09-22 15:18    28  *********
  43    2013-09-22 15:19    29  **********
  44    2013-09-22 15:20    29  **********
  45    2013-09-22 15:21    30  ***********
  46    2013-09-22 15:22    31  ************
  47    2013-09-22 15:23    32  *************
  48    2013-09-22 15:24    32  *************
  49    2013-09-22 15:25    32  *************
  50    2013-09-22 15:26    33  **************
  51    2013-09-22 15:27    33  **************
  52    2013-09-22 15:28    33  **************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0009  2            9  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            5  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS



root@sysresccd /root % smartctl -x /dev/sdb
smartctl 5.42 2011-10-20 r3458 [x86_64-linux-3.4.52-std371-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     Hitachi HDS724040ALE640
Serial Number:    PK1311PAG4W5TS
LU WWN Device Id: 5 000cca 22bc2378a
Firmware Version: MJAOA3B0
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Sep 22 15:37:10 2013 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80) Offline data collection activity
was never started.
Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (   24) seconds.
Offline data collection
capabilities: (0x5b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
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
recommended polling time: (   1) minutes.
Extended self-test routine
recommended polling time: ( 255) minutes.
SCT capabilities:       (0x003d) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
  2 Throughput_Performance  P-S---   137   137   054    -    77
  3 Spin_Up_Time            POS---   140   140   024    -    545 (Average 558)
  4 Start_Stop_Count        -O--C-   100   100   000    -    33
  5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
  7 Seek_Error_Rate         PO-R--   100   100   067    -    0
  8 Seek_Time_Performance   P-S---   117   117   020    -    36
  9 Power_On_Hours          -O--C-   100   100   000    -    204
 10 Spin_Retry_Count        PO--C-   100   100   060    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    33
192 Power-Off_Retract_Count -O--CK   100   100   000    -    40
193 Load_Cycle_Count        -O--C-   100   100   000    -    40
194 Temperature_Celsius     -O----   166   166   000    -    36 (Min/Max 19/58)
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
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
GP    Log at address 0x03 has    1 sectors [Ext. Comprehensive SMART error log]
GP    Log at address 0x04 has    7 sectors [Device Statistics log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    1 sectors [Extended self-test log]
GP    Log at address 0x08 has    2 sectors [Power Conditions log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error log]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP    Log at address 0x20 has    1 sectors [Streaming performance log]
GP    Log at address 0x21 has    1 sectors [Write stream error log]
GP    Log at address 0x22 has    1 sectors [Read stream error log]
GP/S  Log at address 0x80 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x81 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x82 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x83 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x84 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x85 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x86 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x87 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x88 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x89 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x90 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x91 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x92 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x93 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x94 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x95 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x96 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x97 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x98 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x99 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
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
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    36 Celsius
Power Cycle Min/Max Temperature:     26/36 Celsius
Lifetime    Min/Max Temperature:     19/58 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -40/70 Celsius
Temperature History Size (Index):    128 (9)

Index    Estimated Time   Temperature Celsius
  10    2013-09-22 13:30    45  **************************
 ...    ..(105 skipped).    ..  **************************
 116    2013-09-22 15:16    45  **************************
 117    2013-09-22 15:17     ?  -
 118    2013-09-22 15:18    27  ********
 119    2013-09-22 15:19    27  ********
 120    2013-09-22 15:20    28  *********
 121    2013-09-22 15:21    28  *********
 122    2013-09-22 15:22    29  **********
 123    2013-09-22 15:23    30  ***********
 124    2013-09-22 15:24    30  ***********
 125    2013-09-22 15:25    31  ************
 126    2013-09-22 15:26    31  ************
 127    2013-09-22 15:27    32  *************
   0    2013-09-22 15:28    32  *************
   1    2013-09-22 15:29    33  **************
   2    2013-09-22 15:30    33  **************
   3    2013-09-22 15:31    34  ***************
   4    2013-09-22 15:32    34  ***************
   5    2013-09-22 15:33    35  ****************
   6    2013-09-22 15:34    35  ****************
   7    2013-09-22 15:35    35  ****************
   8    2013-09-22 15:36    36  *****************
   9    2013-09-22 15:37    36  *****************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0009  2            3  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            1  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS


root@sysresccd /root % smartctl -x /dev/sdc
smartctl 5.42 2011-10-20 r3458 [x86_64-linux-3.4.52-std371-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     Hitachi HDS724040ALE640
Serial Number:    PK1310PAG62REJ
LU WWN Device Id: 5 000cca 22bc2c473
Firmware Version: MJAOA3B0
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Sep 22 15:38:06 2013 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80) Offline data collection activity
was never started.
Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (   24) seconds.
Offline data collection
capabilities: (0x5b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
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
recommended polling time: (   1) minutes.
Extended self-test routine
recommended polling time: ( 255) minutes.
SCT capabilities:       (0x003d) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
  2 Throughput_Performance  P-S---   133   133   054    -    91
  3 Spin_Up_Time            POS---   156   156   024    -    530 (Average 460)
  4 Start_Stop_Count        -O--C-   100   100   000    -    77
  5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
  7 Seek_Error_Rate         PO-R--   100   100   067    -    0
  8 Seek_Time_Performance   P-S---   117   117   020    -    36
  9 Power_On_Hours          -O--C-   100   100   000    -    151
 10 Spin_Retry_Count        PO--C-   100   100   060    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    44
192 Power-Off_Retract_Count -O--CK   100   100   000    -    80
193 Load_Cycle_Count        -O--C-   100   100   000    -    80
194 Temperature_Celsius     -O----   162   162   000    -    37 (Min/Max 19/56)
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
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
GP    Log at address 0x03 has    1 sectors [Ext. Comprehensive SMART error log]
GP    Log at address 0x04 has    7 sectors [Device Statistics log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    1 sectors [Extended self-test log]
GP    Log at address 0x08 has    2 sectors [Power Conditions log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error log]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP    Log at address 0x20 has    1 sectors [Streaming performance log]
GP    Log at address 0x21 has    1 sectors [Write stream error log]
GP    Log at address 0x22 has    1 sectors [Read stream error log]
GP/S  Log at address 0x80 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x81 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x82 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x83 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x84 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x85 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x86 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x87 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x88 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x89 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x90 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x91 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x92 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x93 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x94 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x95 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x96 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x97 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x98 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x99 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
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
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    37 Celsius
Power Cycle Min/Max Temperature:     26/37 Celsius
Lifetime    Min/Max Temperature:     19/56 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -40/70 Celsius
Temperature History Size (Index):    128 (12)

Index    Estimated Time   Temperature Celsius
  13    2013-09-22 13:31    46  ***************************
  14    2013-09-22 13:32    45  **************************
  15    2013-09-22 13:33    45  **************************
  16    2013-09-22 13:34    46  ***************************
  17    2013-09-22 13:35    45  **************************
 ...    ..(  2 skipped).    ..  **************************
  20    2013-09-22 13:38    45  **************************
  21    2013-09-22 13:39    46  ***************************
  22    2013-09-22 13:40    46  ***************************
  23    2013-09-22 13:41    45  **************************
 ...    ..( 45 skipped).    ..  **************************
  69    2013-09-22 14:27    45  **************************
  70    2013-09-22 14:28    46  ***************************
  71    2013-09-22 14:29    45  **************************
 ...    ..( 46 skipped).    ..  **************************
 118    2013-09-22 15:16    45  **************************
 119    2013-09-22 15:17     ?  -
 120    2013-09-22 15:18    27  ********
 121    2013-09-22 15:19    28  *********
 122    2013-09-22 15:20    28  *********
 123    2013-09-22 15:21    29  **********
 124    2013-09-22 15:22    30  ***********
 125    2013-09-22 15:23    30  ***********
 126    2013-09-22 15:24    31  ************
 127    2013-09-22 15:25    31  ************
   0    2013-09-22 15:26    32  *************
   1    2013-09-22 15:27    32  *************
   2    2013-09-22 15:28    33  **************
   3    2013-09-22 15:29    33  **************
   4    2013-09-22 15:30    34  ***************
   5    2013-09-22 15:31    34  ***************
   6    2013-09-22 15:32    34  ***************
   7    2013-09-22 15:33    35  ****************
   8    2013-09-22 15:34    35  ****************
   9    2013-09-22 15:35    36  *****************
  10    2013-09-22 15:36    36  *****************
  11    2013-09-22 15:37    36  *****************
  12    2013-09-22 15:38    37  ******************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0009  2            3  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            1  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS


root@sysresccd /root % smartctl -x /dev/sdd
smartctl 5.42 2011-10-20 r3458 [x86_64-linux-3.4.52-std371-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     Hitachi HDS724040ALE640
Serial Number:    PK1310PAG5ZY0J
LU WWN Device Id: 5 000cca 22bc2b9fc
Firmware Version: MJAOA3B0
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Sep 22 15:39:16 2013 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80) Offline data collection activity
was never started.
Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (   24) seconds.
Offline data collection
capabilities: (0x5b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
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
recommended polling time: (   1) minutes.
Extended self-test routine
recommended polling time: ( 255) minutes.
SCT capabilities:       (0x003d) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
  2 Throughput_Performance  P-S---   137   137   054    -    77
  3 Spin_Up_Time            POS---   129   129   024    -    631 (Average 562)
  4 Start_Stop_Count        -O--C-   100   100   000    -    21
  5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
  7 Seek_Error_Rate         PO-R--   100   100   067    -    0
  8 Seek_Time_Performance   P-S---   117   117   020    -    36
  9 Power_On_Hours          -O--C-   100   100   000    -    166
 10 Spin_Retry_Count        PO--C-   100   100   060    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    14
192 Power-Off_Retract_Count -O--CK   100   100   000    -    28
193 Load_Cycle_Count        -O--C-   100   100   000    -    28
194 Temperature_Celsius     -O----   171   171   000    -    35 (Min/Max 19/59)
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
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
GP    Log at address 0x03 has    1 sectors [Ext. Comprehensive SMART error log]
GP    Log at address 0x04 has    7 sectors [Device Statistics log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    1 sectors [Extended self-test log]
GP    Log at address 0x08 has    2 sectors [Power Conditions log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error log]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP    Log at address 0x20 has    1 sectors [Streaming performance log]
GP    Log at address 0x21 has    1 sectors [Write stream error log]
GP    Log at address 0x22 has    1 sectors [Read stream error log]
GP/S  Log at address 0x80 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x81 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x82 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x83 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x84 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x85 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x86 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x87 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x88 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x89 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x90 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x91 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x92 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x93 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x94 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x95 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x96 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x97 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x98 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x99 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
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
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    36 Celsius
Power Cycle Min/Max Temperature:     26/36 Celsius
Lifetime    Min/Max Temperature:     19/59 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -40/70 Celsius
Temperature History Size (Index):    128 (15)

Index    Estimated Time   Temperature Celsius
  16    2013-09-22 13:32    42  ***********************
  17    2013-09-22 13:33    43  ************************
  18    2013-09-22 13:34    42  ***********************
 ...    ..( 19 skipped).    ..  ***********************
  38    2013-09-22 13:54    42  ***********************
  39    2013-09-22 13:55    43  ************************
  40    2013-09-22 13:56    42  ***********************
 ...    ..(  2 skipped).    ..  ***********************
  43    2013-09-22 13:59    42  ***********************
  44    2013-09-22 14:00    41  **********************
  45    2013-09-22 14:01    42  ***********************
  46    2013-09-22 14:02    41  **********************
 ...    ..( 73 skipped).    ..  **********************
 120    2013-09-22 15:16    41  **********************
 121    2013-09-22 15:17     ?  -
 122    2013-09-22 15:18    26  *******
 123    2013-09-22 15:19    27  ********
 124    2013-09-22 15:20    28  *********
 125    2013-09-22 15:21    29  **********
 126    2013-09-22 15:22    29  **********
 127    2013-09-22 15:23    30  ***********
   0    2013-09-22 15:24    30  ***********
   1    2013-09-22 15:25    31  ************
   2    2013-09-22 15:26    31  ************
   3    2013-09-22 15:27    31  ************
   4    2013-09-22 15:28    32  *************
   5    2013-09-22 15:29    32  *************
   6    2013-09-22 15:30    33  **************
   7    2013-09-22 15:31    33  **************
   8    2013-09-22 15:32    33  **************
   9    2013-09-22 15:33    34  ***************
  10    2013-09-22 15:34    34  ***************
  11    2013-09-22 15:35    34  ***************
  12    2013-09-22 15:36    35  ****************
 ...    ..(  2 skipped).    ..  ****************
  15    2013-09-22 15:39    35  ****************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0009  2            3  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            1  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS


The next post will contain the data from the original 4 drives.

Dave


On 22 September 2013 21:52, Phil Turmel <philip@turmel.org> wrote:
> On 09/22/2013 01:15 PM, Dave Gomboc wrote:
>> Okay,
>>
>> I am nervous about losing 10+ years of personal data.  Your help would
>> be greatly appreciated!
>
> I reviewed this thread and realized you haven't gotten anywhere.
> Unfortunately, reassembly of your array is not likely to be automatic.
> Raid10 in default form cannot tolerate adjacent failures, so the fact
> that you lack indices 1 & 2 suggest your data is lost.
>
> More, very detailed data will be needed.  Please start with the complete
> output of "mdadm -E" for all of the affected partitions, "smartctl -x"
> for all of the drives they're on, and if you have it, a copy of the LVM
> backup file that describes that part of your system.
>
> Phil
