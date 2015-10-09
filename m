From: Shaohua Li <shli@fb.com>
Subject: [PATCH 8/9] MD: set journal disk ->raid_disk
Date: Thu, 8 Oct 2015 21:54:12 -0700
Message-ID: <1621ef103ff6112d33401f3122b917b8fc577d1c.1444360850.git.shli@fb.com>
References: <cover.1444360850.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1444360850.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Set journal disk ->raid_disk to >=0, I choose raid_disks + 1 instead of
0, because we already have a disk with ->raid_disk 0 and this causes
sysfs entry creation conflict. A lot of places assumes disk with
->raid_disk >=0 is normal raid disk, so we add check for journal disk.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c    | 27 ++++++++++++++++++++++-----
 drivers/md/raid5.c |  6 ++++--
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a8db2e2..59b38ef 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1650,6 +1650,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 			rdev->journal_tail = le64_to_cpu(sb->journal_tail);
 			if (mddev->recovery_cp == MaxSector)
 				set_bit(MD_JOURNAL_CLEAN, &mddev->flags);
+			rdev->raid_disk = mddev->raid_disks;
 			break;
 		default:
 			rdev->saved_raid_disk = role;
@@ -1719,7 +1720,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 		sb->feature_map = cpu_to_le32(MD_FEATURE_BITMAP_OFFSET);
 	}
 
