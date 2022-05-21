Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA693C433EF
	for <linux-raid@archiver.kernel.org>; Sat, 21 May 2022 11:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243870AbiEULh7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 May 2022 07:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245233AbiEULh4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 May 2022 07:37:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D23F4AE2C;
        Sat, 21 May 2022 04:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2/f8b4uVSPs1bD36p9JNobQqcg
        /ybjyaqK5EgJloyrV6duWEz8mOxl4OQDsiHW+EAibEL0aIK1Skyh+QSvtMA6ZCEFWb6UmSdQigvYU
        deUUiXn5gmZjHESkypv5Kr3irVjBdmxbGCDXK/zjaHBmb2473heB3OnaLLEHQ4CM/dDi7LgUcMH/E
        4shrJ5ixS8PeSeIT0fw4e74IIsrTZXrLt2iZV4ZQN8isu2oOgpwimYm96iWWdM6awj9F/FZW1rMi6
        P6vir4+EfBhWKF0TmX1GXejWpOE9vN/2TvMB5uigom/mUY9+9odov4sX8KR9tSzskj9VjCCAcTREp
        vvo5sO7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsNQe-00GPDz-Pu; Sat, 21 May 2022 11:37:52 +0000
Date:   Sat, 21 May 2022 04:37:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v1 03/15] md/raid5-cache: Refactor r5l_start() to take a
 struct r5conf
Message-ID: <YojPEBA8riVz6F5z@infradead.org>
References: <20220519191311.17119-1-logang@deltatee.com>
 <20220519191311.17119-4-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519191311.17119-4-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
