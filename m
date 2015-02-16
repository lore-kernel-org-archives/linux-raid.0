From: Dush <tomdush@gmail.com>
Subject: Re: All drive in Raid 5 are in 'spare' mode
Date: Mon, 16 Feb 2015 22:24:10 +0000
Message-ID: <CAL7hTOezLxYm_1z-cYp01LSAb4bUN09-9qi_Jdo6sQkqsYCFzA@mail.gmail.com>
References: <CAL7hTOctZ4tAoPSbO3iFEohRyXuvcY4=6yQj8U-FpoAhV6sT0w@mail.gmail.com>
 <54DC04C1.4010107@turmel.org> <CAL7hTOfhWiCmKVVCtpmHuB-OJkZjQsuaKZMN8oFKAArh=NuSHQ@mail.gmail.com>
 <54E24D10.7030901@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54E24D10.7030901@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> {Convention on kernel.org is to trim replies and either bottom post or
> interleave.  Please don't top-post.}

Sorry about that...


> Where are the forensics I asked for as "Step one"?

# dmesg
[   12.273354] ata7: softreset failed (1st FIS failed)
[   22.273352] ata7: softreset failed (1st FIS failed)
[   57.273349] ata7: softreset failed (1st FIS failed)
[   57.273556] ata7: limiting SATA link speed to 1.5 Gbps
[   62.446679] ata7: softreset failed (device not ready)
[   62.446892] ata7: reset failed, giving up
[   62.933371] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   62.939016] ata8.00: ATA-8: SAMSUNG HD103SJ, 1AJ10001, max UDMA/133
[   62.939019] ata8.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[   62.944696] ata8.00: configured for UDMA/133
[    0.380968] random: systemd-tmpfile urandom read with 1 bits of
entropy available
[    0.411310] ata1: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 17
[    0.411312] ata2: PATA max UDMA/100 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 17
[   63.473837] systemd[1]: Cannot add dependency job for unit
gssproxy.service, ignoring: Unit gssproxy.service failed to load: No
such file or directory.
[   63.632259] systemd-journald[157]: Received request to flush
runtime journal from PID 1
[   63.884029] md: bind<sdc2>
[   63.895136] md: bind<sdc3>
[   63.910832] md: bind<sdb2>
[   63.926903] md: bind<sdd3>
[   63.937151] md: bind<sdd2>
[   63.940172] md: bind<sdb3>
[   94.538293] md: raid6 personality registered for level 6
[   94.538298] md: raid5 personality registered for level 5
[   94.538300] md: raid4 personality registered for level 4
[   94.538954] md/raid:md127: device sdd2 operational as raid disk 1
[   94.538958] md/raid:md127: device sdb2 operational as raid disk 3
[   94.538960] md/raid:md127: device sdc2 operational as raid disk 0
[   94.539457] md/raid:md127: allocated 0kB
[   94.539493] md/raid:md127: raid level 5 active with 3 out of 4
devices, algorithm 2
[   94.539568] md127: detected capacity change from 0 to 16927358976
[   94.544725]  md127: unknown partition table


# smartctl -x /dev/sdb
smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.18.6-1-ARCH] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.11
Device Model:     ST3500320AS
Serial Number:    9QM8H48M
LU WWN Device Id: 5 000c50 01099d533
Firmware Version: SD15
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Mon Feb 16 22:09:04 2015 GMT

==> WARNING: There are known problems with these drives,
THIS DRIVE MAY OR MAY NOT BE AFFECTED,
see the following web pages for details:
http://knowledge.seagate.com/articles/en_US/FAQ/207931en
http://knowledge.seagate.com/articles/en_US/FAQ/207951en
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=632758

SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Unknown

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                       was completed without error.
                                       Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                       without error or no self-test has ever
                                       been run.
Total time to complete Offline
data collection:                (  650) seconds.
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
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 120) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x103b) SCT Status supported.
                                       SCT Error Recovery Control supported.
                                       SCT Feature Control supported.
                                       SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
 1 Raw_Read_Error_Rate     POSR--   099   088   006    -    160388856
 3 Spin_Up_Time            PO----   094   088   000    -    0
 4 Start_Stop_Count        -O--CK   099   099   020    -    1288
 5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    1290
 7 Seek_Error_Rate         POSR--   069   060   030    -    77467799408
 9 Power_On_Hours          -O--CK   061   061   000    -    34392
