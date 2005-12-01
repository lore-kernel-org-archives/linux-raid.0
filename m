From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 008 of 14] Convert md to use kzalloc throughout
Date: Thu, 1 Dec 2005 14:23:28 +1100
Message-ID: <1051201032328.29641@suse.de>
References: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Replace multiple kmalloc/memset pairs with kzalloc calls.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c    |   11 +++--------
 ./drivers/md/linear.c    |    3 +--
 ./drivers/md/md.c        |   10 +++-------
 ./drivers/md/multipath.c |   10 +++-------
 ./drivers/md/raid0.c     |    9 ++-------
 ./drivers/md/raid1.c     |   20 ++++++--------------
 ./drivers/md/raid10.c    |    6 ++----
 ./drivers/md/raid5.c     |    8 ++++----
 8 files changed, 24 insertions(+), 53 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-12-01 14:01:30.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-12-01 13:59:53.000000000 +1100
@@ -887,12 +887,10 @@ static int bitmap_init_from_disk(struct 
 	if (!bitmap->filemap)
 		goto out;
 
-	bitmap->filemap_attr = kmalloc(sizeof(long) * num_pages, GFP_KERNEL);
+	bitmap->filemap_attr = kzalloc(sizeof(long) * num_pages, GFP_KERNEL);
 	if (!bitmap->filemap_attr)
 		goto out;
 
-	memset(bitmap->filemap_attr, 0, sizeof(long) * num_pages);
-
 	oldindex = ~0L;
 
 	for (i = 0; i < chunks; i++) {
@@ -1557,12 +1555,10 @@ int bitmap_create(mddev_t *mddev)
 
 	BUG_ON(file && mddev->bitmap_offset);
 
-	bitmap = kmalloc(sizeof(*bitmap), GFP_KERNEL);
+	bitmap = kzalloc(sizeof(*bitmap), GFP_KERNEL);
 	if (!bitmap)
 		return -ENOMEM;
 
-	memset(bitmap, 0, sizeof(*bitmap));
-
 	spin_lock_init(&bitmap->lock);
 	bitmap->mddev = mddev;
 
@@ -1603,12 +1599,11 @@ int bitmap_create(mddev_t *mddev)
 #ifdef INJECT_FATAL_FAULT_1
 	bitmap->bp = NULL;
 #else
-	bitmap->bp = kmalloc(pages * sizeof(*bitmap->bp), GFP_KERNEL);
+	bitmap->bp = kzalloc(pages * sizeof(*bitmap->bp), GFP_KERNEL);
 #endif
 	err = -ENOMEM;
 	if (!bitmap->bp)
 		goto error;
-	memset(bitmap->bp, 0, pages * sizeof(*bitmap->bp));
 
 	bitmap->flags |= BITMAP_ACTIVE;
 

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2005-12-01 14:01:30.000000000 +1100
+++ ./drivers/md/linear.c	2005-12-01 13:59:53.000000000 +1100
@@ -121,11 +121,10 @@ static int linear_run (mddev_t *mddev)
 	sector_t curr_offset;
 	struct list_head *tmp;
 
-	conf = kmalloc (sizeof (*conf) + mddev->raid_disks*sizeof(dev_info_t),
+	conf = kzalloc (sizeof (*conf) + mddev->raid_disks*sizeof(dev_info_t),
 			GFP_KERNEL);
 	if (!conf)
 		goto out;
-	memset(conf, 0, sizeof(*conf) + mddev->raid_disks*sizeof(dev_info_t));
 	mddev->private = conf;
 
 	cnt = 0;

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-01 14:01:30.000000000 +1100
+++ ./drivers/md/md.c	2005-12-01 13:59:53.000000000 +1100
@@ -228,12 +228,10 @@ static mddev_t * mddev_find(dev_t unit)
 	}
 	spin_unlock(&all_mddevs_lock);
 
-	new = (mddev_t *) kmalloc(sizeof(*new), GFP_KERNEL);
+	new = (mddev_t *) kzalloc(sizeof(*new), GFP_KERNEL);
 	if (!new)
 		return NULL;
 
-	memset(new, 0, sizeof(*new));
-
 	new->unit = unit;
 	if (MAJOR(unit) == MD_MAJOR)
 		new->md_minor = MINOR(unit);
@@ -1620,12 +1618,11 @@ static mdk_rdev_t *md_import_device(dev_
 	mdk_rdev_t *rdev;
 	sector_t size;
 
-	rdev = (mdk_rdev_t *) kmalloc(sizeof(*rdev), GFP_KERNEL);
+	rdev = (mdk_rdev_t *) kzalloc(sizeof(*rdev), GFP_KERNEL);
 	if (!rdev) {
 		printk(KERN_ERR "md: could not alloc mem for new device!\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	memset(rdev, 0, sizeof(*rdev));
 
 	if ((err = alloc_disk_sb(rdev)))
 		goto abort_free;
@@ -3497,11 +3494,10 @@ mdk_thread_t *md_register_thread(void (*
 {
 	mdk_thread_t *thread;
 
-	thread = kmalloc(sizeof(mdk_thread_t), GFP_KERNEL);
+	thread = kzalloc(sizeof(mdk_thread_t), GFP_KERNEL);
 	if (!thread)
 		return NULL;
 
-	memset(thread, 0, sizeof(mdk_thread_t));
 	init_waitqueue_head(&thread->wqueue);
 
 	thread->run = run;

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2005-12-01 14:01:30.000000000 +1100
+++ ./drivers/md/multipath.c	2005-12-01 13:59:53.000000000 +1100
@@ -41,9 +41,7 @@ static mdk_personality_t multipath_perso
 static void *mp_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct multipath_bh *mpb;
-	mpb = kmalloc(sizeof(*mpb), gfp_flags);
-	if (mpb) 
-		memset(mpb, 0, sizeof(*mpb));
+	mpb = kzalloc(sizeof(*mpb), gfp_flags);
 	return mpb;
 }
 
@@ -444,7 +442,7 @@ static int multipath_run (mddev_t *mddev
 	 * should be freed in multipath_stop()]
 	 */
 
-	conf = kmalloc(sizeof(multipath_conf_t), GFP_KERNEL);
+	conf = kzalloc(sizeof(multipath_conf_t), GFP_KERNEL);
 	mddev->private = conf;
 	if (!conf) {
 		printk(KERN_ERR 
@@ -452,9 +450,8 @@ static int multipath_run (mddev_t *mddev
 			mdname(mddev));
 		goto out;
 	}
-	memset(conf, 0, sizeof(*conf));
 
-	conf->multipaths = kmalloc(sizeof(struct multipath_info)*mddev->raid_disks,
+	conf->multipaths = kzalloc(sizeof(struct multipath_info)*mddev->raid_disks,
 				   GFP_KERNEL);
 	if (!conf->multipaths) {
 		printk(KERN_ERR 
@@ -462,7 +459,6 @@ static int multipath_run (mddev_t *mddev
 			mdname(mddev));
 		goto out_free_conf;
 	}
-	memset(conf->multipaths, 0, sizeof(struct multipath_info)*mddev->raid_disks);
 
 	conf->working_disks = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2005-12-01 14:01:30.000000000 +1100
+++ ./drivers/md/raid0.c	2005-12-01 13:59:53.000000000 +1100
@@ -113,21 +113,16 @@ static int create_strip_zones (mddev_t *
 	}
 	printk("raid0: FINAL %d zones\n", conf->nr_strip_zones);
 
-	conf->strip_zone = kmalloc(sizeof(struct strip_zone)*
+	conf->strip_zone = kzalloc(sizeof(struct strip_zone)*
 				conf->nr_strip_zones, GFP_KERNEL);
 	if (!conf->strip_zone)
 		return 1;
-	conf->devlist = kmalloc(sizeof(mdk_rdev_t*)*
+	conf->devlist = kzalloc(sizeof(mdk_rdev_t*)*
 				conf->nr_strip_zones*mddev->raid_disks,
 				GFP_KERNEL);
 	if (!conf->devlist)
 		return 1;
 
-	memset(conf->strip_zone, 0,sizeof(struct strip_zone)*
-				   conf->nr_strip_zones);
-	memset(conf->devlist, 0,
-	       sizeof(mdk_rdev_t*) * conf->nr_strip_zones * mddev->raid_disks);
-
 	/* The first zone must contain all devices, so here we check that
 	 * there is a proper alignment of slots to devices and find them all
 	 */

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-12-01 14:01:30.000000000 +1100
+++ ./drivers/md/raid1.c	2005-12-01 13:59:53.000000000 +1100
@@ -61,10 +61,8 @@ static void * r1bio_pool_alloc(gfp_t gfp
 	int size = offsetof(r1bio_t, bios[pi->raid_disks]);
 
 	/* allocate a r1bio with room for raid_disks entries in the bios array */
-	r1_bio = kmalloc(size, gfp_flags);
-	if (r1_bio)
-		memset(r1_bio, 0, size);
-	else
+	r1_bio = kzalloc(size, gfp_flags);
+	if (!r1_bio)
 		unplug_slaves(pi->mddev);
 
 	return r1_bio;
@@ -710,13 +708,11 @@ static struct page **alloc_behind_pages(
 {
 	int i;
 	struct bio_vec *bvec;
-	struct page **pages = kmalloc(bio->bi_vcnt * sizeof(struct page *),
+	struct page **pages = kzalloc(bio->bi_vcnt * sizeof(struct page *),
 					GFP_NOIO);
 	if (unlikely(!pages))
 		goto do_sync_io;
 
-	memset(pages, 0, bio->bi_vcnt * sizeof(struct page *));
-
 	bio_for_each_segment(bvec, bio, i) {
 		pages[i] = alloc_page(GFP_NOIO);
 		if (unlikely(!pages[i]))
@@ -1769,19 +1765,16 @@ static int run(mddev_t *mddev)
 	 * bookkeeping area. [whatever we allocate in run(),
 	 * should be freed in stop()]
 	 */
-	conf = kmalloc(sizeof(conf_t), GFP_KERNEL);
+	conf = kzalloc(sizeof(conf_t), GFP_KERNEL);
 	mddev->private = conf;
 	if (!conf)
 		goto out_no_mem;
 
-	memset(conf, 0, sizeof(*conf));
-	conf->mirrors = kmalloc(sizeof(struct mirror_info)*mddev->raid_disks, 
+	conf->mirrors = kzalloc(sizeof(struct mirror_info)*mddev->raid_disks,
 				 GFP_KERNEL);
 	if (!conf->mirrors)
 		goto out_no_mem;
 
-	memset(conf->mirrors, 0, sizeof(struct mirror_info)*mddev->raid_disks);
-
 	conf->tmppage = alloc_page(GFP_KERNEL);
 	if (!conf->tmppage)
 		goto out_no_mem;
@@ -1991,13 +1984,12 @@ static int raid1_reshape(mddev_t *mddev,
 		kfree(newpoolinfo);
 		return -ENOMEM;
 	}
-	newmirrors = kmalloc(sizeof(struct mirror_info) * raid_disks, GFP_KERNEL);
+	newmirrors = kzalloc(sizeof(struct mirror_info) * raid_disks, GFP_KERNEL);
 	if (!newmirrors) {
 		kfree(newpoolinfo);
 		mempool_destroy(newpool);
 		return -ENOMEM;
 	}
-	memset(newmirrors, 0, sizeof(struct mirror_info)*raid_disks);
 
 	raise_barrier(conf);
 

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-12-01 14:01:30.000000000 +1100
+++ ./drivers/md/raid10.c	2005-12-01 13:59:53.000000000 +1100
@@ -59,10 +59,8 @@ static void * r10bio_pool_alloc(gfp_t gf
 	int size = offsetof(struct r10bio_s, devs[conf->copies]);
 
 	/* allocate a r10bio with room for raid_disks entries in the bios array */
-	r10_bio = kmalloc(size, gfp_flags);
-	if (r10_bio)
-		memset(r10_bio, 0, size);
-	else
+	r10_bio = kzalloc(size, gfp_flags);
+	if (!r10_bio)
 		unplug_slaves(conf->mddev);
 
 	return r10_bio;

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-12-01 14:01:30.000000000 +1100
+++ ./drivers/md/raid5.c	2005-12-01 14:01:46.000000000 +1100
@@ -1826,12 +1826,12 @@ static int run(mddev_t *mddev)
 		return -EIO;
 	}
 
-	mddev->private = kmalloc (sizeof (raid5_conf_t)
-				  + mddev->raid_disks * sizeof(struct disk_info),
-				  GFP_KERNEL);
+	mddev->private = kzalloc(sizeof (raid5_conf_t)
+				 + mddev->raid_disks * sizeof(struct disk_info),
+				 GFP_KERNEL);
 	if ((conf = mddev->private) == NULL)
 		goto abort;
-	memset (conf, 0, sizeof (*conf) + mddev->raid_disks * sizeof(struct disk_info) );
+
 	conf->mddev = mddev;
 
 	if ((conf->stripe_hashtbl = (struct stripe_head **) __get_free_pages(GFP_ATOMIC, HASH_PAGES_ORDER)) == NULL)
