Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C19EC433FE
	for <linux-raid@archiver.kernel.org>; Mon, 17 Oct 2022 02:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiJQCLm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 16 Oct 2022 22:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiJQCLl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 16 Oct 2022 22:11:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D8143AC5
        for <linux-raid@vger.kernel.org>; Sun, 16 Oct 2022 19:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665972700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HTa9fa7Mnrs9q/LN1fiMsVOHuzIh7qKoS13WmKC8nSI=;
        b=hF7GY7cRatsX0eRj+rkQlPayT9tXrvY2RXwxHZUKctDhGsRpLADQlodls5rv4gFVRvT14T
        gBU5FXwWpeSrCnrDuS6p6d7lOM/c8ts1ZbvW7Ujtpf5QshMGC2zS0XIiqZUR/6Ls2/Dqbx
        o5o7rqwZ1WQoI6O8G/heYN56BKF6tpQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-SOx9kpa8NdOg8VZne6Oc-Q-1; Sun, 16 Oct 2022 22:11:36 -0400
X-MC-Unique: SOx9kpa8NdOg8VZne6Oc-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DAC8B862FDC;
        Mon, 17 Oct 2022 02:11:25 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-58.pek2.redhat.com [10.72.12.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 552AA40E9926;
        Mon, 17 Oct 2022 02:11:19 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     guoqing.jiang@linux.dev, linux-raid@vger.kernel.org,
        ffan@redhat.com
Subject: [PATCH 1/1] Add mddev->io_acct_cnt for raid0_quiesce
Date:   Mon, 17 Oct 2022 10:11:16 +0800
Message-Id: <20221017021116.39374-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It has added io_acct_set for raid0/raid5 io accounting and it needs to
alloc md_io_acct in the i/o path. They are free when the bios come back
from member disks. Now we don't have a method to monitor if those bios
are all come back. In the takeover process, it needs to free the raid0
memory resource including the memory pool for md_io_acct. But maybe some
bios are still not returned. When those bios are returned, it can cause
panic bcause of introducing NULL pointer or invalid address.

This patch adds io_acct_cnt. So when stopping raid0, it can use this
to wait until all bios come back.

Reported-by: Fine Fan <ffan@redhat.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c    | 13 ++++++++++++-
 drivers/md/md.h    | 11 ++++++++---
 drivers/md/raid0.c |  6 ++++++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9dc0175280b4..57dc2ddf1e11 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -673,6 +673,7 @@ void mddev_init(struct mddev *mddev)
 	atomic_set(&mddev->flush_pending, 0);
 	init_waitqueue_head(&mddev->sb_wait);
 	init_waitqueue_head(&mddev->recovery_wait);
+	init_waitqueue_head(&mddev->wait_io_acct);
 	mddev->reshape_position = MaxSector;
 	mddev->reshape_backwards = 0;
 	mddev->last_sync_action = "none";
@@ -8600,15 +8601,18 @@ int acct_bioset_init(struct mddev *mddev)
 {
 	int err = 0;
 
-	if (!bioset_initialized(&mddev->io_acct_set))
+	if (!bioset_initialized(&mddev->io_acct_set)) {
+		atomic_set(&mddev->io_acct_cnt, 0);
 		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
 			offsetof(struct md_io_acct, bio_clone), 0);
+	}
 	return err;
 }
 EXPORT_SYMBOL_GPL(acct_bioset_init);
 
 void acct_bioset_exit(struct mddev *mddev)
 {
+	WARN_ON(atomic_read(&mddev->io_acct_cnt) != 0);
 	bioset_exit(&mddev->io_acct_set);
 }
 EXPORT_SYMBOL_GPL(acct_bioset_exit);
@@ -8617,12 +8621,17 @@ static void md_end_io_acct(struct bio *bio)
 {
 	struct md_io_acct *md_io_acct = bio->bi_private;
 	struct bio *orig_bio = md_io_acct->orig_bio;
+	struct mddev *mddev = md_io_acct->mddev;
 
 	orig_bio->bi_status = bio->bi_status;
 
 	bio_end_io_acct(orig_bio, md_io_acct->start_time);
 	bio_put(bio);
 	bio_endio(orig_bio);
+
+	if (atomic_dec_and_test(&mddev->io_acct_cnt))
+		if (unlikely(test_bit(MD_QUIESCE, &mddev->flags)))
+			wake_up(&mddev->wait_io_acct);
 }
 
 /*
@@ -8642,6 +8651,8 @@ void md_account_bio(struct mddev *mddev, struct bio **bio)
 	md_io_acct = container_of(clone, struct md_io_acct, bio_clone);
 	md_io_acct->orig_bio = *bio;
 	md_io_acct->start_time = bio_start_io_acct(*bio);
+	md_io_acct->mddev = mddev;
+	atomic_inc(&mddev->io_acct_cnt);
 
 	clone->bi_end_io = md_end_io_acct;
 	clone->bi_private = md_io_acct;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b4e2d8b87b61..061176ff325f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -255,6 +255,7 @@ struct md_cluster_info;
  *		   array is ready yet.
  * @MD_BROKEN: This is used to stop writes and mark array as failed.
  * @MD_DELETED: This device is being deleted
+ * @MD_QUIESCE: This device is being quiesced. Now only raid0 use this flag
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -272,6 +273,7 @@ enum mddev_flags {
 	MD_NOT_READY,
 	MD_BROKEN,
 	MD_DELETED,
+	MD_QUIESCE,
 };
 
 enum mddev_sb_flags {
@@ -513,6 +515,8 @@ struct mddev {
 						   * metadata and bitmap writes
 						   */
 	struct bio_set			io_acct_set; /* for raid0 and raid5 io accounting */
+	atomic_t			io_acct_cnt;
+	wait_queue_head_t		wait_io_acct;
 
 	/* Generic flush handling.
 	 * The last to finish preflush schedules a worker to submit
@@ -710,9 +714,10 @@ struct md_thread {
 };
 
 struct md_io_acct {
-	struct bio *orig_bio;
-	unsigned long start_time;
-	struct bio bio_clone;
+	struct bio	*orig_bio;
+	unsigned long	start_time;
+	struct bio	bio_clone;
+	struct mddev	*mddev;
 };
 
 #define THREAD_WAKEUP  0
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 857c49399c28..aced0ad8cdab 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -754,6 +754,12 @@ static void *raid0_takeover(struct mddev *mddev)
 
 static void raid0_quiesce(struct mddev *mddev, int quiesce)
 {
+	/* It doesn't use a separate struct to count how many bios are submitted
+	 * to member disks to avoid memory alloc and performance decrease
+	 */
+	set_bit(MD_QUIESCE, &mddev->flags);
+	wait_event(mddev->wait_io_acct, !atomic_read(&mddev->io_acct_cnt));
+	clear_bit(MD_QUIESCE, &mddev->flags);
 }
 
 static struct md_personality raid0_personality=
-- 
2.32.0 (Apple Git-132)

