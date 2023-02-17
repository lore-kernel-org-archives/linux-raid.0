Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43EFC636D6
	for <linux-raid@archiver.kernel.org>; Fri, 17 Feb 2023 18:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjBQSeq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Feb 2023 13:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjBQSen (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 17 Feb 2023 13:34:43 -0500
X-Greylist: delayed 150 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Feb 2023 10:34:41 PST
Received: from resqmta-c1p-023464.sys.comcast.net (resqmta-c1p-023464.sys.comcast.net [IPv6:2001:558:fd00:56::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB9635259
        for <linux-raid@vger.kernel.org>; Fri, 17 Feb 2023 10:34:41 -0800 (PST)
Received: from resomta-c1p-023268.sys.comcast.net ([96.102.18.235])
        by resqmta-c1p-023464.sys.comcast.net with ESMTP
        id T5DmpKRhWNlD1T5Wkp4m52; Fri, 17 Feb 2023 18:32:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1676658730;
        bh=Jmbbz+aKj8JUMdSdg6+lY6TP1a06yodxxmrC0ISfnBM=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version:
         Xfinity-Spam-Result;
        b=vM0SZS1wIuDpwiZUMxVVJpoHuXaAB+zHAHwsOeiRYDtb3xXyTMB3a75z04X0Q03ID
         cJQ1QcEHZ6FwjHrFHVo6Sp5ZPU+fy3kCDjoZzUUzMZ1rfAnrPisCnhk9JMGXho931L
         5uQA1TNvQWfd9Rr4pbOAmOVYiscvx6g8c0w0TKR3OWvF9yMSWQ2P81e0GnbvwKPwMi
         k2lPMfkdARgvti6Z0GgLj2gTmBhqd+3PcVJH9CxMZROCiUZM9++2KCxNBvl/eAxQs8
         FqISEi0p5uLBExdNIDoYePk8YXvki9E9pbBvWfwzhcA/ZOUDK+hZOzYKzHtpOzG1w2
         8yLX/fXamA7ZA==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-c1p-023268.sys.comcast.net with ESMTPA
        id T5WHpbmdrmpwmT5WMpiebx; Fri, 17 Feb 2023 18:31:48 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvhedrudeiledguddutdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucevohhmtggrshhtqdftvghsihdpqfgfvfdppffquffrtefokffrnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeflohhnrghthhgrnhcuffgvrhhrihgtkhcuoehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvheqnecuggftrfgrthhtvghrnhepvddtjeeigfeuleetveduvefhvdejvdfhtdfgheejiedtveeukedtgeettddthedvnecukfhppeejuddrvddthedrudekuddrhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghlohepjhguvghrrhhitghkqdhmohgslhegrdgrmhhrrdgtohhrphdrihhnthgvlhdrtghomhdpihhnvghtpeejuddrvddthedrudekuddrhedtpdhmrghilhhfrhhomhepjhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvpdhnsggprhgtphhtthhopeehpdhrtghpthhtohepshhonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhrrghiugesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehpmhgvnhiivghlsehmohhlghgvnhdrmhhpghdruggvpdhrtghpthhtohepshhushhhmhgrrdhkrghlrghkohhtrgesihhnthgvlhdrtghomh
 dprhgtphhtthhopehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvh
X-Xfinity-VMeta: sc=-100.00;st=legit
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
To:     Song Liu <song@kernel.org>, <linux-raid@vger.kernel.org>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>,
        Jon Derrick <jonathan.derrick@linux.dev>
Subject: [PATCH v2] md: Use optimal I/O size for last bitmap page
Date:   Fri, 17 Feb 2023 11:31:39 -0700
Message-Id: <20230217183139.106-1-jonathan.derrick@linux.dev>
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

Example Intel/Solidigm P5520
Raid10, Chunk-size 64M, bitmap-size 57228 bits

$ mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/nvme{0,1,2,3}n1 --assume-clean --bitmap=internal --bitmap-chunk=64M
$ fio --name=test --direct=1 --filename=/dev/md0 --rw=randwrite --bs=4k --runtime=60

Without patch:
  write: IOPS=1676, BW=6708KiB/s (6869kB/s)(393MiB/60001msec); 0 zone resets

With patch:
  write: IOPS=15.7k, BW=61.4MiB/s (64.4MB/s)(3683MiB/60001msec); 0 zone resets

Biosnoop:
Without patch:
Time        Process        PID     Device      LBA        Size      Lat
1.410377    md0_raid10     6900    nvme0n1   W 16         4096      0.02
1.410387    md0_raid10     6900    nvme2n1   W 16         4096      0.02
1.410374    md0_raid10     6900    nvme3n1   W 16         4096      0.01
1.410381    md0_raid10     6900    nvme1n1   W 16         4096      0.02
1.410411    md0_raid10     6900    nvme1n1   W 115346512  4096      0.01
1.410418    md0_raid10     6900    nvme0n1   W 115346512  4096      0.02
1.410915    md0_raid10     6900    nvme2n1   W 24         3584      0.43
1.410935    md0_raid10     6900    nvme3n1   W 24         3584      0.45
1.411124    md0_raid10     6900    nvme1n1   W 24         3584      0.64
1.411147    md0_raid10     6900    nvme0n1   W 24         3584      0.66
1.411176    md0_raid10     6900    nvme3n1   W 2019022184 4096      0.01
1.411189    md0_raid10     6900    nvme2n1   W 2019022184 4096      0.02

With patch:
Time        Process        PID     Device      LBA        Size      Lat
5.747193    md0_raid10     727     nvme0n1   W 16         4096      0.01
5.747192    md0_raid10     727     nvme1n1   W 16         4096      0.02
5.747195    md0_raid10     727     nvme3n1   W 16         4096      0.01
5.747202    md0_raid10     727     nvme2n1   W 16         4096      0.02
5.747229    md0_raid10     727     nvme3n1   W 1196223704 4096      0.02
5.747224    md0_raid10     727     nvme0n1   W 1196223704 4096      0.01
5.747279    md0_raid10     727     nvme0n1   W 24         4096      0.01
5.747279    md0_raid10     727     nvme1n1   W 24         4096      0.02
5.747284    md0_raid10     727     nvme3n1   W 24         4096      0.02
5.747291    md0_raid10     727     nvme2n1   W 24         4096      0.02
5.747314    md0_raid10     727     nvme2n1   W 2234636712 4096      0.01
5.747317    md0_raid10     727     nvme1n1   W 2234636712 4096      0.02

Signed-off-by: Jon Derrick <jonathan.derrick@linux.dev>
---
v1->v2: Add more information to commit message

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

