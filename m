From: Markus Krainz <ldm@gmx.at>
Subject: Re: Building new RAID5 results in removed and failed devices
Date: Fri, 25 Jun 2010 00:10:53 +0200
Message-ID: <4C23D7ED.9080000@gmx.at>
References: <4C23BF79.2070009@gmx.at> <20100624213848.GA17419@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100624213848.GA17419@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Looks like it started doing the initial synchronisation as normal, but
> hid a read error on sdd1 which caused the array to fail.  sdd1 is left
> as faulty, and sdb1 is spare as the rebuild didn't complete.  I'd
> recommend testing sdd1 (SMART tests, read tests, write tests) before
> trying to use it any further.
>
> Cheers,
>      Robin
>    

I think this unlikely because I did a full 4-pass badblocks 
read/write-test on sdb, sdc and sdd before using them.
No bad blocks have been found.

smartctl -H shows PASSED on all 3 devices. However sdd and sdc have 
Offline_Uncorrectable set to 1 while sdb has not. Is this a sign of disk 
failure?

Best regards,
Markus



~/ sudo smartctl -H /dev/sdb
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

~/ sudo smartctl -H /dev/sdc
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

~/ sudo smartctl -H /dev/sdd
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED


~/ sudo smartctl -A /dev/sdd
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  
Always       -       0
   3 Spin_Up_Time            0x0027   243   142   021    Pre-fail  
Always       -       4816
   4 Start_Stop_Count        0x0032   100   100   000    Old_age   
Always       -       42
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  
Always       -       0
   7 Seek_Error_Rate         0x002e   200   200   000    Old_age   
Always       -       0
   9 Power_On_Hours          0x0032   100   100   000    Old_age   
Always       -       453
  10 Spin_Retry_Count        0x0032   100   253   000    Old_age   
Always       -       0
  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   
Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   
Always       -       40
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   
Always       -       32
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   
Always       -       514
194 Temperature_Celsius     0x0022   100   087   000    Old_age   
Always       -       52
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   
Always       -       1
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   
Offline      -       1
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   
Offline      -       0


~/ sudo smartctl -A /dev/sdc
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  
Always       -       0
   3 Spin_Up_Time            0x0027   245   156   021    Pre-fail  
Always       -       4725
   4 Start_Stop_Count        0x0032   100   100   000    Old_age   
Always       -       39
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  
Always       -       0
   7 Seek_Error_Rate         0x002e   200   200   000    Old_age   
Always       -       0
   9 Power_On_Hours          0x0032   100   100   000    Old_age   
Always       -       456
  10 Spin_Retry_Count        0x0032   100   253   000    Old_age   
Always       -       0
  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   
Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   
Always       -       38
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   
Always       -       23
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   
Always       -       1286
194 Temperature_Celsius     0x0022   110   087   000    Old_age   
Always       -       42
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   
Always       -       1
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   
Offline      -       1
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   
Offline      -       0

~/ sudo smartctl -A /dev/sdb
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  
Always       -       0
   3 Spin_Up_Time            0x0027   245   158   021    Pre-fail  
Always       -       4716
   4 Start_Stop_Count        0x0032   100   100   000    Old_age   
Always       -       40
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  
Always       -       0
   7 Seek_Error_Rate         0x002e   200   200   000    Old_age   
Always       -       0
   9 Power_On_Hours          0x0032   100   100   000    Old_age   
Always       -       455
  10 Spin_Retry_Count        0x0032   100   253   000    Old_age   
Always       -       0
  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   
Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   
Always       -       38
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   
Always       -       29
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   
Always       -       1215
194 Temperature_Celsius     0x0022   105   082   000    Old_age   
Always       -       47
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   
Offline      -       0


