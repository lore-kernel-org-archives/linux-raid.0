From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 25/28] md: factor out init code for an mddev
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.82770.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a simple factorisation that makes mddev_find easier to read.


Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   39 ++++++++++++++++++++++-----------------
 1 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 967df62..59bf6aa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -416,6 +416,27 @@ static void mddev_put(mddev_t *mddev)
 	spin_unlock(&all_mddevs_lock);
 }
 
+static void mddev_init(mddev_t *mddev)
+{
+	mutex_init(&mddev->open_mutex);
+	mutex_init(&mddev->reconfig_mutex);
+	mutex_init(&mddev->bitmap_info.mutex);
+	INIT_LIST_HEAD(&mddev->disks);
+	INIT_LIST_HEAD(&mddev->all_mddevs);
+	init_timer(&mddev->safemode_timer);
+	atomic_set(&mddev->active, 1);
+	atomic_set(&mddev->openers, 0);
+	atomic_set(&mddev->active_io, 0);
+	spin_lock_init(&mddev->write_lock);
+	atomic_set(&mddev->flush_pending, 0);
+	init_waitqueue_head(&mddev->sb_wait);
+	init_waitqueue_head(&mddev->recovery_wait);
+	mddev->reshape_position = MaxSector;
+	mddev->resync_min = 0;
+	mddev->resync_max = MaxSector;
+	mddev->level = LEVEL_NONE;
+}
+
 static mddev_t * mddev_find(dev_t unit)
 {
 	mddev_t *mddev, *new = NULL;
@@ -482,23 +503,7 @@ static mddev_t * mddev_find(dev_t unit)
 	else
 		new->md_minor = MINOR(unit) >> MdpMinorShift;
 
-	mutex_init(&new->open_mutex);
-	mutex_init(&new->reconfig_mutex);
-	mutex_init(&new->bitmap_info.mutex);
-	INIT_LIST_HEAD(&new->disks);
-	INIT_LIST_HEAD(&new->all_mddevs);
-	init_timer(&new->safemode_timer);
-	atomic_set(&new->active, 1);
-	atomic_set(&new->openers, 0);
-	atomic_set(&new->active_io, 0);
-	spin_lock_init(&new->write_lock);
-	atomic_set(&new->flush_pending, 0);
-	init_waitqueue_head(&new->sb_wait);
-	init_waitqueue_head(&new->recovery_wait);
-	new->reshape_position = MaxSector;
-	new->resync_min = 0;
-	new->resync_max = MaxSector;
-	new->level = LEVEL_NONE;
+	mddev_init(new);
 
 	goto retry;
 }


