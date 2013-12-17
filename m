From: Julie Ashworth <ashworth@berkeley.edu>
Subject: Re: request help with RAID1 array that endlessly attempts to sync
Date: Tue, 17 Dec 2013 11:26:37 -0800
Message-ID: <20131217192637.GB5070@localhost.localdomain>
References: <20131217065028.GC20941@nx5.priv>
 <20131217165348.GA5070@localhost.localdomain>
 <52B09027.5090605@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52B09027.5090605@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Thanks Phil,
I should note that the drives are labelled "enterprise", purchased from a hw RAID vendor (ACNC.com).

On 17-12-2013 12.55 -0500, Phil Turmel wrote:
> Please post the output of "smartctl -x" for both of these drives.

The Centos5 smartctl (from smartmontools rpm) doesn't support the -x option. However, it's apparently equivelent to:
smartctl -H -i -g all -c -A -f brief -l xerror,error -l xselftest,selftest -l selective -l directory -l scttemp -l scterc -l devstat -l sataphy 

Centos5 smartctl supports the following:
 smartctl -H -i -c -A -l error -l selftest -l selective -l directory -l scttemp -l scttempsts -l scttemphist

... and I enclosed the output for sda and sdb.
If you think it would be useful to have the additional options (provided by -x), then let me know, and I'll try to build it.

> timeout mismatches combined with lack of scrubbing.

I've read about mismatches, but not about scrubbing. I'll investigate this.
What program/options do your weekly scrub?
 
> Maybe not.  Please tell us you know all about error recovery timeouts

Instead of stopping the sync, I decided to slow it down:
echo 1001 > /proc/sys/dev/raid/speed_limit_max

> and the timeout mismatch problem commonly encountered with
> consumer-grade hard drives.  Otherwise, you might want search the list
> archives for various combinations of the keywords "scterc", "error
> recovery", "timeout mismatch", "URE", and/or "bit error rate".

I'm not a big fan of Seagate (enterprise or not). The drives I purchased before these (~2008) needed to have firmware updates to prevent bricking. Sigh.

Thanks for your help and search tips.
best,
Julie
----

--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="smartctl.sda.out"

smartctl version 5.38 [x86_64-redhat-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     Hitachi HUA722010CLA330
Serial Number:    JPW9J0N12TGPJV
Firmware Version: JP4OA3EA
User Capacity:    1,000,204,886,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Tue Dec 17 11:14:24 2013 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84)	Offline data collection activity
					was suspended by an interrupting command from host.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 (9337) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 ( 156) minutes.
SCT capabilities: 	       (0x003d)	SCT Status supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   100   100   016    Pre-fail  Always       -       0
  2 Throughput_Performance  0x0005   137   137   054    Pre-fail  Offline      -       90
  3 Spin_Up_Time            0x0007   100   100   024    Pre-fail  Always       -       249
  4 Start_Stop_Count        0x0012   100   100   000    Old_age   Always       -       5
  5 Reallocated_Sector_Ct   0x0033   100   100   005    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000b   100   100   067    Pre-fail  Always       -       0
  8 Seek_Time_Performance   0x0005   142   142   020    Pre-fail  Offline      -       29
  9 Power_On_Hours          0x0012   100   100   000    Old_age   Always       -       46
 10 Spin_Retry_Count        0x0013   100   100   060    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       5
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       6
193 Load_Cycle_Count        0x0012   100   100   000    Old_age   Always       -       6
194 Temperature_Celsius     0x0002   253   253   000    Old_age   Always       -       22 (Lifetime Min/Max 20/37)
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0022   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0008   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x000a   200   200   000    Old_age   Always       -       0

Log Directory Supported
SMART Log Directory Logging Version 1 [multi-sector log support]
Log at address 0x00 has 001 sectors [Log Directory]
Log at address 0x01 has 001 sectors [Summary SMART error log]
Log at address 0x06 has 001 sectors [SMART self-test log]
Log at address 0x09 has 001 sectors [Selective self-test log]
Log at address 0x80 has 016 sectors [Host vendor specific log]
Log at address 0x81 has 016 sectors [Host vendor specific log]
Log at address 0x82 has 016 sectors [Host vendor specific log]
Log at address 0x83 has 016 sectors [Host vendor specific log]
Log at address 0x84 has 016 sectors [Host vendor specific log]
Log at address 0x85 has 016 sectors [Host vendor specific log]
Log at address 0x86 has 016 sectors [Host vendor specific log]
Log at address 0x87 has 016 sectors [Host vendor specific log]
Log at address 0x88 has 016 sectors [Host vendor specific log]
Log at address 0x89 has 016 sectors [Host vendor specific log]
Log at address 0x8a has 016 sectors [Host vendor specific log]
Log at address 0x8b has 016 sectors [Host vendor specific log]
Log at address 0x8c has 016 sectors [Host vendor specific log]
Log at address 0x8d has 016 sectors [Host vendor specific log]
Log at address 0x8e has 016 sectors [Host vendor specific log]
Log at address 0x8f has 016 sectors [Host vendor specific log]
Log at address 0x90 has 016 sectors [Host vendor specific log]
Log at address 0x91 has 016 sectors [Host vendor specific log]
Log at address 0x92 has 016 sectors [Host vendor specific log]
Log at address 0x93 has 016 sectors [Host vendor specific log]
Log at address 0x94 has 016 sectors [Host vendor specific log]
Log at address 0x95 has 016 sectors [Host vendor specific log]
Log at address 0x96 has 016 sectors [Host vendor specific log]
Log at address 0x97 has 016 sectors [Host vendor specific log]
Log at address 0x98 has 016 sectors [Host vendor specific log]
Log at address 0x99 has 016 sectors [Host vendor specific log]
Log at address 0x9a has 016 sectors [Host vendor specific log]
Log at address 0x9b has 016 sectors [Host vendor specific log]
Log at address 0x9c has 016 sectors [Host vendor specific log]
Log at address 0x9d has 016 sectors [Host vendor specific log]
Log at address 0x9e has 016 sectors [Host vendor specific log]
Log at address 0x9f has 016 sectors [Host vendor specific log]
Log at address 0xe0 has 001 sectors [Reserved log]
Log at address 0xe1 has 001 sectors [Reserved log]
SMART Error Log Version: 0
No Errors Logged

