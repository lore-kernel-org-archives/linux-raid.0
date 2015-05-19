From: Shaohua Li <shli@fb.com>
Subject: [PATCH v2 5/6] md: don't allow resize/reshape with cache support
Date: Mon, 18 May 2015 19:57:33 -0700
Message-ID: <5cd9c56cf99091256b4387a6905cbeb5ea8378c6.1432003804.git.shli@fb.com>
References: <cover.1432003804.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1432003804.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

If cache support is enabled, don't allow resize/reshape in current
stage. In the future, we can flush all data from cache to raid before
resize/reshape and then allow resize/reshape.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 772b65f..53f582d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7173,6 +7173,10 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
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
@@ -7224,6 +7228,8 @@ static int check_reshape(struct mddev *mddev)
 {
 	struct r5conf *conf = mddev->private;
 
+	if (conf->cache)
+		return -EINVAL;
 	if (mddev->delta_disks == 0 &&
 	    mddev->new_layout == mddev->layout &&
 	    mddev->new_chunk_sectors == mddev->chunk_sectors)
-- 
1.8.1

