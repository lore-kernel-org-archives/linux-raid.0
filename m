From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 9 of 9] Optimise reconstruction when re-adding a recently failed drive.
Date: Fri, 18 Feb 2005 11:40:44 +1100
Message-ID: <E1D1wCK-0000Xe-Qm@notabene.cse.unsw.edu.au>
References: <20050218111131.790.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When an array is degraded, bit in the intent-bitmap are
never cleared. So if a recently failed drive is re-added, we only need
to reconstruct the block that are still reflected in the
bitmap.
This patch adds support for this re-adding.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c           |   71 ++++++++++++++++++++++++++++++++++----------
 ./drivers/md/raid1.c        |    7 +++-
 ./include/linux/raid/md_k.h |    4 ++
 3 files changed, 65 insertions(+), 17 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-02-18 11:11:26.000000000 +1100
+++ ./drivers/md/md.c	2005-02-18 11:11:26.000000000 +1100
@@ -620,6 +620,8 @@ static int super_90_validate(mddev_t *md
 	mdp_disk_t *desc;
 	mdp_super_t *sb = (mdp_super_t *)page_address(rdev->sb_page);
 
+	rdev->raid_disk = -1;
+	rdev->in_sync = 0;
 	if (mddev->raid_disks == 0) {
 		mddev->major_version = 0;
 		mddev->minor_version = sb->minor_version;
@@ -650,16 +652,24 @@ static int super_90_validate(mddev_t *md
 		memcpy(mddev->uuid+12,&sb->set_uuid3, 4);
 
 		mddev->max_disks = MD_SB_DISKS;
-	} else {
-		__u64 ev1;
-		ev1 = md_event(sb);
+	} else if (mddev->pers == NULL) {
+		/* Insist on good event counter while assembling */
+		__u64 ev1 = md_event(sb);
 		++ev1;
 		if (ev1 < mddev->events) 
 			return -EINVAL;
-	}
+	} else if (mddev->bitmap) {
+		/* if adding to array with a bitmap, then we can accept an
+		 * older device ... but not too old.
+		 */
+		__u64 ev1 = md_event(sb);
+		if (ev1 < mddev->bitmap->events_cleared)
+			return 0;
+	} else /* just a hot-add of a new device, leave raid_disk at -1 */
+		return 0;
+
 	if (mddev->level != LEVEL_MULTIPATH) {
-		rdev->raid_disk = -1;
-		rdev->in_sync = rdev->faulty = 0;
+		rdev->faulty = 0;
 		desc = sb->disks + rdev->desc_nr;
 
 		if (desc->state & (1<<MD_DISK_FAULTY))
@@ -669,7 +679,8 @@ static int super_90_validate(mddev_t *md
 			rdev->in_sync = 1;
 			rdev->raid_disk = desc->raid_disk;
 		}
-	}
+	} else /* MULTIPATH are always insync */
+		rdev->in_sync = 1;
 	return 0;
 }
 
