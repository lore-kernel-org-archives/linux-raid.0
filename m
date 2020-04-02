From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID Issues - RAID10 working but with errors
Date: Fri, 3 Apr 2020 00:31:45 +1100
Message-ID: <5a4c1822-7452-db80-37cc-bf2bf6fb0c75@websitemanagers.com.au>
References: <d934f662-9fde-370b-bb4b-b92bd1730c96@websitemanagers.com.au>
 <20200402091914.4330D24003E@gemini.denx.de>
 <c95d82c4-1ee9-c783-48d0-1b8c3812d324@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c95d82c4-1ee9-c783-48d0-1b8c3812d324@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 2/4/20 22:20, Phil Turmel wrote:
> On 4/2/20 5:19 AM, Wolfgang Denk wrote:
>> Dear Adam,
>>
>> In message 
>> <d934f662-9fde-370b-bb4b-b92bd1730c96@websitemanagers.com.au> you wrote:
>>>
>>> smartctl -x /dev/sdd
>> ...
>>> Model Family:     Western Digital RE4
>>> Device Model:     WDC WD2003FYYS-02W0B0
>>> Serial Number:    WD-WMAY00922575
>> ...
>>> SMART Attributes Data Structure revision number: 16
>>> Vendor Specific SMART Attributes with Thresholds:
>>> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>>>     1 Raw_Read_Error_Rate     POSR-K   200   200   051    - 23
>>>     3 Spin_Up_Time            POS--K   253   253   021    - 8583
>>>     4 Start_Stop_Count        -O--CK   100   100   000    - 77
>>>     5 Reallocated_Sector_Ct   PO--CK   184   184   140    - 126
>> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>     7 Seek_Error_Rate         -OSR-K 200   200   000    -    0
>>>     9 Power_On_Hours          -O--CK   017   017   000    - 61089
>>>    10 Spin_Retry_Count        -O--CK   100   253   000    - 0
>>>    11 Calibration_Retry_Count -O--CK   100   253   000    - 0
>>>    12 Power_Cycle_Count       -O--CK   100   100   000    - 67
>>> 192 Power-Off_Retract_Count -O--CK   200   200   000    - 48
>>> 193 Load_Cycle_Count        -O--CK   200   200   000    - 28
>>> 194 Temperature_Celsius     -O---K   118   105   000    - 34
>>> 196 Reallocated_Event_Count -O--CK   095   095   000    - 105
>> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> 197 Current_Pending_Sector  -O--CK 200   200   000    -    21
>> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> 198 Offline_Uncorrectable   ----CK 200   200   000    -    0
>>> 199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
>>> 200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    2
>> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> This disk has a pretty high count of reallocated sectors, plus a lot
>> of other errors.  I recommend to replace it ASAP.  It is not worth
>
> Concur.  Old and worn out.  Personally, I replace when reallocations 
> are in the 10 to 20 range.  Once you get past that, they seem to start 
> coming much faster.
>
Thank you, I'll check if the drive can be replaced by warranty, or else 
check if I have a spare. Otherwise, I may be forced to buy a replacement.
>
>>> smartctl -x /dev/sdf
>> ...
>>> Model Family:     Western Digital RE4
>>> Device Model:     WDC WD2003FYYS-02W0B0
>>> Serial Number:    WD-WMAY00611922
>> ...
>>> ID# ATTRIBUTE_NAME          FLAGS VALUE WORST THRESH FAIL RAW_VALUE
>>>     1 Raw_Read_Error_Rate     POSR-K   200   200   051    - 0
>>>     3 Spin_Up_Time            POS--K   253   253   021    - 7350
>>>     4 Start_Stop_Count        -O--CK   100   100   000    - 73
>>>     5 Reallocated_Sector_Ct   PO--CK   200   200   140    - 0
>>>     7 Seek_Error_Rate         -OSR-K   200   200   000    - 0
>>>     9 Power_On_Hours          -O--CK   051   051   000    - 36231
>>>    10 Spin_Retry_Count        -O--CK   100   253   000    - 0
>>>    11 Calibration_Retry_Count -O--CK   100   253   000    - 0
>>>    12 Power_Cycle_Count       -O--CK   100   100   000    - 64
>>> 192 Power-Off_Retract_Count -O--CK   200   200   000    - 46
>>> 193 Load_Cycle_Count        -O--CK   200   200   000    - 26
>>> 194 Temperature_Celsius     -O---K   118   094   000    - 34
>>> 196 Reallocated_Event_Count -O--CK   200   200   000    -    0
>>> 197 Current_Pending_Sector  -O--CK   200   200   000    -    0
>>> 198 Offline_Uncorrectable   ----CK   200   200   000    -    0
>>> 199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
>>> 200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    2
>> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> ...
>>>     40 -- 51 0a 00 00 00 2a 25 4e 10 40 00  Error: UNC at LBA =
>>> 0x2a254e10 = 707087888
>> ...
>>>     40 -- 51 0a 00 00 00 1e 5a 3e 86 40 00  Error: UNC at LBA =
>>> 0x1e5a3e86 = 509230726
>> ...
>>>     40 -- 51 0a 00 00 00 1e 0c 77 d3 40 00  Error: UNC at LBA =
>>> 0x1e0c77d3 = 504133587
>> ...
>>>     40 -- 51 0a 00 00 00 1d e4 17 e7 40 00  Error: UNC at LBA =
>>> 0x1de417e7 = 501487591
>> ...
>>>     40 -- 51 0a 00 00 00 1d c0 73 99 40 00  Error: UNC at LBA =
>>> 0x1dc07399 = 499151769
>> ...
>>>     40 -- 51 0a 00 00 00 1d 23 fc 01 40 00  Error: UNC at LBA =
>>> 0x1d23fc01 = 488897537
>>
>> This disk also has stored a number of errors, but it does not look
>> as bad as the first one.  However, there are errors.  I would
>> replace it as well.
>
> Disagree.  No reallocations by the drive, just bad block log entries. 
> This drive is fine.  The bad block log mis-feature should be turned 
> off after failing this drive, zeroing its superblock, and adding back 
> to the array (so the bad blocks get reconstructed).
>
> The bad block log mis-feature should never have been merged in its 
> current form--it simply prevents redundancy from ever working on 
> problem sectors, and cannot distinguish correctable communications 
> problems from true underlying uncorrectable sectors.  Which should be 
> left to the drive, at least until it runs out of spare sectors.  (And 
> why would you keep such a drive anyways?) Bad block logging in MD raid 
> is *Dangerous* *Junk*.


