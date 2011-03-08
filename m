From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 10/14] imsm: add maximum number of disk validation in RAID
 array
Date: Tue, 8 Mar 2011 15:21:17 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC93@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 6f52514bf9ab085b55420bf374abf8069cd981d8 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Thu, 3 Mar 2011 15:27:10 +0100
Subject: [PATCH 10/14] imsm: add maximum number of disk validation in RAID array

Arrays exceeding the OROM/EFI maximum number of supported disk are
blocked in validate_geometry_imsm_orom function.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2539efd..b9f8c9c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4229,12 +4229,30 @@ static int is_raid_level_supported(const struct imsm_orom *orom, int level, int
 	return 0;
 }
 
+
 #define pr_vrb(fmt, arg...) (void) (verbose && fprintf(stderr, Name fmt, ##arg))
+/*
+ * validate volume parameters with OROM/EFI capabilities
+ */
 static int
 validate_geometry_imsm_orom(struct intel_super *super, int level, int layout,
 			    int raiddisks, int *chunk, int verbose)
 {
-	if (!is_raid_level_supported(super->orom, level, raiddisks)) {
+#if DEBUG
+	verbose = 1;
+#endif
+	/* validate container capabilities */
+	if (super->orom && raiddisks > super->orom->tds) {
+		if (verbose)
+			fprintf(stderr, Name ": %d exceeds maximum number of"
+				" platform supported disks: %d\n",
+				raiddisks, super->orom->tds);
+		return 0;
+	}
+
+        /* capabilities of OROM tested - copied from validate_geometry_imsm_volume */
+	if (super->orom && (!is_raid_level_supported(super->orom, level,
+						     raiddisks))) {
 		pr_vrb(": platform does not support raid%d with %d disk%s\n",
 			level, raiddisks, raiddisks > 1 ? "s" : "");
 		return 0;
@@ -4258,7 +4276,6 @@ validate_geometry_imsm_orom(struct intel_super *super, int level, int layout,
 				layout, level);
 		return 0;
 	}
-
 	return 1;
 }
 
@@ -4856,7 +4873,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 						 get_imsm_raid_level(map), /* RAID level */
 						 imsm_level_to_layout(get_imsm_raid_level(map)),
 						 map->num_members, /* raid disks */
-						 chunk,
+						 &chunk,
 						 1 /* verbose */)) {
 			fprintf(stderr, Name ": RAID gemetry validation failed. "
 				"Cannot proceed with the action(s).\n");
-- 
1.6.4.2

