From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v3 3/9] md: superblock changes for PPL
Date: Mon, 30 Jan 2017 19:59:47 +0100
Message-ID: <20170130185953.30428-4-artur.paszkiewicz@intel.com>
References: <20170130185953.30428-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170130185953.30428-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, jes.sorensen@gmail.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Include information about PPL location and size into mdp_superblock_1
and copy it to/from rdev. Because PPL is mutually exclusive with bitmap,
put it in place of 'bitmap_offset'. Add a new flag MD_FEATURE_PPL for
'feature_map', analogically to MD_FEATURE_BITMAP_OFFSET. Add MD_HAS_PPL
to mddev->flags to indicate that PPL is enabled on an array.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/md.c                | 15 +++++++++++++++
 drivers/md/md.h                |  8 ++++++++
 drivers/md/raid0.c             |  3 ++-
 drivers/md/raid1.c             |  3 ++-
 include/uapi/linux/raid/md_p.h | 18 ++++++++++++++----
 5 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 85ac98417a08..e96f73572e23 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1566,6 +1566,12 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	} else if (sb->bblog_offset != 0)
 		rdev->badblocks.shift = 0;
 
+	if (le32_to_cpu(sb->feature_map) & MD_FEATURE_PPL) {
+		rdev->ppl.offset = (__s16)le16_to_cpu(sb->ppl.offset);
+		rdev->ppl.size = le16_to_cpu(sb->ppl.size);
+		rdev->ppl.sector = rdev->sb_start + rdev->ppl.offset;
+	}
+
 	if (!refdev) {
 		ret = 1;
 	} else {
@@ -1678,6 +1684,9 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 
 		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_JOURNAL)
 			set_bit(MD_HAS_JOURNAL, &mddev->flags);
+
+		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_PPL)
+			set_bit(MD_HAS_PPL, &mddev->flags);
 	} else if (mddev->pers == NULL) {
 		/* Insist of good event counter while assembling, except for
 		 * spares (which don't need an event count) */
@@ -1891,6 +1900,12 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
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
index 968bbe72b237..abdb5f2ed2d3 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -122,6 +122,13 @@ struct md_rdev {
 					   * sysfs entry */
 
 	struct badblocks badblocks;
+
+	struct {
+		short offset;	/* Offset from superblock to start of PPL.
+				 * Not used by external metadata. */
+		unsigned int size;	/* Size in sectors of the PPL space */
+		sector_t sector;	/* First sector of the PPL space */
+	} ppl;
 };
 enum flag_bits {
 	Faulty,			/* device is known to have a fault */
@@ -229,6 +236,7 @@ enum mddev_flags {
 				 * supported as calls to md_error() will
 				 * never cause the array to become failed.
 				 */
+	MD_HAS_PPL,		/* The raid array has PPL feature set */
 };
 
 enum mddev_sb_flags {
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 5b3db367814a..37fc1f5185a9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -29,7 +29,8 @@
 #define UNSUPPORTED_MDDEV_FLAGS		\
 	((1L << MD_HAS_JOURNAL) |	\
 	 (1L << MD_JOURNAL_CLEAN) |	\
-	 (1L << MD_FAILFAST_SUPPORTED))
+	 (1L << MD_FAILFAST_SUPPORTED) |\
+	 (1L << MD_HAS_PPL))
 
 static int raid0_congested(struct mddev *mddev, int bits)
 {
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7b0f647bcccb..53623a31b074 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -44,7 +44,8 @@
 
 #define UNSUPPORTED_MDDEV_FLAGS		\
 	((1L << MD_HAS_JOURNAL) |	\
-	 (1L << MD_JOURNAL_CLEAN))
+	 (1L << MD_JOURNAL_CLEAN) |	\
+	 (1L << MD_HAS_PPL))
 
 /*
  * Number of guaranteed r1bios in case of extreme VM load:
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index 9930f3e9040f..fe2112810c43 100644
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
+			__le16 offset; /* sectors from start of superblock that ppl starts (signed) */
+			__le16 size; /* ppl size in sectors */
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
2.11.0

