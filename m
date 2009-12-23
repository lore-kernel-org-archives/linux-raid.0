From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: Re[2]: raid5: cannot start dirty degraded array
Date: Wed, 23 Dec 2009 14:44:02 +0100
Message-ID: <953553783.20091223144402@kaneda.iguw.tuwien.ac.at>
References: <579884013.20091223125023@kaneda.iguw.tuwien.ac.at>
 <52151829.20091223135001@kaneda.iguw.tuwien.ac.at>
 <70ed7c3e0912230525h25566bd8jae95ffab149caf65@mail.gmail.com>
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0912230525h25566bd8jae95ffab149caf65@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


MB> Give the output of these:
MB> mdadm -E /dev/sd[a-z]

]# mdadm -E /dev/sd[a-z]
mdadm: No md superblock detected on /dev/sda.
mdadm: No md superblock detected on /dev/sdb.
mdadm: No md superblock detected on /dev/sdc.
mdadm: No md superblock detected on /dev/sdd.

I assume that's not a good sign ?!

sda was powered on and running after the reboot, a smartctl short test
revealed no errors and smartctl -a also looks unsuspicious (see
below). the drives are rather new.

guess its more likely to be either a problem of the power supply
(400W) or communication between controller and disk.

/dev/sdd (before it was replaced) reported the following:

Dec 20 07:18:54 alfred smartd[2705]: Device: /dev/sdd, 1 Offline uncorr=
ectable sectors
Dec 20 07:48:53 alfred smartd[2705]: Device: /dev/sdd, 1 Offline uncorr=
ectable sectors
Dec 20 08:18:54 alfred smartd[2705]: Device: /dev/sdd, 1 Offline uncorr=
ectable sectors
Dec 20 08:48:55 alfred smartd[2705]: Device: /dev/sdd, 1 Offline uncorr=
ectable sectors
Dec 20 09:18:53 alfred smartd[2705]: Device: /dev/sdd, 1 Offline uncorr=
ectable sectors
Dec 20 09:48:58 alfred smartd[2705]: Device: /dev/sdd, 1 Offline uncorr=
ectable sectors
Dec 20 10:19:01 alfred smartd[2705]: Device: /dev/sdd, 1 Offline uncorr=
ectable sectors
Dec 20 10:48:54 alfred smartd[2705]: Device: /dev/sdd, 1 Offline uncorr=
ectable sectors

(what triggered a re-sync of the array)


# smartctl -a /dev/sda
smartctl version 5.38 [i686-redhat-linux-gnu] Copyright (C) 2002-8 Bruc=
e Allen
Home page is http://smartmontools.sourceforge.net/

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD15EADS-00R6B0
Serial Number:    WD-WCAUP0017818
=46irmware Version: 01.00A01
User Capacity:    1,500,301,910,016 bytes
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Dec 23 14:40:46 2009 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activit=
y
                                        was completed without error.
                                        Auto Offline Data Collection: E=
nabled.
Self-test execution status:      (   0) The previous self-test routine =
completed
                                        without error or no self-test h=
as ever
                                        been run.
Total time to complete Offline
data collection:                 (40800) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate=
=2E
                                        Auto Offline data collection on=
/off support.
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
SCT capabilities:              (0x303f) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0027   177   145   021    Pre-fail  Alway=
s       -       8133
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       15
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   093   093   000    Old_age   Alway=
s       -       5272
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       14
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       2
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s       -       13
194 Temperature_Celsius     0x0022   125   109   000    Old_age   Alway=
s       -       27
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(ho=
urs)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      5272   =
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



>>From the errors you show, it seems like one of the disks is dead (sda=
)
MB> or dying. It could be just a bad PCB (the controller board of the
MB> disk) as it refuses to return SMART data, so you might be able to
MB> rescue data by changing the PCB, if it's that important to have tha=
t
MB> disk.

MB> As for the array, you can run a degraded array by force assembling =
it:
MB> mdadm -Af /dev/md0
MB> In the command above, mdadm will search on existing disks and
MB> partitions, which of them belongs to an array and assemble that arr=
ay,
MB> if possible.

