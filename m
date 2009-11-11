From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID6 array lost a disk, can someone decode the error?
Date: Wed, 11 Nov 2009 08:52:18 +0300
Message-ID: <70ed7c3e0911102152j23404aadgff519e4344dd7d1@mail.gmail.com>
References: <D3A8B834526640108021D4968F07C82B@m5>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D3A8B834526640108021D4968F07C82B@m5>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <guy@watkins-home.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

You seem to have very high numbers in Hardware_ECC_Recovered and
Raw_Read_Error_Rate. I suggest you replace your cables.

You don't have bad sectors, which is good.

Are you using the controller for RAD or just as a way to connect your d=
isks?

I've had similar link-reset problems, but not written related. Turns
out one of the disks had a bad PCB.

On Wed, Nov 11, 2009 at 8:37 AM, Guy Watkins <guy@watkins-home.com> wro=
te:
> I have 2 4-disk RAID6 arrays that loose a disk sometimes. =C2=A0Maybe=
 once every
> month or 3. =C2=A0As far as I can tell I don't have disks that have u=
n-readable
> blocks. =C2=A0The RAID1 arrays also loose disks sometimes. =C2=A0I ha=
ve the 4 disks on
> 1 controller, from lspci:
> 00:0e.0 Mass storage controller: Promise Technology, Inc. PDC20318 (S=
ATA150
> TX4) (rev 02)
>
> I thought the RAID6 logic corrected single block errors? =C2=A0Maybe =
not on a
> write? And I think this is a write because of "super_written"?
>
> The array is a RAID6 but the errors say RAID5?
>
> When I remove and add the disks back in they rebuild just fine.
>
> Anyway, does anyone understand what this error really is? =C2=A0Is it=
 bad disks?
> Bad cable? =C2=A0Bad controller? =C2=A0Bad sunspots? =C2=A0:)
>
> I did see that a smart test had failed at about the same time. =C2=A0=
I also read
> that some disks or controllers can't handle smart tests. =C2=A0Could =
that be it?
> I don't run smart tests vary often, so I know the other failures from=
 the
> past were not caused by a smart test. =C2=A0Maybe I am doing the test=
s wrong? =C2=A0I
> used this command: "smartctl --test=3Dlong /dev/sda"
>
> All info I think might be needed:
>
> The disks are all Seagate ST3320620AS (320 GB disks).
>
> # uname -a
> Linux linux.watkins-home.com 2.6.27.35-170.2.94.fc10.i686 #1 SMP Thu =
Oct 1
> 14:58:51 EDT 2009 i686 i686 i386 GNU/Linux
>
> # rpm -qa mdadm
> mdadm-2.6.9-1.fc10.i386
>
> From /var/log/messages-20091108
> Nov =C2=A01 21:48:29 linux kernel: ata4.00: exception Emask 0x10 SAct=
 0x0 SErr
> 0x180203 action 0x6 frozen
> Nov =C2=A01 21:48:29 linux kernel: ata4: SError: { RecovData RecovCom=
m Persist
> 10B8B Dispar }
> Nov =C2=A01 21:48:29 linux kernel: ata4.00: cmd
> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> Nov =C2=A01 21:48:29 linux kernel: res 40/00:01:00:4f:c2/00:00:00:00:=
00/00 Emask
> 0x14 (ATA bus error)
> Nov =C2=A01 21:48:29 linux kernel: ata4.00: status: { DRDY }
> Nov =C2=A01 21:48:29 linux kernel: ata4: hard resetting link
> Nov =C2=A01 21:48:31 linux kernel: ata4: SATA link up 1.5 Gbps (SStat=
us 113
> SControl 300)
> Nov =C2=A01 21:48:31 linux kernel: ata4.00: configured for UDMA/133
> Nov =C2=A01 21:48:31 linux kernel: ata4.00: device reported invalid C=
HS sector 0
> Nov =C2=A01 21:48:31 linux kernel: ata4: EH complete
> Nov =C2=A01 21:48:31 linux kernel: sd 3:0:0:0: [sdb] 625142448 512-by=
te hardware
> sectors (320073 MB)
> Nov =C2=A01 21:48:31 linux kernel: end_request: I/O error, dev sdb, s=
ector
> 34089705
> Nov =C2=A01 21:48:31 linux kernel: md: super_written gets error=3D-5,=
 uptodate=3D0
