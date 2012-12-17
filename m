From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: WD "RED" drives - are they any good for mdadm?
Date: Mon, 17 Dec 2012 15:36:28 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1212171532380.17599@uplift.swm.pp.se>
References: <50CF2112.1090406@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50CF2112.1090406@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 17 Dec 2012, maurice wrote:

> Does anyone have any experience with these they would care to share?

I have three in production right now, having replaced failing green 
drives. This is the one that's been running the longest, so far without 
any problems at all. This is without any specific settings at all, just 
plugged it in and added it to the md-raid.

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD20EFRX-68AX9N0
Serial Number:    WD-WMC<snip>
LU WWN Device Id: 5 0014ee 0035938bd
Firmware Version: 80.00A80
User Capacity:    2 000 398 934 016 bytes [2,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   9
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Dec 17 15:33:57 2012 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED 
WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       0
   3 Spin_Up_Time            0x0027   178   175   021    Pre-fail  Always       -       4066
   4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       15
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
   7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Always       -       0
   9 Power_On_Hours          0x0032   096   096   000    Old_age   Always       -       3406
  10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Always       -       0
  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       15
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       14
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       0
194 Temperature_Celsius     0x0022   116   110   000    Old_age   Always       -       31
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age   Offline      -       0


-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
