From: Brad Campbell <brad@wasp.net.au>
Subject: Re: now on to tuning....
Date: Wed, 09 Mar 2005 14:04:26 +0400
Message-ID: <422ECA2A.8000806@wasp.net.au>
References: <6F9171BE257CA742BFBCFA87B8F20F8D030E4351@NZURC900PEX1.ubsgs.ubsgroup.net> <Pine.LNX.4.56.0503090926190.4055@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.56.0503090926190.4055@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson wrote:

> And do check your disks regularly, although I don't think current version
> of smartmontools fully supports sata under the scsi subsystem yet...
> 

Actually, if you are using a UP machine, the libata-dev tree has patches that make this work. I 
believe there may be races on SMP machines however.

All 29 drives get a short test every morning and a long test every Sunday morning. Odd results are 
immediately E-mailed to me by smartd.

storage1:/home/brad# smartctl -A -d ata /dev/sda
smartctl version 5.32 Copyright (C) 2002-4 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
   3 Spin_Up_Time            0x0027   252   252   063    Pre-fail  Always       -       5622
   4 Start_Stop_Count        0x0032   253   253   000    Old_age   Always       -       20
   5 Reallocated_Sector_Ct   0x0033   253   253   063    Pre-fail  Always       -       0
   6 Read_Channel_Margin     0x0001   253   253   100    Pre-fail  Offline      -       0
   7 Seek_Error_Rate         0x000a   253   252   000    Old_age   Always       -       0
   8 Seek_Time_Performance   0x0027   250   248   187    Pre-fail  Always       -       35232
   9 Power_On_Minutes        0x0032   252   252   000    Old_age   Always       -       457h+24m
  10 Spin_Retry_Count        0x002b   252   252   157    Pre-fail  Always       -       0
  11 Calibration_Retry_Count 0x002b   253   252   223    Pre-fail  Always       -       0
  12 Power_Cycle_Count       0x0032   253   253   000    Old_age   Always       -       34
192 Power-Off_Retract_Count 0x0032   253   253   000    Old_age   Always       -       0
193 Load_Cycle_Count        0x0032   253   253   000    Old_age   Always       -       0
194 Temperature_Celsius     0x0032   253   253   000    Old_age   Always       -       35
195 Hardware_ECC_Recovered  0x000a   253   252   000    Old_age   Always       -       1411
196 Reallocated_Event_Count 0x0008   253   253   000    Old_age   Offline      -       0
197 Current_Pending_Sector  0x0008   253   253   000    Old_age   Offline      -       0
198 Offline_Uncorrectable   0x0008   253   253   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0008   199   199   000    Old_age   Offline      -       0
200 Multi_Zone_Error_Rate   0x000a   253   252   000    Old_age   Always       -       0
201 Soft_Read_Error_Rate    0x000a   253   252   000    Old_age   Always       -       3
202 TA_Increase_Count       0x000a   253   252   000    Old_age   Always       -       0
203 Run_Out_Cancel          0x000b   253   252   180    Pre-fail  Always       -       0
204 Shock_Count_Write_Opern 0x000a   253   252   000    Old_age   Always       -       0
205 Shock_Rate_Write_Opern  0x000a   253   252   000    Old_age   Always       -       0
207 Spin_High_Current       0x002a   252   252   000    Old_age   Always       -       0
208 Spin_Buzz               0x002a   252   252   000    Old_age   Always       -       0
209 Offline_Seek_Performnce 0x0024   194   194   000    Old_age   Offline      -       0
  99 Unknown_Attribute       0x0004   253   253   000    Old_age   Offline      -       0
100 Unknown_Attribute       0x0004   253   253   000    Old_age   Offline      -       0
101 Unknown_Attribute       0x0004   253   253   000    Old_age   Offline      -       0

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
