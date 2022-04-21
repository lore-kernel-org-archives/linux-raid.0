Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FA8C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 21 Apr 2022 06:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384769AbiDUGVo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Apr 2022 02:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352817AbiDUGVn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 21 Apr 2022 02:21:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7416BC2B;
        Wed, 20 Apr 2022 23:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xlBQ6DVKGvFJX+Ldx3rdWv/HFspbxlibkRveNNlmLbM=; b=ug8j40B6lWGt+wzhUTXj7e353L
        gJ4Bo/pvrUNY75psm5ERq71079ac/QEKwfkQZXEc0dKCAXNuoiTkVplW+XfWLyd3Kcbn4NLeTFk8/
        CWYYY8/aQFy6J1s+IE6OtE9TVksfH751fx0T0NRQzIoi4PCXQOvPwsiS1bFnTYYwbBCl6lvfevuto
        j1xnoqWAKx1mjzB4N1sTzM2E5FkoM3yyBgja95DbZhY/znKbEN7krEt753Oo2qMjefVGALyBTm+4v
        YvQoxX+U2FNxDaZ3+lapRetBuRcdlTUGd2mPRaXmZ8UxxgoZKxVQmwYbTTD7lGhYUYCHW3uSr4pOm
        hy1M7Ruw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nhQ9X-00Bfqb-83; Thu, 21 Apr 2022 06:18:55 +0000
Date:   Wed, 20 Apr 2022 23:18:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH v2 11/12] md/raid5: Check all disks in a stripe_head for
 reshape progress
Message-ID: <YmD3T8KcmSm0e0bS@infradead.org>
References: <20220420195425.34911-1-logang@deltatee.com>
 <20220420195425.34911-12-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420195425.34911-12-logang@deltatee.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Apr 20, 2022 at 01:54:24PM -0600, Logan Gunthorpe wrote:
> +static bool range_ahead_of_reshape(struct mddev *mddev, sector_t min,
> +				   sector_t max, sector_t reshape_sector)
> +{
> +	if (mddev->reshape_backwards)
> +		return max < reshape_sector;
> +	else
> +		return min >= reshape_sector;
> +}

Nit: no need for the return.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
