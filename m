From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 18 of 27 - when writing superblock, generate from mddev/rdev info.
Date: Thu, 18 Jul 2002 23:33:51 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133351.4955@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
when writing superblock, generate from mddev/rdev info.

Rather than relying on the superblock info being kept up-to-date,
we regenerate the superblock from mddev/rdev info before
each write.




 ----------- Diffstat output ------------
 ./drivers/md/md.c |   83 ++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 56 insertions(+), 27 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:06:02	1.11
+++ ./drivers/md/md.c	2002/07/18 12:06:12	1.12
@@ -860,44 +860,73 @@ fail:
 	return 1;
 }
 
-static void set_this_disk(mddev_t *mddev, mdk_rdev_t *rdev)
-{
-	int i, ok = 0;
-	mdp_disk_t *desc;
-
-	for (i = 0; i < MD_SB_DISKS; i++) {
-		desc = mddev->sb->disks + i;
-#if 0
-		if (disk_faulty(desc)) {
-			if (mk_kdev(desc->major,desc->minor) == rdev->dev)
-				ok = 1;
-			continue;
-		}
-#endif
-		if (kdev_same(mk_kdev(desc->major,desc->minor), rdev->dev)) {
-			rdev->sb->this_disk = *desc;
-			ok = 1;
-			break;
-		}
-	}
-
-	if (!ok) {
-		MD_BUG();
-	}
-}
-
 static int sync_sbs(mddev_t * mddev)
 {
 	mdk_rdev_t *rdev;
 	mdp_super_t *sb;
 	struct list_head *tmp;
 
+	/* make sb->disks match mddev->disks 
+	 * 1/ zero out disks
+	 * 2/ Add info for each disk, keeping track of highest desc_nr
+	 * 3/ any empty disks < highest become removed
+	 *
+	 * disks[0] gets initialised to REMOVED because
+	 * we cannot be sure from other fields if it has
+	 * been initialised or not.
+	 */
+	int highest = 0;
+	int i;
+	int active=0, working=0,failed=0,spare=0,nr_disks=0;
+
+	sb = mddev->sb;
+
+	sb->disks[0].state = (1<<MD_DISK_REMOVED);
+	ITERATE_RDEV(mddev,rdev,tmp) {
+		mdp_disk_t *d = &sb->disks[rdev->desc_nr];
+		nr_disks++;
+		d->number = rdev->desc_nr;
+		d->major = major(rdev->dev);
+		d->minor = minor(rdev->dev);
+		d->raid_disk = rdev->raid_disk;
+		if (rdev->faulty) {
+			d->state = (1<<MD_DISK_FAULTY);
+			failed++;
+		} else if (rdev->in_sync) {
+			d->state = (1<<MD_DISK_ACTIVE);
+			d->state |= (1<<MD_DISK_SYNC);
+			active++;
+			working++;
+		} else {
+			d->state = 0;
+			spare++;
+			working++;
+		}
+		if (rdev->desc_nr > highest)
+			highest = rdev->desc_nr;
+	}
+	
+	/* now set the "removed" bit on any non-trailing holes */
+	for (i=0; i<highest; i++) {
+		mdp_disk_t *d = &sb->disks[i];
+		if (d->state == 0 && d->number == 0) {
+			d->number = i;
+			d->raid_disk = i;
+			d->state = (1<<MD_DISK_REMOVED);
+		}
+	}
+	sb->nr_disks = nr_disks;
+	sb->active_disks = active;
+	sb->working_disks = working;
+	sb->failed_disks = failed;
+	sb->spare_disks = spare;
+
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		if (rdev->faulty || rdev->alias_device)
 			continue;
 		sb = rdev->sb;
 		*sb = *mddev->sb;
-		set_this_disk(mddev, rdev);
+		sb->this_disk = sb->disks[rdev->desc_nr];
 		sb->sb_csum = calc_sb_csum(sb);
 	}
 	return 0;
