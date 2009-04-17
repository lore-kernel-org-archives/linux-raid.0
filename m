From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 4/4] md: update sync_completed and reshape_position even
	more often.
Date: Fri, 17 Apr 2009 12:14:54 +1000
Message-ID: <20090417021454.13390.2513.stgit@notabene.brown>
References: <20090417020953.13390.5371.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090417020953.13390.5371.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

There are circumstances when a user-space process might need to
"oversee" a resync/reshape process.  For example when doing an
in-place reshape of a raid5, it is prudent to take a backup of each
section before reshaping it as this is the only way to provide
safety against an unplanned shutdown (i.e. crash/power failure).

The sync_max sysfs value can be used to stop the resync from
advancing beyond a particular point.
So user-space can:
  suspend IO to the first section and back it up
  set 'sync_max' to the end of the section
  wait for 'sync_completed' to reach that point
  resume IO on the first section and move on to the next section.

However this process requires the kernel and user-space to run in
lock-step which could introduce unnecessary delays.

It would be better if a 'double buffered' approach could be used with
userspace and kernel space working on different sections with the
'next' section always ready when the 'current' section is finished.

One problem with implementing this is that sync_completed is only
guaranteed to be updated when the sync process reaches sync_max.
(it is updated on a time basis at other times, but it is hard to rely
on that).  This defeats some of the double buffering.

With this patch, sync_completed (and reshape_position) get updated as
the current position approaches sync_max, so there is room for
userspace to advance sync_max early without losing updates.

To be precise, sync_completed is updated when the current sync
position reaches half way between the current value of sync_completed
and the value of sync_max.  This will usually be a good time for user
space to update sync_max.

If sync_max does not get updated, the updates to sync_completed
(together with associated metadata updates) will occur at an
exponentially increasing frequency which will get unreasonably fast
(one update every page) immediately before the process hits sync_max
and stops.  So the update rate will be unreasonably fast only for an
insignificant period of time.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c    |    3 ++-
 drivers/md/raid5.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7af64f3..612343f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6347,7 +6347,8 @@ void md_do_sync(mddev_t *mddev)
 		if ((mddev->curr_resync > mddev->curr_resync_completed &&
 		     (mddev->curr_resync - mddev->curr_resync_completed)
 		    > (max_sectors >> 4)) ||
-		    j >= mddev->resync_max
+		    (j - mddev->curr_resync_completed)*2
+		    >= mddev->resync_max - mddev->curr_resync_completed
 			) {
 			/* time to update curr_resync_completed */
 			blk_unplug(mddev->queue);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 76892ac..4616bc3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3940,7 +3940,8 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	 * then we need to write out the superblock.
 	 */
 	sector_nr += reshape_sectors;
-	if (sector_nr >= mddev->resync_max) {
+	if ((sector_nr - mddev->curr_resync_completed) * 2
+	    >= mddev->resync_max - mddev->curr_resync_completed) {
 		/* Cannot proceed until we've updated the superblock... */
 		wait_event(conf->wait_for_overlap,
 			   atomic_read(&conf->reshape_stripes) == 0);


