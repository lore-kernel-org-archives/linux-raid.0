From: "Justin Stephenson" <justin@evensteveninc.com>
Subject: Re[2]: Raid 6 Fail Event
Date: Tue, 18 Nov 2014 02:19:58 +0000
Message-ID: <em9c396e06-5c30-4ce4-a917-a16a5c477168@littlez>
References: <AB2BF2A1-8D2D-4AC0-920F-1D182875A31B@colorremedies.com>
Reply-To: "Justin Stephenson" <justin@evensteveninc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AB2BF2A1-8D2D-4AC0-920F-1D182875A31B@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Chris,


I have read up on the SMART error the drive has been giving me. It is a=
=20
known issue with the SEAGATE 3TB drives I am using. I have swapped the=20
drive out for a new one and am rebuilding right now. I am including the=
=20
dump of the smartctl -x /dev/sdh below.


when i rebooted earlier mdadm kicked the device out so when I tried to=20
--manage fail and --manage remove the drive it told me it did not exist=
=2E


I removed the old drive and installed a spanky new one.



I re formatted the drive with parted as follows (this is how I did my=20
other drives - it is a 7 device raid):


#parted -a optimal

 >mklabel gpt

 >mkpart primary

 >>start 2048s

 >>end -1

 >set
 >>1

 >>raid

 >>on


I readded the newly formatted drive:

#mdadm --manage /dev/md0 --add /dev/sde1



When I check /proc/mdstat everthing seems to be going fine.


I did a smartctl -x on the other drives and they did not turn up this=20
error. I will keep my eye on them though.


See below for the smartctl -x of the failed drive.


Thank-you again for your help.


- Justin


[root@BigBlue Desktop]# smartctl -x /dev/sdh
smartctl 5.43 2012-06-30 r3573 [x86_64-linux-2.6.32-431.3.1.el6.x86_64]=
=20
(local build)
Copyright (C) 2002-12 by Bruce Allen,=20
http://smartmontools.sourceforge.net

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family: Seagate Barracuda (SATA 3Gb/s, 4K Sectors)
Device Model: ST3000DM001-1CH166
Serial Number: Z1F3ZWAY
LU WWN Device Id: 5 000c50 0651b19cc
=46irmware Version: CC27
User Capacity: 3,000,592,982,016 bytes [3.00 TB]
Sector Sizes: 512 bytes logical, 4096 bytes physical
Device is: In smartctl database [for details use: -P show]
ATA Version is: 8
ATA Standard is: ACS-2 (unknown minor revision code: 0x001f)
Local Time is: Mon Nov 17 17:58:16 2014 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is: Unavailable
APM level is: 128 (minimum power consumption without standby)
Rd look-ahead is: Enabled
Write cache is: Enabled
ATA Security is: Disabled, frozen [SEC2]

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status: (0x00) Offline data collection activity
was never started.
Auto Offline Data Collection: Disabled.
Self-test execution status: ( 0) The previous self-test routine=20
completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: ( 584) seconds.
Offline data collection
capabilities: (0x73) SMART execute Offline immediate.
Auto Offline data collection on/off support.
Suspend Offline collection upon new
command.
No Offline surface scan supported.
Self-test supported.
Conveyance Self-test supported.
Selective Self-test supported.
SMART capabilities: (0x0003) Saves SMART data before entering
power-saving mode.
Supports SMART auto save timer.
Error logging capability: (0x01) Error logging supported.
General Purpose Logging supported.
Short self-test routine
recommended polling time: ( 1) minutes.
Extended self-test routine
recommended polling time: ( 320) minutes.
Conveyance self-test routine
recommended polling time: ( 2) minutes.
SCT capabilities: (0x3085) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME FLAGS VALUE WORST THRESH FAIL RAW_VALUE
1 Raw_Read_Error_Rate POSR-- 114 099 006 - 73003456
3 Spin_Up_Time PO---- 094 094 000 - 0
4 Start_Stop_Count -O--CK 100 100 020 - 46
5 Reallocated_Sector_Ct PO--CK 100 100 010 - 0
7 Seek_Error_Rate POSR-- 044 043 030 - 2100251894876
9 Power_On_Hours -O--CK 092 092 000 - 7128
10 Spin_Retry_Count PO--C- 100 100 097 - 0
12 Power_Cycle_Count -O--CK 100 100 020 - 46
183 Runtime_Bad_Block -O--CK 099 099 000 - 1
184 End-to-End_Error -O--CK 094 094 099 NOW 6
187 Reported_Uncorrect -O--CK 100 100 000 - 0
188 Command_Timeout -O--CK 100 100 000 - 0
189 High_Fly_Writes -O-RCK 098 098 000 - 2
190 Airflow_Temperature_Cel -O---K 068 057 045 - 32 (Min/Max 31/33)
191 G-Sense_Error_Rate -O--CK 100 100 000 - 0
192 Power-Off_Retract_Count -O--CK 100 100 000 - 20
193 Load_Cycle_Count -O--CK 084 084 000 - 32594
194 Temperature_Celsius -O---K 032 043 000 - 32 (0 19 0 0 0)
197 Current_Pending_Sector -O--C- 100 100 000 - 0
198 Offline_Uncorrectable ----C- 100 100 000 - 0
199 UDMA_CRC_Error_Count -OSRCK 200 200 000 - 0
240 Head_Flying_Hours ------ 100 253 000 - 265527763141589
241 Total_LBAs_Written ------ 100 253 000 - 12406885927
242 Total_LBAs_Read ------ 100 253 000 - 141450480453
||||||_ K auto-keep
|||||__ C event count
||||___ R error rate
|||____ S speed/performance
||_____ O updated online
|______ P prefailure warning

