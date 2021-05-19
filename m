Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B3EC433B4
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 11:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C726A6135B
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 11:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241199AbhESLCm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 07:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhESLCm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 May 2021 07:02:42 -0400
Received: from wp118.webpack.hosteurope.de (wp118.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:847d::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84194C06175F
        for <linux-raid@vger.kernel.org>; Wed, 19 May 2021 04:01:22 -0700 (PDT)
Received: from app20-neu.ox.hosteurope.de ([92.51.170.154]); authenticated
        by wp118.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.0:ECDHE_RSA_AES_256_CBC_SHA1:256)
        id 1ljJx0-0000iH-Q8; Wed, 19 May 2021 13:01:18 +0200
Date:   Wed, 19 May 2021 13:01:18 +0200 (CEST)
From:   wp1083705-spam02 wp1083705-spam02 <spam02@dazinger.net>
To:     Christoph Hellwig <hch@lst.de>, song@kernel.org, axboe@kernel.dk
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org
Message-ID: <1102825331.165797.1621422078235@ox.hosteurope.de>
In-Reply-To: <20210519062215.4111256-1-hch@lst.de>
References: <20210519062215.4111256-1-hch@lst.de>
Subject: Re: [PATCH] md/raid5: remove an incorect assert in
 in_chunk_boundary
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.4-Rev21
X-Originating-IP: 87.247.200.216
X-Originating-Client: open-xchange-appsuite
X-Originating-Sender: spam02@dazinger.net
X-bounce-key: webpack.hosteurope.de;spam02@dazinger.net;1621422082;fe58e114;
X-HE-SMSGID: 1ljJx0-0000iH-Q8
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


> Christoph Hellwig <hch@lst.de> hat am 19.05.2021 08:22 geschrieben:
> 
>  
> Now that the original bdev is stored in the bio this assert is incorrect
> and will trigge for any partitioned raid5 device.
> 
> Reported-by:  Florian D. <spam02@dazinger.net>
> Fixes: 309dca309fc3 ("block: store a block_device pointer in struct bio"),
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/raid5.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 841e1c1aa5e6..7d4ff8a5c55e 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5311,8 +5311,6 @@ static int in_chunk_boundary(struct mddev *mddev, struct bio *bio)
>  	unsigned int chunk_sectors;
>  	unsigned int bio_sectors = bio_sectors(bio);
>  
> -	WARN_ON_ONCE(bio->bi_bdev->bd_partno);
> -
>  	chunk_sectors = min(conf->chunk_sectors, conf->prev_chunk_sectors);
>  	return  chunk_sectors >=
>  		((sector & (chunk_sectors - 1)) + bio_sectors);
> -- 
> 2.30.2

yes, this solves it, I can confirm with this patch the error/warning message when booting linux-5.12 is gone!

Thanks a lot!
Florian
