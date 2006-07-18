From: David Chinner <dgc@sgi.com>
Subject: Re: XFS and write barrier
Date: Wed, 19 Jul 2006 03:04:06 +1000
Message-ID: <20060718170406.GT15160733@melbourne.sgi.com>
References: <200607151248.56603.Martin@lichtvoll.de> <20060716173238.GD3417@free.net.ph> <20060718173122.B1914501@wobbly.melbourne.sgi.com> <17596.41680.124148.595601@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17596.41680.124148.595601@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Nathan Scott <nathans@sgi.com>, xfs@oss.sgi.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 18, 2006 at 06:58:56PM +1000, Neil Brown wrote:
> On Tuesday July 18, nathans@sgi.com wrote:
> > On Mon, Jul 17, 2006 at 01:32:38AM +0800, Federico Sevilla III wrote:
> > > On Sat, Jul 15, 2006 at 12:48:56PM +0200, Martin Steigerwald wrote:
> > > > I am currently gathering information to write an article about journal
> > > > filesystems with emphasis on write barrier functionality, how it
> > > > works, why journalling filesystems need write barrier and the current
> > > > implementation of write barrier support for different filesystems.
> 
> "Journalling filesystems need write barrier" isn't really accurate.
> They can make good use of write barrier if it is supported, and where
> it isn't supported, they should use blkdev_issue_flush in combination
> with regular submit/wait.

blkdev_issue_flush() causes a write cache flush - just like a
barrier typically causes a write cache flush up to the I/O with the
barrier in it.  Both of these mechanisms provide the same thing - an
I/O barrier that enforces ordering of I/Os to disk.

Given that filesystems already indicate to the block layer when they
want a barrier, wouldn't it be better to get the block layer to issue
this cache flush if the underlying device doesn't support barriers
and it receives a barrier request?

FWIW, Only XFS and Reiser3 use this function, and only then when
issuing a fsync when barriers are disabled to make sure a common
test (fsync then power cycle) doesn't result in data loss...

> > Noone here seems to know, maybe Neil &| the other folks on linux-raid
> > can help us out with details on status of MD and write barriers?
> 
> In 2.6.17, md/raid1 will detect if the underlying devices support
> barriers and if they all do, it will accept barrier requests from the
> filesystem and pass those requests down to all devices.
> 
> Other raid levels will reject all barrier requests.

Any particular reason for not supporting barriers on the other types
of RAID?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
