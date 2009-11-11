From: "Guy Watkins" <guy@watkins-home.com>
Subject: RE: RAID6 array lost a disk, can someone decode the error?
Date: Wed, 11 Nov 2009 02:01:43 -0500
Message-ID: <CA641DF8B4814BD390BF8BC522B55AB4@m5>
References: <D3A8B834526640108021D4968F07C82B@m5> <70ed7c3e0911102152j23404aadgff519e4344dd7d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0911102152j23404aadgff519e4344dd7d1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Majed B.'" <majedb@gmail.com>
Cc: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

} -----Original Message-----
} From: Majed B. [mailto:majedb@gmail.com]
} Sent: Wednesday, November 11, 2009 12:52 AM
} To: Guy Watkins
} Cc: LinuxRaid
} Subject: Re: RAID6 array lost a disk, can someone decode the error?
}=20
} You seem to have very high numbers in Hardware_ECC_Recovered and
} Raw_Read_Error_Rate. I suggest you replace your cables.

I thought I just did not understand those fields.  They seemed high/bad=
 to
me too, but I do not have any other disks to compare to.  You think all=
 4
cables could be bad?  They are the same, but no idea what brand.

ok, any recommended vendor for new cables?
=20
} You don't have bad sectors, which is good.
}=20
} Are you using the controller for RAD or just as a way to connect your
} disks?

