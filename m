Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472E5C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  8 Apr 2022 06:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbiDHGHg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Apr 2022 02:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbiDHGH1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Apr 2022 02:07:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEBF5E159;
        Thu,  7 Apr 2022 23:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WSu7ihnrt2riifE0fS98ZAhqbUCB2kG4wJsBXdegcg8=; b=UY/ReC248H1H5Y7Y4dabjotvcr
        jtJitwjv6/z4GMP9cFDT0Szmlvry5TAjzFf9IVij6n8TQSSzkNWjGJiIRNeOdrBmrq345rgiODoZ2
        5haivZWAY+k0wlgcHG2lK7R/eBNButJYXwKQx3j7Mahe026ZpwDyJRCZwlhQH3XWlCN0LiL39G3c9
        fA57xLV735hKev4rIsT6+mAcY8O15WU18V6aZBT4TNXy2mVStLvdV/BS01/pG5xuhELnvxXB5mm9/
        HQzn/6+E051HlSo3VerLHt/ZYDepaF3NUs+KqmQNm1ftgdFBxKDEc0yTi79CzCMrppClG48M2M+rr
        vBVTrnKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nchkK-00FE9Z-Pf; Fri, 08 Apr 2022 06:05:24 +0000
Date:   Thu, 7 Apr 2022 23:05:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>, Shaohua Li <shli@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v1 6/8] md/raid5: Refactor add_stripe_bio()
Message-ID: <Yk/QpHltKpxEc0yd@infradead.org>
References: <20220407164511.8472-1-logang@deltatee.com>
 <20220407164511.8472-7-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407164511.8472-7-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Apr 07, 2022 at 10:45:09AM -0600, Logan Gunthorpe wrote:
> +static int stripe_bio_overlaps(struct stripe_head *sh, struct bio *bi,
> +			       int dd_idx, int forwrite)

This might be a good time to switch the int used as boolean return
value to an actual bool.

> +	pr_debug("checking bi b#%llu to stripe s#%llu\n",
> +		 (unsigned long long)bi->bi_iter.bi_sector,
> +		 (unsigned long long)sh->sector);

sector_t has always been a u64 for years, so these casts are not
needed.
