From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Do I have a bad HDD?
Date: Sun, 31 Jul 2011 19:05:39 +0100
Message-ID: <CADNH=7EHAyk7Z7Wa72XO=p1od6AQP5aew_W5DffgLfZeCu=d-g@mail.gmail.com>
References: <CADNH=7HDCwtUr-HSN7fH_GSH8jTYb-SAwmKY0ZRn3opWAhKiBQ@mail.gmail.com>
	<CADNH=7EJ7tvw2DEsAbeuxxRO1k961RSV4axgvfRUBaKG+Q455Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7EJ7tvw2DEsAbeuxxRO1k961RSV4axgvfRUBaKG+Q455Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31 July 2011 18:59, Mathias Bur=C3=A9n <mathias.buren@gmail.com> wro=
te:
> On 31 July 2011 14:05, Mathias Bur=C3=A9n <mathias.buren@gmail.com> w=
rote:
>> Hi list,
>>
>> Here's the output of my weekly script:
>>
>> DEV =C2=A0 =C2=A0 EVENTS =C2=A0REALL =C2=A0 PEND =C2=A0 =C2=A0UNCORR=
 =C2=A0CRC =C2=A0 =C2=A0 RAW =C2=A0 =C2=A0 ZONE =C2=A0 =C2=A0END
>> sdb1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0
>> sdc1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0
>> sdd1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0
>> sde1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 1
>> sdf1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 47 =C2=A0 =C2=A0 =C2=A0=
6
>> sdg1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0
>> sdh1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 340 =C2=A0 =C2=A0 3
>>
>>
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid6 sdf1[5] sdh1[6] sdg1[0] sde1[7] sdc1[3] sdd1[4] s=
db1[1]
>> =C2=A0 =C2=A0 =C2=A09751756800 blocks super 1.2 level 6, 64k chunk, =
algorithm 2
>> [7/7] [UUUUUUU]
>>
>> unused devices: <none>
>>
>>
>> /dev/md0:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 1.2
>> =C2=A0Creation Time : Tue Oct 19 08:58:41 2010
>> =C2=A0 =C2=A0 Raid Level : raid6
>> =C2=A0 =C2=A0 Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
>> =C2=A0Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
>> =C2=A0 Raid Devices : 7
>> =C2=A0Total Devices : 7
>> =C2=A0 =C2=A0Persistence : Superblock is persistent
>>
>> =C2=A0 =C2=A0Update Time : Sun Jul 31 09:50:43 2011
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>> =C2=A0Active Devices : 7
>> Working Devices : 7
>> =C2=A0Failed Devices : 0
>> =C2=A0Spare Devices : 0
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
>> =C2=A0 =C2=A0 Chunk Size : 64K
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Name : ion:0 =C2=A0(local to host=
 ion)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : e6595c64:b3ae90b3:f01133ac=
