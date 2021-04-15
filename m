Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58428C433B4
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 20:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2817561153
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 20:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbhDOURJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Apr 2021 16:17:09 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:36626 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235169AbhDOURI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Apr 2021 16:17:08 -0400
Received: by mail-pf1-f169.google.com with SMTP id b26so11684367pfr.3;
        Thu, 15 Apr 2021 13:16:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R4MN2eqir+CBtD0tgtCkvzIAT+xpznMNoAirRW915JI=;
        b=YSm6Chmuci5BtX2dDY+uJdjkpag/EU1LJSWwnOU/L5grSh/0xPWZVLLmuHUPQjotqJ
         K1mBO6KtXSTCB+LP+YUB4FGE6aA0Gl6uIZHlzbxD1fdDjOAlDpDzy8+uiETE2XtoY2vf
         ZSEDraAOOX/h8h+o1/JtczSikk0VHHCGs/8XEHiq1wk57Jymv/ERSgX/8Ab2HxtQGIuL
         LkhUFlfJUQppynlFOjGqXLWt7FqnsShoKtuxLPZofqVyKtfb0lAQWj7I4vJVXnb21/Ou
         lvnSvwY4SuL86lHx/qgTaE+Kyhpp2RbVTPo6TsvfsxHAd2WwxRZFiHDEYDuzS4FsK8MT
         5wvw==
X-Gm-Message-State: AOAM530ZZsJUHQMdVvcYXKQqWAiGZw7xSxxGymGjLo3pypcLPO4ejRO6
        SM0VqcWe0AgX0NldtWsZwh0=
X-Google-Smtp-Source: ABdhPJxasAeAsl5iQIA7O0Hpn7d6fx6L/z8/SVQlS1C09Khzz+GwalY1VdAAhZbxcExOg1StAuq49Q==
X-Received: by 2002:a65:53c8:: with SMTP id z8mr5048457pgr.340.1618517804655;
        Thu, 15 Apr 2021 13:16:44 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f031:1d3a:7e95:2876? ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id y187sm2814668pfb.109.2021.04.15.13.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 13:16:43 -0700 (PDT)
Subject: Re: [dm-devel] [RFC PATCH 2/2] block: support to freeze bio based
 request queue
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Christoph Hellwig <hch@lst.de>
References: <20210415103310.1513841-1-ming.lei@redhat.com>
 <20210415103310.1513841-3-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <af8f41f4-74e8-450d-fa63-6feb6b745222@acm.org>
Date:   Thu, 15 Apr 2021 13:16:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415103310.1513841-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/15/21 3:33 AM, Ming Lei wrote:
> 1) grab two queue usage refcount for blk-mq before submitting blk-mq
> bio, one is for bio, anther is for request;
                       ^^^^^^
                       another?

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 09f774e7413d..f71e4b433030 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -431,12 +431,13 @@ EXPORT_SYMBOL(blk_cleanup_queue);
>  int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
>  {
>  	const bool pm = flags & BLK_MQ_REQ_PM;
> +	const unsigned int nr = (flags & BLK_MQ_REQ_DOUBLE_REF) ? 2 : 1;

Please leave out the parentheses from around the condition in the above
and in other ternary expressions. The ternary operator has a very low
precedence so adding parentheses around the condition in a ternary
operator is almost never necessary.

> @@ -480,8 +481,18 @@ static inline int bio_queue_enter(struct bio *bio)
>  	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
>  	bool nowait = bio->bi_opf & REQ_NOWAIT;
>  	int ret;
> +	blk_mq_req_flags_t flags = nowait ? BLK_MQ_REQ_NOWAIT : 0;
> +	bool reffed = bio_flagged(bio, BIO_QUEUE_REFFED);
>  
> -	ret = blk_queue_enter(q, nowait ? BLK_MQ_REQ_NOWAIT : 0);
> +	if (!reffed)
> +		bio_set_flag(bio, BIO_QUEUE_REFFED);
> +
> +	/*
> +	 * Grab two queue references for blk-mq, one is for bio, and
> +	 * another is for blk-mq request.
> +	 */
> +	ret = blk_queue_enter(q, q->mq_ops && !reffed ?
> +			(flags | BLK_MQ_REQ_DOUBLE_REF) : flags);

Consider rewriting the above code as follows to make it easier to read:

	if (q->mq_ops && !reffed)
		flags |= BLK_MQ_REQ_DOUBLE_REF;
	ret = blk_queue_enter(q, flags);

Please also expand the comment above this code. The comment only
explains the reffed == false case but not the reffed == true case. I
assume that the reffed == true case applies to stacked bio-based drivers?

Thanks,

Bart.
