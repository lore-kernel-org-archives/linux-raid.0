From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Uneven wear on raid1 devices
Date: Mon, 25 Jan 2016 16:29:02 +1100
Message-ID: <56A5B29E.3020708@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I was hoping to get some advice on why my two SSD's seem to be wearing 
unevenly, when they are both in the same raid1 array.

First, the array information:
# mdadm --misc --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Fri Jun 14 00:42:04 2013
      Raid Level : raid1
      Array Size : 499975360 (476.81 GiB 511.97 GB)
   Used Dev Size : 499975360 (476.81 GiB 511.97 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Mon Jan 25 16:20:11 2016
           State : active
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : flail:0  (local to host flail)
            UUID : 81b25e43:787b0bc4:f934d006:a726aa89
          Events : 1240606

     Number   Major   Minor   RaidDevice State
        2       8       17        0      active sync   /dev/sdb1
        1       8       49        1      active sync   /dev/sdd1

# smartctl -A /dev/sdb|grep Wear
177 Wear_Leveling_Count     0x0013   093   093   000    Pre-fail 
Always       -       248
# smartctl -A /dev/sdd|grep Wear
177 Wear_Leveling_Count     0x0013   074   074   000    Pre-fail 
Always       -       915

Equally, we can see a different amount of data written to each drive:
# smartctl -A /dev/sdb|grep Written
241 Total_LBAs_Written      0x0032   099   099   000    Old_age 
Always       -       7169916114
# smartctl -A /dev/sdd|grep Written
241 Total_LBAs_Written      0x0032   099   099   000    Old_age 
Always       -       24013780683

I'm stuck wondering why one drive is getting so many more writes than 
the other, and is there some way to "swap" this so that the other drive 
will get the heavier load over the next 12 months?

In theory, this suggests that one drive has 74% life remaining, and the 
other has 93% (unless I'm reading that incorrectly...), while 74% is 
still a lot, I guess I would prefer to prevent it getting too much lower 
and needing replacement....

Any suggestions or advice greatly appreciated.

Full output of smartctl -x below for each drive:

# smartctl -x /dev/sdb
smartctl 5.41 2011-06-09 r3365 [i686-linux-3.2.0-4-686-pae] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     Samsung SSD 840 PRO Series
Serial Number:    S1AXNSAF702689E
LU WWN Device Id: 5 002538 5a02701b8
Firmware Version: DXM06B0Q
User Capacity:    512,110,190,592 bytes [512 GB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4c
Local Time is:    Mon Jan 25 16:28:01 2016 AEDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)    Offline data collection activity
                     was never started.
                     Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)    The previous self-test 
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:         (53956) seconds.
Offline data collection
capabilities:              (0x53) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     No Offline surface scan supported.
                     Self-test supported.
                     No Conveyance Self-test supported.
                     Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      (  35) minutes.
SCT capabilities:            (0x003d)    SCT Status supported.
                     SCT Error Recovery Control supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
   9 Power_On_Hours          -O--CK   098   098   000    -    6435
  12 Power_Cycle_Count       -O--CK   099   099   000    -    1
177 Wear_Leveling_Count     PO--C-   093   093   000    -    248
179 Used_Rsvd_Blk_Cnt_Tot   PO--C-   100   100   010    -    0
181 Program_Fail_Cnt_Total  -O--CK   100   100   010    -    0
182 Erase_Fail_Count_Total  -O--CK   100   100   010    -    0
183 Runtime_Bad_Block       PO--C-   100   100   010    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
190 Airflow_Temperature_Cel -O--CK   072   060   000    -    28
195 Hardware_ECC_Recovered  -O-RC-   200   200   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   100   100   000    -    0
235 Unknown_Attribute       -O--C-   100   100   000    -    0
241 Total_LBAs_Written      -O--CK   099   099   000    - 7169972542
                             ||||||_ K auto-keep
                             |||||__ C event count
                             ||||___ R error rate
                             |||____ S speed/performance
                             ||_____ O updated online
                             |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
GP/S  Log at address 0x01 has    1 sectors [Summary SMART error log]
GP/S  Log at address 0x02 has    1 sectors [Comprehensive SMART error log]
GP/S  Log at address 0x03 has    1 sectors [Ext. Comprehensive SMART 
error log]
GP/S  Log at address 0x06 has    1 sectors [SMART self-test log]
GP/S  Log at address 0x07 has    1 sectors [Extended self-test log]
GP/S  Log at address 0x09 has    1 sectors [Selective self-test log]
GP/S  Log at address 0x10 has    1 sectors [NCQ Command Error]
GP/S  Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP/S  Log at address 0x30 has    1 sectors [Reserved]
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
GP/S  Log at address 0xa0 has   16 sectors [Device vendor specific log]

SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

SMART Selective self-test log data structure revision number 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
   255        0    65535  Read_scanning was never started
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

Error unknown SCT Temperature History Format Version (3), should be 2.
SCT Error Recovery Control:
            Read: Disabled
           Write: Disabled

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2           11  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           11  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0010  2            0  R_ERR response for host-to-device data FIS, non-CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x0013  2            0  R_ERR response for host-to-device non-data FIS, 
non-CRC



# smartctl -x /dev/sdd
smartctl 5.41 2011-06-09 r3365 [i686-linux-3.2.0-4-686-pae] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     Samsung SSD 840 PRO Series
Serial Number:    S12SNEAD204208R
LU WWN Device Id: 5 002538 5501d20d0
Firmware Version: DXM04B0Q
User Capacity:    512,110,190,592 bytes [512 GB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4c
Local Time is:    Mon Jan 25 16:26:24 2016 AEDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)    Offline data collection activity
                     was never started.
                     Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)    The previous self-test 
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:         (53956) seconds.
Offline data collection
capabilities:              (0x53) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     No Offline surface scan supported.
                     Self-test supported.
                     No Conveyance Self-test supported.
                     Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      (  35) minutes.
