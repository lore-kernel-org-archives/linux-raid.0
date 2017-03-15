From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 02/15] md/raid5: simplfy delaying of writes while
 metadata is updated.
Date: Wed, 15 Mar 2017 14:05:12 +1100
Message-ID: <148954711228.18641.2048575896322496918.stgit@noble>
References: <148954692173.18641.1294690639716682540.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148954692173.18641.1294690639716682540.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

If a device fails during a write, we must ensure the failure is
recorded in the metadata before the completion of the write is
acknowleged.

Commit c3cce6cda162 ("md/raid5: ensure device failure recorded before
write request returns.")  added code for this, but it was
unnecessarily complicated.  We already had similar functionality for
handling updates to the bad-block-list, thanks to Commit de393cdea66c
("md: make it easier to wait for bad blocks to be acknowledged.")

So revert most of the former commit, and instead avoid collecting
completed writes if MD_CHANGE_PENDING is set.  raid5d() will then flush
the metadata and retry the stripe_head.
As this change can leave a stripe_head ready for handling immediately
after handle_active_stripes() returns, we change raid5_do_work() to
pause when MD_CHANGE_PENDING is set, so that it doesn't spin.

We check MD_CHANGE_PENDING *after* analyse_stripe() as it could be set
asynchronously.  After analyse_stripe(), we have collected stable data
about the state of devices, which will be used to make decisions.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid5.c |   31 ++++++++-----------------------
 drivers/md/raid5.h |    3 ---
 2 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cc2d039b4aae..f990f74901d2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4690,7 +4690,8 @@ static void handle_stripe(struct stripe_head *sh)
 	if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
 		goto finish;
 
-	if (s.handle_bad_blocks) {
+	if (s.handle_bad_blocks ||
+	    test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
 		set_bit(STRIPE_HANDLE, &sh->state);
 		goto finish;
 	}
@@ -5020,15 +5021,8 @@ static void handle_stripe(struct stripe_head *sh)
 			md_wakeup_thread(conf->mddev->thread);
 	}
 
-	if (!bio_list_empty(&s.return_bi)) {
-		if (test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
-			spin_lock_irq(&conf->device_lock);
-			bio_list_merge(&conf->return_bi, &s.return_bi);
-			spin_unlock_irq(&conf->device_lock);
-			md_wakeup_thread(conf->mddev->thread);
-		} else
-			return_io(&s.return_bi);
-	}
+	if (!bio_list_empty(&s.return_bi))
+		return_io(&s.return_bi);
 
 	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
 }
@@ -6225,6 +6219,7 @@ static void raid5_do_work(struct work_struct *work)
 	struct r5worker *worker = container_of(work, struct r5worker, work);
 	struct r5worker_group *group = worker->group;
 	struct r5conf *conf = group->conf;
+	struct mddev *mddev = conf->mddev;
 	int group_id = group - conf->worker_groups;
 	int handled;
 	struct blk_plug plug;
@@ -6245,6 +6240,9 @@ static void raid5_do_work(struct work_struct *work)
 		if (!batch_size && !released)
 			break;
 		handled += batch_size;
+		wait_event_lock_irq(mddev->sb_wait,
+				    !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags),
+				    conf->device_lock);
 	}
 	pr_debug("%d stripes handled\n", handled);
 
@@ -6272,18 +6270,6 @@ static void raid5d(struct md_thread *thread)
 
 	md_check_recovery(mddev);
 
-	if (!bio_list_empty(&conf->return_bi) &&
-	    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
-		struct bio_list tmp = BIO_EMPTY_LIST;
-		spin_lock_irq(&conf->device_lock);
-		if (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
-			bio_list_merge(&tmp, &conf->return_bi);
-			bio_list_init(&conf->return_bi);
-		}
-		spin_unlock_irq(&conf->device_lock);
-		return_io(&tmp);
-	}
-
 	blk_start_plug(&plug);
 	handled = 0;
 	spin_lock_irq(&conf->device_lock);
@@ -6935,7 +6921,6 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	INIT_LIST_HEAD(&conf->hold_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
-	bio_list_init(&conf->return_bi);
 	init_llist_head(&conf->released_stripes);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index ba5b7a3790af..13800dc9dd88 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -638,9 +638,6 @@ struct r5conf {
 	int			skip_copy; /* Don't copy data from bio to stripe cache */
 	struct list_head	*last_hold; /* detect hold_list promotions */
 
-	/* bios to have bi_end_io called after metadata is synced */
-	struct bio_list		return_bi;
-
 	atomic_t		reshape_stripes; /* stripes with pending writes for reshape */
 	/* unfortunately we need two cache names as we temporarily have
 	 * two caches.


