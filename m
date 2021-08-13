Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAF7C4338F
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 07:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E52E60F14
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 07:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbhHMHui (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Aug 2021 03:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239685AbhHMHug (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Aug 2021 03:50:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57015C061756;
        Fri, 13 Aug 2021 00:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5bHSC0OcYYpqgVdrVVEPqREHErUnImiipx0LepG8OT0=; b=c7LqmxdmehDtJubLNfyZ6o0f/F
        ++OEq04Wkr/NCgX5EDR+os2OTp+H8jOi2pbCLaW9LoyJS6BZwcR5vaEzmhHJysy/8elq1gfFgkeKC
        da1u7Cxh0lscgbU/F+2aEZRUYFoyq6Rdi50Anlf5auuuXaEZSqBKlbFol1IAQ/32C+sP0NSjx6z+Y
        B1WQI/mo88yv3iEo5i+UIpC73BHCdEmOjpQL47R7uaPWdA0WI/xy9WLNGBLd28dW4Yp8hYXz3pYDF
        MOB7OhpGVjBILBZlrs6QNLOja9XV9W4guYJUuxMam5zUZ9z8UaLCxLbrtTQMznPUxNXbPMZGFKP1h
        xH7l6qcA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mERw8-00FSpY-IR; Fri, 13 Aug 2021 07:49:25 +0000
Date:   Fri, 13 Aug 2021 08:49:04 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        jens@chianterastutte.eu, linux-block@vger.kernel.org
Subject: Re: [PATCH] raid1: ensure bio doesn't have more than BIO_MAX_VECS
 sectors
Message-ID: <YRYj8A+mDfAQBo/E@infradead.org>
References: <20210813060510.3545109-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813060510.3545109-1-guoqing.jiang@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Aug 13, 2021 at 02:05:10PM +0800, Guoqing Jiang wrote:
> From: Guoqing Jiang <jiangguoqing@kylinos.cn>
> 
> We can't split bio with more than BIO_MAX_VECS sectors, otherwise the
> below call trace was triggered because we could allocate oversized
> write behind bio later.
> 
> [ 8.097936] bvec_alloc+0x90/0xc0
> [ 8.098934] bio_alloc_bioset+0x1b3/0x260
> [ 8.099959] raid1_make_request+0x9ce/0xc50 [raid1]

Which bio_alloc_bioset is this?  The one in alloc_behind_master_bio?

In which case I think you want to limit the reduction of max_sectors
to just the write behind case, and clearly document what is going on.

In general the size of a bio only depends on the number of vectors, not
the total I/O size.  But alloc_behind_master_bio allocates new backing
pages using order 0 allocations, so in this exceptional case the total
size oes actually matter.

While we're at it: this huge memory allocation looks really deadlock
prone.
