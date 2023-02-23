Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D14B0C64ED8
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 19:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBWTxN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 14:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBWTxK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 14:53:10 -0500
Received: from resqmta-c1p-023832.sys.comcast.net (resqmta-c1p-023832.sys.comcast.net [IPv6:2001:558:fd00:56::9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BAF1ABD3
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 11:53:08 -0800 (PST)
Received: from resomta-c1p-023265.sys.comcast.net ([96.102.18.226])
        by resqmta-c1p-023832.sys.comcast.net with ESMTP
        id VCsjpuIwAEYkgVHeNpDZJI; Thu, 23 Feb 2023 19:53:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1677181987;
        bh=ZAyZJXnouXzHtOmapox/RkPMi0XXnjlX6OGkaJdkpY0=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version:
         Xfinity-Spam-Result;
        b=HW75FU6aNa1FUg5iA2eeqptWzZqk1oMo++PapU8oSn+dwwCN3nS5A/sLz+O+hWiuV
         iweDNwxwKbVU2ILMCuLUkZZZZDPF+/3KVr1opOuFEnUMiTwzdjjQZoB96O/MXqm+T8
         rMsBwbmkSn3o4wAA1ThBo6dVn9/VzrL5L1WJAHTvJQ2yoQGH4uXcyVqOIO6CLuCjoT
         K/AuRIFj4dtmiaxK0dJP1eV2Uv9D6WfWVIeNBPEaP7SvRG2Weahq8ryEvrYErqp+p1
         enRA8mRr4DiOm7/9IBJcnEEBLkZUNprWCw+uXk/+bM+gBF3/EQWsutEI2xTrCQgtRq
         tRaxdeaQnlcsg==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-c1p-023265.sys.comcast.net with ESMTPA
        id VHdspbaW8XNRJVHe3pbD6I; Thu, 23 Feb 2023 19:52:48 +0000
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
Subject: [PATCH v4 2/3] md: Fix types in sb writer
Date:   Thu, 23 Feb 2023 12:52:24 -0700
Message-Id: <20230223195225.534-3-jonathan.derrick@linux.dev>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230223195225.534-1-jonathan.derrick@linux.dev>
References: <20230223195225.534-1-jonathan.derrick@linux.dev>
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
index 2d161d24c51c..20791d5e8903 100644
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

