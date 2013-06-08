From: Phil Turmel <philip@turmel.org>
Subject: Re: Help with failed RAID-5 -> 6 migration
Date: Sat, 08 Jun 2013 18:43:51 -0400
Message-ID: <51B3B3A7.1090007@turmel.org>
References: <CAASLJ=5ewoeNPV1-fwRm3o6rCxQjCYxuJTZ5M9g7p-vFpgDW-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAASLJ=5ewoeNPV1-fwRm3o6rCxQjCYxuJTZ5M9g7p-vFpgDW-w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Phillips <spootsy.ootsy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/07/2013 11:02 PM, Keith Phillips wrote:
> Hi,
> 
> I have a problem. I'm worried I may have borked my array :/
> 
> I've been running a 3x2TB RAID-5 array and I recently got another 2TB
> drive, intending to bump it up to a 4x2TB RAID-6 array.
> 
> I stuck the new disk in and added it to the RAID array, as follows
> ("/files" is on a non-RAID disk):
> mdadm --manage /dev/md0 --add /dev/sda
> mdadm --grow /dev/md0 --raid-devices 4 --level 6
> --backup-file=/files/mdadm-backup
> 
> It seemed to work and the grow process started okay, reporting about 3
> days to completion (at ~8MB/s) which seemed really slow, but I left it
> anyway. Next morning, time to complete was several years and the
> kernel had spat out a bunch of I/O errors (lost those logs, sorry).
> 
> I figured the new disk must be at fault, because I'd done an array
> check recently and the others seemed okay. Hoping it might abort the
> grow, I failed the new disk:
> mdadm --manage /dev/md0 --fail /dev/sda
> 
> But mdadm kept reporting years to completion. So I rebooted.
> 
> Now I'd like to know - what state is my array in? If possible I'd like
> to get back to a working 3 disk RAID-5 configuration while I test the
> new disk and figure out what to do with it.
> 
> The backup-file doesn't exist, and the stats on the array are as follows:
> 
> --------------------------
> cat /proc/mdstat:
> --------------------------
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : inactive sdd[1] sde[3] sdc[0] sda[4]
>       7814054240 blocks super 1.2
> 
> unused devices: <none>
> --------------------------
> mdadm --detail /dev/md0
> --------------------------
> /dev/md0:
>         Version : 1.2
>   Creation Time : Sun Jul 17 00:41:57 2011
>      Raid Level : raid6
>   Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
> 
>     Update Time : Sat Jun  8 11:00:43 2013
>           State : active, degraded, Not Started
>  Active Devices : 3
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 1
> 
>          Layout : left-symmetric-6
>      Chunk Size : 512K
> 
>      New Layout : left-symmetric
> 
>            Name : muncher:0  (local to host muncher)
>            UUID : 830b9ec8:ca8dac63:e31946a0:4c76ccf0
>          Events : 50599
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       32        0      active sync   /dev/sdc
>        1       8       48        1      active sync   /dev/sdd
>        3       8       64        2      active sync   /dev/sde
>        4       8        0        3      spare rebuilding   /dev/sda
> 
> --------------------------
> 
> Any advice greatly appreciated.
> 
> Cheers,
> Keith
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

