From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Why can't I re-add my drive after partition shrink?
Date: Wed, 19 Jul 2017 15:55:47 -0500
Message-ID: <ad3c5c59-dc37-2573-341a-39a381621746@gmail.com>
References: <2ea5ed99-05b5-25d2-c9d4-8ce1f4945eaa@gmail.com>
 <87tw2f2425.fsf@notabene.neil.brown.name>
 <0341a04d-9aa5-7665-d9ff-527fe9fc8238@gmail.com>
 <87pod0ypmh.fsf@notabene.neil.brown.name>
 <8d3e1264-2f0a-6ee9-52b5-edddc1e6f185@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8d3e1264-2f0a-6ee9-52b5-edddc1e6f185@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

<snip>
>>>     Since the problem, I did not want to leave my md in degraded state.
>>> So, I added my drive back and paid the penalty for rebuilding. I have
>>> other disks that need to be resized and *can get you want*. Please let
>>> me know if that is what you meant. If  you wanted the current info 
>>> after
>>> successfully rebuilding the array after a regular add, it is below.
>> I only requested the information because it might help fix, or explain,
>> your difficulty.  If you don't currently have a difficulty, then I don't
>> need to look at any details.
>>
>> Thanks,
>> NeilBrown
>
> Thanks for your time. Yes, I still have the problem as I need to 
> shrink other 5 disks in the array and I like to re-add rather than add 
> and rebuild each time.
>
> The host with the array is currently busy, and I will get this info 
> tomorrow  when I attempt the process on my next hard drive.
>
> Ramesh
>
Here is my attempt to repeat the steps in my last attempt to remove, 
repartition, re-add. Last time I did it on /dev/sdb. Now I am going to 
do it on /dev/sdc. Note that I have not been successful as you see at 
the end. I am going to keep the array degraded so that I can still get 
old info from /dev/sdc1, if you need anything else. I will keep it this 
way till tomorrow and then add the device for md to rebuild. Please ask 
anything else before that or send me a note to keep the array degraded 
so that you can examine /dev/sdc1 more.

<start>
<current-status>

> zym [rramesh] 251 > cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
> [raid4] [raid10]
> md0 : active raid6 sdb1[6] sdg1[11] sdd1[12] sdf1[8] sde1[9] sdc1[10]
>       12348030976 blocks super 1.2 level 6, 64k chunk, algorithm 2 
> [6/6] [UUUUUU]
>       bitmap: 0/23 pages [0KB], 65536KB chunk
>
> unused devices: <none>

<sdc partitions before any changes>
> zym [rramesh] 252 > sudo gdisk -l /dev/sdc
> GPT fdisk (gdisk) version 0.8.8
>
> Partition table scan:
>   MBR: protective
>   BSD: not present
>   APM: not present
>   GPT: present
>
> Found valid GPT with protective MBR; using GPT.
> Disk /dev/sdc: 11721045168 sectors, 5.5 TiB
> Logical sector size: 512 bytes
> Disk identifier (GUID): EF5E7965-FC30-4137-9DDC-1B2C7966B936
> Partition table holds up to 128 entries
> First usable sector is 34, last usable sector is 11721045134
> Partitions will be aligned on 2048-sector boundaries
> Total free space is 2014 sectors (1007.0 KiB)
>
> Number  Start (sector)    End (sector)  Size       Code  Name
>    1            2048     11721045134   5.5 TiB     FD00  Linux RAID