:3f402d20
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 6158767
>>
>> =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice Stat=
e
>> =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 9=
7 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sdg1
>> =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 1=
7 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sdb1
>> =C2=A0 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 4=
9 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sdd1
>> =C2=A0 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 3=
3 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sdc1
>> =C2=A0 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 8=
1 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sdf1
>> =C2=A0 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A011=
3 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sdh1
>> =C2=A0 =C2=A0 =C2=A0 7 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 6=
5 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sde1
>>
>> Here's the SMART data for sdh:
>>
>>
>> smartctl 5.41 2011-06-09 r3365 [x86_64-linux-2.6.39-ck] (local build=
)
>> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourcefor=
ge.net
>>
>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
>> Model Family: =C2=A0 =C2=A0 SAMSUNG SpinPoint F4 EG (AFT)
>> Device Model: =C2=A0 =C2=A0 SAMSUNG HD204UI
>> Serial Number: =C2=A0 =C2=A0S2HGJ1RZ800850
>> LU WWN Device Id: 5 0024e9 003f1ebc9
>> Firmware Version: 1AQ10003
>> User Capacity: =C2=A0 =C2=A02,000,398,934,016 bytes [2.00 TB]
>> Sector Size: =C2=A0 =C2=A0 =C2=A0512 bytes logical/physical
>> Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0In smartctl database [for deta=
ils use: -P show]
>> ATA Version is: =C2=A0 8
>> ATA Standard is: =C2=A0ATA-8-ACS revision 6
>> Local Time is: =C2=A0 =C2=A0Sun Jul 31 14:03:32 2011 IST
>>
>> =3D=3D> WARNING: Using smartmontools or hdparm with this
>> drive may result in data loss due to a firmware bug.
>> ****** THIS DRIVE MAY OR MAY NOT BE AFFECTED! ******
>> Buggy and fixed firmware report same version number!
>> See the following web pages for details:
>> http://www.samsung.com/global/business/hdd/faqView.do?b2b_bbs_msg_id=
=3D386
>> http://sourceforge.net/apps/trac/smartmontools/wiki/SamsungF4EGBadBl=
ocks
>>
>> SMART support is: Available - device has SMART capability.
>> SMART support is: Enabled
>>
>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
>> SMART overall-health self-assessment test result: PASSED
>>
>> General SMART Values:
>> Offline data collection status: =C2=A0(0x82) Offline data collection=
 activity
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0w=
as completed without error.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
uto Offline Data Collection: Enabled.
>> Self-test execution status: =C2=A0 =C2=A0 =C2=A0( =C2=A037) The self=
-test routine was interrupted
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b=
y the host with a hard or soft reset.
>> Total time to complete Offline
>> data collection: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0(20640) seconds.
>> Offline data collection
>> capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0(0x5b) SMART execute Offline immediate.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
uto Offline data collection on/off support.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
uspend Offline collection upon new
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c=
ommand.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0O=
ffline surface scan supported.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
elf-test supported.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0N=
o Conveyance Self-test supported.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
elective Self-test supported.
>> SMART capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x0003=
) Saves SMART data before entering
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p=
ower-saving mode.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
upports SMART auto save timer.
>> Error logging capability: =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x01) Error lo=
gging supported.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0G=
eneral Purpose Logging supported.
>> Short self-test routine
>> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( =C2=A0 2) min=
utes.
>> Extended self-test routine
>> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( 255) minutes.
>> SCT capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(0=
x003f) SCT Status supported.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
CT Error Recovery Control supported.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
CT Feature Control supported.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
CT Data Table supported.
>>
>> SMART Attributes Data Structure revision number: 16
>> Vendor Specific SMART Attributes with Thresholds:
>> ID# ATTRIBUTE_NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FLAG =C2=A0 =C2=
=A0 VALUE WORST THRESH TYPE
>> UPDATED =C2=A0WHEN_FAILED RAW_VALUE
>> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x002f =C2=A0 100 =C2=A0 1=
00 =C2=A0 051 =C2=A0 =C2=A0Pre-fail
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 340
>> =C2=A02 Throughput_Performance =C2=A00x0026 =C2=A0 055 =C2=A0 053 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 18989
>> =C2=A03 Spin_Up_Time =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0023=
 =C2=A0 067 =C2=A0 044 =C2=A0 025 =C2=A0 =C2=A0Pre-fail
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 10165
>> =C2=A04 Start_Stop_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 10=
0 =C2=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 18
>> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 252 =C2=A0 252 =C2=
=A0 010 =C2=A0 =C2=A0Pre-fail
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>> =C2=A07 Seek_Error_Rate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x002e =C2=A0 25=
2 =C2=A0 252 =C2=A0 051 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>> =C2=A08 Seek_Time_Performance =C2=A0 0x0024 =C2=A0 252 =C2=A0 252 =C2=
=A0 015 =C2=A0 =C2=A0Old_age
>> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>> =C2=A09 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 100 =C2=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 6447
>> =C2=A010 Spin_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 2=
52 =C2=A0 252 =C2=A0 051 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>> =C2=A011 Calibration_Retry_Count 0x0032 =C2=A0 252 =C2=A0 252 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>> =C2=A012 Power_Cycle_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 20
>> 181 Program_Fail_Cnt_Total =C2=A00x0022 =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 10117271
>> 191 G-Sense_Error_Rate =C2=A0 =C2=A0 =C2=A00x0022 =C2=A0 100 =C2=A0 =
100 =C2=A0 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 1
>> 192 Power-Off_Retract_Count 0x0022 =C2=A0 252 =C2=A0 252 =C2=A0 000 =
=C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0002 =C2=A0 064 =C2=A0 057 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 35 (Min/Max 16/43=
)
>> 195 Hardware_ECC_Recovered =C2=A00x003a =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>> 196 Reallocated_Event_Count 0x0032 =C2=A0 252 =C2=A0 252 =C2=A0 000 =
=C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>> 197 Current_Pending_Sector =C2=A00x0032 =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 6
>> 198 Offline_Uncorrectable =C2=A0 0x0030 =C2=A0 252 =C2=A0 252 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x0036 =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>> 200 Multi_Zone_Error_Rate =C2=A0 0x002a =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 3
>> 223 Load_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 252 =C2=
=A0 252 =C2=A0 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>> 225 Load_Cycle_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 21
>>
>> SMART Error Log Version: 1
>> No Errors Logged
>>
>> SMART Self-test log structure revision number 1
>> Num =C2=A0Test_Description =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining
>> LifeTime(hours) =C2=A0LBA_of_first_error
>> # 1 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=
=A0 =C2=A0 =C2=A050% =C2=A0 =C2=A0 =C2=A06408 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 2 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06317 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 3 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06260 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 4 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06232 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 5 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06170 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 6 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06064 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 7 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06029 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 8 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05898 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 9 =C2=A0Extended offline =C2=A0 =C2=A0Aborted by host =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 60% =C2=A0 =C2=A0 =C2=A05893 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 -
>> #10 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05728 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #11 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05706 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #12 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=
=A0 =C2=A0 =C2=A040% =C2=A0 =C2=A0 =C2=A05701 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #13 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=
=A0 =C2=A0 =C2=A090% =C2=A0 =C2=A0 =C2=A05666 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #14 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05560 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #15 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05527 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #16 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05392 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #17 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05357 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #18 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05250 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #19 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A04272 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #20 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A04017 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #21 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A03935 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>>
>> Note: selective self-test log revision number (0) not 1 implies that
>> no selective self-test has ever been run
>> SMART Selective self-test log data structure revision number 0
>> Note: revision number not 1 implies that no selective self-test has
>> ever been run
>> =C2=A0SPAN =C2=A0MIN_LBA =C2=A0MAX_LBA =C2=A0CURRENT_TEST_STATUS
>> =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0Interrupted [50% left] (0-65535)
>> =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0Not_testing
>> =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0Not_testing
>> =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0Not_testing
>> =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0Not_testing
>> Selective self-test flags (0x0):
>> =C2=A0After scanning selected spans, do NOT read-scan remainder of d=
isk.
>> If Selective self-test is pending on power-up, resume after 0 minute=
 delay.
