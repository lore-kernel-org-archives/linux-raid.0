From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/2] MD: change journal disk role to disk 0
Date: Wed, 16 Dec 2015 13:13:47 -0800
Message-ID: <2f750625c6c016754fabfab98b84e6f2719bb0e5.1450300354.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, neilb@suse.de
List-Id: linux-raid.ids

Neil pointed out setting journal disk role to raid_disks will confuse
reshape if we support reshape eventually. Switching the role to 0 (we
should be fine as long as the value >=0) and skip sysfs file creation to
avoid error.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 2 +-
 drivers/md/md.h | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 807095f..874c843 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1652,7 +1652,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 			rdev->journal_tail = le64_to_cpu(sb->journal_tail);
 			if (mddev->recovery_cp == MaxSector)
 				set_bit(MD_JOURNAL_CLEAN, &mddev->flags);
-			rdev->raid_disk = mddev->raid_disks;
+			rdev->raid_disk = 0;
 			break;
 		default:
 			rdev->saved_raid_disk = role;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2bea51e..ca0b643 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -566,7 +566,9 @@ static inline char * mdname (struct mddev * mddev)
 static inline int sysfs_link_rdev(struct mddev *mddev, struct md_rdev *rdev)
 {
 	char nm[20];
-	if (!test_bit(Replacement, &rdev->flags) && mddev->kobj.sd) {
+	if (!test_bit(Replacement, &rdev->flags) &&
+	    !test_bit(Journal, &rdev->flags) &&
+	    mddev->kobj.sd) {
 		sprintf(nm, "rd%d", rdev->raid_disk);
 		return sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
 	} else
@@ -576,7 +578,9 @@ static inline int sysfs_link_rdev(struct mddev *mddev, struct md_rdev *rdev)
 static inline void sysfs_unlink_rdev(struct mddev *mddev, struct md_rdev *rdev)
 {
 	char nm[20];
-	if (!test_bit(Replacement, &rdev->flags) && mddev->kobj.sd) {
+	if (!test_bit(Replacement, &rdev->flags) &&
+	    !test_bit(Journal, &rdev->flags) &&
+	    mddev->kobj.sd) {
 		sprintf(nm, "rd%d", rdev->raid_disk);
 		sysfs_remove_link(&mddev->kobj, nm);
 	}
-- 
2.4.6

