Return-Path: <SRS0=7JT0=CJ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBE5C433E7
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 06:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69D9E2072D
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 06:53:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aG4NIY+5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgHaGx5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Aug 2020 02:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgHaGx4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 31 Aug 2020 02:53:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AD3C061573;
        Sun, 30 Aug 2020 23:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vitTGHyMtyMzA5U8cG1JZv4rmI3Iyvz66qzbnhI/g/4=; b=aG4NIY+5vLeWOkRhrOCK1epw1K
        96TN2xHBI5OHlq7k3wim8ScfK75Hp0qwG6DG0V/RZUgNueHD0XyFJwkkE/of01ZJ5eIcOMiY8yzfH
        OyFEKpC4YWzn3j6+fjMgK9mIWOqjfyx28Q4hIrhwUPausv96KaawdTdkgzXRUH4c+EmvP6Uzasmaz
        wkXb5a+MzsuBZU/q2SeQlX6IBMhvK1/RMp0KE+nPLqru2cU8i9q1t0McUCYF2uhzTwsM1exa2SNMz
        oK9zWvm/GDQpgHaLLkAuQ0Cyx2Off6GV4daD2E0ZVFI80bS939jalJ20ssGzxjGb+B+pNmkd5dG8N
        AIY9ThgA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCdhO-0000h5-13; Mon, 31 Aug 2020 06:53:50 +0000
Date:   Mon, 31 Aug 2020 07:53:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org, colyli@suse.de, axboe@kernel.dk,
        kernel-team@fb.com, song@kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 1/3] block: introduce part_[begin|end]_io_acct
Message-ID: <20200831065349.GA2507@infradead.org>
References: <20200818222645.952219-1-songliubraving@fb.com>
 <20200818222645.952219-2-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818222645.952219-2-songliubraving@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Aug 18, 2020 at 03:26:43PM -0700, Song Liu wrote:
> These functions can be used to enable iostat for partitions on devices
> like md, bcache.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>

EXPORT_SYMBOL_GPL for new block layer functionality, please.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
