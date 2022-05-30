Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7A6C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 30 May 2022 05:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbiE3F4V (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 May 2022 01:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbiE3F4U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 May 2022 01:56:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D3C66F9E;
        Sun, 29 May 2022 22:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=s0zhtSdZDf+E4ShiSmCTSdP5gh
        vvO5ObOpQpLqm07DqDiKWJiU3YtubIafN2ykZ7WSMWTuaGNZ8VOpS+CdW8G1/xLPpZ5nHYbXEnQvp
        Uev0ZlpGbpijQP+5q864okDXjMWLpgg7bONvnfu+FcluCoOORL8P6SqNopDSrbEfSpbKOvkqtJVDX
        7GEQ1HxX+RDxzO81eYmKh7SwDMiPIiebz5ffd3aBvzE57BNcmBB71NiJc2b+ukCwStHlzdXwqWGu4
        IdkXCLKsV/h85+GIC5OgsXX1WRTLptCYL33gys3Mg4eBHlLK5qTFZRasQw6geP2JaDYEi5gTm+SSD
        0PaWOXjg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nvYNy-005Tm6-Cl; Mon, 30 May 2022 05:56:14 +0000
Date:   Sun, 29 May 2022 22:56:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v2 02/17] md/raid5-cache: Add r5c_conf_is_writeback()
 helper
Message-ID: <YpRcfjcFgDcPBqYw@infradead.org>
References: <20220526163604.32736-1-logang@deltatee.com>
 <20220526163604.32736-3-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526163604.32736-3-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
