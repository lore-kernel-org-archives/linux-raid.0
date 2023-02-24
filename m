Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40706C7EE2F
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 18:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjBXSgk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Feb 2023 13:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjBXSgi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Feb 2023 13:36:38 -0500
Received: from resqmta-h1p-028591.sys.comcast.net (resqmta-h1p-028591.sys.comcast.net [IPv6:2001:558:fd02:2446::9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE4D6C52D
        for <linux-raid@vger.kernel.org>; Fri, 24 Feb 2023 10:36:37 -0800 (PST)
Received: from resomta-h1p-027911.sys.comcast.net ([96.102.179.202])
        by resqmta-h1p-028591.sys.comcast.net with ESMTP
        id VX6dpz14qGC5dVctRpKfHM; Fri, 24 Feb 2023 18:34:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1677263645;
        bh=5Z0w+ugex+J+O+Uy6m1Y4yEW69xQp3sPnb0QS7Al950=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version:
         Xfinity-Spam-Result;
        b=Wk4VaX/enhWV84ZBtNVkaNwZR7+cq4t/JOl62MQNIMCzqcRQDqPSlkf7Y5PcbJ8QN
         n3A4MLm6HJ/nAh9rwWXRJjtpgeIcI+wP7NBQW8UtyWgNHlCFpbQpl0e3NKjhaekxl+
         dmnUn9H7RT3BtoRTnbt6QXnqGBKHm1Zgvy64f3P5aEPGAtXWtFtB2KZ2T/0EG6Bf7U
         e0wixWhx+Xp+RMEJVhjfmQMVeXW2360++WpFDYUgx9QSAI65fIPk+IjYwNE6VVGTIL
         xs+j3CIsYsh8QjgcaNlVVumCJl80Geq+N8z8Ma3N3uq7kOkFw7EthHc+YRb6xZT5I9
         c7+0cyFFdyNYw==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-h1p-027911.sys.comcast.net with ESMTPA
        id VcsvpymQMN2puVct8pamiL; Fri, 24 Feb 2023 18:33:46 +0000
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
Subject: [PATCH v5 2/3] md: Fix types in sb writer
Date:   Fri, 24 Feb 2023 11:33:22 -0700
Message-Id: <20230224183323.638-3-jonathan.derrick@linux.dev>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230224183323.638-1-jonathan.derrick@linux.dev>
References: <20230224183323.638-1-jonathan.derrick@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Jon Derrick <jonathan.derrick@linux.dev>

Page->index is a pgoff_t and multiplying could cause overflows on a
32-bit architecture. In the sb writer, this is used to calculate and
verify the sector being used, and is multiplied by a sector value. Using
sector_t will cast it to a u64 type and is the more appropriate type for
the unit. Additionally, the integer size unit is converted to a sector
unit in later calculations, and is now corrected to be an unsigned type.

Finally, clean up the calculations using variable aliases to improve
readabiliy.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
---
 drivers/md/md-bitmap.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index cdc61e65abae..bf250a5e3a86 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -215,12 +215,13 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 	struct block_device *bdev;
 	struct mddev *mddev = bitmap->mddev;
 	struct bitmap_storage *store = &bitmap->storage;
-	loff_t offset = mddev->bitmap_info.offset;
-	int size = PAGE_SIZE;
+	sector_t offset = mddev->bitmap_info.offset;
+	sector_t ps, sboff, doff;
+	unsigned int size = PAGE_SIZE;
 
 	bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
 	if (page->index == store->file_pages - 1) {
-		int last_page_size = store->bytes & (PAGE_SIZE - 1);
+		unsigned int last_page_size = store->bytes & (PAGE_SIZE - 1);
 
 		if (last_page_size == 0)
 			last_page_size = PAGE_SIZE;
@@ -228,43 +229,35 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
 			       bdev_logical_block_size(bdev));
 	}
 
+	ps = page->index * PAGE_SIZE / SECTOR_SIZE;
+	sboff = rdev->sb_start + offset;
+	doff = rdev->data_offset;
+
 	/* Just make sure we aren't corrupting data or metadata */
 	if (mddev->external) {
 		/* Bitmap could be anywhere. */
-		if (rdev->sb_start + offset
-		    + (page->index * (PAGE_SIZE / SECTOR_SIZE))
-		    > rdev->data_offset &&
-		    rdev->sb_start + offset
-		    < (rdev->data_offset + mddev->dev_sectors
-		     + (PAGE_SIZE / SECTOR_SIZE)))
+		if (sboff + ps > doff &&
+		    sboff < (doff + mddev->dev_sectors + PAGE_SIZE / SECTOR_SIZE))
 			return -EINVAL;
 	} else if (offset < 0) {
 		/* DATA  BITMAP METADATA  */
-		if (offset
-		    + (long)(page->index * (PAGE_SIZE / SECTOR_SIZE))
-		    + size / SECTOR_SIZE > 0)
+		if (offset + ps + size / SECTOR_SIZE > 0)
 			/* bitmap runs in to metadata */
 			return -EINVAL;
 
-		if (rdev->data_offset + mddev->dev_sectors
-		    > rdev->sb_start + offset)
+		if (doff + mddev->dev_sectors > sboff)
 			/* data runs in to bitmap */
 			return -EINVAL;
 	} else if (rdev->sb_start < rdev->data_offset) {
 		/* METADATA BITMAP DATA */
-		if (rdev->sb_start + offset
-		    + page->index * (PAGE_SIZE / SECTOR_SIZE)
-		    + size / SECTOR_SIZE > rdev->data_offset)
+		if (sboff + ps + size / SECTOR_SIZE > doff)
 			/* bitmap runs in to data */
 			return -EINVAL;
 	} else {
 		/* DATA METADATA BITMAP - no problems */
 	}
 
-	md_super_write(mddev, rdev,
-		       rdev->sb_start + offset
-		       + page->index * (PAGE_SIZE / SECTOR_SIZE),
-		       size, page);
+	md_super_write(mddev, rdev, sboff + ps, (int) size, page);
 	return 0;
 }
 
-- 
2.27.0

