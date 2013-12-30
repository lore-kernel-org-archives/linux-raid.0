From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is partition alignment needed for RAID partitions ?
Date: Mon, 30 Dec 2013 11:10:08 -0600
Message-ID: <52C1A8F0.2030208@hardwarefreak.com>
References: <52C08E63.8020800@insync.za.net> <52C11929.3070600@hardwarefreak.com> <52C12F8B.6080507@insync.za.net> <52C14FB8.8080005@hardwarefreak.com> <52C162A7.1080309@insync.za.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C162A7.1080309@insync.za.net>
Sender: linux-raid-owner@vger.kernel.org
To: Pieter De Wit <pieter@insync.za.net>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/30/2013 6:10 AM, Pieter De Wit wrote:
> Hi Stan,
>> Size is incorrect in what way?  If your RAID0 chunk is 512KiB, then
>> 3407028224 sectors is 3327176 chunks, evenly divisible, so this
>> partition is fully aligned.  Whether the capacity is correct is
>> something only you can determine.  Partition 2 is 1.587 TiB.

> Would you mind showing me the calc you did to get there,
> 3407028224/3327176=1024, 

(3407028224 sectors * 512 bytes per sector) / 524288 (chunk bytes) =

3327176 chunks

> I don't understand how the 512kiB came into play ?

> # mdadm --detail /dev/md1
...
>      Chunk Size : 512K

One kilobyte (K,KB) is 2^10, or 1024 bytes.  512*1024 = 524288 bytes