> Nov =C2=A01 21:48:31 linux kernel: raid5: Disk failure on sdb2, disab=
ling device.
> Nov =C2=A01 21:48:31 linux kernel: raid5: Operation continuing on 3 d=
evices.
> Nov =C2=A01 21:48:31 linux kernel: sd 3:0:0:0: [sdb] Write Protect is=
 off
> Nov =C2=A01 21:48:31 linux kernel: sd 3:0:0:0: [sdb] Write cache: ena=
bled, read
> cache: enabled, doesn't support DPO or FUA
> Nov =C2=A01 21:48:31 linux kernel: RAID5 conf printout:
> Nov =C2=A01 21:48:31 linux kernel: --- rd:4 wd:3
> Nov =C2=A01 21:48:31 linux kernel: disk 0, o:0, dev:sdb2
> Nov =C2=A01 21:48:31 linux kernel: disk 1, o:1, dev:sdd2
> Nov =C2=A01 21:48:31 linux kernel: disk 2, o:1, dev:sdc2
> Nov =C2=A01 21:48:31 linux kernel: disk 3, o:1, dev:sda2
> Nov =C2=A01 21:48:31 linux kernel: RAID5 conf printout:
> Nov =C2=A01 21:48:31 linux kernel: --- rd:4 wd:3
> Nov =C2=A01 21:48:31 linux kernel: disk 1, o:1, dev:sdd2
> Nov =C2=A01 21:48:31 linux kernel: disk 2, o:1, dev:sdc2
> Nov =C2=A01 21:48:31 linux kernel: disk 3, o:1, dev:sda2
>
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid1]
> md0 : active raid1 sdd1[0] sda1[3] sdc1[2] sdb1[1]
> =C2=A0 =C2=A0 =C2=A0264960 blocks [4/4] [UUUU]
> =C2=A0 =C2=A0 =C2=A0bitmap: 0/33 pages [0KB], 4KB chunk
>
> md4 : active raid6 sdd4[0] sda4[3] sdc4[2] sdb4[4](F)
> =C2=A0 =C2=A0 =C2=A0586853888 blocks level 6, 256k chunk, algorithm 2=
 [4/3] [U_UU]
> =C2=A0 =C2=A0 =C2=A0bitmap: 70/140 pages [280KB], 1024KB chunk
>
> md2 : active raid1 sdb3[0] sda3[1]
> =C2=A0 =C2=A0 =C2=A02096384 blocks [2/2] [UU]
> =C2=A0 =C2=A0 =C2=A0bitmap: 0/128 pages [0KB], 8KB chunk
>
> md1 : active raid1 sdd3[0] sdc3[1]
> =C2=A0 =C2=A0 =C2=A02096384 blocks [2/2] [UU]
> =C2=A0 =C2=A0 =C2=A0bitmap: 0/128 pages [0KB], 8KB chunk
>
> md3 : active raid6 sdb2[4](F) sdd2[1] sda2[3] sdc2[2]
> =C2=A0 =C2=A0 =C2=A033559552 blocks level 6, 256k chunk, algorithm 2 =
[4/3] [_UUU]
> =C2=A0 =C2=A0 =C2=A0bitmap: 119/129 pages [476KB], 64KB chunk
>
> unused devices: <none>
>
> # smartctl -a /dev/sda
> smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8 Br=
uce
> Allen
> Home page is http://smartmontools.sourceforge.net/
>
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family: =C2=A0 =C2=A0 Seagate Barracuda 7200.10 family
> Device Model: =C2=A0 =C2=A0 ST3320620AS
> Serial Number: =C2=A0 =C2=A03QF08NDL
> Firmware Version: 3.AAD
> User Capacity: =C2=A0 =C2=A0320,072,933,376 bytes
> Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0In smartctl database [for detai=
ls use: -P show]
> ATA Version is: =C2=A0 7
> ATA Standard is: =C2=A0Exact ATA specification draft version not indi=
cated
> Local Time is: =C2=A0 =C2=A0Tue Nov 10 23:57:28 2009 EST
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
uto Offline Data Collection:
> Enabled.
> Self-test execution status: =C2=A0 =C2=A0 =C2=A0( =C2=A0 0) The previ=
ous self-test routine
> completed
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0w=
ithout error or no self-test has
> ever
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b=
een run.
> Total time to complete Offline
> data collection: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ( 430) seconds.
> Offline data collection
> capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0(0x5b) SMART execute Offline immediate.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
uto Offline data collection on/off
> support.
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
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( =C2=A0 1) minu=
tes.
> Extended self-test routine
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( 115) minutes.
>
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FLAG =C2=A0 =C2=A0=
 VALUE WORST THRESH TYPE =C2=A0 =C2=A0 =C2=A0UPDATED
