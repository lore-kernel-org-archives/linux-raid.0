Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B2FC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 09:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239412AbhLJJfR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Dec 2021 04:35:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234263AbhLJJfQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 10 Dec 2021 04:35:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639128701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qyF+Ci3i+7RAXewpi6KMFHsPNBhdSb6c0pTanKvIZ1c=;
        b=JaWBz7SttHLVstB72AcFL8okONHO6mpHqHtZ+LQQdzVIkaDcgqQ+jhgQf08XwZ7thUJnDj
        jSAS8ooxB8TGUoavY0xe+hvurijvPpP6W+AtGG2YoBWiBDOrjTxGbFLyZ7xWs/Aj5+CJuW
        OyhBDOnfyZskPZiPv/GUERto/j2VKwk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-8OLSNdL1PAG-TEI6GIzojA-1; Fri, 10 Dec 2021 04:31:38 -0500
X-MC-Unique: 8OLSNdL1PAG-TEI6GIzojA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F6F7101F7A1;
        Fri, 10 Dec 2021 09:31:37 +0000 (UTC)
Received: from fedora.redhat.com (ovpn-12-214.pek2.redhat.com [10.72.12.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C74F1001F4D;
        Fri, 10 Dec 2021 09:31:35 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     guoqing.jiang@linux.dev, ncroxon@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH 2/2] md: Move alloc/free acct bioset in to personality
Date:   Fri, 10 Dec 2021 17:31:16 +0800
Message-Id: <20211210093116.7847-3-xni@redhat.com>
In-Reply-To: <20211210093116.7847-1-xni@redhat.com>
References: <20211210093116.7847-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Now it alloc acct bioset in md_run and only raid0/raid5 need acct
bioset. For example, it doesn't create acct bioset when creating
raid1. Then reshape from raid1 to raid0/raid5, it will access acct
bioset after reshaping. It can panic because of NULL pointer
reference.

We can move alloc/free jobs to personality. pers->run alloc acct
bioset and pers->clean free it.

Fixes: daee2024715d (md: check level before create and exit io_acct_set)
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c    | 27 +++++++++++++++++----------
 drivers/md/md.h    |  2 ++
 drivers/md/raid0.c | 10 +++++++++-
 drivers/md/raid5.c | 41 ++++++++++++++++++++++++++++++-----------
 4 files changed, 58 insertions(+), 22 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e8666bdc0d28..0fc34a05a655 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5878,13 +5878,6 @@ int md_run(struct mddev *mddev)
 		if (err)
 			goto exit_bio_set;
 	}
-	if (mddev->level != 1 && mddev->level != 10 &&
-	    !bioset_initialized(&mddev->io_acct_set)) {
-		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
-				  offsetof(struct md_io_acct, bio_clone), 0);
-		if (err)
-			goto exit_sync_set;
-	}
 
 	spin_lock(&pers_lock);
 	pers = find_pers(mddev->level, mddev->clevel);
@@ -6061,9 +6054,6 @@ int md_run(struct mddev *mddev)
 	module_put(pers->owner);
 	md_bitmap_destroy(mddev);
 abort:
-	if (mddev->level != 1 && mddev->level != 10)
-		bioset_exit(&mddev->io_acct_set);
-exit_sync_set:
 	bioset_exit(&mddev->sync_set);
 exit_bio_set:
 	bioset_exit(&mddev->bio_set);
@@ -8596,6 +8586,23 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 }
 EXPORT_SYMBOL_GPL(md_submit_discard_bio);
 
+int acct_bioset_init(struct mddev *mddev)
+{
+	int err = 0;
+
+	if (!bioset_initialized(&mddev->io_acct_set))
+		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
+			offsetof(struct md_io_acct, bio_clone), 0);
+	return err;
+}
+EXPORT_SYMBOL_GPL(acct_bioset_init);
+
+void acct_bioset_exit(struct mddev *mddev)
+{
+	bioset_exit(&mddev->io_acct_set);
+}
+EXPORT_SYMBOL_GPL(acct_bioset_exit);
+
 static void md_end_io_acct(struct bio *bio)
 {
 	struct md_io_acct *md_io_acct = bio->bi_private;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 53ea7a6961de..f1bf3625ef4c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -721,6 +721,8 @@ extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_finish_reshape(struct mddev *mddev);
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 			struct bio *bio, sector_t start, sector_t size);
+int acct_bioset_init(struct mddev *mddev);
+void acct_bioset_exit(struct mddev *mddev);
 void md_account_bio(struct mddev *mddev, struct bio **bio);
 
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 88424d7a6ebd..b59a77b31b90 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -369,6 +369,7 @@ static void raid0_free(struct mddev *mddev, void *priv)
 	struct r0conf *conf = priv;
 
 	free_conf(mddev, conf);
+	acct_bioset_exit(mddev);
 }
 
 static int raid0_run(struct mddev *mddev)
@@ -383,11 +384,16 @@ static int raid0_run(struct mddev *mddev)
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 
+	if (acct_bioset_init(mddev)) {
+		pr_err("md/raid0:%s: alloc acct bioset failed.\n", mdname(mddev));
+		return -ENOMEM;
+	}
+
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {
 		ret = create_strip_zones(mddev, &conf);
 		if (ret < 0)
-			return ret;
+			goto exit_acct_set;
 		mddev->private = conf;
 	}
 	conf = mddev->private;
