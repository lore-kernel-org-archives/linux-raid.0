Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8869EEB64DA
	for <linux-raid@archiver.kernel.org>; Wed, 19 Jul 2023 07:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjGSHKX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Jul 2023 03:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjGSHKM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Jul 2023 03:10:12 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3AC1FF1
        for <linux-raid@vger.kernel.org>; Wed, 19 Jul 2023 00:10:10 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-2633fe9b6c0so341552a91.1
        for <linux-raid@vger.kernel.org>; Wed, 19 Jul 2023 00:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1689750610; x=1690355410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SDGPmqXPbXy9jPXGt4LdQJJoukkPj69aQm1gZgBhB4s=;
        b=ZO5rJy3NY3bE04v4sM7NoIH5y3xMENwOcbNpCW7/vWTbYEg7VpsPOLgek1OH1KyUu5
         rvDq3Gqqff3N45tL43/vJ2mBczz3kF99xG2bDW3U2sUBwx30amoN6lOMdM8blUwSvc9I
         DU7KCBecrBxugrUVLivhj0pQln78lll7BAoAfgf5+ClyW9THhAgvv79930uJ301SDscl
         JmD6Rut3YbafLF7vYHU3pETcbekWvcs/IXNgEetiJ1A7ESVK4t1ye8DtLNSYoV0KCzdl
         hJRemYZo1TQeoKgyFC/uB+sKkEvL6nUh1u9IPpYAC4gC0sRG4rrm/RBd3qJb8d5uv0CE
         a4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689750610; x=1690355410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SDGPmqXPbXy9jPXGt4LdQJJoukkPj69aQm1gZgBhB4s=;
        b=e8tmBRsO1zK/Ntth+0pqZTiwdW9C676BL7msx/4CdK0mpe5B/xj/lpNdkZ1xY3Nx8k
         /PkXL5v1jy8hIXR0BUtYaFUcrsGFiw8Mo+fJX1dkjyNnlwyItdkji+DS+qPXMFqoSBP8
         c49l9pwkbiGU19UfPuxgEFRpQDPCO7rbn4dLCLLpxx1TqKKQVv6GJNbk1Bb3XH210GxE
         fJSeb5j1SMT9cXKWFkEQ7miOSP/BiHFLXw88pWy1ozuCu2myBN6NAGVSQdvaU9ENHvZn
         PELnc3KA+qa4BKjwC1QLcV1r223717XvkJbxhNJWSc7n80RqLJPbGbNIw0Mf7o4cFaj1
         D9rg==
X-Gm-Message-State: ABy/qLZdVNvoQd7+dudoaA09FTnjfafIaNK4WQ5L3vmbl84n7FSVDs3b
        23nKvyN2sDb/G1fvCgN0H3jL3Q==
X-Google-Smtp-Source: APBJJlG//2hxKX90n2i5tHZRj1zBJ6+RGphPPYANxyzWmCdjdN582HzJp1IH+m/DGc0piYB+rOrg+w==
X-Received: by 2002:a17:90a:2e13:b0:262:ec12:7c40 with SMTP id q19-20020a17090a2e1300b00262ec127c40mr1812873pjd.11.1689750609939;
        Wed, 19 Jul 2023 00:10:09 -0700 (PDT)
Received: from nixos.tailf4e9e.ts.net ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id 11-20020a17090a194b00b002639c4f81cesm667453pjh.3.2023.07.19.00.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 00:10:09 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, yukuai1@huaweicloud.com,
        Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v3 1/3] md/raid1: freeze array more strictly when reshape
Date:   Wed, 19 Jul 2023 15:09:52 +0800
Message-Id: <20230719070954.3084379-2-xueshi.hu@smartx.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719070954.3084379-1-xueshi.hu@smartx.com>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When an IO error happens, reschedule_retry() will increase
r1conf::nr_queued, which makes freeze_array() unblocked. However, before
all r1bio in the memory pool are released, the memory pool should not be
modified. Introduce freeze_array_totally() to solve the problem. Compared
to freeze_array(), it's more strict because any in-flight io needs to
complete including queued io.

Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
---
 drivers/md/raid1.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index dd25832eb045..5605c9680818 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1072,7 +1072,7 @@ static void freeze_array(struct r1conf *conf, int extra)
 	/* Stop sync I/O and normal I/O and wait for everything to
 	 * go quiet.
 	 * This is called in two situations:
-	 * 1) management command handlers (reshape, remove disk, quiesce).
+	 * 1) management command handlers (remove disk, quiesce).
 	 * 2) one normal I/O request failed.
 
 	 * After array_frozen is set to 1, new sync IO will be blocked at
@@ -1111,6 +1111,37 @@ static void unfreeze_array(struct r1conf *conf)
 	wake_up(&conf->wait_barrier);
 }
 
+/* conf->resync_lock should be held */
+static int get_pending(struct r1conf *conf)
+{
+	int idx, ret;
+
+	ret = atomic_read(&conf->nr_sync_pending);
+	for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
+		ret += atomic_read(&conf->nr_pending[idx]);
+
+	return ret;
+}
+
+static void freeze_array_totally(struct r1conf *conf)
+{
+	/*
+	 * freeze_array_totally() is almost the same with freeze_array() except
+	 * it requires there's no queued io. Raid1's reshape will destroy the
+	 * old mempool and change r1conf::raid_disks, which are necessary when
+	 * freeing the queued io.
+	 */
+	spin_lock_irq(&conf->resync_lock);
+	conf->array_frozen = 1;
+	raid1_log(conf->mddev, "freeze totally");
+	wait_event_lock_irq_cmd(
+			conf->wait_barrier,
+			get_pending(conf) == 0,
+			conf->resync_lock,
+			md_wakeup_thread(conf->mddev->thread));
+	spin_unlock_irq(&conf->resync_lock);
+}
+
 static void alloc_behind_master_bio(struct r1bio *r1_bio,
 					   struct bio *bio)
 {
@@ -3296,7 +3327,7 @@ static int raid1_reshape(struct mddev *mddev)
 		return -ENOMEM;
 	}
 
-	freeze_array(conf, 0);
+	freeze_array_totally(conf);
 
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
-- 
2.40.1

