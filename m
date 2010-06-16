From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 3/3] md: fix invalid dev slots after takeover
Date: Wed, 16 Jun 2010 14:40:08 +1000
Message-ID: <20100616144008.5b404e54@notabene.brown>
References: <BE2BFE91933D1B4089447C64486040801E8734B6@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040801E8734B6@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Trela, Maciej" <Maciej.Trela@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Tue, 15 Jun 2010 09:36:36 +0100
"Trela, Maciej" <Maciej.Trela@intel.com> wrote:

> From: Maciej Trela <maciej.trela@intel.com>
> 
> While raid10->raid0 takeover incorrect slot numbers are set for raid0. This was caused by invalidating dev slot numbers before calling pers->run(). We are invalidating all devs that has (rdev->raid_disk >= mddev->raid_disks) but rdev->raid_disk numbers are scaled in pers->run().
> 
> Another option to fix the problem:
> If invalidating devs should rather be performed before run() we could use devlist[index] for invalidating - devlist is already updated after calling takeover...

Thanks.  I see the problem but don't really like the fix.

I propose the following (Which includes the 2/3 patch - all part of the same
big problem really).

By the way, your patches were missing signed-off-by lines.

Thanks,
NeilBrown

commit f0cbbf52b705fc412af11d1aa3ba852d0e184fd5
Author: NeilBrown <neilb@suse.de>
Date:   Tue Jun 15 09:36:03 2010 +0100

    md: fix handling of array level takeover that re-arranges devices.
    
    Most array level changes leave the list of devices largely unchanged,
    possibly causing one at the end to become redundant.
    However conversions between RAID0 and RAID10 need to renumber
    all devices (except 0).
    
    This renumbering is currently being done in the ->run method when the
    new personality takes over.  However this is too late as the common
    code in md.c might already have invalidated some of the devices if
    they had a ->raid_disk number that appeared to high.
    
    Moving it into the ->takeover method is too early as the array is
    still active at that time and wrong ->raid_disk numbers could cause
    confusion.
    
    So add a ->new_raid_disk field to mdk_rdev_s and use it to communicate
    the new raid_disk number.
    Now the common code knows exactly which devices need to be renumbered,
    and which can be invalidated, and can do it all at a convenient time
    when the array is suspend.
    It can also update some symlinks in sysfs which previously were not be
    updated correctly.
    
    Reported-by: Maciej Trela <maciej.trela@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4edcda8..4869128 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3001,6 +3001,9 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 		return -EINVAL;
 	}
 
+	list_for_each_entry(rdev, &mddev->disks, same_set)
+		rdev->new_raid_disk = rdev->raid_disk;
+
 	/* ->takeover must set new_* and/or delta_disks
 	 * if it succeeds, and may set them when it fails.
 	 */
@@ -3051,13 +3054,35 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 		mddev->safemode = 0;
 	}
 
-	module_put(mddev->pers->owner);
-	/* Invalidate devices that are now superfluous */
-	list_for_each_entry(rdev, &mddev->disks, same_set)
-		if (rdev->raid_disk >= mddev->raid_disks) {
-			rdev->raid_disk = -1;
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		char nm[20];
+		if (rdev->raid_disk < 0)
+			continue;
+		if (rdev->new_raid_disk > mddev->raid_disks)
+			rdev->new_raid_disk = -1;
+		if (rdev->new_raid_disk == rdev->raid_disk)
+			continue;
+		sprintf(nm, "rd%d", rdev->raid_disk);
+		sysfs_remove_link(&mddev->kobj, nm);
+	}
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		if (rdev->raid_disk < 0)
+			continue;
+		if (rdev->new_raid_disk == rdev->raid_disk)
+			continue;
+		rdev->raid_disk = rdev->new_raid_disk;
+		if (rdev->raid_disk < 0)
 			clear_bit(In_sync, &rdev->flags);
+		else {
+			char nm[20];
+			sprintf(nm, "rd%d", rdev->raid_disk);
+			if(sysfs_create_link(&mddev->kobj, &rdev->kobj, nm))
+				printk("md: cannot register %s for %s after level change\n",
+				       nm, mdname(mddev));
 		}
+	}
+
+	module_put(mddev->pers->owner);
 	mddev->pers = pers;
 	mddev->private = priv;
 	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7ab5ea1..10597bf 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -78,6 +78,9 @@ struct mdk_rdev_s
 
 	int desc_nr;			/* descriptor index in the superblock */
 	int raid_disk;			/* role of device in array */
