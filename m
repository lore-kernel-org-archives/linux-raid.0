Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05BBFC0007A
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 16:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BAFF207A5
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 16:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389367AbgLCQWa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 11:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389361AbgLCQW3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 11:22:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5577AC061A4F;
        Thu,  3 Dec 2020 08:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=gFUPuMyLOWcb8AqvDN/KfoHYkZaV/QXuHXIthCOK1JM=; b=CjvyLtNnAdr2/ZnoRtVTY3MA3s
        DPnnz4eiBCPEejt7WpLQz2IkJ642+A8XHb7HFUjMZYT8I/mcUhBiJJwyPFR1dWb5JhRt3xtwu2q9P
        4Nrm/vsveU5AIWVji8vxnKbzllL1Bl4qECRyNjNgSmUx53olhdKIGvzeuUrlOcHmeWJoRecJN9M1h
        JJkW4YRAWRCmLuZd1JI/xdHQrYPFoLbVS+rlMl0jHBsd7grYYHaeLidtr/ZTbIuMec58cCQn/hZOa
        6gl97+zhaMFyDx990ygP2QMQi6vVD5p+Az6VawdLTsKeOemsii4qxOJTxG30+lH2aFXAhM+A7jwmn
        Aco0kyAw==;
Received: from 213-225-0-143.nat.highway.a1.net ([213.225.0.143] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkrMU-0005bR-Mw; Thu, 03 Dec 2020 16:21:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/5] block: remove the unused block_sleeprq tracepoint
Date:   Thu,  3 Dec 2020 17:21:35 +0100
Message-Id: <20201203162139.2110977-2-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201203162139.2110977-1-hch@lst.de>
References: <20201203162139.2110977-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The block_sleeprq tracepoint was only used by the legacy request code.
Remove it now that the legacy request code is gone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 include/trace/events/block.h | 18 ------------------
 kernel/trace/blktrace.c      | 22 ----------------------
 2 files changed, 40 deletions(-)

diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 34d64ca306b1c7..76459cf750e14d 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -441,24 +441,6 @@ DEFINE_EVENT(block_get_rq, block_getrq,
 	TP_ARGS(q, bio, rw)
 );
 
-/**
- * block_sleeprq - waiting to get a free request entry in queue for block IO operation
- * @q: queue for operation
- * @bio: pending block IO operation (can be %NULL)
- * @rw: low bit indicates a read (%0) or a write (%1)
- *
- * In the case where a request struct cannot be provided for queue @q
- * the process needs to wait for an request struct to become
- * available.  This tracepoint event is generated each time the
- * process goes to sleep waiting for request struct become available.
- */
-DEFINE_EVENT(block_get_rq, block_sleeprq,
-
-	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
-
-	TP_ARGS(q, bio, rw)
-);
-
 /**
  * block_plug - keep operations requests in request queue
  * @q: request queue to plug
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index a482a37848bff7..ced589df304b57 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -959,25 +959,6 @@ static void blk_add_trace_getrq(void *ignore,
 	}
 }
 
-
-static void blk_add_trace_sleeprq(void *ignore,
-				  struct request_queue *q,
-				  struct bio *bio, int rw)
-{
-	if (bio)
-		blk_add_trace_bio(q, bio, BLK_TA_SLEEPRQ, 0);
-	else {
-		struct blk_trace *bt;
-
-		rcu_read_lock();
-		bt = rcu_dereference(q->blk_trace);
-		if (bt)
-			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_SLEEPRQ,
-					0, 0, NULL, 0);
-		rcu_read_unlock();
-	}
-}
-
 static void blk_add_trace_plug(void *ignore, struct request_queue *q)
 {
 	struct blk_trace *bt;
@@ -1164,8 +1145,6 @@ static void blk_register_tracepoints(void)
 	WARN_ON(ret);
 	ret = register_trace_block_getrq(blk_add_trace_getrq, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_sleeprq(blk_add_trace_sleeprq, NULL);
-	WARN_ON(ret);
 	ret = register_trace_block_plug(blk_add_trace_plug, NULL);
 	WARN_ON(ret);
 	ret = register_trace_block_unplug(blk_add_trace_unplug, NULL);
@@ -1185,7 +1164,6 @@ static void blk_unregister_tracepoints(void)
 	unregister_trace_block_split(blk_add_trace_split, NULL);
 	unregister_trace_block_unplug(blk_add_trace_unplug, NULL);
 	unregister_trace_block_plug(blk_add_trace_plug, NULL);
-	unregister_trace_block_sleeprq(blk_add_trace_sleeprq, NULL);
 	unregister_trace_block_getrq(blk_add_trace_getrq, NULL);
 	unregister_trace_block_bio_queue(blk_add_trace_bio_queue, NULL);
 	unregister_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge, NULL);
-- 
2.29.2

