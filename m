From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md -  Zero out some kmalloced space in md driver
Date: Wed, 11 Jun 2003 17:00:33 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19Pzaz-0000GX-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>, Andrew Morton <akpm@digeo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This should fix most (all??) of the recently reported problems with MD in
2.5.70-bk and derivatives.

NeilBrown

### Comments for ChangeSet

Recent changes to md malloced some data structures differently
and didn't zero out those data structures, where the old code
had zeroed it out.

This patch adds the relevant memsets.



 ----------- Diffstat output ------------
 ./drivers/md/linear.c    |    2 +-
 ./drivers/md/multipath.c |    1 +
 ./drivers/md/raid0.c     |    3 +++
 ./drivers/md/raid1.c     |    3 ++-
 ./drivers/md/raid5.c     |    2 +-
 5 files changed, 8 insertions(+), 3 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2003-06-11 09:46:09.000000000 +1000
+++ ./drivers/md/linear.c	2003-06-11 09:46:28.000000000 +1000
@@ -93,7 +93,7 @@ static int linear_run (mddev_t *mddev)
 			GFP_KERNEL);
 	if (!conf)
 		goto out;
-	memset(conf, 0, sizeof(*conf));
+	memset(conf, 0, sizeof(*conf) + mddev->raid_disks*sizeof(dev_info_t));
 	mddev->private = conf;
 
 	/*

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2003-06-11 09:47:13.000000000 +1000
+++ ./drivers/md/multipath.c	2003-06-11 09:47:55.000000000 +1000
@@ -397,6 +397,7 @@ static int multipath_run (mddev_t *mddev
 			mdidx(mddev));
 		goto out_free_conf;
 	}
+	memset(conf->multipaths, 0, sizeof(struct multipath_info)*mddev->raid_disks);
 
 	conf->working_disks = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-06-11 09:38:02.000000000 +1000
+++ ./drivers/md/raid0.c	2003-06-11 09:48:57.000000000 +1000
@@ -90,6 +90,9 @@ static int create_strip_zones (mddev_t *
 
 	memset(conf->strip_zone, 0,sizeof(struct strip_zone)*
 				   conf->nr_strip_zones);
+	memset(conf->devlist, 0,
+	       sizeof(mdk_rdev_t*) * conf->nr_strip_zones * mddev->raid_disks);
+
 	/* The first zone must contain all devices, so here we check that
 	 * there is a proper alignment of slots to devices and find them all
 	 */

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-06-11 09:49:29.000000000 +1000
+++ ./drivers/md/raid1.c	2003-06-11 09:51:06.000000000 +1000
@@ -47,7 +47,7 @@ static void * r1bio_pool_alloc(int gfp_f
 	r1_bio = kmalloc(sizeof(r1bio_t) + sizeof(struct bio*)*mddev->raid_disks,
 			 gfp_flags);
 	if (r1_bio)
-		memset(r1_bio, 0, sizeof(*r1_bio));
+		memset(r1_bio, 0, sizeof(*r1_bio) + sizeof(struct bio*)*mddev->raid_disks);
 
 	return r1_bio;
 }
@@ -1057,6 +1057,7 @@ static int run(mddev_t *mddev)
 		       mdidx(mddev));
 		goto out_free_conf;
 	}
+	memset(conf->mirrors, 0, sizeof(struct mirror_info)*mddev->raid_disks);
 
 	conf->r1bio_pool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
 						r1bio_pool_free, mddev);

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-06-11 09:50:15.000000000 +1000
+++ ./drivers/md/raid5.c	2003-06-11 09:50:30.000000000 +1000
@@ -1458,7 +1458,7 @@ static int run (mddev_t *mddev)
 				  GFP_KERNEL);
 	if ((conf = mddev->private) == NULL)
 		goto abort;
-	memset (conf, 0, sizeof (*conf));
+	memset (conf, 0, sizeof (*conf) + mddev->raid_disks * sizeof(struct disk_info) );
 	conf->mddev = mddev;
 
 	if ((conf->stripe_hashtbl = (struct stripe_head **) __get_free_pages(GFP_ATOMIC, HASH_PAGES_ORDER)) == NULL)
