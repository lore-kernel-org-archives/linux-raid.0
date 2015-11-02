From: Phil Turmel <philip@turmel.org>
Subject: Re: Advice requested
Date: Mon, 2 Nov 2015 10:41:33 -0500
Message-ID: <5637842D.1070000@turmel.org>
References: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
 <56367C33.6060703@turmel.org>
 <CAPpdf5_PUpR7GhBHUaQfWb8Q+7FZenxXgFqbaN3f3r0r6NQNDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf5_PUpR7GhBHUaQfWb8Q+7FZenxXgFqbaN3f3r0r6NQNDA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good morning Dee,

{ Added linux-raid back -- convention on kernel.org is reply-to-all }

On 11/02/2015 09:28 AM, o1bigtenor wrote:
> Reply is interleaved.

Thank you!

> On Sun, Nov 1, 2015 at 2:55 PM, Phil Turmel <philip@turmel.org> wrote:

>> What happened to the other two drives?  If you still have them, please
>> supply "mdadm -E" report for them.
> 
> root@debianbase:/# mdadm -E
> mdadm: No devices to examine

That means you didn't tell it what device(s) to examine, so it did
nothing.  Based on your data below, I expect you need to examine
/dev/sdb1, /dev/sdc1, /dev/sde1, and /dev/sdf1.

{ A look at the section on --examine in "man mdadm" would have helped
here.  Please spend some time reviewing "man mdadm" and "man md". }

It seems /dev/sdd1 is missing, so I guess the device names have changed.
Please supply the reports for all four array devices with their current
names (as shown in the smartctl reports).

Paste the result inline in your reply.

>> Also supply "smartctl -i -A -l scterc /dev/sdX" for each of your drives.
> 
> please see attachment

I've converted your libreoffice file to text -- please just post text
in-line in the future, without wrapping.  No attachments, no pastebin.

Some comments inline:

> root@debianbase:/# smartctl -i -A -l scterc /dev/sdb 
> smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.1.0-2-amd64] (local build) 
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org 
> 
> === START OF INFORMATION SECTION === 
> Model Family:     Seagate Barracuda 7200.12 
> Device Model:     ST31000524AS 
> Serial Number:    9VPE3VX1 
> LU WWN Device Id: 5 000c50 03ee8ad75 
> Firmware Version: JC4B 
> User Capacity:    1,000,204,886,016 bytes [1.00 TB] 
> Sector Size:      512 bytes logical/physical 
> Rotation Rate:    7200 rpm 
> Device is:        In smartctl database [for details use: -P show] 
> ATA Version is:   ATA8-ACS T13/1699-D revision 4 
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s) 
> Local Time is:    Mon Nov  2 07:16:28 2015 CST 
> SMART support is: Available - device has SMART capability. 
> SMART support is: Enabled 
> 
> === START OF READ SMART DATA SECTION === 
> SMART Attributes Data Structure revision number: 10 
> Vendor Specific SMART Attributes with Thresholds: 
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE 
>  1 Raw_Read_Error_Rate     0x000f   117   100   006    Pre-fail  Always       -       150964952 
>  3 Spin_Up_Time            0x0003   100   100   000    Pre-fail  Always       -       0 
>  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       664 
>  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0 

This ^^^ is good.

>  7 Seek_Error_Rate         0x000f   066   060   030    Pre-fail  Always       -       3829738 
>  9 Power_On_Hours          0x0032   073   073   000    Old_age   Always       -       24498 
> 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0 
> 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       646 
> 183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always       -       0 
> 184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0 
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0 
> 188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       0 
> 189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always       -       0 
> 190 Airflow_Temperature_Cel 0x0022   069   052   045    Old_age   Always       -       31 (Min/Max 29/31) 
> 194 Temperature_Celsius     0x0022   031   048   000    Old_age   Always       -       31 (0 17 0 0 0) 
> 195 Hardware_ECC_Recovered  0x001a   035   009   000    Old_age   Always       -       150964952 
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0 

As is this ^^^

> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0 
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0 
> 240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       26106 (151 195 0) 
> 241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       3874945427 
> 242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       3008180623 
> 
> SCT Error Recovery Control: 
>           Read: Disabled 
>          Write: Disabled 

This ^^^ is *bad*.  You have an older desktop drive that supports ERC,
but since it is a desktop drive, it's turned off by default.  You *need*
a boot script that will turn it on every power cycle.  Some references
on "timeout mismatch" are in the post-script.