@@ -433,6 +439,8 @@ static int raid0_run(struct mddev *mddev)
 
 free:
 	free_conf(mddev, conf);
+exit_acct_set:
+	acct_bioset_exit(mddev);
 	return ret;
 }
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1240a5c16af8..13afa8c5cc8a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7447,12 +7447,19 @@ static int raid5_run(struct mddev *mddev)
 	struct md_rdev *rdev;
 	struct md_rdev *journal_dev = NULL;
 	sector_t reshape_offset = 0;
-	int i;
+	int i, ret = 0;
 	long long min_offset_diff = 0;
 	int first = 1;
 
-	if (mddev_init_writes_pending(mddev) < 0)
+	if (acct_bioset_init(mddev)) {
+		pr_err("md/raid456:%s: alloc acct bioset failed.\n", mdname(mddev));
 		return -ENOMEM;
+	}
+
+	if (mddev_init_writes_pending(mddev) < 0) {
+		ret = -ENOMEM;
+		goto exit_acct_set;
+	}
 
 	if (mddev->recovery_cp != MaxSector)
 		pr_notice("md/raid:%s: not clean -- starting background reconstruction\n",
@@ -7483,7 +7490,8 @@ static int raid5_run(struct mddev *mddev)
 	    (mddev->bitmap_info.offset || mddev->bitmap_info.file)) {
 		pr_notice("md/raid:%s: array cannot have both journal and bitmap\n",
 			  mdname(mddev));
-		return -EINVAL;
+		ret = -EINVAL;
+		goto exit_acct_set;
 	}
 
 	if (mddev->reshape_position != MaxSector) {
@@ -7508,13 +7516,15 @@ static int raid5_run(struct mddev *mddev)
 		if (journal_dev) {
 			pr_warn("md/raid:%s: don't support reshape with journal - aborting.\n",
 				mdname(mddev));
-			return -EINVAL;
+			ret = -EINVAL;
+			goto exit_acct_set;
 		}
 
 		if (mddev->new_level != mddev->level) {
 			pr_warn("md/raid:%s: unsupported reshape required - aborting.\n",
 				mdname(mddev));
-			return -EINVAL;
+			ret = -EINVAL;
+			goto exit_acct_set;
 		}
 		old_disks = mddev->raid_disks - mddev->delta_disks;
 		/* reshape_position must be on a new-stripe boundary, and one
@@ -7530,7 +7540,8 @@ static int raid5_run(struct mddev *mddev)
 		if (sector_div(here_new, chunk_sectors * new_data_disks)) {
 			pr_warn("md/raid:%s: reshape_position not on a stripe boundary\n",
 				mdname(mddev));
-			return -EINVAL;
+			ret = -EINVAL;
+			goto exit_acct_set;
 		}
 		reshape_offset = here_new * chunk_sectors;
 		/* here_new is the stripe we will write to */
@@ -7552,7 +7563,8 @@ static int raid5_run(struct mddev *mddev)
 			else if (mddev->ro == 0) {
 				pr_warn("md/raid:%s: in-place reshape must be started in read-only mode - aborting\n",
 					mdname(mddev));
-				return -EINVAL;
+				ret = -EINVAL;
+				goto exit_acct_set;
 			}
 		} else if (mddev->reshape_backwards
 		    ? (here_new * chunk_sectors + min_offset_diff <=
@@ -7562,7 +7574,8 @@ static int raid5_run(struct mddev *mddev)
 			/* Reading from the same stripe as writing to - bad */
 			pr_warn("md/raid:%s: reshape_position too early for auto-recovery - aborting.\n",
 				mdname(mddev));
-			return -EINVAL;
+			ret = -EINVAL;
+			goto exit_acct_set;
 		}
 		pr_debug("md/raid:%s: reshape will continue\n", mdname(mddev));
 		/* OK, we should be able to continue; */
@@ -7586,8 +7599,10 @@ static int raid5_run(struct mddev *mddev)
 	else
 		conf = mddev->private;
 
-	if (IS_ERR(conf))
-		return PTR_ERR(conf);
+	if (IS_ERR(conf)) {
+		ret = PTR_ERR(conf);
+		goto exit_acct_set;
+	}
 
 	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
 		if (!journal_dev) {
@@ -7784,7 +7799,10 @@ static int raid5_run(struct mddev *mddev)
 	free_conf(conf);
 	mddev->private = NULL;
 	pr_warn("md/raid:%s: failed to run raid set.\n", mdname(mddev));
-	return -EIO;
+	ret = -EIO;
+exit_acct_set:
+	acct_bioset_exit(mddev);
+	return ret;
 }
 
 static void raid5_free(struct mddev *mddev, void *priv)
@@ -7792,6 +7810,7 @@ static void raid5_free(struct mddev *mddev, void *priv)
 	struct r5conf *conf = priv;
 
 	free_conf(conf);
+	acct_bioset_exit(mddev);
 	mddev->to_remove = &raid5_attrs_group;
 }
 
-- 
2.31.1

