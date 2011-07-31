From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Do I have a bad HDD?
Date: Sun, 31 Jul 2011 19:14:21 +0100
Message-ID: <CADNH=7F3CVZ6r56jFrSHoVyzOZTHCfXPE_j-Rn8powbB6BLBYQ@mail.gmail.com>
References: <CADNH=7HDCwtUr-HSN7fH_GSH8jTYb-SAwmKY0ZRn3opWAhKiBQ@mail.gmail.com>
	<CADNH=7EJ7tvw2DEsAbeuxxRO1k961RSV4axgvfRUBaKG+Q455Q@mail.gmail.com>
	<CADNH=7EHAyk7Z7Wa72XO=p1od6AQP5aew_W5DffgLfZeCu=d-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7EHAyk7Z7Wa72XO=p1od6AQP5aew_W5DffgLfZeCu=d-g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31 July 2011 19:05, Mathias Bur=C3=A9n <mathias.buren@gmail.com> wro=
te:
> On 31 July 2011 18:59, Mathias Bur=C3=A9n <mathias.buren@gmail.com> w=
rote:
>> On 31 July 2011 14:05, Mathias Bur=C3=A9n <mathias.buren@gmail.com> =
wrote:
>>> Hi list,
>>>
>>> Here's the output of my weekly script:
>>>
>>> DEV =C2=A0 =C2=A0 EVENTS =C2=A0REALL =C2=A0 PEND =C2=A0 =C2=A0UNCOR=
R =C2=A0CRC =C2=A0 =C2=A0 RAW =C2=A0 =C2=A0 ZONE =C2=A0 =C2=A0END
>>> sdb1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0
>>> sdc1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0
>>> sdd1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0
>>> sde1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 1
>>> sdf1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 47 =C2=A0 =C2=A0 =C2=A0=
6
>>> sdg1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0
>>> sdh1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 340 =C2=A0 =C2=A0 3
>>>
>>>
>>> Personalities : [raid6] [raid5] [raid4]
>>> md0 : active raid6 sdf1[5] sdh1[6] sdg1[0] sde1[7] sdc1[3] sdd1[4] =
sdb1[1]
>>> =C2=A0 =C2=A0 =C2=A09751756800 blocks super 1.2 level 6, 64k chunk,=
 algorithm 2
