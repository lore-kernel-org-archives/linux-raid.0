Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5015BC433EF
	for <linux-raid@archiver.kernel.org>; Sat, 21 May 2022 11:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349788AbiEULig (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 May 2022 07:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347029AbiEULia (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 May 2022 07:38:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004954E3AF;
        Sat, 21 May 2022 04:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SSAxOTelOLN5Jxl1NS58dDihvZ
        Mdzog89K+mwPEey6JwokUNeIq9K49oayhyxvu0uxoNqw16MqP2UzsqL/t3p1YZkJPgDwe+uSlH3ZK
        mfl34wn613KjN7jyyIEZ9KNDErzUNmgzFMXd2c29H1zzQy6+yRjeWvG+YtiRXc5ba5Myrc0T514uh
        J/CaGfGYWQhBNwVf/4+QHltuvr5nb3Hf/JhWlLIfudfoNmEaqkdAi8SrVdcmXIQ7FO+IJDVhrNiAv
        xGd8UVvYllzdJprZb/j/90Zl8iUxgKvEqjc5Xe9I0HCiBRPVDZ9cu9W6Lg74TDOBbRLluKC7J6AGG
        O507IRMw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsNRD-00GPIL-Ak; Sat, 21 May 2022 11:38:27 +0000
Date:   Sat, 21 May 2022 04:38:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v1 05/15] md/raid5-cache: Refactor r5l_wake_reclaim() to
 take a struct r5conf
Message-ID: <YojPM9D3sEgWZUOj@infradead.org>
References: <20220519191311.17119-1-logang@deltatee.com>
 <20220519191311.17119-6-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519191311.17119-6-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