10 Spin_Retry_Count        PO--C-   100   100   097    -    0
12 Power_Cycle_Count       -O--CK   100   100   020    -    988
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   001   001   000    -    183
188 Command_Timeout         -O--CK   100   096   000    -    4295032839
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   067   054   045    -    33 (Min/Max 16/33)
194 Temperature_Celsius     -O---K   033   046   000    -    33 (0 10 0 0 0)
195 Hardware_ECC_Recovered  -O-RC-   024   016   000    -    160388856
197 Current_Pending_Sector  -O--C-   100   100   000    -    757
198 Offline_Uncorrectable   ----C-   100   100   000    -    757
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
0xa8       GPL,SL  VS      20  Device vendor specific log
0xa9       GPL,SL  VS       1  Device vendor specific log
0xb0       GPL     VS    2819  Device vendor specific log
0xbe-0xbf  GPL     VS   65535  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
Device Error Count: 261 (device log contains only the most recent 20 errors)
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

Error 261 [0] occurred at disk power-on lifetime: 34388 hours (1432
days + 20 hours)
 When the command that caused the error occurred, the device was active or idle.

 After command completion occurred, registers were:
 ER -- ST COUNT  LBA_48  LH LM LL DV DC
 -- -- -- == -- == == == -- -- -- -- --
 04 -- 71 00 04 00 00 00 00 32 9d e0 00  Device Fault; Error: ABRT

 Commands leading to the command that caused the error were:
 CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
 -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
 a1 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:14.067  IDENTIFY PACKET DEVICE
 ec 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:14.067  IDENTIFY DEVICE
 00 00 00 00 00 00 00 00 00 00 00 00 04     13:02:13.913  NOP [Abort
queued commands]
 00 00 00 00 00 00 00 00 00 00 00 00 ff     13:02:13.587  NOP [Abort
queued commands]
 a1 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:08.581  IDENTIFY PACKET DEVICE

Error 260 [19] occurred at disk power-on lifetime: 34388 hours (1432
days + 20 hours)
 When the command that caused the error occurred, the device was active or idle.

 After command completion occurred, registers were:
 ER -- ST COUNT  LBA_48  LH LM LL DV DC
 -- -- -- == -- == == == -- -- -- -- --
 04 -- 71 00 04 00 00 00 00 32 9d e0 00

 Commands leading to the command that caused the error were:
 CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
 -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
 ec 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:14.067  IDENTIFY DEVICE
 00 00 00 00 00 00 00 00 00 00 00 00 04     13:02:13.913  NOP [Abort
queued commands]
 00 00 00 00 00 00 00 00 00 00 00 00 ff     13:02:13.587  NOP [Abort
queued commands]
 a1 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:08.581  IDENTIFY PACKET DEVICE
 ec 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:08.580  IDENTIFY DEVICE

Error 259 [18] occurred at disk power-on lifetime: 34388 hours (1432
days + 20 hours)
 When the command that caused the error occurred, the device was active or idle.

 After command completion occurred, registers were:
 ER -- ST COUNT  LBA_48  LH LM LL DV DC
 -- -- -- == -- == == == -- -- -- -- --
 04 -- 71 00 04 00 00 00 00 32 9d e0 00  Device Fault; Error: ABRT

 Commands leading to the command that caused the error were:
 CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
 -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
 a1 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:08.581  IDENTIFY PACKET DEVICE
 ec 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:08.580  IDENTIFY DEVICE
 00 00 00 00 00 00 00 00 00 00 00 00 04     13:02:08.427  NOP [Abort
queued commands]
 00 00 00 00 00 00 00 00 00 00 00 00 ff     13:02:08.107  NOP [Abort
queued commands]
 a1 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:08.086  IDENTIFY PACKET DEVICE

Error 258 [17] occurred at disk power-on lifetime: 34388 hours (1432
days + 20 hours)
 When the command that caused the error occurred, the device was active or idle.

 After command completion occurred, registers were:
 ER -- ST COUNT  LBA_48  LH LM LL DV DC
 -- -- -- == -- == == == -- -- -- -- --
 04 -- 71 00 04 00 00 00 00 32 9d e0 00

 Commands leading to the command that caused the error were:
 CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
 -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
 ec 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:08.580  IDENTIFY DEVICE
 00 00 00 00 00 00 00 00 00 00 00 00 04     13:02:08.427  NOP [Abort
queued commands]
 00 00 00 00 00 00 00 00 00 00 00 00 ff     13:02:08.107  NOP [Abort
queued commands]
 a1 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:08.086  IDENTIFY PACKET DEVICE
 ec 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:08.069  IDENTIFY DEVICE