>>> [7/7] [UUUUUUU]
>>>
>>> unused devices: <none>
>>>
>>>
>>> /dev/md0:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 1.2
>>> =C2=A0Creation Time : Tue Oct 19 08:58:41 2010
>>> =C2=A0 =C2=A0 Raid Level : raid6
>>> =C2=A0 =C2=A0 Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
>>> =C2=A0Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
>>> =C2=A0 Raid Devices : 7
>>> =C2=A0Total Devices : 7
>>> =C2=A0 =C2=A0Persistence : Superblock is persistent
>>>
>>> =C2=A0 =C2=A0Update Time : Sun Jul 31 09:50:43 2011
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>>> =C2=A0Active Devices : 7
>>> Working Devices : 7
>>> =C2=A0Failed Devices : 0
>>> =C2=A0Spare Devices : 0
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
>>> =C2=A0 =C2=A0 Chunk Size : 64K
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Name : ion:0 =C2=A0(local to hos=
t ion)
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : e6595c64:b3ae90b3:f01133a=
c:3f402d20
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 6158767
>>>
>>> =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice Sta=
te
>>> =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
97 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdg1
>>> =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
17 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdb1
>>> =C2=A0 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
49 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdd1
>>> =C2=A0 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
33 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdc1
>>> =C2=A0 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
81 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdf1
>>> =C2=A0 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A01=
13 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sdh1
>>> =C2=A0 =C2=A0 =C2=A0 7 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
65 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 =
/dev/sde1
>>>
>>> Here's the SMART data for sdh:
>>>
>>>
>>> smartctl 5.41 2011-06-09 r3365 [x86_64-linux-2.6.39-ck] (local buil=
d)
>>> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourcefo=
rge.net
>>>
>>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
>>> Model Family: =C2=A0 =C2=A0 SAMSUNG SpinPoint F4 EG (AFT)
>>> Device Model: =C2=A0 =C2=A0 SAMSUNG HD204UI
>>> Serial Number: =C2=A0 =C2=A0S2HGJ1RZ800850
>>> LU WWN Device Id: 5 0024e9 003f1ebc9
>>> Firmware Version: 1AQ10003
>>> User Capacity: =C2=A0 =C2=A02,000,398,934,016 bytes [2.00 TB]
>>> Sector Size: =C2=A0 =C2=A0 =C2=A0512 bytes logical/physical
>>> Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0In smartctl database [for det=
ails use: -P show]
>>> ATA Version is: =C2=A0 8
>>> ATA Standard is: =C2=A0ATA-8-ACS revision 6
>>> Local Time is: =C2=A0 =C2=A0Sun Jul 31 14:03:32 2011 IST
>>>
>>> =3D=3D> WARNING: Using smartmontools or hdparm with this
>>> drive may result in data loss due to a firmware bug.
>>> ****** THIS DRIVE MAY OR MAY NOT BE AFFECTED! ******
>>> Buggy and fixed firmware report same version number!
>>> See the following web pages for details:
>>> http://www.samsung.com/global/business/hdd/faqView.do?b2b_bbs_msg_i=
d=3D386
>>> http://sourceforge.net/apps/trac/smartmontools/wiki/SamsungF4EGBadB=
locks
>>>
>>> SMART support is: Available - device has SMART capability.
>>> SMART support is: Enabled
>>>
>>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
>>> SMART overall-health self-assessment test result: PASSED
>>>
>>> General SMART Values:
>>> Offline data collection status: =C2=A0(0x82) Offline data collectio=
n activity
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0w=
as completed without error.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
uto Offline Data Collection: Enabled.
>>> Self-test execution status: =C2=A0 =C2=A0 =C2=A0( =C2=A037) The sel=
f-test routine was interrupted
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b=
y the host with a hard or soft reset.
>>> Total time to complete Offline
>>> data collection: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0(20640) seconds.
>>> Offline data collection
>>> capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0(0x5b) SMART execute Offline immediate.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
uto Offline data collection on/off support.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
uspend Offline collection upon new
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c=
ommand.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0O=
ffline surface scan supported.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
elf-test supported.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0N=
o Conveyance Self-test supported.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
elective Self-test supported.
>>> SMART capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x000=
3) Saves SMART data before entering
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p=
ower-saving mode.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
upports SMART auto save timer.
>>> Error logging capability: =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x01) Error l=
ogging supported.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0G=
eneral Purpose Logging supported.
>>> Short self-test routine
>>> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( =C2=A0 2) mi=
nutes.
>>> Extended self-test routine
>>> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( 255) minutes=
=2E
>>> SCT capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(=
0x003f) SCT Status supported.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
CT Error Recovery Control supported.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
CT Feature Control supported.
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
CT Data Table supported.
>>>
>>> SMART Attributes Data Structure revision number: 16
>>> Vendor Specific SMART Attributes with Thresholds:
>>> ID# ATTRIBUTE_NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FLAG =C2=A0 =C2=
=A0 VALUE WORST THRESH TYPE
>>> UPDATED =C2=A0WHEN_FAILED RAW_VALUE
>>> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x002f =C2=A0 100 =C2=A0 =
100 =C2=A0 051 =C2=A0 =C2=A0Pre-fail
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 340
>>> =C2=A02 Throughput_Performance =C2=A00x0026 =C2=A0 055 =C2=A0 053 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 18989
>>> =C2=A03 Spin_Up_Time =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x002=
3 =C2=A0 067 =C2=A0 044 =C2=A0 025 =C2=A0 =C2=A0Pre-fail
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 10165
>>> =C2=A04 Start_Stop_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 1=
00 =C2=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 18
>>> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 252 =C2=A0 252 =C2=
=A0 010 =C2=A0 =C2=A0Pre-fail
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>>> =C2=A07 Seek_Error_Rate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x002e =C2=A0 2=
52 =C2=A0 252 =C2=A0 051 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>>> =C2=A08 Seek_Time_Performance =C2=A0 0x0024 =C2=A0 252 =C2=A0 252 =C2=
=A0 015 =C2=A0 =C2=A0Old_age
>>> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>>> =C2=A09 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=
=A0 100 =C2=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 6447
>>> =C2=A010 Spin_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 =
252 =C2=A0 252 =C2=A0 051 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>>> =C2=A011 Calibration_Retry_Count 0x0032 =C2=A0 252 =C2=A0 252 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>>> =C2=A012 Power_Cycle_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 20
>>> 181 Program_Fail_Cnt_Total =C2=A00x0022 =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 10117271
>>> 191 G-Sense_Error_Rate =C2=A0 =C2=A0 =C2=A00x0022 =C2=A0 100 =C2=A0=
 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 1
>>> 192 Power-Off_Retract_Count 0x0022 =C2=A0 252 =C2=A0 252 =C2=A0 000=
 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>>> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0002 =C2=A0 064 =C2=A0 057 =
=C2=A0 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 35 (Min/Max 16/4=
3)
>>> 195 Hardware_ECC_Recovered =C2=A00x003a =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>>> 196 Reallocated_Event_Count 0x0032 =C2=A0 252 =C2=A0 252 =C2=A0 000=
 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>>> 197 Current_Pending_Sector =C2=A00x0032 =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 6
