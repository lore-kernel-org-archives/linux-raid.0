Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74FB9C0018C
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 16:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37416207A5
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 16:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436748AbgLCQWf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 11:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389361AbgLCQWd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 11:22:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A08C061A52;
        Thu,  3 Dec 2020 08:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=t7iSq6/VcOdB+KF2dNlAmkCtFIEWX1qiFGlHKaHNwtI=; b=Cq3Y0rVL/fcvy0tFuyrw0/yTQ5
        rtiORs6N2BSNFUU9C5r8CjK/tY11s3d75Ca4iSD6Dip9fuQU1Xs4So2bjpHBCiL1v3VSKC+gszCLy
        KejxnhP2LPJsJZxjVP+2xaIccCY+oGQEDIUrQOAc5guMTVVt9MYx5BIEMcq4etAumjcsEFWUt/W3r
        5H+f6c7wDQW6JYr+FW1G2Vw6zaReIlSNY1u2GzLiXWZMc6uabT/e6qD2B18iP5QGIUhyIrnGG5j53
        dE812GHSQRn/4P1x2DtVv8GoWzZEDarbs/t3Yk7YAXHW/xsID4FLLRAsP/2p5pup8bsbEnDT2H4a+
        P9qO/q3A==;
Received: from 213-225-0-143.nat.highway.a1.net ([213.225.0.143] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkrMZ-0005dN-KE; Thu, 03 Dec 2020 16:21:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] block: remove the request_queue argument to the block_split tracepoint
Date:   Thu,  3 Dec 2020 17:21:37 +0100
Message-Id: <20201203162139.2110977-4-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201203162139.2110977-1-hch@lst.de>
References: <20201203162139.2110977-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The request_queue can trivially be derived from the bio.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-merge.c            |  2 +-
 drivers/md/dm.c              |  2 +-
 include/trace/events/block.h | 14 ++++++--------
 kernel/trace/blktrace.c      |  5 ++---
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 1a46d5bbd399e3..4071daa88a5eaf 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -338,7 +338,7 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
 		split->bi_opf |= REQ_NOMERGE;
 
 		bio_chain(split, *bio);
-		trace_block_split(q, split, (*bio)->bi_iter.bi_sector);
+		trace_block_split(split, (*bio)->bi_iter.bi_sector);
 		submit_bio_noacct(*bio);
 		*bio = split;
 	}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ed7e836efbcdbc..9a5bd90779c7c4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1612,7 +1612,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 				part_stat_unlock();
 
 				bio_chain(b, bio);
-				trace_block_split(md->queue, b, bio->bi_iter.bi_sector);
+				trace_block_split(b, bio->bi_iter.bi_sector);
 				ret = submit_bio_noacct(bio);
 				break;
 			}
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 506c29dc7c76fd..b415e4cba84304 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -411,21 +411,19 @@ DEFINE_EVENT(block_unplug, block_unplug,
 
 /**
  * block_split - split a single bio struct into two bio structs
- * @q: queue containing the bio
  * @bio: block operation being split
  * @new_sector: The starting sector for the new bio
  *
- * The bio request @bio in request queue @q needs to be split into two
- * bio requests. The newly created @bio request starts at
- * @new_sector. This split may be required due to hardware limitation
- * such as operation crossing device boundaries in a RAID system.
+ * The bio request @bio needs to be split into two bio requests.  The newly
+ * created @bio request starts at @new_sector. This split may be required due to
+ * hardware limitations such as operation crossing device boundaries in a RAID
+ * system.
  */
 TRACE_EVENT(block_split,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio,
-		 unsigned int new_sector),
+	TP_PROTO(struct bio *bio, unsigned int new_sector),
 
-	TP_ARGS(q, bio, new_sector),
+	TP_ARGS(bio, new_sector),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev				)
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 7ab88e00c15765..3ca6d62114f461 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -970,10 +970,9 @@ static void blk_add_trace_unplug(void *ignore, struct request_queue *q,
 	rcu_read_unlock();
 }
 
-static void blk_add_trace_split(void *ignore,
-				struct request_queue *q, struct bio *bio,
-				unsigned int pdu)
+static void blk_add_trace_split(void *ignore, struct bio *bio, unsigned int pdu)
 {
+	struct request_queue *q = bio->bi_disk->queue;
 	struct blk_trace *bt;
 
 	rcu_read_lock();
-- 
2.29.2

