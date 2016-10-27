From: Alexander Shenkin <al@shenkin.org>
Subject: recovering failed raid5
Date: Thu, 27 Oct 2016 16:06:14 +0100
Message-ID: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

A RAID newbie here - apologies in advance for any bonehead questions.
I have 4 3TB disks that participate in 3 raid arrays.  md2 is failing.
I'm hoping someone here might be able to give me pointers for the
right direction to take to avoid data loss, if possible, and recover
the array.

md2: raid5 mounted on /, via sd[abcd]3
md3: raid10 are swap, via sd[abcd]4
md0: raid1 mounted on /boot, via sd[abcd]1
sd[abcd]2 are used for bios_grub

My sdb was recently reporting problems.  Instead of second guessing
those problems, I just got a new disk, replaced it, and added it to
the arrays.  /dev/md3 synced in the new device just fine.  But md0 and
md2 were showing it as spare (S).  When I tried to remove and re-add
sdb3 to md2, sdc3 started acting up, leading to an error message when
adding to the md2 array:

username@machinename:~$ sudo mdadm --manage /dev/md2 --add /dev/sdb3
sudo: unable to open /var/lib/sudo/username/1: No such file or directory
mdadm: /dev/md2 has failed so using --add cannot work and might destroy
mdadm: data on /dev/sdb3.  You should stop the array and re-assemble it.

Following the wiki
(https://raid.wiki.kernel.org/index.php/Linux_Raid), I've included
relevant information below.  My system has marked / as read-only at
this point, so I'm not able to install lsdrv.

The Event counts in the raid5 array (md2) are all quite similar:
         Events : 53547
         Events : 53539
         Events : 53547

Perhaps that means I can try "mdadm --assemble --force /dev/md2
/dev/sd[acd]3"?  I wanted to check with the experts, however, before
moving forward.

Thanks,
Allie


table of contents:
1) mdadm.conf
2) smartctl (disabled on drives - can enable once back up.  should I?)
3) mdadm --examine
4) cat /proc/mdstat
5) parted
6) dmesg output is available here: http://pastebin.com/YRz2Lxr1

################## mdadm.conf ###############################

root@machinename:/home/username# cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default (built-in), scan all partitions (/proc/partitions) and all
# containers for MD superblocks. alternatively, specify devices to scan,
using
# wildcards if desired.
#DEVICE partitions containers

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR machinename@shenkin.org

# definitions of existing MD arrays
ARRAY /dev/md/0 metadata=1.2 UUID=437e4abb:c7ac46f1:ef8b2976:94921060
name=arrayname:0
   spares=2
ARRAY /dev/md/2 metadata=1.2 UUID=6426779d:5a08badf:9958e59e:2ded49d5
name=arrayname:2
ARRAY /dev/md/3 metadata=1.2 UUID=dd78a43e:92699c27:3dc5489d:91d93bb2
name=arrayname:3

# This file was auto-generated on Sat, 12 Dec 2015 09:37:39 +0000
# by mkconf $Id$


########################## smartctl ##########################

note: SMART only enabled after problems started cropping up.

root@machinename:/home/username# smartctl --xall /dev/sda
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.19.0-39-generic] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST3000DM001-9YN166
Serial Number:    Z1F13FBA
LU WWN Device Id: 5 000c50 04e444ab1
Firmware Version: CC4B
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Oct 26 11:14:12 2016 BST

==> WARNING: A firmware update for this drive may be available,
see the following Seagate web pages:
http://knowledge.seagate.com/articles/en_US/FAQ/207931en
http://knowledge.seagate.com/articles/en_US/FAQ/223651en

SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM level is:     254 (maximum performance)
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Write SCT (Get) XXX Error Recovery Control Command failed: scsi error
aborted command
Wt Cache Reorder: N/A

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
data collection:                (  592) seconds.
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
recommended polling time:        ( 335) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x3085) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   114   099   006    -    81641176
  3 Spin_Up_Time            PO----   092   092   000    -    0
  4 Start_Stop_Count        -O--CK   100   100   020    -    32
  5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
  7 Seek_Error_Rate         POSR--   072   060   030    -    17221506
  9 Power_On_Hours          -O--CK   092   092   000    -    7180
 10 Spin_Retry_Count        PO--C-   100   100   097    -    0
 12 Power_Cycle_Count       -O--CK   100   100   020    -    49
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
188 Command_Timeout         -O--CK   100   100   000    -    0 0 0
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   051   049   045    -    49 (Min/Max 48/50)
191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
192 Power-Off_Retract_Count -O--CK   100   100   000    -    43
193 Load_Cycle_Count        -O--CK   100   100   000    -    70
194 Temperature_Celsius     -O---K   049   051   000    -    49 (0 15 0 0 0)
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    - 1783h+53m+16.383s
241 Total_LBAs_Written      ------   100   253   000    -    837415739719
242 Total_LBAs_Read         ------   100   253   000    -    121956855490474
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
0x03       GPL     R/O      5  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa1       GPL,SL  VS      20  Device vendor specific log
0xa2       GPL     VS    4496  Device vendor specific log
0xa8       GPL,SL  VS      20  Device vendor specific log
0xa9       GPL,SL  VS       1  Device vendor specific log
0xab       GPL     VS       1  Device vendor specific log
0xb0       GPL     VS    5067  Device vendor specific log
0xbd       GPL     VS     512  Device vendor specific log
0xbe-0xbf  GPL     VS   65535  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
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
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Data Table command not supported

SCT Error Recovery Control command not supported

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            2  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS

root@machinename:/home/username# smartctl --xall /dev/sdb
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.19.0-39-generic] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST3000DM001-1ER166
Serial Number:    Z502SGLG
LU WWN Device Id: 5 000c50 090cfc6d8
Firmware Version: CC26
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Oct 26 11:14:16 2016 BST

==> WARNING: A firmware update for this drive may be available,
see the following Seagate web pages:
http://knowledge.seagate.com/articles/en_US/FAQ/207931en
http://knowledge.seagate.com/articles/en_US/FAQ/223651en

SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM level is:     254 (maximum performance)
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Write SCT (Get) XXX Error Recovery Control Command failed: scsi error
aborted command
Wt Cache Reorder: N/A

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
data collection:                (   80) seconds.
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
recommended polling time:        ( 318) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x1085) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   100   100   006    -    155392
  3 Spin_Up_Time            PO----   100   100   000    -    0
  4 Start_Stop_Count        -O--CK   100   100   020    -    1
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   100   253   030    -    0
  9 Power_On_Hours          -O--CK   100   100   000    -    50
 10 Spin_Retry_Count        PO--C-   100   100   097    -    0
 12 Power_Cycle_Count       -O--CK   100   100   020    -    1
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
188 Command_Timeout         -O--CK   100   100   000    -    0 0 0
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   050   050   045    -    50 (Min/Max 17/50)
191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
192 Power-Off_Retract_Count -O--CK   100   100   000    -    1
193 Load_Cycle_Count        -O--CK   100   100   000    -    1
194 Temperature_Celsius     -O---K   050   050   000    -    50 (0 17 0 0 0)
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    -    50h+33m+15.470s
241 Total_LBAs_Written      ------   100   253   000    -    15979162
242 Total_LBAs_Read         ------   100   253   000    -    19700
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
0x03       GPL     R/O      5  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa1       GPL,SL  VS      20  Device vendor specific log
0xa2       GPL     VS    4496  Device vendor specific log
0xa8       GPL,SL  VS     129  Device vendor specific log
0xa9       GPL,SL  VS       1  Device vendor specific log
0xab       GPL     VS       1  Device vendor specific log
0xb0       GPL     VS    5176  Device vendor specific log
0xbe-0xbf  GPL     VS   65535  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL,SL  VS      10  Device vendor specific log
0xc3       GPL,SL  VS       8  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
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
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Data Table command not supported

