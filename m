From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 11/13] md: Don't let implementation detail of curr_resync
	leak out through sysfs.
Date: Wed, 12 Jan 2011 09:12:47 +1100
Message-ID: <20110111221247.12732.76833.stgit@notabene.brown>
References: <20110111221050.12732.31647.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111221050.12732.31647.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mddev->curr_resync has artificial values of '1' and '2' which are used
by the which ensures only one resync is happening at a time on any
given device.

These values are internal and should never be exposed to user-space
(except when translated appropriately as in the 'pending' status in
/proc/mdstat).

Unfortunately they are as ->curr_resync is assigned to
->curr_resync_completed and that value is directly visible through
sysfs.

So change the assignments to ->curr_resync_completed to get the same
valued from elsewhere in a form that doesn't have the magic '1' or '2'
values.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |    2 +-
 drivers/md/md.c     |    5 ++---
 drivers/md/raid5.c  |    4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 6cf5871..9a35320 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1546,7 +1546,7 @@ void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector)
 	wait_event(bitmap->mddev->recovery_wait,
 		   atomic_read(&bitmap->mddev->recovery_active) == 0);
 
-	bitmap->mddev->curr_resync_completed = bitmap->mddev->curr_resync;
+	bitmap->mddev->curr_resync_completed = sector;
 	set_bit(MD_CHANGE_CLEAN, &bitmap->mddev->flags);
 	sector &= ~((1ULL << CHUNK_BLOCK_SHIFT(bitmap)) - 1);
 	s = 0;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b98a85f..42b1d9e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6824,7 +6824,7 @@ void md_do_sync(mddev_t *mddev)
 		       desc, mdname(mddev));
 		mddev->curr_resync = j;
 	}
-	mddev->curr_resync_completed = mddev->curr_resync;
+	mddev->curr_resync_completed = j;
 
 	while (j < max_sectors) {
 		sector_t sectors;
@@ -6842,8 +6842,7 @@ void md_do_sync(mddev_t *mddev)
 			md_unplug(mddev);
 			wait_event(mddev->recovery_wait,
 				   atomic_read(&mddev->recovery_active) == 0);
-			mddev->curr_resync_completed =
-				mddev->curr_resync;
+			mddev->curr_resync_completed = j;
 			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
 			sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9212c07..d223a6c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4236,7 +4236,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		wait_event(conf->wait_for_overlap,
 			   atomic_read(&conf->reshape_stripes)==0);
 		mddev->reshape_position = conf->reshape_progress;
-		mddev->curr_resync_completed = mddev->curr_resync;
+		mddev->curr_resync_completed = sector_nr;
 		conf->reshape_checkpoint = jiffies;
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		md_wakeup_thread(mddev->thread);
@@ -4337,7 +4337,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		wait_event(conf->wait_for_overlap,
 			   atomic_read(&conf->reshape_stripes) == 0);
 		mddev->reshape_position = conf->reshape_progress;
-		mddev->curr_resync_completed = mddev->curr_resync + reshape_sectors;
+		mddev->curr_resync_completed = sector_nr;
 		conf->reshape_checkpoint = jiffies;
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		md_wakeup_thread(mddev->thread);


