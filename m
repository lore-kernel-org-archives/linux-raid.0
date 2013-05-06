From: Phil Turmel <philip@turmel.org>
Subject: Re: Failed during rebuild (raid5)
Date: Mon, 06 May 2013 08:36:34 -0400
Message-ID: <5187A3D2.6060109@turmel.org>
References: <51839E4F.7050102@midgaard.us> <CANU9nTneT2CRWJhdN=d87Hb7W9M+apQH+fRE-S+sieZ-W6+hjg@mail.gmail.com> <51866602.8000704@midgaard.us> <518693EF.6090802@midgaard.us> <518721CD.2040108@turmel.org> <51878BD0.9010809@midgaard.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51878BD0.9010809@midgaard.us>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Boman <aboman@midgaard.us>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Andreas,

You dropped the list.  Please don't do that.  I added it back, and left
the end of the mail untrimmed so the list can see it.

On 05/06/2013 06:54 AM, Andreas Boman wrote:
> On 05/05/2013 11:21 PM, Phil Turmel wrote:
>> Hi Andreas,
>>
>> On 05/05/2013 01:16 PM, Andreas Boman wrote:
>>
>> [trim /]
>>
>>> Turns out the superblocks are there. I ran --examine on the disk instead
>>> of partition. OOps.
>>
>> Please share the "--examine" reports for your array, and "smartctl -x"
>> for each disk, and anything from dmesg/syslog that relates to your array
>> or errors on its members.  (Your original post did say you would be able
>> to get log info.)
> 
> The --examine for the array (as it is now) and smartctl -x for the
> failed disk are at the end of this mail.
> 
> I pasted some log snippets here:  http://pastebin.com/iqnYje1W
> This should be the interesting part:
> 
> May  2 15:50:14 yggdrasil kernel: [    7.247383] md: md127 stopped.
> May  2 15:50:14 yggdrasil kernel: [    7.794697] raid5: allocated 5334kB
> for md127
> May  2 15:50:14 yggdrasil kernel: [    7.794843] md127: detected
> capacity change from 0 to 6001196793856
> May  2 15:50:14 yggdrasil kernel: [    7.796294]  md127: unknown
> partition table
> May  2 15:54:36 yggdrasil kernel: [  287.180692] md: recovery of RAID
> array md127
> May  2 22:40:26 yggdrasil kernel: [24637.888695] raid5:md127: read error
> not correctable (sector 884472576 on sda1).

Current versions of MD raid in the kernel allow multiple read errors per
hour before kicking out a drive.  What kernel and mdadm versions are
involved here?

> Disk was sda at the time, sdb now don't ask why it reorders at times, I
> don't know. Sometimes the on board boot disk is sda, sometimes it is the
> last disk it seems.

You need to document the device names vs. drive S/Ns so you don't mess
up any "--create" operations.  This is one of the reasons "--create
--assume-clean" is so dangerous.

I recommend my own "lsdrv" @ github.com/pturmel.  But an excerpt from
"ls -l /dev/disk/by-id/" will do.

Use of LABEL= and UUID= syntax in fstab and during boot is intended to
mitigate the fact that the kernel cannot guarantee the order it finds
devices during boot.

> I tried to jump ddrescue to the end of the drive to ensure I get the md
> superblock and then live with some lost data after file system repair.
> 
> ./ddrescue -f -d -n -i1499889899520 /dev/sdb /dev/sdf /root/rescue.log
> 
> ^that is what i did (i tried to go further and further). These completed
> every time with no error. Also no superblock copied.

You have a v0.90 array.  The superblock is within 128k of the end of the
partition.

> I'm guessing its some kind of user error that prevents me from copying
> that superblock.

Yes, something destroyed it.

> I'm still trying to determine if bringing the array up (--assemble
> --force) using this disk with the missing data will be just bad or very
> bad? I've been told that mdadm doesn't care, but what will it do when
> data is missing in a chunk on this disk?

Presuming you mean while using the ddrescued copy, then any bad data
will show up in the array's files.  There's no help for that.

>>> After that is done I'll try to get the array up with 4 disks, then add
>>> the spare and have it rebuild. After that I'll add a disk to go to
>>> raid 6.
>>
>> It may be wiser to get it running degraded and take a backup, but that
>> remains to be seen.  You haven't shown that you know why the first
>> rebuild failed.  Until that is understood and addressed, you probably
>> won't succeed in rebuilding onto a spare.

