Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADAA174EFA;
	Mon, 19 Aug 2024 15:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724079635; cv=none; b=gxNd8TfrKEekWUbGIttM1LXPAjPp3yyMyteKUsRxreGJRO6wZBw53UfcBzTKreekjTbnVDwgaZWvKwMpTR2HbeCGIRRsx//5jSbLuYUv6ZZNw24ilR/Pq/C4ZJzBfSN+/n/zJZKfRyJLUjO1CkrkGLFej0rTI1L2NnS4Eu3FXhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724079635; c=relaxed/simple;
	bh=GHzT2N9LjCqSMb5MyrHcLwGQbHLlvzJm7jH3a+jhedI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RInN993pNNj+kEGNBfUiXVkxuewjlX+m3EZbgiQXIRuDsJvMrR9+2dhPPSaGBj08vxyfW/Y/+cCFWlSD3gNakzY3xUP4Ugr5c7Kgabotl7Zth8nhEgng5G4Au/IYl1kbhYZ1OmCRdmajQnHy2VbNZ3dXcVr0XfHAyiYdn8ksJr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NW+qX5Uk; arc=none smtp.client-ip=209.85.215.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NW+qX5Uk"
Received: by mail-pg1-f194.google.com with SMTP id 41be03b00d2f7-7c3e1081804so2860431a12.3;
        Mon, 19 Aug 2024 08:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724079630; x=1724684430; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kaminwM+y1QTp/CtYOenguNIVgmzng10w3F4ZCrybu4=;
        b=NW+qX5Uk9x4JbOpM6+0fUiI2FRiqNuSqAQQ8oQuV6f7hYd1ogI6zrH/UthuHSoCAqO
         xmC9oqZGXLvw+A7WQ5z09Rxdv9NK0OUkdOwJtIbjsawiZRD5u8dPTjaJjxl9CuPuK1Qc
         bYmynp19fRIUUMyTcr3c22YnYBMU+3pPwTtgZ2nRjSfMZoXaHU57rCUK8O7rR5qGWlVF
         9vhkSmsdkPnjMwEkJBQFLbVxIrUpWwh9Tni8inG7IJKShQiRQqUoCV7ArUiFHBIDTaMa
         lDAjFH7YX8kBs6tb7S/pu2B7XsbxObaFe+xvvn1wVYhfbWxfMwA+KAZq0u0WRIss/w7c
         Zafg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724079630; x=1724684430;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kaminwM+y1QTp/CtYOenguNIVgmzng10w3F4ZCrybu4=;
        b=QwUuqAqDS8CdMqUh83fp02quynLoYuZQEy3MXikkbegq5E4UMAMPns6syRhkFDt+2I
         naBz7PQLtMine87AkRLdvK7mHuJxEeJOKcNCYSuqQ6G20O0JTvqvNSxvn6ZNcvmNzfdq
         89zxfqB8bS0zXpHwRfuFTQyqJVux5hnl4n9RweUE2N0kv5Fw6K6Vz6zSSwiO1CWm6srY
         v+pLINkYRMF00l8fgAIbccvzuBGAwrsW2+83NYp//CLsyOv3L0snZDW84hIqJI6PEX+x
         hgupy+zJbh9B8qhH4PFgvfQdkw7CzrSX+TKuZ6ipO8oY0oZ4XqLHdghxSWjoWeJt/iae
         I7tw==
X-Forwarded-Encrypted: i=1; AJvYcCVxD4ef4WMsAxZWQ5Wyr8PnVRJa3F+ucOgqtmOa94RFcDY7uqQazymAZHsH+3pkBC8F5PVlTCWt32aMv4utzBnI9dbZAdEg12fPIuxVDbkIHGIKo8GhWDUody9/HT9TPHTiXgcD/lScow==
X-Gm-Message-State: AOJu0Yyhk57j9EZLUQzfIN+UzaZcXiwmBesvEF7f3feQs7ucxXVYUiQ6
	UcVJKhHN7h1jyZYGCfzcPTGLGh4y0sr5nbFkTg+JHE7tXbI1WMgD
