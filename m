Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EF4C4338F
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 09:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15ECF61B51
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 09:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbhHPJjR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Aug 2021 05:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhHPJjR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 Aug 2021 05:39:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6301C061764;
        Mon, 16 Aug 2021 02:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tYb26lD5y8OOKWadomD7Qv64PtRbDGKEV+koBkpG4/k=; b=ohmXCXFoh3/aIZHIXlVrhNuqDN
        J4XZPlxnHhZGsFu780/7ZhxWLxCtAQXF2FiIZTjalWxwsKs7Vjw1zEoMyXG4KqV2+JcUCkWnyged0
        z0VbDcUHGcJaC5lw/g9ndypCv0Idu0WVlwi0GqboWTK5ybNapRxQf1tpKIanjgylo6Gld8kgLb+H2
        nUaD+wQoQvzKC5RVBwbmon08+PZ/vc9OhMQbuuONk7abD1FWehQZMaqzLVRsnsA26qVmuhgB+kkvF
        Atzq8C/Ue4EyyDCi4j03IwC/doX4Q4A5ywyJzsP+SGtAlIo4U5ijSvV0TtLWPLOSeGnv1hGK/gp6n
        fZx4viFw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFZ46-001Clr-Bc; Mon, 16 Aug 2021 09:38:06 +0000
Date:   Mon, 16 Aug 2021 10:37:54 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org,
        linux-raid@vger.kernel.org, jens@chianterastutte.eu,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] raid1: ensure bio doesn't have more than BIO_MAX_VECS
 sectors
Message-ID: <YRox8gMjl/Y5Yt/k@infradead.org>
References: <20210813060510.3545109-1-guoqing.jiang@linux.dev>
 <YRYj8A+mDfAQBo/E@infradead.org>
 <0eac4589-ffd2-fb1a-43cc-87722731438a@linux.dev>
 <YRd26VGAnBiYeHrH@infradead.org>
 <YReFYrjtWr9MvfBr@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YReFYrjtWr9MvfBr@T590>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Aug 14, 2021 at 04:57:06PM +0800, Ming Lei wrote:
> > +	if (bitmap)
> > +		max_sectors = min_t(int, max_sectors, BIO_MAX_VECS * PAGE_SIZE);
> 
> s/PAGE_SIZE/PAGE_SECTORS

Yeah, max_sectors is in size units, I messed that up.

> 
> > +
> >  	if (max_sectors < bio_sectors(bio)) {
> >  		struct bio *split = bio_split(bio, max_sectors,
> >  					      GFP_NOIO, &conf->bio_split);
> > 
> 
> Here the limit is max single-page vectors, and the above way may not work,
> such as:
> 
> 0 ~ 254: each bvec's length is 512
> 255: bvec's length is 8192
> 
> the total length is just 512*255 + 8192 = 138752 bytes = 271 sectors, but it
> still may need 257 bvecs, which can't be allocated via bio_alloc_bioset().

Yes, we still need the rounding magic that alloc_behind_master_bio uses
here.

> One solution is to add queue limit of max_single_page_bvec, and let
> blk_queue_split() handle it.

I'd rather not bloat the core with this.
