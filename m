From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 2/2] md: be cautious about using ->curr_resync_completed
 for ->recovery_offset
Date: Tue, 17 Oct 2017 16:18:36 +1100
Message-ID: <150821751632.9754.9103449859789225425.stgit@noble>
References: <150821741376.9754.10397416458024667409.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150821741376.9754.10397416458024667409.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The ->recovery_offset shows how much of a non-InSync device is actually
in sync - how much has been recoveryed.

When performing a recovery, ->curr_resync and ->curr_resync_completed
follow the device address being recovered and so can be used to update
->recovery_offset.

When performing a reshape, ->curr_resync* might follow the device
addresses (raid5) or might follow array addresses (raid10), so cannot
in general be used to set ->recovery_offset.  When reshaping backwards,
->curre_resync* measures from the *end* of the array-or-device, so is
particularly unhelpful.

So change the common code in md.c to only use ->curr_resync_complete
for the simple recovery case, and add code to raid5.c to update
->recovery_offset during a forwards reshape.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c    |   32 +++++++++++++++++++++-----------
 drivers/md/raid5.c |   18 ++++++++++++++++++
 2 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a9f1352b3849..d1dfc9879368 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2453,10 +2453,17 @@ void md_update_sb(struct mddev *mddev, int force_change)
 		}
 	}
 
-	/* First make sure individual recovery_offsets are correct */
+	/* First make sure individual recovery_offsets are correct
+	 * curr_resync_completed can only be used during recovery.
+	 * During reshape/resync it might use array-addresses rather
+	 * that device addresses.
+	 */
 	rdev_for_each(rdev, mddev) {
 		if (rdev->raid_disk >= 0 &&
 		    mddev->delta_disks >= 0 &&
+		    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
+		    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
+		    !test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 		    !test_bit(Journal, &rdev->flags) &&
 		    !test_bit(In_sync, &rdev->flags) &&
 		    mddev->curr_resync_completed > rdev->recovery_offset)
@@ -8507,16 +8514,19 @@ void md_do_sync(struct md_thread *thread)
 		} else {
 			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 				mddev->curr_resync = MaxSector;
-			rcu_read_lock();
-			rdev_for_each_rcu(rdev, mddev)
-				if (rdev->raid_disk >= 0 &&
-				    mddev->delta_disks >= 0 &&
-				    !test_bit(Journal, &rdev->flags) &&
-				    !test_bit(Faulty, &rdev->flags) &&
-				    !test_bit(In_sync, &rdev->flags) &&
-				    rdev->recovery_offset < mddev->curr_resync)
-					rdev->recovery_offset = mddev->curr_resync;
-			rcu_read_unlock();
+			if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
+			    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
+				rcu_read_lock();
+				rdev_for_each_rcu(rdev, mddev)
+					if (rdev->raid_disk >= 0 &&
+					    mddev->delta_disks >= 0 &&
+					    !test_bit(Journal, &rdev->flags) &&
+					    !test_bit(Faulty, &rdev->flags) &&
+					    !test_bit(In_sync, &rdev->flags) &&
+					    rdev->recovery_offset < mddev->curr_resync)
+						rdev->recovery_offset = mddev->curr_resync;
+				rcu_read_unlock();
+			}
 		}
 	}
  skip:
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a8df52130f8a..89ad79614309 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5739,6 +5739,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	 */
 	struct r5conf *conf = mddev->private;
 	struct stripe_head *sh;
+	struct md_rdev *rdev;
 	sector_t first_sector, last_sector;
 	int raid_disks = conf->previous_raid_disks;
 	int data_disks = raid_disks - conf->max_degraded;
@@ -5861,6 +5862,15 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 			return 0;
 		mddev->reshape_position = conf->reshape_progress;
 		mddev->curr_resync_completed = sector_nr;
+		if (!mddev->reshape_backwards)
+			/* Can update recovery_offset */
+			rdev_for_each(rdev, mddev)
+				if (rdev->raid_disk >= 0 &&
+				    !test_bit(Journal, &rdev->flags) &&
+				    !test_bit(In_sync, &rdev->flags) &&
+				    rdev->recovery_offset < sector_nr)
+					rdev->recovery_offset = sector_nr;
+
 		conf->reshape_checkpoint = jiffies;
 		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		md_wakeup_thread(mddev->thread);
@@ -5959,6 +5969,14 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 			goto ret;
 		mddev->reshape_position = conf->reshape_progress;
 		mddev->curr_resync_completed = sector_nr;
+		if (!mddev->reshape_backwards)
+			/* Can update recovery_offset */
+			rdev_for_each(rdev, mddev)
+				if (rdev->raid_disk >= 0 &&
+				    !test_bit(Journal, &rdev->flags) &&
+				    !test_bit(In_sync, &rdev->flags) &&
+				    rdev->recovery_offset < sector_nr)
+					rdev->recovery_offset = sector_nr;
 		conf->reshape_checkpoint = jiffies;
 		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		md_wakeup_thread(mddev->thread);


