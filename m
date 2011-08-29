From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: (solved) RAID1, changed disk, 2nd has errors ...
Date: Tue, 30 Aug 2011 00:40:51 +0100
Message-ID: <CADNH=7EczqKSw4n3qSkxkp_NDxbaJDJDr_PtnnpcVPONNq2ABg@mail.gmail.com>
References: <4E5787A1.7080807@xunil.at>
	<20110826125653.GA13709@cthulhu.home.robinhill.me.uk>
	<4E57A4D5.3070004@xunil.at>
	<20110826140810.GB13709@cthulhu.home.robinhill.me.uk>
	<4E57BEBB.2000606@xunil.at>
	<4E5B396D.9020609@xunil.at>
	<4E5B438D.8000107@xunil.at>
	<CADNH=7G=HFSinigdCtHbSV0iKMGB57CrgjA+Qde4xRAeW7FURQ@mail.gmail.com>
	<4E5B4712.90106@xunil.at>
	<4E5B4D12.5060604@xunil.at>
	<4E5BA388.3000405@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5BA388.3000405@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, robin.hill47@ntlworld.com
List-Id: linux-raid.ids

On 29 August 2011 15:34, Stefan G. Weichinger <lists@xunil.at> wrote:
> Am 29.08.2011 10:25, schrieb Stefan G. Weichinger:
>
>> I get
>>
>> 197 Current_Pending_Sector =C2=A00x0012 =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
>> =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>> 198 Offline_Uncorrectable =C2=A0 0x0010 =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age
>> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>>
>>
>> Sounds good to me! Right?
>>
>> So now I could re-add /dev/sdb4 to retry syncing that array, correct=
?
>
> Did that.
>
> I failed/removed/re-added /dev/sdb4 and waited for some hours of resy=
ncing.
>
> Now /dev/md2 is in sync again, still with no bad sectors in SMART
> (attached, @Mathias ;-))
>
> thanks to Robin and Mathias for your feedback, it helped me to get th=
e
> picture and chose the next steps!
>
> For now I let the arrays as they are and wait for the second new hdd.
> As soon as I have it here I will swap /dev/sdb as well.
>
> (a new server with maybe RAID6 is soon to come there ...)
>
> Thanks, Stefan
>
> ----
>
> # smartctl -a /dev/sda
> smartctl 5.40 2010-10-16 r3189 [i686-pc-linux-gnu] (local build)
> Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforg=
e.net
>
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family: =C2=A0 =C2=A0 Seagate Barracuda 7200.12 family
> Device Model: =C2=A0 =C2=A0 ST31000528AS
> Serial Number: =C2=A0 =C2=A09VP3BSEV
> Firmware Version: CC38
> User Capacity: =C2=A0 =C2=A01.000.204.886.016 bytes
> Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0In smartctl database [for detai=
ls use: -P show]
> ATA Version is: =C2=A0 8
> ATA Standard is: =C2=A0ATA-8-ACS revision 4
> Local Time is: =C2=A0 =C2=A0Mon Aug 29 16:31:35 2011 CEST
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
> Self-test execution status: =C2=A0 =C2=A0 =C2=A0( =C2=A0 0) The previ=
ous self-test routine
> completed
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0w=
ithout error or no self-test has ever
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b=
een run.
> Total time to complete Offline
> data collection: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ( 600) seconds.
> Offline data collection
> capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0(0x7b) SMART execute Offline immediate.
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
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0C=
onveyance Self-test supported.
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
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( 178) minutes.
> Conveyance self-test routine
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( =C2=A0 2) minu=
tes.
> SCT capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x=
103f) SCT Status supported.
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
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FLAG =C2=A0 =C2=A0=
 VALUE WORST THRESH TYPE
> UPDATED =C2=A0WHEN_FAILED RAW_VALUE
> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x000f =C2=A0 117 =C2=A0 09=
9 =C2=A0 006 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 134791791
> =C2=A03 Spin_Up_Time =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0003 =
=C2=A0 097 =C2=A0 095 =C2=A0 000 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> =C2=A04 Start_Stop_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100=
 =C2=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 50
> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 100 =C2=A0 100 =C2=
=A0 036 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> =C2=A07 Seek_Error_Rate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x000f =C2=A0 080=
 =C2=A0 060 =C2=A0 030 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 111650379
