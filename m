From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Recent drive errors
Date: Tue, 19 May 2015 05:08:11 -0600
Message-ID: <3296560.sGbn0HyrQY@balsa>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have this one drive that dropped out of one of my arrays once. It shows UNC
errors in SMART (log appended), and Reported_Uncorrect is 5. There are no
smart test failures or any other SMART values that look spectacularly wrong,
other than maybe Load_Cycle_Count which is 10625 (these seagates used to
constantly park and unpark before i updated the firmware).

I'm wondering whether or not this drive is still safe to use. I feel like I
can't trust it, especially after all the other Seagates I had that failed in
the past few years. I'm running a tool called whdd on it right now and it
shows very consistent latency spikes above 150ms. Really, I'm wondering if
this drive is RMAable as is, or if i have to wait for it to degrade further as
i have another drive with like 10k reallocated sectors to send in. I have
already replaced both with WD Red's so I can do whatever tests are needed to
figure it out.

Thanks for any help,

SMART log:

# smartctl -a /dev/sdf
smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.0.0-1-amd64] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST3000DM001-9YN166
Serial Number:    W1F2G312
LU WWN Device Id: 5 000c50 060014689
Firmware Version: CC4H
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue May 19 04:42:33 2015 MDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART Status not supported: Incomplete response, ATA output registers missing
SMART overall-health self-assessment test result: PASSED
Warning: This result is based on an Attribute check.

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
                                        Auto Offline data collection on/off support.
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
recommended polling time:        ( 345) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x3085) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   115   099   006    Pre-fail  Always       -       100468288
  3 Spin_Up_Time            0x0003   092   091   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       526
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   069   060   030    Pre-fail  Always       -       9795200
  9 Power_On_Hours          0x0032   094   094   000    Old_age   Always       -       5590
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       36
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   095   095   000    Old_age   Always       -       5
188 Command_Timeout         0x0032   100   099   000    Old_age   Always       -       0 0 1
189 High_Fly_Writes         0x003a   099   099   000    Old_age   Always       -       1
190 Airflow_Temperature_Cel 0x0022   064   054   045    Old_age   Always       -       36 (Min/Max 35/36)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       524
193 Load_Cycle_Count        0x0032   095   095   000    Old_age   Always       -       10625
194 Temperature_Celsius     0x0022   036   046   000    Old_age   Always       -       36 (0 18 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       5572h+04m+02.074s
241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       44489827126891
242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       22877192047256

SMART Error Log Version: 1
ATA Error Count: 5
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

Error 5 occurred at disk power-on lifetime: 5309 hours (221 days + 5 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 c0 ff ff ff 4f 00  48d+03:55:47.791  READ FPDMA QUEUED
  61 00 80 ff ff ff 4f 00  48d+03:55:47.791  WRITE FPDMA QUEUED
  e5 00 00 00 00 00 00 00  48d+03:55:47.784  CHECK POWER MODE
  60 00 08 08 00 00 40 00  48d+03:55:47.755  READ FPDMA QUEUED
  60 00 08 00 00 00 40 00  48d+03:55:47.751  READ FPDMA QUEUED

Error 4 occurred at disk power-on lifetime: 5309 hours (221 days + 5 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 00 ff ff ff 4f 00  48d+03:55:44.672  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  48d+03:55:44.672  READ FPDMA QUEUED
  60 00 c0 ff ff ff 4f 00  48d+03:55:44.672  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00  48d+03:55:44.672  READ FPDMA QUEUED
  60 00 08 00 00 00 40 00  48d+03:55:44.672  READ FPDMA QUEUED

Error 3 occurred at disk power-on lifetime: 5309 hours (221 days + 5 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 00 ff ff ff 4f 00  48d+03:55:41.802  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00  48d+03:55:41.802  READ FPDMA QUEUED
  60 00 c0 ff ff ff 4f 00  48d+03:55:41.802  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  48d+03:55:41.802  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  48d+03:55:41.801  READ FPDMA QUEUED

Error 2 occurred at disk power-on lifetime: 5309 hours (221 days + 5 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  48d+03:55:38.809  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00  48d+03:55:38.793  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  48d+03:55:38.793  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  48d+03:55:38.792  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  48d+03:55:38.792  READ FPDMA QUEUED

Error 1 occurred at disk power-on lifetime: 5309 hours (221 days + 5 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 00 ff ff ff 4f 00  48d+03:55:35.636  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  48d+03:55:35.636  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  48d+03:55:35.636  READ FPDMA QUEUED
  60 00 40 ff ff ff 4f 00  48d+03:55:35.636  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  48d+03:55:35.636  READ FPDMA QUEUED

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      5574         -
# 2  Extended offline    Completed without error       00%      5571         -
# 3  Extended offline    Completed without error       00%      5561         -
# 4  Short offline       Completed without error       00%      5556         -
# 5  Short offline       Completed without error       00%      5553         -
# 6  Short offline       Completed without error       00%      5529         -
# 7  Short offline       Completed without error       00%      5505         -
# 8  Short offline       Completed without error       00%      5481         -
# 9  Short offline       Completed without error       00%      5457         -
#10  Short offline       Completed without error       00%      5433         -
#11  Short offline       Completed without error       00%      5409         -
#12  Short offline       Completed without error       00%      5385         -
#13  Short offline       Completed without error       00%      5361         -
#14  Short offline       Completed without error       00%      5337         -
#15  Short offline       Completed without error       00%      5313         -
#16  Short offline       Completed without error       00%      5289         -
#17  Short offline       Completed without error       00%      5265         -
#18  Short offline       Completed without error       00%      5241         -
#19  Short offline       Completed without error       00%      5217         -
#20  Short offline       Completed without error       00%      5193         -
#21  Short offline       Completed without error       00%      5169         -

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

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
