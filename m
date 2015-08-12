From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 4/9] raid5: log reclaim support
Date: Wed, 12 Aug 2015 13:50:08 +1000
Message-ID: <20150812135008.7ee44eef@noble>
References: <cover.1438215986.git.shli@fb.com>
	<41a6d2e74494506fcd6ffd68a5884d38dc0bfa8e.1438215986.git.shli@fb.com>
	<20150805134330.3f4269e4@noble>
	<20150805213412.GA3167799@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150805213412.GA3167799@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, 5 Aug 2015 14:34:21 -0700 Shaohua Li <shli@fb.com> wrote:

> On Wed, Aug 05, 2015 at 01:43:30PM +1000, NeilBrown wrote:
> > On Wed, 29 Jul 2015 17:38:44 -0700 Shaohua Li <shli@fb.com> wrote:
> > 
> > > This is the reclaim support for raid5 log. A stripe write will have
> > > following steps:
> > > 
> > > 1. reconstruct the stripe, read data/calculate parity. ops_run_io
> > > prepares to write data/parity to raid disks
> > > 2. hijack ops_run_io. stripe data/parity is appending to log disk
> > > 3. flush log disk cache
> > > 4. ops_run_io run again and do normal operation. stripe data/parity is
> > > written in raid array disks. raid core can return io to upper layer.
> > > 5. flush cache of all raid array disks
> > > 6. update super block
> > > 7. log disk space used by the stripe can be reused
> > > 
> > > In practice, several stripes consist of an io_unit and we will batch
> > > several io_unit in different steps, but the whole process doesn't
> > > change.
> > > 
> > > It's possible io return just after data/parity hit log disk, but then
> > > read IO will need read from log disk. For simplicity, IO return happens
> > > at step 4, where read IO can directly read from raid disks.
> > > 
> > > Currently reclaim run every minute or out of space. Reclaim is just to
> > > free log disk spaces, it doesn't impact data consistency.
> > 
> > Having arbitrary times lines "every minute" is a warning sign.
> > "As soon as possible" and "Just it time" can both make sense easily.
> > "every minute" needs more justification.
> > 
> > I'll probably say more when I find the code.
> 
> The idea is if we reclaim periodically, recovery could scan less log
> space. It's insane recovery scans a 1T disk. As I said this is just to
> free disk spaces. It's not a signal we will lose data in minute
> interval. I can change the relaim to run every 1G reclaimable space for
> example.

There seem to be two issues here and I might be confusing them.

Firstly there is the question of when a stripe gets written back to the
array.  Once the data is safe in the log this doesn't have to happen in
any great hurry, but I suspect it should still happen sooner rather
than later.

Presumably as soon as data/parity of a stripe is safe in the log,
that stripe will be scheduled to be written to the array - is that
correct?

As these writes-to-the-array complete the counter in the io_unit will
decrease.  when it reaches zero the io_unit can be freed and the
recovery_offset in the superblock can, potentially be updated.

Secondly there is the question of how often the superblock is updated.
As you say; delaying the updates indefinitely could lead to a recovery
having to examine a very large part of the log - maybe more than
necessary (though if that might be a problem, the simple solution is to
use a smaller log).

I would probably feel most comfortable scheduling a superblock update
whenever the amount of log space that it would reclaim exceeds 1/4 of
the log size.  That should be often enough without imposing a
completely arbitrary number.

Make sense?

thanks,
NeilBrown
