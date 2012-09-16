From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
Subject: Re: raid1 issue after disk failure: both disks of the array are still
 active
Date: Sun, 16 Sep 2012 17:31:27 +0200
Message-ID: <5055F0CF.6000908@linuxsystems.it>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com> <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se> <5052E096.5040509@linuxsystems.it> <45F26B36-1890-4F8E-BDF9-0DB49FDEE922@colorremedies.com> <20120914182755.GA2534@cthulhu.home.robinhill.me.uk> <7664099D-4C11-4254-B970-2DCAD5F86A46@colorremedies.com> <5054D175.5070303@linuxsystems.it> <20120915194102.GA10403@cthulhu.home.robinhill.me.uk> <5055AD0A.60704@linuxsystems.it> <44576376-12B0-4A78-B5CF-C759ED2EBA9A@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44576376-12B0-4A78-B5CF-C759ED2EBA9A@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Il 16/09/2012 17:26, Chris Murphy ha scritto:
> Something isn't right. How did you write zeros?

dd if=/dev/zero of=/dev/sda


> I went through the archives and wasn't able to find the full smartctl -x results for this drive, can you post them?

root@asterisk:~# smartctl -x /dev/sda
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-2-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint F1 DT
Device Model:     SAMSUNG HD322HJ
Serial Number:    S17AJDWQ402689
LU WWN Device Id: 5 0000f0 003046298
Firmware Version: 1AC01110
User Capacity:    320,072,933,376 bytes [320 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 3b
Local Time is:    Sun Sep 16 17:29:50 2012 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x06) Offline data collection activity
                                         was aborted by the device with 
a fatal error.
                                         Auto Offline Data Collection: 
Disabled.
Self-test execution status:      ( 114) The previous self-test completed 
having
                                         the read element of the test 
failed.
Total time to complete Offline
data collection:                ( 3888) seconds.
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
recommended polling time:        (  66) minutes.
Conveyance self-test routine
recommended polling time:        (   8) minutes.
SCT capabilities:              (0x003f) SCT Status supported.
                                         SCT Error Recovery Control 
