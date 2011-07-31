From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Do I have a bad HDD?
Date: Sun, 31 Jul 2011 18:59:00 +0100
Message-ID: <CADNH=7EJ7tvw2DEsAbeuxxRO1k961RSV4axgvfRUBaKG+Q455Q@mail.gmail.com>
References: <CADNH=7HDCwtUr-HSN7fH_GSH8jTYb-SAwmKY0ZRn3opWAhKiBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7HDCwtUr-HSN7fH_GSH8jTYb-SAwmKY0ZRn3opWAhKiBQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31 July 2011 14:05, Mathias Bur=C3=A9n <mathias.buren@gmail.com> wro=
te:
> Hi list,
>
> Here's the output of my weekly script:
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
> sdf1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 47 =C2=A0 =C2=A0 =C2=A06
> sdg1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 0
> sdh1 =C2=A0 =C2=A06158767 0 =C2=A0 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0=
 0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 340 =C2=A0 =C2=A0 3
>
>
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdf1[5] sdh1[6] sdg1[0] sde1[7] sdc1[3] sdd1[4] sd=
b1[1]
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
> =C2=A0 =C2=A0Update Time : Sun Jul 31 09:50:43 2011
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
> Here's the SMART data for sdh:
>
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
> Local Time is: =C2=A0 =C2=A0Sun Jul 31 14:03:32 2011 IST
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
> Offline data collection status: =C2=A0(0x82) Offline data collection =
activity
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0w=
as completed without error.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
uto Offline Data Collection: Enabled.
> Self-test execution status: =C2=A0 =C2=A0 =C2=A0( =C2=A037) The self-=
test routine was interrupted
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b=
y the host with a hard or soft reset.
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
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 340
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
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 6447
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
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 10117271
> 191 G-Sense_Error_Rate =C2=A0 =C2=A0 =C2=A00x0022 =C2=A0 100 =C2=A0 1=
00 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 1
> 192 Power-Off_Retract_Count 0x0022 =C2=A0 252 =C2=A0 252 =C2=A0 000 =C2=
=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0002 =C2=A0 064 =C2=A0 057 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 35 (Min/Max 16/43)
> 195 Hardware_ECC_Recovered =C2=A00x003a =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 196 Reallocated_Event_Count 0x0032 =C2=A0 252 =C2=A0 252 =C2=A0 000 =C2=
=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 197 Current_Pending_Sector =C2=A00x0032 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 6
> 198 Offline_Uncorrectable =C2=A0 0x0030 =C2=A0 252 =C2=A0 252 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
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
> # 1 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=A0=
 =C2=A0 =C2=A050% =C2=A0 =C2=A0 =C2=A06408 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
-
> # 2 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06317 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> # 3 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06260 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> # 4 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06232 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> # 5 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06170 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> # 6 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06064 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> # 7 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A06029 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> # 8 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05898 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> # 9 =C2=A0Extended offline =C2=A0 =C2=A0Aborted by host =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 60% =C2=A0 =C2=A0 =C2=A05893 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 -
> #10 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05728 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #11 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05706 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #12 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=A0=
 =C2=A0 =C2=A040% =C2=A0 =C2=A0 =C2=A05701 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
-
> #13 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=A0=
 =C2=A0 =C2=A090% =C2=A0 =C2=A0 =C2=A05666 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
-
> #14 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05560 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #15 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05527 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #16 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05392 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #17 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05357 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #18 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05250 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #19 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A04272 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #20 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A04017 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
> #21 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A03935 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -
>
> Note: selective self-test log revision number (0) not 1 implies that
> no selective self-test has ever been run
> SMART Selective self-test log data structure revision number 0
> Note: revision number not 1 implies that no selective self-test has
> ever been run
> =C2=A0SPAN =C2=A0MIN_LBA =C2=A0MAX_LBA =C2=A0CURRENT_TEST_STATUS
> =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0 =C2=A0Interrupted [50% left] (0-65535)
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
>
> It has 6 pending sectors. Why are they not reallocated? Can I force
> this somehow? (a scrub did not reallocate them) Is this enough to
> replace the HDD?
>
> Thanks,
> Mathias
>

Uh oh, I did another scrub, and here's the status:

DEV	EVENTS	REALL	PEND	UNCORR	CRC	RAW	ZONE	END
sdb1	6158767	0	0	0	2	0	0=09
sdc1	6158767	0	0	0	0	0	0=09
sdd1	6158767	0	0	0	0	0	0=09
sde1	6158767	0	0	0	0	0	1=09
sdf1	6158768	0	0	0	0	47	6=09
sdg1	6158767	0	0	0	0	0	0=09
sdh1	6158767	0	8	1	0	341	3=09


Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdh1[6] sdg1[0] sdf1[5] sde1[7] sdd1[4] sdb1[1] sdc1=
[3]
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

    Update Time : Sun Jul 31 18:51:58 2011
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

