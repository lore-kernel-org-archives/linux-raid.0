From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Ninth(?) Velociraptor replacement or md(RAID)/smartmontools(?)
 bug?
Date: Fri, 21 Nov 2008 06:12:24 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811210600310.5577@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, martmontools-support@lists.sourceforge.net, Bruce Allen <ballen@gravity.phys.uwm.edu>
List-Id: linux-raid.ids

Comment 1: From Alan Cox:

================================================================================
Alan Cox <alan@lxorguk.ukuu.org.uk>

> Error 1 occurred at disk power-on lifetime: 818 hours (34 days + 2 hours)
>    When the command that caused the error occurred, the device was doing SMART
Offline or Self-test.
>
>    After command completion occurred, registers were:
>    ER ST SC SN CL CH DH
>    -- -- -- -- -- -- --
>    04 51 00 34 cf f3 a3

So Error 0x04 (ABRT)
Status 0x51 (DRDY N/A ERR)      Error occurred, and at the point data
transfer was expected

Which the spec says means the device errored the command because it does
not support it.

Seems odd that this then tripped a raid failover
================================================================================

Comment 1 Response: Should this have tripped a raid fail-over?  I have 
been having raid failures like this ever since I replaced all my 
raptor150s with velociraptor300 disks, what can be done so this does not 
occur?  Is this a WD/firmware bug or a bug in the md/raid code?

================================================================================

Other questions I have:

Question 1: With a 3ware controller, it will 'remap' bad sectors, example:

20081114005455 - Controller 0
WARNING - Sector repair completed: port=11, LBA=0x73E3EAC

Question 2: How come the kernel does not do this?  Does this not defeat 
the purpose of raid, it should remap the bad sector and continue 
processing, not drop the RAID/break it?

================================================================================

Logs from RAID1, smart info, etc, is SMART doing something bad on these 
newer velociraptor disks?

================================================================================

Security Events for kernel
=-=-=-=-=-=-=-=-=-=-=-=-=-
Nov 21 01:04:17 p34 kernel: [490609.124770] end_request: I/O error, dev sda,
sector 309997925
        ^^^^^^^^^ Bad sector?? Is it really?

System Events
=-=-=-=-=-=-=
Nov 21 01:04:17 p34 kernel: [490609.089174] ata1.00: exception Emask 0x0 SAct
0x0 SErr 0x0 action 0x0
Nov 21 01:04:17 p34 kernel: [490609.089180] ata1.00: irq_stat 0x40000001
Nov 21 01:04:17 p34 kernel: [490609.089186] ata1.00: cmd
ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Nov 21 01:04:17 p34 kernel: [490609.089187]          res
51/04:00:34:cf:f3/00:00:00:f3:40/a3 Emask 0x1 (device error)
Nov 21 01:04:17 p34 kernel: [490609.089192] ata1.00: status: { DRDY ERR }
Nov 21 01:04:17 p34 kernel: [490609.089195] ata1.00: error: { ABRT }
Nov 21 01:04:17 p34 kernel: [490609.113037] ata1.00: configured for UDMA/133
Nov 21 01:04:17 p34 kernel: [490609.124774] raid1: Disk failure on sda3,
disabling device.
Nov 21 01:04:17 p34 kernel: [490609.124775] raid1: Operation continuing on 1
devices.
Nov 21 01:04:17 p34 kernel: [490609.124802] sd 0:0:0:0: [sda] Write Protect is
off
Nov 21 01:04:17 p34 kernel: [490609.124803] sd 0:0:0:0: [sda] Mode Sense: 00 3a
00 00
Nov 21 01:04:17 p34 kernel: [490609.124820] sd 0:0:0:0: [sda] Write cache:
enabled, read cache: enabled, doesn't support DPO or FUA
Nov 21 01:04:17 p34 kernel: [490609.133725] RAID1 conf printout:
Nov 21 01:04:17 p34 kernel: [490609.133728]  --- wd:1 rd:2
Nov 21 01:04:17 p34 kernel: [490609.133731]  disk 0, wo:1, o:0, dev:sda3
Nov 21 01:04:17 p34 kernel: [490609.133733]  disk 1, wo:0, o:1, dev:sdb3
Nov 21 01:04:17 p34 kernel: [490609.136170] RAID1 conf printout:
Nov 21 01:04:17 p34 kernel: [490609.136172]  --- wd:1 rd:2
Nov 21 01:04:17 p34 kernel: [490609.136174]  disk 1, wo:0, o:1, dev:sdb3
Nov 21 01:04:17 p34 mdadm[3285]: Fail event detected on md device /dev/md2,
component device /dev/sda3
Nov 21 01:34:02 p34 smartd[30574]: Device: /dev/sda, ATA error count increased
from 0 to 1
Nov 21 01:34:02 p34 smartd[30574]: Warning via mail to root@lucidpixels.com:
successful

