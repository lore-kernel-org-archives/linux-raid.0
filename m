Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779DAC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jul 2022 07:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbiGLHFF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbiGLHED (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Jul 2022 03:04:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDDC21E02;
        Tue, 12 Jul 2022 00:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=0JLzuoaC7nW3s5hxRaC/qqyoK8M7u9apwCZLzl0G/70=; b=RSFks6mNQQfVI8KIqaWXROJAwA
        AevKjH/MNEQrD3DorF0MELIK775DA1wB5Thqr+T3Fo2E9EmhaCetrC1X4rZtrKv4qv8WMLN3U0Dsz
        SphekHYLl/qrJ+/PiCB2S0QN42yRvw1XeCjLJCaSt0tyPe3qla0mLaAATs61o7W2TTstwWhxs1XnA
        J1EoIDx9Qs+SgG3TRlmOZDrH+Oufs1ygUdxPLav0ERLKPUnrlrlqP79t2EYDTFZ8ptoNjNyV0+FjV
        L6NuYFmr/r0FAim0g8r0sI2yaCPfo8dPyKUe9YEwO1ys//aYHp2VWFhJszoBfuSbGXKIskeJeKSeB
        2YI/ugIA==;
Received: from ip4d15c27d.dynamic.kabel-deutschland.de ([77.21.194.125] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oB9w1-008DbJ-IL; Tue, 12 Jul 2022 07:03:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 7/8] md: only delete entries from all_mddevs when the disk is freed
Date:   Tue, 12 Jul 2022 09:03:30 +0200
Message-Id: <20220712070331.1390700-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712070331.1390700-1-hch@lst.de>
References: <20220712070331.1390700-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This ensures device names don't get prematurely reused.  Instead add a
deleted flag to skip already deleted devices in mddev_get and other
places that only want to see live mddevs.

Reported-by; Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 58 ++++++++++++++++++++++++++++++++++---------------
 drivers/md/md.h |  1 +
 2 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f15bc6bb65f2d..9afc438a08e4d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -625,6 +625,10 @@ EXPORT_SYMBOL(md_flush_request);
 
 static inline struct mddev *mddev_get(struct mddev *mddev)
 {
+	lockdep_assert_held(&all_mddevs_lock);
+
+	if (mddev->deleted)
+		return NULL;
 	atomic_inc(&mddev->active);
 	return mddev;
 }
@@ -639,7 +643,7 @@ static void mddev_put(struct mddev *mddev)
 	    mddev->ctime == 0 && !mddev->hold_active) {
 		/* Array is not configured at all, and not held active,
 		 * so destroy it */
-		list_del_init(&mddev->all_mddevs);
+		mddev->deleted = true;
 
 		/*
 		 * Call queue_work inside the spinlock so that
@@ -720,8 +724,8 @@ static struct mddev *mddev_find(dev_t unit)
 
 	spin_lock(&all_mddevs_lock);
 	mddev = mddev_find_locked(unit);
-	if (mddev)
-		mddev_get(mddev);
+	if (mddev && !mddev_get(mddev))
+		mddev = NULL;
 	spin_unlock(&all_mddevs_lock);
 
 	return mddev;
@@ -3330,6 +3334,8 @@ static bool md_rdev_overlaps(struct md_rdev *rdev)
 
 	spin_lock(&all_mddevs_lock);
 	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
+		if (mddev->deleted)
+			continue;
 		rdev_for_each(rdev2, mddev) {
 			if (rdev != rdev2 && rdev->bdev == rdev2->bdev &&
 			    md_rdevs_overlap(rdev, rdev2)) {
@@ -5504,11 +5510,10 @@ md_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
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
@@ -5529,11 +5534,10 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
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
@@ -7815,6 +7819,10 @@ static void md_free_disk(struct gendisk *disk)
 {
 	struct mddev *mddev = disk->private_data;
 
+	spin_lock(&all_mddevs_lock);
+	list_del_init(&mddev->all_mddevs);
+	spin_unlock(&all_mddevs_lock);
+
 	percpu_ref_exit(&mddev->writes_pending);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
@@ -8131,6 +8139,8 @@ static void *md_seq_start(struct seq_file *seq, loff_t *pos)
 		if (!l--) {
 			mddev = list_entry(tmp, struct mddev, all_mddevs);
 			mddev_get(mddev);
+			if (!mddev_get(mddev))
+				continue;
 			spin_unlock(&all_mddevs_lock);
 			return mddev;
 		}
@@ -8144,25 +8154,35 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
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
 
@@ -8732,6 +8752,8 @@ void md_do_sync(struct md_thread *thread)
 			goto skip;
 		spin_lock(&all_mddevs_lock);
 		list_for_each_entry(mddev2, &all_mddevs, all_mddevs) {
+			if (mddev2->deleted)
+				continue;
 			if (mddev2 == mddev)
 				continue;
 			if (!mddev->parallel_resync
@@ -9530,7 +9552,8 @@ static int md_notify_reboot(struct notifier_block *this,
 
 	spin_lock(&all_mddevs_lock);
 	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
-		mddev_get(mddev);
+		if (!mddev_get(mddev))
+			continue;
 		spin_unlock(&all_mddevs_lock);
 		if (mddev_trylock(mddev)) {
 			if (mddev->pers)
@@ -9885,7 +9908,8 @@ static __exit void md_exit(void)
 
 	spin_lock(&all_mddevs_lock);
 	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
-		mddev_get(mddev);
+		if (!mddev_get(mddev))
+			continue;
 		spin_unlock(&all_mddevs_lock);
 		export_array(mddev);
 		mddev->ctime = 0;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index cf2cbb17acbd4..e731a2fdc6ac1 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -488,6 +488,7 @@ struct mddev {
 
 	atomic_t			max_corr_read_errors; /* max read retries */
 	struct list_head		all_mddevs;
+	bool				deleted;
 
 	const struct attribute_group	*to_remove;
 
-- 
2.30.2