JBOD.  I did not know that controller had RAID.  :)

} I've had similar link-reset problems, but not written related. Turns
} out one of the disks had a bad PCB.
}=20
} On Wed, Nov 11, 2009 at 8:37 AM, Guy Watkins <guy@watkins-home.com> w=
rote:
} > I have 2 4-disk RAID6 arrays that loose a disk sometimes. =A0Maybe =
once
} every
} > month or 3. =A0As far as I can tell I don't have disks that have un=
-
} readable
} > blocks. =A0The RAID1 arrays also loose disks sometimes. =A0I have t=
he 4
} disks on
} > 1 controller, from lspci:
} > 00:0e.0 Mass storage controller: Promise Technology, Inc. PDC20318
} (SATA150
} > TX4) (rev 02)
} >
} > I thought the RAID6 logic corrected single block errors? =A0Maybe n=
ot on a
} > write? And I think this is a write because of "super_written"?
} >
} > The array is a RAID6 but the errors say RAID5?
} >
} > When I remove and add the disks back in they rebuild just fine.
} >
} > Anyway, does anyone understand what this error really is? =A0Is it =
bad
} disks?
} > Bad cable? =A0Bad controller? =A0Bad sunspots? =A0:)
} >
} > I did see that a smart test had failed at about the same time. =A0I=
 also
} read
} > that some disks or controllers can't handle smart tests. =A0Could t=
hat be
} it?
} > I don't run smart tests vary often, so I know the other failures fr=
om
} the
} > past were not caused by a smart test. =A0Maybe I am doing the tests=
 wrong?
} =A0I
} > used this command: "smartctl --test=3Dlong /dev/sda"
} >
} > All info I think might be needed:
} >
} > The disks are all Seagate ST3320620AS (320 GB disks).
} >
} > # uname -a
} > Linux linux.watkins-home.com 2.6.27.35-170.2.94.fc10.i686 #1 SMP Th=
u Oct
} 1
} > 14:58:51 EDT 2009 i686 i686 i386 GNU/Linux
} >
} > # rpm -qa mdadm
} > mdadm-2.6.9-1.fc10.i386
} >
} > From /var/log/messages-20091108
} > Nov =A01 21:48:29 linux kernel: ata4.00: exception Emask 0x10 SAct =
0x0
} SErr
} > 0x180203 action 0x6 frozen
} > Nov =A01 21:48:29 linux kernel: ata4: SError: { RecovData RecovComm
} Persist
} > 10B8B Dispar }
} > Nov =A01 21:48:29 linux kernel: ata4.00: cmd
} > ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
} > Nov =A01 21:48:29 linux kernel: res 40/00:01:00:4f:c2/00:00:00:00:0=
0/00
} Emask
} > 0x14 (ATA bus error)
} > Nov =A01 21:48:29 linux kernel: ata4.00: status: { DRDY }
} > Nov =A01 21:48:29 linux kernel: ata4: hard resetting link
} > Nov =A01 21:48:31 linux kernel: ata4: SATA link up 1.5 Gbps (SStatu=
s 113
} > SControl 300)
} > Nov =A01 21:48:31 linux kernel: ata4.00: configured for UDMA/133
} > Nov =A01 21:48:31 linux kernel: ata4.00: device reported invalid CH=
S
} sector 0
} > Nov =A01 21:48:31 linux kernel: ata4: EH complete
} > Nov =A01 21:48:31 linux kernel: sd 3:0:0:0: [sdb] 625142448 512-byt=
e
} hardware
} > sectors (320073 MB)
} > Nov =A01 21:48:31 linux kernel: end_request: I/O error, dev sdb, se=
ctor
} > 34089705
} > Nov =A01 21:48:31 linux kernel: md: super_written gets error=3D-5,
} uptodate=3D0
} > Nov =A01 21:48:31 linux kernel: raid5: Disk failure on sdb2, disabl=
ing
} device.
} > Nov =A01 21:48:31 linux kernel: raid5: Operation continuing on 3 de=
vices.
} > Nov =A01 21:48:31 linux kernel: sd 3:0:0:0: [sdb] Write Protect is =
off
} > Nov =A01 21:48:31 linux kernel: sd 3:0:0:0: [sdb] Write cache: enab=
led,
} read
} > cache: enabled, doesn't support DPO or FUA
} > Nov =A01 21:48:31 linux kernel: RAID5 conf printout:
} > Nov =A01 21:48:31 linux kernel: --- rd:4 wd:3
} > Nov =A01 21:48:31 linux kernel: disk 0, o:0, dev:sdb2
} > Nov =A01 21:48:31 linux kernel: disk 1, o:1, dev:sdd2
} > Nov =A01 21:48:31 linux kernel: disk 2, o:1, dev:sdc2
} > Nov =A01 21:48:31 linux kernel: disk 3, o:1, dev:sda2
} > Nov =A01 21:48:31 linux kernel: RAID5 conf printout:
} > Nov =A01 21:48:31 linux kernel: --- rd:4 wd:3
} > Nov =A01 21:48:31 linux kernel: disk 1, o:1, dev:sdd2
} > Nov =A01 21:48:31 linux kernel: disk 2, o:1, dev:sdc2
} > Nov =A01 21:48:31 linux kernel: disk 3, o:1, dev:sda2
} >
} > # cat /proc/mdstat
} > Personalities : [raid6] [raid5] [raid4] [raid1]
} > md0 : active raid1 sdd1[0] sda1[3] sdc1[2] sdb1[1]
} > =A0 =A0 =A0264960 blocks [4/4] [UUUU]
} > =A0 =A0 =A0bitmap: 0/33 pages [0KB], 4KB chunk
} >
} > md4 : active raid6 sdd4[0] sda4[3] sdc4[2] sdb4[4](F)
} > =A0 =A0 =A0586853888 blocks level 6, 256k chunk, algorithm 2 [4/3] =
[U_UU]
} > =A0 =A0 =A0bitmap: 70/140 pages [280KB], 1024KB chunk
} >
} > md2 : active raid1 sdb3[0] sda3[1]
} > =A0 =A0 =A02096384 blocks [2/2] [UU]
} > =A0 =A0 =A0bitmap: 0/128 pages [0KB], 8KB chunk
} >
} > md1 : active raid1 sdd3[0] sdc3[1]
} > =A0 =A0 =A02096384 blocks [2/2] [UU]
} > =A0 =A0 =A0bitmap: 0/128 pages [0KB], 8KB chunk
} >
} > md3 : active raid6 sdb2[4](F) sdd2[1] sda2[3] sdc2[2]
} > =A0 =A0 =A033559552 blocks level 6, 256k chunk, algorithm 2 [4/3] [=
_UUU]
} > =A0 =A0 =A0bitmap: 119/129 pages [476KB], 64KB chunk
} >
} > unused devices: <none>
} >
} > # smartctl -a /dev/sda
} > smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8 =
Bruce
} > Allen
} > Home page is http://smartmontools.sourceforge.net/
} >
} > =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
} > Model Family: =A0 =A0 Seagate Barracuda 7200.10 family
} > Device Model: =A0 =A0 ST3320620AS
} > Serial Number: =A0 =A03QF08NDL
} > Firmware Version: 3.AAD
} > User Capacity: =A0 =A0320,072,933,376 bytes
} > Device is: =A0 =A0 =A0 =A0In smartctl database [for details use: -P=
 show]
} > ATA Version is: =A0 7
} > ATA Standard is: =A0Exact ATA specification draft version not indic=
ated
} > Local Time is: =A0 =A0Tue Nov 10 23:57:28 2009 EST
} > SMART support is: Available - device has SMART capability.
} > SMART support is: Enabled
} >
} > =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
} > SMART overall-health self-assessment test result: PASSED
} >
} > General SMART Values:
} > Offline data collection status: =A0(0x82) Offline data collection a=
ctivity
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0was completed without error.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Auto Offline Data Collection:
} > Enabled.
} > Self-test execution status: =A0 =A0 =A0( =A0 0) The previous self-t=
est routine
} > completed
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0without error or no self-test has
} > ever
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0been run.
} > Total time to complete Offline
} > data collection: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ( 430) seconds.
} > Offline data collection
} > capabilities: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(0x5b) SMART e=
xecute Offline immediate.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Auto Offline data collection
} on/off
} > support.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Suspend Offline collection upon
} new
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0command.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Offline surface scan supported.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Self-test supported.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0No Conveyance Self-test
} supported.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Selective Self-test supported.
} > SMART capabilities: =A0 =A0 =A0 =A0 =A0 =A0(0x0003) Saves SMART dat=
a before entering
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0power-saving mode.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Supports SMART auto save timer.
} > Error logging capability: =A0 =A0 =A0 =A0(0x01) Error logging suppo=
rted.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0General Purpose Logging
} supported.
} > Short self-test routine
} > recommended polling time: =A0 =A0 =A0 =A0( =A0 1) minutes.
} > Extended self-test routine
} > recommended polling time: =A0 =A0 =A0 =A0( 115) minutes.
} >
} > SMART Attributes Data Structure revision number: 10
} > Vendor Specific SMART Attributes with Thresholds:
} > ID# ATTRIBUTE_NAME =A0 =A0 =A0 =A0 =A0FLAG =A0 =A0 VALUE WORST THRE=
SH TYPE
} =A0UPDATED
} > WHEN_FAILED RAW_VALUE
} > =A01 Raw_Read_Error_Rate =A0 =A0 0x000f =A0 114 =A0 097 =A0 006 =A0=
 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 77830969
} > =A03 Spin_Up_Time =A0 =A0 =A0 =A0 =A0 =A00x0003 =A0 094 =A0 090 =A0=
 000 =A0 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 0
} > =A04 Start_Stop_Count =A0 =A0 =A0 =A00x0032 =A0 100 =A0 100 =A0 020=
 =A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 83
} > =A05 Reallocated_Sector_Ct =A0 0x0033 =A0 100 =A0 100 =A0 036 =A0 =A0=
Pre-fail =A0Always
} > - =A0 =A0 =A0 0
} > =A07 Seek_Error_Rate =A0 =A0 =A0 =A0 0x000f =A0 081 =A0 060 =A0 030=
 =A0 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 150227385
} > =A09 Power_On_Hours =A0 =A0 =A0 =A0 =A00x0032 =A0 073 =A0 073 =A0 0=
00 =A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 23919
} > =A010 Spin_Retry_Count =A0 =A0 =A0 =A00x0013 =A0 100 =A0 100 =A0 09=
7 =A0 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 0
} > =A012 Power_Cycle_Count =A0 =A0 =A0 0x0032 =A0 100 =A0 100 =A0 020 =
=A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 116
} > 187 Reported_Uncorrect =A0 =A0 =A00x0032 =A0 100 =A0 100 =A0 000 =A0=
 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 189 High_Fly_Writes =A0 =A0 =A0 =A0 0x003a =A0 100 =A0 100 =A0 000 =
