Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFFEC433FE
	for <linux-raid@archiver.kernel.org>; Wed, 19 Oct 2022 12:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbiJSM0F (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Oct 2022 08:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233948AbiJSMZR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Oct 2022 08:25:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57B81C7D61;
        Wed, 19 Oct 2022 05:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xws8xFXwM1KyPnBLrh1r+q3lBJxGn8b72mAASi9/amU=; b=QIoDHfQoFCCed+6zaJwE3c7Vri
        679zySmrP7NeCw0NYuZUUWOYVKL628W5Jo2uoV+mECIa6gfyTeV/ysIAnP6xN00+sH1NaDTd+L/KF
        6JowD3VnkG5JDi57/V7dmMHixDFwpKDH8he+7AeGOwwwRZ+JNdc0bmnBiSeIarg+R55AJjLCSGvz7
        4EowRtfH7jO1UiVdPGHhNLrPqDsba02CC29bliYwFMFYQZQW5J7aIzYPlikTsv83x5OusqA+36YEH
        CQLB0HG+pQwM8GI3x7zbeyg6Vhx8aMMl3/2JdMCrcJyXPIXIjP+qIj3lcgEZ49oavruHFPXXRiDUn
        TTEvniPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ol6nv-000j61-CW; Wed, 19 Oct 2022 11:00:07 +0000
Date:   Wed, 19 Oct 2022 04:00:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Giulio Benetti <giulio.benetti@benettiengineering.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-raid@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Mark Brown <broonie@kernel.org>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH 3/3] raid: substitute empty_zero_page with helper
 ZERO_PAGE(0)
Message-ID: <Y0/Yt4uJWg4knNoc@infradead.org>
References: <20221018215755.33566-1-giulio.benetti@benettiengineering.com>
 <20221018215755.33566-3-giulio.benetti@benettiengineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018215755.33566-3-giulio.benetti@benettiengineering.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Oct 18, 2022 at 11:57:55PM +0200, Giulio Benetti wrote:
>  #if RAID6_USE_EMPTY_ZERO_PAGE
> -# define raid6_empty_zero_page empty_zero_page
> +# define raid6_empty_zero_page ZERO_PAGE(0)
>  #else
>  extern const char raid6_empty_zero_page[PAGE_SIZE];

RAID6_USE_EMPTY_ZERO_PAGE is never set to a non-zero value.  So this
is dead code and we can just remove all code related to the
RAID6_USE_EMPTY_ZERO_PAGE case.
