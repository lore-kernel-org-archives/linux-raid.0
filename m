From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 12/26] md: level_store: group all important changes into
 one place.
Date: Wed, 04 Feb 2015 08:42:29 +1100
Message-ID: <20150203214229.3448.51698.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gather all the changes that can happen atomically and might
be relevant to other code into one place.  This will
make it easier to refine the locking.

Note that this puts quite a few things between mddev_detach()
and ->free().  Enabling this was the point of some recent patches.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   62 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2920fd004865..58f531f8dcc2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3280,9 +3280,9 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	char clevel[16];
 	ssize_t rv = len;
-	struct md_personality *pers;
+	struct md_personality *pers, *oldpers;
 	long level;
-	void *priv;
+	void *priv, *oldpriv;
 	struct md_rdev *rdev;
 
 	if (mddev->pers == NULL) {
@@ -3374,9 +3374,35 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	/* Looks like we have a winner */
 	mddev_suspend(mddev);
 	mddev_detach(mddev);
-	mddev->pers->free(mddev, mddev->private);
+	oldpers = mddev->pers;
+	oldpriv = mddev->private;
+	mddev->pers = pers;
+	mddev->private = priv;
+	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
+	mddev->level = mddev->new_level;
+	mddev->layout = mddev->new_layout;
+	mddev->chunk_sectors = mddev->new_chunk_sectors;
+	mddev->delta_disks = 0;
+	mddev->reshape_backwards = 0;
+	mddev->degraded = 0;
+
+	if (oldpers->sync_request == NULL &&
+	    mddev->external) {
+		/* We are converting from a no-redundancy array
+		 * to a redundancy array and metadata is managed
+		 * externally so we need to be sure that writes
+		 * won't block due to a need to transition
+		 *      clean->dirty
+		 * until external management is started.
+		 */
+		mddev->in_sync = 0;
+		mddev->safemode_delay = 0;
+		mddev->safemode = 0;
+	}
 
-	if (mddev->pers->sync_request == NULL &&
+	oldpers->free(mddev, oldpriv);
+
+	if (oldpers->sync_request == NULL &&
 	    pers->sync_request != NULL) {
 		/* need to add the md_redundancy_group */
 		if (sysfs_create_group(&mddev->kobj, &md_redundancy_group))
@@ -3385,27 +3411,13 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 			       mdname(mddev));
 		mddev->sysfs_action = sysfs_get_dirent(mddev->kobj.sd, "sync_action");
 	}
-	if (mddev->pers->sync_request != NULL &&
+	if (oldpers->sync_request != NULL &&
 	    pers->sync_request == NULL) {
 		/* need to remove the md_redundancy_group */
 		if (mddev->to_remove == NULL)
 			mddev->to_remove = &md_redundancy_group;
 	}
 
-	if (mddev->pers->sync_request == NULL &&
-	    mddev->external) {
-		/* We are converting from a no-redundancy array
-		 * to a redundancy array and metadata is managed
-		 * externally so we need to be sure that writes
-		 * won't block due to a need to transition
-		 *      clean->dirty
-		 * until external management is started.
-		 */
-		mddev->in_sync = 0;
-		mddev->safemode_delay = 0;
-		mddev->safemode = 0;
-	}
-
 	rdev_for_each(rdev, mddev) {
 		if (rdev->raid_disk < 0)
 			continue;
@@ -3431,17 +3443,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		}
 	}
 
-	module_put(mddev->pers->owner);
-	mddev->pers = pers;
-	mddev->private = priv;
-	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
-	mddev->level = mddev->new_level;
-	mddev->layout = mddev->new_layout;
-	mddev->chunk_sectors = mddev->new_chunk_sectors;
-	mddev->delta_disks = 0;
-	mddev->reshape_backwards = 0;
-	mddev->degraded = 0;
-	if (mddev->pers->sync_request == NULL) {
+	if (pers->sync_request == NULL) {
 		/* this is now an array without redundancy, so
 		 * it must always be in_sync
 		 */


