From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID Recovery
Date: Wed, 8 Mar 2017 01:06:12 +1100
Message-ID: <94b4591a-bda1-529b-3af1-c451b657082f@websitemanagers.com.au>
References: <936e84af-f190-3541-bdf8-eaa0c42d2ddc@websitemanagers.com.au>
 <e4d9724d-ab52-aa79-c600-7b287c16a182@turmel.org>
 <7cefe670-dcea-6e04-b090-b215a6a218c9@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7cefe670-dcea-6e04-b090-b215a6a218c9@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

BTW, just some more info I've found... either almost the entire drives 
are RAID1 mirrors, or all 4 are RAID1 mirrors:

root@ubuntu:~# cmp /dev/sda /dev/sdb
/dev/sda /dev/sdb differ: byte 1000162959365, line 243319233
root@ubuntu:~# cmp /dev/sdc /dev/sdd
/dev/sdc /dev/sdd differ: byte 1000162971653, line 243236929

Now I'll need to compare sdb and sdc to find out if all 4 are identical...

PS, they are 1TB drives, so sure, might be a minute amount of unique 
data at the very end of the drives....

Other option, they have been re-initialised/zero'd or similar, and thats 
why all the data is identical (useless). I was hoping to get a starting 
point for where the partition boundaries might have been ....

Regards,
Adam


