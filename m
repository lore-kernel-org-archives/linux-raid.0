Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DC9C61DA3
	for <linux-raid@archiver.kernel.org>; Tue, 21 Feb 2023 14:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbjBUOou (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Feb 2023 09:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjBUOot (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Feb 2023 09:44:49 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14106A5E9
        for <linux-raid@vger.kernel.org>; Tue, 21 Feb 2023 06:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1YNSOluD0PnUb8v9l+hWWl+WrAWE4HS944T8IU/D+/w=; b=YqRydz4gxYoKsm9fhmYx8aWszV
        Ry+H16hBsbgjCA5MQqs2zMx+UVneIhG0meT2SoVUjqX1CiV7cU8v7AP5bMQuUTkHGutT4gNzm88c3
        OXLOSp5dTGjeuR9yH/e7eOFfQOgp2rSQff9uC4f2/aJ5R68kSUFbf9W8gF9sjwkRWzAMKehJ1zonO
        dFxHjjAphB8he0u5YTK035amlA9Wym+XNcPX2quFAENPS3vpco3ma/6OgZnwNgUh1faBkc9fWo/3F
        C++Mv556N5hL85x75Ip3FUDOGygIoUE4eTP5MK/yY0qHrppWuuKRryk1qJ/FYSVNVnR+z9gUHU0Md
        Y+s67bBQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pUTss-008XAc-6Z; Tue, 21 Feb 2023 14:44:46 +0000
Date:   Tue, 21 Feb 2023 06:44:46 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>
Subject: Re: [PATCH v2] md: Use optimal I/O size for last bitmap page
Message-ID: <Y/TY3ujJpQBZcK2K@infradead.org>
References: <20230217183139.106-1-jonathan.derrick@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217183139.106-1-jonathan.derrick@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This becomes prety unreadable with all the long lines.

Can you do a little refactoring, with:

 1) a prep patch that splits out a helper to write the bitmap
    to one device (i.e. the main loop body)
 2) add a helper that returns the optimal I/O sizse in your new
    patch.  Please also use unsigned int instead of plain int for
    the I/O size everywhere as it can't be signed.

>  			/* DATA  BITMAP METADATA  */
> +			loff_t off = offset + (long)(page->index * (PAGE_SIZE/512));

And all the arithmetics here look ott to say nicely.

page->index is a pgoff_t, and multiplying it could cause overflows
on 32-bit architetures, so you need to cast it to a 64-bit type before
multiplying it.  It also will be unsigned, and I'm not quite sure
if loff_t is the right type for something that is in Linux block
number uints, that would usually be a sector_t.  Last but not least
it should be using SECTOR_SIZe and have whitespaces around the
operators.

I know at least some of this is pre-existing in the coe, but I think
this is a good time to get it right.
