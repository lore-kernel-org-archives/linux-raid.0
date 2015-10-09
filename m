From: Shaohua Li <shli@fb.com>
Subject: [PATCH 5/9] MD: add new bit to indicate raid array with journal
Date: Thu, 8 Oct 2015 21:54:09 -0700
Message-ID: <70565ff884e0b85f0bcfaa7c731973377f07bf75.1444360850.git.shli@fb.com>
References: <cover.1444360850.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1444360850.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

From: Song Liu <songliubraving@fb.com>

If a raid array has journal feature bit set, add a new bit to indicate
this. If the array is started without journal disk existing, we know
there is something wrong.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 10 +++++++---
 drivers/md/md.h |  1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index daf42bb..a5b0bbd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1667,6 +1667,8 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 			set_bit(WriteMostly, &rdev->flags);
 		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_REPLACEMENT)
 			set_bit(Replacement, &rdev->flags);
+		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_JOURNAL)
+			set_bit(MD_HAS_JOURNAL, &mddev->flags);
 	} else /* MULTIPATH are always insync */
 		set_bit(In_sync, &rdev->flags);
 
@@ -1807,16 +1809,18 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	for (i=0; i<max_dev;i++)
 		sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_FAULTY);
 
+	if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
+		sb->feature_map |= MD_FEATURE_JOURNAL;
+
 	rdev_for_each(rdev2, mddev) {
 		i = rdev2->desc_nr;
 		if (test_bit(Faulty, &rdev2->flags))
 			sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_FAULTY);
 		else if (test_bit(In_sync, &rdev2->flags))
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
-		else if (test_bit(Journal, &rdev2->flags)) {
+		else if (test_bit(Journal, &rdev2->flags))
 			sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_JOURNAL);
-			sb->feature_map |= cpu_to_le32(MD_FEATURE_JOURNAL);
-		} else if (rdev2->raid_disk >= 0)
+		else if (rdev2->raid_disk >= 0)
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
 		else
 			sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_SPARE);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index e14e667..2bea51e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -233,6 +233,7 @@ struct mddev {
 				 * md_ioctl checked on it.
 				 */
 #define MD_JOURNAL_CLEAN 5	/* A raid with journal is already clean */
+#define MD_HAS_JOURNAL	6	/* The raid array has journal feature set */
 
 	int				suspended;
 	atomic_t			active_io;
-- 
2.4.6

