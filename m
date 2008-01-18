From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 4] md: Set and test the ->persistent flag for md devices more consistently.
Date: Fri, 18 Jan 2008 22:02:30 +1100
Message-ID: <1080118110230.30467@suse.de>
References: <20080118215531.30136.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


If you try to start an array for which the number of raid disks is
listed as zero, md will currently try to read metadata off any devices
that have been given.  This was done because the value of raid_disks
is used to signal whether array details have been provided by
userspace (raid_disks > 0) or must be read from the devices
(raid_disks == 0).

However for an array without persistent metadata (or with externally
managed metadata) this is the wrong thing to do.  So we add a test in
do_md_run to give an error if raid_disks is zero for non-persistent
arrays.

This requires that mddev->persistent is set corrently at this point,
which it currently isn't for in-kernel autodetected arrays.

So set ->persistent for autodetect arrays, and remove the settign in
super_*_validate which is now redundant.

Also clear ->persistent when stopping an array so it is consistently
zero when starting an array.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-01-18 10:46:49.000000000 +1100
+++ ./drivers/md/md.c	2008-01-18 11:03:15.000000000 +1100
@@ -779,7 +779,6 @@ static int super_90_validate(mddev_t *md
 		mddev->major_version = 0;
 		mddev->minor_version = sb->minor_version;
 		mddev->patch_version = sb->patch_version;
-		mddev->persistent = 1;
 		mddev->external = 0;
 		mddev->chunk_size = sb->chunk_size;
 		mddev->ctime = sb->ctime;
@@ -1159,7 +1158,6 @@ static int super_1_validate(mddev_t *mdd
 	if (mddev->raid_disks == 0) {
 		mddev->major_version = 1;
 		mddev->patch_version = 0;
-		mddev->persistent = 1;
 		mddev->external = 0;
 		mddev->chunk_size = le32_to_cpu(sb->chunksize) << 9;
 		mddev->ctime = le64_to_cpu(sb->ctime) & ((1ULL << 32)-1);
@@ -3219,8 +3217,11 @@ static int do_md_run(mddev_t * mddev)
 	/*
 	 * Analyze all RAID superblock(s)
 	 */
-	if (!mddev->raid_disks)
+	if (!mddev->raid_disks) {
+		if (!mddev->persistent)
+			return -EINVAL;
 		analyze_sbs(mddev);
+	}
 
 	chunk_size = mddev->chunk_size;
 
@@ -3627,6 +3628,7 @@ static int do_md_stop(mddev_t * mddev, i
 		mddev->resync_max = MaxSector;
 		mddev->reshape_position = MaxSector;
 		mddev->external = 0;
+		mddev->persistent = 0;
 
 	} else if (mddev->pers)
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
@@ -3735,6 +3737,7 @@ static void autorun_devices(int part)
 			mddev_unlock(mddev);
 		} else {
 			printk(KERN_INFO "md: created %s\n", mdname(mddev));
+			mddev->persistent = 1;
 			ITERATE_RDEV_GENERIC(candidates,rdev,tmp) {
 				list_del_init(&rdev->same_set);
 				if (bind_rdev_to_array(rdev, mddev))
