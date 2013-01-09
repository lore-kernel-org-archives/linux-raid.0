From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: re: md: raid1,10: Handle REQ_WRITE_SAME flag in write bios
Date: Tue, 8 Jan 2013 23:11:19 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1301082253320.25146@jlaw-desktop.mno.stratus.com>
References: <20130108134415.GA840@elgon.mountain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130108134415.GA840@elgon.mountain>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: Joe Lawrence <Joe.Lawrence@stratus.com>
List-Id: linux-raid.ids

On Tue, 8 Jan 2013, Dan Carpenter wrote:

> Hello Joe Lawrence,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch aa992f57bd76: "md: raid1,10: Handle REQ_WRITE_SAME flag in 
> write bios" from Dec 14, 2012, leads to the following Smatch 
> complaint:
> 
> drivers/md/raid10.c:3630 run()
> 	 error: we previously assumed 'mddev->queue' could be null (see line 3619)
> 
> drivers/md/raid10.c
>   3618		chunk_size = mddev->chunk_sectors << 9;
>   3619		if (mddev->queue) {
>                     ^^^^^^^^^^^^
> Old check.
> 
>   3620			blk_queue_max_discard_sectors(mddev->queue,
>   3621						      mddev->chunk_sectors);
>   3622			blk_queue_io_min(mddev->queue, chunk_size);
>   3623			if (conf->geo.raid_disks % conf->geo.near_copies)
>   3624				blk_queue_io_opt(mddev->queue, chunk_size * conf->geo.raid_disks);
>   3625			else
>   3626				blk_queue_io_opt(mddev->queue, chunk_size *
>   3627						 (conf->geo.raid_disks / conf->geo.near_copies));
>   3628		}
>   3629	
>   3630		blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
>                                                  ^^^^^^^^^^^^
> New dereference.
> 
>   3631		rdev_for_each(rdev, mddev) {
>   3632			long long diff;
> 
> regards,
> dan carpenter
> 

Hi Neil,

Here's a revised patch that should make the static checker happy.  If you 
prefer a second patch instead, let me know.

Regards,

-- Joe

From 414901de959ea1873187fa3fecf2f00b107d40e2 Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Tue, 8 Jan 2013 23:02:38 -0500
Subject: [PATCH 4/4] md: raid1,10: Handle REQ_WRITE_SAME flag in write bios

Set mddev queue's max_write_same_sectors to its chunk_sector value (before
disk_stack_limits merges the underlying disk limits.)  With that in place,
be sure to handle writes coming down from the block layer that have the
REQ_WRITE_SAME flag set.  That flag needs to be copied into any newly cloned
write bio.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/md/raid1.c  | 7 ++++++-
 drivers/md/raid10.c | 9 +++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d5bddfc..6e5d5a5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1000,6 +1000,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
 	const unsigned long do_discard = (bio->bi_rw
 					  & (REQ_DISCARD | REQ_SECURE));
+	const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
 	struct raid1_plug_cb *plug = NULL;
@@ -1301,7 +1302,8 @@ read_again:
 				   conf->mirrors[i].rdev->data_offset);
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = WRITE | do_flush_fua | do_sync | do_discard;
+		mbio->bi_rw =
+			WRITE | do_flush_fua | do_sync | do_discard | do_same;
 		mbio->bi_private = r1_bio;
 
 		atomic_inc(&r1_bio->remaining);
@@ -2818,6 +2820,9 @@ static int run(struct mddev *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
+	if (mddev->queue)
+		blk_queue_max_write_same_sectors(mddev->queue,
+						 mddev->chunk_sectors);
 	rdev_for_each(rdev, mddev) {
 		if (!mddev->gendisk)
 			continue;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 64d4824..1a74c12 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1105,6 +1105,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	const unsigned long do_fua = (bio->bi_rw & REQ_FUA);
 	const unsigned long do_discard = (bio->bi_rw
 					  & (REQ_DISCARD | REQ_SECURE));
+	const unsigned long do_same = (bio->bi_rw & REQ_WRITE_SAME);
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
@@ -1460,7 +1461,8 @@ retry_write:
 							      rdev));
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
-			mbio->bi_rw = WRITE | do_sync | do_fua | do_discard;
+			mbio->bi_rw =
+				WRITE | do_sync | do_fua | do_discard | do_same;
 			mbio->bi_private = r10_bio;
 
 			atomic_inc(&r10_bio->remaining);
@@ -1502,7 +1504,8 @@ retry_write:
 						   r10_bio, rdev));
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
-			mbio->bi_rw = WRITE | do_sync | do_fua | do_discard;
+			mbio->bi_rw =
+				WRITE | do_sync | do_fua | do_discard | do_same;
 			mbio->bi_private = r10_bio;
 
 			atomic_inc(&r10_bio->remaining);
@@ -3569,6 +3572,8 @@ static int run(struct mddev *mddev)
 	if (mddev->queue) {
 		blk_queue_max_discard_sectors(mddev->queue,
 					      mddev->chunk_sectors);
+		blk_queue_max_write_same_sectors(mddev->queue,
+						 mddev->chunk_sectors);
 		blk_queue_io_min(mddev->queue, chunk_size);
 		if (conf->geo.raid_disks % conf->geo.near_copies)
 			blk_queue_io_opt(mddev->queue, chunk_size * conf->geo.raid_disks);
-- 
1.7.11.7

