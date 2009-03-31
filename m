From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/14] md/raid5: clearly differentiate 'before' and 'after'
	stripes during reshape.
Date: Tue, 31 Mar 2009 15:54:43 +1100
Message-ID: <20090331045443.2589.48426.stgit@notabene.brown>
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

During a raid5 reshape, we have some stripes in the cache that are
'before' the reshape (and are still to be processed) and some that are
'after'.  They are currently differentiated by having different
->disks values as the only reshape current supported involves changing
the number of disks.

However we will soon support reshapes that do not change the number
of disks (chunk parity or chunk size).  So make the difference more
explicit with a 'generation' number.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   12 +++++++-----
 drivers/md/raid5.h |    3 +++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 76eed59..73cdf43 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -318,6 +318,7 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 
 	remove_hash(sh);
 
+	sh->generation = conf->generation - previous;
 	sh->disks = previous ? conf->previous_raid_disks : conf->raid_disks;
 	sh->sector = sector;
 	stripe_set_idx(sector, conf, previous, sh);
@@ -341,7 +342,8 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 	insert_hash(conf, sh);
 }
 
-static struct stripe_head *__find_stripe(raid5_conf_t *conf, sector_t sector, int disks)
+static struct stripe_head *__find_stripe(raid5_conf_t *conf, sector_t sector,
+					 short generation)
 {
 	struct stripe_head *sh;
 	struct hlist_node *hn;
@@ -349,7 +351,7 @@ static struct stripe_head *__find_stripe(raid5_conf_t *conf, sector_t sector, in
 	CHECK_DEVLOCK();
 	pr_debug("__find_stripe, sector %llu\n", (unsigned long long)sector);
 	hlist_for_each_entry(sh, hn, stripe_hash(conf, sector), hash)
-		if (sh->sector == sector && sh->disks == disks)
+		if (sh->sector == sector && sh->generation == generation)
 			return sh;
 	pr_debug("__stripe %llu not in cache\n", (unsigned long long)sector);
 	return NULL;
@@ -363,7 +365,6 @@ get_active_stripe(raid5_conf_t *conf, sector_t sector,
 		  int previous, int noblock)
 {
 	struct stripe_head *sh;
-	int disks = previous ? conf->previous_raid_disks : conf->raid_disks;
 
 	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
 
@@ -373,7 +374,7 @@ get_active_stripe(raid5_conf_t *conf, sector_t sector,
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    conf->quiesce == 0,
 				    conf->device_lock, /* nothing */);
-		sh = __find_stripe(conf, sector, disks);
+		sh = __find_stripe(conf, sector, conf->generation - previous);
 		if (!sh) {
 			if (!conf->inactive_blocked)
 				sh = get_free_stripe(conf);
@@ -3648,7 +3649,7 @@ static int make_request(struct request_queue *q, struct bio * bi)
 				if ((mddev->delta_disks < 0
 				     ? logical_sector >= conf->reshape_progress
 				     : logical_sector < conf->reshape_progress)
-				    && disks == conf->previous_raid_disks)
+				    && previous)
 					/* mismatch, need to try again */
 					must_retry = 1;
 				spin_unlock_irq(&conf->device_lock);
@@ -4837,6 +4838,7 @@ static int raid5_start_reshape(mddev_t *mddev)
 	else
 		conf->reshape_progress = 0;
 	conf->reshape_safe = conf->reshape_progress;
+	conf->generation++;
 	spin_unlock_irq(&conf->device_lock);
 
 	/* Add some new drives, as many as will fit.
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index b2edcc4..a081fb4 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -198,6 +198,8 @@ struct stripe_head {
 	struct hlist_node	hash;
 	struct list_head	lru;	      /* inactive_list or handle_list */
 	struct raid5_private_data *raid_conf;
+	short			generation;	/* increments with every
+						 * reshape */
 	sector_t		sector;		/* sector of this row */
 	short			pd_idx;		/* parity disk index */
 	short			qd_idx;		/* 'Q' disk index for raid6 */
@@ -348,6 +350,7 @@ struct raid5_private_data {
 	 */
 	sector_t		reshape_safe;
 	int			previous_raid_disks;
+	short			generation; /* increments with every reshape */
 
 	struct list_head	handle_list; /* stripes needing handling */
 	struct list_head	hold_list; /* preread ready stripes */


