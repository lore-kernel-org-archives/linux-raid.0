Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32325C43460
	for <linux-raid@archiver.kernel.org>; Tue, 20 Apr 2021 07:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F110D61077
	for <linux-raid@archiver.kernel.org>; Tue, 20 Apr 2021 07:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhDTH73 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Apr 2021 03:59:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229521AbhDTH73 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 20 Apr 2021 03:59:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618905537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DAjeY/T/CPScSPWymCzycaeNgOOPXoZc8Xkk3oZ35yo=;
        b=NGzp5blfOjjj/hO/aTzl8BWEnwUtaCVx7Rf2O3rG2yDQ3KOWdR+L3RadtmaG2Ctp3cGmjr
        HlGMN0OgLp+EMRF0804sEJF8N8NiGJoDNJyfVHcJ/RmAFJZ4ri9vj6uITDFIrO9bEVohPS
        5odycSR9vPNIZWbzuuUudSM+Zp2t3CI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-ZNEhrwp9NXembJ99KWR84g-1; Tue, 20 Apr 2021 03:58:53 -0400
X-MC-Unique: ZNEhrwp9NXembJ99KWR84g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C17B91E767;
        Tue, 20 Apr 2021 07:58:52 +0000 (UTC)
Received: from T590 (ovpn-13-154.pek2.redhat.com [10.72.13.154])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 735E75D9CA;
        Tue, 20 Apr 2021 07:58:39 +0000 (UTC)
Date:   Tue, 20 Apr 2021 15:58:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH 2/2] block: support to freeze bio based
 request queue
Message-ID: <YH6JrTEsYfFA5DQH@T590>
References: <20210415103310.1513841-1-ming.lei@redhat.com>
 <20210415103310.1513841-3-ming.lei@redhat.com>
 <b1db72f3-f0a1-72f2-be12-6fd50c29e231@linux.alibaba.com>
 <YH2Kr8ZIn2fWKFyl@T590>
 <42c79dce-ad99-4e59-6566-727fa08a66bc@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42c79dce-ad99-4e59-6566-727fa08a66bc@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Apr 20, 2021 at 03:21:55PM +0800, JeffleXu wrote:
> 
> 
> On 4/19/21 9:50 PM, Ming Lei wrote:
> > On Mon, Apr 19, 2021 at 08:05:46PM +0800, JeffleXu wrote:
> >>
> >>
> >> On 4/15/21 6:33 PM, Ming Lei wrote:
> >>> For bio based request queue, the queue usage refcnt is only grabbed
> >>> during submission, which isn't consistent with request base queue.
> >>>
> >>> Queue freezing has been used widely, and turns out it is very useful
> >>> to quiesce queue activity.
> >>>
> >>> Support to freeze bio based request queue by the following approach:
> >>>
> >>> 1) grab two queue usage refcount for blk-mq before submitting blk-mq
> >>> bio, one is for bio, anther is for request;
> >>
> >>
> >> Hi, I can't understand the sense of grabbing two refcounts on the
> >> @q_usage_count of the underlying blk-mq device, while
> >> @q_usage_count of the MD/DM device is kept untouched.
> > 
> > Follows the point:
> > 
> > 1) for blk-mq, we hold one refcount for bio and another for request, and
> > release one after ending bio or completing request.
> 
> Blk-mq has already implemented queue freezing semantics, even without
> this 'grabbing two refcount'. So is this just for the code consisdency
> with the bio-based queue?

Right.

> 
> 
> > 
> > 2) for bio based queue, just holding one refcount for bio, and release it
> > after the bio is ended.
> 
> OK.
> 
> > 
> > As I mentioned to you, the current in-tree code only grabs the refcount
> > during submitting bio for bio base queue, and the refcount is released
> > after returning from submission, see __submit_bio().
> 
> Yes. I ignored that the refcount grabbed in the entry of bio submission
> has been returned back when the submission completes for bio-based queue.
> 
> > 
> >>
> >> In the following calling stack
> >>
> >> ```
> >> queue_poll_store
> >> 	blk_mq_freeze_queue(q)
> >> ```
> >>
> >> Is the input @q still the request queue of MD/DM device?
> > 
> > It can be either one after bio based io polling is supported,
> > queue/io_poll is exposed for both blk-mq and bio based queue.
> > 
> > However, I guess bio based polling doesn't need such strict bio queue
> > freezing, cause QUEUE_FLAG_POLL is only read in submission path, so
> > looks current freezing just during submission is enough.
> 
> Not actually.
> 
> blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>  	struct blk_mq_hw_ctx *hctx;
>  	long state;
> 
> -	if (!blk_qc_t_valid(cookie) || !blk_queue_poll(q))
> +	if (!blk_queue_poll(q) || (queue_is_mq(q) && !blk_qc_t_valid(cookie)))
> 
> Here QUEUE_FLAG_POLL is still checked in blk_poll() for bio-based queue,
> at least in your latest patch for bio-based polling.

OK, we can simply drop it.


Thanks,
Ming