smart error:

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

smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD3000HLFS-01G6U0
Serial Number:    WD-*********
Firmware Version: 04.04V01
User Capacity:    300,069,052,416 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Fri Nov 21 04:06:58 2008 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x02)	Offline data collection activity
 					was completed without error.
 					Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)	The previous self-test routine completed
 					without error or no self-test has ever
 					been run.
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
   7 Seek_Error_Rate         0x000e   100   253   000    Old_age   Always       -       0
   9 Power_On_Hours          0x0032   099   099   000    Old_age   Always       -       821
  10 Spin_Retry_Count        0x0012   100   253   000    Old_age   Always       -       0
  11 Calibration_Retry_Count 0x0012   100   253   000    Old_age   Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       22
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       13
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       22
194 Temperature_Celsius     0x0022   121   115   000    Old_age   Always       -       26
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       0

SMART Error Log Version: 1
ATA Error Count: 1
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
# 1  Short offline       Completed without error       00%       818         -
# 2  Short offline       Completed without error       00%       794         -
# 3  Short offline       Completed without error       00%       771         -
# 4  Short offline       Completed without error       00%       747         -
# 5  Short offline       Completed without error       00%       723         -
# 6  Extended offline    Completed without error       00%       701         -
# 7  Short offline       Completed without error       00%       676         -
# 8  Short offline       Completed without error       00%       652         -
# 9  Short offline       Completed without error       00%       628         -
#10  Short offline       Completed without error       00%       605         -
#11  Short offline       Completed without error       00%       581         -
#12  Extended offline    Completed without error       00%       535         -
#13  Short offline       Completed without error       00%       510         -
#14  Short offline       Completed without error       00%       486         -
#15  Short offline       Completed without error       00%       462         -
#16  Short offline       Completed without error       00%       438         -
#17  Short offline       Completed without error       00%       414         -
#18  Short offline       Completed without error       00%       406         -
#19  Short offline       Completed without error       00%       391         -
#20  Extended offline    Completed without error       00%       366         -
#21  Short offline       Completed without error       00%       342         -

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

I put it back into the RAID and then another bad sector caused it to error out
again:

[504864.661639] RAID1 conf printout:
[504864.661643]  --- wd:2 rd:2
[504864.661646]  disk 0, wo:0, o:1, dev:sda3
[504864.661649]  disk 1, wo:0, o:1, dev:sdb3
[504915.503044] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[504915.503050] ata1.00: irq_stat 0x40000001
[504915.503055] ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[504915.503056]          res 51/04:00:34:cf:f3/00:00:00:f3:40/a3 Emask 0x1 (device error)
[504915.503059] ata1.00: status: { DRDY ERR }
[504915.503061] ata1.00: error: { ABRT }
[504915.526980] ata1.00: configured for UDMA/133
[504915.526990] ata1: EH complete
[504915.527187] sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
[504915.534181] end_request: I/O error, dev sda, sector 310069939
                                                         ^^^^^^^^^ Another one.
[504915.534187] raid1: Disk failure on sda3, disabling device.
[504915.534188] raid1: Operation continuing on 1 devices.
[504915.534476] sd 0:0:0:0: [sda] Write Protect is off
[504915.534479] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[504915.534505] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[504915.545832] RAID1 conf printout:
[504915.545837]  --- wd:1 rd:2


Try to write on those sectors, force remap?

p34:~# hdparm --write-sector 310069939 --yes-i-know-what-i-am-doing /dev/sda

/dev/sda:
re-writing sector 310069939: succeeded
p34:~#

p34:~# hdparm --write-sector 309997925 --yes-i-know-what-i-am-doing /dev/sda

/dev/sda:
re-writing sector 309997925: succeeded
p34:~#

p34:~# hdparm --repair-sector 310069939 --yes-i-know-what-i-am-doing /dev/sda

/dev/sda:
re-writing sector 310069939: succeeded

p34:~# hdparm --repair-sector 309997925 --yes-i-know-what-i-am-doing /dev/sda

/dev/sda:
re-writing sector 309997925: succeeded
p34:~#

-

Right now I am running a long smart test followed by an offline test to 
see what happens next.
