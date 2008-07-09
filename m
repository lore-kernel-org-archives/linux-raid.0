From: Gerhard Wiesinger <lists@wiesinger.com>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
Date: Wed, 9 Jul 2008 07:37:50 +0200 (CEST)
Message-ID: <alpine.LFD.1.10.0807090726200.686@bbs.intern>
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan> <alpine.LFD.1.10.0807071649340.1160@bbs.intern> <alpine.LFD.1.10.0807071705490.2997@bbs.intern> <alpine.DEB.1.10.0807071149530.32508@p34.internal.lan> <alpine.LFD.1.10.0807080811560.5439@bbs.intern>
 <alpine.DEB.1.10.0807080433550.17980@p34.internal.lan> <alpine.LFD.1.10.0807081232350.32659@bbs.intern> <alpine.DEB.1.10.0807080915040.23688@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753507AbYGIFin@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0807080915040.23688@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 8 Jul 2008, Justin Piszcz wrote:

>>>>> Hi Gerhard,
>>> 
>>> Please run:
>>> 
>>> smartctl -t short /dev/sdc
>>> sleep 300
>>> smartctl -t long /dev/sdc
>>> 
>>> Wait 2-3 hours or more and:
>>> 
>>> smartctl -a /dev/sdc
>> 
>> 
>> I'm changing the disk one more time ...
>
> Once you replace the disk please re-run the tests shown above and show us the 
> output please.
>
> How many SAMSUNG disks have you gone through, do they really fail that often?
>

Hello Justin!

Setup Power suppply:
sda-sdd are on the same power supply cable, sde, sdf are on a second one.

I changed the disk to a new SAMSUNG disk and the first raid resync did NOT 
work and I had 1 reallocated sector ...

Also the RMA guy at our very good computer store (http://www.ditech.at/) 
were helpfull in changing the disks and he hates the SAMSUNG disks 
because of high RMA rates ...

But:
smart checks were ok (details see below). The smart checks are shown as 
aborted, but before running the next tests they were at "Completed without 
error" (strange).

Now sdc has it's own power cable and I'm running a raid resync now.

Power supply is:
ATX 385 Watt, ENERMAX PRO82+

Load on power supply measured on 220V side with a true RMS Wattmeter:
Power off: 6,5W
Max seen at power up: 196W
BIOS: 114,1W
Linux idle: 92,0W
100% Disk I/O, 100% CPU load: 149,6W
=> Everything fine and as expected.

I'll keep you up to date ...

Ciao,
Gerhard

--
http://www.wiesinger.com/


==============================================================================================
smartctl -a /dev/sdc
smartctl version 5.38 [x86_64-redhat-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     SAMSUNG HD103UJ
Serial Number:    XXXXXXXXXXXXX
Firmware Version: 1AA01109
User Capacity:    1,000,204,886,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 3b
Local Time is:    Wed Jul  9 07:03:39 2008 CEST

==> WARNING: May need -F samsung or -F samsung2 enabled; see manual for 
details.

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                         was never started.
                                         Auto Offline Data Collection: 
Disabled.
Self-test execution status:      (   0) The previous self-test routine 
completed
                                         without error or no self-test has 
ever
                                         been run.
Total time to complete Offline
data collection:                 (11927) seconds.
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
                                         General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 200) minutes.
Conveyance self-test routine
recommended polling time:        (  21) minutes.
SCT capabilities:              (0x003f) SCT Status supported.
                                         SCT Feature Control supported.
                                         SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED 
WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail  Always       -       0
   3 Spin_Up_Time            0x0007   091   091   011    Pre-fail  Always       -       3560
   4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       5
   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       1
   7 Seek_Error_Rate         0x000f   253   253   051    Pre-fail  Always       -       0
   8 Seek_Time_Performance   0x0025   100   100   015    Pre-fail  Offline      -       13955
   9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       11
  10 Spin_Retry_Count        0x0033   100   100   051    Pre-fail  Always       -       0
  11 Calibration_Retry_Count 0x0012   100   100   000    Old_age   Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       5
  13 Read_Soft_Error_Rate    0x000e   100   100   000    Old_age   Always       -       0
183 Unknown_Attribute       0x0032   100   100   000    Old_age   Always       -       0
184 Unknown_Attribute       0x0033   100   100   099    Pre-fail  Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
188 Unknown_Attribute       0x0032   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0022   075   066   000    Old_age   Always       -       25 (Lifetime Min/Max 25/34)
194 Temperature_Celsius     0x0022   074   064   000    Old_age   Always       -       26 (Lifetime Min/Max 25/36)
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       2077
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   100   100   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x000a   253   253   000    Old_age   Always       -       0
201 Soft_Read_Error_Rate    0x000a   100   100   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 0
Warning: ATA Specification requires self-test log structure revision 
number = 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%         4         -
# 2  Conveyance offline  Aborted by host               00%         1         -
# 3  Short offline       Aborted by host               00%         0         -
# 4  Conveyance offline  Aborted by host               00%         0         -

SMART Selective Self-Test Log Data Structure Revision Number (0) should be 
1
SMART Selective self-test log data structure revision number 0
Warning: ATA Specification requires selective self-test log data structure 
revision number = 1
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
==============================================================================================
