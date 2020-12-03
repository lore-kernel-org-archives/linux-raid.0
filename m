Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBDAC433FE
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 16:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 401D4207AC
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 16:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389360AbgLCQW3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 11:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728676AbgLCQW3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 11:22:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8593C061A4E;
        Thu,  3 Dec 2020 08:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=mpF6zCYlFRTkfhfhMF1Rh1ZN68VZGaIgDwy8OF0XJs4=; b=YUCWDBEKuS/lMIYTgx2DZGv9DP
        /DzeeS7n6XSFO38bPa12wLvbry6u6+PDpGfCKgBo2u2Ci22ki8pEGEvs21sJIvQUucaVY98wZArJ9
        cwlHgaQqMsRtbMhSv2Ox0moN1CfLkvPXAAas/v4nGr9Pwo/ahgFosscfU0LDOwE2hTkgGgvYFNw5o
        z+MYyrzlhEGRo6iaYnIoIGUTt6qBDSgQlMm9VKh4QpV+nvYRhteqsU4ogFV0VzoywkQ6ORRGjkoyK
        PVONBoJj3BeaPPUltSSt2lSuSD3P6YdKZoQV23CrccQSFfpqO4RUT3S+6yIqibi6IczuQ4/Y7NLT7
        4uilmnFw==;
Received: from 213-225-0-143.nat.highway.a1.net ([213.225.0.143] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkrMS-0005bN-Eo; Thu, 03 Dec 2020 16:21:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: block tracepoint cleanups v2
Date:   Thu,  3 Dec 2020 17:21:34 +0100
Message-Id: <20201203162139.2110977-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,

this series cleans up the block layer tracepoints by removing unused
tracepoints or tracepoint arguments and consolidating the implementation
of various bio based tracepoints.

Changes since v1:
 - a few commit log typo fixes and improvements


Diffstat:
 block/blk-core.c              |    4 
 block/blk-merge.c             |    8 -
 block/blk-mq-sched.c          |    2 
 block/blk-mq.c                |   10 -
 block/bounce.c                |    2 
 drivers/md/dm-rq.c            |    2 
 drivers/md/dm.c               |    5 
 drivers/md/md-linear.c        |    3 
 drivers/md/md.c               |    5 
 drivers/md/raid0.c            |    4 
 drivers/md/raid1.c            |    7 -
 drivers/md/raid10.c           |    6 -
 drivers/md/raid5.c            |   15 +-
 drivers/nvme/host/multipath.c |    3 
 drivers/s390/scsi/zfcp_fsf.c  |    3 
 include/linux/blktrace_api.h  |    5 
 include/trace/events/block.h  |  228 +++++++++---------------------------------
 kernel/trace/blktrace.c       |  126 ++++++-----------------
 18 files changed, 125 insertions(+), 313 deletions(-)
