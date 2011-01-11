From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 06/13] md: md_stop_writes requires mddev_lock.
Date: Wed, 12 Jan 2011 09:12:46 +1100
Message-ID: <20110111221246.12732.27399.stgit@notabene.brown>
References: <20110111221050.12732.31647.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111221050.12732.31647.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As md_stop_writes manipulates the sync_thread and calls md_update_sb,
it need to be called with mddev_lock held.

In all internal cases it is, but the symbol is exported for dm-raid to
call and in that case the lock won't be help.
Do make an exported version which takes the lock, and an internal
version which does not.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 540347c..f43ff29 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4704,7 +4704,7 @@ static void md_clean(mddev_t *mddev)
 	mddev->plug = NULL;
 }
 
-void md_stop_writes(mddev_t *mddev)
+static void __md_stop_writes(mddev_t *mddev)
 {
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
@@ -4724,6 +4724,13 @@ void md_stop_writes(mddev_t *mddev)
 		md_update_sb(mddev, 1);
 	}
 }
+
+void md_stop_writes(mddev_t *mddev)
+{
+	mddev_lock(mddev);
+	__md_stop_writes(mddev);
+	mddev_unlock(mddev);
+}
 EXPORT_SYMBOL_GPL(md_stop_writes);
 
 void md_stop(mddev_t *mddev)
@@ -4748,7 +4755,7 @@ static int md_set_readonly(mddev_t *mddev, int is_open)
 		goto out;
 	}
 	if (mddev->pers) {
-		md_stop_writes(mddev);
+		__md_stop_writes(mddev);
 
 		err  = -ENXIO;
 		if (mddev->ro==1)
@@ -4785,7 +4792,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		if (mddev->ro)
 			set_disk_ro(disk, 0);
 
-		md_stop_writes(mddev);
+		__md_stop_writes(mddev);
 		md_stop(mddev);
 		mddev->queue->merge_bvec_fn = NULL;
 		mddev->queue->unplug_fn = NULL;


