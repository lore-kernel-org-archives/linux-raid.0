From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 13 of 13 - Fix up oops-able error message
Date: Thu, 22 Aug 2002 10:34:29 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E17hfvh-00050o-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

If we get here, then bio->bi_bdev isn't set, so we really
shouldn't de-reference it.


 ----------- Diffstat output ------------
 ./drivers/md/raid1.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- ./drivers/md/raid1.c	2002/08/21 23:14:39	1.7
+++ ./drivers/md/raid1.c	2002/08/21 23:20:40	1.8
@@ -866,7 +866,7 @@ static void sync_request_write(mddev_t *
 		 * Nowhere to write this to... I guess we
 		 * must be done
 		 */
-		printk(IO_ERROR, bdev_partition_name(bio->bi_bdev), r1_bio->sector);
+		printk(KERN_ALERT "raid1: sync aborting as there is nowhere to write sector %lu\n", r1_bio->sector);
 		md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, 0);
 		resume_device(conf);
 		put_buf(r1_bio);
