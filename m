Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C288EB64DA
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jul 2023 11:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjGELcd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jul 2023 07:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjGELcc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 5 Jul 2023 07:32:32 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874021731
        for <linux-raid@vger.kernel.org>; Wed,  5 Jul 2023 04:32:30 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a640c23a62f3a-99364ae9596so388211066b.1
        for <linux-raid@vger.kernel.org>; Wed, 05 Jul 2023 04:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1688556749; x=1691148749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pfcUkXskDs1PlVvCtS/77goHvC4BWQbuyFAW01s6mBc=;
        b=isBp8vwIqideYqERyjyF1KDBqgDM4ZMokUPXK1kF07Ns59/xXEHK21Q6M9SYLpD+lK
         Rf8Vtvmrgnfh3zI2s7/aNsaRao56U1v1L+cT6pDp787eulr6v68Yp4L2CocG6fNnk2yB
         t+66vyD8c+DW/185ApyUqGUsdB2r2MTZMjsd1raWjEYDThg5i5jF4/abm0ZWtwmPj7Ao
         xR6S8zLNtn7V9DzISmYaCU+DozqfnZ64xe4pIrIu6bzgdI+ZZCFJPCA5pFDEyQHprz49
         ryOOzAvTIDHacsUynIUddgBdGtBjT1mn2oaeO20BxrMjPLLTpJ9PMJ3FPIEl/5+NBEnI
         YYhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688556749; x=1691148749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pfcUkXskDs1PlVvCtS/77goHvC4BWQbuyFAW01s6mBc=;
        b=TNecQkpwVlogqklQvk6oRepg46p3g9pMcOWJGtBWLpZcTB1/4Cs1PFYO4twlVydOiW
         SoOSlC/hd3BIaFZgW+91rIKITvz00I+muJ4SxwsI6HFGQMlz/Q9iyXbrMf5faeJ2MG/s
         YKy1uTCUNsoso0yeZXXbT8gKN7MMaEcO+iOobrOWR5P2nr0amMqwfor+668clkvbPab5
         1f3UAK7ymNMcFTOM4gzUpVFg3dHa6co3BQZzKNeviQTmwgU76dicEm5XbRUANZyNSQIe
         N0nSvezPkADZirpVy/RZ6HevDTpP2ulMRFf1Kc/rNAPCJe/FWa8pVp60A82pC2uzq0FN
         uy6w==
X-Gm-Message-State: ABy/qLZaqwH2S2Xcx8VbIRoCkqaN7lI6pzAp3JZQOW6iAw+j1+OHXFTm
        my80BOQZ3rN5E5M+/r2vxs0a8M8WL79A+zsEKQ/4lQDP
X-Google-Smtp-Source: APBJJlEbH6e5YBxzmPE6yCw2Iem1tFPSIJYd9IbNU3AFo4VcdpiB1nLjSG7vkZbhU30L6m9MlHFSxw==
X-Received: by 2002:a17:906:16c9:b0:991:e12e:9855 with SMTP id t9-20020a17090616c900b00991e12e9855mr11107555ejd.12.1688556748787;
        Wed, 05 Jul 2023 04:32:28 -0700 (PDT)
Received: from lb02065.fkb.profitbricks.net ([2001:9e8:1411:3900:c130:881:a7f7:61f5])
        by smtp.gmail.com with ESMTPSA id qn13-20020a170907210d00b00992e51fecfbsm7088720ejb.64.2023.07.05.04.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 04:32:28 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>
Subject: [PATCHv3] md/raid1: Avoid lock contention from wake_up()
Date:   Wed,  5 Jul 2023 13:32:27 +0200
Message-Id: <20230705113227.148494-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

wake_up is called unconditionally in a few paths such as make_request(),
which cause lock contention under high concurrency workload like below
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
v3: rephrase the commit message, no code change.

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

