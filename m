From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: Re: MD Raid1, ext4 and write same
Date: Mon, 10 Dec 2012 18:10:35 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1212101748190.30895@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1212101704450.30895@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1212101704450.30895@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>
List-Id: linux-raid.ids

First potential patch... clear mddev->gendisk->queue's 
max_write_same_sectors to stop block from sending these cmds...

From 2607192fe0b8de266c86943b5c5a469e9f7a0e71 Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Mon, 10 Dec 2012 14:21:29 -0500
Subject: [PATCH] MD Raid1 allows WRITE SAME cmds it doesn't currently handle

The MD Raid1 code calls disk_stack_limits to merge limits for its top level
gendisk with each bottom level block device.  Since blk_set_stacking_limits
sets the initial max_write_same_sectors to UINT_MAX, disk_stack_limits will
settle on the lowest value of max_write_same_sectors across the underlying
block devices.  If this happens to be non-zero, the block layer will pass bios
with REQ_WRITE_SAME set.  The MD Raid1 code does not appear to handle this
flag so explicitly turn off WRITE SAME by zeroing the top level MD device
max_write_same_sectors.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/md/raid1.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 636bae0..0820f4e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1516,6 +1516,8 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		p = conf->mirrors+mirror;
 		if (!p->rdev) {
 
+			/* MD Raid1 doesn't support WRITE SAME. */
+			blk_queue_max_write_same_sectors(mddev->gendisk->queue, 0);
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
 
@@ -2822,6 +2824,8 @@ static int run(struct mddev *mddev)
 	rdev_for_each(rdev, mddev) {
 		if (!mddev->gendisk)
 			continue;
+		/* MD Raid1 doesn't support WRITE SAME. */
+		blk_queue_max_write_same_sectors(mddev->gendisk->queue, 0);
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
 		if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
-- 
1.7.11.7

