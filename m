Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57341EB8FB5
	for <linux-raid@archiver.kernel.org>; Wed,  6 Sep 2023 08:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbjIFItL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Sep 2023 04:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbjIFItJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Sep 2023 04:49:09 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14CF10D9;
        Wed,  6 Sep 2023 01:48:57 -0700 (PDT)
Received: from dggpeml500003.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RgbXm2gfkzhZHy;
        Wed,  6 Sep 2023 16:44:56 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpeml500003.china.huawei.com
 (7.185.36.200) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Wed, 6 Sep
 2023 16:48:55 +0800
From:   Li Nan <linan122@huawei.com>
To:     <song@kernel.org>
CC:     <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linan122@huawei.com>, <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH] md: use interruptible apis in idle/frozen_sync_thread
Date:   Wed, 6 Sep 2023 16:44:01 +0800
Message-ID: <20230906084401.1027358-1-linan122@huawei.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500003.china.huawei.com (7.185.36.200)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Before refactoring idle and frozen from action_store, interruptible apis
is used so that hungtask warning won't be triggered if it takes too long
to finish indle/frozen sync_thread. So change to use interruptible apis.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 46badd13a687..52689adfa37f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4834,11 +4834,14 @@ static void idle_sync_thread(struct mddev *mddev)
 {
 	int sync_seq = atomic_read(&mddev->sync_seq);
 
-	mutex_lock(&mddev->sync_mutex);
+	if (mutex_lock_interruptible(&mddev->sync_mutex))
+		return;
+
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	stop_sync_thread(mddev);
 
-	wait_event(resync_wait, sync_seq != atomic_read(&mddev->sync_seq) ||
+	wait_event_interruptible(resync_wait,
+			sync_seq != atomic_read(&mddev->sync_seq) ||
 			!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));
 
 	mutex_unlock(&mddev->sync_mutex);
@@ -4846,11 +4849,13 @@ static void idle_sync_thread(struct mddev *mddev)
 
 static void frozen_sync_thread(struct mddev *mddev)
 {
-	mutex_lock(&mddev->sync_mutex);
+	if (mutex_lock_interruptible(&mddev->sync_mutex))
+		return;
+
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	stop_sync_thread(mddev);
 
-	wait_event(resync_wait, mddev->sync_thread == NULL &&
+	wait_event_interruptible(resync_wait, mddev->sync_thread == NULL &&
 			!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));
 
 	mutex_unlock(&mddev->sync_mutex);
-- 
2.39.2

