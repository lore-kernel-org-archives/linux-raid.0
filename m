From: Phil Lobbes <phil@perkpartners.com>
Subject: Re: RAID1 == two different ARRAY in scan, and Q on read error corrected
Date: Sat, 19 Apr 2008 13:26:16 -0400
Message-ID: <28126.1208625976@perkpartners.com>
References: <27567.1208547359@perkpartners.com> <48091A67.1090906@sauce.co.nz> <A20315AE59B5C34585629E258D76A97C087DAB@34093-C3-EVS3.exchange.rackspace.com> <480963D0.70307@sauce.co.nz>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <480963D0.70307@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> The error was:
> 
> Apr 18 14:01:45  smartd[2104]: Device: /dev/sdc, 3 Currently
> unreadable (pending) sectors
> 
> These are not ECC errors and the definition I have for pending sector
> errors is, "Current count of unstable sectors (waiting for
> remapping)."
>
> It would be useful to see the Reallocated Sectors Count from the
> smartctl output.

Here's the requested count:

  5 Reallocated_Sector_Ct   0x0033   251   251   063    Pre-fail  Always       -       22

And the full set in case it helps give a clearer picture...

Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  3 Spin_Up_Time            0x0027   186   181   063    Pre-fail  Always       -       24376
  4 Start_Stop_Count        0x0032   252   252   000    Old_age   Always       -       1988
  5 Reallocated_Sector_Ct   0x0033   251   251   063    Pre-fail  Always       -       22
  6 Read_Channel_Margin     0x0001   253   253   100    Pre-fail  Offline      -       0
  7 Seek_Error_Rate         0x000a   253   252   000    Old_age   Always       -       0
  8 Seek_Time_Performance   0x0027   240   224   187    Pre-fail  Always       -       64525
  9 Power_On_Minutes        0x0032   170   170   000    Old_age   Always       -       614h+37m
 10 Spin_Retry_Count        0x002b   253   252   157    Pre-fail  Always       -       0
 11 Calibration_Retry_Count 0x002b   253   252   223    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   253   253   000    Old_age   Always       -       6
192 Power-Off_Retract_Count 0x0032   253   253   000    Old_age   Always       -       0
193 Load_Cycle_Count        0x0032   253   253   000    Old_age   Always       -       0
194 Temperature_Celsius     0x0032   001   253   000    Old_age   Always       -       53
195 Hardware_ECC_Recovered  0x000a   252   204   000    Old_age   Always       -       39547
196 Reallocated_Event_Count 0x0008   253   253   000    Old_age   Offline      -       0
197 Current_Pending_Sector  0x0008   253   253   000    Old_age   Offline      -       3
198 Offline_Uncorrectable   0x0008   253   253   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0008   199   199   000    Old_age   Offline      -       0
200 Multi_Zone_Error_Rate   0x000a   253   252   000    Old_age   Always       -       0
201 Soft_Read_Error_Rate    0x000a   253   252   000    Old_age   Always       -       0
202 TA_Increase_Count       0x000a   253   001   000    Old_age   Always       -       0
203 Run_Out_Cancel          0x000b   253   076   180    Pre-fail  Always   In_the_past 0
204 Shock_Count_Write_Opern 0x000a   253   252   000    Old_age   Always       -       0
205 Shock_Rate_Write_Opern  0x000a   253   252   000    Old_age   Always       -       0
207 Spin_High_Current       0x002a   253   252   000    Old_age   Always       -       0
208 Spin_Buzz               0x002a   253   252   000    Old_age   Always       -       0
209 Offline_Seek_Performnce 0x0024   239   239   000    Old_age   Offline      -       169
210 Unknown_Attribute       0x0032   253   252   000    Old_age   Always       -       0
211 Unknown_Attribute       0x0032   253   252   000    Old_age   Always       -       0
212 Unknown_Attribute       0x0032   253   253   000    Old_age   Always       -       0
