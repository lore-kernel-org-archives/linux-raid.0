From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 13 - Silence a warning in md.c
Date: Thu, 22 Aug 2002 10:33:56 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E17hfvA-0004zw-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

->major_name is "const char *" so we need to sprintf into the kmalloced
space *before* assigning that space to ->major_name.


 ----------- Diffstat output ------------
 ./drivers/md/md.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

--- ./drivers/md/md.c	2002/08/21 22:54:36	1.4
+++ ./drivers/md/md.c	2002/08/21 23:00:33	1.5
@@ -1345,6 +1345,8 @@ static int do_md_run(mddev_t * mddev)
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
 	struct gendisk *disk;
+	char *major_name;
+
 
 	if (list_empty(&mddev->disks)) {
 		MD_BUG();
@@ -1454,15 +1456,16 @@ static int do_md_run(mddev_t * mddev)
 	if (!disk)
 		return -ENOMEM;
 	memset(disk, 0, sizeof(struct gendisk));
-	disk->major_name = kmalloc(6, GFP_KERNEL);
-	if (!disk->major_name) {
+	major_name = kmalloc(6, GFP_KERNEL);
+	if (!major_name) {
 		kfree(disk);
 		return -ENOMEM;
 	}
 	disk->major = MD_MAJOR;
 	disk->first_minor = mdidx(mddev);
 	disk->minor_shift = 0;
-	sprintf(disk->major_name, "md%d", mdidx(mddev));
+	sprintf(major_name, "md%d", mdidx(mddev));
+	disk->major_name = major_name;
 	disk->part = md_hd_struct + mdidx(mddev);
 	disk->nr_real = 1;
 	disk->fops = &md_fops;
