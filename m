Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A946C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 13:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 391BD6105A
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 13:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbhERNnl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 09:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbhERNnh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 09:43:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68436C061573
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 06:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XbWi/89+55FV850jfv/1tGKtZai1/qI8CTiHElbTRKw=; b=ZjY11ar1yrowC9+Ji8GNwLPV4v
        gACvdCsFdDrvbL+M9nYc5kgW23rwYUo8bsRhrz7hmXlvZDSx+jbFJ39RE6KKohwrqe54vNpxRlKNF
        bO+XEubCbn1qfIiVH4cdJ+EVGbm5W9Cok3u/DnHDA8S6fZgV6T4W1PJyjbZ+TxtBuN4tTC/X1WhF9
        ZXAEeubIA5ECPRxdsUsuq7oa8mETbwTza4D+GcUsM4ogV+UaZx7xBVS5tBO2daviSUvEJpoaSsQnD
        Dx1s2wJcTZedmWruiNHcALW084kCkNXaSG83Y4rbQgjmvlgtGa19w6DWAtq5caug/vK+/8xbjKCUr
        pNu0wyeg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lizxo-00E1YY-Rl; Tue, 18 May 2021 13:41:09 +0000
Date:   Tue, 18 May 2021 14:40:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        artur.paszkiewicz@intel.com,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
Subject: Re: [PATCH 4/5] md/raid1: enable io accounting
Message-ID: <YKPD4IxoGecsvQyv@infradead.org>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
 <20210518053225.641506-5-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518053225.641506-5-jiangguoqing@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 18, 2021 at 01:32:24PM +0800, Guoqing Jiang wrote:
> For raid1, we record the start time between split bio and clone bio,
> and finish the accounting in the final endio.
> 
> Also introduce start_time in r1bio accordingly.
> 
> Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
> ---
>  drivers/md/raid1.c | 11 +++++++++++
>  drivers/md/raid1.h |  1 +
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index ced076ba560e..b08a47523dbb 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -300,6 +300,8 @@ static void call_bio_endio(struct r1bio *r1_bio)
>  	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>  		bio->bi_status = BLK_STS_IOERR;
>  
> +	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
> +		bio_end_io_acct_remapped(bio, r1_bio->start_time, bio->bi_bdev);

This can use bio_end_io_acct.

> +	/*
> +	 * Reuse print_msg, if it is false then a fresh r1_bio is just
> +	 * allocated before.
> +	 */
> +	if (!print_msg && blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
> +		r1_bio->start_time = bio_start_io_acct(bio);
> +

Please rename the print_msg vaiable to something sensible and drop the
comment.
