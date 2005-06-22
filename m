From: Harry Mangalam <hjm@tacgi.com>
Subject: Re: More tales of horror from the linux (HW) raid crypt
Date: Wed, 22 Jun 2005 14:33:00 -0700
Message-ID: <200506221433.00321.hjm@tacgi.com>
References: <5d96567b05061804477325d743@mail.gmail.com> <200506221316.33178.hjm@tacgi.com> <20050622223833.60b3eba1.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050622223833.60b3eba1.pegasus@nerv.eu.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is this too OT? Let me know..

The Storage Review DB would be a decent 1st approximation (includes data on 
~35K drives), but relies on entering the info on only drives that the DB 
knows about, and also relies on info that the person entering the data 
remembers - how many hours in use, etc. It's also available only to 
registered users who might be entering spurious data to gain access to the 
DB.

The SMART data (granted, it would only be possible to collect data from SMART 
drives) would tell you considerably more info:
(including that I was mistaken when I previously said I only bought IBM's and 
Seagates) :)

This is the kind of info that wold be quite useful to have available in a 
CDDB-like DB.  It would also point out which drives are susceptible to 
failure under continuous-on conditions versus frequent power-cycling, etc.

an example from my home system:

1062 $ smartctl -a /dev/hda
smartctl version 5.32 Copyright (C) 2002-4 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD800JB-00CRA1
Serial Number:    WD-WMA8E4088773
Firmware Version: 17.07W17
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   5
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Jun 22 14:24:56 2005 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activity
                                        was suspended by an interrupting 
command from host.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine 
completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                 (3120) seconds.
Offline data collection
capabilities:                    (0x3b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off 
support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        No Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        No General Purpose Logging support.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  58) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   200   200   051    Pre-fail  Always       
-       0
  3 Spin_Up_Time            0x0007   099   095   021    Pre-fail  Always       
-       4141
  4 Start_Stop_Count        0x0032   100   100   040    Old_age   Always       
-       122
  5 Reallocated_Sector_Ct   0x0033   199   199   140    Pre-fail  Always       
-       2
  7 Seek_Error_Rate         0x000b   200   200   051    Pre-fail  Always       
-       0
  9 Power_On_Hours          0x0032   075   075   000    Old_age   Always       
-       18940
 10 Spin_Retry_Count        0x0013   100   100   051    Pre-fail  Always       
-       0
 11 Calibration_Retry_Count 0x0013   100   100   051    Pre-fail  Always       
-       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       
-       120
196 Reallocated_Event_Count 0x0032   198   198   000    Old_age   Always       
-       2
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always       
-       0
198 Offline_Uncorrectable   0x0012   200   200   000    Old_age   Always       
-       0
199 UDMA_CRC_Error_Count    0x000a   200   253   000    Old_age   Always       
-       0
200 Multi_Zone_Error_Rate   0x0009   200   200   051    Pre-fail  Offline      
-       0

SMART Error Log Version: 1
No Errors Logged


On Wednesday 22 June 2005 1:38 pm, Jure Pecar wrote:
> On Wed, 22 Jun 2005 13:16:33 -0700
>
> Harry Mangalam <hjm@tacgi.com> wrote:
> > Perhaps something like the CDDB, where a you can run an applet on a
> > cronjob  that will upload your disk's SMART data cache to a remote DB on
> > a regular  basis, so the millions of disks out there can be profiled. 
> > Hmmm - sounds  like a good undergrad project. Did someone say Summer of
> > Code? (http://code.google.com/summerofcode.html)
>
> Actually if you look at the storagereview.com, they already have a crude
> form of this online under "reliability survey". You have to login, then you
> can enter disk model that you have expirience with and what were those
> expiriences. There's quite some info already available ...

-- 
Cheers, Harry
Harry J Mangalam - 949 856 2847 (vox; email for fax) - hjm@tacgi.com 
            <<plain text preferred>>