>>
>>
>> It has 6 pending sectors. Why are they not reallocated? Can I force
>> this somehow? (a scrub did not reallocate them) Is this enough to
>> replace the HDD?
>>
>> Thanks,
>> Mathias
>>
>
> Uh oh, I did another scrub, and here's the status:
>
> DEV =C2=A0 =C2=A0 EVENTS =C2=A0REALL =C2=A0 PEND =C2=A0 =C2=A0UNCORR =
=C2=A0CRC =C2=A0 =C2=A0 RAW =C2=A0 =C2=A0 ZONE =C2=A0 =C2=A0END
> sdb1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0 =C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0
> sdc1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0
> sdd1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0
> sde1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 1
> sdf1 =C2=A0 =C2=A06158768 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 47 =C2=A0 =C2=A0 =C2=A06
> sdg1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0
> sdh1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0=
 1 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 341 =C2=A0 =C2=A0 3
>
>
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdh1[6] sdg1[0] sdf1[5] sde1[7] sdd1[4] sdb1[1] sd=
c1[3]
> =C2=A0 =C2=A0 =C2=A09751756800 blocks super 1.2 level 6, 64k chunk, a=
lgorithm 2
> [7/7] [UUUUUUU]
>
> unused devices: <none>
>
>
> /dev/md0:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 1.2
> =C2=A0Creation Time : Tue Oct 19 08:58:41 2010
> =C2=A0 =C2=A0 Raid Level : raid6
> =C2=A0 =C2=A0 Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
> =C2=A0Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
> =C2=A0 Raid Devices : 7
> =C2=A0Total Devices : 7
> =C2=A0 =C2=A0Persistence : Superblock is persistent
>
> =C2=A0 =C2=A0Update Time : Sun Jul 31 18:51:58 2011
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
> =C2=A0Active Devices : 7
> Working Devices : 7
> =C2=A0Failed Devices : 0
> =C2=A0Spare Devices : 0
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
> =C2=A0 =C2=A0 Chunk Size : 64K
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Name : ion:0 =C2=A0(local to host =
ion)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : e6595c64:b3ae90b3:f01133ac:=
3f402d20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 6158767
>
> =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
> =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 97=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdg1
> =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 17=
 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdb1
