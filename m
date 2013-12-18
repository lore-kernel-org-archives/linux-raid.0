From: Julie Ashworth <ashworth@berkeley.edu>
Subject: Re: request help with RAID1 array that endlessly attempts to sync
Date: Tue, 17 Dec 2013 19:45:56 -0800
Message-ID: <20131218034556.GA9457@localhost.localdomain>
References: <20131217065028.GC20941@nx5.priv>
 <20131217165348.GA5070@localhost.localdomain>
 <52B09027.5090605@turmel.org>
 <20131217192637.GB5070@localhost.localdomain>
 <52B0A956.7030501@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52B0A956.7030501@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hi Phil,
thanks again for your help. It was surprisingly easy to install the latest smarmontools.

On 17-12-2013 14.43 -0500, Phil Turmel wrote:
> I was interested in the reallocation counts, the current pending
> sectors, and the scterc timeouts.  The latter were not present, and are
> important.

ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    3
197 Current_Pending_Sector  -O--C-   100   100   000    -    1
SCT Error Recovery Control:
           Read:    100 (10.0 seconds)
          Write:    100 (10.0 seconds)

(I also attached the full output)

I verified that a weekly scrub is performed via cron (default with Centos5), and there were no errors detected prior to the sync. The output is included in syslog reports. 

> But /dev/sdb has three relocations and only one pending error.  That's
> an old drive, but not sick.  I'd be concerned that there're other
> hardware issues in your system if the timeout issue is not part of the
> problem.

Should I run the sync (mdadm -a) in verbose mode? If so, what is the best way to terminate the current sync? By failing/removing /dev/sda?

Thanks in advance!
best,
Julie
----


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="smartctl-6.2-sdb.out"

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
Local Time is:    Tue Dec 17 19:41:28 2013 PST
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
  1 Raw_Read_Error_Rate     POSR--   083   062   044    -    208852444
  3 Spin_Up_Time            PO----   099   099   000    -    0
  4 Start_Stop_Count        -O--CK   100   100   020    -    30
  5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    3
  7 Seek_Error_Rate         POSR--   081   060   030    -    131804707
  9 Power_On_Hours          -O--CK   067   067   000    -    29583
 10 Spin_Retry_Count        PO--C-   100   100   097    -    0
 12 Power_Cycle_Count       -O--CK   100   037   020    -    30
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   098   098   000    -    2
188 Command_Timeout         -O--CK   100   096   000    -    42950328381
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   079   060   045    -    21 (Min/Max 21/22)
194 Temperature_Celsius     -O---K   021   040   000    -    21 (0 15 0 0 0)
195 Hardware_ECC_Recovered  -O-RC-   057   048   000    -    208852444
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
Device Error Count: 60 (device log contains only the most recent 20 errors)
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

Error 60 [19] occurred at disk power-on lifetime: 29572 hours (1232 days + 4 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 74 5c d2 99 40 00 24d+00:14:08.396  READ FPDMA QUEUED
  27 00 00 00 00 00 00 00 00 00 00 e0 00 24d+00:14:08.368  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 00 24d+00:14:08.367  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 00 24d+00:14:08.353  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00 24d+00:14:08.326  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]

Error 59 [18] occurred at disk power-on lifetime: 29572 hours (1232 days + 4 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 74 5c d2 99 40 00 24d+00:14:05.247  READ FPDMA QUEUED
  27 00 00 00 00 00 00 00 00 00 00 e0 00 24d+00:14:05.220  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 00 24d+00:14:05.218  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 00 24d+00:14:05.205  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00 24d+00:14:05.177  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]

Error 58 [17] occurred at disk power-on lifetime: 29572 hours (1232 days + 4 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 74 5c d2 99 40 00 24d+00:14:02.124  READ FPDMA QUEUED
  27 00 00 00 00 00 00 00 00 00 00 e0 00 24d+00:14:02.096  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 00 24d+00:14:02.095  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 00 24d+00:14:02.081  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00 24d+00:14:02.054  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]

Error 57 [16] occurred at disk power-on lifetime: 29572 hours (1232 days + 4 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 74 5c d2 99 40 00 24d+00:13:58.992  READ FPDMA QUEUED
  27 00 00 00 00 00 00 00 00 00 00 e0 00 24d+00:13:58.964  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 00 24d+00:13:58.963  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 00 24d+00:13:58.950  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00 24d+00:13:58.922  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]

Error 56 [15] occurred at disk power-on lifetime: 29572 hours (1232 days + 4 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 74 5c d2 99 40 00 24d+00:13:55.835  READ FPDMA QUEUED
  27 00 00 00 00 00 00 00 00 00 00 e0 00 24d+00:13:55.808  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 00 24d+00:13:55.806  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 00 24d+00:13:55.793  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00 24d+00:13:55.765  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]

