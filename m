From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Sanity check installation scheme
Date: Thu, 15 Apr 2004 11:41:00 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0404151129540.5201-100000@coffee.psychology.mcmaster.ca>
References: <34091.194.60.85.4.1082027571.squirrel@194.60.85.4>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <34091.194.60.85.4.1082027571.squirrel@194.60.85.4>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I do the same thing. I thought that I could create separate partions on
> top of the RAID-5 array, like I would with hardware RAID (I have some

raiding multiple partitions on the same disks is very dubious.
consider journal flushes - you wind up shuttling the heads between
each of the journals on each of the filesystems on each of the disks.

and for what gain?  yes, I know the traditional saw about /var fillign
up the root partition.  when's the last time that happened to you,
and on what kind of machine?  is it really a primary concern?  how long
was that machine neglected before someone noticed the enormous logs?
why didn't you have logwatch installed?  should the daemon that produced
100 GB of logs really be quite so verbose, should it be exposed to the 
harsh internet, or even running at all?

I find that the lots-of-little-partitions approach causes *more* admin
effort because tiny partitions are by definition more prone to filling
up at inconvenient times (say, installing a new compiler version).
bigger partitions aren't.

parallel raids across partitions is bad for performance and dubious in design.

in this case, I'd have precisely two partitions on all disks, with the first
dedicated to a raid1 (with swapfiles on it), and the second to a raid5.

or else a 10G partition for boot on at least two disks (not raided, but it's
too small to care about), and everything else raid5.  after all, you don't 
need a large /boot.

regards, mark hahn.

