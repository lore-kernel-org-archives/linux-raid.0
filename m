Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2812C43461
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 07:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73CDA61920
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 07:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhEKHNy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 May 2021 03:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbhEKHNw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 May 2021 03:13:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E8DC06175F;
        Tue, 11 May 2021 00:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eOY8yYpdUkKbsvKSZDEAFSODB7Xn0JEwcFi/rzXs6CQ=; b=SIrjJqleS3+gfsqy1qcIfNuwH9
        MqRMQ12J4EM9nBWxVSSV/zV6PP/zruLqkDgwpypZgz4COwWyAkUXDXrtkMhN0jvFm4qfHZ2sGre58
        /f7mNlLou/9QE/eM2GhLbi9vXTOuDXoKGxiNLglf/p1IQs4MmkOla1HbftVxlYB6PW9QQu0tr4PLp
        bdeAsMEs7/xqAEkCZ1gjmsb0T/xoFjn6DXzeaUThkolcz10NfnMYSCNrK6MdstNho55hNGgntPfD8
        bZaPMSzHBTUUfmdNAlHT59HXqv2KL0Xseow4RUWfBa3YsjsdO5v1EoJiojkuRbNxoc0P8Eb2/rH6j
        9qQBCkBw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lgMYg-00721f-Rt; Tue, 11 May 2021 07:12:00 +0000
Date:   Tue, 11 May 2021 08:11:58 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <song@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <jgq516@gmail.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org,
        Pawe?? Wiejacha <pawel.wiejacha@rtbhouse.com>
Subject: Re: [PATCH] md: don't account io stat for split bio
Message-ID: <YJouPh8pZCIXk96f@infradead.org>
References: <20210508034815.123565-1-jgq516@gmail.com>
 <YJjL6AQ+mMgzmIqM@infradead.org>
 <14a350ee-1ec9-6a15-dd76-fb01d8dd2235@gmail.com>
 <6ffb719e-bb56-8f61-9cd3-a0852c4acb7d@intel.com>
 <c1bc42ff-eae7-d0ba-505d-9c6a19d60e93@gmail.com>
 <YJoKOT8U7+9fyraj@infradead.org>
 <CAPhsuW64tRB6i7Rr2f+G-nmbacFKapB1nztinnJ2KKWTbc9VYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW64tRB6i7Rr2f+G-nmbacFKapB1nztinnJ2KKWTbc9VYA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, May 10, 2021 at 11:59:11PM -0700, Song Liu wrote:
> > Yes.  Also if the original bi_end_io is restore before completing the
> > bio you can still override it.
> 
> Do you mean we can somehow avoid cloning the bio?

If you restore the original bi_end_io you might be able to avoid it.
That being said I suspect that always cloning will be more robust.
