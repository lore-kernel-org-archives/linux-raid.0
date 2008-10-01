From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: exception Emask 0x0 SAct 0x1 / SErr 0x0 action 0x2 frozen
Date: Wed, 1 Oct 2008 07:12:57 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0810010710520.22435@p34.internal.lan>
References: <3E6D0C24877245C3A5A327129A7B4CA7@909927SOSLA>  <alpine.DEB.1.10.0809220828490.23159@p34.internal.lan>  <5419A02543384E69AF2BA82FF6E66C14@909927SOSLA>  <alpine.DEB.1.10.0809220903400.23159@p34.internal.lan>  <4B1ABD0393EF40FFB0A12242FE8356AF@909927SOSLA>
  <alpine.DEB.1.10.0809220915470.23159@p34.internal.lan>  <alpine.DEB.1.10.0809220926240.23159@p34.internal.lan>  <e7510f760809231114y6cbaf13aqf7c63bd48a73c978@mail.gmail.com>  <48DBAB81.8050900@tmr.com> <48E08E2D.6050905@kernel.org>
 <a52a95e30809301347s70b57ebfh280a6871329afd72@mail.gmail.com> <alpine.DEB.1.10.0809301715280.14600@p34.internal.lan> <alpine.LNX.2.00.0809301946020.16014@filesrv1.baby-dragons.com> <alpine.DEB.1.10.0810010403500.16900@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0810010403500.16900@p34.internal.lan>
Sender: linux-ide-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Tom Mortensen <tmmlkml@gmail.com>, Tejun Heo <tj@kernel.org>, Bill Davidsen <davidsen@tmr.com>, Gwendal Grignou <gwendal@google.com>, Brian Rademacher <rad@radfiles.net>, linux-ide@vger.kernel.org, linux-raid maillist <linux-raid@vger.kernel.org>, Linux Kernel Maillist <linux-kernel@vger.kernel.org>, Bruce Allen <ballen@gravity.phys.uwm.edu>
List-Id: linux-raid.ids



On Wed, 1 Oct 2008, Justin Piszcz wrote:

>
>
> On Tue, 30 Sep 2008, Mr. James W. Laferriere wrote:
>
>> 	Hello Justin ,
>> 
>>> 
>>> Justin.
>> 	I take it you've tried differant drive manufacturers ?
> It happens across 12-14 velociraptors.
>
>> 	Or even a differant drive of same manuf. ?
> It also occurs (I have seen it) on WD 750GiB drives on a different 
> motherboard
> and chipset (P35).
>
>> 	Seeing as you've moved this same drive(?) across several chipsets & 
>> possibly mother boards ,  Leads me to beleive that the difficulty is either 
>> with the driver or the drive (if it is always the same drive or drive 
>> model) 
> Other people have the same problem with Seagate and / other drives.
> This also occurs on Raptor 150s.
>
> Justin.
>
>
>

This morning (On P965 board this time-- and on RAID1, not RAID5)

[469680.004654] ata2.00: status: { DRDY }
[469680.004660] ata2: hard resetting link
[469680.309567] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[469680.333461] ata2.00: configured for UDMA/133
[469680.333477] ata2: EH complete
[469680.333461] sd 1:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
[469680.340461] sd 1:0:0:0: [sdb] Write Protect is off
[469680.340461] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[469680.345461] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD3000GLFS-01F8U0
Serial Number:    XX-XXXXXXXXXXXX
Firmware Version: 03.03V01
User Capacity:    300,069,052,416 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Oct  1 07:11:23 2008 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

Perfectly good disk (and yes, I have swapped out cables as well), even tried
different a differnet server/psu (earlier version of the same motherboard) 
as well):

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail  Always       -       0
   3 Spin_Up_Time            0x0003   204   196   021    Pre-fail  Always       -       2758
   4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       36
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
   7 Seek_Error_Rate         0x000e   200   200   000    Old_age   Always       -       0
   9 Power_On_Hours          0x0032   097   097   000    Old_age   Always       -       2790
  10 Spin_Retry_Count        0x0012   100   253   000    Old_age   Always       -       0
  11 Calibration_Retry_Count 0x0012   100   253   000    Old_age   Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       36
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       13
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       36
194 Temperature_Celsius     0x0022   120   114   000    Old_age   Always       -       27
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      2784         -
# 2  Short offline       Completed without error       00%      2760         -
# 3  Short offline       Completed without error       00%      2736         -
# 4  Extended offline    Completed without error       00%      2713         -
# 5  Short offline       Completed without error       00%      2688         -
# 6  Extended offline    Completed without error       00%      2513         -
# 7  Short offline       Completed without error       00%      2305         -
# 8  Short offline       Completed without error       00%      2281         -
# 9  Short offline       Completed without error       00%      2258         -
#10  Short offline       Completed without error       00%      2234         -
#11  Extended offline    Completed without error       00%      2210         -
#12  Short offline       Completed without error       00%      2186         -
#13  Short offline       Completed without error       00%      2138         -
#14  Short offline       Completed without error       00%      2114         -
#15  Short offline       Completed without error       00%      2090         -
#16  Short offline       Completed without error       00%      2066         -
#17  Extended offline    Completed without error       00%      2043         -
#18  Short offline       Completed without error       00%      2018         -
#19  Short offline       Completed without error       00%      1970         -
#20  Short offline       Completed without error       00%      1946         -
#21  Short offline       Completed without error       00%      1922         -


