From: "Majed B." <majedb@gmail.com>
Subject: Re: Re[2]: raid5: cannot start dirty degraded array
Date: Wed, 23 Dec 2009 16:48:01 +0300
Message-ID: <70ed7c3e0912230548v1abacfcciadaab2888018b202@mail.gmail.com>
References: <579884013.20091223125023@kaneda.iguw.tuwien.ac.at>
	<52151829.20091223135001@kaneda.iguw.tuwien.ac.at> <70ed7c3e0912230525h25566bd8jae95ffab149caf65@mail.gmail.com>
	<953553783.20091223144402@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <953553783.20091223144402@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My bad, run this: mdadm -E /dev/sd[a-z]1
1 is the partition which most likely you added to the array rather
than the whole disk (which is normal).

You've included the smart report of one disk only. I suggest you look
at the other disks as well and make sure that they're not reporting
any errors. Also, keep in mind that you should run smart test
periodically (can be configured) and that if you haven't run any test
before, you have to run a long or offline test before making sure that
you don't have bad sectors.

On Wed, Dec 23, 2009 at 4:44 PM, Rainer Fuegenstein
<rfu@kaneda.iguw.tuwien.ac.at> wrote:
>
> MB> Give the output of these:
> MB> mdadm -E /dev/sd[a-z]
>
> ]# mdadm -E /dev/sd[a-z]
> mdadm: No md superblock detected on /dev/sda.
> mdadm: No md superblock detected on /dev/sdb.
> mdadm: No md superblock detected on /dev/sdc.
> mdadm: No md superblock detected on /dev/sdd.
>
> I assume that's not a good sign ?!
>
> sda was powered on and running after the reboot, a smartctl short tes=
t
> revealed no errors and smartctl -a also looks unsuspicious (see
> below). the drives are rather new.
>
> guess its more likely to be either a problem of the power supply
> (400W) or communication between controller and disk.
>
> /dev/sdd (before it was replaced) reported the following:
>
> Dec 20 07:18:54 alfred smartd[2705]: Device: /dev/sdd, 1 Offline unco=
rrectable sectors
> Dec 20 07:48:53 alfred smartd[2705]: Device: /dev/sdd, 1 Offline unco=
rrectable sectors
> Dec 20 08:18:54 alfred smartd[2705]: Device: /dev/sdd, 1 Offline unco=
rrectable sectors
> Dec 20 08:48:55 alfred smartd[2705]: Device: /dev/sdd, 1 Offline unco=
rrectable sectors
> Dec 20 09:18:53 alfred smartd[2705]: Device: /dev/sdd, 1 Offline unco=
rrectable sectors
> Dec 20 09:48:58 alfred smartd[2705]: Device: /dev/sdd, 1 Offline unco=
rrectable sectors
> Dec 20 10:19:01 alfred smartd[2705]: Device: /dev/sdd, 1 Offline unco=
rrectable sectors
> Dec 20 10:48:54 alfred smartd[2705]: Device: /dev/sdd, 1 Offline unco=
rrectable sectors
>
> (what triggered a re-sync of the array)
>
>
> # smartctl -a /dev/sda
> smartctl version 5.38 [i686-redhat-linux-gnu] Copyright (C) 2002-8 Br=
uce Allen
> Home page is http://smartmontools.sourceforge.net/
>
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Device Model: =C2=A0 =C2=A0 WDC WD15EADS-00R6B0
> Serial Number: =C2=A0 =C2=A0WD-WCAUP0017818
> Firmware Version: 01.00A01
> User Capacity: =C2=A0 =C2=A01,500,301,910,016 bytes
> Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0Not in smartctl database [for d=
etails use: -P showall]
> ATA Version is: =C2=A0 8
> ATA Standard is: =C2=A0Exact ATA specification draft version not indi=
cated
> Local Time is: =C2=A0 =C2=A0Wed Dec 23 14:40:46 2009 CET
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
ous self-test routine completed
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0w=
ithout error or no self-test has ever
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b=
een run.
> Total time to complete Offline
> data collection: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 (40800) seconds.
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
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( =C2=A0 2) minu=
tes.
> Extended self-test routine
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( 255) minutes.
> Conveyance self-test routine
> recommended polling time: =C2=A0 =C2=A0 =C2=A0 =C2=A0( =C2=A0 5) minu=
tes.
> SCT capabilities: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(0x=
303f) SCT Status supported.
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
 VALUE WORST THRESH TYPE =C2=A0 =C2=A0 =C2=A0UPDATED =C2=A0WHEN_FAILED =
