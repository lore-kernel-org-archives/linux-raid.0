Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33610C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jul 2022 07:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiGLHER (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbiGLHED (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Jul 2022 03:04:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E57A20BC0;
        Tue, 12 Jul 2022 00:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=QB0MAeCjGLNIrTltp2yZr/YZmKCC5R22ivvPxP0yPBw=; b=d0PIlzGXHuUWYgo1ie4K3v0Wk1
        AK98QtNpnKR0IkIInOfED/MUDRNR/AeyjQmxSudc+W7ppliRuYrEJ4pAFX2xO52YIn8pko96G+Lar
        Zq5i+pAezxbL1MdT0l89Bzi0N136UMOvOy73bQLQjT9oIaQBdTG32nS1RW3+WBWZewYM6FplldeK/
        n9o/Ih/PlHzdUhzOAEeLZ2EAEMis7RcmE61pQx/5ZNZbvZz4oIxlw0/bAKuSlcbi5FVdFKE+2303D
        18x8uK7SgKXj2FLjykjvHbTPX8DbYVpIVSj4RlNlcnzOb1snm4v3NrZrIjy3DiAuIUvIyAiqQGnmi
        Bn9rIy0A==;
Received: from ip4d15c27d.dynamic.kabel-deutschland.de ([77.21.194.125] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oB9vz-008DZY-0F; Tue, 12 Jul 2022 07:03:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 6/8] md: stop using for_each_mddev in md_exit
Date:   Tue, 12 Jul 2022 09:03:29 +0200
Message-Id: <20220712070331.1390700-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712070331.1390700-1-hch@lst.de>
References: <20220712070331.1390700-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Just do a simple list_for_each_entry_safe on all_mddevs, and only grab a
reference when we drop the lock and delete the now unused for_each_mddev
macro.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 73abeaed0b6fc..f15bc6bb65f2d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -368,28 +368,6 @@ EXPORT_SYMBOL_GPL(md_new_event);
 static LIST_HEAD(all_mddevs);
 static DEFINE_SPINLOCK(all_mddevs_lock);
 
-/*
- * iterates through all used mddevs in the system.
- * We take care to grab the all_mddevs_lock whenever navigating
- * the list, and to always hold a refcount when unlocked.
- * Any code which breaks out of this loop while own
- * a reference to the current mddev and must mddev_put it.
- */
-#define for_each_mddev(_mddev,_tmp)					\
-									\
-	for (({ spin_lock(&all_mddevs_lock);				\
-		_tmp = all_mddevs.next;					\
-		_mddev = NULL;});					\
-	     ({ if (_tmp != &all_mddevs)				\
-			mddev_get(list_entry(_tmp, struct mddev, all_mddevs));\
-		spin_unlock(&all_mddevs_lock);				\
-		if (_mddev) mddev_put(_mddev);				\
-		_mddev = list_entry(_tmp, struct mddev, all_mddevs);	\
-		_tmp != &all_mddevs;});					\
-	     ({ spin_lock(&all_mddevs_lock);				\
-		_tmp = _tmp->next;})					\
-		)
-
 /* Rather than calling directly into the personality make_request function,
  * IO requests come here first so that we can check if the device is
  * being suspended pending a reconfiguration.
@@ -9885,8 +9863,7 @@ void md_autostart_arrays(int part)
 
 static __exit void md_exit(void)
 {
-	struct mddev *mddev;
-	struct list_head *tmp;
+	struct mddev *mddev, *n;
 	int delay = 1;
 
 	unregister_blkdev(MD_MAJOR,"md");
@@ -9906,17 +9883,23 @@ static __exit void md_exit(void)
 	}
 	remove_proc_entry("mdstat", NULL);
 
-	for_each_mddev(mddev, tmp) {
+	spin_lock(&all_mddevs_lock);
+	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
+		mddev_get(mddev);
+		spin_unlock(&all_mddevs_lock);
 		export_array(mddev);
 		mddev->ctime = 0;
 		mddev->hold_active = 0;
 		/*
-		 * for_each_mddev() will call mddev_put() at the end of each
-		 * iteration.  As the mddev is now fully clear, this will
-		 * schedule the mddev for destruction by a workqueue, and the
+		 * As the mddev is now fully clear, mddev_put will schedule
+		 * the mddev for destruction by a workqueue, and the
 		 * destroy_workqueue() below will wait for that to complete.
 		 */
+		mddev_put(mddev);
+		spin_lock(&all_mddevs_lock);
 	}
+	spin_unlock(&all_mddevs_lock);
+
 	destroy_workqueue(md_rdev_misc_wq);
 	destroy_workqueue(md_misc_wq);
 	destroy_workqueue(md_wq);
-- 
2.30.2

