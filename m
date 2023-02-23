Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725F5C61DA4
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 19:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjBWTxO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 14:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjBWTxK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 14:53:10 -0500
Received: from resqmta-c1p-024060.sys.comcast.net (resqmta-c1p-024060.sys.comcast.net [IPv6:2001:558:fd00:56::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FCF1A65A
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 11:53:08 -0800 (PST)
Received: from resomta-c1p-023265.sys.comcast.net ([96.102.18.226])
        by resqmta-c1p-024060.sys.comcast.net with ESMTP
        id VBEMpK2x5GVzzVHeNp88qS; Thu, 23 Feb 2023 19:53:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1677181987;
        bh=nx2nvCbLG7WVk68wLc2U+to+uc3WhXG1tRVRgU7Jcjs=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version:
         Xfinity-Spam-Result;
        b=h+/tmA5EgUmUvc0el+TdE3Y8JBHSvrT0UTWMCY7DRHrTec6mh8tGoz0AMzFPsjKKS
         v3DG3+DD6PtRMBH7BjGB4RwKaDaTLnZvdaXWMk4Rff8wAZhnI3g679Wz/IGQhKlxf6
         nNBxluPL1fJQN2WOTpDQI0p3Aj+hNx8qons5Ct1aMpbTMV59bicXk0slrjRcrwJhni
         9/m7klK3xavsEeKMFBfLtM54ar0wC5dE3k0IGbpQlJtp9BS0gMl/fH4EenzAVxTlWQ
         ib2ycnRd3i8IlHpblSE7jkddsLafPCrDPF8NRipV1j3ScDKXdo/T3XoJ8T2s3Y4l4l
         rSwggt4ret9Pw==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-c1p-023265.sys.comcast.net with ESMTPA
        id VHdspbaW8XNRJVHe3pbD6H; Thu, 23 Feb 2023 19:52:47 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvhedrudekuddguddvjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucevohhmtggrshhtqdftvghsihdpqfgfvfdppffquffrtefokffrnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeflohhnrghthhgrnhcuffgvrhhrihgtkhcuoehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvheqnecuggftrfgrthhtvghrnheptdetleejfffgffevhefhteevfeeuvdehveffffehtdejuedvvefgfedttdehfedtnecukfhppeejuddrvddthedrudekuddrhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghlohepjhguvghrrhhitghkqdhmohgslhegrdgrmhhrrdgtohhrphdrihhnthgvlhdrtghomhdpihhnvghtpeejuddrvddthedrudekuddrhedtpdhmrghilhhfrhhomhepjhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvpdhnsggprhgtphhtthhopeelpdhrtghpthhtohepshhonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhrrghiugesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehhrdhrvghinhgulhesthhhvghlohhunhhgvgdrnhgvthdprhgtphhtthhopeignhhisehrvgguhhgrthdrtghomhdprhgtphhtthhope
 hhtghhsehlshhtrdguvgdprhgtphhtthhopehhtghhsehinhhfrhgruggvrggurdhorhhg
X-Xfinity-VMeta: sc=-100.00;st=legit
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
To:     Song Liu <song@kernel.org>, <linux-raid@vger.kernel.org>
Cc:     Reindl Harald <h.reindl@thelounge.net>, Xiao Ni <xni@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>,
        Jon Derrick <jonathan.derrick@linux.dev>
Subject: [PATCH v4 1/3] md: Move sb writer loop to its own function
Date:   Thu, 23 Feb 2023 12:52:23 -0700
Message-Id: <20230223195225.534-2-jonathan.derrick@linux.dev>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230223195225.534-1-jonathan.derrick@linux.dev>
References: <20230223195225.534-1-jonathan.derrick@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Jon Derrick <jonathan.derrick@linux.dev>

Preparatory patch for optimal I/O size calculation. Move the sb writer
loop routine into its own function for clarity.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
---
 drivers/md/md-bitmap.c | 124 +++++++++++++++++++++--------------------
 1 file changed, 64 insertions(+), 60 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index e7cc6ba1b657..2d161d24c51c 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -209,76 +209,80 @@ static struct md_rdev *next_active_rdev(struct md_rdev *rdev, struct mddev *mdde
 	return NULL;
 }
 
-static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
+static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
+			   struct page *page)
 {
-	struct md_rdev *rdev;
 	struct block_device *bdev;
 	struct mddev *mddev = bitmap->mddev;
 	struct bitmap_storage *store = &bitmap->storage;
+	loff_t offset = mddev->bitmap_info.offset;
+	int size = PAGE_SIZE;
+
+	bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
+	if (page->index == store->file_pages - 1) {
+		int last_page_size = store->bytes & (PAGE_SIZE - 1);
+
+		if (last_page_size == 0)
+			last_page_size = PAGE_SIZE;
+		size = roundup(last_page_size,
+			       bdev_logical_block_size(bdev));
+	}
+
+	/* Just make sure we aren't corrupting data or metadata */
+	if (mddev->external) {
+		/* Bitmap could be anywhere. */
+		if (rdev->sb_start + offset
+		    + (page->index * (PAGE_SIZE / SECTOR_SIZE))
+		    > rdev->data_offset &&
+		    rdev->sb_start + offset
+		    < (rdev->data_offset + mddev->dev_sectors
+		     + (PAGE_SIZE / SECTOR_SIZE)))
+			return -EINVAL;
+	} else if (offset < 0) {
+		/* DATA  BITMAP METADATA  */
+		if (offset
+		    + (long)(page->index * (PAGE_SIZE / SECTOR_SIZE))
+		    + size / SECTOR_SIZE > 0)
+			/* bitmap runs in to metadata */
+			return -EINVAL;
+
+		if (rdev->data_offset + mddev->dev_sectors
+		    > rdev->sb_start + offset)
+			/* data runs in to bitmap */
+			return -EINVAL;
+	} else if (rdev->sb_start < rdev->data_offset) {
+		/* METADATA BITMAP DATA */
+		if (rdev->sb_start + offset
+		    + page->index * (PAGE_SIZE / SECTOR_SIZE)
+		    + size / SECTOR_SIZE > rdev->data_offset)
+			/* bitmap runs in to data */
+			return -EINVAL;
+	} else {
+		/* DATA METADATA BITMAP - no problems */
+	}
 
-restart:
-	rdev = NULL;
-	while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
-		int size = PAGE_SIZE;
-		loff_t offset = mddev->bitmap_info.offset;
+	md_super_write(mddev, rdev,
+		       rdev->sb_start + offset
+		       + page->index * (PAGE_SIZE / SECTOR_SIZE),
+		       size, page);
+	return 0;
+}
 
-		bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
+static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
+{
+	struct md_rdev *rdev;
+	struct mddev *mddev = bitmap->mddev;
+	int ret;
 
-		if (page->index == store->file_pages-1) {
-			int last_page_size = store->bytes & (PAGE_SIZE-1);
-			if (last_page_size == 0)
-				last_page_size = PAGE_SIZE;
-			size = roundup(last_page_size,
-				       bdev_logical_block_size(bdev));
-		}
-		/* Just make sure we aren't corrupting data or
-		 * metadata
-		 */
-		if (mddev->external) {
-			/* Bitmap could be anywhere. */
-			if (rdev->sb_start + offset + (page->index
-						       * (PAGE_SIZE/512))
-			    > rdev->data_offset
-			    &&
-			    rdev->sb_start + offset
-			    < (rdev->data_offset + mddev->dev_sectors
-			     + (PAGE_SIZE/512)))
-				goto bad_alignment;
-		} else if (offset < 0) {
-			/* DATA  BITMAP METADATA  */
-			if (offset
-			    + (long)(page->index * (PAGE_SIZE/512))
-			    + size/512 > 0)
-				/* bitmap runs in to metadata */
-				goto bad_alignment;
-			if (rdev->data_offset + mddev->dev_sectors
-			    > rdev->sb_start + offset)
-				/* data runs in to bitmap */
-				goto bad_alignment;
-		} else if (rdev->sb_start < rdev->data_offset) {
-			/* METADATA BITMAP DATA */
-			if (rdev->sb_start
-			    + offset
-			    + page->index*(PAGE_SIZE/512) + size/512
-			    > rdev->data_offset)
-				/* bitmap runs in to data */
-				goto bad_alignment;
-		} else {
-			/* DATA METADATA BITMAP - no problems */
+	do {
+		while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
+			ret = __write_sb_page(rdev, bitmap, page);
+			if (ret)
+				return ret;
 		}
-		md_super_write(mddev, rdev,
-			       rdev->sb_start + offset
-			       + page->index * (PAGE_SIZE/512),
-			       size,
-			       page);
-	}
+	} while (wait && md_super_wait(mddev) < 0);
 
-	if (wait && md_super_wait(mddev) < 0)
-		goto restart;
 	return 0;
-
- bad_alignment:
-	return -EINVAL;
 }
 
 static void md_bitmap_file_kick(struct bitmap *bitmap);
-- 
2.27.0

