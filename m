From: Julie Ashworth <ashworth@berkeley.edu>
Subject: Re: request help with RAID1 array that endlessly attempts to sync
Date: Mon, 20 Jan 2014 22:38:08 -0800
Message-ID: <20140121063808.GA27520@ssh2.neuro.berkeley.edu>
References: <20131217065028.GC20941@nx5.priv>
 <20131217165348.GA5070@localhost.localdomain>
 <52B09027.5090605@turmel.org>
 <20131217192637.GB5070@localhost.localdomain>
 <52B0A956.7030501@turmel.org>
 <20131218034556.GA9457@localhost.localdomain>
 <52B19045.5010102@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52B19045.5010102@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 18-12-2013 07.08 -0500, Phil Turmel wrote:
> I'd let the sync continue until it fails or completes.  And if it
> completes, exercise the array to see if it stays flaky.  If it does not
> complete, start swapping parts in the system.
---end quoted text---

I'm responding to an old thread, but current problem. I started a RAID1 rebuild in mid-December, and it's still running - now with 2712 read errors - and counting. (I enclosed smartctl output).

# cat /proc/mdstat
Personalities : [raid1] 
md0 : active raid1 sda1[0] sdb1[1]
      521984 blocks [2/2] [UU]
      
md1 : active raid1 sda2[2] sdb2[1]
      976237824 blocks [2/1] [_U]
      [==============>......]  recovery = 70.9% (692700480/976237824) finish=68.5min speed=68956K/sec


md0 is a boot partition, and md1 is the operating system. 
I configured LVM on md1, and allocated 68GB (of 1TB): 

# vgdisplay /dev/VolGroup00
  VG Name               VolGroup00
  VG Size               931.00 GB
  Alloc PE / Size       2176 / 68.00 GB
  Free  PE / Size       27616 / 863.00 GB
 
Currently, only ~5GB of the 1TB disk is used.

At this point, what is my best option for limiting downtime of the server (i.e. avoiding a rebuild)? 
I added a drive (/dev/sdc) with identical geometry, and consider using dd, i.e.

# dd if=/dev/sdb of=/dev/sdc bs=4096 conv=sync,noerror

This may not be the most efficient method of transferring data, since .5% of the disk is used. But obviously, I'm not in a hurry.

Please excuse my ignorance, but after it's cloned, is it possible to add /dev/sdc2 to md1 while it's syncing (to /dev/sda2)? Or do I need to wait until /dev/sdb fails to replace it with /dev/sdc? 

Thanks!
Julie


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="smartctl.20130120"

smartctl 6.2 2013-07-26 r3841 [x86_64-linux-2.6.18-238.12.1.el5] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda ES.2
Device Model:     ST31000340NS
Serial Number:    9QJ6Y79S
LU WWN Device Id: 5 000c50 01a89c17b
Firmware Version: SN06
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Mon Jan 20 20:33:09 2014 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Unknown

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
data collection: 		(  625) seconds.
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
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 ( 220) minutes.
Conveyance self-test routine
recommended polling time: 	 (   2) minutes.
SCT capabilities: 	       (0x103d)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   075   058   044    -    33516445
  3 Spin_Up_Time            PO----   099   099   000    -    0
  4 Start_Stop_Count        -O--CK   100   100   020    -    36
  5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    3
  7 Seek_Error_Rate         POSR--   081   060   030    -    138049328
  9 Power_On_Hours          -O--CK   066   066   000    -    30400
 10 Spin_Retry_Count        PO--C-   100   100   097    -    0
 12 Power_Cycle_Count       -O--CK   100   037   020    -    36
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   092   092   000    -    8
188 Command_Timeout         -O--CK   100   096   000    -    42950328381
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   079   060   045    -    21 (Min/Max 21/21)
194 Temperature_Celsius     -O---K   021   040   000    -    21 (0 15 0 0 0)
195 Hardware_ECC_Recovered  -O-RC-   064   048   000    -    33516445
197 Current_Pending_Sector  -O--C-   100   100   000    -    1
198 Offline_Uncorrectable   ----C-   100   100   000    -    1
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
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
0x01       GPL,SL  R/O      1  Summary SMART error log
0x02       GPL,SL  R/O      5  Comprehensive SMART error log
0x03       GPL,SL  R/O      5  Ext. Comprehensive SMART error log
0x06       GPL,SL  R/O      1  SMART self-test log
0x07       GPL,SL  R/O      1  Extended self-test log
0x09       GPL,SL  R/W      1  Selective self-test log
0x10       GPL,SL  R/O      1  NCQ Command Error log
0x11       GPL,SL  R/O      1  SATA Phy Event Counters
0x21       GPL,SL  R/O      1  Write stream error log
0x22       GPL,SL  R/O      1  Read stream error log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa1       GPL,SL  VS      20  Device vendor specific log
0xa2       GPL     VS    2248  Device vendor specific log
0xa8       GPL,SL  VS      65  Device vendor specific log
0xa9       GPL,SL  VS       1  Device vendor specific log
0xb0       GPL     VS    2864  Device vendor specific log
0xb6       GPL     VS    1918  Device vendor specific log
0xbe-0xbf  GPL     VS   65535  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
Device Error Count: 2712 (device log contains only the most recent 20 errors)
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

Error 2712 [11] occurred at disk power-on lifetime: 30399 hours (1266 days + 15 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 74 5c d2 99 40 00 12d+15:29:19.453  READ FPDMA QUEUED
  27 00 00 00 00 00 00 00 00 00 00 e0 00 12d+15:29:19.425  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 00 12d+15:29:19.424  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 00 12d+15:29:19.411  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00 12d+15:29:19.383  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]

