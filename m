From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/22] md/raid5: don't complete make_request on barrier
	until writes are scheduled
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.6658.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The post-barrier-flush is sent be md as soon as make_request on the
barrier write completes.  For raid5, the data might not be in the
per-device queues yet.  So for barrier requests, wait for any
pre-reading to be done so that the request will be in the per-device
queues.

We use the 'preread_active' count to check that nothing is still in
the preread phase, and delay the decrement of this count until after
write requests have been submitted to the underlying devices.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   51 +++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ecf89c8..8c772b2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2947,6 +2947,7 @@ static void handle_stripe5(struct stripe_head *sh)
 	struct r5dev *dev;
 	mdk_rdev_t *blocked_rdev = NULL;
 	int prexor;
+	int dec_preread_active = 0;
 
 	memset(&s, 0, sizeof(s));
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d check:%d "
@@ -3096,12 +3097,8 @@ static void handle_stripe5(struct stripe_head *sh)
 					set_bit(STRIPE_INSYNC, &sh->state);
 			}
 		}
-		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-			atomic_dec(&conf->preread_active_stripes);
-			if (atomic_read(&conf->preread_active_stripes) <
-				IO_THRESHOLD)
-				md_wakeup_thread(conf->mddev->thread);
-		}
+		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+			dec_preread_active = 1;
 	}
 
 	/* Now to consider new write requests and what else, if anything
@@ -3208,6 +3205,16 @@ static void handle_stripe5(struct stripe_head *sh)
 
 	ops_run_io(sh, &s);
 
+	if (dec_preread_active) {
+		/* We delay this until after ops_run_io so that if make_request
+		 * is waiting on a barrier, it won't continue until the writes
+		 * have actually been submitted.
+		 */
+		atomic_dec(&conf->preread_active_stripes);
+		if (atomic_read(&conf->preread_active_stripes) <
+		    IO_THRESHOLD)
+			md_wakeup_thread(conf->mddev->thread);
+	}
 	return_io(return_bi);
 }
 
@@ -3221,6 +3228,7 @@ static void handle_stripe6(struct stripe_head *sh)
 	struct r6_state r6s;
 	struct r5dev *dev, *pdev, *qdev;
 	mdk_rdev_t *blocked_rdev = NULL;
+	int dec_preread_active = 0;
 
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
 		"pd_idx=%d, qd_idx=%d\n, check:%d, reconstruct:%d\n",
@@ -3380,12 +3388,8 @@ static void handle_stripe6(struct stripe_head *sh)
 					set_bit(STRIPE_INSYNC, &sh->state);
 			}
 		}
-		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-			atomic_dec(&conf->preread_active_stripes);
-			if (atomic_read(&conf->preread_active_stripes) <
-				IO_THRESHOLD)
-				md_wakeup_thread(conf->mddev->thread);
-		}
+		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+			dec_preread_active = 1;
 	}
 
 	/* Now to consider new write requests and what else, if anything
@@ -3494,6 +3498,18 @@ static void handle_stripe6(struct stripe_head *sh)
 
 	ops_run_io(sh, &s);
 
+
+	if (dec_preread_active) {
+		/* We delay this until after ops_run_io so that if make_request
+		 * is waiting on a barrier, it won't continue until the writes
+		 * have actually been submitted.
+		 */
+		atomic_dec(&conf->preread_active_stripes);
+		if (atomic_read(&conf->preread_active_stripes) <
+		    IO_THRESHOLD)
+			md_wakeup_thread(conf->mddev->thread);
+	}
+
 	return_io(return_bi);
 }
 
@@ -3996,6 +4012,9 @@ static int make_request(struct request_queue *q, struct bio * bi)
 			finish_wait(&conf->wait_for_overlap, &w);
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
+			if (mddev->barrier && 
+			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+				atomic_inc(&conf->preread_active_stripes);
 			release_stripe(sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
@@ -4015,6 +4034,14 @@ static int make_request(struct request_queue *q, struct bio * bi)
 
 		bio_endio(bi, 0);
 	}
+
+	if (mddev->barrier) {
+		/* We need to wait for the stripes to all be handled.
+		 * So: wait for preread_active_stripes to drop to 0.
+		 */
+		wait_event(mddev->thread->wqueue,
+			   atomic_read(&conf->preread_active_stripes) == 0);
+	}
 	return 0;
 }
 


