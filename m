From: Julie Ashworth <ashworth@berkeley.edu>
Subject: request help with RAID1 array that endlessly attempts to sync
Date: Mon, 16 Dec 2013 22:50:28 -0800
Message-ID: <20131217065028.GC20941@nx5.priv>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hi,
I have a RAID1 array (md1) with two partitions (/dev/sda1 and /dev/sdb1).

Earlier today, I replaced /dev/sda because it had errors (reported by smartd/smartctl)
# mdadm /dev/md0 -f /dev/sda1 -r /dev/sda1
# mdadm /dev/md1 -f /dev/sda2 -r /dev/sda2

I replaced and formatted the drive and added it to the RAID1 arrays:

# mdadm /dev/md0 -a /dev/sda1
# mdadm /dev/md1 -a /dev/sda2

Everything looked great at first:
# cat /proc/mdstat 
Personalities : [raid1] 
md0 : active raid1 sda1[0] sdb1[1]
      521984 blocks [2/2] [UU]
      
md1 : active raid1 sda2[2] sdb2[1]
      976237824 blocks [2/1] [_U]
      [====>................]  recovery = 22.4% (219600512/976237824) finish=131.5min speed=95860K/sec
      
unused devices: <none>


But the sync restarted w/o error.

So, I ran:
# smartctl -a /dev/sdb

... which returned 3 errors.

After the second time the sync restarted, smartctl reported 24 errors on /dev/sdb. It has restarted a few times since then, but smartctl reports the same number of errors (24).

I'm enclosing the output from 'smartctl -a /dev/sdb'.
I tried to run a short selftest, but aborted it after 10 minutes. I was concerned that I shouldn't run a selftest at the same time it's rebuilding.

For what it's worth, I can't pause the sync. The command:

# echo idle > /sys/block/md1/md/sync_action

... has apparently no effect.

Can anybody make a recommendation? I'd rather not reboot, but I have a planned outage scheduled Friday.

Thanks in advance for any help,
Julie 
-----------


 

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="smartctl.out"

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
Local Time is:    Mon Dec 16 22:27:54 2013 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (  22)	The self-test routine was aborted by
					the host.
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
  1 Raw_Read_Error_Rate     0x000f   079   062   044    Pre-fail  Always       -       94946845
  3 Spin_Up_Time            0x0003   099   099   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       29
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       3
  7 Seek_Error_Rate         0x000f   081   060   030    Pre-fail  Always       -       131642238
  9 Power_On_Hours          0x0032   067   067   000    Old_age   Always       -       29562
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   037   020    Old_age   Always       -       29
184 Unknown_Attribute       0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   098   098   000    Old_age   Always       -       2
188 Unknown_Attribute       0x0032   100   096   000    Old_age   Always       -       42950328381
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0022   078   060   045    Old_age   Always       -       22 (Lifetime Min/Max 18/40)
194 Temperature_Celsius     0x0022   022   040   000    Old_age   Always       -       22 (0 15 0 0)
195 Hardware_ECC_Recovered  0x001a   064   048   000    Old_age   Always       -       94946845
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       1
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       1
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0

SMART Error Log Version: 1
ATA Error Count: 24 (device log contains only the most recent five errors)
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

Error 24 occurred at disk power-on lifetime: 29559 hours (1231 days + 15 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  23d+11:18:28.172  READ FPDMA QUEUED
  27 00 00 00 00 00 e0 00  23d+11:18:28.145  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  23d+11:18:28.143  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  23d+11:18:28.130  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  23d+11:18:28.102  READ NATIVE MAX ADDRESS EXT

Error 23 occurred at disk power-on lifetime: 29559 hours (1231 days + 15 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  23d+11:18:25.024  READ FPDMA QUEUED
  27 00 00 00 00 00 e0 00  23d+11:18:24.996  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  23d+11:18:24.995  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  23d+11:18:24.982  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  23d+11:18:24.954  READ NATIVE MAX ADDRESS EXT

Error 22 occurred at disk power-on lifetime: 29559 hours (1231 days + 15 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  23d+11:18:21.884  READ FPDMA QUEUED
  27 00 00 00 00 00 e0 00  23d+11:18:21.856  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  23d+11:18:21.855  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  23d+11:18:21.841  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  23d+11:18:21.814  READ NATIVE MAX ADDRESS EXT

Error 21 occurred at disk power-on lifetime: 29559 hours (1231 days + 15 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  23d+11:18:18.752  READ FPDMA QUEUED
  27 00 00 00 00 00 e0 00  23d+11:18:18.724  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  23d+11:18:18.723  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  23d+11:18:18.710  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  23d+11:18:18.682  READ NATIVE MAX ADDRESS EXT

Error 20 occurred at disk power-on lifetime: 29559 hours (1231 days + 15 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  23d+11:18:15.645  READ FPDMA QUEUED
  27 00 00 00 00 00 e0 00  23d+11:18:15.617  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  23d+11:18:15.616  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  23d+11:18:15.603  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  23d+11:18:15.575  READ NATIVE MAX ADDRESS EXT

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


--LZvS9be/3tNcYl/X--