RAW_VALUE
> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x002f =C2=A0 200 =C2=A0 20=
0 =C2=A0 051 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =C2=A0 - =
=C2=A0 =C2=A0 =C2=A0 0
> =C2=A03 Spin_Up_Time =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0027 =
=C2=A0 177 =C2=A0 145 =C2=A0 021 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=
=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 8133
> =C2=A04 Start_Stop_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100=
 =C2=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0=
 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 15
> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 200 =C2=A0 200 =C2=
=A0 140 =C2=A0 =C2=A0Pre-fail =C2=A0Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0=
 =C2=A0 =C2=A0 0
> =C2=A07 Seek_Error_Rate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x002e =C2=A0 200=
 =C2=A0 200 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0=
 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A09 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 093 =C2=A0 093 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=
=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 5272
> =C2=A010 Spin_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 10=
0 =C2=A0 253 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0=
 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A011 Calibration_Retry_Count 0x0032 =C2=A0 100 =C2=A0 253 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=
=A0 =C2=A0 0
> =C2=A012 Power_Cycle_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0 =C2=
=A0 - =C2=A0 =C2=A0 =C2=A0 14
> 192 Power-Off_Retract_Count 0x0032 =C2=A0 200 =C2=A0 200 =C2=A0 000 =C2=
=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=
=A0 2
> 193 Load_Cycle_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 200 =C2=
=A0 200 =C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0 =C2=
=A0 - =C2=A0 =C2=A0 =C2=A0 13
> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0022 =C2=A0 125 =C2=A0 109 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0=
 =C2=A0 =C2=A0 27
> 196 Reallocated_Event_Count 0x0032 =C2=A0 200 =C2=A0 200 =C2=A0 000 =C2=
=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=
=A0 0
> 197 Current_Pending_Sector =C2=A00x0032 =C2=A0 200 =C2=A0 200 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=
=A0 =C2=A0 0
> 198 Offline_Uncorrectable =C2=A0 0x0030 =C2=A0 200 =C2=A0 200 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=
=A0 =C2=A0 0
> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x0032 =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0=
 =C2=A0 =C2=A0 0
> 200 Multi_Zone_Error_Rate =C2=A0 0x0008 =C2=A0 200 =C2=A0 200 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=
=A0 =C2=A0 0
>
> SMART Error Log Version: 1
> No Errors Logged
>
> SMART Self-test log structure revision number 1
> Num =C2=A0Test_Description =C2=A0 =C2=A0Status =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remaining =C2=A0LifeTime(hours) =C2=
=A0LBA_of_first_error
> # 1 =C2=A0Short offline =C2=A0 =C2=A0 =C2=A0 Completed without error =
=C2=A0 =C2=A0 =C2=A0 00% =C2=A0 =C2=A0 =C2=A05272 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 -
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
>>>From the errors you show, it seems like one of the disks is dead (sd=
a)
> MB> or dying. It could be just a bad PCB (the controller board of the
> MB> disk) as it refuses to return SMART data, so you might be able to
> MB> rescue data by changing the PCB, if it's that important to have t=
hat
> MB> disk.
>
> MB> As for the array, you can run a degraded array by force assemblin=
g it:
> MB> mdadm -Af /dev/md0
> MB> In the command above, mdadm will search on existing disks and
> MB> partitions, which of them belongs to an array and assemble that a=
rray,
> MB> if possible.
>
> MB> I also suggest you install smartmontools package and run smartctl=
 -a
