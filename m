From: Alexander Shenkin <al@shenkin.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Wed, 3 Jan 2018 12:44:31 +0000
Message-ID: <20497c70-140d-c4dd-0201-816477bd467f@shenkin.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <8da0ac59-d83b-671c-b088-8e04b13d685e@turmel.org>
 <afaa1020-652d-911c-16e0-12ed87f2197a@shenkin.org>
 <7b011b63-4de6-44ec-1f74-9f33c6466795@turmel.org>
 <2ab868eb-3ce3-f01b-ac9e-23358563040c@shenkin.org>
 <59DF4B80.5010807@youngman.org.uk>
 <ecbbf0ae-3bf8-fe66-79e1-e8207bc09dcc@turmel.org>
 <5b28b0fc-5e4d-9ac3-9a82-7e36f25c5108@shenkin.org>
 <CAK2H+ecT1Psph5Wm9LrPgYOba6PHKzAs55H1LWiqLD+kaBUQZQ@mail.gmail.com>
 <CACsGCyQGZxhfT1A_ojXaBRvB4wgNOH7fqqh8afsQksAeGdKmjg@mail.gmail.com>
 <CACsGCyS9-K4ZJPKauRZkGFRPd0cvShYLViE87i47=RCY1UkbnQ@mail.gmail.com>
 <fcb32200-19f7-5513-24a0-70ca15ca6297@shenkin.org>
 <7bf0a71e-6cb7-59bc-695b-54ed6b08112b@turmel.org>
 <d86c80ba-7703-1591-7816-00d0d9408386@shenkin.org>
 <a5487193-24e6-879b-bd09-caf5f75c8fcc@turmel.org>
 <05e4489d-98ea-4d12-02d6-f13a98e3d5d4@shenkin.org>
 <201ea04e-1a03-fc83-c31c-146b50bb8624@thelounge.net>
 <47ec07c3-25ae-9595-78a2-8420c106f2a0@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47ec07c3-25ae-9595-78a2-8420c106f2a0@fnarfbargle.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, Reindl Harald <h.reindl@thelounge.net>, Phil Turmel <philip@turmel.org>, Edward Kuns <eddie.kuns@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/23/2017 3:14 AM, Brad Campbell wrote:
> On 21/12/17 19:38, Reindl Harald wrote:
>>
>>
>> Am 21.12.2017 um 12:28 schrieb Alexander Shenkin:
>>> Hi all,
>>>
>>> Reporting back after changing the hangcheck timer to 180 secs and 
>>> re-running checkarray.  I got a number of rebuild events (see syslog 
>>> excerpts below and attached), and I see no signs of the hangcheck 
>>> issue in dmesg like I did last time.
>>>
>>> I'm still getting the SMART OfflineUncorrectableSector and 
>>> CurrentPendingSector errors, however.  Should those go away if the 
>>> rewrites were correctly carried out by the drive?  Any thoughts on 
>>> next steps to verify everything is ok?
>>
>> OfflineUncorrectableSector unlikely can go away
>>
>> CurrentPendingSector
>> https://kb.acronis.com/content/9133
> 
> If they've been re-written (so are no longer pending) then a SMART long 
> or possibly offline test will make them go away. I use SMART long myself.
> 

Thanks Brad.  I'm running a long test now, but I believe I have the 
system set up to run long tests regularly, and the issue hasn't been 
fixed.  Furthermore, strangely, the reallocated sector count still sits 
at 0 (see below).  If these errors had been properly handled by the 
drive, shouldn't Reallocated_Sector_Ct sit at least at 8?

Thanks,
Allie

user@machine:~$ sudo smartctl -a /dev/sda

smartctl 6.2 2013-07-26 r3841 [x86_64-linux-4.4.0-97-generic] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST3000DM001-9YN166
Serial Number:    Z1F13FBA
LU WWN Device Id: 5 000c50 04e444ab1
Firmware Version: CC4B
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Jan  3 12:30:04 2018 GMT

==> WARNING: A firmware update for this drive may be available,
see the following Seagate web pages:
http://knowledge.seagate.com/articles/en_US/FAQ/207931en
http://knowledge.seagate.com/articles/en_US/FAQ/223651en

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                         was completed without error.
                                         Auto Offline Data Collection: 
Enabled.
Self-test execution status:      ( 249) Self-test routine in progress...
                                         90% of test remaining.
Total time to complete Offline
data collection:                (  592) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                         Auto Offline data collection 
on/off support.
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
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 335) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x3085) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE 
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   118   099   006    Pre-fail 
Always       -       190170288
   3 Spin_Up_Time            0x0003   093   092   000    Pre-fail 
Always       -       0
   4 Start_Stop_Count        0x0032   100   100   020    Old_age 
Always       -       49
   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail 
Always       -       0
   7 Seek_Error_Rate         0x000f   082   060   030    Pre-fail 
Always       -       175521338
   9 Power_On_Hours          0x0032   083   083   000    Old_age 
Always       -       15266
  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail 
Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   020    Old_age 
Always       -       73
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always 
       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always 
       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always 
       -       0
188 Command_Timeout         0x0032   100   099   000    Old_age   Always 
       -       3 3 3
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always 
       -       0
190 Airflow_Temperature_Cel 0x0022   049   040   045    Old_age   Always 
   In_the_past 51 (108 124 54 26 0)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always 
       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always 
       -       54
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always 
       -       114
194 Temperature_Celsius     0x0022   051   060   000    Old_age   Always 
       -       51 (0 14 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always 
       -       8
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age 
Offline      -       8
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always 
       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age 
Offline      -       9657h+43m+05.288s
241 Total_LBAs_Written      0x0000   100   253   000    Old_age 
Offline      -       178878793257480
242 Total_LBAs_Read         0x0000   100   253   000    Old_age 
Offline      -       134902761417217

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Self-test routine in progress 90%     15266 
     -
# 2  Conveyance offline  Completed: read failure       80%     15160 
     -
# 3  Extended offline    Completed: read failure       10%     15152 
     -
# 4  Conveyance offline  Completed: read failure       70%     14992 
     -
# 5  Extended offline    Completed: read failure       10%     14986 
     -
# 6  Short offline       Completed: read failure       60%     14913 
     -
# 7  Conveyance offline  Completed: read failure       70%     14824 
     -
# 8  Extended offline    Completed: read failure       10%     14818 
     -
# 9  Conveyance offline  Completed: read failure       80%     14656 
     -
#10  Extended offline    Completed: read failure       10%     14649 
     -
#11  Conveyance offline  Completed: read failure       80%     14489 
     -
#12  Extended offline    Completed: read failure       10%     14482 
     -
#13  Conveyance offline  Completed: read failure       80%     14321 
     -
#14  Extended offline    Completed: read failure       10%     14314 
     -
#15  Conveyance offline  Completed: read failure       80%     14153 
     -
#16  Extended offline    Completed: read failure       10%     14145 
     -
#17  Conveyance offline  Completed: read failure       70%     13985 
     -
#18  Extended offline    Completed: read failure       10%     13977 
     -
#19  Conveyance offline  Completed: read failure       70%     13817 
     -
#20  Extended offline    Completed: read failure       10%     13809 
     -
#21  Conveyance offline  Completed without error       00%     13648 
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
If Selective self-test is pending on power-up, resume after 0 minute delay.

