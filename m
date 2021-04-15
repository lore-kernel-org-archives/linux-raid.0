Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E7EC433B4
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 10:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 703E061152
	for <linux-raid@archiver.kernel.org>; Thu, 15 Apr 2021 10:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhDOKeY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Apr 2021 06:34:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30901 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230190AbhDOKeW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 15 Apr 2021 06:34:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618482839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8oJadmEi5UPqOKY+mBm7xcluSmXYdWzdSas+O68yeMc=;
        b=icut0PN0GUs0U0q84KUc9RaBcee9fnbCcv+YQPHr8hiT2abKCPPnOtyZLZ1gYRLlRHPYUp
        yzkVEMjm2/rXopTfM1Tw4Qc91OuQaHkuhmYJNK0vsYglLOY6DwNXDbf+bEweYR7PJ7Ytmp
        VdJ/f+ZN7PeZYLvjfCR2pdBgbyeLkUU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-rAlZXVZ4Mmmj0OuotOxryw-1; Thu, 15 Apr 2021 06:33:56 -0400
X-MC-Unique: rAlZXVZ4Mmmj0OuotOxryw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72A351006701;
        Thu, 15 Apr 2021 10:33:54 +0000 (UTC)
Received: from localhost (ovpn-13-200.pek2.redhat.com [10.72.13.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE8835D9DC;
        Thu, 15 Apr 2021 10:33:40 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        linux-nvme@lists.infradead.org, Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 0/2] block: support to freeze bio based queue
Date:   Thu, 15 Apr 2021 18:33:08 +0800
Message-Id: <20210415103310.1513841-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

For bio based request queue, the queue usage refcnt is only grabbed
during submission, which isn't consistent with request base queue.

Queue freezing has been used widely, and turns out it is very useful
to quiesce queue activity.

So try to support to freeze bio based queue by ->q_usage_counter.

Any comment are welcome!


Ming Lei (2):
  percpu_ref: add percpu_ref_tryget_many_live
  block: support to freeze bio based request queue

 block/bio.c                     | 12 ++++++++++--
 block/blk-core.c                | 23 +++++++++++++++++------
 drivers/nvme/host/core.c        | 16 ++++++++++++++++
 drivers/nvme/host/multipath.c   |  6 ++++++
 include/linux/blk-mq.h          |  2 ++
 include/linux/blk_types.h       |  1 +
 include/linux/blkdev.h          |  7 ++++++-
 include/linux/percpu-refcount.h | 30 ++++++++++++++++++++++++++----
 8 files changed, 84 insertions(+), 13 deletions(-)

-- 
2.29.2

