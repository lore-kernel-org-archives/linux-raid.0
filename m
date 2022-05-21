Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A910C433F5
	for <linux-raid@archiver.kernel.org>; Sat, 21 May 2022 11:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242466AbiEULhf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 May 2022 07:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiEULhb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 May 2022 07:37:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B85A49F35;
        Sat, 21 May 2022 04:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Nq+5bUiJgD0ysanEHlEuPFZYAr
        PPjsKaZYvb8hPB0IwabpCISY0VPbXcip0Qaex09Xfob4Nkn16yKI8gLfhiwX6T+eKwjSE5Cuo4ANx
        I63yaL5MN8BVVjd+VRo39MWZ1TfTllFmMEYYDRFRi+LAlKqyLjBAgY8R0Vc1Hai6PC6ywFAMNKu3k
        wHBouEDhIcSYbUhfFbkvxJOBbbSkI++NoO4kiN3yxCr2kFcQi2qlwT9imzKQvQ4iYLud1zd3qME7e
        JLDM0kx4yFAvt5oXiVK3SSWvpx1Ha9z+eY/ZbOnl5Ybgipf4sXr/Y4jXe8G7Jo2Xf/T7r3zURc694
        MwnPft/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsNQI-00GPAn-A5; Sat, 21 May 2022 11:37:30 +0000
Date:   Sat, 21 May 2022 04:37:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v1 02/15] md/raid5-cache: Refactor r5c_is_writeback() to
 take a struct r5conf
Message-ID: <YojO+j0zP5zEhOGn@infradead.org>
References: <20220519191311.17119-1-logang@deltatee.com>
 <20220519191311.17119-3-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519191311.17119-3-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