@@ -911,6 +922,8 @@ static int super_1_validate(mddev_t *mdd
 {
 	struct mdp_superblock_1 *sb = (struct mdp_superblock_1*)page_address(rdev->sb_page);
 
+	rdev->raid_disk = -1;
+	rdev->in_sync = 0;
 	if (mddev->raid_disks == 0) {
 		mddev->major_version = 1;
 		mddev->patch_version = 0;
@@ -928,13 +941,21 @@ static int super_1_validate(mddev_t *mdd
 		memcpy(mddev->uuid, sb->set_uuid, 16);
 
 		mddev->max_disks =  (4096-256)/2;
-	} else {
-		__u64 ev1;
-		ev1 = le64_to_cpu(sb->events);
+	} else if (mddev->pers == NULL) {
+		/* Insist of good event counter while assembling */
+		__u64 ev1 = le64_to_cpu(sb->events);
 		++ev1;
 		if (ev1 < mddev->events)
 			return -EINVAL;
-	}
+	} else if (mddev->bitmap) {
+		/* If adding to array with a bitmap, then we can accept an
+		 * older device, but not too old.
+		 */
+		__u64 ev1 = le64_to_cpu(sb->events);
+		if (ev1 < mddev->bitmap->events_cleared)
+			return 0;
+	} else /* just a hot-add of a new device, leave raid_disk at -1 */
+		return 0;
 
 	if (mddev->level != LEVEL_MULTIPATH) {
 		int role;
@@ -942,14 +963,10 @@ static int super_1_validate(mddev_t *mdd
 		role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
 		switch(role) {
 		case 0xffff: /* spare */
-			rdev->in_sync = 0;
 			rdev->faulty = 0;
-			rdev->raid_disk = -1;
 			break;
 		case 0xfffe: /* faulty */
-			rdev->in_sync = 0;
 			rdev->faulty = 1;
-			rdev->raid_disk = -1;
 			break;
 		default:
 			rdev->in_sync = 1;
@@ -957,7 +974,9 @@ static int super_1_validate(mddev_t *mdd
 			rdev->raid_disk = role;
 			break;
 		}
-	}
+	} else /* MULTIPATH are always insync */
+		rdev->in_sync = 1;
+
 	return 0;
 }
 
@@ -2211,6 +2230,18 @@ static int add_new_disk(mddev_t * mddev,
 				PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
+		/* set save_raid_disk if appropriate */
+		if (!mddev->persistent) {
+			if (info->state & (1<<MD_DISK_SYNC)  &&
+			    info->raid_disk < mddev->raid_disks)
+				rdev->raid_disk = info->raid_disk;
+			else
+				rdev->raid_disk = -1;
+		} else
+			super_types[mddev->major_version].
+				validate_super(mddev, rdev);
+		rdev->saved_raid_disk = rdev->raid_disk;
+
 		rdev->in_sync = 0; /* just to be sure */
 		rdev->raid_disk = -1;
 		err = bind_rdev_to_array(rdev, mddev);
@@ -3829,6 +3860,14 @@ void md_check_recovery(mddev_t *mddev)
 				mddev->pers->spare_active(mddev);
 			}
 			md_update_sb(mddev);
+
+			/* if array is no-longer degraded, then any saved_raid_disk
+			 * information must be scrapped
+			 */
+			if (!mddev->degraded)
+				ITERATE_RDEV(mddev,rdev,rtmp)
+					rdev->saved_raid_disk = -1;
+			
 			mddev->recovery = 0;
 			/* flag recovery needed just to double check */
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-02-18 11:11:26.000000000 +1100
+++ ./drivers/md/raid1.c	2005-02-18 11:11:26.000000000 +1100
@@ -811,9 +811,12 @@ static int raid1_add_disk(mddev_t *mddev
 {
 	conf_t *conf = mddev->private;
 	int found = 0;
-	int mirror;
+	int mirror = 0;
 	mirror_info_t *p;
 
+	if (rdev->saved_raid_disk >= 0 &&
+	    conf->mirrors[rdev->saved_raid_disk].rdev == NULL)
+		mirror = rdev->saved_raid_disk;
 	for (mirror=0; mirror < mddev->raid_disks; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 
@@ -830,6 +833,8 @@ static int raid1_add_disk(mddev_t *mddev
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
 			found = 1;
+			if (rdev->saved_raid_disk != mirror)
+				conf->fullsync = 1;
 			p->rdev = rdev;
 			break;
 		}

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-02-18 11:11:26.000000000 +1100
+++ ./include/linux/raid/md_k.h	2005-02-18 11:11:26.000000000 +1100
@@ -183,6 +183,10 @@ struct mdk_rdev_s
 
 	int desc_nr;			/* descriptor index in the superblock */
 	int raid_disk;			/* role of device in array */
+	int saved_raid_disk;		/* role that device used to have in the 
+					 * array and could again if we did a partial
+					 * resync from the bitmap
+					 */
 
 	atomic_t	nr_pending;	/* number of pending requests.
 					 * only maintained for arrays that
