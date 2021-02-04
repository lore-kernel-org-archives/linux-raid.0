Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09FAC43381
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 07:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C40C64F55
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 07:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhBDHUk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 02:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbhBDHUI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Feb 2021 02:20:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75F1C061788
        for <linux-raid@vger.kernel.org>; Wed,  3 Feb 2021 23:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1W9bS0NsA1aYv+UU3aEvXrwAmd3THeSXCDDzdbRT5YI=; b=cK9ObO6ef6/I1b8Z9UlhdD/bQ4
        nHc5iS/g4YI/cgTvE1q9LLtwy6wnKv5/MKRSpG4waXiCs4mqNlEQn7dducatlzYdFpPsav8yuufp9
        u30Te6hXgswZznueEgk6Goiy2K6M8LUP0gujAjdo36kEmdE3oWdCHs06cYtz6YBmMWouZcXOiZuVL
        J4mJjz/duO7nxiLBEYHmJ5YWSwk7iM/dWwKaSC1cIzcGCBdXKKSa142ZW7uHEduTyUzSRE4qMYkxD
        pmmGF7jw8jEjGs+Xlza9I/c9MMa7M2lMXDhAC7iR97sAHJOFpqGnZJuKtYWe/LGbxXg/m4/4fliH4
        L0yuoj4A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Yv6-000WE2-L1; Thu, 04 Feb 2021 07:19:17 +0000
Date:   Thu, 4 Feb 2021 07:19:16 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Xiao Ni <xni@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, songliubraving@fb.com,
        linux-raid@vger.kernel.org, matthew.ruffell@canonical.com,
        colyli@suse.de, guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com
Subject: Re: [PATCH 1/5] md: add md_submit_discard_bio() for submitting
 discard bio
Message-ID: <20210204071916.GA123308@infradead.org>
References: <1612359931-24209-1-git-send-email-xni@redhat.com>
 <1612359931-24209-2-git-send-email-xni@redhat.com>
 <20210203154425.GA4078626@infradead.org>
 <f2b663fd-349b-56b4-5b9b-3103184dbdda@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b663fd-349b-56b4-5b9b-3103184dbdda@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 04, 2021 at 12:07:58PM +0800, Xiao Ni wrote:
> > > +extern void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
> > > +			struct bio *bio, sector_t start, sector_t size);
> > no need for the extern.
> > 
> Hi Christoph
> 
> It needs to export it here. If not, there is compile error.
> 
> raid0.c:502:3: error: implicit declaration of function
> ???md_submit_discard_bio??? [-Werror=implicit-function-declaration]
>    md_submit_discard_bio(mddev, rdev, bio,

Yes, the prototype needs to be in the header.  But the extern keyword
is no needed for function declarations.
