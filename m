From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Velociraptor biting the dust (9th disk, continued to use it,
 and..)
Date: Sat, 22 Nov 2008 16:45:05 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811221638360.707@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Cc: smartmontools-support@lists.sourceforge.net, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

I have several questions, to make things more clear I have segmented this
e-mail a bit-- any help with this issue would be greatly appreciated, 
thank you.
================================================================================
So I continued to use the disk and it started failing again:
A Fail event had been detected on md device /dev/md2.
It could be related to component device /dev/sda3.
This is as it happened according to the kernel/dmesg:
================================================================================
[625188.381111] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[625188.381117] ata1.00: irq_stat 0x40000001
[625188.381124] ata1.00: cmd 25/00:a8:7b:57:8a/00:01:1c:00:00/e0 tag 0 dma 21708
8 in
[625188.381125]          res 51/40:a8:7b:57:8a/00:01:1c:00:00/e0 Emask 0x9 (medi
a error)
[625188.381130] ata1.00: status: { DRDY ERR }
[625188.381133] ata1.00: error: { UNC }
[625188.402821] ata1.00: configured for UDMA/133
[625188.402831] ata1: EH complete
[625188.413645] sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB
)
[625188.413665] sd 0:0:0:0: [sda] Write Protect is off
[625188.413668] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[625188.413692] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doe
sn't support DPO or FUA
[631340.401896] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[631340.401902] ata1.00: irq_stat 0x40000001
[631340.401907] ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[631340.401908]          res 51/04:00:34:cf:f3/00:00:00:f3:40/a3 Emask 0x1 (devi
ce error)
[631340.401912] ata1.00: status: { DRDY ERR }
[631340.401914] ata1.00: error: { ABRT }
[631340.421630] ata1.00: configured for UDMA/133
[631340.421641] ata1: EH complete
[631340.421824] sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB
)
================================================================================
[631340.433488] end_request: I/O error, dev sda, sector 586067067
                                                         ^^^^^^^^^
                                                         sector in question
================================================================================
[631340.433493] md: super_written gets error=-5, uptodate=0
[631340.433497] raid1: Disk failure on sda3, disabling device.
[631340.433498] raid1: Operation continuing on 1 devices.
[631340.433571] sd 0:0:0:0: [sda] Write Protect is off
[631340.433575] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[631340.442957] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doe
sn't support DPO or FUA
[631340.444794] RAID1 conf printout:
[631340.444798]  --- wd:1 rd:2
[631340.444800]  disk 0, wo:1, o:0, dev:sda3
[631340.444802]  disk 1, wo:0, o:1, dev:sdb3
[631340.448024] RAID1 conf printout:
[631340.448027]  --- wd:1 rd:2
[631340.448030]  disk 1, wo:0, o:1, dev:sdb3
================================================================================
Nov 22 14:34:02 p34 smartd[30574]: Device: /dev/sda, ATA error count increased from 2 to 3 
Nov 22 16:09:49 p34 mdadm[3285]: Fail event detected on md device /dev/md2, component device /dev/sda3
================================================================================
p34:~# hdparm --read-sector 586067067 /dev/sda
/dev/sda:
reading sector 586067067: succeeded
<prints out a lot of data, snipped for e-mail>
[ .. snip .. ]
p34:~# 
================================================================================
Does this mean the drive already remapped the bad sector?
[632350.116576] sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
586067067 <- says this is the bad sector
586072368 <- total number of sectors