>>> 198 Offline_Uncorrectable =C2=A0 0x0030 =C2=A0 252 =C2=A0 252 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>>> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>>> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x0036 =C2=A0 200 =C2=A0 200 =
=C2=A0 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>>> 200 Multi_Zone_Error_Rate =C2=A0 0x002a =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 3
>>> 223 Load_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 252 =C2=
=A0 252 =C2=A0 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>>> 225 Load_Cycle_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
>>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 21
>>>
>>> SMART Error Log Version: 1
>>> No Errors Logged
>>>
>>> SMART Self-test log structure revision number 1
>>> Num =C2=A0Test_Description =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining
>>> LifeTime(hours) =C2=A0LBA_of_first_error
>>> # 1 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=
=A0 =C2=A0 =C2=A050% =C2=A0 =C2=A0 =C2=A06408 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>>> # 2 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06317 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> # 3 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06260 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> # 4 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06232 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> # 5 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06170 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> # 6 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06064 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> # 7 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06029 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> # 8 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05898 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> # 9 =C2=A0Extended offline =C2=A0 =C2=A0Aborted by host =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 60% =C2=A0 =C2=A0 =C2=A05893 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 -
>>> #10 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05728 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> #11 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05706 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> #12 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=
=A0 =C2=A0 =C2=A040% =C2=A0 =C2=A0 =C2=A05701 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>>> #13 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=
=A0 =C2=A0 =C2=A090% =C2=A0 =C2=A0 =C2=A05666 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>>> #14 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05560 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> #15 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05527 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> #16 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05392 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> #17 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05357 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> #18 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05250 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> #19 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A04272 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> #20 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A04017 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>> #21 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=
=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A03935 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 -
>>>
>>> Note: selective self-test log revision number (0) not 1 implies tha=
t
>>> no selective self-test has ever been run
>>> SMART Selective self-test log data structure revision number 0
>>> Note: revision number not 1 implies that no selective self-test has
>>> ever been run
>>> =C2=A0SPAN =C2=A0MIN_LBA =C2=A0MAX_LBA =C2=A0CURRENT_TEST_STATUS
>>> =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0Interrupted [50% left] (0-65535)
>>> =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0Not_testing
>>> =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0Not_testing
>>> =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0Not_testing
>>> =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0Not_testing
>>> Selective self-test flags (0x0):
>>> =C2=A0After scanning selected spans, do NOT read-scan remainder of =
disk.
>>> If Selective self-test is pending on power-up, resume after 0 minut=
e delay.
>>>
>>>
>>> It has 6 pending sectors. Why are they not reallocated? Can I force
>>> this somehow? (a scrub did not reallocate them) Is this enough to
>>> replace the HDD?
>>>
>>> Thanks,
>>> Mathias
>>>
>>
>> Uh oh, I did another scrub, and here's the status:
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
>> sdf1 =C2=A0 =C2=A06158768 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 47 =C2=A0 =C2=A0 =C2=A0=
6
>> sdg1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0
>> sdh1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 1 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 341 =C2=A0 =C2=A0 3
>>
>>
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid6 sdh1[6] sdg1[0] sdf1[5] sde1[7] sdd1[4] sdb1[1] s=
dc1[3]
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
>> =C2=A0 =C2=A0Update Time : Sun Jul 31 18:51:58 2011
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
>> Local Time is: =C2=A0 =C2=A0Sun Jul 31 18:51:59 2011 IST
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
>> Offline data collection status: =C2=A0(0x80) Offline data collection=
 activity
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0w=
as never started.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
uto Offline Data Collection: Enabled.
>> Self-test execution status: =C2=A0 =C2=A0 =C2=A0( 118) The previous =
self-test completed having
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0t=
he read element of the test failed.
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
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 341
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
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 6452
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
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 10121757
>> 191 G-Sense_Error_Rate =C2=A0 =C2=A0 =C2=A00x0022 =C2=A0 100 =C2=A0 =
100 =C2=A0 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 1
>> 192 Power-Off_Retract_Count 0x0022 =C2=A0 252 =C2=A0 252 =C2=A0 000 =
=C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0002 =C2=A0 064 =C2=A0 057 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 31 (Min/Max 16/43=
)
>> 195 Hardware_ECC_Recovered =C2=A00x003a =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>> 196 Reallocated_Event_Count 0x0032 =C2=A0 252 =C2=A0 252 =C2=A0 000 =
=C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>> 197 Current_Pending_Sector =C2=A00x0032 =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 8
>> 198 Offline_Uncorrectable =C2=A0 0x0030 =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 1
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
>> # 1 =C2=A0Extended offline =C2=A0 =C2=A0Completed: read failure =C2=A0=
 =C2=A0 =C2=A0 60% =C2=A0 =C2=A0 =C2=A06452
>> =C2=A0 =C2=A0 =C2=A01519520304
>> # 2 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=
=A0 =C2=A0 =C2=A050% =C2=A0 =C2=A0 =C2=A06408 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 3 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06317 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 4 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06260 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 5 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06232 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 6 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06170 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 7 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06064 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 8 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06029 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> # 9 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05898 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #10 =C2=A0Extended offline =C2=A0 =C2=A0Aborted by host =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 60% =C2=A0 =C2=A0 =C2=A05893 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 -
>> #11 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05728 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #12 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05706 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #13 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=
=A0 =C2=A0 =C2=A040% =C2=A0 =C2=A0 =C2=A05701 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #14 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=
=A0 =C2=A0 =C2=A090% =C2=A0 =C2=A0 =C2=A05666 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #15 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05560 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #16 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05527 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #17 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05392 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #18 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05357 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #19 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05250 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #20 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A04272 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>> #21 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A04017 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>>
>> Note: selective self-test log revision number (0) not 1 implies that
>> no selective self-test has ever been run
>> SMART Selective self-test log data structure revision number 0
>> Note: revision number not 1 implies that no selective self-test has
>> ever been run
>> =C2=A0SPAN =C2=A0MIN_LBA =C2=A0MAX_LBA =C2=A0CURRENT_TEST_STATUS
>> =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00 =C2=A0Completed_read_failure [60% left] (0-65535)
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
>> :( I do have a bad HDD. RMA is already in progress, I need to take o=
ut
>> the drive and ship it to Samsung in Holland. Will print labels at wo=
rk
>> on Tuesday.
>>
>> Questions:
>>
>> * How do I remove this HDD without causing damage to the array? Is
>> this the correct way?:
>> mdadm --manage /dev/md0 --fail /dev/sdh1 # fail the device
>> mdadm --manage /dev/md0 --remove /dev/sdh1 # remove the device
>> * (shut down the system gracefully)
>> * (remove the HDD)
>> * (install new HDD)
>> * (start system)
>> sfdisk -d /dev/sde | sfdisk /dev/sdh # partition the new HDD
>> mdadm --manage /dev/md0 --add /dev/sdh1 # add the partition to the a=
rray
>>
>> * After removing the HDD, should I do another scrub?
>>
>> Thanks a lot in advance!
>>
>> /Mathias
>>
>
> I think I need to hurry up:
>
> [13957.348692] ata10.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action=
 0x6 frozen
> [13957.348704] ata10.00: failed command: READ FPDMA QUEUED
> [13957.348716] ata10.00: cmd 60/08:00:00:ab:5a/00:00:e1:00:00/40 tag =
0
> ncq 4096 in
> [13957.348719] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res 40/00:00:00:4f:c=
2/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [13957.348724] ata10.00: status: { DRDY }
> [13957.348730] ata10.00: failed command: WRITE FPDMA QUEUED
> [13957.348741] ata10.00: cmd 61/08:08:a8:e7:8d/00:00:2e:00:00/40 tag =
1
> ncq 4096 out
> [13957.348743] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res 40/00:00:00:00:0=
0/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [13957.348749] ata10.00: status: { DRDY }
> [13957.348759] ata10: hard resetting link
> [13962.835319] ata10: link is slow to respond, please be patient (rea=
dy=3D0)
> [13967.368679] ata10: SRST failed (errno=3D-16)
> [13967.368693] ata10: hard resetting link
> [13970.988699] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300=
)
> [13971.002394] ata10.00: configured for UDMA/133
> [13971.002407] ata10.00: device reported invalid CHS sector 0
> [13971.002413] ata10.00: device reported invalid CHS sector 0
> [13971.002427] ata10: EH complete
> [14001.358848] ata10.00: exception Emask 0x0 SAct 0x2 SErr 0x0 action=
 0x6 frozen
