From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 4 of 4 - Fix md superblock incompatabilities with 2.4 kernels.
Date: Tue, 26 Aug 2003 09:26:08 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19rQiu-0002C7-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

2.4 kernels are very fussy about some values in the superblock, and
2.6 got them wrong.  This fixes it.


 ----------- Diffstat output ------------
 ./drivers/md/md.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-08-24 08:07:18.000000000 +1000
+++ ./drivers/md/md.c	2003-08-26 09:11:39.000000000 +1000
@@ -638,14 +638,13 @@ static void super_90_sync(mddev_t *mddev
 	/* make rdev->sb match mddev data..
 	 *
 	 * 1/ zero out disks
-	 * 2/ Add info for each disk, keeping track of highest desc_nr
-	 * 3/ any empty disks < highest become removed
+	 * 2/ Add info for each disk, keeping track of highest desc_nr (next_spare);
+	 * 3/ any empty disks < next_spare become removed
 	 *
 	 * disks[0] gets initialised to REMOVED because
 	 * we cannot be sure from other fields if it has
 	 * been initialised or not.
 	 */
-	int highest = 0;
 	int i;
 	int active=0, working=0,failed=0,spare=0,nr_disks=0;
 
@@ -716,17 +715,17 @@ static void super_90_sync(mddev_t *mddev
 			spare++;
 			working++;
 		}
-		if (rdev2->desc_nr > highest)
-			highest = rdev2->desc_nr;
 	}
 	
-	/* now set the "removed" bit on any non-trailing holes */
-	for (i=0; i<highest; i++) {
+	/* now set the "removed" and "faulty" bits on any missing devices */
+	for (i=0 ; i < mddev->raid_disks ; i++) {
 		mdp_disk_t *d = &sb->disks[i];
 		if (d->state == 0 && d->number == 0) {
 			d->number = i;
 			d->raid_disk = i;
 			d->state = (1<<MD_DISK_REMOVED);
+			d->state |= (1<<MD_DISK_FAULTY);
+			failed++;
 		}
 	}
 	sb->nr_disks = nr_disks;