SCT Error Recovery Control command not supported

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            2  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS

root@machinename:/home/username# smartctl --xall /dev/sdc
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.19.0-39-generic] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST3000DM001-1CH166
Serial Number:    W1F1N909
LU WWN Device Id: 5 000c50 05ce3c3a2
Firmware Version: CC24
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Oct 26 11:14:18 2016 BST

==> WARNING: A firmware update for this drive may be available,
see the following Seagate web pages:
http://knowledge.seagate.com/articles/en_US/FAQ/207931en
http://knowledge.seagate.com/articles/en_US/FAQ/223651en

SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM level is:     254 (maximum performance)
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Write SCT (Get) XXX Error Recovery Control Command failed: scsi error
aborted command
Wt Cache Reorder: N/A

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
data collection:                (  592) seconds.
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
recommended polling time:        ( 324) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x3085) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   107   099   006    -    13439162
  3 Spin_Up_Time            PO----   093   093   000    -    0
  4 Start_Stop_Count        -O--CK   100   100   020    -    30
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   060   060   030    -    42962048780
  9 Power_On_Hours          -O--CK   092   092   000    -    7356
 10 Spin_Retry_Count        PO--C-   100   100   097    -    0
 12 Power_Cycle_Count       -O--CK   100   100   020    -    47
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   098   098   000    -    2
188 Command_Timeout         -O--CK   100   100   000    -    0 0 0
189 High_Fly_Writes         -O-RCK   098   098   000    -    2
190 Airflow_Temperature_Cel -O---K   049   049   045    -    51 (Min/Max 47/51)
191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
192 Power-Off_Retract_Count -O--CK   100   100   000    -    42
193 Load_Cycle_Count        -O--CK   100   100   000    -    89
194 Temperature_Celsius     -O---K   051   051   000    -    51 (0 12 0 0 0)
197 Current_Pending_Sector  -O--C-   100   100   000    -    8
198 Offline_Uncorrectable   ----C-   100   100   000    -    8
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    - 1793h+59m+25.776s
241 Total_LBAs_Written      ------   100   253   000    -    5375768743
242 Total_LBAs_Read         ------   100   253   000    -    80575126377
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
0x03       GPL     R/O      5  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa1       GPL,SL  VS      20  Device vendor specific log
0xa2       GPL     VS    4496  Device vendor specific log
0xa8       GPL,SL  VS     129  Device vendor specific log
0xa9       GPL,SL  VS       1  Device vendor specific log
0xab       GPL     VS       1  Device vendor specific log
0xb0       GPL     VS    5176  Device vendor specific log
0xbd       GPL     VS     512  Device vendor specific log
0xbe-0xbf  GPL     VS   65535  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL,SL  VS      10  Device vendor specific log
0xc4       GPL,SL  VS       5  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
Device Error Count: 2
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

