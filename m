From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: And again help on deciphering an error
Date: Wed, 29 Oct 2008 00:53:30 +0100
Message-ID: <4907A5FA.7050903@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

Before I ask my question - if there is some documentation that answers
what I am asking - I would be thrilled to read it. So far google has not
helped me at all.

This being said I need help with understanding what is going on here
(full log):


Oct 27 11:33:41 Arzamas kernel: ata6.00: exception Emask 0x10 SAct 0x0
SErr 0x80000 action 0xe frozen
Oct 27 11:33:41 Arzamas kernel: ata6.00: irq_stat 0x01100010, PHY RDY
changed
Oct 27 11:33:41 Arzamas kernel: ata6: SError: { 10B8B }
Oct 27 11:33:41 Arzamas kernel: ata6.00: cmd
ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Oct 27 11:33:41 Arzamas kernel: res 06/37:00:00:00:00/00:00:00:00:06/00
Emask 0x12 (ATA bus error)
Oct 27 11:33:41 Arzamas kernel: ata6.00: error: { IDNF ABRT }
Oct 27 11:33:41 Arzamas kernel: ata6: hard resetting link
Oct 27 11:33:46 Arzamas kernel: ata6: SATA link up 3.0 Gbps (SStatus 123
SControl 0)
Oct 27 11:33:46 Arzamas kernel: ata6.00: configured for UDMA/100
Oct 27 11:33:46 Arzamas kernel: ata6: EH complete
Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] 488397168 512-byte
hardware sectors (250059 MB)
Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Write Protect is off
Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Oct 27 11:33:46 Arzamas kernel: end_request: I/O error, dev sde, sector
488166955
Oct 27 11:33:46 Arzamas kernel: md: super_written gets error=-5, uptodate=0
Oct 27 11:33:46 Arzamas kernel: raid10: Disk failure on sde2, disabling
device.
Oct 27 11:33:46 Arzamas kernel: raid10: Operation continuing on 3 devices.
Oct 27 11:33:46 Arzamas kernel: RAID10 conf printout:
Oct 27 11:33:46 Arzamas kernel: --- wd:3 rd:4
Oct 27 11:33:46 Arzamas kernel: disk 0, wo:0, o:1, dev:sdc2
Oct 27 11:33:46 Arzamas kernel: disk 1, wo:0, o:1, dev:sdb2
Oct 27 11:33:46 Arzamas kernel: disk 2, wo:1, o:0, dev:sde2
Oct 27 11:33:46 Arzamas kernel: disk 3, wo:0, o:1, dev:sdd2
Oct 27 11:33:46 Arzamas kernel: RAID10 conf printout:
Oct 27 11:33:46 Arzamas kernel: --- wd:3 rd:4
Oct 27 11:33:46 Arzamas kernel: disk 0, wo:0, o:1, dev:sdc2
Oct 27 11:33:46 Arzamas kernel: disk 1, wo:0, o:1, dev:sdb2
Oct 27 11:33:46 Arzamas kernel: disk 3, wo:0, o:1, dev:sdd2

Afterwards I removed sde from all arrays and mounts, and grilled it
repeatedly with badblocks and smartctl -t long. Nothing came out for
over a day. Below see the smartclt -a output. This happened one day
after I upgraded to 2.6.27.4 from 2.6.23.

Can someone please tell me what seems to be dying? Thank you!



root@Arzamas:~# smartctl -a /dev/sde
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Second Generation Serial ATA family
Device Model:     WDC WD2500AAJS-00B4A0
Serial Number:    WD-WCAT11669666
Firmware Version: 01.03A01
User Capacity:    250,059,350,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Tue Oct 28 19:52:16 2008 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine
completed
					without error or no self-test has ever
					been run.
Total time to complete Offline
data collection: 		 (6180) seconds.
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
recommended polling time: 	 (  75) minutes.
Conveyance self-test routine
recommended polling time: 	 (   5) minutes.
SCT capabilities: 	       (0x303f)	SCT Status supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always
      -       0
  3 Spin_Up_Time            0x0027   175   153   021    Pre-fail  Always
      -       2250
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always
      -       17
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always
      -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Always
      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always
      -       694
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Always
      -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Always
      -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always
      -       17
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always
      -       13
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always
      -       17
194 Temperature_Celsius     0x0022   106   100   000    Old_age   Always
      -       37
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always
      -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always
      -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always
      -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%       694
     -
# 2  Extended offline    Completed without error       00%       684
     -
# 3  Extended offline    Completed without error       00%       663
     -
# 4  Short offline       Aborted by host               60%       662
     -
# 5  Short offline       Completed without error       00%       662
     -

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

root@Arzamas:~#
