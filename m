From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 2] md: Improve the is_mddev_idle test
Date: Thu, 10 May 2007 16:22:31 +1000
Message-ID: <1070510062231.20403@suse.de>
References: <20070510161940.20204.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


During a 'resync' or similar activity, md checks if the devices in the
array are otherwise active and winds back resync activity when they
are.  This test in done in is_mddev_idle, and it is somewhat fragile -
it sometimes thinks there is non-sync io when there isn't.

The test compares the total sectors of io (disk_stat_read) with the sectors
of resync io (disk->sync_io).
This has problems because total sectors gets updated when a request completes,
while resync io gets updated when the request is submitted.  The time difference
can cause large differenced between the two which do not actually imply 
non-resync activity.  The test currently allows for some fuzz (+/- 4096)
but there are some cases when it is not enough.

The test currently looks for any (non-fuzz) difference, either
positive or negative.  This clearly is not needed.  Any non-sync
activity will cause the total sectors to grow faster than the sync_io
count (never slower) so we only need to look for a positive differences.

If we do this then the amount of in-flight sync io will never cause
the appearance of non-sync IO.  Once enough non-sync IO to worry about
starts happening, resync will be slowed down and the measurements will
thus be more precise (as there is less in-flight) and control of resync
will still be suitably responsive.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-05-10 15:51:54.000000000 +1000
+++ ./drivers/md/md.c	2007-05-10 16:05:10.000000000 +1000
@@ -5095,7 +5095,7 @@ static int is_mddev_idle(mddev_t *mddev)
 		 *
 		 * Note: the following is an unsigned comparison.
 		 */
-		if ((curr_events - rdev->last_events + 4096) > 8192) {
+		if ((long)curr_events - (long)rdev->last_events > 4096) {
 			rdev->last_events = curr_events;
 			idle = 0;
 		}
