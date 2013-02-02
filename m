From: Michael Ritzert <ksciplot@gmx.net>
Subject: Re: recovering RAID5 from multiple disk failures
Date: Sat, 2 Feb 2013 13:04:40 +0000 (UTC)
Message-ID: <kej2t8$vk8$1@ger.gmane.org>
References: <kegcd6$6dl$1@ger.gmane.org> <510BC173.7070002@turmel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

In article <510BC173.7070002@turmel.org> you wrote:
>> So the situation is: I have a four-disk RAID5 with two active disks, and
>> two that dropped out at different times.
> 
> Please show the errors from dmesg.

I don't think I can provide that. The RAID ran in a QNAP system, and if
there is a log at all, it's on this disk...
During the copy process, it was all media errors, however.

> And show "smartctl -x" for the drives that failed.

See below.

[...]
> Also show "mdadm -E" for all of the member devices.  This data is an
> absolute *must* before any major surgery on an array.

also below.

>> My first attempt would be to try
>> mdadm --create --metadata=0.9 --chunk=64 --assume-clean, etc.
>> 
>> Is there a chance for this to succeed? Or do you have better suggestions?
> 
> "--create" is a *terrible* first step.  "mdadm --assemble --force" is
> the right tool for this job.

I forgot to mention: I tried that, and stopped it, after I saw the first
thing it did was to start a rebuild of the array. I couldn't figure out
which disk it was trying to rebuild, but whichever of the two dropped out
disks it was, I can't see how it could reconstruct the data once it reaches
the point of the errors on the disk it uses in the reconstruction.
(So "first" above should really say more verbose "first after the new copies
are finished".)
mdadm --assemble --assume-clean sounded like the most logical combination of
options, but was rejected.

Unfortunately, the data on the disk is not simply a filesystem where bad
blocks mean a few unreadable files, but a filesystem with a number of files
on it that represent a volume exported by iSCSI, on which there is an
encrypted partition with a filesystem. So I'm not too sure, if any of these
indirections badly multiplies the effect of a single bad sector, and I'm
trying to reach 100% good, if possible.

>> If all recovery that involves assembling the array fails: Is is possible
>> to manually assemble the data?
>> I'm thinking in the direction of: take the first 64k from disk1, then 64k
>> from disk2, etc.? This would probably take years to complete, but the data
>> is of really big importance to me (which is why I put it on a RAID in the
>> first place...).
> 
> Your scenario sounds like the common timeout mismatch catastrophe, which
> is why I asked for "smartctl -x".  If that is the case, MD won't be able
> to do the reconstructions that it should when encounting read errors.

You mean the "timeout of the disk is longer than RAID's patience" problem?
I have no idea, if the old disks suffered from it, I used Samsung HD204UI
which were certified by QNAP. The copies are now WD NAS edition disks,
which have a lower timeout.

> Also, you have a poor understanding of MD's use--it is *not* a backup
> alternative.  It is a tool for maximizing *uptime*.  It will keep you
> running through the normal random failures that complex
> electro-mechanical systems experience.
> 
> MD won't save your data from accidental deletion or other operator
> error.  It won't save your data from a lightning strike.  It won't save
> your data from a home or office fire.  You still need to make backups.

I'm all too aware of that, and we also tryied to keep a "manual RAID" by
copying to a number of USB disks stored at a different location to survive a
burnt-down house. However, this event uncovered a bad oversight on our
side in that process. We simply missed some data under certain circumstances
(the "I-thought-you-did-it" bug in human interaction). So out of the ~800GB
on the RAID, for some +/-20GB, this is the only remaining copy.
Recently, I also started copying all data to Amazon Glacier, for 100%-epsilon
reliable storage, but this upload simply took longer than the disks lasted
(=less than 30 days spinning! very disappointing).

Regards,
Michael


All the disk data: disk 1 and 3 failed:
(I installed the patch for the firmware bug from December 2012.)

Disk1:
======
/dev/sdc3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : f5ad617a:14ccd4b1:3d7a38e4:71465fe8
  Creation Time : Fri Nov 26 19:58:40 2010
     Raid Level : raid5
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 5855836800 (5584.56 GiB 5996.38 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Fri Jan  4 15:11:07 2013
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 7496591c - correct
         Events : 25

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        3        0      active sync

   0     0       8        3        0      active sync
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync


Disk2:
======
/dev/sdb3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : f5ad617a:14ccd4b1:3d7a38e4:71465fe8
  Creation Time : Fri Nov 26 19:58:40 2010
     Raid Level : raid5
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 5855836800 (5584.56 GiB 5996.38 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Fri Jan  4 16:33:36 2013
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 74966e44 - correct
         Events : 237

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       19        1      active sync   /dev/sdb3

   0     0       0        0        0      removed
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       0        0        2      faulty removed
   3     3       8       51        3      active sync


Disk3:
======
/dev/sdb3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : f5ad617a:14ccd4b1:3d7a38e4:71465fe8
  Creation Time : Fri Nov 26 19:58:40 2010
     Raid Level : raid5
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 5855836800 (5584.56 GiB 5996.38 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Fri Jan  4 16:32:27 2013
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 74966e04 - correct
         Events : 236

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       35        2      active sync   /dev/sdc3

   0     0       0        0        0      removed
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync


Disk4:
======
/dev/sdc3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : f5ad617a:14ccd4b1:3d7a38e4:71465fe8
  Creation Time : Fri Nov 26 19:58:40 2010
     Raid Level : raid5
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 5855836800 (5584.56 GiB 5996.38 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Fri Jan  4 16:33:36 2013
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 74966e68 - correct
         Events : 237

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       51        3      active sync

   0     0       0        0        0      removed
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       0        0        2      faulty removed
   3     3       8       51        3      active sync


Disk1:
======
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-4-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint F4 EG (AFT)
Device Model:     SAMSUNG HD204UI
Serial Number:    S2H7J1BZA16176
LU WWN Device Id: 5 0024e9 004358105
Firmware Version: 1AQ10001
User Capacity:    2.000.398.934.016 bytes [2,00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 6
Local Time is:    Fri Feb  1 20:33:54 2013 CET

==> WARNING: Using smartmontools or hdparm with this
drive may result in data loss due to a firmware bug.
****** THIS DRIVE MAY OR MAY NOT BE AFFECTED! ******
Buggy and fixed firmware report same version number!
See the following web pages for details:
http://www.samsung.com/global/business/hdd/faqView.do?b2b_bbs_msg_id=386
http://sourceforge.net/apps/trac/smartmontools/wiki/SamsungF4EGBadBlocks

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      ( 119)	The previous self-test completed having
					the read element of the test failed.
Total time to complete Offline 
data collection: 		(20640) seconds.
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
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
SCT capabilities: 	       (0x003f)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   100   100   051    -    1121
  2 Throughput_Performance  -OS--K   252   252   000    -    0
  3 Spin_Up_Time            PO---K   066   065   025    -    10415
  4 Start_Stop_Count        -O--CK   099   099   000    -    1123
  5 Reallocated_Sector_Ct   PO--CK   252   252   010    -    0
  7 Seek_Error_Rate         -OSR-K   252   252   051    -    0
  8 Seek_Time_Performance   --S--K   252   252   015    -    0
  9 Power_On_Hours          -O--CK   100   100   000    -    717
 10 Spin_Retry_Count        -O--CK   252   252   051    -    0
 11 Calibration_Retry_Count -O--CK   252   252   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    120
181 Program_Fail_Cnt_Total  -O---K   100   100   000    -    903
191 G-Sense_Error_Rate      -O---K   100   100   000    -    3
192 Power-Off_Retract_Count -O---K   252   252   000    -    0
194 Temperature_Celsius     -O----   064   064   000    -    17 (Min/Max 14/33)
195 Hardware_ECC_Recovered  -O-RCK   100   100   000    -    0
196 Reallocated_Event_Count -O--CK   252   252   000    -    0
197 Current_Pending_Sector  -O--CK   100   100   000    -    30
198 Offline_Uncorrectable   ----CK   252   252   000    -    0
199 UDMA_CRC_Error_Count    -OS-CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   -O-R-K   100   100   000    -    0
223 Load_Retry_Count        -O--CK   252   252   000    -    0
225 Load_Cycle_Count        -O--CK   100   100   000    -    1124
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
GP    Log at address 0x03 has    2 sectors [Ext. Comprehensive SMART error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    2 sectors [Extended self-test log]
GP    Log at address 0x08 has    2 sectors [Power Conditions]
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
Device Error Count: 1005 (device log contains only the most recent 8 errors)
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

Error 1005 [4] occurred at disk power-on lifetime: 716 hours (29 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 13 a4 a7 88 e0 00  Error: UNC 8 sectors at LBA = 0x13a4a788 = 329557896

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 13 a4 a7 88 e0 00     00:01:16.277  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.277  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:01:16.277  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:01:16.277  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.277  READ NATIVE MAX ADDRESS EXT

Error 1004 [3] occurred at disk power-on lifetime: 716 hours (29 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 13 a4 a7 88 e0 00  Error: UNC 8 sectors at LBA = 0x13a4a788 = 329557896

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 13 a4 a7 88 e0 00     00:01:16.271  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.271  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:01:16.271  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:01:16.271  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.271  READ NATIVE MAX ADDRESS EXT

Error 1003 [2] occurred at disk power-on lifetime: 716 hours (29 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 13 a4 a7 88 e0 00  Error: UNC 8 sectors at LBA = 0x13a4a788 = 329557896

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 13 a4 a7 88 e0 00     00:01:16.266  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.266  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:01:16.266  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:01:16.266  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.266  READ NATIVE MAX ADDRESS EXT

Error 1002 [1] occurred at disk power-on lifetime: 716 hours (29 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 13 a4 a7 88 e0 00  Error: UNC 8 sectors at LBA = 0x13a4a788 = 329557896

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 13 a4 a7 88 e0 00     00:01:16.261  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.261  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:01:16.261  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:01:16.261  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.261  READ NATIVE MAX ADDRESS EXT

Error 1001 [0] occurred at disk power-on lifetime: 716 hours (29 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 13 a4 a7 88 e0 00  Error: UNC 8 sectors at LBA = 0x13a4a788 = 329557896

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 13 a4 a7 88 e0 00     00:01:16.256  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.256  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:01:16.256  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:01:16.256  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.256  READ NATIVE MAX ADDRESS EXT

Error 1000 [7] occurred at disk power-on lifetime: 716 hours (29 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 13 a4 a7 88 e0 00  Error: UNC 8 sectors at LBA = 0x13a4a788 = 329557896

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 13 a4 a7 88 e0 00     00:01:16.251  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.251  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:01:16.251  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:01:16.251  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.251  READ NATIVE MAX ADDRESS EXT

Error 999 [6] occurred at disk power-on lifetime: 716 hours (29 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 13 a4 a7 88 e0 00  Error: UNC 8 sectors at LBA = 0x13a4a788 = 329557896

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 13 a4 a7 88 e0 00     00:01:16.246  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.246  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:01:16.246  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:01:16.246  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.246  READ NATIVE MAX ADDRESS EXT

Error 998 [5] occurred at disk power-on lifetime: 716 hours (29 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 13 a4 a7 88 e0 00  Error: UNC 8 sectors at LBA = 0x13a4a788 = 329557896

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 13 a4 a7 88 e0 00     00:01:16.241  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.241  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:01:16.241  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:01:16.241  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:01:16.241  READ NATIVE MAX ADDRESS EXT

SMART Extended Self-test Log Version: 1 (2 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed: read failure       70%       698         327170640
# 2  Extended offline    Completed: read failure       90%       693         327170208
# 3  Short offline       Completed: read failure       10%       692         327170648

Note: selective self-test log revision number (0) not 1 implies that no selective self-test has ever been run
SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has ever been run
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Completed_read_failure [70% left] (0-65535)
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
Current Temperature:                    17 Celsius
Power Cycle Min/Max Temperature:     16/17 Celsius
Lifetime    Min/Max Temperature:     14/67 Celsius
Lifetime    Average Temperature:        80 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         5 minutes
Temperature Logging Interval:        5 minutes
Min/Max recommended Temperature:     -5/80 Celsius
Min/Max Temperature Limit:           -10/85 Celsius
Temperature History Size (Index):    128 (104)

Index    Estimated Time   Temperature Celsius
 105    2013-02-01 09:55    17  -
 106    2013-02-01 10:00    29  **********
 107    2013-02-01 10:05    28  *********
 ...    ..( 15 skipped).    ..  *********
 123    2013-02-01 11:25    28  *********
 124    2013-02-01 11:30    29  **********
 125    2013-02-01 11:35    28  *********
 ...    ..(  9 skipped).    ..  *********
   7    2013-02-01 12:25    28  *********
   8    2013-02-01 12:30    29  **********
 ...    ..(  9 skipped).    ..  **********
  18    2013-02-01 13:20    29  **********
  19    2013-02-01 13:25    28  *********
  20    2013-02-01 13:30    29  **********
 ...    ..(  6 skipped).    ..  **********
  27    2013-02-01 14:05    29  **********
  28    2013-02-01 14:10    28  *********
  29    2013-02-01 14:15    29  **********
  30    2013-02-01 14:20    28  *********
  31    2013-02-01 14:25    28  *********
  32    2013-02-01 14:30    28  *********
  33    2013-02-01 14:35    29  **********
  34    2013-02-01 14:40    28  *********
 ...    ..(  9 skipped).    ..  *********
  44    2013-02-01 15:30    28  *********
  45    2013-02-01 15:35    29  **********
  46    2013-02-01 15:40    28  *********
 ...    ..(  7 skipped).    ..  *********
  54    2013-02-01 16:20    28  *********
  55    2013-02-01 16:25    29  **********
  56    2013-02-01 16:30    28  *********
  57    2013-02-01 16:35    29  **********
  58    2013-02-01 16:40    28  *********
  59    2013-02-01 16:45    28  *********
  60    2013-02-01 16:50    27  ********
  61    2013-02-01 16:55    28  *********
  62    2013-02-01 17:00    29  **********
  63    2013-02-01 17:05    28  *********
 ...    ..( 13 skipped).    ..  *********
  77    2013-02-01 18:15    28  *********
  78    2013-02-01 18:20    29  **********
  79    2013-02-01 18:25    28  *********
 ...    ..( 14 skipped).    ..  *********
  94    2013-02-01 19:40    28  *********
  95    2013-02-01 19:45    27  ********
  96    2013-02-01 19:50    28  *********
  97    2013-02-01 19:55    28  *********
  98    2013-02-01 20:00    27  ********
 ...    ..(  5 skipped).    ..  ********
 104    2013-02-01 20:30    27  ********

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

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
0x0009  4            7  Transition from drive PhyRdy to drive PhyNRdy
0x000a  4            0  Device-to-host register FISes sent due to a COMRESET
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


Disk2:
======
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-4-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint F4 EG (AFT)
Device Model:     SAMSUNG HD204UI
Serial Number:    S2H7J1BZA16132
LU WWN Device Id: 5 0024e9 004357e94
Firmware Version: 1AQ10001
User Capacity:    2.000.398.934.016 bytes [2,00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 6
Local Time is:    Fri Feb  1 20:28:32 2013 CET

==> WARNING: Using smartmontools or hdparm with this
drive may result in data loss due to a firmware bug.
****** THIS DRIVE MAY OR MAY NOT BE AFFECTED! ******
Buggy and fixed firmware report same version number!
See the following web pages for details:
http://www.samsung.com/global/business/hdd/faqView.do?b2b_bbs_msg_id=386
http://sourceforge.net/apps/trac/smartmontools/wiki/SamsungF4EGBadBlocks

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		(20760) seconds.
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
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
SCT capabilities: 	       (0x003f)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   100   100   051    -    0
  2 Throughput_Performance  -OS--K   252   252   000    -    0
  3 Spin_Up_Time            PO---K   067   066   025    -    10206
  4 Start_Stop_Count        -O--CK   099   099   000    -    1124
  5 Reallocated_Sector_Ct   PO--CK   252   252   010    -    0
  7 Seek_Error_Rate         -OSR-K   252   252   051    -    0
  8 Seek_Time_Performance   --S--K   252   252   015    -    0
  9 Power_On_Hours          -O--CK   100   100   000    -    709
 10 Spin_Retry_Count        -O--CK   252   252   051    -    0
 11 Calibration_Retry_Count -O--CK   252   252   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    128
181 Program_Fail_Cnt_Total  -O---K   100   100   000    -    925
191 G-Sense_Error_Rate      -O---K   252   252   000    -    0
192 Power-Off_Retract_Count -O---K   252   252   000    -    0
194 Temperature_Celsius     -O----   064   064   000    -    21 (Min/Max 14/35)
195 Hardware_ECC_Recovered  -O-RCK   100   100   000    -    0
196 Reallocated_Event_Count -O--CK   252   252   000    -    0
197 Current_Pending_Sector  -O--CK   252   252   000    -    0
198 Offline_Uncorrectable   ----CK   252   252   000    -    0
199 UDMA_CRC_Error_Count    -OS-CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   -O-R-K   100   100   000    -    0
223 Load_Retry_Count        -O--CK   252   252   000    -    0
225 Load_Cycle_Count        -O--CK   100   100   000    -    1126
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
GP    Log at address 0x03 has    2 sectors [Ext. Comprehensive SMART error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    2 sectors [Extended self-test log]
GP    Log at address 0x08 has    2 sectors [Power Conditions]
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
No Errors Logged

SMART Extended Self-test Log Version: 1 (2 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%       697         -

Note: selective self-test log revision number (0) not 1 implies that no selective self-test has ever been run
SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has ever been run
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
Current Temperature:                    21 Celsius
Power Cycle Min/Max Temperature:     20/21 Celsius
Lifetime    Min/Max Temperature:     14/62 Celsius
Lifetime    Average Temperature:        80 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         5 minutes
Temperature Logging Interval:        5 minutes
Min/Max recommended Temperature:     -5/80 Celsius
Min/Max Temperature Limit:           -10/85 Celsius
Temperature History Size (Index):    128 (2)

Index    Estimated Time   Temperature Celsius
   3    2013-02-01 09:50    21  **
   4    2013-02-01 09:55    26  *******
   5    2013-02-01 10:00    24  *****
   6    2013-02-01 10:05    24  *****
   7    2013-02-01 10:10    25  ******
   8    2013-02-01 10:15    25  ******
   9    2013-02-01 10:20    18  -
  10    2013-02-01 10:25    19  -
  11    2013-02-01 10:30    21  **
  12    2013-02-01 10:35    22  ***
  13    2013-02-01 10:40    23  ****
  14    2013-02-01 10:45    24  *****
  15    2013-02-01 10:50    24  *****
  16    2013-02-01 10:55    25  ******
  17    2013-02-01 11:00    25  ******
  18    2013-02-01 11:05    26  *******
  19    2013-02-01 11:10    26  *******
  20    2013-02-01 11:15    26  *******
  21    2013-02-01 11:20    27  ********
  22    2013-02-01 11:25    26  *******
  23    2013-02-01 11:30    27  ********
 ...    ..(  4 skipped).    ..  ********
  28    2013-02-01 11:55    27  ********
  29    2013-02-01 12:00    28  *********
  30    2013-02-01 12:05    27  ********
  31    2013-02-01 12:10    27  ********
  32    2013-02-01 12:15    18  -
  33    2013-02-01 12:20    19  -
  34    2013-02-01 12:25    20  *
  35    2013-02-01 12:30    22  ***
  36    2013-02-01 12:35    23  ****
  37    2013-02-01 12:40    18  -
  38    2013-02-01 12:45    19  -
  39    2013-02-01 12:50    21  **
  40    2013-02-01 12:55    22  ***
  41    2013-02-01 13:00    24  *****
  42    2013-02-01 13:05    24  *****
  43    2013-02-01 13:10    24  *****
  44    2013-02-01 13:15    25  ******
  45    2013-02-01 13:20    25  ******
  46    2013-02-01 13:25    26  *******
  47    2013-02-01 13:30    26  *******
  48    2013-02-01 13:35    19  -
  49    2013-02-01 13:40    22  ***
  50    2013-02-01 13:45    24  *****
  51    2013-02-01 13:50    26  *******
  52    2013-02-01 13:55    27  ********
  53    2013-02-01 14:00    29  **********
  54    2013-02-01 14:05    30  ***********
  55    2013-02-01 14:10    31  ************
  56    2013-02-01 14:15    31  ************
  57    2013-02-01 14:20    32  *************
  58    2013-02-01 14:25    32  *************
  59    2013-02-01 14:30    32  *************
  60    2013-02-01 14:35    33  **************
 ...    ..(  2 skipped).    ..  **************
  63    2013-02-01 14:50    33  **************
  64    2013-02-01 14:55    32  *************
  65    2013-02-01 15:00    33  **************
  66    2013-02-01 15:05    33  **************
  67    2013-02-01 15:10    34  ***************
  68    2013-02-01 15:15    33  **************
  69    2013-02-01 15:20    34  ***************
  70    2013-02-01 15:25    34  ***************
  71    2013-02-01 15:30    33  **************
  72    2013-02-01 15:35    33  **************
  73    2013-02-01 15:40    34  ***************
 ...    ..( 46 skipped).    ..  ***************
 120    2013-02-01 19:35    34  ***************
 121    2013-02-01 19:40    33  **************
 122    2013-02-01 19:45    33  **************
 123    2013-02-01 19:50    35  ****************
 124    2013-02-01 19:55    34  ***************
 125    2013-02-01 20:00    34  ***************
 126    2013-02-01 20:05    33  **************
 ...    ..(  3 skipped).    ..  **************
   2    2013-02-01 20:25    33  **************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

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
0x0009  4            3  Transition from drive PhyRdy to drive PhyNRdy
0x000a  4            0  Device-to-host register FISes sent due to a COMRESET
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


Disk 3:
=======
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-4-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint F4 EG (AFT)
Device Model:     SAMSUNG HD204UI
Serial Number:    S2H7J1BZA16147
LU WWN Device Id: 5 0024e9 004357edb
Firmware Version: 1AQ10001
User Capacity:    2.000.398.934.016 bytes [2,00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 6
Local Time is:    Fri Feb  1 20:33:49 2013 CET

==> WARNING: Using smartmontools or hdparm with this
drive may result in data loss due to a firmware bug.
****** THIS DRIVE MAY OR MAY NOT BE AFFECTED! ******
Buggy and fixed firmware report same version number!
See the following web pages for details:
http://www.samsung.com/global/business/hdd/faqView.do?b2b_bbs_msg_id=386
http://sourceforge.net/apps/trac/smartmontools/wiki/SamsungF4EGBadBlocks

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      ( 116)	The previous self-test completed having
					the read element of the test failed.
Total time to complete Offline 
data collection: 		(21000) seconds.
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
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
SCT capabilities: 	       (0x003f)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   100   100   051    -    29439
  2 Throughput_Performance  -OS--K   252   252   000    -    0
  3 Spin_Up_Time            PO---K   067   066   025    -    10221
  4 Start_Stop_Count        -O--CK   099   099   000    -    1130
  5 Reallocated_Sector_Ct   PO--CK   252   252   010    -    0
  7 Seek_Error_Rate         -OSR-K   252   252   051    -    0
  8 Seek_Time_Performance   --S--K   252   252   015    -    0
  9 Power_On_Hours          -O--CK   100   100   000    -    766
 10 Spin_Retry_Count        -O--CK   252   252   051    -    0
 11 Calibration_Retry_Count -O--CK   252   252   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    133
181 Program_Fail_Cnt_Total  -O---K   100   100   000    -    919
191 G-Sense_Error_Rate      -O---K   252   252   000    -    0
192 Power-Off_Retract_Count -O---K   252   252   000    -    0
194 Temperature_Celsius     -O----   064   064   000    -    18 (Min/Max 14/35)
195 Hardware_ECC_Recovered  -O-RCK   100   100   000    -    0
196 Reallocated_Event_Count -O--CK   252   252   000    -    0
197 Current_Pending_Sector  -O--CK   081   081   000    -    2350
198 Offline_Uncorrectable   ----CK   252   100   000    -    0
199 UDMA_CRC_Error_Count    -OS-CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   -O-R-K   100   100   000    -    0
223 Load_Retry_Count        -O--CK   252   252   000    -    0
225 Load_Cycle_Count        -O--CK   100   100   000    -    1132
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
GP    Log at address 0x03 has    2 sectors [Ext. Comprehensive SMART error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    2 sectors [Extended self-test log]
GP    Log at address 0x08 has    2 sectors [Power Conditions]
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
Device Error Count: 21341 (device log contains only the most recent 8 errors)
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

Error 21341 [4] occurred at disk power-on lifetime: 766 hours (31 days + 22 hours)
  When the command that caused the error occurred, the device was in a vendor specific state.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 2c 88 72 70 e0 00  Error: UNC 8 sectors at LBA = 0x2c887270 = 747139696

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 2c 88 72 70 e0 00     00:00:50.113  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.113  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:00:50.113  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:00:50.113  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.113  READ NATIVE MAX ADDRESS EXT

Error 21340 [3] occurred at disk power-on lifetime: 766 hours (31 days + 22 hours)
  When the command that caused the error occurred, the device was in a vendor specific state.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 2c 88 72 70 e0 00  Error: UNC 8 sectors at LBA = 0x2c887270 = 747139696

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 2c 88 72 70 e0 00     00:00:50.108  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.108  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:00:50.108  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:00:50.108  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.108  READ NATIVE MAX ADDRESS EXT

Error 21339 [2] occurred at disk power-on lifetime: 766 hours (31 days + 22 hours)
  When the command that caused the error occurred, the device was in a vendor specific state.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 2c 88 72 70 e0 00  Error: UNC 8 sectors at LBA = 0x2c887270 = 747139696

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 2c 88 72 70 e0 00     00:00:50.103  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.103  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:00:50.103  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:00:50.103  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.103  READ NATIVE MAX ADDRESS EXT

Error 21338 [1] occurred at disk power-on lifetime: 766 hours (31 days + 22 hours)
  When the command that caused the error occurred, the device was in a vendor specific state.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 2c 88 72 70 e0 00  Error: UNC 8 sectors at LBA = 0x2c887270 = 747139696

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 2c 88 72 70 e0 00     00:00:50.098  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.098  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:00:50.098  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:00:50.098  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.098  READ NATIVE MAX ADDRESS EXT

Error 21337 [0] occurred at disk power-on lifetime: 766 hours (31 days + 22 hours)
  When the command that caused the error occurred, the device was in a vendor specific state.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 2c 88 72 70 e0 00  Error: UNC 8 sectors at LBA = 0x2c887270 = 747139696

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 2c 88 72 70 e0 00     00:00:50.093  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.093  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:00:50.093  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:00:50.093  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.093  READ NATIVE MAX ADDRESS EXT

Error 21336 [7] occurred at disk power-on lifetime: 766 hours (31 days + 22 hours)
  When the command that caused the error occurred, the device was in a vendor specific state.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 2c 88 72 70 e0 00  Error: UNC 8 sectors at LBA = 0x2c887270 = 747139696

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 2c 88 72 70 e0 00     00:00:50.087  READ DMA EXT
  25 00 00 00 08 00 00 2c 88 72 78 e0 00     00:00:50.087  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.087  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:00:50.087  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:00:50.087  SET FEATURES [Set transfer mode]

Error 21335 [6] occurred at disk power-on lifetime: 766 hours (31 days + 22 hours)
  When the command that caused the error occurred, the device was in a vendor specific state.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 2c 88 72 b8 e0 00  Error: UNC 8 sectors at LBA = 0x2c8872b8 = 747139768

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 2c 88 72 b8 e0 00     00:00:50.082  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.082  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:00:50.082  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:00:50.082  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.082  READ NATIVE MAX ADDRESS EXT

Error 21334 [5] occurred at disk power-on lifetime: 766 hours (31 days + 22 hours)
  When the command that caused the error occurred, the device was in a vendor specific state.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 08 00 00 2c 88 72 b8 e0 00  Error: UNC 8 sectors at LBA = 0x2c8872b8 = 747139768

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
  25 00 00 00 08 00 00 2c 88 72 b8 e0 00     00:00:50.077  READ DMA EXT
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.077  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 00     00:00:50.077  IDENTIFY DEVICE
  ef 00 03 00 42 00 00 00 00 00 00 a0 00     00:00:50.077  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 00 00 00 00 e0 00     00:00:50.077  READ NATIVE MAX ADDRESS EXT

SMART Extended Self-test Log Version: 1 (2 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed: read failure       40%       766         329136144
# 2  Short offline       Completed: read failure       10%       745         717909280
# 3  Short offline       Completed: read failure       70%       714         327191864
# 4  Extended offline    Completed: read failure       90%       695         329136144
# 5  Short offline       Completed: read failure       80%       695         724561192

Note: selective self-test log revision number (0) not 1 implies that no selective self-test has ever been run
SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has ever been run
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Completed_read_failure [40% left] (0-65535)
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
Current Temperature:                    17 Celsius
Power Cycle Min/Max Temperature:     15/17 Celsius
Lifetime    Min/Max Temperature:     13/67 Celsius
Lifetime    Average Temperature:        80 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         5 minutes
Temperature Logging Interval:        5 minutes
Min/Max recommended Temperature:     -5/80 Celsius
Min/Max Temperature Limit:           -10/85 Celsius
Temperature History Size (Index):    128 (5)

Index    Estimated Time   Temperature Celsius
   6    2013-02-01 09:55    17  -
   7    2013-02-01 10:00    27  ********
 ...    ..( 24 skipped).    ..  ********
  32    2013-02-01 12:05    27  ********
  33    2013-02-01 12:10    26  *******
  34    2013-02-01 12:15    27  ********
 ...    ..( 29 skipped).    ..  ********
  64    2013-02-01 14:45    27  ********
  65    2013-02-01 14:50    28  *********
  66    2013-02-01 14:55    27  ********
 ...    ..( 22 skipped).    ..  ********
  89    2013-02-01 16:50    27  ********
  90    2013-02-01 16:55    26  *******
  91    2013-02-01 17:00    27  ********
 ...    ..(  5 skipped).    ..  ********
  97    2013-02-01 17:30    27  ********
  98    2013-02-01 17:35    26  *******
  99    2013-02-01 17:40    26  *******
 100    2013-02-01 17:45    27  ********
 101    2013-02-01 17:50    26  *******
 102    2013-02-01 17:55    27  ********
 103    2013-02-01 18:00    26  *******
 ...    ..(  6 skipped).    ..  *******
 110    2013-02-01 18:35    26  *******
 111    2013-02-01 18:40    27  ********
 112    2013-02-01 18:45    27  ********
 113    2013-02-01 18:50    26  *******
 114    2013-02-01 18:55    26  *******
 115    2013-02-01 19:00    27  ********
 ...    ..(  2 skipped).    ..  ********
 118    2013-02-01 19:15    27  ********
 119    2013-02-01 19:20    26  *******
 120    2013-02-01 19:25    26  *******
 121    2013-02-01 19:30    27  ********
 122    2013-02-01 19:35    26  *******
 123    2013-02-01 19:40    27  ********
 124    2013-02-01 19:45    27  ********
 125    2013-02-01 19:50    26  *******
 ...    ..(  3 skipped).    ..  *******
   1    2013-02-01 20:10    26  *******
   2    2013-02-01 20:15    27  ********
   3    2013-02-01 20:20    27  ********
   4    2013-02-01 20:25    26  *******
   5    2013-02-01 20:30    26  *******

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

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
0x0009  4            9  Transition from drive PhyRdy to drive PhyNRdy
0x000a  4            1  Device-to-host register FISes sent due to a COMRESET
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


Disk 4:
=======
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-4-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint F4 EG (AFT)
Device Model:     SAMSUNG HD204UI
Serial Number:    S2H7J1BZA16596
LU WWN Device Id: 5 0024e9 00435a3ba
Firmware Version: 1AQ10001
User Capacity:    2.000.398.934.016 bytes [2,00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 6
Local Time is:    Fri Feb  1 20:30:17 2013 CET

==> WARNING: Using smartmontools or hdparm with this
drive may result in data loss due to a firmware bug.
****** THIS DRIVE MAY OR MAY NOT BE AFFECTED! ******
Buggy and fixed firmware report same version number!
See the following web pages for details:
http://www.samsung.com/global/business/hdd/faqView.do?b2b_bbs_msg_id=386
http://sourceforge.net/apps/trac/smartmontools/wiki/SamsungF4EGBadBlocks

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		(20820) seconds.
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
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
SCT capabilities: 	       (0x003f)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   100   100   051    -    1
  2 Throughput_Performance  -OS--K   252   252   000    -    0
  3 Spin_Up_Time            PO---K   067   060   025    -    10215
  4 Start_Stop_Count        -O--CK   099   099   000    -    1134
  5 Reallocated_Sector_Ct   PO--CK   252   252   010    -    0
  7 Seek_Error_Rate         -OSR-K   252   252   051    -    0
  8 Seek_Time_Performance   --S--K   252   252   015    -    0
  9 Power_On_Hours          -O--CK   100   100   000    -    722
 10 Spin_Retry_Count        -O--CK   252   252   051    -    0
 11 Calibration_Retry_Count -O--CK   252   252   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    144
181 Program_Fail_Cnt_Total  -O---K   100   100   000    -    926
191 G-Sense_Error_Rate      -O---K   100   100   000    -    3
192 Power-Off_Retract_Count -O---K   252   252   000    -    0
194 Temperature_Celsius     -O----   064   063   000    -    21 (Min/Max 14/37)
195 Hardware_ECC_Recovered  -O-RCK   100   100   000    -    0
196 Reallocated_Event_Count -O--CK   252   252   000    -    0
197 Current_Pending_Sector  -O--CK   252   252   000    -    0
198 Offline_Uncorrectable   ----CK   252   252   000    -    0
199 UDMA_CRC_Error_Count    -OS-CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   -O-R-K   100   100   000    -    0
223 Load_Retry_Count        -O--CK   252   252   000    -    0
225 Load_Cycle_Count        -O--CK   100   100   000    -    1147
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
GP    Log at address 0x03 has    2 sectors [Ext. Comprehensive SMART error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    2 sectors [Extended self-test log]
GP    Log at address 0x08 has    2 sectors [Power Conditions]
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
No Errors Logged

SMART Extended Self-test Log Version: 1 (2 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%       717         -
# 2  Short offline       Completed without error       00%       707         -
# 3  Short offline       Completed without error       00%       693         -

Note: selective self-test log revision number (0) not 1 implies that no selective self-test has ever been run
SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has ever been run
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
Current Temperature:                    21 Celsius
Power Cycle Min/Max Temperature:     20/22 Celsius
Lifetime    Min/Max Temperature:     13/65 Celsius
Lifetime    Average Temperature:        80 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         5 minutes
Temperature Logging Interval:        5 minutes
Min/Max recommended Temperature:     -5/80 Celsius
Min/Max Temperature Limit:           -10/85 Celsius
Temperature History Size (Index):    128 (108)

Index    Estimated Time   Temperature Celsius
 109    2013-02-01 09:55    22  ***
 110    2013-02-01 10:00    31  ************
 ...    ..(  4 skipped).    ..  ************
 115    2013-02-01 10:25    31  ************
 116    2013-02-01 10:30    30  ***********
 117    2013-02-01 10:35    31  ************
 ...    ..( 52 skipped).    ..  ************
  42    2013-02-01 15:00    31  ************
  43    2013-02-01 15:05    26  *******
  44    2013-02-01 15:10    28  *********
  45    2013-02-01 15:15    30  ***********
  46    2013-02-01 15:20    31  ************
  47    2013-02-01 15:25    32  *************
  48    2013-02-01 15:30    33  **************
  49    2013-02-01 15:35    34  ***************
  50    2013-02-01 15:40    35  ****************
  51    2013-02-01 15:45    35  ****************
  52    2013-02-01 15:50    37  ******************
  53    2013-02-01 15:55    36  *****************
 ...    ..(  9 skipped).    ..  *****************
  63    2013-02-01 16:45    36  *****************
  64    2013-02-01 16:50    35  ****************
  65    2013-02-01 16:55    36  *****************
 ...    ..(  4 skipped).    ..  *****************
  70    2013-02-01 17:20    36  *****************
  71    2013-02-01 17:25    37  ******************
  72    2013-02-01 17:30    36  *****************
 ...    ..( 11 skipped).    ..  *****************
  84    2013-02-01 18:30    36  *****************
  85    2013-02-01 18:35    37  ******************
  86    2013-02-01 18:40    36  *****************
  87    2013-02-01 18:45    36  *****************
  88    2013-02-01 18:50    37  ******************
  89    2013-02-01 18:55    36  *****************
  90    2013-02-01 19:00    36  *****************
  91    2013-02-01 19:05    36  *****************
  92    2013-02-01 19:10    37  ******************
  93    2013-02-01 19:15    36  *****************
  94    2013-02-01 19:20    36  *****************
  95    2013-02-01 19:25    35  ****************
 ...    ..( 11 skipped).    ..  ****************
 107    2013-02-01 20:25    35  ****************
 108    2013-02-01 20:30    21  **

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

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
0x0009  4            3  Transition from drive PhyRdy to drive PhyNRdy
0x000a  4            0  Device-to-host register FISes sent due to a COMRESET
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