+	int new_raid_disk;		/* role that the device will have in
+					 * the array after a level-change completes.
+					 */
 	int saved_raid_disk;		/* role that device used to have in the
 					 * array and could again if we did a partial
 					 * resync from the bitmap
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e70f004..7c7c380 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -173,9 +173,11 @@ static int create_strip_zones(mddev_t *mddev, raid0_conf_t **private_conf)
 	list_for_each_entry(rdev1, &mddev->disks, same_set) {
 		int j = rdev1->raid_disk;
 
-		if (mddev->level == 10)
+		if (mddev->level == 10) {
 			/* taking over a raid10-n2 array */
 			j /= 2;
+			rdev1->new_raid_disk = j;
+		}
 
 		if (j < 0 || j >= mddev->raid_disks) {
 			printk(KERN_ERR "md/raid0:%s: bad disk number %d - "
@@ -361,12 +363,6 @@ static int raid0_run(mddev_t *mddev)
 		mddev->private = conf;
 	}
 	conf = mddev->private;
-	if (conf->scale_raid_disks) {
-		int i;
-		for (i=0; i < conf->strip_zone[0].nb_dev; i++)
-			conf->devlist[i]->raid_disk /= conf->scale_raid_disks;
-		/* FIXME update sysfs rd links */
-	}
 
 	/* calculate array device size */
 	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
@@ -643,7 +639,6 @@ static void *raid0_takeover_raid10(mddev_t *mddev)
 	mddev->recovery_cp = MaxSector;
 
 	create_strip_zones(mddev, &priv_conf);
-	priv_conf->scale_raid_disks = 2;
 	return priv_conf;
 }
 
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index d724e66..91f8e87 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -13,9 +13,6 @@ struct raid0_private_data
 	struct strip_zone *strip_zone;
 	mdk_rdev_t **devlist; /* lists of rdevs, pointed to by strip_zone->dev */
 	int nr_strip_zones;
-	int scale_raid_disks; /* divide rdev->raid_disks by this in run()
-			       * to handle conversion from raid10
-			       */
 };
 
 typedef struct raid0_private_data raid0_conf_t;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0372499..9f65dc5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2241,7 +2241,6 @@ static conf_t *setup_conf(mddev_t *mddev)
 	if (!conf->thread)
 		goto out;
 
-	conf->scale_disks = 0;
 	conf->mddev = mddev;
 	return conf;
 
@@ -2300,11 +2299,6 @@ static int run(mddev_t *mddev)
 		if (disk_idx >= conf->raid_disks
 		    || disk_idx < 0)
 			continue;
-		if (conf->scale_disks) {
-			disk_idx *= conf->scale_disks;
-			rdev->raid_disk = disk_idx;
-			/* MOVE 'rd%d' link !! */
-		}
 		disk = conf->mirrors + disk_idx;
 
 		disk->rdev = rdev;
@@ -2435,13 +2429,6 @@ static void *raid10_takeover_raid0(mddev_t *mddev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	/* Update slot numbers to obtain
-	 * degraded raid10 with missing mirrors
-	 */
-	list_for_each_entry(rdev, &mddev->disks, same_set) {
-		rdev->raid_disk *= 2;
-	}
-
 	/* Set new parameters */
 	mddev->new_level = 10;
 	/* new layout: far_copies = 1, near_copies = 2 */
@@ -2454,7 +2441,11 @@ static void *raid10_takeover_raid0(mddev_t *mddev)
 	mddev->recovery_cp = MaxSector;
 
 	conf = setup_conf(mddev);
-	conf->scale_disks = 2;
+	if (!IS_ERR(conf))
+		list_for_each_entry(rdev, &mddev->disks, same_set)
+			if (rdev->raid_disk >= 0)
+				rdev->new_raid_disk = rdev->raid_disk * 2;
+		
 	return conf;
 }
 
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 3824a08..2316ac2 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -38,11 +38,6 @@ struct r10_private_data_s {
 	int chunk_shift; /* shift from chunks to sectors */
 	sector_t chunk_mask;
 
-	int			scale_disks;  /* When starting array, multiply
-					       * each ->raid_disk by this.
-					       * Need for raid0->raid10 migration
-					       */
-
 	struct list_head	retry_list;
 	/* queue pending writes and submit them on unplug */
 	struct bio_list		pending_bio_list;
