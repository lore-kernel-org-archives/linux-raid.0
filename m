From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 11 of 14 - Remove dependancy on MD_SB_DISKS from raid0
Date: Tue, 27 May 2003 13:01:14 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19KUiA-0003HT-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

Arrays with type-1 superblock can have more than
MD_SB_DISKS, so we remove the dependancy on that number from
raid0, replacing several fixed sized arrays with one
dynamically allocated array.

 ----------- Diffstat output ------------
 ./drivers/md/raid0.c         |   11 +++++++++++
 ./include/linux/raid/raid0.h |    5 +++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-05-27 11:58:26.000000000 +1000
+++ ./drivers/md/raid0.c	2003-05-27 11:58:28.000000000 +1000
@@ -80,6 +80,13 @@ static int create_strip_zones (mddev_t *
 				conf->nr_strip_zones, GFP_KERNEL);
 	if (!conf->strip_zone)
 		return 1;
+	conf->devlist = kmalloc(sizeof(mdk_rdev_t*)*
+				conf->nr_strip_zones*mddev->raid_disks,
+				GFP_KERNEL);
+	if (!conf->devlist) {
+		kfree(conf);
+		return 1;
+	}
 
 	memset(conf->strip_zone, 0,sizeof(struct strip_zone)*
 				   conf->nr_strip_zones);
@@ -89,6 +96,7 @@ static int create_strip_zones (mddev_t *
 	zone = &conf->strip_zone[0];
 	cnt = 0;
 	smallest = NULL;
+	zone->dev = conf->devlist;
 	ITERATE_RDEV(mddev, rdev1, tmp1) {
 		int j = rdev1->raid_disk;
 
@@ -122,6 +130,7 @@ static int create_strip_zones (mddev_t *
 	for (i = 1; i < conf->nr_strip_zones; i++)
 	{
 		zone = conf->strip_zone + i;
+		zone->dev = conf->strip_zone[i-1].dev + mddev->raid_disks;
 
 		printk("raid0: zone %d\n", i);
 		zone->dev_offset = current_offset;
@@ -181,6 +190,7 @@ static int create_strip_zones (mddev_t *
 	printk("raid0: done.\n");
 	return 0;
  abort:
+	kfree(conf->devlist);
 	kfree(conf->strip_zone);
 	return 1;
 }
@@ -288,6 +298,7 @@ out_free_zone_conf:
 	conf->strip_zone = NULL;
 
 out_free_conf:
+	kfree (conf->devlist);
 	kfree(conf);
 	mddev->private = NULL;
 out:

diff ./include/linux/raid/raid0.h~current~ ./include/linux/raid/raid0.h
--- ./include/linux/raid/raid0.h~current~	2003-05-27 11:58:26.000000000 +1000
+++ ./include/linux/raid/raid0.h	2003-05-27 11:58:28.000000000 +1000
@@ -8,14 +8,15 @@ struct strip_zone
 	sector_t zone_offset;	/* Zone offset in md_dev */
 	sector_t dev_offset;	/* Zone offset in real dev */
 	sector_t size;		/* Zone size */
-	int nb_dev;			/* # of devices attached to the zone */
-	mdk_rdev_t *dev[MD_SB_DISKS]; /* Devices attached to the zone */
+	int nb_dev;		/* # of devices attached to the zone */
+	mdk_rdev_t **dev;	/* Devices attached to the zone */
 };
 
 struct raid0_private_data
 {
 	struct strip_zone **hash_table; /* Table of indexes into strip_zone */
 	struct strip_zone *strip_zone;
+	mdk_rdev_t **devlist; /* lists of rdevs, pointed to by strip_zone->dev */
 	int nr_strip_zones;
 
 	sector_t hash_spacing;