SCT capabilities:            (0x003d)    SCT Status supported.
                     SCT Error Recovery Control supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
   9 Power_On_Hours          -O--CK   095   095   000    -    23178
  12 Power_Cycle_Count       -O--CK   099   099   000    -    8
177 Wear_Leveling_Count     PO--C-   074   074   000    -    915
179 Used_Rsvd_Blk_Cnt_Tot   PO--C-   100   100   010    -    0
181 Program_Fail_Cnt_Total  -O--CK   100   100   010    -    0
182 Erase_Fail_Count_Total  -O--CK   100   100   010    -    0
183 Runtime_Bad_Block       PO--C-   100   100   010    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
190 Airflow_Temperature_Cel -O--CK   073   058   000    -    27
195 Hardware_ECC_Recovered  -O-RC-   200   200   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   100   100   000    -    0
235 Unknown_Attribute       -O--C-   099   099   000    -    6
241 Total_LBAs_Written      -O--CK   099   099   000    - 24013821507
                             ||||||_ K auto-keep
                             |||||__ C event count
                             ||||___ R error rate
                             |||____ S speed/performance
                             ||_____ O updated online
                             |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
GP/S  Log at address 0x01 has    1 sectors [Summary SMART error log]
GP/S  Log at address 0x02 has    1 sectors [Comprehensive SMART error log]
GP/S  Log at address 0x03 has    1 sectors [Ext. Comprehensive SMART 
error log]
GP/S  Log at address 0x06 has    1 sectors [SMART self-test log]
GP/S  Log at address 0x07 has    1 sectors [Extended self-test log]
GP/S  Log at address 0x09 has    1 sectors [Selective self-test log]
GP/S  Log at address 0x10 has    1 sectors [NCQ Command Error]
GP/S  Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP/S  Log at address 0x30 has    1 sectors [Reserved]
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
GP/S  Log at address 0xa0 has   16 sectors [Device vendor specific log]

SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

SMART Selective self-test log data structure revision number 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
   255        0    65535  Read_scanning was never started
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

Error unknown SCT Temperature History Format Version (3), should be 2.
SCT Error Recovery Control:
            Read: Disabled
           Write: Disabled

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2           11  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           11  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0010  2            0  R_ERR response for host-to-device data FIS, non-CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x0013  2            0  R_ERR response for host-to-device non-data FIS, 
non-CRC




