Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC01C6FD1B
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjCFVaG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjCFV3U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D368143455
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PwjQZblfiJvlT8vNeewx4/kThyis4XkB9jBxOgnUfWI=;
        b=hegteEeap4hSybbHLMmGFc1YegJfPsKpdlKXtzSohnTDG7WgJLnzwbm6tO3Z7tTO++oBmC
        eTp3VXpDDY1USlMyPTfk+YPn/8tYBRrb8vzFSW2uuY2gsTWJuJnxU1T4bwQb9G//q30EQo
        +MYRTWgtb0i09Fs8yvANBdczOlU9WIQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-jJpMo2fhOpmRk58Vk4ZBzA-1; Mon, 06 Mar 2023 16:28:21 -0500
X-MC-Unique: jJpMo2fhOpmRk58Vk4ZBzA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77ACB101A55E
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:21 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2A5840C83B6;
        Mon,  6 Mar 2023 21:28:20 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 22/34] md: don't indent labels [WARNING]
Date:   Mon,  6 Mar 2023 22:27:45 +0100
Message-Id: <8aadc9ab5e20a5d855c0e2eb2f68387d0ac61cb5.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md.c     | 8 ++++----
 drivers/md/raid10.c | 2 +-
 drivers/md/raid5.c  | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 37f1323306aa..b68b6d9dd8b6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8818,7 +8818,7 @@ void md_do_sync(struct md_thread *thread)
 
 		mddev->curr_resync = MD_RESYNC_DELAYED;
 
-	try_again:
+try_again:
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			goto skip;
 		spin_lock(&all_mddevs_lock);
@@ -9033,7 +9033,7 @@ void md_do_sync(struct md_thread *thread)
 			continue;
 
 		last_check = io_sectors;
-	repeat:
+repeat:
 		if (time_after_eq(jiffies, mark[last_mark] + SYNC_MARK_STEP)) {
 			/* step marks */
 			int next = (last_mark+1) % SYNC_MARKS;
@@ -9476,7 +9476,7 @@ void md_check_recovery(struct mddev *mddev)
 			queue_work(md_misc_wq, &mddev->del_work);
 			goto unlock;
 		}
-	not_running:
+not_running:
 		if (!mddev->sync_thread) {
 			clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 			wake_up(&resync_wait);
@@ -9485,7 +9485,7 @@ void md_check_recovery(struct mddev *mddev)
 				if (mddev->sysfs_action)
 					sysfs_notify_dirent_safe(mddev->sysfs_action);
 		}
-	unlock:
+unlock:
 		wake_up(&mddev->sb_wait);
 		mddev_unlock(mddev);
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7ab011cdb995..a95609d5e79c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -5194,7 +5194,7 @@ static int handle_reshape_read_error(struct mddev *mddev,
 			rcu_read_lock();
 			if (success)
 				break;
-		failed:
+failed:
 			slot++;
 			if (slot >= conf->copies)
 				slot = 0;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a7b37a4e3f66..a1da82a72553 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5864,7 +5864,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	     logical_sector += RAID5_STRIPE_SECTORS(conf)) {
 		DEFINE_WAIT(w);
 		int d;
-	again:
+again:
 		sh = raid5_get_active_stripe(conf, NULL, logical_sector, 0);
 		prepare_to_wait(&conf->wait_for_overlap, &w,
 				TASK_UNINTERRUPTIBLE);
-- 
2.39.2

