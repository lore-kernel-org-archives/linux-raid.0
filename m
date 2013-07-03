From: mwilck@arcor.de
Subject: [PATCH 12/27] DDF: layout_md2ddf: new md->DDF layout conversion
Date: Wed,  3 Jul 2013 22:27:52 +0200
Message-ID: <1372883287-8859-13-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Support for RAID 10 makes it necessary to rewrite the algorithm
for deriving DDF layout from MD layout. The functions level_to_prl
and layout_to_rlq are combined in a single function that takes
md layout parameters and converts them to DDF.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |  178 ++++++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 114 insertions(+), 64 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index a43401e..933485d 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -484,6 +484,107 @@ static unsigned int calc_crc(void *buf, int len)
 	return __cpu_to_be32(newcrc);
 }
 
+#define DDF_INVALID_LEVEL 0xff
+#define DDF_NO_SECONDARY 0xff
+static int err_bad_md_layout(const mdu_array_info_t *array)
+{
+	pr_err("RAID%d layout %x with %d disks is unsupported for DDF\n",
+	       array->level, array->layout, array->raid_disks);
+	return DDF_INVALID_LEVEL;
+}
+
+static int layout_md2ddf(const mdu_array_info_t *array,
+			 struct vd_config *conf)
+{
+	__u16 prim_elmnt_count = __cpu_to_be16(array->raid_disks);
+	__u8 prl = DDF_INVALID_LEVEL, rlq = 0;
+	__u8 sec_elmnt_count = 1;
+	__u8 srl = DDF_NO_SECONDARY;
+
+	switch (array->level) {
+	case LEVEL_LINEAR:
+		prl = DDF_CONCAT;
+		break;
+	case 0:
+		rlq = DDF_RAID0_SIMPLE;
+		prl = DDF_RAID0;
+		break;
+	case 1:
+		switch (array->raid_disks) {
+		case 2:
+			rlq = DDF_RAID1_SIMPLE;
+			break;
+		case 3:
+			rlq = DDF_RAID1_MULTI;
+			break;
+		default:
+			return err_bad_md_layout(array);
+		}
+		prl = DDF_RAID1;
+		break;
+	case 4:
+		if (array->layout != 0)
+			return err_bad_md_layout(array);
+		rlq = DDF_RAID4_N;
+		prl = DDF_RAID4;
+		break;
+	case 5:
+		switch (array->layout) {
+		case ALGORITHM_LEFT_ASYMMETRIC:
+			rlq = DDF_RAID5_N_RESTART;
+			break;
+		case ALGORITHM_RIGHT_ASYMMETRIC:
+			rlq = DDF_RAID5_0_RESTART;
+			break;
+		case ALGORITHM_LEFT_SYMMETRIC:
+			rlq = DDF_RAID5_N_CONTINUE;
+			break;
+		case ALGORITHM_RIGHT_SYMMETRIC:
+			/* not mentioned in standard */
+			return err_bad_md_layout(array);
+		}
+		prl = DDF_RAID5;
+		break;
+	case 6:
+		switch (array->layout) {
+		case ALGORITHM_ROTATING_N_RESTART:
+			rlq = DDF_RAID5_N_RESTART;
+			break;
+		case ALGORITHM_ROTATING_ZERO_RESTART:
+			rlq = DDF_RAID6_0_RESTART;
+			break;
+		case ALGORITHM_ROTATING_N_CONTINUE:
+			rlq = DDF_RAID5_N_CONTINUE;
+			break;
+		}
+		prl = DDF_RAID6;
+		break;
+	case 10:
+		if (array->raid_disks % 2 == 0 && array->layout == 0x102) {
+			rlq = DDF_RAID1_SIMPLE;
+			prim_elmnt_count =  __cpu_to_be16(2);
+			sec_elmnt_count = array->raid_disks / 2;
+		} else if (array->raid_disks % 3 == 0
+			   && array->layout == 0x103) {
+			rlq = DDF_RAID1_MULTI;
+			prim_elmnt_count =  __cpu_to_be16(3);
+			sec_elmnt_count = array->raid_disks / 3;
+		} else
+			return err_bad_md_layout(array);
+		srl = DDF_2SPANNED;
+		prl = DDF_RAID1;
+		break;
+	default:
+		return err_bad_md_layout(array);
+	}
+	conf->prl = prl;
+	conf->prim_elmnt_count = prim_elmnt_count;
+	conf->rlq = rlq;
+	conf->srl = srl;
+	conf->sec_elmnt_count = sec_elmnt_count;
+	return 0;
+}
+
 static int err_bad_ddf_layout(const struct vd_config *conf)
 {
 	pr_err("DDF RAID %u qualifier %u with %u disks is unsupported\n",
@@ -2150,59 +2251,6 @@ static int chunk_to_shift(int chunksize)
 	return ffs(chunksize/512)-1;
 }
 
-static int level_to_prl(int level)
-{
-	switch (level) {
-	case LEVEL_LINEAR: return DDF_CONCAT;
-	case 0: return DDF_RAID0;
-	case 1: return DDF_RAID1;
-	case 4: return DDF_RAID4;
-	case 5: return DDF_RAID5;
-	case 6: return DDF_RAID6;
-	default: return -1;
-	}
-}
-
-static int layout_to_rlq(int level, int layout, int raiddisks)
-{
-	switch(level) {
-	case 0:
-		return DDF_RAID0_SIMPLE;
-	case 1:
-		switch(raiddisks) {
-		case 2: return DDF_RAID1_SIMPLE;
-		case 3: return DDF_RAID1_MULTI;
-		default: return -1;
-		}
-	case 4:
-		switch(layout) {
-		case 0: return DDF_RAID4_N;
-		}
-		break;
-	case 5:
-		switch(layout) {
-		case ALGORITHM_LEFT_ASYMMETRIC:
-			return DDF_RAID5_N_RESTART;
-		case ALGORITHM_RIGHT_ASYMMETRIC:
-			return DDF_RAID5_0_RESTART;
-		case ALGORITHM_LEFT_SYMMETRIC:
-			return DDF_RAID5_N_CONTINUE;
-		case ALGORITHM_RIGHT_SYMMETRIC:
-			return -1; /* not mentioned in standard */
-		}
-	case 6:
-		switch(layout) {
-		case ALGORITHM_ROTATING_N_RESTART:
-			return DDF_RAID5_N_RESTART;
-		case ALGORITHM_ROTATING_ZERO_RESTART:
-			return DDF_RAID6_0_RESTART;
-		case ALGORITHM_ROTATING_N_CONTINUE:
-			return DDF_RAID5_N_CONTINUE;
-		}
-	}
-	return -1;
-}
-
 #ifndef MDASSEMBLE
 struct extent {
 	unsigned long long start, size;
@@ -2320,13 +2368,15 @@ static int init_super_ddf_bvd(struct supertype *st,
 	vc->timestamp = __cpu_to_be32(time(0)-DECADE);
 	vc->seqnum = __cpu_to_be32(1);
 	memset(vc->pad0, 0xff, 24);
-	vc->prim_elmnt_count = __cpu_to_be16(info->raid_disks);
 	vc->chunk_shift = chunk_to_shift(info->chunk_size);
-	vc->prl = level_to_prl(info->level);
-	vc->rlq = layout_to_rlq(info->level, info->layout, info->raid_disks);
-	vc->sec_elmnt_count = 1;
+	if (layout_md2ddf(info, vc) == -1 ||
+		__be16_to_cpu(vc->prim_elmnt_count) > ddf->mppe) {
+		pr_err("%s: unsupported RAID level/layout %d/%d with %d disks\n",
+		       __func__, info->level, info->layout, info->raid_disks);
+		free(vcl);
+		return 0;
+	}
 	vc->sec_elmnt_seq = 0;
-	vc->srl = 0;
 	vc->blocks = __cpu_to_be64(info->size * 2);
 	vc->array_blocks = __cpu_to_be64(
 		calc_array_size(info->level, info->raid_disks, info->layout,
@@ -2990,12 +3040,12 @@ static int validate_geometry_ddf(struct supertype *st,
 	}
 
 	if (!dev) {
-		/* Initial sanity check.  Exclude illegal levels. */
-		int i;
-		for (i=0; ddf_level_num[i].num1 != MAXINT; i++)
-			if (ddf_level_num[i].num2 == level)
-				break;
-		if (ddf_level_num[i].num1 == MAXINT) {
+		mdu_array_info_t array = {
+			.level = level, .layout = layout,
+			.raid_disks = raiddisks
+		};
+		struct vd_config conf;
+		if (layout_md2ddf(&array, &conf) == -1) {
 			if (verbose)
 				pr_err("DDF does not support level %d arrays\n",
 				       level);
-- 
1.7.1
