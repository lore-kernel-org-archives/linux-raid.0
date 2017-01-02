From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Using mdadm --grow to resize a RAID1
Date: Mon, 2 Jan 2017 04:18:44 -0600
Message-ID: <4716208e-12a9-1ae8-46f4-a89ae15d9077@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hey all,

Quick question...

I've replaced and resync'd my root drives /dev/sda and /dev/sdb with 1TB drives up from the 250GB drives I started with.

/boot and swap are fine as is, but I'd like the root mount "/" to use the max available. (as anyone would)

My partition setup looks like:


> Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0x0007868a
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1            2048     8390655     4194304   fd  Linux raid autodetect
> /dev/sda2   *     8390656     9414655      512000   fd  Linux raid autodetect
> /dev/sda3         9414656  1953525167   972055256   fd  Linux raid autodetect
>
> Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0x000d707c
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1            2048     8390655     4194304   fd  Linux raid autodetect
> /dev/sdb2   *     8390656     9414655      512000   fd  Linux raid autodetect
> /dev/sdb3         9414656  1953525167   972055256   fd  Linux raid autodetect
>
>

Currently, the array I want to resize has:

> [root@quantum ~]# mdadm --detail /dev/md1
> /dev/md1:
>         Version : 1.1
>   Creation Time : Sat Jul 30 15:21:45 2011
>      Raid Level : raid1
>      Array Size : 239490048 (228.40 GiB 245.24 GB)
>   Used Dev Size : 239490048 (228.40 GiB 245.24 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Jan  2 04:17:51 2017
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>            Name : localhost.localdomain:1
>            UUID : 8d487d89:63690945:85c66cf4:e9885093
>          Events : 161820
>
>     Number   Major   Minor   RaidDevice State
>        2       8       19        0      active sync   /dev/sdb3
>        4       8        3        1      active sync   /dev/sda3

When I reference https://raid.wiki.kernel.org/index.php/Growing

>  mdadm --grow /dev/mdX --bitmap none
>  mdadm --grow /dev/mdX --size max
>  mdadm --wait /dev/mdX
>  mdadm --grow /dev/mdX --bitmap internal


I get stuck at the --size max.

it seems the correct syntax is "--size=" but that "max" is not supported as an argument.

little help?


Thanks,

 -Ben


