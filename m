Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF74EC433EF
	for <linux-raid@archiver.kernel.org>; Fri,  8 Apr 2022 06:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbiDHGFz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Apr 2022 02:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235061AbiDHGFx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Apr 2022 02:05:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD1734641;
        Thu,  7 Apr 2022 23:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=N0WCejp+v+kyXa7cm3NCWrsAo5fYHCElP+vP7DGqpkU=; b=hNcKPuqRNNbmPcChDNCCWTTrgS
        a34qrQmpXbirui9gVV1SrlYppFQpXwSJxzHPeu9ekJBzyqnp1DtqMKLgC4lFdc9daWW9jGvG2CiqV
        a7gmPwDv5LVEc4YMdRLh237xnQOZggoe4awfIcDdx96GyrYxP7BSta38ZxY5YrjWeG43WvH5Q4Q/v
        cJVQIqXKTDp/APn41qpqFnHT0tuh9G3xuGLTXHkMDY1lLaJOY7kn/+QGA64fsq29AXgO6DVJPxJUB
        /WGprhCkCaE9mYs2xI5YIihYciQf5xV+8dzGWZyg1mKbmZquNkoM0rLF6US0e57A+cN18EYPWcWbl
        Ujj4Jg+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nchin-00FE15-UP; Fri, 08 Apr 2022 06:03:49 +0000
Date:   Thu, 7 Apr 2022 23:03:49 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>, Shaohua Li <shli@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v1 4/8] md/raid5: Make common label for schedule/retry in
 raid5_make_request()
Message-ID: <Yk/QRWBOUhglpFn6@infradead.org>
References: <20220407164511.8472-1-logang@deltatee.com>
 <20220407164511.8472-5-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407164511.8472-5-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Apr 07, 2022 at 10:45:07AM -0600, Logan Gunthorpe wrote:
> Cleanup the code to make a common label for the schedule,
> prepare_to_wait() and retry path. This drops the do_prepare boolean.
> 
> This requires moveing the prepare_to_wait() above the
> read_seqcount_begin() call on the retry path. However there's no
> appearant requirement for ordering between these two calls.
> 
> This should hopefully be easier to read rather than following the
> extra do_prepare boolean, but it will also be used in a subsequent
> patch to add more code common to all schedule() calls.

Hm.  Maybe it is marginally better, but I always hate gotos inside
of loop bodys.  What prevents us from factoring most of the loop
body into a helper function?
