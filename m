From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 7/8] md: allow raid5_quiesce to work properly when reshape
	is happening.
Date: Mon, 03 Aug 2009 07:58:18 +1000
Message-ID: <20090802215818.4198.7589.stgit@notabene.brown>
References: <20090802215444.4198.83094.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090802215444.4198.83094.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

The ->quiesce method is not supposed to stop resync/recovery/reshape,
just normal IO.
But in raid5 we don't have a way to know which stripes are being
used for normal IO and which for resync etc, so we need to wait for
all stripes to be idle to be sure that all writes have completed.

However reshape keeps at least some stripe busy for an extended period
of time, so a call to raid5_quiesce can block for several seconds
needlessly.
So arrange for reshape etc to pause briefly while raid5_quiesce is
trying to quiesce the array so that the active_stripes count can
drop to zero.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 659151e..2dc35b4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3999,6 +3999,9 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 		return 0;
 	}
 
+	/* Allow raid5_quiesce to complete */
+	wait_event(conf->wait_for_overlap, conf->quiesce != 2);
+
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return reshape_request(mddev, sector_nr, skipped);
 
@@ -5104,12 +5107,18 @@ static void raid5_quiesce(mddev_t *mddev, int state)
 
 	case 1: /* stop all writes */
 		spin_lock_irq(&conf->device_lock);
-		conf->quiesce = 1;
+		/* '2' tells resync/reshape to pause so that all
+		 * active stripes can drain
+		 */
+		conf->quiesce = 2;
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    atomic_read(&conf->active_stripes) == 0 &&
 				    atomic_read(&conf->active_aligned_reads) == 0,
 				    conf->device_lock, /* nothing */);
+		conf->quiesce = 1;
 		spin_unlock_irq(&conf->device_lock);
+		/* allow reshape to continue */
+		wake_up(&conf->wait_for_overlap);
 		break;
 
 	case 0: /* re-enable writes */


