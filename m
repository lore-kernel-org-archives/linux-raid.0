From: "=?UTF-8?B?5b2t6Imv5b2m?=" <liangyan.ply@alibaba-inc.com>
Subject: [PATCH] bcache: Fix bdev leak during backing device registering
Date: Thu, 23 Nov 2017 08:42:38 +0800
Message-ID: <20171123004238.79132-1-liangyan.ply@alibaba-inc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?5b2t6Imv5b2m?= <liangyan.ply@alibaba-inc.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Coly Li <colyli@suse.de>, =?UTF-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@alibaba-inc.com>
List-Id: linux-raid.ids

If the backing device hasn't been detached due to exceptional stop
like power outage, the BDEV_STATE in super block can't be reset,
it will fail to register this backing device in next time, but the
opened bdev will be hold, this makes the backing device unaccessable
because of FMODE_EXCL until reboot.

Signed-off-by: Liangyan Peng <liangyan.ply@alibaba-inc.com>
---
 drivers/md/bcache/super.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 66669c8f4161..0b95a594c12e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1174,9 +1174,7 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 	list_for_each_entry(c, &bch_cache_sets, list)
 		bch_cached_dev_attach(dc, c);
 
-	if (BDEV_STATE(&dc->sb) == BDEV_STATE_NONE ||
-	    BDEV_STATE(&dc->sb) == BDEV_STATE_STALE)
-		bch_cached_dev_run(dc);
+	bch_cached_dev_run(dc);
 
 	return;
 err:
@@ -1982,7 +1980,16 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		goto err_close;
 
 	if (SB_IS_BDEV(sb)) {
-		struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
+		struct cached_dev *dc = NULL;
+
+		if (BDEV_STATE(sb) != BDEV_STATE_NONE &&
+			BDEV_STATE(sb) != BDEV_STATE_STALE) {
+			blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
+			err = "invalid super block";
+			pr_info("Failed to register %s: %s", path, err);
+			goto out;
+		}
+		dc = kzalloc(sizeof(*dc), GFP_KERNEL);
 		if (!dc)
 			goto err_close;
 
-- 
2.14.1.40.g8e62ba1
