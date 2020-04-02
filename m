From: Wolfgang Denk <wd@denx.de>
Subject: Re: RAID Issues - RAID10 working but with errors
Date: Thu, 02 Apr 2020 11:19:14 +0200
Message-ID: <20200402091914.4330D24003E@gemini.denx.de>
References: <d934f662-9fde-370b-bb4b-b92bd1730c96@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <d934f662-9fde-370b-bb4b-b92bd1730c96@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Adam,

In message <d934f662-9fde-370b-bb4b-b92bd1730c96@websitemanagers.com.au> you wrote:
>
> smartctl -x /dev/sdd
...
> Model Family:     Western Digital RE4
> Device Model:     WDC WD2003FYYS-02W0B0
> Serial Number:    WD-WMAY00922575
...
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>    1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    23
>    3 Spin_Up_Time            POS--K   253   253   021    -    8583
>    4 Start_Stop_Count        -O--CK   100   100   000    -    77
>    5 Reallocated_Sector_Ct   PO--CK   184   184   140    -    126
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>    7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
>    9 Power_On_Hours          -O--CK   017   017   000    -    61089
>   10 Spin_Retry_Count        -O--CK   100   253   000    -    0
>   11 Calibration_Retry_Count -O--CK   100   253   000    -    0
>   12 Power_Cycle_Count       -O--CK   100   100   000    -    67
> 192 Power-Off_Retract_Count -O--CK   200   200   000    -    48
> 193 Load_Cycle_Count        -O--CK   200   200   000    -    28
> 194 Temperature_Celsius     -O---K   118   105   000    -    34
> 196 Reallocated_Event_Count -O--CK   095   095   000    -    105
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 197 Current_Pending_Sector  -O--CK   200   200   000    -    21
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 198 Offline_Uncorrectable   ----CK   200   200   000    -    0
> 199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
> 200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    2
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This disk has a pretty high count of reallocated sectors, plus a lot
of other errors.  I recommend to replace it ASAP.  It is not worth
further investigation - this drive has reached EOL.


> smartctl -x /dev/sdf
...
> Model Family:     Western Digital RE4
> Device Model:     WDC WD2003FYYS-02W0B0
> Serial Number:    WD-WMAY00611922
...
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>    1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
>    3 Spin_Up_Time            POS--K   253   253   021    -    7350
>    4 Start_Stop_Count        -O--CK   100   100   000    -    73
>    5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
>    7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
>    9 Power_On_Hours          -O--CK   051   051   000    -    36231
>   10 Spin_Retry_Count        -O--CK   100   253   000    -    0
>   11 Calibration_Retry_Count -O--CK   100   253   000    -    0
>   12 Power_Cycle_Count       -O--CK   100   100   000    -    64
> 192 Power-Off_Retract_Count -O--CK   200   200   000    -    46
> 193 Load_Cycle_Count        -O--CK   200   200   000    -    26
> 194 Temperature_Celsius     -O---K   118   094   000    -    34
> 196 Reallocated_Event_Count -O--CK   200   200   000    -    0
> 197 Current_Pending_Sector  -O--CK   200   200   000    -    0
> 198 Offline_Uncorrectable   ----CK   200   200   000    -    0
> 199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
> 200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    2
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
...
>    40 -- 51 0a 00 00 00 2a 25 4e 10 40 00  Error: UNC at LBA = 
> 0x2a254e10 = 707087888
...
>    40 -- 51 0a 00 00 00 1e 5a 3e 86 40 00  Error: UNC at LBA = 
> 0x1e5a3e86 = 509230726
...
>    40 -- 51 0a 00 00 00 1e 0c 77 d3 40 00  Error: UNC at LBA = 
> 0x1e0c77d3 = 504133587
...
>    40 -- 51 0a 00 00 00 1d e4 17 e7 40 00  Error: UNC at LBA = 
> 0x1de417e7 = 501487591
...
>    40 -- 51 0a 00 00 00 1d c0 73 99 40 00  Error: UNC at LBA = 
> 0x1dc07399 = 499151769
...
>    40 -- 51 0a 00 00 00 1d 23 fc 01 40 00  Error: UNC at LBA = 
> 0x1d23fc01 = 488897537

This disk also has stored a number of errors, but it does not look
as bad as the first one.  However, there are errors.  I would
replace it as well.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"A complex system that works is invariably found to have evolved from
a simple system that worked."             - John Gall, _Systemantics_
