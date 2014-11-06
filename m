From: Vince <stuff@hagenhuegel.de>
Subject: Re: Raid5 drive fail during grow and no backup
Date: Thu, 6 Nov 2014 17:12:37 +0000 (UTC)
Message-ID: <loom.20141106T175806-337@post.gmane.org>
References: <loom.20141031T141939-473@post.gmane.org> <5455A35C.2060000@turmel.org> <loom.20141103T151703-83@post.gmane.org> <5458FC2A.1050308@turmel.org> <loom.20141105T200200-434@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

> This is a problem you haven't solved yet, I think.  The raid array 
> should have fixed this bad sector for you without kicking the drive out. 
> The scenario is common with "green" drives and/or consumer-grade 
> drives in general.

i investigated some time and now i am a bit confused.

All my 5 WD Red drives have ERC enables (7sec)
The kernel timeout is set to 30sec (/sys/block/sdb/device/timeout)
on all devices.

Unfortunately i haven't any backup of the dmesg output, but i can remeber i
got something like:
"failed command: READ FPDMA QUEUED status: { DRDY ERR } error: { UNC }".
This shows up several times until it ends with showing me the sector which
causes the problem.

My raid is still up, but as you mentioned i would like some kind of self
repair if a sector is unreadable instead throwing the disk out of the array.

Here is the samrtctl of one drive that fails.

Do you have any idea if i missing some settings etc?


