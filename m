Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0497C433B4
	for <linux-raid@archiver.kernel.org>; Fri, 16 Apr 2021 01:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB756600EF
	for <linux-raid@archiver.kernel.org>; Fri, 16 Apr 2021 01:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237889AbhDPB3I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Apr 2021 21:29:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236309AbhDPB3H (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 15 Apr 2021 21:29:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618536523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q0cmPSdk62RM6Rohe8F7GfXinQJD6JbYRfgxZ7IYSgE=;
        b=QTQ3ktbQUIFOaMVBxb9/niTRNUWjyFnSmKaCTHYUAYPLbyGosNxcFONRy3qPykET1F1IKj
        e6q6skke7sY5aCpR0mKxAMjPUmId6ioBpEAnu0wFlASXd74xUUrwpItGpk7IicgDTPCH4C
        uGuEK2A2tja1MqXe3z7ZsISJA48CBag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-5I-xjjtWONmT-Z8kJwOWdw-1; Thu, 15 Apr 2021 21:28:41 -0400
X-MC-Unique: 5I-xjjtWONmT-Z8kJwOWdw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45F9F1883520;
        Fri, 16 Apr 2021 01:28:40 +0000 (UTC)
Received: from T590 (ovpn-12-36.pek2.redhat.com [10.72.12.36])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E718D59457;
        Fri, 16 Apr 2021 01:28:26 +0000 (UTC)
Date:   Fri, 16 Apr 2021 09:28:22 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH 2/2] block: support to freeze bio based
 request queue
Message-ID: <YHjoNg/Z7KQ+4+YX@T590>
References: <20210415103310.1513841-1-ming.lei@redhat.com>
 <20210415103310.1513841-3-ming.lei@redhat.com>
 <af8f41f4-74e8-450d-fa63-6feb6b745222@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af8f41f4-74e8-450d-fa63-6feb6b745222@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Apr 15, 2021 at 01:16:42PM -0700, Bart Van Assche wrote:
> On 4/15/21 3:33 AM, Ming Lei wrote:
> > 1) grab two queue usage refcount for blk-mq before submitting blk-mq
> > bio, one is for bio, anther is for request;
>                        ^^^^^^
>                        another?
> 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 09f774e7413d..f71e4b433030 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -431,12 +431,13 @@ EXPORT_SYMBOL(blk_cleanup_queue);
> >  int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
> >  {
> >  	const bool pm = flags & BLK_MQ_REQ_PM;
> > +	const unsigned int nr = (flags & BLK_MQ_REQ_DOUBLE_REF) ? 2 : 1;
> 
> Please leave out the parentheses from around the condition in the above
> and in other ternary expressions. The ternary operator has a very low
> precedence so adding parentheses around the condition in a ternary
> operator is almost never necessary.
> 
> > @@ -480,8 +481,18 @@ static inline int bio_queue_enter(struct bio *bio)
> >  	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
> >  	bool nowait = bio->bi_opf & REQ_NOWAIT;
> >  	int ret;
> > +	blk_mq_req_flags_t flags = nowait ? BLK_MQ_REQ_NOWAIT : 0;
> > +	bool reffed = bio_flagged(bio, BIO_QUEUE_REFFED);
> >  
> > -	ret = blk_queue_enter(q, nowait ? BLK_MQ_REQ_NOWAIT : 0);
> > +	if (!reffed)
> > +		bio_set_flag(bio, BIO_QUEUE_REFFED);
> > +
> > +	/*
> > +	 * Grab two queue references for blk-mq, one is for bio, and
> > +	 * another is for blk-mq request.
> > +	 */
> > +	ret = blk_queue_enter(q, q->mq_ops && !reffed ?
> > +			(flags | BLK_MQ_REQ_DOUBLE_REF) : flags);
> 
> Consider rewriting the above code as follows to make it easier to read:
> 
> 	if (q->mq_ops && !reffed)
> 		flags |= BLK_MQ_REQ_DOUBLE_REF;
> 	ret = blk_queue_enter(q, flags);
> 
> Please also expand the comment above this code. The comment only
> explains the reffed == false case but not the reffed == true case. I
> assume that the reffed == true case applies to stacked bio-based drivers?

'reffed == true' means we have got one queue usage count already for
this bio, so only need to grab one usage count for blk-mq request.


Thanks,
Ming