> MB> /dev/sd[a-z] and see the report for each disk to make sure you do=
n't
> MB> have bad sectors or bad cables (CRC/ATA read errors) on any of th=
e
> MB> disks.
>
> MB> On Wed, Dec 23, 2009 at 3:50 PM, Rainer Fuegenstein
> MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
>>> addendum: when going through the logs I found the reason:
>>>
>>> Dec 23 02:55:40 alfred kernel: ata1.00: exception Emask 0x0 SAct 0x=
0 SErr 0x0 action 0x6 frozen
>>> Dec 23 02:55:40 alfred kernel: ata1.00: cmd ea/00:00:00:00:00/00:00=
:00:00:00/a0 tag 0
>>> Dec 23 02:55:40 alfred kernel: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0re=
s 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> Dec 23 02:55:40 alfred kernel: ata1.00: status: { DRDY }
>>> Dec 23 02:55:45 alfred kernel: ata1: link is slow to respond, pleas=
e be patient (ready=3D0)
>>> Dec 23 02:55:50 alfred kernel: ata1: device not ready (errno=3D-16)=
, forcing hardreset
>>> Dec 23 02:55:50 alfred kernel: ata1: soft resetting link
>>> Dec 23 02:55:55 alfred kernel: ata1: link is slow to respond, pleas=
e be patient (ready=3D0)
>>> Dec 23 02:56:00 alfred kernel: ata1: SRST failed (errno=3D-16)
>>> Dec 23 02:56:00 alfred kernel: ata1: soft resetting link
>>> Dec 23 02:56:05 alfred kernel: ata1: link is slow to respond, pleas=
e be patient (ready=3D0)
>>> Dec 23 02:56:10 alfred kernel: ata1: SRST failed (errno=3D-16)
>>> Dec 23 02:56:10 alfred kernel: ata1: soft resetting link
>>> Dec 23 02:56:15 alfred kernel: ata1: link is slow to respond, pleas=
e be patient (ready=3D0)
>>> Dec 23 02:56:45 alfred kernel: ata1: SRST failed (errno=3D-16)
>>> Dec 23 02:56:45 alfred kernel: ata1: limiting SATA link speed to 1.=
5 Gbps
>>> Dec 23 02:56:45 alfred kernel: ata1: soft resetting link
>>> Dec 23 02:56:50 alfred kernel: ata1: SRST failed (errno=3D-16)
>>> Dec 23 02:56:50 alfred kernel: ata1: reset failed, giving up
>>> Dec 23 02:56:50 alfred kernel: ata1.00: disabled
>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: timing out command, wait=
ed 30s
>>> Dec 23 02:56:50 alfred kernel: ata1: EH complete
>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code =
=3D 0x00040000
>>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, sec=
tor 1244700223
>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code =
=3D 0x00040000
>>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, sec=
tor 1554309191
>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code =
=3D 0x00040000
>>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, sec=
tor 1554309439
>>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code =
=3D 0x00040000
>>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, sec=
tor 572721343
>>> Dec 23 02:56:50 alfred kernel: raid5: Disk failure on sda1, disabli=
ng device. Operation continuing on 3 devices
>>> Dec 23 02:56:50 alfred kernel: RAID5 conf printout:
>>> Dec 23 02:56:50 alfred kernel: =C2=A0--- rd:4 wd:3 fd:1
>>> Dec 23 02:56:50 alfred kernel: =C2=A0disk 0, o:1, dev:sdb1
>>> Dec 23 02:56:50 alfred kernel: =C2=A0disk 1, o:1, dev:sdd1
>>> Dec 23 02:56:50 alfred kernel: =C2=A0disk 2, o:0, dev:sda1
>>> Dec 23 02:56:50 alfred kernel: =C2=A0disk 3, o:1, dev:sdc1
>>> Dec 23 02:56:50 alfred kernel: RAID5 conf printout:
>>> Dec 23 02:56:50 alfred kernel: =C2=A0--- rd:4 wd:3 fd:1
>>> Dec 23 02:56:50 alfred kernel: =C2=A0disk 0, o:1, dev:sdb1
>>> Dec 23 02:56:50 alfred kernel: =C2=A0disk 1, o:1, dev:sdd1
>>> Dec 23 02:56:50 alfred kernel: =C2=A0disk 3, o:1, dev:sdc1
>>> Dec 23 03:22:57 alfred smartd[2692]: Device: /dev/sda, not capable =
of SMART self-check
>>> Dec 23 03:22:57 alfred smartd[2692]: Sending warning via mail to ro=
ot ...
>>> Dec 23 03:22:58 alfred smartd[2692]: Warning via mail to root: succ=
essful
>>> Dec 23 03:22:58 alfred smartd[2692]: Device: /dev/sda, failed to re=
ad SMART Attribute Data
>>> Dec 23 03:22:58 alfred smartd[2692]: Sending warning via mail to ro=
ot ...
>>> Dec 23 03:22:58 alfred smartd[2692]: Warning via mail to root: succ=
essful
>>> Dec 23 03:52:57 alfred smartd[2692]: Device: /dev/sda, not capable =
of SMART self-check
>>> Dec 23 03:52:57 alfred smartd[2692]: Device: /dev/sda, failed to re=
ad SMART Attribute Data
>>> Dec 23 04:22:57 alfred smartd[2692]: Device: /dev/sda, not capable =
of SMART self-check
>>> Dec 23 04:22:57 alfred smartd[2692]: Device: /dev/sda, failed to re=
ad SMART Attribute Data
>>> Dec 23 04:52:57 alfred smartd[2692]: Device: /dev/sda, not capable =
of SMART self-check
>>> =C2=A0[...]
>>> Dec 23 09:52:57 alfred smartd[2692]: Device: /dev/sda, not capable =
of SMART self-check
>>> Dec 23 09:52:57 alfred smartd[2692]: Device: /dev/sda, failed to re=
ad SMART Attribute Data
>>> =C2=A0(crash here)
>>>
>>>
>>> RF> hi,
>>>
>>> RF> got a "nice" early christmas present this morning: after a cras=
h, the raid5
>>> RF> (consisting of 4*1.5TB WD caviar green SATA disks) won't start =
:-(
>>>
>>> RF> the history:
>>> RF> sometimes, the raid kicked out one disk, started a resync (whic=
h
>>> RF> lasted for about 3 days) and was fine after that. a few days ag=
o I
>>> RF> replaced drive sdd (which seemed to cause the troubles) and syn=
ced the
>>> RF> raid again which finished yesterday in the early afternoon. at =
10am
>>> RF> today the system crashed and the raid won't start:
>>>
>>> RF> OS is Centos 5
>>> RF> mdadm - v2.6.9 - 10th March 2009
>>> RF> Linux alfred 2.6.18-164.6.1.el5xen #1 SMP Tue Nov 3 17:53:47 ES=
T 2009 i686 athlon i386 GNU/Linux
>>>
>>>
>>> RF> Dec 23 12:30:19 alfred kernel: md: Autodetecting RAID arrays.
>>> RF> Dec 23 12:30:19 alfred kernel: md: autorun ...
>>> RF> Dec 23 12:30:19 alfred kernel: md: considering sdd1 ...
>>> RF> Dec 23 12:30:19 alfred kernel: md: =C2=A0adding sdd1 ...
>>> RF> Dec 23 12:30:19 alfred kernel: md: =C2=A0adding sdc1 ...
>>> RF> Dec 23 12:30:19 alfred kernel: md: =C2=A0adding sdb1 ...
>>> RF> Dec 23 12:30:19 alfred kernel: md: =C2=A0adding sda1 ...
>>> RF> Dec 23 12:30:19 alfred kernel: md: created md0
>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sda1>
>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdb1>
>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdc1>
>>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdd1>
>>> RF> Dec 23 12:30:19 alfred kernel: md: running: <sdd1><sdc1><sdb1><=
sda1>
>>> RF> Dec 23 12:30:19 alfred kernel: md: kicking non-fresh sda1 from =
array!
>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sda1>
>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sda1)
>>> RF> Dec 23 12:30:19 alfred kernel: md: md0: raid array is not clean=
 -- starting background reconstruction
