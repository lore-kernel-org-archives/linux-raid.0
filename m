From: Caspar Smit <c.smit@truebit.nl>
Subject: Re: Proper way to delete an old RAID1?
Date: Tue, 18 Jun 2013 20:42:14 +0200
Message-ID: <CAKFseUOGX=9MQLfs3JMdku7D8AOsnFHosKc0DHL3b2crWtqxRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mark,

Stopping an MD device will not remove/delete anything.
The --remove command cannot be used AFTER an MD device is stopped.
(--remove is only for removing drives/partitions from a running MD
device NOT to remove the MD itself e.g. mdadm --remove /dev/mdX
/dev/sdb, furthermore a drive/partition can only be removed after you
fail the drive first or it has failed by itself offcouse, see the
--fail switch)

To completely erase the MD you need to stop it and then remove the
superblocks from the member drives:

mdadm --stop /dev/md127
mdadm --zero-superblock /dev/sdb5
mdadm --zero-superblock /dev/sdc5
mdadm --zero-superblock /dev/sdd5

You can combine the last 3 commands to:

mdadm --zero-superblock /dev/sd[b-d]5

but to be 100% safe use them seperately.

This will erase the superblocks on the members of /dev/md127 and you
will not be able to assemble it again and it will not be started
during a reboot (remove it from the mdadm.conf too offcourse, but
since the array comes up as /dev/md127 I presume it is already not
present in mdadm.conf)

Kind regards,
Caspar

2013/6/18 Mark Knecht <markknecht@gmail.com>:
> I'm in the process of trying to clean up my home server. When I first
> built the machine the main RAID was a partition-based 0.90 RAID1 which
> is no longer used. I would like to get rid of this RAID (/dev/md127)
> completely. What's the right way to do this?
>
> mark@c2RAID6 ~ $ cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md6 : active raid5 sdd6[2] sdb6[0] sdc6[1]
>       494833664 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>       bitmap: 0/2 pages [0KB], 65536KB chunk
>
> md7 : active raid6 sdd7[2] sdc7[1] sdb7[0] sdf2[4] sde2[3]
>       395387904 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]
>
> md127 : active (auto-read-only) raid1 sdc5[1] sdd5[2] sdb5[0]
>       52436032 blocks [3/3] [UUU]
>
> md3 : active raid6 sdb3[0] sdf3[5] sde3[3] sdd3[2] sdc3[1]
>       157305168 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]
>
> unused devices: <none>
> mark@c2RAID6 ~ $
>
> To I need to do anything more than:
>
> mdadm --stop /dev/md127
> mdadm --remove /dev/md127
>
> to remove the raid1? Should I do something to zero out the partitions?
> I expect to delete the partitions when this is complete and then grown
> one of the other RAIDs to fill the area available.
>
> My eventual goal is to also get rid of the raid5 /dev/md6 and then
> possibly combine md3 & md7 into a single raid6 partition. I just don't
> want to take the whole machine down to do it where doing reshaping,
> even if slow, works fine for me.
>
> Thanks,
> Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
