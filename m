From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 20/36] md/raid5. Don't write to known bad block on doubtful
 devices.
Date: Thu, 21 Jul 2011 12:58:49 +1000
Message-ID: <20110721025849.8422.68502.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If a device has seen write errors, don't write to any known
bad blocks on that device.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 54e89d1..33ae4e2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -526,6 +526,36 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			atomic_inc(&rdev->nr_pending);
 		rcu_read_unlock();
 
+		/* We have already checked bad blocks for reads.  Now
+		 * need to check for writes.
+		 */
+		while ((rw & WRITE) && rdev &&
+		       test_bit(WriteErrorSeen, &rdev->flags)) {
+			sector_t first_bad;
+			int bad_sectors;
+			int bad = is_badblock(rdev, sh->sector, STRIPE_SECTORS,
+					      &first_bad, &bad_sectors);
+			if (!bad)
+				break;
+
+			if (bad < 0) {
+				set_bit(BlockedBadBlocks, &rdev->flags);
+				if (!conf->mddev->external &&
+				    conf->mddev->flags) {
+					/* It is very unlikely, but we might
+					 * still need to write out the
+					 * bad block log - better give it
+					 * a chance*/
+					md_check_recovery(conf->mddev);
+				}
+				md_wait_for_blocked_rdev(rdev, conf->mddev);
+			} else {
+				/* Acknowledged bad block - skip the write */
+				rdev_dec_pending(rdev, conf->mddev);
+				rdev = NULL;
+			}
+		}
+
 		if (rdev) {
 			if (s->syncing || s->expanding || s->expanded)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
@@ -3317,7 +3347,6 @@ finish:
 
 	ops_run_io(sh, &s);
 
-
 	if (s.dec_preread_active) {
 		/* We delay this until after ops_run_io so that if make_request
 		 * is waiting on a flush, it won't continue until the writes


