From: Redeeman <redeeman@metanurb.dk>
Subject: Re: time limited error recovery and md raid
Date: Sat, 06 Dec 2008 03:59:21 +0100
Message-ID: <1228532361.16555.100.camel@localhost>
References: <1228510646.16555.73.camel@localhost>
	 <alpine.DEB.1.10.0812051600410.17806@p34.internal.lan>
	 <1228511266.16555.81.camel@localhost>
	 <alpine.DEB.1.10.0812051609070.17806@p34.internal.lan>
	 <1228511880.16555.87.camel@localhost>
	 <alpine.DEB.1.10.0812051618340.17806@p34.internal.lan>
	 <1228512684.16555.91.camel@localhost>
	 <alpine.DEB.1.10.0812051637360.17806@p34.internal.lan>
	 <1228514942.16555.95.camel@localhost>
	 <alpine.DEB.1.10.0812051852110.4906@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812051852110.4906@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2008-12-05 at 18:52 -0500, Justin Piszcz wrote:
> 
> On Fri, 5 Dec 2008, Redeeman wrote:
> 
> > On Fri, 2008-12-05 at 16:42 -0500, Justin Piszcz wrote:
> >>
> >> On Fri, 5 Dec 2008, Redeeman wrote:
> >>
> >>> On Fri, 2008-12-05 at 16:21 -0500, Justin Piszcz wrote:
> >>>>
> >>>> On Fri, 5 Dec 2008, Redeeman wrote:
> >>>>
> >>>>> On Fri, 2008-12-05 at 16:12 -0500, Justin Piszcz wrote:
> >>>>>>
> >>>>>> On Fri, 5 Dec 2008, Redeeman wrote:
> >>>>>>
> >>>>>>> On Fri, 2008-12-05 at 16:01 -0500, Justin Piszcz wrote:
> >>>>>>>>
> >>>>>>>> On Fri, 5 Dec 2008, Redeeman wrote:
> >>>>>>>>
> >>> Okay, you happen to have any knowledge to pass on about current 1tb
> >>> disks?
> >> I am still looking for some good 1TiB drives myself.  I know one user who
> >> has 12 of these, 11 in a RAID-5 array and 1 as a spare on a 12-port 3ware
> >> PCI-X card:
> >> SAMSUNG Spinpoint F1 HD103UJ 1TB 7200 RPM 32MB Cache SATA 3.0Gb/s Hard Drive
> > I guess those look pretty good.
> >
> > i personally am running WD RE2 and Seagate ES.2 in raids without issues
> > at all, raid1, but hmm..
> 
> Can you show the smartctl -a output for each of the disks in your raids?
this is a raid1 with 1xwd re2 gp and 1x seagate es.2:
fileserver1:~# smartctl -a /dev/sda
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD1000FYPS-01ZKB0
Serial Number:    WD-WCASJ1247531
Firmware Version: 02.01B01
User Capacity:    1.000.203.804.160 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sat Dec  6 04:00:27 2008 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activity
                                        was suspended by an interrupting
command from host.
                                        Auto Offline Data Collection:
Enabled.
Self-test execution status:      (   0) The previous self-test routine
completed
                                        without error or no self-test
has ever
                                        been run.
Total time to complete Offline
data collection:                 (27960) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon
new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging
supported.
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
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail  Always
-       0
  3 Spin_Up_Time            0x0003   178   178   021    Pre-fail  Always
-       8066
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always
-       43
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always
-       0
  7 Seek_Error_Rate         0x000e   200   200   000    Old_age   Always
-       0
  9 Power_On_Hours          0x0032   096   096   000    Old_age   Always
-       3065
 10 Spin_Retry_Count        0x0012   100   253   000    Old_age   Always
-       0
 11 Calibration_Retry_Count 0x0012   100   253   000    Old_age   Always
-       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always
-       43
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always
-       59
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always
-       675
194 Temperature_Celsius     0x0022   122   108   000    Old_age   Always
-       30
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always
-       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always
-       0
198 Offline_Uncorrectable   0x0010   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always
-       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%       589
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
If Selective self-test is pending on power-up, resume after 0 minute
delay.

fileserver1:~# smartctl -a /dev/sdb
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     ST31000340NS
Serial Number:    9QJ0RPJG
Firmware Version: SN05
User Capacity:    1.000.204.886.016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sat Dec  6 04:01:06 2008 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection:
Enabled.
Self-test execution status:      (   0) The previous self-test routine
completed
                                        without error or no self-test
has ever
                                        been run.
Total time to complete Offline
data collection:                 ( 650) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon
new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging
supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 237) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   079   063   044    Pre-fail  Always
-       93375833
  3 Spin_Up_Time            0x0003   099   099   000    Pre-fail  Always
-       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always
-       40
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always
-       1
  7 Seek_Error_Rate         0x000f   065   060   030    Pre-fail  Always
-       21491681226
  9 Power_On_Hours          0x0032   097   097   000    Old_age   Always
-       3068
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always
-       0
 12 Power_Cycle_Count       0x0032   100   037   020    Old_age   Always
-       41
184 Unknown_Attribute       0x0032   100   100   099    Old_age   Always
-       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always
-       0
188 Unknown_Attribute       0x0032   100   090   000    Old_age   Always
-       60
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always
-       0
190 Airflow_Temperature_Cel 0x0022   067   055   045    Old_age   Always
-       33 (Lifetime Min/Max 18/37)
194 Temperature_Celsius     0x0022   033   045   000    Old_age   Always
-       33 (0 18 0 0)
195 Hardware_ECC_Recovered  0x001a   022   022   000    Old_age   Always
-       93375833
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always
-       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always
-       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%       589
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
If Selective self-test is pending on power-up, resume after 0 minute
delay.


> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

