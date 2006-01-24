From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 5] md: Don't remove bitmap from md array when switching to read-only
Date: Tue, 24 Jan 2006 14:58:32 +1100
Message-ID: <1060124035832.28836@suse.de>
References: <20060124145516.28734.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Reuben Farrelly <reuben-lkml@reub.net>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


While a read-only array doesn't not really need a bitmap, we should
not remove the bitmap when switching an array to read-only because
 a/ There is no code to re-add the bitmap which switching to read-write,
 b/ There is insufficient locking - the bitmap could be accessed while it is
    being removed.

cc: Reuben Farrelly <reuben-lkml@reub.net>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-01-24 13:42:29.000000000 +1100
+++ ./drivers/md/md.c	2006-01-24 14:47:17.000000000 +1100
@@ -2690,14 +2690,6 @@ static int do_md_stop(mddev_t * mddev, i
 			set_disk_ro(disk, 1);
 	}
 
-	bitmap_destroy(mddev);
-	if (mddev->bitmap_file) {
-		atomic_set(&mddev->bitmap_file->f_dentry->d_inode->i_writecount, 1);
-		fput(mddev->bitmap_file);
-		mddev->bitmap_file = NULL;
-	}
-	mddev->bitmap_offset = 0;
-
 	/*
 	 * Free resources if final stop
 	 */
@@ -2707,6 +2699,14 @@ static int do_md_stop(mddev_t * mddev, i
 		struct gendisk *disk;
 		printk(KERN_INFO "md: %s stopped.\n", mdname(mddev));
 
+		bitmap_destroy(mddev);
+		if (mddev->bitmap_file) {
+			atomic_set(&mddev->bitmap_file->f_dentry->d_inode->i_writecount, 1);
+			fput(mddev->bitmap_file);
+			mddev->bitmap_file = NULL;
+		}
+		mddev->bitmap_offset = 0;
+
 		ITERATE_RDEV(mddev,rdev,tmp)
 			if (rdev->raid_disk >= 0) {
 				char nm[20];
