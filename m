Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D95AC433ED
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 13:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED262610E9
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 13:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349560AbhERNhj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 09:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245195AbhERNhj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 09:37:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4686FC061573
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 06:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jbp4P9/5IellfOgth1rssGGTPsDy6Nd0FroEhfQAsLA=; b=JIIQ6QD4HasyDLvHZGCFKMwQcn
        +ebDm/0Yqn/3IwMnJdRKsJAXVEaov3ARV+VDN+EQ9PKGfWSlZAOJiOeuCsSenSiJi8Ne2UXoMlmNu
        PYtXOsXbVLvlSCGigoTX4TDmlHd2vsfmgZuvL7awJpf8qiJPTsTsjQ8EBUvhOnKM7A3APRsHdbyON
        BUW1PwhLOGnRn1m1vgiSxvJOCAD6UghbleNJXF7dBrGE6hq7XTMi7MckCt6ZA0t5b628pfEH8cTmb
        vOJtuL4Cjyy4ufTNvEPUA7RzeAEtIY7wFnGP2V7fDC6iR0zv+5hTBwMXR6uO3J3Jom9bnU/WHeOE+
        kGuXWj6w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lizsl-00E1HF-3n; Tue, 18 May 2021 13:35:47 +0000
Date:   Tue, 18 May 2021 14:35:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        artur.paszkiewicz@intel.com,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
Subject: Re: [PATCH 2/5] md: the latest try for improve io stats accounting
Message-ID: <YKPCpwHbr/E9q31g@infradead.org>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
 <20210518053225.641506-3-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518053225.641506-3-jiangguoqing@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> +	struct bio orig_bio_clone;

Maybe call this bio_clone?  or just bio?

> +static void md_end_io(struct bio *bio)
> +{
> +	struct md_io *md_io = bio->bi_private;
> +	struct bio *orig_bio = md_io->orig_bio;
> +
> +	orig_bio->bi_status = bio->bi_status;
> +
> +	bio_end_io_acct_remapped(orig_bio, md_io->start_time, orig_bio->bi_bdev);

Overly long line.  And trivially fixed by just using bio_end_io_acct.

> +	/*
> +	 * We don't clone bio for multipath, raid1 and raid10 since we can reuse
> +	 * their clone infrastructure.
> +	 */
> +	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue) &&
> +	    (bio->bi_pool != &mddev->md_io_bs) &&
> +	    (mddev->level != 1) && (mddev->level != 10) &&
> +	    (mddev->level != LEVEL_MULTIPATH)) {

This should use a flag in struct md_personality instead.

> -	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE)) {
> +	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
> +	    bioset_integrity_create(&mddev->md_io_bs, BIO_POOL_SIZE)) {

If the md_io_bs creation fails bio_set needs to be cleaned up.
