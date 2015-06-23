From: Shaohua Li <shli@fb.com>
Subject: [PATCH V4 10/13] raid5: don't allow resize/reshape with cache support
Date: Tue, 23 Jun 2015 14:38:00 -0700
Message-ID: <e4b3fb3ea95daad7b6aad2f5072c9f727dd96696.1435094582.git.shli@fb.com>
References: <cover.1435094582.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1435094582.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

If cache support is enabled, don't allow resize/reshape in current
stage. In the future, we can flush all data from cache to raid before
resize/reshape and then allow resize/reshape.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 093611e..f3b22f2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7186,6 +7186,10 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	 * worth it.
 	 */
 	sector_t newsize;
+	struct r5conf *conf = mddev->private;
+
+	if (conf->cache)
+		return -EINVAL;
 	sectors &= ~((sector_t)mddev->chunk_sectors - 1);
 	newsize = raid5_size(mddev, sectors, mddev->raid_disks);
 	if (mddev->external_size &&
@@ -7237,6 +7241,8 @@ static int check_reshape(struct mddev *mddev)
 {
 	struct r5conf *conf = mddev->private;
 
+	if (conf->cache)
+		return -EINVAL;
 	if (mddev->delta_disks == 0 &&
 	    mddev->new_layout == mddev->layout &&
 	    mddev->new_chunk_sectors == mddev->chunk_sectors)
-- 
1.8.1

