Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7543C1B0F25;
	Tue, 10 Dec 2024 21:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733866522; cv=none; b=RwQcBms0DVUdrx1Q7fYQBD+zfxi1lMXPuQ/a1UP+qfcSGtNZWvhzLrJo53hrODud9Fvke4lvPx9cLpVrc9AUxBuItOCTvq1v0HhsCa+WjJrNcWqmfvyhpbcJebsymGTmKZaxGkXJIegxmKmxvViowHGTX5Ztq0Sz1zoFN2kSEWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733866522; c=relaxed/simple;
	bh=Yc0TX4h6e7uxi0GZ5WvtUaKu/wbgjnJsBWuONWjozmo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bkuQ14R/dONytw7/y+EcYGWeCOBFiHprhhm1ws/YHsu1Ly9OkeFiKPKytMZy/xK7eWDjdkEAkBL4Zp6kM6uJL5BSBI+H+VdpdwTD97F9HOazfAMriS9bPqWmiSOiazFskZrfAItYz7RzTPniWKhveGq39SgeaIAk9IZiHZFIWRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lDqp2eMI; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lDqp2eMI"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-21654fdd5daso24015235ad.1;
        Tue, 10 Dec 2024 13:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733866520; x=1734471320; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NUp4QIrFZDHFMKlhwx3XvEYKi3ssFMMpt4MmuhkRTYY=;
        b=lDqp2eMICFQUx6uc2iM0zhIvuNaplhPj5VduMH4mgG5WnATIAJCbRBDXMzu+692l2+
         jF56YzjWxFb9pTSlqLGdwfr+A4JhKncBYNJ5UZVHsFjOTkSRPQYqzmDBpUy43Kqm2RwM
         zKEDrPn96kf1PCOJEU4Pu75uyWvAA7jHSNEn6xlGhDU2U36uiPQ4eu1wX8wswct81nTg
         erICPcAI2rSVBKA2sjLPBkImBR2Bjlxthh20XjaNxeS0TpLcSzMx5pzUqYtbMaRXYwUd
         NReCKvLCCCfLnVXKhoGfh7+wb9qD37FM9hRjkIR97wiGp9i3nAakJWtcVUzYpiH5iXKl
         dLOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733866520; x=1734471320;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NUp4QIrFZDHFMKlhwx3XvEYKi3ssFMMpt4MmuhkRTYY=;
        b=wHemcu+CoWZUUdUNLQGmDG5/EX0MlnARWyva55AojVuVg2mVf6VSUw9zc2T1hMd7SI
         wmjWklRvMqCFz0T1uLYE7p98OFThggnwoZdnVdDab+QPJ4PlpLLWod/FMuEmiHQFd/xA
         gEdToq3kLA9H1C7jTN1QF9C7/xsWSo3zDPU/6lk5SIEQXDUsTS/byr8ctUxduiOGdg6K
         PMRQ9BjnV03Q5W906SIrEvHdHo/5tVb5RvxXk4pkyqj4wvFIj+968Sc+rKkJsqIV884I
         46jlDo/3IUdS3DmjApEQJW8dlpj1DL6TEHWSw/3SUZSLxMg0px1Y6NzCfOtSHiYxSNBC
         aDKA==
X-Forwarded-Encrypted: i=1; AJvYcCWhdupuJ17h7H8JS8iUr/gi4m+oxwzvjWZBv06jmgz3yoWdPUkYmdRxtexIHiZfo87QXCE0cJCweEZDIN0=@vger.kernel.org, AJvYcCXcddR0KRS9FY2U9ZG5raxoAwT5G+MrX7kpUGVUtEcnydlczuT4u9mflmzV5AfgtTe+xr0bqTO1eN1mDA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ0rYhNPfxUWCs+MuNZ76qlEFbUt8TzG/cVdjwUmHMKoilRtH0
	LaBmqduqdZon2lK+Typ06F+Sc2DwmLdhcoHzhx2RXXN68sl3skfF
