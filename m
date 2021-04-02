Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0132C433B4
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 10:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0ECA610FC
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 10:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhDBKss (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Apr 2021 06:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhDBKsr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 2 Apr 2021 06:48:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EB5C0613E6
        for <linux-raid@vger.kernel.org>; Fri,  2 Apr 2021 03:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PVx18KOtnb6FaB0oYKWHJ5qftiok+MYQK2IaFqG2Vd0=; b=fQK/neqN86x9f737PHaOvW8/t/
        MpZ55jJs1cIY8v5wlHi5PvT9/PQBrzlGCM1R8Su6prdfNqwSrqrRobuv3ymzd29lv34FfWFHBR+bJ
        8wWIoTSMXbM9d6mssPvGviJCuWvQOBZOGgYZ/Ig9zEEvy/XgLiK7opZwxy5PIGaZl/WkTJ0NTtRCg
        JKWhBhOplj2uYEjOl6avAUzf5QEMuPZE9fjYOvptTMISpSB2E0zkIIeRT6SlTRkT6eIxOBKqbr/2C
        gCIS8bedHghoHE2u0dR1HVg3xwQCIUvniXa6pu/WWpOo56roX+Dy+yyQbBQIpF6mx2mjaCxf4crwJ
        KJihDZuw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSHLX-007XtD-6H; Fri, 02 Apr 2021 10:48:16 +0000
Date:   Fri, 2 Apr 2021 11:48:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <song@kernel.org>
Cc:     "heming.zhao@suse.com" <heming.zhao@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        lidong.zhong@suse.com, Xiao Ni <xni@redhat.com>,
        NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.com>
Subject: Re: [PATCH v2] md: don't create mddev in md_open
Message-ID: <20210402104811.GA1798339@infradead.org>
References: <1617240896-15343-1-git-send-email-heming.zhao@suse.com>
 <20210401061722.GA1355765@infradead.org>
 <a96554cc-abbd-347c-ea24-37d2a41e6073@suse.com>
 <CAPhsuW6_9av6H=1LkD5qqpyOcA8j2jj8d660FUpadn3Jfd79Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW6_9av6H=1LkD5qqpyOcA8j2jj8d660FUpadn3Jfd79Vw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Apr 01, 2021 at 10:58:54PM -0700, Song Liu wrote:
> Hi Christoph and Heming,
> 
> Trying to understand the whole picture here. Please let me know if I
> misunderstood anything.
> 
> IIUC, the primary goal of Christoph's set is to get rid of the
> ERESTARTSYS hack from md,
> and eventually move bd_mutext. 02/15 to 07/15 of this set cleans up
> code in md.c, and they
> are not very important for the rest of the set (is this correct?).

Yes, at least that is the long term goal.

But as posted in this thread we can just split the two patches out
to do the same thing that the patch from Heming did, without making more
of a mess of mddev_find.  I can resend them separately as a small series
instead of the attachment if that makes them easier to review.
