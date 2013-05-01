From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: replacing drives
Date: Wed, 1 May 2013 15:14:40 -0300
Message-ID: <CAH3kUhGnUe8gUCy7zncHYDa-ROaCgDFBCoi=qMkBnYDxQbSHSg@mail.gmail.com>
References: <517A8EB5.8080100@supsi.ch>
	<20130426155347.GA9928@cthulhu.home.robinhill.me.uk>
	<517FC46A.1080702@supsi.ch>
	<alpine.DEB.2.00.1304301519350.26743@uplift.swm.pp.se>
	<517FD7BE.8040401@supsi.ch>
	<517FDF24.9000807@turmel.org>
	<CAH3kUhGLW9oZjnCAAF=vF_m0_RK3u3NxscmWQFFznEEOnRoK3w@mail.gmail.com>
	<518075FA.107@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <518075FA.107@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Phil Turmel <philip@turmel.org>, Roberto Nunnari <roberto.nunnari@supsi.ch>, Mikael Abrahamsson <swmike@swm.pp.se>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2013/4/30 Brad Campbell <lists2009@fnarfbargle.com>:
> On 30/04/13 23:39, Roberto Spadim wrote:
>>
>> check disk temperature via smartctl
>> some sata disks stop running after 55C and wait any time (a day if
>> needed) to get temperature down to +-53C and resume operation
>>
>
> G'day Roberto,
>
> Have you got any data or model numbers to back this one up?
> I've seen plenty of disks set the "warranty void" flag if they exceed 55C,
> but I've never seen a disk stop or pause (and I've run some _very_ hot).
>
> I'd be really interested in finding out a bit more about this.
>
> Regards,
> Brad



i replaced 4 old disk with this 'new' one:
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-2.6.39-ARCH] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint F3
Device Model:     SAMSUNG HD502HJ
Serial Number:    S2BWJ60B237288
LU WWN Device Id: 5 0024e9 4009a5bf6
Firmware Version: 1AJ10001
User Capacity:    500.107.862.016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 6
Local Time is:    Wed May  1 15:07:29 2013 BRT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                ( 4740) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  79) minutes.
SCT capabilities:              (0x003f) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   100   100   051    Pre-fail
Always       -       0
  2 Throughput_Performance  0x0026   048   048   000    Old_age
Always       -       5091
  3 Spin_Up_Time            0x0023   082   081   025    Pre-fail
Always       -       5638
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       19
  5 Reallocated_Sector_Ct   0x0033   252   252   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   252   252   051    Old_age
Always       -       0
  8 Seek_Time_Performance   0x0024   252   252   015    Old_age
Offline      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       5921
 10 Spin_Retry_Count        0x0032   252   252   051    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   252   252   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       23
191 G-Sense_Error_Rate      0x0022   252   252   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0022   252   252   000    Old_age
Always       -       0
194 Temperature_Celsius     0x0002   064   056   000    Old_age
Always       -       27 (Min/Max 15/45)
195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age
Always       -       0
196 Reallocated_Event_Count 0x0032   252   252   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   252   252   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   252   252   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0036   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x002a   100   100   000    Old_age
Always       -       2
223 Load_Retry_Count        0x0032   252   252   000    Old_age
Always       -       0
225 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       23

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      4074         -
# 2  Extended offline    Completed without error       00%       383         -

Note: selective self-test log revision number (0) not 1 implies that
no selective self-test has ever been run
SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has
ever been run
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Completed [00% left] (0-65535)
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.




this disk model (SAMSUNG HD502HJ) stop and wait temperature get down
again (they have about 6months of heavy read, and are not enterprise
level), i have about 20 units, i replace every 6months, they are cheap
and never lost information with this 6months interval, but i'm not
surelly safe without a raid1 and backups, and of course it's a
enterprise level system running not enterprise level hardware (ok it's
wrong but still working)
after 6months i replace the disk, i replace the first with 6months the
second with 7, the third with 8 and the fourth with 9, after 6 months
i replace normally each disk (the older have 9 months on the first
replace), i had no problem yet, it's a raid1 4 disks setup running
mariadb/mysql database with high read and low write, raid0/raid10
don't work in this workload



--
Roberto Spadim
