From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFH] Partition table recovery
Date: Mon, 23 Jul 2007 09:58:32 -0400
Message-ID: <20070723135832.GD19927@thunk.org>
References: <200707200813.03553.a1426z@gawab.com> <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org> <200707220710.31402.a1426z@gawab.com> <20070722162802.GA20174@thunk.org> <46A46399.5090406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46A46399.5090406@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rene Herman <rene.herman@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 23, 2007 at 10:15:21AM +0200, Rene Herman wrote:
> On an integrated system like this, do you consider it acceptable to only do 
> the MS-DOS partitions and not the other types that may be present _inside_ 
> those partitions? (MINIX subpartitions, BSD slices, ...). I believe those 
> should really also be done, but this would require keeping more information 
> again.

Well, I'm considering this to be a MBR backup scheme, so Minix and BSD
slices are legacy systems which are out of scope.  If they are busted
in the same way as MBR in terms of not having redundant backups of
critical data, when they have a lot fewer excuses that MBR, and they
can address that issue in their own way.  The number of Linux users
that also have Minix and BSD partitions are a vanishingly small number
in any case.

> I (very) briefly looked at blkid but unless I'm mistaken blkid needs device 
> names? The documentation seems to be missing. When scanning the device for 
> the partition table, we've built a list of partitions with offsets into the 
> device and it would be nice if we could hand the fd and the offset off to 
> something directly. If the program has to construct device names itself 
> there's another truckload of pitfalls right there.

Yeah, good point, I'd have to add that support into blkid.  It's been
on my todo list, but I just haven't gotten around to it yet.

> It might in fact make sense to just ask the kernel for the partitions on a 
> device and not bother with scanning anything ourselves. Ie, just walk 
> sysfs. Would you agree? This siginificantly reduces the risk of things 
> getting out of sync, both scanning order and implementation.

My concern of sysfs is that #1, it won't work on older kernels since
you would need to add new fields to backup what we want, and #2, I'm
still fundamentally distrustful of sysfs because there isn't a bright
line between what is an exported interface that will never change, and
something which is considered an "internal implementation detail" that
can change whenever some kernel hacker feels like it.  (Or when some
kernel hacker is careless...)  So as far as I'm concerned sysfs is a
terrible, TERRIBLE way to export a published interface where we
promise stability to userspace.

So I'd just as soon do this in userspace; after all, the entire
partition manager (and there are multiple ones; fdisk, sfdisk, gpart,
etc.) all in userspace, and that needs to be in synch with the kernel
partition reading code anyway.  So one more userspace implementation
is in my mind much cleaner than trying to push the needed
functionality into sysfs, and then hoping against hope that it doesn't
accidentally change in the future.

						- Ted
