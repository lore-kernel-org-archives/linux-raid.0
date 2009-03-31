From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 14/14] md/raid5 revise rules for when to update metadata
	during reshape
Date: Tue, 31 Mar 2009 15:54:44 +1100
Message-ID: <20090331045444.2589.83153.stgit@notabene.brown>
References: <20090331044827.2589.95894.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090331044827.2589.95894.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

We currently update the metadata :
 1/ every 3Megabytes
 2/ When the place we will write new-layout data to is recorded in
    the metadata as still containing old-layout data.

Rule one exists to avoid having to re-do too much reshaping in the
face of a crash/restart.  So it should really be time based rather
than size based.  So change it to "every 10 seconds".

Rule two turns out to be too harsh when restriping an array
'in-place', as in that case the metadata much be updates for every
stripe.
For the in-place update, it can only possibly be safe from a crash if
some user-space program data a backup of every e.g. few hundred
stripes before allowing them to be reshaped.  In that case, the
constant metadata update is pointless.
So only update the metadata if the new metadata will report that the
end of the 'old-layout' data is beyond where we are currently
writing 'new-layout' data.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   34 ++++++++++++++++++++++++++++------
 drivers/md/raid5.h |    2 ++
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bb4b12e..3bbc6d6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3766,7 +3766,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	int new_data_disks = conf->raid_disks - conf->max_degraded;
 	int i;
 	int dd_idx;
-	sector_t writepos, safepos, gap;
+	sector_t writepos, readpos, safepos;
 	sector_t stripe_addr;
 	int reshape_sectors;
 	struct list_head stripes;
@@ -3806,26 +3806,46 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	 */
 	writepos = conf->reshape_progress;
 	sector_div(writepos, new_data_disks);
+	readpos = conf->reshape_progress;
+	sector_div(readpos, data_disks);
 	safepos = conf->reshape_safe;
 	sector_div(safepos, data_disks);
 	if (mddev->delta_disks < 0) {
 		writepos -= reshape_sectors;
+		readpos += reshape_sectors;
 		safepos += reshape_sectors;
-		gap = conf->reshape_safe - conf->reshape_progress;
 	} else {
 		writepos += reshape_sectors;
+		readpos -= reshape_sectors;
 		safepos -= reshape_sectors;
-		gap = conf->reshape_progress - conf->reshape_safe;
 	}
 
+	/* 'writepos' is the most advanced device address we might write.
+	 * 'readpos' is the least advanced device address we might read.
+	 * 'safepos' is the least address recorded in the metadata as having
+	 *     been reshaped.
+	 * If 'readpos' is behind 'writepos', then there is no way that we can
+	 * ensure safety in the face of a crash - that must be done by userspace
+	 * making a backup of the data.  So in that case there is no particular
+	 * rush to update metadata.
+	 * Otherwise if 'safepos' is behind 'writepos', then we really need to
+	 * update the metadata to advance 'safepos' to match 'readpos' so that
+	 * we can be safe in the event of a crash.
+	 * So we insist on updating metadata if safepos is behind writepos and
+	 * readpos is beyond writepos.
+	 * In any case, update the metadata every 10 seconds.
+	 * Maybe that number should be configurable, but I'm not sure it is
+	 * worth it.... maybe it could be a multiple of safemode_delay???
+	 */
 	if ((mddev->delta_disks < 0
-	     ? writepos < safepos
-	     : writepos > safepos) ||
-	    gap > (new_data_disks)*3000*2 /*3Meg*/) {
+	     ? (safepos > writepos && readpos < writepos)
+	     : (safepos < writepos && readpos > writepos)) ||
+	    time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
 		/* Cannot proceed until we've updated the superblock... */
 		wait_event(conf->wait_for_overlap,
 			   atomic_read(&conf->reshape_stripes)==0);
 		mddev->reshape_position = conf->reshape_progress;
+		conf->reshape_checkpoint = jiffies;
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		md_wakeup_thread(mddev->thread);
 		wait_event(mddev->sb_wait, mddev->flags == 0 ||
@@ -3923,6 +3943,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		wait_event(conf->wait_for_overlap,
 			   atomic_read(&conf->reshape_stripes) == 0);
 		mddev->reshape_position = conf->reshape_progress;
+		conf->reshape_checkpoint = jiffies;
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		md_wakeup_thread(mddev->thread);
 		wait_event(mddev->sb_wait,
@@ -4957,6 +4978,7 @@ static int raid5_start_reshape(mddev_t *mddev)
 		spin_unlock_irq(&conf->device_lock);
 		return -EAGAIN;
 	}
+	conf->reshape_checkpoint = jiffies;
 	md_wakeup_thread(mddev->sync_thread);
 	md_new_event(mddev);
 	return 0;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index cdd0456..52ba999 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -352,6 +352,8 @@ struct raid5_private_data {
 	int			previous_raid_disks;
 	int			prev_chunk, prev_algo;
 	short			generation; /* increments with every reshape */
+	unsigned long		reshape_checkpoint; /* Time we last updated
+						     * metadata */
 
 	struct list_head	handle_list; /* stripes needing handling */
 	struct list_head	hold_list; /* preread ready stripes */