> [14001.358862] ata10.00: failed command: READ FPDMA QUEUED
> [14001.358887] ata10.00: cmd 60/08:08:00:ab:5a/00:00:e1:00:00/40 tag =
1
> ncq 4096 in
> [14001.358890] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res 40/00:00:00:00:0=
0/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [14001.358898] ata10.00: status: { DRDY }
> [14001.358913] ata10: hard resetting link
> [14006.845324] ata10: link is slow to respond, please be patient (rea=
dy=3D0)
> [14011.378656] ata10: SRST failed (errno=3D-16)
> [14011.378669] ata10: hard resetting link
> [14016.865323] ata10: link is slow to respond, please be patient (rea=
dy=3D0)
> [14021.398640] ata10: SRST failed (errno=3D-16)
> [14021.398652] ata10: hard resetting link
> [14026.885310] ata10: link is slow to respond, please be patient (rea=
dy=3D0)
> [14029.925349] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300=
)
> [14029.939048] ata10.00: configured for UDMA/133
> [14029.939061] ata10.00: device reported invalid CHS sector 0
> [14029.939078] ata10: EH complete
> [14060.345358] ata10.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action=
 0x6 frozen
> [14060.345371] ata10.00: failed command: READ FPDMA QUEUED
> [14060.345384] ata10.00: cmd 60/08:00:00:ab:5a/00:00:e1:00:00/40 tag =
0
> ncq 4096 in
> [14060.345387] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res 40/00:00:00:4f:c=
2/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [14060.345394] ata10.00: status: { DRDY }
> [14060.345407] ata10: hard resetting link
> [14065.831985] ata10: link is slow to respond, please be patient (rea=
dy=3D0)
> [14070.365333] ata10: SRST failed (errno=3D-16)
> [14070.365345] ata10: hard resetting link
> [14074.625347] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300=
)
> [14074.639043] ata10.00: configured for UDMA/133
> [14074.639056] ata10.00: device reported invalid CHS sector 0
> [14074.639088] ata10: EH complete
> [14105.358687] ata10.00: NCQ disabled due to excessive errors
> [14105.358700] ata10.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action=
 0x6 frozen
> [14105.358712] ata10.00: failed command: READ FPDMA QUEUED
> [14105.358729] ata10.00: cmd 60/08:00:00:ab:5a/00:00:e1:00:00/40 tag =
0
> ncq 4096 in
> [14105.358732] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res 40/00:00:00:4f:c=
2/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [14105.358741] ata10.00: status: { DRDY }
> [14105.358754] ata10: hard resetting link
> [14110.845314] ata10: link is slow to respond, please be patient (rea=
dy=3D0)
> [14115.378674] ata10: SRST failed (errno=3D-16)
> [14115.378689] ata10: hard resetting link
> [14119.372023] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300=
)
> [14119.385704] ata10.00: configured for UDMA/133
> [14119.385716] ata10.00: device reported invalid CHS sector 0
> [14119.385743] ata10: EH complete
> [14121.527814] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action=
 0x6
