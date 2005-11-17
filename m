From: NeilBrown <neilb@suse.de>
Subject: [PATCH md ] Fix is_mddev_idle calculation now that disk/sector accounting happens when request completes.
Date: Thu, 17 Nov 2005 14:30:53 +1100
Message-ID: <1051117033053.7957@suse.de>
References: <20051117142856.7892.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, Jens Axboe <axboe@suse.de>
List-Id: linux-raid.ids

This patch against 2.6.14-mm2 (and 2.6.15-rc1) is needed to compensate
for recent changes which stop resync from proceeding at full speed on
an idle array.  It is suitable for 2.6.15-rc2.

NeilBrown


### Comments for Changeset

md needs to monitor the rate of requests to it's devices when doing
resync/recovery so that it can back-off when there is non-resync IO.
It does this by comparing resync IO, which it counts, with total IO
which is taken from disk_stats.

disk_stats were recently changed to account sectors when a request
completes instead of when it is queued.  This upsets md's calculations. 

We could do the sync_io accounting at the end of requests too, but
that has problems.  If an underlying device is an md array, the
accounting will still be done when the request is submitted.  This
could be changed for some raid levels, but it cannot be changed for
raid0 or linear without substantial code changes.

So instead, we increase the error that is_mddev_idle allows, up to the
maximum amount of resync IO that can be in flight at any time.  The
calculation is current fragile as each personality as different limits
for in-flight resync.  This should be fixed up.

For now, this simple patch fixes the problem.

Increasing the error margin decreases the sensitivity to non-resync
IO.  To partially compensate for this, the time to wait when
non-resync IO is detected is increased so that less steady IO is
required to keep the resync at bay.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-17 14:11:09.000000000 +1100
+++ ./drivers/md/md.c	2005-11-17 14:21:27.000000000 +1100
@@ -3837,11 +3837,20 @@ static int is_mddev_idle(mddev_t *mddev)
 		curr_events = disk_stat_read(disk, sectors[0]) + 
 				disk_stat_read(disk, sectors[1]) - 
 				atomic_read(&disk->sync_io);
-		/* Allow some slack between valud of curr_events and last_events,
-		 * as there are some uninteresting races.
+		/* The difference between curr_events and last_events
+		 * will be affected by any new non-sync IO (making
+		 * curr_events bigger) and any difference in the amount of
+		 * in-flight syncio (making current_events bigger or smaller)
+		 * The amount in-flight is currently limited to
+		 * 32*64K in raid1/10 and 256*PAGE_SIZE in raid5/6
+		 * which is at most 4096 sectors.
+		 * These numbers are fairly fragile and should be made
+		 * more robust, probably by enforcing the
+		 * 'window size' that md_do_sync sort-of uses.
+		 *
 		 * Note: the following is an unsigned comparison.
 		 */
-		if ((curr_events - rdev->last_events + 32) > 64) {
+		if ((curr_events - rdev->last_events + 4096) > 8192) {
 			rdev->last_events = curr_events;
 			idle = 0;
 		}
@@ -4100,7 +4109,7 @@ static void md_do_sync(mddev_t *mddev)
 		if (currspeed > sysctl_speed_limit_min) {
 			if ((currspeed > sysctl_speed_limit_max) ||
 					!is_mddev_idle(mddev)) {
-				msleep(250);
+				msleep(500);
 				goto repeat;
 			}
 		}