> =C2=A0 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 49=
 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdd1
> =C2=A0 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 33=
 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdc1
> =C2=A0 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 81=
 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdf1
> =C2=A0 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0113=
 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdh1
> =C2=A0 =C2=A0 =C2=A0 7 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 65=
 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sde1
>
> smartctl 5.41 2011-06-09 r3365 [x86_64-linux-2.6.39-ck] (local build)
> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforg=
e.net
>
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family: =C2=A0 =C2=A0 SAMSUNG SpinPoint F4 EG (AFT)
> Device Model: =C2=A0 =C2=A0 SAMSUNG HD204UI
> Serial Number: =C2=A0 =C2=A0S2HGJ1RZ800850
> LU WWN Device Id: 5 0024e9 003f1ebc9
> Firmware Version: 1AQ10003
> User Capacity: =C2=A0 =C2=A02,000,398,934,016 bytes [2.00 TB]
> Sector Size: =C2=A0 =C2=A0 =C2=A0512 bytes logical/physical
> Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0In smartctl database [for detai=
ls use: -P show]
> ATA Version is: =C2=A0 8
> ATA Standard is: =C2=A0ATA-8-ACS revision 6
> Local Time is: =C2=A0 =C2=A0Sun Jul 31 18:51:59 2011 IST
>
> =3D=3D> WARNING: Using smartmontools or hdparm with this
> drive may result in data loss due to a firmware bug.
> ****** THIS DRIVE MAY OR MAY NOT BE AFFECTED! ******
> Buggy and fixed firmware report same version number!
> See the following web pages for details:
> http://www.samsung.com/global/business/hdd/faqView.do?b2b_bbs_msg_id=3D=
386
> http://sourceforge.net/apps/trac/smartmontools/wiki/SamsungF4EGBadBlo=
cks
>
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
>
> General SMART Values:
> Offline data collection status: =C2=A0(0x80) Offline data collection =
activity
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0w=
as never started.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
uto Offline Data Collection: Enabled.
> Self-test execution status: =C2=A0 =C2=A0 =C2=A0( 118) The previous s=
elf-test completed having
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0t=
he read element of the test failed.
> Total time to complete Offline
> data collection: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0(20640) seconds.
> Offline data collection
> capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0(0x5b) SMART execute Offline immediate.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
uto Offline data collection on/off support.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
uspend Offline collection upon new
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c=
ommand.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0O=
ffline surface scan supported.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
elf-test supported.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0N=
o Conveyance Self-test supported.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
elective Self-test supported.
> SMART capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x0003)=
 Saves SMART data before entering
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p=
ower-saving mode.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
upports SMART auto save timer.
> Error logging capability: =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x01) Error log=
ging supported.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0G=
eneral Purpose Logging supported.
> Short self-test routine
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( =C2=A0 2) minu=
tes.
> Extended self-test routine
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( 255) minutes.
> SCT capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x=
003f) SCT Status supported.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
CT Error Recovery Control supported.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
CT Feature Control supported.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
CT Data Table supported.
>
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FLAG =C2=A0 =C2=A0=
 VALUE WORST THRESH TYPE
> UPDATED =C2=A0WHEN_FAILED RAW_VALUE
> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x002f =C2=A0 100 =C2=A0 10=
0 =C2=A0 051 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 341
> =C2=A02 Throughput_Performance =C2=A00x0026 =C2=A0 055 =C2=A0 053 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 18989
> =C2=A03 Spin_Up_Time =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0023 =
=C2=A0 067 =C2=A0 044 =C2=A0 025 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 10165
> =C2=A04 Start_Stop_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100=
 =C2=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 18
> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 252 =C2=A0 252 =C2=
=A0 010 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A07 Seek_Error_Rate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x002e =C2=A0 252=
 =C2=A0 252 =C2=A0 051 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A08 Seek_Time_Performance =C2=A0 0x0024 =C2=A0 252 =C2=A0 252 =C2=
=A0 015 =C2=A0 =C2=A0Old_age
> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> =C2=A09 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 100 =C2=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 6452
> =C2=A010 Spin_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 25=
2 =C2=A0 252 =C2=A0 051 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A011 Calibration_Retry_Count 0x0032 =C2=A0 252 =C2=A0 252 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A012 Power_Cycle_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 20
> 181 Program_Fail_Cnt_Total =C2=A00x0022 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 10121757
> 191 G-Sense_Error_Rate =C2=A0 =C2=A0 =C2=A00x0022 =C2=A0 100 =C2=A0 1=
00 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 1
> 192 Power-Off_Retract_Count 0x0022 =C2=A0 252 =C2=A0 252 =C2=A0 000 =C2=
=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0002 =C2=A0 064 =C2=A0 057 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 31 (Min/Max 16/43)
> 195 Hardware_ECC_Recovered =C2=A00x003a =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 196 Reallocated_Event_Count 0x0032 =C2=A0 252 =C2=A0 252 =C2=A0 000 =C2=
=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 197 Current_Pending_Sector =C2=A00x0032 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 8
> 198 Offline_Uncorrectable =C2=A0 0x0030 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 1
> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x0036 =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 200 Multi_Zone_Error_Rate =C2=A0 0x002a =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 3
> 223 Load_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 252 =C2=
=A0 252 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 225 Load_Cycle_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 21
>
> SMART Error Log Version: 1
> No Errors Logged
>
> SMART Self-test log structure revision number 1
> Num =C2=A0Test_Description =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining
> LifeTime(hours) =C2=A0LBA_of_first_error
> # 1 =C2=A0Extended offline =C2=A0 =C2=A0Completed: read failure =C2=A0=
 =C2=A0 =C2=A0 60% =C2=A0 =C2=A0 =C2=A06452
> =C2=A0 =C2=A0 =C2=A01519520304
> # 2 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=A0=
 =C2=A0 =C2=A050% =C2=A0 =C2=A0 =C2=A06408 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
-
> # 3 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06317 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> # 4 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06260 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> # 5 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06232 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> # 6 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06170 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> # 7 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06064 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> # 8 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06029 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> # 9 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05898 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #10 =C2=A0Extended offline =C2=A0 =C2=A0Aborted by host =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 60% =C2=A0 =C2=A0 =C2=A05893 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 -
> #11 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05728 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #12 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05706 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #13 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=A0=
 =C2=A0 =C2=A040% =C2=A0 =C2=A0 =C2=A05701 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
-
> #14 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=A0=
 =C2=A0 =C2=A090% =C2=A0 =C2=A0 =C2=A05666 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
