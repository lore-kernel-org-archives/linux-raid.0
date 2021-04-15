Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368D0C433B4
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 13:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B101610FA
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 13:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhDON46 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Apr 2021 09:56:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230056AbhDON45 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 15 Apr 2021 09:56:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618494994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t6k+KJHgh4qNKstVz2JZFL9ECTTreUR+oV6XNzdagBg=;
        b=UtczuPlfJFLFn2aOXbYjI0TRanGmNYzWnSB6DsRFneFwvqC/PP5PU6iqWgNaGfUOebQlwy
        NMKP+PML0wmukY/e/icZYyQ4Bn14A9D8X5gk4kH/duaDn47Biak3Kv9+wFQv0W2oAx567m
        yfpv1+JvOFpevXRFAQ5mLD0I/VG6Gnc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-pZdUGFrCMOSb0PZnU_PH-g-1; Thu, 15 Apr 2021 09:56:32 -0400
X-MC-Unique: pZdUGFrCMOSb0PZnU_PH-g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 167CB6D4EE;
        Thu, 15 Apr 2021 13:56:31 +0000 (UTC)
Received: from T590 (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CB685D71F;
        Thu, 15 Apr 2021 13:56:16 +0000 (UTC)
Date:   Thu, 15 Apr 2021 21:56:11 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC PATCH 2/2] block: support to freeze bio based request queue
Message-ID: <YHhF+3Qw4Y+hv5X4@T590>
References: <20210415103310.1513841-1-ming.lei@redhat.com>
 <20210415103310.1513841-3-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415103310.1513841-3-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Apr 15, 2021 at 06:33:10PM +0800, Ming Lei wrote:
> For bio based request queue, the queue usage refcnt is only grabbed
> during submission, which isn't consistent with request base queue.
> 
> Queue freezing has been used widely, and turns out it is very useful
> to quiesce queue activity.
> 
> Support to freeze bio based request queue by the following approach:
> 
> 1) grab two queue usage refcount for blk-mq before submitting blk-mq
> bio, one is for bio, anther is for request;
> 
> 2) add bio flag of BIO_QUEUE_REFFED for making sure that only one
> refcnt is grabbed for each bio, so we can put the refcnt when the
> bio is going away
> 
> 3) nvme mpath is a bit special, because same bio is used for both
> mpath queue and underlying nvme queue. So we put the mpath queue's
> usage refcnt before completing the nvme request.

RAID needs similar handling too, but it is easy to do, see md_end_io().

-- 
Ming

