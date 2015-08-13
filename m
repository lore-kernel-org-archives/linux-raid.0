From: Shaohua Li <shli@fb.com>
Subject: [patch v2 10/11] raid5: don't allow resize/reshape with cache(log) support
Date: Thu, 13 Aug 2015 14:32:03 -0700
Message-ID: <d00e6ec07f5ebe525aada3b66469e51bbcf1f73f.1439500639.git.shli@fb.com>
References: <cover.1439500639.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1439500639.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

If cache(log) support is enabled, don't allow resize/reshape in current
stage. In the future, we can flush all data from cache(log) to raid
before resize/reshape and then allow resize/reshape.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 80a9a78..343536d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6655,6 +6655,7 @@ static int run(struct mddev *mddev)
 	int working_disks = 0;
 	int dirty_parity_disks = 0;
 	struct md_rdev *rdev;
+	struct md_rdev *journal_dev = NULL;
 	sector_t reshape_offset = 0;
 	int i;
 	long long min_offset_diff = 0;
@@ -6667,6 +6668,9 @@ static int run(struct mddev *mddev)
 
 	rdev_for_each(rdev, mddev) {
 		long long diff;
+
+		if (test_bit(Journal, &rdev->flags))
+			journal_dev = rdev;
 		if (rdev->raid_disk < 0)
 			continue;
 		diff = (rdev->new_data_offset - rdev->data_offset);
@@ -6698,6 +6702,13 @@ static int run(struct mddev *mddev)
 		int old_disks;
 		int max_degraded = (mddev->level == 6 ? 2 : 1);
 
+		if (journal_dev) {
+			printk(KERN_ERR "md/raid:%s: don't support reshape "
+			       "with journal - aborting.\n",
+			       mdname(mddev));
+			return -EINVAL;
+		}
+
 		if (mddev->new_level != mddev->level) {
 			printk(KERN_ERR "md/raid:%s: unsupported reshape "
 			       "required - aborting.\n",
@@ -7209,6 +7220,10 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	 * worth it.
 	 */
 	sector_t newsize;
+	struct r5conf *conf = mddev->private;
+
+	if (conf->log)
+		return -EINVAL;
 	sectors &= ~((sector_t)mddev->chunk_sectors - 1);
 	newsize = raid5_size(mddev, sectors, mddev->raid_disks);
 	if (mddev->external_size &&
@@ -7260,6 +7275,8 @@ static int check_reshape(struct mddev *mddev)
 {
 	struct r5conf *conf = mddev->private;
 
+	if (conf->log)
+		return -EINVAL;
 	if (mddev->delta_disks == 0 &&
 	    mddev->new_layout == mddev->layout &&
 	    mddev->new_chunk_sectors == mddev->chunk_sectors)
-- 
1.8.1