X-Google-Smtp-Source: AGHT+IEnR+EmQosQtpx3wY59evA0KRzeZOA9UTtgEVAThceNaIjTbzEDaJZYHZuqPIFYBu0lSIrXpg==
X-Received: by 2002:a17:90b:190a:b0:2c9:6ad9:b75b with SMTP id 98e67ed59e1d1-2d3e0e4210emr8212135a91.40.1724079629668;
        Mon, 19 Aug 2024 08:00:29 -0700 (PDT)
Received: from [192.168.1.31] (ip68-231-38-120.ph.ph.cox.net. [68.231.38.120])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3faea6b6csm6082337a91.35.2024.08.19.08.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 08:00:29 -0700 (PDT)
Message-ID: <d4635229-c239-4f12-8e43-f71ef387885f@gmail.com>
Date: Mon, 19 Aug 2024 08:00:27 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V7] md/bitmap: Optimize lock contention.
To: Shushu Yi <teddyxym@outlook.com>, linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai3@huawei.com, linux-kernel@vger.kernel.org,
 paul.e.luse@intel.com, firnyee@gmail.com, hch@infradead.org
References: <SJ0PR10MB57411EB574BA6DD7EC82C557D8832@SJ0PR10MB5741.namprd10.prod.outlook.com>
Content-Language: en-US
From: Paul E Luse <paulluselinux@gmail.com>
In-Reply-To: <SJ0PR10MB57411EB574BA6DD7EC82C557D8832@SJ0PR10MB5741.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/24 6:36 AM, Shushu Yi wrote:
> Optimize scattered address space. Achieves significant improvements in
> both throughput and latency.
> 
> Maximize thread-level parallelism and reduce CPU suspension time caused
> by lock contention. Achieve increased overall storage throughput by
> 89.4% on a system with four PCIe 4.0 SSDs. (Set the iodepth to 32 and
> employ libaio. Configure the I/O size as 4 KB with sequential write and
> 16 threads. In RAID5 consist of 2+1 1TB Samsung 980Pro SSDs, throughput
> went from 5218MB/s to 9884MB/s.)
> 
> Specifically:
> Customize different types of lock structures (mlock and bmclocks) to
> manage data and metadata by their own characteristics. Scatter each
> segment across the entire address range in the storage such that CPU
> threads can be interleaved to access different segments.
> The counter lock is also used to protect the metadata update of the
> counter table. Modifying both the counter values and their metadata
> simultaneously can result in memory faults. mdraid rarely updates the
> metadata of the counter table. Thus, employ a readers-writer lock
> mechanism to protect the metadata, which can reap the most benefits
> from this condition.
> Before updating the metadata, the CPU thread acquires the writer lock.
> Otherwise, if the CPU threads need to revise the counter values, they
> apply for the reader locks and the counter locks successively.
> Sequential stripe heads are spread across different locations in the
> SSDs via a configurable hash function rather than mapping to a
> continuous SSD space. Thus, sequential stripe heads are dispersed
> uniformly across the whole space. Sequential write requests are
> shuffled to access scattered space. Can effectively reduce the counter
> preemption.
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
> V4 -> V5: Resolved a adress conflict on main (commit
> f0e729af2eb6bee9eb58c4df1087f14ebaefe26b (HEAD -> md-6.10, tag:
> md-6.10-20240502, origin/md-6.10)).
> V5 -> V6: Restored changes to the number of NR_STRIPE_HASH_LOCKS. Set
> the maximum number of bmclocks (65536) to prevent excessive memory
> usage. Optimized the number of bmclocks in RAID5 when the capacity of
> each SSD is less than or equal to 4TB, and still performs well when
> the capacity of each SSD is greater than 4TB.
> V6 -> V7: Changed according to Song Liu's comments: redundant
> "locktypes" were subtracted, unnecessary fixes were removed, NULL
> Pointers were changed from "0" to "NULL", code comments were added, and
> commit logs were refined.
> 


Thanks Shushu!  It's been a while so I'd like to runa full perf sweep 
and at at least one run with data integrity checking.  I'll aim to get 
that done over the next week or so, it might bleed into early next week 
but it will get done :)

-Paul

