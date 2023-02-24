Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377F6C7EE23
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 18:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjBXSgi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Feb 2023 13:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjBXSgh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Feb 2023 13:36:37 -0500
X-Greylist: delayed 150 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Feb 2023 10:36:36 PST
Received: from resqmta-h1p-028589.sys.comcast.net (resqmta-h1p-028589.sys.comcast.net [IPv6:2001:558:fd02:2446::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7746C52F
        for <linux-raid@vger.kernel.org>; Fri, 24 Feb 2023 10:36:36 -0800 (PST)
Received: from resomta-h1p-027911.sys.comcast.net ([96.102.179.202])
        by resqmta-h1p-028589.sys.comcast.net with ESMTP
        id VX6dpHL7vEHHIVctRpD1Ws; Fri, 24 Feb 2023 18:34:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1677263645;
        bh=OQQr3ZZ1aotkrNi+c3xKvuXGnWynaXu23fZ7KOEQ4jE=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version:
         Xfinity-Spam-Result;
        b=MZ8g5fkJpgrx+OyvwJdInsP+4YjfDg3IpQi5iTS6+9I+B9GdCCzf3N/yE+3L0Bsap
         Upwaa49yW2zt9nZMj+p+2qXvZZ0GzEmv6J3mGnWW70sCIiLRnXaTZ8Z+7Z/n2f9DfU
         UNyq5k0msVVWhMydJ6lg4dDtloOVE8yJVHrJMGuKbQfLrcjzZbG7DWp1fOZSzIR+Za
         VsRrVHDyr7XWfsRw0OSscR3LGkeqUQ80VsqZVtP/QL9SM2VNSvW4KAZdGxvcKdYZvY
         e0ZXAIuGBMP97xWOBdluwYQk45NiSbtU3paKg24P/D+SPds4fz1vYkaBgLwgXYlMRF
         eaaSBKIPt+QMg==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-h1p-027911.sys.comcast.net with ESMTPA
        id VcsvpymQMN2puVct6pamiB; Fri, 24 Feb 2023 18:33:45 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvhedrudekfedguddtlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucevohhmtggrshhtqdftvghsihdpqfgfvfdppffquffrtefokffrnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeflohhnrghthhgrnhcuffgvrhhrihgtkhcuoehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvheqnecuggftrfgrthhtvghrnheptdetleejfffgffevhefhteevfeeuvdehveffffehtdejuedvvefgfedttdehfedtnecukfhppeejuddrvddthedrudekuddrhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghlohepjhguvghrrhhitghkqdhmohgslhegrdgrmhhrrdgtohhrphdrihhnthgvlhdrtghomhdpihhnvghtpeejuddrvddthedrudekuddrhedtpdhmrghilhhfrhhomhepjhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvpdhnsggprhgtphhtthhopeelpdhrtghpthhtohepshhonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhrrghiugesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehhrdhrvghinhgulhesthhhvghlohhunhhgvgdrnhgvthdprhgtphhtthhopeignhhisehrvgguhhgrthdrtghomhdprhgtphhtthhope
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
Subject: [PATCH v5 1/3] md: Move sb writer loop to its own function
Date:   Fri, 24 Feb 2023 11:33:21 -0700
Message-Id: <20230224183323.638-2-jonathan.derrick@linux.dev>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230224183323.638-1-jonathan.derrick@linux.dev>
References: <20230224183323.638-1-jonathan.derrick@linux.dev>
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
 drivers/md/md-bitmap.c | 125 +++++++++++++++++++++--------------------
 1 file changed, 65 insertions(+), 60 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index e7cc6ba1b657..cdc61e65abae 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -209,76 +209,81 @@ static struct md_rdev *next_active_rdev(struct md_rdev *rdev, struct mddev *mdde
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
+		rdev = NULL;
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