MB> I also suggest you install smartmontools package and run smartctl -=
a
MB> /dev/sd[a-z] and see the report for each disk to make sure you don'=
t
MB> have bad sectors or bad cables (CRC/ATA read errors) on any of the
MB> disks.

MB> On Wed, Dec 23, 2009 at 3:50 PM, Rainer Fuegenstein
MB> <rfu@kaneda.iguw.tuwien.ac.at> wrote:
>> addendum: when going through the logs I found the reason:
>>
>> Dec 23 02:55:40 alfred kernel: ata1.00: exception Emask 0x0 SAct 0x0=
 SErr 0x0 action 0x6 frozen
>> Dec 23 02:55:40 alfred kernel: ata1.00: cmd ea/00:00:00:00:00/00:00:=
00:00:00/a0 tag 0
>> Dec 23 02:55:40 alfred kernel: =A0 =A0 =A0 =A0 =A0res 40/00:00:00:00=
:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> Dec 23 02:55:40 alfred kernel: ata1.00: status: { DRDY }
>> Dec 23 02:55:45 alfred kernel: ata1: link is slow to respond, please=
 be patient (ready=3D0)
>> Dec 23 02:55:50 alfred kernel: ata1: device not ready (errno=3D-16),=
 forcing hardreset
>> Dec 23 02:55:50 alfred kernel: ata1: soft resetting link
>> Dec 23 02:55:55 alfred kernel: ata1: link is slow to respond, please=
 be patient (ready=3D0)
>> Dec 23 02:56:00 alfred kernel: ata1: SRST failed (errno=3D-16)
>> Dec 23 02:56:00 alfred kernel: ata1: soft resetting link
>> Dec 23 02:56:05 alfred kernel: ata1: link is slow to respond, please=
 be patient (ready=3D0)
>> Dec 23 02:56:10 alfred kernel: ata1: SRST failed (errno=3D-16)
>> Dec 23 02:56:10 alfred kernel: ata1: soft resetting link
>> Dec 23 02:56:15 alfred kernel: ata1: link is slow to respond, please=
 be patient (ready=3D0)
>> Dec 23 02:56:45 alfred kernel: ata1: SRST failed (errno=3D-16)
>> Dec 23 02:56:45 alfred kernel: ata1: limiting SATA link speed to 1.5=
 Gbps
>> Dec 23 02:56:45 alfred kernel: ata1: soft resetting link
>> Dec 23 02:56:50 alfred kernel: ata1: SRST failed (errno=3D-16)
>> Dec 23 02:56:50 alfred kernel: ata1: reset failed, giving up
>> Dec 23 02:56:50 alfred kernel: ata1.00: disabled
>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: timing out command, waite=
d 30s
>> Dec 23 02:56:50 alfred kernel: ata1: EH complete
>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code =3D=
 0x00040000
>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, sect=
or 1244700223
>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code =3D=
 0x00040000
>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, sect=
or 1554309191
>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code =3D=
 0x00040000
>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, sect=
or 1554309439
>> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code =3D=
 0x00040000
>> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, sect=
or 572721343
>> Dec 23 02:56:50 alfred kernel: raid5: Disk failure on sda1, disablin=
g device. Operation continuing on 3 devices
>> Dec 23 02:56:50 alfred kernel: RAID5 conf printout:
>> Dec 23 02:56:50 alfred kernel: =A0--- rd:4 wd:3 fd:1
>> Dec 23 02:56:50 alfred kernel: =A0disk 0, o:1, dev:sdb1
>> Dec 23 02:56:50 alfred kernel: =A0disk 1, o:1, dev:sdd1
>> Dec 23 02:56:50 alfred kernel: =A0disk 2, o:0, dev:sda1
>> Dec 23 02:56:50 alfred kernel: =A0disk 3, o:1, dev:sdc1
>> Dec 23 02:56:50 alfred kernel: RAID5 conf printout:
>> Dec 23 02:56:50 alfred kernel: =A0--- rd:4 wd:3 fd:1
>> Dec 23 02:56:50 alfred kernel: =A0disk 0, o:1, dev:sdb1
>> Dec 23 02:56:50 alfred kernel: =A0disk 1, o:1, dev:sdd1
>> Dec 23 02:56:50 alfred kernel: =A0disk 3, o:1, dev:sdc1
>> Dec 23 03:22:57 alfred smartd[2692]: Device: /dev/sda, not capable o=
f SMART self-check
>> Dec 23 03:22:57 alfred smartd[2692]: Sending warning via mail to roo=
t ...
>> Dec 23 03:22:58 alfred smartd[2692]: Warning via mail to root: succe=
ssful
>> Dec 23 03:22:58 alfred smartd[2692]: Device: /dev/sda, failed to rea=
d SMART Attribute Data
>> Dec 23 03:22:58 alfred smartd[2692]: Sending warning via mail to roo=
t ...
>> Dec 23 03:22:58 alfred smartd[2692]: Warning via mail to root: succe=
ssful
>> Dec 23 03:52:57 alfred smartd[2692]: Device: /dev/sda, not capable o=
f SMART self-check
>> Dec 23 03:52:57 alfred smartd[2692]: Device: /dev/sda, failed to rea=
d SMART Attribute Data
>> Dec 23 04:22:57 alfred smartd[2692]: Device: /dev/sda, not capable o=
f SMART self-check
>> Dec 23 04:22:57 alfred smartd[2692]: Device: /dev/sda, failed to rea=
d SMART Attribute Data
>> Dec 23 04:52:57 alfred smartd[2692]: Device: /dev/sda, not capable o=
f SMART self-check
>> =A0[...]
>> Dec 23 09:52:57 alfred smartd[2692]: Device: /dev/sda, not capable o=
f SMART self-check
>> Dec 23 09:52:57 alfred smartd[2692]: Device: /dev/sda, failed to rea=
d SMART Attribute Data
>> =A0(crash here)
>>
>>
>> RF> hi,
>>
>> RF> got a "nice" early christmas present this morning: after a crash=
, the raid5
>> RF> (consisting of 4*1.5TB WD caviar green SATA disks) won't start :=
-(
>>
>> RF> the history:
>> RF> sometimes, the raid kicked out one disk, started a resync (which
>> RF> lasted for about 3 days) and was fine after that. a few days ago=
 I
>> RF> replaced drive sdd (which seemed to cause the troubles) and sync=
ed the
>> RF> raid again which finished yesterday in the early afternoon. at 1=
0am
>> RF> today the system crashed and the raid won't start:
>>
>> RF> OS is Centos 5
>> RF> mdadm - v2.6.9 - 10th March 2009
>> RF> Linux alfred 2.6.18-164.6.1.el5xen #1 SMP Tue Nov 3 17:53:47 EST=
 2009 i686 athlon i386 GNU/Linux
>>
>>
>> RF> Dec 23 12:30:19 alfred kernel: md: Autodetecting RAID arrays.
>> RF> Dec 23 12:30:19 alfred kernel: md: autorun ...
>> RF> Dec 23 12:30:19 alfred kernel: md: considering sdd1 ...
>> RF> Dec 23 12:30:19 alfred kernel: md: =A0adding sdd1 ...
>> RF> Dec 23 12:30:19 alfred kernel: md: =A0adding sdc1 ...
>> RF> Dec 23 12:30:19 alfred kernel: md: =A0adding sdb1 ...
>> RF> Dec 23 12:30:19 alfred kernel: md: =A0adding sda1 ...
>> RF> Dec 23 12:30:19 alfred kernel: md: created md0
>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sda1>
>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdb1>
>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdc1>
>> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdd1>
>> RF> Dec 23 12:30:19 alfred kernel: md: running: <sdd1><sdc1><sdb1><s=
da1>
>> RF> Dec 23 12:30:19 alfred kernel: md: kicking non-fresh sda1 from a=
rray!
>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sda1>
>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sda1)
>> RF> Dec 23 12:30:19 alfred kernel: md: md0: raid array is not clean =
-- starting background reconstruction
>> RF> =A0 =A0 (no reconstruction is actually started, disks are idle)
>> RF> Dec 23 12:30:19 alfred kernel: raid5: automatically using best c=
hecksumming function: pIII_sse
>> RF> Dec 23 12:30:19 alfred kernel: =A0 =A0pIII_sse =A0: =A07085.000 =
MB/sec
>> RF> Dec 23 12:30:19 alfred kernel: raid5: using function: pIII_sse (=
7085.000 MB/sec)
>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x1 =A0 =A0896 MB/s
>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x2 =A0 =A0972 MB/s
>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x4 =A0 =A0893 MB/s
>> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x8 =A0 =A0934 MB/s
>> RF> Dec 23 12:30:19 alfred kernel: raid6: mmxx1 =A0 =A0 1845 MB/s
>> RF> Dec 23 12:30:19 alfred kernel: raid6: mmxx2 =A0 =A0 3250 MB/s
>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse1x1 =A0 =A01799 MB/s
>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse1x2 =A0 =A03067 MB/s
>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse2x1 =A0 =A02980 MB/s
>> RF> Dec 23 12:30:19 alfred kernel: raid6: sse2x2 =A0 =A04015 MB/s
>> RF> Dec 23 12:30:19 alfred kernel: raid6: using algorithm sse2x2 (40=
15 MB/s)
>> RF> Dec 23 12:30:19 alfred kernel: md: raid6 personality registered =
for level 6
>> RF> Dec 23 12:30:19 alfred kernel: md: raid5 personality registered =
for level 5
>> RF> Dec 23 12:30:19 alfred kernel: md: raid4 personality registered =
for level 4
>> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdd1 operational as=
 raid disk 1
>> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdc1 operational as=
 raid disk 3
>> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdb1 operational as=
 raid disk 0
>> RF> Dec 23 12:30:19 alfred kernel: raid5: cannot start dirty degrade=
d array for md0
>> RF> Dec 23 12:30:19 alfred kernel: RAID5 conf printout:
>> RF> Dec 23 12:30:19 alfred kernel: =A0--- rd:4 wd:3 fd:1
>> RF> Dec 23 12:30:19 alfred kernel: =A0disk 0, o:1, dev:sdb1
>> RF> Dec 23 12:30:19 alfred kernel: =A0disk 1, o:1, dev:sdd1
>> RF> Dec 23 12:30:19 alfred kernel: =A0disk 3, o:1, dev:sdc1
>> RF> Dec 23 12:30:19 alfred kernel: raid5: failed to run raid set md0
>> RF> Dec 23 12:30:19 alfred kernel: md: pers->run() failed ...
>> RF> Dec 23 12:30:19 alfred kernel: md: do_md_run() returned -5
>> RF> Dec 23 12:30:19 alfred kernel: md: md0 stopped.
>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdd1>
>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdd1)
>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdc1>
>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdc1)
>> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdb1>
>> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdb1)
>> RF> Dec 23 12:30:19 alfred kernel: md: ... autorun DONE.
>> RF> Dec 23 12:30:19 alfred kernel: device-mapper: multipath: version=
 1.0.5 loaded
>>
>> RF> # cat /proc/mdstat
>> RF> Personalities : [raid6] [raid5] [raid4]
>> RF> unused devices: <none>
>>
>> RF> filesystem used on top of md0 is xfs.
>>
>> RF> please advice what to do next and let me know if you need furthe=
r
>> RF> information. really don't want to lose 3TB worth of data :-(
>>
>>
>> RF> tnx in advance.
>>
>> RF> --
>> RF> To unsubscribe from this list: send the line "unsubscribe linux-=
raid" in
>> RF> the body of a message to majordomo@vger.kernel.org
>> RF> More majordomo info at =A0http://vger.kernel.org/majordomo-info.=
html
>>
>>
>> --------------------------------------------------------------------=
----------
>> Unix gives you just enough rope to hang yourself -- and then a coupl=
e of more
>> feet, just to be sure.
>> (Eric Allman)
>> --------------------------------------------------------------------=
----------
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>





-----------------------------------------------------------------------=
-------
Unix gives you just enough rope to hang yourself -- and then a couple o=
f more=20
feet, just to be sure.
(Eric Allman)
-----------------------------------------------------------------------=
-------

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
