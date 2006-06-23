From: Tom Vier <tmv@comcast.net>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Fri, 23 Jun 2006 14:19:25 -0400
Message-ID: <20060623181925.GB3894@zero>
References: <449AEB7C.6040108@cjx.com> <fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com> <449BE381.6070000@cjx.com> <200606231701.44803.a1426z@gawab.com> <449C150E.3040107@thebarn.com>
Reply-To: Tom Vier <tmv@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <449C150E.3040107@thebarn.com>
Sender: linux-raid-owner@vger.kernel.org
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 23, 2006 at 11:21:34AM -0500, Russell Cattelan wrote:
> When you refer to data=ordered are you taking about ext3 user data 
> journaling?

iirc, data=ordered just writes new data out before updating block pointers,
the file's length in its inode, and the block usage bitmap. That way you
don't get junk or zeroed data at the tail of the file. However, i think to
prevent data leaks (from deleted files), data=writeback requires a write to
the journal, indicating what blocks are being added, so that on recovery
they can be zeroed if the transaction wasn't completed.

> While user data journaling seems like a good idea is unclear as what 
> benefits it really provides?

Data gets commited sooner (until pressure or timeouts force the data to be
written to its final spot - then you loose thruput and there's a net delay).
I think for bursts of small file creation, data=journaled is a win. I don't
know how lazy ext3 is about writing the data to its final position. It
probably does it when the commit timeout hits 0 or the journal is full.

> As far as barriers go I assume you are referring to the ide write barriers?
> 
> The need for barrier support in the file system is a result of cheap ide
> disks providing large write caches but not having enough reserve power to
> guarantee that the cache will be sync'ed to disk in the event of a power
> failure.

It's needed on any drive (including scsi) that has writeback cache enabled.
Most scsi drives (in my experience) come from the factory with the cache set
to write thru, in case the fs/os doesn't use ordered tags, cache flushes, or
force-unit-access writes.

> Note ext3,xfs,and reiser all use write barrier now fos r ide disks.

What i've found very disappointing is that my raid1 doesn't support them!

Jun 22 10:53:49 zero kernel: Filesystem "md1": Disabling barriers, not
supported by the underlying device

I'm not sure if it's the sata drive that don't support write barriers, or if
it's just the md1 layer. I need to investigate that. I think reiserfs also
complained that trying to enabled write barriers fails on that md1 (i've
been playing with various fs'es on it).

-- 
Tom Vier <tmv@comcast.net>
DSA Key ID 0x15741ECE