smartctl -x /dev/sdd
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-4-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red (AF)
Device Model:     WDC WD30EFRX-68AX9N0
Serial Number:    WD-WMC1T2041480
LU WWN Device Id: 5 0014ee 058d836a6
Firmware Version: 80.00A80
User Capacity:    3.000.592.982.016 bytes [3,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   9
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Thu Nov  6 18:10:11 2014 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		(42000) seconds.
Offline data collection
capabilities: 			 (0x7b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
Conveyance self-test routine
recommended polling time: 	 (   5) minutes.
SCT capabilities: 	       (0x70bd)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    1625
  3 Spin_Up_Time            POS--K   176   173   021    -    6175
  4 Start_Stop_Count        -O--CK   099   099   000    -    1290
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   084   084   000    -    11786
 10 Spin_Retry_Count        -O--CK   100   100   000    -    0
 11 Calibration_Retry_Count -O--CK   100   100   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    177
192 Power-Off_Retract_Count -O--CK   200   200   000    -    50
193 Load_Cycle_Count        -O--CK   200   200   000    -    1239
194 Temperature_Celsius     -O---K   121   102   000    -    29
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
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
SMART Log at address 0x02 has    5 sectors [Comprehensive SMART error log]
GP    Log at address 0x03 has    6 sectors [Ext. Comprehensive SMART error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    1 sectors [Extended self-test log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
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
GP/S  Log at address 0xa0 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa1 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa2 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa3 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa4 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa5 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa6 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa7 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa8 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xa9 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xaa has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xab has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xac has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xad has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xae has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xaf has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb0 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb1 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb2 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb3 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb4 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb5 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb6 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb7 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xbd has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xc0 has    1 sectors [Device vendor specific log]
GP    Log at address 0xc1 has   93 sectors [Device vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
Device Error Count: 6807 (device log contains only the most recent 24 errors)
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

Error 6807 [14] occurred at disk power-on lifetime: 11653 hours (485 days +
13 hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  04 -- 61 00 02 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.798  SET FEATURES
[Reserved for Serial ATA]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     16:03:04.798  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     16:03:04.798  SET FEATURES [Set
transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.797  SET FEATURES
[Reserved for Serial ATA]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     16:03:04.797  IDENTIFY DEVICE

Error 6806 [13] occurred at disk power-on lifetime: 11653 hours (485 days +
13 hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  04 -- 61 00 46 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     16:03:04.798  SET FEATURES [Set
transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.797  SET FEATURES
[Reserved for Serial ATA]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     16:03:04.797  IDENTIFY DEVICE
  35 00 00 04 00 00 01 13 7f 4c 00 e0 08     16:03:04.797  WRITE DMA EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.797  SET FEATURES
[Reserved for Serial ATA]

Error 6805 [12] occurred at disk power-on lifetime: 11653 hours (485 days +
13 hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  04 -- 61 00 02 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.797  SET FEATURES
[Reserved for Serial ATA]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     16:03:04.797  IDENTIFY DEVICE
  35 00 00 04 00 00 01 13 7f 4c 00 e0 08     16:03:04.797  WRITE DMA EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.797  SET FEATURES
[Reserved for Serial ATA]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     16:03:04.796  IDENTIFY DEVICE

Error 6804 [11] occurred at disk power-on lifetime: 11653 hours (485 days +
13 hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  04 -- 61 04 00 00 01 13 7f 4c 00 e0 00  Device Fault; Error: ABRT 1024
sectors at LBA = 0x1137f4c00 = 4622076928

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  35 00 00 04 00 00 01 13 7f 4c 00 e0 08     16:03:04.797  WRITE DMA EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.797  SET FEATURES
[Reserved for Serial ATA]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     16:03:04.796  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     16:03:04.796  SET FEATURES [Set
transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.796  SET FEATURES
[Reserved for Serial ATA]

Error 6803 [10] occurred at disk power-on lifetime: 11653 hours (485 days +
13 hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  04 -- 61 00 02 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.797  SET FEATURES
[Reserved for Serial ATA]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     16:03:04.796  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     16:03:04.796  SET FEATURES [Set
transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.796  SET FEATURES
[Reserved for Serial ATA]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     16:03:04.795  IDENTIFY DEVICE

Error 6802 [9] occurred at disk power-on lifetime: 11653 hours (485 days +
13 hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  04 -- 61 00 46 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     16:03:04.796  SET FEATURES [Set
transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.796  SET FEATURES
[Reserved for Serial ATA]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     16:03:04.795  IDENTIFY DEVICE
  35 00 00 04 00 00 01 13 7f 4c 00 e0 08     16:03:04.795  WRITE DMA EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.795  SET FEATURES
[Reserved for Serial ATA]

Error 6801 [8] occurred at disk power-on lifetime: 11653 hours (485 days +
13 hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  04 -- 61 00 02 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.796  SET FEATURES
[Reserved for Serial ATA]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     16:03:04.795  IDENTIFY DEVICE
  35 00 00 04 00 00 01 13 7f 4c 00 e0 08     16:03:04.795  WRITE DMA EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.795  SET FEATURES
[Reserved for Serial ATA]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     16:03:04.795  IDENTIFY DEVICE

Error 6800 [7] occurred at disk power-on lifetime: 11653 hours (485 days +
13 hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  04 -- 61 04 00 00 01 13 7f 4c 00 e0 00  Device Fault; Error: ABRT 1024
sectors at LBA = 0x1137f4c00 = 4622076928

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  35 00 00 04 00 00 01 13 7f 4c 00 e0 08     16:03:04.795  WRITE DMA EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.795  SET FEATURES
[Reserved for Serial ATA]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     16:03:04.795  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     16:03:04.794  SET FEATURES [Set
transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     16:03:04.794  SET FEATURES
[Reserved for Serial ATA]

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(hours)
 LBA_of_first_error
# 1  Short offline       Completed without error       00%     11770         -
# 2  Short offline       Completed without error       00%     11757         -
# 3  Short offline       Completed without error       00%     11746         -
# 4  Extended offline    Completed without error       00%     11729         -
# 5  Extended offline    Completed without error       00%     11698         -
# 6  Extended offline    Aborted by host               90%     11677         -
# 7  Short offline       Completed without error       00%     11654         -
# 8  Short offline       Completed without error       00%     11565         -
# 9  Short offline       Completed: read failure       70%     11557         9
#10  Short offline       Completed: read failure       70%     11557         9
#11  Extended offline    Completed: read failure       90%     11556         9
#12  Short offline       Completed without error       00%      1367         -
#13  Short offline       Completed without error       00%      1346         -
#14  Extended offline    Completed without error       00%      1327         -
#15  Short offline       Completed without error       00%      1295         -
#16  Short offline       Completed without error       00%      1271         -
#17  Short offline       Completed without error       00%      1247         -
#18  Short offline       Completed without error       00%      1223         -
3 of 3 failed self-tests are outdated by newer successful extended offline
self-test # 4

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
Power Cycle Min/Max Temperature:     22/35 Celsius
Lifetime    Min/Max Temperature:     15/49 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (158)

Index    Estimated Time   Temperature Celsius
 159    2014-11-06 10:13    29  **********
 ...    ..( 20 skipped).    ..  **********
 180    2014-11-06 10:34    29  **********
 181    2014-11-06 10:35    31  ************
 ...    ..(128 skipped).    ..  ************
 310    2014-11-06 12:44    31  ************
 311    2014-11-06 12:45    30  ***********
 ...    ..( 70 skipped).    ..  ***********
 382    2014-11-06 13:56    30  ***********
 383    2014-11-06 13:57    31  ************
 ...    ..( 82 skipped).    ..  ************
 466    2014-11-06 15:20    31  ************
 467    2014-11-06 15:21    30  ***********
 ...    ..( 32 skipped).    ..  ***********
  22    2014-11-06 15:54    30  ***********
  23    2014-11-06 15:55    29  **********
 ...    ..( 49 skipped).    ..  **********
  73    2014-11-06 16:45    29  **********
  74    2014-11-06 16:46    30  ***********
 ...    ..(  2 skipped).    ..  ***********
  77    2014-11-06 16:49    30  ***********
  78    2014-11-06 16:50    29  **********
 ...    ..( 23 skipped).    ..  **********
 102    2014-11-06 17:14    29  **********
 103    2014-11-06 17:15    30  ***********
 ...    ..(  9 skipped).    ..  ***********
 113    2014-11-06 17:25    30  ***********
 114    2014-11-06 17:26    29  **********
 ...    ..( 43 skipped).    ..  **********
 158    2014-11-06 18:10    29  **********

SCT Error Recovery Control:
           Read:     70 (7,0 seconds)
          Write:     70 (7,0 seconds)

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
0x0009  2           15  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           15  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4       363301  Vendor specific








