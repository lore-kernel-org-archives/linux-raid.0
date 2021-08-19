Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2931C4338F
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 08:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A15556109F
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 08:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhHSI5J (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Aug 2021 04:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhHSI5J (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Aug 2021 04:57:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624D4C061575;
        Thu, 19 Aug 2021 01:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=t2j00fcwtjdfugITzyV7IoRkwl4bJ89gqLKBUqgEM68=; b=eVHF0ajU3zoZ706J5Io89VYGjk
        483z9qt4fyf22B+A+lSGhDoZkH9wsdfIg3KMf6hAmpLkaO1D3ZxJH5DgQekX6H1vSc/p387tLWX4/
        tT7kdGZ9rY3PsGPeMsFn8TA/lMOMskZ68tKiQicAap2groq4d0m8PU8CZjHMtecOw3AgMzefSsEMy
        6bntZsqiHG0rSFvUZ1zctTdQ/maDeBbPC0PxwLr6SIYViOYdX6u7kA+VCgM7pWzjV1Iq4tH9v2eB2
        SJ6zHuoYBGentzKZjM8vpK6kZoC+I7DWXSsWpptATDQo3al6P+dzGTlsjqcu3BgZcbfD1PugdE0xr
        Y2VcD3QQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mGdpz-004qFr-B9; Thu, 19 Aug 2021 08:55:57 +0000
Date:   Thu, 19 Aug 2021 09:55:47 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH V2] raid1: ensure write behind bio has less than
 BIO_MAX_VECS sectors
Message-ID: <YR4ckyTCiOXCRnue@infradead.org>
References: <20210818073738.1271033-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818073738.1271033-1-guoqing.jiang@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Aug 18, 2021 at 03:37:38PM +0800, Guoqing Jiang wrote:
>  	for (i = 0;  i < disks; i++) {
>  		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
> +
> +		if (test_bit(WriteMostly, &mirror->rdev->flags))
> +			write_behind = true;

How does this condition relate to the ones used for actually calling
alloc_behind_master_bio?  It looks related, but as someone not familiar
with the code I can't really verify if this is correct, so a comment
explaining it might be useful.

> +	/*
> +	 * When using a bitmap, we may call alloc_behind_master_bio below.
> +	 * alloc_behind_master_bio allocates a copy of the data payload a page
> +	 * at a time and thus needs a new bio that can fit the whole payload
> +	 * this bio in page sized chunks.
> +	 */
> +	if (write_behind && bitmap)
> +		max_sectors = min_t(int, max_sectors, BIO_MAX_VECS * PAGE_SECTORS);

Overly long line here.