-	if (rdev->raid_disk >= 0 &&
+	if (rdev->raid_disk >= 0 && !test_bit(Journal, &rdev->flags) &&
 	    !test_bit(In_sync, &rdev->flags)) {
 		sb->feature_map |=
 			cpu_to_le32(MD_FEATURE_RECOVERY_OFFSET);
@@ -2303,6 +2304,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	rdev_for_each(rdev, mddev) {
 		if (rdev->raid_disk >= 0 &&
 		    mddev->delta_disks >= 0 &&
+		    !test_bit(Journal, &rdev->flags) &&
 		    !test_bit(In_sync, &rdev->flags) &&
 		    mddev->curr_resync_completed > rdev->recovery_offset)
 				rdev->recovery_offset = mddev->curr_resync_completed;
@@ -2539,6 +2541,7 @@ state_show(struct md_rdev *rdev, char *page)
 		sep = ",";
 	}
 	if (!test_bit(Faulty, &flags) &&
+	    !test_bit(Journal, &flags) &&
 	    !test_bit(In_sync, &flags)) {
 		len += sprintf(page+len, "%sspare", sep);
 		sep = ",";
@@ -2622,7 +2625,8 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	} else if (cmd_match(buf, "insync") && rdev->raid_disk == -1) {
 		set_bit(In_sync, &rdev->flags);
 		err = 0;
-	} else if (cmd_match(buf, "-insync") && rdev->raid_disk >= 0) {
+	} else if (cmd_match(buf, "-insync") && rdev->raid_disk >= 0 &&
+		   !test_bit(Journal, &rdev->flags)) {
 		if (rdev->mddev->pers == NULL) {
 			clear_bit(In_sync, &rdev->flags);
 			rdev->saved_raid_disk = rdev->raid_disk;
@@ -2641,6 +2645,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		 * check if recovery is needed.
 		 */
 		if (rdev->raid_disk >= 0 &&
+		    !test_bit(Journal, &rdev->flags) &&
 		    !test_bit(Replacement, &rdev->flags))
 			set_bit(WantReplacement, &rdev->flags);
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
@@ -2718,7 +2723,9 @@ __ATTR(errors, S_IRUGO|S_IWUSR, errors_show, errors_store);
 static ssize_t
 slot_show(struct md_rdev *rdev, char *page)
 {
-	if (rdev->raid_disk < 0)
+	if (test_bit(Journal, &rdev->flags))
+		return sprintf(page, "journal\n");
+	else if (rdev->raid_disk < 0)
 		return sprintf(page, "none\n");
 	else
 		return sprintf(page, "%d\n", rdev->raid_disk);
@@ -2730,6 +2737,8 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 	int slot;
 	int err;
 
+	if (test_bit(Journal, &rdev->flags))
+		return -EBUSY;
 	if (strncmp(buf, "none", 4)==0)
 		slot = -1;
 	else {
@@ -2928,6 +2937,8 @@ rdev_size_store(struct md_rdev *rdev, const char *buf, size_t len)
 	sector_t oldsectors = rdev->sectors;
 	sector_t sectors;
 
+	if (test_bit(Journal, &rdev->flags))
+		return -EBUSY;
 	if (strict_blocks_to_sectors(buf, &sectors) < 0)
 		return -EINVAL;
 	if (rdev->data_offset != rdev->new_data_offset)
@@ -3290,7 +3301,9 @@ static void analyze_sbs(struct mddev *mddev)
 			rdev->desc_nr = i++;
 			rdev->raid_disk = rdev->desc_nr;
 			set_bit(In_sync, &rdev->flags);
-		} else if (rdev->raid_disk >= (mddev->raid_disks - min(0, mddev->delta_disks))) {
+		} else if (rdev->raid_disk >=
+			    (mddev->raid_disks - min(0, mddev->delta_disks)) &&
+			   !test_bit(Journal, &rdev->flags)) {
 			rdev->raid_disk = -1;
 			clear_bit(In_sync, &rdev->flags);
 		}
@@ -7805,6 +7818,7 @@ void md_do_sync(struct md_thread *thread)
 		rcu_read_lock();
 		rdev_for_each_rcu(rdev, mddev)
 			if (rdev->raid_disk >= 0 &&
+			    !test_bit(Journal, &rdev->flags) &&
 			    !test_bit(Faulty, &rdev->flags) &&
 			    !test_bit(In_sync, &rdev->flags) &&
 			    rdev->recovery_offset < j)
@@ -8026,6 +8040,7 @@ void md_do_sync(struct md_thread *thread)
 			rdev_for_each_rcu(rdev, mddev)
 				if (rdev->raid_disk >= 0 &&
 				    mddev->delta_disks >= 0 &&
+				    !test_bit(Journal, &rdev->flags) &&
 				    !test_bit(Faulty, &rdev->flags) &&
 				    !test_bit(In_sync, &rdev->flags) &&
 				    rdev->recovery_offset < mddev->curr_resync)
@@ -8066,7 +8081,8 @@ static int remove_and_add_spares(struct mddev *mddev,
 		    rdev->raid_disk >= 0 &&
 		    !test_bit(Blocked, &rdev->flags) &&
 		    (test_bit(Faulty, &rdev->flags) ||
-		     ! test_bit(In_sync, &rdev->flags)) &&
+		     (!test_bit(In_sync, &rdev->flags) &&
+		      !test_bit(Journal, &rdev->flags))) &&
 		    atomic_read(&rdev->nr_pending)==0) {
 			if (mddev->pers->hot_remove_disk(
 				    mddev, rdev) == 0) {
@@ -8088,6 +8104,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 			continue;
 		if (rdev->raid_disk >= 0 &&
 		    !test_bit(In_sync, &rdev->flags) &&
+		    !test_bit(Journal, &rdev->flags) &&
 		    !test_bit(Faulty, &rdev->flags))
 			spares++;
 		if (rdev->raid_disk >= 0)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8024cad..efbb5da 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6560,7 +6560,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	rdev_for_each(rdev, mddev) {
 		raid_disk = rdev->raid_disk;
 		if (raid_disk >= max_disks
-		    || raid_disk < 0)
+		    || raid_disk < 0 || test_bit(Journal, &rdev->flags))
 			continue;
 		disk = conf->disks + raid_disk;
 
@@ -6694,8 +6694,10 @@ static int run(struct mddev *mddev)
 	rdev_for_each(rdev, mddev) {
 		long long diff;
 
-		if (test_bit(Journal, &rdev->flags))
+		if (test_bit(Journal, &rdev->flags)) {
 			journal_dev = rdev;
+			continue;
+		}
 		if (rdev->raid_disk < 0)
 			continue;
 		diff = (rdev->new_data_offset - rdev->data_offset);
-- 
2.4.6

