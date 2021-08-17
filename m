Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A3FC4338F
	for <linux-raid@archiver.kernel.org>; Tue, 17 Aug 2021 05:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22E4560F58
	for <linux-raid@archiver.kernel.org>; Tue, 17 Aug 2021 05:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhHQFH5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhHQFH4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Aug 2021 01:07:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639CAC061764;
        Mon, 16 Aug 2021 22:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3Z86cz3fUNgUETYamNMxas9xIITKTvan2RKjjEQ9x00=; b=UaOVQE/N0fV+9/EssgYNczuBeF
        ZyfWZOo85hiAPa5fSOQBFHUA2//KPBUDuATUurJkn2IZcpgtE8LH+XPEB+TCcA0qi60gwtXOAukjF
        XqGQqeU8DKNQUQIONsLzEuqSqZmLOFD9VfZHFpwR5AVI52aUHGzBnTfPwT45fNv/X/sbu/BQLRi1B
        BPH0bg3nvV8TQS8uZcKz8sj+nBXTD3jo98R5psMrh9P5xF42pYOfSGwL9OjS9vboli17Hc582azl3
        QWj6YZtftrvDhmqGna3in2HBLydluh3ssPeq9oiMy8VeYEeIABp7Qvg0Ldl2h1pIzq5c0z7DB5jym
        2C6nXFVw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFrIi-0029sS-QU; Tue, 17 Aug 2021 05:06:27 +0000
Date:   Tue, 17 Aug 2021 06:06:12 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org,
        linux-raid@vger.kernel.org, jens@chianterastutte.eu,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] raid1: ensure bio doesn't have more than BIO_MAX_VECS
 sectors
Message-ID: <YRtDxEw7Zp2H7mxp@infradead.org>
References: <20210813060510.3545109-1-guoqing.jiang@linux.dev>
 <YRYj8A+mDfAQBo/E@infradead.org>
 <0eac4589-ffd2-fb1a-43cc-87722731438a@linux.dev>
 <YRd26VGAnBiYeHrH@infradead.org>
 <YReFYrjtWr9MvfBr@T590>
 <YRox8gMjl/Y5Yt/k@infradead.org>
 <YRpOwFewTw4imskn@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRpOwFewTw4imskn@T590>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Aug 16, 2021 at 07:40:48PM +0800, Ming Lei wrote:
> > > 
> > > 0 ~ 254: each bvec's length is 512
> > > 255: bvec's length is 8192
> > > 
> > > the total length is just 512*255 + 8192 = 138752 bytes = 271 sectors, but it
> > > still may need 257 bvecs, which can't be allocated via bio_alloc_bioset().
> > 
> > Yes, we still need the rounding magic that alloc_behind_master_bio uses
> > here.
> 
> But it is wrong to use max sectors to limit number of bvecs(segments), isn't it?

The raid1 write behind code cares about the size ofa bio it can reach by
adding order 0 pages to it.  The bvecs are part of that and I think the
calculation in the patch documents that a well.
