Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBF6C43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 09:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237330AbiGSJUG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 05:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237375AbiGSJTL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 05:19:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5592C648;
        Tue, 19 Jul 2022 02:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=m4NrhbVGccTIK5QopqHsRRCGN1zz0H3F22TyrvpKWM8=; b=NaxqOtLpes/Yq3665T2bY+7/0s
        lmpsxC3+wLpfqmgHk3pZ2eKPNeCG5DTPQq7rQxvvnJY3xj0IGKeoqH7vQgzPbrFt8utVNr3m0I5ka
        5CtDoqzrwwlKtemMN4bIvJ+RTap8DNW1USflWxyJ6VC5GuHveJ7iLVuoVADyNejt7AMJB8iEbUAHD
        SoAdk2xYPePH+WeHjaG+6cmwLY1J1cvtvHfU1WtjdIvX/3IoEaMe3rxVncH4C0Q1vOdYodpk1j9pe
        cfxQePFn1XegFVkOfjW6YwlqKJzwUYwJ/dIge6R3faQWq5xXcFt0GNKWj99dUE5WPzdEbaQPW2V3e
        GrGlGN7w==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDjNi-007D0P-1s; Tue, 19 Jul 2022 09:19:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 09/10] md: only delete entries from all_mddevs when the disk is freed
Date:   Tue, 19 Jul 2022 11:18:23 +0200
Message-Id: <20220719091824.1064989-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220719091824.1064989-1-hch@lst.de>
References: <20220719091824.1064989-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This ensures device names don't get prematurely reused.  Instead add a
deleted flag to skip already deleted devices in mddev_get and other
places that only want to see live mddevs.

Reported-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 56 +++++++++++++++++++++++++++++++++----------------
 drivers/md/md.h |  2 ++
 2 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ee3e9ba03fd25..6180d0a6b926d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -625,6 +625,10 @@ EXPORT_SYMBOL(md_flush_request);
 
 static inline struct mddev *mddev_get(struct mddev *mddev)
 {
+	lockdep_assert_held(&all_mddevs_lock);
+
+	if (test_bit(MD_DELETED, &mddev->flags))
+		return NULL;
 	atomic_inc(&mddev->active);
 	return mddev;
 }
