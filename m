From: NeilBrown <neilb@suse.de>
Subject: [PATCH 17/18] md: add ->takeover method for raid5 to be able to take
	over raid1
Date: Thu, 12 Feb 2009 14:10:11 +1100
Message-ID: <20090212031011.23983.65898.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The RAID1 must have two drives and be a suitable size to
be a multiple of a chunksize that isn't too small.
---

 drivers/md/raid5.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 89ce65d..8847c14 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4151,7 +4151,8 @@ static struct attribute_group raid5_attrs_group = {
 	.attrs = raid5_attrs,
 };
 
-static raid5_conf_t *setup_conf(mddev_t *mddev, int raid_disks, int level, int layout)
+static raid5_conf_t *setup_conf(mddev_t *mddev, int raid_disks,
+				int level, int layout, int chunksize)
 {
 	raid5_conf_t *conf;
 	int raid_disk, memory;
@@ -4170,7 +4171,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev, int raid_disks, int level, int l
 		return ERR_PTR(-EIO);
 	}
 
-	if (mddev->chunk_size < PAGE_SIZE) {
+	if (chunksize < PAGE_SIZE) {
 		printk(KERN_ERR "md/raid5: chunk_size must be at least "
 		       "PAGE_SIZE but %d < %ld\n",
 		       mddev->chunk_size, PAGE_SIZE);
@@ -4237,7 +4238,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev, int raid_disks, int level, int l
 			conf->fullsync = 1;
 	}
 
-	conf->chunk_size = mddev->chunk_size;
+	conf->chunk_size = chunksize;
 	conf->level = level;
 	if (conf->level == 6)
 		conf->max_degraded = 2;
@@ -4330,11 +4331,13 @@ static int run(mddev_t *mddev)
 	}
 
 	if (mddev->private == NULL)
-		conf = setup_conf(mddev, mddev->raid_disks, mddev->level, mddev->layout);
+		conf = setup_conf(mddev, mddev->raid_disks, mddev->level,
+				  mddev->layout, mddev->chunk_size);
 	else {
 		conf = mddev->private;
 		mddev->raid_disks = conf->raid_disks;
 		mddev->layout = conf->algorithm;
+		mddev->chunk_size = conf->chunk_size;
 	}
 
 	if (IS_ERR(conf))
@@ -4869,6 +4872,63 @@ static void raid5_quiesce(mddev_t *mddev, int state)
 	}
 }
 
+
+static void *raid5_takeover_raid1(mddev_t *mddev)
+{
+	int chunksect;
+	raid5_conf_t *conf;
+
+	if (mddev->raid_disks != 2 ||
+	    mddev->degraded > 1)
+		return ERR_PTR(-EINVAL);
+
+	/* Should check if there are write-behind devices? */
+
+	chunksect = 64*2; /* 64K by default */
+
+	/* The array must be an exact multiple of chunksize */
+	while (chunksect && (mddev->array_sectors & (chunksect-1)))
+		chunksect >>= 1;
+
+	if ((chunksect<<9) < STRIPE_SIZE)
+		/* array size does not allow a suitable chunk size */
+		return ERR_PTR(-EINVAL);
+
+	conf = setup_conf(mddev, 2, 5, ALGORITHM_LEFT_SYMMETRIC,
+			  chunksect << 9);
+	if (IS_ERR(conf))
+		return conf;
+
+	conf->thread = md_register_thread(raid5d, mddev, "%s_raid5");
+	if (conf->thread)
+		return conf;
+
+	safe_put_page(conf->spare_page);
+	kfree(conf->disks);
+	kfree(conf->stripe_hashtbl);
+	kfree(conf);
+
+	return ERR_PTR(-ENOMEM);
+
+}
+
+static void *raid5_takeover(mddev_t *mddev)
+{
+	/* raid5 can take over:
+	 *  raid0 - if all devices are the same - make it a raid4 layout
+	 *  raid1 - if there are two drives.  We need to know the chunk size
+	 *  raid4 - trivial - just use a raid4 layout.
+	 *  raid6 - Providing it is a *_6 layout
+	 *
+	 * For now, just do raid1
+	 */
+
+	if (mddev->level == 1)
+		return raid5_takeover_raid1(mddev);
+
+	return ERR_PTR(-EINVAL);
+}
+
 static struct mdk_personality raid5_personality;
 
 static void *raid6_takeover(mddev_t *mddev)
@@ -4911,7 +4971,8 @@ static void *raid6_takeover(mddev_t *mddev)
 	default:
 		return ERR_PTR(-EINVAL);
 	}
-	conf = setup_conf(mddev, mddev->raid_disks + 1, 6, new_layout);
+	conf = setup_conf(mddev, mddev->raid_disks + 1, 6, new_layout,
+			  mddev->chunk_size);
 	if (IS_ERR(conf))
 		return conf;
 
@@ -4970,6 +5031,7 @@ static struct mdk_personality raid5_personality =
 	.start_reshape  = raid5_start_reshape,
 #endif
 	.quiesce	= raid5_quiesce,
+	.takeover	= raid5_takeover,
 };
 
 static struct mdk_personality raid4_personality =


