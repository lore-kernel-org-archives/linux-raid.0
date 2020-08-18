Return-Path: <SRS0=fBal=B4=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B68C433DF
	for <linux-raid@archiver.kernel.org>; Tue, 18 Aug 2020 19:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DDA52076E
	for <linux-raid@archiver.kernel.org>; Tue, 18 Aug 2020 19:45:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N61G1Cp7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgHRTpM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Aug 2020 15:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbgHRTpE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 Aug 2020 15:45:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659EDC061342;
        Tue, 18 Aug 2020 12:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=U4MIf2lCi6IjYxRdtV0kTVnULW1LZNZAc4yIpa1q9jk=; b=N61G1Cp70WD+t0nHtEm0vZgsCC
        prZOoPO5OGHOGZGBgsN1fGLvsUlXnjF9XIjjIxT5xdhI8AZWTKbPGAwQXGRtRsjR7Q43DFMQ419kz
        9e9w5XkAtwoqa/PqkMXo5k0A7RKzPfLBkxKA0AhWR0esmR/pQ4qfrWVPVbuK2lmUj1m6HXXxkA/VN
        vIZAaQIbsrACBQ6LMDUZk+QTaQgL7XDggekmgdO6yD3MNDgXXI8TwgcWYe0ZI/BiAHc6FeM9QaVmN
        +mvs+7YxMFYgxWll3YTZNJ+J2xP1OaSCtjW8xffbyWFEhQfQ1kN5ChdwpYxvRuy04dfBYAEQMZlHc
        mzSMeekQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k87XZ-00012N-9r; Tue, 18 Aug 2020 19:45:01 +0000
Date:   Tue, 18 Aug 2020 20:45:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org, colyli@suse.de, axboe@kernel.dk,
        kernel-team@fb.com, song@kernel.org
Subject: Re: [PATCH 1/4] block: expose disk_map_sector_rcu() and
 hd_struct_put in genhd.h
Message-ID: <20200818194501.GB3271@infradead.org>
References: <20200818070238.1323126-1-songliubraving@fb.com>
 <20200818070238.1323126-2-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818070238.1323126-2-songliubraving@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Aug 18, 2020 at 12:02:35AM -0700, Song Liu wrote:
> So they can be used in drivers.

Looking at your later patches I'd much rather hide the call to
disk_map_sector_rcu in the actual accounting helper.
