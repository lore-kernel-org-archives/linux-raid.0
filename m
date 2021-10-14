Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16352C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 08:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB6CE600D3
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 08:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhJNIEx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Oct 2021 04:04:53 -0400
Received: from out0.migadu.com ([94.23.1.103]:61796 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229970AbhJNIEs (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 14 Oct 2021 04:04:48 -0400
Subject: Re: [PATCH 4/5] md: Kill usage of page->index
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1634198561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kKNA120OvBxdiyQ+60rfydF2q7/iOLG4nQiHojVwuIY=;
        b=WGcyIy/pME5IlXtFE5zns0IYbWAsSCtuqQ00Z/YgB4/z11kWmWfytwAJVGUf3Gn8DLNWdU
        ZjVSLWqsVoFVkOC6Iip1usixATX9vvWJK+jirGH/2XiQi7FZS9MrH2Yn1MJSqH56kL6u3p
        4Q84UCQTYbKTmF/WaNQY2gE/j+5wEiQ=
To:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk
Cc:     alexander.h.duyck@linux.intel.com, heming.zhao@suse.com
References: <20211013160034.3472923-1-kent.overstreet@gmail.com>
 <20211013160034.3472923-5-kent.overstreet@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <bcdd4b56-9b6b-c5cb-2eb7-540fa003d692@linux.dev>
Date:   Thu, 14 Oct 2021 16:02:34 +0800
MIME-Version: 1.0
In-Reply-To: <20211013160034.3472923-5-kent.overstreet@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 10/14/21 12:00 AM, Kent Overstreet wrote:
> As part of the struct page cleanups underway, we want to remove as much
> usage of page->mapping and page->index as possible, as frequently they
> are known from context - as they are here in the md bitmap code.
>
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> ---
>   drivers/md/md-bitmap.c | 44 ++++++++++++++++++++----------------------
>   1 file changed, 21 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index e29c6298ef..dcdb4597c5 100644
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
> +	write_page(bitmap, bitmap->storage.sb_page, 0, 1);
>   }
>   EXPORT_SYMBOL(md_bitmap_update_sb);
>   
> @@ -524,7 +522,6 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
>   	bitmap->storage.sb_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>   	if (bitmap->storage.sb_page == NULL)
>   		return -ENOMEM;
> -	bitmap->storage.sb_page->index = 0;
>   
>   	sb = kmap_atomic(bitmap->storage.sb_page);
>   
> @@ -802,7 +799,6 @@ static int md_bitmap_storage_alloc(struct bitmap_storage *store,
>   	if (store->sb_page) {
>   		store->filemap[0] = store->sb_page;
>   		pnum = 1;
> -		store->sb_page->index = offset;

The offset is related with slot num, so it is better to verify the 
change with clustered raid.

@Heming


Thanks,
Guoqing