=A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 190 Airflow_Temperature_Cel 0x0022 =A0 061 =A0 046 =A0 045 =A0 =A0O=
ld_age =A0 Always
} > - =A0 =A0 =A0 39 (Lifetime Min/Max 37/43)
} > 194 Temperature_Celsius =A0 =A0 0x0022 =A0 039 =A0 054 =A0 000 =A0 =
=A0Old_age =A0 Always
} > - =A0 =A0 =A0 39 (0 21 0 0)
} > 195 Hardware_ECC_Recovered =A00x001a =A0 065 =A0 054 =A0 000 =A0 =A0=
Old_age =A0 Always
} > - =A0 =A0 =A0 102168431
} > 197 Current_Pending_Sector =A00x0012 =A0 100 =A0 100 =A0 000 =A0 =A0=
Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 198 Offline_Uncorrectable =A0 0x0010 =A0 100 =A0 100 =A0 000 =A0 =A0=
Old_age
} Offline
} > - =A0 =A0 =A0 0
} > 199 UDMA_CRC_Error_Count =A0 =A00x003e =A0 200 =A0 200 =A0 000 =A0 =
=A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 200 Multi_Zone_Error_Rate =A0 0x0000 =A0 100 =A0 253 =A0 000 =A0 =A0=
Old_age
} Offline
} > - =A0 =A0 =A0 0
} > 202 TA_Increase_Count =A0 =A0 =A0 0x0032 =A0 100 =A0 253 =A0 000 =A0=
 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} >
} > SMART Error Log Version: 1
} > No Errors Logged
} >
} > SMART Self-test log structure revision number 1
} > Num =A0Test_Description =A0 =A0Status =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0Remaining
} =A0LifeTime(hours)
} > LBA_of_first_error
} > # 1 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 23730
} > -
} > # 2 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 22581
} > -
} > # 3 =A0Short offline =A0 =A0 =A0 Completed without error =A0 =A0 =A0=
 00% =A0 =A0 22577
} > -
} > # 4 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 17267
} > -
} > # 5 =A0Short offline =A0 =A0 =A0 Completed without error =A0 =A0 =A0=
 00% =A0 =A0 17259
} > -
} > # 6 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 =A0 384
} > -
} >
} > SMART Selective self-test log data structure revision number 1
} > =A0SPAN =A0MIN_LBA =A0MAX_LBA =A0CURRENT_TEST_STATUS
} > =A0 =A01 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A03 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A04 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A05 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > Selective self-test flags (0x0):
} > =A0After scanning selected spans, do NOT read-scan remainder of dis=
k.
} > If Selective self-test is pending on power-up, resume after 0 minut=
e
} delay.
} >
} > # smartctl -a /dev/sdb
} > smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8 =
Bruce
} > Allen
} > Home page is http://smartmontools.sourceforge.net/
} >
} > =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
} > Model Family: =A0 =A0 Seagate Barracuda 7200.10 family
} > Device Model: =A0 =A0 ST3320620AS
} > Serial Number: =A0 =A03QF08SKR
} > Firmware Version: 3.AAD
} > User Capacity: =A0 =A0320,072,933,376 bytes
} > Device is: =A0 =A0 =A0 =A0In smartctl database [for details use: -P=
 show]
} > ATA Version is: =A0 7
} > ATA Standard is: =A0Exact ATA specification draft version not indic=
ated
} > Local Time is: =A0 =A0Wed Nov 11 00:03:14 2009 EST
} > SMART support is: Available - device has SMART capability.
} > SMART support is: Enabled
} >
} > =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
} > SMART overall-health self-assessment test result: PASSED
} >
} > General SMART Values:
} > Offline data collection status: =A0(0x82) Offline data collection a=
ctivity
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0was completed without error.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Auto Offline Data Collection:
} > Enabled.
} > Self-test execution status: =A0 =A0 =A0( =A037) The self-test routi=
ne was
} > interrupted
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0by the host with a hard or soft
} > reset.
} > Total time to complete Offline
} > data collection: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ( 430) seconds.
} > Offline data collection
} > capabilities: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(0x5b) SMART e=
xecute Offline immediate.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Auto Offline data collection
} on/off
} > support.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Suspend Offline collection upon
} new
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0command.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Offline surface scan supported.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Self-test supported.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0No Conveyance Self-test
} supported.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Selective Self-test supported.
} > SMART capabilities: =A0 =A0 =A0 =A0 =A0 =A0(0x0003) Saves SMART dat=
a before entering
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0power-saving mode.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Supports SMART auto save timer.
} > Error logging capability: =A0 =A0 =A0 =A0(0x01) Error logging suppo=
rted.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0General Purpose Logging
} supported.
} > Short self-test routine
} > recommended polling time: =A0 =A0 =A0 =A0( =A0 1) minutes.
} > Extended self-test routine
} > recommended polling time: =A0 =A0 =A0 =A0( 115) minutes.
} >
} > SMART Attributes Data Structure revision number: 10
} > Vendor Specific SMART Attributes with Thresholds:
} > ID# ATTRIBUTE_NAME =A0 =A0 =A0 =A0 =A0FLAG =A0 =A0 VALUE WORST THRE=
SH TYPE
} =A0UPDATED
} > WHEN_FAILED RAW_VALUE
} > =A01 Raw_Read_Error_Rate =A0 =A0 0x000f =A0 111 =A0 091 =A0 006 =A0=
 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 136981744
} > =A03 Spin_Up_Time =A0 =A0 =A0 =A0 =A0 =A00x0003 =A0 099 =A0 090 =A0=
 000 =A0 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 0
} > =A04 Start_Stop_Count =A0 =A0 =A0 =A00x0032 =A0 100 =A0 100 =A0 020=
 =A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 104
} > =A05 Reallocated_Sector_Ct =A0 0x0033 =A0 100 =A0 100 =A0 036 =A0 =A0=
Pre-fail =A0Always
} > - =A0 =A0 =A0 1
} > =A07 Seek_Error_Rate =A0 =A0 =A0 =A0 0x000f =A0 084 =A0 060 =A0 030=
 =A0 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 257877357
} > =A09 Power_On_Hours =A0 =A0 =A0 =A0 =A00x0032 =A0 073 =A0 073 =A0 0=
00 =A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 23916
} > =A010 Spin_Retry_Count =A0 =A0 =A0 =A00x0013 =A0 100 =A0 100 =A0 09=
7 =A0 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 0
} > =A012 Power_Cycle_Count =A0 =A0 =A0 0x0032 =A0 100 =A0 100 =A0 020 =
=A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 157
} > 187 Reported_Uncorrect =A0 =A0 =A00x0032 =A0 100 =A0 100 =A0 000 =A0=
 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 189 High_Fly_Writes =A0 =A0 =A0 =A0 0x003a =A0 100 =A0 100 =A0 000 =
