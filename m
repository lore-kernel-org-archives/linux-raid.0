From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: [PATCH] md: raid1,10: Handle REQ_WRITE_SAME flag in write bios
Date: Fri, 14 Dec 2012 14:36:25 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1212141406480.30895@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, neilb@suse.de
List-Id: linux-raid.ids

Submitting patch for review... This sets the max_write_same_sectors for 
the mdev request queue to its chunk_sectors (before merging its member 
disk limits).  I believe this should keep the write same LBA sector count 
inside the write intent bitmap granularity, but I'm not sure if the sector 
range could cross bits and how could would be handled.  Any insight into 
the bitmap side of things would be appreciated.

Thanks,

-- Joe

From d31c4569b3883475f293403fa4eed63f107616bb Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Fri, 14 Dec 2012 11:25:27 -0500
Subject: [PATCH] md: raid1,10: Handle REQ_WRITE_SAME flag in write bios

Set mddev queue's max_write_same_sectors to its chunk_sector value (before
disk_stack_limits merges the underlying disk limits.)  With that in place,
be sure to handle writes coming down from the block layer that have the
REQ_WRITE_SAME flag set.  That flag needs to be copied into any newly cloned
write bio.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/md/raid1.c  | 5 ++++-
 drivers/md/raid10.c | 8 ++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a0f7309..c9ef213 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1001,6 +1001,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
 	const unsigned long do_discard = (bio->bi_rw
 					  & (REQ_DISCARD | REQ_SECURE));
+	const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
 	struct raid1_plug_cb *plug = NULL;
@@ -1302,7 +1303,8 @@ read_again:
 				   conf->mirrors[i].rdev->data_offset);
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = WRITE | do_flush_fua | do_sync | do_discard;
+		mbio->bi_rw =
+			WRITE | do_flush_fua | do_sync | do_discard | do_same;
 		mbio->bi_private = r1_bio;
 
 		atomic_inc(&r1_bio->remaining);
@@ -2819,6 +2821,7 @@ static int run(struct mddev *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
+	blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
 	rdev_for_each(rdev, mddev) {
 		if (!mddev->gendisk)
 			continue;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c9acbd7..3d77a92 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1106,6 +1106,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	const unsigned long do_fua = (bio->bi_rw & REQ_FUA);
 	const unsigned long do_discard = (bio->bi_rw
 					  & (REQ_DISCARD | REQ_SECURE));
+	const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
@@ -1461,7 +1462,8 @@ retry_write:
 							      rdev));
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
-			mbio->bi_rw = WRITE | do_sync | do_fua | do_discard;
+			mbio->bi_rw =
+				WRITE | do_sync | do_fua | do_discard | do_same;
 			mbio->bi_private = r10_bio;
 
 			atomic_inc(&r10_bio->remaining);
@@ -1503,7 +1505,8 @@ retry_write:
 						   r10_bio, rdev));
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
-			mbio->bi_rw = WRITE | do_sync | do_fua | do_discard;
+			mbio->bi_rw =
+				WRITE | do_sync | do_fua | do_discard | do_same;
 			mbio->bi_private = r10_bio;
 
 			atomic_inc(&r10_bio->remaining);
@@ -3578,6 +3581,7 @@ static int run(struct mddev *mddev)
 					 (conf->geo.raid_disks / conf->geo.near_copies));
 	}
 
+	blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
 	rdev_for_each(rdev, mddev) {
 		long long diff;
 		struct request_queue *q;
-- 
1.7.11.7

