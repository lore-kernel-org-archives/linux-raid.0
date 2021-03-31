Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D1DC433E0
	for <linux-raid@archiver.kernel.org>; Wed, 31 Mar 2021 06:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4588E619BC
	for <linux-raid@archiver.kernel.org>; Wed, 31 Mar 2021 06:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhCaGz4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 Mar 2021 02:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbhCaGzm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 Mar 2021 02:55:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E4CC061574
        for <linux-raid@vger.kernel.org>; Tue, 30 Mar 2021 23:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ktvyXrAaX2feNcgR7kgLttRbcVDOMSL+F3bOHbKpGKc=; b=FoBEbKN+u/EvFBhwaXT0EwMROl
        FX9/4Q5P7EGCcRAoKAAQhrvoeJeW0alFv+uupgbWwlfzdQIonprkoq1DS/4KVGDH6FKFFSzGSld2o
        Usa5UdS1rPg/MjY5ZGJ6ZBshyKpdJWkx1bexKhy8XZyi12XPlbY8hwKr3xcI98vd8LufuMUYkx5P+
        vJLa+ALYoWdSBAkFc0kjrKwdgak922uARbDTGUhsO/I7NPhUe3d2o9c6JkDJ6eWsE4KJltMEJdoI2
        s9TnJW0ETuFiC254hBi/bqAqOfVvJny8U+HEnQAGQd7AaUk/BGg54oEIvy/FmJYilefRolNlaoXUL
        gHa8fUeA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lRUky-0049aT-UJ; Wed, 31 Mar 2021 06:55:19 +0000
Date:   Wed, 31 Mar 2021 07:55:12 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Zhao Heming <heming.zhao@suse.com>
Cc:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, lidong.zhong@suse.com,
        xni@redhat.com, neilb@suse.de, colyli@suse.com
Subject: Re: [PATCH] md: don't create mddev in md_open
Message-ID: <20210331065512.GA987842@infradead.org>
References: <1617090209-18648-1-git-send-email-heming.zhao@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617090209-18648-1-git-send-email-heming.zhao@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> -static struct mddev *mddev_find(dev_t unit)
> +static struct mddev *mddev_find(dev_t unit, bool create)

This just makes the mess that is mddev_find even worse.  Please take
a look at the patches at the beginning of the

  "move bd_mutex to the gendisk"

series to try to clean this up properly.