General Purpose Log Directory Version 1
SMART Log Directory Version 1 [multi-sector log support]
GP/S Log at address 0x00 has 1 sectors [Log Directory]
SMART Log at address 0x01 has 1 sectors [Summary SMART error log]
SMART Log at address 0x02 has 5 sectors [Comprehensive SMART error log]
GP Log at address 0x03 has 5 sectors [Ext. Comprehensive SMART error=20
log]
SMART Log at address 0x06 has 1 sectors [SMART self-test log]
GP Log at address 0x07 has 1 sectors [Extended self-test log]
SMART Log at address 0x09 has 1 sectors [Selective self-test log]
GP Log at address 0x10 has 1 sectors [NCQ Command Error log]
GP Log at address 0x11 has 1 sectors [SATA Phy Event Counters]
GP Log at address 0x21 has 1 sectors [Write stream error log]
GP Log at address 0x22 has 1 sectors [Read stream error log]
GP/S Log at address 0x80 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x81 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x82 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x83 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x84 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x85 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x86 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x87 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x88 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x89 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x8a has 16 sectors [Host vendor specific log]
GP/S Log at address 0x8b has 16 sectors [Host vendor specific log]
GP/S Log at address 0x8c has 16 sectors [Host vendor specific log]
GP/S Log at address 0x8d has 16 sectors [Host vendor specific log]
GP/S Log at address 0x8e has 16 sectors [Host vendor specific log]
GP/S Log at address 0x8f has 16 sectors [Host vendor specific log]
GP/S Log at address 0x90 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x91 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x92 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x93 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x94 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x95 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x96 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x97 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x98 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x99 has 16 sectors [Host vendor specific log]
GP/S Log at address 0x9a has 16 sectors [Host vendor specific log]
GP/S Log at address 0x9b has 16 sectors [Host vendor specific log]
GP/S Log at address 0x9c has 16 sectors [Host vendor specific log]
GP/S Log at address 0x9d has 16 sectors [Host vendor specific log]
GP/S Log at address 0x9e has 16 sectors [Host vendor specific log]
GP/S Log at address 0x9f has 16 sectors [Host vendor specific log]
GP/S Log at address 0xa1 has 20 sectors [Device vendor specific log]
GP Log at address 0xa2 has 4496 sectors [Device vendor specific log]
GP/S Log at address 0xa8 has 129 sectors [Device vendor specific log]
GP/S Log at address 0xa9 has 1 sectors [Device vendor specific log]
GP Log at address 0xab has 1 sectors [Device vendor specific log]
GP Log at address 0xb0 has 5176 sectors [Device vendor specific log]
GP Log at address 0xbe has 65535 sectors [Device vendor specific log]
GP Log at address 0xbf has 65535 sectors [Device vendor specific log]
GP/S Log at address 0xc0 has 1 sectors [Device vendor specific log]
GP/S Log at address 0xc1 has 10 sectors [Device vendor specific log]
GP/S Log at address 0xc4 has 5 sectors [Device vendor specific log]
GP/S Log at address 0xe0 has 1 sectors [SCT Command/Status]
GP/S Log at address 0xe1 has 1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
Device Error Count: 1
CR =3D Command Register
=46EATR =3D Features Register
COUNT =3D Count (was: Sector Count) Register
LBA_48 =3D Upper bytes of LBA High/Mid/Low Registers ] ATA-8
LH =3D LBA High (was: Cylinder High) Register ] LBA
LM =3D LBA Mid (was: Cylinder Low) Register ] Register
LL =3D LBA Low (was: Sector Number) Register ]
DV =3D Device (was: Device/Head) Register
DC =3D Device Control Register
ER =3D Error register
ST =3D Status register
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
SS=3Dsec, and sss=3Dmillisec. It "wraps" after 49.710 days.

