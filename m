From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 04/12] md: superblock changes for PPL
Date: Thu, 24 Nov 2016 13:28:39 +0100
Message-ID: <20161124122847.16456-5-artur.paszkiewicz@intel.com>
References: <20161124122847.16456-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161124122847.16456-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Include information about PPL location and size into mdp_superblock_1
and copy it to/from rdev. Because PPL is mutually exclusive with bitmap,
put it in place of 'bitmap_offset'. Add a new flag MD_FEATURE_PPL for
'feature_map', analogically to MD_FEATURE_BITMAP_OFFSET. Add MD_HAS_PPL
to mddev->flags to indicate that PPL is enabled on an array.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/md.c                | 14 ++++++++++++++
 drivers/md/md.h                |  8 ++++++++
 drivers/md/raid5.c             |  7 +++++++
 include/uapi/linux/raid/md_p.h | 18 ++++++++++++++----
 4 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4876687..7028d54 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1524,6 +1524,11 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	} else if (sb->bblog_offset != 0)
 		rdev->badblocks.shift = 0;
 
+	if (le32_to_cpu(sb->feature_map) & MD_FEATURE_PPL) {
+		rdev->ppl.offset = le16_to_cpu(sb->ppl.offset);
+		rdev->ppl.size = le16_to_cpu(sb->ppl.size);
+	}
+
 	if (!refdev) {
 		ret = 1;
 	} else {
@@ -1636,6 +1641,9 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 
 		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_JOURNAL)
 			set_bit(MD_HAS_JOURNAL, &mddev->flags);
+
+		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_PPL)
+			set_bit(MD_HAS_PPL, &mddev->flags);
 	} else if (mddev->pers == NULL) {
 		/* Insist of good event counter while assembling, except for
 		 * spares (which don't need an event count) */
@@ -1849,6 +1857,12 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
 		sb->feature_map |= cpu_to_le32(MD_FEATURE_JOURNAL);
 
+	if (test_bit(MD_HAS_PPL, &mddev->flags)) {
+		sb->feature_map |= cpu_to_le32(MD_FEATURE_PPL);
+		sb->ppl.offset = cpu_to_le16(rdev->ppl.offset);
+		sb->ppl.size = cpu_to_le16(rdev->ppl.size);
+	}
+
 	rdev_for_each(rdev2, mddev) {
 		i = rdev2->desc_nr;
 		if (test_bit(Faulty, &rdev2->flags))
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2fc75ac..d1e56f8 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -122,6 +122,13 @@ struct md_rdev {
 					   * sysfs entry */
 
 	struct badblocks badblocks;
+
+	struct {
+		unsigned int offset; /* Offset from superblock to start of PPL.
+				      * Not used by external metadata. */
+		unsigned int size;   /* Size in sectors of the PPL space */
+		sector_t sector;     /* First sector of the PPL space */
+	} ppl;
 };
 enum flag_bits {
 	Faulty,			/* device is known to have a fault */
@@ -235,6 +242,7 @@ enum mddev_flags {
 				 * never cause the array to become failed.
 				 */
 	MD_NEED_REWRITE,	/* metadata write needs to be repeated */
+	MD_HAS_PPL,		/* The raid array has PPL feature set */
 };
 #define MD_UPDATE_SB_FLAGS (BIT(MD_CHANGE_DEVS) | \
 			    BIT(MD_CHANGE_CLEAN) | \
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 26e4045..fdf2503 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6795,6 +6795,10 @@ static int raid5_run(struct mddev *mddev)
 	rdev_for_each(rdev, mddev) {
 		long long diff;
 
+		if (test_bit(MD_HAS_PPL, &mddev->flags) &&
+		    test_bit(In_sync, &rdev->flags))
+			set_bit(JournalPpl, &rdev->flags);
+
 		if (test_bit(JournalPpl, &rdev->flags) &&
 		    test_bit(In_sync, &rdev->flags))
 			ppl_disks++;
@@ -6817,6 +6821,9 @@ static int raid5_run(struct mddev *mddev)
 			min_offset_diff = diff;
 	}
 
+	if (ppl_disks)
+		set_bit(MD_HAS_PPL, &mddev->flags);
+
 	if (mddev->reshape_position != MaxSector) {
 		/* Check that we can continue the reshape.
 		 * Difficulties arise if the stripe we would write to
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index 9930f3e..455caa8 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -242,10 +242,18 @@ struct mdp_superblock_1 {
 
 	__le32	chunksize;	/* in 512byte sectors */
 	__le32	raid_disks;
-	__le32	bitmap_offset;	/* sectors after start of superblock that bitmap starts
-				 * NOTE: signed, so bitmap can be before superblock
-				 * only meaningful of feature_map[0] is set.
-				 */
+	union {
+		__le32	bitmap_offset;	/* sectors after start of superblock that bitmap starts
+					 * NOTE: signed, so bitmap can be before superblock
+					 * only meaningful of feature_map[0] is set.
+					 */
+
+		/* only meaningful when feature_map[MD_FEATURE_PPL] is set */
+		struct {
+			__le16 offset; /* sectors after start of superblock that ppl starts */
+			__le16 size; /* PPL size (including header) in sectors */
+		} ppl;
+	};
 
 	/* These are only valid with feature bit '4' */
 	__le32	new_level;	/* new level we are reshaping to		*/
@@ -318,6 +326,7 @@ struct mdp_superblock_1 {
 					     */
 #define MD_FEATURE_CLUSTERED		256 /* clustered MD */
 #define	MD_FEATURE_JOURNAL		512 /* support write cache */
+#define	MD_FEATURE_PPL			1024 /* support PPL */
 #define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET	\
 					|MD_FEATURE_RECOVERY_OFFSET	\
 					|MD_FEATURE_RESHAPE_ACTIVE	\
@@ -328,6 +337,7 @@ struct mdp_superblock_1 {
 					|MD_FEATURE_RECOVERY_BITMAP	\
 					|MD_FEATURE_CLUSTERED		\
 					|MD_FEATURE_JOURNAL		\
+					|MD_FEATURE_PPL			\
 					)
 
 struct r5l_payload_header {
-- 
2.10.1

