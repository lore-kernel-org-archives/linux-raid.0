Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DAFFC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 11 Mar 2022 17:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350789AbiCKRb6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Mar 2022 12:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350786AbiCKRbw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Mar 2022 12:31:52 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E77C9902
        for <linux-raid@vger.kernel.org>; Fri, 11 Mar 2022 09:30:48 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id z7so10919327iom.1
        for <linux-raid@vger.kernel.org>; Fri, 11 Mar 2022 09:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=91p5fyoti+r99A/MLHXzhui0PoyX/YysuNW7zXeNbUA=;
        b=V5re+zgR1eGZ4rAjBh1xEwA16T7jqn5dR/KLfBrwxL0xdnm7gG1f74sq97R7FCxEnB
         8Yp9YgEQZFkKY4TyP7XIsJIAGfsje3FHbq6sdlCCrBKO2KVZecWv5DZn4jszm7dKs2lt
         IHQihgTc3xw6Z/NcMqBF3uUbvNL+tDYR8q1OzMW2dFVeKboZjMUXJgp1+onWB0ynwYfx
         AlT6Zs19ljKk1mq/myRHg5r9WVKC2vjUcv3Gi51uvwmLgy27u1wy+daUvuRSAeyJLsLs
         U+Uq1udqZy6I+zKw8+9epehkrAKMfyV++kMJ22FElEhJykO5ipmIduAIS+jxOtr1HM/l
         AsBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=91p5fyoti+r99A/MLHXzhui0PoyX/YysuNW7zXeNbUA=;
        b=C1TRJ7bGgLcFYEz+YbQM3u7pBfy7PXsFvyTH13pEq5bjWhSUzo52KQ246PS+Do2rUP
         F7r2xjC3ltt14qpkjIC0sr4Ln/65ZvyplxLWZHDEAB/BqBs4TYPzuvRrnXESpUsm/M5G
         NCBk1kxFPA7vkHmMVNTbXEZBL51JNGO8blgPzxRKP6EhX0K/vvBw8a5T72dnM6jGpaEZ
         qarysHt7l9Iije0nhDVAd1obF2stMa/J/6CDziQmnuNJEsHHgA9dGo/T3UcRwmLASNWN
         ko8yr4lI3CMz1vnr2nKRbjG3gT9G60te9oXrAk0fQGBGaCuni9qJEKX5i2KYes1mNerM
         WPQg==
X-Gm-Message-State: AOAM533c6zl451m4kZyl86B4Pn54czvtlBYl/A+Bw2rDIa4HetztdKSt
        2Q+0FYuh4mF1OBX9nr9biOgbJw==
X-Google-Smtp-Source: ABdhPJzdSa1Whd43NnaQvNGvszejNdbL7bw9pouDrrqgkfcxe5cCaPt5e/3/yjzGglu9+dTb6RPqMQ==
X-Received: by 2002:a05:6638:359:b0:317:c322:b012 with SMTP id x25-20020a056638035900b00317c322b012mr9171926jap.285.1647019847618;
        Fri, 11 Mar 2022 09:30:47 -0800 (PST)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r2-20020a92d442000000b002c62b540c85sm4622356ilm.5.2022.03.11.09.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 09:30:47 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        llowrey@nuclearwinter.com, i400sjon@gmail.com,
        rogerheflin@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] block: flush plug based on hardware and software queue order
Date:   Fri, 11 Mar 2022 10:30:41 -0700
Message-Id: <20220311173041.165948-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220311173041.165948-1-axboe@kernel.dk>
References: <20220311173041.165948-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

We used to sort the plug list if we had multiple queues before dispatching
requests to the IO scheduler. This usually isn't needed, but for certain
workloads that interleave requests to disks, it's a less efficient to
process the plug list one-by-one if everything is interleaved.

Don't sort the list, but skip through it and flush out entries that have
the same target at the same time.

Fixes: df87eb0fce8f ("block: get rid of plug list sorting")
Reported-by: Song Liu <song@kernel.org>
Tested-by: Song Liu <song@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq.c | 59 ++++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 31 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 862d91c6112e..213bb5979bed 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2573,13 +2573,36 @@ static void __blk_mq_flush_plug_list(struct request_queue *q,
 	q->mq_ops->queue_rqs(&plug->mq_list);
 }
 
+static void blk_mq_dispatch_plug_list(struct blk_plug *plug, bool from_sched)
+{
+	struct blk_mq_hw_ctx *this_hctx = NULL;
+	struct blk_mq_ctx *this_ctx = NULL;
+	struct request *requeue_list = NULL;
+	unsigned int depth = 0;
+	LIST_HEAD(list);
+
+	do {
+		struct request *rq = rq_list_pop(&plug->mq_list);
+
+		if (!this_hctx) {
+			this_hctx = rq->mq_hctx;
+			this_ctx = rq->mq_ctx;
+		} else if (this_hctx != rq->mq_hctx || this_ctx != rq->mq_ctx) {
+			rq_list_add(&requeue_list, rq);
+			continue;
+		}
+		list_add_tail(&rq->queuelist, &list);
+		depth++;
+	} while (!rq_list_empty(plug->mq_list));
+
+	plug->mq_list = requeue_list;
+	trace_block_unplug(this_hctx->queue, depth, !from_sched);
+	blk_mq_sched_insert_requests(this_hctx, this_ctx, &list, from_sched);
+}
+
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 {
-	struct blk_mq_hw_ctx *this_hctx;
-	struct blk_mq_ctx *this_ctx;
 	struct request *rq;
-	unsigned int depth;
-	LIST_HEAD(list);
 
 	if (rq_list_empty(plug->mq_list))
 		return;
@@ -2615,35 +2638,9 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 			return;
 	}
 
-	this_hctx = NULL;
-	this_ctx = NULL;
-	depth = 0;
 	do {
-		rq = rq_list_pop(&plug->mq_list);
-
-		if (!this_hctx) {
-			this_hctx = rq->mq_hctx;
-			this_ctx = rq->mq_ctx;
-		} else if (this_hctx != rq->mq_hctx || this_ctx != rq->mq_ctx) {
-			trace_block_unplug(this_hctx->queue, depth,
-						!from_schedule);
-			blk_mq_sched_insert_requests(this_hctx, this_ctx,
-						&list, from_schedule);
-			depth = 0;
-			this_hctx = rq->mq_hctx;
-			this_ctx = rq->mq_ctx;
-
-		}
-
-		list_add(&rq->queuelist, &list);
-		depth++;
+		blk_mq_dispatch_plug_list(plug, from_schedule);
 	} while (!rq_list_empty(plug->mq_list));
-
-	if (!list_empty(&list)) {
-		trace_block_unplug(this_hctx->queue, depth, !from_schedule);
-		blk_mq_sched_insert_requests(this_hctx, this_ctx, &list,
-						from_schedule);
-	}
 }
 
 void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
-- 
2.35.1

