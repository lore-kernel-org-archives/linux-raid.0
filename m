From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 39/54] md/raid5: Add some spaces for better code readability
Date: Thu, 6 Oct 2016 11:39:01 +0200
Message-ID: <bde870ae-1e7d-6003-809a-1d39460edb23@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Oct 2016 16:00:32 +0200

Use space characters at some source code places according to
the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid5.c | 165 +++++++++++++++++++++++++++--------------------------
 1 file changed, 83 insertions(+), 82 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5bcc1ff..e29c198 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -292,7 +292,7 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 			      struct list_head *temp_inactive_list)
 {
 	BUG_ON(!list_empty(&sh->lru));
-	BUG_ON(atomic_read(&conf->active_stripes)==0);
+	BUG_ON(atomic_read(&conf->active_stripes) == 0);
 	if (test_bit(STRIPE_HANDLE, &sh->state)) {
 		if (test_bit(STRIPE_DELAYED, &sh->state) &&
 		    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
@@ -2224,7 +2224,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		osh = get_free_stripe(conf, hash);
 		unlock_device_hash_lock(conf, hash);
 
-		for(i=0; i<conf->pool_size; i++) {
+		for (i = 0; i < conf->pool_size; i++) {
 			nsh->dev[i].page = osh->dev[i].page;
 			nsh->dev[i].orig_page = osh->dev[i].page;
 		}
@@ -2246,7 +2246,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 	 */
 	ndisks = kcalloc(newsize, sizeof(*ndisks), GFP_NOIO);
 	if (ndisks) {
-		for (i=0; i<conf->raid_disks; i++)
+		for (i = 0; i < conf->raid_disks; i++)
 			ndisks[i] = conf->disks[i];
 		kfree(conf->disks);
 		conf->disks = ndisks;
@@ -2255,11 +2255,11 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 
 	mutex_unlock(&conf->cache_size_mutex);
 	/* Step 4, return new stripes to service */
-	while(!list_empty(&newstripes)) {
+	while (!list_empty(&newstripes)) {
 		nsh = list_entry(newstripes.next, struct stripe_head, lru);
 		list_del_init(&nsh->lru);
 
-		for (i=conf->raid_disks; i < newsize; i++)
+		for (i = conf->raid_disks; i < newsize; i++)
 			if (!nsh->dev[i].page) {
 				struct page *p = alloc_page(GFP_NOIO);
 				nsh->dev[i].page = p;
@@ -2315,7 +2315,7 @@ static void raid5_end_read_request(struct bio *bi)
 	struct md_rdev *rdev = NULL;
 	sector_t s;
 
-	for (i=0 ; i<disks; i++)
+	for (i = 0 ; i < disks; i++)
 		if (bi == &sh->dev[i].req)
 			break;
 
@@ -2571,7 +2571,7 @@ sector_t raid5_compute_sector(struct r5conf *conf, sector_t r_sector,
 	 * Select the parity disk based on the user selected algorithm.
 	 */
 	pd_idx = qd_idx = -1;
-	switch(conf->level) {
+	switch (conf->level) {
 	case 4:
 		pd_idx = data_disks;
 		break;
@@ -2759,7 +2759,7 @@ sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous)
 
 	if (i == sh->pd_idx)
 		return 0;
-	switch(conf->level) {
+	switch (conf->level) {
 	case 4: break;
 	case 5:
 		switch (algorithm) {
@@ -2957,7 +2957,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
 {
 	struct bio **bip;
 	struct r5conf *conf = sh->raid_conf;
-	int firstwrite=0;
+	int firstwrite = 0;
 
 	pr_debug("adding bi b#%llu to stripe s#%llu\n",
 		(unsigned long long)bi->bi_iter.bi_sector,
@@ -3001,7 +3001,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
 	if (forwrite) {
 		/* check if page is covered */
 		sector_t sector = sh->dev[dd_idx].sector;
-		for (bi=sh->dev[dd_idx].towrite;
+		for (bi = sh->dev[dd_idx].towrite;
 		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
 			     bi && bi->bi_iter.bi_sector <= sector;
 		     bi = r5_next_bio(bi, sh->dev[dd_idx].sector)) {
@@ -3639,7 +3639,8 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	}
 	if ((rcw < rmw || (rcw == rmw && conf->rmw_level != PARITY_PREFER_RMW)) && rcw > 0) {
 		/* want reconstruct write, but need to get some data */
-		int qread =0;
+		int qread = 0;
+
 		rcw = 0;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
@@ -4031,7 +4032,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 
 	/* Now to look around and see what can be done */
 	rcu_read_lock();
-	for (i=disks; i--; ) {
+	for (i = disks; i--; ) {
 		struct md_rdev *rdev;
 		sector_t first_bad;
 		int bad_sectors;
@@ -4716,7 +4717,7 @@ static int in_chunk_boundary(struct mddev *mddev, struct bio *bio)
  *  add bio to the retry LIFO  ( in O(1) ... we are in interrupt )
  *  later sampled by raid5d.
  */
-static void add_bio_to_retry(struct bio *bi,struct r5conf *conf)
+static void add_bio_to_retry(struct bio *bi, struct r5conf *conf)
 {
 	unsigned long flags;
 
@@ -4739,7 +4740,7 @@ static struct bio *remove_bio_from_retry(struct r5conf *conf)
 		return bi;
 	}
 	bi = conf->retry_read_aligned_list;
-	if(bi) {
+	if (bi) {
 		conf->retry_read_aligned_list = bi->bi_next;
 		bi->bi_next = NULL;
 		/*
@@ -4768,7 +4769,7 @@ static void raid5_align_endio(struct bio *bi)
 
 	bio_put(bi);
 
-	rdev = (void*)raid_bi->bi_next;
+	rdev = (void *)raid_bi->bi_next;
 	raid_bi->bi_next = NULL;
 	mddev = rdev->mddev;
 	conf = mddev->private;
@@ -4838,7 +4839,7 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 
 		atomic_inc(&rdev->nr_pending);
 		rcu_read_unlock();
-		raid_bio->bi_next = (void*)rdev;
+		raid_bio->bi_next = (void *)rdev;
 		align_bi->bi_bdev =  rdev->bdev;
 		bio_clear_flag(align_bi, BIO_SEG_VALID);
 
@@ -5198,7 +5199,7 @@ static void raid5_make_request(struct mddev *mddev, struct bio *bi)
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
 
 	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
-	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
+	for (; logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		int previous;
 		int seq;
 
@@ -5464,10 +5465,10 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	if ((mddev->reshape_backwards
 	     ? (safepos > writepos && readpos < writepos)
 	     : (safepos < writepos && readpos > writepos)) ||
-	    time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
+	    time_after(jiffies, conf->reshape_checkpoint + 10 * HZ)) {
 		/* Cannot proceed until we've updated the superblock... */
 		wait_event(conf->wait_for_overlap,
-			   atomic_read(&conf->reshape_stripes)==0
+			   atomic_read(&conf->reshape_stripes) == 0
 			   || test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 		if (atomic_read(&conf->reshape_stripes) != 0)
 			return 0;
@@ -5497,7 +5498,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 		/* If any of this stripe is beyond the end of the old
 		 * array, then we need to zero those blocks
 		 */
-		for (j=sh->disks; j--;) {
+		for (j = sh->disks; j--;) {
 			sector_t s;
 			if (j == sh->pd_idx)
 				continue;
@@ -6406,7 +6407,7 @@ static unsigned long raid5_cache_scan(struct shrinker *shrink,
 	unsigned long ret = SHRINK_STOP;
 
 	if (mutex_trylock(&conf->cache_size_mutex)) {
-		ret= 0;
+		ret = 0;
 		while (ret < sc->nr_to_scan &&
 		       conf->max_nr_stripes > conf->min_nr_stripes) {
 			if (drop_one_stripe(conf) == 0) {
@@ -7582,7 +7583,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 {
 	struct r5conf *conf = mddev->private;
 
-	switch(state) {
+	switch (state) {
 	case 2: /* resume for a suspend */
 		wake_up(&conf->wait_for_overlap);
 		break;
@@ -7850,70 +7851,70 @@ static void *raid6_takeover(struct mddev *mddev)
 }
 
 static struct md_personality raid6_personality = {
-	.name		= "raid6",
-	.level		= 6,
-	.owner		= THIS_MODULE,
-	.make_request	= raid5_make_request,
-	.run		= raid5_run,
-	.free		= raid5_free,
-	.status		= raid5_status,
-	.error_handler	= raid5_error,
-	.hot_add_disk	= raid5_add_disk,
-	.hot_remove_disk= raid5_remove_disk,
-	.spare_active	= raid5_spare_active,
-	.sync_request	= raid5_sync_request,
-	.resize		= raid5_resize,
-	.size		= raid5_size,
-	.check_reshape	= raid6_check_reshape,
-	.start_reshape  = raid5_start_reshape,
-	.finish_reshape = raid5_finish_reshape,
-	.quiesce	= raid5_quiesce,
-	.takeover	= raid6_takeover,
-	.congested	= raid5_congested,
+	.name            = "raid6",
+	.level           = 6,
+	.owner           = THIS_MODULE,
+	.make_request    = raid5_make_request,
+	.run             = raid5_run,
+	.free            = raid5_free,
+	.status          = raid5_status,
+	.error_handler   = raid5_error,
+	.hot_add_disk    = raid5_add_disk,
+	.hot_remove_disk = raid5_remove_disk,
+	.spare_active    = raid5_spare_active,
+	.sync_request    = raid5_sync_request,
+	.resize          = raid5_resize,
+	.size            = raid5_size,
+	.check_reshape   = raid6_check_reshape,
+	.start_reshape   = raid5_start_reshape,
+	.finish_reshape  = raid5_finish_reshape,
+	.quiesce         = raid5_quiesce,
+	.takeover        = raid6_takeover,
+	.congested       = raid5_congested,
 };
 static struct md_personality raid5_personality = {
-	.name		= "raid5",
-	.level		= 5,
-	.owner		= THIS_MODULE,
-	.make_request	= raid5_make_request,
-	.run		= raid5_run,
-	.free		= raid5_free,
-	.status		= raid5_status,
-	.error_handler	= raid5_error,
-	.hot_add_disk	= raid5_add_disk,
-	.hot_remove_disk= raid5_remove_disk,
-	.spare_active	= raid5_spare_active,
-	.sync_request	= raid5_sync_request,
-	.resize		= raid5_resize,
-	.size		= raid5_size,
-	.check_reshape	= raid5_check_reshape,
-	.start_reshape  = raid5_start_reshape,
-	.finish_reshape = raid5_finish_reshape,
-	.quiesce	= raid5_quiesce,
-	.takeover	= raid5_takeover,
-	.congested	= raid5_congested,
+	.name            = "raid5",
+	.level           = 5,
+	.owner           = THIS_MODULE,
+	.make_request    = raid5_make_request,
+	.run             = raid5_run,
+	.free            = raid5_free,
+	.status          = raid5_status,
+	.error_handler   = raid5_error,
+	.hot_add_disk    = raid5_add_disk,
+	.hot_remove_disk = raid5_remove_disk,
+	.spare_active    = raid5_spare_active,
+	.sync_request    = raid5_sync_request,
+	.resize          = raid5_resize,
+	.size            = raid5_size,
+	.check_reshape   = raid5_check_reshape,
+	.start_reshape   = raid5_start_reshape,
+	.finish_reshape  = raid5_finish_reshape,
+	.quiesce         = raid5_quiesce,
+	.takeover        = raid5_takeover,
+	.congested       = raid5_congested,
 };
 static struct md_personality raid4_personality = {
-	.name		= "raid4",
-	.level		= 4,
-	.owner		= THIS_MODULE,
-	.make_request	= raid5_make_request,
-	.run		= raid5_run,
-	.free		= raid5_free,
-	.status		= raid5_status,
-	.error_handler	= raid5_error,
-	.hot_add_disk	= raid5_add_disk,
-	.hot_remove_disk= raid5_remove_disk,
-	.spare_active	= raid5_spare_active,
-	.sync_request	= raid5_sync_request,
-	.resize		= raid5_resize,
-	.size		= raid5_size,
-	.check_reshape	= raid5_check_reshape,
-	.start_reshape  = raid5_start_reshape,
-	.finish_reshape = raid5_finish_reshape,
-	.quiesce	= raid5_quiesce,
-	.takeover	= raid4_takeover,
-	.congested	= raid5_congested,
+	.name            = "raid4",
+	.level           = 4,
+	.owner           = THIS_MODULE,
+	.make_request    = raid5_make_request,
+	.run             = raid5_run,
+	.free            = raid5_free,
+	.status          = raid5_status,
+	.error_handler   = raid5_error,
+	.hot_add_disk    = raid5_add_disk,
+	.hot_remove_disk = raid5_remove_disk,
+	.spare_active    = raid5_spare_active,
+	.sync_request    = raid5_sync_request,
+	.resize          = raid5_resize,
+	.size            = raid5_size,
+	.check_reshape   = raid5_check_reshape,
+	.start_reshape   = raid5_start_reshape,
+	.finish_reshape  = raid5_finish_reshape,
+	.quiesce         = raid5_quiesce,
+	.takeover        = raid4_takeover,
+	.congested       = raid5_congested,
 };
 
 static int __init raid5_init(void)
-- 
2.10.1

