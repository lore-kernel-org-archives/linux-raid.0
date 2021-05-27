Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D82C4707F
	for <linux-raid@archiver.kernel.org>; Thu, 27 May 2021 15:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A82BB61358
	for <linux-raid@archiver.kernel.org>; Thu, 27 May 2021 15:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbhE0P1l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 May 2021 11:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbhE0P1k (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 May 2021 11:27:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D530FC061574
        for <linux-raid@vger.kernel.org>; Thu, 27 May 2021 08:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Jaub3xRp9Pc3QpP86/hEjJ71XI30RXl1uJNaihGXMkc=; b=vLITlbseFuDdF/fe7jtCA4Z5zt
        iOA/opWvfkjq97ZbcZ8GqTkqqSznGFEoxl6CJ/CMulU57BsjXiIxSTdfdglM7j0pbsgsWOHuP3lYB
        tsKKEI6SJTPjVyMhcz73Im8VHEikAW9MTbWV2CR6ydmT2WNH+GlPRXeBGr3xS7SDrsLelqLuIlYHU
        gcRtYG5UZzgXrzTCsC8Ag368icqmDFo9txiMaW5EfCJ7XlcUmPuldLIzcgyrA2Bo2cqk1Do1arqSp
        puPrCZiiMl6Ih+UnE+2ZXevsyOlO3DTRNYGXTf3M9F7UtjUG8jTGik0QuSFcsWdq2elDgH4ic8fyH
        Mfsyb5nA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lmHt5-005fpb-4p; Thu, 27 May 2021 15:25:37 +0000
Date:   Thu, 27 May 2021 16:25:31 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        artur.paszkiewicz@intel.com, hch@infradead.org
Subject: Re: [PATCH V3 2/8] md: add io accounting for raid0 and raid5
Message-ID: <YK+56xtF7VoZexoa@infradead.org>
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
 <20210525094623.763195-3-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525094623.763195-3-jiangguoqing@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 25, 2021 at 05:46:17PM +0800, Guoqing Jiang wrote:
> We introduce a new bioset (io_acct_set) for raid0 and raid5 since they
> don't own clone infrastructure to accounting io. And the bioset is added
> to mddev instead of to raid0 and raid5 layer, because with this way, we
> can put common functions to md.h and reuse them in raid0 and raid5.
> 
> Also struct md_io_acct is added accordingly which includes io start_time,
> the origin bio and cloned bio. Then we can call bio_{start,end}_io_acct
> to get related io status.
> 
> Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
> ---
>  drivers/md/md.c    | 44 +++++++++++++++++++++++++++++++++++++++++++-
>  drivers/md/md.h    |  8 ++++++++
>  drivers/md/raid0.c |  3 +++
>  drivers/md/raid5.c |  9 +++++++++
>  4 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7ba00e4c862d..87786f180525 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2340,7 +2340,8 @@ int md_integrity_register(struct mddev *mddev)
>  			       bdev_get_integrity(reference->bdev));
>  
>  	pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
> -	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
> +	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
> +	    bioset_integrity_create(&mddev->io_acct_set, BIO_POOL_SIZE)) {

Don't we need to create this new only for raid0 and raid5?
Shouldn't they call helpers to create it?

> @@ -5864,6 +5866,12 @@ int md_run(struct mddev *mddev)
>  		if (err)
>  			return err;
>  	}
> +	if (!bioset_initialized(&mddev->io_acct_set)) {
> +		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
> +				  offsetof(struct md_io_acct, bio_clone), 0);
> +		if (err)
> +			return err;
> +	}

Can someone explain why we are having these bioset_initialized checks
here (also for the existing one)?  This just smells like very sloppy
life time rules.

> +/* used by personalities (raid0 and raid5) to account io stats */

Instead of mentioning the personalities this migt better explain
something like ".. by personalities that don't already clone the
bio and thus can't easily add the timestamp to their extended bio
structure"

> +void md_account_bio(struct mddev *mddev, struct bio **bio)
> +{
> +	struct md_io_acct *md_io_acct;
> +	struct bio *clone;
> +
> +	if (!blk_queue_io_stat((*bio)->bi_bdev->bd_disk->queue))
> +		return;
> +
> +	clone = bio_clone_fast(*bio, GFP_NOIO, &mddev->io_acct_set);
> +	md_io_acct = container_of(clone, struct md_io_acct, bio_clone);
> +	md_io_acct->orig_bio = *bio;
> +	md_io_acct->start_time = bio_start_io_acct(*bio);
> +
> +	clone->bi_end_io = md_end_io_acct;
> +	clone->bi_private = md_io_acct;
> +	*bio = clone;

I would find a calling conventions that returns the allocated clone
(or the original bio if there is no accounting) more logical.

> +	struct bio_set			io_acct_set; /* for raid0 and raid5 io accounting */

crazy long line.
