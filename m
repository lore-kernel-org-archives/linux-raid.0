Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03DAEC4320A
	for <linux-raid@archiver.kernel.org>; Sat, 14 Aug 2021 08:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC20260F46
	for <linux-raid@archiver.kernel.org>; Sat, 14 Aug 2021 08:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbhHNI5w (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 14 Aug 2021 04:57:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237543AbhHNI5v (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 14 Aug 2021 04:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628931442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hVaGgxPnEuUaeVNs1e3S9yjlL7gUklGWzlvGDXZIRvc=;
        b=efYTrMuNZpbF8h40ieJd6aax+8kQd51t2ZXzvIXYt6HDt0GlSIa0cH6PCfbENggOubj/p9
        lrLcKo7UH6FFOI/rn8FaBW0yqU997H0mEGXwmejAtSy1KX5/a8+Fgn02y1FmDFK27WEXtk
        y8ybfmGGELPqoL1jNIsXHjTsWU5pHwE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-kmYA8s_vNyajXmJosHO4ow-1; Sat, 14 Aug 2021 04:57:21 -0400
X-MC-Unique: kmYA8s_vNyajXmJosHO4ow-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82B4D1853025;
        Sat, 14 Aug 2021 08:57:19 +0000 (UTC)
Received: from T590 (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 60F2818A77;
        Sat, 14 Aug 2021 08:57:10 +0000 (UTC)
Date:   Sat, 14 Aug 2021 16:57:06 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org,
        linux-raid@vger.kernel.org, jens@chianterastutte.eu,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] raid1: ensure bio doesn't have more than BIO_MAX_VECS
 sectors
Message-ID: <YReFYrjtWr9MvfBr@T590>
References: <20210813060510.3545109-1-guoqing.jiang@linux.dev>
 <YRYj8A+mDfAQBo/E@infradead.org>
 <0eac4589-ffd2-fb1a-43cc-87722731438a@linux.dev>
 <YRd26VGAnBiYeHrH@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRd26VGAnBiYeHrH@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Aug 14, 2021 at 08:55:21AM +0100, Christoph Hellwig wrote:
> On Fri, Aug 13, 2021 at 04:38:59PM +0800, Guoqing Jiang wrote:
> > 
> > Ok, thanks.
> > 
> > > In general the size of a bio only depends on the number of vectors, not
> > > the total I/O size.  But alloc_behind_master_bio allocates new backing
> > > pages using order 0 allocations, so in this exceptional case the total
> > > size oes actually matter.
> > > 
> > > While we're at it: this huge memory allocation looks really deadlock
> > > prone.
> > 
> > Hmm, let me think more about it, or could you share your thought? ????
> 
> Well, you'd need a mempool which can fit the max payload of a bio,
> that is BIO_MAX_VECS pages.
> 
> FYI, this is what I'd do instead of this patch for now.  We don't really
> need a vetor per sector, just per page.  So this limits the I/O
> size a little less.
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 3c44c4bb40fc..5b27d995302e 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1454,6 +1454,15 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>  		goto retry_write;
>  	}
>  
> +	/*
> +	 * When using a bitmap, we may call alloc_behind_master_bio below.
> +	 * alloc_behind_master_bio allocates a copy of the data payload a page
> +	 * at a time and thus needs a new bio that can fit the whole payload
> +	 * this bio in page sized chunks.
> +	 */
> +	if (bitmap)
> +		max_sectors = min_t(int, max_sectors, BIO_MAX_VECS * PAGE_SIZE);

s/PAGE_SIZE/PAGE_SECTORS

> +
>  	if (max_sectors < bio_sectors(bio)) {
>  		struct bio *split = bio_split(bio, max_sectors,
>  					      GFP_NOIO, &conf->bio_split);
> 

Here the limit is max single-page vectors, and the above way may not work,
such as:

0 ~ 254: each bvec's length is 512
255: bvec's length is 8192

the total length is just 512*255 + 8192 = 138752 bytes = 271 sectors, but it
still may need 257 bvecs, which can't be allocated via bio_alloc_bioset().

One solution is to add queue limit of max_single_page_bvec, and let
blk_queue_split() handle it.



Thanks,
Ming

