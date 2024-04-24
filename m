Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8AC1DFEF
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 16:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714063013; cv=none; b=P6b1GKm/zyiesfwnCatrRSR18hsKcsAA2y+o6sFQXU7cpz5yWq4VV/8RWRECOvQA6l868Vlh9CuL5CNGkC7mLtXY2tZEa5tbbppV+XdUH5UiuN1eG5YR04seRdtg3xgZQAlIn7scR3ZPhhOzJTsvJmQgHCMTwXs9Q5USABiayXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714063013; c=relaxed/simple;
	bh=Q319bwsfJCjtV7D7QXtuOMoGF+HSA7kstHYfWNCYH7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=azJuf2qYw+DR7Xsp0PMN9gPC/tdRaUpIul3/m7Q6eq00Q6xNCFe16jpblwIkG3hW7akKohzoqz1oNK8IHJOa29KD4WF6Kou0EXm6v6J7F4tsomey4h/oq4Km3cVReHyRm9ajSg/vmIYzSktGMDkc4dOWXfTbBcc7ClV3ttip0Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cBgJ1lSQ; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cBgJ1lSQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714063012; x=1745599012;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q319bwsfJCjtV7D7QXtuOMoGF+HSA7kstHYfWNCYH7Y=;
  b=cBgJ1lSQUQGigy02qduikFIYozy1q70UEVk8puhbOF1iwYb7DpT37JUT
   glEzh2YkpkNoYCp/TnOFS6iDxMN2yxkAbx8nnXbhmptLxuKqOKYx4Oeyw
   upqXJXlfXUNrjiPqIH+Tc9l8oY0SixMpbg/WttaljnSGBC53HAns8l1Nn
   Doo/idCk4Di/Tj9v/zDEKfjvjLkiaJ9/B9/4Dyepf+AO30//9Ja0e4mMX
   7KAA5FuI+bC2RdnT3lBHYBI9w01WO2AJfsPi0fdLd8cLlJ2fuGRsjajSC
   TYLb0gzbnz7egoaBIA+83b8MveYSMHkiAG0udyt29ePAZ5heXnizOWqpq
   A==;
X-CSE-ConnectionGUID: 16FEL6oRTj6e4J4bpAn7sg==
X-CSE-MsgGUID: GIX52Be1R5GUa0Oye9VxsA==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9884640"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="9884640"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 09:36:51 -0700
X-CSE-ConnectionGUID: TnGh6+DeSeqA+H1DSNHORA==
X-CSE-MsgGUID: 9b+COhR1SySWfgipB7kEEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="62623937"
Received: from mshivarx-mobl.amr.corp.intel.com (HELO peluse-desk5) ([10.212.96.219])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 09:36:50 -0700
Date: Tue, 23 Apr 2024 23:48:36 -0700
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: Shushu Yi <teddyxym@outlook.com>
Cc: linux-raid@vger.kernel.org, firnyee@gmail.com, song@kernel.org,
 hch@infradead.org, paul.e.luse@intel.com
Subject: Re: [RFC V4] md/raid5: optimize Scattered Address Space and
 Thread-Level Parallelism to improve RAID5 performance
Message-ID: <20240423234836.42bfbf39@peluse-desk5>
In-Reply-To: <SJ0PR10MB5741964ECA25920AD608FEADD8082@SJ0PR10MB5741.namprd10.prod.outlook.com>
References: <SJ0PR10MB5741964ECA25920AD608FEADD8082@SJ0PR10MB5741.namprd10.prod.outlook.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; aarch64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Thanks Shushu! Apprecaite the continued follow-ups for sure.  Wrt the
performance claims below can you provide the full details on test setup
and results?

Within the next few days I should have a chance to run this again on
latest Xeon with gen5 Samsungs.

-Paul

On Tue, 16 Apr 2024 13:22:53 +0800
Shushu Yi <teddyxym@outlook.com> wrote:

