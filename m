From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: How do I tell which disk failed?
Date: Tue, 08 Jan 2013 01:32:38 -0800
Message-ID: <1357637558.16366.154.camel@corn.betterworld.us>
References: <1357610701.16366.13.camel@corn.betterworld.us>
	 <50EBAC5D.8080000@hardwarefreak.com>
	 <1357628351.16366.86.camel@corn.betterworld.us>
	 <02B6762C-3755-4CE3-9AB1-A48D3384CACB@colorremedies.com>
	 <1357631387.16366.131.camel@corn.betterworld.us>
	 <F5C2E9CA-635E-4FA5-9C20-EB0F6AE94838@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F5C2E9CA-635E-4FA5-9C20-EB0F6AE94838@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: ross@biostat.ucsf.edu, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2013-01-08 at 01:48 -0700, Chris Murphy wrote:
> On Jan 8, 2013, at 12:49 AM, Ross Boylan <ross@biostat.ucsf.edu> wrote:
> > 
> > The raw value (last column) for one of the parameters seems to be
> > changing extremely rapidly, and perhaps is overflowing:
> > # date; smartctl -a /dev/sda | grep 195
> > Mon Jan  7 23:11:03 PST 2013
> > 195 Hardware_ECC_Recovered  0x001a   059   024   000    Old_age   Always       -       241377818
> > # date; smartctl -a /dev/sda | grep 195
> > Mon Jan  7 23:12:26 PST 2013
> > 195 Hardware_ECC_Recovered  0x001a   056   024   000    Old_age   Always       -       3600778
> 
> Not good. The current value is 56, the worst is 24, and the threshold is 0. These are high values. 
Do you mean 56, 24, and 0 are high values?  Or the raw values are high?
Is the raw value wrapping around?
> The firmware is doing its job in that it's fixing errors. But the fact it has to at this rate is not a good sign. Post sda's full attribute list.
--------------------------------------------------------------------------------------------------------------------------------------------------
# date; smartctl -a /dev/sda
Tue Jan  8 01:20:54 PST 2013
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     ST3750330NS
Serial Number:    9QK1MBCW
Firmware Version: SN05
User Capacity:    750,156,374,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Tue Jan  8 01:20:54 2013 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabled.
# the next item seems peculiar.
# It sounds as if the test was aborted, yet the rest result above is passed.
Self-test execution status:      (  41) The self-test routine was interrupted
                                        by the host with a hard or soft reset.
Total time to complete Offline
data collection:                 ( 642) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 177) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   075   063   044    Pre-fail  Always       -       38010669
  3 Spin_Up_Time            0x0003   099   099   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       101
  5 Reallocated_Sector_Ct   0x0033   099   099   036    Pre-fail  Always       -       31
  7 Seek_Error_Rate         0x000f   078   060   030    Pre-fail  Always       -       65563711282
  9 Power_On_Hours          0x0032   061   061   000    Old_age   Always       -       34776
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   037   020    Old_age   Always       -       102
184 Unknown_Attribute       0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
188 Unknown_Attribute       0x0032   100   088   000    Old_age   Always       -       335
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0022   066   057   045    Old_age   Always       -       34 (Lifetime Min/Max 34/36)
194 Temperature_Celsius     0x0022   034   043   000    Old_age   Always       -       34 (0 18 0 0)
195 Hardware_ECC_Recovered  0x001a   044   024   000    Old_age   Always       -       38010669
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Interrupted (host reset)      00%     34773         -
# 2  Extended offline    Completed without error       00%     32464         -
# 3  Extended offline    Completed without error       00%     21385         -
# 4  Short offline       Completed without error       00%     20993         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.
------------------------------------------------------------
> 
> Is this disk under warranty? If it is I'd just get rid of it.
I think it's over 3 years old, so probably not in warranty; it might be
if it's a 5 year warranty.

Fortunately, I've already got new disks in the machine.  The transition
has proved challenging.

I was more or less ready to go, but I wanted to do some experiments with
the alignment of partitions and other parameters.  Any suggestions would
be great.

Ross


P.S. Here are the results for sdb, which has also been generating
chatter in the logs.
--------------------------------------------------------------------------------
on Jan  7 22:51:59 PST 2013
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD2003FYYS-02W0B1
Serial Number:    WD-WCAY00580447
Firmware Version: 01.01D02
User Capacity:    2,000,398,934,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Jan  7 22:51:59 2013 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                 (29760) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
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
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       0
  3 Spin_Up_Time            0x0027   253   253   021    Pre-fail  Always       -       7725
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       14
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   098   098   000    Old_age   Always       -       1676
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       13
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       8
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       5
194 Temperature_Celsius     0x0022   107   102   000    Old_age   Always       -       45
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      1676         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.
------------------------------------------------------------------------------------------------------

> 
> 
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

