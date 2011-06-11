From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: HDD reports errors while completing RAID6 array check
Date: Sat, 11 Jun 2011 10:49:47 +0100
Message-ID: <BANLkTimf-P1x57KmYbunGp8UHskvjQS35A@mail.gmail.com>
References: <BANLkTik87PZChAzgBnDM170uJHU=3Yc6Eg@mail.gmail.com>
	<20110611000000.76ca58e7@natsu>
	<BANLkTinPfZeSwJ8Tckc0usXFpLHHuPSz4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinPfZeSwJ8Tckc0usXFpLHHuPSz4Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10 June 2011 19:23, Mathias Bur=C3=A9n <mathias.buren@gmail.com> wro=
te:
> On 10 June 2011 19:00, Roman Mamedov <rm@romanrm.ru> wrote:
>> On Fri, 10 Jun 2011 18:37:06 +0100
>> Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>>
>>> =C2=A0 9 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=
=A0 090 =C2=A0 090 =C2=A0 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 7781
>>
>>
>>> # 1 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06827
>>> - # 2 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00%
>>> 6550 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - # 3 =C2=A0Extended offline =C2=A0=
 =C2=A0Completed without error
>>> 00% =C2=A0 =C2=A0 =C2=A06468 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - # 4 =C2=A0=
Extended offline =C2=A0 =C2=A0Completed without
>>> error =C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06329 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 - # 5 =C2=A0Extended offline =C2=A0 =C2=A0Completed
>>> without error =C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06040 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 - # 6 =C2=A0Extended offline
>>> Completed without error =C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A0=
5584 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - # 7 =C2=A0Extended
>>> offline =C2=A0 =C2=A0Completed without error =C2=A0 =C2=A0 =C2=A0 0=
0% =C2=A0 =C2=A0 =C2=A05178 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - # 8
>>> Extended offline =C2=A0 =C2=A0Completed without error =C2=A0 =C2=A0=
 =C2=A0 00% =C2=A0 =C2=A0 =C2=A04761 =C2=A0 =C2=A0 =C2=A0 =C2=A0 - #
>>> 9 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A02285 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 -
>>> #10 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A01514
>>
>> I suggest that you do another "smartctl -t long" on it, the latest o=
ne was
>> done almost 1000 hours ago which is also much longer than the period=
 between
>> previous tests. Freezes on reads could be a symptom of a bad (unread=
able, or
>> very slowly readable - which is worse) sector, perhaps it could be d=
etected by
>> the SMART test. Or also do a full read of the drive directly (not th=
rough the
>> RAID) e.g. with "badblocks" and see if you get any I/O errors that w=
ay.
>>
>> --
>> With respect,
>> Roman
>>
>
> Thanks for the suggestions, I'll start the long selftest now.
>
> /M
>

Things look OK after the test:

 $ sudo smartctl -a /dev/sdd
Password:
smartctl 5.40 2010-10-16 r3189 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Green (Adv. Format) family
Device Model:     WDC WD20EARS-00MVWB0
Serial Number:    WD-WMAZ20188479
=46irmware Version: 50.0AB50
User Capacity:    2,000,398,934,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sat Jun 11 10:48:05 2011 IST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activit=
y
                                        was suspended by an
interrupting command from host.
                                        Auto Offline Data Collection: E=
nabled.
Self-test execution status:      (   0) The previous self-test routine =
completed
                                        without error or no self-test h=
as ever
                                        been run.
Total time to complete Offline
data collection:                 (36000) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate=
=2E
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon=
 new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before enterin=
g
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging support=
ed.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 255) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x3035) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   176   162   021    Pre-fail
Always       -       6183
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       59
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   090   090   000    Old_age
Always       -       7797
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       53
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       32
193 Load_Cycle_Count        0x0032   162   162   000    Old_age
Always       -       114863
194 Temperature_Celsius     0x0022   109   102   000    Old_age
Always       -       41
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      7788   =
      -
# 2  Extended offline    Completed without error       00%      6827   =
      -
# 3  Extended offline    Completed without error       00%      6550   =
      -
# 4  Extended offline    Completed without error       00%      6468   =
      -
# 5  Extended offline    Completed without error       00%      6329   =
      -
# 6  Extended offline    Completed without error       00%      6040   =
      -
# 7  Extended offline    Completed without error       00%      5584   =
      -
# 8  Extended offline    Completed without error       00%      5178   =
      -
# 9  Extended offline    Completed without error       00%      4761   =
      -
#10  Short offline       Completed without error       00%      2285   =
      -
#11  Extended offline    Completed without error       00%      1514   =
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

I initiated a self test on each of the other HDDs as well. It's time
to run badblocks then!

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
