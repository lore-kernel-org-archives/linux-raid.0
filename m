Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F91FECAAA1
	for <linux-raid@archiver.kernel.org>; Mon,  5 Sep 2022 05:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbiIEFvd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Sep 2022 01:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbiIEFvb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Sep 2022 01:51:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8C926540;
        Sun,  4 Sep 2022 22:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oxHDQNWHeVqsXOYaI/9HoISVUu
        fhiAavbaGxvRM9x11NPh+k6VK5NldTlPGSqLP6SeDrWjGF5pRumgHlQYQsQewKi/46TAAu7jnaDEv
        xLXQRR3RMbM7BMgMGt5JdcnNpt0klHApwyA4MDYt5qpxF92+/8ZcUAKaWl1R2dID6tOiBbUrSFm+P
        jhBaPnvK0BFINP8d3oy2TO8U46Pzz5Ozlj4sBRH/cATRUgZOttVnroKAfqUUvVCoAN3tYQUJ5YSMc
        pXCOcaROZMUh0eIw7i8EuAxI/8Y+b6ifEIq6p9FITm9TD9+oWE9OSytHXbGZ0DuO4tauxyam6iaS9
        xuUVWRvA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oV514-00BWXw-Ch; Mon, 05 Sep 2022 05:51:26 +0000
Date:   Sun, 4 Sep 2022 22:51:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH 1/2] md/raid5: Remove unnecessary bio_put() in
 raid5_read_one_chunk()
Message-ID: <YxWOXi9XfatrQAxk@infradead.org>
References: <20220902171609.23376-1-logang@deltatee.com>
 <20220902171609.23376-2-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902171609.23376-2-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
