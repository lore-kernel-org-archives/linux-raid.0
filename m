From: =?UTF-8?B?VG9yIEFybmUgVmVzdGLDuA==?= <torarnv@gmail.com>
Subject: Re: RAID5 in sync does not populate slots sequentially, shows array as (somewhat) faulty
Date: Tue, 4 Mar 2008 11:42:39 +0100
Message-ID: <47CD279F.2070500@gmail.com>
References: <47CBD62E.7040608@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47CD23A7.2000904@rabbit.us>
References: <47CC44C7.1040304@tmr.com>
References: <47CD23A7.2000904@rabbit.us>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> After Tor Arne reported his success I figured I will simply fail/remove 
> sda3, scrape it clean, and will add it back. I zeroed superblocks 
> beforehand and also wrote zeros (dd  if=/dev/zero) to the drives start 
> and end just to make sure everythign is off. After resync I am back at 
> square one - the offset of sda3 is different than everything else and 
> the array has one failed drive. If someone can shed some light I made 
> snapshots of the superblocks[1] alongside with the current output of 
> mdadm at http://rabbit.us/pool/md5_problem.tar.bz2.

Not sure if this is at all related to your problem, but one of the 
things I tried was to shred all the old drives in the system that were 
not going to be part of the array.

/dev/sda system (250GB) <-- shred
/dev/sdb home (250GB) <-- shred

/dev/sdc raid (750GB)
/dev/sdd raid (750GB)
/dev/sde raid (750GB)
/dev/sdf raid (750GB)

The reason I did this was because /dev/sda and /dev/sdb used to be part 
of a RAID1 array, but were now used as system disk and home disk 
respectively. I was afraid that mdadm would pick up on some of the 
lingering RAID superblocks on those disks when reporting, so I shredded 
them both using 'shred -n 1' and reinstalled.

Don't know if that affected anything at all for me, since the actual 
problem was that I didn't wait for a full resync, but now you know :)

Tor Arne









> 
> [1] dd if=/dev/sdX3 of=sdX_sb count=<Data Offset> bs=512
> 
> Here is my system config:
> 
> root@Thesaurus:/arx/space/pool# fdisk -l /dev/sd[abcd]
> 
> Disk /dev/sda: 400.0 GB, 400088457216 bytes
> 255 heads, 63 sectors/track, 48641 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x00000000
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1           7       56196   fd  Linux raid 
> autodetect
> /dev/sda2               8         507     4016250   fd  Linux raid 
> autodetect
> /dev/sda3             508       36407   288366750   83  Linux
> /dev/sda4           36408       48641    98269605   83  Linux
> 
> Disk /dev/sdb: 320.0 GB, 320072933376 bytes
> 255 heads, 63 sectors/track, 38913 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x00000000
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1           7       56196   fd  Linux raid 
> autodetect
> /dev/sdb2               8         507     4016250   fd  Linux raid 
> autodetect
> /dev/sdb3             508       36407   288366750   83  Linux
> /dev/sdb4           36408       38913    20129445   83  Linux
> 
> Disk /dev/sdc: 300.0 GB, 300090728448 bytes
> 255 heads, 63 sectors/track, 36483 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x00000000
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1               1           7       56196   fd  Linux raid 
> autodetect
> /dev/sdc2               8         507     4016250   fd  Linux raid 
> autodetect
> /dev/sdc3             508       36407   288366750   83  Linux
> /dev/sdc4           36408       36483      610470   83  Linux
> 
> Disk /dev/sdd: 300.0 GB, 300090728448 bytes
> 255 heads, 63 sectors/track, 36483 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x00000000
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdd1               1           7       56196   fd  Linux raid 
> autodetect
> /dev/sdd2               8         507     4016250   fd  Linux raid 
> autodetect
> /dev/sdd3             508       36407   288366750   83  Linux
> /dev/sdd4           36408       36483      610470   83  Linux
> root@Thesaurus:/arx/space/pool#
> 
> root@Thesaurus:~# cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md5 : active raid5 sda3[4] sdd3[3] sdc3[2] sdb3[1]
>       865081344 blocks super 1.1 level 5, 2048k chunk, algorithm 2 [4/4] 
> [UUUU]
> 
> md1 : active raid1 sdd1[3] sdc1[2] sdb1[1] sda1[0]
>       56128 blocks [4/4] [UUUU]
> 
> md10 : active raid10 sdd2[3] sdc2[2] sdb2[1] sda2[0]
>       5353472 blocks 1024K chunks 3 far-copies [4/4] [UUUU]
> 
> unused devices: <none>
> root@Thesaurus:~#
> 
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