> Optimize scattered address space. Achieves significant improvements in
> both throughput and latency.
> 
> Maximize thread-level parallelism and reduce CPU suspension time
> caused by lock contention. Achieve increased overall storage
> throughput by 89.4% and decrease the 99.99th percentile I/O latency
> by 85.4% on a system with four PCIe 4.0 SSDs.
> 
> Note: Publish this work as a paper and provide the URL
> (https://www.hotstorage.org/2022/camera-ready/hotstorage22-5/pdf/
> hotstorage22-5.pdf).
> 
> Co-developed-by: Yiming Xu <teddyxym@outlook.com>
> Signed-off-by: Yiming Xu <teddyxym@outlook.com>
> Signed-off-by: Shushu Yi <firnyee@gmail.com>
> Tested-by: Paul Luse <paul.e.luse@intel.com>
> ---
> V1 -> V2: Cleaned up coding style and divided into 2 patches (HemiRAID
> and ScalaRAID corresponding to the paper mentioned above). ScalaRAID
> equipped every counter with a counter lock and employ our D-Block.
> HemiRAID increased the number of stripe locks to 128
> V2 -> V3: Adjusted the language used in the subject and changelog.
> Since patch 1/2 in V2 cannot be used independently and does not
> encompass all of our work, it has been merged into a single patch.
> V3 -> V4: Fixed incorrect sending address and changelog format.
> 
>  drivers/md/md-bitmap.c | 197
> ++++++++++++++++++++++++++++++----------- drivers/md/md-bitmap.h |
> 12 ++- 2 files changed, 154 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 059afc24c08b..5ed5fe810b2f 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -47,10 +47,12 @@ static inline char *bmname(struct bitmap *bitmap)
>   * if we find our page, we increment the page's refcount so that it
> stays
>   * allocated while we're using it
>   */
> -static int md_bitmap_checkpage(struct bitmap_counts *bitmap,
> -			       unsigned long page, int create, int
> no_hijack) -__releases(bitmap->lock)
> -__acquires(bitmap->lock)
> +static int md_bitmap_checkpage(struct bitmap_counts *bitmap,
> unsigned long page,
> +			       int create, int no_hijack, spinlock_t
> *bmclock, int locktype) +__releases(bmclock)
> +__acquires(bmclock)
> +__releases(bitmap->mlock)
> +__acquires(bitmap->mlock)
>  {
>  	unsigned char *mappage;
>  
> @@ -65,8 +67,10 @@ __acquires(bitmap->lock)
>  		return -ENOENT;
>  
>  	/* this page has not been allocated yet */
> -
> -	spin_unlock_irq(&bitmap->lock);
> +	if (locktype)
> +		spin_unlock_irq(bmclock);
> +	else
> +		write_unlock_irq(&bitmap->mlock);
>  	/* It is possible that this is being called inside a
>  	 * prepare_to_wait/finish_wait loop from
> raid5c:make_request().
>  	 * In general it is not permitted to sleep in that context
> as it @@ -81,7 +85,11 @@ __acquires(bitmap->lock)
>  	 */
>  	sched_annotate_sleep();
>  	mappage = kzalloc(PAGE_SIZE, GFP_NOIO);
> -	spin_lock_irq(&bitmap->lock);
> +
> +	if (locktype)
> +		spin_lock_irq(bmclock);
> +	else
> +		write_lock_irq(&bitmap->mlock);
>  
>  	if (mappage == NULL) {
>  		pr_debug("md/bitmap: map page allocation failed,
> hijacking\n"); @@ -399,7 +407,7 @@ static int read_file_page(struct
> file *file, unsigned long index, }
>  
>  	wait_event(bitmap->write_wait,
> -		   atomic_read(&bitmap->pending_writes)==0);
> +		   atomic_read(&bitmap->pending_writes) == 0);
>  	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
>  		ret = -EIO;
>  out:
> @@ -458,7 +466,7 @@ static void md_bitmap_wait_writes(struct bitmap
> *bitmap) {
>  	if (bitmap->storage.file)
>  		wait_event(bitmap->write_wait,
> -			   atomic_read(&bitmap->pending_writes)==0);
> +			   atomic_read(&bitmap->pending_writes) ==
> 0); else
>  		/* Note that we ignore the return value.  The writes
>  		 * might have failed, but that would just mean that
> @@ -1248,16 +1256,28 @@ void md_bitmap_write_all(struct bitmap
> *bitmap) static void md_bitmap_count_page(struct bitmap_counts
> *bitmap, sector_t offset, int inc)
>  {
> -	sector_t chunk = offset >> bitmap->chunkshift;
> -	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
> +	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> +	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift -
> (PAGE_SHIFT - SECTOR_SHIFT));
> +	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
> +	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
> +					(bits - (bitmap->chunkshift
> + SECTOR_SHIFT - PAGE_SHIFT)));
> +	unsigned long cntid = blockno & mask;
> +	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
> +
>  	bitmap->bp[page].count += inc;
>  	md_bitmap_checkfree(bitmap, page);
>  }
>  
>  static void md_bitmap_set_pending(struct bitmap_counts *bitmap,
> sector_t offset) {
> -	sector_t chunk = offset >> bitmap->chunkshift;
> -	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
> +	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> +	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift -
> (PAGE_SHIFT - SECTOR_SHIFT));
> +	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
> +	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
> +					(bits - (bitmap->chunkshift
> + SECTOR_SHIFT - PAGE_SHIFT)));
> +	unsigned long cntid = blockno & mask;
> +	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
> +
>  	struct bitmap_page *bp = &bitmap->bp[page];
>  
>  	if (!bp->pending)
> @@ -1266,7 +1286,7 @@ static void md_bitmap_set_pending(struct
> bitmap_counts *bitmap, sector_t offset) 
>  static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts
> *bitmap, sector_t offset, sector_t *blocks,
> -					       int create);
> +					       int create,
> spinlock_t *bmclock, int locktype); 
>  static void mddev_set_timeout(struct mddev *mddev, unsigned long
> timeout, bool force)
> @@ -1349,7 +1369,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
>  	 * decrement and handle accordingly.
>  	 */
>  	counts = &bitmap->counts;
> -	spin_lock_irq(&counts->lock);
> +	write_lock_irq(&counts->mlock);
>  	nextpage = 0;
>  	for (j = 0; j < counts->chunks; j++) {
>  		bitmap_counter_t *bmc;
> @@ -1364,7 +1384,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
>  			counts->bp[j >> PAGE_COUNTER_SHIFT].pending
> = 0; }
>  
> -		bmc = md_bitmap_get_counter(counts, block, &blocks,
> 0);
> +		bmc = md_bitmap_get_counter(counts, block, &blocks,
> 0, 0, 0); if (!bmc) {
>  			j |= PAGE_COUNTER_MASK;
>  			continue;
> @@ -1380,7 +1400,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
>  			bitmap->allclean = 0;
>  		}
>  	}
> -	spin_unlock_irq(&counts->lock);
> +	write_unlock_irq(&counts->mlock);
>  
>  	md_bitmap_wait_writes(bitmap);
>  	/* Now start writeout on any page in NEEDWRITE that isn't
> DIRTY. @@ -1413,17 +1433,25 @@ void md_bitmap_daemon_work(struct
> mddev *mddev) 
>  static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts
> *bitmap, sector_t offset, sector_t *blocks,
> -					       int create)
> -__releases(bitmap->lock)
> -__acquires(bitmap->lock)
> +					       int create,
> spinlock_t *bmclock, int locktype) +__releases(bmclock)
> +__acquires(bmclock)
> +__releases(bitmap->mlock)
> +__acquires(bitmap->mlock)
>  {
>  	/* If 'create', we might release the lock and reclaim it.
>  	 * The lock must have been taken with interrupts enabled.
>  	 * If !create, we don't release the lock.
>  	 */
> -	sector_t chunk = offset >> bitmap->chunkshift;
> -	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
> -	unsigned long pageoff = (chunk & PAGE_COUNTER_MASK) <<
> COUNTER_BYTE_SHIFT;
> +	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> +	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift -
> (PAGE_SHIFT - SECTOR_SHIFT));
> +	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
> +	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
> +					(bits - (bitmap->chunkshift
> + SECTOR_SHIFT - PAGE_SHIFT)));
> +	unsigned long cntid = blockno & mask;
> +	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
> +	unsigned long pageoff = (cntid & PAGE_COUNTER_MASK) <<
> COUNTER_BYTE_SHIFT; +
>  	sector_t csize;
>  	int err;
>  
> @@ -1435,7 +1463,7 @@ __acquires(bitmap->lock)
>  		 */
>  		return NULL;
>  	}
> -	err = md_bitmap_checkpage(bitmap, page, create, 0);
> +	err = md_bitmap_checkpage(bitmap, page, create, 0, bmclock,
> 1); 
>  	if (bitmap->bp[page].hijacked ||
>  	    bitmap->bp[page].map == NULL)
> @@ -1461,6 +1489,28 @@ __acquires(bitmap->lock)
>  			&(bitmap->bp[page].map[pageoff]);
>  }
>  
> +/* set-association */
> +static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts
> *bitmap, sector_t offset); +
> +static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts
> *bitmap, sector_t offset) +{
> +	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> +	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift -
> (PAGE_SHIFT - SECTOR_SHIFT));
> +	unsigned long bitscnt = totblocks ? fls((totblocks - 1)) : 0;
> +	unsigned long maskcnt = ULONG_MAX << bitscnt | ~(ULONG_MAX
> << (bitscnt -
> +					(bitmap->chunkshift +
> SECTOR_SHIFT - PAGE_SHIFT)));
> +	unsigned long cntid = blockno & maskcnt;
> +
> +	unsigned long totcnts = bitmap->chunks;
> +	unsigned long bitslock = totcnts ? fls((totcnts - 1)) : 0;
> +	unsigned long masklock = ULONG_MAX << bitslock | ~(ULONG_MAX
> <<
> +					(bitslock -
> BITMAP_COUNTER_LOCK_RATIO_SHIFT));
> +	unsigned long lockid = cntid & masklock;
> +
> +	spinlock_t *bmclock = &(bitmap->bmclocks[lockid]);
> +	return bmclock;
> +}
> +
>  int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
> unsigned long sectors, int behind) {
>  	if (!bitmap)
> @@ -1480,11 +1530,15 @@ int md_bitmap_startwrite(struct bitmap
> *bitmap, sector_t offset, unsigned long s while (sectors) {
>  		sector_t blocks;
>  		bitmap_counter_t *bmc;
> +		spinlock_t *bmclock;
>  
> -		spin_lock_irq(&bitmap->counts.lock);
> -		bmc = md_bitmap_get_counter(&bitmap->counts, offset,
> &blocks, 1);
> +		bmclock = md_bitmap_get_bmclock(&bitmap->counts,
> offset);
> +		read_lock(&bitmap->counts.mlock);
> +		spin_lock_irq(bmclock);
> +		bmc = md_bitmap_get_counter(&bitmap->counts, offset,
> &blocks, 1, bmclock, 1); if (!bmc) {
> -			spin_unlock_irq(&bitmap->counts.lock);
> +			spin_unlock_irq(bmclock);
> +			read_unlock(&bitmap->counts.mlock);
>  			return 0;
>  		}
>  
> @@ -1496,7 +1550,8 @@ int md_bitmap_startwrite(struct bitmap *bitmap,
> sector_t offset, unsigned long s */
>  			prepare_to_wait(&bitmap->overflow_wait,
> &__wait, TASK_UNINTERRUPTIBLE);
> -			spin_unlock_irq(&bitmap->counts.lock);
> +			spin_unlock_irq(bmclock);
> +			read_unlock(&bitmap->counts.mlock);
>  			schedule();
>  			finish_wait(&bitmap->overflow_wait, &__wait);
>  			continue;
> @@ -1513,7 +1568,8 @@ int md_bitmap_startwrite(struct bitmap *bitmap,
> sector_t offset, unsigned long s 
>  		(*bmc)++;
>  
> -		spin_unlock_irq(&bitmap->counts.lock);
> +		spin_unlock_irq(bmclock);
> +		read_unlock(&bitmap->counts.mlock);
>  
>  		offset += blocks;
>  		if (sectors > blocks)
> @@ -1542,11 +1598,15 @@ void md_bitmap_endwrite(struct bitmap
> *bitmap, sector_t offset, sector_t blocks;
>  		unsigned long flags;
>  		bitmap_counter_t *bmc;
> +		spinlock_t *bmclock;
>  
> -		spin_lock_irqsave(&bitmap->counts.lock, flags);
> -		bmc = md_bitmap_get_counter(&bitmap->counts, offset,
> &blocks, 0);
> +		bmclock = md_bitmap_get_bmclock(&bitmap->counts,
> offset);
> +		read_lock(&bitmap->counts.mlock);
> +		spin_lock_irqsave(bmclock, flags);
> +		bmc = md_bitmap_get_counter(&bitmap->counts, offset,
> &blocks, 0, bmclock, 1); if (!bmc) {
> -			spin_unlock_irqrestore(&bitmap->counts.lock,
> flags);
> +			spin_unlock_irqrestore(bmclock, flags);
> +			read_unlock(&bitmap->counts.mlock);
>  			return;
>  		}
>  
> @@ -1568,7 +1628,8 @@ void md_bitmap_endwrite(struct bitmap *bitmap,
> sector_t offset, md_bitmap_set_pending(&bitmap->counts, offset);
>  			bitmap->allclean = 0;
>  		}
> -		spin_unlock_irqrestore(&bitmap->counts.lock, flags);
> +		spin_unlock_irqrestore(bmclock, flags);
> +		read_unlock(&bitmap->counts.mlock);
>  		offset += blocks;
>  		if (sectors > blocks)
>  			sectors -= blocks;
> @@ -1582,13 +1643,16 @@ static int __bitmap_start_sync(struct bitmap
> *bitmap, sector_t offset, sector_t int degraded)
>  {
>  	bitmap_counter_t *bmc;
> +	spinlock_t *bmclock;
>  	int rv;
>  	if (bitmap == NULL) {/* FIXME or bitmap set as 'failed' */
>  		*blocks = 1024;
>  		return 1; /* always resync if no bitmap */
>  	}
> -	spin_lock_irq(&bitmap->counts.lock);
> -	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks,
> 0);
> +	bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> +	read_lock(&bitmap->counts.mlock);
> +	spin_lock_irq(bmclock);
> +	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks,
> 0, bmclock, 1); rv = 0;
>  	if (bmc) {
>  		/* locked */
> @@ -1602,7 +1666,8 @@ static int __bitmap_start_sync(struct bitmap
> *bitmap, sector_t offset, sector_t }
>  		}
>  	}
> -	spin_unlock_irq(&bitmap->counts.lock);
> +	spin_unlock_irq(bmclock);
> +	read_unlock(&bitmap->counts.mlock);
>  	return rv;
>  }
>  
> @@ -1634,13 +1699,16 @@ void md_bitmap_end_sync(struct bitmap
> *bitmap, sector_t offset, sector_t *blocks {
>  	bitmap_counter_t *bmc;
>  	unsigned long flags;
> +	spinlock_t *bmclock;
>  
>  	if (bitmap == NULL) {
>  		*blocks = 1024;
>  		return;
>  	}
> -	spin_lock_irqsave(&bitmap->counts.lock, flags);
> -	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks,
> 0);
> +	bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> +	read_lock(&bitmap->counts.mlock);
> +	spin_lock_irqsave(bmclock, flags);
> +	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks,
> 0, bmclock, 1); if (bmc == NULL)
>  		goto unlock;
>  	/* locked */
> @@ -1657,7 +1725,8 @@ void md_bitmap_end_sync(struct bitmap *bitmap,
> sector_t offset, sector_t *blocks }
>  	}
>   unlock:
> -	spin_unlock_irqrestore(&bitmap->counts.lock, flags);
> +	spin_unlock_irqrestore(bmclock, flags);
> +	read_unlock(&bitmap->counts.mlock);
>  }
>  EXPORT_SYMBOL(md_bitmap_end_sync);
>  
> @@ -1738,10 +1807,15 @@ static void md_bitmap_set_memory_bits(struct
> bitmap *bitmap, sector_t offset, in 
>  	sector_t secs;
>  	bitmap_counter_t *bmc;
> -	spin_lock_irq(&bitmap->counts.lock);
> -	bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs,
> 1);
> +	spinlock_t *bmclock;
> +
> +	bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> +	read_lock(&bitmap->counts.mlock);
> +	spin_lock_irq(bmclock);
> +	bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs,
> 1, bmclock, 1); if (!bmc) {
> -		spin_unlock_irq(&bitmap->counts.lock);
> +		spin_unlock_irq(bmclock);
> +		read_unlock(&bitmap->counts.mlock);
>  		return;
>  	}
>  	if (!*bmc) {
> @@ -1752,7 +1826,8 @@ static void md_bitmap_set_memory_bits(struct
> bitmap *bitmap, sector_t offset, in }
>  	if (needed)
>  		*bmc |= NEEDED_MASK;
> -	spin_unlock_irq(&bitmap->counts.lock);
> +	spin_unlock_irq(bmclock);
> +	read_unlock(&bitmap->counts.mlock);
>  }
>  
>  /* dirty the memory and file bits for bitmap chunks "s" to "e" */
> @@ -1806,6 +1881,7 @@ void md_bitmap_free(struct bitmap *bitmap)
>  {
>  	unsigned long k, pages;
>  	struct bitmap_page *bp;
> +	spinlock_t *bmclocks;
>  
>  	if (!bitmap) /* there was no bitmap */
>  		return;
> @@ -1826,6 +1902,7 @@ void md_bitmap_free(struct bitmap *bitmap)
>  
>  	bp = bitmap->counts.bp;
>  	pages = bitmap->counts.pages;
> +	bmclocks = bitmap->counts.bmclocks;
>  
>  	/* free all allocated memory */
>  
> @@ -1834,6 +1911,7 @@ void md_bitmap_free(struct bitmap *bitmap)
>  			if (bp[k].map && !bp[k].hijacked)
>  				kfree(bp[k].map);
>  	kfree(bp);
> +	kfree(bmclocks);
>  	kfree(bitmap);
>  }
>  EXPORT_SYMBOL(md_bitmap_free);
> @@ -1900,7 +1978,9 @@ struct bitmap *md_bitmap_create(struct mddev
> *mddev, int slot) if (!bitmap)
>  		return ERR_PTR(-ENOMEM);
>  
> -	spin_lock_init(&bitmap->counts.lock);
> +	/* initialize metadata lock */
> +	rwlock_init(&bitmap->counts.mlock);
> +
>  	atomic_set(&bitmap->pending_writes, 0);
>  	init_waitqueue_head(&bitmap->write_wait);
>  	init_waitqueue_head(&bitmap->overflow_wait);
> @@ -2143,6 +2223,8 @@ int md_bitmap_resize(struct bitmap *bitmap,
> sector_t blocks, int ret = 0;
>  	long pages;
>  	struct bitmap_page *new_bp;
> +	spinlock_t *new_bmclocks;
> +	int num_bmclocks, i;
>  
>  	if (bitmap->storage.file && !init) {
>  		pr_info("md: cannot resize file-based bitmap\n");
> @@ -2211,7 +2293,7 @@ int md_bitmap_resize(struct bitmap *bitmap,
> sector_t blocks, memcpy(page_address(store.sb_page),
>  		       page_address(bitmap->storage.sb_page),
>  		       sizeof(bitmap_super_t));
> -	spin_lock_irq(&bitmap->counts.lock);
> +	write_lock_irq(&bitmap->counts.mlock);
>  	md_bitmap_file_unmap(&bitmap->storage);
>  	bitmap->storage = store;
>  
> @@ -2227,18 +2309,28 @@ int md_bitmap_resize(struct bitmap *bitmap,
> sector_t blocks, blocks = min(old_counts.chunks <<
> old_counts.chunkshift, chunks << chunkshift);
>  
> +	/* initialize bmc locks */
> +	num_bmclocks = DIV_ROUND_UP(chunks,
> BITMAP_COUNTER_LOCK_RATIO); +
> +	new_bmclocks = kvcalloc(num_bmclocks, sizeof(*new_bmclocks),
> GFP_KERNEL);
> +	bitmap->counts.bmclocks = new_bmclocks;
> +	for (i = 0; i < num_bmclocks; ++i) {
> +		spinlock_t *bmclock = &(bitmap->counts.bmclocks)[i];
> +
> +		spin_lock_init(bmclock);
> +	}
> +
>  	/* For cluster raid, need to pre-allocate bitmap */
>  	if (mddev_is_clustered(bitmap->mddev)) {
>  		unsigned long page;
>  		for (page = 0; page < pages; page++) {
> -			ret = md_bitmap_checkpage(&bitmap->counts,
> page, 1, 1);
> +			ret = md_bitmap_checkpage(&bitmap->counts,
> page, 1, 1, 0, 0); if (ret) {
>  				unsigned long k;
>  
>  				/* deallocate the page memory */
> -				for (k = 0; k < page; k++) {
> +				for (k = 0; k < page; k++)
>  					kfree(new_bp[k].map);
> -				}
>  				kfree(new_bp);
>  
>  				/* restore some fields from
> old_counts */ @@ -2261,11 +2353,12 @@ int md_bitmap_resize(struct
> bitmap *bitmap, sector_t blocks, bitmap_counter_t *bmc_old, *bmc_new;
>  		int set;
>  
> -		bmc_old = md_bitmap_get_counter(&old_counts, block,
> &old_blocks, 0);
> +		bmc_old = md_bitmap_get_counter(&old_counts, block,
> &old_blocks, 0, 0, 0); set = bmc_old && NEEDED(*bmc_old);
>  
>  		if (set) {
> -			bmc_new =
> md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);
> +			bmc_new =
> md_bitmap_get_counter(&bitmap->counts, block, &new_blocks,
> +
> 		1, 0, 0); if (bmc_new) {
>  				if (*bmc_new == 0) {
>  					/* need to set on-disk bits
> too. */ @@ -2301,7 +2394,7 @@ int md_bitmap_resize(struct bitmap
> *bitmap, sector_t blocks, int i;
>  		while (block < (chunks << chunkshift)) {
>  			bitmap_counter_t *bmc;
> -			bmc = md_bitmap_get_counter(&bitmap->counts,
> block, &new_blocks, 1);
> +			bmc = md_bitmap_get_counter(&bitmap->counts,
> block, &new_blocks, 1, 0, 0); if (bmc) {
>  				/* new space.  It needs to be
> resynced, so
>  				 * we set NEEDED_MASK.
> @@ -2317,7 +2410,7 @@ int md_bitmap_resize(struct bitmap *bitmap,
> sector_t blocks, for (i = 0; i < bitmap->storage.file_pages; i++)
>  			set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
>  	}
> -	spin_unlock_irq(&bitmap->counts.lock);
> +	write_unlock_irq(&bitmap->counts.mlock);
>  
>  	if (!init) {
>  		md_bitmap_unplug(bitmap);
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index bb9eb418780a..1b9c36bb73ed 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -2,7 +2,9 @@
>  /*
>   * bitmap.h: Copyright (C) Peter T. Breuer (ptb@ot.uc3m.es) 2003
>   *
> - * additions: Copyright (C) 2003-2004, Paul Clements, SteelEye
> Technology, Inc.
> + * additions:
> + *		Copyright (C) 2003-2004, Paul Clements, SteelEye
> Technology, Inc.
> + *		Copyright (C) 2022-2023, Shushu Yi
> (firnyee@gmail.com) */
>  #ifndef BITMAP_H
>  #define BITMAP_H 1
> @@ -103,6 +105,9 @@ typedef __u16 bitmap_counter_t;
>  #define PAGE_COUNTER_MASK  (PAGE_COUNTER_RATIO - 1)
>  
>  #define BITMAP_BLOCK_SHIFT 9
> +/* how many counters share the same bmclock? */
> +#define BITMAP_COUNTER_LOCK_RATIO_SHIFT 0
> +#define BITMAP_COUNTER_LOCK_RATIO (1 <<
> BITMAP_COUNTER_LOCK_RATIO_SHIFT) 
>  #endif
>  
> @@ -116,7 +121,7 @@ typedef __u16 bitmap_counter_t;
>  enum bitmap_state {
>  	BITMAP_STALE	   = 1,  /* the bitmap file is out of
> date or had -EIO */ BITMAP_WRITE_ERROR = 2, /* A write error has
> occurred */
> -	BITMAP_HOSTENDIAN  =15,
> +	BITMAP_HOSTENDIAN  = 15,
>  };
>  
>  /* the superblock at the front of the bitmap file -- little endian */
> @@ -180,7 +185,8 @@ struct bitmap_page {
>  struct bitmap {
>  
>  	struct bitmap_counts {
> -		spinlock_t lock;
> +		rwlock_t mlock;				/*
> lock for metadata */
> +		spinlock_t *bmclocks;		/* locks for
> bmc */ struct bitmap_page *bp;
>  		unsigned long pages;		/* total number
> of pages
>  						 * in the bitmap */

