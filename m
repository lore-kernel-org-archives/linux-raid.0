From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: RAID1 sync() slowness
Date: Tue, 10 Aug 2004 19:58:02 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0408101949300.10066-100000@coffee.psychology.mcmaster.ca>
References: <1092141982.4118c39ee37e5@www.tastycake.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1092141982.4118c39ee37e5@www.tastycake.net>
To: Nick Maynard <nick.maynard@alumni.doc.ic.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> md4 : active raid1 hdg6[1] hde6[0]
>       102494592 blocks [2/2] [UU]
> 
> md3 : active raid1 hdg5[1] hde5[0]
>       2104384 blocks [2/2] [UU]
> 
> md2 : active raid1 hdg3[1] hde3[0]
>       2104448 blocks [2/2] [UU]
> 
> md0 : active raid1 hdg1[1] hde1[0]
>       24000 blocks [2/2] [UU]
> 
> md1 : active raid1 hdg2[1] hde2[0]
>       10490368 blocks [2/2] [UU]

yucko!  running lots of separate raided partitions across the same 
two disks is a mis-design.  the problem is that unless you almost 
never do IO on some partitions, you'll wind up shuttling the heads
around an obscene amount of time.

> /dev/md2 is swap space, the other arrays are ext2/3 filesystems.

IMO, ext3 is particularly obscene for this kind of
many-mutually-interfering-partitions approach.

> We're finding calls to sync() take a much longer time than we would expect.

given that you've pessimized your system's throughput, what kind of 
performance would you expect?

> In particular, sometimes it can take over a second (in extreme cases, several)
> to run "sync".  As our mail server runs sync() often, we're getting some fairly

it's understandable that mail would want to sync messages.  but this 
should not be done with sync!  perhaps fdatasync, perhaps you should
even look at the journal_data option.  but obviously, you can't share
a disk with other filesystems.

note also that syslog can cause a surprising amount of synchronous 
activity.  it's easy to turn off.

> We originally thought it might be something to do with atime inode records, and
> tried remounting our filesystems with noatime, but to no avail.

watch out for directories with the +S attribute, as well.

> The hardware's all fairly recent - two 120GB drives on their own channels, DMA,
> 2.4Ghz P4, 1GB RAM - so we shouldn't be having trouble of this sort.

you might also tune bdflush to step a little livelier in flushing
dirty blocks.

> The system is currently running 2.4.26.

iirc, there have also been some sync performance improvements in 2.6.