> ---
>   drivers/md/md-bitmap.c | 198 +++++++++++++++++++++++++++++++----------
>   drivers/md/md-bitmap.h |  21 ++++-
>   2 files changed, 169 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 08232d8dc815..52958748f2a3 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -47,10 +47,12 @@ static inline char *bmname(struct bitmap *bitmap)
>    * if we find our page, we increment the page's refcount so that it stays
>    * allocated while we're using it
>    */
> -static int md_bitmap_checkpage(struct bitmap_counts *bitmap,
> -			       unsigned long page, int create, int no_hijack)
> -__releases(bitmap->lock)
> -__acquires(bitmap->lock)
> +static int md_bitmap_checkpage(struct bitmap_counts *bitmap, unsigned long page,
> +			       int create, int no_hijack, spinlock_t *bmclock)
> +__releases(bmclock)
> +__acquires(bmclock)
> +__releases(bitmap->mlock)
> +__acquires(bitmap->mlock)
>   {
>   	unsigned char *mappage;
>   
> @@ -65,8 +67,10 @@ __acquires(bitmap->lock)
>   		return -ENOENT;
>   
>   	/* this page has not been allocated yet */
> -
> -	spin_unlock_irq(&bitmap->lock);
> +	if (bmclock)
> +		spin_unlock_irq(bmclock); /* lock for bmc */
> +	else
> +		write_unlock_irq(&bitmap->mlock); /* lock for metadata */
>   	/* It is possible that this is being called inside a
>   	 * prepare_to_wait/finish_wait loop from raid5c:make_request().
>   	 * In general it is not permitted to sleep in that context as it
> @@ -81,7 +85,11 @@ __acquires(bitmap->lock)
>   	 */
>   	sched_annotate_sleep();
>   	mappage = kzalloc(PAGE_SIZE, GFP_NOIO);
> -	spin_lock_irq(&bitmap->lock);
> +
> +	if (bmclock)
> +		spin_lock_irq(bmclock);  /* lock for bmc */
> +	else
> +		write_lock_irq(&bitmap->mlock); /* lock for metadata */
>   
>   	if (mappage == NULL) {
>   		pr_debug("md/bitmap: map page allocation failed, hijacking\n");
> @@ -1248,16 +1256,35 @@ void md_bitmap_write_all(struct bitmap *bitmap)
>   static void md_bitmap_count_page(struct bitmap_counts *bitmap,
>   				 sector_t offset, int inc)
>   {
> -	sector_t chunk = offset >> bitmap->chunkshift;
> -	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
> +    /*
> +     * The stripe heads are spread across different locations in the
> +     * SSDs via a configurable hash function rather than mapping to a
> +     * continuous SSD space.
> +     * Sequential write requests are shuffled to different counter to
> +     * reduce the counter preemption.
> +     */
> +	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> +	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - (PAGE_SHIFT - SECTOR_SHIFT));
> +	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
> +	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
> +					(bits - (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
> +	unsigned long cntid = blockno & mask;
> +	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
> +
>   	bitmap->bp[page].count += inc;
>   	md_bitmap_checkfree(bitmap, page);
>   }
>   
>   static void md_bitmap_set_pending(struct bitmap_counts *bitmap, sector_t offset)
>   {
> -	sector_t chunk = offset >> bitmap->chunkshift;
> -	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
> +	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> +	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - (PAGE_SHIFT - SECTOR_SHIFT));
> +	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
> +	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
> +					(bits - (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
> +	unsigned long cntid = blockno & mask;
> +	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
> +
>   	struct bitmap_page *bp = &bitmap->bp[page];
>   
>   	if (!bp->pending)
> @@ -1266,7 +1293,7 @@ static void md_bitmap_set_pending(struct bitmap_counts *bitmap, sector_t offset)
>   
>   static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts *bitmap,
>   					       sector_t offset, sector_t *blocks,
> -					       int create);
> +					       int create, spinlock_t *bmclock);
>   
>   static void mddev_set_timeout(struct mddev *mddev, unsigned long timeout,
>   			      bool force)
> @@ -1349,7 +1376,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
>   	 * decrement and handle accordingly.
>   	 */
>   	counts = &bitmap->counts;
> -	spin_lock_irq(&counts->lock);
> +	write_lock_irq(&counts->mlock);
>   	nextpage = 0;
>   	for (j = 0; j < counts->chunks; j++) {
>   		bitmap_counter_t *bmc;
> @@ -1364,7 +1391,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
>   			counts->bp[j >> PAGE_COUNTER_SHIFT].pending = 0;
>   		}
>   
> -		bmc = md_bitmap_get_counter(counts, block, &blocks, 0);
> +		bmc = md_bitmap_get_counter(counts, block, &blocks, 0, NULL);
>   		if (!bmc) {
>   			j |= PAGE_COUNTER_MASK;
>   			continue;
> @@ -1380,7 +1407,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
>   			bitmap->allclean = 0;
>   		}
>   	}
> -	spin_unlock_irq(&counts->lock);
> +	write_unlock_irq(&counts->mlock);
>   
>   	md_bitmap_wait_writes(bitmap);
>   	/* Now start writeout on any page in NEEDWRITE that isn't DIRTY.
> @@ -1413,17 +1440,25 @@ void md_bitmap_daemon_work(struct mddev *mddev)
>   
>   static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts *bitmap,
>   					       sector_t offset, sector_t *blocks,
> -					       int create)
> -__releases(bitmap->lock)
> -__acquires(bitmap->lock)
> +					       int create, spinlock_t *bmclock)
> +__releases(bmclock)
> +__acquires(bmclock)
> +__releases(bitmap->mlock)
> +__acquires(bitmap->mlock)
>   {
>   	/* If 'create', we might release the lock and reclaim it.
>   	 * The lock must have been taken with interrupts enabled.
>   	 * If !create, we don't release the lock.
>   	 */
> -	sector_t chunk = offset >> bitmap->chunkshift;
> -	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
> -	unsigned long pageoff = (chunk & PAGE_COUNTER_MASK) << COUNTER_BYTE_SHIFT;
> +	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> +	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - (PAGE_SHIFT - SECTOR_SHIFT));
> +	unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
> +	unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
> +					(bits - (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
> +	unsigned long cntid = blockno & mask;
> +	unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
> +	unsigned long pageoff = (cntid & PAGE_COUNTER_MASK) << COUNTER_BYTE_SHIFT;
> +
>   	sector_t csize = ((sector_t)1) << bitmap->chunkshift;
>   	int err;
>   
> @@ -1436,7 +1471,7 @@ __acquires(bitmap->lock)
>   		*blocks = csize - (offset & (csize - 1));
>   		return NULL;
>   	}
> -	err = md_bitmap_checkpage(bitmap, page, create, 0);
> +	err = md_bitmap_checkpage(bitmap, page, create, 0, bmclock);
>   
>   	if (bitmap->bp[page].hijacked ||
>   	    bitmap->bp[page].map == NULL)
> @@ -1461,6 +1496,28 @@ __acquires(bitmap->lock)
>   			&(bitmap->bp[page].map[pageoff]);
>   }
>   
> +/* set-association */
> +static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts *bitmap, sector_t offset);
> +
> +static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts *bitmap, sector_t offset)
> +{
> +	sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> +	sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - (PAGE_SHIFT - SECTOR_SHIFT));
> +	unsigned long bitscnt = totblocks ? fls((totblocks - 1)) : 0;
> +	unsigned long maskcnt = ULONG_MAX << bitscnt | ~(ULONG_MAX << (bitscnt -
> +					(bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
> +	unsigned long cntid = blockno & maskcnt;
> +
> +	unsigned long totcnts = bitmap->chunks;
> +	unsigned long bitslock = totcnts ? fls((totcnts - 1)) : 0;
> +	unsigned long masklock = ULONG_MAX << bitslock | ~(ULONG_MAX <<
> +					(bitslock - BITMAP_COUNTER_LOCK_RATIO_SHIFT));
> +	unsigned long lockid = cntid & masklock;
> +
> +	spinlock_t *bmclock = &(bitmap->bmclocks[lockid]);
> +	return bmclock;
> +}
> +
>   int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors, int behind)
>   {
>   	if (!bitmap)
> @@ -1480,11 +1537,15 @@ int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long s
>   	while (sectors) {
>   		sector_t blocks;
>   		bitmap_counter_t *bmc;
> +		spinlock_t *bmclock;
>   
> -		spin_lock_irq(&bitmap->counts.lock);
> -		bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 1);
> +		bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> +		read_lock(&bitmap->counts.mlock);
> +		spin_lock_irq(bmclock);
> +		bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 1, bmclock);
>   		if (!bmc) {
> -			spin_unlock_irq(&bitmap->counts.lock);
> +			spin_unlock_irq(bmclock);
> +			read_unlock(&bitmap->counts.mlock);
>   			return 0;
>   		}
>   
> @@ -1496,7 +1557,8 @@ int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long s
>   			 */
>   			prepare_to_wait(&bitmap->overflow_wait, &__wait,
>   					TASK_UNINTERRUPTIBLE);
> -			spin_unlock_irq(&bitmap->counts.lock);
> +			spin_unlock_irq(bmclock);
> +			read_unlock(&bitmap->counts.mlock);
>   			schedule();
>   			finish_wait(&bitmap->overflow_wait, &__wait);
>   			continue;
> @@ -1513,7 +1575,8 @@ int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long s
>   
>   		(*bmc)++;
>   
> -		spin_unlock_irq(&bitmap->counts.lock);
> +		spin_unlock_irq(bmclock);
> +		read_unlock(&bitmap->counts.mlock);
>   
>   		offset += blocks;
>   		if (sectors > blocks)
> @@ -1542,11 +1605,15 @@ void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
>   		sector_t blocks;
>   		unsigned long flags;
>   		bitmap_counter_t *bmc;
> +		spinlock_t *bmclock;
>   
> -		spin_lock_irqsave(&bitmap->counts.lock, flags);
> -		bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 0);
> +		bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> +		read_lock(&bitmap->counts.mlock);
> +		spin_lock_irqsave(bmclock, flags);
> +		bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 0, bmclock);
>   		if (!bmc) {
> -			spin_unlock_irqrestore(&bitmap->counts.lock, flags);
> +			spin_unlock_irqrestore(bmclock, flags);
> +			read_unlock(&bitmap->counts.mlock);
>   			return;
>   		}
>   
> @@ -1568,7 +1635,8 @@ void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
>   			md_bitmap_set_pending(&bitmap->counts, offset);
>   			bitmap->allclean = 0;
>   		}
> -		spin_unlock_irqrestore(&bitmap->counts.lock, flags);
> +		spin_unlock_irqrestore(bmclock, flags);
> +		read_unlock(&bitmap->counts.mlock);
>   		offset += blocks;
>   		if (sectors > blocks)
>   			sectors -= blocks;
> @@ -1582,13 +1650,16 @@ static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t
>   			       int degraded)
>   {
>   	bitmap_counter_t *bmc;
> +	spinlock_t *bmclock;
>   	int rv;
>   	if (bitmap == NULL) {/* FIXME or bitmap set as 'failed' */
>   		*blocks = 1024;
>   		return 1; /* always resync if no bitmap */
>   	}
> -	spin_lock_irq(&bitmap->counts.lock);
> -	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
> +	bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> +	read_lock(&bitmap->counts.mlock);
> +	spin_lock_irq(bmclock);
> +	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0, bmclock);
>   	rv = 0;
>   	if (bmc) {
>   		/* locked */
> @@ -1602,7 +1673,8 @@ static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t
>   			}
>   		}
>   	}
> -	spin_unlock_irq(&bitmap->counts.lock);
> +	spin_unlock_irq(bmclock);
> +	read_unlock(&bitmap->counts.mlock);
>   	return rv;
>   }
>   
> @@ -1634,13 +1706,16 @@ void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks
>   {
>   	bitmap_counter_t *bmc;
>   	unsigned long flags;
> +	spinlock_t *bmclock;
>   
>   	if (bitmap == NULL) {
>   		*blocks = 1024;
>   		return;
>   	}
> -	spin_lock_irqsave(&bitmap->counts.lock, flags);
> -	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
> +	bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> +	read_lock(&bitmap->counts.mlock);
> +	spin_lock_irqsave(bmclock, flags);
> +	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0, bmclock);
>   	if (bmc == NULL)
>   		goto unlock;
>   	/* locked */
> @@ -1657,7 +1732,8 @@ void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks
>   		}
>   	}
>    unlock:
> -	spin_unlock_irqrestore(&bitmap->counts.lock, flags);
> +	spin_unlock_irqrestore(bmclock, flags);
> +	read_unlock(&bitmap->counts.mlock);
>   }
>   EXPORT_SYMBOL(md_bitmap_end_sync);
>   
> @@ -1738,10 +1814,15 @@ static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, in
>   
>   	sector_t secs;
>   	bitmap_counter_t *bmc;
> -	spin_lock_irq(&bitmap->counts.lock);
> -	bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs, 1);
> +	spinlock_t *bmclock;
> +
> +	bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> +	read_lock(&bitmap->counts.mlock);
> +	spin_lock_irq(bmclock);
> +	bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs, 1, bmclock);
>   	if (!bmc) {
> -		spin_unlock_irq(&bitmap->counts.lock);
> +		spin_unlock_irq(bmclock);
> +		read_unlock(&bitmap->counts.mlock);
>   		return;
>   	}
>   	if (!*bmc) {
> @@ -1752,7 +1833,8 @@ static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, in
>   	}
>   	if (needed)
>   		*bmc |= NEEDED_MASK;
> -	spin_unlock_irq(&bitmap->counts.lock);
> +	spin_unlock_irq(bmclock);
> +	read_unlock(&bitmap->counts.mlock);
>   }
>   
>   /* dirty the memory and file bits for bitmap chunks "s" to "e" */
> @@ -1806,6 +1888,7 @@ void md_bitmap_free(struct bitmap *bitmap)
>   {
>   	unsigned long k, pages;
>   	struct bitmap_page *bp;
> +	spinlock_t *bmclocks;
>   
>   	if (!bitmap) /* there was no bitmap */
>   		return;
> @@ -1826,6 +1909,7 @@ void md_bitmap_free(struct bitmap *bitmap)
>   
>   	bp = bitmap->counts.bp;
>   	pages = bitmap->counts.pages;
> +	bmclocks = bitmap->counts.bmclocks;
>   
>   	/* free all allocated memory */
>   
> @@ -1834,6 +1918,7 @@ void md_bitmap_free(struct bitmap *bitmap)
>   			if (bp[k].map && !bp[k].hijacked)
>   				kfree(bp[k].map);
>   	kfree(bp);
> +	kfree(bmclocks);
>   	kfree(bitmap);
>   }
>   EXPORT_SYMBOL(md_bitmap_free);
> @@ -1900,7 +1985,9 @@ struct bitmap *md_bitmap_create(struct mddev *mddev, int slot)
>   	if (!bitmap)
>   		return ERR_PTR(-ENOMEM);
>   
> -	spin_lock_init(&bitmap->counts.lock);
> +	/* initialize metadata lock */
> +	rwlock_init(&bitmap->counts.mlock);
> +
>   	atomic_set(&bitmap->pending_writes, 0);
>   	init_waitqueue_head(&bitmap->write_wait);
>   	init_waitqueue_head(&bitmap->overflow_wait);
> @@ -2143,6 +2230,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>   	int ret = 0;
>   	long pages;
>   	struct bitmap_page *new_bp;
> +	spinlock_t *new_bmclocks;
> +	int num_bmclocks, i;
>   
>   	if (bitmap->storage.file && !init) {
>   		pr_info("md: cannot resize file-based bitmap\n");
> @@ -2211,7 +2300,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>   		memcpy(page_address(store.sb_page),
>   		       page_address(bitmap->storage.sb_page),
>   		       sizeof(bitmap_super_t));
> -	spin_lock_irq(&bitmap->counts.lock);
> +	write_lock_irq(&bitmap->counts.mlock);
>   	md_bitmap_file_unmap(&bitmap->storage);
>   	bitmap->storage = store;
>   
> @@ -2227,11 +2316,23 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>   	blocks = min(old_counts.chunks << old_counts.chunkshift,
>   		     chunks << chunkshift);
>   
> +	/* initialize bmc locks */
> +	num_bmclocks = DIV_ROUND_UP(chunks, BITMAP_COUNTER_LOCK_RATIO);
> +	num_bmclocks = min(num_bmclocks, BITMAP_COUNTER_LOCK_MAX);
> +
> +	new_bmclocks = kvcalloc(num_bmclocks, sizeof(*new_bmclocks), GFP_KERNEL);
> +	bitmap->counts.bmclocks = new_bmclocks;
> +	for (i = 0; i < num_bmclocks; ++i) {
> +		spinlock_t *bmclock = &(bitmap->counts.bmclocks)[i];
> +
> +		spin_lock_init(bmclock);
> +	}
> +
>   	/* For cluster raid, need to pre-allocate bitmap */
>   	if (mddev_is_clustered(bitmap->mddev)) {
>   		unsigned long page;
>   		for (page = 0; page < pages; page++) {
> -			ret = md_bitmap_checkpage(&bitmap->counts, page, 1, 1);
> +			ret = md_bitmap_checkpage(&bitmap->counts, page, 1, 1, NULL);
>   			if (ret) {
>   				unsigned long k;
>   
> @@ -2261,11 +2362,12 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>   		bitmap_counter_t *bmc_old, *bmc_new;
>   		int set;
>   
> -		bmc_old = md_bitmap_get_counter(&old_counts, block, &old_blocks, 0);
> +		bmc_old = md_bitmap_get_counter(&old_counts, block, &old_blocks, 0, NULL);
>   		set = bmc_old && NEEDED(*bmc_old);
>   
>   		if (set) {
> -			bmc_new = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);
> +			bmc_new = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks,
> +										1, NULL);
>   			if (bmc_new) {
>   				if (*bmc_new == 0) {
>   					/* need to set on-disk bits too. */
> @@ -2301,7 +2403,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>   		int i;
>   		while (block < (chunks << chunkshift)) {
>   			bitmap_counter_t *bmc;
> -			bmc = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);
> +			bmc = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1, NULL);
>   			if (bmc) {
>   				/* new space.  It needs to be resynced, so
>   				 * we set NEEDED_MASK.
> @@ -2317,7 +2419,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>   		for (i = 0; i < bitmap->storage.file_pages; i++)
>   			set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
>   	}
> -	spin_unlock_irq(&bitmap->counts.lock);
> +	write_unlock_irq(&bitmap->counts.mlock);
>   
>   	if (!init) {
>   		md_bitmap_unplug(bitmap);
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index bb9eb418780a..3de5b9f09ac8 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -2,7 +2,9 @@
>   /*
>    * bitmap.h: Copyright (C) Peter T. Breuer (ptb@ot.uc3m.es) 2003
>    *
> - * additions: Copyright (C) 2003-2004, Paul Clements, SteelEye Technology, Inc.
> + * additions:
> + *		Copyright (C) 2003-2004, Paul Clements, SteelEye Technology, Inc.
> + *		Copyright (C) 2022-2023, Shushu Yi (firnyee@gmail.com)
>    */
>   #ifndef BITMAP_H
>   #define BITMAP_H 1
> @@ -103,6 +105,10 @@ typedef __u16 bitmap_counter_t;
>   #define PAGE_COUNTER_MASK  (PAGE_COUNTER_RATIO - 1)
>   
>   #define BITMAP_BLOCK_SHIFT 9
> +/* how many counters share the same bmclock? */
> +#define BITMAP_COUNTER_LOCK_RATIO_SHIFT 0
> +#define BITMAP_COUNTER_LOCK_RATIO (1 << BITMAP_COUNTER_LOCK_RATIO_SHIFT)
> +#define BITMAP_COUNTER_LOCK_MAX 65536
>   
>   #endif
>   
> @@ -180,7 +186,18 @@ struct bitmap_page {
>   struct bitmap {
>   
>   	struct bitmap_counts {
> -		spinlock_t lock;
> +		/*
> +		 * Customize different types of lock structures to manage
> +		 * data and metadata.
> +		 * Split the counter table into multiple segments and assigns a
> +		 * dedicated lock to each segment.  The counters in the counter
> +		 * table, which map to neighboring stripe blocks, are interleaved
> +		 * across different segments.
> +		 * CPU threads that target different segments can acquire the locks
> +		 * simultaneously, resulting in better thread-level parallelism.
> +		 */
> +		rwlock_t mlock;				/* lock for metadata */
> +		spinlock_t *bmclocks;		/* locks for bmc */
>   		struct bitmap_page *bp;
>   		unsigned long pages;		/* total number of pages
>   						 * in the bitmap */

