From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] md/bitmap: don't read page from device with Bitmap_sync
Date: Fri, 16 Jun 2017 17:19:27 +0800
Message-ID: <20170616091927.12959-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, neilb@suse.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The device owns Bitmap_sync flag needs recovery
to become in sync, and read page from this type
device could get stale status.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
When develop for clustered raid10 feature, if add a
disk under grow mode in master node, I could get
the "bitmap superblock UUID mismatch" warning due
to the page is read from Bitmap_sync device.

 drivers/md/bitmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index bf7419a..bf34cd8 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -156,7 +156,8 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
 
 	rdev_for_each(rdev, mddev) {
 		if (! test_bit(In_sync, &rdev->flags)
-		    || test_bit(Faulty, &rdev->flags))
+		    || test_bit(Faulty, &rdev->flags)
+		    || test_bit(Bitmap_sync, &rdev->flags))
 			continue;
 
 		target = offset + index * (PAGE_SIZE/512);
-- 
2.10.0

