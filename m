From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] imsm: remove redundant characters from some error messages
Date: Fri, 16 Sep 2016 15:25:14 +0200
Message-ID: <20160916132514.29226-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Fix the cases that produced messages like "mdadm: : The message".

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 92817e9..c96c6bc 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5678,7 +5678,7 @@ active_arrays_by_format(char *name, char* hba, struct md_list **devlist,
 				if (num > 0)
 					fd = open(path, O_RDONLY, 0);
 				if ((num <= 0) || (fd < 0)) {
-					pr_vrb(": Cannot open %s: %s\n",
+					pr_vrb("Cannot open %s: %s\n",
 					       dev->name, strerror(errno));
 				}
 				free(path);
@@ -5808,7 +5808,7 @@ count_volumes_list(struct md_list *devlist, char *homehost,
 	*found = 0;
 	st = match_metadata_desc_imsm("imsm");
 	if (st == NULL) {
-		pr_vrb(": cannot allocate memory for imsm supertype\n");
+		pr_vrb("cannot allocate memory for imsm supertype\n");
 		return 0;
 	}
 
@@ -5821,7 +5821,7 @@ count_volumes_list(struct md_list *devlist, char *homehost,
 			continue;
 		tst = dup_super(st);
 		if (tst == NULL) {
-			pr_vrb(": cannot allocate memory for imsm supertype\n");
+			pr_vrb("cannot allocate memory for imsm supertype\n");
 			goto err_1;
 		}
 		tmpdev->container = 0;
@@ -6047,14 +6047,14 @@ validate_geometry_imsm_orom(struct intel_super *super, int level, int layout,
 {
 	/* check/set platform and metadata limits/defaults */
 	if (super->orom && raiddisks > super->orom->dpa) {
-		pr_vrb(": platform supports a maximum of %d disks per array\n",
+		pr_vrb("platform supports a maximum of %d disks per array\n",
 		       super->orom->dpa);
 		return 0;
 	}
 
 	/* capabilities of OROM tested - copied from validate_geometry_imsm_volume */
 	if (!is_raid_level_supported(super->orom, level, raiddisks)) {
-		pr_vrb(": platform does not support raid%d with %d disk%s\n",
+		pr_vrb("platform does not support raid%d with %d disk%s\n",
 			level, raiddisks, raiddisks > 1 ? "s" : "");
 		return 0;
 	}
@@ -6063,24 +6063,24 @@ validate_geometry_imsm_orom(struct intel_super *super, int level, int layout,
 		*chunk = imsm_default_chunk(super->orom);
 
 	if (super->orom && !imsm_orom_has_chunk(super->orom, *chunk)) {
-		pr_vrb(": platform does not support a chunk size of: %d\n", *chunk);
+		pr_vrb("platform does not support a chunk size of: %d\n", *chunk);
 		return 0;
 	}
 
 	if (layout != imsm_level_to_layout(level)) {
 		if (level == 5)
-			pr_vrb(": imsm raid 5 only supports the left-asymmetric layout\n");
+			pr_vrb("imsm raid 5 only supports the left-asymmetric layout\n");
 		else if (level == 10)
-			pr_vrb(": imsm raid 10 only supports the n2 layout\n");
+			pr_vrb("imsm raid 10 only supports the n2 layout\n");
 		else
-			pr_vrb(": imsm unknown layout %#x for this raid level %d\n",
+			pr_vrb("imsm unknown layout %#x for this raid level %d\n",
 				layout, level);
 		return 0;
 	}
 
 	if (super->orom && (super->orom->attr & IMSM_OROM_ATTR_2TB) == 0 &&
 			(calc_array_size(level, raiddisks, layout, *chunk, size) >> 32) > 0) {
-		pr_vrb(": platform does not support a volume size over 2TB\n");
+		pr_vrb("platform does not support a volume size over 2TB\n");
 		return 0;
 	}
 
@@ -6251,7 +6251,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 		int count = count_volumes(super->hba,
 				      super->orom->dpa, verbose);
 		if (super->orom->vphba <= count) {
-			pr_vrb(": platform does not support more than %d raid volumes.\n",
+			pr_vrb("platform does not support more than %d raid volumes.\n",
 			       super->orom->vphba);
 			return 0;
 		}
@@ -6407,7 +6407,7 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 				count = count_volumes(super->hba,
 						      super->orom->dpa, verbose);
 				if (super->orom->vphba <= count) {
-					pr_vrb(": platform does not support more than %d raid volumes.\n",
+					pr_vrb("platform does not support more than %d raid volumes.\n",
 					       super->orom->vphba);
 					return 0;
 				}
@@ -10582,7 +10582,7 @@ static int imsm_manage_reshape(
 	}
 	/* Only one volume can migrate at the same time */
 	if (migr_vol_qan != 1) {
-		pr_err(": %s", migr_vol_qan ?
+		pr_err("%s", migr_vol_qan ?
 			"Number of migrating volumes greater than 1\n" :
 			"There is no volume during migrationg\n");
 		goto abort;
-- 
2.10.0

