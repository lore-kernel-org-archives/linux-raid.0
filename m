Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406DCC433FE
	for <linux-raid@archiver.kernel.org>; Fri, 15 Oct 2021 03:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 256BC61152
	for <linux-raid@archiver.kernel.org>; Fri, 15 Oct 2021 03:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhJODDk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Oct 2021 23:03:40 -0400
Received: from out0.migadu.com ([94.23.1.103]:45611 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhJODDi (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 14 Oct 2021 23:03:38 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1634266887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3JKKcKQvzmKtnZfQe0695j3qKTRuj5F96dGAJHbJWhM=;
        b=sHRXBvQ3uzVNSyW2U4PMQMJqqgDHZce78OlRAvH4+YgVDmf0vBv7+1VNVN14ajTRIc+Rln
        v3wLKO7D6AKu7/vjqnf57mwYy7cCS60P1fXxtHavMKvZonqswopZfomK0rOXs6QMumB9E4
        Nq65njoCBlTOoltGah1kWIxOzX3YSAg=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH v2] md: Kill usage of page->index
To:     Kent Overstreet <kent.overstreet@gmail.com>,
        "heming.zhao@suse.com" <heming.zhao@suse.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk,
        alexander.h.duyck@linux.intel.com
References: <20211013160034.3472923-1-kent.overstreet@gmail.com>
 <20211013160034.3472923-5-kent.overstreet@gmail.com>
 <bcdd4b56-9b6b-c5cb-2eb7-540fa003d692@linux.dev>
 <04714b0e-297b-7383-ed4f-e39ae5e56433@suse.com>
 <YWg/AGR50Vw7DDuU@moria.home.lan>
Message-ID: <c2e2edd1-8f6f-1849-df0a-46916e311586@linux.dev>
Date:   Fri, 15 Oct 2021 11:01:21 +0800
MIME-Version: 1.0
In-Reply-To: <YWg/AGR50Vw7DDuU@moria.home.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 10/14/21 10:30 PM, Kent Overstreet wrote:
> On Thu, Oct 14, 2021 at 04:58:46PM +0800,heming.zhao@suse.com  wrote:
>> Hello all,
>>
>> The page->index takes an important role for cluster-md module.
>> i.e, a two-node HA env, node A bitmap may be managed in first 4K area, then
>> node B bitmap is in 8K area (the second page). this patch removes the index
>> and fix/hardcode index with value 0, which will only operate first node bitmap.
>>
>> If this serial patches are important and must be merged in mainline, we should
>> redesign code logic for the related code.
>>
>> Thanks,
>> Heming
> Can you look at and test the updated patch below? The more I look at the md
> bitmap code the more it scares me.
>
> -- >8 --
> Subject: [PATCH] md: Kill usage of page->index
>
> As part of the struct page cleanups underway, we want to remove as much
> usage of page->mapping and page->index as possible, as frequently they
> are known from context - as they are here in the md bitmap code.
>
> Signed-off-by: Kent Overstreet<kent.overstreet@gmail.com>
> ---
>   drivers/md/md-bitmap.c | 49 ++++++++++++++++++++----------------------
>   drivers/md/md-bitmap.h |  1 +
>   2 files changed, 24 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index e29c6298ef..316e4cd5a7 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -165,10 +165,8 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
>   
>   		if (sync_page_io(rdev, target,
>   				 roundup(size, bdev_logical_block_size(rdev->bdev)),
> -				 page, REQ_OP_READ, 0, true)) {
> -			page->index = index;
> +				 page, REQ_OP_READ, 0, true))
>   			return 0;
> -		}
>   	}
>   	return -EIO;
>   }
> @@ -209,7 +207,8 @@ static struct md_rdev *next_active_rdev(struct md_rdev *rdev, struct mddev *mdde
>   	return NULL;
>   }
>   
> -static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
> +static int write_sb_page(struct bitmap *bitmap, struct page *page,
> +			 unsigned long index, int wait)
>   {
>   	struct md_rdev *rdev;
>   	struct block_device *bdev;
> @@ -224,7 +223,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>   
>   		bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
>   
> -		if (page->index == store->file_pages-1) {
> +		if (index == store->file_pages-1) {
>   			int last_page_size = store->bytes & (PAGE_SIZE-1);
>   			if (last_page_size == 0)
>   				last_page_size = PAGE_SIZE;
> @@ -236,8 +235,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>   		 */
>   		if (mddev->external) {
>   			/* Bitmap could be anywhere. */
> -			if (rdev->sb_start + offset + (page->index
> -						       * (PAGE_SIZE/512))
> +			if (rdev->sb_start + offset + index * PAGE_SECTORS
>   			    > rdev->data_offset
>   			    &&
>   			    rdev->sb_start + offset
> @@ -247,7 +245,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>   		} else if (offset < 0) {
>   			/* DATA  BITMAP METADATA  */
>   			if (offset
> -			    + (long)(page->index * (PAGE_SIZE/512))
> +			    + (long)(index * PAGE_SECTORS)
>   			    + size/512 > 0)
>   				/* bitmap runs in to metadata */
>   				goto bad_alignment;
> @@ -259,7 +257,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>   			/* METADATA BITMAP DATA */
>   			if (rdev->sb_start
>   			    + offset
> -			    + page->index*(PAGE_SIZE/512) + size/512
> +			    + index * PAGE_SECTORS + size/512
>   			    > rdev->data_offset)
>   				/* bitmap runs in to data */
>   				goto bad_alignment;
> @@ -268,7 +266,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>   		}
>   		md_super_write(mddev, rdev,
>   			       rdev->sb_start + offset
> -			       + page->index * (PAGE_SIZE/512),
> +			       + index * PAGE_SECTORS,
>   			       size,
>   			       page);
>   	}
> @@ -285,12 +283,13 @@ static void md_bitmap_file_kick(struct bitmap *bitmap);
>   /*
>    * write out a page to a file
>    */
> -static void write_page(struct bitmap *bitmap, struct page *page, int wait)
> +static void write_page(struct bitmap *bitmap, struct page *page,
> +		       unsigned long index, int wait)
>   {
>   	struct buffer_head *bh;
>   
>   	if (bitmap->storage.file == NULL) {
> -		switch (write_sb_page(bitmap, page, wait)) {
> +		switch (write_sb_page(bitmap, page, index, wait)) {
>   		case -EINVAL:
>   			set_bit(BITMAP_WRITE_ERROR, &bitmap->flags);
>   		}
> @@ -399,7 +398,6 @@ static int read_page(struct file *file, unsigned long index,
>   		blk_cur++;
>   		bh = bh->b_this_page;
>   	}
> -	page->index = index;
>   
>   	wait_event(bitmap->write_wait,
>   		   atomic_read(&bitmap->pending_writes)==0);
> @@ -472,7 +470,7 @@ void md_bitmap_update_sb(struct bitmap *bitmap)
>   	sb->sectors_reserved = cpu_to_le32(bitmap->mddev->
>   					   bitmap_info.space);
>   	kunmap_atomic(sb);
> -	write_page(bitmap, bitmap->storage.sb_page, 1);
> +	write_page(bitmap, bitmap->storage.sb_page, bitmap->storage.sb_index, 1);

I guess it is fine for sb_page now.

[...]

> @@ -1027,7 +1024,7 @@ void md_bitmap_unplug(struct bitmap *bitmap)
>   							  "md bitmap_unplug");
>   			}
>   			clear_page_attr(bitmap, i, BITMAP_PAGE_PENDING);
> -			write_page(bitmap, bitmap->storage.filemap[i], 0);
> +			write_page(bitmap, bitmap->storage.filemap[i], i, 0);

But for filemap page, I am not sure the above is correct.

>   			writing = 1;
>   		}
>   	}
> @@ -1137,7 +1134,7 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
>   				memset(paddr + offset, 0xff,
>   				       PAGE_SIZE - offset);
>   				kunmap_atomic(paddr);
> -				write_page(bitmap, page, 1);
> +				write_page(bitmap, page, index, 1);

Ditto.

>   
>   				ret = -EIO;
>   				if (test_bit(BITMAP_WRITE_ERROR,
> @@ -1336,7 +1333,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
>   		if (bitmap->storage.filemap &&
>   		    test_and_clear_page_attr(bitmap, j,
>   					     BITMAP_PAGE_NEEDWRITE)) {
> -			write_page(bitmap, bitmap->storage.filemap[j], 0);
> +			write_page(bitmap, bitmap->storage.filemap[j], j, 0);

Ditto.


>   		}
>   	}
>   
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index cfd7395de8..6e820eea32 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -207,6 +207,7 @@ struct bitmap {
>   						 * w/ filemap pages */
>   		unsigned long file_pages;	/* number of pages in the file*/
>   		unsigned long bytes;		/* total bytes in the bitmap */
> +		unsigned long sb_index;		/* sb page index */

I guess it resolve the issue for sb_page, and we might need to do 
similar things
for filemap as well if I am not misunderstood.

Thanks,
Guoqing
