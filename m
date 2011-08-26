From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: RAID1, changed disk, 2nd has errors ...
Date: Fri, 26 Aug 2011 14:19:25 +0200
Message-ID: <4E578F4D.9050908@xunil.at>
References: <4E5787A1.7080807@xunil.at> <CADNH=7HMgJ9+wCEH5i03L6UmQw2xnMopnx09z8W0nU-q6_0Dig@mail.gmail.com>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7HMgJ9+wCEH5i03L6UmQw2xnMopnx09z8W0nU-q6_0Dig@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
List-Id: linux-raid.ids

Am 26.08.2011 14:01, schrieb Mathias Bur=C3=A9n:

> Could you perhaps post the output of "smartctl -a /dev/sda" (and sdb
> for completeness sake) here? You can find smartctl in the
> smartmontools package.

sure. sdb is the new hdd from today (as mentioned)

->

 # smartctl -a /dev/sda
smartctl 5.40 2010-10-16 r3189 [i686-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Seagate Barracuda 7200.12 family
Device Model:     ST31000528AS
Serial Number:    9VP3BSEV
=46irmware Version: CC38
User Capacity:    1.000.204.886.016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Fri Aug 26 14:18:06 2011 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activit=
y
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
SMART capabilities:            (0x0003)	Saves SMART data before enterin=
g
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
  1 Raw_Read_Error_Rate     0x000f   101   099   006    Pre-fail  Alway=
s
      -       77880938
  3 Spin_Up_Time            0x0003   097   095   000    Pre-fail  Alway=
s
      -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Alway=
s
      -       50
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Alway=
s
      -       0
  7 Seek_Error_Rate         0x000f   080   060   030    Pre-fail  Alway=
s
      -       110698342
  9 Power_On_Hours          0x0032   085   085   000    Old_age   Alway=
s
      -       13359
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Alway=
s
      -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Alway=
s
      -       25
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Alway=
s
      -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age   Alway=
s
      -       0
187 Reported_Uncorrect      0x0032   082   082   000    Old_age   Alway=
s
      -       18
188 Command_Timeout         0x0032   100   099   000    Old_age   Alway=
s
      -       2
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Alway=
s
      -       0
190 Airflow_Temperature_Cel 0x0022   065   060   045    Old_age   Alway=
s
      -       35 (Min/Max 32/36)
194 Temperature_Celsius     0x0022   035   040   000    Old_age   Alway=
s
      -       35 (0 15 0 0)
195 Hardware_ECC_Recovered  0x001a   046   024   000    Old_age   Alway=
s
      -       77880938
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Alway=
s
      -       2
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       2
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Alway=
s
      -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age
Offline      -       16896401355883
241 Total_LBAs_Written      0x0000   100   253   000    Old_age
Offline      -       2526036334
242 Total_LBAs_Read         0x0000   100   253   000    Old_age
Offline      -       2586691393

SMART Error Log Version: 1
ATA Error Count: 18 (device log contains only the most recent five erro=
rs)
	CR =3D Command Register [HEX]
	FR =3D Features Register [HEX]
	SC =3D Sector Count Register [HEX]
	SN =3D Sector Number Register [HEX]
	CL =3D Cylinder Low Register [HEX]
	CH =3D Cylinder High Register [HEX]
	DH =3D Device/Head Register [HEX]
	DC =3D Device Command Register [HEX]
	ER =3D Error register [HEX]
	ST =3D Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
SS=3Dsec, and sss=3Dmillisec. It "wraps" after 49.710 days.

Error 18 occurred at disk power-on lifetime: 13357 hours (556 days + 13
hours)
  When the command that caused the error occurred, the device was activ=
e
or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA =3D 0x0fffffff =3D 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00      01:28:56.212  READ DMA EXT
  27 00 00 00 00 00 e0 00      01:28:56.211  READ NATIVE MAX ADDRESS EX=
T
  ec 00 00 00 00 00 a0 00      01:28:56.191  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      01:28:56.175  SET FEATURES [Set transfer
mode]
  27 00 00 00 00 00 e0 00      01:28:56.151  READ NATIVE MAX ADDRESS EX=
T

Error 17 occurred at disk power-on lifetime: 13357 hours (556 days + 13
hours)
  When the command that caused the error occurred, the device was activ=
e
or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA =3D 0x0fffffff =3D 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00      01:28:53.001  READ DMA EXT
  27 00 00 00 00 00 e0 00      01:28:53.000  READ NATIVE MAX ADDRESS EX=
T
  ec 00 00 00 00 00 a0 00      01:28:52.980  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      01:28:52.961  SET FEATURES [Set transfer
mode]
  27 00 00 00 00 00 e0 00      01:28:52.940  READ NATIVE MAX ADDRESS EX=
T

Error 16 occurred at disk power-on lifetime: 13357 hours (556 days + 13
hours)
  When the command that caused the error occurred, the device was activ=
e
or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA =3D 0x0fffffff =3D 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00      01:28:49.790  READ DMA EXT
  27 00 00 00 00 00 e0 00      01:28:49.789  READ NATIVE MAX ADDRESS EX=
T
  ec 00 00 00 00 00 a0 00      01:28:49.749  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      01:28:49.739  SET FEATURES [Set transfer
mode]
  27 00 00 00 00 00 e0 00      01:28:49.719  READ NATIVE MAX ADDRESS EX=
T

Error 15 occurred at disk power-on lifetime: 13357 hours (556 days + 13
hours)
  When the command that caused the error occurred, the device was activ=
e
or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA =3D 0x0fffffff =3D 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00      01:28:46.580  READ DMA EXT
  27 00 00 00 00 00 e0 00      01:28:46.579  READ NATIVE MAX ADDRESS EX=
T
  ec 00 00 00 00 00 a0 00      01:28:46.559  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      01:28:46.542  SET FEATURES [Set transfer
mode]
  27 00 00 00 00 00 e0 00      01:28:46.519  READ NATIVE MAX ADDRESS EX=
T

Error 14 occurred at disk power-on lifetime: 13357 hours (556 days + 13
hours)
  When the command that caused the error occurred, the device was activ=
e
or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA =3D 0x0fffffff =3D 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 00 08 ff ff ff ef 00      01:28:43.379  READ DMA EXT
  27 00 00 00 00 00 e0 00      01:28:43.378  READ NATIVE MAX ADDRESS EX=
T
  ec 00 00 00 00 00 a0 00      01:28:43.358  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00      01:28:43.345  SET FEATURES [Set transfer
mode]
  27 00 00 00 00 00 e0 00      01:28:43.318  READ NATIVE MAX ADDRESS EX=
T

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     13357
     -
# 2  Short offline       Completed without error       00%     13333
     -
# 3  Short offline       Completed without error       00%     13310
     -
# 4  Short offline       Completed without error       00%     13286
     -
# 5  Short offline       Completed without error       00%     13261
     -
# 6  Short offline       Completed without error       00%     13237
     -
# 7  Short offline       Completed without error       00%     13213
     -
# 8  Extended offline    Completed without error       00%     13207
     -
# 9  Short offline       Completed without error       00%     13189
     -
#10  Short offline       Completed without error       00%     13164
     -
#11  Short offline       Completed without error       00%     13162
     -
#12  Short offline       Completed without error       00%     13138
     -
#13  Short offline       Completed without error       00%     13114
     -
#14  Short offline       Completed without error       00%     13090
     -
#15  Short offline       Completed without error       00%     13066
     -
#16  Extended offline    Completed without error       00%     13060
     -
#17  Short offline       Completed without error       00%     13042
     -
#18  Short offline       Completed without error       00%     13018
     -
#19  Short offline       Completed without error       00%     12994
     -
#20  Short offline       Completed without error       00%     12970
     -
#21  Short offline       Completed without error       00%     12946
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
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.



# smartctl -a /dev/sdb
smartctl 5.40 2010-10-16 r3189 [i686-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     ST1000NM0011
Serial Number:    Z1N04CMC
=46irmware Version: SN02
User Capacity:    1.000.204.886.016 bytes
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Fri Aug 26 14:18:35 2011 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activit=
y
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine
completed
					without error or no self-test has ever
					been run.
Total time to complete Offline
data collection: 		 ( 114) seconds.
Offline data collection
capabilities: 			 (0x7b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before enterin=
g
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 ( 155) minutes.
Conveyance self-test routine
recommended polling time: 	 (   2) minutes.
SCT capabilities: 	       (0x10bd)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   066   066   044    Pre-fail  Alway=
s
      -       5184768
  3 Spin_Up_Time            0x0003   097   097   000    Pre-fail  Alway=
s
      -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Alway=
s
      -       8
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Alway=
s
      -       0
  7 Seek_Error_Rate         0x000f   100   253   030    Pre-fail  Alway=
s
      -       88000
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Alway=
s
      -       3
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Alway=
s
      -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Alway=
s
      -       8
184 End-to-End_Error        0x0032   100   100   099    Old_age   Alway=
s
      -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Alway=
s
      -       0
188 Command_Timeout         0x0032   100   100   000    Old_age   Alway=
s
      -       0
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Alway=
s
      -       0
190 Airflow_Temperature_Cel 0x0022   064   049   045    Old_age   Alway=
s
      -       36 (Min/Max 30/37)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Alway=
s
      -       1
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Alway=
s
      -       7
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Alway=
s
      -       8
194 Temperature_Celsius     0x0022   036   051   000    Old_age   Alway=
s
      -       36 (0 25 0 0)
195 Hardware_ECC_Recovered  0x001a   102   100   000    Old_age   Alway=
s
      -       5184768
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Alway=
s
      -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Alway=
s
      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%         1
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
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