On 7/3/17 20:17, Adam Goryachev wrote:
>
>
> On 7/3/17 07:10, Phil Turmel wrote:
>> On 03/06/2017 10:07 AM, Adam Goryachev wrote:
>>> Hi all,
>>>
>>> I'm trying to assist a friend to recover their RAID array, it consists
>>> of 4 drives, most likely in RAID10. It was a linux based NAS (AFAIK). I
>>> would really appreciate any tips or suggestions...
>>>
>>> First, the bad news:
>>>
>>> mdadm --misc --examine /dev/sd[abcd]
>>> /dev/sda:
>>>     MBR Magic : aa55
>>> /dev/sdb:
>>>     MBR Magic : aa55
>>> /dev/sdc:
>>>     MBR Magic : aa55
>>> /dev/sdd:
>>>     MBR Magic : aa55
>>>
>>> This really doesn't look promising.... but the disks themselves look
>>> "healthy"... at least mostly.
>> As Reindl said, this by itself is no surprise.  The NAS has to boot off
>> of *something*, so partitions for /boot, /swap, /, and /data, or some
>> combination, is common for such small systems.
>>
>> The first partition is likely raid1 across all devices for /boot.
>> After that, all bets are off.
> OK, so since it looks like the partition table has been lost, is there 
> something that could be used to define where the partition table 
> boundaries are? eg, if the raid is marked at the beginning of each 
> partition, then finding it will show that "this" is the beginning, or 
> vice versa if the raid marker is at the end of the partitions....
>>> Looking at the content of the drives, it might be possible that all 
>>> four
>>> drives were in RAID1 ... at least, I can find identical data on all 
>>> four
>>> of the drives:
>>>
>>> Running this command for each drive:
>>>
>>> strings /dev/sdd |cat -n |less
>>>
>>> looking for some "text", and I find what looks like a log file snipped
>>> which is identical across all four drives. Thats 25 lines of output,
>>> that exists on the same output line number, matching across all 4
>>> drives. So perhaps I have a 4 drive RAID1, which I guess should make it
>>> easier to recover from.
>> Probably just a 4x raid1 mirror for the root partition.
> OK, so if I can find where the drives stop being identical, then I can 
> probably identify the end of the root partition. Also, if I can 
> recover the root partition (not the goal) then it might contain some 
> valuable information on the original config of the rest of the 
> drives.... and hence get to recover the actual data partitions.
>>> Disks are /dev/sda /dev/sdb /dev/sdc /dev/sdd, all identical
>>> "partitions" that don't seem to exist, but there is a MBR partition 
>>> table
>>>
>>> gdisk -l /dev/sda
>>> GPT fdisk (gdisk) version 1.0.1
>>>
>>> Partition table scan:
>>>    MBR: MBR only
>>>    BSD: not present
>>>    APM: not present
>>>    GPT: not present
>>>
>>>
>>> ***************************************************************
>>> Found invalid GPT and valid MBR; converting MBR to GPT format
>>> in memory.
>>> ***************************************************************
>>>
>>> Disk /dev/sda: 1953525168 sectors, 931.5 GiB
>>> Logical sector size: 512 bytes
>>> Disk identifier (GUID): 145F71F0-4D0B-4941-9F9E-2C5301BF518F
>>> Partition table holds up to 128 entries
>>> First usable sector is 34, last usable sector is 1953525134
>>> Partitions will be aligned on 2048-sector boundaries
>>> Total free space is 1953525101 sectors (931.5 GiB)
>> This is worrisome.  Please repost the complete output of fdisk -l
>> and gdisk -l for all of these devices.  But....
>>
>>> The first two drives look like this (lots of read errors), the second
>>> two look perfectly clean...
>> Please remove the drives from the NAS box and connect to a known good
>> system.  Your smartctl reports include neither re-allocated sectors
>> nor pending relocations, which would be expected if there are many
>> read errors.  That means the read errors are likely due to controller,
>> cables, or power supply problems.
> The drives have already been removed from the original NAS device, 
> they are now connected to a PC running from a ubuntu live CD...
>> Note, timeout mismatch *does not* apply to sda, but you trimmed
>> too much to tell for the other devices.  Please submit complete output
>> from smartctl -iA -l scterc /dev/sdX for each of these devices.
> All devices are the same, but I'll include it here:
> smartctl -iA -l scterc /dev/sda
> smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.8.0-22-generic] (local 
> build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, 
> www.smartmontools.org
>
> === START OF INFORMATION SECTION ===
> Device Model:     ST1000NM0033         81Y9807 81Y3867IBM
> Serial Number:    Z1W2ZG3M
> LU WWN Device Id: 5 000c50 079c48262
> Firmware Version: BB5A
> User Capacity:    1,000,204,886,016 bytes [1.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    7200 rpm
> Form Factor:      3.5 inches
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   ACS-2 (minor revision not indicated)
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> Local Time is:    Tue Mar  7 09:11:11 2017 UTC
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>
> === START OF READ SMART DATA SECTION ===
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED  
> WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   081   063   044 Pre-fail 
> Always       -       122481432
>   3 Spin_Up_Time            0x0003   097   096   000 Pre-fail 
> Always       -       0
>   4 Start_Stop_Count        0x0032   100   100   020 Old_age 
> Always       -       80
>   5 Reallocated_Sector_Ct   0x0033   100   100   010 Pre-fail 
> Always       -       0
>   7 Seek_Error_Rate         0x000f   082   060   030 Pre-fail 
> Always       -       182098084
>   9 Power_On_Hours          0x0032   087   087   000 Old_age 
> Always       -       11892
>  10 Spin_Retry_Count        0x0013   100   100   097 Pre-fail 
> Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   020 Old_age 
> Always       -       65
> 184 End-to-End_Error        0x0032   100   100   099 Old_age 
> Always       -       0
> 187 Reported_Uncorrect      0x0032   100   100   000 Old_age 
> Always       -       0
> 188 Command_Timeout         0x0032   100   100   000 Old_age 
> Always       -       0
> 189 High_Fly_Writes         0x003a   100   100   000 Old_age 
> Always       -       0
> 190 Airflow_Temperature_Cel 0x0022   063   051   045 Old_age 
> Always       -       37 (Min/Max 36/40)
> 191 G-Sense_Error_Rate      0x0032   100   100   000 Old_age 
> Always       -       0
> 192 Power-Off_Retract_Count 0x0032   100   100   000 Old_age 
> Always       -       60
> 193 Load_Cycle_Count        0x0032   100   100   000 Old_age 
> Always       -       559
> 194 Temperature_Celsius     0x0022   037   049   000 Old_age 
> Always       -       37 (0 21 0 0 0)
> 195 Hardware_ECC_Recovered  0x001a   021   007   000 Old_age 
> Always       -       122481432
> 197 Current_Pending_Sector  0x0012   100   100   000 Old_age 
> Always       -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000 Old_age 
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000 Old_age 
> Always       -       0
>
> SCT Error Recovery Control:
>            Read:     75 (7.5 seconds)
>           Write:     75 (7.5 seconds)
>
> smartctl -iA -l scterc /dev/sdb
> smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.8.0-22-generic] (local 
> build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, 
> www.smartmontools.org
>
> === START OF INFORMATION SECTION ===
> Device Model:     ST1000NM0033         81Y9807 81Y3867IBM
> Serial Number:    Z1W2ZKKD
> LU WWN Device Id: 5 000c50 079c557df
> Firmware Version: BB5A
> User Capacity:    1,000,204,886,016 bytes [1.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    7200 rpm
> Form Factor:      3.5 inches
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   ACS-2 (minor revision not indicated)
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
> Local Time is:    Tue Mar  7 09:11:11 2017 UTC
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>
> === START OF READ SMART DATA SECTION ===
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED  
> WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   083   063   044    Pre-fail 
> Always       -       225986939
>   3 Spin_Up_Time            0x0003   097   096   000    Pre-fail 
> Always       -       0
>   4 Start_Stop_Count        0x0032   100   100   020    Old_age 
> Always       -       80
>   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
> Always       -       0
>   7 Seek_Error_Rate         0x000f   082   060   030    Pre-fail 
> Always       -       192404045
>   9 Power_On_Hours          0x0032   087   087   000    Old_age 
> Always       -       11892
>  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail 
> Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   020    Old_age 
> Always       -       66
> 184 End-to-End_Error        0x0032   100   100   099    Old_age 
> Always       -       0
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age 
> Always       -       0
> 188 Command_Timeout         0x0032   100   100   000    Old_age 
> Always       -       0
> 189 High_Fly_Writes         0x003a   100   100   000    Old_age 
> Always       -       0
> 190 Airflow_Temperature_Cel 0x0022   059   047   045    Old_age 
> Always       -       41 (Min/Max 40/44)
> 191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age 
> Always       -       0
> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age 
> Always       -       58
> 193 Load_Cycle_Count        0x0032   100   100   000    Old_age 
> Always       -       556
> 194 Temperature_Celsius     0x0022   041   053   000    Old_age 
> Always       -       41 (0 21 0 0 0)
> 195 Hardware_ECC_Recovered  0x001a   023   013   000    Old_age 
> Always       -       225986939
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age 
> Always       -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age 
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age 
> Always       -       0
>
> SCT Error Recovery Control:
>            Read:     75 (7.5 seconds)
>           Write:     75 (7.5 seconds)
>
> smartctl -iA -l scterc /dev/sdc
> smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.8.0-22-generic] (local 
> build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, 
> www.smartmontools.org
>
> === START OF INFORMATION SECTION ===
> Device Model:     WD1003FBYX-23        81Y9807 81Y3867IBM
> Serial Number:    WD-WCAW37DULJLP
> LU WWN Device Id: 5 0014ee 261450c09
> Firmware Version: WB35
> User Capacity:    1,000,204,886,016 bytes [1.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    7200 rpm
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   ATA8-ACS (minor revision not indicated)
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Tue Mar  7 09:11:11 2017 UTC
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>
> === START OF READ SMART DATA SECTION ===
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED  
> WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail 
> Always       -       3
>   3 Spin_Up_Time            0x0027   186   173   021    Pre-fail 
> Always       -       3691
>   4 Start_Stop_Count        0x0032   100   100   000    Old_age 
> Always       -       90
>   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail 
> Always       -       0
>   7 Seek_Error_Rate         0x002e   100   253   000    Old_age 
> Always       -       0
>   9 Power_On_Hours          0x0032   084   084   000    Old_age 
> Always       -       11777
>  10 Spin_Retry_Count        0x0032   100   253   000    Old_age 
> Always       -       0
>  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age 
> Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age 
> Always       -       76
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age 
> Always       -       69
> 193 Load_Cycle_Count        0x0032   200   200   000    Old_age 
> Always       -       20
> 194 Temperature_Celsius     0x0022   103   092   000    Old_age 
> Always       -       44
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age 
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age 
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   200   200   000    Old_age 
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age 
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age 
> Offline      -       0
>
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)
>
> smartctl -iA -l scterc /dev/sdd
> smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.8.0-22-generic] (local 
> build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, 
> www.smartmontools.org
>
> === START OF INFORMATION SECTION ===
> Device Model:     WD1003FBYX-23        81Y9807 81Y3867IBM
> Serial Number:    WD-WCAW37DULEES
> LU WWN Device Id: 5 0014ee 26143dbd2
> Firmware Version: WB35
> User Capacity:    1,000,204,886,016 bytes [1.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    7200 rpm
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   ATA8-ACS (minor revision not indicated)
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Tue Mar  7 09:11:11 2017 UTC
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>
> === START OF READ SMART DATA SECTION ===
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED  
> WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail 
> Always       -       0
>   3 Spin_Up_Time            0x0027   184   173   021    Pre-fail 
> Always       -       3758
>   4 Start_Stop_Count        0x0032   100   100   000    Old_age 
> Always       -       90
>   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail 
> Always       -       0
>   7 Seek_Error_Rate         0x002e   100   253   000    Old_age 
> Always       -       0
>   9 Power_On_Hours          0x0032   084   084   000    Old_age 
> Always       -       11767
>  10 Spin_Retry_Count        0x0032   100   253   000    Old_age 
> Always       -       0
>  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age 
> Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age 
> Always       -       76
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age 
> Always       -       67
> 193 Load_Cycle_Count        0x0032   200   200   000    Old_age 
> Always       -       22
> 194 Temperature_Celsius     0x0022   106   095   000    Old_age 
> Always       -       41
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age 
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age 
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   200   200   000    Old_age 
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age 
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age 
> Offline      -       0
>
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)
>
>> Do the fdisk & gdisk reports from the known good system, and also,
>> if you can find any partitions, run --examine on each from the same
>> system.  Keep the --examine reports with the corresponding smartctl
>> report.
>>
> Looks like the partition tables are all gone... fdisk and gdisk both 
> report no partitions on any drive. gdisk shows them all with MBR (as 
> mdadm did, which is apparently due to the magic bytes aa55
>
> So it seems the real problem will be to work out where the various 
> partitions start and end...... Then re-create the partition table, and 
> hopefully the actual data will still be good.
> Any ideas on how to "find" the partitions?
>
> Thanks,
> Adam
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