Error 2 [1] occurred at disk power-on lifetime: 7306 hours (304 days + 10 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 00 3f ad 38 00 00  Error: UNC at LBA =
0x003fad38 = 4173112

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  --------------- --------------------
  60 00 00 00 38 00 00 00 3f af 30 40 00     00:13:13.200  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 3f ae b0 40 00     00:13:13.200  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 3f ae 30 40 00     00:13:13.200  READ FPDMA QUEUED
  60 00 00 00 80 00 00 00 3f ad b0 40 00     00:13:13.200  READ FPDMA QUEUED
  60 00 00 04 c0 00 00 00 3f b0 00 40 00     00:13:13.200  READ FPDMA QUEUED

Error 1 [0] occurred at disk power-on lifetime: 7306 hours (304 days + 10 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 00 3f ad 38 00 00  Error: UNC at LBA =
0x003fad38 = 4173112

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  --------------- --------------------
  60 00 00 02 a8 00 00 00 3f ac c0 40 00     00:13:09.845  READ FPDMA QUEUED
  60 00 00 04 f0 00 00 00 3f a7 d0 40 00     00:13:09.842  READ FPDMA QUEUED
  60 00 00 00 b8 00 00 00 3f a7 18 40 00     00:13:09.812  READ FPDMA QUEUED
  60 00 00 05 40 00 00 00 3f a1 d8 40 00     00:13:09.812  READ FPDMA QUEUED
  60 00 00 00 08 00 00 00 3f a1 c8 40 00     00:13:09.812  READ FPDMA QUEUED

SMART Extended Self-test Log Version: 1 (1 sectors)
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

SCT Data Table command not supported

SCT Error Recovery Control command not supported

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            2  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS

root@machinename:/home/username# smartctl --xall /dev/sdd
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.19.0-39-generic] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST3000DM001-9YN166
Serial Number:    S1F0HLY4
LU WWN Device Id: 5 000c50 0513b85c1
Firmware Version: CC9F
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Oct 26 11:14:19 2016 BST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM level is:     254 (maximum performance)
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Write SCT (Get) XXX Error Recovery Control Command failed: scsi error
aborted command
Wt Cache Reorder: N/A

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
data collection:                (  575) seconds.
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
recommended polling time:        ( 331) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x3081) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   114   099   006    -    76568208
  3 Spin_Up_Time            PO----   092   092   000    -    0
  4 Start_Stop_Count        -O--CK   100   100   020    -    37
  5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
  7 Seek_Error_Rate         POSR--   071   060   030    -    13538199
  9 Power_On_Hours          -O--CK   092   092   000    -    7083
 10 Spin_Retry_Count        PO--C-   100   100   097    -    0
 12 Power_Cycle_Count       -O--CK   100   100   020    -    54
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   053   053   000    -    47
188 Command_Timeout         -O--CK   100   100   000    -    0 0 0
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   058   058   045    -    42 (Min/Max 41/42)
191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
192 Power-Off_Retract_Count -O--CK   100   100   000    -    45
193 Load_Cycle_Count        -O--CK   100   100   000    -    77
194 Temperature_Celsius     -O---K   042   042   000    -    42 (0 14 0 0 0)
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    - 1775h+53m+38.823s
241 Total_LBAs_Written      ------   100   253   000    -    828557670290
242 Total_LBAs_Read         ------   100   253   000    -    52298143648302
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
0x03       GPL     R/O      5  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa1       GPL,SL  VS      20  Device vendor specific log
0xa2       GPL     VS    4496  Device vendor specific log
0xa8       GPL,SL  VS      20  Device vendor specific log
0xa9       GPL,SL  VS       1  Device vendor specific log
0xab       GPL     VS       1  Device vendor specific log
0xb0       GPL     VS    5067  Device vendor specific log
0xbd       GPL     VS     512  Device vendor specific log
0xbe-0xbf  GPL     VS   65535  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
Device Error Count: 47 (device log contains only the most recent 20 errors)
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