Error 257 [16] occurred at disk power-on lifetime: 34388 hours (1432
days + 20 hours)
 When the command that caused the error occurred, the device was active or idle.

 After command completion occurred, registers were:
 ER -- ST COUNT  LBA_48  LH LM LL DV DC
 -- -- -- == -- == == == -- -- -- -- --
 04 -- 71 00 04 00 00 00 00 32 9d e0 00  Device Fault; Error: ABRT

 Commands leading to the command that caused the error were:
 CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
 -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
 a1 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:08.086  IDENTIFY PACKET DEVICE
 ec 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:08.069  IDENTIFY DEVICE
 2f 00 00 00 01 00 00 00 00 00 10 a0 00     13:02:08.047  READ LOG EXT
 60 00 00 00 10 00 00 81 00 05 ef 40 00     13:02:04.913  READ FPDMA QUEUED
 60 00 00 00 08 00 00 83 00 04 9f 40 00     13:02:04.913  READ FPDMA QUEUED

Error 256 [15] occurred at disk power-on lifetime: 34388 hours (1432
days + 20 hours)
 When the command that caused the error occurred, the device was active or idle.

 After command completion occurred, registers were:
 ER -- ST COUNT  LBA_48  LH LM LL DV DC
 -- -- -- == -- == == == -- -- -- -- --
 04 -- 71 00 04 00 00 00 00 32 9d e0 00

 Commands leading to the command that caused the error were:
 CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
 -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
 ec 00 00 00 00 00 00 00 00 00 00 a0 00     13:02:08.069  IDENTIFY DEVICE
 2f 00 00 00 01 00 00 00 00 00 10 a0 00     13:02:08.047  READ LOG EXT
 60 00 00 00 10 00 00 81 00 05 ef 40 00     13:02:04.913  READ FPDMA QUEUED
 60 00 00 00 08 00 00 83 00 04 9f 40 00     13:02:04.913  READ FPDMA QUEUED
 60 00 00 00 08 00 00 41 00 08 47 40 00     13:02:04.912  READ FPDMA QUEUED

Error 255 [14] occurred at disk power-on lifetime: 34388 hours (1432
days + 20 hours)
 When the command that caused the error occurred, the device was active or idle.

 After command completion occurred, registers were:
 ER -- ST COUNT  LBA_48  LH LM LL DV DC
 -- -- -- == -- == == == -- -- -- -- --
 04 -- 71 00 04 00 00 00 00 32 9d e0 00  Device Fault; Error: ABRT

 Commands leading to the command that caused the error were:
 CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
 -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
 2f 00 00 00 01 00 00 00 00 00 10 a0 00     13:02:08.047  READ LOG EXT
 60 00 00 00 10 00 00 81 00 05 ef 40 00     13:02:04.913  READ FPDMA QUEUED
 60 00 00 00 08 00 00 83 00 04 9f 40 00     13:02:04.913  READ FPDMA QUEUED
 60 00 00 00 08 00 00 41 00 08 47 40 00     13:02:04.912  READ FPDMA QUEUED
 60 00 00 00 08 00 00 70 00 06 b7 40 00     13:02:04.909  READ FPDMA QUEUED

Error 254 [13] occurred at disk power-on lifetime: 34388 hours (1432
days + 20 hours)
 When the command that caused the error occurred, the device was active or idle.

 After command completion occurred, registers were:
 ER -- ST COUNT  LBA_48  LH LM LL DV DC
 -- -- -- == -- == == == -- -- -- -- --
 04 -- 71 00 04 00 00 00 00 32 9d 40 00  Device Fault; Error: ABRT at
LBA = 0x0000329d = 12957

 Commands leading to the command that caused the error were:
 CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
 -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
 60 00 00 00 10 00 00 81 00 05 ef 40 00     13:02:04.913  READ FPDMA QUEUED
 60 00 00 00 08 00 00 83 00 04 9f 40 00     13:02:04.913  READ FPDMA QUEUED
 60 00 00 00 08 00 00 41 00 08 47 40 00     13:02:04.912  READ FPDMA QUEUED
 60 00 00 00 08 00 00 70 00 06 b7 40 00     13:02:04.909  READ FPDMA QUEUED
 60 00 00 00 08 00 00 7e 00 03 87 40 00     13:02:04.909  READ FPDMA QUEUED

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed: read failure       90%     34220
      336941
