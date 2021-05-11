Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80169C433B4
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 04:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FEA86191F
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 04:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhEKElE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 May 2021 00:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhEKElD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 May 2021 00:41:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447A7C061574;
        Mon, 10 May 2021 21:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=20LHnlnumNu0S4uklyLlpEJ56Pdr62kAvnnn+1GZFf4=; b=dH37xnoJgSLICkKar22gfCMZ20
        OkRgim9SIXTsOt2j/3OU2+fYm/JVhbcihTtInwHHhnXdFMNHIuBIrjlv3XPjSTkiIiCU3kvUQ3RfH
        DIc3nY3WPaqFYqMud4Nt7gakGCYSinQpa02PC0L1JZDP3wavh/g55dnUtF/N5u8XOSz2PEuIzzkE9
        /ZV76LIvx2nKey/pkhYHZL+DRFEeNs2raD57ssgl8Flp5VLuzckTzZfRVxITHSzQ1YzpZgmdjKS+p
        Rt9R0hD8b8NQ19FXKmnign77n3juHMxlc8NfdsZOHVllcf5lcdM6ofeLxglb+56ZChLhcVVz+y78j
        2Qvc6/fg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lgK9x-006udr-Ej; Tue, 11 May 2021 04:38:25 +0000
Date:   Tue, 11 May 2021 05:38:17 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Christoph Hellwig <hch@infradead.org>, song@kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        pawel.wiejacha@rtbhouse.com
Subject: Re: [PATCH] md: don't account io stat for split bio
Message-ID: <YJoKOT8U7+9fyraj@infradead.org>
References: <20210508034815.123565-1-jgq516@gmail.com>
 <YJjL6AQ+mMgzmIqM@infradead.org>
 <14a350ee-1ec9-6a15-dd76-fb01d8dd2235@gmail.com>
 <6ffb719e-bb56-8f61-9cd3-a0852c4acb7d@intel.com>
 <c1bc42ff-eae7-d0ba-505d-9c6a19d60e93@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1bc42ff-eae7-d0ba-505d-9c6a19d60e93@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 11, 2021 at 10:13:41AM +0800, Guoqing Jiang wrote:
> > > Song and Artur, what are your opinion?
> > In the initial version of the io accounting patch the bio was cloned instead
> > of just overriding bi_end_io and bi_private. Would this be the right approach?
> > 
> > https://lore.kernel.org/linux-raid/20200601161256.27718-1-artur.paszkiewicz@intel.com/
> 
> Maybe we can have different approach for different personality layers.
> 
> 1. raid1 and raid10 can do the accounting in their own layer since they
> already
> ?????? clone bio here.
> 2. make the initial version handles other personality such as raid0 and
> raid5
> ?????? in the md layer.
> 
> Also a sysfs node which can enable/disable the accounting could be helpful.

Yes.  Also if the original bi_end_io is restore before completing the
bio you can still override it.