> [14121.527824] ata10.00: edma_err_cause=3D00000084 pp_flags=3D0000000=
1,
> dev error, EDMA self-disable
> [14121.527832] ata10.00: failed command: READ DMA EXT
> [14121.527844] ata10.00: cmd 25/00:08:00:ab:5a/00:00:e1:00:00/e0 tag =
0
> dma 4096 in
> [14121.527846] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res 51/89:08:00:ab:5=
a/89:00:e1:00:00/e0 Emask
> 0x10 (ATA bus error)
> [14121.527852] ata10.00: status: { DRDY ERR }
> [14121.527857] ata10.00: error: { ICRC }
> [14121.527867] ata10: hard resetting link
> [14127.011973] ata10: link is slow to respond, please be patient (rea=
dy=3D0)
> [14131.545295] ata10: SRST failed (errno=3D-16)
> [14131.545307] ata10: hard resetting link
> [14137.031984] ata10: link is slow to respond, please be patient (rea=
dy=3D0)
> [14141.565306] ata10: SRST failed (errno=3D-16)
> [14141.565317] ata10: hard resetting link
> [14147.051993] ata10: link is slow to respond, please be patient (rea=
dy=3D0)
> [14161.032035] INFO: task jbd2/dm-0-8:613 blocked for more than 120 s=
econds.
> [14161.032044] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [14161.032050] jbd2/dm-0-8 =C2=A0 =C2=A0 D ffffffff81823020 =C2=A0 =C2=
=A0 0 =C2=A0 613 =C2=A0 =C2=A0 =C2=A02 0x00000000
> [14161.032060] =C2=A0ffff8800c91e11a0 0000000000000046 00000000000000=
00
> ffff8800cf0697c0
> [14161.032070] =C2=A0ffff8800cf069780 ffff8800cf069780 ffff8800c93bdf=
d8
> ffff8800c93bdfd8
> [14161.032079] =C2=A0ffff8800c91e13d8 0000000000004000 ffff880094ed19=
c0
> ffff8800c97e0688
> [14161.032087] Call Trace:
> [14161.032106] =C2=A0[<ffffffff81204c67>] ? generic_make_request+0x2f=
7/0x570
> [14161.032116] =C2=A0[<ffffffff81133200>] ? __wait_on_buffer+0x30/0x3=
0
> [14161.032124] =C2=A0[<ffffffff814262e7>] ? io_schedule+0x57/0x80
> [14161.032131] =C2=A0[<ffffffff8113320a>] ? sleep_on_buffer+0xa/0x20
> [14161.032137] =C2=A0[<ffffffff81426a2f>] ? __wait_on_bit+0x4f/0x80
> [14161.032143] =C2=A0[<ffffffff81133200>] ? __wait_on_buffer+0x30/0x3=
0
> [14161.032150] =C2=A0[<ffffffff81426add>] ? out_of_line_wait_on_bit+0=
x7d/0xa0
> [14161.032159] =C2=A0[<ffffffff81059300>] ? autoremove_wake_function+=
0x30/0x30
> [14161.032168] =C2=A0[<ffffffff811b680e>] ?
> jbd2_journal_commit_transaction+0x155e/0x16f0
> [14161.032176] =C2=A0[<ffffffff810592d0>] ? abort_exclusive_wait+0xb0=
/0xb0
> [14161.032183] =C2=A0[<ffffffff8142968e>] ? apic_timer_interrupt+0xe/=
0x20
> [14161.032191] =C2=A0[<ffffffff811baddd>] ? kjournald2+0xad/0x210
> [14161.032198] =C2=A0[<ffffffff810592d0>] ? abort_exclusive_wait+0xb0=
/0xb0
> [14161.032205] =C2=A0[<ffffffff811bad30>] ? commit_timeout+0x10/0x10
> [14161.032212] =C2=A0[<ffffffff81058a0f>] ? kthread+0x7f/0x90
> [14161.032219] =C2=A0[<ffffffff81429a54>] ? kernel_thread_helper+0x4/=
0x10
> [14161.032226] =C2=A0[<ffffffff81058990>] ? kthread_worker_fn+0x180/0=
x180
> [14161.032233] =C2=A0[<ffffffff81429a50>] ? gs_change+0xb/0xb
> [14161.032261] INFO: task squid:1659 blocked for more than 120 second=
s.
> [14161.032264] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [14161.032269] squid =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 D ffffffff818=
23020 =C2=A0 =C2=A0 0 =C2=A01659 =C2=A0 1657 0x00000000
> [14161.032277] =C2=A0ffff8800c9179d60 0000000000000082 ffff8800c97b06=
88
> ffffffff812bf074
> [14161.032285] =C2=A0ffff880012b818c0 ffffffff81823020 ffff8800c22c5f=
d8
> ffff8800c22c5fd8
> [14161.032293] =C2=A0ffff8800c9179f98 0000000000004000 ffff8800c22c5f=
d8
> 0000000000000000
> [14161.032301] Call Trace:
>
>
> :-/
>
> Currently shutting down all daemons that access the filesystem on the
> array, in attempt to umount the fs.
>

Sorry for spamming like this, it's happening in realtime. While I was
shutting down daemons it looks like MD took out the failing HDD
itself, see:

[14401.032600] INFO: task flush-253:0:25632 blocked for more than 120 s=
econds.
[14401.032604] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[14401.032608] flush-253:0     D ffffffff81823020     0 25632      2 0x=
00000000
[14401.032615]  ffff88003c02bac0 0000000000000046 ffffffff81425a7f
ffff8800cf06f5c0
[14401.032623]  ffff8800cf06f580 ffffffff81823020 ffff88001666ffd8
ffff88001666ffd8
[14401.032632]  ffff88003c02bcf8 0000000000004000 ffff88001666ffd8
ffff88003c02bd00
[14401.032639] Call Trace:
[14401.032645]  [<ffffffff81425a7f>] ? schedule+0x49f/0xcb0
[14401.032653]  [<ffffffff8105f465>] ? sched_clock_local+0x15/0x80
[14401.032662]  [<ffffffff81343287>] ? get_active_stripe+0x307/0x6f0
[14401.032669]  [<ffffffff81032ab0>] ? try_to_wake_up+0x210/0x210
[14401.032676]  [<ffffffff81346b38>] ? make_request+0x198/0x660
[14401.032683]  [<ffffffff8135b4fa>] ? __map_bio+0x4a/0x1d0
[14401.032690]  [<ffffffff810592d0>] ? abort_exclusive_wait+0xb0/0xb0
[14401.032697]  [<ffffffff8134d563>] ? md_make_request+0x103/0x250
[14401.032704]  [<ffffffff81204c67>] ? generic_make_request+0x2f7/0x570
[14401.032710]  [<ffffffff810f7399>] ? kmem_cache_alloc+0x169/0x180
[14401.032718]  [<ffffffff8135bff4>] ? dm_get_live_table+0x44/0x60
[14401.032724]  [<ffffffff81360225>] ? linear_merge+0x45/0x50
[14401.032731]  [<ffffffff81204f4d>] ? submit_bio+0x6d/0x100
[14401.032738]  [<ffffffff8118296c>] ? ext4_io_submit+0x1c/0x50
[14401.032744]  [<ffffffff81182ac1>] ? ext4_bio_write_page+0x121/0x370
[14401.032751]  [<ffffffff8117c137>] ? mpage_da_submit_io+0x347/0x450
[14401.032759]  [<ffffffff81180eae>] ? mpage_da_map_and_submit+0x1ce/0x=
420
[14401.032766]  [<ffffffff81181920>] ? ext4_da_writepages+0x340/0x620
[14401.032774]  [<ffffffff812071f7>] ? blk_flush_plug_list+0xa7/0x250
[14401.032782]  [<ffffffff8112c41e>] ? writeback_single_inode+0x10e/0x2=
70
[14401.032789]  [<ffffffff8112c801>] ? writeback_sb_inodes+0xf1/0x1b0
[14401.032796]  [<ffffffff814297ee>] ? reschedule_interrupt+0xe/0x20
[14401.032803]  [<ffffffff8112d36b>] ? writeback_inodes_wb+0x7b/0x150
[14401.032810]  [<ffffffff8112d8d3>] ? wb_writeback+0x493/0x4f0
[14401.032818]  [<ffffffff8111fec2>] ? get_nr_inodes+0x42/0x60
[14401.032825]  [<ffffffff8112d9c7>] ? wb_check_old_data_flush+0x97/0xa=
0
[14401.032832]  [<ffffffff8112db3f>] ? wb_do_writeback+0x16f/0x210
[14401.032839]  [<ffffffff81046dd0>] ? init_timer_deferrable_key+0x10/0=
x10
[14401.032846]  [<ffffffff8112dc5b>] ? bdi_writeback_thread+0x7b/0x310
[14401.032852]  [<ffffffff8102d149>] ? __wake_up_common+0x49/0x80
[14401.032860]  [<ffffffff8112dbe0>] ? wb_do_writeback+0x210/0x210
[14401.032866]  [<ffffffff81058a0f>] ? kthread+0x7f/0x90
[14401.032873]  [<ffffffff81429a54>] ? kernel_thread_helper+0x4/0x10
[14401.032880]  [<ffffffff81058990>] ? kthread_worker_fn+0x180/0x180
[14401.032887]  [<ffffffff81429a50>] ? gs_change+0xb/0xb
[14404.915260] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14409.448594] ata10: SRST failed (errno=3D-16)
[14409.448604] ata10: hard resetting link
[14414.935260] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14431.895309] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[14431.909004] ata10.00: configured for UDMA/33
[14431.909026] ata10: EH complete
[14434.040581] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0=
x6
[14434.040589] ata10.00: edma_err_cause=3D00000084 pp_flags=3D00000001,
dev error, EDMA self-disable
[14434.040597] ata10.00: failed command: READ DMA EXT
[14434.040609] ata10.00: cmd 25/00:08:10:e0:59/00:00:b2:00:00/e0 tag 0
dma 4096 in
[14434.040612]          res 51/89:08:10:e0:59/89:00:b2:00:00/e0 Emask
0x10 (ATA bus error)
[14434.040617] ata10.00: status: { DRDY ERR }
[14434.040622] ata10.00: error: { ICRC }
[14434.040631] ata10: hard resetting link
[14439.525256] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14444.058589] ata10: SRST failed (errno=3D-16)
[14444.058600] ata10: hard resetting link
[14449.545254] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14454.078594] ata10: SRST failed (errno=3D-16)
[14454.078604] ata10: hard resetting link
[14459.565256] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14476.525289] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[14476.579007] ata10.00: configured for UDMA/33
[14476.579038] sd 9:0:0:0: [sdh] Device not ready
[14476.579043] sd 9:0:0:0: [sdh]  Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[14476.579049] sd 9:0:0:0: [sdh]  Sense Key : Not Ready [current] [desc=
riptor]
[14476.579057] Descriptor sense data with sense descriptors (in hex):
[14476.579061]         72 02 04 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[14476.579076]         b2 59 e0 10
[14476.579083] sd 9:0:0:0: [sdh]  Add. Sense: Logical unit not ready,
cause not reportable
[14476.579091] sd 9:0:0:0: [sdh] CDB: Read(10): 28 00 b2 59 e0 10 00 00=
 08 00