Error 2711 [10] occurred at disk power-on lifetime: 30399 hours (1266 days + 15 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 74 5c d2 99 40 00 12d+15:29:16.279  READ FPDMA QUEUED
  27 00 00 00 00 00 00 00 00 00 00 e0 00 12d+15:29:16.252  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 00 12d+15:29:16.250  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 00 12d+15:29:16.237  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00 12d+15:29:16.210  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]

Error 2710 [9] occurred at disk power-on lifetime: 30399 hours (1266 days + 15 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 74 5c d2 99 40 00 12d+15:29:13.115  READ FPDMA QUEUED
  60 00 00 00 80 00 00 74 5c e2 01 40 00 12d+15:29:13.114  READ FPDMA QUEUED
  27 00 00 00 00 00 00 00 00 00 00 e0 00 12d+15:29:13.087  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 00 12d+15:29:13.085  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 00 12d+15:29:13.072  SET FEATURES [Set transfer mode]

Error 2709 [8] occurred at disk power-on lifetime: 30399 hours (1266 days + 15 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 74 5c d2 99 40 00 12d+15:29:09.933  READ FPDMA QUEUED
  27 00 00 00 00 00 00 00 00 00 00 e0 00 12d+15:29:09.905  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 00 12d+15:29:09.904  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 00 12d+15:29:09.890  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00 12d+15:29:09.863  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]

Error 2708 [7] occurred at disk power-on lifetime: 30399 hours (1266 days + 15 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 74 5c d2 99 40 00 12d+15:29:06.793  READ FPDMA QUEUED
  27 00 00 00 00 00 00 00 00 00 00 e0 00 12d+15:29:06.765  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 00 12d+15:29:06.763  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 00 12d+15:29:06.750  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00 12d+15:29:06.723  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]

Error 2707 [6] occurred at disk power-on lifetime: 30399 hours (1266 days + 15 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 74 5c d2 99 40 00 12d+15:29:03.653  READ FPDMA QUEUED
  60 00 00 00 08 00 00 74 5c d2 89 40 00 12d+15:29:03.645  READ FPDMA QUEUED
  60 00 00 00 08 00 00 74 5c d2 81 40 00 12d+15:29:03.638  READ FPDMA QUEUED
  ea 00 00 00 00 00 00 00 00 00 00 a0 00 12d+15:29:03.629  FLUSH CACHE EXT
  61 00 00 00 08 00 00 74 70 59 01 40 00 12d+15:29:03.628  WRITE FPDMA QUEUED

Error 2706 [5] occurred at disk power-on lifetime: 30399 hours (1266 days + 15 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 80 00 00 74 5c d2 81 40 00 12d+15:29:00.466  READ FPDMA QUEUED
  60 00 00 00 80 00 00 74 5c d3 81 40 00 12d+15:29:00.465  READ FPDMA QUEUED
  60 00 00 00 80 00 00 74 5c d4 01 40 00 12d+15:29:00.465  READ FPDMA QUEUED
  60 00 00 00 80 00 00 74 5c d4 81 40 00 12d+15:29:00.464  READ FPDMA QUEUED
  60 00 00 00 80 00 00 74 5c d5 01 40 00 12d+15:29:00.464  READ FPDMA QUEUED

Error 2705 [4] occurred at disk power-on lifetime: 30399 hours (1266 days + 15 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 80 00 00 74 5c d3 01 40 00 12d+15:28:57.308  READ FPDMA QUEUED
  60 00 00 00 80 00 00 74 5c d5 01 40 00 12d+15:28:57.307  READ FPDMA QUEUED
  60 00 00 00 80 00 00 74 5c d4 81 40 00 12d+15:28:57.307  READ FPDMA QUEUED
  60 00 00 00 80 00 00 74 5c d4 01 40 00 12d+15:28:57.307  READ FPDMA QUEUED
  60 00 00 00 80 00 00 74 5c d3 81 40 00 12d+15:28:57.307  READ FPDMA QUEUED

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Aborted by host               60%     29560         -

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
SCT Version (vendor specific):       522 (0x020a)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    21 Celsius
Power Cycle Min/Max Temperature:     21/21 Celsius
Lifetime    Min/Max Temperature:     15/40 Celsius
Under/Over Temperature Limit Count:   0/1
SCT Temperature History Version:     2
Temperature Sampling Period:         10 minutes
Temperature Logging Interval:        10 minutes
Min/Max recommended Temperature:      0/ 0 Celsius
Min/Max Temperature Limit:            0/ 0 Celsius
Temperature History Size (Index):    128 (114)

Index    Estimated Time   Temperature Celsius
 115    2014-01-19 23:20    21  **
 ...    ..( 96 skipped).    ..  **
  84    2014-01-20 15:30    21  **
  85    2014-01-20 15:40    22  ***
 ...    ..(  5 skipped).    ..  ***
  91    2014-01-20 16:40    22  ***
  92    2014-01-20 16:50    21  **
 ...    ..( 14 skipped).    ..  **
 107    2014-01-20 19:20    21  **
 108    2014-01-20 19:30    22  ***
 109    2014-01-20 19:40    22  ***
 110    2014-01-20 19:50    22  ***
 111    2014-01-20 20:00    21  **
 112    2014-01-20 20:10    22  ***
 113    2014-01-20 20:20     ?  -
 114    2014-01-20 20:30    21  **

SCT Error Recovery Control:
           Read:    100 (10.0 seconds)
          Write:    100 (10.0 seconds)

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            1  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS


--C7zPtVaVf+AK4Oqc--
