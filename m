Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B56C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 07:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3620761926
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 07:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhEKHMX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 May 2021 03:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbhEKHMV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 May 2021 03:12:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D30C061574;
        Tue, 11 May 2021 00:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MmFfSO78QylSgUAN03rCUfzitKR9iSOK2FtmAm+OdKc=; b=d+Xv5crcClaup1OStoHAAXEBzz
        Ve+/0LPbt6jWzf/eZTlcNSrwVKshMBlfNbWcEK3Eoq9zfnsY/+9dRWukO+dymzbpcmr6PWYHGbmQE
        asxv+fCCtCCEoCp1Kk2gdIz5q7IpT3sDMfMKWMy+Qb2v7N8vhLM+X8LJi61BuKxCdqLvJsFFOTLFO
        8NfGbulf+hxQIuB1TrCM3qcLteuKpiYGORiZTqlPp981GsPdBopG0sK5Yptk+TSnvrFciVotwP9h8
        xXyqWYRvjrkLvBYG/5UWawBK6anieLczJi6PG+0QKxo8Mqi0ak/3rWansR0hg7M3RY9mvp1ulRpAq
        fowa/ulA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lgMX2-0071tH-Tz; Tue, 11 May 2021 07:10:25 +0000
Date:   Tue, 11 May 2021 08:10:16 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <song@kernel.org>
Cc:     Guoqing Jiang <jgq516@gmail.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org,
        Pawe?? Wiejacha <pawel.wiejacha@rtbhouse.com>
Subject: Re: [PATCH] md: don't account io stat for split bio
Message-ID: <YJot2JAZkQi7RPGS@infradead.org>
References: <20210508034815.123565-1-jgq516@gmail.com>
 <YJjL6AQ+mMgzmIqM@infradead.org>
 <14a350ee-1ec9-6a15-dd76-fb01d8dd2235@gmail.com>
 <6ffb719e-bb56-8f61-9cd3-a0852c4acb7d@intel.com>
 <c1bc42ff-eae7-d0ba-505d-9c6a19d60e93@gmail.com>
 <CAPhsuW44cc2p+29_rLqrq7i3R0d03sjtwRQtbLRkta+jzsdYsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW44cc2p+29_rLqrq7i3R0d03sjtwRQtbLRkta+jzsdYsw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, May 10, 2021 at 11:58:32PM -0700, Song Liu wrote:
> IIUC, the sysfs node is needed to get better performance (by disabling
> accounting)?

FYI, we already have that sysfs file in the block layer
("queue/iostats"), please just observe QUEUE_FLAG_IO_STAT flag.

> in md.c). This
> should simplify the code. If the user do not need extreme performance, we should
> keep the stats on (default). If the user do need extreme performance, s/he could
> disable stats via sysfs.

Given that the code already does a memory allocation it might as well
always clone and do away with the separate md_io allocation entirely.
Memory usage grows a bit, but it can reuse all the bio cloning
infrastructure.
