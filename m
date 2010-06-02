From: Dan Christensen <jdc@uwo.ca>
Subject: Re: devices get kicked from RAID about once a month
Date: Wed, 02 Jun 2010 11:29:09 -0400
Message-ID: <876321o3lm.fsf@uwo.ca>
References: <87k4qho723.fsf@uwo.ca>
	<628039470-1275491015-cardhu_decombobulator_blackberry.rim.net-326486810-@bda837.bisx.prod.on.blackberry>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

rsivak@vshift.com writes:

> I would say that these are probably desktop type drives - not
> enterprise drives.

Right.

> In which case, what you're probably hitting are
> media errors - when a drive hits a bad sector.  A consumer level drive
> will try as hard as possible to retrieve the data - I'd say somewhere
> around 15 seconds, depending on the manufacturer.  This is often
> enough to get the drive kicked out of the array.

Could be.  I've included the SMART info for one of the drives below.
Most of the values look very good to me.  E.g. no re-allocated sectors
at all.  The only one that raises an eyebrow is:

195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       540903625

Do the stats below support the theory that these are timeouts due to
media errors?  Does anyone know if Samsung Spinpoint drives can be
tweaked to not try so hard to retrieve data?  Or is it possible to make
the kernel more tolerant of such timeouts?

Thanks,

Dan

smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint P120 series
Device Model:     SAMSUNG SP2504C
Serial Number:    S09QJ1UL210508
Firmware Version: VT100-33
User Capacity:    250,059,350,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 4a
Local Time is:    Wed Jun  2 11:23:40 2010 EDT

==> WARNING: May need -F samsung3 enabled; see manual for details.

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84)	Offline data collection activity
					was suspended by an interrupting command from host.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 (4965) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 (  82) minutes.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail  Always       -       789
  3 Spin_Up_Time            0x0007   100   100   025    Pre-fail  Always       -       5952
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       101
  5 Reallocated_Sector_Ct   0x0033   253   253   010    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   253   253   051    Pre-fail  Always       -       0
  8 Seek_Time_Performance   0x0025   253   253   015    Pre-fail  Offline      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       34577
 10 Spin_Retry_Count        0x0033   253   253   051    Pre-fail  Always       -       0
 11 Calibration_Retry_Count 0x0012   253   002   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       86
190 Airflow_Temperature_Cel 0x0022   142   106   000    Old_age   Always       -       32
194 Temperature_Celsius     0x0022   142   106   000    Old_age   Always       -       32
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       540903625
196 Reallocated_Event_Count 0x0032   253   253   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0012   253   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   253   253   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x000a   100   100   000    Old_age   Always       -       0
201 Soft_Read_Error_Rate    0x000a   100   100   000    Old_age   Always       -       0
202 TA_Increase_Count       0x0032   253   253   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     34427         -
# 2  Extended offline    Completed without error       00%     34258         -
# 3  Extended offline    Completed without error       00%     34089         -
# 4  Extended offline    Completed without error       00%     34002         -
# 5  Short offline       Completed without error       00%     34001         -
# 6  Extended offline    Completed without error       00%     33921         -
# 7  Extended offline    Completed without error       00%     33754         -
# 8  Extended offline    Completed without error       00%     33586         -
# 9  Extended offline    Completed without error       00%     33417         -
#10  Extended offline    Completed without error       00%     33249         -
#11  Extended offline    Completed without error       00%     33077         -
#12  Extended offline    Completed without error       00%     32909         -
#13  Extended offline    Completed without error       00%     32740         -
#14  Extended offline    Completed without error       00%     32513         -
#15  Extended offline    Completed without error       00%     32344         -
#16  Extended offline    Completed without error       00%     32176         -
#17  Extended offline    Completed without error       00%     32066         -
#18  Short offline       Completed without error       00%     32064         -
#19  Extended offline    Completed without error       00%     32007         -
#20  Extended offline    Completed without error       00%     31839         -
#21  Extended offline    Completed without error       00%     31670         -

SMART Selective Self-Test Log Data Structure Revision Number (0) should be 1
SMART Selective self-test log data structure revision number 0
Warning: ATA Specification requires selective self-test log data structure revision number = 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.