[14476.579106] end_request: I/O error, dev sdh, sector 2992234512
[14476.579147] ata10: EH complete
[14484.352060] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0=
x6 frozen
[14484.352070] ata10.00: failed command: SMART
[14484.352082] ata10.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[14484.352084]          res 40/00:08:10:e0:59/89:00:b2:00:00/e0 Emask
0x4 (timeout)
[14484.352090] ata10.00: status: { DRDY }
[14484.352099] ata10: hard resetting link
[14489.838590] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14494.371940] ata10: SRST failed (errno=3D-16)
[14494.371951] ata10: hard resetting link
[14499.858587] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14504.391923] ata10: SRST failed (errno=3D-16)
[14504.391933] ata10: hard resetting link
[14509.878583] ata10: link is slow to respond, please be patient (ready=
=3D0)
[14536.995640] nfsd: last server has exited, flushing export cache
[14539.425250] ata10: SRST failed (errno=3D-16)
[14539.425263] ata10: hard resetting link
[14544.431917] ata10: SRST failed (errno=3D-16)
[14544.431926] ata10: reset failed, giving up
[14544.431932] ata10.00: disabled
[14544.431973] ata10: EH complete
[14544.432042] sd 9:0:0:0: [sdh] Unhandled error code
[14544.432062] sd 9:0:0:0: [sdh] Unhandled error code
[14544.432080] sd 9:0:0:0: [sdh]  Result: hostbyte=3DDID_BAD_TARGET
driverbyte=3DDRIVER_OK
[14544.432111] sd 9:0:0:0: [sdh]
[14544.432126] sd 9:0:0:0: [sdh] CDB: Read(10)Result:
hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
[14544.432163] sd 9:0:0:0: [sdh] CDB: Write(10): 2a 00 e1 5a ab 00 00 0=
0 08
[14544.432216] sd 9:0:0:0: [sdh] Unhandled error code
[14544.432232]  00
[14544.432240] sd 9:0:0:0: [sdh]
[14544.432253] Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
[14544.432272] end_request: I/O error, dev sdh, sector 3780815616
[14544.432290] sd 9:0:0:0: [sdh] CDB:
[14544.432305] md/raid:md0: Disk failure on sdh1, disabling device.
[14544.432321] md/raid:md0: Operation continuing on 6 devices.
[14544.432336] Write(10): 2a 00 e1 5a ef 78 00 00 80 00
[14544.432389] end_request: I/O error, dev sdh, sector 3780833144
[14544.432412] : 28 00 b2 33 44 80 00 00 08 00
[14544.432433] end_request: I/O error, dev sdh, sector 2989704320
[14544.432453] sd 9:0:0:0: [sdh] Unhandled error code
[14544.432471] sd 9:0:0:0: [sdh]  Result: hostbyte=3DDID_BAD_TARGET
driverbyte=3DDRIVER_OK
[14544.432498] sd 9:0:0:0: [sdh] CDB: Write(10): 2a 00 e1 5a ef f8 00 0=
0 80 00
[14544.432553] end_request: I/O error, dev sdh, sector 3780833272
[14544.432618] sd 9:0:0:0: [sdh] Unhandled error code
[14544.432639] sd 9:0:0:0: [sdh] Unhandled error code
[14544.432659] sd 9:0:0:0: [sdh]  Result: hostbyte=3DDID_BAD_TARGET
driverbyte=3DDRIVER_OK
[14544.432687] sd 9:0:0:0: [sdh] CDB: Write(10): 2a 00 b2 59 e0 10 00 0=
0 08 00
[14544.432749] end_request: I/O error, dev sdh, sector 2992234512
[14544.432774] sd 9:0:0:0: [sdh]  Result: hostbyte=3DDID_BAD_TARGET
driverbyte=3DDRIVER_OK
[14544.432785] sd 9:0:0:0: [sdh] CDB: Write(10): 2a 00
[14544.432800] sd 9:0:0:0: [sdh] Unhandled error code
[14544.432820] sd 9:0:0:0: [sdh]  Result: hostbyte=3DDID_BAD_TARGET
driverbyte=3DDRIVER_OK
[14544.432849] sd 9:0:0:0: [sdh] CDB: Write(10): 2a 00 e1 5a eb 00 00 0=
0 80 00
[14544.432910] end_request: I/O error, dev sdh, sector 3780832000
[14544.432933]  e1 5a f0 78 00 00 80 00
[14544.432949] end_request: I/O error, dev sdh, sector 3780833400
[14544.432965] sd 9:0:0:0: [sdh] Unhandled error code
[14544.432972] sd 9:0:0:0: [sdh]  Result: hostbyte=3DDID_BAD_TARGET
driverbyte=3DDRIVER_OK
[14544.432982] sd 9:0:0:0: [sdh] CDB: Write(10): 2a 00 e1 5a ef 00 00 0=
0 78 00
[14544.433002] end_request: I/O error, dev sdh, sector 3780833024
[14544.433012] sd 9:0:0:0: [sdh] Unhandled error code
[14544.433033] sd 9:0:0:0: [sdh]  Result: hostbyte=3DDID_BAD_TARGET
driverbyte=3DDRIVER_OK
[14544.433062] sd 9:0:0:0: [sdh] CDB: Write(10): 2a 00 e1 5a f0 f8 00 0=
0 80 00
[14544.433121] end_request: I/O error, dev sdh, sector 3780833528
[14544.433205] sd 9:0:0:0: [sdh] Unhandled error code
[14544.433227] sd 9:0:0:0: [sdh] Unhandled error code
[14544.433247] sd 9:0:0:0: [sdh]  Result: hostbyte=3DDID_BAD_TARGET
driverbyte=3DDRIVER_OK
[14544.433276] sd 9:0:0:0: [sdh] CDB: Write(10): 2a 00 e1 5a f1 78 00 0=
0 80 00
[14544.433333] end_request: I/O error, dev sdh, sector 3780833656
[14544.433357] sd 9:0:0:0: [sdh]  Result: hostbyte=3DDID_BAD_TARGET
driverbyte=3DDRIVER_OK
[14544.433366] sd 9:0:0:0: [sdh] CDB: Write(10): 2a 00 2e 8d e7 b0 00 0=
0 28 00
[14544.433387] end_request: I/O error, dev sdh, sector 781051824
[14544.433399] sd 9:0:0:0: [sdh] Unhandled error code
[14544.433408] sd 9:0:0:0: [sdh]  Result: hostbyte=3DDID_BAD_TARGET
driverbyte=3DDRIVER_OK
[14544.433419] sd 9:0:0:0: [sdh] CDB: Write(10): 2a 00 e1 5a f1 f8 00 0=
0 80 00
[14544.433440] end_request: I/O error, dev sdh, sector 3780833784
[14544.433487] sd 9:0:0:0: [sdh] Unhandled error code
[14544.433493] sd 9:0:0:0: [sdh]  Result: hostbyte=3DDID_BAD_TARGET
driverbyte=3DDRIVER_OK
[14544.433502] sd 9:0:0:0: [sdh] CDB: Write(10): 2a 00 e1 5a f2 78 00 0=
0 08 00
[14544.433523] end_request: I/O error, dev sdh, sector 3780833912
[14544.488761] RAID conf printout:
[14544.488772]  --- level:6 rd:7 wd:6
[14544.488779]  disk 0, o:1, dev:sdg1
[14544.488783]  disk 1, o:1, dev:sdb1
[14544.488788]  disk 2, o:1, dev:sdd1
[14544.488793]  disk 3, o:1, dev:sdc1
[14544.488797]  disk 4, o:1, dev:sdf1
[14544.488801]  disk 5, o:0, dev:sdh1
[14544.488805]  disk 6, o:1, dev:sde1
[14544.515279] RAID conf printout:
[14544.515289]  --- level:6 rd:7 wd:6
[14544.515295]  disk 0, o:1, dev:sdg1
[14544.515299]  disk 1, o:1, dev:sdb1
[14544.515304]  disk 2, o:1, dev:sdd1
[14544.515308]  disk 3, o:1, dev:sdc1
[14544.515313]  disk 4, o:1, dev:sdf1
[14544.515317]  disk 6, o:1, dev:sde1
[14570.639011] nvidia 0000:00:03.5: PCI INT B disabled
[14570.639441] nvidia 0000:03:00.0: PCI INT A disabled
[14591.505699] HDA Intel 0000:00:08.0: PCI INT A disabled
 ~ $ dmesg > /srv/http/dmesg-failing-harddrive.log
 ~ $ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdh1[6](F) sdg1[0] sdf1[5] sde1[7] sdd1[4] sdb1[1] s=
