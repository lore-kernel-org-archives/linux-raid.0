Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA5DC636D3
	for <linux-raid@archiver.kernel.org>; Thu,  9 Feb 2023 20:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjBIUnW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Feb 2023 15:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBIUnV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Feb 2023 15:43:21 -0500
X-Greylist: delayed 321 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Feb 2023 12:43:19 PST
Received: from out-143.mta0.migadu.com (out-143.mta0.migadu.com [91.218.175.143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42ABD28872
        for <linux-raid@vger.kernel.org>; Thu,  9 Feb 2023 12:43:19 -0800 (PST)
Message-ID: <80812f87-a743-2deb-3d43-d07fcc4ce895@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675975076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bxxeSPSM923KHOZO5Pv+lzzWLRahvIbdF1/jFL5+ByY=;
        b=GbIWQZmzDC+TareZHyu0qcapU5sbhKJfOsyFWtBSOlIA01rPUhENzd9diSmFBSvjQ8AkwN
        j7o7QsDD0dT7MIUGq2bK5/pb+RSTegoQdJw9NvoKFmRUwfyPYmR+pDIILTClMLq6gV17hR
        uB8T/JcMU3V6ama33JGiz8fWVV78u64=
Date:   Thu, 9 Feb 2023 13:37:49 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] md: Use optimal I/O size for last bitmap page
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Cc:     Sushma Kalakota <sushma.kalakota@intel.com>
References: <20230118005319.147-1-jonathan.derrick@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
In-Reply-To: <20230118005319.147-1-jonathan.derrick@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

Any thoughts on this?

On 1/17/2023 5:53 PM, Jonathan Derrick wrote:
> From: Jon Derrick <jonathan.derrick@linux.dev>
> 
> If the bitmap space has enough room, size the I/O for the last bitmap
> page write to the optimal I/O size for the storage device. The expanded
> write is checked that it won't overrun the data or metadata.
> 
> This change helps increase performance by preventing unnecessary
> device-side read-mod-writes due to non-atomic write unit sizes.
> 
> Ex biosnoop log. Device lba size 512, optimal size 4k:
> Before:
> Time        Process        PID     Device      LBA        Size      Lat
> 0.843734    md0_raid10     5267    nvme0n1   W 24         3584      1.17
> 0.843933    md0_raid10     5267    nvme1n1   W 24         3584      1.36
> 0.843968    md0_raid10     5267    nvme1n1   W 14207939968 4096      0.01
> 0.843979    md0_raid10     5267    nvme0n1   W 14207939968 4096      0.02
> 
> After:
> Time        Process        PID     Device      LBA        Size      Lat
> 18.374244   md0_raid10     6559    nvme0n1   W 24         4096      0.01
> 18.374253   md0_raid10     6559    nvme1n1   W 24         4096      0.01
> 18.374300   md0_raid10     6559    nvme0n1   W 11020272296 4096      0.01
> 18.374306   md0_raid10     6559    nvme1n1   W 11020272296 4096      0.02
> 
> Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
> ---
>  drivers/md/md-bitmap.c | 27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index e7cc6ba1b657..569297ea9b99 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -220,6 +220,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>  	rdev = NULL;
>  	while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
>  		int size = PAGE_SIZE;
> +		int optimal_size = PAGE_SIZE;
>  		loff_t offset = mddev->bitmap_info.offset;
>  
>  		bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
> @@ -228,9 +229,14 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>  			int last_page_size = store->bytes & (PAGE_SIZE-1);
>  			if (last_page_size == 0)
>  				last_page_size = PAGE_SIZE;
> -			size = roundup(last_page_size,
> -				       bdev_logical_block_size(bdev));
> +			size = roundup(last_page_size, bdev_logical_block_size(bdev));
> +			if (bdev_io_opt(bdev) > bdev_logical_block_size(bdev))
> +				optimal_size = roundup(last_page_size, bdev_io_opt(bdev));
> +			else
> +				optimal_size = size;
>  		}
> +
> +
>  		/* Just make sure we aren't corrupting data or
>  		 * metadata
>  		 */
> @@ -246,9 +252,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>  				goto bad_alignment;
>  		} else if (offset < 0) {
>  			/* DATA  BITMAP METADATA  */
> -			if (offset
> -			    + (long)(page->index * (PAGE_SIZE/512))
> -			    + size/512 > 0)
> +			loff_t off = offset + (long)(page->index * (PAGE_SIZE/512));
> +			if (size != optimal_size &&
> +			    off + optimal_size/512 <= 0)
> +				size = optimal_size;
> +			else if (off + size/512 > 0)
>  				/* bitmap runs in to metadata */
>  				goto bad_alignment;
>  			if (rdev->data_offset + mddev->dev_sectors
> @@ -257,10 +265,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>  				goto bad_alignment;
>  		} else if (rdev->sb_start < rdev->data_offset) {
>  			/* METADATA BITMAP DATA */
> -			if (rdev->sb_start
> -			    + offset
> -			    + page->index*(PAGE_SIZE/512) + size/512
> -			    > rdev->data_offset)
> +			loff_t off = rdev->sb_start + offset + page->index*(PAGE_SIZE/512);
> +			if (size != optimal_size &&
> +			    off + optimal_size/512 <= rdev->data_offset)
> +				size = optimal_size;
> +			else if (off + size/512 > rdev->data_offset)
>  				/* bitmap runs in to data */
>  				goto bad_alignment;
>  		} else {