SMART Self-test log structure revision number 1
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
Device State:                        SMART Off-line Data Collection executing in background (4)
Current Temperature:                    22 Celsius
Power Cycle Min/Max Temperature:     20/25 Celsius
Lifetime    Min/Max Temperature:     20/37 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -40/70 Celsius
Temperature History Size (Index):    128 (110)

Index    Estimated Time   Temperature Celsius
 111    2013-12-17 09:07    24  *****
 ...    ..( 31 skipped).    ..  *****
  15    2013-12-17 09:39    24  *****
  16    2013-12-17 09:40    23  ****
 ...    ..(  4 skipped).    ..  ****
  21    2013-12-17 09:45    23  ****
  22    2013-12-17 09:46    22  ***
 ...    ..( 87 skipped).    ..  ***
 110    2013-12-17 11:14    22  ***


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="smartctl.sdb.out"

smartctl version 5.38 [x86_64-redhat-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     ST31000340NS
Serial Number:    9QJ6Y79S
Firmware Version: SN06
User Capacity:    1,000,204,886,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Tue Dec 17 11:14:32 2013 PST
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
data collection: 		 ( 625) seconds.
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
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   081   062   044    Pre-fail  Always       -       142396197
  3 Spin_Up_Time            0x0003   099   099   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       30
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       3
  7 Seek_Error_Rate         0x000f   081   060   030    Pre-fail  Always       -       131721923
  9 Power_On_Hours          0x0032   067   067   000    Old_age   Always       -       29575
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   037   020    Old_age   Always       -       30
184 Unknown_Attribute       0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   098   098   000    Old_age   Always       -       2
188 Unknown_Attribute       0x0032   100   096   000    Old_age   Always       -       42950328381
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0022   079   060   045    Old_age   Always       -       21 (Lifetime Min/Max 21/22)
194 Temperature_Celsius     0x0022   021   040   000    Old_age   Always       -       21 (0 15 0 0)
195 Hardware_ECC_Recovered  0x001a   061   048   000    Old_age   Always       -       142396197
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       1
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       1
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0

Log Directory Supported
SMART Log Directory Logging Version 1 [multi-sector log support]
Log at address 0x00 has 001 sectors [Log Directory]
Log at address 0x01 has 001 sectors [Summary SMART error log]
Log at address 0x02 has 005 sectors [Comprehensive SMART error log]
Log at address 0x03 has 005 sectors [Extended Comprehensive SMART error log]
Log at address 0x06 has 001 sectors [SMART self-test log]
Log at address 0x07 has 001 sectors [Extended self-test log]
Log at address 0x09 has 001 sectors [Selective self-test log]
Log at address 0x10 has 001 sectors [Reserved log]
Log at address 0x11 has 001 sectors [Reserved log]
Log at address 0x21 has 001 sectors [Write stream error log]
Log at address 0x22 has 001 sectors [Read stream error log]
Log at address 0x80 has 016 sectors [Host vendor specific log]
Log at address 0x81 has 016 sectors [Host vendor specific log]
Log at address 0x82 has 016 sectors [Host vendor specific log]
Log at address 0x83 has 016 sectors [Host vendor specific log]
Log at address 0x84 has 016 sectors [Host vendor specific log]
Log at address 0x85 has 016 sectors [Host vendor specific log]
Log at address 0x86 has 016 sectors [Host vendor specific log]
Log at address 0x87 has 016 sectors [Host vendor specific log]
Log at address 0x88 has 016 sectors [Host vendor specific log]
Log at address 0x89 has 016 sectors [Host vendor specific log]
Log at address 0x8a has 016 sectors [Host vendor specific log]
Log at address 0x8b has 016 sectors [Host vendor specific log]
Log at address 0x8c has 016 sectors [Host vendor specific log]
Log at address 0x8d has 016 sectors [Host vendor specific log]
Log at address 0x8e has 016 sectors [Host vendor specific log]
Log at address 0x8f has 016 sectors [Host vendor specific log]
Log at address 0x90 has 016 sectors [Host vendor specific log]
Log at address 0x91 has 016 sectors [Host vendor specific log]
Log at address 0x92 has 016 sectors [Host vendor specific log]
Log at address 0x93 has 016 sectors [Host vendor specific log]
Log at address 0x94 has 016 sectors [Host vendor specific log]
Log at address 0x95 has 016 sectors [Host vendor specific log]
Log at address 0x96 has 016 sectors [Host vendor specific log]
Log at address 0x97 has 016 sectors [Host vendor specific log]
Log at address 0x98 has 016 sectors [Host vendor specific log]
Log at address 0x99 has 016 sectors [Host vendor specific log]
Log at address 0x9a has 016 sectors [Host vendor specific log]
Log at address 0x9b has 016 sectors [Host vendor specific log]
Log at address 0x9c has 016 sectors [Host vendor specific log]
Log at address 0x9d has 016 sectors [Host vendor specific log]
Log at address 0x9e has 016 sectors [Host vendor specific log]
Log at address 0x9f has 016 sectors [Host vendor specific log]
Log at address 0xa1 has 020 sectors [Device vendor specific log]
Log at address 0xa8 has 065 sectors [Device vendor specific log]
Log at address 0xa9 has 001 sectors [Device vendor specific log]
Log at address 0xe0 has 001 sectors [Reserved log]
Log at address 0xe1 has 001 sectors [Reserved log]
SMART Error Log Version: 1
ATA Error Count: 60 (device log contains only the most recent five errors)
	CR = Command Register [HEX]
	FR = Features Register [HEX]
	SC = Sector Count Register [HEX]
	SN = Sector Number Register [HEX]
	CL = Cylinder Low Register [HEX]
	CH = Cylinder High Register [HEX]
	DH = Device/Head Register [HEX]
	DC = Device Command Register [HEX]
	ER = Error register [HEX]
	ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 60 occurred at disk power-on lifetime: 29572 hours (1232 days + 4 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  24d+00:14:08.396  READ FPDMA QUEUED
  27 00 00 00 00 00 e0 00  24d+00:14:08.368  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  24d+00:14:08.367  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  24d+00:14:08.353  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  24d+00:14:08.326  READ NATIVE MAX ADDRESS EXT

Error 59 occurred at disk power-on lifetime: 29572 hours (1232 days + 4 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  24d+00:14:05.247  READ FPDMA QUEUED
  27 00 00 00 00 00 e0 00  24d+00:14:05.220  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  24d+00:14:05.218  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  24d+00:14:05.205  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  24d+00:14:05.177  READ NATIVE MAX ADDRESS EXT

Error 58 occurred at disk power-on lifetime: 29572 hours (1232 days + 4 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  24d+00:14:02.124  READ FPDMA QUEUED
  27 00 00 00 00 00 e0 00  24d+00:14:02.096  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  24d+00:14:02.095  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  24d+00:14:02.081  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  24d+00:14:02.054  READ NATIVE MAX ADDRESS EXT

Error 57 occurred at disk power-on lifetime: 29572 hours (1232 days + 4 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  24d+00:13:58.992  READ FPDMA QUEUED
  27 00 00 00 00 00 e0 00  24d+00:13:58.964  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  24d+00:13:58.963  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  24d+00:13:58.950  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  24d+00:13:58.922  READ NATIVE MAX ADDRESS EXT

Error 56 occurred at disk power-on lifetime: 29572 hours (1232 days + 4 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  24d+00:13:55.835  READ FPDMA QUEUED
  27 00 00 00 00 00 e0 00  24d+00:13:55.808  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  24d+00:13:55.806  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  24d+00:13:55.793  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  24d+00:13:55.765  READ NATIVE MAX ADDRESS EXT

SMART Self-test log structure revision number 1
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
Under/Over Temperature Limit Count:   0/15
SCT Temperature History Version:     2
Temperature Sampling Period:         10 minutes
Temperature Logging Interval:        10 minutes
Min/Max recommended Temperature:      0/ 0 Celsius
Min/Max Temperature Limit:            0/ 0 Celsius
Temperature History Size (Index):    128 (20)

Index    Estimated Time   Temperature Celsius
  21    2013-12-16 14:00    22  ***
 ...    ..( 18 skipped).    ..  ***
  40    2013-12-16 17:10    22  ***
  41    2013-12-16 17:20    23  ****
  42    2013-12-16 17:30    22  ***
 ...    ..(  9 skipped).    ..  ***
  52    2013-12-16 19:10    22  ***
  53    2013-12-16 19:20    21  **
  54    2013-12-16 19:30    22  ***
 ...    ..( 25 skipped).    ..  ***
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
 ...    ..(  7 skipped).    ..  **
  20    2013-12-17 11:10    21  **


--9jxsPFA5p3P2qPhR--