> WHEN_FAILED RAW_VALUE
> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x000f =C2=A0 114 =C2=A0 09=
7 =C2=A0 006 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 77830969
> =C2=A03 Spin_Up_Time =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0003 =
=C2=A0 094 =C2=A0 090 =C2=A0 000 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A04 Start_Stop_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100=
 =C2=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 83
> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 100 =C2=A0 100 =C2=
=A0 036 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A07 Seek_Error_Rate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x000f =C2=A0 081=
 =C2=A0 060 =C2=A0 030 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 150227385
> =C2=A09 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 073 =C2=A0 073 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 23919
> =C2=A010 Spin_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0013 =C2=A0 10=
0 =C2=A0 100 =C2=A0 097 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A012 Power_Cycle_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 116
> 187 Reported_Uncorrect =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100 =C2=A0 1=
00 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 189 High_Fly_Writes =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x003a =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 190 Airflow_Temperature_Cel 0x0022 =C2=A0 061 =C2=A0 046 =C2=A0 045 =C2=
=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 39 (Lifetime Min/Max 37/43)
> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0022 =C2=A0 039 =C2=A0 054 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 39 (0 21 0 0)
> 195 Hardware_ECC_Recovered =C2=A00x001a =C2=A0 065 =C2=A0 054 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 102168431
> 197 Current_Pending_Sector =C2=A00x0012 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 198 Offline_Uncorrectable =C2=A0 0x0010 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Offline
> - =C2=A0 =C2=A0 =C2=A0 0
> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x003e =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 200 Multi_Zone_Error_Rate =C2=A0 0x0000 =C2=A0 100 =C2=A0 253 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Offline
> - =C2=A0 =C2=A0 =C2=A0 0
> 202 TA_Increase_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 2=
53 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
>
> SMART Error Log Version: 1
> No Errors Logged
>
> SMART Self-test log structure revision number 1
> Num =C2=A0Test_Description =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining =C2=A0LifeTime(hours)
> LBA_of_first_error
> # 1 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 23730
> -
> # 2 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 22581
> -
> # 3 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 22577
> -
> # 4 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 17267
> -
> # 5 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 17259
> -
> # 6 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A0 384
> -
>
> SMART Selective self-test log data structure revision number 1
> =C2=A0SPAN =C2=A0MIN_LBA =C2=A0MAX_LBA =C2=A0CURRENT_TEST_STATUS
> =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0 =C2=A0Not_testing
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
> # smartctl -a /dev/sdb
> smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8 Br=
uce
> Allen
> Home page is http://smartmontools.sourceforge.net/
>
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family: =C2=A0 =C2=A0 Seagate Barracuda 7200.10 family
> Device Model: =C2=A0 =C2=A0 ST3320620AS
> Serial Number: =C2=A0 =C2=A03QF08SKR
> Firmware Version: 3.AAD
> User Capacity: =C2=A0 =C2=A0320,072,933,376 bytes
> Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0In smartctl database [for detai=
ls use: -P show]
> ATA Version is: =C2=A0 7
> ATA Standard is: =C2=A0Exact ATA specification draft version not indi=
cated
> Local Time is: =C2=A0 =C2=A0Wed Nov 11 00:03:14 2009 EST
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
uto Offline Data Collection:
> Enabled.
> Self-test execution status: =C2=A0 =C2=A0 =C2=A0( =C2=A037) The self-=
test routine was
> interrupted
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b=
y the host with a hard or soft
> reset.
> Total time to complete Offline
> data collection: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ( 430) seconds.
> Offline data collection
> capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0(0x5b) SMART execute Offline immediate.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
uto Offline data collection on/off
> support.
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
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( =C2=A0 1) minu=
tes.
> Extended self-test routine
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( 115) minutes.
>
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FLAG =C2=A0 =C2=A0=
 VALUE WORST THRESH TYPE =C2=A0 =C2=A0 =C2=A0UPDATED
