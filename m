From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 4 - Set max_sectors for raid0 only, not for all raid levels.
Date: Tue, 26 Aug 2003 09:26:07 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19rQit-0002By-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet
raid1 and multipath have not concept of a chunksize, so basing
max_sectors on it is obviously wrong.
Similary 'linear' has a very different concept of chunksize and
max_sectors doesn't apply.
raid5 does have relevant chunk_size concept, but it has code to
effectively handle any chunksize.  

So we only need to set max_sectors based on chunk_size in raid0.

 ----------- Diffstat output ------------
 ./drivers/md/md.c    |    6 ------
 ./drivers/md/raid0.c |    7 +++++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-08-24 08:07:12.000000000 +1000
+++ ./drivers/md/md.c	2003-08-24 08:07:18.000000000 +1000
@@ -1610,12 +1610,6 @@ static int do_md_run(mddev_t * mddev)
 	spin_unlock(&pers_lock);
 
 	blk_queue_make_request(mddev->queue, mddev->pers->make_request);
-	printk("%s: setting max_sectors to %d, segment boundary to %d\n",
-		disk->disk_name,
-		chunk_size >> 9,
-		(chunk_size>>1)-1);
-	blk_queue_max_sectors(mddev->queue, chunk_size >> 9);
-	blk_queue_segment_boundary(mddev->queue, (chunk_size>>1) - 1);
 	mddev->queue->queuedata = mddev;
 
 	err = mddev->pers->run(mddev);

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-08-24 07:03:43.000000000 +1000
+++ ./drivers/md/raid0.c	2003-08-24 08:07:18.000000000 +1000
@@ -231,6 +231,13 @@ static int raid0_run (mddev_t *mddev)
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
 
+	printk("md%d: setting max_sectors to %d, segment boundary to %d\n",
+	       mdidx(mddev),
+	       mddev->chunk_size >> 9,
+	       (mddev->chunk_size>>1)-1);
+	blk_queue_max_sectors(mddev->queue, mddev->chunk_size >> 9);
+	blk_queue_segment_boundary(mddev->queue, (mddev->chunk_size>>1) - 1);
+
 	conf = kmalloc(sizeof (raid0_conf_t), GFP_KERNEL);
 	if (!conf)
 		goto out;
