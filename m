From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Growing a 5-drive RAID6 - some initial questions
Date: Thu, 20 Jun 2013 08:08:29 -0700
Message-ID: <CAK2H+efK6xt4N=dS4xjTgQSk_mAtvRZP1d2sEzsQXz5=vZANOQ@mail.gmail.com>
References: <CAK2H+edY8VKauwivLU5SJ6EU_ZOkTqxGvecYTNW2s5yC-xN4Og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+edY8VKauwivLU5SJ6EU_ZOkTqxGvecYTNW2s5yC-xN4Og@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jun 19, 2013 at 2:39 PM, Mark Knecht <markknecht@gmail.com> wrote:
> Hi,
>    On my home server my / partition is a 5-drive RAID6 which doesn't
> extend to the full extent of the drive. I've now removed everything to
> the end of the drive (saved to external USB drives for now) and am
> interested in growing the RAID6 to use all the disk space available.
> Before I start I've got a couple of questions. Note that I have no
> storage space issues. I only use about 200GB total on this machine so
> the new, larger RAID6 will be more than large enough. I do value
> having RAID6 and being able to lose two drives.
>
> 1) Is the fail/remove/partition/add method shown here a reasonable
> method for my task?
>
> https://raid.wiki.kernel.org/index.php/Growing
>
> 2) The RAID is a 5-drive RAID6 using a 16K chunk size. Would
> performance be helped significantly using some other chunk size?
>
>    I am not overly concerned about how long it takes to complete. It
> seems to me that failing 1 drive in a RAID6 built using 500GB RE3 WD
> drives is _reasonably_ safe. The drives came from 3 different orders
> at Amazon spanning about 8 months so I doubt they are from the same
> manufacturing run. I wouldn't expect each drive grow operation to take
> more than a few hours, but that's a total guess on my part having done
> no calculations.
>
>    Some additional RAID info follows at the end.
>
>    I could run smartctl testing before starting but it's never shown a
> problem before.
>
> Thanks in advance,
> Mark
>
> c2RAID6 ~ # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
>
> md3 : active raid6 sdb3[0] sdf3[5] sde3[3] sdd3[2] sdc3[1]
>       157305168 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]
>
> unused devices: <none>
> c2RAID6 ~ #
>
> c2RAID6 ~ # mdadm -D /dev/md3
> /dev/md3:
>         Version : 1.2
>   Creation Time : Thu Dec 30 17:40:50 2010
>      Raid Level : raid6
>      Array Size : 157305168 (150.02 GiB 161.08 GB)
>   Used Dev Size : 52435056 (50.01 GiB 53.69 GB)
>    Raid Devices : 5
>   Total Devices : 5
>     Persistence : Superblock is persistent
>
>     Update Time : Wed Jun 19 14:33:03 2013
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 16K
>
>            Name : c2stable:3
>            UUID : de47f991:86d98467:0637635b:9c6d0591
>          Events : 22706
>
>     Number   Major   Minor   RaidDevice State
>        0       8       19        0      active sync   /dev/sdb3
>        1       8       35        1      active sync   /dev/sdc3
>        2       8       51        2      active sync   /dev/sdd3
>        3       8       67        3      active sync   /dev/sde3
>        5       8       83        4      active sync   /dev/sdf3
> c2RAID6 ~ #

A couple of follow-up questions if anyone has info & time to answer.
My kernel is 3.8.13-gentoo. I'm using mdadm-3.1.4.

I'm currently doing the recovery step on the 5th of 5 drives so the
next step is the one that will grow the RAID:

mdadm --grow /dev/md0 --size=max

1) With regards to growing the array, a long time ago I remember
growing a RAID and getting burned by a bug that didn't like the ending
sector number. Something about the size of the RAID not being
divisible by chunk size or something like that. At that time I was not
using RAID6. Are there any known problems like that at this time for
RAID6?

2) Out of curiosity, is it the grow command that creates the ext4
filesystem on the new portion of the RAID or is there some step not
shown at the link able where I need to do some file system in this
process? Or possibly the mdadm --add step?

Thanks,
Mark