> WHEN_FAILED RAW_VALUE
> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x000f =C2=A0 111 =C2=A0 09=
1 =C2=A0 006 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 136981744
> =C2=A03 Spin_Up_Time =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0003 =
=C2=A0 099 =C2=A0 090 =C2=A0 000 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A04 Start_Stop_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100=
 =C2=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 104
> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 100 =C2=A0 100 =C2=
=A0 036 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 1
> =C2=A07 Seek_Error_Rate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x000f =C2=A0 084=
 =C2=A0 060 =C2=A0 030 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 257877357
> =C2=A09 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 073 =C2=A0 073 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 23916
> =C2=A010 Spin_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0013 =C2=A0 10=
0 =C2=A0 100 =C2=A0 097 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A012 Power_Cycle_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 157
> 187 Reported_Uncorrect =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100 =C2=A0 1=
00 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 189 High_Fly_Writes =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x003a =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 190 Airflow_Temperature_Cel 0x0022 =C2=A0 059 =C2=A0 049 =C2=A0 045 =C2=
=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 41 (Lifetime Min/Max 38/43)
> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0022 =C2=A0 041 =C2=A0 051 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 41 (0 21 0 0)
> 195 Hardware_ECC_Recovered =C2=A00x001a =C2=A0 063 =C2=A0 054 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 160751697
> 197 Current_Pending_Sector =C2=A00x0012 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 198 Offline_Uncorrectable =C2=A0 0x0010 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Offline
> - =C2=A0 =C2=A0 =C2=A0 0
> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x003e =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 200 Multi_Zone_Error_Rate =C2=A0 0x0000 =C2=A0 100 =C2=A0 253 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Offline
> - =C2=A0 =C2=A0 =C2=A0 0
> 202 TA_Increase_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 2=
53 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
>
> SMART Error Log Version: 1
> No Errors Logged
>
> SMART Self-test log structure revision number 1
> Num =C2=A0Test_Description =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining =C2=A0LifeTime(hours)
> LBA_of_first_error
> # 1 =C2=A0Extended offline =C2=A0 =C2=A0Interrupted (host reset) =C2=A0=
 =C2=A0 =C2=A050% =C2=A0 =C2=A0 23726