# for sector in $(seq 586067060 586072368); do hdparm --read-sector $sector /dev/sda > sector.$sector; done
All sectors could be read except the last one:
-rw-r--r-- 1 root root 1327 2008-11-22 16:30 sector.586072364
-rw-r--r-- 1 root root 1327 2008-11-22 16:30 sector.586072365
-rw-r--r-- 1 root root 1327 2008-11-22 16:30 sector.586072366
-rw-r--r-- 1 root root 1327 2008-11-22 16:30 sector.586072367
-rw-r--r-- 1 root root   37 2008-11-22 16:30 sector.586072368
================================================================================
p34:~/read# dmesg
p34:~/read# # empty
p34:~/read# hdparm --read-sector 586072368 /dev/sda
/dev/sda:
reading sector 586072368: FAILED: Input/output error
p34:~/read# dmesg
[632714.975824] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[632714.975831] ata1.00: irq_stat 0x40000001
[632714.975837] ata1.00: cmd 24/00:01:30:c1:ee/00:00:22:00:00/40 tag 0 pio 512 in
[632714.975838]          res 51/10:01:30:c1:ee/00:00:22:00:00/40 Emask 0x81 (invalid argument)
[632714.975844] ata1.00: status: { DRDY ERR }
[632714.975847] ata1.00: error: { IDNF }
[632714.998757] ata1.00: configured for UDMA/133
[632714.998783] ata1: EH complete
[632714.998829] sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
[632714.998842] sd 0:0:0:0: [sda] Write Protect is off
[632714.998844] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[632714.998860] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
p34:~/read# 
Although its a different error IDNF, vs. that of above (UNC/ABRT).
================================================================================
In the smart logs on the disk; I see:

Error 3 occurred at disk power-on lifetime: 855 hours (35 days + 15 hours)
   When the command that caused the error occurred, the device was doing SMART Offline or Self-test.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 a8 7b 57 8a e0  Error: UNC 168 sectors at LBA = 0x008a577b = 9066363

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 a8 7b 57 8a 1c 08   9d+21:14:13.968  READ DMA EXT
   25 00 00 33 64 db 19 08   9d+21:13:56.211  READ DMA EXT
   25 00 00 a3 4c d6 19 08   9d+21:13:52.598  READ DMA EXT
   25 00 00 a3 38 d6 19 08   9d+21:13:52.586  READ DMA EXT
   25 00 00 a3 36 d6 19 08   9d+21:13:52.584  READ DMA EXT
================================================================================
However, the full smartctl output does not show any offline uncorrectable/etc
sectors yet?
================================================================================
BTW: I have already submitted an RMA for this disk (9th RMA!) I just cannot get
over how many of these are failing.
================================================================================
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD3000HLFS-01G6U0
Serial Number:    ***************
Firmware Version: 04.04V01
User Capacity:    300,069,052,416 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sat Nov 22 16:33:29 2008 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x85)	Offline data collection activity
 					was aborted by an interrupting command from host.
 					Auto Offline Data Collection: Enabled.
Self-test execution status:      ( 247)	Self-test routine in progress...
 					70% of test remaining.
Total time to complete Offline 
data collection: 		 (4800) seconds.
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
recommended polling time: 	 (  59) minutes.
Conveyance self-test routine
recommended polling time: 	 (   5) minutes.
SCT capabilities: 	       (0x303f)	SCT Status supported.
 					SCT Feature Control supported.
 					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail  Always       -       0
   3 Spin_Up_Time            0x0003   198   198   021    Pre-fail  Always       -       3083
   4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       22
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
   7 Seek_Error_Rate         0x000e   200   200   000    Old_age   Always       -       0
   9 Power_On_Hours          0x0032   099   099   000    Old_age   Always       -       857
  10 Spin_Retry_Count        0x0012   100   253   000    Old_age   Always       -       0
  11 Calibration_Retry_Count 0x0012   100   253   000    Old_age   Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       22
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       13
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       22
194 Temperature_Celsius     0x0022   118   115   000    Old_age   Always       -       29
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       0

SMART Error Log Version: 1
ATA Error Count: 4
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