Error 47 [6] occurred at disk power-on lifetime: 4698 hours (195 days
+ 18 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 f4 df c2 c0 00 00  Error: UNC at LBA =
0xf4dfc2c0 = 4108305088

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  --------------- --------------------
  60 00 00 00 08 00 00 cf 15 5c d0 40 00 21d+03:57:37.019  READ FPDMA QUEUED
  61 00 00 00 08 00 00 cd 15 33 d8 40 00 21d+03:57:37.018  WRITE FPDMA QUEUED
  61 00 00 00 08 00 00 cd 15 33 a8 40 00 21d+03:57:37.018  WRITE FPDMA QUEUED
  60 00 00 00 28 00 00 ae 41 4c a0 40 00 21d+03:57:37.018  READ FPDMA QUEUED
  60 00 00 00 20 00 00 f4 df c4 40 40 00 21d+03:57:37.018  READ FPDMA QUEUED

Error 46 [5] occurred at disk power-on lifetime: 4698 hours (195 days
+ 18 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 f4 df c2 c0 00 00  Error: UNC at LBA =
0xf4dfc2c0 = 4108305088

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  --------------- --------------------
  60 00 00 00 80 00 00 f4 df b0 a0 40 00 21d+03:57:33.737  READ FPDMA QUEUED
  61 00 00 00 80 00 00 f4 df b0 a0 40 00 21d+03:57:33.736  WRITE FPDMA QUEUED
  60 00 00 02 38 00 00 f4 df c4 60 40 00 21d+03:57:33.736  READ FPDMA QUEUED
  60 00 00 05 40 00 00 f4 df bf 20 40 00 21d+03:57:33.736  READ FPDMA QUEUED
  61 00 00 00 80 00 00 f4 df b0 a0 40 00 21d+03:57:33.734  WRITE FPDMA QUEUED

Error 45 [4] occurred at disk power-on lifetime: 4698 hours (195 days
+ 18 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 f4 df b0 a0 00 00  Error: UNC at LBA =
0xf4dfb0a0 = 4108300448

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  --------------- --------------------
  60 00 00 03 d0 00 00 f4 df b7 10 40 00 21d+03:57:30.735  READ FPDMA QUEUED
  60 00 00 00 30 00 00 f4 df b4 20 40 00 21d+03:57:30.733  READ FPDMA QUEUED
  60 00 00 00 78 00 00 ae 41 4c 20 40 00 21d+03:57:30.733  READ FPDMA QUEUED
  60 00 00 00 80 00 00 f4 df b3 a0 40 00 21d+03:57:30.732  READ FPDMA QUEUED
  60 00 00 00 80 00 00 f4 df b3 20 40 00 21d+03:57:30.732  READ FPDMA QUEUED

Error 44 [3] occurred at disk power-on lifetime: 4698 hours (195 days
+ 18 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 f4 df b0 a0 00 00  Error: UNC at LBA =
0xf4dfb0a0 = 4108300448

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  --------------- --------------------
  60 00 00 00 a8 00 00 f4 df b4 50 40 00 21d+03:57:27.426  READ FPDMA QUEUED
  61 00 00 00 50 00 00 cd 15 33 88 40 00 21d+03:57:27.403  WRITE FPDMA QUEUED
  60 00 00 02 18 00 00 f4 df ac f8 40 00 21d+03:57:27.388  READ FPDMA QUEUED
  60 00 00 05 40 00 00 f4 df a7 b8 40 00 21d+03:57:27.387  READ FPDMA QUEUED
  60 00 00 00 58 00 00 f4 df 95 68 40 00 21d+03:57:27.384  READ FPDMA QUEUED

Error 43 [2] occurred at disk power-on lifetime: 4698 hours (195 days
+ 18 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 f4 df 95 68 00 00  Error: UNC at LBA =
0xf4df9568 = 4108293480

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  --------------- --------------------
  60 00 00 00 80 00 00 f4 df 91 50 40 00 21d+03:57:24.175  READ FPDMA QUEUED
  61 00 00 00 80 00 00 f4 df 91 50 40 00 21d+03:57:24.175  WRITE FPDMA QUEUED
  60 00 00 01 c0 00 00 f4 df 9e 78 40 00 21d+03:57:24.175  READ FPDMA QUEUED
  60 00 00 05 40 00 00 f4 df 99 38 40 00 21d+03:57:24.174  READ FPDMA QUEUED
  61 00 00 00 80 00 00 f4 df 91 50 40 00 21d+03:57:24.173  WRITE FPDMA QUEUED

Error 42 [1] occurred at disk power-on lifetime: 4698 hours (195 days
+ 18 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 f4 df 95 68 00 00  Error: UNC at LBA =
0xf4df9568 = 4108293480

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  --------------- --------------------
  60 00 00 01 00 00 00 f4 df 94 c0 40 00 21d+03:57:21.120  READ FPDMA QUEUED
  60 00 00 00 80 00 00 f4 df 91 d0 40 00 21d+03:57:21.119  READ FPDMA QUEUED
  60 00 00 00 80 00 00 f4 df 92 50 40 00 21d+03:57:21.119  READ FPDMA QUEUED
  60 00 00 00 80 00 00 f4 df 92 d0 40 00 21d+03:57:21.119  READ FPDMA QUEUED
  60 00 00 00 80 00 00 f4 df 93 50 40 00 21d+03:57:21.119  READ FPDMA QUEUED

Error 41 [0] occurred at disk power-on lifetime: 4698 hours (195 days
+ 18 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 f4 df 91 50 00 00  Error: UNC at LBA =
0xf4df9150 = 4108292432

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  --------------- --------------------
  60 00 00 03 78 00 00 f4 df 95 c0 40 00 21d+03:57:18.237  READ FPDMA QUEUED
  60 00 00 00 70 00 00 f4 df 94 50 40 00 21d+03:57:18.235  READ FPDMA QUEUED
  60 00 00 00 80 00 00 f4 df 93 d0 40 00 21d+03:57:18.235  READ FPDMA QUEUED
  60 00 00 00 80 00 00 f4 df 93 50 40 00 21d+03:57:18.235  READ FPDMA QUEUED
  60 00 00 00 80 00 00 f4 df 92 d0 40 00 21d+03:57:18.235  READ FPDMA QUEUED

Error 40 [19] occurred at disk power-on lifetime: 4698 hours (195 days
+ 18 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- == -- == == == -- -- -- -- --
  40 -- 51 00 00 00 00 f4 df 91 50 00 00  Error: UNC at LBA =
0xf4df9150 = 4108292432

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time Command/Feature_Name
  -- == -- == -- == == == -- -- -- -- --  --------------- --------------------
  60 00 00 00 08 00 00 ca 32 4a 70 40 00 21d+03:57:15.237  READ FPDMA QUEUED
  60 00 00 00 08 00 00 ca 32 4a 40 40 00 21d+03:57:15.237  READ FPDMA QUEUED
  60 00 00 00 20 00 00 ca 31 9e a0 40 00 21d+03:57:15.237  READ FPDMA QUEUED
  60 00 00 01 00 00 00 f4 df 94 c0 40 00 21d+03:57:15.236  READ FPDMA QUEUED
  60 00 00 05 40 00 00 f4 df 8f 80 40 00 21d+03:57:15.236  READ FPDMA QUEUED

SMART Extended Self-test Log Version: 1 (1 sectors)
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

SCT Data Table command not supported

SCT Error Recovery Control command not supported

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            2  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS

root@machinename:/home/username#


################### mdadm --examine ###########################

/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 437e4abb:c7ac46f1:ef8b2976:94921060
           Name : arrayname:0
  Creation Time : Mon Dec  7 08:31:31 2015
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 3901440 (1905.32 MiB 1997.54 MB)
     Array Size : 1950656 (1905.26 MiB 1997.47 MB)
  Used Dev Size : 3901312 (1905.26 MiB 1997.47 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 9cb1890b:ad675b3b:7517467f:0780ec8e

    Update Time : Mon Oct 24 09:19:37 2016
       Checksum : 65eadceb - correct
         Events : 92


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 437e4abb:c7ac46f1:ef8b2976:94921060
           Name : arrayname:0
  Creation Time : Mon Dec  7 08:31:31 2015
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 3901440 (1905.32 MiB 1997.54 MB)
     Array Size : 1950656 (1905.26 MiB 1997.47 MB)
  Used Dev Size : 3901312 (1905.26 MiB 1997.47 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 7acd8648:d34b69f3:f85b524d:dedb6b19

    Update Time : Mon Oct 24 08:53:41 2016
       Checksum : b3817738 - correct
         Events : 91


   Device Role : spare
   Array State : AA ('A' == active, '.' == missing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 437e4abb:c7ac46f1:ef8b2976:94921060
           Name : arrayname:0
  Creation Time : Mon Dec  7 08:31:31 2015
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 3901440 (1905.32 MiB 1997.54 MB)
     Array Size : 1950656 (1905.26 MiB 1997.47 MB)
  Used Dev Size : 3901312 (1905.26 MiB 1997.47 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f162eae5:19f8926b:f5bb6a2a:8adbbefd

    Update Time : Mon Oct 24 08:53:41 2016
       Checksum : 8a7a189d - correct
         Events : 91


   Device Role : spare
   Array State : AA ('A' == active, '.' == missing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 437e4abb:c7ac46f1:ef8b2976:94921060
           Name : arrayname:0
  Creation Time : Mon Dec  7 08:31:31 2015
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 3901440 (1905.32 MiB 1997.54 MB)
     Array Size : 1950656 (1905.26 MiB 1997.47 MB)
  Used Dev Size : 3901312 (1905.26 MiB 1997.47 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 6b10139e:ab5da9d0:665b17ee:daf63719

    Update Time : Mon Oct 24 09:19:37 2016
       Checksum : 86deec80 - correct
         Events : 92


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)
/dev/sda3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6426779d:5a08badf:9958e59e:2ded49d5
           Name : arrayname:2
  Creation Time : Mon Dec  7 08:32:42 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5840377856 (2784.91 GiB 2990.27 GB)
     Array Size : 8760565248 (8354.73 GiB 8970.82 GB)
  Used Dev Size : 5840376832 (2784.91 GiB 2990.27 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c6136963:6c04bbd8:436bda87:2ad19433

    Update Time : Mon Oct 24 09:02:52 2016
       Checksum : 2ec5936f - correct
         Events : 53547

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A..A ('A' == active, '.' == missing)
/dev/sdc3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6426779d:5a08badf:9958e59e:2ded49d5
           Name : arrayname:2
  Creation Time : Mon Dec  7 08:32:42 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5840377856 (2784.91 GiB 2990.27 GB)
     Array Size : 8760565248 (8354.73 GiB 8970.82 GB)
  Used Dev Size : 5840376832 (2784.91 GiB 2990.27 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 657c6955:1cdcfdaf:eb6c2aed:f5a4ed1f

    Update Time : Mon Oct 24 08:53:57 2016
       Checksum : 49afa71b - correct
         Events : 53539

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdd3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6426779d:5a08badf:9958e59e:2ded49d5
           Name : arrayname:2
  Creation Time : Mon Dec  7 08:32:42 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5840377856 (2784.91 GiB 2990.27 GB)
     Array Size : 8760565248 (8354.73 GiB 8970.82 GB)
  Used Dev Size : 5840376832 (2784.91 GiB 2990.27 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 1f7d54bf:e8b8a81e:898d9255:d2683cd7

    Update Time : Mon Oct 24 09:02:52 2016
       Checksum : 41fe73ed - correct
         Events : 53547

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : A..A ('A' == active, '.' == missing)
/dev/sda4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : dd78a43e:92699c27:3dc5489d:91d93bb2
           Name : arrayname:3
  Creation Time : Mon Dec  7 08:33:17 2015
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 15976448 (7.62 GiB 8.18 GB)
     Array Size : 15975424 (15.24 GiB 16.36 GB)
  Used Dev Size : 15975424 (7.62 GiB 8.18 GB)
    Data Offset : 8192 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : cba9cc59:55cccd59:aecb8e98:4de1814a

    Update Time : Mon Oct 24 08:56:30 2016
       Checksum : dbe91e70 - correct
         Events : 75

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdb4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : dd78a43e:92699c27:3dc5489d:91d93bb2
           Name : arrayname:3
  Creation Time : Mon Dec  7 08:33:17 2015
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 15976448 (7.62 GiB 8.18 GB)
     Array Size : 15975424 (15.24 GiB 16.36 GB)
  Used Dev Size : 15975424 (7.62 GiB 8.18 GB)
    Data Offset : 8192 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f3c3c943:303bd216:bb42b1aa:5ac65a19

    Update Time : Mon Oct 24 08:56:30 2016
       Checksum : 63e60391 - correct
         Events : 75

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdc4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : dd78a43e:92699c27:3dc5489d:91d93bb2
           Name : arrayname:3
  Creation Time : Mon Dec  7 08:33:17 2015
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 15976448 (7.62 GiB 8.18 GB)
     Array Size : 15975424 (15.24 GiB 16.36 GB)
  Used Dev Size : 15975424 (7.62 GiB 8.18 GB)
    Data Offset : 8192 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 1fece6ad:ac89b95f:e861553e:d507b3d6

    Update Time : Mon Oct 24 08:56:30 2016
       Checksum : 67e6dae0 - correct
         Events : 75

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdd4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : dd78a43e:92699c27:3dc5489d:91d93bb2
           Name : arrayname:3
  Creation Time : Mon Dec  7 08:33:17 2015
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 15976448 (7.62 GiB 8.18 GB)
     Array Size : 15975424 (15.24 GiB 16.36 GB)
  Used Dev Size : 15975424 (7.62 GiB 8.18 GB)
    Data Offset : 8192 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 33cae133:63d86892:7011553c:2068b2cc

    Update Time : Mon Oct 24 08:56:30 2016
       Checksum : 1490177f - correct
         Events : 75

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing)


############ /proc/mdstat ############################################

root@machinename:/home/username# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md3 : active raid10 sdb4[4] sdd4[3] sda4[0] sdc4[2]
      15975424 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]

md2 : active raid5 sda3[0] sdc3[2](F) sdd3[3]
      8760565248 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/2]
[U__U]

md0 : active raid1 sdb1[4](S) sdc1[2](S) sda1[0] sdd1[3]
      1950656 blocks super 1.2 [2/2] [UU]

unused devices: <none>


################ PARTITIONS ##################

root@machinename:/home/username# cat sd.parted
BYT;
/dev/sda:3001GB:scsi:512:4096:gpt:ATA ST3000DM001-9YN1;
1:1049kB:2000MB:1999MB::boot:raid;
2:2000MB:2001MB:1049kB::grubbios:bios_grub;
3:2001MB:2992GB:2990GB:ext4:main:raid;
4:2992GB:3001GB:8184MB:linux-swap(v1):swap:raid;

BYT;
/dev/sdb:3001GB:scsi:512:4096:gpt:ATA ST3000DM001-1CH1;
1:1049kB:2000MB:1999MB::boot:raid;
2:2000MB:2001MB:1049kB::grubbios:bios_grub;
3:2001MB:2992GB:2990GB::main:raid;
4:2992GB:3001GB:8184MB::swap:raid;

BYT;
/dev/sdc:3001GB:scsi:512:4096:gpt:ATA ST3000DM001-1CH1;
1:1049kB:2000MB:1999MB::boot:raid;
2:2000MB:2001MB:1049kB::grubbios:bios_grub;
3:2001MB:2992GB:2990GB::main:raid;
4:2992GB:3001GB:8184MB::swap:raid;

BYT;
/dev/sdd:3001GB:scsi:512:4096:gpt:ATA ST3000DM001-9YN1;
1:1049kB:2000MB:1999MB::boot:raid;
2:2000MB:2001MB:1049kB::grubbios:bios_grub;
3:2001MB:2992GB:2990GB::main:raid;
4:2992GB:3001GB:8184MB::swap:raid;

BYT;
/dev/md0:1997MB:md:512:4096:loop:Linux Software RAID Array;
1:0.00B:1997MB:1997MB:ext4::;

BYT;
/dev/md2:8971GB:md:512:4096:loop:Linux Software RAID Array;
1:0.00B:8971GB:8971GB:ext4::;

BYT;
/dev/md3:16.4GB:md:512:4096:loop:Linux Software RAID Array;
1:0.00B:16.4GB:16.4GB:linux-swap(v1)::;
