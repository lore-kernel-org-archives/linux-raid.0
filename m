From: Shaohua Li <shli@fb.com>
Subject: [PATCH] md: cleanup mddev flag clear for takeover
Date: Wed, 4 Jan 2017 16:10:19 -0800
Message-ID: <54e76f766a02584d618f7f6501b55fa255da47c2.1483574948.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Commit 6995f0b (md: takeover should clear unrelated bits) clear
unrelated bits, but it's quite fragile. To avoid error in the future,
define a macro for unsupported mddev flags for each raid type and use it
to clear unsupported mddev flags. This should be less error-prone.

Suggested-by: NeilBrown <neilb@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.h    |  8 ++++++++
 drivers/md/raid0.c | 12 ++++++++----
 drivers/md/raid1.c |  8 ++++++--
 drivers/md/raid5.c |  5 ++++-
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2302536..4aae26d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -212,6 +212,7 @@ extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 				int is_new);
 struct md_cluster_info;
 
+/* change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added */
 enum mddev_flags {
 	MD_ARRAY_FIRST_USE,	/* First use of array, needs initialization */
 	MD_CLOSING,		/* If set, we are closing the array, do not open
@@ -704,4 +705,11 @@ static inline int mddev_is_clustered(struct mddev *mddev)
 }
 
 extern void md_writesame_setup(struct mddev *mddev, struct bio *bio);
+
+/* clear unsupported mddev_flags */
+static inline void mddev_clear_unsupported_flags(struct mddev *mddev,
+	unsigned long unsupported_flags)
+{
+	mddev->flags &= ~unsupported_flags;
+}
 #endif /* _MD_MD_H */
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 5e4cddb..5b3db36 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -26,6 +26,11 @@
 #include "raid0.h"
 #include "raid5.h"
 
+#define UNSUPPORTED_MDDEV_FLAGS		\
+	((1L << MD_HAS_JOURNAL) |	\
+	 (1L << MD_JOURNAL_CLEAN) |	\
+	 (1L << MD_FAILFAST_SUPPORTED))
+
 static int raid0_congested(struct mddev *mddev, int bits)
 {
 	struct r0conf *conf = mddev->private;
@@ -541,8 +546,7 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
 	mddev->delta_disks = -1;
 	/* make sure it will be not marked as dirty */
 	mddev->recovery_cp = MaxSector;
-	clear_bit(MD_HAS_JOURNAL, &mddev->flags);
-	clear_bit(MD_JOURNAL_CLEAN, &mddev->flags);
+	mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
 
 	create_strip_zones(mddev, &priv_conf);
 
@@ -585,7 +589,7 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
 	mddev->degraded = 0;
 	/* make sure it will be not marked as dirty */
 	mddev->recovery_cp = MaxSector;
-	clear_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
+	mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
 
 	create_strip_zones(mddev, &priv_conf);
 	return priv_conf;
@@ -628,7 +632,7 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
 	mddev->raid_disks = 1;
 	/* make sure it will be not marked as dirty */
 	mddev->recovery_cp = MaxSector;
-	clear_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
+	mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
 
 	create_strip_zones(mddev, &priv_conf);
 	return priv_conf;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1442240..7b0f647 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -42,6 +42,10 @@
 #include "raid1.h"
 #include "bitmap.h"
 
+#define UNSUPPORTED_MDDEV_FLAGS		\
+	((1L << MD_HAS_JOURNAL) |	\
+	 (1L << MD_JOURNAL_CLEAN))
+
 /*
  * Number of guaranteed r1bios in case of extreme VM load:
  */
@@ -3257,8 +3261,8 @@ static void *raid1_takeover(struct mddev *mddev)
 		if (!IS_ERR(conf)) {
 			/* Array must appear to be quiesced */
 			conf->array_frozen = 1;
-			clear_bit(MD_HAS_JOURNAL, &mddev->flags);
-			clear_bit(MD_JOURNAL_CLEAN, &mddev->flags);
+			mddev_clear_unsupported_flags(mddev,
+				UNSUPPORTED_MDDEV_FLAGS);
 		}
 		return conf;
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ac5fd69..071dfdd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -62,6 +62,8 @@
 #include "raid0.h"
 #include "bitmap.h"
 
+#define UNSUPPORTED_MDDEV_FLAGS	(1L << MD_FAILFAST_SUPPORTED)
+
 #define cpu_to_group(cpu) cpu_to_node(cpu)
 #define ANY_GROUP NUMA_NO_NODE
 
@@ -7881,7 +7883,8 @@ static void *raid5_takeover_raid1(struct mddev *mddev)
 
 	ret = setup_conf(mddev);
 	if (!IS_ERR_VALUE(ret))
-		clear_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
+		mddev_clear_unsupported_flags(mddev,
+			UNSUPPORTED_MDDEV_FLAGS);
 	return ret;
 }
 
-- 
2.9.3

