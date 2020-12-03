Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DE4C4361B
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 20:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BBF8221F4
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 20:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgLCUyd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:54:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgLCUyd (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 3 Dec 2020 15:54:33 -0500
Date:   Thu, 3 Dec 2020 12:53:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607028832;
        bh=1qnh0zonGEKUtIopKxMwK2GAcQI/emT//CzIroXxMQ4=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=swWm+RlRucBc2/AEAfNW31Y5h/qA1GZtN6hleh2Ha9iujwDJ87l5/lv7Ij4ectCS3
         mpUVeXR+DoZxoLCsjL/V3yFiEs5Mf2a2XJhVeYP/6h0F+1nfiWLbDA8DXIANAn8OAd
         5cKCe7LMUGSZPx5ngOAl7rkyHxwUqM0AFNPCAWCyjc11VHv9/jbHY3TucZgTFApNKq
         Y2DGUo9hoXwRB2Ce/FyLhShVgP4XKI6N02A9EvKkAvOxWnIkSxNy0tMcqrpw/LBPur
         q8DkuPiZ17pDt+IxHDWoXSsxXq7OVd9SrhCvIJb90VWtv1DGylbKDoFSwrl87zWxBK
         F57TdXT9aEJUA==
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Coly Li <colyli@suse.de>, Song Liu <song@kernel.org>,
        dm-devel@redhat.com, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 3/9] block: store a block_device pointer in struct bio
Message-ID: <20201203205349.GB3404013@dhcp-10-100-145-180.wdc.com>
References: <20201201165424.2030647-1-hch@lst.de>
 <20201201165424.2030647-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201165424.2030647-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Dec 01, 2020 at 05:54:18PM +0100, Christoph Hellwig wrote:
> diff --git a/block/blk.h b/block/blk.h
> index 98f0b1ae264120..64dc8e5a3f44cb 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -99,8 +99,8 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
>  	rq->bio = rq->biotail = bio;
>  	rq->ioprio = bio_prio(bio);
>  
> -	if (bio->bi_disk)
> -		rq->rq_disk = bio->bi_disk;
> +	if (bio->bi_bdev)
> +		rq->rq_disk = bio->bi_bdev->bd_disk;
>  }

Just fyi, this function has been relocated to include/linux/blk-mq.h
