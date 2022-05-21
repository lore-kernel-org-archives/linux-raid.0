Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1B2C433F5
	for <linux-raid@archiver.kernel.org>; Sat, 21 May 2022 11:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244945AbiEULiX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 May 2022 07:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349464AbiEULiP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 May 2022 07:38:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC8B50473;
        Sat, 21 May 2022 04:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tBG+QAHfylo0Vezf2SxMj6xAkG
        s85+FEczMn8zbrHbIv+ZNs5vCRTdQbKiPv/ebIHRWcA0iR4FMCFUZeBeBwkDmTnfLabCVBdxQbkBX
        vpYFjoS2b74qw0h2vRjO1YJpe71LRwl3qqswV9+jDZmo+01njk4Ddj0vx0wzcHGj3gYAhfqOO1Gq/
        vN5XlUTChKVJ6BoAoBmD33J5ClMuJliJ8lssKHQ2fcq2bMpvRr4Oy0MhZE4Vjck9/IE1J9wvZeBxT
        lC3+XYzLVJ7OR3YyuAyVKWQGfy1XIb9fd4uvR93ocQ+e2toJiiWPU548FhFd7L/xARhlNdNd1y3+W
        1gmN3/GA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsNQu-00GPG9-Ic; Sat, 21 May 2022 11:38:08 +0000
Date:   Sat, 21 May 2022 04:38:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v1 04/15] md/raid5-cache: Refactor
 r5l_flush_stripe_to_raid() to take a struct r5conf
Message-ID: <YojPIDmU8zfkxYuS@infradead.org>
References: <20220519191311.17119-1-logang@deltatee.com>
 <20220519191311.17119-5-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519191311.17119-5-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
