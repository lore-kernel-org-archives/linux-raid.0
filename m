Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703C3C61DA4
	for <linux-raid@archiver.kernel.org>; Wed, 22 Feb 2023 23:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjBVXlg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Feb 2023 18:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBVXlf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Feb 2023 18:41:35 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB3F1CF56
        for <linux-raid@vger.kernel.org>; Wed, 22 Feb 2023 15:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=damb/rWqZfhV85oJXXHiFsrtOOYfHZJCwBJ8EcTErRM=; b=pDtbq4osHHme5zm0hM9wvSsTeg
        1C6wL3go/5zdU1E6DxQ6i8WJaSgx+115eyJX0+uk9NiCaoyjJ1CFyMdDx0q0xXD7uzwRtP79+u1/V
        ZPZU+Q8qzAS09yZgr7MeO5qQUqikVaSB0UBKJHurj1/M1xRPmAFPIaYv1wXWoVe6nirrvnnr1cUSq
        sldJGooEYev1S7eegSvSlYojeaw3mdgvY0DYqJQONsDx24TstbEeDXro+m6p9MZlt+Un/SnFlxAWY
        lYlgaI0Po9Y+DhKgIn+xHvmaSuNK2vddgC8B7DQ0zehpkn5n+OWgKxGh/3eo7MfM893O4vZ7ZJXCM
        6AgxUMNA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pUyjr-00ESTE-DL; Wed, 22 Feb 2023 23:41:31 +0000
Date:   Wed, 22 Feb 2023 15:41:31 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Xiao Ni <xni@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>
Subject: Re: [PATCH v3 2/3] md: Fix types in sb writer
Message-ID: <Y/aoK9KbpOiVxDqY@infradead.org>
References: <20230222215828.225-1-jonathan.derrick@linux.dev>
 <20230222215828.225-3-jonathan.derrick@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222215828.225-3-jonathan.derrick@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Feb 22, 2023 at 02:58:27PM -0700, Jonathan Derrick wrote:
> From: Jon Derrick <jonathan.derrick@linux.dev>
> 
> Page->index is a pgoff_t and multiplying could cause overflows on a
> 32-bit architecture. In the sb writer, this is used to calculate and
> verify the sector being used, and is multiplied by a sector value. Using
> sector_t will cast it to a u64 type and is the more appropriate type for
> the unit. Additionally, the integer size unit is converted to a sector
> unit in later calculations, and is now corrected to be an unsigned type.
> 
> Finally, clean up the calculations using variable aliases to improve
> readabiliy.
> 
> Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
> ---
>  drivers/md/md-bitmap.c | 36 +++++++++++++++---------------------
>  1 file changed, 15 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 5c65268a2d97..11f4453775ee 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -215,55 +215,49 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>  	struct block_device *bdev;
>  	struct mddev *mddev = bitmap->mddev;
>  	struct bitmap_storage *store = &bitmap->storage;
> -	loff_t offset = mddev->bitmap_info.offset;
> -	int size = PAGE_SIZE;
> +	sector_t offset = mddev->bitmap_info.offset;
> +	sector_t ps, sboff, doff;
> +	unsigned int size = PAGE_SIZE;
>  
>  	bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
>  	if (page->index == store->file_pages - 1) {
> -		int last_page_size = store->bytes & (PAGE_SIZE - 1);
> +		unsigned int last_page_size = store->bytes & (PAGE_SIZE - 1);
>  		if (last_page_size == 0)

This should probably grow an empty line after the variable
declaration (here or in the previous patch).

> +		    sboff < (doff + mddev->dev_sectors + (PAGE_SIZE / SECTOR_SIZE)))

No need for either pair of braces here.

> -		       rdev->sb_start + offset
> -		       + page->index * (PAGE_SIZE / SECTOR_SIZE),
> -		       size, page);
> +	md_super_write(mddev, rdev, sboff + ps,
> +		       (int) size, page);

This easily fits into a single line now.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
