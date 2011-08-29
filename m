From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: (solved) RAID1, changed disk, 2nd has errors ...
Date: Mon, 29 Aug 2011 16:34:48 +0200
Message-ID: <4E5BA388.3000405@xunil.at>
References: <4E5787A1.7080807@xunil.at> <20110826125653.GA13709@cthulhu.home.robinhill.me.uk> <4E57A4D5.3070004@xunil.at> <20110826140810.GB13709@cthulhu.home.robinhill.me.uk> <4E57BEBB.2000606@xunil.at> <4E5B396D.9020609@xunil.at> <4E5B438D.8000107@xunil.at> <CADNH=7G=HFSinigdCtHbSV0iKMGB57CrgjA+Qde4xRAeW7FURQ@mail.gmail.com> <4E5B4712.90106@xunil.at> <4E5B4D12.5060604@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5B4D12.5060604@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, robin.hill47@ntlworld.com
List-Id: linux-raid.ids

Am 29.08.2011 10:25, schrieb Stefan G. Weichinger:

> I get
> 
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always
>       -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
> Offline      -       0
> 
> 
> Sounds good to me! Right?
> 
> So now I could re-add /dev/sdb4 to retry syncing that array, correct?

Did that.

I failed/removed/re-added /dev/sdb4 and waited for some hours of resyncing.

Now /dev/md2 is in sync again, still with no bad sectors in SMART
(attached, @Mathias ;-))

thanks to Robin and Mathias for your feedback, it helped me to get the
picture and chose the next steps!

For now I let the arrays as they are and wait for the second new hdd.
As soon as I have it here I will swap /dev/sdb as well.

(a new server with maybe RAID6 is soon to come there ...)

Thanks, Stefan

----

# smartctl -a /dev/sda
smartctl 5.40 2010-10-16 r3189 [i686-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.12 family
Device Model:     ST31000528AS
Serial Number:    9VP3BSEV
Firmware Version: CC38
User Capacity:    1.000.204.886.016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Mon Aug 29 16:31:35 2011 CEST
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
data collection: 		 ( 600) seconds.
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
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 ( 178) minutes.
Conveyance self-test routine
recommended polling time: 	 (   2) minutes.
SCT capabilities: 	       (0x103f)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   117   099   006    Pre-fail  Always
      -       134791791
  3 Spin_Up_Time            0x0003   097   095   000    Pre-fail  Always
      -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always
      -       50
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always
      -       0
  7 Seek_Error_Rate         0x000f   080   060   030    Pre-fail  Always
      -       111650379
  9 Power_On_Hours          0x0032   085   085   000    Old_age   Always
      -       13433
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always
      -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always
      -       25
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always
      -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always
      -       0
187 Reported_Uncorrect      0x0032   082   082   000    Old_age   Always
      -       18
188 Command_Timeout         0x0032   100   099   000    Old_age   Always
      -       2
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always
      -       0
190 Airflow_Temperature_Cel 0x0022   067   060   045    Old_age   Always
      -       33 (Min/Max 27/36)
194 Temperature_Celsius     0x0022   033   040   000    Old_age   Always
      -       33 (0 15 0 0)
195 Hardware_ECC_Recovered  0x001a   048   024   000    Old_age   Always
      -       134791791
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always
      -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always
      -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age
Offline      -       255980050855093
241 Total_LBAs_Written      0x0000   100   253   000    Old_age
Offline      -       2678846567
242 Total_LBAs_Read         0x0000   100   253   000    Old_age
Offline      -       4015371061

SMART Error Log Version: 1
ATA Error Count: 18 (device log contains only the most recent five errors)
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

Error 18 occurred at disk power-on lifetime: 13357 hours (556 days + 13
hours)
  When the command that caused the error occurred, the device was active
or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00      01:28:56.212  READ DMA EXT
  27 00 00 00 00 00 e0 00      01:28:56.211  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00      01:28:56.191  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      01:28:56.175  SET FEATURES [Set transfer
mode]
  27 00 00 00 00 00 e0 00      01:28:56.151  READ NATIVE MAX ADDRESS EXT

Error 17 occurred at disk power-on lifetime: 13357 hours (556 days + 13
hours)
  When the command that caused the error occurred, the device was active
or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00      01:28:53.001  READ DMA EXT
  27 00 00 00 00 00 e0 00      01:28:53.000  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00      01:28:52.980  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      01:28:52.961  SET FEATURES [Set transfer
mode]
  27 00 00 00 00 00 e0 00      01:28:52.940  READ NATIVE MAX ADDRESS EXT

Error 16 occurred at disk power-on lifetime: 13357 hours (556 days + 13
hours)
  When the command that caused the error occurred, the device was active
or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00      01:28:49.790  READ DMA EXT
  27 00 00 00 00 00 e0 00      01:28:49.789  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00      01:28:49.749  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      01:28:49.739  SET FEATURES [Set transfer
mode]
  27 00 00 00 00 00 e0 00      01:28:49.719  READ NATIVE MAX ADDRESS EXT

Error 15 occurred at disk power-on lifetime: 13357 hours (556 days + 13
hours)
  When the command that caused the error occurred, the device was active
or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00      01:28:46.580  READ DMA EXT
  27 00 00 00 00 00 e0 00      01:28:46.579  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00      01:28:46.559  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      01:28:46.542  SET FEATURES [Set transfer
mode]
  27 00 00 00 00 00 e0 00      01:28:46.519  READ NATIVE MAX ADDRESS EXT

Error 14 occurred at disk power-on lifetime: 13357 hours (556 days + 13
hours)
  When the command that caused the error occurred, the device was active
or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00      01:28:43.379  READ DMA EXT
  27 00 00 00 00 00 e0 00      01:28:43.378  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00      01:28:43.358  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      01:28:43.345  SET FEATURES [Set transfer
mode]
  27 00 00 00 00 00 e0 00      01:28:43.318  READ NATIVE MAX ADDRESS EXT

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     13429
     -
# 2  Short offline       Completed without error       00%     13405
     -
# 3  Short offline       Completed without error       00%     13381
     -
# 4  Extended offline    Completed without error       00%     13375
     -
# 5  Short offline       Completed without error       00%     13357
     -
# 6  Short offline       Completed without error       00%     13333
     -
# 7  Short offline       Completed without error       00%     13310
     -
# 8  Short offline       Completed without error       00%     13286
     -
# 9  Short offline       Completed without error       00%     13261
     -
#10  Short offline       Completed without error       00%     13237
     -
#11  Short offline       Completed without error       00%     13213
     -
#12  Extended offline    Completed without error       00%     13207
     -
#13  Short offline       Completed without error       00%     13189
     -
#14  Short offline       Completed without error       00%     13164
     -
#15  Short offline       Completed without error       00%     13162
     -
#16  Short offline       Completed without error       00%     13138
     -
#17  Short offline       Completed without error       00%     13114
     -
#18  Short offline       Completed without error       00%     13090
     -
#19  Short offline       Completed without error       00%     13066
     -
#20  Extended offline    Completed without error       00%     13060
     -
#21  Short offline       Completed without error       00%     13042
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


