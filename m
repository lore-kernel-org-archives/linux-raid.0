From: Jeff Breidenbach <jeff@jab.org>
Subject: Re: split RAID1 during backups?
Date: Mon, 24 Oct 2005 13:28:51 -0700
Message-ID: <E1EU8w7-0003Bp-00@toko.jab.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks for all the suggestions.

> a big hint you're suffering from atime updates is write traffic when your
> fs is mounted rw, and your static webserver is the only thing running (and
> your logs go elsewhere)... atime updates are probably the only writes
> then.  try "iostat -x 5".

I think atime updates are an unlikely, since the partition is mounted
with atime turned off. I will look into the directory listing issue.

# mount | grep md0
/dev/md0 on /data1 type reiserfs (rw,noatime,nodiratime)

# vmstat
procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 1  0      0  57468 962964 2301336    0    0   345   500    3     2 40  6 31 23


>  The real problem is that you should be able to search the disk faster
>than that, identify the modified files, and do incrementals regularly. I
>have 400GB of 2-5MB files, and it takes minutes, not hours, to scan them.
>That's PATA not SATA, I suspect there may still be issues there, SATA is
>not as well explored, certainly not by me!

I'm not sure this is a relevant comparison. The files in question are
three about 1000 times smaller, and there are about 1000 times more of them.

>Get one more drive of the same size, and at backup time add it to
>the mirror. After rebuild take it back out of the mirror. Put a
>remount r/o in there at your discresion. Now you have a valid copy of
>your data, back that up as you like.

Interesting. What is the advantage over the current practice? Is it
faster, or does is use less disk I/O? Reminder: the current practice
(which I think is too slow) is to copy md0 with dd_rescue while the
partition is also feeding a webserver.

> the md event counts would be out of sync and unless you're using bitmapped
> intent logging this would cause a full resync.  if the raid wasn't online
> you could probably use one of the mdadm options to force the two devices
> to be a sync'd raid1 ... but i'm guessing you wouldn't be able to do it
> online.

I will look into intent logging. This is the first I've heard of it, thanks.

> other 2.6.x bleeding edge options are to mark one drive as write-mostly
> so that you have no read traffic competition while doing a backup... or
> just use the bitmap intent logging and a nbd to add a third, networked,
> copy of the drive on another machine.

This is also the first I've heard of ndb. Thanks, I'll look into that
too.

>One last thought, the slowness of the disk may result from the extended
>times to do directory operations which you mention. You don't have all
>those thousands of files in a single directory, do you? How long does it
>take to do an unsuccessful "find" from the root? Like "find /base -name
>spvgZy3G" or other name it's not going to find.

Individual directories contain up to about 150,000 files. If I run ls
-U on all directories, it completes in a reasonably amount of time (I
forget how much, but I think it is well under an hour). Reiserfs is
supposed to be good at this sort of thing. If I were to stat each
file, then it's a different story.

Jeff
