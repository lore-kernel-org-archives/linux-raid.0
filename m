Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5838C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  8 Apr 2022 06:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbiDHGKm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Apr 2022 02:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiDHGKl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Apr 2022 02:10:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB72312B5E3;
        Thu,  7 Apr 2022 23:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=w118xfJjXBhTzYmwil9Bnt9Ri8
        3BVSZPliD0zFlaGLKjf3YBeLqM2n3lbfqA41a2DhCXVD5fjh5ENf4Rpgn7Xp8dB1UxjIohYpC7wNV
        nIwBjhFSkISR4FaWtfcme+p7s756MdImBs5x5Z5UH8EaqqvU89jbE1U2wmU3T+b4drwsO+2lV5l2C
        Ide5GfPc4dCp0VaTHuV5mlFBBpke8f6icEFkM+MTpbWEO0QCJ8PByX+GtrbPfpZuBLA6wvt8i1NYL
        gppl1YniAiDTdCcb0REpqWG37GVLm0SGAQod9S84TZWYBmwAMUyFQUfN+Jv6wv59c81bb4kMOju9m
        RJ6+tWSQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nchnQ-00FEZ8-FC; Fri, 08 Apr 2022 06:08:36 +0000
Date:   Thu, 7 Apr 2022 23:08:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH v1 7/7] md/raid5: Annotate functions that hold
 device_lock with __must_hold
Message-ID: <Yk/RZBMB/K06BQKS@infradead.org>
References: <20220407165713.9243-1-logang@deltatee.com>
 <20220407165713.9243-8-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407165713.9243-8-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
