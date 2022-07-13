Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBCF5C43334
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jul 2022 11:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbiGMLbm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Jul 2022 07:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbiGMLbk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Jul 2022 07:31:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBA1102726;
        Wed, 13 Jul 2022 04:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=W1e6MzbMvcjOzxPlhjQN2IPC6OQvXK65Jnlzyh8Wt5w=; b=Q5hDKDCBGnwfuAZzKk1G2iYRmr
        I41HgF/hfNYBkio2BSrRU0p9wo8Vy1rSPvf+OBdziTySpfTmdp6PVSjGmCkx4/BVegmiZW1OdVxNc
        zM+3CMELy8Hx5GZAmt1N2n4WLjOYdk3L76l/FIKhkpYROY6jqtpEqMBSxQy2EKudRi+dtG3zeF/ig
        2ZXaQQLfBPksAMfRZzEk7L6e0lP9MZNQUvWRhrBIgzzO8DSVOte106vw/AUec6qGqUIbG9yhRi+hh
        m1sXFcEOKslxqocB6YHQuRENc7Yy99TBuH6UZ3K9O9eoFCrDmN8La7M7Fqx3n9zqAOKtj3splcoH1
        9shTU5Xg==;
Received: from ip4d15c27d.dynamic.kabel-deutschland.de ([77.21.194.125] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oBaaf-003A3r-A4; Wed, 13 Jul 2022 11:31:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 4/9] md: factor out the rdev overlaps check from rdev_size_store
Date:   Wed, 13 Jul 2022 13:31:20 +0200
Message-Id: <20220713113125.2232975-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220713113125.2232975-1-hch@lst.de>
References: <20220713113125.2232975-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This splits the code into nicely readable chunks and also avoids
the refcount inc/dec manipulations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 84 +++++++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 45 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3127dcb8102ce..5346135ab51c8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3344,14 +3344,33 @@ rdev_size_show(struct md_rdev *rdev, char *page)
 	return sprintf(page, "%llu\n", (unsigned long long)rdev->sectors / 2);
 }
 
-static int overlaps(sector_t s1, sector_t l1, sector_t s2, sector_t l2)
+static int md_rdevs_overlap(struct md_rdev *a, struct md_rdev *b)
 {
 	/* check if two start/length pairs overlap */
-	if (s1+l1 <= s2)
-		return 0;
-	if (s2+l2 <= s1)
-		return 0;
-	return 1;
+	if (a->data_offset + a->sectors <= b->data_offset)
+		return false;
+	if (b->data_offset + b->sectors <= a->data_offset)
+		return false;
+	return true;
+}
+
+static bool md_rdev_overlaps(struct md_rdev *rdev)
+{
+	struct mddev *mddev;
+	struct md_rdev *rdev2;
+
+	spin_lock(&all_mddevs_lock);
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
+		rdev_for_each(rdev2, mddev) {
+			if (rdev != rdev2 && rdev->bdev == rdev2->bdev &&
+			    md_rdevs_overlap(rdev, rdev2)) {
+				spin_unlock(&all_mddevs_lock);
+				return true;
+			}
+		}
+	}
+	spin_unlock(&all_mddevs_lock);
+	return false;
 }
 
 static int strict_blocks_to_sectors(const char *buf, sector_t *sectors)
@@ -3403,46 +3422,21 @@ rdev_size_store(struct md_rdev *rdev, const char *buf, size_t len)
 		return -EINVAL; /* component must fit device */
 
 	rdev->sectors = sectors;
-	if (sectors > oldsectors && my_mddev->external) {
-		/* Need to check that all other rdevs with the same
-		 * ->bdev do not overlap.  'rcu' is sufficient to walk
-		 * the rdev lists safely.
-		 * This check does not provide a hard guarantee, it
-		 * just helps avoid dangerous mistakes.
-		 */
-		struct mddev *mddev;
-		int overlap = 0;
-		struct list_head *tmp;
 
-		rcu_read_lock();
-		for_each_mddev(mddev, tmp) {
-			struct md_rdev *rdev2;
-
-			rdev_for_each(rdev2, mddev)
-				if (rdev->bdev == rdev2->bdev &&
-				    rdev != rdev2 &&
-				    overlaps(rdev->data_offset, rdev->sectors,
-					     rdev2->data_offset,
-					     rdev2->sectors)) {
-					overlap = 1;
-					break;
-				}
-			if (overlap) {
-				mddev_put(mddev);
-				break;
-			}
-		}
-		rcu_read_unlock();
-		if (overlap) {
-			/* Someone else could have slipped in a size
-			 * change here, but doing so is just silly.
-			 * We put oldsectors back because we *know* it is
-			 * safe, and trust userspace not to race with
-			 * itself
-			 */
-			rdev->sectors = oldsectors;
-			return -EBUSY;
-		}
+	/*
+	 * Check that all other rdevs with the same bdev do not overlap.  This
+	 * check does not provide a hard guarantee, it just helps avoid
+	 * dangerous mistakes.
+	 */
+	if (sectors > oldsectors && my_mddev->external &&
+	    md_rdev_overlaps(rdev)) {
+		/*
+		 * Someone else could have slipped in a size change here, but
+		 * doing so is just silly.  We put oldsectors back because we
+		 * know it is safe, and trust userspace not to race with itself.
+		 */
+		rdev->sectors = oldsectors;
+		return -EBUSY;
 	}
 	return len;
 }
-- 
2.30.2

