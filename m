From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/md0: optimize raid0 discard handling
Date: Wed, 10 May 2017 09:09:33 -0700
Message-ID: <20170510160933.rtv4m23a4wmilzqe@kernel.org>
References: <1af0237c374a1e276663fa17824e8345165fcca6.1494203680.git.shli@fb.com>
 <87r2zyn8op.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87r2zyn8op.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, Kernel-team@fb.com, Coly Li <colyli@suse.de>
List-Id: linux-raid.ids

On Tue, May 09, 2017 at 11:03:02AM +1000, Neil Brown wrote:
> On Sun, May 07 2017, Shaohua Li wrote:
> 
> > There are complaints that raid0 discard handling is slow. Currently we
> > divide discard request into chunks and dispatch to underlayer disks. The
> > block layer will do merge to form big requests. This causes a lot of
> > request split/merge and uses significant CPU time.
> >
> > A simple idea is to calculate the range for each raid disk for an IO
> > request and send a discard request to raid disks, which will avoid the
> > split/merge completely. Previously Coly tried the approach, but the
> > implementation was too complex because of raid0 zones. This patch always
> > split bio in zone boundary and handle bio within one zone. It simplifies
> > the implementation a lot.
> >
> > Cc: NeilBrown <neilb@suse.com>
> > Cc: Coly Li <colyli@suse.de>
> > Signed-off-by: Shaohua Li <shli@fb.com>
> 
> Reviewed-by: NeilBrown <neilb@suse.com>
> 
> I'm a little bit bothered by the use for __blkdev_issue_discard() which
> uses bio_alloc(), which allocates from fs_bio_set.  This code isn't in a
> filesystem, so it feels wrong.
> 
> fs_bio_set has 4 entries.  If 4 different threads call
> __blkdev_issue_discard() on a raid0 device, they could get allocated all
> of the entries from the pool.  Then when raid0 calls
> __blkdev_issue_discard(), the pool is empty.
> 
> I don't think this is actually a problem as discard (presumably) doesn't
> happen on the write-out-for-memory-reclaim path, so the bio_alloc() will
> eventually be able to get memory from kmalloc() rather than from the
> pool.
> 
> Maybe next_bio() should use the bio_split pool from
> bio->bi_bdev->queue.  But it probably doesn't really matter.

Indead this part isn't comfortable. I'd suppose discard is only called in
transaction thread of fs, so only one thread is calling into discard. Probably
not a big deal.

Thanks,
Shaohua
