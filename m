From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 3 - Don't check a device size before bd_get in md.c
Date: Thu, 13 Mar 2003 12:00:10 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18tH4s-0008ID-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Lars Marowsky-Bree <lmb@suse.de> noted that we shouldn't
be using blk_size for a device before calling bd_get.
This code rearrangement fixes this little issue.


 ----------- Diffstat output ------------
 ./drivers/md/md.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-13 10:47:13.000000000 +1100
+++ ./drivers/md/md.c	2003-03-13 11:46:25.000000000 +1100
@@ -2395,13 +2395,6 @@ static int hot_add_disk(mddev_t * mddev,
 	}
 
 	persistent = !mddev->sb->not_persistent;
-	size = calc_dev_size(dev, mddev, persistent);
-
-	if (size < mddev->sb->size) {
-		printk(KERN_WARNING "md%d: disk size %d blocks < array size %d\n",
-				mdidx(mddev), size, mddev->sb->size);
-		return -ENOSPC;
-	}
 
 	rdev = find_rdev(mddev, dev);
 	if (rdev)
@@ -2423,6 +2416,14 @@ static int hot_add_disk(mddev_t * mddev,
 		err = -EINVAL;
 		goto abort_export;
 	}
+	size = calc_dev_size(dev, mddev, persistent);
+
+	if (size < mddev->sb->size) {
+		printk(KERN_WARNING "md%d: disk size %d blocks < array size %d\n",
+				mdidx(mddev), size, mddev->sb->size);
+		err = -ENOSPC;
+		gotot abort_export;
+	}
 	bind_rdev_to_array(rdev, mddev);
 
 	/*