# 2  Extended offline    Completed: read failure       90%     32539
      39315653
# 3  Extended offline    Completed without error       00%     25079         -
# 4  Extended offline    Interrupted (host reset)      00%     24385         -
# 5  Short offline       Completed without error       00%     19163         -
# 6  Short offline       Completed without error       00%     10742         -
# 7  Extended offline    Completed without error       00%        79         -

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
Current Temperature:                    33 Celsius
Power Cycle Min/Max Temperature:     16/33 Celsius
Lifetime    Min/Max Temperature:     10/46 Celsius
Under/Over Temperature Limit Count:   0/235

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/ 0 Celsius
Min/Max Temperature Limit:            0/ 0 Celsius
Temperature History Size (Index):    128 (50)

Index    Estimated Time   Temperature Celsius
 51    2015-02-16 20:02    30  ***********
...    ..( 12 skipped).    ..  ***********
 64    2015-02-16 20:15    30  ***********
 65    2015-02-16 20:16    28  *********
 66    2015-02-16 20:17    28  *********
 67    2015-02-16 20:18    28  *********
 68    2015-02-16 20:19    29  **********
...    ..(  6 skipped).    ..  **********
 75    2015-02-16 20:26    29  **********
 76    2015-02-16 20:27    30  ***********
...    ..(  9 skipped).    ..  ***********
 86    2015-02-16 20:37    30  ***********
 87    2015-02-16 20:38    31  ************
...    ..( 40 skipped).    ..  ************
  0    2015-02-16 21:19    31  ************
  1    2015-02-16 21:20    32  *************
...    ..( 38 skipped).    ..  *************
 40    2015-02-16 21:59    32  *************
 41    2015-02-16 22:00    33  **************
...    ..(  8 skipped).    ..  **************
 50    2015-02-16 22:09    33  **************

SCT Error Recovery Control:
          Read: Disabled
         Write: Disabled

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2           14  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS

# smartctl -x /dev/sdc
smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.18.6-1-ARCH] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Black
Device Model:     WDC WD5001AALS-00E3A0
Serial Number:    WD-WCATR3121296
LU WWN Device Id: 5 0014ee 25a457f4e
Firmware Version: 05.01D05
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Mon Feb 16 22:09:29 2015 GMT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Disabled
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                       was completed without error.
                                       Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                       without error or no self-test has ever
                                       been run.
Total time to complete Offline
data collection:                ( 8700) seconds.
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
recommended polling time:        ( 103) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x3037) SCT Status supported.
                                       SCT Feature Control supported.
                                       SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
 1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
 3 Spin_Up_Time            POS--K   179   174   021    -    4050
 4 Start_Stop_Count        -O--CK   100   100   000    -    963
 5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
 7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
 9 Power_On_Hours          -O--CK   068   068   000    -    23596
10 Spin_Retry_Count        -O--CK   100   100   000    -    0
11 Calibration_Retry_Count -O--CK   100   100   000    -    0
12 Power_Cycle_Count       -O--CK   100   100   000    -    739
192 Power-Off_Retract_Count -O--CK   200   200   000    -    97
193 Load_Cycle_Count        -O--CK   200   200   000    -    865
194 Temperature_Celsius     -O---K   111   097   000    -    36
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
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb5  GPL,SL  VS       1  Device vendor specific log
0xb6       GPL     VS       1  Device vendor specific log
0xb7       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      24  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     23424         -
# 2  Extended offline    Completed without error       00%     21741         -
# 3  Extended offline    Completed without error       00%     14306         -
# 4  Short offline       Completed without error       00%      8409         -
# 5  Short offline       Completed without error       00%         2         -

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

SCT Status Version:                  2
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    36 Celsius
Power Cycle Min/Max Temperature:     18/37 Celsius
Lifetime    Min/Max Temperature:     36/50 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (252)