Error 55 [14] occurred at disk power-on lifetime: 29572 hours (1232 days + 4 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 08 00 00 74 5c d2 99 40 00 24d+00:13:52.680  READ FPDMA QUEUED
  60 00 00 00 08 00 00 74 5c d2 89 40 00 24d+00:13:52.671  READ FPDMA QUEUED
  60 00 00 00 08 00 00 74 5c d2 81 40 00 24d+00:13:52.664  READ FPDMA QUEUED
  ea 00 00 00 00 00 00 00 00 00 00 a0 00 24d+00:13:52.657  FLUSH CACHE EXT
  61 00 00 00 08 00 00 74 70 59 01 40 00 24d+00:13:52.657  WRITE FPDMA QUEUED

Error 54 [13] occurred at disk power-on lifetime: 29572 hours (1232 days + 4 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 80 00 00 74 5c d2 81 40 00 24d+00:13:49.491  READ FPDMA QUEUED
  60 00 00 00 80 00 00 74 5c d3 01 40 00 24d+00:13:49.490  READ FPDMA QUEUED
  60 00 00 00 80 00 00 74 5c d3 81 40 00 24d+00:13:49.488  READ FPDMA QUEUED
  27 00 00 00 00 00 00 00 00 00 00 e0 00 24d+00:13:49.461  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 00 24d+00:13:49.459  IDENTIFY DEVICE

Error 53 [12] occurred at disk power-on lifetime: 29572 hours (1232 days + 4 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 74 5c d2 9b 00 00  Error: UNC at LBA = 0x745cd29b = 1952240283

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  60 00 00 00 80 00 00 74 5c d3 81 40 00 24d+00:13:46.341  READ FPDMA QUEUED
  60 00 00 00 80 00 00 74 5c d3 01 40 00 24d+00:13:46.341  READ FPDMA QUEUED
  60 00 00 00 80 00 00 74 5c d2 81 40 00 24d+00:13:46.340  READ FPDMA QUEUED
  27 00 00 00 00 00 00 00 00 00 00 e0 00 24d+00:13:46.312  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
  ec 00 00 00 00 00 00 00 00 00 00 a0 00 24d+00:13:46.311  IDENTIFY DEVICE

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
Power Cycle Min/Max Temperature:     21/22 Celsius
Lifetime    Min/Max Temperature:     15/40 Celsius
Under/Over Temperature Limit Count:   0/66
SCT Temperature History Version:     2
Temperature Sampling Period:         10 minutes
Temperature Logging Interval:        10 minutes
Min/Max recommended Temperature:      0/ 0 Celsius
Min/Max Temperature Limit:            0/ 0 Celsius
Temperature History Size (Index):    128 (71)

Index    Estimated Time   Temperature Celsius
  72    2013-12-16 22:30    22  ***
 ...    ..(  7 skipped).    ..  ***
  80    2013-12-16 23:50    22  ***
  81    2013-12-17 00:00    21  **
  82    2013-12-17 00:10    22  ***
  83    2013-12-17 00:20    21  **
  84    2013-12-17 00:30    22  ***
  85    2013-12-17 00:40    21  **
 ...    ..(  3 skipped).    ..  **
  89    2013-12-17 01:20    21  **
  90    2013-12-17 01:30    22  ***
 ...    ..(  7 skipped).    ..  ***
  98    2013-12-17 02:50    22  ***
  99    2013-12-17 03:00    21  **
 ...    ..(  9 skipped).    ..  **
 109    2013-12-17 04:40    21  **
 110    2013-12-17 04:50    22  ***
 ...    ..(  7 skipped).    ..  ***
 118    2013-12-17 06:10    22  ***
 119    2013-12-17 06:20    21  **
 ...    ..( 10 skipped).    ..  **
   2    2013-12-17 08:10    21  **
   3    2013-12-17 08:20    22  ***
   4    2013-12-17 08:30    22  ***
   5    2013-12-17 08:40     ?  -
   6    2013-12-17 08:50    22  ***
   7    2013-12-17 09:00    22  ***
   8    2013-12-17 09:10    22  ***
   9    2013-12-17 09:20    21  **
  10    2013-12-17 09:30    22  ***
  11    2013-12-17 09:40    22  ***
  12    2013-12-17 09:50    21  **
 ...    ..( 42 skipped).    ..  **
  55    2013-12-17 17:00    21  **
  56    2013-12-17 17:10    22  ***
  57    2013-12-17 17:20    21  **
 ...    ..( 13 skipped).    ..  **
  71    2013-12-17 19:40    21  **

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


--7JfCtLOvnd9MIVvH--
