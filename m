From: Jamie Thompson <jamierocks@gmail.com>
Subject: Corrupted FS after recovery. Coincidence?
Date: Wed, 27 Feb 2013 19:38:00 +0000
Message-ID: <512E6098.6040703@jamie-thompson.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all.

I just wanted to check with those more clued up that I'm not missing 
something important. To save you wading through the logs, in summary my 
filesystem got borked after I recovered an array when I realised I'd 
used the device and not the partition and corrected the mistake. I'd 
like to know if it's just bad luck and is likely to be a ram corruption 
of some sort, or if I did something wrong with my actions as I was under 
the impression the validation would fail the disk if there was a 
problem? I've done this before and it all went fine...

I have a remote server running Debian Testing...of relevance are the 3 
SATA drives on a LSI SAS controller and the RAID5 in use on them, though 
it also has two 2GB compactflash cards running in RAID1 with the root 
filesystem on them.

At the weekend I pulled one of the drives to use elsewhere. I replaced 
it with a new larger drive (old array drives are 500Gb, new one is 1.5TB 
- I'll be getting more in due course to enlarge the array), added a new 
partition over the whole disk, and added it to the array, which then 
began to rebuild:

Old disk:
> Disk /dev/sdc: 499.3 GB, 499279462400 bytes
> 255 heads, 63 sectors/track, 60700 cylinders, total 975155200 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x5932fff1
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1              63   975145499   487572718+  fd  Linux raid 
> autodetect

New disk:
> Disk /dev/sdd: 1500.3 GB, 1500301910016 bytes
> 81 heads, 63 sectors/track, 574226 cylinders, total 2930277168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0xbcba78d3
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdf1            2048  2930277167  1465137560   fd  Linux raid 
> autodetect

<pulls disk>
> Feb 25 18:41:33 mrlinux kernel: [281921.556280] RAID conf printout:
> Feb 25 18:41:33 mrlinux kernel: [281921.556288]  --- level:5 rd:3 wd:2
> Feb 25 18:41:33 mrlinux kernel: [281921.556294]  disk 0, o:1, dev:sde1
> Feb 25 18:41:33 mrlinux kernel: [281921.556299]  disk 1, o:1, dev:sdc1
> Feb 25 18:41:33 mrlinux kernel: [281921.556304]  disk 2, o:0, dev:sdd1
> Feb 25 18:41:33 mrlinux kernel: [281921.620023] RAID conf printout:
> Feb 25 18:41:33 mrlinux kernel: [281921.620029]  --- level:5 rd:3 wd:2
> Feb 25 18:41:33 mrlinux kernel: [281921.620033]  disk 0, o:1, dev:sde1
> Feb 25 18:41:33 mrlinux kernel: [281921.620036]  disk 1, o:1, dev:sdc1
<inserts new disk>
> Feb 25 18:56:22 mrlinux kernel: [282809.983189] mptsas: ioc0: 
> attaching sata device: fw_channel 0, fw_id 2, phy 0, sas_addr 0
> x455c3c41ddbfae97
> Feb 25 18:56:22 mrlinux kernel: [282809.994670] scsi 5:0:2:0: 
> Direct-Access     ATA      WDC WD15EARS-00M AB51 PQ: 0 ANSI: 5
> Feb 25 18:56:22 mrlinux kernel: [282809.996926] sd 5:0:2:0: [sdf] 
> 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
> Feb 25 18:56:22 mrlinux kernel: [282810.026435] sd 5:0:2:0: [sdf] 
> Write Protect is off
> Feb 25 18:56:22 mrlinux kernel: [282810.026442] sd 5:0:2:0: [sdf] Mode 
> Sense: 73 00 00 08
> Feb 25 18:56:22 mrlinux kernel: [282810.037183] sd 5:0:2:0: [sdf] 
> Write cache: enabled, read cache: enabled, doesn't support
> DPO or FUA
> Feb 25 18:56:22 mrlinux kernel: [282810.098805]  sdf: unknown 
> partition table
> Feb 25 18:56:22 mrlinux kernel: [282810.159468] sd 5:0:2:0: [sdf] 
> Attached SCSI disk
<partitions new disk>
> Feb 25 18:59:08 mrlinux kernel: [282976.397358]  sdf: sdf1
<adds to array>
> Feb 25 18:59:42 mrlinux kernel: [283010.226883] md: bind<sdf>
> Feb 25 18:59:42 mrlinux kernel: [283010.266108] RAID conf printout:
> Feb 25 18:59:42 mrlinux kernel: [283010.266116]  --- level:5 rd:3 wd:2
> Feb 25 18:59:42 mrlinux kernel: [283010.266122]  disk 0, o:1, dev:sde1
> Feb 25 18:59:42 mrlinux kernel: [283010.266127]  disk 1, o:1, dev:sdc1
> Feb 25 18:59:42 mrlinux kernel: [283010.266132]  disk 2, o:1, dev:sdf
> Feb 25 18:59:42 mrlinux kernel: [283010.266226] md: recovery of RAID 
> array md1
> Feb 25 18:59:42 mrlinux kernel: [283010.266235] md: minimum 
> _guaranteed_  speed: 1000 KB/sec/disk.
> Feb 25 18:59:42 mrlinux kernel: [283010.266240] md: using maximum 
> available idle IO bandwidth (but not more than 200000 KB/sec) for 
> recovery.
> Feb 25 18:59:42 mrlinux kernel: [283010.266255] md: using 128k window, 
> over a total of 487572608k.
<recovers 500GB in 03:56:38>
> Feb 25 22:56:20 mrlinux kernel: [297208.335405] md: md1: recovery done.
> Feb 25 22:56:20 mrlinux kernel: [297208.601814] RAID conf printout:
> Feb 25 22:56:20 mrlinux kernel: [297208.601822]  --- level:5 rd:3 wd:3
> Feb 25 22:56:20 mrlinux kernel: [297208.601828]  disk 0, o:1, dev:sde1
> Feb 25 22:56:20 mrlinux kernel: [297208.601833]  disk 1, o:1, dev:sdc1
> Feb 25 22:56:20 mrlinux kernel: [297208.601837]  disk 2, o:1, dev:sdf

The next day I noticed I'd made a mistake - I'd added /dev/sdf and not 
/dev/sdf1. I've had this before and it confused the system during boot 
as it saw two superblocks, so I failed the disk, removed it from the 
array, then recreated the partition table that had been obliterated. I 
then re-added the disk (or, more accurately, the partition) to the array:

> Feb 26 09:50:52 mrlinux kernel: [336480.481487] md: cannot remove 
> active disk sdf from md1 ...
<remembers you have to fail a disk before you can remove it...and does so>
> Feb 26 09:51:47 mrlinux kernel: [336535.564743] md/raid:md1: Disk 
> failure on sdf, disabling device.
> Feb 26 09:51:47 mrlinux kernel: [336535.564746] md/raid:md1: Operation 
> continuing on 2 devices.
> Feb 26 09:51:47 mrlinux kernel: [336535.597393] RAID conf printout:
> Feb 26 09:51:47 mrlinux kernel: [336535.597399]  --- level:5 rd:3 wd:2
> Feb 26 09:51:47 mrlinux kernel: [336535.597403]  disk 0, o:1, dev:sde1
> Feb 26 09:51:47 mrlinux kernel: [336535.597406]  disk 1, o:1, dev:sdc1
> Feb 26 09:51:47 mrlinux kernel: [336535.597409]  disk 2, o:0, dev:sdf
> Feb 26 09:51:48 mrlinux kernel: [336535.664011] RAID conf printout:
> Feb 26 09:51:48 mrlinux kernel: [336535.664017]  --- level:5 rd:3 wd:2
> Feb 26 09:51:48 mrlinux kernel: [336535.664020]  disk 0, o:1, dev:sde1
> Feb 26 09:51:48 mrlinux kernel: [336535.664023]  disk 1, o:1, dev:sdc1
<removes disk from array>
> Feb 26 09:52:11 mrlinux kernel: [336558.705730] md: unbind<sdf>
> Feb 26 09:52:11 mrlinux kernel: [336558.769675] md: export_rdev(sdf)
<repartitions disk>
> Feb 26 09:54:06 mrlinux kernel: [336674.474874]  sdf: sdf1
<re-adds disk to array>
> Feb 26 09:54:19 mrlinux kernel: [336687.596415] md: bind<sdf1>
> Feb 26 09:54:19 mrlinux kernel: [336687.636078] RAID conf printout:
> Feb 26 09:54:19 mrlinux kernel: [336687.636087]  --- level:5 rd:3 wd:2
> Feb 26 09:54:19 mrlinux kernel: [336687.636094]  disk 0, o:1, dev:sde1
> Feb 26 09:54:19 mrlinux kernel: [336687.636099]  disk 1, o:1, dev:sdc1
> Feb 26 09:54:19 mrlinux kernel: [336687.636105]  disk 2, o:1, dev:sdf1
> Feb 26 09:54:19 mrlinux kernel: [336687.636308] md: recovery of RAID 
> array md1
> Feb 26 09:54:19 mrlinux kernel: [336687.636317] md: minimum 
> _guaranteed_  speed: 1000 KB/sec/disk.
> Feb 26 09:54:19 mrlinux kernel: [336687.636322] md: using maximum 
> available idle IO bandwidth (but not more than 200000 KB/sec) for 
> recovery.
> Feb 26 09:54:19 mrlinux kernel: [336687.636342] md: using 128k window, 
> over a total of 487572608k.
<recovers 500Gb in 00:00:09>
> Feb 26 09:54:28 mrlinux kernel: [336696.647039] md: md1: recovery done.
> Feb 26 09:54:29 mrlinux kernel: [336696.726098] RAID conf printout:
> Feb 26 09:54:29 mrlinux kernel: [336696.726106]  --- level:5 rd:3 wd:3
> Feb 26 09:54:29 mrlinux kernel: [336696.726112]  disk 0, o:1, dev:sde1
> Feb 26 09:54:29 mrlinux kernel: [336696.726117]  disk 1, o:1, dev:sdc1
> Feb 26 09:54:29 mrlinux kernel: [336696.726122]  disk 2, o:1, dev:sdf1

Here's the strange thing, it recovered very quickly, which I thought was 
nice, but I wonder if it created a problem, as about an hour later I 
started getting errors in my logs:
> Feb 26 10:34:05 mrlinux kernel: [339073.432724] attempt to access 
> beyond end of device
> Feb 26 10:34:05 mrlinux kernel: [339073.432732] dm-1: rw=0, 
> want=15613016656, limit=58589184
> Feb 26 10:34:05 mrlinux kernel: [339073.533896] attempt to access 
> beyond end of device
> Feb 26 10:34:05 mrlinux kernel: [339073.533905] dm-0: rw=0, 
> want=1681676296, limit=97648640
> Feb 26 10:34:05 mrlinux kernel: [339073.533916] attempt to access 
> beyond end of device
> Feb 26 10:34:05 mrlinux kernel: [339073.533920] dm-0: rw=0, 
> want=18656264368, limit=97648640
> Feb 26 10:34:05 mrlinux kernel: [339073.533945] attempt to access 
> beyond end of device
> Feb 26 10:34:05 mrlinux kernel: [339073.533950] dm-0: rw=0, 
> want=18289707016, limit=97648640
> Feb 26 10:34:05 mrlinux kernel: [339073.533955] attempt to access 
> beyond end of device
...and eventually:
> Feb 26 10:34:05 mrlinux kernel: [339073.534443] dm-0: rw=0, 
> want=16783872552, limit=97648640
> Feb 26 10:34:05 mrlinux kernel: [339073.534447] attempt to access 
> beyond end of device
> Feb 26 10:34:05 mrlinux kernel: [339073.534450] dm-0: rw=0, 
> want=17686087704, limit=97648640
> Feb 26 10:34:05 mrlinux kernel: [339073.534515] attempt to access 
> beyond end of device
> Feb 26 10:34:05 mrlinux kernel: [339073.534520] dm-0: rw=0, 
> want=16716398592, limit=97648640
> Feb 26 10:37:57 mrlinux kernel: [339305.646807] EXT3-fs error (device 
> dm-1): ext3_add_entry: bad entry in directory #1243562: rec_len % 4 != 
> 0 - offset=0, inode=873485355, rec_len=14129, name_len=108
> Feb 26 10:37:57 mrlinux kernel: [339305.647224] EXT3-fs error (device 
> dm-1): ext3_add_entry: bad entry in directory #1243562: rec_len % 4 != 
> 0 - offset=0, inode=873485355, rec_len=14129, name_len=108
> Feb 26 10:37:57 mrlinux kernel: [339305.647591] EXT3-fs error (device 
> dm-1): ext3_add_entry: bad entry in directory #1243562: rec_len % 4 != 
> 0 - offset=0, inode=873485355, rec_len=14129, name_len=108
> Feb 26 10:37:57 mrlinux kernel: [339305.647912] EXT3-fs error (device 
> dm-1): ext3_add_entry: bad entry in directory #1243562: rec_len % 4 != 
> 0 - offset=0, inode=873485355, rec_len=14129, name_len=108
> Feb 26 10:37:57 mrlinux kernel: [339305.657177] attempt to access 
> beyond end of device
> Feb 26 10:37:57 mrlinux kernel: [339305.657185] dm-0: rw=0, 
> want=2157354904, limit=97648640
> Feb 26 10:37:57 mrlinux kernel: [339305.657192] attempt to access 
> beyond end of device
> Feb 26 10:37:57 mrlinux kernel: [339305.657196] dm-0: rw=0, 
> want=2157358136, limit=97648640
> Feb 26 10:37:57 mrlinux kernel: [339305.657202] attempt to access 
> beyond end of device
...and finally, and hour after that when I noticed and tried to check 
the new disk:
> Feb 26 11:28:19 mrlinux kernel: [342327.335517] dm-0: rw=0, 
> want=12776039208, limit=97648640
> Feb 26 11:28:19 mrlinux kernel: [342327.335523] attempt to access 
> beyond end of device
> Feb 26 11:28:19 mrlinux kernel: [342327.335527] dm-0: rw=0, 
> want=6906147664, limit=97648640
> Feb 26 11:28:19 mrlinux kernel: [342327.368414] apache2[12760]: 
> segfault at 0 ip b7794e4f sp bffd1245 error 6 in apache2[b7752000+69000]
> Feb 26 11:30:43 mrlinux kernel: [342471.157911] smartctl[11466]: 
> segfault at 4 ip b77b6a72 sp bfecf650 error 4 in 
> ld-2.13.so[b77ac000+1c000]
> Feb 26 11:32:24 mrlinux kernel: [342572.338509] attempt to access 
> beyond end of device
> Feb 26 11:32:24 mrlinux kernel: [342572.338518] dm-0: rw=0, 
> want=6906147664, limit=97648640
> Feb 26 11:32:24 mrlinux kernel: [342572.338554] apache2[24950]: 
> segfault at 0 ip b7794e4f sp bffd1245 error 6 in apache2[b7752000+69000]
> Feb 26 11:53:28 mrlinux kernel: [343835.861163] EXT3-fs error (device 
> dm-1): ext3_add_entry: bad entry in directory #1243562: rec_len % 4 != 
> 0 - offset=0, inode=873485355, rec_len=14129, name_len=108
> Feb 26 11:53:28 mrlinux kernel: [343835.901372] EXT3-fs error (device 
> dm-1): ext3_add_entry: bad entry in directory #1243562: rec_len % 4 != 
> 0 - offset=0, inode=873485355, rec_len=14129, name_len=108
> Feb 26 11:53:28 mrlinux kernel: [343835.930939] EXT3-fs error (device 
> dm-1): ext3_add_entry: bad entry in directory #1243562: rec_len % 4 != 
> 0 - offset=0, inode=873485355, rec_len=14129, name_len=108
> Feb 26 11:53:28 mrlinux kernel: [343835.963208] EXT3-fs error (device 
> dm-1): ext3_add_entry: bad entry in directory #1243562: rec_len % 4 != 
> 0 - offset=0, inode=873485355, rec_len=14129, name_len=108
> Feb 26 11:53:28 mrlinux kernel: [343835.965505] attempt to access 
> beyond end of device
> Feb 26 11:53:28 mrlinux kernel: [343835.965514] dm-0: rw=0, 
> want=14955012880, limit=97648640
> Feb 26 12:08:15 mrlinux kernel: [344722.924052] EXT3-fs error (device 
> dm-1): ext3_add_entry: bad entry in directory #408850: rec_len % 4 != 
> 0 - offset=0, inode=134901586, rec_len=17695, name_len=24
> Feb 26 12:08:17 mrlinux kernel: [344724.810787] EXT3-fs (dm-1): error 
> in ext3_new_inode: IO failure
> Feb 26 12:08:17 mrlinux kernel: [344724.885464] attempt to access 
> beyond end of device
,,,and some more for good measure:
> Feb 26 12:08:35 mrlinux kernel: [344743.007400] EXT3-fs error (device 
> dm-1): ext3_free_blocks: Freeing blocks not in datazone
>  - block = 858599726, count = 1
> Feb 26 12:08:35 mrlinux kernel: [344743.069558] EXT3-fs error (device 
> dm-1): ext3_free_blocks: Freeing blocks not in datazone
>  - block = 1650811950, count = 1

Having rebooted the segfaults are gone, and I can confirm that the new 
disk seems fine:
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED  
> WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail 
> Always       -       0
>   3 Spin_Up_Time            0x0027   100   253   021    Pre-fail 
> Always       -       0
>   4 Start_Stop_Count        0x0032   100   100   000    Old_age 
> Always       -       4
>   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail 
> Always       -       0
>   7 Seek_Error_Rate         0x002e   200   200   000    Old_age 
> Always       -       0
>   9 Power_On_Hours          0x0032   100   100   000    Old_age 
> Always       -       46
>  10 Spin_Retry_Count        0x0032   100   253   000    Old_age 
> Always       -       0
>  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age 
> Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age 
> Always       -       4
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age 
> Always       -       3
> 193 Load_Cycle_Count        0x0032   200   200   000    Old_age 
> Always       -       108
> 194 Temperature_Celsius     0x0022   131   113   000    Old_age 
> Always       -       19
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age 
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age 
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   100   253   000    Old_age 
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age 
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age 
> Offline      -       0
>
> SMART Error Log Version: 1
> No Errors Logged
However, all three of my data partitions on the RAID5 volume have errors 
beyond what the boot time fsck -a/-p will repair, so I'm looking into 
those. Seems fine though as I was able to mount them and copy everything 
to an external disk fine before recovery.

If you made it this far, thanks! Any pointers?
- Jamie