> =C2=A09 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 085 =C2=A0 085 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 13433
> =C2=A010 Spin_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0013 =C2=A0 10=
0 =C2=A0 100 =C2=A0 097 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> =C2=A012 Power_Cycle_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 25
> 183 Runtime_Bad_Block =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=A0 1=
00 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> 184 End-to-End_Error =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 099 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> 187 Reported_Uncorrect =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 082 =C2=A0 0=
82 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 18
> 188 Command_Timeout =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 099 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 2
> 189 High_Fly_Writes =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x003a =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> 190 Airflow_Temperature_Cel 0x0022 =C2=A0 067 =C2=A0 060 =C2=A0 045 =C2=
=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 33 (Min/Max 27/36)
> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0022 =C2=A0 033 =C2=A0 040 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 33 (0 15 0 0)
> 195 Hardware_ECC_Recovered =C2=A00x001a =C2=A0 048 =C2=A0 024 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 134791791
> 197 Current_Pending_Sector =C2=A00x0012 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> 198 Offline_Uncorrectable =C2=A0 0x0010 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x003e =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> 240 Head_Flying_Hours =C2=A0 =C2=A0 =C2=A0 0x0000 =C2=A0 100 =C2=A0 2=
53 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 255980050855093
> 241 Total_LBAs_Written =C2=A0 =C2=A0 =C2=A00x0000 =C2=A0 100 =C2=A0 2=
53 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 2678846567
> 242 Total_LBAs_Read =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x0000 =C2=A0 100 =C2=
=A0 253 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 4015371061
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
> Error 18 occurred at disk power-on lifetime: 13357 hours (556 days + =
13
> hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active
> or idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D=
 268435455
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 08 ff ff ff ef 00 =C2=A0 =C2=A0 =C2=A001:28:56.212 =C2=A0=
READ DMA EXT
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A001:28:56.211 =C2=A0=
READ NATIVE MAX ADDRESS EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A001:28:56.191 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A001:28:56.175 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A001:28:56.151 =C2=A0=
READ NATIVE MAX ADDRESS EXT
>
> Error 17 occurred at disk power-on lifetime: 13357 hours (556 days + =
13
> hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active
> or idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D=
 268435455
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 08 ff ff ff ef 00 =C2=A0 =C2=A0 =C2=A001:28:53.001 =C2=A0=
READ DMA EXT
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A001:28:53.000 =C2=A0=
READ NATIVE MAX ADDRESS EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A001:28:52.980 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A001:28:52.961 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A001:28:52.940 =C2=A0=
READ NATIVE MAX ADDRESS EXT
>
> Error 16 occurred at disk power-on lifetime: 13357 hours (556 days + =
13
> hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active
> or idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D=
 268435455
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 08 ff ff ff ef 00 =C2=A0 =C2=A0 =C2=A001:28:49.790 =C2=A0=
READ DMA EXT
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A001:28:49.789 =C2=A0=
READ NATIVE MAX ADDRESS EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A001:28:49.749 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A001:28:49.739 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A001:28:49.719 =C2=A0=
READ NATIVE MAX ADDRESS EXT
>
> Error 15 occurred at disk power-on lifetime: 13357 hours (556 days + =
13
> hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active
> or idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D=
 268435455
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 08 ff ff ff ef 00 =C2=A0 =C2=A0 =C2=A001:28:46.580 =C2=A0=
READ DMA EXT
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A001:28:46.579 =C2=A0=
READ NATIVE MAX ADDRESS EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A001:28:46.559 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A001:28:46.542 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A001:28:46.519 =C2=A0=
READ NATIVE MAX ADDRESS EXT
>
> Error 14 occurred at disk power-on lifetime: 13357 hours (556 days + =
13
> hours)
> =C2=A0When the command that caused the error occurred, the device was=
 active
> or idle.
>
> =C2=A0After command completion occurred, registers were:
> =C2=A0ER ST SC SN CL CH DH
> =C2=A0-- -- -- -- -- -- --
> =C2=A040 51 00 ff ff ff 0f =C2=A0Error: UNC at LBA =3D 0x0fffffff =3D=
 268435455
>
> =C2=A0Commands leading to the command that caused the error were:
> =C2=A0CR FR SC SN CL CH DH DC =C2=A0 Powered_Up_Time =C2=A0Command/Fe=
ature_Name
> =C2=A0-- -- -- -- -- -- -- -- =C2=A0---------------- =C2=A0----------=
----------
> =C2=A025 00 08 ff ff ff ef 00 =C2=A0 =C2=A0 =C2=A001:28:43.379 =C2=A0=
READ DMA EXT
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A001:28:43.378 =C2=A0=
READ NATIVE MAX ADDRESS EXT
> =C2=A0ec 00 00 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A001:28:43.358 =C2=A0=
IDENTIFY DEVICE
> =C2=A0ef 03 46 00 00 00 a0 00 =C2=A0 =C2=A0 =C2=A001:28:43.345 =C2=A0=
SET FEATURES [Set transfer
> mode]
> =C2=A027 00 00 00 00 00 e0 00 =C2=A0 =C2=A0 =C2=A001:28:43.318 =C2=A0=
READ NATIVE MAX ADDRESS EXT
>
> SMART Self-test log structure revision number 1
> Num =C2=A0Test_Description =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining
> LifeTime(hours) =C2=A0LBA_of_first_error
> # 1 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13429
> =C2=A0 =C2=A0 -
> # 2 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13405
> =C2=A0 =C2=A0 -
> # 3 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13381
> =C2=A0 =C2=A0 -
> # 4 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13375
> =C2=A0 =C2=A0 -
> # 5 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13357
> =C2=A0 =C2=A0 -
> # 6 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13333
> =C2=A0 =C2=A0 -
> # 7 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13310
> =C2=A0 =C2=A0 -
> # 8 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13286
> =C2=A0 =C2=A0 -
> # 9 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13261
> =C2=A0 =C2=A0 -
> #10 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13237
> =C2=A0 =C2=A0 -
> #11 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13213
> =C2=A0 =C2=A0 -
> #12 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13207
> =C2=A0 =C2=A0 -
> #13 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13189
> =C2=A0 =C2=A0 -
> #14 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13164
> =C2=A0 =C2=A0 -
> #15 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13162
> =C2=A0 =C2=A0 -
> #16 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13138
> =C2=A0 =C2=A0 -
> #17 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13114
> =C2=A0 =C2=A0 -
> #18 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13090
> =C2=A0 =C2=A0 -
> #19 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13066
> =C2=A0 =C2=A0 -
> #20 =C2=A0Extended offline =C2=A0 =C2=A0Completed without error =C2=A0=
 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13060
> =C2=A0 =C2=A0 -
> #21 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 13042
> =C2=A0 =C2=A0 -
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
>
>

Glad you got it working, but your drive looks like a failing drive to
me, because of these:

187 Reported_Uncorrect      0x0032   082   082   000    Old_age   Alway=
s
     -       18

So I'd replace it ASAP. Cheers,

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