@@ -639,7 +643,7 @@ static void mddev_put(struct mddev *mddev)
 	    mddev->ctime == 0 && !mddev->hold_active) {
 		/* Array is not configured at all, and not held active,
 		 * so destroy it */
-		list_del_init(&mddev->all_mddevs);
+		set_bit(MD_DELETED, &mddev->flags);
 
 		/*
 		 * Call queue_work inside the spinlock so that
@@ -719,8 +723,8 @@ static struct mddev *mddev_find(dev_t unit)
 
 	spin_lock(&all_mddevs_lock);
 	mddev = mddev_find_locked(unit);
-	if (mddev)
-		mddev_get(mddev);
+	if (mddev && !mddev_get(mddev))
+		mddev = NULL;
 	spin_unlock(&all_mddevs_lock);
 
 	return mddev;
@@ -3338,6 +3342,8 @@ static bool md_rdev_overlaps(struct md_rdev *rdev)
 
 	spin_lock(&all_mddevs_lock);
 	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
+		if (test_bit(MD_DELETED, &mddev->flags))
+			continue;
 		rdev_for_each(rdev2, mddev) {
 			if (rdev != rdev2 && rdev->bdev == rdev2->bdev &&
 			    md_rdevs_overlap(rdev, rdev2)) {
@@ -5525,11 +5531,10 @@ md_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 	if (!entry->show)
 		return -EIO;
 	spin_lock(&all_mddevs_lock);
-	if (list_empty(&mddev->all_mddevs)) {
+	if (!mddev_get(mddev)) {
 		spin_unlock(&all_mddevs_lock);
 		return -EBUSY;
 	}
-	mddev_get(mddev);
 	spin_unlock(&all_mddevs_lock);
 
 	rv = entry->show(mddev, page);
@@ -5550,11 +5555,10 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 	spin_lock(&all_mddevs_lock);
-	if (list_empty(&mddev->all_mddevs)) {
+	if (!mddev_get(mddev)) {
 		spin_unlock(&all_mddevs_lock);
 		return -EBUSY;
 	}
-	mddev_get(mddev);
 	spin_unlock(&all_mddevs_lock);
 	rv = entry->store(mddev, page, length);
 	mddev_put(mddev);
@@ -7849,7 +7853,7 @@ static void md_free_disk(struct gendisk *disk)
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
 
-	kfree(mddev);
+	mddev_free(mddev);
 }
 
 const struct block_device_operations md_fops =
@@ -8171,6 +8175,8 @@ static void *md_seq_start(struct seq_file *seq, loff_t *pos)
 		if (!l--) {
 			mddev = list_entry(tmp, struct mddev, all_mddevs);
 			mddev_get(mddev);
+			if (!mddev_get(mddev))
+				continue;
 			spin_unlock(&all_mddevs_lock);
 			return mddev;
 		}
@@ -8184,25 +8190,35 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct list_head *tmp;
 	struct mddev *next_mddev, *mddev = v;
+	struct mddev *to_put = NULL;
 
 	++*pos;
 	if (v == (void*)2)
 		return NULL;
 
 	spin_lock(&all_mddevs_lock);
-	if (v == (void*)1)
+	if (v == (void*)1) {
 		tmp = all_mddevs.next;
-	else
+	} else {
+		to_put = mddev;
 		tmp = mddev->all_mddevs.next;
-	if (tmp != &all_mddevs)
-		next_mddev = mddev_get(list_entry(tmp,struct mddev,all_mddevs));
-	else {
-		next_mddev = (void*)2;
-		*pos = 0x10000;
 	}
+
+	for (;;) {
+		if (tmp == &all_mddevs) {
+			next_mddev = (void*)2;
+			*pos = 0x10000;
+			break;
+		}
+		next_mddev = list_entry(tmp, struct mddev, all_mddevs);
+		if (mddev_get(next_mddev))
+			break;
+		mddev = next_mddev;
+		tmp = mddev->all_mddevs.next;
+	};
 	spin_unlock(&all_mddevs_lock);
 
-	if (v != (void*)1)
+	if (to_put)
 		mddev_put(mddev);
 	return next_mddev;
 
@@ -8766,6 +8782,8 @@ void md_do_sync(struct md_thread *thread)
 			goto skip;
 		spin_lock(&all_mddevs_lock);
 		list_for_each_entry(mddev2, &all_mddevs, all_mddevs) {
+			if (test_bit(MD_DELETED, &mddev2->flags))
+				continue;
 			if (mddev2 == mddev)
 				continue;
 			if (!mddev->parallel_resync
@@ -9568,7 +9586,8 @@ static int md_notify_reboot(struct notifier_block *this,
 
 	spin_lock(&all_mddevs_lock);
 	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
-		mddev_get(mddev);
+		if (!mddev_get(mddev))
+			continue;
 		spin_unlock(&all_mddevs_lock);
 		if (mddev_trylock(mddev)) {
 			if (mddev->pers)
@@ -9923,7 +9942,8 @@ static __exit void md_exit(void)
 
 	spin_lock(&all_mddevs_lock);
 	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
-		mddev_get(mddev);
+		if (!mddev_get(mddev))
+			continue;
 		spin_unlock(&all_mddevs_lock);
 		export_array(mddev);
 		mddev->ctime = 0;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1a85dbe78a71c..6d1e526065cca 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -254,6 +254,7 @@ struct md_cluster_info;
  * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not report that
  *		   array is ready yet.
  * @MD_BROKEN: This is used to stop writes and mark array as failed.
+ * @MD_DELETED: This device is being deleted
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -270,6 +271,7 @@ enum mddev_flags {
 	MD_UPDATING_SB,
 	MD_NOT_READY,
 	MD_BROKEN,
+	MD_DELETED,
 };
 
 enum mddev_sb_flags {
-- 
2.30.2