Index    Estimated Time   Temperature Celsius
253    2015-02-16 14:12    35  ****************
...    ..(  6 skipped).    ..  ****************
260    2015-02-16 14:19    35  ****************
261    2015-02-16 14:20    36  *****************
...    ..( 16 skipped).    ..  *****************
278    2015-02-16 14:37    36  *****************
279    2015-02-16 14:38    37  ******************
280    2015-02-16 14:39    36  *****************
...    ..(  2 skipped).    ..  *****************
283    2015-02-16 14:42    36  *****************
284    2015-02-16 14:43    37  ******************
285    2015-02-16 14:44    36  *****************
...    ..( 54 skipped).    ..  *****************
340    2015-02-16 15:39    36  *****************
341    2015-02-16 15:40    37  ******************
342    2015-02-16 15:41    36  *****************
...    ..(  3 skipped).    ..  *****************
346    2015-02-16 15:45    36  *****************
347    2015-02-16 15:46    37  ******************
348    2015-02-16 15:47    36  *****************
...    ..(  4 skipped).    ..  *****************
353    2015-02-16 15:52    36  *****************
354    2015-02-16 15:53    37  ******************
355    2015-02-16 15:54    36  *****************
...    ..(  2 skipped).    ..  *****************
358    2015-02-16 15:57    36  *****************
359    2015-02-16 15:58    37  ******************
360    2015-02-16 15:59    36  *****************
...    ..( 10 skipped).    ..  *****************
371    2015-02-16 16:10    36  *****************
372    2015-02-16 16:11    37  ******************
373    2015-02-16 16:12    36  *****************
...    ..( 12 skipped).    ..  *****************
386    2015-02-16 16:25    36  *****************
387    2015-02-16 16:26    37  ******************
388    2015-02-16 16:27    36  *****************
...    ..(145 skipped).    ..  *****************
 56    2015-02-16 18:53    36  *****************
 57    2015-02-16 18:54    35  ****************
...    ..( 46 skipped).    ..  ****************
104    2015-02-16 19:41    35  ****************
105    2015-02-16 19:42     ?  -
106    2015-02-16 19:43    18  -
107    2015-02-16 19:44    19  -
108    2015-02-16 19:45    20  *
109    2015-02-16 19:46    20  *
110    2015-02-16 19:47    21  **
111    2015-02-16 19:48    21  **
112    2015-02-16 19:49    22  ***
113    2015-02-16 19:50    22  ***
114    2015-02-16 19:51    23  ****
115    2015-02-16 19:52    24  *****
116    2015-02-16 19:53    25  ******
117    2015-02-16 19:54    25  ******
118    2015-02-16 19:55    25  ******
119    2015-02-16 19:56    26  *******
...    ..(  3 skipped).    ..  *******
123    2015-02-16 20:00    26  *******
124    2015-02-16 20:01    27  ********
125    2015-02-16 20:02    27  ********
126    2015-02-16 20:03    27  ********
127    2015-02-16 20:04    28  *********
128    2015-02-16 20:05    28  *********
129    2015-02-16 20:06    29  **********
...    ..(  4 skipped).    ..  **********
134    2015-02-16 20:11    29  **********
135    2015-02-16 20:12    30  ***********
...    ..(  4 skipped).    ..  ***********
140    2015-02-16 20:17    30  ***********
141    2015-02-16 20:18    31  ************
142    2015-02-16 20:19    31  ************
143    2015-02-16 20:20    30  ***********
144    2015-02-16 20:21    31  ************
...    ..(  3 skipped).    ..  ************
148    2015-02-16 20:25    31  ************
149    2015-02-16 20:26    32  *************
...    ..( 18 skipped).    ..  *************
168    2015-02-16 20:45    32  *************
169    2015-02-16 20:46    33  **************
...    ..( 16 skipped).    ..  **************
186    2015-02-16 21:03    33  **************
187    2015-02-16 21:04    34  ***************
...    ..(  2 skipped).    ..  ***************
190    2015-02-16 21:07    34  ***************
191    2015-02-16 21:08    35  ****************
192    2015-02-16 21:09    34  ***************
193    2015-02-16 21:10    35  ****************
...    ..( 31 skipped).    ..  ****************
225    2015-02-16 21:42    35  ****************
226    2015-02-16 21:43    36  *****************
227    2015-02-16 21:44    36  *****************
228    2015-02-16 21:45    35  ****************
229    2015-02-16 21:46    34  ***************
230    2015-02-16 21:47    33  **************
231    2015-02-16 21:48    33  **************
232    2015-02-16 21:49     ?  -
233    2015-02-16 21:50    33  **************
234    2015-02-16 21:51    32  *************
235    2015-02-16 21:52    32  *************
236    2015-02-16 21:53    33  **************
...    ..(  8 skipped).    ..  **************
245    2015-02-16 22:02    33  **************
246    2015-02-16 22:03    34  ***************
...    ..(  3 skipped).    ..  ***************
250    2015-02-16 22:07    34  ***************
251    2015-02-16 22:08    35  ****************
252    2015-02-16 22:09    35  ****************

