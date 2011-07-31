From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Do I have a bad HDD?
Date: Sun, 31 Jul 2011 14:05:44 +0100
Message-ID: <CADNH=7HDCwtUr-HSN7fH_GSH8jTYb-SAwmKY0ZRn3opWAhKiBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi list,

Here's the output of my weekly script:

DEV	EVENTS	REALL	PEND	UNCORR	CRC	RAW	ZONE	END
sdb1	6158767	0	0	0	2	0	0	
sdc1	6158767	0	0	0	0	0	0	
sdd1	6158767	0	0	0	0	0	0	
sde1	6158767	0	0	0	0	0	1	
sdf1	6158767	0	0	0	0	47	6	
sdg1	6158767	0	0	0	0	0	0	
sdh1	6158767	0	6	0	0	340	3	


Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdf1[5] sdh1[6] sdg1[0] sde1[7] sdc1[3] sdd1[4] sdb1[1]
      9751756800 blocks super 1.2 level 6, 64k chunk, algorithm 2
[7/7] [UUUUUUU]

unused devices: <none>


/dev/md0:
        Version : 1.2
  Creation Time : Tue Oct 19 08:58:41 2010
     Raid Level : raid6
     Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
  Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
   Raid Devices : 7
  Total Devices : 7
    Persistence : Superblock is persistent

    Update Time : Sun Jul 31 09:50:43 2011
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : ion:0  (local to host ion)
           UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
         Events : 6158767

    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       1       8       17        1      active sync   /dev/sdb1
       4       8       49        2      active sync   /dev/sdd1
       3       8       33        3      active sync   /dev/sdc1
       5       8       81        4      active sync   /dev/sdf1
       6       8      113        5      active sync   /dev/sdh1
       7       8       65        6      active sync   /dev/sde1

Here's the SMART data for sdh:


smartctl 5.41 2011-06-09 r3365 [x86_64-linux-2.6.39-ck] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint F4 EG (AFT)
Device Model:     SAMSUNG HD204UI
Serial Number:    S2HGJ1RZ800850
LU WWN Device Id: 5 0024e9 003f1ebc9
Firmware Version: 1AQ10003
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 6
Local Time is:    Sun Jul 31 14:03:32 2011 IST

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
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (  37)	The self-test routine was interrupted
					by the host with a hard or soft reset.
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
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   100   100   051    Pre-fail
Always       -       340
  2 Throughput_Performance  0x0026   055   053   000    Old_age
Always       -       18989
  3 Spin_Up_Time            0x0023   067   044   025    Pre-fail
Always       -       10165
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       18
  5 Reallocated_Sector_Ct   0x0033   252   252   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   252   252   051    Old_age
Always       -       0
  8 Seek_Time_Performance   0x0024   252   252   015    Old_age
Offline      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       6447
 10 Spin_Retry_Count        0x0032   252   252   051    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   252   252   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       20
181 Program_Fail_Cnt_Total  0x0022   100   100   000    Old_age
Always       -       10117271
191 G-Sense_Error_Rate      0x0022   100   100   000    Old_age
Always       -       1
192 Power-Off_Retract_Count 0x0022   252   252   000    Old_age
Always       -       0
194 Temperature_Celsius     0x0002   064   057   000    Old_age
Always       -       35 (Min/Max 16/43)
195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age
Always       -       0
196 Reallocated_Event_Count 0x0032   252   252   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   100   100   000    Old_age
Always       -       6
198 Offline_Uncorrectable   0x0030   252   252   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0036   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x002a   100   100   000    Old_age
Always       -       3
223 Load_Retry_Count        0x0032   252   252   000    Old_age
Always       -       0
225 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       21

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Interrupted (host reset)      50%      6408         -
# 2  Extended offline    Completed without error       00%      6317         -
# 3  Extended offline    Completed without error       00%      6260         -
# 4  Extended offline    Completed without error       00%      6232         -
# 5  Extended offline    Completed without error       00%      6170         -
# 6  Extended offline    Completed without error       00%      6064         -
# 7  Extended offline    Completed without error       00%      6029         -
# 8  Extended offline    Completed without error       00%      5898         -
# 9  Extended offline    Aborted by host               60%      5893         -
#10  Extended offline    Completed without error       00%      5728         -
#11  Extended offline    Completed without error       00%      5706         -
#12  Extended offline    Interrupted (host reset)      40%      5701         -
#13  Extended offline    Interrupted (host reset)      90%      5666         -
#14  Extended offline    Completed without error       00%      5560         -
#15  Extended offline    Completed without error       00%      5527         -
#16  Extended offline    Completed without error       00%      5392         -
#17  Extended offline    Completed without error       00%      5357         -
#18  Extended offline    Completed without error       00%      5250         -
#19  Extended offline    Completed without error       00%      4272         -
#20  Extended offline    Completed without error       00%      4017         -
#21  Extended offline    Completed without error       00%      3935         -

Note: selective self-test log revision number (0) not 1 implies that
no selective self-test has ever been run
SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has
ever been run
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Interrupted [50% left] (0-65535)
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.


It has 6 pending sectors. Why are they not reallocated? Can I force
this somehow? (a scrub did not reallocate them) Is this enough to
replace the HDD?

Thanks,
Mathias
