Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B672EB64DD
	for <linux-raid@archiver.kernel.org>; Mon,  3 Jul 2023 08:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjGCIBy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 3 Jul 2023 04:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbjGCIBn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 3 Jul 2023 04:01:43 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D481721
        for <linux-raid@vger.kernel.org>; Mon,  3 Jul 2023 01:01:22 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id 4fb4d7f45d1cf-51d9890f368so4553066a12.2
        for <linux-raid@vger.kernel.org>; Mon, 03 Jul 2023 01:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1688371280; x=1690963280;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bA/PHgSONU4z+h0QF90XnSjU3zD1Kk86W8CNOAlP8Ok=;
        b=b/vcCaGt9/sBLk5MaBE7N4IlSfV81m38o5XFdhxoI6IeQzePuGHxUZqmeuU5ZZxZKb
         O10f0qZ++wYf5/mESxuPDI14p1Ve08oL9cyg5TEIlFsTaxOXBvqzzzk5ZW916LXJgQpH
         xz2Y5Wx9KvE1d7TOYqVHeNbl6U3kC8J1Qtjl6cO1T+uu4/u2jamaHTR6IgmFY+tahWMO
         5qC6nhQK65lfmXqbXTU+htAir8a+lui+QrbiwgzhnX/7yJSjPD1N8Be2Zw0zXGwscrCx
         bSUtx2fqSRTHrOt9BD/HG+e4S+XCbQ/9z9Jc4X/Nhl2K8+vm8PaNrNxtvEYo34ibQEJg
         B/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688371280; x=1690963280;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bA/PHgSONU4z+h0QF90XnSjU3zD1Kk86W8CNOAlP8Ok=;
        b=JYEDnBIC0SpIaQwofGMkuXAwChqC0icC7WiHrgz+vkpliu6JjrbziUM3fLaosBon6f
         ZLMPVu2jJEl3xA+VYhBs7uMPXoCEnSWdZeaoh4n6zxnB/bZaV5yMApnx+VY/l8vmUMip
         jS/EwH+BdkuQgNlWattD8mWvTHeKa/U1WKHSLOrB2MS+fWDxEwz38N9JgN5reVZjA1Gj
         2dcNl3en+ZU1V/9gRUqX2KWYXu2RB9NMIPkLrhobfswU0QvKpBQdCk6ZWg3GLsdnUgqL
         dUmdjOhY38dG0/Q23xDVjC3KbJll8C7Wn6SMLfsbo5szCBYmGw7dDBRrQ69lX5F8jf1D
         6lfw==
X-Gm-Message-State: ABy/qLZ9+2swymhGNI7v/EiFw8HVqQzoK6N/mbrnN7y0lKPRqX5UerMv
        EBRWn4vD0Qj579qKkR7mTiGFzeP1t7kavUV7MR3/PoWt
X-Google-Smtp-Source: APBJJlEBExQG37p/w++Dlppr9VM5DPAENcdQv5EmPWsk3ORiPSbFsPIn7tY3UM7fG6iHVx5AFDSi6g==
X-Received: by 2002:aa7:d8d2:0:b0:51e:16ae:b6d7 with SMTP id k18-20020aa7d8d2000000b0051e16aeb6d7mr503389eds.33.1688371280048;
        Mon, 03 Jul 2023 01:01:20 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:141a:3800:bdc7:c600:b6ef:e03d])
        by smtp.gmail.com with ESMTPSA id b5-20020aa7cd05000000b0051da8fd7570sm4814720edw.41.2023.07.03.01.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jul 2023 01:01:19 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH] raid1: prevent unnecessary call to wake_up() in fast path
Date:   Mon,  3 Jul 2023 10:01:19 +0200
Message-Id: <20230703080119.11464-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

wake_up is called unconditionally in fast path such as make_request(),
which cause lock contention under high concurrency
    raid1_end_write_request
     wake_up
      __wake_up_common_lock
       spin_lock_irqsave

Improve performance by only call wake_up() if waitqueue is not empty

Fio test script:

[global]
name=random reads and writes
ioengine=libaio
direct=1
readwrite=randrw
rwmixread=70
iodepth=64
buffered=0
filename=/dev/md0
size=1G
runtime=30
time_based
randrepeat=0
norandommap
refill_buffers
ramp_time=10
bs=4k
numjobs=400
group_reporting=1
[job1]

Test result with ramdisk raid1 on a EPYC:

	Before this patch       With this patch
	READ	BW=4621MB/s	BW=7337MB/s
	WRITE	BW=1980MB/s	BW=1675MB/s

The patch is inspired by Yu Kuai's change for raid10:
https://lore.kernel.org/r/20230621105728.1268542-1-yukuai1@huaweicloud.com

Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/md/raid1.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f834d99a36f6..808c91f338e6 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -789,11 +789,17 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 	return best_disk;
 }
 
+static void wake_up_barrier(struct r1conf *conf)
+{
+	if (wq_has_sleeper(&conf->wait_barrier))
+		wake_up(&conf->wait_barrier);
+}
+
 static void flush_bio_list(struct r1conf *conf, struct bio *bio)
 {
 	/* flush any pending bitmap writes to disk before proceeding w/ I/O */
 	raid1_prepare_flush_writes(conf->mddev->bitmap);
-	wake_up(&conf->wait_barrier);
+	wake_up_barrier(conf);
 
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
@@ -835,6 +841,7 @@ static void flush_pending_writes(struct r1conf *conf)
 		spin_unlock_irq(&conf->device_lock);
 }
 
+
 /* Barriers....
  * Sometimes we need to suspend IO while we do something else,
  * either some resync/recovery, or reconfigure the array.
@@ -970,7 +977,7 @@ static bool _wait_barrier(struct r1conf *conf, int idx, bool nowait)
 	 * In case freeze_array() is waiting for
 	 * get_unqueued_pending() == extra
 	 */
-	wake_up(&conf->wait_barrier);
+	wake_up_barrier(conf);
 	/* Wait for the barrier in same barrier unit bucket to drop. */
 
 	/* Return false when nowait flag is set */
@@ -1013,7 +1020,7 @@ static bool wait_read_barrier(struct r1conf *conf, sector_t sector_nr, bool nowa
 	 * In case freeze_array() is waiting for
 	 * get_unqueued_pending() == extra
 	 */
-	wake_up(&conf->wait_barrier);
+	wake_up_barrier(conf);
 	/* Wait for array to be unfrozen */
 
 	/* Return false when nowait flag is set */
@@ -1042,7 +1049,7 @@ static bool wait_barrier(struct r1conf *conf, sector_t sector_nr, bool nowait)
 static void _allow_barrier(struct r1conf *conf, int idx)
 {
 	atomic_dec(&conf->nr_pending[idx]);
-	wake_up(&conf->wait_barrier);
+	wake_up_barrier(conf);
 }
 
 static void allow_barrier(struct r1conf *conf, sector_t sector_nr)
@@ -1171,7 +1178,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		spin_unlock_irq(&conf->device_lock);
-		wake_up(&conf->wait_barrier);
+		wake_up_barrier(conf);
 		md_wakeup_thread(mddev->thread);
 		kfree(plug);
 		return;
-- 
2.34.1