You only shared one "smartctl -x" report.  Please show the others.  If
the others show pending sectors, you will have more difficulty after
rescuing sdb.  (You will need to use ddrescue on the other drives that
show pending sectors.)

/dev/sdb has six pending sectors--unrecoverable read errors that won't
be resolved until those sectors are rewritten.  They might be normal
transient errors that'll be fine after rewrite.  Or they might be
unwritable, and the drive will have to re-allocate them.  You need
regular "check" scrubs in a non-degraded array to catch these early and
fix them.

Since ddrescue is struggling with this disk starting at 884471083, close
to the point where MD kicked it, you might have a large damage area that
can't be rewritten.

> I have been wondering about that, it would be difficult to do (not to
> mention I'd have to buy a bunch of large disks to backup to), but I have
> (am) considered it.

Be careful selecting drives.  The Samsung drive has ERC--you really want
to pick drives that have it.

If I understand correctly, your current plan is to ddrescue sdb, then
assemble degraded (with --force).  I agree with this plan, and I think
you should not need to use "--create --assume-clean".  You will need to
fsck the filesystem before you mount, and accept that some data will be
lost.  Be sure to remove sdb from the system after you've duplicated it,
as two drives with identical metadata will cause problems for MD.

Phil

> 
> Thanks,
> Andreas
> 
> 
> ---------------------metadata
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 60b8d5d0:00c342d3:59cb281a:834c72d9
>   Creation Time : Sun Oct  3 06:23:33 2010
>      Raid Level : raid5
>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 127
> 
>     Update Time : Thu May  2 22:15:22 2013
>           State : clean
>  Active Devices : 4
> Working Devices : 5
>  Failed Devices : 1
>   Spare Devices : 1
>        Checksum : dd5e9120 - correct
>          Events : 1011948
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     2       8        1        2      active sync   /dev/sda1
> 
>    0     0       8       33        0      active sync   /dev/sdc1
>    1     1       0        0        1      faulty removed
>    2     2       8        1        2      active sync   /dev/sda1
>    3     3       8       49        3      active sync   /dev/sdd1
>    4     4       8       65        4      active sync   /dev/sde1
>    5     5       8       17        5      spare   /dev/sdb1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 60b8d5d0:00c342d3:59cb281a:834c72d9
>   Creation Time : Sun Oct  3 06:23:33 2010
>      Raid Level : raid5
>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 127
> 
>     Update Time : Fri May  3 05:31:49 2013
>           State : clean
>  Active Devices : 3
> Working Devices : 4
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : dd5ef826 - correct
>          Events : 1012026
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     5       8       17        5      spare   /dev/sdb1
> 
>    0     0       8       33        0      active sync   /dev/sdc1
>    1     1       0        0        1      faulty removed
>    2     2       0        0        2      faulty removed
>    3     3       8       49        3      active sync   /dev/sdd1
>    4     4       8       65        4      active sync   /dev/sde1
>    5     5       8       17        5      spare   /dev/sdb1
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 60b8d5d0:00c342d3:59cb281a:834c72d9
>   Creation Time : Sun Oct  3 06:23:33 2010
>      Raid Level : raid5
>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 127
> 
>     Update Time : Fri May  3 05:31:49 2013
>           State : clean
>  Active Devices : 3
> Working Devices : 4
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : dd5ef832 - correct
>          Events : 1012026
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     0       8       33        0      active sync   /dev/sdc1
> 
>    0     0       8       33        0      active sync   /dev/sdc1
>    1     1       0        0        1      faulty removed
>    2     2       0        0        2      faulty removed
>    3     3       8       49        3      active sync   /dev/sdd1
>    4     4       8       65        4      active sync   /dev/sde1
>    5     5       8       17        5      spare   /dev/sdb1
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 60b8d5d0:00c342d3:59cb281a:834c72d9
>   Creation Time : Sun Oct  3 06:23:33 2010
>      Raid Level : raid5
>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 127
> 
>     Update Time : Fri May  3 05:31:49 2013
>           State : clean
>  Active Devices : 3
> Working Devices : 4
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : dd5ef848 - correct
>          Events : 1012026
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     3       8       49        3      active sync   /dev/sdd1
> 
>    0     0       8       33        0      active sync   /dev/sdc1
>    1     1       0        0        1      faulty removed
>    2     2       0        0        2      faulty removed
>    3     3       8       49        3      active sync   /dev/sdd1
>    4     4       8       65        4      active sync   /dev/sde1
>    5     5       8       17        5      spare   /dev/sdb1
> /dev/sdg1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 60b8d5d0:00c342d3:59cb281a:834c72d9
>   Creation Time : Sun Oct  3 06:23:33 2010
>      Raid Level : raid5
>   Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 127
> 
>     Update Time : Fri May  3 05:31:49 2013
>           State : clean
>  Active Devices : 3
> Working Devices : 4
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : dd5ef85a - correct
>          Events : 1012026
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     4       8       65        4      active sync   /dev/sde1
> 
>    0     0       8       33        0      active sync   /dev/sdc1
>    1     1       0        0        1      faulty removed
>    2     2       0        0        2      faulty removed
>    3     3       8       49        3      active sync   /dev/sdd1
>    4     4       8       65        4      active sync   /dev/sde1
>    5     5       8       17        5      spare   /dev/sdb1
> 
> 
> 
> ---------------------smartctl -x
> 
> 
>  smartctl -x /dev/sdb
> smartctl 5.40 2010-07-12 r3124 [x86_64-unknown-linux-gnu] (local build)
> Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net
> 
> === START OF INFORMATION SECTION ===
> Model Family:     SAMSUNG SpinPoint F2 EG series
> Device Model:     SAMSUNG HD154UI
> Serial Number:    S1Y6J1LZ100168
> Firmware Version: 1AG01118
> User Capacity:    1,500,301,910,016 bytes
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   8
> ATA Standard is:  ATA-8-ACS revision 3b
> Local Time is:    Mon May  6 05:41:26 2013 EDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> 
> General SMART Values:
> Offline data collection status:  (0x00)    Offline data collection activity
>                     was never started.
>                     Auto Offline Data Collection: Disabled.
> Self-test execution status:      ( 114)    The previous self-test
> completed having
>                     the read element of the test failed.
> Total time to complete Offline
> data collection:          (19591) seconds.
> Offline data collection
> capabilities:              (0x7b) SMART execute Offline immediate.
>                     Auto Offline data collection on/off support.
>                     Suspend Offline collection upon new
>                     command.
>                     Offline surface scan supported.
>                     Self-test supported.
>                     Conveyance Self-test supported.
>                     Selective Self-test supported.
> SMART capabilities:            (0x0003)    Saves SMART data before entering
>                     power-saving mode.
>                     Supports SMART auto save timer.
> Error logging capability:        (0x01)    Error logging supported.
>                     General Purpose Logging supported.
> Short self-test routine
> recommended polling time:      (   2) minutes.
> Extended self-test routine
> recommended polling time:      ( 255) minutes.
> Conveyance self-test routine
> recommended polling time:      (  34) minutes.
> SCT capabilities:            (0x003f)    SCT Status supported.
>                     SCT Error Recovery Control supported.
>                     SCT Feature Control supported.
>                     SCT Data Table supported.
> 
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE     
> UPDATED  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail 
> Always       -       17
>   3 Spin_Up_Time            0x0007   063   063   011    Pre-fail 
> Always       -       11770
>   4 Start_Stop_Count        0x0032   100   100   000    Old_age  
> Always       -       155
>   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
> Always       -       0
>   7 Seek_Error_Rate         0x000f   253   253   051    Pre-fail 
> Always       -       0
>   8 Seek_Time_Performance   0x0025   100   097   015    Pre-fail 
> Offline      -       14926
>   9 Power_On_Hours          0x0032   100   100   000    Old_age  
> Always       -       378
>  10 Spin_Retry_Count        0x0033   100   100   051    Pre-fail 
> Always       -       0
>  11 Calibration_Retry_Count 0x0012   100   100   000    Old_age  
> Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age  
> Always       -       67
>  13 Read_Soft_Error_Rate    0x000e   100   100   000    Old_age  
> Always       -       17
> 183 Runtime_Bad_Block       0x0032   100   100   000    Old_age  
> Always       -       1
> 184 End-to-End_Error        0x0033   100   100   000    Pre-fail 
> Always       -       0
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age  
> Always       -       18
> 188 Command_Timeout         0x0032   100   100   000    Old_age  
> Always       -       0
> 190 Airflow_Temperature_Cel 0x0022   075   068   000    Old_age  
> Always       -       25 (Lifetime Min/Max 17/32)
> 194 Temperature_Celsius     0x0022   075   066   000    Old_age  
> Always       -       25 (Lifetime Min/Max 17/34)
> 195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age  
> Always       -       463200379
> 196 Reallocated_Event_Count 0x0032   100   100   000    Old_age  
> Always       -       0
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age  
> Always       -       6
> 198 Offline_Uncorrectable   0x0030   100   100   000    Old_age  
> Offline      -       1
> 199 UDMA_CRC_Error_Count    0x003e   100   100   000    Old_age  
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x000a   100   100   000    Old_age  
> Always       -       0
> 201 Soft_Read_Error_Rate    0x000a   100   100   000    Old_age  
> Always       -       0
> 
> General Purpose Logging (GPL) feature set supported
> General Purpose Log Directory Version 1
> SMART           Log Directory Version 1 [multi-sector log support]
> GP/S  Log at address 0x00 has    1 sectors [Log Directory]
> SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
> SMART Log at address 0x02 has    2 sectors [Comprehensive SMART error log]
> GP    Log at address 0x03 has    2 sectors [Ext. Comprehensive SMART
> error log]
> GP    Log at address 0x04 has    2 sectors [Device Statistics]
> SMART Log at address 0x06 has    1 sectors [SMART self-test log]
> GP    Log at address 0x07 has    2 sectors [Extended self-test log]
> SMART Log at address 0x09 has    1 sectors [Selective self-test log]
> GP    Log at address 0x10 has    1 sectors [NCQ Command Error]
> GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
> GP    Log at address 0x20 has    2 sectors [Streaming performance log]
> GP    Log at address 0x21 has    1 sectors [Write stream error log]
> GP    Log at address 0x22 has    1 sectors [Read stream error log]
> GP/S  Log at address 0x80 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x81 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x82 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x83 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x84 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x85 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x86 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x87 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x88 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x89 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x8a has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x8b has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x8c has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x8d has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x8e has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x8f has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x90 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x91 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x92 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x93 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x94 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x95 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x96 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x97 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x98 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x99 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x9a has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x9b has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x9c has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x9d has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x9e has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x9f has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
> GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]
> 
> SMART Extended Comprehensive Error Log Version: 1 (2 sectors)
> Device Error Count: 6
>     CR     = Command Register
>     FEATR  = Features Register
>     COUNT  = Count (was: Sector Count) Register
>     LBA_48 = Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
>     LH     = LBA High (was: Cylinder High) Register    ]   LBA
>     LM     = LBA Mid (was: Cylinder Low) Register      ] Register
>     LL     = LBA Low (was: Sector Number) Register     ]
>     DV     = Device (was: Device/Head) Register
>     DC     = Device Control Register
>     ER     = Error register
>     ST     = Status register
> Powered_Up_Time is measured from power on, and printed as
> DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
> SS=sec, and sss=millisec. It "wraps" after 49.710 days.
> 
> Error 6 [5] occurred at disk power-on lifetime: 329 hours (13 days + 17
> hours)
>   When the command that caused the error occurred, the device was active
> or idle.
> 
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   00 -- 42 00 00 00 00 34 b7 f5 34 40 00
> 
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
> Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  --------------- 
> --------------------
>   60 00 08 01 00 00 00 00 b7 f4 3f 40 00     06:51:19.350  READ FPDMA
> QUEUED
>   60 00 00 01 00 00 00 00 b7 f5 3f 40 00     06:51:19.350  READ FPDMA
> QUEUED
>   60 00 08 01 00 00 00 00 b7 f7 3f 40 00     06:51:19.350  READ FPDMA
> QUEUED
>   60 00 70 01 00 00 00 00 b7 f6 3f 40 00     06:51:19.350  READ FPDMA
> QUEUED
>   60 00 08 01 00 00 00 00 b7 f8 3f 40 00     06:51:19.350  READ FPDMA
> QUEUED
> 
> Error 5 [4] occurred at disk power-on lifetime: 329 hours (13 days + 17
> hours)
>   When the command that caused the error occurred, the device was active
> or idle.
> 
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   00 -- 42 00 00 00 00 34 b7 f5 35 40 00
> 
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
> Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  --------------- 
> --------------------
>   60 00 08 01 00 00 00 00 b7 fb 3f 40 00     06:51:13.030  READ FPDMA
> QUEUED
>   60 00 00 01 00 00 00 00 b7 fa 3f 40 00     06:51:13.030  READ FPDMA
> QUEUED
>   60 00 08 00 e8 00 00 00 b7 f9 57 40 00     06:51:13.030  READ FPDMA
> QUEUED
>   60 00 70 00 18 00 00 00 b7 f9 3f 40 00     06:51:13.030  READ FPDMA
> QUEUED
>   60 00 08 01 00 00 00 00 b7 f8 3f 40 00     06:51:13.030  READ FPDMA
> QUEUED
> 
> Error 4 [3] occurred at disk power-on lifetime: 329 hours (13 days + 17
> hours)
>   When the command that caused the error occurred, the device was active
> or idle.
> 
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   00 -- 42 00 00 00 00 34 b7 f5 33 40 00
> 
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
> Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  --------------- 
> --------------------
>   60 00 08 01 00 00 00 00 b7 f4 3f 40 00     06:51:08.060  READ FPDMA
> QUEUED
>   60 00 00 01 00 00 00 00 b7 f5 3f 40 00     06:51:08.060  READ FPDMA
> QUEUED
>   60 00 08 01 00 00 00 00 b7 f7 3f 40 00     06:51:08.060  READ FPDMA
> QUEUED
>   60 00 70 01 00 00 00 00 b7 f6 3f 40 00     06:51:08.060  READ FPDMA
> QUEUED
>   60 00 08 01 00 00 00 00 b7 f8 3f 40 00     06:51:08.060  READ FPDMA
> QUEUED
> 
> Error 3 [2] occurred at disk power-on lifetime: 329 hours (13 days + 17
> hours)
>   When the command that caused the error occurred, the device was active
> or idle.
> 
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   00 -- 42 00 00 00 00 34 b7 f5 31 40 00
> 
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
> Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  --------------- 
> --------------------
>   60 00 08 01 00 00 00 00 b7 fb 3f 40 00     06:51:03.650  READ FPDMA
> QUEUED
>   60 00 00 01 00 00 00 00 b7 fa 3f 40 00     06:51:03.650  READ FPDMA
> QUEUED
>   60 00 08 00 e8 00 00 00 b7 f9 57 40 00     06:51:03.650  READ FPDMA
> QUEUED
>   60 00 70 00 18 00 00 00 b7 f9 3f 40 00     06:51:03.650  READ FPDMA
> QUEUED
>   60 00 08 01 00 00 00 00 b7 f8 3f 40 00     06:51:03.650  READ FPDMA
> QUEUED
> 
> Error 2 [1] occurred at disk power-on lifetime: 329 hours (13 days + 17
> hours)
>   When the command that caused the error occurred, the device was active
> or idle.
> 
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   00 -- 42 00 00 00 00 34 b7 f5 34 40 00
> 
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
> Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  --------------- 
> --------------------
>   60 00 08 01 00 00 00 00 b7 f4 3f 40 00     06:50:58.240  READ FPDMA
> QUEUED
>   60 00 00 01 00 00 00 00 b7 f5 3f 40 00     06:50:58.240  READ FPDMA
> QUEUED
>   60 00 08 01 00 00 00 00 b7 f7 3f 40 00     06:50:58.240  READ FPDMA
> QUEUED
>   60 00 70 01 00 00 00 00 b7 f6 3f 40 00     06:50:58.240  READ FPDMA
> QUEUED
>   60 00 08 01 00 00 00 00 b7 f8 3f 40 00     06:50:58.240  READ FPDMA
> QUEUED
> 
> Error 1 [0] occurred at disk power-on lifetime: 329 hours (13 days + 17
> hours)
>   When the command that caused the error occurred, the device was active
> or idle.
> 
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   00 -- 42 00 00 00 00 34 b7 f5 2f 40 00
> 
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
> Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  --------------- 
> --------------------
>   60 00 00 01 00 00 00 00 b7 f4 3f 40 00     06:50:53.300  READ FPDMA
> QUEUED
>   60 00 08 01 00 00 00 00 b7 f3 3f 40 00     06:50:53.280  READ FPDMA
> QUEUED
>   60 00 00 01 00 00 00 00 b7 f2 3f 40 00     06:50:53.280  READ FPDMA
> QUEUED
>   60 00 08 00 e8 00 00 00 b7 f1 57 40 00     06:50:53.280  READ FPDMA
> QUEUED
>   60 00 00 00 18 00 00 00 b7 f1 3f 40 00     06:50:53.270  READ FPDMA
> QUEUED
> 
> SMART Extended Self-test Log Version: 1 (2 sectors)
> Num  Test_Description    Status                  Remaining 
> LifeTime(hours)  LBA_of_first_error
> # 1  Short offline       Completed: read failure       20%      
> 375         884471093
> # 2  Short offline       Completed: read failure       20%      
> 351         884471083
> # 3  Extended offline    Completed: read failure       90%      
> 337         884471094
> # 4  Short offline       Completed: read failure       20%      
> 333         884471093
> # 5  Short offline       Completed without error       00%      
> 309         -
> # 6  Short offline       Completed without error       00%      
> 285         -
> # 7  Short offline       Completed without error       00%      
> 261         -
> # 8  Short offline       Completed without error       00%      
> 237         -
> # 9  Short offline       Completed without error       00%      
> 213         -
> #10  Extended offline    Completed: read failure       60%      
> 203         884471093
> #11  Short offline       Completed without error       00%      
> 190         -
> #12  Short offline       Completed without error       00%      
> 166         -
> #13  Short offline       Completed without error       00%      
> 142         -
> #14  Short offline       Completed without error       00%      
> 118         -
> #15  Short offline       Completed without error       00%       
> 94         -
> #16  Short offline       Completed without error       00%       
> 70         -
> 
> SMART Selective self-test log data structure revision number 1
>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>     1        0        0  Not_testing
>     2        0        0  Not_testing
>     3        0        0  Not_testing
>     4        0        0  Not_testing
>     5        0        0  Not_testing
> Selective self-test flags (0x0):
>   After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute delay.
> 
> SCT Status Version:                  2
> SCT Version (vendor specific):       256 (0x0100)
> SCT Support Level:                   1
> Device State:                        Active (0)
> Current Temperature:                 25 Celsius
> Power Cycle Max Temperature:         34 Celsius
> Lifetime    Max Temperature:         40 Celsius
> SCT Temperature History Version:     2
> Temperature Sampling Period:         1 minute
> Temperature Logging Interval:        1 minute
> Min/Max recommended Temperature:     -4/72 Celsius
> Min/Max Temperature Limit:           -9/77 Celsius
> Temperature History Size (Index):    128 (113)
> 
> Index    Estimated Time   Temperature Celsius
>  114    2013-05-06 03:34    26  *******
>  115    2013-05-06 03:35    25  ******
>  116    2013-05-06 03:36    26  *******
>  ...    ..(  3 skipped).    ..  *******
>  120    2013-05-06 03:40    26  *******
>  121    2013-05-06 03:41    25  ******
>  122    2013-05-06 03:42    25  ******
>  123    2013-05-06 03:43    26  *******
>  124    2013-05-06 03:44    25  ******
>  ...    ..(  4 skipped).    ..  ******
>    1    2013-05-06 03:49    25  ******
>    2    2013-05-06 03:50    26  *******
>    3    2013-05-06 03:51    26  *******
>    4    2013-05-06 03:52    25  ******
>    5    2013-05-06 03:53    25  ******
>    6    2013-05-06 03:54    25  ******
>    7    2013-05-06 03:55    26  *******
>  ...    ..(  2 skipped).    ..  *******
>   10    2013-05-06 03:58    26  *******
>   11    2013-05-06 03:59    25  ******
>   12    2013-05-06 04:00    26  *******
>   13    2013-05-06 04:01    25  ******
>   14    2013-05-06 04:02    25  ******
>   15    2013-05-06 04:03    26  *******
>   16    2013-05-06 04:04    25  ******
>  ...    ..(  4 skipped).    ..  ******
>   21    2013-05-06 04:09    25  ******
>   22    2013-05-06 04:10    26  *******
>   23    2013-05-06 04:11    25  ******
>  ...    ..( 89 skipped).    ..  ******
>  113    2013-05-06 05:41    25  ******
> 
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)
> 
> SATA Phy Event Counters (GP Log 0x11)
> ID      Size     Value  Description
> 0x000a  2            7  Device-to-host register FISes sent due to a
> COMRESET
> 0x0001  2            0  Command failed due to ICRC error
> 0x0002  2            0  R_ERR response for data FIS
> 0x0003  2            0  R_ERR response for device-to-host data FIS
> 0x0004  2            0  R_ERR response for host-to-device data FIS
> 0x0005  2            0  R_ERR response for non-data FIS
> 0x0006  2            0  R_ERR response for device-to-host non-data FIS
> 0x0007  2            0  R_ERR response for host-to-device non-data FIS
> 0x0008  2            0  Device-to-host non-data FIS retries
> 0x0009  2            7  Transition from drive PhyRdy to drive PhyNRdy
> 0x000b  2            0  CRC errors within host-to-device FIS
> 0x000d  2            0  Non-CRC errors within host-to-device FIS
> 0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
> 0x0010  2            0  R_ERR response for host-to-device data FIS, non-CRC
> 0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
> 0x0013  2            0  R_ERR response for host-to-device non-data FIS,
> non-CRC
> 
> 
> 
> 

