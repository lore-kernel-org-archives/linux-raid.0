Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78302C433EF
	for <linux-raid@archiver.kernel.org>; Sat, 21 May 2022 11:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352606AbiEULvU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 May 2022 07:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354851AbiEULvL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 May 2022 07:51:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2799711165;
        Sat, 21 May 2022 04:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zCup3J0Qp2ghHCxB1jX7uxl+Bb
        uCRMTflvxLESHJQnmJWjBjD3WMfP6SQfSrODRN23TC49L39DXw943fqkdn7kopKNx4itTSIC9WE7/
        Xqb/ZZjKJAlztspCZVL6zD/QrffY9oWULRlN2A2zNtVzVKQg63EjxjoPhwc6kInZJ6P3oWpOsNmy5
        +OG73L1mSdY0z0M1EiR+Ug03+Wn6SYHe1qauzfoooo2aS8Ae7kXs136jWR29/nIjVYzFSKpa7Bf1P
        lN64CG9zd3Ghz5uziiiwFr4IdK3fdwfvFPoOHY2qlF9Cz6hSKixR9qv6YokW7FnaYwqBFzk5h4f6M
        msLJC8cg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsNdW-00GQrh-K2; Sat, 21 May 2022 11:51:10 +0000
Date:   Sat, 21 May 2022 04:51:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v1 13/15] md/raid5-cache: Annotate pslot with __rcu
 notation
Message-ID: <YojSLm7jrqZBZbQw@infradead.org>
References: <20220519191311.17119-1-logang@deltatee.com>
 <20220519191311.17119-14-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519191311.17119-14-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