> -
> # 2 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 22580
> -
> # 3 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 22577
> -
> # 4 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 17267
> -
> # 5 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 17260
> -
> # 6 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A0 384
> -
>
> SMART Selective self-test log data structure revision number 1
> =C2=A0SPAN =C2=A0MIN_LBA =C2=A0MAX_LBA =C2=A0CURRENT_TEST_STATUS
> =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0 =C2=A0Not_testing
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
> # smartctl -a /dev/sdc
> smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8 Br=
uce
> Allen
> Home page is http://smartmontools.sourceforge.net/
>
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family: =C2=A0 =C2=A0 Seagate Barracuda 7200.10 family
> Device Model: =C2=A0 =C2=A0 ST3320620AS
> Serial Number: =C2=A0 =C2=A03QF08V24
> Firmware Version: 3.AAD
> User Capacity: =C2=A0 =C2=A0320,072,933,376 bytes
> Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0In smartctl database [for detai=
ls use: -P show]
> ATA Version is: =C2=A0 7
> ATA Standard is: =C2=A0Exact ATA specification draft version not indi=
cated
> Local Time is: =C2=A0 =C2=A0Wed Nov 11 00:03:36 2009 EST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
> See vendor-specific Attribute list for marginal Attributes.
>
> General SMART Values:
> Offline data collection status: =C2=A0(0x82) Offline data collection =
activity
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0w=
as completed without error.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
uto Offline Data Collection:
> Enabled.
> Self-test execution status: =C2=A0 =C2=A0 =C2=A0( =C2=A0 0) The previ=
ous self-test routine
> completed
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0w=
ithout error or no self-test has
> ever
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b=
een run.
> Total time to complete Offline
> data collection: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ( 430) seconds.
> Offline data collection
> capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0(0x5b) SMART execute Offline immediate.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
uto Offline data collection on/off
> support.
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
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( =C2=A0 1) minu=
tes.
> Extended self-test routine
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( 115) minutes.
>
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FLAG =C2=A0 =C2=A0=
 VALUE WORST THRESH TYPE =C2=A0 =C2=A0 =C2=A0UPDATED
> WHEN_FAILED RAW_VALUE
> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x000f =C2=A0 119 =C2=A0 09=
0 =C2=A0 006 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 221110249
> =C2=A03 Spin_Up_Time =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0003 =
=C2=A0 094 =C2=A0 090 =C2=A0 000 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A04 Start_Stop_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100=
 =C2=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 94
> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 100 =C2=A0 100 =C2=
=A0 036 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A07 Seek_Error_Rate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x000f =C2=A0 081=
 =C2=A0 060 =C2=A0 030 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 138219006
