Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102AEE57D
	for <linux-raid@vger.kernel.org>; Sat,  8 Jun 2024 13:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717854243; cv=none; b=pa8fUtWln+GIRmnINtAb8/VOVrx/+Rc3lL1BHf7aQ/Z+qn4I3ZeKf1X/0hzl8pRy5kwNziSiOI9+ZL2kzPDUFFlKlo9PDX8VGjnBv0q/GpjOe8dFM4Xwp6IhR4toz5Oiq+8bKJMGxwSAC9H8gLvlVhv9gUzKvcqDkeF8ZYPPawE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717854243; c=relaxed/simple;
	bh=ioDNm777ZcI825Wcq7ZPe6c9ayLydQCWy7/yUuBeOQE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jao3XShtcRiDAkAOFPsMh/WqR6Nf1RupF39vDd3Xl6ffTb175MG6Y15QFcFiIqFYif1mhA3odNQcoG1EXYn4y8HZbkymeJQrwIsEda5sOf8upTu/suR67URx90pywVe5pQSvvxG0giYBqVtXjO/vjsnXmL+fDkTjQBkJcCO3kMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mteIGStG; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mteIGStG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717854241; x=1749390241;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ioDNm777ZcI825Wcq7ZPe6c9ayLydQCWy7/yUuBeOQE=;
  b=mteIGStGmwWExkCVaw6nDqv8Amp321ZW9HTlnycnc224dzjOxRzW5nFE
   xdM9gOG1e1vlM+i2P4AYglXC/0V3KWSvRlhzdKZ5MO8XUfJ/EK1UBnjon
   0YnzsVL9ar0WPL1CsKIthl4FbeAKVJCnQCBemcJieNE0O1IpGeJrGHw+M
   yWPPPjNFpDW8fj0PBMamcCtSdeFALv7SshszX2H/fsmnvtiXGyswa1rw0
   WD9yzOeBkiq4Gh+Sz31Z2fs7Dz4QPhLYycwEI56KM+yXA7q0f3NORK4i8
   9E6SvrxTg6qCnchjPlLq1rEdw/rITb2/xc4TrdkMjf3nsPfQZU0zpZBDQ
   A==;
X-CSE-ConnectionGUID: Ox2oTr71TD+TSattPRm3Ew==
X-CSE-MsgGUID: OfEv2aIPSweJAic5rjqd/w==
X-IronPort-AV: E=McAfee;i="6600,9927,11097"; a="14371756"
X-IronPort-AV: E=Sophos;i="6.08,223,1712646000"; 
   d="scan'208";a="14371756"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2024 06:44:00 -0700
X-CSE-ConnectionGUID: tsojs87AT8STfdTCQB12Iw==
X-CSE-MsgGUID: QOxj3HqUSHe0Yfebdc1v0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,223,1712646000"; 
   d="scan'208";a="38543285"
Received: from ashoknav-mobl.amr.corp.intel.com (HELO peluse-desk5) ([10.212.9.120])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2024 06:43:59 -0700
Date: Sat, 8 Jun 2024 06:43:56 -0700
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: Shushu Yi <teddyxym@outlook.com>
Cc: linux-raid@vger.kernel.org, Shushu Yi <firnyee@gmail.com>, Song Liu
 <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, hch@infradead.org, Paul
 Luse <paul.e.luse@intel.com>
Subject: Re: [RFC V5] md/raid5: optimize Scattered Address Space and
 Thread-Level Parallelism to improve RAID5 performance
Message-ID: <20240608064356.508c0cf5@peluse-desk5>
In-Reply-To: <20240605100327.7c64312f@peluse-desk5>
References: <SJ0PR10MB574112619D4A62D4EBC891E9D8F92@SJ0PR10MB5741.namprd10.prod.outlook.com>
	<20240605100327.7c64312f@peluse-desk5>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; aarch64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 5 Jun 2024 10:03:27 -0700
Paul E Luse <paul.e.luse@linux.intel.com> wrote:

> On Thu,  6 Jun 2024 00:53:42 +0800
> Shushu Yi <teddyxym@outlook.com> wrote:
> 
> Awesome thanks!  FYi for everyone on V4 I ran both data integrity (no
> issues) and perf tests and performance looked compelling.  I'm
> re-running the baseline now (as I had to skip one patch because of the
> conflict), once that's done tomrorow I will re-run V5 and publish
> resutls for everyone.
> 
> -Paul


