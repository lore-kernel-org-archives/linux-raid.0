From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 06/28] md:Add support for Raid0->Raid5 takeover
Date: Thu, 15 Apr 2010 16:21:07 +1000
Message-ID: <20100415062107.5126.96062.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Maciej Trela <maciej.trela@intel.com>
List-Id: linux-raid.ids

From: Trela Maciej <Maciej.Trela@intel.com>

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c    |   13 +++++++++++++
 drivers/md/raid5.c |   26 ++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 509a5e4..ccfbd4a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2973,6 +2973,19 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	/* Looks like we have a winner */
 	mddev_suspend(mddev);
 	mddev->pers->stop(mddev);
+	if (mddev->pers->sync_request == NULL &&
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
 	module_put(mddev->pers->owner);
 	/* Invalidate devices that are now superfluous */
 	list_for_each_entry(rdev, &mddev->disks, same_set)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 04139d9..c54ddbc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -52,6 +52,7 @@
 #include <linux/cpu.h>
 #include "md.h"
 #include "raid5.h"
+#include "raid0.h"
 #include "bitmap.h"
 
 /*
@@ -5616,6 +5617,21 @@ static void raid5_quiesce(mddev_t *mddev, int state)
 }
 
 
+static void *raid5_takeover_raid0(mddev_t *mddev)
+{
+
+	mddev->new_level = 5;
+	mddev->new_layout = ALGORITHM_PARITY_N;
+	mddev->new_chunk_sectors = mddev->chunk_sectors;
+	mddev->raid_disks += 1;
+	mddev->delta_disks = 1;
+	/* make sure it will be not marked as dirty */
+	mddev->recovery_cp = MaxSector;
+
+	return setup_conf(mddev);
+}
+
+
 static void *raid5_takeover_raid1(mddev_t *mddev)
 {
 	int chunksect;
@@ -5745,6 +5761,16 @@ static void *raid5_takeover(mddev_t *mddev)
 	 *  raid4 - trivial - just use a raid4 layout.
 	 *  raid6 - Providing it is a *_6 layout
 	 */
+	if (mddev->level == 0) {
+		/* for raid0 takeover only one zone is supported */
+		struct raid0_private_data *raid0_priv
+			= mddev->private;
+		if (raid0_priv->nr_strip_zones > 1) {
+			printk(KERN_ERR "md: cannot takeover raid 0 with more than one zone.\n");
+			return ERR_PTR(-EINVAL);
+		}
+		return raid5_takeover_raid0(mddev);
+	}
 
 	if (mddev->level == 1)
 		return raid5_takeover_raid1(mddev);


