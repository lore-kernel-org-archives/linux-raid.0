From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 2 - Set ra_pages for raid0/raid5 devices properly.
Date: Fri, 21 Nov 2003 14:21:19 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AN1rD-0007ls-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet
stripe to be effective.  This patch sets ra_pages 
appropriately.

 ----------- Diffstat output ------------
 ./drivers/md/raid0.c |   16 ++++++++++++++++
 ./drivers/md/raid5.c |   10 ++++++++++
 2 files changed, 26 insertions(+)

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-11-21 14:10:24.000000000 +1100
+++ ./drivers/md/raid0.c	2003-11-21 14:15:45.000000000 +1100
@@ -311,6 +311,22 @@ static int raid0_run (mddev_t *mddev)
 		conf->hash_spacing++;
 	}
 
+	/* calculate the max read-ahead size.
+	 * For read-ahead of large files to be effective, we need to 
+	 * readahead at least a whole stripe. i.e. number of devices
+	 * multiplied by chunk size.
+	 * If an individual device has an ra_pages greater than the
+	 * chunk size, then we will not drive that device as hard as it
+	 * wants.  We consider this a configuration error: a larger
+	 * chunksize should be used in that case.
+	 */
+	{
+		int stripe = mddev->raid_disks * mddev->chunk_size / PAGE_CACHE_SIZE;
+		if (mddev->queue->backing_dev_info.ra_pages < stripe)
+			mddev->queue->backing_dev_info.ra_pages = stripe;
+	}
+
+
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	return 0;
 

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-11-21 13:59:18.000000000 +1100
+++ ./drivers/md/raid5.c	2003-11-21 14:16:52.000000000 +1100
@@ -1571,6 +1571,16 @@ memory = conf->max_nr_stripes * (sizeof(
 
 	print_raid5_conf(conf);
 
+	/* read-ahead size must cover a whole stripe, which is
+	 * (n-1) * chunksize where 'n' is the number of raid devices
+	 */
+	{
+		int stripe = (mddev->raid_disks-1) * mddev->chunk_size
+			/ PAGE_CACHE_SIZE;
+		if (mddev->queue->backing_dev_info.ra_pages < stripe)
+			mddev->queue->backing_dev_info.ra_pages = stripe;
+	}
+
 	/* Ok, everything is just fine now */
 	mddev->array_size =  mddev->size * (mddev->raid_disks - 1);
 	return 0;
