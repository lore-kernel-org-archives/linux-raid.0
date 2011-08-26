From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Raid failing, which command to remove the bad drive?
Date: Fri, 26 Aug 2011 15:26:07 -0700
Message-ID: <4E581D7F.1080709@vorgon.com>
References: <4E57FE4D.5080503@vorgon.com> <CADNH=7GgGzhLLqYc5kSC=bMN43MK=DE1TwP7gDAeDutHCoO2kA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7GgGzhLLqYc5kSC=bMN43MK=DE1TwP7gDAeDutHCoO2kA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

um, no, that was the email that mdadm sends I thought. And it says=20
problem is sdb in each case. Though I was wondering why each one said=20
[U_] instead of [_U]. Here is the smartctl for sda and below that will=20
be for sdb

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
vorg@x64VDR:~$ sudo smartctl -a /dev/sda
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-2.6.34.20100610.1] (local=20
build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Seagate Barracuda 7200.11
Device Model:     ST3500320AS
Serial Number:    9QM7M86S
LU WWN Device Id: 5 000c50 01059c636
=46irmware Version: SD1A
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Fri Aug 26 15:23:41 2011 MST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activit=
y
                                         was completed without error.
                                         Auto Offline Data Collection:=20
Enabled.
Self-test execution status:      (   0) The previous self-test routine=20
completed
                                         without error or no self-test=20
has ever
                                         been run.
Total time to complete Offline
data collection:                (  650) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate=
=2E
                                         Auto Offline data collection=20
on/off support.
                                         Suspend Offline collection upo=
n new
                                         command.
                                         Offline surface scan supported=
=2E
                                         Self-test supported.
                                         Conveyance Self-test supported=
=2E
                                         Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before enterin=
g
                                         power-saving mode.
                                         Supports SMART auto save timer=
=2E
Error logging capability:        (0x01) Error logging supported.
                                         General Purpose Logging suppor=
ted.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 119) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x103b) SCT Status supported.
                                         SCT Error Recovery Control=20
supported.
                                         SCT Feature Control supported.
                                         SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE=20
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   114   100   006    Pre-fail=20
Always       -       83309768
   3 Spin_Up_Time            0x0003   094   094   000    Pre-fail=20
Always       -       0
   4 Start_Stop_Count        0x0032   100   100   020    Old_age=20
Always       -       13
   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail=20
Always       -       0
   7 Seek_Error_Rate         0x000f   071   060   030    Pre-fail=20
Always       -       13556066
   9 Power_On_Hours          0x0032   094   094   000    Old_age=20
Always       -       5406
  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail=20
Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   020    Old_age=20
Always       -       13
184 End-to-End_Error        0x0032   100   100   099    Old_age   Alway=
s=20
       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Alway=
s=20
       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age   Alway=
s=20
       -       0
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Alway=
s=20
       -       0
190 Airflow_Temperature_Cel 0x0022   067   065   045    Old_age   Alway=
s=20
       -       33 (Min/Max 30/35)
194 Temperature_Celsius     0x0022   033   040   000    Old_age   Alway=
s=20
       -       33 (0 21 0 0)
195 Hardware_ECC_Recovered  0x001a   058   033   000    Old_age   Alway=
s=20
       -       83309768
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Alway=
s=20
       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age=20
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Alway=
s=20
       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]


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
lay
On 8/26/2011 2:25 PM, Mathias Bur=C3=A9n wrote:
> smartctl -a /dev/sda
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

vorg@x64VDR:~$ sudo smartctl -a /dev/sdb
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-2.6.34.20100610.1] (local=20
build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

Vendor:               /1:0:0:0
Product:
User Capacity:        600,332,565,813,390,450 bytes [600 PB]
Logical block size:   774843950 bytes
scsiModePageOffset: response length too short, resp_len=3D47 offset=3D5=
0=20
bd_len=3D46
 >> Terminate command early due to bad response to IEC mode page
A mandatory SMART command failed: exiting. To continue, add one or more=
=20
'-T permissive' options.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