Performance results look very good.  Christoph I know you showed
interest in V1 of this patch, I'm think these numbers might peak your
interest again.

https://photos.app.goo.gl/5v2bWeYBsKWu6FHA8

> 
> > Optimize scattered address space. Achieves significant improvements
> > in both throughput and latency.
> > 
> > Maximize thread-level parallelism and reduce CPU suspension time
> > caused by lock contention. Achieve increased overall storage
> > throughput by 89.4% and decrease the 99.99th percentile I/O latency
> > by 85.4% on a system with four PCIe 4.0 SSDs. (Set the iodepth to 32
> > and employ libaio. Configure the I/O size as 4 KB with sequential
> > write and 16 threads. In RAID5 consist of 2+1 1TB Samsung 980Pro
> > SSDs, throughput went from 5218MB/s to 9884MB/s.)
> > 
> > Note: Publish this work as a paper and provide the URL
> > (https://www.hotstorage.org/2022/camera-ready/hotstorage22-5/pdf/
> > hotstorage22-5.pdf).
> > 
> > Co-developed-by: Yiming Xu <teddyxym@outlook.com>
> > Signed-off-by: Yiming Xu <teddyxym@outlook.com>
> > Signed-off-by: Shushu Yi <firnyee@gmail.com>
> > Tested-by: Paul Luse <paul.e.luse@intel.com>
> > ---
> > V1 -> V2: Cleaned up coding style and divided into 2 patches
> > (HemiRAID and ScalaRAID corresponding to the paper mentioned
> > above). ScalaRAID equipped every counter with a counter lock and
> > employ our D-Block. HemiRAID increased the number of stripe locks
> > to 128 V2 -> V3: Adjusted the language used in the subject and
> > changelog. Since patch 1/2 in V2 cannot be used independently and
> > does not encompass all of our work, it has been merged into a
> > single patch. V3 -> V4: Fixed incorrect sending address and
> > changelog format. V4 -> V5: Resolved a adress conflict on main
> > (commit f0e729af2eb6bee9eb58c4df1087f14ebaefe26b (HEAD -> md-6.10,
> > tag: md-6.10-20240502, origin/md-6.10)).
> > 
> >  drivers/md/md-bitmap.c | 197
> > ++++++++++++++++++++++++++++++----------- drivers/md/md-bitmap.h |
> > 12 ++- drivers/md/raid5.h     |   7 +-
> >  3 files changed, 155 insertions(+), 61 deletions(-)
> > 
> > diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> > index 0a2d37eb38ef..f08d3228b305 100644
> > --- a/drivers/md/md-bitmap.c
> > +++ b/drivers/md/md-bitmap.c
> > @@ -47,10 +47,12 @@ static inline char *bmname(struct bitmap
> > *bitmap)
> >   * if we find our page, we increment the page's refcount so that it
> > stays
> >   * allocated while we're using it
> >   */
> > -static int md_bitmap_checkpage(struct bitmap_counts *bitmap,
> > -			       unsigned long page, int create, int
> > no_hijack) -__releases(bitmap->lock)
> > -__acquires(bitmap->lock)
> > +static int md_bitmap_checkpage(struct bitmap_counts *bitmap,
> > unsigned long page,
> > +			       int create, int no_hijack,
> > spinlock_t *bmclock, int locktype) +__releases(bmclock)
> > +__acquires(bmclock)
> > +__releases(bitmap->mlock)
> > +__acquires(bitmap->mlock)
> >  {
> >  	unsigned char *mappage;
> >  
> > @@ -65,8 +67,10 @@ __acquires(bitmap->lock)
> >  		return -ENOENT;
> >  
> >  	/* this page has not been allocated yet */
> > -
> > -	spin_unlock_irq(&bitmap->lock);
> > +	if (locktype)
> > +		spin_unlock_irq(bmclock);
> > +	else
> > +		write_unlock_irq(&bitmap->mlock);
> >  	/* It is possible that this is being called inside a
> >  	 * prepare_to_wait/finish_wait loop from
> > raid5c:make_request().
> >  	 * In general it is not permitted to sleep in that context
> > as it @@ -81,7 +85,11 @@ __acquires(bitmap->lock)
> >  	 */
> >  	sched_annotate_sleep();
> >  	mappage = kzalloc(PAGE_SIZE, GFP_NOIO);
> > -	spin_lock_irq(&bitmap->lock);
> > +
> > +	if (locktype)
> > +		spin_lock_irq(bmclock);
> > +	else
> > +		write_lock_irq(&bitmap->mlock);
> >  
> >  	if (mappage == NULL) {
> >  		pr_debug("md/bitmap: map page allocation failed,
> > hijacking\n"); @@ -399,7 +407,7 @@ static int read_file_page(struct
> > file *file, unsigned long index, }
> >  
> >  	wait_event(bitmap->write_wait,
> > -		   atomic_read(&bitmap->pending_writes)==0);
> > +		   atomic_read(&bitmap->pending_writes) == 0);
> >  	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
> >  		ret = -EIO;
> >  out:
> > @@ -458,7 +466,7 @@ static void md_bitmap_wait_writes(struct bitmap
> > *bitmap) {
> >  	if (bitmap->storage.file)
> >  		wait_event(bitmap->write_wait,
> > -
> > atomic_read(&bitmap->pending_writes)==0);
> > +			   atomic_read(&bitmap->pending_writes) ==
> > 0); else
> >  		/* Note that we ignore the return value.  The
> > writes
> >  		 * might have failed, but that would just mean that
> > @@ -1248,16 +1256,28 @@ void md_bitmap_write_all(struct bitmap
> > *bitmap) static void md_bitmap_count_page(struct bitmap_counts
> > *bitmap, sector_t offset, int inc)
> >  {
> > -	sector_t chunk = offset >> bitmap->chunkshift;
> > -	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
> > +	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> > +	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift
> > - (PAGE_SHIFT - SECTOR_SHIFT));
> > +	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
> > +	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
> > +					(bits - (bitmap->chunkshift
> > + SECTOR_SHIFT - PAGE_SHIFT)));
> > +	unsigned long cntid = blockno & mask;
> > +	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
> > +
> >  	bitmap->bp[page].count += inc;
> >  	md_bitmap_checkfree(bitmap, page);
> >  }
> >  
> >  static void md_bitmap_set_pending(struct bitmap_counts *bitmap,
> > sector_t offset) {
> > -	sector_t chunk = offset >> bitmap->chunkshift;
> > -	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
> > +	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> > +	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift
> > - (PAGE_SHIFT - SECTOR_SHIFT));
> > +	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
> > +	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
> > +					(bits - (bitmap->chunkshift
> > + SECTOR_SHIFT - PAGE_SHIFT)));
> > +	unsigned long cntid = blockno & mask;
> > +	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
> > +
> >  	struct bitmap_page *bp = &bitmap->bp[page];
> >  
> >  	if (!bp->pending)
> > @@ -1266,7 +1286,7 @@ static void md_bitmap_set_pending(struct
> > bitmap_counts *bitmap, sector_t offset) 
> >  static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts
> > *bitmap, sector_t offset, sector_t *blocks,
> > -					       int create);
> > +					       int create,
> > spinlock_t *bmclock, int locktype); 
> >  static void mddev_set_timeout(struct mddev *mddev, unsigned long
> > timeout, bool force)
> > @@ -1349,7 +1369,7 @@ void md_bitmap_daemon_work(struct mddev
> > *mddev)
> >  	 * decrement and handle accordingly.
> >  	 */
> >  	counts = &bitmap->counts;
> > -	spin_lock_irq(&counts->lock);
> > +	write_lock_irq(&counts->mlock);
> >  	nextpage = 0;
> >  	for (j = 0; j < counts->chunks; j++) {
> >  		bitmap_counter_t *bmc;
> > @@ -1364,7 +1384,7 @@ void md_bitmap_daemon_work(struct mddev
> > *mddev) counts->bp[j >> PAGE_COUNTER_SHIFT].pending
> > = 0; }
> >  
> > -		bmc = md_bitmap_get_counter(counts, block, &blocks,
> > 0);
> > +		bmc = md_bitmap_get_counter(counts, block, &blocks,
> > 0, 0, 0); if (!bmc) {
> >  			j |= PAGE_COUNTER_MASK;
> >  			continue;
> > @@ -1380,7 +1400,7 @@ void md_bitmap_daemon_work(struct mddev
> > *mddev) bitmap->allclean = 0;
> >  		}
> >  	}
> > -	spin_unlock_irq(&counts->lock);
> > +	write_unlock_irq(&counts->mlock);
> >  
> >  	md_bitmap_wait_writes(bitmap);
> >  	/* Now start writeout on any page in NEEDWRITE that isn't
> > DIRTY. @@ -1413,17 +1433,25 @@ void md_bitmap_daemon_work(struct
> > mddev *mddev) 
> >  static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts
> > *bitmap, sector_t offset, sector_t *blocks,
> > -					       int create)
> > -__releases(bitmap->lock)
> > -__acquires(bitmap->lock)
> > +					       int create,
> > spinlock_t *bmclock, int locktype) +__releases(bmclock)
> > +__acquires(bmclock)
> > +__releases(bitmap->mlock)
> > +__acquires(bitmap->mlock)
> >  {
> >  	/* If 'create', we might release the lock and reclaim it.
> >  	 * The lock must have been taken with interrupts enabled.
> >  	 * If !create, we don't release the lock.
> >  	 */
> > -	sector_t chunk = offset >> bitmap->chunkshift;
> > -	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
> > -	unsigned long pageoff = (chunk & PAGE_COUNTER_MASK) <<
> > COUNTER_BYTE_SHIFT;
> > +	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> > +	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift
> > - (PAGE_SHIFT - SECTOR_SHIFT));
> > +	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
> > +	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
> > +					(bits - (bitmap->chunkshift
> > + SECTOR_SHIFT - PAGE_SHIFT)));
> > +	unsigned long cntid = blockno & mask;
> > +	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
> > +	unsigned long pageoff = (cntid & PAGE_COUNTER_MASK) <<
> > COUNTER_BYTE_SHIFT; +
> >  	sector_t csize = ((sector_t)1) << bitmap->chunkshift;
> >  	int err;
> >  
> > @@ -1436,7 +1464,7 @@ __acquires(bitmap->lock)
> >  		*blocks = csize - (offset & (csize - 1));
> >  		return NULL;
> >  	}
> > -	err = md_bitmap_checkpage(bitmap, page, create, 0);
> > +	err = md_bitmap_checkpage(bitmap, page, create, 0, bmclock,
> > 1); 
> >  	if (bitmap->bp[page].hijacked ||
> >  	    bitmap->bp[page].map == NULL)
> > @@ -1461,6 +1489,28 @@ __acquires(bitmap->lock)
> >  			&(bitmap->bp[page].map[pageoff]);
> >  }
> >  
> > +/* set-association */
> > +static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts
> > *bitmap, sector_t offset); +
> > +static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts
> > *bitmap, sector_t offset) +{
> > +	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> > +	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift
> > - (PAGE_SHIFT - SECTOR_SHIFT));
> > +	unsigned long bitscnt = totblocks ? fls((totblocks - 1)) :
> > 0;
> > +	unsigned long maskcnt = ULONG_MAX << bitscnt | ~(ULONG_MAX
> > << (bitscnt -
> > +					(bitmap->chunkshift +
> > SECTOR_SHIFT - PAGE_SHIFT)));
> > +	unsigned long cntid = blockno & maskcnt;
> > +
> > +	unsigned long totcnts = bitmap->chunks;
> > +	unsigned long bitslock = totcnts ? fls((totcnts - 1)) : 0;
> > +	unsigned long masklock = ULONG_MAX << bitslock |
> > ~(ULONG_MAX <<
> > +					(bitslock -
> > BITMAP_COUNTER_LOCK_RATIO_SHIFT));
> > +	unsigned long lockid = cntid & masklock;
> > +
> > +	spinlock_t *bmclock = &(bitmap->bmclocks[lockid]);
> > +	return bmclock;
> > +}
> > +
> >  int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
> > unsigned long sectors, int behind) {
> >  	if (!bitmap)
> > @@ -1480,11 +1530,15 @@ int md_bitmap_startwrite(struct bitmap
> > *bitmap, sector_t offset, unsigned long s while (sectors) {
> >  		sector_t blocks;
> >  		bitmap_counter_t *bmc;
> > +		spinlock_t *bmclock;
> >  
> > -		spin_lock_irq(&bitmap->counts.lock);
> > -		bmc = md_bitmap_get_counter(&bitmap->counts,
> > offset, &blocks, 1);
> > +		bmclock = md_bitmap_get_bmclock(&bitmap->counts,
> > offset);
> > +		read_lock(&bitmap->counts.mlock);
> > +		spin_lock_irq(bmclock);
> > +		bmc = md_bitmap_get_counter(&bitmap->counts,
> > offset, &blocks, 1, bmclock, 1); if (!bmc) {
> > -			spin_unlock_irq(&bitmap->counts.lock);
> > +			spin_unlock_irq(bmclock);
> > +			read_unlock(&bitmap->counts.mlock);
> >  			return 0;
> >  		}
> >  
> > @@ -1496,7 +1550,8 @@ int md_bitmap_startwrite(struct bitmap
> > *bitmap, sector_t offset, unsigned long s */
> >  			prepare_to_wait(&bitmap->overflow_wait,
> > &__wait, TASK_UNINTERRUPTIBLE);
> > -			spin_unlock_irq(&bitmap->counts.lock);
> > +			spin_unlock_irq(bmclock);
> > +			read_unlock(&bitmap->counts.mlock);
> >  			schedule();
> >  			finish_wait(&bitmap->overflow_wait,
> > &__wait); continue;
> > @@ -1513,7 +1568,8 @@ int md_bitmap_startwrite(struct bitmap
> > *bitmap, sector_t offset, unsigned long s 
> >  		(*bmc)++;
> >  
> > -		spin_unlock_irq(&bitmap->counts.lock);
> > +		spin_unlock_irq(bmclock);
> > +		read_unlock(&bitmap->counts.mlock);
> >  
> >  		offset += blocks;
> >  		if (sectors > blocks)
> > @@ -1542,11 +1598,15 @@ void md_bitmap_endwrite(struct bitmap
> > *bitmap, sector_t offset, sector_t blocks;
> >  		unsigned long flags;
> >  		bitmap_counter_t *bmc;
> > +		spinlock_t *bmclock;
> >  
> > -		spin_lock_irqsave(&bitmap->counts.lock, flags);
> > -		bmc = md_bitmap_get_counter(&bitmap->counts,
> > offset, &blocks, 0);
> > +		bmclock = md_bitmap_get_bmclock(&bitmap->counts,
> > offset);
> > +		read_lock(&bitmap->counts.mlock);
> > +		spin_lock_irqsave(bmclock, flags);
> > +		bmc = md_bitmap_get_counter(&bitmap->counts,
> > offset, &blocks, 0, bmclock, 1); if (!bmc) {
> > -
> > spin_unlock_irqrestore(&bitmap->counts.lock, flags);
> > +			spin_unlock_irqrestore(bmclock, flags);
> > +			read_unlock(&bitmap->counts.mlock);
> >  			return;
> >  		}
> >  
> > @@ -1568,7 +1628,8 @@ void md_bitmap_endwrite(struct bitmap *bitmap,
> > sector_t offset, md_bitmap_set_pending(&bitmap->counts, offset);
> >  			bitmap->allclean = 0;
> >  		}
> > -		spin_unlock_irqrestore(&bitmap->counts.lock,
> > flags);
> > +		spin_unlock_irqrestore(bmclock, flags);
> > +		read_unlock(&bitmap->counts.mlock);
> >  		offset += blocks;
> >  		if (sectors > blocks)
> >  			sectors -= blocks;
> > @@ -1582,13 +1643,16 @@ static int __bitmap_start_sync(struct bitmap
> > *bitmap, sector_t offset, sector_t int degraded)
> >  {
> >  	bitmap_counter_t *bmc;
> > +	spinlock_t *bmclock;
> >  	int rv;
> >  	if (bitmap == NULL) {/* FIXME or bitmap set as 'failed' */
> >  		*blocks = 1024;
> >  		return 1; /* always resync if no bitmap */
> >  	}
> > -	spin_lock_irq(&bitmap->counts.lock);
> > -	bmc = md_bitmap_get_counter(&bitmap->counts, offset,
> > blocks, 0);
> > +	bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> > +	read_lock(&bitmap->counts.mlock);
> > +	spin_lock_irq(bmclock);
> > +	bmc = md_bitmap_get_counter(&bitmap->counts, offset,
> > blocks, 0, bmclock, 1); rv = 0;
> >  	if (bmc) {
> >  		/* locked */
> > @@ -1602,7 +1666,8 @@ static int __bitmap_start_sync(struct bitmap
> > *bitmap, sector_t offset, sector_t }
> >  		}
> >  	}
> > -	spin_unlock_irq(&bitmap->counts.lock);
> > +	spin_unlock_irq(bmclock);
> > +	read_unlock(&bitmap->counts.mlock);
> >  	return rv;
> >  }
> >  
> > @@ -1634,13 +1699,16 @@ void md_bitmap_end_sync(struct bitmap
> > *bitmap, sector_t offset, sector_t *blocks {
> >  	bitmap_counter_t *bmc;
> >  	unsigned long flags;
> > +	spinlock_t *bmclock;
> >  
> >  	if (bitmap == NULL) {
> >  		*blocks = 1024;
> >  		return;
> >  	}
> > -	spin_lock_irqsave(&bitmap->counts.lock, flags);
> > -	bmc = md_bitmap_get_counter(&bitmap->counts, offset,
> > blocks, 0);
> > +	bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> > +	read_lock(&bitmap->counts.mlock);
> > +	spin_lock_irqsave(bmclock, flags);
> > +	bmc = md_bitmap_get_counter(&bitmap->counts, offset,
> > blocks, 0, bmclock, 1); if (bmc == NULL)
> >  		goto unlock;
> >  	/* locked */
> > @@ -1657,7 +1725,8 @@ void md_bitmap_end_sync(struct bitmap *bitmap,
> > sector_t offset, sector_t *blocks }
> >  	}
> >   unlock:
> > -	spin_unlock_irqrestore(&bitmap->counts.lock, flags);
> > +	spin_unlock_irqrestore(bmclock, flags);
> > +	read_unlock(&bitmap->counts.mlock);
> >  }
> >  EXPORT_SYMBOL(md_bitmap_end_sync);
> >  
> > @@ -1738,10 +1807,15 @@ static void md_bitmap_set_memory_bits(struct
> > bitmap *bitmap, sector_t offset, in 
> >  	sector_t secs;
> >  	bitmap_counter_t *bmc;
> > -	spin_lock_irq(&bitmap->counts.lock);
> > -	bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs,
> > 1);
> > +	spinlock_t *bmclock;
> > +
> > +	bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> > +	read_lock(&bitmap->counts.mlock);
> > +	spin_lock_irq(bmclock);
> > +	bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs,
> > 1, bmclock, 1); if (!bmc) {
> > -		spin_unlock_irq(&bitmap->counts.lock);
> > +		spin_unlock_irq(bmclock);
> > +		read_unlock(&bitmap->counts.mlock);
> >  		return;
> >  	}
> >  	if (!*bmc) {
> > @@ -1752,7 +1826,8 @@ static void md_bitmap_set_memory_bits(struct
> > bitmap *bitmap, sector_t offset, in }
> >  	if (needed)
> >  		*bmc |= NEEDED_MASK;
> > -	spin_unlock_irq(&bitmap->counts.lock);
> > +	spin_unlock_irq(bmclock);
> > +	read_unlock(&bitmap->counts.mlock);
> >  }
> >  
> >  /* dirty the memory and file bits for bitmap chunks "s" to "e" */
> > @@ -1806,6 +1881,7 @@ void md_bitmap_free(struct bitmap *bitmap)
> >  {
> >  	unsigned long k, pages;
> >  	struct bitmap_page *bp;
> > +	spinlock_t *bmclocks;
> >  
> >  	if (!bitmap) /* there was no bitmap */
> >  		return;
> > @@ -1826,6 +1902,7 @@ void md_bitmap_free(struct bitmap *bitmap)
> >  
> >  	bp = bitmap->counts.bp;
> >  	pages = bitmap->counts.pages;
> > +	bmclocks = bitmap->counts.bmclocks;
> >  
> >  	/* free all allocated memory */
> >  
> > @@ -1834,6 +1911,7 @@ void md_bitmap_free(struct bitmap *bitmap)
> >  			if (bp[k].map && !bp[k].hijacked)
> >  				kfree(bp[k].map);
> >  	kfree(bp);
> > +	kfree(bmclocks);
> >  	kfree(bitmap);
> >  }
> >  EXPORT_SYMBOL(md_bitmap_free);
> > @@ -1900,7 +1978,9 @@ struct bitmap *md_bitmap_create(struct mddev
> > *mddev, int slot) if (!bitmap)
> >  		return ERR_PTR(-ENOMEM);
> >  
> > -	spin_lock_init(&bitmap->counts.lock);
> > +	/* initialize metadata lock */
> > +	rwlock_init(&bitmap->counts.mlock);
> > +
> >  	atomic_set(&bitmap->pending_writes, 0);
> >  	init_waitqueue_head(&bitmap->write_wait);
> >  	init_waitqueue_head(&bitmap->overflow_wait);
> > @@ -2143,6 +2223,8 @@ int md_bitmap_resize(struct bitmap *bitmap,
> > sector_t blocks, int ret = 0;
> >  	long pages;
> >  	struct bitmap_page *new_bp;
> > +	spinlock_t *new_bmclocks;
> > +	int num_bmclocks, i;
> >  
> >  	if (bitmap->storage.file && !init) {
> >  		pr_info("md: cannot resize file-based bitmap\n");
> > @@ -2211,7 +2293,7 @@ int md_bitmap_resize(struct bitmap *bitmap,
> > sector_t blocks, memcpy(page_address(store.sb_page),
> >  		       page_address(bitmap->storage.sb_page),
> >  		       sizeof(bitmap_super_t));
> > -	spin_lock_irq(&bitmap->counts.lock);
> > +	write_lock_irq(&bitmap->counts.mlock);
> >  	md_bitmap_file_unmap(&bitmap->storage);
> >  	bitmap->storage = store;
> >  
> > @@ -2227,18 +2309,28 @@ int md_bitmap_resize(struct bitmap *bitmap,
> > sector_t blocks, blocks = min(old_counts.chunks <<
> > old_counts.chunkshift, chunks << chunkshift);
> >  
> > +	/* initialize bmc locks */
> > +	num_bmclocks = DIV_ROUND_UP(chunks,
> > BITMAP_COUNTER_LOCK_RATIO); +
> > +	new_bmclocks = kvcalloc(num_bmclocks,
> > sizeof(*new_bmclocks), GFP_KERNEL);
> > +	bitmap->counts.bmclocks = new_bmclocks;
> > +	for (i = 0; i < num_bmclocks; ++i) {
> > +		spinlock_t *bmclock =
> > &(bitmap->counts.bmclocks)[i]; +
> > +		spin_lock_init(bmclock);
> > +	}
> > +
> >  	/* For cluster raid, need to pre-allocate bitmap */
> >  	if (mddev_is_clustered(bitmap->mddev)) {
> >  		unsigned long page;
> >  		for (page = 0; page < pages; page++) {
> > -			ret = md_bitmap_checkpage(&bitmap->counts,
> > page, 1, 1);
> > +			ret = md_bitmap_checkpage(&bitmap->counts,
> > page, 1, 1, 0, 0); if (ret) {
> >  				unsigned long k;
> >  
> >  				/* deallocate the page memory */
> > -				for (k = 0; k < page; k++) {
> > +				for (k = 0; k < page; k++)
> >  					kfree(new_bp[k].map);
> > -				}
> >  				kfree(new_bp);
> >  
> >  				/* restore some fields from
> > old_counts */ @@ -2261,11 +2353,12 @@ int md_bitmap_resize(struct
> > bitmap *bitmap, sector_t blocks, bitmap_counter_t *bmc_old,
> > *bmc_new; int set;
> >  
> > -		bmc_old = md_bitmap_get_counter(&old_counts, block,
> > &old_blocks, 0);
> > +		bmc_old = md_bitmap_get_counter(&old_counts, block,
> > &old_blocks, 0, 0, 0); set = bmc_old && NEEDED(*bmc_old);
> >  
> >  		if (set) {
> > -			bmc_new =
> > md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);
> > +			bmc_new =
> > md_bitmap_get_counter(&bitmap->counts, block, &new_blocks,
> > +
> > 		1, 0, 0); if (bmc_new) {
> >  				if (*bmc_new == 0) {
> >  					/* need to set on-disk bits
> > too. */ @@ -2301,7 +2394,7 @@ int md_bitmap_resize(struct bitmap
> > *bitmap, sector_t blocks, int i;
> >  		while (block < (chunks << chunkshift)) {
> >  			bitmap_counter_t *bmc;
> > -			bmc =
> > md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);
> > +			bmc =
> > md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1, 0,
> > 0); if (bmc) { /* new space.  It needs to be
> > resynced, so
> >  				 * we set NEEDED_MASK.
> > @@ -2317,7 +2410,7 @@ int md_bitmap_resize(struct bitmap *bitmap,
> > sector_t blocks, for (i = 0; i < bitmap->storage.file_pages; i++)
> >  			set_page_attr(bitmap, i,
> > BITMAP_PAGE_DIRTY); }
> > -	spin_unlock_irq(&bitmap->counts.lock);
> > +	write_unlock_irq(&bitmap->counts.mlock);
> >  
> >  	if (!init) {
> >  		md_bitmap_unplug(bitmap);
> > diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> > index bb9eb418780a..1b9c36bb73ed 100644
> > --- a/drivers/md/md-bitmap.h
> > +++ b/drivers/md/md-bitmap.h
> > @@ -2,7 +2,9 @@
> >  /*
> >   * bitmap.h: Copyright (C) Peter T. Breuer (ptb@ot.uc3m.es) 2003
> >   *
> > - * additions: Copyright (C) 2003-2004, Paul Clements, SteelEye
> > Technology, Inc.
> > + * additions:
> > + *		Copyright (C) 2003-2004, Paul Clements, SteelEye
> > Technology, Inc.
> > + *		Copyright (C) 2022-2023, Shushu Yi
> > (firnyee@gmail.com) */
> >  #ifndef BITMAP_H
> >  #define BITMAP_H 1
> > @@ -103,6 +105,9 @@ typedef __u16 bitmap_counter_t;
> >  #define PAGE_COUNTER_MASK  (PAGE_COUNTER_RATIO - 1)
> >  
> >  #define BITMAP_BLOCK_SHIFT 9
> > +/* how many counters share the same bmclock? */
> > +#define BITMAP_COUNTER_LOCK_RATIO_SHIFT 0
> > +#define BITMAP_COUNTER_LOCK_RATIO (1 <<
> > BITMAP_COUNTER_LOCK_RATIO_SHIFT) 
> >  #endif
> >  
> > @@ -116,7 +121,7 @@ typedef __u16 bitmap_counter_t;
> >  enum bitmap_state {
> >  	BITMAP_STALE	   = 1,  /* the bitmap file is out of
> > date or had -EIO */ BITMAP_WRITE_ERROR = 2, /* A write error has
> > occurred */
> > -	BITMAP_HOSTENDIAN  =15,
> > +	BITMAP_HOSTENDIAN  = 15,
> >  };
> >  
> >  /* the superblock at the front of the bitmap file -- little endian
> > */ @@ -180,7 +185,8 @@ struct bitmap_page {
> >  struct bitmap {
> >  
> >  	struct bitmap_counts {
> > -		spinlock_t lock;
> > +		rwlock_t mlock;				/*
> > lock for metadata */
> > +		spinlock_t *bmclocks;		/* locks for
> > bmc */ struct bitmap_page *bp;
> >  		unsigned long pages;		/* total number
> > of pages
> >  						 * in the bitmap */
> > diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> > index 9b5a7dc3f2a0..818ce86f4b2c 100644
> > --- a/drivers/md/raid5.h
> > +++ b/drivers/md/raid5.h
> > @@ -496,12 +496,7 @@ struct disk_info {
> >  #define HASH_MASK		(NR_HASH - 1)
> >  #define MAX_STRIPE_BATCH	8
> >  
> > -/* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
> > - * This is because we sometimes take all the spinlocks
> > - * and creating that much locking depth can cause
> > - * problems.
> > - */

I'm no expert in this code but I assume it is the case that the reduced
lock contention is the reason this is no longer a concern? How did you
come up with the number 128?

> > -#define NR_STRIPE_HASH_LOCKS 8
> > +#define NR_STRIPE_HASH_LOCKS 128
> >  #define STRIPE_HASH_LOCKS_MASK (NR_STRIPE_HASH_LOCKS - 1)
> >  
> >  struct r5worker {
> 
> 

