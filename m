From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 005 of 18] Fix --re-add for raid1 and raid6
Date: Mon, 28 Nov 2005 10:40:01 +1100
Message-ID: <1051127234001.14793@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


If you have an array with a write-intent-bitmap, and you remove a device,
then re-add it, a full recovery isn't needed.  We detect a re-add by looking
at saved_raid_disk.  For raid1, it doesn't matter which disk it was, only
whether or not it was an active device.
The old code being removed set a value of 'mirror' which was then ignored, 
so it can go.  The changed code performs the correct check.

For raid6, if there are two missing devices, make sure we chose the right
slot on --re-add rather than always the first slot.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c     |    8 ++++----
 ./drivers/md/raid6main.c |   10 ++++++++--
 2 files changed, 12 insertions(+), 6 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-11-28 10:08:19.000000000 +1100
+++ ./drivers/md/raid1.c	2005-11-28 10:11:52.000000000 +1100
@@ -953,9 +953,6 @@ static int raid1_add_disk(mddev_t *mddev
 	int mirror = 0;
 	mirror_info_t *p;
 
-	if (rdev->saved_raid_disk >= 0 &&
-	    conf->mirrors[rdev->saved_raid_disk].rdev == NULL)
-		mirror = rdev->saved_raid_disk;
 	for (mirror=0; mirror < mddev->raid_disks; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 
@@ -972,7 +969,10 @@ static int raid1_add_disk(mddev_t *mddev
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
 			found = 1;
-			if (rdev->saved_raid_disk != mirror)
+			/* As all devices are equivalent, we don't need a full recovery
+			 * if this was recently any drive of the array
+			 */
+			if (rdev->saved_raid_disk < 0)
 				conf->fullsync = 1;
 			rcu_assign_pointer(p->rdev, rdev);
 			break;

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-11-28 10:09:27.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-11-28 10:11:52.000000000 +1100
@@ -2158,9 +2158,15 @@ static int raid6_add_disk(mddev_t *mddev
 		/* no point adding a device */
 		return 0;
 	/*
-	 * find the disk ...
+	 * find the disk ... but prefer rdev->saved_raid_disk
+	 * if possible.
 	 */
-	for (disk=0; disk < mddev->raid_disks; disk++)
+	if (rdev->saved_raid_disk >= 0 &&
+	    conf->disks[rdev->saved_raid_disk].rdev == NULL)
+		disk = rdev->saved_raid_disk;
+	else
+		disk = 0;
+	for ( ; disk < mddev->raid_disks; disk++)
 		if ((p=conf->disks + disk)->rdev == NULL) {
 			clear_bit(In_sync, &rdev->flags);
 			rdev->raid_disk = disk;