>>> RF> =C2=A0 =C2=A0 (no reconstruction is actually started, disks are=
 idle)
>>> RF> Dec 23 12:30:19 alfred kernel: raid5: automatically using best =
checksumming function: pIII_sse
>>> RF> Dec 23 12:30:19 alfred kernel: =C2=A0 =C2=A0pIII_sse =C2=A0: =C2=
=A07085.000 MB/sec
>>> RF> Dec 23 12:30:19 alfred kernel: raid5: using function: pIII_sse =
(7085.000 MB/sec)
>>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x1 =C2=A0 =C2=A0896 =
MB/s
>>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x2 =C2=A0 =C2=A0972 =
MB/s
>>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x4 =C2=A0 =C2=A0893 =
MB/s
>>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x8 =C2=A0 =C2=A0934 =
MB/s
>>> RF> Dec 23 12:30:19 alfred kernel: raid6: mmxx1 =C2=A0 =C2=A0 1845 =
MB/s
>>> RF> Dec 23 12:30:19 alfred kernel: raid6: mmxx2 =C2=A0 =C2=A0 3250 =
MB/s
>>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse1x1 =C2=A0 =C2=A01799 =
MB/s
>>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse1x2 =C2=A0 =C2=A03067 =
MB/s
>>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse2x1 =C2=A0 =C2=A02980 =
MB/s
>>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse2x2 =C2=A0 =C2=A04015 =
MB/s
>>> RF> Dec 23 12:30:19 alfred kernel: raid6: using algorithm sse2x2 (4=
015 MB/s)
>>> RF> Dec 23 12:30:19 alfred kernel: md: raid6 personality registered=
 for level 6