smartctl 5.41 2011-06-09 r3365 [x86_64-linux-2.6.39-ck] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     SAMSUNG SpinPoint F4 EG (AFT)
Device Model:     SAMSUNG HD204UI
Serial Number:    S2HGJ1RZ800850
LU WWN Device Id: 5 0024e9 003f1ebc9
=46irmware Version: 1AQ10003
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 6
Local Time is:    Sun Jul 31 18:51:59 2011 IST

=3D=3D> WARNING: Using smartmontools or hdparm with this
drive may result in data loss due to a firmware bug.
****** THIS DRIVE MAY OR MAY NOT BE AFFECTED! ******
Buggy and fixed firmware report same version number!
See the following web pages for details:
http://www.samsung.com/global/business/hdd/faqView.do?b2b_bbs_msg_id=3D=
386
http://sourceforge.net/apps/trac/smartmontools/wiki/SamsungF4EGBadBlock=
s

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80)	Offline data collection activit=
y
					was never started.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      ( 118)	The previous self-test complete=
d having
					the read element of the test failed.
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
SMART capabilities:            (0x0003)	Saves SMART data before enterin=
g
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
Always       -       341
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
Always       -       6452
 10 Spin_Retry_Count        0x0032   252   252   051    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   252   252   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       20
181 Program_Fail_Cnt_Total  0x0022   100   100   000    Old_age
Always       -       10121757
191 G-Sense_Error_Rate      0x0022   100   100   000    Old_age
Always       -       1
192 Power-Off_Retract_Count 0x0022   252   252   000    Old_age
Always       -       0
194 Temperature_Celsius     0x0002   064   057   000    Old_age
Always       -       31 (Min/Max 16/43)
195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age
Always       -       0
196 Reallocated_Event_Count 0x0032   252   252   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   100   100   000    Old_age
Always       -       8
198 Offline_Uncorrectable   0x0030   100   100   000    Old_age
Offline      -       1
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
# 1  Extended offline    Completed: read failure       60%      6452
      1519520304
# 2  Extended offline    Interrupted (host reset)      50%      6408   =
      -
# 3  Extended offline    Completed without error       00%      6317   =
      -
# 4  Extended offline    Completed without error       00%      6260   =
      -
# 5  Extended offline    Completed without error       00%      6232   =
      -
# 6  Extended offline    Completed without error       00%      6170   =
      -
# 7  Extended offline    Completed without error       00%      6064   =
      -
# 8  Extended offline    Completed without error       00%      6029   =
      -
# 9  Extended offline    Completed without error       00%      5898   =
      -
#10  Extended offline    Aborted by host               60%      5893   =
      -
#11  Extended offline    Completed without error       00%      5728   =
      -
#12  Extended offline    Completed without error       00%      5706   =
      -
#13  Extended offline    Interrupted (host reset)      40%      5701   =
      -
#14  Extended offline    Interrupted (host reset)      90%      5666   =
      -
#15  Extended offline    Completed without error       00%      5560   =
      -
#16  Extended offline    Completed without error       00%      5527   =
      -
#17  Extended offline    Completed without error       00%      5392   =
      -
#18  Extended offline    Completed without error       00%      5357   =
      -
#19  Extended offline    Completed without error       00%      5250   =
      -
#20  Extended offline    Completed without error       00%      4272   =
      -
#21  Extended offline    Completed without error       00%      4017   =
      -

Note: selective self-test log revision number (0) not 1 implies that
no selective self-test has ever been run
SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has
ever been run
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Completed_read_failure [60% left] (0-65535)
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.

:( I do have a bad HDD. RMA is already in progress, I need to take out
the drive and ship it to Samsung in Holland. Will print labels at work
on Tuesday.

Questions:

* How do I remove this HDD without causing damage to the array? Is
this the correct way?:
mdadm --manage /dev/md0 --fail /dev/sdh1 # fail the device
mdadm --manage /dev/md0 --remove /dev/sdh1 # remove the device
* (shut down the system gracefully)
* (remove the HDD)
* (install new HDD)
* (start system)
sfdisk -d /dev/sde | sfdisk /dev/sdh # partition the new HDD
mdadm --manage /dev/md0 --add /dev/sdh1 # add the partition to the arra=
y

* After removing the HDD, should I do another scrub?

Thanks a lot in advance!

/Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
