From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID Issues - RAID10 working but with errors
Date: Thu, 2 Apr 2020 09:52:05 -0400
Message-ID: <006bc778-da45-6bfa-db7d-f11e6dfa0242@turmel.org>
References: <d934f662-9fde-370b-bb4b-b92bd1730c96@websitemanagers.com.au>
 <20200402091914.4330D24003E@gemini.denx.de>
 <c95d82c4-1ee9-c783-48d0-1b8c3812d324@turmel.org>
 <5a4c1822-7452-db80-37cc-bf2bf6fb0c75@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5a4c1822-7452-db80-37cc-bf2bf6fb0c75@websitemanagers.com.au>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/2/20 9:31 AM, Adam Goryachev wrote:
> 
> On 2/4/20 22:20, Phil Turmel wrote:

>> Concur.  Old and worn out.  Personally, I replace when reallocations 
>> are in the 10 to 20 range.  Once you get past that, they seem to start 
>> coming much faster.
>>
> Thank you, I'll check if the drive can be replaced by warranty, or else 
> check if I have a spare. Otherwise, I may be forced to buy a replacement.

I'll be astonished if you can get a warranty replacement for a drive 
that has 60 *thousand* hours of uptime.

> So I have a "spare" drive in the array, what steps should I take to 
> "fix" this? Here are the statistics on the spare drive. Maybe it is just 
> as bad as the other two anyway, and I should replace all three?
> 
> If I can, I assume I would run some commands on the spare to configure 
> it to not have any BBL, then add it back to the array, use it to replace 
> the existing bad drive?

Use the --replace operation of modern mdadm/kernel to get that failing 
drive out right away.  It appears you won't be able to remove the bad 
block misfeature until all devices in the array have an empty log.

> Equally, all data is real-time synced to another machine (DRBD), as well 
> as being backed up regularly, so I'm not super concerned about the data 
> content, but I do want to maximise uptime, and minimise risk to the data 
> as it really is rather important (understatement...).

Understood.  --replace is your friend.

> smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-8-amd64] (local build)
> Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Model Family:     Western Digital RE4
> Device Model:     WDC WD2003FYYS-02W0B0
> 
> 
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>    1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
>    3 Spin_Up_Time            POS--K   253   253   021    -    7391
>    4 Start_Stop_Count        -O--CK   100   100   000    -    72
>    5 Reallocated_Sector_Ct   PO--CK   181   181   140    -    151
>    7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
>    9 Power_On_Hours          -O--CK   009   008   000    -    66691
>   10 Spin_Retry_Count        -O--CK   100   253   000    -    0
>   11 Calibration_Retry_Count -O--CK   100   253   000    -    0
>   12 Power_Cycle_Count       -O--CK   100   100   000    -    62
> 192 Power-Off_Retract_Count -O--CK   200   200   000    -    47
> 193 Load_Cycle_Count        -O--CK   200   200   000    -    24
> 194 Temperature_Celsius     -O---K   116   103   000    -    36
> 196 Reallocated_Event_Count -O--CK   059   059   000    -    141
> 197 Current_Pending_Sector  -O--CK   200   200   000    -    3
> 198 Offline_Uncorrectable   ----CK   200   200   000    -    0
> 199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
> 200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
>                              ||||||_ K auto-keep
>                              |||||__ C event count
>                              ||||___ R error rate
>                              |||____ S speed/performance
>                              ||_____ O updated online
>                              |______ P prefailure warning

Bleh.  Replace this one, too.

> sdb:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>    1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    73
>    3 Spin_Up_Time            POS--K   253   253   021    -    9008
>    4 Start_Stop_Count        -O--CK   100   100   000    -    78
>    5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
>    7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
>    9 Power_On_Hours          -O--CK   022   022   000    -    57426
>   10 Spin_Retry_Count        -O--CK   100   253   000    -    0
>   11 Calibration_Retry_Count -O--CK   100   253   000    -    0
>   12 Power_Cycle_Count       -O--CK   100   100   000    -    65
> 192 Power-Off_Retract_Count -O--CK   200   200   000    -    46
> 193 Load_Cycle_Count        -O--CK   200   200   000    -    31
> 194 Temperature_Celsius     -O---K   105   095   000    -    47
> 196 Reallocated_Event_Count -O--CK   200   200   000    -    0
> 197 Current_Pending_Sector  -O--CK   200   200   000    -    0
> 198 Offline_Uncorrectable   ----CK   200   200   000    -    0
> 199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
> 200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    6
> 
> sdc:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>    1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    42
>    3 Spin_Up_Time            POS--K   253   253   021    -    8441
>    4 Start_Stop_Count        -O--CK   100   100   000    -    69
>    5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
>    7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
>    9 Power_On_Hours          -O--CK   010   010   000    -    65784
>   10 Spin_Retry_Count        -O--CK   100   253   000    -    0
>   11 Calibration_Retry_Count -O--CK   100   253   000    -    0
>   12 Power_Cycle_Count       -O--CK   100   100   000    -    67
> 192 Power-Off_Retract_Count -O--CK   200   200   000    -    48
> 193 Load_Cycle_Count        -O--CK   200   200   000    -    20
> 194 Temperature_Celsius     -O---K   120   105   000    -    32
> 196 Reallocated_Event_Count -O--CK   200   200   000    -    0
> 197 Current_Pending_Sector  -O--CK   200   200   000    -    0
> 198 Offline_Uncorrectable   ----CK   200   200   000    -    0
> 199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
> 200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    2

These two are in astonishingly good condition for their age.

When you've replaced the two bad drives and returned to having a hot 
spare, use --replace again on any drives that still have entries in 
their bad block logs.  The free up drive can than have its superblock 
zeroed and added back as the spare.  Rinse and repeat.

All of the above can be done on the fly, assuming you have hot-swap bays 
for new drives.

When all drives are good, with empty bad block lists, stop the array and 
immediately re-assemble with --update=no-bbl.

Phil