SCT Error Recovery Control command not supported

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x000a  2            9  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x8000  4        14489  Vendor specific


# smartctl -x /dev/sdd
smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.18.6-1-ARCH] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint F3
Device Model:     SAMSUNG HD103SJ
Serial Number:    S246J9KB924045
LU WWN Device Id: 5 0024e9 2062a5827
Firmware Version: 1AJ10001
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 6
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Mon Feb 16 22:10:00 2015 GMT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Disabled
APM feature is:   Disabled
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                       was never started.
                                       Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                       without error or no self-test has ever
                                       been run.
Total time to complete Offline
data collection:                ( 9360) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                       Auto Offline data collection
on/off support.
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
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 156) minutes.
SCT capabilities:              (0x003f) SCT Status supported.
                                       SCT Error Recovery Control supported.
                                       SCT Feature Control supported.
                                       SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
 1 Raw_Read_Error_Rate     POSR-K   100   100   051    -    1
 2 Throughput_Performance  -OS--K   055   050   000    -    8667
 3 Spin_Up_Time            PO---K   069   067   025    -    9424
 4 Start_Stop_Count        -O--CK   100   100   000    -    589
 5 Reallocated_Sector_Ct   PO--CK   252   252   010    -    0
 7 Seek_Error_Rate         -OSR-K   252   252   051    -    0
 8 Seek_Time_Performance   --S--K   252   252   015    -    0
 9 Power_On_Hours          -O--CK   100   100   000    -    15097
