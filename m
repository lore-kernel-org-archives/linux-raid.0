From: whollygoat@letterboxes.org
Subject: zero-superblock, Re: some ?? re failed disk and resyncing of array
Date: Mon, 02 Feb 2009 16:52:13 -0800
Message-ID: <1233622333.26974.1298163227@webmail.messagingengine.com>
References: <1233389816.28363.1297740563@webmail.messagingengine.com>
 <49842A1E.1090105@dgreaves.com>
 <1233403388.29916.1297756217@webmail.messagingengine.com>
 <4985FAF1.2090208@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4985FAF1.2090208@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Bill Davidsen <davidsen@tmr.com>, David Greaves <david@dgreaves.com>
List-Id: linux-raid.ids

On Sun, 01 Feb 2009 14:41:37 -0500, "Bill Davidsen" <davidsen@tmr.com>
said:
> whollygoat@letterboxes.org wrote:
> > On Sat, 31 Jan 2009 10:38:22 +0000, "David Greaves" <david@dgreaves.com>
> > said:
> >   
> >> whollygoat@letterboxes.org wrote:
> >>     
> >>> On a boot a couple of days ago, mdadm failed a disk and
> >>> started resyncing to spare (raid5, 6 drives, 5 active, 1
> >>> spare).  smartctl -H <disk> returned info (can't remember
> >>> the exact text) that made me suspect the drive was
> >>> fine, but the data connection was bad.  Sure enough the
> >>> data cable was damaged.  Replaced the cable and smartctl
> >>> sees the disk just fine and reports no errors.
> >>>
> >>> - I'd like to readd the drive as a spare.  Is it enough
> >>> to "mdadm --add /dev/hdk" or do I need to prep the drive to
> >>> remove any data that said where it previously belonged
> >>> in the array?
> >>>       
> >> That should work.
> >> Any issues and you can zero the superblock (man mdadm)
> >> No need to zero the disk.
> >>     
> >
> > Would --re-add be better?
> >
> >   
> I don't think do. And I would zero the superblock. The more detail you 
> put into preventing unwanted autodetection the fewer learning 
> experiences you will have.

Can anyone provide any more insight with the below?

fly:~# mdadm --zero-superblock /dev/hdk1
mdadm: Unrecognised md component device - /dev/hdk1

fly:~# fdisk -l /dev/hdk

Disk /dev/hdk: 120.0 GB, 120034123776 bytes
255 heads, 63 sectors/track, 14593 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hdk1               1       14593   117218241   da  Non-FS data

fly:~# mdadm -a /dev/hdk1
mdadm: /dev/hdk1 does not appear to be an md device

fly:~# smartctl -a /dev/hdk
smartctl version 5.36 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce
Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar SE family
Device Model:     WDC WD1200JB-00GVC0
Serial Number:    WD-WCALA2237663
Firmware Version: 08.02D08
User Capacity:    120,034,123,776 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   6
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Feb  2 16:50:13 2009 PST
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
data collection:                 (3472) seconds.
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
                                        No General Purpose Logging
                                        support.
Short self-test routine 
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  49) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE     
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   200   200   051    Pre-fail  Always
        -       0
  3 Spin_Up_Time            0x0007   126   122   021    Pre-fail  Always
        -       4200
  4 Start_Stop_Count        0x0032   100   100   040    Old_age   Always
        -       680
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always
        -       0
  7 Seek_Error_Rate         0x000b   200   200   051    Pre-fail  Always
        -       0
  9 Power_On_Hours          0x0032   085   085   000    Old_age   Always
        -       10951
 10 Spin_Retry_Count        0x0013   100   100   051    Pre-fail  Always
       -       0
 11 Calibration_Retry_Count 0x0013   100   100   051    Pre-fail  Always
       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always
       -       677
194 Temperature_Celsius     0x0022   112   094   000    Old_age   Always
      -       35
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always
      -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always
      -       0
198 Offline_Uncorrectable   0x0012   200   200   000    Old_age   Always
      -       0
199 UDMA_CRC_Error_Count    0x000a   200   253   000    Old_age   Always
      -       0
200 Multi_Zone_Error_Rate   0x0009   200   200   051    Pre-fail 
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     10922    
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


Thanks,

wg
-- 
  
  whollygoat@letterboxes.org

-- 
http://www.fastmail.fm - The way an email service should be

