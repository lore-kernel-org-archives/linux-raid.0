From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 04/11] md: raid1/raid10: handle allocation errors during
	array setup.
Date: Fri, 16 Oct 2009 16:49:18 +1100
Message-ID: <20091016054918.24208.91547.stgit@notabene.brown>
References: <20091016054316.24208.33818.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091016054316.24208.33818.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Both raid1 and raid10 create a mempool during startup.
If the 'alloc' function for this mempool fails, unplug_slaves
is called.
If that happens when the pool is being initialised, unplug_slaves
will try to use the 'conf' structure that isn't filled in yet, and
badness will happen.

So ensure that unplug_slaves doesn't get called unless we know
that the conf structure if fully initialised.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c  |    5 +++--
 drivers/md/raid10.c |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 71a01a2..a053423 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -64,7 +64,7 @@ static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
 
 	/* allocate a r1bio with room for raid_disks entries in the bios array */
 	r1_bio = kzalloc(size, gfp_flags);
-	if (!r1_bio)
+	if (!r1_bio && pi->mddev)
 		unplug_slaves(pi->mddev);
 
 	return r1_bio;
@@ -1979,13 +1979,14 @@ static int run(mddev_t *mddev)
 	conf->poolinfo = kmalloc(sizeof(*conf->poolinfo), GFP_KERNEL);
 	if (!conf->poolinfo)
 		goto out_no_mem;
-	conf->poolinfo->mddev = mddev;
+	conf->poolinfo->mddev = NULL;
 	conf->poolinfo->raid_disks = mddev->raid_disks;
 	conf->r1bio_pool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
 					  r1bio_pool_free,
 					  conf->poolinfo);
 	if (!conf->r1bio_pool)
 		goto out_no_mem;
+	conf->poolinfo->mddev = mddev;
 
 	spin_lock_init(&conf->device_lock);
 	mddev->queue->queue_lock = &conf->device_lock;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 69fc76c..c2cb7b8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -68,7 +68,7 @@ static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 
 	/* allocate a r10bio with room for raid_disks entries in the bios array */
 	r10_bio = kzalloc(size, gfp_flags);
-	if (!r10_bio)
+	if (!r10_bio && conf->mddev)
 		unplug_slaves(conf->mddev);
 
 	return r10_bio;
@@ -2096,7 +2096,6 @@ static int run(mddev_t *mddev)
 	if (!conf->tmppage)
 		goto out_free_conf;
 
-	conf->mddev = mddev;
 	conf->raid_disks = mddev->raid_disks;
 	conf->near_copies = nc;
 	conf->far_copies = fc;
@@ -2133,6 +2132,7 @@ static int run(mddev_t *mddev)
 		goto out_free_conf;
 	}
 
+	conf->mddev = mddev;
 	spin_lock_init(&conf->device_lock);
 	mddev->queue->queue_lock = &conf->device_lock;
 


