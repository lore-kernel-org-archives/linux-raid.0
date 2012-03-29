From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 5/6] check volume size in validate_geometry_imsm_orom
Date: Thu, 29 Mar 2012 12:43:23 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B918A205EE@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

When orom does not support volumes over 2TB the creation should be disallowed

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 super-intel.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 820ffd0..d0b1442 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5860,7 +5860,7 @@ static int imsm_default_chunk(const struct imsm_orom *orom)
 
 static int
 validate_geometry_imsm_orom(struct intel_super *super, int level, int layout,
-			    int raiddisks, int *chunk, int verbose)
+			    int raiddisks, int *chunk, unsigned long long size, int verbose)
 {
 	/* check/set platform and metadata limits/defaults */
 	if (super->orom && raiddisks > super->orom->dpa) {
@@ -5895,6 +5895,12 @@ validate_geometry_imsm_orom(struct intel_super *super, int level, int layout,
 				layout, level);
 		return 0;
 	}
+
+	if (super->orom && (super->orom->attr & IMSM_OROM_ATTR_2TB) == 0 && chunk &&
+			(calc_array_size(level, raiddisks, layout, *chunk, size) >> 32) > 0) {
+		pr_vrb(": platform does not support a volume size over 2TB\n");
+		return 0;
+	}
 	return 1;
 }
 
@@ -5922,7 +5928,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 
 	mpb = super->anchor;
 
-	if (!validate_geometry_imsm_orom(super, level, layout, raiddisks, chunk, verbose)) {
+	if (!validate_geometry_imsm_orom(super, level, layout, raiddisks, chunk, size, verbose)) {
 		fprintf(stderr, Name ": RAID gemetry validation failed. "
 			"Cannot proceed with the action(s).\n");
 		return 0;
@@ -6187,7 +6193,7 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 		if (st->sb) {
 			struct intel_super *super = st->sb;
 			if (!validate_geometry_imsm_orom(st->sb, level, layout,
-							 raiddisks, chunk,
+							 raiddisks, chunk, size,
 							 verbose))
 				return 0;
 			/* we are being asked to automatically layout a
@@ -6598,7 +6604,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 						 get_imsm_raid_level(map), /* RAID level */
 						 imsm_level_to_layout(get_imsm_raid_level(map)),
 						 map->num_members, /* raid disks */
-						 &chunk,
+						 &chunk, join_u32(dev->size_low, dev->size_high),
 						 1 /* verbose */)) {
 			fprintf(stderr, Name ": IMSM RAID geometry validation"
 				" failed.  Array %s activation is blocked.\n",
-- 
1.6.4.2