Error 1 [0] occurred at disk power-on lifetime: 7093 hours (295 days +=20
13 hours)
When the command that caused the error occurred, the device was active=20
or idle.

After command completion occurred, registers were:
ER -- ST COUNT LBA_48 LH LM LL DV DC
-- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
04 -- 71 00 04 00 00 00 80 87 80 e0 00

Commands leading to the command that caused the error were:
CR FEATR COUNT LBA_48 LH LM LL DV DC Powered_Up_Time=20
Command/Feature_Name
-- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- -- ------------=
---=20
--------------------
ea 00 00 00 00 00 00 00 00 00 00 a0 00 22d+15:53:02.331 FLUSH CACHE EXT
61 00 00 00 01 00 00 00 00 08 08 40 00 22d+15:53:02.330 WRITE FPDMA=20
QUEUED
ea 00 00 00 00 00 00 00 00 00 00 a0 00 22d+15:53:02.330 FLUSH CACHE EXT
ea 00 00 00 00 00 00 00 00 00 00 a0 00 22d+15:52:40.493 FLUSH CACHE EXT
61 00 00 00 01 00 00 00 00 08 08 40 00 22d+15:52:40.492 WRITE FPDMA=20
QUEUED

SMART Extended Self-test Log Version: 1 (1 sectors)
Num Test_Description Status Remaining LifeTime(hours) LBA_of_first_erro=
r
# 1 Short offline Completed without error 00% 7120 -

SMART Selective self-test log data structure revision number 1
SPAN MIN_LBA MAX_LBA CURRENT_TEST_STATUS
1 0 0 Not_testing
2 0 0 Not_testing
3 0 0 Not_testing
4 0 0 Not_testing
5 0 0 Not_testing
Selective self-test flags (0x0):
After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute=20
delay.

Warning: device does not support SCT Data Table command
Warning: device does not support SCT Error Recovery Control command
SATA Phy Event Counters (GP Log 0x11)
ID Size Value Description
0x000a 2 2 Device-to-host register FISes sent due to a COMRESET
0x0001 2 0 Command failed due to ICRC error
0x0003 2 0 R_ERR response for device-to-host data FIS
0x0004 2 0 R_ERR response for host-to-device data FIS
0x0006 2 0 R_ERR response for device-to-host non-data FIS
0x0007 2 0 R_ERR response for host-to-device non-data FIS









On Mon, Nov 17, 2014 at 12:19 PM, Chris Murphy <lists@colorremedies.com=
>=20
wrote:


On Nov 16, 2014, at 6:34 PM, Justin Stephenson=20
<justin@evensteveninc.com> wrote:

 > Thank-you, Chris. I appreciate your help with this.
 >
 > Backup are good. I'm a regular disk to disk to LTO guy. Here is what=
 I=20
have turned up:
 >
 > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
 > # smartctl -x /dev/sdh
 >
 > big long list of stuff.

Please post it.



 > I found the serial.
 >
 > I also tried smartctl -H /dev/sdh and received
 >
 > Overall-health self-assesment test restul: PASSED
 >
 > 184 End-to-End_Error {flag value worst thresh} Old_age FAILING_NOW_6

Cute, it=E2=80=99s failing but it=E2=80=99s overall health is passing. =
This is a great=20
example of why the health self-assess is useless.


 >
 > I did not find anything for the serial in results from dmesg
 >
 > # smartctl -l scterc /dev/sdh
 >
 > Warning: device does not support SCT Commands

Interesting it supports a SMART IV attribut but doesn=E2=80=99t support=
 SCT=20
commands.


 >
 > # cat /sys/block/sdh/device/state
 >
 > Running
 >
 > # cat /sys/block/sdh/device/timeout
 >
 > 30

