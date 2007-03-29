From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: is this raid5 OK ?
Date: Thu, 29 Mar 2007 18:35:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0703291834230.29287@p34.internal.lan>
References: <237230840.20070329193857@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <237230840.20070329193857@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 29 Mar 2007, Rainer Fuegenstein wrote:

> hi,
>
> I manually created my first raid5 on 4 400 GB pata harddisks:
>
> [root@server ~]# mdadm --create --verbose /dev/md0 --level=5 --raid-devices=4 --spare-devices=0 /dev/hde1 /dev/hdf1 /dev/hdg1 /dev/hdh1
> mdadm: layout defaults to left-symmetric
> mdadm: chunk size defaults to 64K
> mdadm: size set to 390708736K
> mdadm: array /dev/md0 started.
>
> but, mdstat shows:
>
> [root@server ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 hdh1[4] hdg1[2] hdf1[1] hde1[0]
>      1172126208 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>
> unused devices: <none>
>
> I'm surprised to see that there's one "failed" device [UUU_] ?
> shouldn't it read [UUUU] ?
>
> root@alfred ~]# mdadm --detail --scan mdadm --misc --detail /dev/md0
> mdadm: cannot open mdadm: No such file or directory
> /dev/md0:
>        Version : 00.90.03
>  Creation Time : Thu Mar 29 19:21:29 2007
>     Raid Level : raid5
>     Array Size : 1172126208 (1117.83 GiB 1200.26 GB)
>    Device Size : 390708736 (372.61 GiB 400.09 GB)
>   Raid Devices : 4
>  Total Devices : 4
> Preferred Minor : 0
>    Persistence : Superblock is persistent
>
>    Update Time : Thu Mar 29 19:37:07 2007
>          State : clean
> Active Devices : 4
> Working Devices : 4
> Failed Devices : 0
>  Spare Devices : 0
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
>           UUID : 08c98d1b:d0b5614d:d6893163:61d4bf1b
>         Events : 0.596
>
>    Number   Major   Minor   RaidDevice State
>       0      33        1        0      active sync   /dev/hde1
>       1      33       65        1      active sync   /dev/hdf1
>       2      34        1        2      active sync   /dev/hdg1
>       2       0        0        0      removed
>
>       4      34       65        4      active sync   /dev/hdh1
>
>
> ... and why is there a "removed" entry ?
>
> sorry if these questions are stupid, but this is my first raid5 and
> I'm a bit worried.
>
> cu
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Strange, it should read [UUUU].. Correct, I would mdadm --zero-superblock 
on all those drives and re-create the array (mdadm -S (stop it first)) of 
course before you do it.

Justin.