supported.
                                         SCT Feature Control supported.
                                         SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR--   099   099   051    -    712
   3 Spin_Up_Time            POS---   094   094   011    -    2810
   4 Start_Stop_Count        -O--CK   099   099   000    -    1077
   5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
   7 Seek_Error_Rate         POSR--   253   253   051    -    0
   8 Seek_Time_Performance   P-S--K   100   100   015    -    9508
   9 Power_On_Hours          -O--CK   098   098   000    -    9006
  10 Spin_Retry_Count        PO--CK   100   100   051    -    0
  11 Calibration_Retry_Count -O--C-   100   100   000    -    0
  12 Power_Cycle_Count       -O--CK   099   099   000    -    1077
  13 Read_Soft_Error_Rate    -OSR--   099   099   000    -    654
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        PO--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    908
188 Command_Timeout         -O--CK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   063   055   000    -    37 (Min/Max 
28/45)
194 Temperature_Celsius     -O---K   063   054   000    -    37 (Min/Max 
28/46)
195 Hardware_ECC_Recovered  -O-RC-   100   100   000    -    988053162
196 Reallocated_Event_Count -O--CK   100   100   000    -    0
197 Current_Pending_Sector  -O--C-   100   100   000    -    3
198 Offline_Uncorrectable   ----CK   100   100   000    -    1
199 UDMA_CRC_Error_Count    -OSRCK   100   100   000    -    0
200 Multi_Zone_Error_Rate   -O-R--   100   100   000    -    0
201 Soft_Read_Error_Rate    -O-R--   095   095   000    -    440
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
SMART Log at address 0x02 has    2 sectors [Comprehensive SMART error log]
GP    Log at address 0x03 has    2 sectors [Ext. Comprehensive SMART 
error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    2 sectors [Extended self-test log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
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

SMART Extended Comprehensive Error Log Version: 1 (2 sectors)
Device Error Count: 450 (device log contains only the most recent 8 errors)
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

Error 450 [1] occurred at disk power-on lifetime: 9001 hours (375 days + 
1 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 00 00 00 00 00 00 0f 48 e0 00  Error: UNC at LBA = 
0x00000f48 = 3912

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   c8 00 00 00 08 00 00 00 00 0f 48 e0 08 21d+23:03:29.664  READ DMA
   27 00 00 00 00 00 00 00 00 00 00 e0 08 21d+23:03:29.664  READ NATIVE 
MAX ADDRESS EXT
   ec 00 00 00 00 00 00 00 00 00 00 a0 08 21d+23:03:29.654  IDENTIFY DEVICE
   ef 00 03 00 46 00 00 00 00 00 00 a0 08 21d+23:03:29.654  SET FEATURES 
[Set transfer mode]
   27 00 00 00 00 00 00 00 00 00 00 e0 08 21d+23:03:29.654  READ NATIVE 
MAX ADDRESS EXT

Error 449 [0] occurred at disk power-on lifetime: 9001 hours (375 days + 
1 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 00 00 00 00 00 00 0f 48 e0 00  Error: UNC at LBA = 
0x00000f48 = 3912

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   c8 00 00 00 08 00 00 00 00 0f 48 e0 08 21d+23:03:27.714  READ DMA
   27 00 00 00 00 00 00 00 00 00 00 e0 08 21d+23:03:27.714  READ NATIVE 
MAX ADDRESS EXT
   ec 00 00 00 00 00 00 00 00 00 00 a0 08 21d+23:03:27.714  IDENTIFY DEVICE
   ef 00 03 00 46 00 00 00 00 00 00 a0 08 21d+23:03:27.714  SET FEATURES 
[Set transfer mode]
   27 00 00 00 00 00 00 00 00 00 00 e0 08 21d+23:03:27.714  READ NATIVE 
MAX ADDRESS EXT

Error 448 [7] occurred at disk power-on lifetime: 9001 hours (375 days + 
1 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 00 00 00 00 00 00 0f 48 e0 00  Error: UNC at LBA = 
0x00000f48 = 3912

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   c8 00 00 00 08 00 00 00 00 0f 48 e0 08 21d+23:03:25.774  READ DMA
   27 00 00 00 00 00 00 00 00 00 00 e0 08 21d+23:03:25.774  READ NATIVE 
MAX ADDRESS EXT
   ec 00 00 00 00 00 00 00 00 00 00 a0 08 21d+23:03:25.774  IDENTIFY DEVICE
   ef 00 03 00 46 00 00 00 00 00 00 a0 08 21d+23:03:25.774  SET FEATURES 
[Set transfer mode]
   27 00 00 00 00 00 00 00 00 00 00 e0 08 21d+23:03:25.764  READ NATIVE 
MAX ADDRESS EXT

Error 447 [6] occurred at disk power-on lifetime: 9001 hours (375 days + 
1 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 00 00 00 00 00 00 0f 48 e0 00  Error: UNC at LBA = 
0x00000f48 = 3912

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   c8 00 00 00 08 00 00 00 00 0f 48 e0 08 21d+23:03:23.804  READ DMA
   27 00 00 00 00 00 00 00 00 00 00 e0 08 21d+23:03:23.804  READ NATIVE 
MAX ADDRESS EXT
   ec 00 00 00 00 00 00 00 00 00 00 a0 08 21d+23:03:23.794  IDENTIFY DEVICE
   ef 00 03 00 46 00 00 00 00 00 00 a0 08 21d+23:03:23.794  SET FEATURES 
[Set transfer mode]
   27 00 00 00 00 00 00 00 00 00 00 e0 08 21d+23:03:23.794  READ NATIVE 
MAX ADDRESS EXT

Error 446 [5] occurred at disk power-on lifetime: 9001 hours (375 days + 
1 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 00 00 00 00 00 00 0f 48 e0 00  Error: UNC at LBA = 
0x00000f48 = 3912

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   c8 00 00 00 08 00 00 00 00 0f 48 e0 08 21d+23:03:21.824  READ DMA
   27 00 00 00 00 00 00 00 00 00 00 e0 08 21d+23:03:21.824  READ NATIVE 
MAX ADDRESS EXT
   ec 00 00 00 00 00 00 00 00 00 00 a0 08 21d+23:03:21.814  IDENTIFY DEVICE
   ef 00 03 00 46 00 00 00 00 00 00 a0 08 21d+23:03:21.814  SET FEATURES 
[Set transfer mode]
   27 00 00 00 00 00 00 00 00 00 00 e0 08 21d+23:03:21.814  READ NATIVE 
MAX ADDRESS EXT

Error 445 [4] occurred at disk power-on lifetime: 9001 hours (375 days + 
1 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 00 00 00 00 00 00 0f 48 e0 00  Error: UNC at LBA = 
0x00000f48 = 3912

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   c8 00 00 00 08 00 00 00 00 0f 48 e0 08 21d+23:03:20.254  READ DMA
   c8 00 00 00 08 00 00 00 00 0f 40 e0 08 21d+23:03:20.254  READ DMA
   c8 00 00 00 08 00 00 00 00 0f 38 e0 08 21d+23:03:20.254  READ DMA
   c8 00 00 00 08 00 00 00 00 0f 30 e0 08 21d+23:03:20.254  READ DMA
   c8 00 00 00 08 00 00 00 00 0f 28 e0 08 21d+23:03:20.254  READ DMA

Error 444 [3] occurred at disk power-on lifetime: 9001 hours (375 days + 
1 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 00 00 00 00 00 00 0f 48 e0 00  Error: UNC at LBA = 
0x00000f48 = 3912

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   c8 00 00 00 08 00 00 00 00 0f 48 e0 08 21d+23:02:10.594  READ DMA
   27 00 00 00 00 00 00 00 00 00 00 e0 08 21d+23:02:10.594  READ NATIVE 
MAX ADDRESS EXT
   ec 00 00 00 00 00 00 00 00 00 00 a0 08 21d+23:02:10.594  IDENTIFY DEVICE
   ef 00 03 00 46 00 00 00 00 00 00 a0 08 21d+23:02:10.594  SET FEATURES 
[Set transfer mode]
   27 00 00 00 00 00 00 00 00 00 00 e0 08 21d+23:02:10.594  READ NATIVE 
MAX ADDRESS EXT

Error 443 [2] occurred at disk power-on lifetime: 9001 hours (375 days + 
1 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 00 00 00 00 00 00 0f 48 e0 00  Error: UNC at LBA = 
0x00000f48 = 3912

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   c8 00 00 00 08 00 00 00 00 0f 48 e0 08 21d+23:02:08.654  READ DMA
   27 00 00 00 00 00 00 00 00 00 00 e0 08 21d+23:02:08.654  READ NATIVE 
MAX ADDRESS EXT
   ec 00 00 00 00 00 00 00 00 00 00 a0 08 21d+23:02:08.654  IDENTIFY DEVICE
   ef 00 03 00 46 00 00 00 00 00 00 a0 08 21d+23:02:08.654  SET FEATURES 
[Set transfer mode]
   27 00 00 00 00 00 00 00 00 00 00 e0 08 21d+23:02:08.654  READ NATIVE 
MAX ADDRESS EXT

SMART Extended Self-test Log Version: 0 (2 sectors)
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed: read failure       20%      8991 
      3912
# 2  Offline             Aborted by host               90%      8985 
      -
# 3  Offline             Aborted by host               90%      8981 
      -
# 4  Offline             Aborted by host               90%      8981 
      -
# 5  Extended offline    Aborted by host               90%      8980 
      -
# 6  Extended offline    Aborted by host               90%      8980 
      -
# 7  Short offline       Aborted by host               20%      8980 
      -
# 8  Short offline       Aborted by host               20%      8980 
      -
# 9  Extended offline    Aborted by host               90%      8968 
      -
#10  Short offline       Aborted by host               20%      8967 
      -
#11  Short offline       Aborted by host               20%      8943 
      -
#12  Short offline       Aborted by host               20%      8919 
      -
#13  Short offline       Aborted by host               20%      8895 
      -
#14  Short offline       Aborted by host               20%      8871 
      -
#15  Short offline       Aborted by host               20%      8847 
      -
#16  Short offline       Aborted by host               20%      8823 
      -
#17  Extended offline    Aborted by host               90%      8800 
      -
#18  Short offline       Aborted by host               20%      8799 
      -
#19  Short offline       Aborted by host               20%      8775 
      -
#20  Short offline       Aborted by host               20%      8751 
      -
#21  Short offline       Aborted by host               20%      8727 
      -

Note: selective self-test log revision number (0) not 1 implies that no 
selective self-test has ever been run
SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has ever 
been run
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  2
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                 37 Celsius
Power Cycle Max Temperature:         46 Celsius
Lifetime    Max Temperature:         46 Celsius
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:     -4/72 Celsius
Min/Max Temperature Limit:           -9/77 Celsius
Temperature History Size (Index):    128 (36)

Index    Estimated Time   Temperature Celsius
   37    2012-09-16 15:22    37  ******************
  ...    ..(126 skipped).    ..  ******************
   36    2012-09-16 17:29    37  ******************

SCT Error Recovery Control:
            Read: Disabled
           Write: Disabled

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2           24  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2           32  Transition from drive PhyRdy to drive PhyNRdy
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0010  2            0  R_ERR response for host-to-device data FIS, non-CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x0013  2            0  R_ERR response for host-to-device non-data FIS, 
non-CRC

-- 
http://www.linuxsystems.it
