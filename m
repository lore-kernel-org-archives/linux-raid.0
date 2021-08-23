Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041DDC4338F
	for <linux-raid@archiver.kernel.org>; Mon, 23 Aug 2021 06:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6095611C8
	for <linux-raid@archiver.kernel.org>; Mon, 23 Aug 2021 06:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhHWGwV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 Aug 2021 02:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbhHWGwU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 23 Aug 2021 02:52:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A43C061575;
        Sun, 22 Aug 2021 23:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uCWVwv/sQJESLZJQECzCX6ToUOh94WzFyNlwTL+HvI8=; b=IcdOj4/dCT4DM8XqWkWaLbaQYa
        PB7anTyh7nGtPhQ3gQXSk/afJbWxH0Zk5QdUUVnuebPJonJ5V363Sbtrz5Tg2eEK1GQVx+6fjCZ2e
        unvfyXhJgRjPxI+ziKx54VBdOIS1V9+4yGcZNYqx9Tb1oNrF0YyQYUrIQUSWoryZYrXp3O+iPQA1c
        n7bGyEmrciwacsWc3EsLNkmk5mmRK9XERgPxXkAPTJmUCWhIWAVMgk0LcxJcehko6Xq7fVE/9qG+t
        VSkZLg4POsR1p49KptMthqjQHntVgnTVUk2OEWkdrzjkbCzQ462TFqs/z0wvYWX7Z+LhnisPdr+So
        ESPWDr0g==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mI3mn-009OVX-4U; Mon, 23 Aug 2021 06:50:31 +0000
Date:   Mon, 23 Aug 2021 07:50:21 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH V2] raid1: ensure write behind bio has less than
 BIO_MAX_VECS sectors
Message-ID: <YSNFLXpY2ZY1hvSE@infradead.org>
References: <20210818073738.1271033-1-guoqing.jiang@linux.dev>
 <YR4ckyTCiOXCRnue@infradead.org>
 <207ca922-4223-632b-ed68-4e78e40ac3dc@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <207ca922-4223-632b-ed68-4e78e40ac3dc@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Aug 20, 2021 at 04:19:22PM +0800, Guoqing Jiang wrote:
> How about this?
> 
> +???????????????????????????? /*
> +?????????????????????????????? * The write-behind io is only attempted on drives marked as
> +?????????????????????????????? * write-mostly, which means we will allocate write behind
> +?????????????????????????????? * bio later.
> +?????????????????????????????? */
> ?????????????????????????????? if (test_bit(WriteMostly, &mirror->rdev->flags))
> ?????????????????????????????????????????????? write_behind = true;

Except for the weird formatting of the whitespaces this looks good.
