Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2346C12002
	for <linux-raid@archiver.kernel.org>; Wed, 21 Jul 2021 05:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBAFB60FED
	for <linux-raid@archiver.kernel.org>; Wed, 21 Jul 2021 05:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbhGUEXx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Jul 2021 00:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbhGUEX2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Jul 2021 00:23:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BF2C061574;
        Tue, 20 Jul 2021 22:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=D20QS6MxrqZjpfJr3udotoWchnhZQTjbmypQCoId5Uw=; b=dlPo+cYBzFsFFxIcS4cYqT1y4v
        5Og9QnPdR7+tgNY/mC4DDWWwn9IG6Y1NxBmegim+rvlhrYTIO4sYBBTzCbgKQiyUExae41YdthWOB
        +iHlTPjl2Yy3lzJAT0lCtOu1qpNEg16QRSjSjY3YH+GP7i3Mm7cfgujPX0kGu7li12Q0DCLsBcAEP
        TD2DV6pCn3bPuvPvCmnlEz816HpGzL1dZeBTuDMPz5LlqdpTfhcmgrwpWHbPA3glsfRek93dlTGpd
        KJHjPzOvYVx96bDHgqkpcl3KG5OU2lopmvHN0bke/Z8M1V/Ash+m7zLezzViDDeoE9o1tXCTfwmri
        KHGshupw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m64OY-008oIM-3C; Wed, 21 Jul 2021 05:03:47 +0000
Date:   Wed, 21 Jul 2021 06:03:46 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, hare@suse.de, bvanassche@acm.org,
        ming.lei@redhat.com, hch@infradead.org, jack@suse.cz,
        osandov@fb.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/5] md: replace GENHD_FL_UP with GENHD_FL_DISK_ADDED on
 is_mddev_broken()
Message-ID: <YPeqspNQrE7PvbXR@infradead.org>
References: <20210720182048.1906526-1-mcgrof@kernel.org>
 <20210720182048.1906526-3-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720182048.1906526-3-mcgrof@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jul 20, 2021 at 11:20:45AM -0700, Luis Chamberlain wrote:
> The GENHD_FL_DISK_ADDED flag is what we really want, as the
> flag GENHD_FL_UP could be set on a semi-initialized device.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Based on the commit log for the patch adding this check I think this
is wrong  It actually wants to detected underlying devices for which
del_gendisk has been called.

> ---
>  drivers/md/md.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 832547cf038f..cf70e0cfa856 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -764,9 +764,7 @@ struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev);
>  
>  static inline bool is_mddev_broken(struct md_rdev *rdev, const char *md_type)
>  {
> -	int flags = rdev->bdev->bd_disk->flags;
> -
> -	if (!(flags & GENHD_FL_UP)) {
> +	if (!blk_disk_added(rdev->bdev->bd_disk)) {
>  		if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags))
>  			pr_warn("md: %s: %s array has a missing/failed member\n",
>  				mdname(rdev->mddev), md_type);
> -- 
> 2.27.0
> 
---end quoted text---
