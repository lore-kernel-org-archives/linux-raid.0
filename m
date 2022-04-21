Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F05C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 21 Apr 2022 06:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384689AbiDUGNM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Apr 2022 02:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbiDUGNK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 21 Apr 2022 02:13:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BAC13CD5;
        Wed, 20 Apr 2022 23:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=18xk0KT5B86gCiyEjqVUpD20TLPm7YxWiS57uAbCHcY=; b=zeJ+OM3dBqjlIlEfQ2ghD0PZm7
        kLxWTmdUZn3/hB2WTYhFVFFKzMVq/Z+XjALwi6wWZNAMOETDdH3HvbPN3VIer4Iz56Z247wQ/fJtJ
        Leqet9JRS0A5FjxbciRT6B8w8HoQWitihRJQSlq0WZ4mjCzGmxrCc2typkG/B2hyRRy3Rbru/e3Zp
        4Nvn+9wv4iRXLZZTjDCcB8rOiz4HY559iiiyQLTWrDYGfBRcy87mOi0rJJXrZ56+0HDcNw2LTA7oB
        nPuqXSbr9sPCx6WQk/nrsZsJAHTJ2hjm6XyZE4FyIaCd70GuwsYRHtvNNH5Ez4AkZdQZXzP443Nh2
        w70JBZ2A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nhQ1F-00BdlH-Ia; Thu, 21 Apr 2022 06:10:21 +0000
Date:   Wed, 20 Apr 2022 23:10:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v2 04/12] md/raid5: Move common stripe count increment
 code into __find_stripe()
Message-ID: <YmD1Tenc2Ylu+biA@infradead.org>
References: <20220420195425.34911-1-logang@deltatee.com>
 <20220420195425.34911-5-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420195425.34911-5-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Apr 20, 2022 at 01:54:17PM -0600, Logan Gunthorpe wrote:
> Both uses of find_stripe() require a fairly complicated dance to
> increment the reference count. Move this into a common find_get_stripe()
> helper.
> 
> No functional changes intended.

The subject is wrong now.

>  static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t sector,
> -					 short generation)
> +					 short generation, int hash)
>  {
>  	struct stripe_head *sh;
>  
> @@ -624,6 +624,49 @@ static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t sector,
>  	return NULL;
>  }

And the new hash argument here is not needed.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