-
> #15 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05560 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #16 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05527 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #17 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05392 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #18 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05357 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #19 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05250 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #20 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A04272 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #21 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A04017 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>
> Note: selective self-test log revision number (0) not 1 implies that
> no selective self-test has ever been run
> SMART Selective self-test log data structure revision number 0
> Note: revision number not 1 implies that no selective self-test has
> ever been run
> =C2=A0SPAN =C2=A0MIN_LBA =C2=A0MAX_LBA =C2=A0CURRENT_TEST_STATUS
> =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0 =C2=A0Completed_read_failure [60% left] (0-65535)
> =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0 =C2=A0Not_testing
> =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0 =C2=A0Not_testing
> =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0 =C2=A0Not_testing
> =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0 =C2=A0Not_testing
> Selective self-test flags (0x0):
> =C2=A0After scanning selected spans, do NOT read-scan remainder of di=
sk.
> If Selective self-test is pending on power-up, resume after 0 minute =
delay.
>
> :( I do have a bad HDD. RMA is already in progress, I need to take ou=
t
> the drive and ship it to Samsung in Holland. Will print labels at wor=
k
> on Tuesday.
>
> Questions:
>
> * How do I remove this HDD without causing damage to the array? Is
> this the correct way?:
> mdadm --manage /dev/md0 --fail /dev/sdh1 # fail the device
> mdadm --manage /dev/md0 --remove /dev/sdh1 # remove the device
> * (shut down the system gracefully)
> * (remove the HDD)
> * (install new HDD)
> * (start system)
> sfdisk -d /dev/sde | sfdisk /dev/sdh # partition the new HDD
> mdadm --manage /dev/md0 --add /dev/sdh1 # add the partition to the ar=
ray
>
> * After removing the HDD, should I do another scrub?
>
> Thanks a lot in advance!
>
> /Mathias
>

I think I need to hurry up:

[13957.348692] ata10.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0=
x6 frozen
[13957.348704] ata10.00: failed command: READ FPDMA QUEUED
[13957.348716] ata10.00: cmd 60/08:00:00:ab:5a/00:00:e1:00:00/40 tag 0
ncq 4096 in
[13957.348719]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[13957.348724] ata10.00: status: { DRDY }
[13957.348730] ata10.00: failed command: WRITE FPDMA QUEUED
[13957.348741] ata10.00: cmd 61/08:08:a8:e7:8d/00:00:2e:00:00/40 tag 1
ncq 4096 out
[13957.348743]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[13957.348749] ata10.00: status: { DRDY }
[13957.348759] ata10: hard resetting link
[13962.835319] ata10: link is slow to respond, please be patient (ready=
=3D0)
[13967.368679] ata10: SRST failed (errno=3D-16)
[13967.368693] ata10: hard resetting link
[13970.988699] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[13971.002394] ata10.00: configured for UDMA/133
[13971.002407] ata10.00: device reported invalid CHS sector 0
[13971.002413] ata10.00: device reported invalid CHS sector 0
[13971.002427] ata10: EH complete
[14001.358848] ata10.00: exception Emask 0x0 SAct 0x2 SErr 0x0 action 0=
x6 frozen
[14001.358862] ata10.00: failed command: READ FPDMA QUEUED
[14001.358887] ata10.00: cmd 60/08:08:00:ab:5a/00:00:e1:00:00/40 tag 1
ncq 4096 in
[14001.358890]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[14001.358898] ata10.00: status: { DRDY }
[14001.358913] ata10: hard resetting link
[14006.845324] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14011.378656] ata10: SRST failed (errno=3D-16)
[14011.378669] ata10: hard resetting link
[14016.865323] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14021.398640] ata10: SRST failed (errno=3D-16)
[14021.398652] ata10: hard resetting link
[14026.885310] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14029.925349] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[14029.939048] ata10.00: configured for UDMA/133
[14029.939061] ata10.00: device reported invalid CHS sector 0
[14029.939078] ata10: EH complete
[14060.345358] ata10.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0=
x6 frozen
[14060.345371] ata10.00: failed command: READ FPDMA QUEUED
[14060.345384] ata10.00: cmd 60/08:00:00:ab:5a/00:00:e1:00:00/40 tag 0
ncq 4096 in
[14060.345387]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[14060.345394] ata10.00: status: { DRDY }
[14060.345407] ata10: hard resetting link
[14065.831985] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14070.365333] ata10: SRST failed (errno=3D-16)
[14070.365345] ata10: hard resetting link
[14074.625347] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[14074.639043] ata10.00: configured for UDMA/133
[14074.639056] ata10.00: device reported invalid CHS sector 0
[14074.639088] ata10: EH complete
[14105.358687] ata10.00: NCQ disabled due to excessive errors
[14105.358700] ata10.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0=
x6 frozen
[14105.358712] ata10.00: failed command: READ FPDMA QUEUED
[14105.358729] ata10.00: cmd 60/08:00:00:ab:5a/00:00:e1:00:00/40 tag 0
ncq 4096 in
[14105.358732]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[14105.358741] ata10.00: status: { DRDY }
[14105.358754] ata10: hard resetting link
[14110.845314] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14115.378674] ata10: SRST failed (errno=3D-16)
[14115.378689] ata10: hard resetting link
[14119.372023] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[14119.385704] ata10.00: configured for UDMA/133
[14119.385716] ata10.00: device reported invalid CHS sector 0
[14119.385743] ata10: EH complete
[14121.527814] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0=
x6
[14121.527824] ata10.00: edma_err_cause=3D00000084 pp_flags=3D00000001,
dev error, EDMA self-disable
[14121.527832] ata10.00: failed command: READ DMA EXT
[14121.527844] ata10.00: cmd 25/00:08:00:ab:5a/00:00:e1:00:00/e0 tag 0
dma 4096 in
[14121.527846]          res 51/89:08:00:ab:5a/89:00:e1:00:00/e0 Emask
0x10 (ATA bus error)
[14121.527852] ata10.00: status: { DRDY ERR }
[14121.527857] ata10.00: error: { ICRC }
[14121.527867] ata10: hard resetting link
[14127.011973] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14131.545295] ata10: SRST failed (errno=3D-16)
[14131.545307] ata10: hard resetting link
[14137.031984] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14141.565306] ata10: SRST failed (errno=3D-16)
[14141.565317] ata10: hard resetting link
[14147.051993] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14161.032035] INFO: task jbd2/dm-0-8:613 blocked for more than 120 sec=
onds.
[14161.032044] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[14161.032050] jbd2/dm-0-8     D ffffffff81823020     0   613      2 0x=
00000000
[14161.032060]  ffff8800c91e11a0 0000000000000046 0000000000000000
ffff8800cf0697c0
[14161.032070]  ffff8800cf069780 ffff8800cf069780 ffff8800c93bdfd8
ffff8800c93bdfd8
[14161.032079]  ffff8800c91e13d8 0000000000004000 ffff880094ed19c0
ffff8800c97e0688
[14161.032087] Call Trace:
[14161.032106]  [<ffffffff81204c67>] ? generic_make_request+0x2f7/0x570
[14161.032116]  [<ffffffff81133200>] ? __wait_on_buffer+0x30/0x30
[14161.032124]  [<ffffffff814262e7>] ? io_schedule+0x57/0x80
[14161.032131]  [<ffffffff8113320a>] ? sleep_on_buffer+0xa/0x20
[14161.032137]  [<ffffffff81426a2f>] ? __wait_on_bit+0x4f/0x80
[14161.032143]  [<ffffffff81133200>] ? __wait_on_buffer+0x30/0x30
[14161.032150]  [<ffffffff81426add>] ? out_of_line_wait_on_bit+0x7d/0xa=
0
[14161.032159]  [<ffffffff81059300>] ? autoremove_wake_function+0x30/0x=
30
[14161.032168]  [<ffffffff811b680e>] ?
jbd2_journal_commit_transaction+0x155e/0x16f0
[14161.032176]  [<ffffffff810592d0>] ? abort_exclusive_wait+0xb0/0xb0
[14161.032183]  [<ffffffff8142968e>] ? apic_timer_interrupt+0xe/0x20
[14161.032191]  [<ffffffff811baddd>] ? kjournald2+0xad/0x210
[14161.032198]  [<ffffffff810592d0>] ? abort_exclusive_wait+0xb0/0xb0
[14161.032205]  [<ffffffff811bad30>] ? commit_timeout+0x10/0x10
[14161.032212]  [<ffffffff81058a0f>] ? kthread+0x7f/0x90
[14161.032219]  [<ffffffff81429a54>] ? kernel_thread_helper+0x4/0x10
[14161.032226]  [<ffffffff81058990>] ? kthread_worker_fn+0x180/0x180
[14161.032233]  [<ffffffff81429a50>] ? gs_change+0xb/0xb
[14161.032261] INFO: task squid:1659 blocked for more than 120 seconds.
[14161.032264] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[14161.032269] squid           D ffffffff81823020     0  1659   1657 0x=
00000000
[14161.032277]  ffff8800c9179d60 0000000000000082 ffff8800c97b0688
ffffffff812bf074
[14161.032285]  ffff880012b818c0 ffffffff81823020 ffff8800c22c5fd8
ffff8800c22c5fd8
[14161.032293]  ffff8800c9179f98 0000000000004000 ffff8800c22c5fd8
0000000000000000
[14161.032301] Call Trace:


:-/

Currently shutting down all daemons that access the filesystem on the
array, in attempt to umount the fs.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