> =C2=A09 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 073 =C2=A0 073 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 23917
> =C2=A010 Spin_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0013 =C2=A0 10=
0 =C2=A0 100 =C2=A0 097 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A012 Power_Cycle_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 130
> 187 Reported_Uncorrect =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 082 =C2=A0 0=
82 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 18
> 189 High_Fly_Writes =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x003a =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 190 Airflow_Temperature_Cel 0x0022 =C2=A0 059 =C2=A0 044 =C2=A0 045 =C2=
=A0 =C2=A0Old_age =C2=A0 Always
> In_the_past 41 (Lifetime Min/Max 39/45)
> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0022 =C2=A0 041 =C2=A0 056 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 41 (0 22 0 0)
> 195 Hardware_ECC_Recovered =C2=A00x001a =C2=A0 066 =C2=A0 057 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 145841009
> 197 Current_Pending_Sector =C2=A00x0012 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 198 Offline_Uncorrectable =C2=A0 0x0010 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Offline
> - =C2=A0 =C2=A0 =C2=A0 0
> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x003e =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 200 Multi_Zone_Error_Rate =C2=A0 0x0000 =C2=A0 100 =C2=A0 253 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Offline
> - =C2=A0 =C2=A0 =C2=A0 0
> 202 TA_Increase_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 2=
53 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
>
> SMART Error Log Version: 1
> ATA Error Count: 18 (device log contains only the most recent five er=
rors)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CR =3D Command Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0FR =3D Features Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0SC =3D Sector Count Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0SN =3D Sector Number Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CL =3D Cylinder Low Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CH =3D Cylinder High Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0DH =3D Device/Head Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0DC =3D Device Command Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ER =3D Error register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ST =3D Status register [HEX]
> Powered_Up_Time is measured from power on, and printed as
> DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
> SS=3Dsec, and sss=3Dmillisec. It "wraps" after 49.710 days.
>
> Error 18 occurred at disk power-on lifetime: 5380 hours (224 days + 4=
 hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active or
> idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 63 81 09 e0 =C2=A0Error: UNC at LBA =3D 0x00098163 =3D=
 622947
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 00 e1 7e 09 e0 00 =C2=A0 =C2=A0 =C2=A000:16:26.026 =C2=A0=
READ DMA EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:26.022 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:26.022 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:26.019 =C2=A0=
IDENTIFY DEVICE
> =C2=A025 00 00 e1 7e 09 e0 00 =C2=A0 =C2=A0 =C2=A000:16:24.456 =C2=A0=
READ DMA EXT
>
> Error 17 occurred at disk power-on lifetime: 5380 hours (224 days + 4=
 hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active or
> idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 63 81 09 e0 =C2=A0Error: UNC at LBA =3D 0x00098163 =3D=
 622947
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 00 e1 7e 09 e0 00 =C2=A0 =C2=A0 =C2=A000:16:21.313 =C2=A0=
READ DMA EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:19.753 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:19.749 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:19.749 =C2=A0=
IDENTIFY DEVICE
> =C2=A025 00 00 e1 7e 09 e0 00 =C2=A0 =C2=A0 =C2=A000:16:24.456 =C2=A0=
READ DMA EXT
>
> Error 16 occurred at disk power-on lifetime: 5380 hours (224 days + 4=
 hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active or
> idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 63 81 09 e0 =C2=A0Error: UNC at LBA =3D 0x00098163 =3D=
 622947
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 00 e1 7e 09 e0 00 =C2=A0 =C2=A0 =C2=A000:16:21.313 =C2=A0=
READ DMA EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:19.753 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:19.749 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:19.749 =C2=A0=
IDENTIFY DEVICE
> =C2=A025 00 00 e1 7e 09 e0 00 =C2=A0 =C2=A0 =C2=A000:16:19.745 =C2=A0=
READ DMA EXT
>
> Error 15 occurred at disk power-on lifetime: 5380 hours (224 days + 4=
 hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active or
> idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 63 81 09 e0 =C2=A0Error: UNC at LBA =3D 0x00098163 =3D=
 622947
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 00 e1 7e 09 e0 00 =C2=A0 =C2=A0 =C2=A000:16:21.313 =C2=A0=
READ DMA EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:19.753 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:19.749 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:19.749 =C2=A0=
IDENTIFY DEVICE
> =C2=A025 00 00 e1 7e 09 e0 00 =C2=A0 =C2=A0 =C2=A000:16:19.745 =C2=A0=
READ DMA EXT
>
> Error 14 occurred at disk power-on lifetime: 5380 hours (224 days + 4=
 hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active or
> idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 63 81 09 e0 =C2=A0Error: UNC at LBA =3D 0x00098163 =3D=
 622947
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 00 e1 7e 09 e0 00 =C2=A0 =C2=A0 =C2=A000:16:17.672 =C2=A0=
READ DMA EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:19.753 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:19.749 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:16:19.749 =C2=A0=
IDENTIFY DEVICE
> =C2=A025 00 00 e1 7e 09 e0 00 =C2=A0 =C2=A0 =C2=A000:16:19.745 =C2=A0=
READ DMA EXT
>
> SMART Self-test log structure revision number 1
> Num =C2=A0Test_Description =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining =C2=A0LifeTime(hours)
> LBA_of_first_error
> # 1 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 23728
> -
> # 2 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 22579
> -
> # 3 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 22576
> -
> # 4 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 17265
> -
> # 5 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 17257
> -
> # 6 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A0 384
> -
>
> SMART Selective self-test log data structure revision number 1
> =C2=A0SPAN =C2=A0MIN_LBA =C2=A0MAX_LBA =C2=A0CURRENT_TEST_STATUS
> =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0 =C2=A0Not_testing
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
> # smartctl -a /dev/sdd
> smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8 Br=
uce
> Allen
> Home page is http://smartmontools.sourceforge.net/
>
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family: =C2=A0 =C2=A0 Seagate Barracuda 7200.10 family
> Device Model: =C2=A0 =C2=A0 ST3320620AS
> Serial Number: =C2=A0 =C2=A03QF08WDP
> Firmware Version: 3.AAD
> User Capacity: =C2=A0 =C2=A0320,072,933,376 bytes
> Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0In smartctl database [for detai=
ls use: -P show]
> ATA Version is: =C2=A0 7
> ATA Standard is: =C2=A0Exact ATA specification draft version not indi=
cated
> Local Time is: =C2=A0 =C2=A0Wed Nov 11 00:04:04 2009 EST
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
uto Offline Data Collection:
> Enabled.
> Self-test execution status: =C2=A0 =C2=A0 =C2=A0( =C2=A0 0) The previ=
ous self-test routine
> completed
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0w=
ithout error or no self-test has
> ever
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b=
een run.
> Total time to complete Offline
> data collection: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ( 430) seconds.
> Offline data collection
> capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0(0x5b) SMART execute Offline immediate.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
uto Offline data collection on/off
> support.
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
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( =C2=A0 1) minu=
tes.
> Extended self-test routine
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( 115) minutes.
>
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FLAG =C2=A0 =C2=A0=
 VALUE WORST THRESH TYPE =C2=A0 =C2=A0 =C2=A0UPDATED
> WHEN_FAILED RAW_VALUE
> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x000f =C2=A0 110 =C2=A0 09=
0 =C2=A0 006 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 25809154
> =C2=A03 Spin_Up_Time =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0003 =
=C2=A0 098 =C2=A0 090 =C2=A0 000 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A04 Start_Stop_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100=
 =C2=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 516
> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 100 =C2=A0 100 =C2=
=A0 036 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A07 Seek_Error_Rate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x000f =C2=A0 082=
 =C2=A0 060 =C2=A0 030 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 192909989
> =C2=A09 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 073 =C2=A0 073 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 23896
> =C2=A010 Spin_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0013 =C2=A0 10=
0 =C2=A0 100 =C2=A0 097 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A012 Power_Cycle_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 777
> 187 Reported_Uncorrect =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100 =C2=A0 1=
00 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 189 High_Fly_Writes =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x003a =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 190 Airflow_Temperature_Cel 0x0022 =C2=A0 061 =C2=A0 050 =C2=A0 045 =C2=
=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 39 (Lifetime Min/Max 36/42)
> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0022 =C2=A0 039 =C2=A0 050 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 39 (0 20 0 0)
> 195 Hardware_ECC_Recovered =C2=A00x001a =C2=A0 064 =C2=A0 055 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 81546876
> 197 Current_Pending_Sector =C2=A00x0012 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 198 Offline_Uncorrectable =C2=A0 0x0010 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Offline
> - =C2=A0 =C2=A0 =C2=A0 0
> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x003e =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
> 200 Multi_Zone_Error_Rate =C2=A0 0x0000 =C2=A0 100 =C2=A0 253 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Offline
> - =C2=A0 =C2=A0 =C2=A0 0
> 202 TA_Increase_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 2=
53 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> - =C2=A0 =C2=A0 =C2=A0 0
>
> SMART Error Log Version: 1
> ATA Error Count: 6 (device log contains only the most recent five err=
ors)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CR =3D Command Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0FR =3D Features Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0SC =3D Sector Count Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0SN =3D Sector Number Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CL =3D Cylinder Low Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CH =3D Cylinder High Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0DH =3D Device/Head Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0DC =3D Device Command Register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ER =3D Error register [HEX]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ST =3D Status register [HEX]
> Powered_Up_Time is measured from power on, and printed as
> DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
> SS=3Dsec, and sss=3Dmillisec. It "wraps" after 49.710 days.
>
> Error 6 occurred at disk power-on lifetime: 10007 hours (416 days + 2=
3
> hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active or
> idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 a5 0d 4a e0 =C2=A0Error: UNC at LBA =3D 0x004a0da5 =3D=
 4853157
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 00 8f 0c 4a e0 00 =C2=A0 =C2=A0 =C2=A000:05:45.657 =C2=A0=
READ DMA EXT
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A000:05:45.654 =C2=A0=
READ NATIVE MAX ADDRESS EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:05:43.727 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:05:43.660 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A000:05:43.658 =C2=A0=
READ NATIVE MAX ADDRESS EXT
>
> Error 5 occurred at disk power-on lifetime: 10007 hours (416 days + 2=
3
> hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active or
> idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 a5 0d 4a e0 =C2=A0Error: UNC at LBA =3D 0x004a0da5 =3D=
 4853157
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 00 8f 0c 4a e0 00 =C2=A0 =C2=A0 =C2=A000:05:45.657 =C2=A0=
READ DMA EXT
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A000:05:45.654 =C2=A0=
READ NATIVE MAX ADDRESS EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:05:43.727 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:05:43.660 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A000:05:43.658 =C2=A0=
READ NATIVE MAX ADDRESS EXT
>
> Error 4 occurred at disk power-on lifetime: 10007 hours (416 days + 2=
3
> hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active or
> idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 a5 0d 4a e0 =C2=A0Error: UNC at LBA =3D 0x004a0da5 =3D=
 4853157
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 00 8f 0c 4a e0 00 =C2=A0 =C2=A0 =C2=A000:05:39.547 =C2=A0=
READ DMA EXT
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A000:05:39.544 =C2=A0=
READ NATIVE MAX ADDRESS EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:05:43.727 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:05:43.660 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A000:05:43.658 =C2=A0=
READ NATIVE MAX ADDRESS EXT
>
> Error 3 occurred at disk power-on lifetime: 10007 hours (416 days + 2=
3
> hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active or
> idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 a5 0d 4a e0 =C2=A0Error: UNC at LBA =3D 0x004a0da5 =3D=
 4853157
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 00 8f 0c 4a e0 00 =C2=A0 =C2=A0 =C2=A000:05:39.547 =C2=A0=
READ DMA EXT
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A000:05:39.544 =C2=A0=
READ NATIVE MAX ADDRESS EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:05:39.530 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:05:39.475 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A000:05:39.472 =C2=A0=
READ NATIVE MAX ADDRESS EXT
>
> Error 2 occurred at disk power-on lifetime: 10007 hours (416 days + 2=
3
> hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active or
> idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 a5 0d 4a e0 =C2=A0Error: UNC at LBA =3D 0x004a0da5 =3D=
 4853157
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 00 8f 0c 4a e0 00 =C2=A0 =C2=A0 =C2=A000:05:39.547 =C2=A0=
READ DMA EXT
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A000:05:39.544 =C2=A0=
READ NATIVE MAX ADDRESS EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:05:39.530 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A000:05:39.475 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A000:05:39.472 =C2=A0=
READ NATIVE MAX ADDRESS EXT
>
> SMART Self-test log structure revision number 1
> Num =C2=A0Test_Description =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining =C2=A0LifeTime(hours)
> LBA_of_first_error
> # 1 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 23707
> -
> # 2 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 22559
> -
> # 3 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 22555
> -
> # 4 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 17248
> -
> # 5 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 17241
> -
> # 6 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 17241
> -
> # 7 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A0 384
> -
> # 8 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A0 381
> -
>
> SMART Selective self-test log data structure revision number 1
> =C2=A0SPAN =C2=A0MIN_LBA =C2=A0MAX_LBA =C2=A0CURRENT_TEST_STATUS
> =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0 =C2=A0Not_testing
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
> Thanks,
> Guy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