10 Spin_Retry_Count        -O--CK   252   252   051    -    0
11 Calibration_Retry_Count -O--CK   252   252   000    -    0
12 Power_Cycle_Count       -O--CK   100   100   000    -    491
191 G-Sense_Error_Rate      -O---K   100   100   000    -    3
192 Power-Off_Retract_Count -O---K   252   252   000    -    0
194 Temperature_Celsius     -O----   064   055   000    -    34 (Min/Max 11/45)
195 Hardware_ECC_Recovered  -O-RCK   100   100   000    -    0
196 Reallocated_Event_Count -O--CK   252   252   000    -    0
197 Current_Pending_Sector  -O--CK   252   252   000    -    0
198 Offline_Uncorrectable   ----CK   252   252   000    -    0
199 UDMA_CRC_Error_Count    -OS-CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   -O-R-K   100   100   000    -    30
223 Load_Retry_Count        -O--CK   252   252   000    -    0
225 Load_Cycle_Count        -O--CK   100   100   000    -    591
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
0x02           SL  R/O      2  Comprehensive SMART error log
0x03       GPL     R/O      2  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      2  Extended self-test log
0x08       GPL     R/O      2  Power Conditions log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (2 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (2 sectors)
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     14928         -
# 2  Extended offline    Completed without error       00%     13234         -
# 3  Extended offline    Completed without error       00%      5808         -
# 4  Extended offline    Interrupted (host reset)      70%      5136         -

SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has
ever been run
SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
   1        0        0  Completed [00% left] (0-65535)
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
Current Temperature:                    34 Celsius
Power Cycle Min/Max Temperature:     19/34 Celsius
Lifetime    Min/Max Temperature:     14/64 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         5 minutes
Temperature Logging Interval:        5 minutes
Min/Max recommended Temperature:     -5/80 Celsius
Min/Max Temperature Limit:           -10/85 Celsius
Temperature History Size (Index):    128 (7)

Index    Estimated Time   Temperature Celsius
  8    2015-02-16 11:35    35  ****************
  9    2015-02-16 11:40    35  ****************
 10    2015-02-16 11:45    34  ***************
...    ..( 22 skipped).    ..  ***************
 33    2015-02-16 13:40    34  ***************
 34    2015-02-16 13:45    35  ****************
 35    2015-02-16 13:50    34  ***************
...    ..( 22 skipped).    ..  ***************
 58    2015-02-16 15:45    34  ***************
 59    2015-02-16 15:50    33  **************
 60    2015-02-16 15:55    33  **************
 61    2015-02-16 16:00    34  ***************
 62    2015-02-16 16:05    33  **************
 63    2015-02-16 16:10    34  ***************
 64    2015-02-16 16:15    33  **************
...    ..(  6 skipped).    ..  **************
 71    2015-02-16 16:50    33  **************
 72    2015-02-16 16:55    34  ***************
 73    2015-02-16 17:00    33  **************
 74    2015-02-16 17:05    33  **************
 75    2015-02-16 17:10    33  **************
 76    2015-02-16 17:15    34  ***************
 77    2015-02-16 17:20    33  **************
...    ..(  7 skipped).    ..  **************
 85    2015-02-16 18:00    33  **************
 86    2015-02-16 18:05    32  *************
 87    2015-02-16 18:10    33  **************
 88    2015-02-16 18:15    33  **************
 89    2015-02-16 18:20    32  *************
 90    2015-02-16 18:25    19  -
 91    2015-02-16 18:30    22  ***
 92    2015-02-16 18:35    24  *****
 93    2015-02-16 18:40    25  ******
 94    2015-02-16 18:45    26  *******
 95    2015-02-16 18:50    27  ********
 96    2015-02-16 18:55    28  *********
 97    2015-02-16 19:00    28  *********
 98    2015-02-16 19:05    29  **********
 99    2015-02-16 19:10    29  **********
100    2015-02-16 19:15    30  ***********
...    ..(  3 skipped).    ..  ***********
104    2015-02-16 19:35    30  ***********
105    2015-02-16 19:40    31  ************
...    ..(  5 skipped).    ..  ************
111    2015-02-16 20:10    31  ************
112    2015-02-16 20:15    32  *************
113    2015-02-16 20:20    30  ***********
114    2015-02-16 20:25    30  ***********
115    2015-02-16 20:30    31  ************
116    2015-02-16 20:35    31  ************
117    2015-02-16 20:40    32  *************
118    2015-02-16 20:45    32  *************
119    2015-02-16 20:50    32  *************
120    2015-02-16 20:55    33  **************
...    ..(  7 skipped).    ..  **************
  0    2015-02-16 21:35    33  **************
  1    2015-02-16 21:40    34  ***************
...    ..(  5 skipped).    ..  ***************
  7    2015-02-16 22:10    34  ***************

SCT Error Recovery Control:
          Read: Disabled
         Write: Disabled

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  4            0  Command failed due to ICRC error
0x0002  4            0  R_ERR response for data FIS
0x0003  4            0  R_ERR response for device-to-host data FIS
0x0004  4            0  R_ERR response for host-to-device data FIS
0x0005  4            0  R_ERR response for non-data FIS
0x0006  4            0  R_ERR response for device-to-host non-data FIS
0x0007  4            0  R_ERR response for host-to-device non-data FIS
0x0008  4            0  Device-to-host non-data FIS retries
0x0009  4           16  Transition from drive PhyRdy to drive PhyNRdy
0x000a  4           14  Device-to-host register FISes sent due to a COMRESET
0x000b  4            0  CRC errors within host-to-device FIS
0x000d  4            0  Non-CRC errors within host-to-device FIS
0x000f  4            0  R_ERR response for host-to-device data FIS, CRC
0x0010  4            0  R_ERR response for host-to-device data FIS, non-CRC
0x0012  4            0  R_ERR response for host-to-device non-data FIS, CRC
0x0013  4            0  R_ERR response for host-to-device non-data FIS, non-CRC
0x8e00  4            0  Vendor specific
0x8e01  4            0  Vendor specific
0x8e02  4            0  Vendor specific
0x8e03  4            0  Vendor specific
0x8e04  4            0  Vendor specific
0x8e05  4            0  Vendor specific
0x8e06  4            0  Vendor specific
0x8e07  4            0  Vendor specific
0x8e08  4            0  Vendor specific
0x8e09  4            0  Vendor specific
0x8e0a  4            0  Vendor specific
0x8e0b  4            0  Vendor specific
0x8e0c  4            0  Vendor specific
0x8e0d  4            0  Vendor specific
0x8e0e  4            0  Vendor specific
0x8e0f  4            0  Vendor specific
0x8e10  4            0  Vendor specific
0x8e11  4            0  Vendor specific

No /dev/sde anymore...


>  Did you read about and fix any timeout mismatch issue?

I did yes but not sure to understand how to set up 120 second timeout
in sysfs...

The following commands is still valid without 1 of my drives?
mdadm --stop /dev/md126
mdadm --assemble --force --verbose --run /dev/md126 /dev/sd[bcd]3


> Also, your device names have changed.  You *must* keep track of which
> one is which "RaidDevice".  Specifically, what was "sde" now appears to
> be "sdd".  Did you reboot?  You know that device names are not
> guaranteed to be consistent from one boot to the next, I hope.  Show an
> excerpt from "ls -l /dev/disk/by-id/" with your next report so we know
> which drive serial number has which name.

Now you said it, I'm felling stupid... Yes, I reboot every day and I
don't have trace of previous "mapping" (id -> name).

# ls -l /dev/disk/by-id
total 0
lrwxrwxrwx 1 root root  9 Feb 16 21:16
ata-SAMSUNG_HD103SJ_S246J9KB924045 -> ../../sdd
lrwxrwxrwx 1 root root 10 Feb 16 21:16
ata-SAMSUNG_HD103SJ_S246J9KB924045-part1 -> ../../sdd1
lrwxrwxrwx 1 root root 10 Feb 16 21:16
ata-SAMSUNG_HD103SJ_S246J9KB924045-part2 -> ../../sdd2
lrwxrwxrwx 1 root root 10 Feb 16 21:16
ata-SAMSUNG_HD103SJ_S246J9KB924045-part3 -> ../../sdd3
lrwxrwxrwx 1 root root 10 Feb 16 21:16
ata-SAMSUNG_HD103SJ_S246J9KB924045-part4 -> ../../sdd4
lrwxrwxrwx 1 root root  9 Feb 16 21:16 ata-ST3500320AS_9QM8H48M -> ../../sdb
lrwxrwxrwx 1 root root 10 Feb 16 21:16 ata-ST3500320AS_9QM8H48M-part1
-> ../../sdb1
lrwxrwxrwx 1 root root 10 Feb 16 21:16 ata-ST3500320AS_9QM8H48M-part2
-> ../../sdb2
lrwxrwxrwx 1 root root 10 Feb 16 21:16 ata-ST3500320AS_9QM8H48M-part3
-> ../../sdb3
lrwxrwxrwx 1 root root  9 Feb 16 21:16
ata-WDC_WD5001AALS-00E3A0_WD-WCATR3121296 -> ../../sdc
lrwxrwxrwx 1 root root 10 Feb 16 21:16
ata-WDC_WD5001AALS-00E3A0_WD-WCATR3121296-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 Feb 16 21:16
ata-WDC_WD5001AALS-00E3A0_WD-WCATR3121296-part2 -> ../../sdc2
lrwxrwxrwx 1 root root 10 Feb 16 21:16
ata-WDC_WD5001AALS-00E3A0_WD-WCATR3121296-part3 -> ../../sdc3
lrwxrwxrwx 1 root root 11 Feb 16 21:17
md-uuid-6408f077:eefbe269:c173be8e:b17eb4df -> ../../md127
lrwxrwxrwx 1 root root  9 Feb 16 21:16 wwn-0x5000c5001099d533 -> ../../sdb
lrwxrwxrwx 1 root root 10 Feb 16 21:16 wwn-0x5000c5001099d533-part1 ->
../../sdb1
lrwxrwxrwx 1 root root 10 Feb 16 21:16 wwn-0x5000c5001099d533-part2 ->
../../sdb2
lrwxrwxrwx 1 root root 10 Feb 16 21:16 wwn-0x5000c5001099d533-part3 ->
../../sdb3
lrwxrwxrwx 1 root root  9 Feb 16 21:16 wwn-0x50014ee25a457f4e -> ../../sdc
lrwxrwxrwx 1 root root 10 Feb 16 21:16 wwn-0x50014ee25a457f4e-part1 ->
../../sdc1
lrwxrwxrwx 1 root root 10 Feb 16 21:16 wwn-0x50014ee25a457f4e-part2 ->
../../sdc2
lrwxrwxrwx 1 root root 10 Feb 16 21:16 wwn-0x50014ee25a457f4e-part3 ->
../../sdc3
lrwxrwxrwx 1 root root  9 Feb 16 21:16 wwn-0x50024e92062a5827 -> ../../sdd
lrwxrwxrwx 1 root root 10 Feb 16 21:16 wwn-0x50024e92062a5827-part1 ->
../../sdd1
lrwxrwxrwx 1 root root 10 Feb 16 21:16 wwn-0x50024e92062a5827-part2 ->
../../sdd2
lrwxrwxrwx 1 root root 10 Feb 16 21:16 wwn-0x50024e92062a5827-part3 ->
../../sdd3
lrwxrwxrwx 1 root root 10 Feb 16 21:16 wwn-0x50024e92062a5827-part4 ->
../../sdd4


Thanks,
Dush