=A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 190 Airflow_Temperature_Cel 0x0022 =A0 059 =A0 049 =A0 045 =A0 =A0O=
ld_age =A0 Always
} > - =A0 =A0 =A0 41 (Lifetime Min/Max 38/43)
} > 194 Temperature_Celsius =A0 =A0 0x0022 =A0 041 =A0 051 =A0 000 =A0 =
=A0Old_age =A0 Always
} > - =A0 =A0 =A0 41 (0 21 0 0)
} > 195 Hardware_ECC_Recovered =A00x001a =A0 063 =A0 054 =A0 000 =A0 =A0=
Old_age =A0 Always
} > - =A0 =A0 =A0 160751697
} > 197 Current_Pending_Sector =A00x0012 =A0 100 =A0 100 =A0 000 =A0 =A0=
Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 198 Offline_Uncorrectable =A0 0x0010 =A0 100 =A0 100 =A0 000 =A0 =A0=
Old_age
} Offline
} > - =A0 =A0 =A0 0
} > 199 UDMA_CRC_Error_Count =A0 =A00x003e =A0 200 =A0 200 =A0 000 =A0 =
=A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 200 Multi_Zone_Error_Rate =A0 0x0000 =A0 100 =A0 253 =A0 000 =A0 =A0=
Old_age
} Offline
} > - =A0 =A0 =A0 0
} > 202 TA_Increase_Count =A0 =A0 =A0 0x0032 =A0 100 =A0 253 =A0 000 =A0=
 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} >
} > SMART Error Log Version: 1
} > No Errors Logged
} >
} > SMART Self-test log structure revision number 1
} > Num =A0Test_Description =A0 =A0Status =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0Remaining
} =A0LifeTime(hours)
} > LBA_of_first_error
} > # 1 =A0Extended offline =A0 =A0Interrupted (host reset) =A0 =A0 =A0=
50% =A0 =A0 23726
} > -
} > # 2 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 22580
} > -
} > # 3 =A0Short offline =A0 =A0 =A0 Completed without error =A0 =A0 =A0=
 00% =A0 =A0 22577
} > -
} > # 4 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 17267
} > -
} > # 5 =A0Short offline =A0 =A0 =A0 Completed without error =A0 =A0 =A0=
 00% =A0 =A0 17260
} > -
} > # 6 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 =A0 384
} > -
} >
} > SMART Selective self-test log data structure revision number 1
} > =A0SPAN =A0MIN_LBA =A0MAX_LBA =A0CURRENT_TEST_STATUS
} > =A0 =A01 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A03 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A04 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A05 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > Selective self-test flags (0x0):
} > =A0After scanning selected spans, do NOT read-scan remainder of dis=
k.
} > If Selective self-test is pending on power-up, resume after 0 minut=
e
} delay.
} >
} > # smartctl -a /dev/sdc
} > smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8 =
Bruce
} > Allen
} > Home page is http://smartmontools.sourceforge.net/
} >
} > =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
} > Model Family: =A0 =A0 Seagate Barracuda 7200.10 family
} > Device Model: =A0 =A0 ST3320620AS
} > Serial Number: =A0 =A03QF08V24
} > Firmware Version: 3.AAD
} > User Capacity: =A0 =A0320,072,933,376 bytes
} > Device is: =A0 =A0 =A0 =A0In smartctl database [for details use: -P=
 show]
} > ATA Version is: =A0 7
} > ATA Standard is: =A0Exact ATA specification draft version not indic=
ated
} > Local Time is: =A0 =A0Wed Nov 11 00:03:36 2009 EST
} > SMART support is: Available - device has SMART capability.
} > SMART support is: Enabled
} >
} > =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
} > SMART overall-health self-assessment test result: PASSED
} > See vendor-specific Attribute list for marginal Attributes.
} >
} > General SMART Values:
} > Offline data collection status: =A0(0x82) Offline data collection a=
ctivity
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0was completed without error.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Auto Offline Data Collection:
} > Enabled.
} > Self-test execution status: =A0 =A0 =A0( =A0 0) The previous self-t=
est routine
} > completed
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0without error or no self-test has
} > ever
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0been run.
} > Total time to complete Offline
} > data collection: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ( 430) seconds.
} > Offline data collection
} > capabilities: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(0x5b) SMART e=
xecute Offline immediate.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Auto Offline data collection
} on/off
} > support.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Suspend Offline collection upon
} new
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0command.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Offline surface scan supported.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Self-test supported.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0No Conveyance Self-test
} supported.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Selective Self-test supported.
} > SMART capabilities: =A0 =A0 =A0 =A0 =A0 =A0(0x0003) Saves SMART dat=
a before entering
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0power-saving mode.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Supports SMART auto save timer.
} > Error logging capability: =A0 =A0 =A0 =A0(0x01) Error logging suppo=
rted.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0General Purpose Logging
} supported.
} > Short self-test routine
} > recommended polling time: =A0 =A0 =A0 =A0( =A0 1) minutes.
} > Extended self-test routine
} > recommended polling time: =A0 =A0 =A0 =A0( 115) minutes.
} >
} > SMART Attributes Data Structure revision number: 10
} > Vendor Specific SMART Attributes with Thresholds:
} > ID# ATTRIBUTE_NAME =A0 =A0 =A0 =A0 =A0FLAG =A0 =A0 VALUE WORST THRE=
SH TYPE
} =A0UPDATED
} > WHEN_FAILED RAW_VALUE
} > =A01 Raw_Read_Error_Rate =A0 =A0 0x000f =A0 119 =A0 090 =A0 006 =A0=
 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 221110249
} > =A03 Spin_Up_Time =A0 =A0 =A0 =A0 =A0 =A00x0003 =A0 094 =A0 090 =A0=
 000 =A0 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 0
} > =A04 Start_Stop_Count =A0 =A0 =A0 =A00x0032 =A0 100 =A0 100 =A0 020=
 =A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 94
} > =A05 Reallocated_Sector_Ct =A0 0x0033 =A0 100 =A0 100 =A0 036 =A0 =A0=
Pre-fail =A0Always
} > - =A0 =A0 =A0 0
} > =A07 Seek_Error_Rate =A0 =A0 =A0 =A0 0x000f =A0 081 =A0 060 =A0 030=
 =A0 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 138219006
} > =A09 Power_On_Hours =A0 =A0 =A0 =A0 =A00x0032 =A0 073 =A0 073 =A0 0=
00 =A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 23917
} > =A010 Spin_Retry_Count =A0 =A0 =A0 =A00x0013 =A0 100 =A0 100 =A0 09=
7 =A0 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 0
} > =A012 Power_Cycle_Count =A0 =A0 =A0 0x0032 =A0 100 =A0 100 =A0 020 =
=A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 130
} > 187 Reported_Uncorrect =A0 =A0 =A00x0032 =A0 082 =A0 082 =A0 000 =A0=
 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 18
} > 189 High_Fly_Writes =A0 =A0 =A0 =A0 0x003a =A0 100 =A0 100 =A0 000 =
=A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 190 Airflow_Temperature_Cel 0x0022 =A0 059 =A0 044 =A0 045 =A0 =A0O=
ld_age =A0 Always
} > In_the_past 41 (Lifetime Min/Max 39/45)
} > 194 Temperature_Celsius =A0 =A0 0x0022 =A0 041 =A0 056 =A0 000 =A0 =
=A0Old_age =A0 Always
} > - =A0 =A0 =A0 41 (0 22 0 0)
} > 195 Hardware_ECC_Recovered =A00x001a =A0 066 =A0 057 =A0 000 =A0 =A0=
Old_age =A0 Always
} > - =A0 =A0 =A0 145841009
} > 197 Current_Pending_Sector =A00x0012 =A0 100 =A0 100 =A0 000 =A0 =A0=
Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 198 Offline_Uncorrectable =A0 0x0010 =A0 100 =A0 100 =A0 000 =A0 =A0=
Old_age
} Offline
} > - =A0 =A0 =A0 0
} > 199 UDMA_CRC_Error_Count =A0 =A00x003e =A0 200 =A0 200 =A0 000 =A0 =
=A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 200 Multi_Zone_Error_Rate =A0 0x0000 =A0 100 =A0 253 =A0 000 =A0 =A0=
Old_age
} Offline
} > - =A0 =A0 =A0 0
} > 202 TA_Increase_Count =A0 =A0 =A0 0x0032 =A0 100 =A0 253 =A0 000 =A0=
 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} >
} > SMART Error Log Version: 1
} > ATA Error Count: 18 (device log contains only the most recent five
} errors)
} > =A0 =A0 =A0 =A0CR =3D Command Register [HEX]
} > =A0 =A0 =A0 =A0FR =3D Features Register [HEX]
} > =A0 =A0 =A0 =A0SC =3D Sector Count Register [HEX]
} > =A0 =A0 =A0 =A0SN =3D Sector Number Register [HEX]
} > =A0 =A0 =A0 =A0CL =3D Cylinder Low Register [HEX]
} > =A0 =A0 =A0 =A0CH =3D Cylinder High Register [HEX]
} > =A0 =A0 =A0 =A0DH =3D Device/Head Register [HEX]
} > =A0 =A0 =A0 =A0DC =3D Device Command Register [HEX]
} > =A0 =A0 =A0 =A0ER =3D Error register [HEX]
} > =A0 =A0 =A0 =A0ST =3D Status register [HEX]
} > Powered_Up_Time is measured from power on, and printed as
} > DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
} > SS=3Dsec, and sss=3Dmillisec. It "wraps" after 49.710 days.
} >
} > Error 18 occurred at disk power-on lifetime: 5380 hours (224 days +=
 4
} hours)
} > =A0When the command that caused the error occurred, the device was =
active
} or
} > idle.
} >
} > =A0After command completion occurred, registers were:
} > =A0ER ST SC SN CL CH DH
} > =A0-- -- -- -- -- -- --
} > =A040 51 00 63 81 09 e0 =A0Error: UNC at LBA =3D 0x00098163 =3D 622=
947
} >
} > =A0Commands leading to the command that caused the error were:
} > =A0CR FR SC SN CL CH DH DC =A0 Powered_Up_Time =A0Command/Feature_N=
ame
} > =A0-- -- -- -- -- -- -- -- =A0---------------- =A0-----------------=
---
} > =A025 00 00 e1 7e 09 e0 00 =A0 =A0 =A000:16:26.026 =A0READ DMA EXT
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:16:26.022 =A0IDENTIFY DEVI=
CE
} > =A0ef 03 46 00 00 00 a0 00 =A0 =A0 =A000:16:26.022 =A0SET FEATURES =
[Set transfer
} > mode]
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:16:26.019 =A0IDENTIFY DEVI=
CE
} > =A025 00 00 e1 7e 09 e0 00 =A0 =A0 =A000:16:24.456 =A0READ DMA EXT
} >
} > Error 17 occurred at disk power-on lifetime: 5380 hours (224 days +=
 4
} hours)
} > =A0When the command that caused the error occurred, the device was =
active
} or
} > idle.
} >
} > =A0After command completion occurred, registers were:
} > =A0ER ST SC SN CL CH DH
} > =A0-- -- -- -- -- -- --
} > =A040 51 00 63 81 09 e0 =A0Error: UNC at LBA =3D 0x00098163 =3D 622=
947
} >
} > =A0Commands leading to the command that caused the error were:
} > =A0CR FR SC SN CL CH DH DC =A0 Powered_Up_Time =A0Command/Feature_N=
ame
} > =A0-- -- -- -- -- -- -- -- =A0---------------- =A0-----------------=
---
} > =A025 00 00 e1 7e 09 e0 00 =A0 =A0 =A000:16:21.313 =A0READ DMA EXT
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:16:19.753 =A0IDENTIFY DEVI=
CE
} > =A0ef 03 46 00 00 00 a0 00 =A0 =A0 =A000:16:19.749 =A0SET FEATURES =
[Set transfer
} > mode]
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:16:19.749 =A0IDENTIFY DEVI=
CE
} > =A025 00 00 e1 7e 09 e0 00 =A0 =A0 =A000:16:24.456 =A0READ DMA EXT
} >
} > Error 16 occurred at disk power-on lifetime: 5380 hours (224 days +=
 4
} hours)
} > =A0When the command that caused the error occurred, the device was =
active
} or
} > idle.
} >
} > =A0After command completion occurred, registers were:
} > =A0ER ST SC SN CL CH DH
} > =A0-- -- -- -- -- -- --
} > =A040 51 00 63 81 09 e0 =A0Error: UNC at LBA =3D 0x00098163 =3D 622=
947
} >
} > =A0Commands leading to the command that caused the error were:
} > =A0CR FR SC SN CL CH DH DC =A0 Powered_Up_Time =A0Command/Feature_N=
ame
} > =A0-- -- -- -- -- -- -- -- =A0---------------- =A0-----------------=
---
} > =A025 00 00 e1 7e 09 e0 00 =A0 =A0 =A000:16:21.313 =A0READ DMA EXT
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:16:19.753 =A0IDENTIFY DEVI=
CE
} > =A0ef 03 46 00 00 00 a0 00 =A0 =A0 =A000:16:19.749 =A0SET FEATURES =
[Set transfer
} > mode]
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:16:19.749 =A0IDENTIFY DEVI=
CE
} > =A025 00 00 e1 7e 09 e0 00 =A0 =A0 =A000:16:19.745 =A0READ DMA EXT
} >
} > Error 15 occurred at disk power-on lifetime: 5380 hours (224 days +=
 4
} hours)
} > =A0When the command that caused the error occurred, the device was =
active
} or
} > idle.
} >
} > =A0After command completion occurred, registers were:
} > =A0ER ST SC SN CL CH DH
} > =A0-- -- -- -- -- -- --
} > =A040 51 00 63 81 09 e0 =A0Error: UNC at LBA =3D 0x00098163 =3D 622=
947
} >
} > =A0Commands leading to the command that caused the error were:
} > =A0CR FR SC SN CL CH DH DC =A0 Powered_Up_Time =A0Command/Feature_N=
ame
} > =A0-- -- -- -- -- -- -- -- =A0---------------- =A0-----------------=
---
} > =A025 00 00 e1 7e 09 e0 00 =A0 =A0 =A000:16:21.313 =A0READ DMA EXT
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:16:19.753 =A0IDENTIFY DEVI=
CE
} > =A0ef 03 46 00 00 00 a0 00 =A0 =A0 =A000:16:19.749 =A0SET FEATURES =
[Set transfer
} > mode]
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:16:19.749 =A0IDENTIFY DEVI=
CE
} > =A025 00 00 e1 7e 09 e0 00 =A0 =A0 =A000:16:19.745 =A0READ DMA EXT
} >
} > Error 14 occurred at disk power-on lifetime: 5380 hours (224 days +=
 4
} hours)
} > =A0When the command that caused the error occurred, the device was =
active
} or
} > idle.
} >
} > =A0After command completion occurred, registers were:
} > =A0ER ST SC SN CL CH DH
} > =A0-- -- -- -- -- -- --
} > =A040 51 00 63 81 09 e0 =A0Error: UNC at LBA =3D 0x00098163 =3D 622=
947
} >
} > =A0Commands leading to the command that caused the error were:
} > =A0CR FR SC SN CL CH DH DC =A0 Powered_Up_Time =A0Command/Feature_N=
ame
} > =A0-- -- -- -- -- -- -- -- =A0---------------- =A0-----------------=
---
} > =A025 00 00 e1 7e 09 e0 00 =A0 =A0 =A000:16:17.672 =A0READ DMA EXT
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:16:19.753 =A0IDENTIFY DEVI=
CE
} > =A0ef 03 46 00 00 00 a0 00 =A0 =A0 =A000:16:19.749 =A0SET FEATURES =
[Set transfer
} > mode]
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:16:19.749 =A0IDENTIFY DEVI=
CE
} > =A025 00 00 e1 7e 09 e0 00 =A0 =A0 =A000:16:19.745 =A0READ DMA EXT
} >
} > SMART Self-test log structure revision number 1
} > Num =A0Test_Description =A0 =A0Status =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0Remaining
} =A0LifeTime(hours)
} > LBA_of_first_error
} > # 1 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 23728
} > -
} > # 2 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 22579
} > -
} > # 3 =A0Short offline =A0 =A0 =A0 Completed without error =A0 =A0 =A0=
 00% =A0 =A0 22576
} > -
} > # 4 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 17265
} > -
} > # 5 =A0Short offline =A0 =A0 =A0 Completed without error =A0 =A0 =A0=
 00% =A0 =A0 17257
} > -
} > # 6 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 =A0 384
} > -
} >
} > SMART Selective self-test log data structure revision number 1
} > =A0SPAN =A0MIN_LBA =A0MAX_LBA =A0CURRENT_TEST_STATUS
} > =A0 =A01 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A03 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A04 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A05 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > Selective self-test flags (0x0):
} > =A0After scanning selected spans, do NOT read-scan remainder of dis=
k.
} > If Selective self-test is pending on power-up, resume after 0 minut=
e
} delay.
} >
} > # smartctl -a /dev/sdd
} > smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8 =
Bruce
} > Allen
} > Home page is http://smartmontools.sourceforge.net/
} >
} > =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
} > Model Family: =A0 =A0 Seagate Barracuda 7200.10 family
} > Device Model: =A0 =A0 ST3320620AS
} > Serial Number: =A0 =A03QF08WDP
} > Firmware Version: 3.AAD
} > User Capacity: =A0 =A0320,072,933,376 bytes
} > Device is: =A0 =A0 =A0 =A0In smartctl database [for details use: -P=
 show]
} > ATA Version is: =A0 7
} > ATA Standard is: =A0Exact ATA specification draft version not indic=
ated
} > Local Time is: =A0 =A0Wed Nov 11 00:04:04 2009 EST
} > SMART support is: Available - device has SMART capability.
} > SMART support is: Enabled
} >
} > =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
} > SMART overall-health self-assessment test result: PASSED
} >
} > General SMART Values:
} > Offline data collection status: =A0(0x82) Offline data collection a=
ctivity
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0was completed without error.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Auto Offline Data Collection:
} > Enabled.
} > Self-test execution status: =A0 =A0 =A0( =A0 0) The previous self-t=
est routine
} > completed
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0without error or no self-test has
} > ever
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0been run.
} > Total time to complete Offline
} > data collection: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ( 430) seconds.
} > Offline data collection
} > capabilities: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(0x5b) SMART e=
xecute Offline immediate.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Auto Offline data collection
} on/off
} > support.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Suspend Offline collection upon
} new
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0command.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Offline surface scan supported.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Self-test supported.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0No Conveyance Self-test
} supported.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Selective Self-test supported.
} > SMART capabilities: =A0 =A0 =A0 =A0 =A0 =A0(0x0003) Saves SMART dat=
a before entering
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0power-saving mode.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0Supports SMART auto save timer.
} > Error logging capability: =A0 =A0 =A0 =A0(0x01) Error logging suppo=
rted.
} > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0General Purpose Logging
} supported.
} > Short self-test routine
} > recommended polling time: =A0 =A0 =A0 =A0( =A0 1) minutes.
} > Extended self-test routine
} > recommended polling time: =A0 =A0 =A0 =A0( 115) minutes.
} >
} > SMART Attributes Data Structure revision number: 10
} > Vendor Specific SMART Attributes with Thresholds:
} > ID# ATTRIBUTE_NAME =A0 =A0 =A0 =A0 =A0FLAG =A0 =A0 VALUE WORST THRE=
SH TYPE
} =A0UPDATED
} > WHEN_FAILED RAW_VALUE
} > =A01 Raw_Read_Error_Rate =A0 =A0 0x000f =A0 110 =A0 090 =A0 006 =A0=
 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 25809154
} > =A03 Spin_Up_Time =A0 =A0 =A0 =A0 =A0 =A00x0003 =A0 098 =A0 090 =A0=
 000 =A0 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 0
} > =A04 Start_Stop_Count =A0 =A0 =A0 =A00x0032 =A0 100 =A0 100 =A0 020=
 =A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 516
} > =A05 Reallocated_Sector_Ct =A0 0x0033 =A0 100 =A0 100 =A0 036 =A0 =A0=
Pre-fail =A0Always
} > - =A0 =A0 =A0 0
} > =A07 Seek_Error_Rate =A0 =A0 =A0 =A0 0x000f =A0 082 =A0 060 =A0 030=
 =A0 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 192909989
} > =A09 Power_On_Hours =A0 =A0 =A0 =A0 =A00x0032 =A0 073 =A0 073 =A0 0=
00 =A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 23896
} > =A010 Spin_Retry_Count =A0 =A0 =A0 =A00x0013 =A0 100 =A0 100 =A0 09=
7 =A0 =A0Pre-fail =A0Always
} > - =A0 =A0 =A0 0
} > =A012 Power_Cycle_Count =A0 =A0 =A0 0x0032 =A0 100 =A0 100 =A0 020 =
=A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 777
} > 187 Reported_Uncorrect =A0 =A0 =A00x0032 =A0 100 =A0 100 =A0 000 =A0=
 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 189 High_Fly_Writes =A0 =A0 =A0 =A0 0x003a =A0 100 =A0 100 =A0 000 =