>> I'm not intending to be jerk, but this is a technical mailing list.
> Understood - here is the complete layout:
> 
> /dev/sda - 250 gig disk
> /dev/sdb - 2TB disk
> /dev/sdc - 2TB disk
> /dev/sdd - 256gig iSCSI target on QNAP NAS (block allocated, not thin
> prov'ed)
> /dev/sde - 2TB iSCSI target on QNAP NAS (block allocated, not thin prov'ed)
>> Show your partition table for sdc.  Even if the partitions on it are not
>> aligned, reads shouldn't be adversely affected by it.  Show
>>
>> $ mdadm --detail
> # parted /dev/sdb unit s print
> Model: ATA WDC WD20EARX-008 (scsi)
> Disk /dev/sdb: 3907029168s
> Sector size (logical/physical): 512B/4096B
> Partition Table: gpt
> 
> Number  Start       End          Size         File system  Name Flags
>  1      2048s       500000767s   499998720s raid
>  2      500000768s  3907028991s  3407028224s raid
> 
> # parted /dev/sdc unit s print
> Model: ATA WDC WD20EARX-008 (scsi)
> Disk /dev/sdc: 3907029168s
> Sector size (logical/physical): 512B/4096B
> Partition Table: gpt
> 
> Number  Start       End          Size         File system  Name Flags
>  1      2048s       500000767s   499998720s raid
>  2      500000768s  3907028991s  3407028224s raid

These partitions are all aligned and the same sizes.  No problems here.

> 
> # mdadm --detail /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Mon Dec 30 12:33:43 2013
>      Raid Level : raid1
>      Array Size : 249868096 (238.29 GiB 255.86 GB)
>   Used Dev Size : 249868096 (238.29 GiB 255.86 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Dec 31 01:01:42 2013
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
> 
>            Name : srv01:0  (local to host srv01)
>            UUID : 45d71ef8:9a1115cb:8ed0c4d9:95d56df4
>          Events : 25
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       17        0      active sync   /dev/sdb1
>        1       8       33        1      active sync   /dev/sdc1
> 
> # mdadm --detail /dev/md1
> /dev/md1:
>         Version : 1.2
>   Creation Time : Mon Dec 30 12:33:56 2013
>      Raid Level : raid0
>      Array Size : 3407027200 (3249.19 GiB 3488.80 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
> 
>     Update Time : Mon Dec 30 12:33:56 2013
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
> 
>      Chunk Size : 512K
> 
>            Name : srv01:1  (local to host srv01)
>            UUID : abfdcb5e:804fa119:9c4a8d88:fa2f08a7
>          Events : 0
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       18        0      active sync   /dev/sdb2
>        1       8       34        1      active sync   /dev/sdc2
> 
>>
>> for the RAID0 array.  md itself, especially in RAID0 personality, is
>> simply not going to be the -cause- of low performance.  The problem lay
>> somewhere else.  Given the track record of Western Digital's Green
>> series of drives I'm leaning toward that cause.  Post output from
>>
>> $ smartctl -A /dev/sdb
>> $ smartctl -A /dev/sdc
> # smartctl -A /dev/sdb
> smartctl 6.2 2013-04-20 r3812 [i686-linux-3.11.0-14-generic] (local build)
> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF READ SMART DATA SECTION ===
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED 
> WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> Always       -       0
>   3 Spin_Up_Time            0x0027   217   186   021    Pre-fail
> Always       -       4141
>   4 Start_Stop_Count        0x0032   100   100   000    Old_age
> Always       -       102
>   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
>   7 Seek_Error_Rate         0x002e   200   200   000    Old_age
> Always       -       0
>   9 Power_On_Hours          0x0032   089   089   000    Old_age
> Always       -       8263
>  10 Spin_Retry_Count        0x0032   100   100   000    Old_age
> Always       -       0
>  11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
> Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> Always       -       102
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> Always       -       88
> 193 Load_Cycle_Count        0x0032   155   155   000    Old_age
> Always       -       135985
> 194 Temperature_Celsius     0x0022   121   108   000    Old_age
> Always       -       29
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
> # smartctl -A /dev/sdc
> smartctl 6.2 2013-04-20 r3812 [i686-linux-3.11.0-14-generic] (local build)
> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF READ SMART DATA SECTION ===
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED 
> WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> Always       -       0
>   3 Spin_Up_Time            0x0027   217   186   021    Pre-fail
> Always       -       4141
>   4 Start_Stop_Count        0x0032   100   100   000    Old_age
> Always       -       100
>   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
>   7 Seek_Error_Rate         0x002e   200   200   000    Old_age
> Always       -       0
>   9 Power_On_Hours          0x0032   089   089   000    Old_age
> Always       -       8263
>  10 Spin_Retry_Count        0x0032   100   253   000    Old_age
> Always       -       0
>  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
> Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> Always       -       100
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> Always       -       86
> 193 Load_Cycle_Count        0x0032   156   156   000    Old_age
> Always       -       134976
> 194 Temperature_Celsius     0x0022   122   109   000    Old_age
> Always       -       28
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

smartctl data indicates there are no problems with the drives.

>>>>> I would have expected the RAID0 device to easily get
>>>>> up to the 60meg/sec mark ?
>>>> As the source disk of a bulk file copy over NFS/CIFS?  As a point of
>>>> reference, I have a workstation that maxes 50MB/s FTP and only 24MB/s
>>>> CIFS to/from a server.  Both hosts have far in excess of 100MB/s disk
>>>> throughput.  The 50MB/s limitation is due to the cheap Realtek mobo
>>>> NIC,
>>>> and the 24MB/s is a Samba limit.  I've spent dozens of hours attempting
>>>> to tweak Samba to greater throughput but it simply isn't capable on
>>>> that
>>>> machine.
>>>>
>>>> Your throughput issues are with your network, not your RAID.  Learn and
>>>> use FIO to see what your RAID/disks can do.  For now a really simple
>>>> test is to time cat of a large file and pipe to /dev/null.  Divide the
>>>> file size by the elapsed time.  Or simply do a large read with dd. 
>>>> This
>>>> will be much more informative than "moving data to a NAS", where your
>>>> throughput is network limited, not disk.
>>>>
>>> The system is using a server grade NIC, I will run a dd/network test
>>> shortly after the copy is done. (I am shifting all the data back to the
>>> NAS, incase I mucked up the partitions :) ), I do recall that this
>>> system was able to fill a gig pipe...
>> Now that you've made it clear the first scenario was over iSCSI same as
>> the 2nd scenario, and not NFS/CIFS, I doubt the TCP stack is the
>> problem.  Assume the network is fine for now and concentrate on the disk
>> drives in the host.  That's seems the most likely cause of the problem
>> at this point.
>>
>> BTW, you didn't state the throughput of the RAID1 device on sdb/sdc.
>> The RAID0 device is on the same disks, yes?  RAID0 was 15 MB/s.  What
>> was the RAID1?
>>
> ATM, the data is still moving back to the NAS (from the RAID1 device).
> According to iostat, this is reading at +30000 kB/s (all of my numbers
> are from iostat -x)

Please show the exact iostat command line you are using and the output.

> Also, there is no other disk usage in the system. All the data is
> currently on the NAS (except system "stuff" for a quite firewall)
> 
> I just spotted another thing, the two drives are on the same SATA
> controller, from rescan-scsi-bus:
> 
> Scanning for device 3 0 0 0 ...
> OLD: Host: scsi3 Channel: 00 Id: 00 Lun: 00
>       Vendor: ATA      Model: WDC WD20EARX-008 Rev: 51.0
>       Type:   Direct-Access                    ANSI SCSI revision: 05
> Scanning for device 3 0 1 0 ...
> OLD: Host: scsi3 Channel: 00 Id: 01 Lun: 00
>       Vendor: ATA      Model: WDC WD20EARX-008 Rev: 51.0
>       Type:   Direct-Access                    ANSI SCSI revision: 05
> 
> Would it be better to move these apart ? I remember IDE used to have
> this issue, but I also recall SATA "fixed" that.

This isn't the problem.  Even if both drives were connected via a plain
old 33MHz 132MB/s PCI SATA card you'd still be capable of 120MB/s
throughput, 60MB/s per drive.

> Thanks again,

You're welcome.  Eventually you get to the bottom of this.

-- 
Stan

