From: Phil Turmel <philip@turmel.org>
Subject: Re: assistance recovering failed raid6 array
Date: Mon, 20 Feb 2017 12:36:22 -0500
Message-ID: <5cc1566c-1b4c-c663-56a1-2040b93b46d7@turmel.org>
References: <58AA4B1E.1030809@bosner.de>
 <e01061cb-ea4c-4f64-16e8-e6027adbc70d@turmel.org>
 <E18A7C79-09E0-4361-9F89-68AE1E6FCBF6@bosner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E18A7C79-09E0-4361-9F89-68AE1E6FCBF6@bosner.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Bosner <martin@bosner.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Martin,

{ Note: convention on kernel.org is reply-to-all, bottom post or
interleave, and trim unneeded material. }

On 02/20/2017 12:05 PM, Martin Bosner wrote:
> for x in /dev/sd[a-z] /dev/sda[a-j] ; do echo mdadm -E ${x}1 ; smartctl -iA -l scterc $x ; done

Darn.  I didn't mean to leave 'echo' there.  Please run this
part over again:

for x in /dev/sd[a-z] /dev/sda[a-j] ; do mdadm -E ${x}1 ; done

> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-62-generic] (local build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Model Family:     Seagate Barracuda 7200.14 (AF)
> Device Model:     ST3000DM001-1CH166
> Serial Number:    Z1F4RN82
> LU WWN Device Id: 5 000c50 0662080a6
> Firmware Version: CC27
> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    7200 rpm
> Form Factor:      3.5 inches
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
> Local Time is:    Mon Feb 20 17:04:09 2017 CET
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   111   099   006    Pre-fail  Always       -       32613624
>   3 Spin_Up_Time            0x0003   098   098   000    Pre-fail  Always       -       0
>   4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       4
>   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
>   7 Seek_Error_Rate         0x000f   067   060   030    Pre-fail  Always       -       5379264
>   9 Power_On_Hours          0x0032   096   096   000    Old_age   Always       -       4222
>  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       4
> 183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always       -       0
> 184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
> 188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       0 0 0
> 189 High_Fly_Writes         0x003a   099   099   000    Old_age   Always       -       1
> 190 Airflow_Temperature_Cel 0x0022   072   066   045    Old_age   Always       -       28 (Min/Max 26/28)
> 191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       0
> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       4
> 193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       4
> 194 Temperature_Celsius     0x0022   028   040   000    Old_age   Always       -       28 (0 25 0 0 0)
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
> 240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       4222h+01m+40.011s
> 241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       6286190299
> 242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       103173878942
> 
> SCT Error Recovery Control command not supported
      ^^^^^^^^^^^^^^^^^^^^^^         ^^^^^^^^^^^^^

Eewwww!  You have desktop drives.  Which means your array has
blown up due to timeout mismatch.  You have some reading to
do.[1]

Phil

[1] Recommendations from the archives (whole threads):

http://marc.info/?l=linux-raid&m=139050322510249&w=2
http://marc.info/?l=linux-raid&m=135863964624202&w=2
http://marc.info/?l=linux-raid&m=135811522817345&w=1
http://marc.info/?l=linux-raid&m=133761065622164&w=2
http://marc.info/?l=linux-raid&m=132477199207506
http://marc.info/?l=linux-raid&m=133665797115876&w=2
http://marc.info/?l=linux-raid&m=142487508806844&w=3
http://marc.info/?l=linux-raid&m=144535576302583&w=2