> root@debianbase:/# smartctl -i -A -l scterc /dev/sdc 
> smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.1.0-2-amd64] (local build) 
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org 
> 
> === START OF INFORMATION SECTION === 
> Model Family:     Seagate Barracuda 7200.14 (AF) 
> Device Model:     ST1000DM003-1ER162 
> Serial Number:    Z4Y27SPH 
> LU WWN Device Id: 5 000c50 079702992 
> Firmware Version: CC45 
> User Capacity:    1,000,204,886,016 bytes [1.00 TB] 
> Sector Sizes:     512 bytes logical, 4096 bytes physical 
> Rotation Rate:    7200 rpm 
> Form Factor:      3.5 inches 
> Device is:        In smartctl database [for details use: -P show] 
> ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b 
> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s) 
> Local Time is:    Mon Nov  2 07:16:38 2015 CST 
> SMART support is: Available - device has SMART capability. 
> SMART support is: Enabled 
> 
> === START OF READ SMART DATA SECTION === 
> SMART Attributes Data Structure revision number: 10 
> Vendor Specific SMART Attributes with Thresholds: 
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE 
>  1 Raw_Read_Error_Rate     0x000f   115   099   006    Pre-fail  Always       -       98239568 
>  3 Spin_Up_Time            0x0003   097   097   000    Pre-fail  Always       -       0 
>  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       89 
>  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0 
>  7 Seek_Error_Rate         0x000f   100   253   030    Pre-fail  Always       -       308478 
>  9 Power_On_Hours          0x0032   096   096   000    Old_age   Always       -       4258 
> 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0 
> 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       89 
> 183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always       -       0 
> 184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0 
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0 
> 188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       0 0 0 
> 189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always       -       0 
> 190 Airflow_Temperature_Cel 0x0022   073   053   045    Old_age   Always       -       27 (Min/Max 24/27) 
> 191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       0 
> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       20 
> 193 Load_Cycle_Count        0x0032   099   099   000    Old_age   Always       -       3807 
> 194 Temperature_Celsius     0x0022   027   047   000    Old_age   Always       -       27 (0 15 0 0 0) 
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0 
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0 
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0 
> 240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       3830h+12m+39.793s 
> 241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       2220627944 
> 242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       24802170836 
> 
> SCT Error Recovery Control command not supported 

This ^^^ is *really bad*.  You have a modern desktop drive that doesn't
support ERC at all.  You *must* use a boot script to override linux's
low level driver timeout for this device.  Please see the references.

> root@debianbase:/# smartctl -i -A -l scterc /dev/sde 
> smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.1.0-2-amd64] (local build) 
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org 
> 
> === START OF INFORMATION SECTION === 
> Model Family:     Seagate Barracuda 7200.12 
> Device Model:     ST31000524AS 
> Serial Number:    9VPE44LL 
> LU WWN Device Id: 5 000c50 03eed16df 
> Firmware Version: JC4B 
> User Capacity:    1,000,204,886,016 bytes [1.00 TB] 
> Sector Size:      512 bytes logical/physical 
> Rotation Rate:    7200 rpm 
> Device is:        In smartctl database [for details use: -P show] 
> ATA Version is:   ATA8-ACS T13/1699-D revision 4 
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s) 
> Local Time is:    Mon Nov  2 07:16:45 2015 CST 
> SMART support is: Available - device has SMART capability. 
> SMART support is: Enabled 
> 
> === START OF READ SMART DATA SECTION === 
> SMART Attributes Data Structure revision number: 10 
> Vendor Specific SMART Attributes with Thresholds: 
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE 
>  1 Raw_Read_Error_Rate     0x000f   118   100   006    Pre-fail  Always       -       184109834 
>  3 Spin_Up_Time            0x0003   100   100   000    Pre-fail  Always       -       0 
>  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       663 
>  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0 
>  7 Seek_Error_Rate         0x000f   065   060   030    Pre-fail  Always       -       3341907 
>  9 Power_On_Hours          0x0032   073   073   000    Old_age   Always       -       24462 
> 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0 
> 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       644 
> 183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always       -       0 
> 184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0 
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0 
> 188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       0 
> 189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always       -       0 
> 190 Airflow_Temperature_Cel 0x0022   069   047   045    Old_age   Always       -       31 (Min/Max 25/31) 
> 194 Temperature_Celsius     0x0022   031   053   000    Old_age   Always       -       31 (0 18 0 0 0) 
> 195 Hardware_ECC_Recovered  0x001a   026   014   000    Old_age   Always       -       184109834 
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0 
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0 
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0 
> 240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       26005 (154 33 0) 
> 241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       1062575833 
> 242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       3869056902 
> 
> SCT Error Recovery Control: 
>           Read: Disabled 
>          Write: Disabled 