>>> RF> Dec 23 12:30:19 alfred kernel: md: raid5 personality registered=
 for level 5
>>> RF> Dec 23 12:30:19 alfred kernel: md: raid4 personality registered=
 for level 4
>>> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdd1 operational a=
s raid disk 1
>>> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdc1 operational a=
s raid disk 3
>>> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdb1 operational a=
s raid disk 0
>>> RF> Dec 23 12:30:19 alfred kernel: raid5: cannot start dirty degrad=
ed array for md0
>>> RF> Dec 23 12:30:19 alfred kernel: RAID5 conf printout:
>>> RF> Dec 23 12:30:19 alfred kernel: =C2=A0--- rd:4 wd:3 fd:1
>>> RF> Dec 23 12:30:19 alfred kernel: =C2=A0disk 0, o:1, dev:sdb1
>>> RF> Dec 23 12:30:19 alfred kernel: =C2=A0disk 1, o:1, dev:sdd1
>>> RF> Dec 23 12:30:19 alfred kernel: =C2=A0disk 3, o:1, dev:sdc1
>>> RF> Dec 23 12:30:19 alfred kernel: raid5: failed to run raid set md=
0
>>> RF> Dec 23 12:30:19 alfred kernel: md: pers->run() failed ...
>>> RF> Dec 23 12:30:19 alfred kernel: md: do_md_run() returned -5
>>> RF> Dec 23 12:30:19 alfred kernel: md: md0 stopped.
>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdd1>
>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdd1)
>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdc1>
>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdc1)
>>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdb1>
>>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdb1)
>>> RF> Dec 23 12:30:19 alfred kernel: md: ... autorun DONE.
>>> RF> Dec 23 12:30:19 alfred kernel: device-mapper: multipath: versio=
n 1.0.5 loaded
>>>
>>> RF> # cat /proc/mdstat
>>> RF> Personalities : [raid6] [raid5] [raid4]
>>> RF> unused devices: <none>
>>>
>>> RF> filesystem used on top of md0 is xfs.
>>>
>>> RF> please advice what to do next and let me know if you need furth=
er
>>> RF> information. really don't want to lose 3TB worth of data :-(
>>>
>>>
>>> RF> tnx in advance.
>>>
>>> RF> --
>>> RF> To unsubscribe from this list: send the line "unsubscribe linux=
-raid" in
>>> RF> the body of a message to majordomo@vger.kernel.org
>>> RF> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-i=
nfo.html
>>>
>>>
>>> -------------------------------------------------------------------=
-----------
>>> Unix gives you just enough rope to hang yourself -- and then a coup=
le of more
>>> feet, just to be sure.
>>> (Eric Allman)
>>> -------------------------------------------------------------------=
-----------
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>>
>
>
>
>
>
> ---------------------------------------------------------------------=
---------
> Unix gives you just enough rope to hang yourself -- and then a couple=
 of more
> feet, just to be sure.
> (Eric Allman)
> ---------------------------------------------------------------------=
---------
>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
