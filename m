From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 3/5] md/raid5: simplfy delaying of writes while metadata
 is updated.
Date: Mon, 21 Nov 2016 12:19:43 +1100
Message-ID: <147969118348.5434.15228520921578776286.stgit@noble>
References: <147969099621.5434.12384452255155063186.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147969099621.5434.12384452255155063186.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If a device fails during a write, we must ensure the failure is
recorded in the metadata before the completion of the write is
acknowleged.

Commit: c3cce6cda162 ("md/raid5: ensure device failure recorded before write request returns.")
added code for this, but it was unnecessarily complicated.  We already
had similar function for handling updated to the bad-block-list thanks to
Commit: de393cdea66c ("md: make it easier to wait for bad blocks to be acknowledged.")

So revert most of the former commit, and instead avoid collecting
completed write if MD_CHANGE_PENDING is set.  raid5d will then flush
the metadata and retry the stripe_head.

We check MD_CHANGE_PENDING *after* analyse_stripe() as it could be set
asynchronously.  After analyse_stripe(), we have collected stable data
about the data of devices, which will be used to make decisions.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid5.c |   27 ++++-----------------------
 drivers/md/raid5.h |    3 ---
 2 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d07d2dce6856..e53b8f499a4c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4344,7 +4344,8 @@ static void handle_stripe(struct stripe_head *sh)
 	if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
 		goto finish;
 
-	if (s.handle_bad_blocks) {
+	if (s.handle_bad_blocks ||
+	    test_bit(MD_CHANGE_PENDING, &conf->mddev->flags)) {
 		set_bit(STRIPE_HANDLE, &sh->state);
 		goto finish;
 	}
@@ -4632,15 +4633,8 @@ static void handle_stripe(struct stripe_head *sh)
 			md_wakeup_thread(conf->mddev->thread);
 	}
 
-	if (!bio_list_empty(&s.return_bi)) {
-		if (test_bit(MD_CHANGE_PENDING, &conf->mddev->flags)) {
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
@@ -5846,18 +5840,6 @@ static void raid5d(struct md_thread *thread)
 
 	md_check_recovery(mddev);
 
-	if (!bio_list_empty(&conf->return_bi) &&
-	    !test_bit(MD_CHANGE_PENDING, &mddev->flags)) {
-		struct bio_list tmp = BIO_EMPTY_LIST;
-		spin_lock_irq(&conf->device_lock);
-		if (!test_bit(MD_CHANGE_PENDING, &mddev->flags)) {
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
@@ -6490,7 +6472,6 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	INIT_LIST_HEAD(&conf->hold_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
-	bio_list_init(&conf->return_bi);
 	init_llist_head(&conf->released_stripes);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 57ec49f0839e..f654f8207a44 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -482,9 +482,6 @@ struct r5conf {
 	int			skip_copy; /* Don't copy data from bio to stripe cache */
 	struct list_head	*last_hold; /* detect hold_list promotions */
 
-	/* bios to have bi_end_io called after metadata is synced */
-	struct bio_list		return_bi;
-
 	atomic_t		reshape_stripes; /* stripes with pending writes for reshape */
 	/* unfortunately we need two cache names as we temporarily have
 	 * two caches.