Again.

> root@debianbase:/# smartctl -i -A -l scterc /dev/sdf 
> smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.1.0-2-amd64] (local build) 
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org 
> 
> === START OF INFORMATION SECTION === 
> Model Family:     Seagate Barracuda 7200.12 
> Device Model:     ST31000524AS 
> Serial Number:    9VPE31PN 
> LU WWN Device Id: 5 000c50 03eeadf56 
> Firmware Version: JC4B 
> User Capacity:    1,000,204,886,016 bytes [1.00 TB] 
> Sector Size:      512 bytes logical/physical 
> Rotation Rate:    7200 rpm 
> Device is:        In smartctl database [for details use: -P show] 
> ATA Version is:   ATA8-ACS T13/1699-D revision 4 
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s) 
> Local Time is:    Mon Nov  2 07:17:53 2015 CST 
> SMART support is: Available - device has SMART capability. 
> SMART support is: Enabled 
> 
> === START OF READ SMART DATA SECTION === 
> SMART Attributes Data Structure revision number: 10 
> Vendor Specific SMART Attributes with Thresholds: 
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE 
>  1 Raw_Read_Error_Rate     0x000f   116   099   006    Pre-fail  Always       -       104938837 
>  3 Spin_Up_Time            0x0003   100   100   000    Pre-fail  Always       -       0 
>  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       594 
>  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0 
>  7 Seek_Error_Rate         0x000f   066   060   030    Pre-fail  Always       -       3679723 
>  9 Power_On_Hours          0x0032   073   073   000    Old_age   Always       -       24417 
> 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0 
> 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       579 
> 183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always       -       0 
> 184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0 
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0 
> 188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       0 
> 189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always       -       0 
> 190 Airflow_Temperature_Cel 0x0022   070   040   045    Old_age   Always   In_the_past 30 (19 143 30 29 0) 
> 194 Temperature_Celsius     0x0022   030   060   000    Old_age   Always       -       30 (0 18 0 0 0) 
> 195 Hardware_ECC_Recovered  0x001a   036   013   000    Old_age   Always       -       104938837 
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0 
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0 
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0 
> 240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       25870 (135 125 0) 
> 241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       366206138 
> 242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       37669615 
> 
> SCT Error Recovery Control: 
>           Read: Disabled 
>          Write: Disabled 

And again.

Looking for this is one of the reasons I asked for these reports --
non-raid rated drives producing timeout mismatch failures is a common
problem seen on this list.  I also wanted to know if your drives are
generally healthy -- they are -- and how that might have impacted your
situation.  { I had some of the same Seagate .12 drives -- they didn't
start failing until they had nearly 40k hours. }

Another reason I asked for this is that drive names can change on power
cycles and unplug/replug cycles.  Knowing what device is what (versus
drive serial number) is important.  Please verify drive serial number
versus device name after any power cycle or replug event and let us know
any changes.

> enclosed is also a copy of the kernel log which indicates that a drive error
> had occurred. My thinking is that my ups box (too small but all I could find
> when I bought the system) didn't provide enough power in a severe brown-
> out incident.

