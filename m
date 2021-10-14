Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BBDC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 14:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28D9A61167
	for <linux-raid@archiver.kernel.org>; Thu, 14 Oct 2021 14:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhJNOab (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Oct 2021 10:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhJNOab (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Oct 2021 10:30:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC38C061570;
        Thu, 14 Oct 2021 07:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=saaEW/JUFx/dk1YX0uUtbSq9f1ztgQrV+3IzEx5+zBk=; b=YjxHhm2CUacKiivFVXlfDu1ixl
        dVuuZ5o97RrcceD7vr5kSFWTJue0bY6DNifIMDJ8HPvkjG1F7FekDTEEwRnbdrd3/j1rIqOsAj2IW
        yu/x2PBKn9vMSbiDp/hvq4aDonwpnflmCSJ6oAE0AZQQIiuE1ZcFJlrxYmKlpoYxS3ALLGIfhoCnj
        bbJiJJjX5xfg6R+f3F3tI9NUuXNP3zH5jmWfnfw0q627gjrVeYYkiGfyNwzyegVdJS1Lqtc0z5jja
        QXaSG0E0rwB2tIKBBcsOs9M1T85StaLkJfUySiXZ/mZvs+N1KHXGsyd6HeBnJt32xY2IyCvtYu4Tl
        RDOaEIBA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mb1hl-008OOe-41; Thu, 14 Oct 2021 14:27:48 +0000
Date:   Thu, 14 Oct 2021 15:27:33 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk,
        alexander.h.duyck@linux.intel.com
Subject: Re: [PATCH 5/5] brd: Kill usage of page->index
Message-ID: <YWg+VUxXiJJTxXA3@casper.infradead.org>
References: <20211013160034.3472923-1-kent.overstreet@gmail.com>
 <20211013160034.3472923-6-kent.overstreet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013160034.3472923-6-kent.overstreet@gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Oct 13, 2021 at 12:00:34PM -0400, Kent Overstreet wrote:
> As part of the struct page cleanups underway, we want to remove as much
> usage of page->mapping and page->index as possible, as frequently they
> are known from context.
> 
> In the brd code, we're never actually reading from page->index except in
> assertions, so references to it can be safely deleted.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>

More than that ... this is essentially asserting that the radix tree
code works, and we have a test suite to ensure that.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