Error 4 occurred at disk power-on lifetime: 857 hours (35 days + 17 hours)
   When the command that caused the error occurred, the device was doing SMART Offline or Self-test.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   04 51 00 34 cf f3 a3

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   ea 00 00 00 00 00 00 08   9d+22:56:39.886  FLUSH CACHE EXIT
   ca 00 20 13 9b 04 06 08   9d+22:56:39.685  WRITE DMA
   ca 00 08 2b 29 13 02 08   9d+22:56:39.685  WRITE DMA
   ca 00 08 83 57 05 02 08   9d+22:56:39.685  WRITE DMA
   ca 00 08 bb 54 05 02 08   9d+22:56:39.685  WRITE DMA

Error 3 occurred at disk power-on lifetime: 855 hours (35 days + 15 hours)
   When the command that caused the error occurred, the device was doing SMART Offline or Self-test.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 a8 7b 57 8a e0  Error: UNC 168 sectors at LBA = 0x008a577b = 9066363

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 a8 7b 57 8a 1c 08   9d+21:14:13.968  READ DMA EXT
   25 00 00 33 64 db 19 08   9d+21:13:56.211  READ DMA EXT
   25 00 00 a3 4c d6 19 08   9d+21:13:52.598  READ DMA EXT
   25 00 00 a3 38 d6 19 08   9d+21:13:52.586  READ DMA EXT
   25 00 00 a3 36 d6 19 08   9d+21:13:52.584  READ DMA EXT

Error 2 occurred at disk power-on lifetime: 822 hours (34 days + 6 hours)
   When the command that caused the error occurred, the device was doing SMART Offline or Self-test.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   04 51 00 34 cf f3 a3

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   ea 00 00 00 00 00 00 08   8d+11:51:40.026  FLUSH CACHE EXIT
   ea 00 00 00 00 00 00 08   8d+11:51:40.008  FLUSH CACHE EXIT
   35 00 08 7b ac ee 22 08   8d+11:51:40.008  WRITE DMA EXT
   ea 00 00 00 00 00 00 08   8d+11:51:35.045  FLUSH CACHE EXIT
   b0 d4 00 01 4f c2 00 08   8d+11:51:32.628  SMART EXECUTE OFF-LINE IMMEDIATE

Error 1 occurred at disk power-on lifetime: 818 hours (34 days + 2 hours)
   When the command that caused the error occurred, the device was doing SMART Offline or Self-test.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   04 51 00 34 cf f3 a3

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   ea 00 00 00 00 00 00 08   8d+07:53:27.728  FLUSH CACHE EXIT
   ea 00 00 00 00 00 00 08   8d+07:53:27.711  FLUSH CACHE EXIT
   35 00 08 7b ac ee 22 08   8d+07:53:27.711  WRITE DMA EXT
   ea 00 00 00 00 00 00 08   8d+07:53:24.980  FLUSH CACHE EXIT
   b0 d4 00 01 4f c2 00 08   8d+07:53:19.871  SMART EXECUTE OFF-LINE IMMEDIATE

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%       857         -
# 2  Short offline       Completed without error       00%       842         -
# 3  Extended offline    Completed without error       00%       823         -
# 4  Short offline       Completed without error       00%       822         -
# 5  Short offline       Completed without error       00%       822         -
# 6  Short offline       Completed without error       00%       818         -
# 7  Short offline       Completed without error       00%       794         -
# 8  Short offline       Completed without error       00%       771         -
# 9  Short offline       Completed without error       00%       747         -
#10  Short offline       Completed without error       00%       723         -
#11  Extended offline    Completed without error       00%       701         -
#12  Short offline       Completed without error       00%       676         -
#13  Short offline       Completed without error       00%       652         -
#14  Short offline       Completed without error       00%       628         -
#15  Short offline       Completed without error       00%       605         -
#16  Short offline       Completed without error       00%       581         -
#17  Extended offline    Completed without error       00%       535         -
#18  Short offline       Completed without error       00%       510         -
#19  Short offline       Completed without error       00%       486         -
#20  Short offline       Completed without error       00%       462         -
#21  Short offline       Completed without error       00%       438         -

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

