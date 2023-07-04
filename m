Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35FAEEB64DD
	for <linux-raid@archiver.kernel.org>; Tue,  4 Jul 2023 07:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjGDHly (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 Jul 2023 03:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjGDHlx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 4 Jul 2023 03:41:53 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76627CA
        for <linux-raid@vger.kernel.org>; Tue,  4 Jul 2023 00:41:52 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id 4fb4d7f45d1cf-51d805cb33aso6625441a12.3
        for <linux-raid@vger.kernel.org>; Tue, 04 Jul 2023 00:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1688456511; x=1691048511;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xVwvYHw3xOjEWJL0O11gAIq6vskmzoOhFMid45tHxj8=;
        b=RcwL9PdLa0rauAx8+6T6qawBggJxtaSLkYjOGYfkmr+VLmlpbMG6uxlBzsrlW5N6ed
         eiQwbhCCire4zniXlSk4JMgpKGss9xEMu0BbHGVPtP0w3Hp/a6PJbkj8rm/UyXRuPu9J
         WVz7XDHfj1MYOalit50QPCXZ+Fdk+JUeN18srCyNwEZR4mB8QcB5TLqBtcWtrf5nIL0M
         EpTsmrIo3mCJbgxrBkaMUl4JPLZL/Xt1J9jMRixnQ3Mhp4ONnReCrhEfbSQtjNlosE/8
         +HqSIPIRxs4UC88oVAzSWdsRc569edB3Rjdh5vJ68xyzCfNtQN2GYzMEQgzOefQOohqz
         C0Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688456511; x=1691048511;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xVwvYHw3xOjEWJL0O11gAIq6vskmzoOhFMid45tHxj8=;
        b=a6CnfQuGy1yj1t9BmJO0UiUGdPYQRhIAnNfn0WYxHTJePkn/zjR2hUW7U+Cgs5MHam
         0BcfQ0XoWdSFF3aAl1txRMgAKMyVg4j0/IIUG4wHP3usCpa2qWWTvbIzLtBl5rsAnAcc
         RlOqm+VkqKszmQ+2HewPBe7gAEtyF4uXIhAVVAYpattAwesV2KDJFWIW+r5sNjajr9eP
         sOKIQ8KD5QUd/JuqIKRbHkjZ6/y3XuVACWO/esGqQummio1G1HIV7XH4yyCdbZoWfqyE
         2STgGfjHJmjfetSs+aTPpV8gAfn+OL3gp2chaaDJ4PhKEqG17JX/8ZtHZA61WiRD9oDL
         alhg==
X-Gm-Message-State: ABy/qLZ7pdWSl5a/P+tFWuhND3ETdDpdNs5DVIviCbvJAwGNVbhxm/bQ
        Vc360bI7jaqH28c/X0khkHICDIcLyVrO3UCK8YY5+p6Z
X-Google-Smtp-Source: APBJJlEhcX6Ywf217fU9wOxhIKUkGgGv+6Vt3tpUiVk5FH1fz76y2jbd0VjOcN3WsG7wrj0rc2UNqA==
X-Received: by 2002:aa7:d64e:0:b0:51e:cc7:534d with SMTP id v14-20020aa7d64e000000b0051e0cc7534dmr5277100edr.24.1688456510727;
        Tue, 04 Jul 2023 00:41:50 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:1435:9200:c0c6:7201:e34a:3a])
        by smtp.gmail.com with ESMTPSA id m16-20020aa7c2d0000000b0051e070cff76sm3310870edp.3.2023.07.04.00.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 00:41:50 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>
Subject: [PATCHv2] md/raid1: Prevent unnecessary call to wake_up() in fast path
Date:   Tue,  4 Jul 2023 09:41:49 +0200
Message-Id: <20230704074149.58863-1-jinpu.wang@ionos.com>
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

Test result with 2 ramdisk in raid1 on a Intel Broadwell 56 cores server.

	Before this patch       With this patch
	READ	BW=4621MB/s	BW=7337MB/s
	WRITE	BW=1980MB/s	BW=3144MB/s

The patch is inspired by Yu Kuai's change for raid10:
https://lore.kernel.org/r/20230621105728.1268542-1-yukuai1@huaweicloud.com

Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
v2: addressed comments from Kuai
* Removed newline
* change the missing case in raid1_write_request
* I still kept the change for _wait_barrier and wait_read_barrier, as I did
 performance tests without them there are still lock contention from
 __wake_up_common_lock

 drivers/md/raid1.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f834d99a36f6..0c76c36d8cb1 100644
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
@@ -970,7 +976,7 @@ static bool _wait_barrier(struct r1conf *conf, int idx, bool nowait)
 	 * In case freeze_array() is waiting for
 	 * get_unqueued_pending() == extra
 	 */
-	wake_up(&conf->wait_barrier);
+	wake_up_barrier(conf);
 	/* Wait for the barrier in same barrier unit bucket to drop. */
 
 	/* Return false when nowait flag is set */
@@ -1013,7 +1019,7 @@ static bool wait_read_barrier(struct r1conf *conf, sector_t sector_nr, bool nowa
 	 * In case freeze_array() is waiting for
 	 * get_unqueued_pending() == extra
 	 */
-	wake_up(&conf->wait_barrier);
+	wake_up_barrier(conf);
 	/* Wait for array to be unfrozen */
 
 	/* Return false when nowait flag is set */
@@ -1042,7 +1048,7 @@ static bool wait_barrier(struct r1conf *conf, sector_t sector_nr, bool nowait)
 static void _allow_barrier(struct r1conf *conf, int idx)
 {
 	atomic_dec(&conf->nr_pending[idx]);
-	wake_up(&conf->wait_barrier);
+	wake_up_barrier(conf);
 }
 
 static void allow_barrier(struct r1conf *conf, sector_t sector_nr)
@@ -1171,7 +1177,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		spin_unlock_irq(&conf->device_lock);
-		wake_up(&conf->wait_barrier);
+		wake_up_barrier(conf);
 		md_wakeup_thread(mddev->thread);
 		kfree(plug);
 		return;
@@ -1574,7 +1580,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	r1_bio_write_done(r1_bio);
 
 	/* In case raid1d snuck in to freeze_array */
-	wake_up(&conf->wait_barrier);
+	wake_up_barrier(conf);
 }
 
 static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
-- 
2.34.1

