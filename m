Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3B2C6379F
	for <linux-raid@archiver.kernel.org>; Wed, 18 Jan 2023 01:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjARBHS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Jan 2023 20:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjARBGt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Jan 2023 20:06:49 -0500
X-Greylist: delayed 151 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 17 Jan 2023 16:56:28 PST
Received: from resqmta-h1p-028595.sys.comcast.net (resqmta-h1p-028595.sys.comcast.net [IPv6:2001:558:fd02:2446::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9618647435
        for <linux-raid@vger.kernel.org>; Tue, 17 Jan 2023 16:56:28 -0800 (PST)
Received: from resomta-h1p-028516.sys.comcast.net ([96.102.179.207])
        by resqmta-h1p-028595.sys.comcast.net with ESMTP
        id HwOgpsb9l92y9HwiDpmmSL; Wed, 18 Jan 2023 00:53:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1674003237;
        bh=KT/2r5iU7ZHBf9ncZ+N12cQMmJ5YDBsDmN2iBqHI2M8=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version:
         Xfinity-Spam-Result;
        b=XkVv3Cmp/t1GuOH5LOrQQFhbZUSaEfiBmN38E7Ve0AGCrkZ1Y+oolUM+DqJsVMaHU
         i2eGs00npgVoiffPIN1+BmqWo+zp15dL1oDyaMFeqbV3g33lIFy9i8BUAHLWuu3jys
         rheDmJxpylzwNuvFLAO5T/NE0SMFID3pikWT1BQ+zOUKxyzSls7cX7XetMSDV7vKvi
         U87OvMQi2NesGx/aYvu9JaPxDwfGZ59yKOiHHOk+9BV5oa1yb4m0SP/TFx7BlAJQX7
         ZC3gs7loKQiaKIcrh1uKRjyXvcbIHug3v5j7KhT1Nn0hCMcCY3EDcOvd4smomTWrwJ
         OUXdVFD/Q5rSg==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-h1p-028516.sys.comcast.net with ESMTPA
        id HwhkpTnG4xvJwHwhppmO0a; Wed, 18 Jan 2023 00:53:35 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvhedruddtjedgvdekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvehomhgtrghsthdqtfgvshhipdfqfgfvpdfpqffurfetoffkrfenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheplfhonhgrthhhrghnucffvghrrhhitghkuceojhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvqeenucggtffrrghtthgvrhhnpedvtdejiefgueelteevudevhfdvjedvhfdtgfehjeeitdevueektdegtedttdehvdenucfkphepjedurddvtdehrddukedurdehtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopehjuggvrhhrihgtkhdqmhhosghlgedrrghmrhdrtghorhhprdhinhhtvghlrdgtohhmpdhinhgvthepjedurddvtdehrddukedurdehtddpmhgrihhlfhhrohhmpehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvhdpnhgspghrtghpthhtohepgedprhgtphhtthhopehsohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrhgrihgusehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhushhhmhgrrdhkrghlrghkohhtrgesihhnthgvlhdrtghomhdprhgtphhtthhopehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugi
 druggvvh
X-Xfinity-VMeta: sc=-100.00;st=legit
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
To:     Song Liu <song@kernel.org>, <linux-raid@vger.kernel.org>
Cc:     Sushma Kalakota <sushma.kalakota@intel.com>,
        Jon Derrick <jonathan.derrick@linux.dev>
Subject: [PATCH] md: Use optimal I/O size for last bitmap page
Date:   Tue, 17 Jan 2023 17:53:19 -0700
Message-Id: <20230118005319.147-1-jonathan.derrick@linux.dev>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Jon Derrick <jonathan.derrick@linux.dev>

If the bitmap space has enough room, size the I/O for the last bitmap
page write to the optimal I/O size for the storage device. The expanded
write is checked that it won't overrun the data or metadata.

This change helps increase performance by preventing unnecessary
device-side read-mod-writes due to non-atomic write unit sizes.

Ex biosnoop log. Device lba size 512, optimal size 4k:
Before:
Time        Process        PID     Device      LBA        Size      Lat
0.843734    md0_raid10     5267    nvme0n1   W 24         3584      1.17
0.843933    md0_raid10     5267    nvme1n1   W 24         3584      1.36
0.843968    md0_raid10     5267    nvme1n1   W 14207939968 4096      0.01
0.843979    md0_raid10     5267    nvme0n1   W 14207939968 4096      0.02

After:
Time        Process        PID     Device      LBA        Size      Lat
18.374244   md0_raid10     6559    nvme0n1   W 24         4096      0.01
18.374253   md0_raid10     6559    nvme1n1   W 24         4096      0.01
18.374300   md0_raid10     6559    nvme0n1   W 11020272296 4096      0.01
18.374306   md0_raid10     6559    nvme1n1   W 11020272296 4096      0.02

Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
---
 drivers/md/md-bitmap.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index e7cc6ba1b657..569297ea9b99 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -220,6 +220,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 	rdev = NULL;
 	while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
 		int size = PAGE_SIZE;
+		int optimal_size = PAGE_SIZE;
 		loff_t offset = mddev->bitmap_info.offset;
 
 		bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
@@ -228,9 +229,14 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 			int last_page_size = store->bytes & (PAGE_SIZE-1);
 			if (last_page_size == 0)
 				last_page_size = PAGE_SIZE;
-			size = roundup(last_page_size,
-				       bdev_logical_block_size(bdev));
+			size = roundup(last_page_size, bdev_logical_block_size(bdev));
+			if (bdev_io_opt(bdev) > bdev_logical_block_size(bdev))
+				optimal_size = roundup(last_page_size, bdev_io_opt(bdev));
+			else
+				optimal_size = size;
 		}
+
+
 		/* Just make sure we aren't corrupting data or
 		 * metadata
 		 */
@@ -246,9 +252,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 				goto bad_alignment;
 		} else if (offset < 0) {
 			/* DATA  BITMAP METADATA  */
-			if (offset
-			    + (long)(page->index * (PAGE_SIZE/512))
-			    + size/512 > 0)
+			loff_t off = offset + (long)(page->index * (PAGE_SIZE/512));
+			if (size != optimal_size &&
+			    off + optimal_size/512 <= 0)
+				size = optimal_size;
+			else if (off + size/512 > 0)
 				/* bitmap runs in to metadata */
 				goto bad_alignment;
 			if (rdev->data_offset + mddev->dev_sectors
@@ -257,10 +265,11 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 				goto bad_alignment;
 		} else if (rdev->sb_start < rdev->data_offset) {
 			/* METADATA BITMAP DATA */
-			if (rdev->sb_start
-			    + offset
-			    + page->index*(PAGE_SIZE/512) + size/512
-			    > rdev->data_offset)
+			loff_t off = rdev->sb_start + offset + page->index*(PAGE_SIZE/512);
+			if (size != optimal_size &&
+			    off + optimal_size/512 <= rdev->data_offset)
+				size = optimal_size;
+			else if (off + size/512 > rdev->data_offset)
 				/* bitmap runs in to data */
 				goto bad_alignment;
 		} else {
-- 
2.27.0