So I have a "spare" drive in the array, what steps should I take to 
"fix" this? Here are the statistics on the spare drive. Maybe it is just 
as bad as the other two anyway, and I should replace all three?

If I can, I assume I would run some commands on the spare to configure 
it to not have any BBL, then add it back to the array, use it to replace 
the existing bad drive?

I assume that the two "good" drives and mdadm output, suggests that I 
have a single "good" copy of all the data on the two good drives:

     Number   Major   Minor   RaidDevice State
        0       8       18        0      active sync set-A /dev/sdb2
        1       8       34        1      active sync set-B /dev/sdc2
        2       8       50        2      active sync set-A /dev/sdd2
        4       8       82        3      active sync set-B /dev/sdf2

        3       8       66        -      spare   /dev/sde2

(Good drives assumed to be sdb and sdc)

Equally, all data is real-time synced to another machine (DRBD), as well 
as being backed up regularly, so I'm not super concerned about the data 
content, but I do want to maximise uptime, and minimise risk to the data 
as it really is rather important (understatement...).


smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-8-amd64] (local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital RE4
Device Model:     WDC WD2003FYYS-02W0B0


SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
   3 Spin_Up_Time            POS--K   253   253   021    -    7391
   4 Start_Stop_Count        -O--CK   100   100   000    -    72
   5 Reallocated_Sector_Ct   PO--CK   181   181   140    -    151
   7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
   9 Power_On_Hours          -O--CK   009   008   000    -    66691
  10 Spin_Retry_Count        -O--CK   100   253   000    -    0
  11 Calibration_Retry_Count -O--CK   100   253   000    -    0
  12 Power_Cycle_Count       -O--CK   100   100   000    -    62
192 Power-Off_Retract_Count -O--CK   200   200   000    -    47
193 Load_Cycle_Count        -O--CK   200   200   000    -    24
194 Temperature_Celsius     -O---K   116   103   000    -    36
196 Reallocated_Event_Count -O--CK   059   059   000    -    141
197 Current_Pending_Sector  -O--CK   200   200   000    -    3
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                             ||||||_ K auto-keep
                             |||||__ C event count
                             ||||___ R error rate
                             |||____ S speed/performance
                             ||_____ O updated online
                             |______ P prefailure warning

[......]

Error 646 [21] occurred at disk power-on lifetime: 1152 hours (48 days + 
0 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 02 c3 87 67 40 00  Error: UNC at LBA = 
0x02c38767 = 46368615

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 a8 00 00 02 c3 82 00 40 08 31d+11:36:50.175  READ FPDMA 
QUEUED
   60 0a 00 00 a0 00 00 02 c3 78 00 40 08 31d+11:36:49.708  READ FPDMA 
QUEUED
   60 0a 00 00 98 00 00 02 c3 6e 00 40 08 31d+11:36:49.574  READ FPDMA 
QUEUED
   60 0a 00 00 90 00 00 02 c3 64 00 40 08 31d+11:36:49.149  READ FPDMA 
QUEUED
   60 0a 00 00 88 00 00 02 c3 5a 00 40 08 31d+11:36:49.141  READ FPDMA 
QUEUED

Error 645 [20] occurred at disk power-on lifetime: 890 hours (37 days + 
2 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 66 7c ad fb 40 00  Error: UNC at LBA = 
0x667cadfb = 1719447035

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 58 00 00 66 7c ac 80 40 08 20d+13:07:16.625  READ FPDMA 
QUEUED
   60 0a 00 00 50 00 00 66 7c a2 80 40 08 20d+13:07:16.603  READ FPDMA 
QUEUED
   ea 00 00 00 00 00 00 00 00 00 00 e0 08 20d+13:07:16.474  FLUSH CACHE EXT
   61 00 07 00 40 00 00 02 54 38 18 40 08 20d+13:07:16.474  WRITE FPDMA 
QUEUED
   ea 00 00 00 00 00 00 00 00 00 00 e0 08 20d+13:07:16.462  FLUSH CACHE EXT

Error 644 [19] occurred at disk power-on lifetime: 890 hours (37 days + 
2 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 66 54 17 ee 40 00  Error: UNC at LBA = 
0x665417ee = 1716787182

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 98 00 00 66 54 15 80 40 08 20d+13:06:57.140  READ FPDMA 
QUEUED
   61 07 00 00 90 00 00 66 54 0e 80 40 08 20d+13:06:57.140  WRITE FPDMA 
QUEUED
   61 00 08 00 88 00 00 02 54 38 10 40 08 20d+13:06:57.140  WRITE FPDMA 
QUEUED
   ea 00 00 00 00 00 00 00 00 00 00 e0 08 20d+13:06:56.685  FLUSH CACHE EXT
   ef 00 10 00 02 00 00 00 00 00 00 a0 08 20d+13:06:56.684  SET FEATURES 
[Enable SATA feature]

Error 643 [18] occurred at disk power-on lifetime: 890 hours (37 days + 
2 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 66 54 0e dc 40 00  Error: UNC at LBA = 
0x66540edc = 1716784860

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 e0 00 00 66 54 0b 80 40 08 20d+13:06:54.853  READ FPDMA 
QUEUED
   60 08 00 00 d8 00 00 66 54 03 80 40 08 20d+13:06:54.845  READ FPDMA 
QUEUED
   60 08 00 00 d0 00 00 66 53 fb 80 40 08 20d+13:06:54.837  READ FPDMA 
QUEUED
   60 08 00 00 c8 00 00 66 53 f3 80 40 08 20d+13:06:54.829  READ FPDMA 
QUEUED
   60 09 00 00 c0 00 00 66 53 ea 80 40 08 20d+13:06:54.820  READ FPDMA 
QUEUED

Error 642 [17] occurred at disk power-on lifetime: 890 hours (37 days + 
2 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 66 53 a2 fd 40 00  Error: UNC at LBA = 
0x6653a2fd = 1716757245

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 a0 00 00 66 53 9b 80 40 08 20d+13:06:52.760  READ FPDMA 
QUEUED
   60 09 80 00 98 00 00 66 53 92 00 40 08 20d+13:06:52.751  READ FPDMA 
QUEUED
   60 0a 00 00 90 00 00 66 53 88 00 40 08 20d+13:06:52.740  READ FPDMA 
QUEUED
   60 0a 00 00 88 00 00 66 53 7e 00 40 08 20d+13:06:52.730  READ FPDMA 
QUEUED
   60 09 80 00 80 00 00 66 53 74 80 40 08 20d+13:06:52.721  READ FPDMA 
QUEUED

Error 641 [16] occurred at disk power-on lifetime: 889 hours (37 days + 
1 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 3f f5 31 61 40 00  Error: UNC at LBA = 
0x3ff53161 = 1073033569

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 40 00 00 3f f5 2d 00 40 08 20d+11:59:33.169  READ FPDMA 
QUEUED
   60 0a 00 00 38 00 00 3f f5 23 00 40 08 20d+11:59:33.159  READ FPDMA 
QUEUED
   60 08 80 00 30 00 00 3f f5 1a 80 40 08 20d+11:59:33.151  READ FPDMA 
QUEUED
   60 0a 00 00 28 00 00 3f f5 10 80 40 08 20d+11:59:33.142  READ FPDMA 
QUEUED
   60 0a 00 00 20 00 00 3f f5 06 80 40 08 20d+11:59:33.132  READ FPDMA 
QUEUED

Error 640 [15] occurred at disk power-on lifetime: 889 hours (37 days + 
1 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 3e ee 42 1a 40 00  Error: UNC at LBA = 
0x3eee421a = 1055801882

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 70 00 00 3e ee 41 00 40 08 20d+11:57:50.591  READ FPDMA 
QUEUED
   60 0a 00 00 68 00 00 3e ee 37 00 40 08 20d+11:57:50.565  READ FPDMA 
QUEUED
   60 0a 00 00 60 00 00 3e ee 2d 00 40 08 20d+11:57:50.556  READ FPDMA 
QUEUED
   60 0a 00 00 58 00 00 3e ee 23 00 40 08 20d+11:57:50.547  READ FPDMA 
QUEUED
   60 0a 00 00 50 00 00 3e ee 19 00 40 08 20d+11:57:50.525  READ FPDMA 
QUEUED

Error 639 [14] occurred at disk power-on lifetime: 889 hours (37 days + 
1 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 3e ec be 4c 40 00  Error: UNC at LBA = 
0x3eecbe4c = 1055702604

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 a8 00 00 3e ec ba 80 40 08 20d+11:57:44.704  READ FPDMA 
QUEUED
   60 08 80 00 a0 00 00 3e ec b2 00 40 08 20d+11:57:44.696  READ FPDMA 
QUEUED
   60 0a 00 00 98 00 00 3e ec a8 00 40 08 20d+11:57:44.671  READ FPDMA 
QUEUED
   ea 00 00 00 00 00 00 00 00 00 00 e0 08 20d+11:57:44.664  FLUSH CACHE EXT
   60 0a 00 00 80 00 00 3e ec 9e 00 40 08 20d+11:57:44.659  READ FPDMA 
QUEUED

Note, parts were omitted, hopefully I've included the relevant/important 
parts. The other two drives show 0 errors (it looks like to me):

sdb:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    73
   3 Spin_Up_Time            POS--K   253   253   021    -    9008
   4 Start_Stop_Count        -O--CK   100   100   000    -    78
   5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
   7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
   9 Power_On_Hours          -O--CK   022   022   000    -    57426
  10 Spin_Retry_Count        -O--CK   100   253   000    -    0
  11 Calibration_Retry_Count -O--CK   100   253   000    -    0
  12 Power_Cycle_Count       -O--CK   100   100   000    -    65
192 Power-Off_Retract_Count -O--CK   200   200   000    -    46
193 Load_Cycle_Count        -O--CK   200   200   000    -    31
194 Temperature_Celsius     -O---K   105   095   000    -    47
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    6

sdc:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    42
   3 Spin_Up_Time            POS--K   253   253   021    -    8441
   4 Start_Stop_Count        -O--CK   100   100   000    -    69
   5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
   7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
   9 Power_On_Hours          -O--CK   010   010   000    -    65784
  10 Spin_Retry_Count        -O--CK   100   253   000    -    0
  11 Calibration_Retry_Count -O--CK   100   253   000    -    0
  12 Power_Cycle_Count       -O--CK   100   100   000    -    67
192 Power-Off_Retract_Count -O--CK   200   200   000    -    48
193 Load_Cycle_Count        -O--CK   200   200   000    -    20
194 Temperature_Celsius     -O---K   120   105   000    -    32
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    2


>
>> Best regards,
>>
>> Wolfgang Denk
>
> Regards,
>
> Phil
>
