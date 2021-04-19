Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD9EC433B4
	for <linux-raid@archiver.kernel.org>; Mon, 19 Apr 2021 13:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FB706101E
	for <linux-raid@archiver.kernel.org>; Mon, 19 Apr 2021 13:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbhDSNvW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Apr 2021 09:51:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238883AbhDSNvU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 19 Apr 2021 09:51:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618840250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SXyrXEedJfmFDgBmkAT/98qBgfpQeb6WK3mtJeKmj+I=;
        b=hAX8qu+RfiTPU2LqUCB5VUu72JLMqXsnHEGUB279EGtuBDch8/5XCieO6kZBuLCCDTr/5j
        kjF6SRjMhrXCSltN9R1aegypEN5Rc2wN2LoRc4i+XvQ2RRL8Cl5RdcpyDfQYftnkEudSF/
        Um3FiUGJ4oE7095J3VdZm5C8XiXu1Vo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-zM7VMfOEPTeooElOnQyGzw-1; Mon, 19 Apr 2021 09:50:48 -0400
X-MC-Unique: zM7VMfOEPTeooElOnQyGzw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E72DD1006CB0;
        Mon, 19 Apr 2021 13:50:46 +0000 (UTC)
Received: from T590 (ovpn-12-222.pek2.redhat.com [10.72.12.222])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 02A6017A81;
        Mon, 19 Apr 2021 13:50:41 +0000 (UTC)
Date:   Mon, 19 Apr 2021 21:50:39 +0800
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
Message-ID: <YH2Kr8ZIn2fWKFyl@T590>
References: <20210415103310.1513841-1-ming.lei@redhat.com>
 <20210415103310.1513841-3-ming.lei@redhat.com>
 <b1db72f3-f0a1-72f2-be12-6fd50c29e231@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1db72f3-f0a1-72f2-be12-6fd50c29e231@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Apr 19, 2021 at 08:05:46PM +0800, JeffleXu wrote:
> 
> 
> On 4/15/21 6:33 PM, Ming Lei wrote:
> > For bio based request queue, the queue usage refcnt is only grabbed
> > during submission, which isn't consistent with request base queue.
> > 
> > Queue freezing has been used widely, and turns out it is very useful
> > to quiesce queue activity.
> > 
> > Support to freeze bio based request queue by the following approach:
> > 
> > 1) grab two queue usage refcount for blk-mq before submitting blk-mq
> > bio, one is for bio, anther is for request;
> 
> 
> Hi, I can't understand the sense of grabbing two refcounts on the
> @q_usage_count of the underlying blk-mq device, while
> @q_usage_count of the MD/DM device is kept untouched.

Follows the point:

1) for blk-mq, we hold one refcount for bio and another for request, and
release one after ending bio or completing request.

2) for bio based queue, just holding one refcount for bio, and release it
after the bio is ended.

As I mentioned to you, the current in-tree code only grabs the refcount
during submitting bio for bio base queue, and the refcount is released
after returning from submission, see __submit_bio().

> 
> In the following calling stack
> 
> ```
> queue_poll_store
> 	blk_mq_freeze_queue(q)
> ```
> 
> Is the input @q still the request queue of MD/DM device?

It can be either one after bio based io polling is supported,
queue/io_poll is exposed for both blk-mq and bio based queue.

However, I guess bio based polling doesn't need such strict bio queue
freezing, cause QUEUE_FLAG_POLL is only read in submission path, so
looks current freezing just during submission is enough.


Thanks, 
Ming

