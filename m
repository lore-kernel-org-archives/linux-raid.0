From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 3/6] md: Export and rename find_rdev_nr_rcu
Date: Tue, 14 Apr 2015 10:43:55 -0500
Message-ID: <20150414154355.GA4093@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: GQJiang@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is required by the clustering module (patches to follow) to
find the device to remove or re-add.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c | 9 +++++----
 drivers/md/md.h | 1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2949c4a..9d253c2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -646,7 +646,7 @@ void mddev_unlock(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(mddev_unlock);
 
-static struct md_rdev *find_rdev_nr_rcu(struct mddev *mddev, int nr)
+struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr)
 {
 	struct md_rdev *rdev;
 
@@ -656,6 +656,7 @@ static struct md_rdev *find_rdev_nr_rcu(struct mddev *mddev, int nr)
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(md_find_rdev_nr_rcu);
 
 static struct md_rdev *find_rdev(struct mddev *mddev, dev_t dev)
 {
@@ -2053,11 +2054,11 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 		int choice = 0;
 		if (mddev->pers)
 			choice = mddev->raid_disks;
-		while (find_rdev_nr_rcu(mddev, choice))
+		while (md_find_rdev_nr_rcu(mddev, choice))
 			choice++;
 		rdev->desc_nr = choice;
 	} else {
-		if (find_rdev_nr_rcu(mddev, rdev->desc_nr)) {
+		if (md_find_rdev_nr_rcu(mddev, rdev->desc_nr)) {
 			rcu_read_unlock();
 			return -EBUSY;
 		}
@@ -5728,7 +5729,7 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 		return -EFAULT;
 
 	rcu_read_lock();
-	rdev = find_rdev_nr_rcu(mddev, info.number);
+	rdev = md_find_rdev_nr_rcu(mddev, info.number);
 	if (rdev) {
 		info.major = MAJOR(rdev->bdev->bd_dev);
 		info.minor = MINOR(rdev->bdev->bd_dev);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d98c0d7..ecdce36 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -672,6 +672,7 @@ extern void md_unplug(struct blk_plug_cb *cb, bool from_schedule);
 extern void md_reload_sb(struct mddev *mddev);
 extern void md_update_sb(struct mddev *mddev, int force);
 extern void md_kick_rdev_from_array(struct md_rdev * rdev);
+struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
 static inline int mddev_check_plugged(struct mddev *mddev)
 {
 	return !!blk_check_plugged(md_unplug, mddev,
-- 
2.1.4