<sdc mdadm info before any changes>
> zym [rramesh] 253 > sudo mdadm --examine /dev/sdc1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 0e9f76b5:4a89171a:a930bccd:78749144
>            Name : zym:0  (local to host zym)
>   Creation Time : Mon Apr 22 00:08:12 2013
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
>      Array Size : 12348030976 (11776.00 GiB 12644.38 GB)
>   Used Dev Size : 6174015488 (2944.00 GiB 3161.10 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 7e035b56:d1e1882b:e78a08ad:3ba50667
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Wed Jul 19 15:12:46 2017
>        Checksum : a52ef205 - correct
>          Events : 297182
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>    Device Role : Active device 2
>    Array State : AAAAAA ('A' == active, '.' == missing)
> zym [rramesh] 256 > sudo mdadm --examine-bitmap /dev/sdc1
>         Filename : /dev/sdc1
>            Magic : 6d746962
>          Version : 4
>             UUID : 0e9f76b5:4a89171a:a930bccd:78749144
>           Events : 297182
>   Events Cleared : 297182
>            State : OK
>        Chunksize : 64 MB
>           Daemon : 5s flush period
>       Write Mode : Normal
>        Sync Size : 3087007744 (2944.00 GiB 3161.10 GB)
>           Bitmap : 47104 bits (chunks), 0 dirty (0.0%)

<removal and repartition begins>
> zym [rramesh] 254 > sudo  mdadm /dev/md0 --fail /dev/sdc1
> mdadm: set /dev/sdc1 faulty in /dev/md0
>
> zym [rramesh] 255 > sudo mdadm /dev/md0 --remove /dev/sdc1
> mdadm: hot removed /dev/sdc1 from /dev/md0
>
> zym [rramesh] 261 > gdisk /dev/sdc
>  <snip>
> Command (? for help): p
> <snip>
>
> Number  Start (sector)    End (sector)  Size       Code  Name
>    1            2048     11721045134   5.5 TiB     FD00  Linux RAID
>
> Command (? for help): d
> Using 1
>
> Command (? for help): n
> Partition number (1-128, default 1):
> First sector (34-11721045134, default = 2048) or {+-}size{KMGTP}:
> Last sector (2048-11721045134, default = 11721045134) or 
> {+-}size{KMGTP}: 6442452991
> Current type is 'Linux filesystem'
> Hex code or GUID (L to show codes, Enter = 8300): FD00
> Changed type of partition to 'Linux RAID'
>
> Command (? for help): n
> Partition number (2-128, default 2):
> First sector (34-11721045134, default = 6442452992) or {+-}size{KMGTP}:
> Last sector (6442452992-11721045134, default = 11721045134) or 
> {+-}size{KMGTP}:
> Current type is 'Linux filesystem'
> Hex code or GUID (L to show codes, Enter = 8300): FD00
> Changed type of partition to 'Linux RAID'
>
> Command (? for help): p
> Disk /dev/sdc: 11721045168 sectors, 5.5 TiB
> Logical sector size: 512 bytes
> Disk identifier (GUID): EF5E7965-FC30-4137-9DDC-1B2C7966B936
> Partition table holds up to 128 entries
> First usable sector is 34, last usable sector is 11721045134
> Partitions will be aligned on 2048-sector boundaries
> Total free space is 2014 sectors (1007.0 KiB)
>
> Number  Start (sector)    End (sector)  Size       Code  Name
>    1            2048      6442452991   3.0 TiB     FD00  Linux RAID
>    2      6442452992     11721045134   2.5 TiB     FD00  Linux RAID
>
> Command (? for help): w
>
> Final checks complete. About to write GPT data. THIS WILL OVERWRITE 
> EXISTING
> PARTITIONS!!
>
> Do you want to proceed? (Y/N): Y
> OK; writing new GUID partition table (GPT) to /dev/sdc.
> The operation has completed successfully.
>

<good device that is still in md0>
> zym [rramesh] 264 > cat /proc/partitions |fgrep sdb
>    8       16 5860522584 sdb
>    8       17 3221225472 sdb1
>    8       18 2639296071 sdb2

<device just removed and repartitioned>
> zym [rramesh] 271 > cat /proc/partitions |fgrep sdc
>    8       32 5860522584 sdc
>    8       33 3221225472 sdc1
>    8       34 2639296071 sdc2

<good device still in md0>
> zym [rramesh] 265 > sudo  mdadm --examine /dev/sdb1
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 0e9f76b5:4a89171a:a930bccd:78749144
>            Name : zym:0  (local to host zym)
>   Creation Time : Mon Apr 22 00:08:12 2013
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 6442188800 (3071.88 GiB 3298.40 GB)
>      Array Size : 12348030976 (11776.00 GiB 12644.38 GB)
>   Used Dev Size : 6174015488 (2944.00 GiB 3161.10 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 702ca77d:564d69ff:e45d9679:64c314fa
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Wed Jul 19 15:15:00 2017
>        Checksum : c5578b94 - correct
>          Events : 297185
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>    Device Role : Active device 4
>    Array State : AA.AAA ('A' == active, '.' == missing)

<good device still in md0>
> zym [rramesh] 266 > sudo mdadm --examine-bitmap  /dev/sdb1
>         Filename : /dev/sdb1
>            Magic : 6d746962
>          Version : 4
>             UUID : 0e9f76b5:4a89171a:a930bccd:78749144
>           Events : 297185
>   Events Cleared : 297182
>            State : OK
>        Chunksize : 64 MB
>           Daemon : 5s flush period
>       Write Mode : Normal
>        Sync Size : 3087007744 (2944.00 GiB 3161.10 GB)
>           Bitmap : 47104 bits (chunks), 0 dirty (0.0%)

<device just removed and repartitioned>
> zym [rramesh] 267 > sudo mdadm --examine /dev/sdc1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 0e9f76b5:4a89171a:a930bccd:78749144
>            Name : zym:0  (local to host zym)
>   Creation Time : Mon Apr 22 00:08:12 2013
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)
>      Array Size : 12348030976 (11776.00 GiB 12644.38 GB)
>   Used Dev Size : 6174015488 (2944.00 GiB 3161.10 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 7e035b56:d1e1882b:e78a08ad:3ba50667
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Wed Jul 19 15:12:46 2017
>        Checksum : a52ef205 - correct
>          Events : 297182
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>    Device Role : Active device 2
>    Array State : AAAAAA ('A' == active, '.' == missing)

<device just removed and repartitioned>
> zym [rramesh] 268 > sudo mdadm --examine-bitmap /dev/sdc1
>         Filename : /dev/sdc1
>            Magic : 6d746962
>          Version : 4
>             UUID : 0e9f76b5:4a89171a:a930bccd:78749144
>           Events : 297182
>   Events Cleared : 297182
>            State : OK
>        Chunksize : 64 MB
>           Daemon : 5s flush period
>       Write Mode : Normal
>        Sync Size : 3087007744 (2944.00 GiB 3161.10 GB)
>           Bitmap : 47104 bits (chunks), 0 dirty (0.0%)
> zym [rramesh] 269 > cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
> [raid4] [raid10]
> md0 : active raid6 sdb1[6] sdg1[11] sdd1[12] sdf1[8] sde1[9]
>       12348030976 blocks super 1.2 level 6, 64k chunk, algorithm 2 
> [6/5] [UU_UUU]
>       bitmap: 0/23 pages [0KB], 65536KB chunk
>
> unused devices: <none>


<Cannot re-add!!!!>
> zym [rramesh] 270 > sudo mdadm /dev/md0 --re-add /dev/sdc1
> mdadm: --re-add for /dev/sdc1 to /dev/md0 is not possible

I have not added this device yet and I am keeping the array degraded, 
just in case you need anything else. I will do so till tomorrow. After 
that I will simply add the device so that it will rebuild unless you ask 
for delay or additional info.

Ramesh
