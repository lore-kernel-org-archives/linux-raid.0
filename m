From: <yuji_touya@yokogawa-digital.com>
Subject: RE: Help raid10 recovery from 2 disks removed
Date: Thu, 24 Oct 2013 10:14:42 +0000
Message-ID: <1F36A02C60ACD1478457DCD917DA0FA8034983@ZEX001-0M9030.jp.ykgw.net>
References: <1F36A02C60ACD1478457DCD917DA0FA8034656@ZEX001-0M9030.jp.ykgw.net>
 <alpine.DEB.2.02.1310241050290.1838@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1310241050290.1838@uplift.swm.pp.se>
Content-Language: ja-JP
Sender: linux-raid-owner@vger.kernel.org
To: swmike@swm.pp.se
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael,

Thank you for your great help!
I could assemble /dev/md0 by using only /dev/sd[bde], and mount it (read only) to /home.

# mdadm --misc --stop /dev/md0
mdadm: stopped /dev/md0

# mdadm --assemble --force /dev/md0 /dev/sd[bde]
mdadm: forcing event count in /dev/sdb(0) from 34220 upto 34224
mdadm: /dev/md0 has been started with 3 drives (out of 4).

# cat /proc/mdstat
Personalities : [raid10]
md0 : active raid10 sdb[0] sde[3] sdd[2]
      3907028992 blocks 1024K chunks 2 near-copies [4/3] [U_UU]

unused devices: <none>

> You need to figure out what happened to get sdb kicked out of the array,
> check logs and "dmesg". Also use smartctl to check sdb and see if it's
> failing.

Here's syslog entries about raid10 and smartctl output.
sdb seems to have too many bad blocks. Is that the reason why sdb was kicked out?
I'm going to copy files from /dev/md0 to anywhere else as soon as possible.
Should I repair filesystem before copying? (like xfs_repair /dev/md0)


Oct 23 18:11:29 localhost kernel: sd 0:0:1:0: [sdb] Sense Key : Medium Error [current] [descriptor]
Oct 23 18:11:29 localhost kernel: Descriptor sense data with sense descriptors (in hex):
Oct 23 18:11:29 localhost kernel:        72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
Oct 23 18:11:29 localhost kernel:        11 af 30 10
Oct 23 18:11:29 localhost kernel: sd 0:0:1:0: [sdb] Add. Sense: Unrecovered read error - auto reallocate failed
Oct 23 18:11:29 localhost kernel: end_request: I/O error, dev sdb, sector 296693776
Oct 23 18:11:29 localhost kernel: ata1: EH complete
Oct 23 18:11:29 localhost kernel: raid10: Disk failure on sdb, disabling device.
Oct 23 18:11:29 localhost kernel: raid10: Operation continuing on 2 devices.
Oct 23 18:11:29 localhost kernel: raid10: sdb: unrecoverable I/O read error for block 593387520
Oct 23 18:11:29 localhost kernel: raid10: sdb: unrecoverable I/O read error for block 593387768
Oct 23 18:11:29 localhost kernel: raid10: sdb: unrecoverable I/O read error for block 593388016
Oct 23 18:11:29 localhost kernel: raid10: sdb: unrecoverable I/O read error for block 593396704
Oct 23 18:11:29 localhost kernel: raid10: sdb: unrecoverable I/O read error for block 593396952
Oct 23 18:11:29 localhost kernel: raid10: sdb: unrecoverable I/O read error for block 593397200

# badblocks /dev/sdb > sdb.bad
# wc -l sdb.bad
69 sdb.bad

# smartctl -a /dev/sdb
smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     ST2000DM001-9YN164
Serial Number:    W240D0XN
Firmware Version: CC4C
User Capacity:    2,000,398,934,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Thu Oct 24 18:48:02 2013 JST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                 ( 592) seconds.
Offline data collection
capabilities:                    (0x73) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        No Offline surface scan supported.
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
recommended polling time:        ( 255) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x3085) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   115   097   006    Pre-fail  Always       -       88125160
  3 Spin_Up_Time            0x0003   093   093   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       14
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   068   060   030    Pre-fail  Always       -       6495909
  9 Power_On_Hours          0x0032   086   086   000    Old_age   Always       -       12734
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       14
183 Unknown_Attribute       0x0032   100   100   000    Old_age   Always       -       0
184 Unknown_Attribute       0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   001   001   000    Old_age   Always       -       655
188 Unknown_Attribute       0x0032   100   100   000    Old_age   Always       -       0
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0022   053   038   045    Old_age   Always   In_the_past 47 (13 90 58 39)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       7
193 Load_Cycle_Count        0x0032   096   096   000    Old_age   Always       -       9838
194 Temperature_Celsius     0x0022   047   062   000    Old_age   Always       -       47 (0 21 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       112
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       112
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       106154411688763
241 Unknown_Attribute       0x0000   100   253   000    Old_age   Offline      -       956764483658
242 Unknown_Attribute       0x0000   100   253   000    Old_age   Offline      -       154136770090

SMART Error Log Version: 1
ATA Error Count: 522 (device log contains only the most recent five errors)
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

Error 522 occurred at disk power-on lifetime: 12729 hours (530 days + 9 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00  23d+01:40:53.125  READ DMA EXT
  27 00 00 00 00 00 e0 00  23d+01:40:53.124  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  23d+01:40:53.121  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  23d+01:40:53.119  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  23d+01:40:53.090  READ NATIVE MAX ADDRESS EXT

Error 521 occurred at disk power-on lifetime: 12729 hours (530 days + 9 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00  23d+01:40:50.249  READ DMA EXT
  27 00 00 00 00 00 e0 00  23d+01:40:50.249  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  23d+01:40:50.246  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  23d+01:40:50.243  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  23d+01:40:50.215  READ NATIVE MAX ADDRESS EXT

Error 520 occurred at disk power-on lifetime: 12729 hours (530 days + 9 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00  23d+01:40:47.373  READ DMA EXT
  27 00 00 00 00 00 e0 00  23d+01:40:47.372  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  23d+01:40:47.369  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  23d+01:40:47.367  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  23d+01:40:47.340  READ NATIVE MAX ADDRESS EXT

Error 519 occurred at disk power-on lifetime: 12729 hours (530 days + 9 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00  23d+01:40:44.506  READ DMA EXT
  27 00 00 00 00 00 e0 00  23d+01:40:44.505  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  23d+01:40:44.502  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  23d+01:40:44.499  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  23d+01:40:44.472  READ NATIVE MAX ADDRESS EXT

Error 518 occurred at disk power-on lifetime: 12729 hours (530 days + 9 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00  23d+01:40:41.622  READ DMA EXT
  27 00 00 00 00 00 e0 00  23d+01:40:41.622  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  23d+01:40:41.618  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  23d+01:40:41.616  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  23d+01:40:41.589  READ NATIVE MAX ADDRESS EXT

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
-----
CONFIDENTIAL: This e-mail may contain information that is confidential or otherwise protected from disclosure and intended only for the party to whom it is addressed. If you are not the intended recipient, please notify the sender by return and delete this e-mail. You are hereby formally advised that any unauthorized use, disclosure or copying of this email is strictly prohibited and may be unlawful.
