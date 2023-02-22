Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A082C61DA4
	for <linux-raid@archiver.kernel.org>; Wed, 22 Feb 2023 22:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjBVWBp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Feb 2023 17:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjBVWBo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Feb 2023 17:01:44 -0500
X-Greylist: delayed 150 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Feb 2023 14:01:42 PST
Received: from resqmta-a1p-077436.sys.comcast.net (resqmta-a1p-077436.sys.comcast.net [IPv6:2001:558:fd01:2bb4::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D433841B59
        for <linux-raid@vger.kernel.org>; Wed, 22 Feb 2023 14:01:42 -0800 (PST)
Received: from resomta-a1p-077058.sys.comcast.net ([96.103.145.239])
        by resqmta-a1p-077436.sys.comcast.net with ESMTP
        id UnbDpYZ1gi3AlUx8opEVPo; Wed, 22 Feb 2023 21:59:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1677103150;
        bh=qPdLhx5ycWaT4aMCe5WDiXmSIfDtmuyTn4IKLqHHlWY=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version:
         Xfinity-Spam-Result;
        b=vV9KnGp3GAYjtb4Hy0pvZ2chgpgHULnE8h+ss61BHdyxxHULXddfUne1I2B1CH5Xe
         UdSvATLHtwwd76jVn39GX4wJiqJWd5KiV73xOq5mCwyIlWzxM0OeoW9fXKS6hI43Rl
         n1f2q0uX/r2lDYhxFLXHswaHValM/MRxMnsKYm81FN/zcNPL2ysWi7btICup3R4OaX
         GNYlc7xWnSPnU9lWakJnMIk9qOdPHk8A0XO/qDfNgMXIuyB4NUYxicnTGDhWkRyWEi
         KMiZgHUcL/o945+NfI3IU5HYH4K8MYUbGKeyJ82WPlHOiHctSl2TUwLgHdEdJED1GD
         1G276IR66qo/g==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-a1p-077058.sys.comcast.net with ESMTPA
        id Ux8JpSr0ZqdkEUx8Upx9bW; Wed, 22 Feb 2023 21:58:50 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvhedrudejledgudehfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucevohhmtggrshhtqdftvghsihdpqfgfvfdppffquffrtefokffrnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeflohhnrghthhgrnhcuffgvrhhrihgtkhcuoehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvheqnecuggftrfgrthhtvghrnheptdetleejfffgffevhefhteevfeeuvdehveffffehtdejuedvvefgfedttdehfedtnecukfhppeejuddrvddthedrudekuddrhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghlohepjhguvghrrhhitghkqdhmohgslhegrdgrmhhrrdgtohhrphdrihhnthgvlhdrtghomhdpihhnvghtpeejuddrvddthedrudekuddrhedtpdhmrghilhhfrhhomhepjhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvpdhnsggprhgtphhtthhopeejpdhrtghpthhtohepshhonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhrrghiugesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopeignhhisehrvgguhhgrthdrtghomhdprhgtphhtthhopehhtghhsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepphhmvghnii
 gvlhesmhholhhgvghnrdhmphhgrdguvgdprhgtphhtthhopehsuhhshhhmrgdrkhgrlhgrkhhothgrsehinhhtvghlrdgtohhm
X-Xfinity-VMeta: sc=-100.00;st=legit
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
To:     Song Liu <song@kernel.org>, <linux-raid@vger.kernel.org>
Cc:     Xiao Ni <xni@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>,
        Jon Derrick <jonathan.derrick@linux.dev>
Subject: [PATCH v3 2/3] md: Fix types in sb writer
Date:   Wed, 22 Feb 2023 14:58:27 -0700
Message-Id: <20230222215828.225-3-jonathan.derrick@linux.dev>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230222215828.225-1-jonathan.derrick@linux.dev>
References: <20230222215828.225-1-jonathan.derrick@linux.dev>
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

Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
---
 drivers/md/md-bitmap.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 5c65268a2d97..11f4453775ee 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -215,55 +215,49 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
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
 		size = roundup(last_page_size,
 			       bdev_logical_block_size(bdev));
 	}
 
+	ps = page->index * (PAGE_SIZE / SECTOR_SIZE);
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
+		    sboff < (doff + mddev->dev_sectors + (PAGE_SIZE / SECTOR_SIZE)))
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
+	md_super_write(mddev, rdev, sboff + ps,
+		       (int) size, page);
 	return 0;
 }
 
-- 
2.27.0