X-Gm-Gg: ASbGncvO4vqL/ALBEk9UBCbX0u9yd2Wgr8AExPvo2Wr/A6Ynt83QYYi41aeFzewtWhN
	Mo5SkHdnWVeMnB+N3ZNUJUGGmJVakdLXTTzJBb2ZH+fOyrYGrDxiMtt+FN6+FpCAnz79GG4liDe
	crQeH29kqYpp4ENmKZhw0IUoHeo2/er+PAsoxO5YdElib8dDS+4iQbSn6WvZAiM68JzBjbdRmpt
	jLu1HZJ0TCngy3iqPESFny++K6zdx0ju2Jo4FYfBuFFLjLCfoYzO2WeE0p3hfG93YhHf6OgGMSr
	IEDGX2OK7RbjY+0SwD4hTDuz6hQ=
X-Google-Smtp-Source: AGHT+IHcSmPLWcp/9s/cWJv/Z9aH4ngprC8dmHAwk7SXSwgrzSxayngeh3s3+/D0oZnWLeuU2gdFbg==
X-Received: by 2002:a17:902:ec88:b0:215:a190:ba10 with SMTP id d9443c01a7336-217783af518mr8791825ad.15.1733866519543;
        Tue, 10 Dec 2024 13:35:19 -0800 (PST)
Received: from [192.168.1.31] (ip68-231-38-120.ph.ph.cox.net. [68.231.38.120])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215f8e3e7cdsm94315165ad.10.2024.12.10.13.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2024 13:35:18 -0800 (PST)
Message-ID: <802a7704-585a-4ff1-8661-41874a98988a@gmail.com>
Date: Tue, 10 Dec 2024 14:35:17 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V9] md/bitmap: Optimize lock contention.
To: Shushu Yi <teddyxym@outlook.com>, linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai3@huawei.com, linux-kernel@vger.kernel.org,
 paul.e.luse@intel.com, firnyee@gmail.com, hch@infradead.org
References: <DM6PR12MB319444916C454CDBA6FCD358D83D2@DM6PR12MB3194.namprd12.prod.outlook.com>
Content-Language: en-US
From: Paul E Luse <paulluselinux@gmail.com>
In-Reply-To: <DM6PR12MB319444916C454CDBA6FCD358D83D2@DM6PR12MB3194.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/10/24 3:21 AM, Shushu Yi wrote:
> 
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
> V7 -> V8: Rebase onto newest Linux (6.12-rc2).
> V8 -> V9: Rebase onto newest code (md-6.13).
> 

Thanks!  So this patch fails to apply on either md-6.12 or md-6.13.  I 
know there was an issue before that I thought we'd cleared up on Slack. 
This was the issue last time:

oh hey, you know I think the issue might be "git format-patch 
master..new" as your patch should not be the diff between your branch 
and master but the diff between your brancn and md-6.12

Not sure if that's what is happening here or not, feel free to hit me up 
on slack but before sending another to the list I'd sugegst creating it 
and then testing its application with "git apply <patch name>" on a 
clean md-6.12 branch.

