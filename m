Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C821C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  8 Apr 2022 06:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbiDHGIH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Apr 2022 02:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbiDHGIG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Apr 2022 02:08:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328648BE0F;
        Thu,  7 Apr 2022 23:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=A6b+cX8hCB8oB11lm2BdzaQ+eWpWdm8tA3u4Ttvi6EI=; b=lr3uug1E9ClqhmRQnJUM6m4zvu
        H+QXpYVrltMP/5D4gXQTqD3G1Z076X+3471FD4Q1s6yc2pfwcSG51hiBuSrey1sUZP0iSCVEKH0Fl
        lsNknnudbq+Ga6SkkBuJ/d5hW9A1cQhtNUs2LKsyCymwKPczcAUhDzWvNMBmeO4CCBoW+MyQ6MNrJ
        3iFN4lRmkm8q0zv7eU+kH9R0XII2PasECvlKNYoBbRfHnLzDrl5RvMz2GrSQJemjR09kJpetHDJSh
        nzjCyWMVizGvs3kHid/EhnRxerV9emGCvMb073htfeYGzKnRT7LmWsvVvV1EG9pTNpMgkw3N3z9Xz
        tqDr+eVA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nchkw-00FEDs-QY; Fri, 08 Apr 2022 06:06:02 +0000
Date:   Thu, 7 Apr 2022 23:06:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH v1 1/7] md/raid5: Cleanup setup_conf() error returns
Message-ID: <Yk/Qyo/tAb0Q9xur@infradead.org>
References: <20220407165713.9243-1-logang@deltatee.com>
 <20220407165713.9243-2-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407165713.9243-2-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Apr 07, 2022 at 10:57:07AM -0600, Logan Gunthorpe wrote:
> Be more careful about the error returns. Most errors in this function
> are actually ENOMEM, but it forcibly returns EIO if conf has been
> allocated.
> 
> Instead return ret and ensure it is set appropriately before each goto
> abort.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