dc1[3]
      9751756800 blocks super 1.2 level 6, 64k chunk, algorithm 2
[7/6] [UUUUU_U]

unused devices: <none>
 ~ $

$ mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Tue Oct 19 08:58:41 2010
     Raid Level : raid6
     Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
  Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
   Raid Devices : 7
  Total Devices : 7
    Persistence : Superblock is persistent

    Update Time : Sun Jul 31 19:07:25 2011
          State : clean, degraded
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : ion:0  (local to host ion)
           UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
         Events : 6158774

    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       1       8       17        1      active sync   /dev/sdb1
       4       8       49        2      active sync   /dev/sdd1
       3       8       33        3      active sync   /dev/sdc1
       5       8       81        4      active sync   /dev/sdf1
       5       0        0        5      removed
       7       8       65        6      active sync   /dev/sde1

       6       8      113        -      faulty spare   /dev/sdh1

Shutting down the LV:

$ vgchange -an lvstorage
  /dev/sdh: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdh: read failed after 0 of 4096 at 2000398843904: Input/output =
error
  /dev/sdh: read failed after 0 of 4096 at 2000398925824: Input/output =
error
  /dev/sdh: read failed after 0 of 4096 at 4096: Input/output error
  /dev/sdh1: read failed after 0 of 4096 at 2000397795328: Input/output=
 error
  /dev/sdh1: read failed after 0 of 4096 at 2000397877248: Input/output=
 error
  /dev/sdh1: read failed after 0 of 4096 at 0: Input/output error
  /dev/sdh1: read failed after 0 of 4096 at 4096: Input/output error
  0 logical volume(s) in volume group "lvstorage" now active

Removing the bad HDD:

$ mdadm --manage /dev/md0 --remove /dev/sdh1
mdadm: hot removed /dev/sdh1 from /dev/md0

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdg1[0] sdf1[5] sde1[7] sdd1[4] sdb1[1] sdc1[3]
      9751756800 blocks super 1.2 level 6, 64k chunk, algorithm 2
[7/6] [UUUUU_U]

unused devices: <none>

 $ mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Tue Oct 19 08:58:41 2010
     Raid Level : raid6
     Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
  Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
   Raid Devices : 7
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Sun Jul 31 19:13:02 2011
          State : clean, degraded
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : ion:0  (local to host ion)
           UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
         Events : 6158779

    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       1       8       17        1      active sync   /dev/sdb1
       4       8       49        2      active sync   /dev/sdd1
       3       8       33        3      active sync   /dev/sdc1
       5       8       81        4      active sync   /dev/sdf1
       5       0        0        5      removed
       7       8       65        6      active sync   /dev/sde1

I'll shut down the system now and remove the HDD. I suppose I've just
one question to ask then; should I rescrub the array when it's up with
1 HDD removed?

Thanks again,
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