> Aug 28 10:39:28 debiantestingbase kernel: [    3.025162] scsi 3:0:0:0: Direct-Access     ATA      ST31000524AS     JC4B PQ: 0 ANSI: 5
> Aug 28 10:39:28 debiantestingbase kernel: [    3.025768] sd 3:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> Aug 28 10:39:28 debiantestingbase kernel: [    3.026296] sd 3:0:0:0: [sdb] Write Protect is off
> Aug 28 10:39:28 debiantestingbase kernel: [    3.026304] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> Aug 28 10:39:28 debiantestingbase kernel: [    3.026484] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 28 10:39:28 debiantestingbase kernel: [    3.028273]  sdb: sdb1
> Aug 28 10:39:28 debiantestingbase kernel: [    3.028698] sd 3:0:0:0: [sdb] Attached SCSI disk
> Aug 28 10:39:28 debiantestingbase kernel: [    3.086532] Switched to clocksource tsc
> Aug 28 10:39:28 debiantestingbase kernel: [    3.168919] md: bind<sdb1>
> Aug 28 10:39:28 debiantestingbase kernel: [    3.342285] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Aug 28 10:39:28 debiantestingbase kernel: [    3.343153] ata5.00: ATA-9: ST1000DM003-1ER162, CC45, max UDMA/133
> Aug 28 10:39:28 debiantestingbase kernel: [    3.343158] ata5.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> Aug 28 10:39:28 debiantestingbase kernel: [    3.344067] ata5.00: configured for UDMA/133
> Aug 28 10:39:28 debiantestingbase kernel: [    3.344255] scsi 4:0:0:0: Direct-Access     ATA      ST1000DM003-1ER1 CC45 PQ: 0 ANSI: 5
> Aug 28 10:39:28 debiantestingbase kernel: [    3.344627] sd 4:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> Aug 28 10:39:28 debiantestingbase kernel: [    3.344631] sd 4:0:0:0: [sdc] 4096-byte physical blocks
> Aug 28 10:39:28 debiantestingbase kernel: [    3.344823] sd 4:0:0:0: [sdc] Write Protect is off
> Aug 28 10:39:28 debiantestingbase kernel: [    3.344831] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> Aug 28 10:39:28 debiantestingbase kernel: [    3.344946] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 28 10:39:28 debiantestingbase kernel: [    3.411364]  sdc: sdc1
> Aug 28 10:39:28 debiantestingbase kernel: [    3.412317] sd 4:0:0:0: [sdc] Attached SCSI disk
> Aug 28 10:39:28 debiantestingbase kernel: [    3.501080] md: bind<sdc1>
> Aug 28 10:39:28 debiantestingbase kernel: [    3.662509] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Aug 28 10:39:28 debiantestingbase kernel: [    3.674767] ata6.00: ATA-8: Corsair Force 3 SSD, 1.3.3, max UDMA/133
> Aug 28 10:39:28 debiantestingbase kernel: [    3.674772] ata6.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> Aug 28 10:39:28 debiantestingbase kernel: [    3.684647] ata6.00: configured for UDMA/133
> Aug 28 10:39:28 debiantestingbase kernel: [    3.684933] scsi 5:0:0:0: Direct-Access     ATA      Corsair Force 3  3    PQ: 0 ANSI: 5
> Aug 28 10:39:28 debiantestingbase kernel: [    3.685504] sd 5:0:0:0: [sdd] 468862128 512-byte logical blocks: (240 GB/223 GiB)
> Aug 28 10:39:28 debiantestingbase kernel: [    3.685975] sd 5:0:0:0: [sdd] Write Protect is off
> Aug 28 10:39:28 debiantestingbase kernel: [    3.685983] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> Aug 28 10:39:28 debiantestingbase kernel: [    3.686186] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 28 10:39:28 debiantestingbase kernel: [    3.688051]  sdd: sdd1 sdd4 < sdd5 sdd6 sdd7 sdd8 sdd9 sdd10 >
> Aug 28 10:39:28 debiantestingbase kernel: [    3.689305] sd 5:0:0:0: [sdd] Attached SCSI disk
> Aug 28 10:39:28 debiantestingbase kernel: [    4.002712] ata8: SATA link down (SStatus 0 SControl 300)
> Aug 28 10:39:28 debiantestingbase kernel: [    4.003107] scsi 8:0:0:0: Direct-Access     ATA      ST31000524AS     JC4B PQ: 0 ANSI: 5
> Aug 28 10:39:28 debiantestingbase kernel: [    4.003597] sd 8:0:0:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> Aug 28 10:39:28 debiantestingbase kernel: [    4.003843] scsi 9:0:0:0: Direct-Access     ATA      ST31000524AS     JC4B PQ: 0 ANSI: 5
> Aug 28 10:39:28 debiantestingbase kernel: [    4.003975] sd 8:0:0:0: [sde] Write Protect is off
> Aug 28 10:39:28 debiantestingbase kernel: [    4.003980] sd 8:0:0:0: [sde] Mode Sense: 00 3a 00 00
> Aug 28 10:39:28 debiantestingbase kernel: [    4.004090] sd 8:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 28 10:39:28 debiantestingbase kernel: [    4.004478] sd 9:0:0:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> Aug 28 10:39:28 debiantestingbase kernel: [    4.004645] sd 9:0:0:0: [sdf] Write Protect is off
> Aug 28 10:39:28 debiantestingbase kernel: [    4.004650] sd 9:0:0:0: [sdf] Mode Sense: 00 3a 00 00
> Aug 28 10:39:28 debiantestingbase kernel: [    4.004737] sd 9:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 28 10:39:28 debiantestingbase kernel: [    4.004778] scsi 15:0:0:0: Processor         Marvell  91xx Config      1.01 PQ: 0 ANSI: 5
> Aug 28 10:39:28 debiantestingbase kernel: [    4.006375]  sdf: sdf1
> Aug 28 10:39:28 debiantestingbase kernel: [    4.006967] sd 9:0:0:0: [sdf] Attached SCSI disk
> Aug 28 10:39:28 debiantestingbase kernel: [    4.008855]  sde: sde1
> Aug 28 10:39:28 debiantestingbase kernel: [    4.009704] sd 8:0:0:0: [sde] Attached SCSI disk
> Aug 28 10:39:28 debiantestingbase kernel: [    4.018710] ata16.00: exception Emask 0x1 SAct 0x0 SErr 0x0 action 0x0
> Aug 28 10:39:28 debiantestingbase kernel: [    4.018753] ata16.00: irq_stat 0x40000001
> Aug 28 10:39:28 debiantestingbase kernel: [    4.018783] ata16.00: cmd a0/01:00:00:00:01/00:00:00:00:
> Aug 28 10:39:28 debiantestingbase kernel: [    4.018783]          Inquiry 12 01 00 00 ff 00res 50/00:00:af:6d:70/00:00:74:00:
> Aug 28 10:39:28 debiantestingbase kernel: [    4.018868] ata16.00: status: { DRDY }