=A0 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 190 Airflow_Temperature_Cel 0x0022 =A0 061 =A0 050 =A0 045 =A0 =A0O=
ld_age =A0 Always
} > - =A0 =A0 =A0 39 (Lifetime Min/Max 36/42)
} > 194 Temperature_Celsius =A0 =A0 0x0022 =A0 039 =A0 050 =A0 000 =A0 =
=A0Old_age =A0 Always
} > - =A0 =A0 =A0 39 (0 20 0 0)
} > 195 Hardware_ECC_Recovered =A00x001a =A0 064 =A0 055 =A0 000 =A0 =A0=
Old_age =A0 Always
} > - =A0 =A0 =A0 81546876
} > 197 Current_Pending_Sector =A00x0012 =A0 100 =A0 100 =A0 000 =A0 =A0=
Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 198 Offline_Uncorrectable =A0 0x0010 =A0 100 =A0 100 =A0 000 =A0 =A0=
Old_age
} Offline
} > - =A0 =A0 =A0 0
} > 199 UDMA_CRC_Error_Count =A0 =A00x003e =A0 200 =A0 200 =A0 000 =A0 =
=A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} > 200 Multi_Zone_Error_Rate =A0 0x0000 =A0 100 =A0 253 =A0 000 =A0 =A0=
Old_age
} Offline
} > - =A0 =A0 =A0 0
} > 202 TA_Increase_Count =A0 =A0 =A0 0x0032 =A0 100 =A0 253 =A0 000 =A0=
 =A0Old_age =A0 Always
} > - =A0 =A0 =A0 0
} >
} > SMART Error Log Version: 1
} > ATA Error Count: 6 (device log contains only the most recent five
} errors)
} > =A0 =A0 =A0 =A0CR =3D Command Register [HEX]
} > =A0 =A0 =A0 =A0FR =3D Features Register [HEX]
} > =A0 =A0 =A0 =A0SC =3D Sector Count Register [HEX]
} > =A0 =A0 =A0 =A0SN =3D Sector Number Register [HEX]
} > =A0 =A0 =A0 =A0CL =3D Cylinder Low Register [HEX]
} > =A0 =A0 =A0 =A0CH =3D Cylinder High Register [HEX]
} > =A0 =A0 =A0 =A0DH =3D Device/Head Register [HEX]
} > =A0 =A0 =A0 =A0DC =3D Device Command Register [HEX]
} > =A0 =A0 =A0 =A0ER =3D Error register [HEX]
} > =A0 =A0 =A0 =A0ST =3D Status register [HEX]
} > Powered_Up_Time is measured from power on, and printed as
} > DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
} > SS=3Dsec, and sss=3Dmillisec. It "wraps" after 49.710 days.
} >
} > Error 6 occurred at disk power-on lifetime: 10007 hours (416 days +=
 23
} > hours)
} > =A0When the command that caused the error occurred, the device was =
active
} or
} > idle.
} >
} > =A0After command completion occurred, registers were:
} > =A0ER ST SC SN CL CH DH
} > =A0-- -- -- -- -- -- --
} > =A040 51 00 a5 0d 4a e0 =A0Error: UNC at LBA =3D 0x004a0da5 =3D 485=
3157
} >
} > =A0Commands leading to the command that caused the error were:
} > =A0CR FR SC SN CL CH DH DC =A0 Powered_Up_Time =A0Command/Feature_N=
ame
} > =A0-- -- -- -- -- -- -- -- =A0---------------- =A0-----------------=
---
} > =A025 00 00 8f 0c 4a e0 00 =A0 =A0 =A000:05:45.657 =A0READ DMA EXT
} > =A027 00 00 00 00 00 e0 00 =A0 =A0 =A000:05:45.654 =A0READ NATIVE M=
AX ADDRESS EXT
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:05:43.727 =A0IDENTIFY DEVI=
CE
} > =A0ef 03 46 00 00 00 a0 00 =A0 =A0 =A000:05:43.660 =A0SET FEATURES =
[Set transfer
} > mode]
} > =A027 00 00 00 00 00 e0 00 =A0 =A0 =A000:05:43.658 =A0READ NATIVE M=
AX ADDRESS EXT
} >
} > Error 5 occurred at disk power-on lifetime: 10007 hours (416 days +=
 23
} > hours)
} > =A0When the command that caused the error occurred, the device was =
active
} or
} > idle.
} >
} > =A0After command completion occurred, registers were:
} > =A0ER ST SC SN CL CH DH
} > =A0-- -- -- -- -- -- --
} > =A040 51 00 a5 0d 4a e0 =A0Error: UNC at LBA =3D 0x004a0da5 =3D 485=
3157
} >
} > =A0Commands leading to the command that caused the error were:
} > =A0CR FR SC SN CL CH DH DC =A0 Powered_Up_Time =A0Command/Feature_N=
ame
} > =A0-- -- -- -- -- -- -- -- =A0---------------- =A0-----------------=
---
} > =A025 00 00 8f 0c 4a e0 00 =A0 =A0 =A000:05:45.657 =A0READ DMA EXT
} > =A027 00 00 00 00 00 e0 00 =A0 =A0 =A000:05:45.654 =A0READ NATIVE M=
AX ADDRESS EXT
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:05:43.727 =A0IDENTIFY DEVI=
CE
} > =A0ef 03 46 00 00 00 a0 00 =A0 =A0 =A000:05:43.660 =A0SET FEATURES =
[Set transfer
} > mode]
} > =A027 00 00 00 00 00 e0 00 =A0 =A0 =A000:05:43.658 =A0READ NATIVE M=
AX ADDRESS EXT
} >
} > Error 4 occurred at disk power-on lifetime: 10007 hours (416 days +=
 23
} > hours)
} > =A0When the command that caused the error occurred, the device was =
active
} or
} > idle.
} >
} > =A0After command completion occurred, registers were:
} > =A0ER ST SC SN CL CH DH
} > =A0-- -- -- -- -- -- --
} > =A040 51 00 a5 0d 4a e0 =A0Error: UNC at LBA =3D 0x004a0da5 =3D 485=
3157
} >
} > =A0Commands leading to the command that caused the error were:
} > =A0CR FR SC SN CL CH DH DC =A0 Powered_Up_Time =A0Command/Feature_N=
ame
} > =A0-- -- -- -- -- -- -- -- =A0---------------- =A0-----------------=
---
} > =A025 00 00 8f 0c 4a e0 00 =A0 =A0 =A000:05:39.547 =A0READ DMA EXT
} > =A027 00 00 00 00 00 e0 00 =A0 =A0 =A000:05:39.544 =A0READ NATIVE M=
AX ADDRESS EXT
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:05:43.727 =A0IDENTIFY DEVI=
CE
} > =A0ef 03 46 00 00 00 a0 00 =A0 =A0 =A000:05:43.660 =A0SET FEATURES =
[Set transfer
} > mode]
} > =A027 00 00 00 00 00 e0 00 =A0 =A0 =A000:05:43.658 =A0READ NATIVE M=
AX ADDRESS EXT
} >
} > Error 3 occurred at disk power-on lifetime: 10007 hours (416 days +=
 23
} > hours)
} > =A0When the command that caused the error occurred, the device was =
active
} or
} > idle.
} >
} > =A0After command completion occurred, registers were:
} > =A0ER ST SC SN CL CH DH
} > =A0-- -- -- -- -- -- --
} > =A040 51 00 a5 0d 4a e0 =A0Error: UNC at LBA =3D 0x004a0da5 =3D 485=
3157
} >
} > =A0Commands leading to the command that caused the error were:
} > =A0CR FR SC SN CL CH DH DC =A0 Powered_Up_Time =A0Command/Feature_N=
ame
} > =A0-- -- -- -- -- -- -- -- =A0---------------- =A0-----------------=
---
} > =A025 00 00 8f 0c 4a e0 00 =A0 =A0 =A000:05:39.547 =A0READ DMA EXT
} > =A027 00 00 00 00 00 e0 00 =A0 =A0 =A000:05:39.544 =A0READ NATIVE M=
AX ADDRESS EXT
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:05:39.530 =A0IDENTIFY DEVI=
CE
} > =A0ef 03 46 00 00 00 a0 00 =A0 =A0 =A000:05:39.475 =A0SET FEATURES =
[Set transfer
} > mode]
} > =A027 00 00 00 00 00 e0 00 =A0 =A0 =A000:05:39.472 =A0READ NATIVE M=
AX ADDRESS EXT
} >
} > Error 2 occurred at disk power-on lifetime: 10007 hours (416 days +=
 23
} > hours)
} > =A0When the command that caused the error occurred, the device was =
active
} or
} > idle.
} >
} > =A0After command completion occurred, registers were:
} > =A0ER ST SC SN CL CH DH
} > =A0-- -- -- -- -- -- --
} > =A040 51 00 a5 0d 4a e0 =A0Error: UNC at LBA =3D 0x004a0da5 =3D 485=
3157
} >
} > =A0Commands leading to the command that caused the error were:
} > =A0CR FR SC SN CL CH DH DC =A0 Powered_Up_Time =A0Command/Feature_N=
ame
} > =A0-- -- -- -- -- -- -- -- =A0---------------- =A0-----------------=
---
} > =A025 00 00 8f 0c 4a e0 00 =A0 =A0 =A000:05:39.547 =A0READ DMA EXT
} > =A027 00 00 00 00 00 e0 00 =A0 =A0 =A000:05:39.544 =A0READ NATIVE M=
AX ADDRESS EXT
} > =A0ec 00 00 00 00 00 a0 00 =A0 =A0 =A000:05:39.530 =A0IDENTIFY DEVI=
CE
} > =A0ef 03 46 00 00 00 a0 00 =A0 =A0 =A000:05:39.475 =A0SET FEATURES =
[Set transfer
} > mode]
} > =A027 00 00 00 00 00 e0 00 =A0 =A0 =A000:05:39.472 =A0READ NATIVE M=
AX ADDRESS EXT
} >
} > SMART Self-test log structure revision number 1
} > Num =A0Test_Description =A0 =A0Status =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0Remaining
} =A0LifeTime(hours)
} > LBA_of_first_error
} > # 1 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 23707
} > -
} > # 2 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 22559
} > -
} > # 3 =A0Short offline =A0 =A0 =A0 Completed without error =A0 =A0 =A0=
 00% =A0 =A0 22555
} > -
} > # 4 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 17248
} > -
} > # 5 =A0Short offline =A0 =A0 =A0 Completed without error =A0 =A0 =A0=
 00% =A0 =A0 17241
} > -
} > # 6 =A0Short offline =A0 =A0 =A0 Completed without error =A0 =A0 =A0=
 00% =A0 =A0 17241
} > -
} > # 7 =A0Extended offline =A0 =A0Completed without error =A0 =A0 =A0 =
00% =A0 =A0 =A0 384
} > -
} > # 8 =A0Short offline =A0 =A0 =A0 Completed without error =A0 =A0 =A0=
 00% =A0 =A0 =A0 381
} > -
} >
} > SMART Selective self-test log data structure revision number 1
} > =A0SPAN =A0MIN_LBA =A0MAX_LBA =A0CURRENT_TEST_STATUS
} > =A0 =A01 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A03 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A04 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > =A0 =A05 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
} > Selective self-test flags (0x0):
} > =A0After scanning selected spans, do NOT read-scan remainder of dis=
k.
} > If Selective self-test is pending on power-up, resume after 0 minut=
e
} delay.
} >
} > Thanks,
} > Guy
} >
} > --
} > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
} > the body of a message to majordomo@vger.kernel.org
} > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
} >
}=20
}=20
}=20
} --
}        Majed B.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
