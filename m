Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6525C4338F
	for <linux-raid@archiver.kernel.org>; Sat, 14 Aug 2021 07:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B254260F4B
	for <linux-raid@archiver.kernel.org>; Sat, 14 Aug 2021 07:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237434AbhHNH4r (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 14 Aug 2021 03:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbhHNH4r (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 14 Aug 2021 03:56:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596ADC06175F;
        Sat, 14 Aug 2021 00:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=V+NiOH/AY6x7CLqKzKV0ZvvLM9zHkh8SBM2Is+GQlVo=; b=c823Dyla4Jm6vGUypq83XMhCBm
        KhNDuxbG9jtVxBVCmrfAQLdVhYkd5TYFt7PgHj9QDtMxS3HbnOi0jRCM/cx2//Tu4K+GnAVUIJ7LH
        dSjLAjfjzKEZq9E6vPpGVlW6dKjLSczDVbzfgMGn/tQr5jwFcILKc0m15jbKUvEeYfHEXa5yEMgQM
        oEVnHYu2J2En78QFAwmdgmogdVXonSBmJsU6xIyHJbVzQSGd0IGs5hEnNymY7/wROIExUwJpKu4Ke
        MJ3JeK43p0BM+MHVaUoTXhaOomaQs/7MexRxKnPfJa4MINw81IhKkICM3G85Wk4KP5N5YDOHlaK+3
        3lLWDRgA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mEoVl-00GVYM-0y; Sat, 14 Aug 2021 07:55:29 +0000
Date:   Sat, 14 Aug 2021 08:55:21 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Christoph Hellwig <hch@infradead.org>, song@kernel.org,
        linux-raid@vger.kernel.org, jens@chianterastutte.eu,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] raid1: ensure bio doesn't have more than BIO_MAX_VECS
 sectors
Message-ID: <YRd26VGAnBiYeHrH@infradead.org>
References: <20210813060510.3545109-1-guoqing.jiang@linux.dev>
 <YRYj8A+mDfAQBo/E@infradead.org>
 <0eac4589-ffd2-fb1a-43cc-87722731438a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0eac4589-ffd2-fb1a-43cc-87722731438a@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Aug 13, 2021 at 04:38:59PM +0800, Guoqing Jiang wrote:
> 
> Ok, thanks.
> 
> > In general the size of a bio only depends on the number of vectors, not
> > the total I/O size.  But alloc_behind_master_bio allocates new backing
> > pages using order 0 allocations, so in this exceptional case the total
> > size oes actually matter.
> > 
> > While we're at it: this huge memory allocation looks really deadlock
> > prone.
> 
> Hmm, let me think more about it, or could you share your thought? ????

Well, you'd need a mempool which can fit the max payload of a bio,
that is BIO_MAX_VECS pages.

FYI, this is what I'd do instead of this patch for now.  We don't really
need a vetor per sector, just per page.  So this limits the I/O
size a little less.

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3c44c4bb40fc..5b27d995302e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1454,6 +1454,15 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		goto retry_write;
 	}
 
+	/*
+	 * When using a bitmap, we may call alloc_behind_master_bio below.
+	 * alloc_behind_master_bio allocates a copy of the data payload a page
+	 * at a time and thus needs a new bio that can fit the whole payload
+	 * this bio in page sized chunks.
+	 */
+	if (bitmap)
+		max_sectors = min_t(int, max_sectors, BIO_MAX_VECS * PAGE_SIZE);
+
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      GFP_NOIO, &conf->bio_split);