This ^^^ isn't really an error.

> Aug 28 10:39:28 debiantestingbase kernel: [    4.125325] random: nonblocking pool is initialized
> Aug 28 10:39:28 debiantestingbase kernel: [    4.125530] md: bind<sde1>
> Aug 28 10:39:28 debiantestingbase kernel: [    4.142140] md: bind<sdf1>
> Aug 28 10:39:28 debiantestingbase kernel: [    4.144984] md: raid10 personality registered for level 10
> Aug 28 10:39:28 debiantestingbase kernel: [    4.145397] md/raid10:md0: active with 4 out of 4 devices

If it was, you wouldn't get this ^^^ success.

> Aug 28 10:39:28 debiantestingbase kernel: [    4.145440] md0: detected capacity change from 0 to 2000403038208
> Aug 28 10:39:28 debiantestingbase kernel: [    4.208978]  md0:
> Aug 28 10:39:28 debiantestingbase kernel: [    4.479305] device-mapper: uevent: version 1.0.3
> Aug 28 10:39:28 debiantestingbase kernel: [    4.479536] device-mapper: ioctl: 4.30.0-ioctl (2014-12-22) initialised: dm-devel@redhat.com

This section of your syslog is too far back in time -- before the failure.

[trim /]

> Was following directions from one person on linux-raid and when he stopped
> responding turned to someone who is somewhat connected with redhat and
> hard drive stuff. There seemed to be a consensus that I needed to use low
> level tools in an attempt to recover files, if I could. As there are about 200k
> I wasn't looking forward to repairing things ;-(  !

A link to the linux-raid archive of the prior discussion might help.
And you might still need low level tools -- we are still trying to get
your array started.  Then we can look at the next layer on top of that.
 Based on your prior mails, /dev/md0 was formatted as ext4, yes?

> Thanking you for your assistance.

You're welcome.

Phil

[1] http://marc.info/?l=linux-raid&m=139050322510249&w=2
[2] http://marc.info/?l=linux-raid&m=135863964624202&w=2
[3] http://marc.info/?l=linux-raid&m=135811522817345&w=1
[4] http://marc.info/?l=linux-raid&m=133761065622164&w=2
[5] http://marc.info/?l=linux-raid&m=132477199207506
[6] http://marc.info/?l=linux-raid&m=133665797115876&w=2
[7] http://marc.info/?l=linux-raid&m=142487508806844&w=3
[8] http://marc.info/?l=linux-raid&m=144535576302583&w=2