Since the drives you have don=E2=80=99t support SCT commands, you need =
to set=20
the command timer to something much more than the default of 30,=20
otherwise your array will not function correctly when it encounters bad=
=20
sectors. In many cases the linux scsi command timer will reach 30=20
seconds and reset the interface, before the typical consumer drive=20
recovers (either returns data successfully or an error). This could be=20
quite long, maybe 2 minutes. Future drives you buy should have=20
configurable SCT ERC so the drive can be set to return a read error=20
after something like 7 seconds, i.e. you want the drive to give up=20
sooner, and by informing md of the problem sector range, the data is=20
rebuilt from parity and written back to the bad sectors on the drive=20
where the problem gets fixed.




 >
 > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
 >
 > Should I replace the drive or re add and resync?

Well I don=E2=80=99t know anything about attribute 184 End-to-End error=
, but=20
based on the description in wikipedia it sounds disqualifying to me.

I personally would get the drive replaced no matter what: either under=20
warranty, or if no warranty I=E2=80=99d get a new drive and test/play w=
ith this=20
one offline and if it proves its worth then maybe it can be a spare dow=
n=20
the road.

But you could also smartctl -x all the other drives and see what value=20
they have for this attribute.

 >
 > I also went through and reseated all the SATA and power connections =
as=20
I understand these can cause issues as well.




Chris Murphy



--

Even Steven Inc || Phone and Fax =3D 416-900-6069 || www.evensteveninc.=
com=20
||
--------
Justin Stephenson
Creative Director/Motion Designer
416-900-6069
http://justinstephenson.com



------ Original Message ------
=46rom: "Chris Murphy" <lists@colorremedies.com>
To: "Justin Stephenson" <justin@evensteveninc.com>
Cc: linux-raid@vger.kernel.org
Sent: 17/11/2014 12:19:26 PM
Subject: Re: Raid 6 Fail Event

>
>On Nov 16, 2014, at 6:34 PM, Justin Stephenson=20
><justin@evensteveninc.com> wrote:
>
>>  Thank-you, Chris. I appreciate your help with this.
>>
>>  Backup are good. I'm a regular disk to disk to LTO guy. Here is wha=
t=20
>>I have turned up:
>>
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>  # smartctl -x /dev/sdh
>>
>>  big long list of stuff.
>
>Please post it.
>
>
>
>>  I found the serial.
>>
>>  I also tried smartctl -H /dev/sdh and received
>>
>>  Overall-health self-assesment test restul: PASSED
>>
>>  184 End-to-End_Error {flag value worst thresh} Old_age FAILING_NOW_=
6
>
>Cute, it=E2=80=99s failing but it=E2=80=99s overall health is passing.=
 This is a great=20
>example of why the health self-assess is useless.
>
>
>>
>>  I did not find anything for the serial in results from dmesg
>>
>>  # smartctl -l scterc /dev/sdh
>>
>>  Warning: device does not support SCT Commands
>
>Interesting it supports a SMART IV attribut but doesn=E2=80=99t suppor=
t SCT=20
>commands.
>
>
>>
>>  # cat /sys/block/sdh/device/state
>>
>>  Running
>>
>>  # cat /sys/block/sdh/device/timeout
>>
>>  30
>
>Since the drives you have don=E2=80=99t support SCT commands, you need=
 to set=20
>the command timer to something much more than the default of 30,=20
>otherwise your array will not function correctly when it encounters ba=
d=20
>sectors. In many cases the linux scsi command timer will reach 30=20
>seconds and reset the interface, before the typical consumer drive=20
>recovers (either returns data successfully or an error). This could be=
=20
>quite long, maybe 2 minutes. Future drives you buy should have=20
>configurable SCT ERC so the drive can be set to return a read error=20
>after something like 7 seconds, i.e. you want the drive to give up=20
>sooner, and by informing md of the problem sector range, the data is=20
>rebuilt from parity and written back to the bad sectors on the drive=20
>where the problem gets fixed.
>
>
>
>
>>
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>>  Should I replace the drive or re add and resync?
>
>Well I don=E2=80=99t know anything about attribute 184 End-to-End erro=
r, but=20
>based on the description in wikipedia it sounds disqualifying to me.
>
>I personally would get the drive replaced no matter what: either under=
=20
>warranty, or if no warranty I=E2=80=99d get a new drive and test/play =
with this=20
>one offline and if it proves its worth then maybe it can be a spare=20
>down the road.
>
>But you could also smartctl -x all the other drives and see what value=
=20
>they have for this attribute.
>
>>
>>  I also went through and reseated all the SATA and power connections=
=20
>>as I understand these can cause issues as well.
>
>
>
>
>Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