> ---
>   drivers/md/md-bitmap.c | 199 +++++++++++++++++++++++++++++++----------
>   drivers/md/md-bitmap.h |  22 ++++-
>   2 files changed, 172 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index b092c7b5282f..65f5c34d47b2 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -47,10 +47,12 @@ static inline char *bmname(struct bitmap *bitmap)
>    * if we find our page, we increment the page's refcount so that it stays
>    * allocated while we're using it
>    */
> -static int md_bitmap_checkpage(struct bitmap_counts *bitmap,
> -                   unsigned long page, int create, int no_hijack)
> -__releases(bitmap->lock)
> -__acquires(bitmap->lock)
> +static int md_bitmap_checkpage(struct bitmap_counts *bitmap, unsigned 
> long page,
> +                   int create, int no_hijack, spinlock_t *bmclock)
> +__releases(bmclock)
> +__acquires(bmclock)
> +__releases(bitmap->mlock)
> +__acquires(bitmap->mlock)
>   {
>       unsigned char *mappage;
> 
> @@ -73,7 +75,10 @@ __acquires(bitmap->lock)
> 
>       /* this page has not been allocated yet */
> 
> -    spin_unlock_irq(&bitmap->lock);
> +    if (bmclock)
> +        spin_unlock_irq(bmclock); /* lock for bmc */
> +    else
> +        write_unlock_irq(&bitmap->mlock); /* lock for metadata */
>       /* It is possible that this is being called inside a
>        * prepare_to_wait/finish_wait loop from raid5c:make_request().
>        * In general it is not permitted to sleep in that context as it
> @@ -88,7 +93,11 @@ __acquires(bitmap->lock)
>        */
>       sched_annotate_sleep();
>       mappage = kzalloc(PAGE_SIZE, GFP_NOIO);
> -    spin_lock_irq(&bitmap->lock);
> +
> +    if (bmclock)
> +        spin_lock_irq(bmclock);  /* lock for bmc */
> +    else
> +        write_lock_irq(&bitmap->mlock); /* lock for metadata */
> 
>       if (mappage == NULL) {
>           pr_debug("md/bitmap: map page allocation failed, hijacking\n");
> @@ -1202,16 +1211,35 @@ void md_bitmap_write_all(struct bitmap *bitmap)
>   static void md_bitmap_count_page(struct bitmap_counts *bitmap,
>                    sector_t offset, int inc)
>   {
> -    sector_t chunk = offset >> bitmap->chunkshift;
> -    unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
> +    /*
> +     * The stripe heads are spread across different locations in the
> +     * SSDs via a configurable hash function rather than mapping to a
> +     * continuous SSD space.
> +     * Sequential write requests are shuffled to different counter to
> +     * reduce the counter preemption.
> +     */
> +    sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> +    sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - 
> (PAGE_SHIFT - SECTOR_SHIFT));
> +    unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
> +    unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
> +                    (bits - (bitmap->chunkshift + SECTOR_SHIFT - 
> PAGE_SHIFT)));
> +    unsigned long cntid = blockno & mask;
> +    unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
> +
>       bitmap->bp[page].count += inc;
>       md_bitmap_checkfree(bitmap, page);
>   }
> 
>   static void md_bitmap_set_pending(struct bitmap_counts *bitmap, 
> sector_t offset)
>   {
> -    sector_t chunk = offset >> bitmap->chunkshift;
> -    unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
> +    sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> +    sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - 
> (PAGE_SHIFT - SECTOR_SHIFT));
> +    unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
> +    unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
> +                    (bits - (bitmap->chunkshift + SECTOR_SHIFT - 
> PAGE_SHIFT)));
> +    unsigned long cntid = blockno & mask;
> +    unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
> +
>       struct bitmap_page *bp = &bitmap->bp[page];
> 
>       if (!bp->pending)
> @@ -1220,7 +1248,7 @@ static void md_bitmap_set_pending(struct 
> bitmap_counts *bitmap, sector_t offset)
> 
>   static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts 
> *bitmap,
>                              sector_t offset, sector_t *blocks,
> -                           int create);
> +                           int create, spinlock_t *bmclock);
> 
>   /*
>    * bitmap daemon -- periodically wakes up to clean bits and flush pages
> @@ -1288,7 +1316,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
>        * decrement and handle accordingly.
>        */
>       counts = &bitmap->counts;
> -    spin_lock_irq(&counts->lock);
> +    write_lock_irq(&counts->mlock);
>       nextpage = 0;
>       for (j = 0; j < counts->chunks; j++) {
>           bitmap_counter_t *bmc;
> @@ -1303,7 +1331,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
>               counts->bp[j >> PAGE_COUNTER_SHIFT].pending = 0;
>           }
> 
> -        bmc = md_bitmap_get_counter(counts, block, &blocks, 0);
> +        bmc = md_bitmap_get_counter(counts, block, &blocks, 0, NULL);
>           if (!bmc) {
>               j |= PAGE_COUNTER_MASK;
>               continue;
> @@ -1319,7 +1347,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
>               bitmap->allclean = 0;
>           }
>       }
> -    spin_unlock_irq(&counts->lock);
> +    write_unlock_irq(&counts->mlock);
> 
>       md_bitmap_wait_writes(bitmap);
>       /* Now start writeout on any page in NEEDWRITE that isn't DIRTY.
> @@ -1353,21 +1381,29 @@ void md_bitmap_daemon_work(struct mddev *mddev)
> 
>   static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts 
> *bitmap,
>                              sector_t offset, sector_t *blocks,
> -                           int create)
> -__releases(bitmap->lock)
> -__acquires(bitmap->lock)
> +                           int create, spinlock_t *bmclock)
> +__releases(bmclock)
> +__acquires(bmclock)
> +__releases(bitmap->mlock)
> +__acquires(bitmap->mlock)
>   {
>       /* If 'create', we might release the lock and reclaim it.
>        * The lock must have been taken with interrupts enabled.
>        * If !create, we don't release the lock.
>        */
> -    sector_t chunk = offset >> bitmap->chunkshift;
> -    unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
> -    unsigned long pageoff = (chunk & PAGE_COUNTER_MASK) << 
> COUNTER_BYTE_SHIFT;
> +    sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> +    sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - 
> (PAGE_SHIFT - SECTOR_SHIFT));
> +    unsigned long bits = totblocks ? fls((totblocks - 1)) : 0;
> +    unsigned long mask = ULONG_MAX << bits | ~(ULONG_MAX <<
> +                    (bits - (bitmap->chunkshift + SECTOR_SHIFT - 
> PAGE_SHIFT)));
> +    unsigned long cntid = blockno & mask;
> +    unsigned long page = cntid >> PAGE_COUNTER_SHIFT;
> +    unsigned long pageoff = (cntid & PAGE_COUNTER_MASK) << 
> COUNTER_BYTE_SHIFT;
> +
>       sector_t csize;
>       int err;
> 
> -    err = md_bitmap_checkpage(bitmap, page, create, 0);
> +    err = md_bitmap_checkpage(bitmap, page, create, 0, bmclock);
> 
>       if (bitmap->bp[page].hijacked ||
>           bitmap->bp[page].map == NULL)
> @@ -1393,6 +1429,28 @@ __acquires(bitmap->lock)
>               &(bitmap->bp[page].map[pageoff]);
>   }
> 
> +/* set-association */
> +static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts *bitmap, 
> sector_t offset);
> +
> +static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts *bitmap, 
> sector_t offset)
> +{
> +    sector_t blockno = offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> +    sector_t totblocks = bitmap->chunks << (bitmap->chunkshift - 
> (PAGE_SHIFT - SECTOR_SHIFT));
> +    unsigned long bitscnt = totblocks ? fls((totblocks - 1)) : 0;
> +    unsigned long maskcnt = ULONG_MAX << bitscnt | ~(ULONG_MAX << 
> (bitscnt -
> +                    (bitmap->chunkshift + SECTOR_SHIFT - PAGE_SHIFT)));
> +    unsigned long cntid = blockno & maskcnt;
> +
> +    unsigned long totcnts = bitmap->chunks;
> +    unsigned long bitslock = totcnts ? fls((totcnts - 1)) : 0;
> +    unsigned long masklock = ULONG_MAX << bitslock | ~(ULONG_MAX <<
> +                    (bitslock - BITMAP_COUNTER_LOCK_RATIO_SHIFT));
> +    unsigned long lockid = cntid & masklock;
> +
> +    spinlock_t *bmclock = &(bitmap->bmclocks[lockid]);
> +    return bmclock;
> +}
> +
>   int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, 
> unsigned long sectors, int behind)
>   {
>       if (!bitmap)
> @@ -1412,11 +1470,15 @@ int md_bitmap_startwrite(struct bitmap *bitmap, 
> sector_t offset, unsigned long s
>       while (sectors) {
>           sector_t blocks;
>           bitmap_counter_t *bmc;
> +        spinlock_t *bmclock;
> 
> -        spin_lock_irq(&bitmap->counts.lock);
> -        bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 1);
> +        bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> +        read_lock(&bitmap->counts.mlock);
> +        spin_lock_irq(bmclock);
> +        bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 
> 1, bmclock);
>           if (!bmc) {
> -            spin_unlock_irq(&bitmap->counts.lock);
> +            spin_unlock_irq(bmclock);
> +            read_unlock(&bitmap->counts.mlock);
>               return 0;
>           }
> 
> @@ -1428,7 +1490,8 @@ int md_bitmap_startwrite(struct bitmap *bitmap, 
> sector_t offset, unsigned long s
>                */
>               prepare_to_wait(&bitmap->overflow_wait, &__wait,
>                       TASK_UNINTERRUPTIBLE);
> -            spin_unlock_irq(&bitmap->counts.lock);
> +            spin_unlock_irq(bmclock);
> +            read_unlock(&bitmap->counts.mlock);
>               schedule();
>               finish_wait(&bitmap->overflow_wait, &__wait);
>               continue;
> @@ -1445,7 +1508,8 @@ int md_bitmap_startwrite(struct bitmap *bitmap, 
> sector_t offset, unsigned long s
> 
>           (*bmc)++;
> 
> -        spin_unlock_irq(&bitmap->counts.lock);
> +        spin_unlock_irq(bmclock);
> +        read_unlock(&bitmap->counts.mlock);
> 
>           offset += blocks;
>           if (sectors > blocks)
> @@ -1474,11 +1538,15 @@ void md_bitmap_endwrite(struct bitmap *bitmap, 
> sector_t offset,
>           sector_t blocks;
>           unsigned long flags;
>           bitmap_counter_t *bmc;
> +        spinlock_t *bmclock;
> 
> -        spin_lock_irqsave(&bitmap->counts.lock, flags);
> -        bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 0);
> +        bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> +        read_lock(&bitmap->counts.mlock);
> +        spin_lock_irqsave(bmclock, flags);
> +        bmc = md_bitmap_get_counter(&bitmap->counts, offset, &blocks, 
> 0, bmclock);
>           if (!bmc) {
> -            spin_unlock_irqrestore(&bitmap->counts.lock, flags);
> +            spin_unlock_irqrestore(bmclock, flags);
> +            read_unlock(&bitmap->counts.mlock);
>               return;
>           }
> 
> @@ -1500,7 +1568,8 @@ void md_bitmap_endwrite(struct bitmap *bitmap, 
> sector_t offset,
>               md_bitmap_set_pending(&bitmap->counts, offset);
>               bitmap->allclean = 0;
>           }
> -        spin_unlock_irqrestore(&bitmap->counts.lock, flags);
> +        spin_unlock_irqrestore(bmclock, flags);
> +        read_unlock(&bitmap->counts.mlock);
>           offset += blocks;
>           if (sectors > blocks)
>               sectors -= blocks;
> @@ -1514,13 +1583,16 @@ static int __bitmap_start_sync(struct bitmap 
> *bitmap, sector_t offset, sector_t
>                      int degraded)
>   {
>       bitmap_counter_t *bmc;
> +    spinlock_t *bmclock;
>       int rv;
>       if (bitmap == NULL) {/* FIXME or bitmap set as 'failed' */
>           *blocks = 1024;
>           return 1; /* always resync if no bitmap */
>       }
> -    spin_lock_irq(&bitmap->counts.lock);
> -    bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
> +    bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> +    read_lock(&bitmap->counts.mlock);
> +    spin_lock_irq(bmclock);
> +    bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0, 
> bmclock);
>       rv = 0;
>       if (bmc) {
>           /* locked */
> @@ -1534,7 +1606,8 @@ static int __bitmap_start_sync(struct bitmap 
> *bitmap, sector_t offset, sector_t
>               }
>           }
>       }
> -    spin_unlock_irq(&bitmap->counts.lock);
> +    spin_unlock_irq(bmclock);
> +    read_unlock(&bitmap->counts.mlock);
>       return rv;
>   }
> 
> @@ -1566,13 +1639,16 @@ void md_bitmap_end_sync(struct bitmap *bitmap, 
> sector_t offset, sector_t *blocks
>   {
>       bitmap_counter_t *bmc;
>       unsigned long flags;
> +    spinlock_t *bmclock;
> 
>       if (bitmap == NULL) {
>           *blocks = 1024;
>           return;
>       }
> -    spin_lock_irqsave(&bitmap->counts.lock, flags);
> -    bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
> +    bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> +    read_lock(&bitmap->counts.mlock);
> +    spin_lock_irqsave(bmclock, flags);
> +    bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0, 
> bmclock);
>       if (bmc == NULL)
>           goto unlock;
>       /* locked */
> @@ -1589,7 +1665,8 @@ void md_bitmap_end_sync(struct bitmap *bitmap, 
> sector_t offset, sector_t *blocks
>           }
>       }
>    unlock:
> -    spin_unlock_irqrestore(&bitmap->counts.lock, flags);
> +    spin_unlock_irqrestore(bmclock, flags);
> +    read_unlock(&bitmap->counts.mlock);
>   }
>   EXPORT_SYMBOL(md_bitmap_end_sync);
> 
> @@ -1670,10 +1747,15 @@ static void md_bitmap_set_memory_bits(struct 
> bitmap *bitmap, sector_t offset, in
> 
>       sector_t secs;
>       bitmap_counter_t *bmc;
> -    spin_lock_irq(&bitmap->counts.lock);
> -    bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs, 1);
> +    spinlock_t *bmclock;
> +
> +    bmclock = md_bitmap_get_bmclock(&bitmap->counts, offset);
> +    read_lock(&bitmap->counts.mlock);
> +    spin_lock_irq(bmclock);
> +    bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs, 1, 
> bmclock);
>       if (!bmc) {
> -        spin_unlock_irq(&bitmap->counts.lock);
> +        spin_unlock_irq(bmclock);
> +        read_unlock(&bitmap->counts.mlock);
>           return;
>       }
>       if (!*bmc) {
> @@ -1684,7 +1766,8 @@ static void md_bitmap_set_memory_bits(struct 
> bitmap *bitmap, sector_t offset, in
>       }
>       if (needed)
>           *bmc |= NEEDED_MASK;
> -    spin_unlock_irq(&bitmap->counts.lock);
> +    spin_unlock_irq(bmclock);
> +    read_unlock(&bitmap->counts.mlock);
>   }
> 
>   /* dirty the memory and file bits for bitmap chunks "s" to "e" */
> @@ -1736,6 +1819,7 @@ void md_bitmap_free(struct bitmap *bitmap)
>   {
>       unsigned long k, pages;
>       struct bitmap_page *bp;
> +    spinlock_t *bmclocks;
> 
>       if (!bitmap) /* there was no bitmap */
>           return;
> @@ -1756,6 +1840,7 @@ void md_bitmap_free(struct bitmap *bitmap)
> 
>       bp = bitmap->counts.bp;
>       pages = bitmap->counts.pages;
> +    bmclocks = bitmap->counts.bmclocks;
> 
>       /* free all allocated memory */
> 
> @@ -1764,6 +1849,7 @@ void md_bitmap_free(struct bitmap *bitmap)
>               if (bp[k].map && !bp[k].hijacked)
>                   kfree(bp[k].map);
>       kfree(bp);
> +    kfree(bmclocks);
>       kfree(bitmap);
>   }
>   EXPORT_SYMBOL(md_bitmap_free);
> @@ -1831,7 +1917,9 @@ struct bitmap *md_bitmap_create(struct mddev 
> *mddev, int slot)
>       if (!bitmap)
>           return ERR_PTR(-ENOMEM);
> 
> -    spin_lock_init(&bitmap->counts.lock);
> +    /* initialize metadata lock */
> +    rwlock_init(&bitmap->counts.mlock);
> +
>       atomic_set(&bitmap->pending_writes, 0);
>       init_waitqueue_head(&bitmap->write_wait);
>       init_waitqueue_head(&bitmap->overflow_wait);
> @@ -2072,6 +2160,8 @@ int md_bitmap_resize(struct bitmap *bitmap, 
> sector_t blocks,
>       int ret = 0;
>       long pages;
>       struct bitmap_page *new_bp;
> +    spinlock_t *new_bmclocks;
> +    int num_bmclocks, i;
> 
>       if (bitmap->storage.file && !init) {
>           pr_info("md: cannot resize file-based bitmap\n");
> @@ -2154,12 +2244,25 @@ int md_bitmap_resize(struct bitmap *bitmap, 
> sector_t blocks,
>       blocks = min(old_counts.chunks << old_counts.chunkshift,
>                chunks << chunkshift);
> 
> -    spin_lock_irq(&bitmap->counts.lock);
> +    write_lock_irq(&bitmap->counts.mlock);
> +
> +    /* initialize bmc locks */
> +    num_bmclocks = DIV_ROUND_UP(chunks, BITMAP_COUNTER_LOCK_RATIO);
> +    num_bmclocks = min(num_bmclocks, BITMAP_COUNTER_LOCK_MAX);
> +
> +    new_bmclocks = kvcalloc(num_bmclocks, sizeof(*new_bmclocks), 
> GFP_KERNEL);
> +    bitmap->counts.bmclocks = new_bmclocks;
> +    for (i = 0; i < num_bmclocks; ++i) {
> +        spinlock_t *bmclock = &(bitmap->counts.bmclocks)[i];
> +
> +        spin_lock_init(bmclock);
> +    }
> +
>       /* For cluster raid, need to pre-allocate bitmap */
>       if (mddev_is_clustered(bitmap->mddev)) {
>           unsigned long page;
>           for (page = 0; page < pages; page++) {
> -            ret = md_bitmap_checkpage(&bitmap->counts, page, 1, 1);
> +            ret = md_bitmap_checkpage(&bitmap->counts, page, 1, 1, NULL);
>               if (ret) {
>                   unsigned long k;
> 
> @@ -2189,11 +2292,12 @@ int md_bitmap_resize(struct bitmap *bitmap, 
> sector_t blocks,
>           bitmap_counter_t *bmc_old, *bmc_new;
>           int set;
> 
> -        bmc_old = md_bitmap_get_counter(&old_counts, block, 
> &old_blocks, 0);
> +        bmc_old = md_bitmap_get_counter(&old_counts, block, 
> &old_blocks, 0, NULL);
>           set = bmc_old && NEEDED(*bmc_old);
> 
>           if (set) {
> -            bmc_new = md_bitmap_get_counter(&bitmap->counts, block, 
> &new_blocks, 1);
> +            bmc_new = md_bitmap_get_counter(&bitmap->counts, block, 
> &new_blocks,
> ++                                        1, NULL);
>               if (*bmc_new == 0) {
>                   /* need to set on-disk bits too. */
>                   sector_t end = block + new_blocks;
> @@ -2226,7 +2330,7 @@ int md_bitmap_resize(struct bitmap *bitmap, 
> sector_t blocks,
>           int i;
>           while (block < (chunks << chunkshift)) {
>               bitmap_counter_t *bmc;
> -            bmc = md_bitmap_get_counter(&bitmap->counts, block, 
> &new_blocks, 1);
> +            bmc = md_bitmap_get_counter(&bitmap->counts, block, 
> &new_blocks, 1, NULL);
>               if (bmc) {
>                   /* new space.  It needs to be resynced, so
>                    * we set NEEDED_MASK.
> @@ -2242,7 +2346,8 @@ int md_bitmap_resize(struct bitmap *bitmap, 
> sector_t blocks,
>           for (i = 0; i < bitmap->storage.file_pages; i++)
>               set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
>       }
> -    spin_unlock_irq(&bitmap->counts.lock);
> +    write_unlock_irq(&bitmap->counts.mlock);
> +    read_unlock(&bitmap->counts.mlock);
> 
>       if (!init) {
>           md_bitmap_unplug(bitmap);
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index cfd7395de8fd..ff43b61f5ff0 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -2,7 +2,9 @@
>   /*
>    * bitmap.h: Copyright (C) Peter T. Breuer (ptb@ot.uc3m.es) 2003
>    *
> - * additions: Copyright (C) 2003-2004, Paul Clements, SteelEye 
> Technology, Inc.
> + * additions:
> + *        Copyright (C) 2003-2004, Paul Clements, SteelEye Technology, 
> Inc.
> + *        Copyright (C) 2022-2023, Shushu Yi (firnyee@gmail.com)
>    */
>   #ifndef BITMAP_H
>   #define BITMAP_H 1
> @@ -112,6 +114,11 @@ typedef __u16 bitmap_counter_t;
> 
>   #define BITMAP_MAGIC 0x6d746962
> 
> +/* how many counters share the same bmclock? */
> +#define BITMAP_COUNTER_LOCK_RATIO_SHIFT 0
> +#define BITMAP_COUNTER_LOCK_RATIO (1 << BITMAP_COUNTER_LOCK_RATIO_SHIFT)
> +#define BITMAP_COUNTER_LOCK_MAX 65536
> +
>   /* use these for bitmap->flags and bitmap->sb->state bit-fields */
>   enum bitmap_state {
>       BITMAP_STALE       = 1,  /* the bitmap file is out of date or had 
> -EIO */
> @@ -180,7 +187,18 @@ struct bitmap_page {
>   struct bitmap {
> 
>       struct bitmap_counts {
> -        spinlock_t lock;
> +        /*
> +         * Customize different types of lock structures to manage
> +         * data and metadata.
> +         * Split the counter table into multiple segments and assigns a
> +         * dedicated lock to each segment.  The counters in the counter
> +         * table, which map to neighboring stripe blocks, are interleaved
> +         * across different segments.
> +         * CPU threads that target different segments can acquire the 
> locks
> +         * simultaneously, resulting in better thread-level parallelism.
> +         */
> +        rwlock_t mlock;                /* lock for metadata */
> +        spinlock_t *bmclocks;        /* locks for bmc */
>           struct bitmap_page *bp;
>           unsigned long pages;        /* total number of pages
>                            * in the bitmap */

