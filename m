Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B87E3C433ED
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 06:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 962E5611AE
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 06:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbhESGWd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 02:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234902AbhESGWd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 May 2021 02:22:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20975C06175F
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 23:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ji3ZqmsYMdwOEkR7JuoL/LF8PBJroCX9cNh1m/4zMOA=; b=BHEWX5FhdNvZOPOTsu0gTVbK2u
        QygI7IJIvBuusybsBabPe04GclV4iOmIGAgI1P2vmdQA+pU2ufNQJINHo9+cSS8Gz2I6RWhWyVqST
        jbqn9rKr6f6wb7pSbVG/PhlIq+uUK6NAJg2D82znuDhYnEeLgUFscb8JF+DdE6APTUy2QUIhLsB7c
        dHMk8KR/2QAdpiR76nwyssCKyxgkmClzXB1CohzklrPnKqXpbnt2doLLaoWEgcvI6MvLYhBQ9Y7BE
        L8j3Zz162Vi+2rBffvCSsOEQYxFNrfXbw9xtq/XdZqrvREtol/tRTxm7KnaFvTSRn7+uln+yga0fA
        qMGTU8IA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ljFZA-00EgWi-2J; Wed, 19 May 2021 06:20:34 +0000
Date:   Wed, 19 May 2021 07:20:24 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     Song Liu <song@kernel.org>, "Florian D." <spam02@dazinger.net>,
        linux-raid <linux-raid@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Linux-5.12 regression
Message-ID: <YKSuKP41/tQmK13/@infradead.org>
References: <F368C0E3-1315-42B8-8328-441D2F7ABAC3@dazinger.net>
 <CAPhsuW6rBJFmrT8vZJ4fyoSvY3Z16_Hy8oo67=jkHra64AfmbQ@mail.gmail.com>
 <50b93926-a51c-146f-e9ac-51c4b36dc5a3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50b93926-a51c-146f-e9ac-51c4b36dc5a3@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, May 19, 2021 at 10:05:27AM +0800, Guoqing Jiang wrote:
> Agree, not sure why it is added in 10433d04b8e6, cc Christoph.

To ensure the assumption that the removal of the call to
get_start_sect() was correct.  And at the time it was.  But 5.12
changed the code to remove bi_partno and keep the original bdev
in ->bi_bdev so it became incorret.  So yes, the assert should be
removed, but the commit it fixes is
309dca309fc3 ("block: store a block_device pointer in struct bio"),
not 10433d04b8e6.

I'll send you a fix.
